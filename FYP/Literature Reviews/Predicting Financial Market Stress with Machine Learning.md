---
citekey: "aldasoroPredictingFinancialMarket2025"
title: "Predicting financial market stress with machine learning"
authors: "Iñaki Aldasoro, Peter Hördahl, Andreas Schrimpf, Sonya Zhu"
year: 2025
venue: "Bank for International Settlements"
doi: ""
zotero: "zotero://select/library/items/PYNXNGJT"
stream: 
market: 
status: complete
tags:
  - literature-review
---
%% begin review %%

BIS Working Paper 1250, February 2025, all four authors out of the BIS Monetary and Economic Department with Schrimpf also at CEPR. Two contributions stacked on each other. First, they build daily <font color="#ffff00">market condition indicators</font> (MCIs) for three US markets, Treasury, FX and money markets, out of microstructure inputs rather than the equity-volatility inputs that dominate conventional stress indices, aggregating each market's inputs through a rolling-window PCA so the index at any date uses only past information. Second, they forecast the full conditional distribution of those indicators three to twelve months ahead with quantile regression, benchmarking a random forest against a quantile AR and a 44-predictor multivariate quantile regression, and then open the forest up with Shapley values. <font color="#ffc000">The headline is that the random forest achieves up to 27% lower quantile loss than the AR benchmark at the 90th quantile of FX stress three months out, that the 44-predictor linear model wins in-sample everywhere and loses out-of-sample everywhere, and that funding liquidity, investor overextension and the global financial cycle carry most of the attribution.</font> The MCI series are released with the paper.

This is not a competitor architecture, there are no agents here and nothing resembling an orchestrator, and the horizon is monthly over three to twelve months rather than daily. It earns a full note because it is the closest thing in my set to a worked specification of the thing my weighting function conditions on. My orchestrator is supposed to vary agent influence as a function of measured exogenous market state, and the measurement half of that sentence has so far been a promise, $L_t$ and $V_t$ named and not constructed. This paper constructs exactly that object from illiquidity, volatility and arbitrage-breakdown inputs, enforces the look-ahead discipline that makes it usable in a forecasting exercise, forecasts its upper tail rather than its level, and attributes the forecast with SHAP, which is the same attribution layer the re-scoped explainability plan commits to. It speaks directly to $A_L$ and $A_V$ and to the orchestrator's state vector, and the parsimony result in the middle of it is the most useful thing I have read against my own conditioning set.

#### Gap it's addressing

- **Aggregate stress and financial conditions indices conflate broad sentiment with structural vulnerability, and the authors make that concrete rather than asserting it.** The argument is that FSIs and FCIs give a snapshot of market health but mix broad sentiment shifts, equity volatility via the VIX above all, with liquidity shortages and arbitrage breakdowns, and the supporting observation is that the OFR's FSI and Goldman's US FCI both correlate very highly with the VIX despite the VIX being one input among many. The consequence they care about is that a stress signal you cannot attribute to a market is a stress signal you cannot act on with a targeted intervention.
- **The missing object is a market-specific indicator built from market-specific frictions.** Rather than one index for the system, three indices for three segments, each built from the dislocations that are diagnostic of that segment, bid-ask spreads and on/off-the-run spreads and repo-OIS for illiquidity, covered interest parity deviations and triangular no-arbitrage violations for impaired arbitrage. The claim is that these capture balance-sheet constraints on intermediaries in a way a volatility index cannot.
- **Distribution rather than mean is the second framing, and it is the one that transfers.** Policymakers care about the upper percentile stress scenarios that could trigger contagion, not the conditional mean, and linear regression on conditional means flattens precisely those extremes. Quantile regression gives the whole distribution, which lets them ask what drives the worst 10% of money market outcomes rather than the average one.
- **Two properties of the forecasting problem are argued to suit tree-based models specifically.** The quantile loss is non-smooth and many of the 44 predictors are uninformative on average while mattering in specific quantiles, both conditions under which [[Empirical Asset Pricing via Machine Learning]] and the tabular-data result they lean on say trees do well, and trees also stay interpretable through TreeSHAP in a way a network does not.

The premise carrying the whole exercise is that the first principal component of a dozen standardised friction measures is a meaningful scalar state of a market. The paper asserts this, validates it informally against known episodes, and never tests it against an alternative aggregation, so I deal with it once, in limitations, rather than relitigating it each section.

#### Data and setup

