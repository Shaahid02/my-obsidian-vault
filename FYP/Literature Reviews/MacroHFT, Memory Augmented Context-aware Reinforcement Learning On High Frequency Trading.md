KDD '24, Zong, Wang, Qin, Feng, Wang and An, out of NTU Singapore, Skywork AI and SUTD. Minute-level high-frequency trading on four cryptocurrency pairs, framed as a two-level hierarchical MDP where six specialised DDQN sub-agents are each trained on a slice of the market decomposed by <font color="#ffc000">trend and volatility</font>, and a hyper-agent then learns a softmax mixture over their Q-value estimates, with an episodic memory module attached to stabilise that mixture under sudden fluctuations. Code released at github.com/ZONG0004/MacroHFT.

This is the direct successor to EarnHFT from largely the same group, and for my purposes it is the closest thing in the vault to a worked template for the RL execution layer, single asset, long only, discrete action, minute bars, which is exactly the shape the RL component would take on the CSE. It is also the only paper I have read so far that treats <font color="#ffc000">volatility as a conditioning variable the policy is trained against</font> rather than as a metric reported at the end, which is precisely where G2 lives. The contrast with [[Deep Reinforcement Learning Framework for Diversified Dynamic Portfolio Allocation Across Global Equity Markets]] is useful, that paper is cross-sectional allocation with a continuous Dirichlet action and walk-forward retraining, this one is single-asset timing with a binary action and one fixed split, so between them they bracket the two ends of what an RL layer can be asked to do.

> [!NOTE]
> **Hierarchical RL here does not mean multiple time scales.** EarnHFT put the low-level MDP at second-level granularity and the high-level MDP at minute level. MacroHFT deliberately operates both levels at the same minute-level time scale, the hierarchy is over *policy specialisation* rather than over *temporal abstraction*. Worth holding onto, because most of the HRL literature means the second thing.

#### Gap it's addressing

The paper states three drawbacks of existing RL-based HFT, and they are unusually concrete for this literature:

- **Market conditions are treated as uniform, or segmented on trend alone.** Most methods assume a single stationary environment, and the ones that do segment (EarnHFT [21] being the named case) split only on market trend, neglecting volatility entirely. The argument is that ignoring differences between markets with varying volatility levels degrades both risk management and the degree of specialisation any one strategy can reach, which matters more in crypto than almost anywhere else.
- **Overfitting to a small slice of features, with recent market conditions disregarded.** Citing [28], the claim is that a policy network trained on a long undifferentiated stretch becomes over-sensitive to particular indicators while having no mechanism to adjust for what the market has been doing lately, so it cannot make policy adjustments on financial context.
- **Individual agents adjust too slowly during sudden fluctuations.** At minute granularity in crypto, a single agent's decision is one-sided and highly biased, and the paper argues this is what causes significant loss in extreme markets.

Underneath all three is a sharper implicit claim that the paper never states as a hypothesis but which is really what it is testing: EarnHFT and MetaTrader both *select* one agent per timestep via a router, and MacroHFT *mixes* all of them via learned softmax weights. Whether mixing beats routing is the actual novelty, and I will come back to this, because Figure 5 complicates it.

#### Data and setup

Four USDT pairs from Binance at minute granularity, with 5-level limit order book snapshots alongside OHLCV. One fixed train / validation / test split per market, not walk-forward:

| Dataset | Train | Validation | Test |
| --- | --- | --- | --- |
| BTC/USDT | 22/03/05 - 23/02/22 | 23/03/18 - 23/06/15 | 23/06/22 - 23/10/15 |
| ETH/USDT | 22/02/01 - 23/01/31 | 23/02/01 - 23/05/31 | 23/06/01 - 23/10/31 |
| DOT/USDT | 22/02/01 - 23/01/31 | 23/02/01 - 23/05/31 | 23/06/01 - 23/10/31 |
| LTC/USDT | 22/02/01 - 23/01/31 | 23/02/01 - 23/05/31 | 23/06/01 - 23/10/31 |

