Estimates long memory (self-similarity) in both returns and volatility across 45 cryptocurrency markets and 16 international equity indices, split into a pre-pandemic window and a pandemic window, using a combined ARFIMA-FIGARCH specification and comparing the resulting fractional differencing parameters across markets with t-tests and F-tests. Lahmiri and Bekiros, *Chaos, Solitons and Fractals* 151 (2021) 111221.

This sits directly beside [[Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange]] in my reading, same estimator family, same regime-split logic, far larger cross-section, and it's useful to me for two separable reasons. The design is a clean template for framing a before-and-after long-memory comparison across a cross-section of markets rather than one index at a time, which is close to what I'd want on CSE tickers. The execution is a cautionary example of how thin the evidence gets when each window is four months long and the inference is read loosely, and two of the paper's four headline conclusions don't survive a conventional reading of its own tables.

Core motivation: long memory in returns implies past price changes carry information about future ones, and long memory in volatility implies past volatility forecasts future volatility, so both matter for asset allocation and risk control. The authors' angle is that COVID-19 is a natural experiment on whether those persistence properties are stable, and that nobody had measured the parameter before and during the pandemic for digital currencies and equities side by side.

#### Gap it's addressing

- Long memory had been documented separately in the returns of stocks, commodities, cryptocurrencies and alternative investments, and separately again in their volatilities, but not estimated before and during COVID-19 as a paired comparison.
- Cryptocurrency and equity markets are usually studied in isolation, so whether the two categories share a persistence profile, and whether a common shock moves them the same way, was open.
- Most studies estimate persistence in the mean or in the variance, not both within one specification, so return memory and volatility memory get characterised on different samples and can't be compared directly.

#### Data and setup

Daily closing prices from Yahoo Finance for 61 markets, split into two non-overlapping windows chosen around the pandemic onset:

| | Window | Stated observations |
| --- | --- | --- |
| Pre-pandemic | September 2019 to December 2019 | 123 |
| Pandemic | January 2020 to April 2020 | 120 |

The cryptocurrency set is 45 coins led by Bitcoin, Ethereum, XRP, Tether, Litecoin and Binance, running down to thin names like MaidSafeCoin, Bytecoin and DigixDAO. The equity set is 16 major indices, TSX, S&P500, DAX, CAC40, BEL20, MOEX, Nikkei225, Hang Seng, SSE Composite, All Ordinaries, BSE SENSEX, KOSPI, TSEC, IBOVESPA, IPC and MERVAL. Returns are log differences, $r_t = \log(p_t) - \log(p_{t-1})$.

> [!WARNING]
> The 123 and 120 observation counts are calendar days, which works for crypto since it trades continuously, but the equity series only have trading days. The paper's own S&P500 plots show roughly 85 samples before and 72 during, so the equity estimates rest on about seventy daily observations per window.

The model is a single integrated specification, ARFIMA($p_m$, $d_m$, $q_m$)-FIGARCH($p_v$, $d_v$, $q_v$), with the mean equation carrying the return memory and the variance equation carrying the volatility memory. The mean equation applies fractional differencing to the demeaned return series before the ARMA polynomials act on it:

$$\phi(L)(1-L)^{d_m}(r_t - \mu) = \beta(L)\varepsilon_t$$

where:

- $L$ is the lag operator, $\phi(L)$ and $\beta(L)$ the AR and MA polynomials
- $d_m$ is the fractional differencing parameter for returns, the quantity the whole paper is about
- $\varepsilon_t = \eta_t \sqrt{h_t}$, so the innovation is a standardised shock scaled by conditional volatility

The variance equation applies the same fractional differencing idea to squared innovations, which is what lets shocks to volatility decay hyperbolically rather than exponentially:

$$\alpha(L)(1-L)^{d_v}\varepsilon_t^2 = \omega + (1 - \theta(L))v_t$$

where $v_t = \varepsilon_t^2 - h_t$ is the innovation to the conditional variance and $d_v$ is the volatility memory parameter. Both are constrained to $0 < d_m < 1$ and $0 < d_v < 1$.

