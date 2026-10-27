---
status: current
created: 2026-10-23
revised: 2026-10-24
written_against: "[[Research Gap (Final Statement)]]; [[Contribution to Knowledge]]; [[PoC Specification]]; [[29-09-2026]]; [[Week 4]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 7 of the PP live presentation template. The aim, research questions and objectives have been outstanding since 20 September and were rated 1.0 in two separate audits. Nothing here is new research: every question below already exists somewhere in the vault as a candidate wording, and this note selects, sharpens and connects them. Proposed values are marked provisional and can be overruled. Sentiment is out of scope throughout.*

---

## Why this note exists

The research record is strong and the chain that the rubric actually assesses is not. [[29-09-2026]] §11.3 sets the gate as **Gap → RQ → Objective → Requirement → Data → Acceptance/Evaluation fully traceable**, and the first two links have never been written down. Everything downstream, the requirements note and the evaluation protocol in particular, traces back to this note, so it goes first.

> [!NOTE]
> Candidate wordings existed in five places: [[13-09-2026]] §4.3 and §6.9, [[20-09-2026]] §6.2, [[29-09-2026]] §7.1, and [[Week 4]] §2.4. The job here was choosing between them and scoping each one to what the planned experiments can actually answer.

---

## Part 1. The aim

One sentence, build and evaluate. **Approved 24 October, with one word changed.**

> **To design, implement and evaluate a market-state-conditioned orchestration operator that continuously varies the influence of methodologically heterogeneous financial agents over a single shared decision, and to establish, on Colombo Stock Exchange data under a cost-aware and regime-decomposed protocol, under what conditions it earns its place against fixed, static learned and performance-reactive weighting.**

Three things it is doing deliberately. It names an artefact, so the software engineering spine has something to attach to. It names the comparison rather than claiming an improvement, so a null is inside the aim rather than outside it. And it scopes the evidence to one market and one protocol, which is what the language rule requires.

**The word that changed, and why.** It previously read *"to establish ... whether that conditioning earns its place"*. An aim is not a research question, so *whether* broke no rule, but it sat oddly beside a main question framed as *how* and *under what conditions*, and that is the kind of inconsistency an examiner notices without being able to name. *Under what conditions* costs one word and removes it. The same change is made to the project goal in [[03 Problem, Goal and Outcomes]] Part 4.

---

## Part 2. Research questions

> [!important]
> **Restructured 24 October against the supervisor's formatting guideline.** Two rules apply. There is **one main research question** and the rest support it. And **no question, main or supporting, may be answerable yes or no**: each has to admit investigation of how something can be achieved, under what conditions it works, what has to be overcome, and what follows if the initial approach does not succeed. A negative finding is a legitimate contribution provided the question was not framed so that a negative answer ends the inquiry.
>
> The previous RQ1 failed that rule. It read *"Does continuously varying the influence ... produce better decisions than ..."*, which resolves to yes or no. It is reframed below. The previous RQ2 already passed, because it was taken in the supervisor's own wording from [[29-09-2026]] §7.1 and begins *"How should ..."*.

### The main research question

> **MRQ. How should the influence of methodologically heterogeneous financial agents be adapted to measured market state when those agents resolve to a single shared decision, and under what market conditions does such adaptation earn its place against fixed, static learned and performance-reactive weighting?**

