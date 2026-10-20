---
date: 2026-10-20
type: dataset-profile
project: FYP — Multi-Agent Financial Decision Systems for the CSE
source: extracted/daily_share_prices (official CSE Data Library items 30-33 + 2026)
window: 2012-01-01 to 2026-06-30
tags: [fyp, dataset, liquidity, edge, data-quality]
---

# Dataset Profile: EDGE readiness and liquidity stratification

Profiled the 359 equity securities in `extracted/daily_share_prices` (335 voting, 24 non-voting; rights, warrants, preference and unit instruments excluded). 356 of them have at least 60 calendar-aligned days inside the window, giving 853,577 price rows. Each series was aligned to the validated 3,920-day trading calendar before any statistic was computed.

This profile does not repeat the extraction and reconciliation work already recorded in the repository README. It covers the four questions that decide how the liquidity agent and the cost model can actually be built.

---

## 1. Open price availability sets the EDGE window

| Period | Rows with a positive open |
|---|---|
| 2012 to 2016 | 0.0% |
| 2017 to 2026 H1 | 100.0% |

The split is clean, not gradual. There is no partial coverage year.

**Consequence.** The full EDGE estimator of Ardia, Guidotti and Kroencke (2024) requires open, high, low and close. It can therefore run on 2017-01-01 onward, roughly 9.5 years and about 570,000 rows. For 2012 to 2016 the estimator has to drop to CHL, which is one of the same paper's four discrete generalized estimators and still carries the discreteness correction. What is lost before 2017 is the GMM efficiency gain, not the method and not the correction.

This should be stated as a window decision in the methodology rather than discovered later: EDGE on 2017 onward, CHL on 2012 to 2016, with the two reported separately rather than spliced into one series.

---

## 2. The tau indicator confirms the discreteness problem is real here

Share of calendar-aligned days on which high, low and previous close all coincide, which is the condition the paper's $\tau_t = 0$ flag exists to catch:

| Year | tau = 0 | Year | tau = 0 |
|---|---|---|---|
| 2012 | 18.3% | 2020 | 19.5% |
| 2013 | 21.8% | 2021 | 12.1% |
| 2014 | 20.1% | 2022 | 14.2% |
| 2015 | 25.7% | 2023 | 15.1% |
| 2016 | 29.9% | 2024 | 12.7% |
| 2017 | 29.2% | 2025 | 4.3% |
| 2018 | 32.1% | 2026 H1 | 2.3% |
| 2019 | 30.0% | | |

Across securities the median is 13.4%, the 75th percentile 29.7% and the 95th percentile 60.6%.

By liquidity quintile the spread is much wider than the time series suggests:

| Quintile | Median daily turnover | Trading frequency | tau = 0 | Median trades/day |
|---|---:|---:|---:|---:|
| Q1 (least liquid) | Rs 19,475 | 60.5% | 43.5% | 4 |
| Q2 | Rs 62,305 | 83.6% | 22.4% | 8 |
| Q3 | Rs 145,514 | 93.0% | 13.9% | 13 |
| Q4 | Rs 420,056 | 97.3% | 6.1% | 21 |
| Q5 (most liquid) | Rs 2,230,554 | 99.5% | 1.6% | 44 |

For reference, the paper reports roughly 2 to 5% for recent US large caps and about 15% for US small caps. Q5 of the CSE sits in US large-cap territory; Q1 at 43.5% sits beyond the US small-cap figure and closer to what the paper finds for the pre-electronification era.

**Reading.** This is measured support for the thin-book argument, on the actual market, rather than an appeal to the paper's simulation. It is also an argument for stratifying rather than averaging: Q1 and Q5 are different measurement regimes, and a single market-wide spread estimate would conceal that. Scope the claim to this window and this universe.

---

## 3. The published close is often not a traded price

54,796 of 853,577 rows, 6.4%, have a close outside the day's high-low range. By year:

| Year | Close outside [L,H] | Year | Close outside [L,H] |
|---|---:|---|---:|
| 2012 to 2014 | 0.00% | 2020 | 8.37% |
| 2015 | 6.07% | 2021 | 6.40% |
| 2016 | 10.78% | 2022 | 7.13% |
| 2017 | 10.56% | 2023 | 8.24% |
| 2018 | 11.93% | 2024 | 7.48% |
| 2019 | 13.26% | 2025 | 3.84% |
| | | 2026 H1 | 3.62% |

From 2015 onward, by liquidity quintile:

| Quintile | Violation rate | Median trades on violating days | Median trades on clean days |
|---|---:|---:|---:|
| Q1 (least liquid) | 25.4% | 1 | 6 |
| Q2 | 7.9% | 1 | 9 |
| Q3 | 3.8% | 1 | 14 |
| Q4 | 2.1% | 1 | 21 |
| Q5 (most liquid) | 0.4% | 1 | 54 |

The median number of trades on a violating day is exactly 1 in every quintile. Deviations are small, median 0.44% of price, 95th percentile 1.22%. Inspected examples show the pattern directly: a counter trades once, high and low both equal that single trade price, and the published open and close carry a different reference value.

