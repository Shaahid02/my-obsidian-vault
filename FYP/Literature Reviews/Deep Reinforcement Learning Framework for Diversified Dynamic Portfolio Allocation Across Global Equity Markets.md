Develops and evaluates a deep reinforcement learning framework for dynamic portfolio allocation using the Soft Actor-Critic (SAC) algorithm, tested across three global equity markets, the Nasdaq-100, Nikkei 225, and Euro Stoxx 50, with walk-forward optimization spanning sixteen out-of-sample folds from 2003 to 2026. Written by Kashif and Ślepaczuk, this is essentially the direct methodological blueprint for my own project, same core idea of framing portfolio allocation as a sequential decision problem under an MDP, same SAC backbone, same walk-forward evaluation logic, just applied at global market scale rather than the CSE.

Core motivation: traditional portfolio construction treats prediction and allocation as two separate steps, forecast returns first, then feed them into a mean-variance optimizer. This two-step process is misaligned with what actually matters (risk-adjusted performance rather than forecast accuracy), slow to react to fast-changing markets, and brittle under estimation error. RL collapses prediction and allocation into a single learned policy trained directly on the objective that matters, so the paper's whole pitch is building and stress-testing that unified framework under conditions realistic enough, transaction costs, turnover penalties, diversification constraints, walk-forward retraining, that the results actually say something about deployability rather than just backtested-in-hindsight profitability.

#### Gap it's addressing

- Most prior DRL portfolio papers (Yang et al. 2020, Jiang et al. 2024, Cheng and Sun 2024, and others cited in the RL literature review) test on a single market, usually US equities, so there's no clean evidence on whether an RL allocation framework's edge generalizes across economically distinct markets or is just picking up something specific to one market's dynamics. This paper runs the identical framework, same features, same SAC setup, same WFO scheme, across Nasdaq-100, Nikkei 225, and Euro Stoxx 50 to test that directly.
- Flat policy architectures (a single distribution over all assets plus cash) dominate the DRL portfolio literature. Nobody had tried separating the equity-cash decision from individual asset selection into a hierarchical structure, a natural way to decompose the problem, how much to be in the market at all versus which stocks to hold once you're in it, but this hadn't been tested in this space before.
- Standard WFO retrains the model at every single fold regardless of whether the previous model is still working, which is computationally expensive and not how a real desk would operate. There wasn't an existing adaptive retraining rule that only retrains when validation performance actually degrades.
- Regime dependence of RL portfolio allocation is mostly asserted rather than tested. Papers claim RL "adapts to changing conditions" without decomposing performance across actual macroeconomic regimes to check when that's true and when it isn't.

#### Data and setup

Three indices representing US, Asian, and European equities, Nasdaq-100, Nikkei 225, Euro Stoxx 50, daily data from 2 January 2003 to 13 March 2026. Prices come from yfinance, historical index membership (all additions and deletions) from the Bloomberg Terminal, the two merged into a tradability mask so the investable universe at each date only includes stocks that were actually both a member of the index and had a valid price on that day. This is the standard survivorship-bias fix and it matters a lot here since these indices reconstitute constituents constantly (the Nasdaq-100 alone grew from under 100 to over 500 tradable names across the sample, as tracked in their Figure 2).
![[Pasted image 20260913184605.png]]
At each time step the universe is filtered down to the top-k assets by 120-day momentum (k = 20 or 30 depending on configuration) before the RL agent even sees the state, mainly to keep the action space and state dimensionality fixed and manageable rather than trying to model the full time-varying constituent list directly. Momentum itself is just the trailing 120-day price change:

$$m_{i,t}^{(120)} = \frac{P_{i,t}}{P_{i,t-120}} - 1$$

