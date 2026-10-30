---
status: current
created: 2026-10-23
revised: 2026-10-30
written_against: "[[Contribution to Knowledge]]; [[PoC Specification]]; [[PoC Build Plan]]; [[29-09-2026]]; [[17 Project Plan, Milestones and Dependencies]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 18 of the PP live presentation template. Risk material is unusually well developed in this project and it is scattered across three notes in three different forms, so this one consolidates it into the template's four columns. The template asks for research, technical, data, schedule, responsible-practice and evaluation risks, and all six categories have real entries. Sentiment is out of scope throughout.*

---

## Why this note exists

The supervisor's standard at [[29-09-2026]] §8.1 is one line: **risk and ethics must be project-specific, not generic.** Most of what is below is project-specific in a strong sense, because the risks are named failure modes observed in published systems rather than categories from a template. Entropy collapse is in this register because a reviewed system's own published weight trace shows it.

---

> [!NOTE]
> **Revised 30 October 2026.** This note shares the Project Plan, Feasibility and Risk criterion with [[17 Project Plan, Milestones and Dependencies]], and that criterion scored **32 of 100** in the [[24-10-2026]] assessment. §6.5 asks for a formal register with **probability, impact, priority, owner and mitigation**; this note had rich content in free prose and none of that structure. Every row is now scored. Three rows were understating the project and are corrected. Seven risk areas named in §2.2 had no row and now do. **Ethics is not in this note**: it is a responsible-practice item and lives on slide 19, referenced here once and not repeated.

## The scoring rule

`[ADDED 30 OCTOBER 2026]` Stated so the scores are auditable rather than asserted, and deliberately three-point rather than numeric. A number on a research risk looks more precise than the judgement behind it.

| Axis | Values |
|---|---|
| **Likelihood** | Low, Moderate, High, Certain. **Unmeasured** where the honest answer is that it has not been measured yet, and **Realised** where it has already happened |
| **Impact** | Low, Moderate, High, measured against the research claim rather than against convenience |
| **Priority** | **P1 Critical** = High impact and High or Certain likelihood. **P2 Major** = High impact with lower likelihood, or Moderate impact with High likelihood. **P3 Minor** = the rest. **Managed** or **Closed** where a risk has been realised and handled |
| **Owner** | Me, except where it is not. **Three risks are not mine to control**, and naming them is the point of the column |

An **Unmeasured** likelihood never scores below P2 while it stays unmeasured, because an unknown probability on a high-impact risk is not the same as a low one.

---

## Part 1. Research risks

These threaten the claim rather than the build, and they are the ones worth leading with because they show the contribution has been pressure-tested.

| Risk | Likelihood · Impact · Priority · Owner | Mitigation | Contingency or fallback |
|---|---|---|---|
| **State conditioning adds nothing beyond reacting to recent agent performance** | L Moderate · I High · **P2 Major** · Owner: me<br>_Moderate likelihood, high impact. <font color="#ffc000">This is the risk that actually threatens the contribution</font>_ | The discounted inverse-MSE arm is run specifically to detect it, rather than being left out of the comparison | If that arm matches the proposal, the finding is that performance reactivity is sufficient on this market, which is reportable and attributable |
| **Equal weighting wins** | L High · I High · **P1 Critical** · Owner: me<br>_Moderate to high, given fifty years of evidence that it is hard to beat_ | Equal weight is the pre-registered primary benchmark rather than a convenience baseline, and the margin and test are fixed before the run | Decided in advance that a null is acceptable. The review documenting the finding states there is no comprehensive guidance on when to prefer which, so an answer on a thin frontier market is worth having either way |
| **Entropy collapse: the orchestrator converges on near-constant weights** | L Moderate · I High · **P2 Major** · Owner: me<br>_Moderate, high impact on the claim_ | Weight-distribution entropy over time as a pre-registered diagnostic | Observed rather than hypothetical, since one reviewed system's weight trace is near-binary with three of six curves barely off the floor. If it occurs, report it with the trace |
| **The orchestrator zeroes the fundamental agent permanently rather than conditionally** | L Moderate · I Moderate · **P3 Minor** · Owner: me<br>_Moderate_ | Weight trajectory around reporting dates as the natural test of whether the mechanism is conditional or merely selective | If permanent, heterogeneity survives on paper while the system behaves as three agents, and that has to be stated rather than presented as four-agent evidence |
| **The pool is less heterogeneous than claimed** | L Unmeasured · I High · **P2 Major** · Owner: me<br>_Unknown until measured_ | Pairwise error correlation across the four agents, plus a separate check on whether the volatility and liquidity constructs are partly measuring the same thing | If correlations are high, the error-cancellation argument weakens accordingly and is reported as weakened |
| **Weights move only in the two or three most volatile months and are inert otherwise** | L Moderate · I Moderate · **P3 Minor** · Owner: me<br>_Moderate_ | Quiet and stressed sub-periods reported separately, with friction charged either way | A mechanism that only works in crisis is a narrower claim, not a failed one, provided it is described that way |
| **The state vector grows as reviews suggest additions, and overfits** | L Moderate · I High · **P2 Major** · Owner: me<br>_Moderate_ | Any addition must beat the existing set out of sample on the ablation protocol. The cited warning is a result where 44 predictors on 84 observations win in sample everywhere and lose out of sample everywhere | The static learned-weight arm stays in as the shrinkage-equivalent control |

