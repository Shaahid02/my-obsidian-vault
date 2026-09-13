Behavioural finance paper testing whether market-wide liquidity and investor sentiment (proxied by turnover) can predict short-term expected returns on the Colombo Stock Exchange (CSE), using monthly data from 2010 to 2021.

Core motivation: traditional finance treats liquidity as just a transaction-cost story, wider spreads and higher price impact mean investors demand a return premium. But Baker and Stein (2004) and Baker and Wurgler (2006) argue transaction costs alone can't explain how strongly liquidity predicts returns over time. The behavioural explanation is that liquidity itself is partly driven by investor sentiment: overconfident, irrational investors under short-sale constraints underreact to market signals, which lowers the price impact of trades and pushes liquidity up. So liquidity swings become a readable proxy for sentiment swings.

#### Gap it's addressing

- Liquidity as a priced risk factor is well studied cross-sectionally (Amihud and Mendelson, Pastor and Stambaugh, Acharya and Pedersen), but the time-series side, why liquidity itself varies over time, is much less explored.
- Almost all of this work is done on the US and other developed/emerging markets. Frontier markets like Sri Lanka barely feature, despite frontier markets being exactly where low transparency and thin, undiversified equity lists should make sentiment-driven liquidity matter more.
- Sentiment measurement research is dominated by survey indices and composite indices (Baker and Wurgler's sentiment index), which are expensive to build and rarely available for smaller markets. Turnover as a sentiment proxy (Baker and Stein, 2004) is cheap and available, but it hasn't really been tested as the sole sentiment indicator against expected returns in a frontier market context.

#### Data and setup

296 CSE-listed firms, January 2010 to December 2021 (142 months), OLS time-series regression. Outliers (top/bottom 1% of estimated illiquidity) dropped following Amihud (2002). Risk-free rate from 91-day T-bill auction rates.

Two liquidity/sentiment proxies are built at the market level, each in both equal-weighted and value-weighted form:

- **Amihud illiquidity (ILLIQ)**: average ratio of daily absolute return to rupee trading volume, aggregated monthly. Split into *expected* illiquidity (forecast from an AR(1) model using the prior month's illiquidity) and *unexpected* illiquidity (the residual, i.e. the surprise component).
- **Turnover**: rupee trade volume divided by market value, averaged monthly, used as the sentiment proxy per Baker and Stein (2004).

Two secondary sentiment/control variables are added in the full model: the advance-decline ratio (number of advancing vs declining stocks, a technical sentiment measure) and dividend yield (control for general valuation level, following Baker and Stein).

#### Hypotheses

1. Ex-ante excess market returns increase with expected illiquidity (the illiquidity risk premium story).
2. Contemporaneous excess returns fall when illiquidity is unexpectedly high (illiquidity shocks hurt prices in the same period).
3. The illiquidity effect is stronger for small-cap stocks than large-cap (small stocks carry more illiquidity risk).
4. Excess returns rise with the advance-decline ratio.
5. Excess returns fall with turnover (this is the Baker and Stein direction, high turnover signals overvaluation by overconfident investors, so returns should be lower going forward).

#### Findings

This is the part that's actually interesting for a frontier market, because CSE doesn't behave like the US in a couple of places:

- **Expected illiquidity and returns are negatively related**, not positively, in both equal- and value-weighted specifications (significant only for value-weighted, coefficient around -0.027, p = 0.024). This flips Amihud's (2002) original US finding, where higher expected illiquidity means investors demand higher future returns. The paper's read is that CSE large-cap stocks aren't sensitive enough to illiquidity to command a premium, they're liquid enough to exit cheaply regardless. Stereńczak et al. (2020) found the same kind of null/negative illiquidity premium across most frontier markets they tested, so this isn't a one-off result for Sri Lanka.
- **Unexpected illiquidity and contemporaneous returns are negatively related**, as expected and consistent with Amihud (2002). Unexpected illiquidity shocks depress returns in the same month, coefficient around -0.084 to -0.097, highly significant. This held up better than the expected-illiquidity result, and the paper suggests it fits with CSE investors trading reactively (buying winners, selling losers) rather than forecasting illiquidity ahead of time.
- **Small-cap portfolios are more exposed to unexpected illiquidity than large-cap** (-0.071 vs -0.060), confirming H3. Straightforward size-based liquidity risk, consistent with prior literature.
- **Turnover is positively related to future returns**, the opposite of what Baker and Stein (2004) predict, and the opposite of H5. Coefficient 0.007 (equal-weighted) to 0.017 (value-weighted), both significant. The paper leans on the high-volume return premium literature (Ying, 1966; Gervais et al., 2001) instead: high turnover signals more visibility and investor interest in a stock, which pushes demand and price up over the following month, rather than signalling overvaluation that reverses. Several emerging-market studies found the same positive direction (Jun et al., 2003; Dey, 2005; Urooj et al., 2019; Anusakumar et al., 2017), so this looks like a broader emerging/frontier market pattern rather than something CSE-specific.
- **Advance-decline ratio** is positively related to returns on its own, but the effect disappears once turnover and illiquidity are added together in the multivariate model, so it isn't adding independent explanatory power once the other two are in.
- **Dividend yield** has no significant predictive power at the 1-month horizon, consistent with Samarakoon (1999) on the CSE specifically.

#### Why this reversal on turnover matters

Baker and Stein's model assumes overconfident investors trade too much and push prices too high, so high turnover should predict a correction. The CSE result says the opposite is happening: turnover behaves like a demand/attention signal rather than an overvaluation signal. The paper attributes this to country-specific heterogeneity in how sentiment operates (citing Schmeling, 2009, and Baker et al., 2012, on the same point), which basically means the direction of the sentiment-return relationship isn't a universal constant, it depends on the market's investor base, regulatory maturity, and level of herd behaviour. That's the main empirical takeaway to carry forward: a sentiment proxy validated on the US market can't be assumed to point the same direction elsewhere.

#### Limitations

- Turnover is used as the sole sentiment proxy in the core model. It's cheap and available, but it's still a liquidity-based proxy standing in for sentiment, not a direct measure of investor mood (no survey data, no text-based sentiment).
- The negative illiquidity premium result is flagged by the authors themselves as needing more explanation, they note it but don't have a strong causal story for why large-cap CSE investors don't demand a premium.
- Only a 1-month-ahead horizon is tested. No look at whether these relationships hold or decay over longer horizons.
- OLS time-series regression on monthly aggregates, so this is a market-wide, not stock-level, sentiment-return relationship.

#### Why this matters for my project

This is the closest empirical anchor I have for the CSE side of my project. A few things carry over directly:

- It confirms that a sentiment proxy's relationship with returns is not something you can assume transfers from the US/developed-market literature to Sri Lanka, the turnover-return sign flips here. That's a strong argument for why a Sri Lanka specific sentiment model (rather than reusing a US-trained sentiment-return assumption) is necessary in my own work.
- Turnover and Amihud illiquidity are both cheap, price/volume-derived proxies that don't need text data. That's a useful benchmark or control variable to sit alongside a text-based sentiment signal (news/social sentiment via the Sinhala/English sentiment models I'm using elsewhere), since this paper shows liquidity alone already carries real predictive signal on the CSE.
- The small-cap vs large-cap illiquidity sensitivity split is a good reminder that any predictive model I build should probably be tested across market-cap tiers rather than only on the aggregate index, since the CSE clearly doesn't behave uniformly across firm size.
- Method-wise, the expected/unexpected illiquidity decomposition (AR(1) forecast plus residual) is a clean, reusable way to separate "priced-in" liquidity conditions from liquidity shocks, which could be adapted as a feature engineering step rather than just using raw liquidity as an input.
