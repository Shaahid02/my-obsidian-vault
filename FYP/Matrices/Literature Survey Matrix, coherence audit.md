---
status: current
revised: 2026-10-18
written_against: 59 reviews; Literature Survey Matrix.xlsx
tags:
  - working-doc
  - audit
---
# Literature Survey Matrix, coherence audit against the notes

*18 October 2026. Every row of `Matrices/Literature Survey Matrix.xlsx` checked against the literature review note its "My Note" column links to. This audits whether the matrix still reflects the notes. It does not re-verify either against the source papers.*

## The headline

**33 of 59 rows state "Not recorded in the note" in the Limitations column, and all 33 of those notes have a full Limitations section.** That is the single largest and least ambiguous problem. Limitations is the column a critical literature review leans on hardest, and on more than half the matrix it currently asserts the opposite of what the vault holds.

The affected rows are P01, P02, P03, P05, P06, P07, and then P26 through P52 almost contiguously.

## The pattern underneath it

The in-sync rows are **P04 and P08 to P25**, a contiguous block of 18. Essentially everything outside that block shows drift. That is the signature of a matrix populated in batches against different generations of the notes, rather than scattered individual errors. The Read Me's own provenance line says content is "drawn from the vault's own literature review notes, quoting my phrasing" — where the phrasing no longer exists in the note, the cell is quoting a superseded draft.

## The worked example

Row **P01** (TradingAgents) quotes "seven specialised roles feeding a fixed hierarchy" and "seven channels feeding a hierarchy with no weights and no ablation".

The note now reads: "eleven agents across seven specialised role types feeding a fixed hierarchy", and it explicitly warns that "the paper's headline figure of seven is a count of role *types* and not of agents". So the matrix does not merely use older wording, it carries the count the note was rewritten to correct.

## Other cells claiming the note records nothing

Sixteen beyond Limitations. Some are legitimate in substance but wrong in form: P58 and P59 say "not recorded in the note" for Sentiment Handling, where the honest cell is "None" because those papers have no sentiment component. Saying the note is silent and saying the paper does not do it are different claims, and only one of them is true.

Genuinely missing: **P26, P46 and P52 Key Results** (all three notes carry results), and **P57 Citation, Venue and Link** (the note has them).

## Quoted spans that no longer appear in their note

Of 1,950 quoted fragments checked, 478 did not match verbatim. Graded by how much of each fragment appears contiguously in the note:

| Band | Count | Reading |
| --- | --- | --- |
| ≥ 0.9 | 150 | punctuation or markup only, not findings |
| 0.5 to 0.9 | 55 | minor rewording |
| 0.2 to 0.5 | 83 | quote starts right then departs, note likely edited |
| < 0.2 | 190 | the sentence is not in the current note |

**Treat the bottom two bands as needing review, not as established errors.** A fragment absent from the note may have been quoted from the paper rather than the note, which the matrix's own convention permits in places. Spot checks suggest most are the author's own evaluative phrasing rather than paper quotations, which would make them note-sourced and therefore stale, but that was not established fragment by fragment.

## Reliability of this audit

Mechanical checks, run with search. During this session the same approach produced three false positives, including one where a claim was reported missing because the note wrote "18/19" and the search looked for "18 of 19". The Limitations finding is safe, because it compares a cell's explicit assertion against the presence of a section heading. The quote bands are weaker evidence and are labelled accordingly.

Two things this audit does **not** establish: whether any note is correct about its paper, and whether any matrix cell outside the quoted spans is factually right. Both were out of scope.

## Suggested order of work

1. **Fill the 33 Limitations cells.** Mechanical, high value, and the notes already contain the material as 5 to 6 argued bullets each.
2. **Fix the four genuinely empty cells**: P26, P46, P52 Key Results and P57's bibliographic three.
3. **Re-sync the under-0.2 quote band** on the stale rows, starting with P01, whose agent count is wrong rather than merely dated.
4. **Reword the "not recorded" cells that should read "None"** so the matrix stops conflating silence in the note with absence in the paper.

## Per-row verdict

