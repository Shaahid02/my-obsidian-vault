---
citekey: "mohamedriyathModelingLongtermVolatility2026"
title: "Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange"
authors: "Mohamed Riyath"
year: 2026
venue: "IIM Ranchi Journal of Management Studies"
doi: ""
zotero: ""
stream: volatility
market: CSE
data_period: 2012-2024
method: [ARMA-FIGARCH]
role: protocol-source
has_oos: false
reproducible: partial
status: complete
validated:
tags:
  - literature-review
---
Uses an ARMA-FIGARCH model to test long-term volatility memory in the Colombo Stock Exchange, comparing the ASPI and S&P SL20 across three economic regimes (normal, COVID-19, economic crisis) using daily data from January 2012 to April 2024. Mohamed Riyath, *IIM Ranchi Journal of Management Studies* 5, no. 1 (2026): 21–45.

Core motivation: volatility clustering and long memory are well documented in developed markets, but frontier markets like Sri Lanka rarely get the advanced econometric treatment. Standard GARCH models capture short-run clustering fine but assume shocks decay exponentially, when in reality financial time series often show hyperbolic decay, shocks that fade slowly and linger for a long time (Baillie, 1996). The paper's angle is that CSE's dual-index structure (ASPI as the broad market, S&P SL20 as the top 20 liquid blue-chip stocks) plus its exposure to two back-to-back systemic shocks, COVID-19 followed straight into an economic/forex crisis, makes it an unusually good natural experiment for testing whether volatility memory holds up under compounded stress.

This is the paper I would actually take <font color="#ffc000">volatility persistence</font> numbers from for the CSE risk layer, so the note below separates what the tables show from what the paper's prose claims about them, because on two points those diverge.

#### Gap it's addressing

- Long-memory volatility modeling is mature in developed and BRICS markets, but frontier markets with thin liquidity, restricted capital access, and a retail-dominated investor base are underexplored, and Sri Lanka specifically has had almost no FIGARCH-based work done on it.
- Most CSE volatility studies (Morawakage and Nimal, 2016; Sujenthini and Wijesinghe, 2022; Withanage and Jayasinghe, 2017) use plain GARCH or GARCH variants, which handle clustering but not long-run persistence or structural breaks. [[Sri Lankan Stock Market Volatility Analysis, An ARMA-GARCH Approach]] is the local precedent that finds persistence close to one on ASPI without ever pushing it into a long-memory framework, which is exactly the move this paper makes.
- Nobody had compared how a broad-market index and a blue-chip index respond differently to the same systemic shocks within a single frontier market. Single-index studies miss this segmentation entirely.
- No prior study looked at two sequential, back-to-back systemic crises in a frontier market. Earlier papers analyze one crisis at a time, so how volatility persistence behaves under compounded/consecutive shocks was still an open question.

#### Data and setup

Daily closing prices for ASPI (RASPI in returns) and S&P SL20 (SNP20, RSNP in returns) from the CSE, January 4, 2012 to April 30, 2024, 2,922 observations. The full sample is split into three periods based on documented economic events rather than arbitrary cutoffs:

| Period | Window | Observations |
| --- | --- | --- |
| Normal | Jan 2, 2012 to Dec 31, 2019 | 1,924 |
| COVID-19 | Jan 3, 2020 to Dec 31, 2021 | 302 |
| Economic crisis | Jan 4, 2022 to Apr 30, 2024 | 549 |

The COVID-19 window is the one to watch. Two calendar years should yield roughly 480 trading days, and the CSE was closed for an extended stretch from March to May 2020, which accounts for part of the shortfall but leaves 302 a thin basis for a fractional differencing estimate. The three subsamples also sum to 2,775 against a full sample of 2,922, so 147 observations sit outside any subsample, and the full sample is dated as starting January 4 while the normal subsample starts January 2, which is an internal inconsistency in the source rather than something the text explains.

Returns are computed as log differences of the price index, $R_t = \ln(P_t / P_{t-1})$. ADF rejects a unit root at the 1% level under all three specifications, with constant, with constant and trend, and with neither ($p < 0.0001$ for both indices), so the return series are stationary. The model itself is built in two stages:

- **Mean equation**: ARMA(1,1) captures autocorrelation in returns before the variance equation is modeled, chosen over higher-order specifications on AIC/BIC grounds.
- **Variance equation**: FIGARCH(1,d,1), which extends GARCH by adding a fractional differencing term to the variance equation.

The fractional differencing operator is the whole mechanism, and it is worth writing out because the decay behaviour it buys is what the rest of the paper rests on:

