KDD 2024, Zhang, Zhao, Xia, Sun et al. out of NTU Singapore, NUS, Zhejiang, SMU and Skywork AI. This is FinAgent. A single LLM trading agent, not a multi-agent system, built around five modules: market intelligence, memory, low-level reflection, high-level reflection, and a tool-augmented decision maker. Two things are actually new here, a dual-level reflection split and a diversified retrieval scheme that indexes memory by retrieval intent rather than by raw similarity. Tested on 5 US stocks and one crypto pair, single asset trading only.

Worth reading as the direct predecessor to most of what came after it. [[FinVision, A Multi-Agent Framework for Stock Market Prediction]] is close to a lighter reimplementation of this, same module decomposition, same MACD Crossover and KDJ with RSI Filter strategies bolted on as tools, and [[FinCon, A Synthesized LLM Multi-Agent System with Conceptual Verbal Reinforcement for Enhanced Financial Decision Making]] benchmarks against it and beats it. So FinAgent is the thing the field moved past, which makes it useful for a different reason than FinCon: it is where the single-agent-with-modules design hits its ceiling, and that ceiling is the argument for going multi-agent at all.

## Major differences to mine

Single agent, five modules. Everything routes through one LLM context. This is exactly the failure mode FinCon names later, pile all the information onto one agent and decision quality degrades as data volume grows. FinAgent is the existence proof of the problem, not a solution to it.

Same fluidity problem as everything else. Five US megacaps plus ETHUSD, with between 2,611 and 10,076 news items per asset over 398 trading days. That is roughly 20 to 25 news items per asset per trading day. The CSE will not produce that for any ticker, and the whole market intelligence module is built on the assumption that there is enough daily text to summarise, embed, and retrieve against. With one announcement a week the diversified retrieval scheme has nothing to diversify over.

Visual modality is a hard dependency. The low-level reflection module takes a Kline chart image and the high-level reflection module takes a trading chart image, both fed to GPT-4V. That is generatable for the CSE, the charts are just plotted from OHLCV with pyecharts, so this is portable in principle. But the claim being made is that a vision model reading a candlestick picture extracts something the numerical features do not already contain, and the paper never isolates that. No ablation strips the image while keeping the module.

Expert guidance is a data source I cannot replicate. Auxiliary information comes from Seeking Alpha professional analyst commentary, 393 to 600 items per stock. There is no CSE equivalent. Daily FT and EconomyNext are news, not per-ticker analyst coverage. So the augmented tools component loses its expert branch entirely and reduces to the three rule-based strategies.

No sentiment model anywhere. Sentiment is a field the LLM fills in while summarising market intelligence, POSITIVE, NEGATIVE or NEUTRAL, per news item, in English, from institutional sources. Nothing handles Sinhala, Singlish or code-mixed retail text, which is where G3 lives. Same blind spot as [[TradingAgents, Multi-Agents LLM Financial Trading Framework]] and FinVision.

Execution friction is mentioned once and then dropped. Section 3.1 says the reward function considers a commission fee. No cost parameter appears anywhere in the experimental setup, no slippage, no liquidity constraint, no turnover penalty. So it is the G1 problem in its most common form, the friction is acknowledged in the formulation and absent from the numbers.

Risk is measured, never controlled. MDD, VOL, SOR and CR are all reported as evaluation metrics. None of them feed back into the decision. There is no risk trigger, no exposure cap, nothing like FinCon's CVaR alert and certainly nothing with volatility persistence in it. The trader preference is a static string in the prompt, aggressive or conservative, set once. That is the opening for G2.

Single asset only. The conclusion says portfolio management is future work. So there is no cross-sectional allocation, no covariance, no weights.

## Standout features

Dual-level reflection, split by what it reflects on. Low-level reflects on price movements against market intelligence, high-level reflects on the agent's own past trading decisions. Different inputs, different visual data, different purpose.

Diversified retrieval. Memory is queried by M distinct retrieval types, not one similarity search, so top-K retrieval yields an M×K set of past market intelligence with each item tagged by the query intent that found it.