| Row | Verdict | Limitations cell | Quotes absent | Quotes drifting | Other cells claiming the note is silent |
| --- | --- | --- | --- | --- | --- |
| P01 | STALE | **false** | 2 | 3 | — |
| P02 | STALE | **false** | 2 | 2 | — |
| P03 | STALE | **false** | 7 | 3 | — |
| P04 | IN SYNC | ok | 0 | 0 | — |
| P05 | STALE | **false** | 2 | 2 | — |
| P06 | STALE | **false** | 2 | 1 | — |
| P07 | STALE | **false** | 3 | 3 | — |
| P08 | IN SYNC | ok | 0 | 0 | — |
| P09 | IN SYNC | ok | 0 | 0 | — |
| P10 | IN SYNC | ok | 0 | 0 | — |
| P11 | IN SYNC | ok | 0 | 0 | — |
| P12 | IN SYNC | ok | 0 | 0 | — |
| P13 | IN SYNC | ok | 0 | 0 | — |
| P14 | STALE | ok | 8 | 2 | Sentiment Handling, Fundamental / RAG Handling |
| P15 | IN SYNC | ok | 0 | 0 | — |
| P16 | IN SYNC | ok | 0 | 0 | — |
| P17 | IN SYNC | ok | 0 | 0 | — |
| P18 | IN SYNC | ok | 0 | 0 | — |
| P19 | IN SYNC | ok | 0 | 0 | — |
| P20 | IN SYNC | ok | 0 | 0 | — |
| P21 | IN SYNC | ok | 0 | 0 | — |
| P22 | IN SYNC | ok | 0 | 0 | — |
| P23 | IN SYNC | ok | 0 | 0 | — |
| P24 | IN SYNC | ok | 0 | 0 | — |
| P25 | IN SYNC | ok | 0 | 0 | — |
| P26 | STALE | **false** | 6 | 2 | Key Results |
| P27 | STALE | **false** | 10 | 7 | — |
| P28 | STALE | **false** | 8 | 0 | — |
| P29 | STALE | **false** | 2 | 0 | — |
| P30 | STALE | **false** | 1 | 3 | — |
| P31 | STALE | **false** | 3 | 1 | — |
| P32 | STALE | **false** | 7 | 2 | — |
| P33 | STALE | **false** | 5 | 1 | — |
| P34 | STALE | **false** | 5 | 1 | — |
| P35 | DRIFTED | **false** | 1 | 1 | — |
| P36 | STALE | **false** | 6 | 4 | — |
| P37 | STALE | **false** | 10 | 2 | — |
| P38 | DRIFTED | **false** | 0 | 0 | — |
| P39 | STALE | **false** | 4 | 0 | — |
| P40 | DRIFTED | **false** | 1 | 0 | — |
| P41 | DRIFTED | **false** | 0 | 0 | — |
| P42 | STALE | **false** | 4 | 3 | — |
| P43 | STALE | **false** | 6 | 1 | — |
| P44 | STALE | **false** | 1 | 2 | — |
| P45 | STALE | **false** | 3 | 3 | — |
| P46 | STALE | **false** | 4 | 2 | Link / DOI, Dataset(s) & Period, Key Results |
| P47 | STALE | **false** | 3 | 4 | — |
| P48 | DRIFTED | **false** | 0 | 1 | — |
| P49 | DRIFTED | **false** | 0 | 0 | — |
| P50 | STALE | **false** | 5 | 2 | — |
| P51 | STALE | **false** | 5 | 1 | — |
| P52 | STALE | **false** | 14 | 3 | Key Results |
| P54 | STALE | ok | 3 | 4 | — |
| P55 | DRIFTED | ok | 3 | 1 | — |
| P56 | STALE | ok | 10 | 6 | Citation |
| P57 | STALE | ok | 13 | 3 | Citation, Venue / Type, Link / DOI |
| P58 | STALE | ok | 4 | 0 | Sentiment Handling, Liquidity & Friction Handling |
| P59 | STALE | ok | 14 | 7 | Sentiment Handling |
| P60 | STALE | ok | 3 | 0 | Volatility & Risk Handling, Explainability |