> [!NOTE]
> The paper's stated reading of <font color="#ffc000">the fractional differencing parameter</font>: $d = 0$ is short memory, $d < 0.5$ is long memory, and $d > 0.5$ means the series is nonstationary. That third clause matters later, because most of the estimates reported here land above 0.5.

All parameters are estimated by <font color="#ffff00">quasi-maximum likelihood</font>, with the errors assumed to follow an asymmetric normal distribution:

$$LogLikelihood(\varepsilon_t, \theta) = \frac{-1}{2}\log(2\pi) - \frac{1}{2}\sum_{t=1}^{T}\left(\log(h_t) + \frac{\varepsilon_t^2}{h_t}\right)$$

The unit of analysis for the statistical tests is the cross-section of fitted $d$ values, 45 from crypto and 16 from equities per window, compared with Student's t-tests for equality of means and F-tests for equality of variances.

#### Findings

- **Return persistence rose in both categories during the pandemic window.** For cryptocurrencies the one-sided test that pre-pandemic $d$ is below pandemic $d$ comes back at 0.0049, and for equities at $1.6919 \times 10^{-5}$, with the equality tests rejected at 0.0098 and $3.3838 \times 10^{-5}$ respectively. The boxplots put the crypto median around 0.58 before and 0.62 during, and the equity median around 0.55 before and 0.72 during, so the equity shift is the larger of the two on this sample.

![[Pasted image 20260920163901.png]]

- **The volatility side moves far more than the return side, from something close to short memory to strong persistence.** Pre-pandemic, the median $d$ estimated from volatility sits near 0.02 for cryptocurrencies and near 0.05 for equities, with most of the crypto distribution bunched at zero, and during the pandemic those medians jump to roughly 0.74 and 0.81. Taken at face value this says volatility in both asset classes had almost no long memory in late 2019 and a great deal of it by April 2020, which is a much stronger claim than the paper interrogates, and one that sits awkwardly against the wider literature reporting persistent volatility memory in normal periods.

![[Pasted image 20260920163902.png]]

- **Return memory doesn't distinguish cryptocurrencies from equities in either window.** The equality tests come back at 0.9667 before and 1.0000 during, so on this evidence the two market categories carry comparable degrees of return persistence both before and through the shock. That's the cleanest result in the paper and the one least dependent on the inference problems below.

- **Two of the four headline conclusions invert the paper's own tables.** The text reads each set of one-sided tests by picking the row with the *largest* p-value as the supported claim, which reverses the usual convention. On variances, the reported values say cryptocurrency $d$ was *more* variable before the pandemic than during it at $7.6246 \times 10^{-6}$, and that the equity variance change isn't significant at all (0.3319), yet the conclusion states variability increased in both categories. On the cross-asset volatility comparison, the pandemic-window tests give 0.0386 for crypto below equities and 0.9614 for crypto above, and the boxplot medians of 0.74 against 0.81 agree with the first, yet the paper concludes cryptocurrency volatility exhibited the higher degree of persistence.

![[Pasted image 20260920163903.png]]

![[Pasted image 20260920163904.png]]

- **What survives is the direction, not the contrasts.** Read conventionally, the defensible result is that the level of persistence in both returns and volatility increased across both categories of market between late 2019 and April 2020, and that return persistence is statistically indistinguishable across the two categories. The claims about *differences* between crypto and equities, and about changes in *dispersion*, don't hold up on the numbers as printed.

#### Limitations

- **The windows are too short for the estimator.** Fractional differencing parameters are estimated with large standard errors on short samples, and seventy to a hundred and twenty observations is short by the standards of the long-memory literature, which typically works with thousands. The paper reports no standard errors or confidence intervals on any individual $d$, so there's no way to tell how much of the cross-sectional shift in means is estimation noise, and a t-test across 45 noisy point estimates treats each one as if it were measured exactly.

- **Most estimates sit outside the region the model assumes.** By the paper's own stated criterion, $d > 0.5$ means the series is nonstationary, and the majority of the reported estimates in both windows are above 0.5, several close to 1.0. No stationarity or unit-root testing is reported, and no fractional differencing is applied before estimation, so the ARFIMA-FIGARCH fits are being read in a range where the paper has itself said the specification doesn't apply.