---

## Part 2. Data risks

| Risk | Likelihood · Impact · Priority · Owner | Mitigation | Contingency or fallback |
|---|---|---|---|
| **The price series is not adjusted for corporate actions** | `[CLOSED 30 OCTOBER 2026]`<br>Was L Certain · I High · **P1 Critical** · Owner: me | Registers purchased from the exchange, and **the adjusted panel was built on 23 October**, carrying `adj_close` and `tr_close` with 31 register corrections each confirmed against both price and issued quantity | **Realised, mitigated and closed.** The detect-and-exclude workaround is withdrawn. What survives is the ex-date row below, which is narrower |
| **Bid, ask and depth never arrive** | L High · I Moderate · **P2 Major** · **Owner: the exchange**<br>_Moderate to high. None of the Data Library's forty items contains any_ | Two data levels declared in advance, so the sub-gap does not collapse if order-book data cannot be obtained | Level A, the proxy route, is guaranteed feasible and is the plan. Level B is the enhancement. The microstructure route closes and that is reportable rather than fatal |
| **Crossings make counters look liquid without being liquid** | L Certain · I High · **P1 Critical** · Owner: me<br>_Certain, and quantified_ | Crossing trades stripped at daily per-security granularity, with stripped and unstripped reported side by side | The small number of cases where crossings exceed panel turnover are resolved or excluded individually with the reason stated |
| **Survivorship bias** | L Certain · I Moderate · **P2 Major** · Owner: me<br>_Certain. No listing and delisting register with effective dates is held_ | Series-end dates used as an explicit proxy for a tradability mask | Labelled as a proxy, with the residual bias reported. Voluntary delistings cannot be separated from failures and that is said plainly |
| **Data Library delivery is late** | `[CLOSED 30 OCTOBER 2026]`<br>Was L Unmeasured · I Moderate · **P3 Minor** · **Owner: CSE Data Library** | Order initiated independently of the proof of concept, since the real system needs it regardless | **Delivered.** The corporate-action registers arrived and the adjusted panel was built from them on 23 October |
| **Ex-date reliability: no documented date in the registers is an ex-date** | `[ADDED 30 OCTOBER 2026]`<br>L Certain · I Moderate · **P2 Major** · Owner: me<br>_The residual that survives the adjusted panel, recorded as requirement **DR10**_ | Ex-dates recovered from measured price drops, with reliability carried as a field. `corporate_actions.csv` records **259 events as approximate** in `ex_date_basis` | Daily-return models drop or flag the days around approximate events. Longer horizons are unaffected, and the affected count is reported |
| **Data licensing is breached or the terms are misread** | `[ADDED 30 OCTOBER 2026]`<br>L Low · I High · **P2 Major** · Owner: me<br>_Named in §2.2 as a required risk area. It was treated in [[19 Responsible Research and Project Considerations]] as a settled decision rather than as a live risk_ | Purchased at the student rate rather than scraped. Licensing and reuse terms recorded as a field on every dataset row. Benchmark licences respected individually, one non-commercial and one permissive | Nothing is redistributed. If a term proves narrower than read, the affected item is withdrawn from the released pipeline and the result reported without it |
| **Unexamined files carry defects** | L High · I Moderate · **P2 Major** · Owner: me<br>_Likely. Every file examined so far has carried at least one_ | Loaders assert expected row counts and date ranges per item, with at least ten items known to change layout, units or meaning partway through their own history | The unexamined items are named as unexamined rather than assumed clean |

