---
status: current
created: 2026-10-23
revised: 2026-10-24
written_against: "[[16-06-2026]]; [[ELI5 - The Whole Project in Plain English]]; [[07 Research Questions, Aim and Objectives]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slides 1 and 2 of the PP live presentation template. The two are combined because both are framing rather than content, and because the one-sentence focus on slide 1 and the spine table on slide 2 have to agree with each other. Sentiment is out of scope throughout.*

---

## Part 1. The title

> [!important]
> **Decided 24 October 2026.**
>
> ## Market-State-Conditioned Orchestration of Heterogeneous Agents for Financial Decision Support: A Colombo Stock Exchange Study

**Why this one.** It names the contribution rather than a supporting mechanism, which matters because the friction work is self-rated 3 out of 5 and the orchestration operator is 4. It mirrors the wording of the surviving claim agreed with the supervisor on 29 September, so the title, the gap statement and the contribution statement all use the same vocabulary. And it answers the integration challenge at a glance, which is the challenge both panel members raised in different forms, in [[Week 3]] §2.2 and [[Week 4]] §2.4.

**Two properties it satisfies, which any title had to.** No sentiment reference anywhere, and the CSE named as the evaluation setting rather than as the subject, which is the framing [[29-09-2026]] §3.2 prescribed.

### The two not chosen, kept as the record

| Candidate | Wording | Why it was not chosen |
|---|---|---|
| **A** | A Friction-Aware Multi-Agent Decision Support Framework for Frontier Equity Markets: A Colombo Stock Exchange Case Study | My own shorter form from [[16-06-2026]] §4, and it never contained sentiment, so it carried the most continuity with what the supervisor has already seen. Set aside because "friction-aware" foregrounds the supporting contribution rather than the main one |
| **C** | Adaptive Multi-Agent Orchestration under Liquidity and Volatility Constraints: A Colombo Stock Exchange Case Study | Shortest and easiest to say. Set aside because "adaptive" is vaguer than "market-state-conditioned", and because it names two of the four conditioning terms, which invites the question of why those two |

**One consequence to carry.** The chosen title is long for a single line on a slide. Set it in two lines on slide 1, breaking after the colon, rather than reducing the type size.

---

## Part 2. Slide 1 content

| Field | Content |
|---|---|
| Student name | Shaahid Fathul |
| IIT and UoW ID | 20223216, W1986734 |
| Supervisor | Guhanathan Poravi |
| Academic year | 2026 to 2027 |
| Group | Group four, roughly row 30 on the panel sheet |
| Project title | Market-State-Conditioned Orchestration of Heterogeneous Agents for Financial Decision Support: A Colombo Stock Exchange Study |

**The one-sentence research focus**, approved 24 October, following the template's own sentence shape, which is *investigates [gap] by designing, implementing and evaluating [artefact] for [context]*:

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

## Part 5. Settled and open

### Settled 24 October

| Item | Decision |
|---|---|
| Project title | Candidate B, as in Part 1 |
| One-sentence research focus | Approved as drafted in Part 2 |
| Slide 2, keep or cut | **Keep.** It carries no criterion of its own and costs roughly forty seconds, but the communication criterion assesses structure and this is the slide that tells the examiner what structure to expect |

### Still open

Nothing. The student IDs were supplied on 24 October and are in Part 2. They remain on the 3 November proofreading checklist, which verifies student IDs, title and supervisor details against the submission record, but that is a check rather than an open decision.

### Propagation from the title decision

The title is now fixed, so these have to agree with it and should be checked when each is built.

| Where | What must match |
|---|---|
| Slide 1 | The title itself, set over two lines |
| Slide 3 | The goal statement, which already uses "market-state-conditioned orchestration operator" |
| Slide 6 | The contribution statement, same vocabulary |
| Slide 20 | The closing defence, which names the contribution again |
| Recorded video and Blackboard filename | Same title, so the submission record matches the deck |

---

**Related notes.** [[07 Research Questions, Aim and Objectives]] for the aim this focus sentence compresses. [[_Proposal Notes Index]] for the slide to criterion mapping.

**Language discipline applies here too.** No "first", "nobody", "never". No sentiment reference anywhere in the title or the focus sentence.