**Reading.** This looks like the CSE closing-price rule producing a reference price rather than a transaction price on days with negligible trading. It is not an extraction defect; it appears in the official files and the 2012 to 2014 absence is explained by those years having no open field and a different file layout.

**Consequence.** Ardia et al. treat rows where the open or close falls outside the high-low range as missing. Applying the same rule costs 6.4% of rows overall but 25.4% of rows in Q1, which is where the cost model matters most. Two things follow. The exclusion rate has to be reported alongside every spread series, not just applied silently. And the exclusion is itself a measurement: the frequency with which a CSE price is not transaction-based is a candidate staleness variable with a cleaner interpretation than zero-return frequency.

I have not found this quantified for the CSE in the literature covered so far. State it as a measurement on this dataset, not as a general claim about the market.

---

## 4. Liquidity stratification is feasible and wide

| Trading frequency band | Securities |
|---|---:|
| Below 25% of days | 6 (1.7%) |
| 25 to 50% | 19 (5.3%) |
| 50 to 75% | 58 (16.3%) |
| 75 to 90% | 78 (21.9%) |
| 90% and above | 195 (54.8%) |

Median trading frequency is 92.2%, 5th percentile 42.4%. Median daily turnover spans a factor of 114 from Q1 to Q5. Median annualised volatility runs 58.0% in Q1 down to 42.2% in Q5, so the least liquid counters are also the most volatile, which is the combination the risk and liquidity agents are supposed to handle jointly.

**Candidate universe.** 234 voting securities trade on at least 60% of days and have at least 2,000 aligned days. That is enough for a five-stratum design with roughly 45 securities per stratum, which is well beyond the 20 to 50 originally planned and allows the stratum itself to be an experimental factor rather than a robustness note.

---

## 5. EDGE sample size is adequate except at the bottom

Counting only $\tau_t = 1$ days, the median security has 2,573 usable observations over the window, or 44.4 per quarter. 24 securities (6.7%) fall below 10 per quarter and 6 fall below 3, which is the paper's stated minimum for the covariance structure.

A quarterly aggregation window is therefore workable for most of the universe. The 24 securities below 10 observations per quarter should either move to an annual window or be reported separately, and the count of non-positive squared estimates has to accompany every series because that is the only visible signal that the truncation bias is distorting the number.

---

## 6. Survivorship: the official extraction adds 46 securities

| Set | Count |
|---|---:|
| In both official and API | 313 |
| Official only | 46 |
| API only | 0 |

The 46 are delisted or otherwise absent from the API scrape, a 14.7% uplift on the API-only universe. Working from `historical_trades/` alone would have excluded them, and that exclusion spans a period containing a sovereign default. Use `extracted/daily_share_prices/` as the base panel, as the README already recommends.

Item 06, New Listings and De-listings, has still not been supplied. Listing and delisting dates can be reconstructed from first and last appearance across the yearly files, so this is not blocking, but the reason for each delisting cannot be, and voluntary delistings cannot be separated from failures without it.

---

## 7. Corporate-action adjustment: scale of the job

1,567 one-day moves larger than 35% in log terms, across 170 securities (48% of the universe). The median affected security has one such move, so the distribution is concentrated.

Seven securities account for most of the total and need inspection before any adjustment table is built:

| Symbol | Moves > 35% | Trading frequency | Median turnover |
|---|---:|---:|---:|
| SEMB.X0000 | 600 | 97% | Rs 78,832 |
| BLUE.X0000 | 244 | 89% | Rs 40,000 |
| PCH.N0000 | 107 | 78% | Rs 166,406 |
| CSF.N0000 | 91 | 97% | Rs 282,395 |
| ASPH.N0000 | 89 | 74% | Rs 143,639 |
| PCP.N0000 | 71 | 75% | Rs 71,461 |
| AINV.N0000 | 66 | 94% | Rs 100,904 |

600 moves above 35% in 14 years is not a corporate-action pattern. These are more likely price-scale or very-low-price oscillation artifacts and should be checked individually before being fed to an adjustment routine. The remaining roughly 300 moves spread across 163 securities are the plausible corporate-action candidates, and those are the ones to reconcile against Data Library items 01 to 05.

---

## Decisions this forces

1. EDGE runs on 2017 onward. CHL covers 2012 to 2016. Report separately.
2. Apply the paper's exclusion of rows with open or close outside the high-low range, and report the exclusion rate per security and per stratum alongside every spread estimate.
3. Stratify by liquidity. Q1 and Q5 differ by a factor of 114 in turnover and by 27 times in the tau = 0 rate, so a pooled estimate would hide the regime the contribution is about.
4. Quarterly aggregation for EDGE, with the 24 thinnest securities moved to an annual window or reported separately.
5. Build the panel from `extracted/daily_share_prices/`, not the API scrape.
6. Inspect the seven high-jump securities before building the adjustment table; treat the remaining jumps as corporate-action candidates to reconcile against items 01 to 05.

Outputs: `extracted/profile/security_profile.csv`, one row per security with trading frequency, tau rate, zero-return rate, turnover, trade count, Amihud, annualised volatility and jump count.