| | |
|---|---|
| **Where it comes from** | [[13-09-2026]] §4.3 and §6.9, sharpened by the surviving claim in [[29-09-2026]] §3.1, and independently converged on by the panel in [[Week 4]] §2.4 |
| **How it is answered** | The five-arm comparison, $B_1$ equal weight, $B_2$ static learned, $B_3$ discounted inverse-MSE with no market state, $P$ the proposal, $O$ oracle, run over byte-identical cached agent outputs, with one ablation per state input |
| **What counts as an answer** | A specified weighting form with its functional choices justified, plus a cost-adjusted decision-level comparison against $B_1$ at a pre-registered margin, with class balance and Matthews correlation on the same row, HAC-adjusted and bootstrap tested, and attributable per-input deltas |
| **Why it is not binary** | The first clause asks for a design and its justification, which has to be answered whatever the comparison shows. The second clause asks **under what conditions**, not whether, so a result that holds only in stressed regimes or only above a liquidity threshold is an answer rather than a failure |
| **What the investigation does if adaptation does not earn its place** | Four routes, each pre-specified. The per-input ablations identify which state inputs carry signal and which do not. The oracle gap separates a wrong hypothesis from a hard estimation problem. The quiet against stressed decomposition establishes whether the mechanism is regime-specific rather than inert. The agent error correlation establishes whether the pool was heterogeneous enough for any weighting to matter. Each of those is a reportable finding |
| **The arm that threatens it most** | $B_3$. If reacting to recent agent performance does as well as conditioning on measured exogenous state, then state conditioning is not earning its place on this market, and establishing that is a result |

### Supporting questions

Two, each supporting the main question by establishing a mechanism the main question then evaluates.

> **SQ1. How should a multi-agent decision system alter both execution behaviour and the influence of price-derived agents when market liquidity deteriorates?**

| | |
|---|---|
| **Where it comes from** | [[29-09-2026]] §7.1 verbatim, with §7.4 supplying the coupling $C'_{T,t} = C_{T,t} \cdot g(L_t)$. The supervisor framed it deliberately to move the question away from cost modelling and back into decision systems |
| **How it supports the main question** | Liquidity is one of the four state inputs, and it is the input with the clearest local evidence. This question establishes the mechanism by which that input acts, which the main question then evaluates |
| **How it is answered** | The A3 sensitivity sweep, freezing a date and sweeping $L_t$ over its observed range to record $\partial w / \partial L$, plus the two separating ablations $P - \text{LiquidityReliability}$ and $P - \text{CostObjective}$, plus the participation-rate sweep |
| **Why it is not binary** | It asks how the system should alter two distinct behaviours, so the answer is a specification plus a measured sensitivity, and the separating ablations attribute any effect to the trust channel, the execution channel, or both |
| **What the investigation does if the coupling adds nothing** | The two ablations distinguish an inert trust channel from an inert cost channel. The proxy limitation below bounds what could have been detected at all, which is itself a reportable constraint on the method rather than on the hypothesis |
| **The honest limit** | The cost term rests on proxies for illiquidity rather than on a measurement of what a trade pays, because no validated spread measurement exists for this market. State it in the same breath |

> **SQ2. How can the confidence of architecturally unlike agents be estimated from the structure of their outputs and placed on a common scale, so that it can enter a single shared weighting decision?**

| | |
|---|---|
| **Where it comes from** | [[Contribution to Knowledge]] C2 and K2, which already state comparability across unlike architectures as an open question. The negative evidence is strong enough to motivate it on its own: one reviewed system declares a confidence field in its output contract, puts it in a figure, and never computes with it, while another feeds three model-authored expected returns straight into an exact optimiser with no calibration |
| **How it supports the main question** | $C_{i,t}$ is one of the four inputs to the weighting function. If four agents' confidences are not on a common scale, the operator is combining incommensurable quantities and the main question cannot be answered cleanly, whatever the comparison shows |
| **How it is answered** | Four per-agent mechanisms computed from output structure rather than self-report: whether the extracted program parses and whether every argument traces to a retrieved figure, with step count as a difficulty proxy; realised conformal interval width at target coverage; Theil's $U2$ against the random walk; and a rolling loss ratio against a fixed benchmark. Then one common transform, each raw score mapped through its own empirical accuracy-at-threshold curve on a rolling validation window. Evaluated by the per-agent calibration curves and the $C_{i,t}$ ablation |
| **Why it is not binary** | It asks **how** confidence can be estimated and placed on a common scale, so the deliverable is a method plus a measured comparison of four mechanisms on one agent pool. That comparison exists whatever the calibration quality turns out to be |
| **What the investigation does if comparability is not achieved** | The per-agent calibration curves still establish which mechanisms are well calibrated and which are not, which is a result about the mechanisms rather than about the project. The $C_{i,t}$ ablation establishes whether the term carries signal at all. And a demonstration that four backward-looking competence estimates cannot be made comparable is a direct answer to a question the literature itself lists as open |
| **The honest limit** | All four are backward-looking estimates on rolling windows, so comparability here is empirical rather than theoretical. Having four mechanisms is progress on the problem rather than a solution to it, and that is stated as the position rather than discovered under questioning |