Daily series from Bloomberg, Tradeweb, Datascope and the Fed for the index inputs, EPFR and ICI for fund flows, over 01/01/2003 to 31/05/2024, then aggregated to monthly for the forecasting exercise.

| Component | Setting |
| --- | --- |
| Markets | US Treasury, US money market, FX centred on the dollar |
| Period | Jan 2003 to May 2024, 239 monthly observations |
| MCI inputs | FX 4 series, Treasury 8 series, money market 4 series |
| Aggregation | rolling-window PCA, first principal component |
| Initial PCA window | 3 years, expanded by one month at each step |
| Predictors | 44, in two families, overextension and risk perception, versus funding liquidity and market-making capacity |
| Estimation-test window | 84 months, rolled forward |
| Horizons | $h = 1 \ldots 12$ months |
| Test windows | 153 at $h=1$, 142 at $h=12$ |
| Quantiles | median, 75th, 90th, 95th |
| Metric | average out-of-sample quantile loss |

> [!NOTE]
> **MCI.** For each market, the input series are signed so higher means worse conditions, z-scored to mean zero and unit variance, and then reduced to their first principal component, which is re-normalised to zero mean and unit standard deviation. Positive values therefore mean tighter-than-average conditions. All three are right-skewed in the way you would expect of a stress measure: MCI(TR) runs −1.80 to 6.34, MCI(MM) −1.53 to 5.02, MCI(FX) −1.77 to 4.15, each against a standard deviation of roughly 0.95.

Two choices in that grid matter more than they look. The first is the rolling PCA, which the authors adopt specifically because the full-sample version used in their earlier policy article computes the components from the entire dataset and therefore introduces future information into every historical value of the index. <font color="#ffc000">They run both and plot them together, which is the cheapest possible honesty about look-ahead bias and something almost nothing else in my set does.</font> The two series are close in the crises and visibly apart elsewhere, the Treasury panel in particular, where the rolling estimate carries a spike in early 2020 more than twice the height of the full-sample one.

![[Pasted image 20261004180001.png]]

The second is the 84-month estimation window. That is 84 monthly observations against 44 predictors in the multivariate specification and against a random forest in the ML specification, which is a very small training set by any ML standard and is the fact that makes the parsimony result below more than a curiosity.

> [!WARNING]
> **The test windows overlap heavily and the paper does not say how the confidence intervals handle it.** With 153 rolling 84-month windows over a 239-month sample and forecast horizons out to twelve months, successive forecast errors share almost all of their training data and, at $h=12$, eleven months of their target window. The 90% intervals in Figure 4 are the only uncertainty quantification in the paper and the correction used to produce them is not stated, so I read the significance claims as indicative rather than as clean tests.

#### Model architecture and training

Everything is evaluated under the same objective, the check-function quantile loss, which is the piece I would need to reimplement and the reason the comparison across models is apples to apples:

$$\frac{1}{N}\sum_{t=1}^{T}\rho_\tau\left(y_t - \boldsymbol{\beta}\boldsymbol{x_t^T}\right), \qquad \rho_\tau(u) = \begin{cases}\tau u & \text{if } u > 0\\ (\tau - 1)u & \text{if } u \leq 0\end{cases}$$

where $\tau$ is the quantile being fitted and the asymmetry of $\rho_\tau$ is what makes the fitted line a quantile rather than a mean, under-prediction and over-prediction being penalised at different rates.

The first benchmark is a quantile AR(1) on the market's own lagged MCI, extended so that each market sees all three, which is the specification the rest of the paper actually competes against. The second adds the 44 predictors on top:

$$y^\tau_{i,t} \sim \beta_1 y_{tr,t-1} + \beta_2 y_{mm,t-1} + \beta_3 y_{fx,t-1} + \sum_{k=1}^{K}\gamma_k x_{k,t-1} + \varepsilon_t, \qquad i \in \{tr, mm, fx\}$$

The predictors split into Fed and government balance-sheet variables (Treasury purchases in level and six-month moving average, the Treasury General Account, failed deliveries, dealer coupon holdings), fund flows (EPFR cross-border flows, ICI intra-family flows into money market, high-yield and equity funds), macro-financial state (excess bond premium, broad dollar index, the Rey global financial cycle index, Citi surprise indices, futures margin, bill issuance, curve slopes) and risk proxies (MOVE, VIX, SKEW, three-month implied vol on EUR, GBP and JPY).

