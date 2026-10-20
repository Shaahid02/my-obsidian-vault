---
status: current
created: 2026-10-20
written_against: "[[Data Cleaning Checklist]]"
tags:
  - working-doc
---
*Created 20 October 2026. What a four-agent PoC requires from the data, in dependency order, with $A_F$ built last. Written against [[Data Cleaning Checklist]], [[Dataset Profile 2026-10-20]], [[Data Library Profile Items 01-39]] and the `FYP Dataset` repository. Schedule is deliberately absent: this note is about order and precondition, not dates. Sentiment is out of scope throughout.*

---

## 1. The shape of the job

The agents are not where the work is. Three of the four run on a handful of columns once those columns are correct, and all three are gated by the same six data artefacts. $A_F$ is gated by something else, which is that its corpus has not been collected.

```
A0 loaders  ──►  A1 master + calendar  ──►  A2 adjusted panel ─┬──► A_T
                                                                ├──► A_V
                   A3 shares outstanding ───────────────────────►│
                   A4 crossing-stripped volume ─────────────────►├──► A_L
                   A5 float ─────────────────────────────────────┤
                   A6 spread, EDGE and CHL ─────────────────────┘

                   A7 filings corpus ────────────────────────────►  A_F
```

Nothing in A2 to A6 can be reordered. A7 is independent of all of it and can run in parallel from the start, which is the argument for beginning the harvest early even though $A_F$ is built last.

---

## 2. A0. Loaders

One loader per Data Library item, each asserting an expected row count and date range. Seven items change layout, units or meaning partway through their own history, and three of those fail silently rather than loudly ([[Data Cleaning Checklist]] 0.1).

| Item | The trap | Severity |
|---|---|---|
| 16 | The 2014 sheet keys issued quantity by bare company code, 287 of them with no full IDs. 2005 to 2013 and 2015 onward use `AAF-N-0000`. A reader built for the neighbours returns nothing for 2014 | Blocking |
| 17 | Three header variants, not two, and three sheet-name styles. Percentage strings begin 2016 Q4, but 2018_Q3, 2020_Q3 and 3-2022 revert to decimals and 2020_Q2 is mixed. 2020_Q1 is a COVID note with no data | Blocking |
| 37 | Date formats are not sequential by era. `M/D/YYYY` appears in 2012 to 2015 and again in 2017 and 2019. The QUARTER column is the cheapest validation | Blocking |
| 07 | **A second header block at row 8380.** From 2020-01-02 the sector columns switch from the old scheme to GICS, with nothing in the data to signal it. Date, ASPI and SL20 keep their meaning. Any sector series read straight down this file across 2020 is two unrelated index families concatenated | Blocking |
| 21 | Four layouts, not three. Voting and non-voting cannot be separated before 2017, so take those years from item 16 | Degrading |
| 01 to 05 | Mixed date types within a single column. Item 01's 2021 DATE OF EX holds 105 serials and 105 strings. Some carry trailing non-breaking spaces | Degrading |
| 39 | Market Cap sheet column D rows 2365 to 2425 are date-formatted and read as errors unless raw values are requested | Degrading |

> The checklist's own framing of why these matter is worth keeping in front of the build: the three errors found in the original checklist all came from checking that a field existed and had a plausible magnitude, without checking that it carried information or was internally consistent at a small multiple.

---

## 3. A1. Security master and calendar

| What | Detail |
|---|---|
| Base panel | `extracted/daily_share_prices/`, not `historical_trades/`. 46 N and X securities are in the official panel and absent from the API, a 12.8% gap of 359. The API-only route would exclude them, and that exclusion spans a sovereign default |
| Universe | 359 equity securities profiled, 335 voting and 24 non-voting. 356 have at least 60 aligned days, giving 853,577 rows. Rights, warrants, preference and unit instruments excluded |
| Listing and delisting | Item 06 was never supplied. Reconstruct dates from first and last appearance across the yearly files. Reasons are not recoverable, so voluntary delistings cannot be separated from failures. Report that as a residual limitation rather than carrying it silently |
| Name crosswalk | Build company-name to security-ID from item 16, across all years. Items 02, 03 and 04 carry only Company or Name columns, so without this the three largest share-count actions cannot be joined at all |
| Calendar | 3,920 validated trading days, 2010 to 2026-06-30, matching both the Data Library annual Market Days figure and the annual reports for all 17 years. Forward-fill for the $\tau_t$ construction and keep a traded flag, so a zero-volume day stays distinguishable from a non-trading day |

