---
status: current
created: 2026-10-23
written_against: "[[29-09-2026]]; [[20-09-2026]]; [[16-06-2026]]; [[PoC Build Plan]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 17 of the PP live presentation template. The plan to 5 November is detailed and credible. Nothing in the vault goes past that date, and the rubric's plan criterion asks about the whole project, so the stages after the proposal are composed here from the module scopes rather than extracted. Dates beyond 5 November are marked to be confirmed. Sentiment is out of scope throughout.*

---

## Why this note exists

Two gaps, not one. The near-term plan exists in [[29-09-2026]] §11 at the level of individual tasks and hours, which is more than the slide needs. The post-proposal plan does not exist at all: there is no IPD date, no final submission date and no viva date anywhere in the vault, and the only statement of what those stages contain is a three-row table in [[16-06-2026]] §2.2.

The template's instruction is the standard to meet: a credible plan includes dependencies and fallback options, not only dates.

> [!WARNING]
> <font color="#ff0000">Open input.</font> Every date after 5 November 2026 below is marked **TBC**. They should be taken from the module handbook or confirmed with the supervisor before this slide is built. Presenting a plan that stops at the proposal is weaker than presenting one with confirmed stages and unconfirmed dates.

---

## Part 1. The whole project, by stage

The template's four-row table, extended to five because the proposal period is still running.

| Stage | Main work | Milestone or output | Dependency |
|---|---|---|---|
| **Now to PP, to 5 Nov 2026** | Close the SE spine: questions, requirements, architecture, methodology, testing design. Run the orchestration proof of concept and capture its evidence. Build and rehearse the deck | Working core proof of concept, 21-slide deck, signed Ethics Application, recorded video | Corporate-action handling for any quoted return. Ethics form signatures |
| **PP to IPD, TBC** | Adjusted price panel from the purchased registers. Filings corpus harvest. Fundamental agent built live. Full four-agent framework | **Working prototype**, which the module requires at IPD. Chapters 1, 4, 5 and 6 | Data Library delivery, lead time unknown. The filings harvest, which is independent of everything else and should start early |
| **IPD to final build, TBC** | Full build and integration. Cost term inside the allocation objective. The persistence re-levering experiment, which needs no CSE data | Feature-complete artefact. Sub-gap 2 converted from hypothesis to result or reported null | Architecture frozen. Bid, ask and depth if the exchange request succeeds, otherwise the proxy route stands |
| **Testing and evaluation, TBC** | Five arms at full scale, all ablations, regime decomposition, significance testing, stability sweeps | Evaluation dataset and results. The CSE baseline set | A stable artefact. The adjusted panel |
| **Report and finalisation, TBC** | Analysis, limitations, thesis, demonstration, viva preparation | **Fully functional prototype** and the whole thesis | Results complete |

The prototype expectations are the module's own, recorded at [[16-06-2026]] §2.2: no prototype required at the proposal, a working prototype at IPD, a fully functional prototype at the end.

---

## Part 2. The proposal period in detail

126 hours from 29 September to 5 November, adopted as a revised plan after the earlier 182-hour version. Availability is zero on Mondays, two hours Tuesday to Friday, four on Saturday and twelve on Sunday.

| Date | Gate |
|---|---|
| 4 Oct | Research records synchronised, literature and gap frozen |
| 11 Oct | Questions, objectives, requirements, data schema and experimental universe frozen |
| 18 Oct | Architecture and methodology defined, integrated proof-of-concept skeleton working. **Change freeze: no new agents, datasets, research gaps or technologies after this date** |
| 25 Oct | Adaptive orchestration proof of concept with baseline and ablation evidence working |
| 1 Nov | Full slide deck, ethics, backups and proof of concept frozen |
| 5 Nov | Submission complete |

**Honest status against those gates.** The 4 October and 11 October gates were partly met on the research side and not on the software engineering side: the questions, requirements, architecture and methodology were scheduled for 6 to 17 October and were written on 23 October instead. The 18 October build did not start from the position the spec assumed, which is why [[PoC Build Plan]] re-cut it to 36 hours and dropped the persistence experiment. That slippage is recorded rather than smoothed over, and it belongs on this slide as evidence that the plan is monitored rather than decorative.

