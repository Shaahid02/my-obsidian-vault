---
status: current
created: 2026-10-23
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

One sentence, build and evaluate, provisional.

> **To design, implement and evaluate a market-state-conditioned orchestration operator that continuously varies the influence of methodologically heterogeneous financial agents over a single shared decision, and to establish, on Colombo Stock Exchange data under a cost-aware and regime-decomposed protocol, whether that conditioning earns its place against fixed, static learned and performance-reactive weighting.**

Three things it is doing deliberately. It names an artefact, so the software engineering spine has something to attach to. It names the comparison rather than claiming an improvement, so a null is inside the aim rather than outside it. And it scopes the evidence to one market and one protocol, which is what the language rule requires.

---

## Part 2. Research questions

Three questions. [[29-09-2026]] §11.3 asks for a third **only if genuinely independent**, and §4 below argues that it is, with a caveat about its status at proposal stage.

### RQ1. The orchestration question

> Does continuously varying the influence of methodologically heterogeneous agents as a function of measured exogenous market state produce better decisions than fixed, static learned, or performance-reactive weighting, on a market where channel reliability varies substantially?

| | |
|---|---|
| **Where it comes from** | [[13-09-2026]] §4.3, sharpened by the surviving claim in [[29-09-2026]] §3.1 and independently converged on by the panel in [[Week 4]] §2.4 |
| **How it is answered** | The five-arm comparison, $B_1$ equal weight, $B_2$ static learned, $B_3$ discounted inverse-MSE with no market state, $P$ the proposal, $O$ oracle, run over byte-identical cached agent outputs, with one ablation per state input |
| **What counts as an answer** | A cost-adjusted decision-level result against $B_1$ at a pre-registered margin, with class balance and Matthews correlation on the same row, HAC-adjusted and bootstrap tested, plus the attributable per-input deltas |
| **The arm that threatens it** | $B_3$. If reacting to recent agent performance does as well as conditioning on measured state, the state conditioning is not earning its place, and that is the finding |

### RQ2. The liquidity question

Taken in the supervisor's own prescribed wording from [[29-09-2026]] §7.1, which deliberately moves the question away from cost modelling and back into decision systems.

> How should a multi-agent decision system alter both execution behaviour and the influence of price-derived agents when market liquidity deteriorates?

| | |
|---|---|
| **Where it comes from** | [[29-09-2026]] §7.1, with §7.4 supplying the coupling $C'_{T,t} = C_{T,t} \cdot g(L_t)$ |
| **How it is answered** | The A3 sensitivity sweep, freezing a date and sweeping $L_t$ over its observed range to record $\partial w / \partial L$, plus the two separating ablations $P - \text{LiquidityReliability}$ and $P - \text{CostObjective}$, plus the participation-rate sweep |
| **What counts as an answer** | A measured sensitivity, and a separation of whether any improvement comes from changing agent trust, changing execution decisions, or both |
| **The honest limit** | The cost term rests on proxies for illiquidity rather than on a measurement of what a trade pays, because no validated spread measurement exists for this market. Say it in the same breath |

### RQ3. The persistence question

> Does conditioning the post-shock exposure-restoration schedule on measured volatility persistence improve risk-adjusted outcomes relative to the exponential decay an EWMA half-life assumes?

| | |
|---|---|
| **Where it comes from** | [[13-09-2026]] §4.5 and §6.5, with the named target identified in [[Research Gap (Final Statement)]] Sub-gap 2 |
| **How it is answered** | Reproduce the target-volatility scaler on the source paper's own four-ETF environment, verify the reproduction approximately matches reported behaviour, then substitute a persistence-aware decay schedule |
| **Why it is independent** | It runs on a different environment, needs no CSE data, and tests a different mechanism from RQ1. It is the one component off the critical path |
| **Status at proposal stage** | <font color="#ff0000">Pre-registered experiment, not a result.</font> PoC-B was cut from the 25 October gate in [[PoC Build Plan]] §6 because it does not fit alongside PoC-A in the hours available. Present it as a hypothesis with the baseline identified and the environment chosen |

There is local feasibility evidence that the quantity is estimable on this sample. [[PoC Data Build]] §7 reports GPH at $m = 58$ on the ASPI from 2012 to 2026 giving $\hat{d} = 0.408$ on absolute returns and $0.365$ on squared returns, against $-0.085$ on returns themselves as a negative control, with asymptotic standard error $0.084$. That is a feasibility result on one index and one sample and should be scoped to it.

---

## Part 3. Objectives

Six, each mapped to a research question and to a technical contribution. The mapping is the point: an objective that serves no question does not belong, and a question with no objective cannot be answered.

| # | Objective | Serves | Contribution |
|--:|---|---|---|
| **O1** | Build a data layer enforcing point-in-time correctness through a single as-of cursor shared by all four channels, over a corporate-action-aware CSE panel | RQ1, RQ2 | C6 |
| **O2** | Implement four methodologically heterogeneous agents behind one output contract, each emitting a structurally computed confidence rather than a self-report | RQ1 | C2 |
| **O3** | Construct the state vector, the liquidity composite $L_t$, the volatility level $V_t$ and the persistence $P_t$, from measured market quantities | RQ1, RQ2, RQ3 | C1 |
| **O4** | Implement the orchestration operator as a low-capacity form, with an abstention channel that shrinks an absent agent toward a floor rather than to zero | RQ1 | C1, C3 |
| **O5** | Evaluate the operator against four comparison arms over identical agent outputs, with one ablation per state input and the pre-registered diagnostics | RQ1, RQ2 | K1 |
| **O6** | Produce a CSE baseline set under a walk-forward, cost-aware, regime-decomposed protocol, with the liquidity screen reported as a statistic in its own right | RQ1 | K3, K5 |

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

