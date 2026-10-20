---
date: 2026-10-20
type: dataset-profile
project: FYP — Multi-Agent Financial Decision Systems for the CSE
scope: CSE Data Library items 01 to 39, excluding the annual report corpus (A_F)
window: 2012-01-01 to 2026-06-30 unless stated
tags: [fyp, dataset, data-quality, volatility, liquidity]
---

# Data Library Profile: Items 01 to 39

Companion to [[Dataset Profile 2026-10-20]], which covered the per-security price panel. This pass covers the remaining items against what A_V, A_T and A_L need. A_F is out of scope by instruction.

Every file in this library has its own layout, and several change layout partway through their own history. Treat the loader for each item as a separate piece of work with an assertion on expected row counts, not as a generic reader.

---

## 1. A_V: index and market-state series

### Coverage

| Item | Series | Observations | Range |
|---|---|---:|---|
| 07 | All Share Price Index | 9,891 | 1985-01-02 to 2026-06-30 |
| 07 | Milanka Price Index | 7,835 | 1985-01-02 to **2023-03-31** |
| 07 | S&P Sri Lanka 20 | 3,327 | **2012-06-27** to 2026-06-30 |
| 09 | ASTRI (total return) | 5,356 | 2004-01-02 to 2026-06-30 |
| 09 | S&P SL20 TRI | 3,327 | 2012-06-27 to 2026-06-30 |
| 10 | Market PER, PBV, DY | 7,281 | 1996-01-03 to 2026-06-30 |
| 11 | ASPI, turnover, shares, trades, market cap | 7,752 | 1994-01-03 to 2026-06-30 |

Two consequences for the window. The Milanka index is discontinued from April 2023, so it cannot serve as a second market factor across the full period. S&P SL20 does not start until 2012-06-27, so the first six months of 2012 have ASPI only. If the SL20 is wanted as the liquid-large-cap comparator, the practical start is 2012-07-01.

ASTRI from 2004 covers the whole window and is the correct benchmark for a backtest, since the price index excludes dividends.

### Return and volatility profile, 2012-01 to 2026-06

| Series | n | Annualised volatility | Annualised mean | Skew | Kurtosis |
|---|---:|---:|---:|---:|---:|
| ASPI | 3,443 | 15.1% | 9.05% | -0.64 | 14.0 |
| ASTRI | 3,442 | 18.2% | 10.84% | -0.35 | 168.6 |
| S&P SL20 | 3,326 | 34.1% | 5.63% | 0.36 | 821.4 |

The SL20 figures are contaminated. See the defect below. The ASPI kurtosis of 14 is ordinary for a daily equity index; the ASTRI figure of 168 suggests at least one bad print in that series too and should be checked before use.

Annualised volatility by year, ASPI: 14.8 (2012), 9.0, 7.4, 8.4, 7.9, **5.6 (2017)**, 6.9, 8.4, 20.4 (2020), 22.8, **31.6 (2022)**, 15.2, 10.8, 15.8, 19.7 (2026 H1).

A factor of 5.6 between the quietest and the most volatile year, with the regimes falling where expected. The regime variable has real variation to work with, and it does not need to be hand-dated.

### Long memory in volatility is present and measurable

ASPI, 2012 to 2026, autocorrelation at lags 1, 5, 10, 20, 50, 100, 250:

| Series | 1 | 5 | 10 | 20 | 50 | 100 | 250 |
|---|---:|---:|---:|---:|---:|---:|---:|
| returns | 0.241 | 0.015 | 0.006 | 0.002 | -0.004 | -0.002 | 0.021 |
| absolute returns | 0.431 | 0.317 | 0.265 | 0.189 | 0.121 | 0.122 | 0.108 |
| squared returns | 0.382 | 0.225 | 0.209 | 0.109 | 0.024 | 0.063 | 0.044 |

GPH estimates of the fractional parameter, m = 58:

| Series | d-hat | Standard error |
|---|---:|---:|
| returns | -0.084 | 0.168 |
| absolute returns | **0.407** | 0.168 |
| squared returns | **0.364** | 0.168 |

Absolute returns still show autocorrelation of 0.108 at a one-year lag, and both volatility proxies give d comfortably inside the stationary long-memory range with the point estimate more than two standard errors from zero. Returns themselves show no such structure, which is the expected pattern and a useful negative control.

This is a feasibility result rather than a finding: it says the $P_t$ persistence term has something to estimate on this sample at this length. It is a single-sample GPH estimate on one index, so scope it to that and do not present it as a characterisation of the market. The lag-1 return autocorrelation of 0.241 is itself worth noting, since it is large for a daily index and is consistent with stale pricing in a thin market.

### Two defects in the index and statistics files