The ML model is a quantile regression forest in the Meinshausen sense, a random forest read as an estimate of the full conditional distribution rather than the conditional mean. <font color="#ff0000">No hyperparameters are reported anywhere, no tuning procedure is described, and the XGBoost comparison that would show the choice of tree ensemble does not drive the result is explicitly "unreported".</font> Attribution is TreeSHAP, with the Shapley value defined in the usual cooperative-game form:

$$\phi_i = \sum_{S \subseteq N \setminus \{i\}} \frac{|S|!\,(|N| - |S| - 1)!}{|N|!}\left[f(S \cup \{i\}) - f(S)\right]$$

where:
- $N$ is the full feature set and $S$ a subset not containing feature $i$
- $f(S)$ is the model's prediction using only the features in $S$
- the combinatorial weight averages $i$'s marginal contribution over every possible ordering of the features

The reason this is affordable at all is that the exact computation is exponential in $|N|$ and the Lundberg tree solution reduces it to a polynomial traversal of the tree structure, which is why the attribution layer here costs almost nothing while the same thing on a network would not.

#### Findings

- **The MCIs carry market-specific stress that the VIX does not, and the 2015–16 window is the cleanest demonstration.** The FX MCI rose significantly through the Swiss franc de-peg, Brexit and the US money market fund reform without a commensurate VIX spike, which is the single episode that justifies the whole construction, because an index tightly linked to the VIX by design cannot produce that divergence. The Treasury MCI moves into positive territory after the 2013 taper tantrum and during the idiosyncratic flash events of 2014 and 2021, and all three spike in the GFC and the pandemic to differing degrees, the money market one remaining largely subdued outside those two. I would read the known-episode matching as construct validation rather than as a result, since the inputs were chosen partly because they are known to move in those episodes.
- **Out of sample the 44-predictor model loses to a one-lag AR everywhere, and the reversal against in-sample is total.** In-sample the multivariate model has lower quantile loss than the AR unambiguously, every market, every quantile, every horizon from one to twelve months. Out of sample the ordering flips just as completely, across horizons, markets and quantiles, and at the twelve-month horizon for the Treasury MCI the multivariate model's quantile loss exceeds the AR's by 18%. The out-of-sample panels are also visibly unstable, the full-model loss sawtoothing between adjacent horizons while the AR line rises smoothly, which is what estimation noise rather than mis-specification looks like.

  ![[Pasted image 20261004180002.png]]
- **The random forest's gains are real in two markets out of three and the third is a null the authors state plainly.** RF has significantly lower quantile loss than the AR in money and FX markets across horizons and quantiles, reaching 27% lower loss at the 90th quantile of FX stress at the three-month horizon, with money market performance comparable at $h=1$ and significantly better from $h=2$ onward, and FX improving monotonically out to $h=11$. For the Treasury market RF does not significantly outperform, slightly underperforming on median predictions and improving only in the upper tail at three to five month horizons, with intervals that cross zero throughout. <font color="#ffc000">The gain is therefore conditional on the market, and the market where it fails is the one with the deepest book and the most intermediary structure in its inputs.</font>

  ![[Pasted image 20261004180003.png]]
- **Attribution is dominated by the indicator's own lag in all three markets, with the other markets' indicators ranking high, which the authors read as self-reinforcing illiquidity plus spillover.** For the money market, current MCI(MM) is the top feature by a wide margin and MCI(FX) ranks eleventh; for FX, MCI(FX) ranks second and MCI(TR) third; for Treasury, MCI(TR) is first. The reading offered is that stress is self-reinforcing within a market and transmits across markets that are distinct but intertwined through market-making and collateral. That reading is consistent with the attribution but is not separately tested, there is no spillover identification here and no decomposition of own-lag persistence into anything finer.

  ![[Pasted image 20261004180004.png]]
- **Which predictor families matter is market-specific, and the split is the most portable finding in the paper.** The top five by mean absolute Shapley value:

  | Rank | Money market | FX | Treasury |
  | --- | --- | --- | --- |
  | 1 | MCI (MM) | IV EUR 3m | MCI (TR) |
  | 2 | Fed Treasury purchases (6ma) | MCI (FX) | Sentiment (6ma) |
  | 3 | 3m bill issuance | MCI (TR) | Sentiment |
  | 4 | Global financial cycle index | Sentiment (6ma) | Swap 3m2y |
  | 5 | Treasury General Account | IV GBP 3m | CP issuance |

  Money market tails are predicted by funding and official-sector supply, lower Fed purchases and lower bill issuance and lower TGA balances predicting tighter conditions ahead, together with the global financial cycle. FX tails are predicted overwhelmingly by risk perception, implied volatility on EUR and GBP and intra-family equity flows, with funding and market-making variables present but lower. The authors' summary, that investor overextension in seemingly calm and low-volatility periods often sows the seeds for subsequent market stress, is the right shape of claim for a Shapley plot, directional and conditional rather than causal.

