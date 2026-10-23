---
status: current
created: 2026-10-23
written_against: "[[_Corpus Index]]; [[Research Matrices Status]]; [[Zotero Integration Setup]]; [[29-09-2026]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 21 of the PP live presentation template. This criterion is worth 5 percent and the material behind it is strong, so the work is mostly mechanical. One genuine open item sits inside it, which is the citation style. Sentiment is out of scope throughout.*

---

## Why this note exists

The criterion assesses three things: appropriate attribution, a complete and consistent reference list, and **a clear distinction between sourced evidence and the student's own analysis**. The third is the one that is usually weakest and is the one this project is best placed on, because keeping a paper's claim, its evidence and my reading of it visibly separate is already a standing rule across every review note.

The template's own instruction adds that citations belong wherever a claim is made, not collected at the end, and that AI is not cited as academic evidence.

---

## Part 1. What the reference base looks like

| Measure | Value |
|---|---|
| Reviewed papers in the corpus | **59**, all complete |
| Missing a citekey | 0 |
| Reference manager | Zotero with Better BibTeX, exporting to a library file in the vault |
| Approximate preprint count | Around 14 |
| Quoted spans in the survey matrix, all verbatim against their notes | 1,621 |

**Venue spread across the corpus** includes machine learning and natural language venues, forecasting and operational research journals, and finance journals. The supervisor's instruction at [[29-09-2026]] §4.3 is the one to follow on the slide: anchor central novelty claims primarily in peer-reviewed work rather than in preprints alone, and the roughly 14 preprints are flagged rather than hidden.

---

## Part 2. Citation style

> [!WARNING]
> <font color="#ff0000">Open item.</font> The template says to use Harvard or the required institutional style. The vault does not record which one this submission requires: [[Zotero Integration Setup]] says only to set the Quick Copy format to "the citation style the proposal needs", which was never resolved. Confirm it before the deck is built, because changing it afterwards means regenerating every in-slide citation.

Default position if no instruction surfaces: **Harvard**, as the template's own first-named option, applied consistently across in-slide citations and the reference list.

---

## Part 3. What gets cited on which slide

Citations belong where the claim is, so this is a checklist rather than a principle.

| Slide | Claims needing a citation |
|---|---|
| 3 problem | All five documented failure cases, and every CSE market-structure figure |
| 4 evidence to gap | Each of the six contrasted systems, plus the forecast-combination review |
| 5 literature | The theme clusters, with the corpus counts labelled as counts of my own corpus rather than of the field |
| 6 contribution | The named ancestor method, and each system a clause is defined against |
| 8 baselines | Every system in the comparison table, plus the local baseline with its reported in-sample figures |
| 10 requirements | The source column already carries them, which is most of the work done |
| 11 architecture | The regularisation sign-flip result, the covariance-instability results, the step-count accuracy figures |
| 12 data | The source items, the licences, and the estimator paper whose exclusion rule is adopted |
| 13, 14 methodology and evaluation | The protocol sources, the combination review, the significance-testing caution |
| 18 risk | The published weight trace behind the entropy risk, and the predictor-count warning |
| 20 scope | The withdrawn claims, each with the paper that caused the withdrawal |

Technical and tool documentation is cited from official documentation rather than from secondary sources, and the community-produced exchange API documentation is labelled as community-produced rather than official.

---

## Part 4. Separating sourced evidence from my own analysis

This is the part of the criterion worth showing rather than asserting, and the mechanisms already exist.

- **Three-way separation as a standing rule.** A paper's claim, the evidence it offers, and my reading of it are kept visibly distinct in every review note, and where only one of the three is being reported the note says which.
- **Scoping every claim to its conditions.** Findings are reported as holding on that dataset, that sample, that cost assumption, rather than as general results.
- **Panel and supervisor input separated from my inference.** Each feedback point is recorded as a verbatim quote, then my reading labelled as mine, then the action taken.
- **Candidate contributions labelled as candidate.** The standing form is that these are candidate contributions not identified in the literature reviewed to a stated cutoff, to be further validated against recent work.
- **Withdrawn claims kept visible.** Eight claims have been withdrawn or demoted on evidence and are recorded as withdrawn rather than deleted.
- **A provenance audit.** Every quoted span in the survey matrix was checked against the note it came from, producing thirteen substantive corrections, four adjudicated against the source PDFs.

---

## Part 5. AI and academic integrity

Short, because the detail lives on slide 16, but this criterion is where attribution is assessed and one line belongs here.

AI assistance was used for literature search, note drafting, matrix population and synthesis, and in every case the verification is reading the source. **AI is not cited as evidence anywhere**, and an AI-produced summary is treated as a prompt to read the paper rather than a substitute for reading it. The standing conflict rule is that where a working document disagrees with a review note or with the source paper, the paper wins and the conflict is reported rather than reconciled silently.

---

## Part 6. The pre-submission checklist for this criterion

From [[29-09-2026]] §11.6, which already specifies the quality sweep. Worth keeping as the actual checklist rather than rewriting it.

- Every claim on every slide has evidence behind it.
- Every citation appearing on a slide appears in the reference list.
- No absolute novelty language remains anywhere in my own wording.
- Terminology is consistent across slides.
- Sentiment has not accidentally reappeared.
- Bibliographic metadata is complete, with no missing venue, year or identifier.
- Preprints are identifiable as preprints where a central claim rests on one.

---

## Part 7. Open decisions

1. **The citation style.** Part 2. This is the only hard blocker on the slide.
2. **How many references appear on the slide itself.** A 59-item list will not fit and is not what the slide is for. The template's framing is key references actually cited, which in practice means the ten to fifteen that appear in the spoken argument, with the full list in the handout.
3. **Whether the corpus statistics appear here or on slide 5.** They belong on slide 5 as evidence of coverage, and this slide should carry attribution practice rather than counts.

---

**Related notes.** [[_Corpus Index]] for the per-note table and the coverage figures. [[Research Matrices Status]] for the provenance audit. [[16 Iteration, Feedback, Change and AI Verification]] for the verification process in full. [[Zotero Integration Setup]] for the reference pipeline.

**Language discipline applies here too.** Corpus counts are counts of my own corpus and are labelled as such, not as counts of the field.