---

## Part 3. Technical and build risks

| Risk | Likelihood · Impact · Priority · Owner | Mitigation | Contingency or fallback |
|---|---|---|---|
| **The weights are inert, A2 or A3 fails** | L Moderate · I High · **P2 Major** · Owner: me<br>_Moderate_ | A3 scheduled early in the build so there is time to respond rather than discovering it on the final night | This is a finding, not a build failure. Report the sensitivity sweep and investigate whether it is the form, the scaling or the state |
| **The orchestrator is unstable across regularisation** | L High · I Low · **P3 Minor** · Owner: me<br>_Expected rather than feared_ | Swept and reported rather than tuned to a favourable value | The instability is itself the reason the form is low capacity, and reporting it is consistent with that argument |
| **Agent outputs are not byte-identical across arms** | L Low · I High · **P2 Major** · Owner: me<br>_Low if designed correctly, high impact if not_ | Architectural: agents run once, arms consume the cache | Not recoverable by discipline, which is why it is an architectural constraint rather than a procedure |
| **The fundamental agent is unbuildable in time** | `[REASSESSED 30 OCTOBER 2026]`<br>L Moderate · I Moderate · **P3 Minor** · Owner: me<br>_Was High on the grounds that no corpus existed. **22,893 filings are now secured**, 2012-01-01 to 2026-10-04, every probed file carrying a text layer and every filename carrying the announcement date. What remains is build time, not data_ | Keep it emitting the contract in a no-data state so the framework stays four-agent and the ablation structure holds. Milestone **M5**, 10 January 2027 | Report it as stubbed with the reason. The on-and-off ablation then runs only in a degenerate sense and that is stated, rather than a zero delta being reported as a finding |
| **The persistence estimator, the FIGARCH-family long-memory estimate, is unstable on short windows** | L Moderate · I Moderate · **P3 Minor** · Owner: me | Report the estimator's own stability on rolling windows rather than a single point estimate | Per-regime estimation and a slower-moving cap, with the instability reported either way |
| **Confidence estimates do not transfer across architectures** | `[ADDED 30 OCTOBER 2026]`<br>L Unmeasured · I High · **P2 Major** · Owner: me<br>_Named in §6.5 as a technical risk. It sits in [[07 Research Questions, Aim and Objectives]] as SQ2 and in [[16 Iteration, Feedback, Change and AI Verification]] as the thinnest term in the derivation_ | Each raw score mapped through its own empirical accuracy-at-threshold curve, with calibration monotonicity asserted as a test | If the four do not land on a common scale, the operator is combining incommensurable quantities and **that is reported as the finding**, with the per-agent curves shown rather than a single blended confidence |
| **The orchestration mechanism is harder to implement than the design implies** | `[ADDED 30 OCTOBER 2026]`<br>L Moderate · I High · **P2 Major** · Owner: me<br>_Named in §2.2 as technical complexity_ | The form is deliberately low capacity, which is an argument from statistics in [[11 Architecture and Indicative Solution]] and cheap to implement as a consequence. Milestone **M6** sits eight days before IPD so there is room to respond | Fall back to the gated linear form with the floor and abstention channel only, dropping the liquidity coupling to a reported ablation rather than a component |
| **Findings do not generalise beyond the tested window and universe** | `[ADDED 30 OCTOBER 2026]`<br>L Moderate · I Moderate · **P3 Minor** · Owner: me<br>_Named in §2.2 alongside overfitting and leakage, and distinct from both_ | The claim is scoped in advance to one market, one window and one universe, and the evaluation is decomposed by regime and by liquidity tier rather than pooled | This is **bounded rather than mitigated**. A result that holds in one stratum and not another is a narrower finding, not a failed one, provided it is described that way |
| **The published persistence baseline does not reproduce** | `[ADDED 30 OCTOBER 2026]`<br>L Moderate · I Moderate · **P3 Minor** · Owner: me<br>_Named in §2.2. The persistence experiment is a reproduction, so this is a real exposure rather than a generic one_ | Reproduction fidelity tested against the published behaviour before any substitution is made, on the source paper's own four-ETF environment, which needs no CSE data | A failed reproduction is reported as a failed reproduction. The substitution experiment is not run on top of a baseline that does not match, since the delta would mean nothing |
| **Lookahead enters the pipeline** | L Low · I High · **P2 Major** · Owner: me<br>_Low by design, catastrophic if realised_ | The as-of cursor at the data layer, with violations raising rather than warning, and the cursor built before any agent | Not retrofittable, which is why it is the one ordering rule the build protects absolutely |