Separate query text field generated alongside every summary. The summary serves the trading decision, the query text serves retrieval. Two objectives, two fields, instead of one summary doing both jobs badly.

Augmented tools as auxiliary agents. MACD Crossover, KDJ with RSI Filter, Mean Reversion, plus expert guidance, each supplying both a decision and its explanation into the final prompt.

Chain-of-Thought plus in-context learning in the decision module, with the reasoning emitted as a required output field rather than as a nicety.

XML output format instead of JSON, because GPT-4 kept violating JSON's stricter syntax. Small, practical, and I will hit the same thing.

#### Gap it's addressing

The paper states five challenges, which is a cleaner problem statement than most of this literature manages:

- **Ch1** Insufficient multimodal data processing. Numerical, textual and visual market data need analytical methods to extract key insights, and prior work handles one or two modalities.
- **Ch2** Imprecise information retrieval. Mixing retrieval with the main task and retrieving against brief summaries produces noisy searches.
- **Ch3** Adaptability in rapidly evolving markets. Models need to respond to both live data and historical patterns.
- **Ch4** Integration of domain knowledge. Established expert methods and technical strategies are not wired in.
- **Ch5** Reasoning for actions. Black box models give decisions without the reasoning.

Positioned against BloombergGPT and FinGPT, which it argues are QA systems rather than sequential decision makers, and against FinMem, which it credits with the memory mechanism and human-aligned character design but calls text-only. The gap it claims is the space between financial QA and sequential trading.

Ch2 is the one I should take seriously and it generalises well beyond this paper. Retrieval and reasoning are different objectives, and using the reasoning artefact as the retrieval key is a mistake I would otherwise have made in the G4 RAG pipeline.

#### Problem formulation

Standard MDP first, a 5-tuple $(\mathcal{S}, \mathcal{A}, \mathcal{T}, R, \gamma)$ with transition function $\mathcal{T}: \mathcal{S} \times \mathcal{A} \times \mathcal{S} \to [0,1]$, reward $R: \mathcal{S} \times \mathcal{A} \to \mathbb{R}$, discount $\gamma \in [0,1]$. Note this is a full MDP, fully observable, unlike FinCon's POMDP framing and unlike what the survey in [[The Evolution of Reinforcement Learning in Quantitative Finance, A Survey]] argues is appropriate. Nobody justifies the Markov property holding here, it is just assumed.

Action space is buy, sell or hold on a single asset. Reward is change in market capital.

The extension is where it gets interesting. The classic RL objective is rewritten to carry a reasoning term:

$$\pi_{\theta^*} = \arg\max_{\pi_\theta} \mathbb{E}_{\pi_\theta}\left[\sum_{i=0}^{T} \gamma^i r_{t+i} \mid s_t = s, \mu_t = \mu\right]$$

where $\mu(\cdot)$ are specialised modules that encapsulate internal reasoning. The policy itself:

$$\pi_{\text{FinAgent}}(a_t \mid s_t, \mu_t) = \mathcal{D}^\lambda\left(\text{LLM}\left(\phi_D^\lambda(s_t, \mu_t)\right)\right), \qquad \mu_t = \mu(s_t, Mem_t^\lambda, Tool_t^\lambda)$$

$\phi^\lambda(\cdot)$ is a task-relevant prompt generator and $\mathcal{D}^\lambda(\cdot)$ is an action parsing function that turns the LLM's text back into an environment action. So the policy is prompt construction plus LLM call plus parse. There are no learned weights in the loop at all, which is the honest reading of this: it wears RL notation without doing any RL.

The module decomposition, with $M$, $L$, $H$ for market intelligence, low-level and high-level reflection:

$$\begin{aligned}
\mu_t &= \mu(s_t, Mem_t^\lambda, Tool_t^\lambda) = \mu(M_t^\lambda, L_t^\lambda, H_t^\lambda, Tool_t^\lambda) \\
M_t^\lambda &= \text{LLM}\left(\phi_M^\lambda(s_t, Mem_t^{M,\lambda})\right) \\
L_t^\lambda &= \text{LLM}\left(\phi_L^\lambda(M_t^\lambda, KC_t, Mem_t^{L,\lambda})\right) \\
H_t^\lambda &= \text{LLM}\left(\phi_H^\lambda(M_t^\lambda, TC_t, Mem_t^{H,\lambda})\right)
\end{aligned}$$

