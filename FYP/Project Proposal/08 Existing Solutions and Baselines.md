---
status: current
created: 2026-10-23
written_against: "[[Research Gap (Final Statement)]]; [[PoC Specification]]; [[Contribution to Knowledge]]; [[Week 4]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 8 of the PP live presentation template. The template's instruction is that comparison must shape requirements, architecture, metrics, baselines and scope rather than being a list, so the right-hand column of every table here is the implication rather than the summary. Sentiment is out of scope throughout.*

---

## Why this note exists

Slide 8 does two jobs that are easy to confuse. It compares **existing solutions**, which is evidence, and it names **experimental baselines**, which is methodology. They overlap but they are not the same list: one reviewed system becomes a baseline arm, most do not, and two of the strongest baselines are not systems at all.

---

## Part 1. Existing solutions, and what each one forces

| Solution | Relevant capability | Strength | Limitation or gap | Implication for my design or evaluation |
|---|---|---|---|---|
| **TradingAgents** | Multi-agent LLM pipeline with specialised analysts feeding one decision | Genuinely heterogeneous analyst roles, widely cited as the reference architecture | Combines through a one-sentence facilitator prompt. No weight object exists, so the combination is invisible rather than wrong | The contribution has to be the weighting quantity itself. Also the reason the superseded "existing systems use fixed weights" wording was retired, since many have no weight at all |
| **FinVision** | Multi-agent market prediction | Analyst specialisation, reported out of sample | Concatenates analyst outputs into a single prompt | Reinforces the same implication. The pool must emit a common structured contract before any weighting is meaningful |
| **HedgeAgents** | A solved constrained optimisation over an explicit weight vector | A real weight vector with real mathematics behind it, re-solved on a schedule | The weights are over **assets**, one agent per asset, so the question of which method to trust cannot arise. Three LLM-authored expected returns feed an exact optimiser with no calibration | The single shared decision clause. Also the argument for calibrating agent outputs before they reach any optimiser, which is the structural confidence mechanism |
| **MacroHFT** | Continuous conditioning on market state | Conditioning is genuinely continuous and the weight trace is published | Six architecturally identical networks on one data stream. Conditioning without heterogeneity. Its weight trace is near-binary with three of six curves barely off the floor | The heterogeneity clause, and the entropy diagnostic. Entropy collapse is an observed failure mode here rather than a hypothetical one |
| **TRIAG** | An orchestrator that learns to coordinate | Learned coordination over multiple agents | Its state vector is agent embeddings, task metric and own hyperparameters, with no environment block. It declares a confidence field and never computes with it | The measured exogenous state clause, and the strongest piece of negative evidence for why a computed confidence mechanism is a contribution |
| **Automate Strategy Finding** | Nominated by a recent survey as the field's adaptive gating mechanism | Learned weights over a pool | Does selection rather than weighting, and its weights carry no time index | Demoted from nearest neighbour to **experimental baseline $B_2$**, static learned weight |
| **FFORMA** | Feature-conditioned learned weights over a heterogeneous pool | The closest method to mine in form, and a strong result in its own domain | Its 42 features are properties of the series being forecast, computed once from history. Not exogenous, not measured per step, not market state | Named as the lineage rather than as a rival. The contribution is positioned as a generalisation along this axis |
| **The CSE Graph-RAG system**, same department | Structure-aware retrieval over CSE filings | Verified prior art on this market, with a public repository | Builds a static snapshot with no as-of field, which is a lookahead hazard in a backtest | Retrieval is **not** claimed as novel. The point-in-time cursor is the response, and this is the documented failure it is defined against |
| **Pavithya et al. (2021), CSE** | Two heterogeneous models, one shared decision | The closest thing to this project's shape, on this exact market | Combination fixed once at three to one on the basis of one model's score on a different and easier task, with realised influence drifting on article count | The clearest motivating failure. It also settles that an agent's weight cannot come from its own in-domain score |
| **Current practice on the CSE**, the manual process | Analyst judgement combining chart reading, filings and market feel | Adapts to conditions continuously, which is exactly what the fixed systems do not | Not reproducible, not auditable, not measurable, and not available as a comparator | Not usable as a baseline. It is the reason the problem exists rather than a thing to beat |