---

## 4. A2. The adjusted price panel

The precondition for every return, and therefore for all four agents and the whole evaluation layer. This is a reconstruction with five inputs that behave differently, not a single script.

### 4.1 The five actions

| Item | Keyed by | Joins cleanly? | Notes |
|---|---|---|---|
| 05 splits | Company ID | Yes | 93 splits 2012 to 2026. 145 of 149 line up with a one-day drop above 25% within seven days of the recorded effective date. The four misses are JKH twice and SAMP in 2010, small ratios where no 25% drop is expected, and SING in 2021, which shows no drop and is worth checking |
| 01 dividends | Security ID | Yes | Carries rate, ex-date, payment date, cum and ex price. Roughly 210 announcements a year, on the order of 3,000 across the window |
| 03 bonus issues | Company name | No | Needs the crosswalk |
| 02 scrip dividends | Company name | No | Needs the crosswalk |
| 04 rights issues | Company name | No | The hardest of the five. See below |

### 4.2 Rights issues, the hard case

A rights issue is not a pure ratio, because shareholders pay cash below market, so the price adjustment runs through the theoretical ex-rights price:

$$TERP = \frac{N \cdot P_{cum} + S \cdot X}{N + S}, \qquad \text{factor} = \frac{P_{cum}}{TERP}$$

Item 04 supplies $X$ for 217 of its events and supplies neither the ex-date nor $P_{cum}$. Three problems, each with a route through:

**The proportion column is corrupted.** 87 cells are formatted `h:mm`, across 2008 to 2010, 2012 to 2015 and one in 2024. Six cases cannot be recovered from the cell at all. Derive the ratio from provisional allotment divided by shares in issue at that date, using the item 16 anchors, and use item 04's proportion only as a sanity check on the derived value.

**Provisional and final allotment diverge.** 43 of 192 events, 22.4%, with minimum take-up 6.44% at Blue Diamonds non-voting in 2023. The two figures do different jobs: the price adjustment on the ex-date uses the **announced** terms, because that is what the market priced on the day, and the share count uses the **final** allotment, because that is what was issued. One number for both is wrong in roughly a fifth of events and badly wrong in the worst cases.

**The ex-date is recoverable from the rights securities.** Cluster each `.R` series into episodes by trading gap. 267 episodes, of which 75.3% are exactly 6 traded days and 83.5% span 6 trading days, the rest running 1 to 5, 8 or 11. The first day of an episode is the ex-date in practice. $P_{cum}$ is then the underlying's close on the prior trading day, which the panel already holds.

> **Conflict between the two profiles, and it changes the result.** [[Data Library Profile Items 01-39]] §7 states that R0000 and R0001 pairs carry identical episode dates and are the voting and non-voting rights of the same issue, so should not be counted twice. [[Data Cleaning Checklist]] 3.5 found that of 16 R0001 files only 10 share their R0000's dates: CDB, SHOT and TESS overlap partially, AAF and VLL never overlap and are separate issues, and NTB has an R0001 with no R0000. The checklist is the merged and cross-checked version, so **pair by date and do not assume**. Assuming the pairing double-counts some issues and misses others.

An `.R` symbol is a company marker rather than an event key in any case: ACME.R0000 covers 4 issues and CRL.R0000 covers 8.

### 4.3 Before building the adjustment table

Inspect the seven securities carrying anomalous counts of one-day moves above 35%, because feeding them to an adjustment routine unexamined will generate factors from what are probably price-scale or low-price oscillation artefacts.

| Symbol | Moves > 35% | Symbol | Moves > 35% |
|---|---:|---|---:|
| SEMB.X0000 | 302 | CSF.N0000 | 60 |
| BLUE.X0000 | 127 | ASPH.N0000 | 55 |
| PCH.N0000 | 78 | AINV.N0000 | 47 |
| PCP.N0000 | 64 | | |

Overall there are 1,076 such moves across 366 securities, or 344 across 184 for N and X from 2012.

### 4.4 The check that validates the whole chain

Apply each year's splits, bonuses, scrip dividends and final rights allotments to item 16's year-end share count and confirm against the next year-end. **Per security per year, not in aggregate**, because offsetting errors cancel in a total. Any residual points at a missed or misdated event. There are 15 annual anchors inside the window, so the actions interpolate between known endpoints rather than extrapolating from one.