$KC_t$ is the Kline chart at day $t$, $TC_t$ the trading chart. Both reflection modules take market intelligence as input, so $M$ is upstream of everything.

Full objective:

$$\pi^*_{\text{FinAgent}} = \arg\max_{\pi(\cdot), \mu(\cdot)} \mathbb{E}_\pi\left[\sum_{i=0}^{T}\gamma^i r_{t+i} \mid s_t = s, \mu_t = \mu\right] \quad \text{s.t. } \pi(a_t \mid s_t, \mu_t) = \mathcal{D}^\lambda\left(\text{LLM}\left(\phi_D^\lambda(s_t,\mu_t)\right)\right)$$

Optimising over both $\pi$ and $\mu$ looks like a joint optimisation but nothing is optimised. There is no gradient, no prompt update rule, no training episode. The agent runs forward through the test window with fixed prompts. Compare FinCon, which at least defines textual gradient descent over $\theta$ and shows convergence in four episodes. FinAgent's $\arg\max$ is decorative, and I should not copy that framing into my own write-up because a reviewer will ask what the optimiser is.

#### Architecture
![[Pasted image 20260918114057.png]]
Five modules, executed in a numbered order per trading day.

**Market intelligence (§4.1).** Two halves.

*Latest market intelligence.* Takes today's news, reports and prices, and produces three fields: `analysis` per item, `summary` across items, and `query` for retrieval. Each news item gets classified on two axes, duration of effect (SHORT-TERM, MEDIUM-TERM, LONG-TERM) and sentiment (POSITIVE, NEGATIVE, NEUTRAL). The prompt forces a choice, one of three, no hedging, and caps analysis at 40 tokens per item and the summary at 300.

*Past market intelligence, via diversified retrieval.* This is the contribution. The naive approach embeds today's summary and does nearest-neighbour search over past summaries, which fails for two reasons the paper states plainly: the summary is optimised for the trading decision rather than for retrieval, and it carries noise irrelevant to the retrieval task. So the module emits an additional query field with $M$ separate query texts, $QLMI_t = \{Q_1^L, \dots, Q_M^L\}$, one per retrieval type. The stated types are short-term, medium/long-term market impact, asset price increase/decrease, market trend bearish/bullish, news/reports. Retrieving top-$K$ against each of $M$ types gives $M \times K$ retrieved items, each tagged with the intent that found it. Retrieved items are then summarised into $SPMI_t$ before going downstream.

**Memory (§4.2).** Vector store, three separate collections: market intelligence memory, low-level reflection memory, high-level reflection memory. Separated so that retrieval for one module cannot pull the other module's artefacts. Justified against a 3A framing:

| | What it buys |
| --- | --- |
| Acuity | Sharper forecasting from news, reports and historical context |
| Adaptability | Quick adjustment as conditions change |
| Amendability | Learning from past mistakes and successes |

Adaptability maps to low-level reflection, amendability to high-level reflection, and this is the cleanest part of the paper's internal logic.

**Reflection (§4.3).** Table 2 is the whole design in four rows:

| Reflection | Low-level | High-level |
| --- | --- | --- |
| Target | Price movements | Trading decisions |
| Visual data | Kline chart | Trading chart |
| Market understanding | Micro | Macro |
| Function | Adaptability | Amendability |

Low-level takes the market intelligence summaries plus the Kline chart with technical indicators and reasons about why prices moved, separately over short, medium and long horizons, emitting $LLR_t^{ST}, LLR_t^{MT}, LLR_t^{LT}$ plus a query field.

High-level takes past trading decisions with their reasoning plus a trading chart with buy and sell markers and a cumulative return plot, judges each past decision correct or incorrect, and emits an improvement field, a summary of lessons, and a query field. The paper's own case study prompt says "trading decision and reasoning made by your assistant for the past 14 days", so the reflection window is two weeks.

