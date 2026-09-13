Uses an ARMA-FIGARCH model to test long-term volatility memory in the Colombo Stock Exchange, comparing the ASPI and S&P SL20 across three economic regimes (normal, COVID-19, economic crisis) using daily data from January 2012 to April 2024.

Core motivation: volatility clustering and long memory are well documented in developed markets, but frontier markets like Sri Lanka rarely get the advanced econometric treatment. Standard GARCH models capture short-run clustering fine but assume shocks decay exponentially, when in reality financial time series often show hyperbolic decay, shocks that fade slowly and linger for a long time (Baillie, 1996). The paper's angle is that CSE's dual-index structure (ASPI as the broad market, S&P SL20 as the top 20 liquid blue-chip stocks) plus its exposure to two back-to-back systemic shocks, COVID-19 followed straight into an economic/forex crisis, makes it an unusually good natural experiment for testing whether volatility memory holds up under compounded stress.

#### Gap it's addressing

- Long-memory volatility modeling is mature in developed and BRICS markets, but frontier markets with thin liquidity, restricted capital access, and a retail-dominated investor base are underexplored, and Sri Lanka specifically has had almost no FIGARCH-based work done on it.
- Most CSE volatility studies (Morawakage and Nimal, 2016; Sujenthini and Wijesinghe, 2022; Withanage and Jayasinghe, 2017) use plain GARCH or GARCH variants, which handle clustering but not long-run persistence or structural breaks.
- Nobody had compared how a broad-market index and a blue-chip index respond differently to the same systemic shocks within a single frontier market. Single-index studies miss this segmentation entirely.
- No prior study looked at two sequential, back-to-back systemic crises in a frontier market. Earlier papers analyze one crisis at a time, so how volatility persistence behaves under compounded/consecutive shocks was still an open question.

#### Data and setup

Daily closing prices for ASPI and S&P SL20 (SNP20) from the CSE, January 4, 2012 to April 30, 2024. The full sample is split into three periods based on documented economic events rather than arbitrary cutoffs:

- **Normal**: Jan 2012 to Dec 2019 (baseline/reference period)
- **COVID-19**: Jan 2020 to Dec 2021 (from just before Sri Lanka's first confirmed case through the pandemic disruption)
- **Economic crisis**: Jan 2022 to Apr 2024 (fuel/gas/milk powder shortages, forex crisis)

Returns are computed as log differences of the price index. ADF confirms stationarity of returns across all specifications. The model itself is built in two stages:

- **Mean equation**: ARMA(1,1) captures autocorrelation in returns before the variance equation is modeled, chosen over higher-order specifications on AIC/BIC grounds.
- **Variance equation**: FIGARCH(1,d,1), which extends GARCH by adding a fractional differencing term (1-B)^d to the variance equation. This is what lets the model capture hyperbolic (slow) decay of shocks instead of the exponential decay GARCH assumes, so short-term clustering and long-term persistence are captured in the same framework instead of needing separate models for each.

Parameters are estimated via ML under the normal distribution assumption, using the BFGS-Marquardt optimization approach, run separately for each period and each index.

#### Findings

- ASPI shows extensive volatility clustering and long-memory persistence in every period, including after COVID-19 subsided. The fractional differencing parameter stays significant across all three regimes, meaning shocks to the broader market don't just cluster short-term, they leave a lasting imprint on future volatility.
- S&P SL20 also clusters significantly during COVID-19, but its long-memory effects are weaker than ASPI's throughout. The blue-chip, top-20 index is comparatively better insulated.
- Volatility shocks have lasting impacts on the market overall, but ASPI is considerably more susceptible to economic fluctuations than S&P SL20. This is read as a liquidity/composition effect: ASPI includes illiquid stocks and small caps that react and stay disturbed longer, while SL20's more liquid, closely watched constituents absorb shocks faster.
- The dual-index comparison is the paper's real contribution here. Testing only ASPI or only SL20 would have hidden this segmentation effect entirely, broad-market and blue-chip volatility dynamics genuinely diverge under the same shock.
- Practically, the persistence findings argue for long-term-memory-aware risk management and portfolio optimization approaches on CSE rather than short-horizon GARCH-style models, since ignoring the long-memory component understates how long a shock's effects on volatility actually last.

#### Limitations

- The FIGARCH specification is estimated under a normal distributional assumption. Financial returns are typically fat-tailed, so a Student-t or skewed-t error distribution might change parameter estimates, though the paper doesn't test this as a robustness check.
- Period boundaries are chosen from documented public events (COVID case confirmation dates, reported shortage timelines) rather than statistically detected breakpoints, and while the authors say sensitivity analysis with alternative cutoffs held up, this is still a judgment call baked into the results.
- Only ARMA-FIGARCH is tested as the volatility model. EGARCH and TGARCH are mentioned as alternatives capable of capturing asymmetric/leverage effects, but they aren't run head-to-head against FIGARCH in this paper, so it's not clear how much of the persistence story is specific to the FIGARCH functional form.
- The study is descriptive/comparative rather than predictive, it characterizes how volatility behaved historically across regimes, but doesn't build or test a forecasting model using these long-memory estimates.

#### Why this matters for my project

- This is direct evidence that CSE volatility is not a clean, well-behaved process, it has genuine long-memory characteristics that persist even after a shock has technically passed. Any model I build on CSE data (whether that's a sentiment-return model or a prediction framework) needs to account for the fact that past volatility keeps influencing the market longer than a short-horizon window would suggest.
- The ASPI vs S&P SL20 divergence is a useful reminder, in the same way the market liquidity paper's small-cap vs large-cap split was, that CSE doesn't behave uniformly across index composition. If I'm testing anything at the index level, I should be wary of using ASPI alone as "the market" without checking whether the blue-chip subset tells a different story.
- The three-regime framing (normal / COVID-19 / crisis) is a clean template for splitting my own CSE data by economic period rather than treating the full sample as one homogeneous series, especially since I'm also working across a period that includes COVID-19 and Sri Lanka's economic crisis.
- Confirms that GARCH-family models are the standard toolkit for CSE volatility work, but that plain GARCH specifically undersells the persistence, this is useful context if volatility (rather than just return direction) ends up being a feature or a robustness check anywhere in my own modeling.
