---
date: 2026-10-20
type: build-checklist
project: FYP — Multi-Agent Financial Decision Systems for the CSE
source:
  - - Dataset Profile 2026-10-20
tags:
  - fyp
  - dataset
  - data-quality
  - build
---

# Data Cleaning Checklist

Everything the two profiling passes turned up, ordered as a build sequence. Items already handled by `extract_daily_prices.py` (the 2023 comma corruption, spilled digits, missing and mislabelled block headers) are not repeated here.

Severity: **B** blocking, produces wrong numbers silently if skipped. **D** degrading, loses data or precision. **C** a choice to declare rather than a defect.

---

## Stage 0: loaders

Nothing downstream is safe until these are done, because three of the four failures below are silent.

| # | Sev | Item | Fix |
|---|---|---|---|
| 0.1 | B | All | Write one loader per Data Library item with an assertion on expected row count and date range. Items 11, 16, 17, 21 and 37 change layout or units partway through their own history, and 16, 17 and 37 fail by returning zero rows rather than raising. |
| 0.2 | B | 16 | The 2014 sheet keys the issued quantity by bare company code while 2015 onward uses full security IDs. A reader built for the neighbouring years returns nothing for 2014. Special-case it or bracket 2014 between the 2013 and 2015 anchors. |
| 0.3 | B | 17 | Two layouts: 2012 to 2016 Q2 uses `SECURITY ID` / `PUBLIC FLOAT` with decimal values, 2017 onward uses `SECURITY` / `PUBLIC_FLOAT` with percentage strings. Three sheet naming conventions (`2012 Q4`, `2017_Q4`, `1-2021`). Handle all of them or lose half the history. |
| 0.4 | B | 37 | Three date formats: `M/D/YYYY` for 2011 to 2015, `DD-MON-YY`, and native datetimes. Parsing only the later formats silently drops 2011 to 2015 entirely. |
| 0.5 | D | 21 | Three layouts. 2017 onward has a `SECURITY TYPE` column with full symbols; 2013 to 2016 has company code only; 2012 and earlier has company code with the shares and price columns in the opposite order. Voting and non-voting cannot be separated before 2017, so take those years from item 16. |
| 0.6 | D | 01 to 05 | Dates appear as Excel serials in some columns and `DD-MON-YY` strings in others, sometimes within the same column of the same sheet. Write one tolerant date parser and use it everywhere. |

---

## Stage 1: security master and calendar

| # | Sev | Item | Fix |
|---|---|---|---|
| 1.1 | B | 06 missing | Item 06 was never supplied. Reconstruct listing and delisting dates from first and last appearance across the yearly price files. Delisting reasons are not recoverable, so voluntary delistings cannot be separated from failures. |
| 1.2 | B | panel | Use `extracted/daily_share_prices/` as the base panel, not `historical_trades/`. The API scrape is missing 46 delisted securities, a 14.7% survivorship gap across a period containing a sovereign default. |
| 1.3 | D | 16 + 01 to 05 | Build a company-name to security-ID crosswalk from item 16's name and ID columns across all years. Items 02, 03 and 04 are keyed by company name only, and companies were renamed inside the window. |
| 1.4 | C | calendar | Decide how a security's non-trading days are represented. Rows exist only for days a security traded, which is the correct raw state, but EDGE and any rolling statistic need calendar alignment. Forward-fill for the $\tau_t$ construction and keep the traded/not-traded flag. |

---

## Stage 2: price panel

| # | Sev | Item | Fix |
|---|---|---|---|
| 2.1 | B | 30 to 33 | Exclude rows where the close or open falls outside the day's high-low range, following Ardia et al. 6.4% of rows overall, 25.4% in the least liquid quintile. The median violating day has exactly 1 trade, so these are reference prices rather than transaction prices. Report the exclusion rate per security and per stratum alongside every spread estimate. |
| 2.2 | C | 30 to 33 | EDGE needs an open price, which is absent for 2012 to 2016 and present from 2017. Run full EDGE on 2017 onward and the CHL estimator on 2012 to 2016, reported separately rather than spliced. |
| 2.3 | D | 30 to 33 | 24 securities have fewer than 10 $\tau_t = 1$ observations per quarter and 6 fall below the paper's minimum of 3. Move those to an annual window or report them separately. |
| 2.4 | D | historical_trades | If the API files are used for the July to October 2026 tail, drop duplicate dates first. 298 of the 334 files contain exact duplicates. |

---

## Stage 3: corporate actions

