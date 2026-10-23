---
status: current
created: 2026-10-23
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

## Part 1. Research risks

These threaten the claim rather than the build, and they are the ones worth leading with because they show the contribution has been pressure-tested.

| Risk | Likelihood and impact | Mitigation | Contingency or fallback |
|---|---|---|---|
| **State conditioning adds nothing beyond reacting to recent agent performance** | Moderate likelihood, high impact. <font color="#ffc000">This is the risk that actually threatens the contribution</font> | The discounted inverse-MSE arm is run specifically to detect it, rather than being left out of the comparison | If that arm matches the proposal, the finding is that performance reactivity is sufficient on this market, which is reportable and attributable |
| **Equal weighting wins** | Moderate to high, given fifty years of evidence that it is hard to beat | Equal weight is the pre-registered primary benchmark rather than a convenience baseline, and the margin and test are fixed before the run | Decided in advance that a null is acceptable. The review documenting the finding states there is no comprehensive guidance on when to prefer which, so an answer on a thin frontier market is worth having either way |
| **Entropy collapse: the orchestrator converges on near-constant weights** | Moderate, high impact on the claim | Weight-distribution entropy over time as a pre-registered diagnostic | Observed rather than hypothetical, since one reviewed system's weight trace is near-binary with three of six curves barely off the floor. If it occurs, report it with the trace |
| **The orchestrator zeroes the fundamental agent permanently rather than conditionally** | Moderate | Weight trajectory around reporting dates as the natural test of whether the mechanism is conditional or merely selective | If permanent, heterogeneity survives on paper while the system behaves as three agents, and that has to be stated rather than presented as four-agent evidence |
| **The pool is less heterogeneous than claimed** | Unknown until measured | Pairwise error correlation across the four agents, plus a separate check on whether the volatility and liquidity constructs are partly measuring the same thing | If correlations are high, the error-cancellation argument weakens accordingly and is reported as weakened |
| **Weights move only in the two or three most volatile months and are inert otherwise** | Moderate | Quiet and stressed sub-periods reported separately, with friction charged either way | A mechanism that only works in crisis is a narrower claim, not a failed one, provided it is described that way |
| **The state vector grows as reviews suggest additions, and overfits** | Moderate | Any addition must beat the existing set out of sample on the ablation protocol. The cited warning is a result where 44 predictors on 84 observations win in sample everywhere and lose out of sample everywhere | The static learned-weight arm stays in as the shrinkage-equivalent control |

---

## Part 2. Data risks

| Risk | Likelihood and impact | Mitigation | Contingency or fallback |
|---|---|---|---|
| **The price series is not adjusted for corporate actions** | <font color="#ff0000">Certain, and currently realised.</font> Very high impact, since every return sits downstream of it | Jump detector run before the liquidity screen, flagging close-to-close ratios near simple split ratios with no matching turnover behaviour. Registers purchased from the exchange | Select proof-of-concept counters with no detected event in the window, state the rule, report how many counters it removed and the direction of the exclusion bias, since counters that split are disproportionately ones that rose |
| **Bid, ask and depth never arrive** | Moderate to high. None of the Data Library's forty items contains any | Two data levels declared in advance, so the sub-gap does not collapse if order-book data cannot be obtained | Level A, the proxy route, is guaranteed feasible and is the plan. Level B is the enhancement. The microstructure route closes and that is reportable rather than fatal |
| **Crossings make counters look liquid without being liquid** | Certain, and quantified | Crossing trades stripped at daily per-security granularity, with stripped and unstripped reported side by side | The small number of cases where crossings exceed panel turnover are resolved or excluded individually with the reason stated |
| **Survivorship bias** | Certain. No listing and delisting register with effective dates is held | Series-end dates used as an explicit proxy for a tradability mask | Labelled as a proxy, with the residual bias reported. Voluntary delistings cannot be separated from failures and that is said plainly |
| **Data Library delivery is late** | Unknown lead time | Order initiated independently of the proof of concept, since the real system needs it regardless | The proof of concept runs on the detect-and-exclude workaround, which was designed for exactly this |
| **Unexamined files carry defects** | Likely. Every file examined so far has carried at least one | Loaders assert expected row counts and date ranges per item, with at least ten items known to change layout, units or meaning partway through their own history | The unexamined items are named as unexamined rather than assumed clean |

---

## Part 3. Technical and build risks