**Item 11 changes units on 2025-01-02.** From that date the column labelled TURNOVER EQUITY-Mn is in rupees rather than millions, MARKET CAP. Mn. is in rupees rather than millions, and SHARES TRADED '000 is in units rather than thousands. TRADES EQUITY is unaffected. The jump is roughly 2.1 million times for turnover and 1.1 million times for market cap, so it is a labelling change rather than a data error, but any loader that trusts the header will produce nonsense for 2025 and 2026.

Layered on top, the README's finding holds: summing item 11 for 2025 gives Rs 1,866.8bn against Rs 1,232.6bn in item 13 and in the per-security panel, a ratio of 1.51, consistent with part of the year being doubled. For 2026 the item 11 sum of Rs 522,812,391,998 matches the extracted panel exactly once the unit correction is applied.

**Recommendation: do not use item 11 turnover at all.** Derive market turnover by summing the per-security panel, which already reconciles to the official annual figure within 0.13% for every year. Use item 11 only for the trade count and as a cross-check.

**The S&P SL20 has two bad days.** On 2019-07-12 the index is printed as 5,569.94 against 2,613.99 the day before, and reverts to 2,643.02 on 2019-07-15. Those are the only two daily moves above 25% in either index across the whole window. This single bad print produces the 107% annualised SL20 volatility for 2019 and the kurtosis of 821 in the table above. Repair or exclude it before any SL20 work.

**2026-01-07 is an all-null row** in item 11, matching the market halt the README documents. It is the only such row in the window.

---

## 2. A_L extensions: the two items that change the liquidity state

### Item 17, public float: nearly half the market is tightly held

58 quarterly sheets, 2012 to 2026 H1, under three different naming conventions and two different layouts. 2012 to 2016 Q2 uses `SECURITY ID` and `PUBLIC FLOAT` with decimal values; 2017 onward uses `SECURITY` and `PUBLIC_FLOAT` with percentage strings. A reader written for one half returns nothing for the other, silently.

Float distribution across all parsed observations:

| p5 | p25 | median | p75 | p95 |
|---:|---:|---:|---:|---:|
| 4.4% | 14.3% | **25.5%** | 40.1% | 90.6% |

48.5% of observations have a public float below 25%, and 12.7% below 10%.

**Does float adjustment change the stratification?** Comparing raw median daily turnover against turnover divided by float, for the 336 securities with both:

- median absolute rank change: 22 places out of 336
- 56 securities move more than 50 places
- the least-liquid quintile retains only 69% of its membership

So yes, materially. Nearly a third of the bottom quintile changes identity depending on which measure is used. That has to be a declared choice in the methodology rather than whichever one the code happened to implement. My reading is that float-adjusted turnover is the better measure of tradeable liquidity on a market where half the counters have under a quarter of shares in public hands, but the raw version should be reported alongside it as a robustness check.

### Item 37, crossings: much larger than I previously assumed

**Correction to earlier advice.** I told you item 37 was a quarterly aggregate and therefore only usable as a slow control. That was wrong. The rows are individual crossing trades with a trade date, security ID, price, quantity and turnover. 26,096 trades across 10,711 distinct security-date pairs, 2011 to 2026. You can strip crossings at daily, per-security granularity.

That matters because the volumes are large. Crossing turnover as a share of total market turnover from the per-security panel:

| Year | Share | Year | Share |
|---|---:|---|---:|
| 2012 | 45.5% | 2020 | 20.4% |
| 2013 | 45.9% | 2021 | **8.8%** |
| 2014 | 37.7% | 2022 | 11.2% |
| 2015 | 33.6% | 2023 | 19.2% |
| 2016 | 38.2% | 2024 | 19.1% |
| 2017 | **47.5%** | 2025 | 31.9% |
| 2018 | 45.2% | 2026 H1 | 46.8% |
| 2019 | 30.8% | | |

Between a tenth and a half of market turnover is negotiated block trades, and the share moves inversely with retail activity: it collapses to 8.8% in the 2021 retail boom and returns above 45% in 2026.

Per security over the window, crossings as a share of that security's own turnover: median 12.5%, 75th percentile 33.0%, 90th percentile 53.0%. 116 securities are above 25% and 41 are above 50%.

**Why this is a problem for $L_t$.** Amihud, relative volume, turnover ratio and trade intensity all assume the volume they divide by is continuous order-book trading. A counter whose turnover is 60% crossings looks liquid on those measures and is not: a crossing is a pre-negotiated transfer that consumed no book depth. Left uncorrected, the liquidity state variable will be systematically wrong for roughly a third of the universe, in the direction of overstating liquidity.