---

## 5. A3 to A6. The liquidity stack

$A_L$ sits on four artefacts, and three of them change the answer rather than refine it.

### A3. Shares outstanding

Item 16 year-end anchors interpolated with the dated actions from 02 to 05. Between 8.7% and 23.2% of securities change issued quantity year on year, most years 10 to 17%, so roughly 45 securities a year and on the order of 600 change events across the window. Item 21 adds a year-end price and market cap but is not float-adjusted, and is company-level in two different layouts before 2017.

### A4. Crossing-stripped volume and turnover

Item 37 holds individual crossing trades with a trade date, security ID, price and quantity: 26,096 trades across 10,711 distinct security-date pairs. It can be stripped at daily per-security granularity.

**Why this is not optional.** Crossings run from 8.8% of annual market turnover in 2021 to 47.4% in 2017, and per security over the whole period the median is 15.8% with a 90th percentile of 53.6%. Amihud, relative volume, turnover ratio and trade intensity all divide by volume they assume is continuous order-book trading. A crossing is a pre-negotiated transfer that consumed no book depth, so a counter whose turnover is heavily crossed looks liquid on those measures without being liquid. Left uncorrected the liquidity state is systematically wrong for roughly a third of the universe, in the direction of overstating liquidity.

**Mechanics.** Subtract with a floor at zero and flag the exceptions rather than letting volume go negative: on 90.7% of crossing security-days the crossing quantity is at or below panel volume, median ratio 0.751, and on 9.3% it exceeds. Resolve the above-100% cases first, since the fix differs by cause: AGST.X0000 at 144.7%, SHAW.N0000 at 110.9% and MERC.N0000 at 102.1% are impossible if crossings are a subset of reported turnover, so either they are partly additive or there are date or symbol mismatches between the two files.

**The contamination is bounded.** 20.3% of 25,901 crossings price outside the day's high-low range, so crossings are excluded from the high-low calculation while being included in volume. EDGE's inputs are open, high, low and close, which are board-only and uncontaminated. The crossing problem is confined to Amihud, relative volume and turnover ratio.

The per-security figure is sensitive to the variant chosen: volume-based gives 15.9%, including never-crossed securities gives 2.7%, and a per-security-year median gives 23.5%. State which was used.

### A5. Float

Item 17, quarterly, 2012 to 2026 H1. 283 observations are exactly 0 and must be treated as missing rather than as a value, or any float-adjusted ratio divides to infinity. There are 0 values above 100%, the maximum being exactly 100.0 with 261 observations at it, and 424 non-zero values below 1% across 24 securities. Winsorise or exclude the sub-1% tail and say which. Median float is 25.0%, and 49.96% of observations sit below 25%.

> **Float adjustment is a methodology decision, not an implementation detail.** Comparing raw median daily turnover against turnover divided by float, the least-liquid quintile retains only 69% of its membership. Nearly a third of the bottom quintile changes identity depending on which measure is used. My reading is that float-adjusted turnover is the better measure of tradeable liquidity on a market where half the counters have under a quarter of shares in public hands, but the raw version belongs alongside it as a robustness check, and the choice has to be declared rather than inherited from whichever the code happened to implement.

### A6. Spread

**The window is non-contiguous, and this is the finding that affects protocol design.** The open field is populated from 2017, but in 2017, 2018 and 2025 every open equals that day's close, so all open-based terms in EDGE collapse to zero identically and the estimator returns numbers without erroring. Genuinely informative opens exist for 2019 to 2020, 2021-04 to 2024-12 and 2026 H1, with the cleaned layer extending coverage through tagged API and TradingView fills.

So the usable EDGE period is roughly six years with **2025 as a hole in the middle**. Any walk-forward design assuming an unbroken sequence needs reworking rather than patching. Use CHL where the open is absent or degenerate, and report EDGE and CHL separately rather than splicing them into one series.

Report, for every spread series, the fraction of non-positive squared estimates. It is the only visible signal that the truncation bias is distorting the number.

---

## 6. The decision that has to be settled before any spread is computed

54,796 of 853,577 rows, 6.41% from 2012, carry a close outside the day's high-low range. The median trade count on a violating day is exactly 1 in every liquidity quintile, and deviations are small, median 0.44% of price.