| Risk | Likelihood and impact | Mitigation | Contingency or fallback |
|---|---|---|---|
| **The weights are inert, A2 or A3 fails** | Moderate | A3 scheduled early in the build so there is time to respond rather than discovering it on the final night | This is a finding, not a build failure. Report the sensitivity sweep and investigate whether it is the form, the scaling or the state |
| **The orchestrator is unstable across regularisation** | Expected rather than feared | Swept and reported rather than tuned to a favourable value | The instability is itself the reason the form is low capacity, and reporting it is consistent with that argument |
| **Agent outputs are not byte-identical across arms** | Low if designed correctly, high impact if not | Architectural: agents run once, arms consume the cache | Not recoverable by discipline, which is why it is an architectural constraint rather than a procedure |
| **The fundamental agent is unbuildable in time** | High at proposal stage. No corpus exists | Keep it emitting the contract in a no-data state so the framework stays four-agent and the ablation structure holds | Report it as stubbed with the reason. The on-and-off ablation then runs only in a degenerate sense and that is stated, rather than a zero delta being reported as a finding |
| **The persistence estimator is unstable on short windows** | Moderate | Report the estimator's own stability | Per-regime estimation and a slower-moving cap |
| **Lookahead enters the pipeline** | Low by design, catastrophic if realised | The as-of cursor at the data layer, with violations raising rather than warning, and the cursor built before any agent | Not retrofittable, which is why it is the one ordering rule the build protects absolutely |

---

## Part 4. Schedule risks

| Risk | Likelihood and impact | Mitigation | Contingency or fallback |
|---|---|---|---|
| **Scope creep back into the proof of concept** | Moderate | The 18 October change freeze, as a hard rule with a named date | Any new agent, dataset, gap or technology after that date is a conflict with the rule whatever its merit |
| **The build does not reach the gate** | Realised once already. The build was re-cut to 36 hours when the earlier plan did not survive contact | Droppability declared in advance, naming which task goes first and which cannot be dropped at any price | The persistence experiment was cut rather than the orchestration build, which preserved the thing the gate exists to demonstrate |
| **Writing is displaced by coding** | Moderate | The plan says largely stop coding from 26 October | The deck is built from frozen evidence rather than from work still in progress |
| **Available hours are overestimated** | Moderate. Availability is zero on Mondays and two hours on most weekdays | Hour budgets per increment rather than per week, and one day deliberately zeroed near the deadline | |

---

## Part 5. Responsible-practice and evaluation risks

| Risk | Mitigation | Contingency |
|---|---|---|
| **The mandatory ethics form is not submitted** | Scheduled for 1 November with signatures, and verified as openable on 4 November | <font color="#ff0000">No contingency exists. Non-submission gives an overall mark of zero regardless of the rubric.</font> This is the single highest-impact item on the slide |
| **Simulated slippage is mistaken for measured slippage** | Presented as simulated every time it appears | There is no ground-truth execution data to validate a CSE simulator against, and that is stated rather than implied |
| **A measurement is adopted that cannot be checked** | A stated screening rule: do not adopt a measurement whose output cannot be checked against anything observable on the market it will be applied to | Already applied once, at the cost of the planned spread estimator, which is the evidence the rule is real |
| **Honest significance testing returns nothing** | Decided in advance that this is acceptable | A reviewed portfolio framework runs 16 folds with the same tests and finds no significant mean-return outperformance anywhere |
| **The gap statement goes stale** | A cutoff of 2026-03-09 is attached explicitly | Re-check before submission |

---

## Part 6. The three risks to put on the slide

Twenty-five rows will not fit in the time available. If only three are shown, these carry the most:

1. **The ethics form**, because it is the only risk with no contingency and an unbounded impact.
2. **The corporate-action problem**, because it is realised rather than hypothetical, it is already being mitigated, and it shows the data work is honest about its own state.
3. **The discounted inverse-MSE arm**, because naming the risk that most threatens your own contribution, and showing you built the experiment that would detect it, is the strongest thing this slide can do.

---

## Part 7. Open decisions

1. **Whether likelihood and impact are scored numerically.** The template's column asks for both. Numeric scores on research risks look more precise than the judgement behind them, and a two-level description may be more honest.
2. **Whether the realised risks are shown as realised.** The corporate-action problem and the build re-cut have both already happened. Showing them as live and managed is stronger than listing them as possibilities.
3. **Whether the ethics item belongs here or on slide 19.** It is a project risk and a responsible-practice item. It should appear once, and this slide is where its lack of a contingency reads loudest.

---

**Related notes.** [[Contribution to Knowledge]] Part 5 for the risks against each contribution. [[PoC Specification]] Part 12 for the build risks. [[PoC Build Plan]] §0a for the corporate-action finding and the interim rule. [[17 Project Plan, Milestones and Dependencies]] for the fallbacks as plan branches.

**Language discipline applies here too.** Risks observed in published systems are attributed to those systems, and risks that are my own judgement are labelled as judgement.