State features fall into four groups: momentum (log returns over 1/5/20/60 days), volatility (rolling standard deviation of returns over 5/20 days), technical indicators (RSI, MACD histogram, Bollinger %B, distance from the 20-day high, a mean-reversion signal), market-relative features (60-day rolling beta to the market ETF proxy, 20-day absolute return), and global features (VIX level and its 5-day change, cross-sectional average return and volatility, market breadth, normalized ETF returns). Benchmark ETF proxies used per market: QQQ for Nasdaq-100, FEZ for Euro Stoxx 50, EWJ for Nikkei 225.

#### Model architecture and training

Portfolio allocation is framed as an MDP, state, action (portfolio weight vector including a cash weight), transition, reward, discount factor, with the agent trained via SAC, an off-policy actor-critic method that maximizes expected return plus policy entropy (encourages exploration, gives more stable learning). The actor outputs the parameters of a Dirichlet distribution the weights are sampled from, which guarantees non-negative weights that sum to one without needing a separate normalization step. The action itself is the weight vector, subject to the budget constraint:

$$a_t = w_t = (w_{1,t}, \dots, w_{N_t,t}, w_t^c), \qquad \sum_{i=1}^{N_t} w_{i,t} + w_t^c = 1$$

Two policy structures are compared, a flat Dirichlet over all assets and cash directly, versus a hierarchical version that first decides the overall equity-cash split, then allocates within the equity portion.

State encoding uses an LSTM applied per asset with a cross-sectional attention mechanism to combine embeddings across assets in the baseline configuration, with one configuration swapping the LSTM for a two-layer Transformer self-attention encoder instead.

The reward function has three components, portfolio log return net of transaction costs, a turnover penalty (discourages excessive rebalancing), and a concentration penalty based on the Herfindahl index (discourages overly concentrated allocations, pushes toward diversification). Net return is first log-transformed to stabilize the learning signal, $\tilde{r}_{p,t} = \log(1 + r_{p,t}^{net})$. Turnover is the L1 distance between consecutive weight vectors:

$$TO_t = \sum_{i=1}^{N_t} |w_{i,t} - w_{i,t}^-| + |w_t^c - w_t^{c,-}|$$

and concentration is measured with the Herfindahl-Hirschman Index, whose minimum (most diversified) value is $1/N_t$:

$$HHI_t = \sum_{i=1}^{N_t} w_{i,t}^2, \qquad HHI_t^{min} = 1/N_t$$

Two reward formulations are tested, absolute return:

$$r_t = 1000 \cdot \tilde{r}_{p,t} - \lambda_{TO} \cdot TO_t \cdot 100 - \lambda_{conc} \cdot (HHI_t - HHI_t^{min}) \cdot 100$$

and benchmark-relative return, where $\tilde{r}_{b,t}$ is the benchmark's log return:

$$r_t = 1000 \cdot (\tilde{r}_{p,t} - \tilde{r}_{b,t}) - \lambda_{TO} \cdot TO_t \cdot 100 - \lambda_{conc} \cdot (HHI_t - HHI_t^{min}) \cdot 100$$

Five configurations in total: LSTM_1 (flat policy, absolute reward, cash allowed), LSTM_2 (hierarchical policy, absolute reward, cash allowed), LSTM_NC_1 and LSTM_NC_2 (flat policy, benchmark-relative reward, fully invested with no cash option, differing top-k), and TRANSFORMERS (flat policy, absolute reward, cash allowed, Transformer encoder instead of LSTM). Transaction costs fixed at 2 bps, consistent with institutional-tier IBKR commissions.
![[Pasted image 20260913184932.png]]
Evaluation uses non-anchored walk-forward optimization, a 5-year training window followed by 1-year validation and 1-year test, rolled forward across sixteen folds spanning 2003 to 2026. Rather than retraining at every fold, an adaptive retraining rule only re-trains the model when the current validation Sharpe ratio drops below a threshold set from the median and standard deviation of the last five validation Sharpes (or unconditionally for the first three folds as a cold start), cutting compute cost while keeping the setup realistic. The validation Sharpe and the threshold are:

$$S_k = \frac{\bar r_k}{\sigma_k}\sqrt{252}, \qquad \theta_k = \text{median}(S_{k-m}, \dots, S_{k-1}) - \frac{1}{2}\text{std}(S_{k-m}, \dots, S_{k-1})$$

with retraining triggered whenever $S_k < 0$, $S_k < \theta_k$, or three consecutive folds have passed without retraining. Model selection within each fold uses validation Sharpe with a tiered preference for configurations that generalize well between training and validation rather than just chasing the highest validation number.

Four benchmarks: Buy & Hold on the market ETF (the primary and most stringent comparison), Momentum Top-20 (equal-weight across the top 20 by the same 120-day momentum measure), Equal-Weight Monthly (naive 1/N diversification within the same top-k momentum universe the RL agent uses, isolating whether the RL policy adds anything beyond the momentum pre-filter itself), and a Markowitz Minimum Variance portfolio built with the same rolling 5-year covariance estimation and WFO structure. The primary evaluation metric throughout is the Modified Information Ratio:

$$IR2 = IR1 \times ARC \times \frac{sign(ARC)}{MD}, \qquad \text{where } IR1 = \frac{ARC}{ASD}$$

chosen specifically because it penalizes drawdowns (MD) directly rather than just scaling return by volatility the way a plain Sharpe ratio does.

#### Findings

- Results diverge sharply by market. On the Nasdaq-100, no RL configuration beats Buy & Hold or Equal-Weight Monthly on IR2, the best RL result (LSTM_2, IR2 = 0.46) still trails Buy & Hold's 0.52. The index's near-uninterrupted uptrend over the sample period simply favors staying fully passive, there isn't much for an active policy to add.
- On the Nikkei 225, RL strategies beat the weak Buy & Hold benchmark (which suffers an 11-year max loss duration recovering from the 2008 crash) but still lose to Equal-Weight Monthly and Markowitz Minimum Variance on IR2.
- The Euro Stoxx 50 is where the framework actually works. Every RL configuration outperforms Buy & Hold on IR2 here, LSTM_2 achieves the best risk-adjusted result of all RL strategies (IR2 = 0.15, ASD = 15.97%, lowest volatility and drawdown among RL configs), and this is also the only market where the regression-based abnormal returns test finds statistically significant positive alpha for several configurations (LSTM_1, LSTM_2, LSTM_NC_2, Transformer, all significant at 10%). The authors read this as the European market's relatively lower trend persistence and higher structural uncertainty being exactly the kind of environment where active allocation earns its keep.
- Despite those IR2 wins, none of the RL strategies show statistically significant mean-return outperformance over Buy & Hold under HAC-adjusted or bootstrap tests in any market, so the central hypothesis is only partially confirmed, real risk-adjusted edge shows up in specific settings, but it doesn't survive the stricter test of statistically distinguishable excess returns except through the regression/alpha route in the Euro Stoxx 50.
- Regime decomposition (post-GFC recovery 2009-2013, secular bull 2014-2019, COVID plus rate-hike cycle 2020-2026) shows RL adds the most value in the post-GFC recovery on the Nasdaq-100 and consistently across all three regimes on the Euro Stoxx 50, but loses to passive benchmarks during the 2014-2019 Nasdaq bull run specifically. The general pattern: RL earns its value in periods of elevated uncertainty and weaker trend persistence, and gets outrun by simple buy-and-hold when a market is just trending hard.
- The hierarchical policy (LSTM_2) consistently produces lower volatility and drawdown than the flat policy (LSTM_1) across all three markets, supporting the idea that separating the equity-cash decision from individual stock selection genuinely helps manage downside risk, though the paper flags this isn't a clean ablation since other design choices co-vary across configurations.
- Cash-allowed configurations beat fully-invested (no-cash) configurations on IR2 consistently, at the cost of somewhat lower absolute returns. The clearest case is Nasdaq-100 LSTM_NC_1, which posts the highest raw return of any RL strategy (1666%) but the worst IR2 among RL configs because of the drawdown that comes with staying fully invested.
- LSTM beats the Transformer encoder on risk-adjusted terms in every market despite the Transformer requiring roughly 23 hours per walk-forward cycle to train versus 14 for LSTM, so the extra self-attention machinery isn't paying for itself here.
- Combining the three markets into an equal-weight cross-asset ensemble improves things across the board, the LSTM_1 ensemble reaches IR2 = 0.41 against a 0.34 common benchmark, with LSTM_2's ensemble posting the lowest volatility and drawdown of any ensemble configuration, confirming a genuine diversification benefit from spreading a strategy across geographically distinct markets.