What matters about those test windows is that they are all flat to down, the paper notes market values fell <font color="#ffc000">14.85% on DOT and 24.94% on LTC</font> over the test period, so the headline result is mostly a claim about not losing money in a falling market rather than about beating a rising one. That is a fair thing to test, it just needs saying plainly when quoting the numbers.

Trading setup: long only, $P_t \ge 0$, binary position so $a \in \{0, 1\}$ with a fixed predefined holding size, commission fixed at 0.02% for all four pairs following Binance's published rate. Metrics are one profit criterion (TR), two risk criteria (AVOL, MDD) and three risk-adjusted criteria (ASR, ACR, ASoR), all annualised with $m = 525600$ minutes in a year. Eight baselines: DQN, DDQN, CDQNRP, PPO, CLSTM-PPO and EarnHFT on the RL side, IV and MACD on the rule-based side.

The feature set is the part of the setup I most appreciate. Appendix A gives every indicator's formula explicitly, which is more reproducible than most of this literature manages, and the features are genuinely <font color="#ffff00">microstructural</font> rather than the usual RSI-and-MACD bundle. Weighted average price from the top two book levels, for instance:

$$y_{\text{wap1}} = \frac{q_t^{a_1} \cdot p_t^{b_1} + q_t^{b_1} \cdot p_t^{a_1}}{q_t^{a_1} + q_t^{b_1}}$$

order flow imbalance across the full five levels:

$$y_{\text{volume\_imbalance}} = \frac{y_{\text{buy\_volume}} - y_{\text{sell\_volume}}}{y_{\text{buy\_volume}} + y_{\text{sell\_volume}}}, \qquad y_{\text{buy\_volume}} = \sum_{i=1}^{5} q_t^{b_i}$$

and every one of the price, spread, WAP and volume features is then z-scored against its own trailing window before it reaches the network:

$$y_{\text{trend}} = \frac{y - \text{RollingMean}(y, 60)}{\text{RollingStd}(y, 60)}$$

where:
- $p_t^{b_i}, p_t^{a_i}$ are the $i$-th level bid and ask prices, $q_t^{b_i}, q_t^{a_i}$ the corresponding quantities
- the rolling window is 60 minutes throughout, matching the backward context window $h = 60$

Hyperparameters, since several turn out to be load-bearing: 4 × RTX 4090, chunk length $l_{chunk}$ explored over $\{360, 4320\}$ minutes (6 hours and 3 days) and set to 360 for BTCUSDT and 4320 for the other three, sub-agent embedding dimension 64 and hyper-agent 32 with policy network dimension 128 in both, 15 epochs each, Adam at 1e-4, $\alpha_l$ tuned over $\{0, 1, 4\}$ per sub-agent, $\alpha_h$ fixed at 0.5, and $\beta$ tuned over $\{1, 5\}$ with DOTUSDT getting 1 and the rest 5.

#### Model architecture and training

![[Pasted image 20260919214001.png]]

The hierarchy is formulated as two MDPs sharing a time scale, $MDP_l = \langle S_l, A_l, T_l, R_l, \gamma_l \rangle$ and $MDP_h = \langle S_h, A_h, T_h, R_h, \gamma_h \rangle$.

**Low-level state** is $s_{lt} = (s_{lt}^1, s_{lt}^2, P_t)$, where $s_{lt}^1 = \phi_1(x_t, b_t)$ are single-step features from the current LOB and OHLCV snapshot, $s_{lt}^2 = \phi_2(x_t, b_t, \dots, x_{t-h+1}, b_{t-h+1})$ are context features over a backward window of $h = 60$ minutes, and $P_t$ is the current position. **Low-level action** $a_{lt} \in \{0,1\}$ is the target position, with $P_{t+1} = a_{lt}$. **Low-level reward** is the one-step net value change after costs:

$$r_{lt} = \left(a_{lt} \times (p_{t+1}^c - p_t^c) - \delta \times |a_{lt} - P_t|\right) \times m$$

where:
- $p_t^c$ is the close price at minute $t$
- $\delta$ is the transaction cost rate, 0.02% here
- $m$ is the predefined holding size

The high-level reward is defined as the same quantity, which follows directly from both MDPs running at the same time scale.