### The third question, withdrawn

A persistence question was carried until 24 October. It read *"Does conditioning the post-shock exposure-restoration schedule on measured volatility persistence improve risk-adjusted outcomes relative to the exponential decay an EWMA half-life assumes?"*

**Withdrawn for two reasons.** It was binary in form, and the experiment that would answer it was cut from the 25 October gate in [[PoC Build Plan]] §6, so it would have stood in the deck with no outcome on slide 3 and no contribution on slide 6.

**What persistence remains as.** A named sub-hypothesis inside the main question's state vector, where $P_t$ is one of the four conditioning inputs and carries its own ablation, plus a pre-registered experiment with the baseline identified and the environment chosen. It runs on a published paper's own four-ETF setup and needs no CSE data, which is why it is off the critical path rather than abandoned.

There is local feasibility evidence that the quantity is estimable on this sample. [[PoC Data Build]] §7 reports GPH at $m = 58$ on the ASPI from 2012 to 2026 giving $\hat{d} = 0.408$ on absolute returns and $0.365$ on squared returns, against $-0.085$ on returns themselves as a negative control, with asymptotic standard error $0.084$. That is a feasibility result on one index and one sample and should be scoped to it.

---

## Part 3. Objectives

Six, each mapped to a research question and to a technical contribution. The mapping is the point: an objective that serves no question does not belong, and a question with no objective cannot be answered.

| # | Objective | Serves | Contribution |
|--:|---|---|---|
| **O1** | Build a data layer enforcing point-in-time correctness through a single as-of cursor shared by all four channels, over a corporate-action-aware CSE panel | MRQ, SQ1 | C6 |
| **O2** | Implement four methodologically heterogeneous agents behind one output contract, each emitting a structurally computed confidence rather than a self-report | MRQ, SQ2 | C2 |
| **O3** | Construct the state vector, the liquidity composite $L_t$, the volatility level $V_t$ and the persistence $P_t$, from measured market quantities | MRQ, SQ1 | C1 |
| **O4** | Implement the orchestration operator as a low-capacity form, with an abstention channel that shrinks an absent agent toward a floor rather than to zero | MRQ | C1, C3 |
| **O5** | Evaluate the operator against four comparison arms over identical agent outputs, with one ablation per state input and the pre-registered diagnostics | MRQ, SQ1 | K1 |
| **O6** | Produce a CSE baseline set under a walk-forward, cost-aware, regime-decomposed protocol, with the liquidity screen reported as a statistic in its own right | MRQ | K3, K5 |

O1 is first for a reason that is not sequencing. Lookahead is the one thing in this project that cannot be retrofitted, so building agents before the cursor exists would compromise every result above it.

---

## Part 4. Success criteria

Two layers. The build criteria already exist as A1 to A6 in [[PoC Specification]] Part 0 and are restated here because the slide needs them. The measurement criteria are the pre-registration items, and those were blank.

### Build criteria, unchanged

| # | Check | Evidence |
|--:|---|---|
| A1 | One ticker-date passes end to end with no manual step | Saved run artefact |
| A2 | The weight vector is not constant over time | Weight trace plus entropy series $H_t$ |
| **A3** | **The weight vector responds to $L_t$ specifically, holding the rest fixed** | **Sensitivity sweep, $\partial w / \partial L$** |
| A4 | At least one decision flips sign between the equal-weight arm and the state-conditioned arm | Disagreement count with dates |
| A5 | Five arms run on identical data and identical agent outputs | Byte-identical agent outputs across arms |
| A6 | Four ablations run, each producing an attributable delta | Ablation table |

