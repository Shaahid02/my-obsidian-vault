---
status: current
created: 2026-10-23
written_against: "[[16-06-2026]]; [[ELI5 - The Whole Project in Plain English]]; [[07 Research Questions, Aim and Objectives]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slides 1 and 2 of the PP live presentation template. The two are combined because both are framing rather than content, and because the one-sentence focus on slide 1 and the spine table on slide 2 have to agree with each other. Sentiment is out of scope throughout.*

---

## Part 1. The title, still open

Every title variant in the vault predates the 20 September scope decision and the working one still contains "Localized Sentiment". A current title does not exist, and slide 1 cannot be built without one.

| Candidate | Wording | Argument for it |
|---|---|---|
| **A** | A Friction-Aware Multi-Agent Decision Support Framework for Frontier Equity Markets: A Colombo Stock Exchange Case Study | This is my own shorter form from [[16-06-2026]] §4 and it never contained sentiment, so it carries continuity with what the supervisor has already seen. Weakness: "friction-aware" foregrounds the supporting contribution rather than the main one |
| **B** | Market-State-Conditioned Orchestration of Heterogeneous Agents for Financial Decision Support: A Colombo Stock Exchange Study | Puts the mechanism in the title, which is what both panel members independently identified as the strongest element. Weakness: longest of the three and heaviest to say out loud |
| **C** | Adaptive Multi-Agent Orchestration under Liquidity and Volatility Constraints: A Colombo Stock Exchange Case Study | Shortest, fits one line, names the two conditioning variables with the clearest local evidence. Weakness: "adaptive" is doing a lot of work and is less precise than "market-state-conditioned" |

> [!WARNING]
> <font color="#ff0000">Open decision.</font> My own reading is that B is the most accurate and C is the most usable, and that A is the safest if the supervisor has been reading the earlier framing. The decision belongs to you and it should be made before anything else on the deck, because slides 1, 3, 6 and 20 all have to agree with it.

**Whichever is chosen, two things must be true.** It contains no sentiment reference, and it names the CSE as a case study or evaluation setting rather than as the subject, which is the framing [[29-09-2026]] §3.2 prescribed.

---

## Part 2. Slide 1 content

| Field          | Content                                       |
| -------------- | --------------------------------------------- |
| Student name   | Shaahid Fathul                                |
| IIT and UoW ID | 20223216, W1986734                            |
| Supervisor     | Guhanathan Poravi                             |
| Academic year  | 2026 to 2027                                  |
| Group          | Group four, roughly row 30 on the panel sheet |
| Project title  | See Part 1, open                              |

**The one-sentence research focus**, following the template's own sentence shape, which is *investigates [gap] by designing, implementing and evaluating [artefact] for [context]*:

> This project investigates how the influence of methodologically heterogeneous financial agents should be set when the reliability of their evidence channels varies with market conditions, by designing, implementing and evaluating a market-state-conditioned orchestration operator on Colombo Stock Exchange data.

One sentence, names the gap and the artefact, scopes the evaluation, and claims nothing about the result.

---

## Part 3. Slide 2, the two spines

The template's own framing is that examiners should see a research spine and a software engineering spine running in parallel and meeting. The table below is the template's, filled, and it doubles as the deck's contents page.

| Research spine | Software engineering spine | Where it is in this deck |
|---|---|---|
| Problem context: agent reliability varies with market state, and systems combine agents as though it does not | Target users and product need: a decision pipeline that does not emit confident output from an empty channel | Slides 3 and 9 |
| Literature and existing work: 59 reviewed papers, with the nearest six systems contrasted clause by clause | Requirements evidence: every requirement carries the paper, measurement or decision that forced it | Slides 4, 5, 6, 8 and 10 |
| Research gap and questions: three questions, one per gap, each answerable by a planned experiment | Artefact scope and boundaries: four agents, one orchestrator, eight stated exclusions | Slides 6, 7 and 10 |
| Methodology and evaluation: design science with a controlled comparative experiment, five arms, per-input ablation | Architecture, implementation and testing: five layers, point-in-time data access, verified data pipeline | Slides 11, 13, 14 and 15 |
| Contribution and limitations: a weighting operator with a named lineage, plus attributable evidence on whether it earns its place | Deployment, risk and responsible practice: research prototype, no interface, three decisions changed by responsible considerations | Slides 16 to 20 |

**The spoken line the template suggests for this slide**, adapted:

> I will show the research gap and the contribution, then how the artefact, the methodology and the evaluation are built to address it, and then what I am not claiming.

---

## Part 4. The four sentences for an opening or a corridor question

From [[ELI5 - The Whole Project in Plain English]], lightly revised to remove the superseded data figure. Worth having memorised, because the first two minutes set how the rest is heard.

> Systems that combine several AI analysts into one trading decision almost always combine them the same way every day, regardless of conditions. That is fine when the analysts are equally reliable, which is roughly true on a deep market, and false on a thin one where some information channels regularly go empty. I am building the component that adjusts how much each analyst is listened to, continuously, from measurable market conditions, and testing it against the fixed alternatives on the Colombo Stock Exchange. The honest framing is that this extends a known family of methods along one named axis, and the test is designed so that "it did not help" is a reportable answer too.

---

## Part 5. Open decisions

1. **The title.** Three candidates in Part 1. Everything else on the deck depends on it.
2. **Student and supervisor details.** To be checked against the submission record, per the 3 November proofreading task.
3. **Whether slide 2 is delivered or skipped.** It carries no criterion of its own and costs perhaps forty seconds. At up to twenty minutes including questions, that is a real trade. My reading is that it earns its place because it tells the examiner what structure to expect, and the communication criterion assesses structure.

---

**Related notes.** [[07 Research Questions, Aim and Objectives]] for the aim this focus sentence compresses. [[_Proposal Notes Index]] for the slide to criterion mapping.

**Language discipline applies here too.** No "first", "nobody", "never". No sentiment reference anywhere in the title or the focus sentence.