> [!WARNING]
> Section 3.2 states that if $a_{lt} > P_t$ an **ask** order is placed and if $a_{lt} < P_t$ a **bid** order is placed. That is inverted, increasing the target position requires buying. The reward function above is written correctly, so this reads as a slip in the prose rather than in the implementation, but it is the kind of thing to check against the released code before reimplementing.

**Market decomposition** is the first phase and the paper's main structural idea. Training and validation data are cut into chunks of fixed length $l_{chunk}$, then each chunk gets two labels. For trend, the chunk goes through a low-pass filter for noise elimination, a linear regression is fitted to the smoothed series, and the slope is the trend indicator. For volatility, average volatility is computed over the *original* unsmoothed chunk so that the fluctuations are preserved, which is a small but correct detail given that the filter would otherwise destroy exactly the signal being measured. Chunks are then split into tertiles on each indicator separately, giving three trend subsets (bull, medium, bear) and three volatility subsets (volatile, medium, stable), so <font color="#ffc000">six training subsets and six sub-agents</font>. Validation chunks are labelled using the quantile thresholds learned on the training set, so each sub-agent is selected on the market it is supposed to be good at.

Worth being precise about what this is not: every chunk carries both a trend label and a volatility label, but no sub-agent is trained on a cell of the cross, there is no "bear and volatile" agent. Six marginal specialists, not nine joint ones. The paper does not justify or ablate that choice.

**Conditional adaptation** is the second idea, borrowed from the adaptive layer norm block in Diffusion Transformers [19]. Instead of concatenating position and context to the input features, where their low dimensionality means they get drowned by the state vector, they are turned into a scale and shift applied to the normalised hidden state:

$$h_s = \psi_1(s_{lt}^1), \qquad c = \psi_3(P_t) + \psi_2(s_{lt}^2) \tag{1}$$

$$(\beta, \gamma) = \psi_c(c) \tag{2}$$

$$h = h_s \cdot \beta + \gamma \tag{3}$$

where:
- $\psi_1, \psi_2$ are fully connected layers, $\psi_3$ a positional embedding layer over the discrete position
- $c$ is the condition representation, the sum of the context and position embeddings
- $\beta, \gamma \in \mathbb{R}^D$ are the scale and shift vectors produced by the fully connected layer $\psi_c$

The adapted hidden state feeds a dueling DDQN head:

$$Q^{sub}(h,a) = V(h) + \left(Adv(h,a) - \frac{1}{|A|}\sum_{a' \in A} Adv(h,a')\right) \tag{4}$$

trained on one-step TD error plus a KL term against an <font color="#ffff00">Optimal Value Supervisor</font> $Q^*$ inherited from EarnHFT, computed by dynamic programming over the training data:

$$L = \left(r + \gamma Q_t^{sub}\left(h', \arg\max_{a'} Q^{sub}(h',a')\right) - Q^{sub}(h,a)\right)^2 + \alpha_l KL\left(Q^{sub}(h,\cdot) \,\|\, Q^*\right) \tag{5}$$

**Meta-policy optimisation** is phase two. The hyper-agent sees $s_{ht} = (s_{ht}^1, s_{ht}^2, P_t)$ where $s_{ht}^1$ is the concatenated low-level single-state and context features and $s_{ht}^2$ is the slope and volatility over a backward window $h_c$, so the same two indicators that defined the decomposition are what the hyper-agent conditions on, via the same conditional adapter. It emits a softmax weight vector over the $N = 6$ sub-agents and mixes their Q-values:

$$Q^{hyper} = \sum_{i=1}^{N} w_i Q_i^{sub}, \qquad a_{ht} = \arg\max_{a'}\left(\sum_{i=1}^{N} w_i Q_i^{sub}\right)$$

**Memory augmentation** is the third idea. A fixed-capacity table $M = (K, E, V)$ stores keys $k = \psi_{enc}(s)$ from the hyper-agent's own state encoder, the state-action pair, and a one-step value estimate $v = r + \gamma \max Q^{hyper}(s', \cdot)$, evicted first-in-first-out so the memory always holds the most recent experiences. Lookup retrieves the top-$m$ neighbours by L2 distance:

$$d(k, k_i) = \|k - k_i\|_2^2 + \epsilon, \quad k_i \in K \tag{6}$$

$$w_i = \frac{d(k,k_i)\mathbf{1}_{a=a_i}}{\sum_{i=1}^{m} d(k,k_i)\mathbf{1}_{a=a_i}} \tag{7}$$

$$Q_M(s,a) = \sum_{i=1}^{m} w_i v_i \tag{8}$$

and the retrieved value becomes an auxiliary regression target alongside the standard TD target:

$$L = \left(r + \gamma Q_t^{hyper}\left(s', \arg\max_{a'} Q^{hyper}(s',a')\right) - Q^{hyper}(s,a)\right)^2 + \alpha_h KL\left(Q^{hyper}(s,\cdot)\|Q^*\right) + \beta\left(Q^{hyper}(s,a) - Q_M(s,a)\right)^2 \tag{9}$$

> [!important]
> Equation 7 as printed weights each retrieved experience **proportionally to its distance**, so the least similar neighbours in the top-$m$ set receive the most weight. Neural episodic control, which equation 6's $\|k - k_i\|_2^2 + \epsilon$ form is lifted straight from, uses that quantity as the *denominator* of the kernel, $w_i \propto 1/(\|k-k_i\|_2^2 + \epsilon)$. Almost certainly a typo, and the surrounding prose about retrieving similar experiences says as much, but it is a sign-flip that would silently train a worse agent if copied verbatim, so it goes on the reimplementation checklist next to the bid/ask slip.

#### Findings

![[Pasted image 20260919214002.png]]

- **MacroHFT is the only method that finishes positive on all four markets**, at TR of 3.03% on BTC, 39.28% on ETH, 13.79% on DOT and 18.16% on LTC, against baselines that are negative in the large majority of cells. Scoped properly, that is a result about a falling-to-flat four-month window in late 2023, and on DOT and LTC where the underlying fell 14.85% and 24.94% the achievement is avoiding the drawdown rather than capturing a rally. It is still the cleanest sweep in the table, since no baseline is positive on more than three markets and most are positive on none.

- **The risk-adjusted profit claim holds, the low-risk claim does not.** MacroHFT takes the best ASR on all four (0.61, 3.89, 0.97, 1.50), best ACR on all four (2.06, 8.41, 2.45, 3.11), best ASoR on all four (0.34, 2.49, 0.68, 0.66). But on raw risk the picture is mixed, MacroHFT's AVOL of 18.19% on BTC sits well above CDQNRP's 1.29% and DDQN's 2.77%, and on DOT its AVOL of 40.31% is the worst figure in that entire market block. The paper is honest about this in Section 5.5, noting that chasing larger potential profit leads to higher risk, so the defensible claim is about return per unit of risk, not about risk itself.

- **The EarnHFT comparison, which is the one that actually matters, is only a real contest on one market.** EarnHFT is the sole hierarchical RL baseline and the direct predecessor, and MacroHFT beats it everywhere, but on BTC, DOT and LTC, EarnHFT posts -11.16%, -2.67% and 0.54%, which is a baseline that simply failed to find a profitable policy at all. On ETH, EarnHFT reaches 18.02% with ASR 1.53 and MacroHFT reaches 39.28% with ASR 3.89, and that is the one cell where two working systems are being compared. So the evidence that adding a volatility axis and switching from routing to mixing improves on EarnHFT rests substantially on a single market, single run.

- **The trading numbers say this is not a high-turnover strategy.** MacroHFT executes 19 trades on BTC, 20 on ETH, 38 on DOT and 138 on LTC across roughly four months of minute bars. CLSTM-PPO takes 407 on ETH, MACD takes 234 to 286, DDQN takes 282 on BTC. So the winning policy is a low-turnover position-holding policy that happens to observe minute-level microstructure, not scalping or market making, and "high frequency" here describes the <font color="#ffc000">observation granularity rather than the trade frequency</font>. The paper never comments on this, which is a missed opportunity, because it is one of the more interesting things the results show. It also means the 0.02% commission barely binds, roughly 20 round trips over four months costs well under a percent, so this setup carries essentially no information about cost sensitivity.

