---
title: Dataset Reconciliation
created: 2026-11-01
revised: 2026-11-01
status: settled
written_against: "Supervisor Meeting Notes/24-10-2026.md §7; PoC Data Build.md; Matrices/Consolidated Research Matrix.xlsx [Dataset]"
---

# Dataset Reconciliation, 1 November 2026

## 0. What this note is

`24-10-2026.md` §7 raised a Critical inconsistency: the proposal notes and the deck quote a universe of 355 securities, while the Dataset sheet of the consolidated matrix carries 323. It also raised two High items that turn out to share the same root cause, a Decision field contradicting its own Verification Status on D24 and D25, and a licensing position in note 19 that the matrix did not support.

The finding was correct, but the diagnosis implied in §7, that one of the two numbers is stale, is wrong. Both numbers are right. They describe two different datasets, and the matrix had a row for only one of them.

This note states the reconciliation, records the universe and record chains in full so the figures can be re-derived, lists the corrections applied to the Dataset sheet, and flags the one residual that does not close.

## 1. The root defect

There are two independent CSE price datasets in this project.

| | D22 | the base panel |
|---|---|---|
| Route | CSE public JSON API, extracted by me | CSE Data Library, purchased |
| Securities | 323 (283 .N, 21 .X, 2 .P, 17 .R) | 359 raw, 357 in-window |
| Observations | 829,070 | 864,264 |
| Licence | undocumented endpoint, no published terms | licensed purchase, student rate, non-commercial |
| Role to 2026-10-23 | primary | did not exist |
| Role from 2026-10-24 | cross-check | primary |

The Dataset sheet had a row for D22 and no row at all for the official extraction. So the matrix could only report 323, while every figure downstream of the build, in the notes, in the PoC specification and on the deck, comes from the official panel. The absence of the row is the defect. The numbers were never in conflict.

Demoting D22 also resolves the licensing item. Note 19 argues the responsible-practice position on the ground that the data was purchased rather than scraped. That argument only holds while the licensed panel is the base panel, which it has been since 24 October, and the matrix now says so.

## 2. Universe chain, official panel

Each step names its exclusion. Source: `PoC Data Build.md` §58-59, §91, §212.

| Step | Count | What was removed |
|---|---|---|
| Raw equity securities in the extraction | 359 | |
| less last traded before the window | 357 | HDEV and SUGA, both last traded November 2011. 333 voting, 24 non-voting. |
| less fewer than 60 aligned trading days | 356 | 1 security |
| less register-incomplete | 355 | DOCK, dropped 2026-10-24. Its December 2025 capital change proved to be a rights issue absent from register item 04, DC-33. |
| **Core universe** | **355** | |
| less eligibility screen | 233 | 122 securities failing either limb: traded on under 60% of aligned days, or under 2,000 aligned days in total. |
| **Final eligible / candidate set** | **233** | |

355 and 233 are both correct and they are not interchangeable. 355 is the cleaned panel that the adjustment and corporate-action work runs over. 233 is the screened set the agents are allowed to trade. Quoting one where the other belongs is the error to watch for, and it is the same error that produced the earlier 234 figure now corrected throughout.

The rights, warrant, preference and unit instruments that appear in D22 do not appear in the official extraction at all. That, not a filtering difference, is most of the gap between 323 and 357.

## 3. Record chain, four distinct populations

These four numbers are frequently mistaken for variants of one another. They are not.

| Count | What it is |
|---|---|
| 864,264 | every row in the official panel, before any universe restriction |
| 853,535 | rows inside the 356-security cleaned universe |
| approx. 817,000 | rows matched to D22 for the cross-check. This is the population the 99.93% close-agreement figure was measured over, and it is the only one of the four that figure may be attached to. |
| 829,070 | D22. A different dataset, not a subset or superset of the others. |

## 4. Corrections applied to the Dataset sheet

Applied 1 November 2026. Superseded text was retained in each cell under `SUPERSEDED TEXT, KEPT AS RECORD:` rather than deleted, and every amended cell is marked `[RECONCILED 1 NOVEMBER 2026]`.