**The key fact is that 99.9% of violations, 55,354 of 55,410, have close equal to the previous close.** These are stale carried-forward reference prices rather than erratic ones, which looks like the CSE closing-price rule producing a reference price instead of a transaction price on days with negligible trading. It appears in the official files, so it is not an extraction defect.

Ardia, Guidotti and Kroencke treat rows where the open or close falls outside the high-low range as missing and drop them. But a stale carried-forward close is precisely what their $\tau_t = 0$ flag exists to identify, so these rows may belong in the estimator as $\tau_t = 0$ observations rather than being excluded. The two treatments give different usable sample sizes and different discreteness corrections, and the choice does not follow from the paper.

**Settle it explicitly, document the reasoning, and report the sample size both ways.** The exclusion rate is itself a measurement worth reporting per security and per stratum: the frequency with which a CSE price is not transaction-based is a candidate staleness variable with a cleaner interpretation than zero-return frequency. I have not found that quantified for the CSE in the literature covered so far, and it should be stated as a measurement on this dataset rather than as a general claim about the market.

---

## 7. What each agent needs once the artefacts exist

### $A_T$ technical

The adjusted panel, plus a decision about opens. Real-open coverage in the cleaned layer is 84.2% overall: 100% for 2019 to 2026, 86 to 92% for 2012 to 2018, and 0% for 2010 to 2011. Opens are tagged with `open_source`, so the robustness check the repository already suggests is cheap: run once with `official` opens only and once with all sources. The previous close is not available as a proxy and should not be introduced as one, since it equals the real open on 25.4% of days with a median error of 1.04%.

Price granularity breaks at 2021-01. 2011 to 2016 and 2020 are entirely on a 10-cent grid, 2017 to 2019 are 0.01 to 0.03% off it, and 2021 onward runs 5.4 to 12.9% off it by year. Treat that as a structural break for any tick-size or discreteness feature.

### $A_V$ volatility

Range estimators need high and low from the adjusted panel. 121 rows have a blank high or low, 23 fully blank and 98 close-only, across 2014 to 2025.

At index level the ASPI is clean across the window and carries 15.1% annualised volatility, with annual figures running from 5.6% in 2017 to 31.6% in 2022. That is a factor of 5.6 between the quietest and the most volatile year, with the regimes falling where expected, so the regime variable has real variation and does not need hand-dating.

The S&P SL20 has one bad print at 2019-07-12, which alone produces 109.7% annualised 2019 volatility against 13.5% without it, and kurtosis of 821 against 21.8. ASTRI has a bad print at 2015-05-20 and several more outside the window. Repair or exclude before use, and scan each series separately.

**For $P_t$, the persistence term has something to estimate on this sample.** GPH at $m = 58$ on the ASPI 2012 to 2026 gives $\hat{d} = 0.407$ on absolute returns and 0.364 on squared returns, both more than two standard errors from zero, against $-0.084$ on returns themselves as a negative control. Absolute returns still show autocorrelation of 0.108 at a one-year lag. This is a feasibility result on one index and one sample, and should be scoped to that rather than presented as a characterisation of the market.

### $A_L$ liquidity

Everything in §5, plus the $\tau$ and stratification material from [[Dataset Profile 2026-10-20]] §2 and §4, which the cross-check did not disturb:

| Quintile | Median daily turnover | Trading frequency | $\tau = 0$ | Median trades/day |
|---|---:|---:|---:|---:|
| Q1 least liquid | Rs 19,475 | 60.5% | 43.5% | 4 |
| Q3 | Rs 145,514 | 93.0% | 13.9% | 13 |
| Q5 most liquid | Rs 2,230,554 | 99.5% | 1.6% | 44 |

A factor of 114 in turnover and 27 in the $\tau = 0$ rate between the extremes. A pooled estimate would conceal the regime the contribution is about, so stratify rather than average. Median annualised volatility runs 58.0% in Q1 down to 42.2% in Q5, so the least liquid counters are also the most volatile, which is the combination $A_V$ and $A_L$ are supposed to handle jointly.

Candidate universe: 234 voting securities trading on at least 60% of days with at least 2,000 aligned days, which supports a five-stratum design with roughly 45 securities per stratum and lets the stratum be an experimental factor rather than a robustness note.

### $A_F$ fundamental