- **PPO and CLSTM-PPO are degenerate rather than competitive.** PPO takes exactly 1 trade on ETH, DOT and LTC, and on LTC the PPO and CLSTM-PPO rows are identical to two decimal places across all six metrics (-24.96%, -0.70, -0.93, -0.61, 66.39%, 50.00%) with a trading number of 1. That is buy-and-hold on a market that fell 24.94%, arrived at by two different algorithms collapsing to the same simplistic policy. The paper diagnoses this correctly, policy-based methods are highly sensitive during training and converge to buy-and-hold, especially in bear markets. It does mean that a quarter of the baseline table is not really testing anything, and that the absence of an explicit buy-and-hold row is a presentational choice rather than a missing benchmark.

- **IV is the baseline to take seriously.** Imbalance Volume is positive on three of four markets (0.56%, 10.58%, 7.75%, against -9.24% on BTC) and takes second-best TR on DOT. A single microstructure indicator with tuned take-profit and stop-loss levels gets most of the way to the learned system on two markets, which the paper acknowledges while noting the dependence on precise threshold tuning and human expertise. The honest reading is that MacroHFT's edge over a well-tuned rule is real but narrower than its edge over the RL baselines.

- **The ablation supports both modules, unevenly, and with one clean exception the paper reports.**

![[Pasted image 20260919214004.png]]

  Removing either module hurts TR and ASR on all four markets, and the largest swing is DOT, where w/o-CA collapses to -16.79% against the full model's 13.79%, a 30 point spread, with MDD widening from 15.89% to 31.66%. LTC shows the same shape, both ablations negative (-6.71% and -8.66%) against the full model's 18.16%. The exception is ETH's drawdown, where w/o-CA achieves MDD of 7.57% against the full model's 9.67%, so on that market the conditional adapter costs about two points of drawdown while taking TR from 14.27% to 39.28%. The paper states this exception explicitly rather than burying it, which is to its credit.

- **The ablation return curves are more informative than the table.**

![[Pasted image 20260919214005.png]]

  Figure 6 attributes distinct failure modes to the two modules, MacroHFT without memory cannot respond in time to the sudden fall in ETH and takes a large loss, while MacroHFT without the conditional adapter fails to adjust when the trend switches from flat or bear to bull and misses the upside. That is a cleaner story than "both help", memory handles abrupt fluctuation and the adapter handles regime transition, and it lines up with what each module is architecturally supposed to do. It rests on two return curves from single runs, so treat it as a plausible mechanism reading rather than as demonstrated.

- **The learned mixture is close to binary, which undercuts the mixing-over-routing argument.**

![[Pasted image 20260919214003.png]]

  Figure 5 plots hyper-agent weights on BTCUSDT averaged over 60-minute intervals, and what it shows is a policy flipping between two configurations, one where the bear sub-agent holds roughly 0.85 of the weight and everything else sits near zero, and one where two sub-agents share about 0.5 each with the volatile agent around 0.15. Three of the six curves are barely off the floor for the whole test period. So on this market, the hyper-agent is effectively doing hard selection with a small blend rather than genuinely mixing six specialists, and the gap between MacroHFT's architecture and EarnHFT's router may be smaller in practice than in principle. The paper reads the same figure as evidence of reasonable mixing and quick adjustment, which is the other available reading, but the near-binary structure is visible and it is not addressed.

- **The qualitative trading examples are consistent with the low-turnover picture.** Figure 4 shows a breakout trade on ETH over a roughly 100-minute window, a long trend-following hold on DOT spanning thousands of minutes with a single exit, and a stop-loss then re-entry on LTC. Three of the four illustrations are multi-hour or multi-day holds. Useful as sanity-checking that the policy is doing something interpretable, not useful as evidence of anything, since they are hand-picked windows.

#### Limitations

