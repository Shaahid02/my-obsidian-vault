NeurIPS 2024, Yu, Yao, Li, Deng et al. out of Stevens Institute of Technology, Harvard and The Fin AI. An LLM multi-agent system for sequential financial decision making, built around two ideas: a manager-analyst hierarchy copied from how real investment firms are structured, and a dual-level risk control component that updates the manager's investment beliefs in natural language instead of in weights. Tested on both single stock trading and portfolio management.

This is the closest published system to what I'm proposing on the orchestration side, closer than [[TradingAgents, Multi-Agents LLM Financial Trading Framework]] in one specific way: TradingAgents lets agents debate laterally, FinCon explicitly refuses to. Everything routes through a manager. Worth reading carefully because it's the strongest existing argument that peer-to-peer agent discussion is a cost, not a feature.

## Major differences to mine

Same fluidity problem as everything else in this space. Eight US large caps plus a 42 stock pool, all of which have thousands of news items and dozens of analyst reports per ticker. The CSE has nothing like that density, and FinCon's whole information architecture assumes multi-source redundancy: if the news agent is noisy, the filings agent and the ECC agent cover for it. On the CSE most tickers will have one weak signal or none, so the analyst group degenerates.

No social media or code-mixed sentiment path. Sentiment here comes from Reuters news, Zacks analyst notes and earnings call audio, all English, all institutional. Nothing in the design handles Sinhala, Singlish, or retail chatter, which is where CSE sentiment actually lives.

No execution friction anywhere in the objective. Trading actions are buy/sell/hold and portfolio weights get rebalanced daily with no transaction cost, no slippage, no liquidity constraint in the optimizer. On a whale-dominated thin market that assumption does most of the work for them. [[Deep Reinforcement Learning Framework for Diversified Dynamic Portfolio Allocation Across Global Equity Markets]] puts turnover penalties inside the reward, FinCon doesn't put anything in.

Risk is measured purely as CVaR on realised daily PnL. That's a backward-looking, empirical-quantile risk measure. It carries no notion of volatility persistence, which is exactly the thing [[Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange]] shows is measurable and material on the CSE. A FIGARCH-informed risk agent would be a real extension rather than a cosmetic one.

Also worth noting the manager is the sole decision maker and the sole holder of episodic memory. Single point of failure, and the paper admits it hallucinates more as the portfolio grows.

## Standout features

Hierarchical communication instead of debate. Analysts talk to the manager, never to each other.

Dual-level risk control, one loop inside the episode (CVaR alert), one loop across episodes (belief update).

Conceptual Verbal Reinforcement (CVRF). The system learns by rewriting its own prompts in natural language, using text as the gradient.

The learning rate analogy. They measure decision overlap between consecutive episodes and use that number to control how aggressively the prompt gets rewritten.

Per-agent memory decay rates tied to the timeliness of each data source. Daily news decays fast, 10-K insight decays slowly.

Converges in four training episodes.

#### Gap it's addressing

Against prior LLM financial agents (FinGPT, FinMem, FinAgent, all of which it benchmarks against):

- They set risk preferences from short-term price fluctuation rather than from an established quantitative risk measure, so long-horizon exposure goes uncontrolled.
- They're mostly single-asset only, so they don't transfer to portfolio management.
- They pile all the information onto one agent inside one context window, which degrades decision quality as data volume grows.

Against multi-agent systems that do use discussion (StockAgent is the one it names): unbounded peer-to-peer chatter is expensive and slow, and without a clear optimization objective there's nothing forcing the conversation to converge on profit. This is the argument I need to take seriously, because my own design leans on cross-agent interaction.

#### Problem formulation

Quantitative trading is framed as an infinite horizon POMDP, same framing as the survey in [[The Evolution of Reinforcement Learning in Quantitative Finance, A Survey]] uses for why the Markov property fails in finance. Time index $\mathbb{T} = \{0,1,2,\dots\}$, discount factor $\alpha \in (0,1)$.

The pieces:

- State space $\mathcal{X} \times \mathcal{Y}$, where $\mathcal{X}$ is observable market state and $\mathcal{Y}$ is the unobservable component.
- Analyst action space $\mathcal{A} = \prod_{i=1}^{I} \mathcal{A}^i$, where each $\mathcal{A}^i$ is the set of processed market information in **textual** format produced by analyst $i$. The analysts' "actions" are text, not trades.
- Manager action space $\mathbb{A}$, which is $\{buy, sell, hold\}$ for single stock and $(\{buy, sell, hold\} \times [-1,1])^{\otimes N}$ for an $N$ stock portfolio. Note sell means short selling is allowed, negative positions are legal.
- Reward $\mathcal{R}(o,b,a)$ is daily profit and loss.
- Observation process $\{O_t\}$, $I$ dimensional, one uni-modal stream per analyst.
- Reflection process $\{B_t\} \subseteq \mathcal{Y}$, the manager's self-reflection, updated daily.

Portfolio weights come from an external mean-variance solver, Markowitz with the directional constraint bolted on from the manager's discrete decision:

$$\max_{\mathbf{w}} \langle \mathbf{w}, \mu \rangle - \langle \mathbf{w}, \Sigma \mathbf{w} \rangle \quad \text{s.t. } w_n = \begin{cases} \in [0,1], & \text{“buy”} \\ \in [-1,0], & \text{“sell”} \\ = 0, & \text{“hold”} \end{cases}, \ \forall n \in \{1,\dots,N\}$$

where $\mu$ and $\Sigma$ are shrinkage estimators of expected return and the sample covariance matrix of daily returns. So the LLM picks direction, a classical optimizer picks size. That separation is a design decision I should probably copy, it keeps the part that needs to be auditable out of the language model.

The system objective, with $R_t^{\Pi_\theta}$ the daily PnL under policy $\Pi_\theta$:

$$\max_{\boldsymbol{\theta}} \ \mathbb{E}\left[\sum_{t \in \mathbb{T}} \alpha^t R_t^{\Pi_{\boldsymbol{\theta}}}\right]$$

The important bit is what $\theta$ is. Policies are parameterised by **textual prompts**, $\boldsymbol{\theta} = (\{\theta^i\}_{i=1}^I, \theta^a)$. So this is a risk-sensitive optimization problem solved by textual gradient descent, not by DRL. Same objective shape as an RL problem, completely different update mechanism.

#### Architecture
![[Pasted image 20260918111510.png]]
Two components: the Manager-Analyst Agent Group and the Risk-Control component.

**Analyst agents.** Each one processes a single modality and nothing else, deliberately, to reduce task load and sharpen focus. The paper says seven distinct types, though the figure and text between them only clearly enumerate six:

1. News agent (Reuters, via Refinitiv Real-Time News)
2. 10-Q / 10-K filings agent (SEC EDGAR, MD&A sections specifically)
3. Analyst reports agent (Zacks Rank and Zacks Analyst commentary)
4. ECC audio agent (earnings conference call recordings, transcribed with the Whisper API)
5. Data analysis agent (tabular time series, computes momentum and CVaR)
6. Stock selection agent (picks the portfolio pool using classical risk diversification)

**Manager agent.** Sole decision maker. Four things support each decision: consolidating analyst insights, receiving risk alerts and belief updates from the risk control component, refining its beliefs about which information sources actually matter for a given target, and self-reflecting on previous trading outcomes.

The point of the hierarchy is stated plainly: improve information presentation and comprehension while minimising communication cost. Analysts never talk to each other, so communication is $O(I)$ rather than $O(I^2)$.

#### Risk control, the actual contribution

**Within-episode (CVaR).** Runs in both training and testing. VaR at confidence level $\alpha$:

$$\text{VaR}_\alpha(PnL) = \inf\{l \in \mathbb{R} : \mathbb{P}(PnL \le l) \ge \alpha\}$$

and CVaR, the expected loss conditional on being past that threshold:

$$\text{CVaR}_\alpha(PnL) = \mathbb{E}\left\{PnL \mid PnL \le \text{VaR}_\alpha(PnL)\right\}$$

FinCon uses $\alpha = 0.01$, so CVaR here is the average of the worst 1% of daily PnLs. A sudden drop in that value triggers a risk alert and the manager goes risk-averse for the day regardless of its prior stance. Simple, and the ablation says it carries a huge amount of the performance.

**Over-episode (CVRF).** Training only. After each episode the system compares the objective value of episode $k$ against $k-1$, feeds the sustained winning and losing trades from both into the risk control component, has it summarise conceptualised investment insights $\{c^1_{k-1},\dots,c^n_{k-1}\}$ and $\{c^1_k,\dots,c^n_k\}$, then reasons about why the better episode was better. That reasoning becomes the meta prompt.

The learning rate is where this gets clever. Rather than editing prompts by an arbitrary amount, they compute $\tau$, the **overlapping percentage of trading decisions between two consecutive episodes**, and use that as the step size:

$$\boldsymbol{\theta} \longleftarrow M_r(\boldsymbol{\theta}, \tau, \textit{meta prompt})$$

The stated analogy:

| Factor | Gradient-based model optimizer | LLM-based prompt optimizer |
| --- | --- | --- |
| Upgrade direction | Model value gradient momentum | Prompt reflection trajectory |
| Update method | Learning rate descent | Overlapping percentage of trading decisions |

Explicitly contrasted with Tang et al.'s text-based gradient descent, which uses prompt edit distance as the learning rate. Measuring behaviour overlap rather than text overlap is the better idea, two prompts can read very differently and produce identical trades.

Belief updates go to the manager first, then get **selectively** propagated only to the analysts they concern. That's the over-communication control again.

At test time the over-episode loop is switched off entirely. Beliefs are frozen, only the CVaR alert keeps running. Worth remembering when reading the test numbers, the belief set is static across the whole test window.

#### Memory

Three types: working, procedural, episodic. Episodic is manager-only and holds actions, PnL series from previous episodes, and updated conceptual beliefs. Each analyst has its own **procedural memory decay rate** matched to how fast its data source goes stale, which is the part I actually want.

Retrieval score for a memory event $E$ is relevancy plus importance, each scaled to $[0,1]$:

$$\gamma^E = S^E_{\text{Relevancy}} + S^E_{\text{Importance}}$$

Relevancy is cosine similarity between the memory event's embedding $\mathbf{m_E}$ and the prompt query embedding $\mathbf{m_P}$:

$$S^E_{\text{Relevancy}} = \frac{\mathbf{m_E} \cdot \mathbf{m_P}}{\|\mathbf{m_E}\|_2 \times \|\mathbf{m_P}\|_2}$$

Importance decays exponentially with the time gap $\delta t = t_P - t_E$ between the inquiry and the event, following Ebbinghaus's forgetting curve, with initial value $v^E$ and degrading ratio $\theta \in (0,1)$:

$$S^E_{\text{Importance}} = v^E \times \theta^{\delta t}$$

Different agents get different $\{v^E, \theta\}$. That's the whole mechanism for "annual filings persist, daily news doesn't." Elegant, and cheap. Top-$K$ was set to 5 events per agent.

There's also an access counter using Guardrails AI: a memory ID judged critical to investment gains gets $+5$ added to its importance score, so events that keep mattering stop decaying.

#### Experimental setup

