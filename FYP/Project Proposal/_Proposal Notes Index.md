---
status: current
created: 2026-10-23
revised: 2026-10-23
tags:
  - index
  - proposal
---
# Project Proposal notes

Twenty-one notes covering every slide of the PP live presentation template. Each converts decisions already recorded elsewhere in the vault into the form the template and the marking rubric ask for. Almost nothing in them is new research; where something is composed rather than extracted, the note says so.

| Note | Slide | Rubric criterion | Weight |
|---|--:|---|--:|
| [[01-02 Title, Research Focus and Proposal Storyline]] | 1, 2 | Communication, plus the focus line feeds Problem and Goal | 10% shared |
| [[03 Problem, Goal and Outcomes]] | 3 | Problem or Opportunity and Project Goal | 10% |
| [[04 Evidence to Research Gap]] | 4 | Background and Evidence | 10% |
| [[05 Critical Literature Landscape]] | 5 | Background and Evidence | 10% |
| [[06 Gap, Novelty and Contribution]] | 6 | Background and Evidence, plus Goal | 10% |
| [[07 Research Questions, Aim and Objectives]] | 7 | Problem and Goal, plus Methodology | 10% / 15% |
| [[08 Existing Solutions and Baselines]] | 8 | Background and Evidence, plus Evaluation | 10% |
| [[09 Stakeholders, Users and Context of Use]] | 9 | Initial Requirements and Indicative Solution | **20%** |
| [[10 Requirements]] | 10 | Initial Requirements and Indicative Solution | **20%** |
| [[11 Architecture and Indicative Solution]] | 11 | Initial Requirements and Indicative Solution | **20%** |
| [[12 Data and Evidence Strategy]] | 12 | Requirements, plus Responsible Considerations | 20% / 10% |
| [[13 Methodology]] | 13 | Methodology and Development Approach | **15%** |
| [[14 Evaluation and Experimental Design]] | 14 | Methodology and Development Approach | **15%** |
| [[15 Testing, QA and Traceability]] | 15 | Methodology and Development Approach | **15%** |
| [[16 Iteration, Feedback, Change and AI Verification]] | 16 | Methodology and Development Approach | **15%** |
| [[17 Project Plan, Milestones and Dependencies]] | 17 | Project Plan Feasibility and Risk | 10% |
| [[18 Risk, Mitigation and Contingency]] | 18 | Project Plan Feasibility and Risk | 10% |
| [[19 Responsible Research and Project Considerations]] | 19 | Responsible Project Considerations | 10% |
| [[20 Scope, Limitations and Closing Defence]] | 20 | Appropriateness of Scope, plus Communication | 10% |
| [[21 Academic Practice and References]] | 21 | Academic Practice and Referencing | 5% |
| [[22 Backup and Q&A Preparation]] | 22 | Communication, responses to questions | 10% shared |

Slides 10 and 11 are a pair. The rubric states that a requirements specification cannot score highly if the technical concept is absent, and that a technology stack cannot compensate for unclear requirements, so neither note carries the criterion alone.

---

## Marks per slide, as a triage signal

Dividing each criterion across the slides that carry it. Not how a marker works, but it is where the preparation time should go.

| Slide | Approximate marks | Note |
|--:|--:|---|
| 19 Responsible considerations | 8 to 10 | One slide carrying a whole criterion |
| 20 Scope and limitations | 7 to 10 | One slide, plus scope appears in the cross-cutting row of every band |
| 10 Requirements | about 6 | Core of the 20 percent criterion |
| 11 Architecture | about 6 | Core of the 20 percent criterion |
| 17, 18 Plan and risk | about 5 each | |
| 21 References | about 5 | Whole criterion |
| 13 to 16 Methodology group | about 3.75 each | |
| 4, 5, 6, 8 Evidence group | about 2.5 each | The strongest material in the project, and the least dense slides |

---

## Assessment conditions

| Item | Value |
|---|---|
| Weighting | 15% of the module |
| Type | Presentation, **up to 20 minutes including questions** |
| Learning outcomes | LO1 to LO5 |
| Qualifying minimum | 30% |
| Mandatory | Signed Ethics Application by the deadline, or the overall mark is zero |
| Submission | Offline copy of the slides through Blackboard. The delivered presentation including answers is the assessed performance |
| PPRS recorded video | 5 November 2026 |

Leaving five to seven minutes for questions puts the delivery at roughly thirteen to fifteen minutes across twenty-one content slides, which is about forty seconds each.

