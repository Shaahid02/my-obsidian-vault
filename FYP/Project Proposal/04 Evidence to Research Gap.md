---
status: current
created: 2026-10-23
revised: 2026-10-24
written_against: "[[Research Gap (Final Statement)]]; [[Research Matrices Status]]; [[_Corpus Index]]; [[Week 4]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 4 of the PP live presentation template. The template's instruction on this slide is blunt: do not stop at "I found papers", explain how the evidence creates a defensible gap and shapes the artefact. Sentiment is out of scope throughout.*

---

## Why this note exists

Slide 4 is where the evidence criterion is won or lost, because it is the slide that shows reasoning rather than reading. The template's table has four columns, evidence source, what it shows, limitation or tension, and resulting gap, and the third column is the one most proposals leave weak.

[[Week 4]] §2.2 asked for exactly this, structured as a comparison of existing systems across named axes: aggregation method, regime detection, liquidity treatment and evaluation protocol. That instruction is the shape of this slide.

> [!WARNING]
> One correction to carry. The panel quoted back a claim that existing multi-agent frameworks use fixed weights. That is the wording [[29-09-2026]] §3.1 directed retiring, in favour of the sharper and more defensible observation that **many of the reviewed systems carry no explicit weighting quantity at all**. Verify and present the current formulation, not the superseded one.

---

## Part 1. The four evidence routes

> [!important]
> **Decided 24 October.** This table is what slide 4 carries. The clause-by-clause contrast in Part 2 moves to slide 6, so the two slides answer different questions: slide 4 answers *how did you arrive at a gap*, slide 6 answers *why is the gap yours*. Part 2 stays in this note as the reasoning behind row two and as backup-slide material.

The template's table, filled. Each row is a different kind of evidence, which is the point: four independent routes converging on the same absence is a stronger argument than one route repeated.

| Evidence source | What it shows | Limitation or tension | Resulting gap |
|---|---|---|---|
| **Academic literature on multi-agent financial systems** | Agent heterogeneity is widely adopted and combination is widely treated as a solved detail. A survey of 167 reinforcement learning papers states directly that coordination protocols among agents are underexplored | Several systems have no weight object at all, so there is no quantity to criticise. Those that do have one weight the wrong thing: assets rather than methods, selection rather than influence, learning rate rather than influence | Influence over a shared decision is fixed at design time, and nothing adapts it to how reliable each agent is right now, as a function of measured conditions outside that agent |
| **Existing systems and tools** | Four named systems each get one necessary clause right and miss the others. A fifth, from the forecast combination literature, gets feature-conditioned weighting right but conditions on properties of the series being forecast rather than on market state | The nearest neighbour in each direction is strong, which is why the contrast has to be clause by clause rather than system by system | The combination of all four clauses at once: continuous, over influence, across methodologically heterogeneous agents, conditioned on measured exogenous state |
| **Domain evidence from the CSE** | Illiquidity shocks depress returns measurably, volume Granger-causes the index at $p = 0.0041$ while macro variables reach nothing, long memory is found across all three regimes, and the fundamental channel is structurally thin | Local studies measure these quantities and stop. Three CSE papers detect volatility clustering and address it only with robust standard errors | There is a measured quantity on one side and a decision that needs it on the other, and nothing joining them |
| **Technical and measurement evidence** | Two papers do model execution cost against depth, and both are implemented and credible | Both use a linear or square-root impact form, neither tests a nonlinear one, neither sweeps participation rate, both calibrate on deep markets, and every allocation system deducts cost after optimising rather than inside the objective | Cost shape in order size is untested across the reviewed set, and cost does not enter the function being optimised, so the optimiser has no reason to prefer a cheaper path to the same position |

---

## Part 2. The prior-work contrast

This is the table that makes the gap defensible, and it is the one to have ready as a backup slide. Each row is the nearest system on one axis, and the right-hand column is why that is not enough.

| System | Nearest on | Why it does not close the gap |
|---|---|---|
| **HedgeAgents** | A solved constrained optimisation over an explicit weight vector | The weights are over **assets**, one agent per asset, so the question of which method to trust cannot arise |
| **MacroHFT** | Continuous conditioning on market state | Six **architecturally identical** networks on one data stream. Conditioning without heterogeneity |
| **Jung and Lee** | A genuinely heterogeneous pool | A fixed prompt template sits where the weighting should be. Degrades 10.36 points and cannot notice |
| **TRIAG** | An orchestrator that learns to coordinate | Its state vector has **no environment block**. It carries a confidence field and never computes with it |
| **FFORMA** | Feature-conditioned learned weights over a heterogeneous pool | Its features are properties of the series being forecast, computed once from history. Not exogenous, not measured per step, not market state |
| **Automate Strategy Finding** | Nominated by a recent survey as the field's adaptive gating mechanism | The primary paper does selection rather than weighting, and its weights carry no time index. Demoted to a baseline arm |