Both reflections are written back to their own memory collection, so the agent reflects on its own past reflections.

**Tool-augmented decision making (§4.4).** Inputs are the market intelligence summary, low-level reflection, high-level reflection, trader preference, and the augmented tools. Auxiliary agents run MACD Crossover, KDJ with RSI Filter and Mean Reversion and each contributes a decision plus an explanation. Expert guidance from Seeking Alpha comes in as text. Output is `analysis`, `reasoning`, `action`, with the action parsed out to BUY, HOLD or SELL.

Prompt engineering detail worth stealing: templates are HTML with `iframe` placeholders swapped for sub-templates at build time, filled from a `params` dict with `$$key$$` markers, and the model is required to return XML which is then parsed with an XML tool. They chose XML over JSON specifically because GPT-4 kept breaking JSON syntax. Appendix F has the full templates and they are reusable.

#### Experimental setup

- Backbone: GPT-4 for text modules, GPT-4V for the two reflection modules that consume images.
- Data: 2022-06-01 to 2024-01-01, 398 trading days. Train 2022-06-01 to 2023-06-01, test 2023-06-01 to 2024-01-01. So a seven month test window on daily data.
- Assets: AAPL, AMZN, GOOGL, MSFT, TSLA, ETHUSD. Six datasets, five of them US megacap tech.
- Sources: prices and news from Financial Modeling Prep, news originating from Bloomberg Technology, Seeking Alpha and CNBC. Expert guidance from Seeking Alpha. Visual data plotted with pyecharts.
- Volumes: news 9748 / 10007 / 7923 / 8178 / 10076 / 2611 and expert guidance 593 / 509 / 488 / 393 / 600 / none, in asset order.
- Hardware: one NVIDIA RTX A6000, used for the baselines. FinAgent itself needs no GPU, it is API calls.
- Baselines: B&H, MACD, KDJ&RSI, ZMR (rule-based); LGBM, LSTM, Transformer (ML and DL); SAC, PPO, DQN (RL); FinGPT, FinMem (LLM).

Metrics, six of them, one profit, three risk-adjusted, two risk. Annual rate of return with $C = 252$ trading days:

$$ARR = \frac{V_T - V_0}{V_0} \times \frac{C}{T}$$

Sharpe over the daily return sequence $\mathbf{r} = \left[\frac{V_1 - V_0}{V_0}, \frac{V_2-V_1}{V_1}, \dots, \frac{V_T - V_{T-1}}{V_{T-1}}\right]^T$, with volatility as its standard deviation:

$$SR = \frac{\mathbb{E}[\mathbf{r}]}{\sigma[\mathbf{r}]} \qquad VOL = \sigma[\mathbf{r}]$$

Maximum drawdown, Calmar and Sortino:

$$MDD = \max_{i=0}^{T}\frac{P_i - R_i}{P_i} \qquad CR = \frac{\mathbb{E}[\mathbf{r}]}{MDD} \qquad SoR = \frac{\mathbb{E}[\mathbf{r}]}{DD}$$

with $R_i$ the cumulative return path, $P_i = \max_{i=0}^{T} R_i$ the running peak, and $DD$ the standard deviation of negative returns only. The MDD definition as printed is malformed, $R_i$ is written as $\prod_{i=1}^{T} \frac{V_i}{V_{t-1}}$, which mixes the index $i$ with $t$ and runs the product to $T$ inside a quantity indexed by $i$. The intent is obvious, it is just wrong on the page.

Note there is no risk-free rate in the Sharpe. $SR = \mathbb{E}[\mathbf{r}]/\sigma[\mathbf{r}]$ with $R_f = 0$. Over a 2023 test window with US short rates around 5%, that inflates every Sharpe in the table including the baselines'. Consistent across methods so the ranking survives, but the absolute numbers do not mean what they look like.

#### Results

Table 4, test window ARR% / SR / MDD%:

| Asset | FinAgent | Best baseline | B&H |
| --- | --- | --- | --- |
| AAPL | 31.9 / 1.43 / 10.4 | LGBM 16.93 / 1.47 / 2.52 | 13.0 / 0.6 / 14.78 |
| AMZN | 65.1 / 1.61 / 13.2 | FinGPT 42.93 / 1.1 / 18.94 | 42.33 / 1.08 / 17.38 |
| GOOGL | 56.15 / 1.78 / 8.45 | DQN 34.4 / 1.39 / 7.15 | 22.47 / 0.71 / 12.97 |
| MSFT | 44.74 / 1.79 / 5.57 | DQN 30.44 / 1.18 / 10.56 | 22.49 / 0.84 / 12.92 |
| TSLA | 92.27 / 2.01 / 12.14 | FinMem 50.04 / 0.92 / 25.77 | 37.4 / 0.72 / 32.65 |
| ETHUSD | 43.08 / 1.18 / 12.72 | FinMem 44.72 / 1.27 / 13.59 | 29.26 / 0.87 / 23.21 |

Highest ARR and SR on all five stocks. Loses to FinMem on ETHUSD on every one of the three. The stated improvements over best baseline are 28.39% on AAPL, 51.64% ARR and 37.61% SR on AMZN, 46.64% on GOOGL, 10.25% ARR and 19.33% SR on MSFT, and 84.39% ARR with 93.27% SR on TSLA.

The abstract's headline is "92.27% return (a 84.39% relative improvement)". That is TSLA, the best of six, against the best single baseline on that asset. The average improvement figure of over 36% is the one to quote if quoting anything.

The 12 baselines claim does not survive counting. The abstract and §5.3 say twelve, §6 and Appendix C say nine, and Appendix D says "four conventional strategies and five advanced algorithms", which is nine. Listing them gives 4 + 3 + 3 + 2 = 12. So the twelve is right and two later sections undercount. Sloppy, and the same species of error as FinCon's caption overclaims.

Some baseline results are worth more than the headline. LGBM on AAPL gets SR 1.47 against FinAgent's 1.43 with an MDD of 2.52% against 10.4%. A gradient boosted tree on price features beats the multimodal foundation agent on risk-adjusted return with a quarter of the drawdown. The paper explains this correctly, rule-based and tree-based methods are robust to outliers and noise so they control risk well while capturing less return, and it concedes FinAgent trades risk control for returns given an aggressive trader preference. That concession is doing a lot of work. The trader preference is a prompt string, and no result isolates how much of the performance difference is architecture versus that one word.

ETHUSD is the honest failure. FinMem beats FinAgent on all three metrics, and the paper's diagnosis is that the auxiliary agents are stock-specific strategies that do not suit crypto's higher trading frequency. The ablation section says a generalised auxiliary agent for crypto could take ETH returns from 44% to 54%. Which means the augmented tools component is not general, it is tuned to an asset class, and the "Generalist" in the title is overstated.

#### Ablations

Table 5, TSLA and ETHUSD, components added cumulatively as M, ML, MLH, MLHT:

| Config | TSLA ARR / SR / MDD | ETHUSD ARR / SR / MDD |
| --- | --- | --- |
| M | 39.01 / 0.90 / 22.54 | 16.21 / 0.63 / 15.93 |
| ML | 39.27 / 0.77 / 30.15 | 25.97 / 0.77 / 24.43 |
| MLH | 57.16 / 1.02 / 25.77 | 52.33 / 1.34 / 13.59 |
| MLHT | 92.27 / 2.01 / 12.14 | 43.08 / 1.18 / 12.72 |

The prose does not match the table. The text claims the low-level reflection module raises ARR% by 45% to 101% and cuts risk by 14% to 44%, but M to ML is 39.01 to 39.27 on TSLA, which is nothing, and MDD gets worse, 22.54 to 30.15. The 45% and 101% figures line up with the ML to MLH step instead, so the prose has attributed the high-level reflection gains to the low-level module. Read the table, not the paragraph.

What the table actually says:

- Low-level reflection alone does nothing useful on TSLA and helps on ETH while increasing drawdown on both.
- High-level reflection is the module that earns its place. ML to MLH is the largest clean jump on both assets and it reduces drawdown on ETH from 24.43 to 13.59.
- Augmented tools are the biggest single contributor on TSLA, 57.16 to 92.27 ARR and 1.02 to 2.01 SR, and they actively hurt ETH, 52.33 down to 43.08. Same asset-class specificity as in the main results.