**No corpus exists for this agent, and that is the thing to start early even though the agent is built last.**

The repository's `CSE Annual Reports/` holds the exchange's own annual reports for 2012 to 2025, which were used to validate market-day counts and turnover. Those are not listed-company filings. Per-company reports have not been collected, and both profiles state $A_F$ was out of scope by instruction, so nothing has been profiled for it.

What the harvest needs:

| Requirement | Why |
|---|---|
| Per-company report PDFs | The framework's only text modality after the September scope decision, so it carries the heterogeneity claim |
| A publication-date field on every document | The as-of cursor has nothing to filter on otherwise. The documented failure case on this market is a static snapshot with no as-of field |
| Link harvesting from the announcements feed | Filenames are opaque id and timestamp pairs, so links cannot be enumerated |
| Text-native rather than scanned | Older filings, roughly pre-2015, are more likely scanned, which is the OCR failure mode that breaks element-based chunking |

Expected coverage should be written as a hypothesis rather than a fact: $A_F$ may have low usable coverage on numerically demanding CSE questions, based on benchmark evidence from other financial-QA pipelines. Measure it with a probe set rather than importing the benchmark figure as a CSE result.

---

## 8. Decisions to record before building

| # | Decision | Consequence of leaving it open |
|--:|---|---|
| 1 | Close-outside-range rows: drop, or admit as $\tau_t = 0$ | Changes every spread estimate and every usable sample size |
| 2 | Float-adjusted or raw liquidity stratification | Changes 31% of the bottom quintile's membership |
| 3 | Panel end at 2026-06-30, or splice the API to 2026-10-02 | Decide on source-consistency grounds. The original reason given for truncating, two different open definitions, was wrong |
| 4 | How walk-forward handles the 2025 EDGE hole | A protocol assuming contiguity will silently train across a gap |
| 5 | Crossings above 100% of panel turnover: additive, or a join defect | The fix differs by cause, and the subtraction cannot be built until it is known |
| 6 | Non-trading day representation | Forward-fill for $\tau_t$ and keep the traded flag, per 1.4 |
| 7 | Benchmark series | ASTRI rather than ASPI, since the price index excludes dividends |

---

## 9. Where [[Dataset Profile 2026-10-20]] is superseded

[[Data Cleaning Checklist]] merged the independent cross-check and is the later document. Where they disagree the checklist's recomputed figures are used, since they were verified against the panel at commit `74f3029` with stated parsing choices. Five profile figures should stop being quoted.

| Profile | Claim | Replaced by |
|---|---|---|
| §1 | Opens 100% present from 2017, so EDGE runs 2017 onward | Opens are degenerate in 2017, 2018 and 2025. EDGE runs 2019 to 2020, 2021-04 to 2024-12 and 2026 H1, non-contiguous |
| §3 | Least-liquid quintile violation rate 25.4% | 15.4%. No quintile definition tried exceeds 21.5% |
| §5 | 24 securities below 10 EDGE observations per quarter, 6 below 3 | 2 and 1 among N0000, 3 and 2 including X. The original averaged over quarters before each security listed. No separate annual-window track is needed |
| §6 | 14.7% survivorship uplift | 12.8%, 46 of 359. The original used the API count as the denominator. 5 of the 44 still trade in 2026, so "delisted" is loose |
| §7 | 1,567 moves above 35% across 170 securities | 1,076 across 366 overall, or 344 across 184 for N and X from 2012. The seven named securities carry lower counts than first reported |

Profile §2 on $\tau$, §4 on stratification and §8 on items 16 and 21 were not disturbed by the cross-check and stand.

Separately, [[Data Library Profile Items 01-39]] is superseded on rights pairing (§4.2 above), on rights event count, 225 against the checklist's 192 once 38 sector-summary rows are excluded, and on the per-security crossing median, 12.5% against 15.8%.

---

**Related notes.** [[PoC Specification]] for what the PoC is and what counts as it succeeding. [[PoC Build Plan]] for the reduced build and the reconciliation with the panel feedback. [[Research Gap]] and [[Contribution to Knowledge]] for what this produces.

**Language discipline applies here too.** No "first", "nobody", "never". The permitted form is *"I have not found that evaluation in the literature I have covered."* The agent set and the conditioning set remain provisional. Figures here are measurements on this dataset over this window and should be scoped to it.
