---
status: current
created: 2026-10-23
written_against: "[[Week 3]]; [[Week 4]]; [[Week 5]]; [[Week 6]]; [[29-09-2026]]; [[20 Scope, Limitations and Closing Defence]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 22 of the PP live presentation template and for the questions after it. The duration is up to twenty minutes **including questions**, so the Q&A is a material share of the assessed performance rather than an epilogue, and the communication criterion explicitly assesses responses to questions. Sentiment is out of scope throughout.*

---

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
| **Is 20 counters enough?** | The candidate universe is 234 voting securities meeting the screen. The proof of concept runs on around nine, stratified across the liquidity cross-section, because the mechanism needs liquidity to vary both across and within counters |
| **Your data is not adjusted for corporate actions. Are your numbers wrong?** | On corporate-action days, yes, which is why the proof of concept excludes counters with detected events and reports the exclusion count and its direction of bias. The registers are purchased and the adjusted series is the next data task |
| **What happens if the exchange never sends bid, ask and depth?** | Nothing collapses. Two data levels were declared in advance, the proxy route is the plan and the microstructure route is the enhancement |
| **How much of this did AI write?** | Assistance in search, drafting and synthesis, with verification by reading the source. The audit found thirteen substantive errors across 59 notes, four adjudicated against the original PDFs, which is evidence the verification runs rather than being claimed |

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

## Part 6. Open decisions

1. **How many backup slides are actually built.** Eight is a lot of preparation for a twenty-minute slot. The literature contrast, the traceability chain and the derivation map are the three that answer questions already on the record.
2. **Whether to volunteer the news defence during the talk.** Raising it unprompted in the limitations slide costs perhaps twenty seconds and removes the sharpest question from the room. My reading is that it is worth it.
3. **Timing split.** At up to twenty minutes including questions, five to seven minutes of Q&A is a reasonable assumption and should be rehearsed as such, because overrunning the talk costs marks under the communication criterion directly.

---

**Related notes.** [[20 Scope, Limitations and Closing Defence]] for the exclusion defence and the closing answers. [[16 Iteration, Feedback, Change and AI Verification]] for the derivation map. [[Week 3]], [[Week 4]] and [[Week 5]] for the questions as asked. [[Week 6]] for the items still to raise with the panel.

**Language discipline applies here too.** Answers scope claims to the conditions they were tested under, and an open question is named as open rather than answered.