---

## Part 2. The experimental baselines

Five arms, and three ablation comparators. The distinction from Part 1 matters: these are run, not cited.

| Arm | Weighting | What it exists to rule out |
|---|---|---|
| $B_1$ | Equal weight | The field's hardest benchmark. Fifty years of combination evidence says it is hard to beat, and the usual reason sophisticated schemes lose is that weight-estimation error exceeds the gain. **Pre-registered as the primary benchmark**, not one arm among several |
| $B_2$ | Static learned weight | Beating equal weighting proves little if a fixed learned weight gets there too. Reference implementation is the gating system demoted from Part 1 |
| $B_3$ | Discounted inverse-MSE, **no market state** | <font color="#ffc000">The arm that actually threatens the contribution.</font> If reacting to recent agent performance does as well as conditioning on measured state, the state conditioning is not earning its place |
| $P$ | State-conditioned, the proposal | |
| $O$ | Oracle, weights fitted on the test window | Prices the estimation cost in this project's own data and units. One extra pass of the same pipeline |

Plus a one-parameter sweep mapping the continuum from equal weights to winner-take-all, which costs almost nothing and places the whole family on one axis.

**The non-negotiable fairness rule.** $B_2$ must be identical to $P$ in every respect except the weighting function. The Graph-RAG paper's fatal flaw is that its proposed system received both the graph and the agent scaffolding while its baseline received neither. Acceptance criterion A5 exists to enforce this, and it is only achievable if agents run once and all arms consume the same cached outputs.

---

## Part 3. Reading the oracle gap

Three outcomes, three different conclusions, decided before the run rather than after.

| Oracle result | Estimated result | Conclusion |
|---|---|---|
| No gain | not reached | The conditioning hypothesis is wrong. Report it |
| Gain | Gain | The mechanism works |
| Gain | No gain | An **estimation** problem with a number attached, not a conceptual failure |

The pre-registration has to separate the two failure modes that look identical in the output: the weighting genuinely not helping, which is the field's prior, against the weighting helping and the test being unable to see it. The first says abandon the conditioning, the second says change how it is estimated.

---

## Part 4. Local baselines for the component channels

Separate from the orchestration arms, and worth one line because they are what makes the CSE baseline set a contribution.

- A published six-variable linear model of share prices on this market reports in-sample $R^2$ of 0.576 and within $R^2$ of 0.090, **with no out-of-sample result at all**. That is a specific baseline to beat out of sample for the fundamental channel.
- Two CSE forecasting studies carried as baselines report out-of-sample results on daily price prediction, which gives the technical channel a local comparator.
- Three CSE volatility studies measure clustering and persistence, which gives the volatility channel a local reference rather than a transplanted one.

What does not exist in the literature I have covered is a CSE baseline set produced under a walk-forward, cost-aware, regime-decomposed protocol, with trade counts equalised and class balance, Matthews correlation and cost-adjusted return reported together. The protocol is not novel and is not claimed as novel. The baseline set produced under it is the contribution.

---

## Part 5. Open decisions

1. **How many rows of Part 1 appear on the slide.** Ten is far too many for the time. Four, chosen so that each defeats a different clause, plus the two CSE rows, is the likely cut, with the rest in backup.
2. **Whether Part 1 and the prior-work contrast on slide 6 are the same table shown twice.** They are close. One option is to put the clause-by-clause contrast on slide 6 and the design-implication version here, which is what the two notes currently assume.
3. **Whether the manual process row is kept.** It is honest and it is the only row with no implication for the design, which may make it a row that costs time without earning anything.

---

**Related notes.** [[04 Evidence to Research Gap]] for the prior-work contrast by clause. [[06 Gap, Novelty and Contribution]] for what survives the contrast. [[14 Evaluation and Experimental Design]] for the arms as an experimental design rather than a comparison. [[PoC Specification]] Part 7 for the full arm specification.

**Language discipline applies here too.** The permitted form is *"I have not found that evaluation in the literature I have covered."* Claims about each system are scoped to what that paper reports.