---

## Part 3. Critical path and dependencies

| Dependency | Blocks | Status |
|---|---|---|
| Corporate-action adjusted price series | Every return, and therefore every agent output, every arm comparison and every number in the evaluation | Registers purchased, delivery lead time unknown. Interim rule is detect and exclude |
| The as-of cursor before any agent | Point-in-time correctness, which cannot be retrofitted | The one ordering rule the build protects |
| Filings corpus harvest | The fundamental agent, and therefore the heterogeneity claim | Not started. Independent of everything else, which is the argument for starting it now |
| Bid, ask and depth from the exchange | The microstructure route, the tick-size classification, and a measured spread | Requested, unanswered. Declared fallback is the proxy route, which was bounded in advance |
| Agents cached before the arms run | The fairness rule, and acceptance criterion A5 | Architectural, designed in |
| Ethics signatures | The entire proposal mark, as a qualifying condition | Scheduled for 1 November |

**The one explicitly unblocked path.** The persistence experiment runs on a published paper's own four-ETF environment and needs no CSE data at all, which takes that sub-gap off the critical path entirely. It was cut from the proposal period for time rather than for dependency, and it is the natural first task after submission.

---

## Part 4. Fallbacks

The template asks for fallback options rather than dates alone, and these were declared in advance rather than invented after a failure.

| If this fails | Fallback |
|---|---|
| Bid, ask and depth never arrive | The two-level data plan declared at [[29-09-2026]] §7.8. Level A, proxy-based liquidity from volume, zero-volume frequency, zero-return frequency, turnover and Amihud, is guaranteed feasible. Level B is the enhancement, not the plan |
| The adjusted series is late | Detect and exclude, selecting proof-of-concept counters with no detected corporate-action event in the window, with the exclusion count and the direction of bias reported |
| The fundamental agent is unbuildable in time | Stub it against a probe set while keeping it emitting the contract, so the on-and-off ablation still runs, and report it as stubbed |
| The weights turn out inert | This is a finding rather than a build failure. Report the sensitivity sweep and investigate whether it is the form, the scaling or the state. A3 is deliberately scheduled early so there is time to respond |
| The universe collapses after the liquidity screen | The surviving count is itself a result. Run on what survives and report the screen |
| The persistence estimator is unstable on short windows | Per-regime estimation and a slower-moving cap, with the instability reported either way |
| Honest significance testing returns nothing | Decided in advance that this is acceptable. A reviewed portfolio framework runs 16 folds with the same tests and finds no significant mean-return outperformance anywhere |

---

## Part 5. How the plan is tracked

Worth one line, because the criterion assesses realism and a tracked plan is more credible than a drawn one.

A task-level tracker covering the proposal period holds 193 atomic tasks against 126 planned hours, with per-task date, workstream, output, dependency, priority, status, completion, a quality rating and an evidence field, plus a 4.5 out of 5 threshold that flags completed tasks below it for rework. Separate sheets carry weekly milestones, a priority improvement log, deliverable definitions of done, and post-deadline live presentation preparation.

> [!NOTE]
> The tracker's own status fields are stale, since it was built on 29 September and the work since has been recorded in the vault notes rather than in the sheet. Either refresh it before the slide is built or present the plan from the notes, but do not present a tracker showing zero completed tasks.

---

## Part 6. Open decisions

1. **The dates after 5 November.** IPD, final submission and viva. Needed from the module handbook or the supervisor.
2. **Whether the slippage in Part 2 is shown.** My reading is yes, briefly, because a plan presented as fully on track invites a question that a plan presented with a recorded deviation does not. The criterion rewards realism.
3. **Whether the tracker is refreshed or retired.** A stale tracker is worse than no tracker on a slide.
4. **Whether the proposal period appears at all**, given that by the presentation it will be nearly complete. It is probably one row rather than the six-gate table.

---

**Related notes.** [[29-09-2026]] §11 for the full task-level plan. [[PoC Build Plan]] for the re-cut build and what was dropped. [[18 Risk, Mitigation and Contingency]] for the risks these fallbacks answer. [[16-06-2026]] §2.2 for the module stage scopes.

**Language discipline applies here too.** Dates not yet confirmed are marked as such rather than estimated.
