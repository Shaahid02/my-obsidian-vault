---
status: current
created: 2026-10-23
revised: 2026-10-30
written_against: "[[_Corpus Index]]; [[Research Matrices Status]]; [[Zotero Integration Setup]]; [[29-09-2026]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 21 of the PP live presentation template. This criterion is worth 5 percent and the material behind it is strong, so the work is mostly mechanical. One genuine open item sits inside it, which is the citation style. Sentiment is out of scope throughout.*

---

> [!NOTE]
> **Revised 30 October 2026.** This criterion scored **50 of 100** in the [[24-10-2026]] assessment, described there as high priority but relatively easy to improve. §6.8 names four claims that appear without source-level attribution and asks for the provenance of every dataset-quality figure. Two corrections and five additions follow. The citation style is settled, the handout the note assumed does not exist, and the biggest gain is Part 3a, which separates what was measured from what was read and what is only a threshold.

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

### `[ADDED 30 OCTOBER 2026]` Read, reported, and not obtained

§6.8 asks that papers personally reviewed be distinguished from inaccessible or secondarily reported ones. Undifferentiated, 59 citations read as 59 citations. Separated, they read as rigour.

| Category | Count | What it means |
|---|---|---|
| **Reviewed against the source paper** | **59** | Each has a review note written against the paper itself and put through a validation pass. This is the strong claim and it is the one worth making |
| **Known only through another paper's description** | To be counted | Anything cited on the strength of a survey's account of it rather than the original. Each one is marked at the point of use, because a survey's reading of a paper is evidence about the survey |
| **Identified as relevant and not obtained** | At least **1** | A 2026 study on modular transaction-cost layers, paywalled and unread, already named in [[20 Scope, Limitations and Closing Defence]] Part 3. Named rather than omitted, because an unobtained paper that is disclosed is a limitation and one that is hidden is a problem |
| **Preprints** | About **14** | Flagged as preprints wherever a central claim rests on one, per [[29-09-2026]] §4.3 |

**Venue spread across the corpus** includes machine learning and natural language venues, forecasting and operational research journals, and finance journals. The supervisor's instruction at [[29-09-2026]] §4.3 is the one to follow on the slide: anchor central novelty claims primarily in peer-reviewed work rather than in preprints alone, and the roughly 14 preprints are flagged rather than hidden.

---

## Part 2. Citation style

> [!important]
> **`[SETTLED 30 OCTOBER 2026]` The required style is Westminster Harvard.** This was the one hard blocker on this note and it is closed. Applied consistently across in-slide citations and the reference list.
>
> **One action follows.** [[Zotero Integration Setup]] records the Quick Copy format as "the citation style the proposal needs", which was never resolved. Set it to Westminster Harvard before generating any citation, because changing it afterwards means regenerating every one of them.

---

## Part 3. What gets cited on which slide

Citations belong where the claim is, so this is a checklist rather than a principle.

> [!important]
> **`[ADDED 30 OCTOBER 2026]` Four claims §6.8 names as appearing without attribution at the point of use.** These are load-bearing in the argument, which is why their being unsourced on a slide costs more than the 5 percent suggests.
>
> | Claim as it appears | Where it comes from |
> |---|---|
> | Mean institutional ownership **66.1 percent** against insider ownership **5.7 percent**, used on slides 9, 19 and 20 to argue available depth is worse than capitalisation suggests | [[Relationship between firm-level investment, idiosyncratic risk and ownership, an emerging market perspective]] |
> | Trading volume Granger-causes the index at **$p = 0.0041$** while money supply and inflation reach nothing, used as the one-line case for liquidity being the centre | [[The Relationship between Macroeconomic Variables, Trading Volume and Stock Returns, Granger Causality Evidence from the Colombo Stock Exchange]] |
> | **10.36 points** of total-return degradation from an agent the architecture could not notice, the measured version of the problem | Jung and Lee. <font color="#ff0000">Pull the exact title and citekey from [[_Corpus Index]] before the slide is built</font> |
> | **4 of 59** papers reproducible from the paper alone, against 21 that are not | **Not a citation problem.** This is my own count over my own corpus, so it needs labelling as an own observation **and** a stated coding rule, which is separately what §7 asks for on slide 5. See Part 3a |

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

