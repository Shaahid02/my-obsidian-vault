---
status: current
created: 2026-10-23
revised: 2026-11-01
written_against: "[[Week 3]]; [[Week 4]]; [[Week 5]]; [[Week 6]]; [[29-09-2026]]; [[20 Scope, Limitations and Closing Defence]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 22 of the PP live presentation template and for the questions after it. The duration is up to twenty minutes **including questions**, so the Q&A is a material share of the assessed performance rather than an epilogue, and the communication criterion explicitly assesses responses to questions. Sentiment is out of scope throughout.*

---

> [!NOTE]
> **Revised 1 November 2026.** The Communication criterion scored **52 of 100** in the [[24-10-2026]] assessment, marked Critical before 5 November and not finally assessable until the live presentation. §6.9 carries twenty-three items, most of which are deck-building rather than Q&A. What belongs here: one stale answer corrected, a new class of question from someone who has already read the material and found the seams, three questions that currently have no good answer, the fact that **there is no proof of concept to demonstrate**, and a delivery section the note did not have.

## Why this note exists

Two reasons. The template recommends a specific set of backup slides and says examiners expect them. And three questions are already on the record as likely, because panel members asked them and the answers were either incomplete or never written down.

The template's own caution is worth keeping: backup slides are not a substitute for a clear presentation, and they are used only when answering.

---

## Part 1. The backup set

The six the template names, with what each holds and where the material is.

| Backup slide | Purpose during questions | Source |
|---|---|---|
| **Literature and gap matrix** | Defend novelty and the evidence base. The clause-by-clause contrast against six named systems is the single strongest artefact here | [[04 Evidence to Research Gap]] Part 2, and the gap matrix |
| **Requirements traceability** | Show the chain from source to requirement to test to evidence in one table | [[10 Requirements]] Part 6, [[15 Testing, QA and Traceability]] Part 6 |
| **Dataset and preprocessing detail** | Defend data strategy and validity. The verification figures are the persuasive part | [[12 Data and Evidence Strategy]] Parts 1 to 3 |
| **Baselines and metrics detail** | Defend the evaluation design, especially the oracle arm and the inverse-MSE arm | [[14 Evaluation and Experimental Design]] Parts 2 and 6 |
| **Architecture and technical detail** | Defend feasibility. The layered view plus the dependency chain | [[11 Architecture and Indicative Solution]] Parts 1 and 2 |
| **AI use and verification** | Defend ownership and academic integrity | [[16 Iteration, Feedback, Change and AI Verification]] Parts 3 and 4 |

Two worth adding beyond the template's list, because both answer questions already asked:

| Extra backup | Why |
|---|---|
| **Derivation of the weighting function** | A panel member asked directly whether the equation came from an AI tool. A term-by-term map to the supporting papers answers it in seconds |
| **The news and sentiment exclusion defence** | Explicitly flagged by a panel member as something examiners are likely to ask, and as worth marks if defended well |

---

## Part 2. Questions already on the record

These were asked by panel members. Two of the three were not answered at the time.

| Question | Asked | Position now |
|---|---|---|
| **How does the system account for news-driven market movement with no sentiment component?** | [[Week 5]] §2.5, with the explicit framing that he was not asking for sentiment back | Answered in [[20 Scope, Limitations and Closing Defence]] Part 4. News reaches the system through its measured consequences in volatility, persistence and liquidity. Reactive rather than anticipatory, and say so |
| **Did the weighting equation come from an AI tool?** | [[Week 5]] §2.4, in passing and not pressed | Answered in [[16 Iteration, Feedback, Change and AI Verification]] Part 4. Each term mapped to supporting papers, with the confidence term flagged as the one resting most on my own reasoning |
| **Have you confirmed the gap rather than hypothesised it?** | [[Week 4]] §2.2 | Partly. The clause-by-clause contrast is the confirmation; the structured comparison across aggregation method, regime detection, liquidity treatment and evaluation protocol that was asked for is still outstanding matrix work |
| **Is adding two agents a strong enough technical contribution?** | [[Week 3]] and [[Week 4]] §2.4 | It is not, and that is why the contribution is the mechanism rather than the agent set. Both panel members independently reached the same conclusion |
| **Why these conditioning variables and not others?** | Implied throughout | Each has local measured evidence, and the macro block was rejected on evidence rather than omitted. The parsimony rule is that any addition must beat the existing set out of sample |

