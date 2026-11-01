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

This note states the reconciliation, records the universe and record chains in full so the figures can be re-derived, lists the corrections applied to both `Matrices/Consolidated Research Matrix.xlsx` and its mirror `Matrices/Dataset Comparison Matrix.xlsx`, records a coverage gap in the panel that the headline figures hide, and flags the one residual that does not close.

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

### 4.1 The same corrections in `Dataset Comparison Matrix.xlsx`

That file is a standalone mirror of the Dataset sheet, and its own Read Me states that where the two disagree the Consolidated Research Matrix is the source. Checking it cell by cell confirmed it was a faithful mirror: before this pass the only divergences were the five cells above, plus one.

The exception is D24's Decision field, which had drifted independently of anything in this reconciliation. The consolidated file read "Obtained. Currently cleansing it." while the mirror still read "BUY, the full set at the student rate", which is the pre-purchase decision. Both are now set to the same current statement, with both superseded values recorded. This is a second instance of the §6.6 pattern: a Decision field left at the value it had when the decision was taken, rather than updated when it was carried out.

The mirror also carries a Read Me whose summary section was written on 18 October and states four things the reconciliation falsifies: that the project's own API extraction is the primary dataset, that the adjusted series does not exist and is the highest-priority item, that there is effectively one viable per-ticker price source, and that licensing attaches to the primary dataset. All four are corrected in place with the superseded text kept, and a dated revision block is appended. A fifth claim, that Data Library items 30 to 33 stop at 2025 and serve as a cross-check, is corrected too: they are the base panel and their closes run to 2026-06-30.

The two files are now identical across all 19 rows and 23 columns.

## 5. The opens are not covered like the closes

This is the gap most easily missed, because every headline figure in §2 and §3 is close-based and continuous, which makes the panel look uniformly complete. It is not.

Closes run 2012-01-02 to 2026-06-30 without interruption. Opens are blank or degenerate in 2017, 2018, 2021 Q1 and 2025. `PoC Data Build.md` §267 records the consequence: on official opens the EDGE spread estimator runs only 2019 to 2020, 2021-04 to 2024-12 and 2026 H1, which is non-contiguous. On the cleaned source-tagged layer, which blends D22 in to fill those periods, it runs from 2012.

Two things follow, and both are open rather than settled.

A walk-forward on the official layer that assumes contiguity would silently train across the 2021 Q1 and 2025 gaps. The fold protocol settled on 1 November specifies 1250-day train, 125-day test, step 125, 16 folds, and it is indexed on trading days rather than on calendar dates, so this does not break it. But any open-based feature inside a fold inherits the gap, and nothing currently checks for that.

Which layer feeds EDGE is open decision 4 in the build log. It is a genuine trade-off rather than an oversight: the cleaned layer buys seven more years of spread estimates at the cost of mixing a licensed source with an unlicensed one inside a single series, which is exactly the mixing that §1 argues against. The build log's own proposal, cleaned layer with an official-only robustness run, keeps the licensing argument intact because the headline result does not depend on the API. That looks right to me, but it is not my decision to record as made.

The panel end is open decision 3: stop at 2026-06-30, or splice D22 forward to 2026-10-02. The same mixing question applies.

## 6. Residual that does not close

`PoC Data Build.md` §270 records 46 voting and non-voting securities present in the official panel and absent from the API, a 12.8% gap, and explicitly notes that this denominator was already corrected once, from the API count to 359. So the 46 is not a first-draft figure; it has been checked.

It still does not reconcile. If 46 of the 357 in-window securities are absent from the API, then 311 are shared. But D22 holds only 304 voting and non-voting securities, 283 .N plus 21 .X. The shortfall is seven, and it points the wrong way: the API cannot share more securities with the panel than it contains.

Measuring against the 359 raw count makes it worse, not better, since that implies 313 shared.

So either D22's breakdown of 323 into 283 .N, 21 .X, 2 .P and 17 .R is wrong, or the 46 is, or the two were counted over different windows in a way neither figure records. I have not resolved which, and I would rather leave it visible than pick the reading that makes the arithmetic close.

Until it is settled, the 46 and the 12.8% should not be quoted in the proposal, the deck or the report. The coverage-gap argument does not depend on the exact figure: it holds on the qualitative point that the official panel carries securities the API route does not, across a span that includes the sovereign default. State it that way.

One figure that is affected and should also be held: §270 adds that 5 of the 44 still trade in 2026, so "delisted" is loose. That sentence uses 44 where the rest of the row uses 46, which is a third count in the same line.

## 7. What this leaves open

| Item | Status |
|---|---|
| D17 per-counter liquidity profiling | not computed. Run against D27, not D22. |
| The 46 against 359 residual | §6. Do not quote 46, 12.8% or 44. |
| Which price layer feeds EDGE | open decision 4. §5. Affects the licensing argument, so it is not purely technical. |
| Panel end, or splice D22 to 2026-10-02 | open decision 3. §5. |
| D22 licence terms | still unconfirmed. Off the critical path now that D22 is not the base panel, but unconfirmed, and the row says so. |
| Listing and delisting register | item 06 was never supplied. Dates reconstructed from first and last appearance; reasons are not recoverable, so voluntary delistings cannot be separated from failures. Reported as a residual limitation. |
| Bid, ask and depth | not in any of the forty purchased items. The cost work runs on illiquidity proxies. A stated limitation, not a gap to be filled. |
| The 374-trading-day figure | still present in the survey matrix, roughly 20 cells across 8 review notes. Superseded, correction outstanding. |

## 8. Figures to use

For quick reference, the figures that are now settled and may be quoted:

- 359 raw, 357 in-window, 356 cleaned, **355 core**, **233 eligible**
- 864,264 panel rows, **853,535 universe rows**, approx. 817,000 matched for the cross-check
- 99.93% close agreement over the matched rows, 99.82% implied VWAP inside the daily range
- turnover reconciled to the published annual figures at 0.13%, except 2016 at 0.8%
- 3,920 trading days, matching the Data Library annual market-day figure and the exchange annual reports across all 17 years
- 54,796 of 853,535 rows, 6.42%, carry a close outside the day high-low range; 99.9% of those equal the previous close, retained with a flag
- 31 register corrections, 259 approximate ex-dates

Figures to hold back until §6 closes: 46, 44, 12.8%. And remember that every figure above is close-based; §5 is why that distinction matters.
