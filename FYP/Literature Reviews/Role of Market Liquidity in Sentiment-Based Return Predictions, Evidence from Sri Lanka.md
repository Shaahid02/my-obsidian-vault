---
citekey: "dissnayakeRoleMarketLiquidity2025"
title: ""
authors: ""
year: 2025
venue: ""
doi: ""
zotero: ""
stream: sentiment
market: CSE
data_period: 2010-2021
method: [liquidity-proxies, predictive-regression]
role: local-context
has_oos:
reproducible:
status: skeleton
validated:
tags:
  - literature-review
---
Behavioural finance paper testing whether market-wide liquidity and investor sentiment (proxied mainly by turnover, with the advance-decline ratio as a secondary proxy) can predict short-term expected returns on the Colombo Stock Exchange (CSE), using monthly data from 2010 to 2021.

Core motivation: traditional finance treats liquidity as just a transaction-cost story, wider spreads and higher price impact mean investors demand a return premium. But Baker and Stein (2004) and Baker and Wurgler (2006) argue transaction costs alone can't explain how strongly liquidity predicts returns over time. The behavioural explanation is that liquidity itself is partly driven by investor sentiment: overconfident, irrational investors under short-sale constraints underreact to market signals, which lowers the price impact of trades and pushes liquidity up. So liquidity swings become a readable proxy for sentiment swings.

The theory underneath this comes from the noise trader literature. Kyle's (1985) model shows how noise traders affect prices and liquidity, and De Long et al. (1990) argue that higher sentiment means more noise trading. Put together, higher sentiment leads to more noise trading and more liquidity (Liu, 2015). The paper also points to overconfidence (Statman et al., 2006) as a reason investors trade on biases rather than fundamentals.

#### Gap it's addressing

- Liquidity as a priced risk factor is well studied cross-sectionally (Amihud and Mendelson, Pastor and Stambaugh, Acharya and Pedersen), but the time-series side, why liquidity itself varies over time, is much less explored.
- Almost all of this work is done on the US and other developed/emerging markets. Frontier markets like Sri Lanka barely feature, despite frontier markets being exactly where low transparency and limited diversity in listed equities should make sentiment-driven liquidity matter more.
- Most sentiment measurement research focuses on the US and other developed and emerging markets (Pandey and Sehgal, 2019), mostly using survey-based or composite indices (Brown and Cliff, 2005; Baker and Wurgler, 2006). Turnover is a readily available sentiment proxy for frontier markets, and earlier conditional asset pricing work (Ho and Hung, 2009; Dash, 2016) didn't focus on turnover as the sole sentiment indicator or on its time-series effect on expected returns.

#### Data and setup

All 296 firms listed on the CSE as of 31 December 2021, covering January 2010 to December 2021 (142 months, so the number of firms in any given month moves around with listings and delistings). OLS time-series regression. Outliers (top/bottom 1% of estimated illiquidity) dropped following Amihud (2002). Market data from the CSE and DataStream, risk-free rate from 91-day T-bill auction rates (Central Bank of Sri Lanka).

Two liquidity/sentiment proxies are built at the market level, each in both equal-weighted and value-weighted form:

- **Amihud illiquidity (ILLIQ)**: ratio of daily absolute return to rupee trading volume, averaged within the month for each stock, then aggregated to the market and log-transformed.

$$ILLIQ^i_{md} = \frac{|R^i_{md}|}{VOL^i_{md}} \qquad AILLIQ^i_m = \frac{1}{D^i_m}\sum_{d=1}^{D^i_m}\frac{|R^i_{md}|}{VOL^i_{md}}$$

where $R^i_{md}$ is stock $i$'s log return on day $d$ of month $m$, $VOL^i_{md}$ is rupee volume (price × shares traded), and $D^i_m$ is the number of trading days. Equal-weighted market illiquidity (MILLIQ1) is the cross-sectional average, value-weighted (MILLIQ2) weights each stock by its share of total market cap.

- **Expected vs unexpected illiquidity**: split using an AR(1) model, following Amihud (2002). Investors are assumed to forecast next month's illiquidity from this month's.

$$\ln MILLIQ_m = c_0 + c_1 \ln MILLIQ_{m-1} + v_m$$

$$\ln MILLIQ^E_m = c_0 + c_1 \ln MILLIQ_{m-1} \qquad \ln MILLIQ^U_m = v_m$$

Estimated models (Tables 1 and 2), illiquidity is very persistent:

| Specification | $c_0$ | $c_1$ | $R^2$ |
|---|---|---|---|
| Equal-weighted | -1.2546 | 0.9061 | 0.820 |
| Value-weighted | -1.4621 | 0.9032 | 0.817 |

- **Turnover**: daily rupee trade volume divided by market value (following Baker et al., 2012), averaged monthly per stock, then aggregated equal- or value-weighted. This is the main sentiment proxy, per Baker and Stein (2004).

Two more variables go into the full model: the **advance-decline ratio** (number of advancing stocks divided by number of declining stocks each month, following Brown and Cliff, 2004), which is a second sentiment proxy, and **dividend yield** as a control for general valuation level (following Baker and Stein).