---

## Part 2a. Questions the 24 October review makes near-certain

`[ADDED 1 NOVEMBER 2026]` A different class from Part 3. These come from someone who has read the material and found the seams, so they arrive precisely rather than vaguely. Five have good answers now. The sixth does not, and is in Part 2b.

| Question | The answer |
|---|---|
| **Why do liquidity and volatility vote rather than act as constraints?** §6.7 says they "may operate more naturally as state estimators or constraints than as independent voting agents" | The state vector is **not built from agent output**. $L_t$, $V_t$ and $P_t$ are computed at the state layer directly from market data, so the agents and the state share a data source but not an output path, and no agent's vote feeds the weight it receives. Concede the residual rather than fight it: $A_L$'s view and $L_t$ come off the same volume series so they correlate, which is a correlation and not a feedback loop, and both the pairwise error correlation and the volatility-liquidity collinearity check are pre-registered for exactly that. Full argument in [[20 Scope, Limitations and Closing Defence]] Part 1a |
| **Why four agents rather than three?** | Error cancellation, and nothing else. Unlike methods make unlike errors, so combining them cancels some of that error, and dropping either market-state agent removes a whole error mode rather than a redundant one. **The part that matters: it is falsifiable.** The per-input ablation measures whether each agent earns its vote, and if one contributes nothing attributable the set shrinks and that is a finding. The agent set is provisional, not settled |
| **What is the minimum you need to build to test your main contribution?** | Nine components, and the list is written down: the point-in-time data layer, the output contract, at least two unlike agents, the state vector with $L_t$, the operator with its abstention floor, arms $B_1$, $P$ and $B_3$ over cached outputs, the A3 sweep, the four state ablations, and the cost-adjusted metric with class balance and Matthews correlation. Six further things are enhancement and have a written drop order. **One rule: nothing proceeds past the required list until $B_1$ against $P$ has run end to end.** [[20 Scope, Limitations and Closing Defence]] Part 2a |
| **Is the oracle an achievable strategy?** §7 says treat it as a hindsight diagnostic upper bound | **No, and it is never presented as one.** It is fitted on the test window, so it is unattainable by construction. It exists to price estimation cost in this project's own data and units, which is what separates a wrong hypothesis from a hard estimation problem: no oracle gain means the conditioning idea is wrong, gain in the oracle without gain in the estimate means an estimation problem with a number attached |
| **Where is your proof of concept?** | The 24 October instruction set aside implementation, coding, model development, experimentation and proof-of-concept work until 5 November, recorded as Final, on the reasoning that the proposal is an assessment in its own right. §8 of that note states the proposal must **describe** the mechanism rather than demonstrate it. **So there is nothing to run, by instruction rather than by failure**, and the feasibility evidence is the data work: a pipeline reconciled at 0.13 percent against published annual figures and 99.93 percent against an independent archive, a secured corpus of 22,893 filings, and the adjusted panel |

---

## Part 2b. Three questions that currently have no good answer

`[ADDED 1 NOVEMBER 2026]` Written down because meeting these cold is worse than meeting them prepared, and because "I know about this, here is the reconciliation I am running" is a far better answer than surprise. Two are §7 **Critical** and one is §7 **High**.