#### Limitations

- **The headline comparison is partly regularised against unregularised, not machine learning against linear.** The multivariate benchmark is an unpenalised quantile regression fitting 44 coefficients on 84 observations, which is nearly saturated and would be expected to overfit catastrophically whatever the data-generating process looks like. <font color="#ff0000">A penalised quantile regression, lasso or elastic net, is the benchmark that would separate "trees capture non-linearities" from "the linear model had no shrinkage", and it is absent.</font> The result that survives cleanly is the narrower and still useful one, that the forest beats a one-lag AR in two markets, and I read the in-sample versus out-of-sample reversal as evidence about the benchmark's specification rather than about linearity.
- **There is no economic evaluation of any kind, on a paper whose stated purpose is real-time vulnerability monitoring.** Quantile loss is the only metric. No decision rule, no threshold, no cost of a false alarm against a missed episode, no comparison against a policymaker's existing FSI on the same test windows, no statement of how much of the 27% loss improvement is concentrated in the two crisis episodes that dominate the sample. With roughly 240 monthly observations containing two large stress events, a model that gets those two periods slightly better will post a materially lower average quantile loss while being no more useful in the other 220 months, and nothing in the paper rules that out.
- **The look-ahead discipline covers aggregation but not variable selection, and the input set is not stable over the sample.** The PCA is rolling, which is the right call and done well, but which variables enter each market's index was decided once with the full 2003 to 2024 sample in view, including knowledge of which spreads blew out in which crisis. The inputs also change composition mid-sample, Treasury quoted spreads being measured one way before 2008 and another after, time-to-quote being Tradeweb-dependent, and LIBOR-based money market inputs spanning the period in which LIBOR was discontinued. None of this is addressed and it means the index is not quite the same object at both ends of the sample.
- **The modelling details that would let anyone reproduce the ML result are missing.** No forest hyperparameters, no tuning protocol, no seed or ensemble treatment, no report of whether the forest is refit at every rolling window or periodically, and the XGBoost robustness check appears only as an assertion that performance is comparable at higher computational cost. Combined with the unstated interval construction noted above, the random forest is effectively a black box in a paper whose second contribution is opening black boxes.
- **Shapley results are presented for the Treasury market where the forecasting model does not beat the benchmark.** The authors do caveat it, saying the Treasury results should be interpreted with caution since out-of-sample performance is not significantly better than the AR, and they are right to, but the plot is still there at the same size as the other two and will be cited. The general issue is sharper than this one instance: SHAP explains what the model does, not what the market does, so attributions from a model with no demonstrated out-of-sample edge are describing a fitted artefact.
- **Everything is market-level, monthly and US, which bounds how far any of it transfers.** The inputs exist because these are the deepest markets in the world, cross-currency bases, repo-OIS, on-the-run premia, failed deliveries, dealer coupon holdings. The construction method is portable, this particular input set is not, and the paper makes no claim about frontier or thinly traded markets.

#### Why this matters for my project