RQ3 pushes further: tools used alone, with no other module feeding the decision, gives 16% ARR on ETHUSD against B&H's 29%. So the rule-based auxiliary agents are not merely unhelpful on crypto, they are worse than doing nothing.

RQ4, diversified retrieval, tested on AAPL only. Figure 5(a) shows ARR and SR both improve with it. Figure 5(b) is a t-SNE of the retrieved market intelligence embeddings coloured by retrieval type, and the clusters separate cleanly, which is offered as proof the retrieval types are picking up genuinely different content. The separation is real but it is evidence that the query texts differ, not that the retrieved information is more useful. One asset, one plot, no numbers in the table. This is the thinnest evidence in the paper supporting what I think is its best idea.

Appendix Table 7 has the fuller grid, w/o-MLH, w/o-LHT, w/o-HT, w/o-T, plus a No-finetuned variant, across all six assets with SOR, CR and VOL. Better ablation than the main text, and it should have been in the main text.

#### Limitations

- Single asset only. No portfolio, no allocation, no covariance. Conclusion says portfolio management is future work.
- No transaction costs, slippage or liquidity anywhere in the experiments, despite a commission fee appearing in the MDP formulation.
- No risk control in the loop. Six risk metrics reported, none fed back.
- Formulated as a fully observable MDP with no justification, against the POMDP consensus.
- No optimisation despite the notation. Prompts are fixed, nothing is trained, and the train/test split exists only for the baselines that need it.
- One test window, seven months, six assets, five of which are correlated US tech megacaps over a period when that sector rallied hard. No walk-forward, no repeated splits, no significance test, no error bars, no seeds. Same G7 problem as everything else in this literature.
- Sharpe computed with a zero risk-free rate in a 5% rate environment.
- Single backbone, GPT-4 and GPT-4V, no open-weight comparison, so architecture versus model is unresolved. Same criticism as FinCon.
- Prose contradicts the ablation table on which reflection module does the work.
- "Generalist" is not supported. It generalises across five same-sector US stocks and fails on the one asset outside that class.

#### What I'm taking from this

Split retrieval from reasoning. Generate a dedicated query field alongside every summary, and never retrieve against the artefact that was written for the decision. This is the single most transferable idea in the paper and it applies straight to the G4 RAG pipeline as much as to the agent memory.

Tag retrieved evidence with the intent that found it. Retrieving $M \times K$ items labelled by retrieval type, rather than top-$K$ by raw similarity, is cheap and gives the decision layer something to weigh. It also gives G6 a free win, an attributable retrieval trail per decision without any extra instrumentation.

The low-level versus high-level reflection split, specifically the axis it splits on. Reflecting on the market and reflecting on your own decisions are different tasks with different inputs. Table 2 is the design. But the ablation says high-level is where the value is, so if I am cutting scope, cut the low-level one.

Auxiliary strategy agents must be matched to the asset. The ETH result is the useful finding in the whole paper. MACD, KDJ with RSI and mean reversion are calibrated to US large-cap daily dynamics, and dropping them onto an asset that trades differently made things actively worse than doing nothing. On the CSE, where turnover is thin and whale-driven, I should assume the same three strategies transfer badly and treat the choice of auxiliary strategies as something to validate, not inherit. This is a concrete argument for G7's equal-weight and rule-based baseline set: if a stock-tuned MACD agent underperforms B&H on ETH, it will very plausibly underperform B&H on the CSE.

The XML-over-JSON detail, and the modular HTML template structure in Appendix F. Saves me a week of prompt plumbing.

And the thing this paper is most useful for: it is the argument against the single-agent-with-modules design. One context, five modules, and the components that help on stocks hurt on crypto with no mechanism to notice or adapt. FinCon's manager-analyst split and its CVaR trigger are both direct responses to failures visible here. So when I justify a multi-agent architecture, FinAgent is the baseline the justification is against, and the ETH row is the evidence.