- Backbone: GPT-4-Turbo for every LLM agent system compared, temperature 0.3 (dropped to 0 for belief generation so beliefs are reproducible across episodes).
- Data: Jan 3 2022 to Jun 10 2023. Stock prices from Yahoo Finance via yfinance, news from Refinitiv, filings from SEC EDGAR, Zacks equity research, ECC audio. Appendix A.8 says the window ends June 10 **2022**, which contradicts the main text and the test split, so it's a typo in the appendix.
- Split: train Jan 3 2022 to Oct 4 2022, test Oct 5 2022 to Jun 10 2023. DRL baselines get a much longer training window, Jan 1 2018 to Oct 4 2022, because they need it to converge.
- Single stock: eight tickers, TSLA, AMZN, NIO, MSFT, AAPL, GOOG, NFLX, COIN. (Figure 5's caption says "all six stocks" while plotting eight, another slip.)
- Portfolio: Portfolio 1 = TSLA, MSFT, PFE. Portfolio 2 = AMZN, GM, LLY. Chosen by the stock selection agent from a 42 stock pool filtered on news availability, over 800 articles each.
- Metrics: Cumulative Return, Sharpe, Max Drawdown.

$$\text{Cumulative Return} = \sum_{t=1}^{n} r_t = \sum_{t=1}^{n}\left[\ln\left(\frac{p_{t+1}}{p_t}\right)\cdot \text{action}_t\right]$$

$$\text{Sharpe Ratio} = \frac{R_p - R_f}{\sigma_p} \qquad \text{Max Drawdown} = \max\left(\frac{P_{\text{peak}} - P_{\text{trough}}}{P_{\text{peak}}}\right)$$

Baselines: Buy-and-Hold, DRL agents (A2C, PPO, DQN via FinRL), LLM agents (Generative Agent, FinGPT, FinMem, FinAgent) for single stock. Markowitz MV, FinRL-A2C and Equal-Weighted ETF for portfolio. Significance tested with Wilcoxon signed-rank, which is the right call for non-Gaussian return data.

#### Results

Single stock, FinCon takes the highest CR and SR on all eight tickers. Headline numbers: TSLA 82.871% CR / 1.972 SR against B&H's 6.425% / 0.145. NIO 17.461% / 0.335 against B&H's -77.210% / -1.449. COIN 57.045% / 0.825 against B&H's -21.756% / -0.311. MDD is among the lowest on most assets but not all.

The DRL agents are badly beaten across the board, and the paper is honest about why in the COIN case: COIN IPO'd in April 2021, so there just isn't enough history for A2C/PPO/DQN to converge, and their COIN results are omitted. That's a real point for my project. If DRL needs five years of daily data to converge on a single US ticker, the CSE data depth question from the matrices work is not a side issue, it's the whole feasibility question.

Portfolio management:

| | CR % | SR | MDD % |
| --- | --- | --- | --- |
| **Portfolio 1** (TSLA, MSFT, PFE) | | | |
| FinCon | 113.836 | 3.269 | 16.163 |
| Markowitz MV | 12.636 | 0.614 | 17.842 |
| FinRL-A2C | 19.461 | 0.831 | 26.917 |
| Equal-Weighted ETF | 9.344 | 0.492 | 21.223 |
| **Portfolio 2** (AMZN, GM, LLY) | | | |
| FinCon | 32.922 | 1.371 | 21.502 |
| Markowitz MV | 10.289 | 0.540 | 25.099 |
| FinRL-A2C | 11.589 | 0.649 | 15.787 |
| Equal-Weighted ETF | 15.061 | 0.867 | 14.662 |

Table 3's caption claims FinCon leads all performance metrics. It doesn't. On Portfolio 2 both FinRL-A2C (15.787) and the Equal-Weighted ETF (14.662) have lower drawdown than FinCon's 21.502. Minor, but it's exactly the kind of overclaim a reviewer would pick up, and I should not repeat the pattern.

A Sharpe of 3.269 on a three-stock portfolio over an eight month test window is also not a number to take at face value. Three assets, one window, no repeated splits, median of five epochs. That's thin evidence for a ratio that high.

#### Ablations

Both ablations are strong, and they're the reason to trust the architecture rather than the headline CR.

**Without within-episode CVaR control:** GOOG goes from 25.077% CR to -1.461%, NIO from 17.461% to -52.887%, Portfolio 1 from 113.836% to 14.699%. MDD roughly doubles in the bearish case (40.647% to 70.243%). Removing one risk trigger flips the system from profitable to loss-making.

**Without over-episode belief updates:** GOOG 25.077% to -11.944%, NIO 17.461% to 8.197%, Portfolio 1 113.836% to 28.432%. The paper argues this loop matters more than the CVaR one for decision quality, though the raw deltas look comparable to me.

The belief convergence evidence is the most interesting single number in the paper. Trading action overlap between consecutive training episodes: 46.939%, then 71.429%, then 81.633%. Beliefs stabilise after four episodes. Compare that to DRL agents needing years of data and thousands of steps. If that holds up, verbal reinforcement is dramatically more sample-efficient than gradient RL, which matters enormously for a market with as little history as the CSE.

Figure 8 shows the actual belief text evolving, from generic ("enhance the use of momentum indicators") to specific and executable ("use negative momentum values to make timely sell decisions during downward trends"). Good illustration that the learned artefact is human-readable, which is directly useful for the explainability angle.

#### Extreme conditions (A.15)

Tested on a high volatility window, VIX averaging above 20, train Jan 17 to Mar 31 2022, test Apr 1 to Oct 15 2022. FinCon is the only agent with positive CR and SR on TSLA single stock (22.460%, 0.695) while everything else is deeply negative, but its MDD is 45.215%, worse than DQN's 8.463%.

On Portfolio 1 under the same conditions FinCon returns **-8.429%** with SR -0.294. Best of a bad field, still a loss. Honest of them to include it, and it's the number I'd quote rather than the 113.836%.

#### Limitations

- Scale. The authors flag it themselves: this is tested on portfolios of three. Whether the manager can hold tens of assets in one context window without degrading is open, and they already observe increased hallucination (inventing non-existent memory event indices) moving from one asset to three.
- No transaction costs, no slippage, no liquidity modelling anywhere.
- Single backbone. Everything is GPT-4-Turbo. No evidence on whether the architecture or the model is doing the work, and no open-weight ablation, unlike [[MultiFinRAG, An Optimized Multimodal Retrieval-Augmented Generation Framework for Financial Question Answering]] which at least compares Gemma3 against LLaMA.
- Beliefs are frozen at test time, so there's no evidence the system adapts to regime change it hasn't seen in training.
- NeurIPS checklist item 7 answers **No** on statistical significance / error bars. Five epochs, median reported, Wilcoxon on the main comparison only. Test window is eight months on eight tickers.
- Hard cap on information volume. The conclusion admits the core unsolved tension: distil aggressively and lose information, extend the context and lose decision quality.

#### What I'm taking from this

The manager-analyst hierarchy with no lateral chatter, as the default. If I want debate anywhere in my design (and [[AlphaAgents, Large Language Model Based Multi-Agents for Equity Portfolio Constructions]] makes a decent case for it as a hallucination check), I need to justify the cost against this paper, not ignore it.

Separating direction from sizing. LLM outputs a discrete signal, a classical optimizer converts it to weights. Keeps the sizing auditable and gives a clean place to inject CSE liquidity and friction constraints, which is where G1 actually lives.

Per-source memory decay rates. Directly portable, and more defensible on the CSE than on US large caps because CSE information arrives so irregularly. A CSE annual report should decay far slower than a Daily FT article.

The decision-overlap learning rate. Measure behaviour, not text. Also gives a free convergence diagnostic.

Swap CVaR for something with volatility memory. CVaR on realised PnL is backward looking and has no persistence structure. Feeding a FIGARCH-derived conditional volatility into the risk agent instead of, or alongside, empirical CVaR is a concrete and defensible novelty, and it's exactly what G2 is asking for. The CVaR formula stays useful as the fallback trigger.

And the thing to be careful about: FinCon works partly because its information environment is dense. Before assuming the manager-analyst structure transfers, I need to know how many analyst agents the CSE can actually feed. An analyst agent with no data is worse than no analyst agent, it produces confident text about nothing and the manager has no way to tell.