**One unresolved question before use.** For a handful of securities the crossing turnover exceeds the panel turnover: AGST.X0000 at 144.7%, SHAW.N0000 at 110.9%, MERC.N0000 at 102.1%. That is impossible if crossings are a subset of reported turnover, so either they are partly additive, or there are date or symbol mismatches between the two files. Resolve this on a few named cases before building the adjustment, because the fix differs depending on the answer.

---

## 3. A_T and sector context

**Item 39, GICS daily.** Five sheets: Sectors Index, PER, PBV, DY, Market Cap, covering 31 GICS sectors from 2016-04-05. Clean layout with a proper date column and no header band. Useful for sector controls and for sector-neutral portfolio constraints, but it starts in April 2016, so it cannot provide sector context for 2012 to 2015. The older sector scheme in item 07 covers that period under a different and non-comparable classification.

**Item 29, beta values.** 70 quarterly sheets, 2009 Q1 to 2026 Q2, with sheet names under four different conventions. Keyed by company ID, not security ID, so voting and non-voting cannot be separated. Two beta variants per sheet, computed against different references. Useful only as a cross-check on betas you compute yourself. Low priority.

**Item 14, CDS activities.** Transposed layout: 38 metric rows against 393 monthly columns from 1994. Includes new accounts, deposits and withdrawals. The new-account series is the best available proxy for retail participation and feeds the regime label rather than the daily state. Monthly granularity.

**Items 20 and 38, foreign activity and holding.** Item 20 is transposed monthly from 1992; item 38 is annual per security, 21 sheets. Both too coarse to drive a daily state variable. Use as regime context only.

---

## 4. Corporate actions, items 01 to 05: a join problem

| Item | Keyed by | Useful fields |
|---|---|---|
| 01 Dividends | **security ID** (`LITE-N-0000`) | rate, ex-date, payment date, cum price, ex price |
| 02 Scrip dividends | company **name** | old/new proportion, allotment date, shares listed |
| 03 Bonus issues | company **name** | shares listed, allotment date, proportion, date listed |
| 04 Rights issues | company **name** | provisional and final allotment, consideration per share, amount raised |
| 05 Share splits | **company ID** | old/new proportion, effective date |

**The problem.** The three items that change the share count by the largest amounts, 02, 03 and 04, identify the company by name only. Joining them to the price panel means fuzzy name matching across 14 years during which companies were renamed, for example Asian Alliance Insurance to Softlogic Life. Items 01 and 05 carry identifiers and join cleanly.

Build the name-to-symbol crosswalk once, from item 16's name and security ID columns across all years, and treat unmatched corporate-action rows as an error to resolve rather than a row to drop. The annual share-count anchors in item 16 give you the check: apply a year's actions and confirm you land on the next year-end figure.

Volume: 93 share splits over 2012 to 2026 from item 05, and roughly 210 dividend announcements per year from item 01, so on the order of 3,000 dividend events across the window. Counts for 02, 03 and 04 are not reported here because the name-keyed layout defeated the generic reader, which is itself the finding.

Dates appear as Excel serials in some columns and as `DD-MON-YY` strings in others, sometimes within the same column of the same sheet.

---

## 5. Verdicts on items 01 to 39

**Use as primary inputs:** 07 (ASPI, sector indices), 09 (ASTRI as the backtest benchmark), 11 (trade count only), 16 (annual share-count anchors), 17 (float, with the two-layout reader), 21 (year-end price and market cap, security-level from 2017), 30 to 33 plus the 2026 file (the price panel), 37 (daily crossings), 39 (GICS sectors from 2016-04).

**Use as secondary or context:** 01 to 05 (corporate actions, once the crosswalk exists), 10 (market valuation ratios as a regime covariate), 13 (annual reconciliation), 14 (retail participation proxy), 20 and 38 (foreign flows as regime context), 29 (beta cross-check).

**Drop:** 08 and 12 (monthly aggregates of daily series already held), 18 and 19 (corporate debt, out of scope for an equity study), 22 to 27 (sector aggregates superseded by item 39 from 2016 and by aggregating the panel before that), 34 to 36 (not supplied, and redundant with the daily panel in any case).

**Do not use:** item 11 turnover, shares traded and market cap columns, for the unit and doubling reasons above.

---

## 6. Decisions this forces

1. Derive market-level turnover from the per-security panel, not item 11.
2. Repair or exclude S&P SL20 on 2019-07-12 and 2019-07-15 before any SL20 work, and check the ASTRI series for a similar bad print given its kurtosis of 168.
3. Start SL20-based analysis at 2012-07-01, not 2012-01-01.
4. Strip crossings from per-security volume before computing any liquidity measure, after resolving the above-100% cases.
5. Declare whether the liquidity stratification is float-adjusted. It changes 31% of the bottom quintile either way.
6. Build the company-name to security-ID crosswalk before attempting corporate-action adjustment.
7. Write a per-item loader with a row-count assertion. Items 11, 16, 17, 21 and 37 all change layout or units partway through, and three of those fail silently rather than loudly.