---

## Part 4. Schedule risks

| Risk | Likelihood · Impact · Priority · Owner | Mitigation | Contingency or fallback |
|---|---|---|---|
| **Scope creep back into the proof of concept** | L Low · I Moderate · **P3 Minor** · Owner: me<br>_Moderate_ | The 18 October change freeze, as a hard rule with a named date | Any new agent, dataset, gap or technology after that date is a conflict with the rule whatever its merit |
| **The build does not reach the gate** | L **Realised** · I Moderate · **Managed** · Owner: me<br>_Realised once already. The build was re-cut to 36 hours when the earlier plan did not survive contact_ | Droppability declared in advance, naming which task goes first and which cannot be dropped at any price | The persistence experiment was cut rather than the orchestration build, which preserved the thing the gate exists to demonstrate |
| **Writing is displaced by coding** | L Moderate · I High · **P2 Major** · Owner: me<br>_Moderate_ | The plan says largely stop coding from 26 October | The deck is built from frozen evidence rather than from work still in progress |
| **Computing resources are insufficient** | `[ADDED 30 OCTOBER 2026]`<br>L Low · I Low · **P3 Minor** · Owner: me<br>_Named in §2.2 paired with development time. Answerable rather than open_ | [[17 Project Plan, Milestones and Dependencies]] Part 1c: the orchestrator is a low-capacity form rather than a network, no component is trained by reinforcement learning, and agents execute once per run with five arms consuming cached outputs, so a five-arm comparison costs one agent pass | The only line item that could carry real cost is the model backbone for the fundamental agent, and a local open-weight model is the zero-cost fallback that bounds it |
| **Available hours are overestimated** | L Moderate · I High · **P2 Major** · Owner: me<br>_Moderate. Availability is zero on Mondays and two hours on most weekdays_ | Hour budgets per increment rather than per week, and one day deliberately zeroed near the deadline | |

---

## Part 4a. Contingency reserve

`[ADDED 30 OCTOBER 2026]` §6.5 asks for reserve against failed experiments, debugging and data correction. Neither this note nor [[17 Project Plan, Milestones and Dependencies]] stated one.

**Fifteen per cent of each stage is held unallocated.** That is roughly **43 of the 288 hours** to IPD and roughly **32 of the 216 hours** from IPD to final submission. It is not spare capacity to be planned into; it is the budget the register above draws on when a P1 or P2 risk lands.

**What it is for, and the evidence that it is needed.** The build has already been re-cut once, from the original plan to 36 hours, when it did not survive contact. Every data file examined so far has carried at least one defect, so data correction is a certainty rather than a possibility. And a failed experiment on the research risks above costs a rerun, not just a rethink.

**What happens when the reserve is exhausted.** The droppability order is declared in advance rather than chosen under pressure: the persistence experiment goes first, because it sits off the critical path entirely and runs on a published paper's own environment. The orchestration build is what cannot be dropped at any price, because it is the thing every acceptance criterion is defined on.

---

## Part 5. Responsible-practice and evaluation risks