$$\phi(B)(1-B)^d \sigma_t^2 = \omega + \theta(B)\epsilon_t^2$$

where:

- $B$ is the backshift operator and $(1-B)^d$ the fractional differencing term
- $d$ is the fractional differencing parameter, the long-memory parameter
- $\phi(B) = 1 - \gamma B$ is the polynomial incorporating the GARCH terms
- $\theta(B) = 1 + \delta B$ is the polynomial incorporating the ARCH terms
- $\omega$ is the constant and $\sigma_t^2$ the conditional variance at time $t$

Setting $d = 0$ collapses this back to standard GARCH with exponentially decaying shock impacts, and $d = 1$ gives full integration where shocks never die. The useful range is in between, where the autocorrelation function of squared returns decays hyperbolically, slowly enough that short-term clustering and long-term persistence are captured in the same framework instead of needing separate models for each.

Parameters are estimated via ML under the normal distribution assumption, using the Broyden-Fletcher-Goldfarb-Shanno algorithm with Marquardt steps, covariances from the outer product of gradients, and a pre-sample variance backcast parameter of 0.7, run separately for each period and each index.

#### Findings

The variance equation estimates across all four panels of Table 3 are the core of the paper, and reading down the columns is what makes the regime story legible, so the grid comes first and the arguments follow from it. Coefficients with $p$-values in parentheses:

| Period | Index | ARCH | GARCH | FIGARCH $d$ |
| --- | --- | --- | --- | --- |
| Full sample | ASPI | 0.0874 (0.0184) | 0.5478 (<0.0001) | 0.6480 (<0.0001) |
| Full sample | S&P SL20 | 0.0932 (0.1217) | 0.3954 (<0.0001) | 0.4333 (<0.0001) |
| Normal | ASPI | 0.2057 (0.0534) | 0.4164 (0.0019) | 0.3758 (<0.0001) |
| Normal | S&P SL20 | 0.1425 (0.2055) | 0.3456 (0.0036) | 0.3204 (<0.0001) |
| COVID-19 | ASPI | −0.0159 (0.8787) | 0.8304 (<0.0001) | 1.1450 (<0.0001) |
| COVID-19 | S&P SL20 | 0.9463 (<0.0001) | 0.7902 (<0.0001) | 0.0099 (0.7760) |
| Economic crisis | ASPI | −0.3416 (0.1051) | 0.0587 (0.8157) | 0.5640 (<0.0001) |
| Economic crisis | S&P SL20 | −0.4366 (0.1098) | −0.1078 (0.7192) | 0.5013 (<0.0001) |

- **Long memory is the one property that survives every regime, and short-term clustering is not.** ASPI's FIGARCH $d$ is significant at $p < 0.0001$ in all three subsamples and in the full sample, but ASPI's ARCH term is only significant in the pooled full sample ($\beta = 0.0874$, $p = 0.0184$), and inside the subsamples it is marginal in the normal period ($\beta = 0.2057$, $p = 0.0534$, which the paper itself calls near-significant), insignificant during COVID-19 ($\beta = -0.0159$, $p = 0.8787$) and insignificant during the economic crisis ($\beta = -0.3416$, $p = 0.1051$). ASPI's GARCH term also goes insignificant in the crisis period ($\beta = 0.0587$, $p = 0.8157$). On this evidence the broad-market story is that crisis-era volatility is carried by long-duration memory rather than by short-horizon clustering, and a reading that has ASPI clustering throughout is not what the subsample tables support.
- **The S&P SL20 inverts that pattern during COVID-19, which is the sharpest result in the paper.** The blue-chip index shows the strongest clustering anywhere in the table ($\beta = 0.9463$, $p < 0.0001$) and strong persistence ($\beta = 0.7902$, $p < 0.0001$), while its long-memory parameter collapses to statistical insignificance ($\beta = 0.0099$, $p = 0.7760$). SL20's $d$ is numerically lower than ASPI's in every panel, so weaker long memory throughout is accurate as a description, but during the pandemic the difference stops being one of degree: pandemic-era blue-chip volatility was immediate and short-lived rather than persistent, which the paper reads as making short-term volatility management the binding concern for those names. Calling SL20 better insulated holds at the long-memory horizon and does not hold at the short one.
- **Both indices flip to negative clustering coefficients in the economic crisis while long memory stays strong.** ARCH is −0.3416 for ASPI and −0.4366 for SL20, neither significant, GARCH is insignificant for both, and yet $d$ sits at 0.5640 and 0.5013 with $p < 0.0001$. The paper's read is that crisis shocks had no clean short-lasting effect and the volatility process became erratic, with the long-memory component the only stable thing left in the specification. The progression across regimes, from balanced ARCH coefficients in the normal period to the extreme COVID-19 split to negative values in the crisis, is the paper's strongest argument that risk management parameters fitted on one regime should not be carried into another.
- **The dual-index comparison is the real contribution, and it is the part that generalises.** Testing only ASPI or only SL20 would have hidden the segmentation entirely, since the two indices do not merely differ in magnitude, they disagree about which component of volatility is doing the work during the pandemic. The paper reads this as a liquidity and composition effect, ASPI carrying illiquid small caps that react and stay disturbed longer while SL20's closely watched constituents absorb shocks faster, though that mechanism is asserted from index composition rather than tested with a liquidity variable.
- **Diagnostics support the symmetric specification on the full sample.** The ARCH LM test on residuals returns $p = 0.8788$ for ASPI and $p = 0.8019$ for SNP20, so no residual heteroskedasticity, and the Engle-Ng sign-bias test finds no significant asymmetry for either index, with joint-bias $p = 0.8185$ for ASPI and $p = 0.3145$ for SNP20 and every individual sign, negative and positive bias test above 0.13. The paper reads this as the market responding similarly to positive and negative shocks, which is an unusual result for an equity index and worth flagging as something to re-test rather than inherit.