- **Nothing here is reusable as a number.** No ARFIMA or FIGARCH orders are reported, no selection criteria, no residual diagnostics, and no per-market estimates of $d$ in any table. Everything is boxplots and p-values, so a reader can't take a single calibrated persistence value out of this paper for any of the 61 markets, which for my purposes is the difference between a citation and an input.

- **Presentation errors compound the inference problem.** The table of F-tests is captioned as applying to volatility series but is used in the text to make a claim about return series, the boxplot captions for volatility reference "Eq. (8)" in a paper containing four numbered equations, the estimates are called $d$ in the text and HE in every table without the $H = d + 0.5$ relationship ever being stated, and the listed cryptocurrency names run to 46 entries with Ethereum appearing twice against a stated count of 45. Individually these are small, collectively they make it hard to know which of the mismatches between text and tables are typos and which are substantive.

- **The design measures a crash, not a pandemic, and the cross-section is unbalanced.** The pandemic window runs January to April 2020, so it is dominated by the March 2020 selloff, and any shock of that magnitude would raise measured persistence regardless of its cause, which means COVID-19 is the label on the window rather than a tested mechanism. The 45 against 16 split also means the crypto cross-section carries almost three times the weight of the equity one in any pooled reading, and the equity set contains no frontier market at all, so nothing here speaks to how these dynamics behave in a thin, retail-dominated exchange.

#### Why this matters for my project

- The before-and-after design is worth borrowing for the CSE risk component, but the correction is obvious from the failure mode here: windows have to be long enough for the estimator to mean something. [[Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange]] splits normal, COVID-19 and economic crisis into periods of years rather than months, and that's the template I should follow if I split my own CSE sample by regime.

- The more transferable idea is the **unit of analysis**, estimating $d$ across a cross-section of markets and testing the distribution rather than reading one index. On CSE that translates to per-ticker persistence across the listed equities instead of ASPI alone, which would let me ask whether volatility memory is a market-wide property or concentrated in the illiquid tail, and the ASPI against S&P SL20 divergence in the FIGARCH paper suggests it's the latter. This depends entirely on <font color="#ff0000">CSE historical data depth</font>, which is still the unanswered question gating everything.

- Volatility persistence moving sharply under a shock while return persistence barely moves is a useful prior for how I design the risk agent. If I'm going to condition position sizing or risk limits on a memory parameter, the volatility side is where the signal appears to live, and conditioning on return persistence looks like it would buy very little.

- The minimum sample length for a usable $d$ estimate is now a parameter I need to pin down before I commit to a design, not after. If CSE price history turns out to be short, or if I want the parameter re-estimated on a rolling window inside a live system, this paper is a concrete demonstration that a four-month window produces estimates I shouldn't trust, and I'd rather find that out in the design phase.

- This is another long-memory paper that measures the parameter, tests whether it changed, and stops there, with no forecasting model, no allocation rule, and no trading evaluation built on top of the estimates. That's exactly the pattern across this whole corner of the literature, and it's the opening my project is working in, turning a measured persistence property into something a risk agent actually consumes.

- Nothing in here is calibration-ready, so it cites as motivation for why volatility persistence is regime-dependent, not as a source of numbers. The FIGARCH estimates I actually need for the risk agent still have to come out of the Riyath paper's tables.

- On my own reporting discipline, the inverted p-value readings are a cheap lesson: state the direction from the effect size and the figure alongside the test, so that a reader can catch a sign error without re-deriving the inference. I should report the economic magnitude and the formal test side by side in my own results for the same reason.

- Return persistence being statistically indistinguishable between cryptocurrencies and equities is a small but useful constraint on how I argue for CSE-specific modelling. If a memory parameter doesn't separate two asset classes as different as Bitcoin and the Nikkei, it isn't going to separate CSE from developed markets either, so the case for building something CSE-specific has to rest on liquidity, microstructure and the sentiment-language problem, not on the persistence parameter being unusual here.

#### Related notes

- [[Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange]], the same ARFIMA/FIGARCH machinery applied to ASPI and S&P SL20 across three regimes, and the paper I'd actually take numbers from.
- [[Sri Lankan Stock Market Volatility Analysis, An ARMA-GARCH Approach]], which finds persistence close to one on ASPI without pushing it into a long-memory framework.