| Question | Why it bites | The holding answer, and what closes it |
|---|---|---|
| **Your success criterion uses an interquartile range. The interquartile range of what?** | §7, High. The margin is settled in [[07 Research Questions, Aim and Objectives]] and [[14 Evaluation and Experimental Design]] as exceeding the IQR of $B_1$ across repeated windows, and **the estimand, the test and the decision rule that go with it are not specified**. A margin without a named distribution is not a decision rule | <font color="#ff0000">**Proposed, not yet settled.**</font> The estimand is the per-fold difference in cost-adjusted return between $P$ and $B_1$ across walk-forward folds; the distribution is $B_1$'s own fold-to-fold dispersion over those same folds; the rule is that the median fold difference must exceed that IQR, with a HAC-adjusted paired test and a stationary bootstrap at $\alpha = 0.05$. **This must be confirmed and written into notes 07 and 14 before the slide claims it** |
| **Your slide says 355 securities. Your dataset worksheet says 323.** | §7, Critical. D22 records 323 including 17 rights-issue securities, against 355 on slide 1 | Reconciliation, not a correction. §7 wants **one defined raw universe, one cleaned universe and one final eligible universe, with every exclusion explained**. The 355 core and 233 candidate figures are after excluding rights, warrants, preference and unit instruments and after dropping DOCK on 24 October; the 323 is a different cut. Until the three universes are named and reconciled, quote the figure with its definition attached rather than bare |
| **You say roughly 817,000 records. Your worksheet says 829,070.** | §7, Critical | Same shape of answer. §7 asks for an auditable reconciliation of **raw, rejected and accepted** record counts. The 853,535 traded rows, the 817k used in the archive cross-check and the 829,070 in D22 are three different populations and are currently quoted as if interchangeable |

> **The rule that covers all three**, from §7: four statuses stay distinct everywhere. A source identified, a dataset downloaded, a derived dataset constructed, and that derived dataset validated.

---

## Part 3. Questions to expect that nobody has asked yet

Written out because the ones that hurt are the ones answered for the first time in the room.

| Likely question | The honest answer |
|---|---|
| **What if equal weights wins?** | That is the field's prior and an acceptable outcome, decided in advance with the margin and the test pre-registered. The review that documents the finding says there is no comprehensive guidance on when to prefer which, so an answer on a thin frontier market is worth having either way |
| **Is this not just an ensemble with extra steps?** | An ensemble with fixed or performance-derived weights is baseline $B_2$ and baseline $B_3$. The question is whether conditioning on measured exogenous state beats both, and those arms exist precisely so that question has an answer |
| **Why four agents?** | Provisional rather than settled, and unchanged by the reviews rather than confirmed by them. Three or four well-defined agents is better research than six loosely justified ones, and the fundamental agent may be stubbed at this stage |
| **How do you know the agents are actually heterogeneous?** | Currently asserted. Pairwise error correlation is a pre-registered diagnostic, and if the correlations are high the error-cancellation argument weakens and that is reported |
| **Your fundamental agent does not work yet. Does the contribution survive?** | The orchestration claim is tested over whichever agents emit the contract, and the agent-on-and-off ablation is what measures its contribution. A stubbed agent is reported as stubbed, and a zero delta from a stub is not presented as a finding |
| **Why not use an LLM to set the weights?** | Capacity. An observed performance sign-flip under a small regularisation change, on a larger universe and a longer history than this one, is the argument for a low-capacity form that can be swept and reported |
| **Is 20 counters enough?** | `[CORRECTED 27 OCTOBER 2026]` The candidate universe is **233** voting securities meeting the screen, out of a core universe of 355. The superseded figure was 234, corrected when DOCK was dropped on 24 October. The proof of concept runs on around nine, stratified across the liquidity cross-section, because the mechanism needs liquidity to vary both across and within counters |
| **Your data is not adjusted for corporate actions. Are your numbers wrong?** | `[CORRECTED 1 NOVEMBER 2026]` **It is adjusted.** The adjusted panel was built on **23 October** from the purchased registers, carrying a price-only `adj_close` and a total-return `tr_close`, with 31 register corrections each confirmed against both price and issued quantity. `tr_close` is primary, because the benchmark is ASTRI and a total-return series against a total-return index is the like-for-like comparison. The detect-and-exclude workaround is withdrawn. **What survives is narrower and is worth volunteering:** no documented date in the registers is an ex-date, they were recovered from measured price drops, and `corporate_actions.csv` records **259 events as approximate**, so daily-return models drop or flag those days while longer horizons are unaffected |
| **What happens if the exchange never sends bid, ask and depth?** | Nothing collapses. Two data levels were declared in advance, the proxy route is the plan and the microstructure route is the enhancement |
| **How much of this did AI write?** | **Lead with the verification, not the assistance.** The claims in this proposal trace to a paper I read or a measurement I ran, and the checking that establishes it is documented rather than asserted. The audit found **thirteen substantive errors across 59 notes, four adjudicated against the original PDFs**, including one note that had reversed a paper's own ablation finding and two that asserted something the paper explicitly withholds. **A verification process that has never caught anything is not evidence of correctness**, which is why the figure worth quoting is what it caught. Assistance was used in search, drafting and synthesis, and in every case the check is reading the source |