A2 can be satisfied by noise. **A3 is the mechanism**, and [[PoC Build Plan]] §4 moves it to Friday deliberately so there is a weekend left to respond if the weights turn out inert.

### Measurement criteria, proposed

> [!WARNING]
> Every value in this table is **provisional, proposed 23 October 2026**. What matters for attributability is that these were fixed before the run, not which values they are. Overrule any of them, but overrule them now rather than after seeing numbers.

| Item | Value | Reasoning |
|---|---|---|
| **Primary metric** | **Cost-adjusted return over the full window, abstained days held flat.** Fixed 24 October | [[Week 4]] §2.7 is explicit that prediction accuracy alone will not support a claim about investment decisions, so the primary has to be decision-level. The full-window form is chosen over per traded day because [[Contribution to Knowledge]] C3 warns that confidence concentrating on small-move days is exactly what makes a high-accuracy selective rule lose to buy-and-hold, and a per-traded-day primary conceals that |
| Return per traded day | Reported alongside, not primary | Still required by C3 element 4, and it is the figure that shows whether selectivity is paying for itself |
| Secondary metrics | Sharpe, maximum drawdown, recovery profile, turnover | Carried as fixed columns, not chosen after the fact |
| Reported on every directional row | Class balance, Matthews correlation, cost-adjusted return | The local example of why: accuracy 0.5837 at MCC 0.1493 |
| **Minimum margin over $B_1$** | **A margin exceeding the interquartile range of $B_1$ across the repeated windows.** Fixed 24 October | An absolute number picked now would be arbitrary. Scaling the margin to the baseline's own dispersion is defensible, and it is still fixed in advance, which is what attributability requires |
| Significance test | HAC-adjusted paired test plus stationary bootstrap, $\alpha = 0.05$ | Part 9. Note the standing warning that standard errors for a combined forecast are nontrivial because the weights are random and correlated with the forecasts |
| Seeds and windows | Five seeds across the walk-forward folds, dispersion reported | Dispersion is reported rather than the best run |
| Volatility estimator | **Parkinson**, frozen | Garman-Klass carries a $(\ln C/O)^2$ term and on a thin counter the open is often stale or auction-set. Already decided in [[PoC Build Plan]] §3 |
| Abstention floor $\phi$ | **0.05** as the pre-registered primary, swept as a robustness strip if time allows | Already decided in [[PoC Build Plan]] §3 |
| Abstained-day exposure | **Hold**, not flat | The flat option carries a round-trip cost each time, which contaminates the abstention economics |
| Unchanged-price handling | Excluded from the directional metric, retained in the economic metric with the position held flat | On this market an unchanged close often means no trade, so it is a liquidity observation rather than a forecasting failure |
| $L_t$ composite inputs | Amihud, turnover ratio, zero-return frequency, high-low range, with $\tau_t$ as a candidate, signed so higher means worse, z-scored, first principal component over an expanding window | Turnover and trade count are held across the full span, confirmed 18 October, so the composite is stronger than the 13 October spec assumed |
| Experimental universe | `[CORRECTED 27 OCTOBER 2026]` Candidate set of **233** voting securities trading on at least 60% of aligned days with at least 2,000 aligned days, from a core universe of **355**, after DOCK was dropped on 24 October. The superseded figures were 234 and 357. PoC runs on roughly nine, stratified three high, three mid, three thin | Selecting the ten most liquid counters leaves $L_t$ with little variation and A3 with nothing to detect |
| Conformal window treatment | No longer constrained | The 1250-day requirement was withdrawn on 18 October because the archive clears it on both tracks |

**Decide now that a null is an acceptable outcome.** Fifty years of forecast-combination evidence says equal weights are hard to beat and that sophisticated schemes usually lose to estimation error. The review that documents this states plainly that there is no comprehensive quantitative guidance on when to choose which, so an answer on a thin frontier market is worth having even if the answer is that equal weights win, provided the margin and the test were written down first.