- **Take the rolling-window PCA as the construction recipe for $L_t$, and build it from what the CSE actually prints.** The method is the transferable part: sign every input so higher means worse, z-score, take the first principal component over an expanding window starting from a three-year block, re-normalise. The CSE analogues of their input families are Amihud illiquidity, turnover ratio, zero-return frequency, quoted spread where the book is visible, and Parkinson or Garman-Klass range volatility, which is the estimator already pinned for $V_t$ since five-minute realised volatility is unavailable here. <font color="#ffc000">That converts the liquidity state from a single Amihud number into a composite with the same construction discipline as a published central bank indicator</font>, and it costs nothing I am not already computing for the cost model.
- **Adopt their look-ahead test as a standing check, because it is cheap and it is the one I am most likely to get wrong.** Running the full-sample PCA alongside the rolling one and plotting both is a half-day of work that produces direct evidence of how much look-ahead bias a naive construction would have injected. The same check generalises to every fitted transform in my pipeline, which is the same question I ended up asking of decomposition boundaries in [[Extending machine learning prediction capabilities by explainable AI in financial time series prediction]], and it belongs in the methodology chapter rather than in a footnote.
- **The parsimony result is a direct warning about my conditioning set and I should pre-register the response.** Eighty-four observations and 44 predictors produced a model that beat its benchmark in-sample everywhere and lost out-of-sample everywhere, at monthly frequency on the deepest markets in the world. My orchestrator conditions on four state variables plus a per-agent confidence term, which is far smaller, but the training sample is roughly 374 trading days per counter and the temptation to widen the state vector as reviews suggest additions is exactly the pressure that produced their Figure 3. The concrete commitment is that any proposed addition to $f(L_t, V_t, P_t, C_{i,t})$ has to beat the existing set out-of-sample on the ablation protocol, not in-sample, and the static learned-weight baseline stays in as the shrinkage-equivalent control.
- **Condition on a forecast tail of the state rather than its current level, and say which horizon.** Their framing is that the useful question is the 90th percentile of stress three months out, not the expected level, and that transfers cleanly: an orchestrator that down-weights $A_T$ when liquidity is already bad is reacting, one that down-weights it when the upper tail of the liquidity state is forecast to widen is anticipating. The horizon mismatch is the hard part, their three to twelve months is a policy horizon and mine is days to a few weeks, so the honest version is to test a short-horizon quantile forecast of $L_t$ on CSE data and report whether it beats the contemporaneous value as a conditioning input, as a named experiment rather than an assumed improvement.
- **Treat the Treasury null as the scoping test, and read the own-lag dominance as persistence rather than as long memory.** The market where the forest failed to beat a one-lag AR is the one whose state is least predictable from anything other than itself, so the check that comes before the agent build is whether the CSE liquidity state is AR-dominated: if a quantile AR(1) on $L_t$ is as good as anything richer, the orchestrator conditions on the lag and the state-forecasting machinery is dead weight. The same result read the other way is independent large-sample support for $P_t$ having something to measure, since the current MCI is the top feature for its own three-month tail in all three markets, but it does not distinguish hyperbolic from exponential decay and estimates nothing like $d$, so [[Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange]] stays the only local evidence on the shape.
- **SHAP over the risk and liquidity features is now the published precedent for the re-scoped attribution plan, and TreeSHAP's cost profile is why it is the right choice here.** The explainability component is attribution over risk features, RAG citation tracing, interpretable FIGARCH and GJR-GARCH parameters, and the orchestrator's weight vector, and this paper is a central-bank-grade instance of the first of those on a tree model. The transferable discipline alongside it is the caveat they half-apply: attribution is only reported for components whose out-of-sample performance clears the benchmark, so no SHAP plot for an agent that has not beaten its own baseline.
- **The cross-market spillover finding suggests a cross-sectional analogue worth testing before the state vector is frozen.** Each market's MCI helps predict the others', which on the CSE has no multi-market equivalent since there is one exchange, but does have a cross-counter one: sector-level or market-wide liquidity state predicting an individual counter's, the structure the graph approach in [[Forecasting realized volatility with spillover effects, Perspectives from graph neural networks]] formalises. The scope rules keep the conditioning set open, so this goes in as a candidate, a market-wide $L_t$ alongside the counter-level one, to be tested on the ablation protocol rather than adopted.
- **Demand the economic evaluation this paper does not give, since the same omission would be fatal in mine.** A better quantile loss on a state variable is not a better decision, and with two dominant crises in the sample it is not even clearly a better forecast in normal conditions. My equivalent trap is an orchestrator whose weights move impressively in the two or three most volatile CSE months and are inert the rest of the time, so the evaluation has to report weight variation and return against the equal-weight and static-learned baselines over quiet sub-periods separately, not only pooled, and with friction charged either way.

%% end review %%

---

> [!info]- Raw annotations from Zotero
> Working material, not part of the review. Re-run the import to pull in new highlights. Delete this block once the review is written.

%% begin annotations %%

%% end annotations %%

---

Aldasoro, I. et al. (2025). Predicting financial market stress with machine learning. Available from [https://www.bis.org/publications/working-paper-1250-predicting-financial-market-stress-machine-learning](https://www.bis.org/publications/working-paper-1250-predicting-financial-market-stress-machine-learning) [Accessed 21 September 2026].


%% Import Date: 2026-10-04T17:24:24.357+05:30 %%
