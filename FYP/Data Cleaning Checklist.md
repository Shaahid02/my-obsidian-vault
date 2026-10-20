---
date: 2026-10-20
revised: 2026-10-20 (merged with cross-check)
type: build-checklist
project: FYP — Multi-Agent Financial Decision Systems for the CSE
source: [[Dataset Profile 2026-10-20]], [[Data Library Profile Items 01-39]], docs/checklist_crosscheck_2026-10-20.md
tags: [fyp, dataset, data-quality, build]
---

# Data Cleaning Checklist

Merged version. Where the independent cross-check and the original profiling disagreed, **the cross-check's recomputed figures are used**, since they were verified against the panel at commit `74f3029` with stated parsing choices. Three original claims were wrong and are marked **[corrected]**; several were partly right and carry revised numbers. Items already handled by `extract_daily_prices.py` are not repeated.

Severity: **B** blocking, produces wrong numbers silently if skipped. **D** degrading, loses data or precision. **C** a choice to declare rather than a defect.

> **Read this first.** The three errors in the original all came from the same habit: checking that a field existed and had a plausible magnitude, without checking that it carried information or was internally consistent at a small multiple. The open price was present but was a copy of the close. The trade count had the right order of magnitude but was doubled. Treat any remaining unverified claim here with that in mind.

---

## Stage 0: loaders

Nothing downstream is safe until these are done. Most of these failures are silent.