---

## Settled by instruction on 23 October

| Decision | Position |
|---|---|
| Implementation stack | Python and the scientific stack, already evidenced by the dataset repository. The backbone for the fundamental agent and any orchestration framework stay open, with selection criteria recorded |
| User interface | None in proposal scope. Batch research pipeline. Recorded as boundary requirement B6 |
| Open items generally | Proposed values written in, flagged provisional and dated, rather than left blank |

---

## Open decisions across all twenty-one notes

Collected so they can be settled in one pass. Ordered by what blocks the most.

| # | Decision | Note | Blocks |
|--:|---|---|---|
| 1 | **The project title.** Three candidates. Every variant in the vault still contains "Localized Sentiment" | 01-02 | Slides 1, 3, 6 and 20 |
| 2 | **Dates after 5 November.** No IPD, final submission or viva date exists anywhere | 17 | Slide 17, and the plan criterion |
| 3 | **Citation style.** Harvard is the template's first-named option; the institutional requirement was never recorded | 21 | Every in-slide citation |
| 4 | The aim sentence, final wording | 07 | Slides 1, 3, 7 |
| 5 | Whether RQ3 stands as a question or as a stated sub-hypothesis | 07 | Slides 6, 7, 14 |
| 6 | Primary metric: per traded day or over the full window | 07, 14 | The pre-registration |
| 7 | Minimum margin: scaled to baseline dispersion, or a fixed number | 07, 14 | The pre-registration |
| 8 | Backbone for the fundamental agent, and whether a framework is used | 11 | Slide 11 |
| 9 | Which diagram goes on slide 11, layered view or dependency chain | 11 | Slide 11 |
| 10 | Labels for the research design and the development process | 13 | Slide 13 |
| 11 | MoSCoW priorities, assigned provisionally | 10 | What gets cut if the build runs short |
| 12 | Close-outside-range rows: dropped, or admitted as degenerate observations | 12 | Every spread estimate and sample size |
| 13 | Float-adjusted or raw liquidity stratification | 12 | A third of the bottom quintile's membership |
| 14 | The full-study window, 2010 to 2026 against the proof-of-concept sizing | 12 | Both came from different panel members a week apart |
| 15 | One consistent term for the motivating decision-maker | 09 | Slides 3, 9, 20 |
| 16 | Whether a unit test suite exists in the repository today | 15 | Whether slide 15 cites or promises |
| 17 | How much code-level AI verification to claim | 16 | Slide 16 |
| 18 | Whether the EDI argument is representational or weakly applicable | 19 | Slide 19 |
| 19 | Whether the withdrawn-claims table sits on slide 6 or slide 20 | 06, 20 | Avoiding a repeat |
| 20 | How many backup slides are actually built | 22 | Preparation time |

---

## Still outstanding outside these notes

- **The project title**, above, which is the one blocking item that cannot be deferred.
- **The Ethics Application.** Separate mandatory submission, listed as Not Started, targeted at 1 November. No contingency exists for non-submission.
- **The structured gap verification** [[Week 4]] §2.2 asked for, comparing existing systems across aggregation method, regime detection, liquidity treatment and evaluation protocol. Matrix work extending existing sheets, not new research.
- **The 374-day correction in the survey matrix**, which sits in around twenty cells across eight review notes and needs a note revision with the paper check that implies, rather than a find and replace.
- **Panel items carried to Week 6**, including whether the mechanism with its ablation needs changing, which was asked in Week 5 and not answered.

---

## One standing warning before lifting text into slides

[[ELI5 - The Whole Project in Plain English]] is the most quotable note in the vault and is **superseded on data**. It still states 374 trading days per counter, 270 companies over ten years, and trading-activity data as missing. All three were corrected between 18 and 21 October: roughly 356 equity securities, about 853,535 traded rows, 3,920 validated trading days from 2010 to 2026-06-30, median per-counter history around 3,400 days, and turnover and trade count held across the full span.

This is not only a number. The forecast-combination objection in that note leans on 374 days to argue that limited data favours equal weights, and [[Research Matrices Status]] already records that the argument "is weaker than it reads" at 3,400 days. If that passage reaches a slide unrevised, it presents a weakened version of my own strongest counter-argument.

---

**Language discipline applies across all twenty-one notes.** No "first", "nobody", "never", no em dashes. The permitted form is *"I have not found that evaluation in the literature I have covered."* The agent set and the conditioning set remain provisional. Sentiment is out of scope throughout.