---

## Part 5. The traceability chain

This is the table the 11 October gate asked for, and the one slide 7 and slide 10 share.

| Gap | Question | Objective | Requirement group | Evidence |
|---|---|---|---|---|
| Influence is fixed at design time, and in most reviewed systems there is no weight object to vary | MRQ | O2, O3, O4 | FR2, FR4, FR5, MAI1, MAI4 | A2, A4, five-arm table, per-input ablations |
| Liquidity governs both what a trade costs and how far a price-derived signal can be trusted | SQ1 | O3, O4 | FR6, FR9, DR4, MAI6 | A3 sensitivity, the two separating ablations |
| Persistence is measured in the local literature and consumed by nothing | Sub-hypothesis under MRQ | O3 | DR7, MAI5 | The $P_t$ ablation. The reproduction experiment is pre-registered rather than run |
| Confidence is declared in reviewed systems and not computed with, and comparability across unlike architectures is unresolved | SQ2 | O2 | MAI1, MAI2, MAI3 | Per-agent calibration curves, the $C_{i,t}$ ablation |
| Backtests on this market have run without point-in-time control | MRQ | O1 | FR1, DR6, NFR1 | Cursor violation raises, documented in the run log |
| No CSE baseline set exists under a defensible protocol | MRQ | O6 | DR1 to DR5, NFR3, NFR5 | The baseline set itself, with the screen reported as a statistic |

---

## Part 6. Settled and open

### Settled 24 October

| Item | Decision |
|---|---|
| Question structure | **One main question plus two supporting questions.** No question answerable yes or no |
| The main question | Reframed as open-ended. The previous binary form is recorded in Part 2 |
| SQ2, confidence comparability | **Added 24 October.** Contribution C2 and open question K2 previously had no question attached to them, so an examiner reading slide 6 would have seen a contribution with nothing behind it |
| RQ3, persistence | **Withdrawn as a question.** Retained as a sub-hypothesis under the main question and as a pre-registered experiment |
| Aim sentence | Approved, with *whether* replaced by *under what conditions* |
| Primary metric | Cost-adjusted return over the full window, abstained days held flat. Per traded day reported alongside |
| Minimum margin | Exceeds the interquartile range of $B_1$ across repeated windows |

### Still open

Nothing in this note. One consistency item is carried forward, in Part 7.

---

## Part 7. Propagation from the restructure

The question labels changed, so these have to change with them. Each is handled when that note is addressed.

| Note | What needs changing |
|---|---|
| [[10 Requirements]] | Part 6 traceability table, three rows relabelled to MRQ, SQ1, SQ2 |
| [[14 Evaluation and Experimental Design]] | Part 1 success criteria row, Part 7 claim limits |
| [[15 Testing, QA and Traceability]] | Part 6 traceability table, three rows |
| [[22 Backup and Q&A Preparation]] | The requirements traceability backup slide |
| [[_Proposal Notes Index]] | Open decisions 4 to 7 now settled |

### One consistency item carried forward

The phrase *"attributable evidence on whether it earns its place"* also appears in [[06 Gap, Novelty and Contribution]] Part 6 and [[20 Scope, Limitations and Closing Defence]] Part 5. In note 06 it sits inside a verbatim quotation of [[Contribution to Knowledge]] Part 3, so changing it there would break the quotation. In note 20 it is my own wording in the closing defence and can be changed freely. **Decide at note 20 rather than sweeping every instance now**, since describing a knowledge contribution as evidence either way is defensible in a sentence that is not a research question.

---

**Related notes.** [[Research Gap (Final Statement)]] for what the literature lacks. [[Contribution to Knowledge]] for what this produces. [[PoC Specification]] Part 0 and Part 10 for the acceptance criteria and the pre-registration block this note fills. [[10 Requirements]] for the requirement groups referenced in Part 5.

**Language discipline applies here too.** No "first", "nobody", "never". The permitted form is *"I have not found that evaluation in the literature I have covered."* The agent set and the conditioning set remain provisional.