| # | Sev | Item | Fix |
|---|---|---|---|
| 3.1 | B | 01 to 05 | Build the adjustment factor table. Prices in the panel are unadjusted, so every split, bonus, scrip and rights event is currently a fake return. |
| 3.2 | B | 04 | Do not read the proportion column. Excel time formatting has turned ratios into clock times (`6:01` is 6:1, `1:08` is 1:8) and some, such as `14:45`, are ambiguous and unrecoverable. Derive the ratio from provisional allotment divided by shares in issue, and use item 04's proportion only as a check. |
| 3.3 | B | 04 | Use the **announced** (provisional) terms for the price adjustment and the **final** allotment for the share count. They diverge in 22% of the 225 events, with take-up as low as 6.4%. Using one figure for both is wrong in roughly a fifth of cases. |
| 3.4 | B | 04 + .R | Item 04 supplies no ex-rights date and no cum price. Recover the ex-date by clustering each `.R` security's trade dates into episodes by gap; episodes are almost all exactly 6 trading days and the first day is the ex-date in practice. Take the cum price from the underlying's close the prior trading day. |
| 3.5 | B | .R | Do not treat an `.R` symbol as an event key. ACME.R0000 covers four separate issues and CRL.R0000 covers eight. And `R0000`/`R0001` pairs carry identical dates because they are the voting and non-voting rights of one issue, so do not count them twice. |
| 3.6 | D | panel | Inspect the seven securities with anomalous counts of one-day moves above 35% before feeding them to any adjustment routine: SEMB.X0000 (600), BLUE.X0000 (244), PCH.N0000 (107), CSF.N0000 (91), ASPH.N0000 (89), PCP.N0000 (71), AINV.N0000 (66). 600 such moves in 14 years is not a corporate-action pattern. The remaining ~300 moves across 163 securities are the plausible candidates. |

---

## Stage 4: liquidity inputs

| # | Sev | Item | Fix |
|---|---|---|---|
| 4.1 | B | 37 | Strip crossings from per-security daily volume and turnover before computing any liquidity measure. Crossings run from 8.8% to 47.5% of market turnover by year and from a median of 12.5% to a 90th percentile of 53% per security. Amihud, relative volume and turnover ratio all assume the volume consumed book depth, and a crossing did not. |
| 4.2 | B | 37 | Resolve the cases where crossing turnover exceeds panel turnover before applying 4.1: AGST.X0000 at 144.7%, SHAW.N0000 at 110.9%, MERC.N0000 at 102.1%. Either crossings are partly additive or there are symbol and date mismatches, and the fix differs. |
| 4.3 | C | 17 | Declare whether the liquidity stratification is float-adjusted. Median float is 25.5% and 48.5% of observations are below 25%. Switching moves the median security 22 places out of 336 and changes 31% of the bottom quintile's membership. Report both. |
| 4.4 | D | 16 + 03 to 05 | Reconstruct the shares-outstanding series by interpolating between item 16's annual year-end anchors using the dated corporate actions. 10 to 22% of securities change issued quantity each year, roughly 600 events over the window. |

---

## Stage 5: index and market-state series

| # | Sev | Item | Fix |
|---|---|---|---|
| 5.1 | B | 11 | Do not use item 11's turnover, shares traded or market cap. Units change silently on 2025-01-02 (turnover and market cap become rupees not millions, shares become units not thousands) and part of 2025 is additionally doubled. Derive market turnover by summing the per-security panel, which reconciles to item 13 within 0.13% every year. Item 11's trade count is unaffected and usable. |
| 5.2 | B | 07 | Repair or exclude the S&P SL20 on 2019-07-12 and 2019-07-15. The index prints 5,569.94 against roughly 2,620 either side. This single bad print produces 107% annualised SL20 volatility for 2019 and a kurtosis of 821 across the window. |
| 5.3 | D | 09 | Check ASTRI for a similar bad print. Its kurtosis of 168.6 over the window is implausible for a total-return index. |
| 5.4 | C | 07, 09, 11 | S&P SL20 and its TRI do not start until 2012-06-27. Begin any SL20-based analysis at 2012-07-01, not 2012-01-01. |
| 5.5 | C | 07, 09 | The Milanka index ends 2023-03-31 and MTRI ends 2025-03-28. Neither can serve as a second market factor across the full window. |
| 5.6 | D | 11, 07 | Handle 2026-01-07, the market-halt day. Item 11 carries an all-null row and item 07 carries the previous day's index values. It is the only all-null row in the window. |
| 5.7 | D | 39 | GICS sector data starts 2016-04-05. The older item 07 sector scheme covers 2012 to 2016 under a different and non-comparable classification, so sector controls cannot be continuous across the window without a stated break. |

---

## Stage 6: verification

| # | Sev | Check |
|---|---|---|
| 6.1 | B | Apply each year's splits, bonuses, scrip dividends and final rights allotments to the item 16 year-end share count and confirm the result against the next year-end. Run it per security per year, not in aggregate, so offsetting errors do not cancel. |
| 6.2 | B | Reconcile annual turnover from the cleaned panel against item 13. The existing extraction already achieves 0.13% for every year except 2016 at 0.8%, so any regression is a new bug. |
| 6.3 | D | Re-check the per-security panel against `historical_trades/` over the overlap after adjustment. The existing comparison shows 99.93% close agreement on 817k rows, which is the baseline to preserve. |
| 6.4 | D | Report, for every spread series, the fraction of non-positive squared estimates. It is the only visible signal that EDGE's truncation bias is distorting the number. |

---

## Not defects, but decisions to record

- Analysis window 2012 to 2026 H1, with 2001 to 2011 held as an untouched stress-test sample.
- Liquidity stratification by quintile rather than a pooled estimate, given the factor of 114 in turnover and 27 in the $\tau_t = 0$ rate between Q1 and Q5.
- Candidate universe of 234 voting securities trading on at least 60% of days with at least 2,000 aligned days.
- EDGE aggregation window quarterly for most securities, annual for the 24 thinnest.