## Part 3a. Where every number came from

`[ADDED 30 OCTOBER 2026]` §6.8 asks for clarity on whether numerical dataset-quality results were **calculated, reported by software logs, or proposed as acceptance thresholds**. It is the same objection §7 makes about planned work reading as completed work, and it lands on the strongest material in the project: the figures are good, and the ambiguity about what they are is what undercuts them.

**Four categories, and every number on a slide belongs to exactly one.**

| Category | How it is labelled | Examples |
|---|---|---|
| **Measured by me on this dataset** | Stated with the window and the universe it was measured over | 0.13 percent turnover reconciliation for every year except 2016 at 0.8 percent. 99.93 percent close agreement across 817k rows. 99.82 percent of implied VWAPs inside the daily range. 3,920 validated trading days. 6.4 percent of rows with a close outside the high-low range, 99.9 percent of those equal to the previous close. Median float 25.2 percent. Crossings 8.8 to 47.4 percent of annual turnover. $\hat{d} = 0.408$ on absolute returns |
| **Reported by a tool or a log** | Named as a loader assertion or a log output rather than an analysis | The empty download error log. The bar-validity assertion that caught ASPM printing a close outside its own high-low range. No duplicate rows, no negative values, trade count 100 percent populated from 2012 |
| **Proposed as a threshold, not a result** | <font color="#ff0000">The category most at risk of reading as a finding</font> | The 60 percent of aligned days and 2,000 aligned days screen. $\alpha = 0.05$. The margin as the interquartile range of $B_1$. The abstention floor $\phi$, **which has no value yet**. The winsorisation threshold, still open. The 4.5 of 5 tracker quality threshold |
| **Read from a paper** | Cited at the point of use, with the conditions it was obtained under | 66.1 and 5.7 percent ownership. $p = 0.0041$. 10.36 points. Step-count accuracy at 67.61, 59.08 and 22.78 percent. Adjusted $R^2$ of 0.189 across five macro variables. The 1250-day conformal refit window |
| **My own count over my own corpus** | Labelled as a count of my corpus, **not of the field**, with the coding rule stated | 4 of 59 reproducible against 21 not. 13 substantive corrections. 1,621 quoted spans. Roughly 14 preprints |

**The coding rule the last category needs.** §7 asks for slide 5's literature statistics to be auditable through a documented classification protocol. For the reproducibility count that means stating what counted as reproducible: whether code was released, whether data was obtainable, and whether the paper alone was sufficient to rebuild the result. Without that rule the number is an impression with a decimal point on it.

---

## Part 3b. Sources that are not papers

`[ADDED 30 OCTOBER 2026]` §6.8 asks for datasets, API documentation, software libraries, models and evaluation tools to be referenced. None were in this note. [[19 Responsible Research and Project Considerations]] Part 2a covers what may be **used and released**, which is a permissions question; this is the attribution question.

| Source | How it is cited |
|---|---|
| **CSE Data Library**, 40 items | Cited as the dataset with item numbers, the extraction date and the purchase route. Item-level, because items differ in coverage and at least ten change layout, units or meaning partway through their own history |
| **CSE announcements feed**, 22,893 filings | Cited as a corpus with the harvest date range and the document-type counts |
| **CSE API** | Cited with its documentation marked **community-produced rather than official**, and with the note that it is the cross-check rather than the base panel |
| **Benchmark datasets** for the fundamental agent | Cited individually with their licences, one non-commercial and one permissive |
| **Software libraries** | Cited from official documentation rather than secondary sources, with versions pinned so the citation is to a specific release |
| **The model backbone** | Still open. Whichever is chosen is cited with its model card and licence, and **licence is one of the four selection criteria** rather than a check made afterwards |
| **Evaluation tools** | The statistical procedures are cited to their sources, the HAC adjustment and the stationary bootstrap in particular, since both are methodological borrowings rather than library calls |

---

## Part 4. Separating sourced evidence from my own analysis

This is the part of the criterion worth showing rather than asserting, and the mechanisms already exist.