- **Single run per cell, one test window per market, no seeds, no error bars, no significance test.** Everything in Tables 1 and 3 is one number from one training run on one four-month out-of-sample stretch, across four assets that are all crypto and all tested over the same mid-2023 period, so the four markets are far less independent than the table's layout implies. A 30 point ablation swing on DOT is striking, but nothing in the paper lets me separate it from run-to-run variance in a DDQN trained on a single decomposed subset. This is the same G7 problem visible in [[A Multimodal Foundation Agent for Financial Trading, Tool-Augmented, Diversified, and Generalist]] and across most of this literature.

- **The execution model ignores the order book that the state observes.** Five levels of LOB feed the features, and the reward function fills an order of predefined size at the next close price minus a flat 0.02% fee. No slippage, no queue position, no partial fills, no market impact, no spread crossing, despite orders being described as limit orders placed into that book. For a portfolio paper that would be a fair simplification, for an HFT paper it is the central omission, and it is <font color="#ff0000">exactly the G1 blind spot</font> in its most consequential form.

- **Binary position, long only, fixed size.** $a \in \{0,1\}$ with holding size $m$ fixed and $P_t \ge 0$, so there is no sizing decision, no leverage and no shorting. This is a timing model. Given that MacroHFT's advantage on DOT and LTC comes from being flat while the market fell, a shorting-capable variant is the obvious next question and the paper does not raise it.

- **Six marginal sub-agents rather than nine joint ones, unexamined.** Every chunk carries both labels but no agent is trained on a trend-volatility cell, so the architecture cannot represent "bear and volatile" as a distinct condition even though its own decomposition identifies one. Since this is the paper's headline structural contribution over EarnHFT, some evidence on the granularity choice would have been the most valuable ablation available and it is not there.

- **The decomposition granularity is a tuned hyperparameter explored over two values.** $l_{chunk}$ is 360 minutes on BTC and 4320 on the other three, a twelve-fold difference selected on validation return, from a search space of exactly two options. Whether the method is sensitive to chunk length, and what the tertile boundaries actually look like in each market, is not reported.

- **The Optimal Value Supervisor is a hindsight teacher whose contribution is never isolated.** $Q^*$ is computed by dynamic programming over training data with full knowledge of future prices, and its KL term appears in both loss functions, with $\alpha_l$ tuned over $\{0,1,4\}$ per sub-agent and $\alpha_h$ fixed at 0.5. No ablation sets $\alpha$ to zero, so whatever share of performance comes from distilling a hindsight-optimal policy is bundled in with the contributions attributed to the conditional adapter and the memory. Since the supervisor is inherited from EarnHFT and EarnHFT is the beaten baseline, this is not a fatal confound, but it does mean the two claimed contributions are measured on top of an unmeasured third.

- **Memory design choices are asserted rather than tested.** FIFO eviction is justified on the grounds that the most recent experiences offer the most relevant knowledge, which is a reasonable prior in a non-stationary market and also exactly the sort of claim that an ablation could settle, since it implies nothing survives from an earlier analogous regime. No results on memory capacity, on $m$, or on eviction policy. And $\beta$ is tuned per market over $\{1,5\}$, so the memory term's weight is itself fitted.

- **Two notational errors and one inconsistency.** The bid/ask direction in Section 3.2 is inverted, equation 7's distance weighting is the reciprocal of what the prose describes, and the number of sub-agents is written $N$ in Section 3.2 and $m$ in the high-level action definition on the following page, with $m$ also used for both the holding size and the number of minutes in a year elsewhere. None of these change the results, all of them cost time when reimplementing.

- **No walk-forward.** One fixed split per market, which is defensible given the training cost of six sub-agents plus a hyper-agent across four markets, but stands in direct contrast to the sixteen-fold walk-forward in [[Deep Reinforcement Learning Framework for Diversified Dynamic Portfolio Allocation Across Global Equity Markets]] and means there is no evidence here about whether the decomposition thresholds learned in 2022 remain valid as the market drifts.

#### Why this matters for my project