| Risk | Likelihood · Impact · Priority · Owner | Mitigation | Contingency |
|---|---|---|---|
| **Simulated slippage is mistaken for measured slippage** | L Low · I Moderate · **P3 Minor** · Owner: me | Presented as simulated every time it appears | There is no ground-truth execution data to validate a CSE simulator against, and that is stated rather than implied |
| **A measurement is adopted that cannot be checked** | L Low · I High · **P2 Major** · Owner: me | A stated screening rule: do not adopt a measurement whose output cannot be checked against anything observable on the market it will be applied to | Already applied once, at the cost of the planned spread estimator, which is the evidence the rule is real |
| **Honest significance testing returns nothing** | L High · I Low · **P3 Minor** · Owner: me | Decided in advance that this is acceptable | A reviewed portfolio framework runs 16 folds with the same tests and finds no significant mean-return outperformance anywhere |
| **The gap statement goes stale** | L Moderate · I Moderate · **P3 Minor** · Owner: me | A cutoff of 2026-03-09 is attached explicitly | Re-check before submission |

---

## Part 6. The three risks to put on the slide

`[REBUILT 30 OCTOBER 2026]` Thirty-four rows will not fit in the time available. Two of the three previously chosen have changed status: ethics has moved to slide 19, and the corporate-action problem is closed. The replacements are chosen so the three cover a research risk, a data risk and a plan risk rather than three of one kind.

1. **The discounted inverse-MSE arm, $B_3$.** Naming the risk that most threatens your own contribution, and showing you built the experiment that would detect it, is the strongest thing this slide can do. If reacting to recent agent performance does as well as conditioning on measured market state, the conditioning is not earning its place, and that arm exists to find out.
2. **Ex-date reliability, DR10.** Realised, measured at 259 approximate events, mitigated by carrying reliability as a field, and narrow enough to state in one sentence. It replaces the corporate-action row and does the same job better, because it shows the data work is honest about what survives after a problem is solved rather than before.
3. **Available hours, with the fifteen per cent reserve.** The plan criterion assesses realism, and the build has already been re-cut once. A stated reserve with a number, and a declared droppability order naming what goes first, is more convincing than a plan with no slack in it.

**If a fourth fits**, the bid-ask row, because it is the clearest case of a fallback declared in advance rather than adopted after a failure, and because its owner is the exchange rather than you.

> **Ethics is not presented on any slide**, decided 30 October, and it is not a row in this register. It is a mandatory qualifying submission rather than a project risk: non-submission voids the entire proposal mark regardless of the rubric, which is a different kind of thing from a risk with a mitigation and a fallback. It is tracked in [[29-09-2026]] §11.6 and in [[19 Responsible Research and Project Considerations]], and not presenting it changes nothing about submitting it.

---

## Part 7. Open decisions

`[UPDATED 30 OCTOBER 2026]` All three closed. The closures are recorded rather than deleted.

1. ~~Whether likelihood and impact are scored numerically.~~ **Closed 30 October: scored, but not numerically.** A three-point scale on each axis with a stated derivation rule, keeping the original prose beneath each score. That meets §6.5's requirement for probability, impact and priority without inventing precision the judgement cannot carry. The rule is above Part 1 so it can be checked.
2. ~~Whether the realised risks are shown as realised.~~ **Closed 30 October: yes.** Realised risks carry **Realised**, **Managed** or **Closed** in the priority field rather than being removed. The corporate-action row and the Data Library row are both closed in place, which shows a register that is maintained rather than drafted once.
3. ~~Whether the ethics item belongs here or on slide 19.~~ **Closed 30 October: neither.** The row is removed from this register and ethics is not presented on any slide. It is a mandatory qualifying submission, not a scored risk, and it is tracked outside the deck. Part 6 carries one line saying so.
4. `[RAISED 30 OCTOBER 2026]` **Whether the register appears on the slide as a matrix.** Thirty-four scored rows support a 3x3 heat map showing where the risks cluster, which communicates faster than three bullet points. It also invites a question about any cell that looks empty.

---

**Related notes.** [[Contribution to Knowledge]] Part 5 for the risks against each contribution. [[PoC Specification]] Part 12 for the build risks. [[PoC Build Plan]] §0a for the corporate-action finding and the interim rule. [[17 Project Plan, Milestones and Dependencies]] for the fallbacks as plan branches.

**Language discipline applies here too.** Risks observed in published systems are attributed to those systems, and risks that are my own judgement are labelled as judgement.