- **Three-way separation as a standing rule.** A paper's claim, the evidence it offers, and my reading of it are kept visibly distinct in every review note, and where only one of the three is being reported the note says which.
- **Scoping every claim to its conditions.** Findings are reported as holding on that dataset, that sample, that cost assumption, rather than as general results.
- **Panel and supervisor input separated from my inference.** Each feedback point is recorded as a verbatim quote, then my reading labelled as mine, then the action taken.
- **Candidate contributions labelled as candidate.** The standing form is that these are candidate contributions not identified in the literature reviewed to a stated cutoff, to be further validated against recent work.
- **Withdrawn claims kept visible.** Eight claims have been withdrawn or demoted on evidence and are recorded as withdrawn rather than deleted.
- **A provenance audit.** Every quoted span in the survey matrix was checked against the note it came from, producing thirteen substantive corrections, four adjudicated against the source PDFs.
- `[ADDED 30 OCTOBER 2026]` **Verified against the originals, which is a stronger claim than cited.** §6.8 asks that quoted experimental results be verified against the actual paper. That verification has run and it **found things**: thirteen substantive corrections across 59 notes, four adjudicated against the source PDFs, including one note that had reversed a paper's own ablation finding and two that asserted something the paper explicitly withholds. A verification process that never caught anything would not be evidence of correctness.

### `[ADDED 30 OCTOBER 2026]` Borrowed equations, architecture and implementation approaches

§6.8 asks for these to be attributed, and they are the easiest attribution to forget because they arrive as ideas rather than as quotes.

| What is borrowed | Attributed as |
|---|---|
| **The weighting function's form** | Feature-conditioned forecast combination, named as the nearest ancestor and positioned as a generalisation along one identified axis. The full term-by-term map is in [[16 Iteration, Feedback, Change and AI Verification]] Part 4, including which term rests on my own reasoning |
| **The liquidity composite** | A published market-condition-indicator recipe, cited rather than presented as constructed here |
| **The conformal interval** as a confidence input | Adaptive conformal inference, cited with its 1250-day refit window and the note that the window does not transfer to the thin strata |
| **Theil's $U2$** as the technical agent's confidence | Standard, cited to its source rather than treated as common knowledge |
| **The accuracy-at-threshold transform** | The abstention literature, cited. **The decision to put four unlike mechanisms through one such transform is my own**, and is labelled as mine |
| **Range volatility estimators** | Parkinson or Garman-Klass, cited, with the choice between them still open |
| **The common output contract and the abstention channel** | Composed here, not borrowed, and said so plainly, since claiming a lineage that does not exist is its own error |

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

1. ~~The citation style.~~ `[CLOSED 30 OCTOBER 2026]` **Westminster Harvard.** Was the only hard blocker on this slide.
2. ~~How many references appear on the slide itself.~~ `[CLOSED 30 OCTOBER 2026]` **Two places, because there is no handout.** The submitted slides **are** the document, so a reference list that lives anywhere else does not exist as far as the assessment is concerned, and §6.8's first complaint is that the deck carries no complete reference slide.
>
   - **Slide 21** carries the ten to fifteen references that appear in the spoken argument, which is what the template means by key references actually cited.
   - **An appendix after the backup slides** carries the complete list, all 59 plus the non-paper sources in Part 3b, in Westminster Harvard. It is never displayed and it does not cost presentation time, and it is read because the deck is submitted.
3. **Whether the corpus statistics appear here or on slide 5.** They belong on slide 5 as evidence of coverage, and this slide should carry attribution practice rather than counts.
4. `[RAISED 30 OCTOBER 2026]` **Consistent paper identifiers across the three artefacts.** §6.8 asks that identifiers match across the Literature Survey, the Research Gap Matrix and the presentation. This is matrix work rather than writing, and it is the kind of inconsistency a marker finds by accident.
5. `[RAISED 30 OCTOBER 2026]` **The count of secondarily reported papers**, in Part 1. It is unknown and has to be established by going through the corpus, not estimated.

---

**Related notes.** [[_Corpus Index]] for the per-note table and the coverage figures. [[Research Matrices Status]] for the provenance audit. [[16 Iteration, Feedback, Change and AI Verification]] for the verification process in full. [[Zotero Integration Setup]] for the reference pipeline.

**Language discipline applies here too.** Corpus counts are counts of my own corpus and are labelled as such, not as counts of the field.