**Stationarity**: ADF tests were run on all variables. Expected illiquidity, turnover, and dividend yield were only stationary at first differences, so the Table 3 and Table 5 regressions use *monthly changes* in these series rather than levels (the Table 4 note says expected illiquidity is I(1) but doesn't explicitly say it was differenced for the size portfolios). This matters for reading the results: the turnover coefficient is really about a change in turnover last month, not the turnover level.

#### Models and hypotheses

Illiquidity model (tests H1 and H2):

$$(RM - Rf)_m = g + h \ln MILLIQ^E_m + j \ln MILLIQ^U_m + w_m$$

Size-portfolio version (tests H3), run separately for large-, mid-, and small-cap tertiles formed on average monthly market cap:

$$(RSZ_p - Rf)_m = g^p + h^p \ln MILLIQ^E_m + j^p \ln MILLIQ^U_m + w_{pm}$$

Full sentiment model (tests H4 and H5), with univariate versions run by setting subsets of coefficients to zero:

$$(RM - r_f)_m = a + b \ln Turnover_{m-1} + c \ln\frac{ADV}{DEC}_{m-1} + d \ln MILLIQ^E_m + e \ln MILLIQ^U_m + k\, DIVY_{m-1} + \mu_m$$

1. Ex-ante excess market returns increase with expected illiquidity (the illiquidity risk premium story).
2. Contemporaneous excess returns fall when illiquidity is unexpectedly high (illiquidity shocks hurt prices in the same period).
3. The illiquidity effect is stronger for smaller, illiquid stocks.
4. Excess returns rise with the advance-decline ratio.
5. Excess returns fall with turnover (this is the Baker and Stein direction, high turnover signals overvaluation by irrational investors under short-sale constraints, so returns should be lower going forward).

#### Findings

This is the part that's actually interesting for a frontier market, because CSE doesn't behave like the US in a couple of places:

- **Expected illiquidity and returns are negatively related**, not positively. In the illiquidity-only model it's -0.023 (p = 0.112) equal-weighted and -0.027 (p = 0.024) value-weighted, so only significant value-weighted. In the full model it's significant in both (-0.032, p = 0.030 and -0.031, p = 0.049). H1 is rejected. This flips Amihud's (2002) US finding, where higher expected illiquidity means investors demand higher future returns. The paper's read is that CSE large-cap stocks aren't sensitive enough to illiquidity to command a premium, they can be traded quickly with little price impact. Stereńczak et al. (2020) found something similar across 22 frontier markets: only Jordan and Lebanon showed a significantly positive illiquidity payoff, the rest were insignificant, and Sri Lanka was actually negative at the 10% level. Their explanation is that in markets not fully integrated into the global economy, the diversification benefit of holding those equities outweighs the illiquidity cost, so the usual illiquidity premium shrinks or disappears. Yaakoubi (2024) also found no significant expected-illiquidity effect for an equal-weighted NYSE portfolio.
- **Unexpected illiquidity and contemporaneous returns are negatively related**, as expected and consistent with Amihud (2002), so H2 is accepted. Coefficient -0.084 (EW) and -0.097 (VW) in the illiquidity-only model, -0.094 and -0.102 in the full model, all highly significant. This held up better than the expected-illiquidity result, and the paper suggests it fits with CSE investors trading reactively (buying winners, selling losers, Chu et al., 2016) rather than forecasting illiquidity ahead of time.
- **Size portfolios (Table 4) aren't a clean small-vs-large story.** Unexpected illiquidity coefficients are -0.060 (large), -0.089 (mid), -0.071 (small), all significant. Small caps are more sensitive than large caps, which is what the authors use to accept H3, but mid caps are actually the most sensitive, so the pattern isn't monotonic across size. The paper only compares large vs small and doesn't formally test whether the coefficients differ, so "H3 confirmed" is weaker than it sounds. Expected illiquidity is only significant for the large-cap portfolio (-0.030, p = 0.017), not for mid (p = 0.233) or small caps (p = 0.442). That lines up with the value-weighted model being the one where expected illiquidity matters, so the negative expected-illiquidity effect seems to sit mainly in large caps. The authors suggest investors may see large companies as less risky and accept lower returns on them, but flag that this needs more study.
- **Turnover changes are positively related to next-month returns**, the opposite of what Baker and Stein (2004) predict, so H5 is rejected. In the full model the coefficient is 0.007 (EW, p = 0.024) and 0.017 (VW, p = 0.004). On its own, value-weighted turnover is 0.022 (p = 0.006), but equal-weighted turnover is only 0.008 (p = 0.066), so significant at 10% only. The paper leans on the high-volume return premium literature (Ying, 1966; Gervais et al., 2001) instead: high trading activity makes a stock more visible, which pushes demand and price up over the following month, rather than signalling overvaluation that reverses. Several emerging-market studies found the same positive direction (Jun et al., 2003; Dey, 2005; Anusakumar et al., 2017 for India, South Korea and Taiwan; Urooj et al., 2019 for Pakistan, explained as overconfidence), so the CSE result is in line with other emerging markets, but the paper still frames the sign as market-dependent rather than universal.
- **Advance-decline ratio** is positively related to returns on its own (0.012, p = 0.026 EW; 0.013, p = 0.001 VW), in line with Zaremba et al. (2021) and Dash and Maitra (2018). But it becomes insignificant in the full model with turnover and illiquidity, similar to Brown and Cliff (2004), so it isn't adding independent explanatory power once the other variables are in.
- **Dividend yield** has no significant predictive power at the 1-month horizon (-0.017, p = 0.756 EW; -0.018, p = 0.636 VW), consistent with Samarakoon (1999) on the CSE. The authors' reading is that short-term sentiment and liquidity conditions matter more than fundamentals like dividends over a one-month window.

**Explanatory power, and where it actually comes from.** The full model reaches $R^2$ = 0.418 (adj 0.397) value-weighted and 0.251 (adj 0.223) equal-weighted. But looking across tables:

| Model | EW $R^2$ | VW $R^2$ |
|---|---|---|
| Turnover only | 0.024 | 0.083 |
| Advance-decline only | 0.035 | 0.062 |
| Illiquidity only (Table 3) | 0.226 | 0.362 |
| Full model | 0.251 | 0.418 |

So most of the fit comes from the illiquidity terms, especially unexpected illiquidity, which is measured in the same month as the return. That term explains returns contemporaneously but can't be used to predict them in advance. The lagged sentiment variables plus dividend yield only add around 2.5 (EW) to 5.6 (VW) percentage points on top of illiquidity. The sentiment effect is statistically significant but small in terms of how much return variation it actually forecasts.

#### Why this reversal on turnover matters

Baker and Stein's model assumes irrational, overconfident investors under short-sale constraints dominate when liquidity is high, so high turnover marks overvaluation and should predict a correction. The CSE result says the opposite is happening: turnover behaves like a demand/attention signal rather than an overvaluation signal. The paper attributes this to country-specific heterogeneity in how sentiment operates, drawing on Schmeling (2009), who found the effect of sentiment varies across countries with overconfidence, herd behaviour, the quality of regulatory institutions, and market integrity (with Baker et al., 2012 also showing sentiment works differently at the country level). That's the main empirical takeaway to carry forward: a sentiment proxy validated on the US market can't be assumed to point the same direction elsewhere.

#### Limitations

From the authors:

- The negative illiquidity premium on the CSE is flagged as needing further investigation, along with the large-cap "investors accept lower returns" explanation, which they say needs more study.
- They call for future work on the long-term effects of sentiment on returns, since only a 1-month-ahead horizon is tested here.

My own read:

- Turnover is the main sentiment proxy (with the advance-decline ratio as a weaker secondary one). Both are market-activity proxies standing in for sentiment, not a direct measure of investor mood (no survey data, no text-based sentiment).
- Because turnover and expected illiquidity are first-differenced, the results are really about changes, while the discussion is mostly written in level terms. Easy to over-read.
- The size-portfolio result is non-monotonic (mid caps most sensitive) and there's no formal test that the coefficients differ, so the H3 conclusion is softer than presented.
- The high $R^2$ comes mainly from contemporaneous unexpected illiquidity, so the actual out-of-sample predictive power of the sentiment variables is modest. No out-of-sample test is reported.
- OLS time-series regression on monthly aggregates, so this is a market-wide, not stock-level, sentiment-return relationship.

#### Why this matters for my project

This is the closest empirical anchor I have for the CSE side of my project. A few things carry over directly:

- It confirms that a sentiment proxy's relationship with returns is not something you can assume transfers from the US/developed-market literature to Sri Lanka, the turnover-return sign flips here. That's a strong argument for why a Sri Lanka specific sentiment model (rather than reusing a US-trained sentiment-return assumption) is necessary in my own work.
- Turnover and Amihud illiquidity are both cheap, price/volume-derived proxies that don't need text data. That's a useful benchmark or control variable to sit alongside a text-based sentiment signal (news/social sentiment via the Sinhala/English sentiment models I'm using elsewhere). But the $R^2$ breakdown is a reminder that lagged sentiment proxies on their own forecast only a small share of returns, so a text sentiment signal needs to be judged on what it adds beyond liquidity, not on in-sample fit with contemporaneous terms included.
- The size-portfolio results are a good reminder that any predictive model I build should be tested across market-cap tiers rather than only on the aggregate index, since the CSE doesn't behave uniformly across firm size, and not even in a simple small-to-large order.
- Method-wise, the expected/unexpected illiquidity decomposition (AR(1) forecast plus residual) is a clean, reusable way to separate "priced-in" liquidity conditions from liquidity shocks, which could be adapted as a feature engineering step rather than just using raw liquidity as an input. Only the expected part is usable for forecasting though, since the unexpected part is only known after the month ends.
- Stationarity matters: turnover and illiquidity series on the CSE are I(1), so any model I build on them needs differencing or similar handling first.