---

## Part 3. The surviving claim, and why each clause is load-bearing

> Continuously vary the influence weight of **methodologically heterogeneous** agents, over a **single shared decision**, as a function of **measured exogenous market state**.

Drop any clause and a named system already does it. That is the test the claim has to pass, and the table above is the evidence that it does.

---

## Part 4. Lineage rather than novelty

This is the framing that makes the gap defensible rather than merely unfilled, and it pre-empts the examiner who knows the forecasting literature.

The weighting function is a time-varying feature-conditioned linear combination, and the forecast combination literature contains both halves separately: time-varying weights through the Kalman filter and smooth-transition line, and feature-conditioned weights through FFORMA. FFORMA is the nearest named ancestor, and the difference is one sentence: its features are properties of the series itself, computed once from history, while mine are properties of market state, measured at each step and exogenous to the agent being weighted.

A second strand supports the premise independently. An asset-pricing study interacts 94 stock characteristics with eight macro state variables inside a single estimator. The difference there is two clauses: those interaction weights are re-estimated once per annual refit and so do not vary at decision time, and they are weights on characteristics inside one model rather than on separate producers of a shared decision.

**Positioning this as a generalisation along an identified axis is stronger and safer than positioning it as new machinery.**

---

## Part 5. The strongest objection, stated before anyone else states it

> [!important]
> **Decided 24 October: this lives on slide 4, and only on slide 4.** It is raised immediately after the gap is stated. Raising it at the moment the gap is claimed is more convincing than raising it at the end, and it is what turns equal weighting from a convenience baseline into the pre-registered primary benchmark on slides 8 and 14. Notes [[06 Gap, Novelty and Contribution]] and [[20 Scope, Limitations and Closing Defence]] reference it but must not restate it.

Putting this on the slide rather than waiting for it is worth more than any additional evidence of the gap.

Across fifty years of evidence the equally weighted combination is persistently hard to beat, and the usual reason sophisticated schemes lose is that weight-estimation error exceeds the gain from better weights. Equal weights is therefore the field's hardest benchmark, which is why it is the pre-registered primary baseline rather than one arm among several, and it raises the bar rather than lowering it.

The same review gives two guidelines that cut in opposite directions here. Limited data argues for the simple average. Structural change argues for changing weights, and CSE relationships demonstrably break across 2020 to 2022. The review states plainly that there is no comprehensive quantitative guidance on when to choose which, so an answer on a thin frontier market is a contribution even if the answer is that equal weights win.

> [!NOTE]
> One honest correction to carry. The "limited data" half of that objection was originally argued on a figure of 374 trading days per counter, which came from a superseded archive. The current extraction gives a median of roughly 3,400 days per counter, so that half of the argument is weaker than it was. The surviving part is that the components are themselves fitted on intermittently traded series, and calendar depth is not effective sample size.

---

## Part 6. How the evidence shaped the artefact

The template asks for this explicitly, and it is the link between slide 4 and slides 10 and 11.

| Evidence | Design consequence |
|---|---|
| Agents do not abstain, and a thin channel produces confident output about nothing | The abstention channel, with a floor rather than a hard zero, and `unparseable` as a separate state |
| An agent's weight cannot be set from its own in-domain score | Weights come from measured marginal contribution, tested by ablation on held-out windows |
| Systems declare confidence and never compute with it | Confidence computed from the structure of each agent's output, never self-reported |
| Equal weights is hard to beat | It is the pre-registered primary benchmark, and a null is an acceptable outcome decided in advance |
| Two published CSE failures of point-in-time hygiene | A single as-of cursor at the data layer, enforced for all four channels |
| A published comparison gave its proposed system scaffolding its baseline did not get | Agents run once, all arms consume the same cached outputs, and byte-identical agent outputs is an acceptance check |

---

## Part 7. Settled and open

### Settled 24 October

| Item | Decision |
|---|---|
| What slide 4 carries | The four evidence routes in Part 1. The clause-by-clause contrast moves to slide 6 |
| Where the objection goes | Slide 4, immediately after the gap is stated, and nowhere else |

### Still open

Nothing. This note is ready to build from.

---

**Related notes.** [[Research Gap (Final Statement)]] for the full argument. [[05 Critical Literature Landscape]] for the corpus this evidence is drawn from. [[06 Gap, Novelty and Contribution]] for what the gap produces. [[08 Existing Solutions and Baselines]] for the same systems treated as experimental baselines.

**Language discipline applies here too.** The permitted form is *"I have not found that evaluation in the literature I have covered."* The gap statement carries a 2026-03-09 cutoff and should be re-checked before submission.