#### Limitations

- **The ASPI COVID-19 estimate of $d = 1.1450$ sits outside the admissible parameter range and the paper does not flag it.** FIGARCH requires $0 \leq d \leq 1$, with $d = 1$ the fully integrated boundary where shocks never decay, so a point estimate above one is not a stronger long-memory reading, it is an estimate the model is not defined to produce. It is also the headline number for the regime, described in the text as the highest long memory across all periods. Combined with the 302-observation window, the most likely explanation is small-sample instability in the estimator rather than a genuine property of pandemic-era ASPI volatility, which is the same failure mode [[The effect of COVID-19 on long memory in returns and volatility of cryptocurrency and stock markets]] demonstrates with four-month windows. <font color="#ff0000">Any calibration I take from this paper should use the normal and crisis-period estimates and treat the COVID-19 figure as indicative only.</font>
- **The parameter stability results in Table 5 do not say what the surrounding text says they say.** Section 4.5 claims individual parameter stability was confirmed for ASPI and that all SNP20 individual statistics were below the 10% critical value, but the Nyblom statistics in the table contradict both: ASPI's MA(1) is 0.6902 against a 5% critical value of 0.470 and a 10% critical value of 0.353, and SNP20's mean-equation constant is 0.4259, also above 0.353. The joint result for ASPI is as described, 2.3940 against a 1% critical value of 2.350, so collective instability holds, but the clean individual-stable / jointly-unstable framing is not supported, and SNP20 is not unambiguously stable either. The substantive point, that ASPI's parameters shift across the sample, survives, the characterisation of how does not.
- **Only ARMA-FIGARCH is estimated, and the asymmetry evidence that would justify that choice is full-sample only.** EGARCH and TGARCH are named as alternatives capable of capturing leverage effects but are never run head-to-head, so how much of the persistence story is specific to the FIGARCH functional form is untested. The Engle-Ng results in Table 4 are a genuine mitigation and should be cited as one, but they are a specification check on the standardized residuals of an already-fitted symmetric model rather than a model comparison, and Section 4.4 is explicit that these diagnostics are run on the full sample. That leaves asymmetry untested inside the COVID-19 and crisis subsamples, which is precisely where leverage effects would be expected to appear, and where the ARCH and GARCH terms go insignificant or negative.
- **The FIGARCH specification is estimated under a normal distributional assumption.** Daily CSE returns here are heavily fat-tailed, with full-sample kurtosis of 35.64 for ASPI returns and 46.12 for SL20 returns against a normal benchmark of 3, and skewness of −1.76 and −2.04, so a Student-t or skewed-t error distribution is the obvious robustness check and the paper does not run it. Given how far those moments are from normality, this is more than a formality, and it compounds with the out-of-range COVID-19 estimate as a reason to treat subsample point estimates as approximate.
- **Period boundaries are chosen from documented public events rather than statistically detected breakpoints, and the study is descriptive rather than predictive.** The authors report that sensitivity analysis with adjacent-month cutoffs held up, but no structural break test is run, and the conclusion concedes that the study does not detect structural breaks in the series. More importantly for my purposes, nothing is forecast: the paper characterises how volatility behaved historically across regimes and stops at the estimates, without building or evaluating a model that consumes them.