#### Limitations

- The five configurations vary encoder, policy structure, reward formulation, and portfolio constraints simultaneously rather than one dimension at a time, so the RQ1-RQ4 comparisons (reward formulation, policy structure, constraints, encoder) are exploratory, not causal, the paper is upfront about this itself.
- Transaction costs are fixed at 2 bps throughout, with no sensitivity check against higher or more realistic retail-tier costs, so it's unclear how much the results would hold up for someone facing worse execution.
- The walk-forward architecture itself (5-year train, 1-year validation, 1-year test, the retraining threshold) was picked from convention rather than tuned or tested for sensitivity, which the authors acknowledge is itself a form of the meta-overfitting risk Bailey et al. warn about.
- None of the RL strategies clear the bar of statistically significant mean-return outperformance over Buy & Hold in any market under HAC or bootstrap tests, so the headline economic results (especially the Euro Stoxx 50 IR2 story) need to be read next to that caveat rather than in isolation.
- The ensemble uses fixed equal weights across the three markets rather than any adaptive cross-market allocation, so the diversification benefit reported is really a lower bound on what a smarter ensemble could do.
- ![[Pasted image 20260913185045.png]]
#### Why this matters for my project

- This is basically the direct template my own framework is built on, same MDP framing, same SAC backbone, same reward structure (return net of costs, turnover penalty, concentration penalty), same walk-forward-plus-adaptive-retraining logic. Reading this closely means I know exactly which pieces are load-bearing (the hierarchical Dirichlet policy earning its keep on drawdown control, the top-k momentum pre-filter keeping the state space fixed-size) versus which are more incidental design choices that co-vary rather than being cleanly tested.
- The market-dependence finding is the single most important thing to carry forward. RL adds real, statistically supported value in the Euro Stoxx 50 specifically because that market has lower trend persistence and more structural uncertainty, and gets beaten by simple buy-and-hold in a strongly trending market like the Nasdaq-100. If I'm applying this framework anywhere else, CSE included, the first question has to be what kind of trend and regime environment that market actually is, since this paper says outright that determines whether active RL allocation is even the right tool.
- The regime decomposition method (splitting the OOS period into macro periods rather than treating it as one homogeneous stretch) is directly reusable, and lines up with the same three-regime logic I've already used in the CSE volatility notes (normal / COVID / crisis), just at a different granularity here (post-GFC / secular bull / COVID-rate hike).
- The statistical significance gap, real IR2 differences but no significant mean-return outperformance under HAC or bootstrap tests, is a good discipline check for my own evaluation. Whatever I build, I need to report both the economic metric (IR2 or equivalent) and the formal significance test side by side rather than letting a good-looking equity curve stand on its own.
- The cash-allowed vs fully-invested tradeoff (higher absolute return but worse IR2 when fully invested) and the hierarchical-vs-flat policy result (hierarchical wins on drawdown control specifically) both point to the same underlying lesson, the specific mechanism you give the policy for managing risk (holding cash, separating allocation stages) matters more for risk-adjusted performance than raw predictive power does. Worth keeping in mind when designing the action space or reward function for my own agent.
- LSTM outperforming the Transformer here, despite the extra training cost, is a useful prior against defaulting to the most complex encoder available. Worth testing both if compute allows, but not assuming attention automatically wins on a dataset this size.