---

## 7. Rights issues: the hardest of the five adjustments

Splits and bonus issues are pure ratios. A rights issue is not, because shareholders pay cash at a subscription price below market, so the price adjustment runs through the theoretical ex-rights price:

$$TERP = \frac{N \cdot P_{cum} + S \cdot X}{N + S}, \qquad \text{adjustment factor} = \frac{P_{cum}}{TERP}$$

where $N$ is shares in issue, $S$ the new shares, $X$ the subscription price and $P_{cum}$ the cum-rights close. That needs three inputs item 04 only partly supplies.

### Scale

225 events over 2012 to 2026 across 174 distinct company names, between 7 and 27 a year. 133 of the 332 profiled companies, **40%**, had at least one rights issue inside the panel period. This is not a long-tail problem.

### What item 04 supplies

| Field | Populated |
|---|---|
| Consideration per share (the subscription price $X$) | 217 / 225 |
| Proportion | 188 / 225, **but corrupted, see below** |
| Date of provisional allotment | 177 / 225 |
| Date listed | 185 / 225 |
| Provisional and final allotment counts | 188 comparable |

It supplies **no ex-rights date and no cum price**, which are the two remaining TERP inputs.

### Three problems

**The proportion column has been mangled by Excel time formatting.** Observed values include `6:01`, `2:01`, `1:08`, `3:14`, `5:24` and `14:45`. The ones with a leading zero in the second component are ratios reformatted as clock times: `6:01` is 6:1, `1:08` is 1:8. Others are ambiguous and cannot be recovered from the cell alone. Do not read this column directly. Derive the ratio from the provisional allotment divided by shares in issue at that date, using the item 16 annual anchors, and use item 04's proportion only as a sanity check on the derived value.

**Provisional and final allotment diverge in 22% of events.** 146 of 188 were fully taken up; the other 42 were under-subscribed, with take-up ranging from 6.4% to 100% and a median of 74% among those. The worst cases: Blue Diamonds 2023 at 6.4% (486.6m provisional against 31.3m final), Kotagala Plantations 2017 at 12.7%, Lanka Realty 2020 at 18.5%, DFCC Bank 2019 at 36.9%.

This matters because the two figures do different jobs. The **price** adjustment on the ex-date must use the **announced** terms, because that is what the market priced on the day. The **share count** change must use the **final** allotment, because that is what was actually issued. Using one number for both is wrong in roughly a fifth of events, and the error is large in the worst cases.

**Item 04 is keyed by company name**, so the crosswalk problem in section 4 applies here too.

### The missing ex-date is recoverable from the rights securities

The 148 `.R` securities excluded from the equity universe are the dating mechanism. They carry 1,493 trade rows between 2010 and 2026, and the episodes are strikingly regular.

A gap-based clustering (new episode after a 60-day gap) over 16 sampled symbols produced 50 clean episodes, almost all exactly 6 trading days long:

| Symbol | Episodes |
|---|---|
| ACME.R0000 | 2010-08, 2014-10, 2022-07, 2026-02 |
| CRL.R0000 | 8 episodes, 2010 through 2024 |
| PMB.R0000 | 5 episodes, including two in 2021 |
| COMB.R0000 / R0001 | identical dates: 2011-08, 2017-06, 2024-07 |

Two things fall out. First, the README's warning about symbol reuse is confirmed and is worse than a nuisance: ACME.R0000 covers four separate issues and CRL.R0000 covers eight, so the symbol is a company marker, not an event key. Second, `R0000` and `R0001` pairs carry **identical** episode dates, so they are the voting and non-voting rights of the same issue rather than sequential issues. Do not count them twice.

**Method.** Cluster each `.R` series into episodes by trading gap. Each episode is one rights issue and its first trade date is, in practice, the ex-rights date, since the rights begin trading once the underlying goes ex. That gives a symbol-keyed, dated event list. Join it to item 04 on company plus approximate date to pick up the subscription price and the final allotment. Having a date on both sides makes that join far more reliable than name matching alone.

$P_{cum}$ then comes from the underlying's close on the trading day before the episode starts, which the panel already has.

### Verification available

Because item 16 gives year-end share counts, the whole chain is checkable: apply the year's splits, bonuses, scrip dividends and final rights allotments to year-end $N$ and confirm the result against year-end $N+1$. Any residual points at a missed or misdated event. Run that check per security per year rather than in aggregate, since offsetting errors would cancel in a total.