#### Why this matters for my project

- **The persistence result is real and the regime-specific point estimates are the part to handle carefully.** Long memory in CSE volatility is supported in every subsample and on both indices, which is enough to justify a persistence-aware risk layer rather than a fixed risk parameter. What I should not do is lift $d$ values straight into a calibration, since the COVID-19 ASPI figure is inadmissible and the windows behind the subsample estimates are short. The defensible use is the normal-period pair, ASPI 0.3758 and SL20 0.3204, and the crisis pair, 0.5640 and 0.5013, as a plausible range for how fast volatility shocks decay on this market, with the full-sample 0.6480 and 0.4333 as the pooled reference.
- **Which component of volatility carries the signal changes with the regime, so a risk signal built on one component will fail in the regime where that component goes quiet.** A short-horizon clustering feature would have been informative for SL20 during COVID-19 and carried essentially nothing for ASPI in the same window, while a long-memory feature would have been the reverse for SL20. If I condition position sizing or exposure on a volatility state, that state needs both a short-horizon and a persistence component, and the weighting between them needs to be allowed to move, which is a stronger argument for a regime-aware design than the one I had from [[Stock Price Prediction Using ARIMA Model, Evidence from Colombo Stock Exchange]] alone.
- **Index-level results on CSE should not be read as market-level results.** The ASPI and SL20 divergence lands the same way the small-cap against large-cap split does in [[Role of Market Liquidity in Sentiment-Based Return Predictions, Evidence from Sri Lanka]], and it means using ASPI alone as the market in any CSE test is a choice I need to defend rather than a default. Anything I evaluate at index level gets checked against the blue-chip subset before I describe the result as a property of the market.
- **The liquidity and composition explanation is the testable version of this and nobody has tested it here.** The paper asserts that ASPI's longer-lived volatility comes from its illiquid constituents, which is plausible and unmeasured. Pairing per-ticker persistence estimates with the spread estimator from [[Efficient estimation of bid–ask spreads from open, high, low, and close prices]] would turn that assertion into a cross-sectional test of whether volatility memory concentrates in the illiquid tail, which is a genuinely open question on this market and sits close to what I am building anyway.
- **The three-regime split is the right template and the observation counts are the warning that comes with it.** Normal, COVID-19 and crisis is a clean partition for my own CSE evaluation, and reporting results per regime rather than pooling a decade of heterogeneous data is the discipline I want. What this paper demonstrates is that the split only works if each window is long enough for whatever I estimate on it, and 302 observations was not enough here, so any regime-conditioned parameter in my own system needs a minimum-window rule fixed in advance rather than discovered afterwards.
- **The symmetry finding is the one result I would not carry over without re-testing.** No significant leverage effect in an equity index runs against most of the asset pricing literature, and the test behind it is full-sample only on a specification that already assumes symmetry. If asymmetric response matters anywhere in my risk layer, and for downside exposure it usually does, I need to establish it on CSE data myself rather than inherit this paper's null.
- **Reporting discipline, same lesson as the Lahmiri note.** The two divergences between this paper's tables and its prose, the Nyblom characterisation and the unflagged out-of-range $d$, both come from reading a conclusion off a pattern rather than off the row, and both are catchable by anyone who checks the table against the claim. Quoting the component figures beside the inference in my own results is the cheapest defence against doing the same thing.
- **This is another long-memory paper that measures the parameter and stops.** No forecasting model, no allocation rule, no evaluation of what the persistence estimate is worth to anyone making a decision, which is the same shape as the rest of this corner of the literature and the opening my project works in. Turning a measured persistence property into something a risk agent actually consumes is the contribution, and the baseline it has to beat is the three-day sign test in [[FinMem, A Performance-Enhanced LLM Trading Agent With Layered Memory and Character Design]], not a strawman.

#### Related notes

- [[The effect of COVID-19 on long memory in returns and volatility of cryptocurrency and stock markets]], the same ARFIMA/FIGARCH machinery across 61 markets, and the clearest demonstration of what a too-short estimation window does to $d$.
- [[Sri Lankan Stock Market Volatility Analysis, An ARMA-GARCH Approach]], which finds persistence close to one on ASPI without the long-memory framing.
- [[Stock Price Prediction Using ARIMA Model, Evidence from Colombo Stock Exchange]], a third independent CSE reading of volatility clustering, from residual behaviour rather than from a fitted variance equation.