- **This is the operational answer to G2 that I have been missing.** [[Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange]] establishes that CSE volatility has long memory, and [[Sri Lankan Stock Market Volatility Analysis, An ARMA-GARCH Approach]] establishes the asymmetry, but neither says what a trading system should *do* with that. MacroHFT's answer is concrete and cheap: cut the series into chunks, label each chunk by its realised volatility tertile, train a specialist per tertile, then condition the policy on the current slope-and-volatility pair at decision time. Long memory is what makes this work at all, since a volatility label only has predictive content for the next chunk if volatility persists, so the FIGARCH $d$ estimates are the justification for the design rather than a separate finding. This converts G2 from a descriptive observation into a mechanism, which is what I need it to be.

- **Do not inherit the six-marginal-agents choice, ablate it.** The paper's own decomposition produces a nine-cell trend × volatility grid and then trains on the margins only. On the CSE, where the thin-and-whale-driven regime and the volatile regime plausibly coincide, the joint cell is the one I would actually want, so the granularity of the decomposition is a first-class experimental variable in my build, not a setting to copy. With CSE's shorter effective history the count of subsets is also constrained by data volume, so this is a decision I have to make explicitly regardless.

- **The conditional adapter is the single cheapest transferable piece.** One extra MLP producing $(\beta, \gamma)$ applied as scale and shift on a layer-normalised hidden state, and the motivation generalises well past this paper: <font color="#ffc000">a low-dimensional conditioning signal concatenated onto a high-dimensional state gets drowned</font>. That is exactly the situation I am in when feeding position, regime label and sentiment score into a policy network alongside a large feature vector, and on this evidence FiLM-style conditioning is a better default than concatenation. The DOT ablation (13.79% with, -16.79% without) is the strongest single number supporting it, scoped to one run on one market.

- **The trading-number finding changes what I can plausibly claim about the CSE.** Nineteen trades in four months is not high-frequency trading in the turnover sense, and that is good news for "High frequency trading in CSE" as a project motivation, because the CSE cannot support 400 trades in four months on any ticker without the position being the market. The realistic framing for me is minute-bar or intraday-bar observation with low turnover, which is what MacroHFT actually delivers despite its title. But the same finding kills any use of this paper as evidence on G1: with roughly twenty round trips and a 2 bps-equivalent flat fee, costs never bind here, so <font color="#ff0000">this paper tells me nothing about what happens when a policy of this shape pays realistic CSE spread and impact</font>. That absence is the open question, and the honest thing is to record it rather than to assume the design survives the friction.

- **Test routing before building mixing.** The architectural claim is that a learned softmax mixture beats EarnHFT's hard router, and Figure 5 shows the learned mixture is near-binary on BTCUSDT anyway. On that evidence the marginal gain from mixing over routing is unquantified, so the sensible order for my own build is to implement the cheaper router first, measure it, and only add the mixture if the router's weight trace shows genuine blending is needed. That also gives me the ablation the paper never ran.

- **Episodic memory is worth having as an option, with the weighting fixed.** Table, FIFO, L2 top-$m$ lookup, one extra squared-error term, no architectural change to the policy network. Cheap enough to include and ablate. Two caveats to carry: reimplement equation 7 as inverse distance, and treat the reported gains as an upper bound since $\beta$ is tuned per market and memory size is never varied.

- **G7 discipline, stated as a contrast.** MacroHFT reports single runs across four correlated crypto markets over one shared four-month window with no seeds and no significance test, and it is a KDD paper. That is the standard I am measuring the field against when I argue that no CSE benchmark exists, and it sets the floor my own protocol has to clear: seeds and repeated windows at minimum, so that a 30-point ablation spread can be distinguished from variance. Pairing that with the walk-forward scheme from the Kashif and Ślepaczuk framework gives me a protocol neither paper has on its own.

- **The two-phase training structure is reusable independently of everything else.** Train specialists on partitioned data, freeze them, then train a light mixing or selecting layer on the full series. This keeps the expensive learning inside narrow, homogeneous subsets and the cross-regime learning in a small network, which matters a lot given how little CSE data I am likely to have. It also gives the sub-agents a natural interpretation as named regime specialists, which feeds G6 directly: a decision annotated with the weight assigned to the bear specialist versus the volatile specialist is an attributable explanation with no extra instrumentation, the same free win I noted from FinAgent's intent-tagged retrieval.