**New row, D27.** The official Data Library extraction, `extracted/daily_share_prices/`. Carries the universe chain of §2, the record populations of §3, the verification evidence, and the licensing position. Written to match D22's column conventions.

**D22, demoted.** Role & Modality moves from "THE PRIMARY DATASET FOR THIS PROJECT" to independent cross-check and coverage comparison, superseded 2026-10-24. Decision moves from "USE, this is the project's primary dataset" to use as cross-check, with its 323 securities labelled explicitly as the API universe. D22 is not deprecated: it is the second source behind the 99.93% agreement figure and the comparison that quantifies the coverage gap.

**D24, Verification Status.** Was "Contents not yet purchased or inspected" while this row's own Decision field already read "Obtained. Currently cleansing it." Corrected to purchased, delivered, inspected and verified. This is the §6.6 contradiction.

**D25, Verification Status and Decision.** Status was "Not obtained" against a Decision reading "Obatined". Status corrected to obtained, registers 01 to 05 delivered and used to build the adjusted panel on 2026-10-23. The typo is fixed and noted.

**D26, Size, Known Gaps, Verification Status and Decision.** Size cited D22 and now cites D27. Status moves from "Does not exist yet, BUILD after D25 arrives" to built 2026-10-23 in `extracted/adjusted/`, 31 register corrections each confirmed against both price and issued quantity. The detect-and-exclude workaround is withdrawn. What survives as a limitation is narrower and is recorded as DR10: no documented ex-dates in the registers, so ex-dates were recovered from measured price drops with 259 events marked approximate in `corporate_actions.csv`.

**D17, Size.** Cited D22's 323 securities and 829,070 observations. Retargeted to the official panel, 355 core over 853,535 universe rows. D17's own Verification Status is unchanged: the per-counter liquidity profiling is genuinely not yet computed, and it must be run against this panel.

## 5. Residual that does not close

`PoC Data Build.md` records 46 voting and non-voting securities present in the official panel and absent from the API, described as a 12.8% gap. 46 of 359 is 12.8%, so the denominator used was the raw count.

That does not reconcile with the other figures. Official in-window is 357. D22's voting plus non-voting count is 304 (283 .N plus 21 .X). The difference is 53, not 46.

I have not resolved which of the three figures is the one in error. The candidates are that the 46 was measured against a pre-cleaning snapshot of the API extraction, that it counted only securities with overlapping trading activity rather than all absent securities, or that the 12.8% was computed against 359 when it should have been against 357.

Until that is settled, the 46 and the 12.8% should not be quoted in the proposal, the deck or the report. The coverage-gap argument does not depend on the exact figure: it holds on the qualitative point that the official panel carries securities the API route does not, across a span that includes the sovereign default. State it that way until the arithmetic closes.

## 6. What this leaves open

| Item | Status |
|---|---|
| D17 per-counter liquidity profiling | not computed. Run against D27. |
| The 46 against 359 residual | §5. Do not quote the figure. |
| D22 licence terms | still unconfirmed. No longer on the critical path, because D22 is no longer the base panel, but it remains unconfirmed and the row says so. |
| Listing and delisting register | not available in any of the forty purchased items. Survivorship is proxied by series-end dates and the residual bias is reported, not eliminated. |
| Bid, ask and depth | not available in any purchased item. The cost work runs on illiquidity proxies, and that is a stated limitation rather than a gap to be filled. |

## 7. Figures to use

For quick reference, the figures that are now settled and may be quoted:

- 359 raw, 357 in-window, 356 cleaned, **355 core**, **233 eligible**
- 864,264 panel rows, **853,535 universe rows**, approx. 817,000 matched for the cross-check
- 99.93% close agreement over the matched rows, 99.82% implied VWAP inside the daily range
- turnover reconciled to the published annual figures at 0.13%, except 2016 at 0.8%
- 3,920 trading days, matching the Data Library annual market-day figure and the exchange annual reports across all 17 years
- 54,796 of 853,535 rows, 6.42%, carry a close outside the day high-low range; 99.9% of those equal the previous close, retained with a flag
- 31 register corrections, 259 approximate ex-dates
