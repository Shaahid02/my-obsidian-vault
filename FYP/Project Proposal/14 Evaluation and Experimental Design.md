---
status: current
created: 2026-10-23
written_against: "[[PoC Specification]]; [[Contribution to Knowledge]]; [[07 Research Questions, Aim and Objectives]]; [[13 Methodology]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 14 of the PP live presentation template. The material is already specified across [[PoC Specification]] Parts 7 to 10, and the work here is selection plus the one thing the spec leaves blank, which is the pre-registered values. Sentiment is out of scope throughout.*

---

## Why this note exists, and the boundary with slide 13

Slides 13 and 14 overlap and will say the same thing twice unless the split is decided. The split used here:

- **Slide 13** carries the two methodologies, why they are distinct, and the validity controls.
- **Slide 14** carries the comparators, the metrics, the protocol, the ablations and the success criteria.

The template's own instruction on this slide is the standard to meet: a strong evaluation does not only show that the system runs, it shows whether the proposed contribution is useful, credible and limited.

---

## Part 1. The template's table

| Evaluation element | What it requires | This project |
|---|---|---|
| **Baseline or comparator** | What is the approach compared against? | Five arms: equal weight, static learned weight, discounted inverse-MSE with no market state, the state-conditioned proposal, and an oracle fitted on the test window. Equal weight is the pre-registered primary benchmark |
| **Metrics** | How is success measured? | Cost-adjusted return per traded day as primary, with Sharpe, maximum drawdown, recovery profile and turnover as secondary. Every directional row also carries class balance and Matthews correlation |
| **Protocol** | Splits, scenarios, cases | Chronological walk-forward with adaptive retraining, five seeds across folds with dispersion reported, decomposed across the Easter attacks, COVID and the 2022 crisis, with a cost sensitivity sweep rather than a single assumption |
| **Ablation or sensitivity** | What is tested separately? | One ablation per state input, plus the fundamental agent on and off, plus two separating ablations for the liquidity coupling and the cost objective, plus a sensitivity sweep over the liquidity state and a stability sweep over the orchestrator's own regularisation |
| **Success criteria** | What result would support the aim? | A margin over equal weighting exceeding the baseline's own dispersion across repeated windows, HAC-adjusted and bootstrap tested at $\alpha = 0.05$, with attributable per-input deltas. A null at that margin is an acceptable and reportable outcome |

---

## Part 2. The five arms and what each rules out

Three arms is not enough, and the reason is specific to each.

| Arm | Weighting | Rules out |
|---|---|---|
| $B_1$ | Equal weight | The field's hardest benchmark. Fifty years of combination evidence says it is hard to beat, and the usual reason sophisticated schemes lose is that weight-estimation error exceeds the gain from better weights |
| $B_2$ | Static learned weight | That a fixed learned weight gets to the same place without any conditioning |
| $B_3$ | Discounted inverse-MSE, no market state | <font color="#ffc000">The arm that actually threatens the contribution.</font> If reacting to recent agent performance does as well as conditioning on measured exogenous state, the state conditioning is not earning its place |
| $P$ | State-conditioned, the proposal | |
| $O$ | Oracle, fitted on the test window | Prices estimation cost in this project's own data and units, which separates a wrong hypothesis from a hard estimation problem |

Plus a one-parameter sweep mapping the continuum from equal weights to winner-take-all, which places the whole family on a single axis at almost no cost.

**The fairness rule is architectural, not procedural.** Every arm must be identical to the others except in the weighting function, which is only achievable if agents run once and all arms consume the same cached outputs. Acceptance criterion A5, byte-identical agent outputs across all five arms, is what enforces it. The motivating failure is a published comparison whose proposed system received both the graph and the agent scaffolding while its baseline received neither.

---

## Part 3. Ablations

One at a time, each producing an attributable delta.

**State inputs.** Proposal minus liquidity, minus volatility, minus persistence, minus confidence. These four are what make the answer attributable rather than a single number.

**Component.** The fundamental agent on and off inside the full framework, which is required rather than optional. If that agent is stubbed at the gate, report it as not run against a live agent with the reason, rather than reporting a zero delta as a finding.

**Mechanism separation, for the liquidity question.** Proposal minus the liquidity-to-reliability coupling, and proposal minus the cost objective. These separate whether any improvement comes from changing agent trust, from changing execution decisions, or from both, which is what RQ2 actually asks.

---

## Part 4. The protocol