| # | Sev | Item | Fix |
|---|---|---|---|
| 0.1 | B | All | One loader per item, with an assertion on expected row count and date range. Items 07, 11, 16, 17, 21, 37 and 39 all change layout, units or meaning partway through their own history. |
| 0.2 | B | 16 | The 2014 sheet keys issued quantity by bare company code (287 of them, no full IDs); 2005 to 2013 and 2015 onward use `AAF-N-0000`. A reader built for the neighbours returns nothing for 2014. |
| 0.3 | B | 17 | **Three** header variants, not two: `SECURITY ID` / `PUBLIC FLOAT` (2012 Q1 to 2016 Q2), `SECURITY` / `PUBLIC FLOAT` (2016 Q3), `COMPANY_NAME` / `SECURITY` / `PUBLIC_FLOAT` (2016 Q4 onward). Three sheet-name styles: `2012 Q4`, `2017_Q1`, `1-2021`. Percentage strings begin 2016 Q4, but 2018_Q3, 2020_Q3 and 3-2022 revert to decimals and 2020_Q2 is mixed. 2020_Q1 is a COVID note with no data. |
| 0.4 | B | 37 | Date formats are not sequential by era. `M/D/YYYY` appears in 2012 to 2015 **and again** in 2017 (539 rows) and 2019 (188 rows). 2011, 2016 and 2018 are native datetimes. `DD-MON-YY` runs 2020 to 2026, mixed with datetimes in 2020 to 2022. All dates agree with the QUARTER column, which is the cheapest validation. |
| 0.5 | D | 21 | **Four** layouts, not three: 2017 onward is code plus SECURITY TYPE; 2013 to 2016 is code, price, quantity; 2010 to 2012 is code, quantity, price; 1999 to 2009 is as 2010 to 2012 plus a DATE TRADED column. Voting and non-voting cannot be separated before 2017, so take those years from item 16. |
| 0.6 | D | 01 to 05 | Mixed date types within a single column: 12 such columns in item 01, 7 in item 02, 1 in item 04 (item 01's 2021 DATE OF EX holds 105 serials and 105 strings). Item 03 is serial-only. Formats seen: Excel serial, `DD-MON-YY`, `M/D/YYYY`, `DD-MM-YYYY`, `DD-Mon-YYYY`, some with trailing non-breaking spaces. |
| 0.7 | B | 07 | **A second header block at row 8380.** Row 8378 is a note, row 8380 is a fresh header, and from 2020-01-02 the sector columns switch from the old scheme (Banks Finance and Insurance, values in the 15,000s) to GICS (Automobiles and Components, values in the 600s). Columns 0, 1 and 3 (date, ASPI, SL20) keep their meaning. Any sector series read straight down this file across 2020 is two unrelated index families concatenated, with nothing in the data to signal it. |
| 0.8 | D | 39 | On the Market Cap sheet, column D rows 2365 to 2425 are date-formatted and openpyxl reads them as errors unless raw values are requested. |

---

## Stage 1: security master and calendar

| # | Sev | Item | Fix |
|---|---|---|---|
| 1.1 | B | 06 missing | Item 06 was never supplied. Reconstruct listing and delisting dates from first and last appearance across the yearly price files. Reasons are not recoverable, so voluntary delistings cannot be separated from failures. |
| 1.2 | B | panel | Use `extracted/daily_share_prices/` as the base panel, not `historical_trades/`. 46 N and X securities are in the official panel and absent from the API: a **12.8%** gap (46 of 359), or 12.3% from 2012 (44 of 357). The original 14.7% used the API count as the denominator. Note 5 of the 44 still trade in 2026, so "delisted" is loose shorthand. |
| 1.3 | D | 16 + 01 to 05 | Build a company-name to security-ID crosswalk from item 16. Items 02, 03 and 04 carry only Company or Name columns; no cell matches a security-ID pattern. |
| 1.4 | C | calendar | Decide how non-trading days are represented. Rows exist only on traded days, which is the correct raw state, but EDGE and any rolling statistic need calendar alignment. Forward-fill for the $\tau_t$ construction and keep the traded flag. |

---

## Stage 2: price panel

| # | Sev | Item | Fix |
|---|---|---|---|
| 2.1 | B | 30 to 33 | Close outside the high-low range on **6.41%** of rows from 2012 (5.71% over the full file, 0 in 2010 to 2011). Least-liquid quintile **15.4%**, not 25.4%; no quintile definition tried exceeds 21.5%. Median trade count on a violating day is 1. **The key fact: 99.9% of violations (55,354 of 55,410) have close equal to the previous close.** These are stale carried-forward reference prices, not erratic ones. See the open question below before choosing a treatment. Open outside the range is negligible once copied opens are excluded: 10 rows of 372,776 real opens. |
| 2.2 | B | 30 to 33 | **[corrected]** The original claim that opens are "present from 2017" is wrong. The field is populated from 2017 but in 2017, 2018 and 2025 **every open equals that day's close**, so all open-based terms in EDGE collapse to zero identically and the estimator returns numbers without erroring. Genuinely informative opens exist for **2019 to 2020, 2021-04 to 2024-12, and 2026 H1**; the cleaned layer extends this (DC-15, DC-16). The usable EDGE period is therefore roughly six years **and is not contiguous**, with 2025 a hole in the middle. Any walk-forward design that assumes an unbroken sequence has to be reworked. Use CHL where the open is absent or degenerate. |
| 2.3 | D | 30 to 33 | **[corrected]** The original 24 and 6 came from averaging each security's observations over all 58 quarters, including quarters before it listed. Using the median quarterly count over quarters with trading: **2** securities below 10 observations per quarter and **1** below 3 (ASPM) among N0000; 3 and 2 including X. This is a much smaller problem than stated and does not need a separate annual-window track. |
| 2.4 | D | both | 298 of 334 API files contain duplicate dates (736 extra rows); de-duplicate before using the API tail. The official panel has no duplicates, no negatives and no high-below-low rows. It is **not** fully populated: **121 rows have a blank high and/or low** (23 fully blank, 98 with a close only, 2014 to 2025, including 32 blank lows in 2024). `DATA_CLEANING.md` DC-05 currently counts only the 23. The trade count is 100% populated. |
| 2.5 | B | 30 to 33 | Price granularity breaks at **2021-01**. 2011 to 2016 and 2020 are 0% off a 10-cent grid, 2017 to 2019 are 0.01 to 0.03%, and 2021 onward runs 8.0, 7.1, 5.4, 6.7, 12.0, 12.9% for closes by year (pooled close 8.4%, high 4.7%, low 4.4%). Separately, **2010 is 18.9% off-grid**, a third regime that matters only if the pre-2012 sample is used. Treat 2021-01 as a structural break for any tick-size or discreteness statistic. |
| 2.6 | C | panel vs API | The official panel ends **2026-06-30**, the API runs to 2026-10-02. Truncate or splice. The original reason given for preferring truncation, two different open definitions, was wrong; decide on source consistency grounds instead. |

---

## Stage 3: corporate actions

| # | Sev | Item | Fix |
|---|---|---|---|
| 3.1 | B | 01 to 05 | Build the adjustment factor table. Panel prices are unadjusted, so every split, bonus, scrip and rights event is currently a fake return (WATA's 1:5 in February 2025 shows as a 80% fall). |
| 3.2 | B | 04 | Do not read the proportion column directly. **87 cells** are formatted `h:mm` (2008 to 2010, 2012 to 2015, and one in 2024), for example `1:08`, `6:07`, `2:13`. Ambiguous cases that cannot be recovered from the cell: `13:10`, `23:05`, `19:01`, `11:20`, `10:11`, `7:23`. Derive the ratio from provisional allotment divided by shares in issue and use the column only as a check. Reading with `xlrd(formatting_info=True)` is what exposes the formatting. |
| 3.3 | B | 04 | **192** rights events with both allotment figures, 2013 to 2026. **43 (22.4%)** have final different from provisional, minimum take-up **6.44%** (Blue Diamonds non-voting, 2023). Use the **announced** terms for the price adjustment and the **final** allotment for the share count. The original 225 included 38 sector-summary rows that a naive parser counts as events. The 2008 to 2012 sheets compare offered with subscribed shares, a different measure, and should not be pooled with these. |
| 3.4 | B | 04 + .R | Item 04 has no ex-rights date and no cum price. Recover the ex-date by clustering each `.R` series into episodes. **267 episodes**, of which 75.3% are exactly 6 traded days and 83.5% span 6 trading days; the rest run 1 to 5, 8 or 11. The first day of an episode is the ex-date in practice. Take the cum price from the underlying's close on the prior trading day. |
| 3.5 | B | .R | An `.R` symbol is a company marker, not an event key: ACME.R0000 covers 4 issues and CRL.R0000 covers 8. **And R0001 is not reliably the non-voting right of the R0000 issue.** Of 16 R0001 files only 10 share their R0000's dates; CDB, SHOT and TESS overlap partially; **AAF and VLL never overlap, so those are separate issues**; NTB has an R0001 with no R0000. Pair them by date, do not assume. |
| 3.6 | D | panel | Seven securities carry anomalous counts of one-day moves above 35%, but the counts on the official panel are lower than first reported: SEMB.X0000 302, BLUE.X0000 127, PCH.N0000 78, PCP.N0000 64, CSF.N0000 60, ASPH.N0000 55, AINV.N0000 47. Overall 1,076 moves across 366 securities, or 344 across 184 for N and X from 2012. Inspect the seven before feeding them to any adjustment routine. |
| 3.7 | D | 05 | On the official panel including X shares from 2010, **145 of 149** splits line up with a one-day drop above 25% within seven days of the recorded effective date. The four misses are JKH twice and SAMP in 2010 (small ratios, so no 25% drop expected) and SING in 2021 (no drop at all, worth checking). The original 74 of 81 was computed on the API data. |

---

## Stage 4: liquidity inputs

| # | Sev | Item | Fix |
|---|---|---|---|
| 4.1 | B | 37 | Strip crossings from per-security volume and turnover before any liquidity measure. Market-wide they run **8.8% (2021) to 47.4% (2017)** of annual turnover. Per security over the whole period, median **15.8%**, 90th percentile 53.6%. The figure is sensitive to the variant: volume-based gives 15.9%, including never-crossed securities gives 2.7%, and a per-security-year median gives 23.5% (p90 77.9%). State which you used. |
| 4.2 | B | 37 | On 90.7% of crossing security-days the crossing quantity is at or below panel volume (median ratio 0.751), so crossings are normally inside it. On 9.3% it exceeds. Subtract with a floor at zero and flag the exceptions rather than letting volume go negative. |
| 4.2b | C | 37 | 20.3% of 25,901 crossings price outside the day's high-low range, so crossings are excluded from the high-low calculation while being included in volume. EDGE uses open, high, low and close, so its inputs are board-only and uncontaminated. The crossing problem is confined to Amihud, relative volume and turnover ratio. |
| 4.3a | B | 17 | **[partly corrected]** 283 float observations are exactly 0 and must be treated as missing, not as a value, or any float-adjusted ratio divides to infinity. There are **0 values above 100%** (the maximum is exactly 100.0, with 261 observations at it) and **424 non-zero values below 1%** across 24 securities, not 88. The original 88 counted only decimal-valued sheets and missed the percentage strings. AGST.X0000 at 0.01% is real. Winsorise or exclude the sub-1% tail and say which. |
| 4.3 | C | 17 | Median float **25.0%** (25.23% excluding zeros); **49.96%** of observations below 25% (49.2% excluding zeros). Declare whether the stratification is float-adjusted and report both. |
| 4.4 | D | 16 + 03 to 05 | Interpolate shares outstanding between item 16's year-end anchors using the dated actions. **8.7% to 23.2%** of securities change issued quantity year on year, most years 10 to 17%. |

---

## Stage 5: index and market-state series

| # | Sev | Item | Fix |
|---|---|---|---|
| 5.1 | B | 11 | **[corrected]** Units change on 2025-01-02: turnover and market cap move from millions to rupees, shares from thousands to units. Turnover is additionally doubled 2025-07-28 to 2025-12-31. **Shares and trades are doubled 2025-07-28 to 2026-06-30** (shares return to thousands on 2026-01-02 but stay doubled). Market cap is not doubled. **The trade count is therefore not usable after 2025-07-27**, contrary to the original claim: it matches the panel on 100% of days from 2012 H2 to 2025 H1, 18 of 124 days in 2025 H2 and 0 of 117 in 2026 H1. Item 13 agrees with the panel (2025: 7,492,995 against 7,495,170; item 11 says 11,525,600). Derive all four series from the panel. |
| 5.1b | D | 11 | Market cap is stored in **billions** from 2020-05-11 to 2020-06-30 (2,128,266.8 then 2,044.8 then 2,404,131 on 2020-07-01), and the 2006-10-05 market cap is stored as text. |
| 5.2 | B | 07 | The S&P SL20 has **one** bad print, 2019-07-12 (2,613.99 to 5,569.94 to 2,643.02); 2019-07-15 is the valid correction, not a second defect. It alone produces 109.7% annualised 2019 volatility against 13.5% without it, and kurtosis of 821.0 against 21.8. The ASPI is clean across the window. |
| 5.3 | B | 09 | ASTRI has a **single** bad print at 2015-05-20 (2015-05-21 is valid). The SL20 TRI has three, on 2014-09-30, 2015-05-20 and 2017-07-19; its 2015-05-20 prints the same bad value as ASTRI's. A full-history scan adds ASTRI 2007-11-14, 2010-05-21, 2010-06-04, **2010-07-06 (+648%)** and 2010-09-28, plus SL20 TRI 2012-07-10. ASTRI's 2008-11-10 is stored as text, and there is a GICS note row at row 3844. Scan each series separately. |
| 5.4 | C | 07, 09, 11 | S&P SL20 and its TRI both start 2012-06-27. Begin SL20 analysis at 2012-07-01. |
| 5.5 | C | 07, 09 | Milanka ends 2023-03-31 and MTRI ends 2025-03-28. MTRI is also blank from 2013-01 to 2017-03, so it is unusable as a continuous series regardless. |
| 5.6 | D | 07, 09, 11 | On 2026-01-07, the halt day: item 11 carries a **text note** ("Market Halted...") with the other columns blank, not an all-null row; item 07 repeats the previous ASPI and sector values but leaves SL20 blank; item 09 blanks ASTRI and SL20 TRI but carries the sectors forward. It is already excluded from `trading_days_all.csv`. |
| 5.7 | D | 39 | All five GICS sheets run 2016-04-05 to 2026-06-30. Sector controls cannot be continuous across the window without a stated break, and item 07's own sector scheme changes at 2020-01-02 (see 0.7). |
| 5.8 | D | 13 | The 2026 "Trades (No) Equity" figure is in millions (4.046958) while "Foreign (No Mn)" holds a raw count (884,877,521). |

---

## Stage 6: verification

| # | Sev | Check |
|---|---|---|
| 6.1 | B | Apply each year's splits, bonuses, scrip dividends and final rights allotments to item 16's year-end share count and confirm against the next year-end. Per security per year, not in aggregate. |
| 6.2 | B | Reconcile annual panel turnover against item 13. The existing extraction achieves 0.13% for every year except 2016 at 0.8%; any regression is a new bug. |
| 6.2b | C | Items 07 and 11 agree exactly on the ASPI for all 3,443 dates from 2012 to 2026-06-30, with 2026-01-07 present only in item 07. In 2011 Q1, 54 dates differ by rounding of 0.05 or less. No action; recorded so it is not re-investigated. |
| 6.3 | D | Re-check the panel against `historical_trades/` after adjustment. The existing 99.93% close agreement on 817k rows is the baseline. |
| 6.4 | D | Report, for every spread series, the fraction of non-positive squared estimates. It is the only visible signal that EDGE's truncation bias is distorting the result. |

---

## Open question to settle before any spread is computed

2.1 establishes that 99.9% of close-outside-range rows carry the **previous day's close**. Ardia et al. treat non-transaction prices as missing and drop them. But a stale carried-forward close is precisely what their $\tau_t = 0$ flag exists to identify, so these rows may belong in the estimator as $\tau_t = 0$ observations rather than being excluded. The two treatments give different usable sample sizes and different discreteness corrections, and the choice is not obvious from the paper. Settle it explicitly, document the reasoning, and report the sample size both ways.

---

## Decisions to record

- Analysis window 2012 to 2026 H1, with 2001 to 2011 held as an untouched stress-test sample. Note the 2010 tick regime (2.5) if that sample is used.
- Liquidity stratification by quintile rather than pooled.
- Candidate universe of 234 voting securities trading on at least 60% of days with at least 2,000 aligned days.
- EDGE aggregation window quarterly; per 2.3 only one or two securities need special handling, not 24.
- EDGE period 2019 to 2024 plus 2026 H1, non-contiguous, with CHL elsewhere (2.2).

---

## Checks run and found clean

No duplicate rows, negative values or high-below-low rows in the official panel. Trade count 100% populated from 2012. The volume-weighted price implied by turnover divided by share volume sits inside the high-low range on **99.82%** of rows (1,713 of 970,264 outside), which confirms the published close is the anomalous field in 2.1 rather than the high, low or volume. Items 07 and 11 agree on the ASPI.

## Not yet examined

Content of items 10, 14, 20, 22 to 27, 29 and 38, and the PER, PBV, DY and Market Cap sheets of item 39, checked for structure and coverage only. Items 30 and 31 (1991 to 2010) not examined. Item 37 has no 2024 Q2 rows, which has not been investigated. Item 16's 2026 sheet is dated 2026-06-30. Given that every file examined so far has carried at least one defect, do not assume the unexamined ones are clean.