---

## Part 4. Three numbers worth having memorised

For the moment when a specific figure would settle a question faster than an argument.

- **$p = 0.0041$**, trading volume Granger-causing the index, where money supply and inflation reach nothing. This is the one-line case for liquidity being the centre.
- **99.93 percent** close agreement across 817k rows against an independent archive, with turnover reconciled to the published annual figures at 0.13 percent. The data is checked, not assumed.
- **10.36 points** of total-return degradation from an agent the architecture could not notice. The problem is measured, not hypothesised.

---

## Part 5. Three things not to do in questions

- **Do not read silence as approval.** A question that was not pressed is not a question that was answered, and a favourable remark in passing does not freeze anything.
- **Do not accept a premise that was already retired.** If the superseded fixed-weight wording is quoted back, note that the current formulation is sharper, that many reviewed systems carry no weighting quantity at all, and move on rather than defending the old phrasing.
- **Do not promote a panel suggestion to a decision in the room.** Panel feedback is advisory unless the supervisor confirms it, which is the standing rule across every session note, and a suggestion to reintroduce sentiment is a conflict with a Final decision rather than an action.

---

## Part 5a. Delivery

`[ADDED 1 NOVEMBER 2026]` §6.9 lists delivery items this note did not cover. The criterion cannot be finally assessed until the live presentation, so preparation here is worth more than anywhere else in the deck.

**Explain each research question and its evaluation without reading the slide.** §6.9 asks for this by name. The test is whether MRQ, SQ1 and SQ2 can each be stated, justified and paired with how it is answered, in roughly thirty seconds each, looking at the examiner rather than the screen. These are the three sentences the whole proposal rests on and they are the ones most likely to be read aloud under pressure.

**Rehearse against a clock, not against a feeling.** The duration is unresolved and the conflict is recorded in [[_Proposal Notes Index]]: the Marking Rubric's Threshold tab says up to twenty minutes **including** questions, the Student Guide says twenty **followed by** examiner questions. Rehearse to the stricter reading, thirteen to fifteen minutes of delivery, because overrunning costs marks under this criterion directly while finishing early costs nothing.

**Ownership is assessed, and it is the one thing no backup slide can supply.** §6.9's last item is demonstrating independent ownership of the research decisions. The material that proves it already exists: the term-by-term derivation of the weighting function with the confidence term flagged as the one resting most on my own reasoning, the eight withdrawn claims, and the thirteen corrections the verification process caught. Ownership is shown by explaining **why a decision went the way it did**, including the ones that cost something, rather than by describing what was built.

**There is no live demonstration, and that is the answer rather than a gap.** §6.9 asks for an alternative demonstration method if the proof of concept cannot run. It cannot run because it was not built, by instruction. See Part 2a.

---

## Part 6. Open decisions

1. **How many backup slides are actually built.** Eight is a lot of preparation for a twenty-minute slot. The literature contrast, the traceability chain and the derivation map are the three that answer questions already on the record.
2. **Whether to volunteer the news defence during the talk.** Raising it unprompted in the limitations slide costs perhaps twenty seconds and removes the sharpest question from the room. My reading is that it is worth it.
3. **Timing split.** At up to twenty minutes including questions, five to seven minutes of Q&A is a reasonable assumption and should be rehearsed as such, because overrunning the talk costs marks under the communication criterion directly.

---

**Related notes.** [[20 Scope, Limitations and Closing Defence]] for the exclusion defence and the closing answers. [[16 Iteration, Feedback, Change and AI Verification]] for the derivation map. [[Week 3]], [[Week 4]] and [[Week 5]] for the questions as asked. [[Week 6]] for the items still to raise with the panel.

**Language discipline applies here too.** Answers scope claims to the conditions they were tested under, and an open question is named as open rather than answered.
