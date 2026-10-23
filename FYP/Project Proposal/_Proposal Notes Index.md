---
status: current
created: 2026-10-23
tags:
  - index
  - proposal
---
# Project Proposal notes

Eight notes written on 23 October 2026, one per template slide that had no material behind it. Each converts decisions already recorded elsewhere in the vault into the form the PP live presentation template and the marking rubric ask for. Nothing in them is new research.

| Note | Slide | Rubric criterion | Weight |
|---|--:|---|--:|
| [[07 Research Questions, Aim and Objectives]] | 7 | Problem and Goal, plus Methodology | 10% / 15% |
| [[09 Stakeholders, Users and Context of Use]] | 9 | Initial Requirements and Indicative Solution | 20% |
| [[10 Requirements]] | 10 | Initial Requirements and Indicative Solution | 20% |
| [[11 Architecture and Indicative Solution]] | 11 | Initial Requirements and Indicative Solution | 20% |
| [[13 Methodology]] | 13 | Methodology and Development Approach | 15% |
| [[15 Testing, QA and Traceability]] | 15 | Methodology and Development Approach | 15% |
| [[16 Iteration, Feedback, Change and AI Verification]] | 16 | Methodology and Development Approach | 15% |
| [[19 Responsible Research and Project Considerations]] | 19 | Responsible Project Considerations | 10% |

Slides 10 and 11 are a pair. The rubric states that a requirements specification cannot score highly if the technical concept is absent, and that a technology stack cannot compensate for unclear requirements, so neither note carries the criterion alone.

---

## Assessment conditions these are written against

| Item | Value |
|---|---|
| Weighting | 15% of the module |
| Type | Presentation, **up to 20 minutes including questions** |
| Learning outcomes | LO1 to LO5 |
| Qualifying minimum | 30% |
| Mandatory | Signed Ethics Application by the deadline, or the overall mark is zero |
| Submission | Offline copy of the slides through Blackboard. The delivered presentation including answers is the assessed performance |
| PPRS recorded video | 5 November 2026 |

The duration is the constraint that shapes the deck. Leaving five to seven minutes for questions puts the delivery at roughly thirteen to fifteen minutes across twenty-one content slides.

---

## Open decisions carried across all eight notes

Collected here so they can be settled in one pass rather than found one at a time. Everything marked provisional in the notes appears below.

### Settled by instruction on 23 October

| Decision | Position |
|---|---|
| Implementation stack | Python and the scientific stack, already evidenced by the dataset repository. The backbone for the fundamental agent and any orchestration framework stay open, with selection criteria recorded |
| User interface | None in proposal scope. Batch research pipeline. Recorded as boundary requirement B6 |
| Open items generally | Proposed values written in, flagged provisional and dated, rather than left blank |

### Still to settle

| # | Decision | Note | Why it matters |
|--:|---|---|---|
| 1 | The aim sentence, final wording | 07 | It is read first on slides 1 and 3 |
| 2 | Whether RQ3 stands as a question or becomes a stated sub-hypothesis | 07 | It has no result behind it and will not have one before 5 November |
| 3 | Primary metric: per traded day or over the full window | 07 | They answer different questions once abstention is in play |
| 4 | Minimum margin over equal weights: scaled to baseline dispersion, or a fixed number | 07 | Either is defensible. Deciding after the run is not |
| 5 | One consistent term for the motivating decision-maker | 09 | The vault currently uses three |
| 6 | MoSCoW priorities, assigned provisionally | 10 | Four requirements are marked Should and are the first candidates to cut |
| 7 | Backbone for the fundamental agent, and whether a framework is used | 11 | Criteria recorded; the decision is outstanding |
| 8 | Which diagram goes on slide 11, layered view or dependency chain | 11 | The layer view suits the criterion; the chain explains build order |
| 9 | Label for the research design and the development process | 13 | Both are naming decisions, not research |
| 10 | Whether a unit test suite exists in the repository today | 15 | The note states tests as planned because the vault does not evidence them |
| 11 | How much code-level AI verification to claim | 16 | The orchestration code does not exist yet |
| 12 | Whether the EDI argument is presented as representational or as weakly applicable | 19 | Both are honest; one is shorter |

---

## What these notes do not cover

- **Slide 17, the project plan.** The schedule to 5 November is detailed in [[29-09-2026]] §11. Nothing exists beyond that date: no IPD date, no final submission date, no viva date. The rubric's plan criterion asks about the whole project, so this needs writing before the deck is built.
- **Slide 20, scope and limitations.** Strong material exists in [[PoC Specification]] Part 1 and [[Contribution to Knowledge]] Part 4, so it was not in the empty set, but it carries one of the highest marks-per-slide figures in the deck and deserves a pass.
- **The project title.** Every recorded variant still contains "Localized Sentiment", which has been out of scope since 20 September.
- **The Ethics Application.** Separate mandatory submission, listed as Not Started.
- **The news and sentiment scope-exclusion defence**, [[Week 5]] outstanding action 1, which belongs on slide 20 and in the Q&A preparation.

---

## One standing warning before lifting text into slides

[[ELI5 - The Whole Project in Plain English]] is the most quotable note in the vault and is **superseded on data**. It still states 374 trading days per counter, 270 companies over ten years, and trading-activity data as missing. All three were corrected between 18 and 21 October: roughly 356 equity securities, about 853,535 traded rows, 3,920 validated trading days from 2010 to 2026-06-30, median per-counter history around 3,400 days, and turnover and trade count held across the full span.

This is not only a number. The forecast-combination objection in that note leans on 374 days to argue that limited data favours equal weights, and [[Research Matrices Status]] already records that the argument "is weaker than it reads" at 3,400 days. If that passage reaches a slide unrevised, it presents a weakened version of my own strongest counter-argument.

---

**Language discipline applies across all eight notes.** No "first", "nobody", "never", no em dashes. The permitted form is *"I have not found that evaluation in the literature I have covered."* The agent set and the conditioning set remain provisional. Sentiment is out of scope throughout.