| Item | Proposed value | Reasoning |
|---|---|---|
| Primary metric | Cost-adjusted return per traded day, decision-level | [[Week 4]] §2.7 is explicit that prediction accuracy alone will not support a claim about investment decisions |
| Secondary metrics | Sharpe, maximum drawdown, recovery profile, turnover | Carried as fixed columns, not chosen after the fact |
| Reported on every directional row | Class balance, Matthews correlation, cost-adjusted return | The local example of why: accuracy 0.5837 at MCC 0.1493 |
| Minimum margin over $B_1$ | A margin exceeding the interquartile range of $B_1$ across the repeated windows | An absolute number picked now would be arbitrary. Scaling the margin to the baseline's own dispersion is defensible and still fixed in advance |
| Significance test | HAC-adjusted paired test plus stationary bootstrap, $\alpha = 0.05$ | Part 9. Note the standing warning that standard errors for a combined forecast are nontrivial because the weights are random and correlated with the forecasts |
| Seeds and windows | Five seeds across the walk-forward folds, dispersion reported | Dispersion is reported rather than the best run |
| Volatility estimator | **Parkinson**, frozen | Garman-Klass carries a $(\ln C/O)^2$ term and on a thin counter the open is often stale or auction-set. Already decided in [[PoC Build Plan]] §3 |
| Abstention floor $\phi$ | **0.05** as the pre-registered primary, swept as a robustness strip if time allows | Already decided in [[PoC Build Plan]] §3 |
| Abstained-day exposure | **Hold**, not flat | The flat option carries a round-trip cost each time, which contaminates the abstention economics |
| Unchanged-price handling | Excluded from the directional metric, retained in the economic metric with the position held flat | On this market an unchanged close often means no trade, so it is a liquidity observation rather than a forecasting failure |
| $L_t$ composite inputs | Amihud, turnover ratio, zero-return frequency, high-low range, with $\tau_t$ as a candidate, signed so higher means worse, z-scored, first principal component over an expanding window | Turnover and trade count are held across the full span, confirmed 18 October, so the composite is stronger than the 13 October spec assumed |
| Experimental universe | Candidate set of 234 voting securities trading on at least 60% of aligned days with at least 2,000 aligned days. PoC runs on roughly nine, stratified three high, three mid, three thin | Selecting the ten most liquid counters leaves $L_t$ with little variation and A3 with nothing to detect |
| Conformal window treatment | No longer constrained | The 1250-day requirement was withdrawn on 18 October because the archive clears it on both tracks |

**Decide now that a null is an acceptable outcome.** Fifty years of forecast-combination evidence says equal weights are hard to beat and that sophisticated schemes usually lose to estimation error. The review that documents this states plainly that there is no comprehensive quantitative guidance on when to choose which, so an answer on a thin frontier market is worth having even if the answer is that equal weights win, provided the margin and the test were written down first.

---

## Part 5. The traceability chain

This is the table the 11 October gate asked for, and the one slide 7 and slide 10 share.

| Gap | RQ | Objective | Requirement group | Evidence |
|---|---|---|---|---|
| Influence is fixed at design time, and in most reviewed systems there is no weight object to vary | RQ1 | O2, O3, O4 | FR2, FR4, FR5, MAI1, MAI4 | A2, A4, five-arm table, per-input ablations |
| Liquidity governs both what a trade costs and how far a price-derived signal can be trusted | RQ2 | O3, O4 | FR9, DR4, MAI6 | A3 sensitivity, the two separating ablations |
| Persistence is measured in the local literature and consumed by nothing | RQ3 | O3 | DR7, MAI5 | Reproduction fidelity, Sharpe and recovery profile, $\hat{d}$ stability |
| Backtests on this market have run without point-in-time control | RQ1 | O1 | FR1, DR6, NFR1 | Cursor violation raises, documented in the run log |
| No CSE baseline set exists under a defensible protocol | RQ1 | O6 | DR1 to DR5, NFR3, NFR5 | The baseline set itself, with the screen reported as a statistic |

---

## Part 6. Open decisions

1. **The aim wording.** Proposed above. It is the single sentence that will be read first on slide 1 and slide 3, so it is worth one pass out loud.
2. **Whether RQ3 survives as a question or becomes a stated sub-hypothesis.** It is independent on the argument in Part 2, but it has no result behind it and will not have one before 5 November. Carrying it as a question with a pre-registered experiment is defensible; carrying it as a question and being unable to say anything about it is not.
3. **The minimum margin form.** Scaling to $B_1$'s dispersion is proposed rather than settled. A fixed number is also defensible, and either is better than deciding afterwards.
4. **Whether the primary metric is per traded day or over the full window.** Both appear in Part 9. They answer different questions once abstention is in play, and only one can be primary.

---

**Related notes.** [[Research Gap (Final Statement)]] for what the literature lacks. [[Contribution to Knowledge]] for what this produces. [[PoC Specification]] Part 0 and Part 10 for the acceptance criteria and the pre-registration block this note fills. [[10 Requirements]] for the requirement groups referenced in Part 5.

**Language discipline applies here too.** No "first", "nobody", "never". The permitted form is *"I have not found that evaluation in the literature I have covered."* The agent set and the conditioning set remain provisional.