| Commitment | Detail |
|---|---|
| **Commitment zero** | Returns computed on a corporate-action-aware series. Everything below depends on it |
| Splits | Chronological, walk-forward with adaptive retraining |
| Seeds | Five across the folds, with dispersion reported rather than the best run |
| Regimes | Decomposed across the Easter attacks, COVID and the 2022 crisis. The index carries 15.1 percent annualised volatility over the window with annual figures running 5.6 percent to 31.6 percent, so the regime variable has real variation and does not need hand-dating |
| Costs | Sensitivity sweep, with friction charged in quiet periods too |
| Significance | HAC-adjusted and bootstrap, $\alpha = 0.05$. Standard errors for a combined forecast are nontrivial because the weights are random and correlated with the forecasts, and that is stated rather than ignored |
| Every directional row | Class balance, Matthews correlation and cost-adjusted return together. The local example of why is accuracy 0.5837 at MCC 0.1493 |
| Trade counts | Equalised before comparison, with exposure time, holding period and turnover as fixed columns |
| Abstention | Evaluated economically or not at all: return per traded day, total return with abstained days held flat, cost per turn, alongside the coverage-accuracy pair |
| Unchanged prices | Excluded from the directional metric, retained in the economic metric with the position held flat, because on this market an unchanged close often means no trade |
| Reproducibility | Pipeline released. Only 4 of 59 reviewed papers are reproducible from the paper alone, against 21 that are not |

---

## Part 5. Diagnostics, which are part of the evaluation rather than extras

Each corresponds to a named risk, and each is much better found by me than by an examiner.

| Diagnostic | Risk it tests |
|---|---|
| Weight entropy over time | Entropy collapse, the orchestrator converging on near-constant weights. Observed rather than hypothetical: one reviewed system's weight trace is near-binary with three of six curves barely off the floor |
| Sensitivity of the weights to liquidity | Inert weights. This is A3 and it is the check that matters |
| Pairwise agent error correlation | The heterogeneity claim is load-bearing and currently asserted rather than measured |
| Volatility and liquidity agent collinearity | Two agents partly measuring the same thing, which would mean a collinearity problem in the state vector |
| Fundamental agent weight trajectory around reporting dates | Whether the mechanism is conditional or merely selective. Permanent zeroing would leave heterogeneity on paper while the system behaves as three agents |
| Oracle gap | Estimation cost |
| Quiet against stressed decomposition | Weights that move impressively in the two or three most volatile months and are inert otherwise |

---

## Part 6. Reading the result, decided in advance

| Oracle | Estimate | Conclusion |
|---|---|---|
| No gain | not reached | The conditioning hypothesis is wrong. Report it |
| Gain | Gain | The mechanism works |
| Gain | No gain | An estimation problem with a number attached, not a conceptual failure |

The pre-registration must separate the two failure modes that look identical in the output: the weighting genuinely not helping, which is the field's prior, against the weighting helping and the two-step test being unable to see it. The first says abandon the conditioning, the second says change how it is estimated.

> [!important]
> **A null is an acceptable outcome, and that is decided now rather than after the run.** The review that documents the fifty-year finding states plainly that there is no comprehensive quantitative guidance on when a changing-weight scheme should be preferred to a simple average. An answer on a thin frontier market is a contribution even if the answer is that equal weights win, provided the margin and the test were written down before the run.

---

## Part 7. What the evaluation will not support

Said here so the claim stays inside what the design can carry. [[Week 4]] §2.7 is the source: prediction accuracy alone will not support a claim about improved investment decisions.

- Direction accuracy supports claims about **forecast quality** only.
- Decision-level claims require the friction-aware metrics on the same row.
- Nothing here supports a claim about live trading performance, because slippage is simulated and there is no ground-truth execution data on this market to validate a simulator against.
- Nothing here supports a general claim about frontier markets. The evidence is one market, one window, one universe.

---

## Part 8. Open decisions

1. **Primary metric per traded day or over the full window.** They answer different questions once abstention is in play, and only one can be primary.
2. **The margin form.** Scaled to the baseline's dispersion is proposed. A fixed number is also defensible. Either beats deciding afterwards.
3. **Whether the oracle arm is presented on the slide.** It is the most distinctive thing in the design and it needs a sentence of explanation that the time budget may not allow. It is a strong backup slide.
4. **How much of Part 4 is shown against slide 13.** The protocol belongs here; the validity controls belong there.

---

**Related notes.** [[PoC Specification]] Parts 7 to 10 for the full specification. [[13 Methodology]] for the research design and validity controls. [[08 Existing Solutions and Baselines]] for the arms as comparators. [[07 Research Questions, Aim and Objectives]] Part 4 for the pre-registered values.

**Language discipline applies here too.** Claims are scoped to this market, this window and this universe.
