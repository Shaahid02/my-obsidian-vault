---
status: current
created: 2026-10-23
written_against: "[[Contribution to Knowledge]]; [[Research Gap (Final Statement)]]; [[Week 3]]; [[Week 4]]; [[29-09-2026]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 6 of the PP live presentation template. This is the slide [[Week 3]] §2.2 was really about, and the instruction that came out of it was to lead with the mechanism rather than with the agent set. The material is already written in [[Contribution to Knowledge]]; what this note does is select the part that fits one slide. Sentiment is out of scope throughout.*

---

## Why this note exists

The template's own warning on slide 6 is the novelty check: explain why the proposal is not a duplicated implementation or an unnecessary integration, and note that for applied work novelty may come from framework design, workflow, evaluation, generalisation, explainability, safety or software engineering process.

Both panel members arrived independently at the same answer to that check. [[Week 4]] §2.1 put it directly:

> "The strongest part is not use of different agents itself, right? It is the proposed market condition [...] it determines actually how much each agent should influence."

So the mechanism leads, the agent set does not, and the slide should make that ordering visible in its first line.

---

## Part 1. The template's table, filled

What exists, what is missing, the proposed novelty, the expected contribution. Three rows, one per gap.

| What exists | What is missing or weak | Proposed novelty | Expected contribution |
|---|---|---|---|
| Multi-agent financial systems combining heterogeneous analysts, mostly through a prompt rather than a coefficient. Separately, feature-conditioned forecast combination with a learned weighting function | Influence is fixed at design time, and in most reviewed systems there is no weight object to vary. Where a weight object exists it weights assets, selection or learning rate rather than influence, or conditions on properties of the series rather than on market state | A continuous, agent-level weighting function over methodologically heterogeneous agents resolving to a single shared decision, conditioned on measured exogenous market state, in a low-capacity form | Attributable evidence, through five arms and per-input ablation, on whether state-aware orchestration earns its place where channel reliability varies |
| Execution cost modelled against depth in two reviewed papers, both credible and implemented | Both use a linear or square-root impact form, neither sweeps participation rate, both calibrate on deep markets, and every allocation system deducts cost after optimising rather than inside the objective | A nonlinear, depth-conditioned cost function held inside the convex allocation objective, plus a participation-rate sweep establishing the shape of the cost curve in order size | A measured cost-curve shape in order size, which I have not found for any market in the reviewed set, and a cost term that changes the decision rather than scoring it afterwards |
| Volatility level operationalised daily by a target-volatility scaler that does most of the risk work in its own paper. Long memory measured on this market across all three regimes | The scaler assumes exponential decay, which is the assumption the local long-memory results contradict, so exposure returns on a schedule that is too fast. Persistence is measured locally and consumed by nothing | The fractional differencing parameter governing the post-shock exposure-restoration schedule, paired with a forecast conditional variance | A tested position on whether persistence should set the re-levering schedule. <font color="#ffc000">At proposal stage this is a pre-registered experiment rather than a result</font> |

---

## Part 2. The clause-by-clause defence

The contribution is not the architecture, it is the set of clauses, and each clause defeats a named nearest neighbour. This is the table to have ready when someone says it sounds like an integration.

| Clause | What it is defined against |
|---|---|
| **Continuously** | One system re-solves on a 30-day calendar clock with a fixed amplitude alarm between |
| **Influence weight** | One varies *selection*, one varies the *learning rate*, one varies *trigger timing*. None varies influence |
| **Methodologically heterogeneous** | One runs six architecturally identical networks, one runs three instances of a single backbone, one runs five agents from fixed templates on one model |
| **Single shared decision** | One splits capital across three books under a one-to-one agent-to-asset mapping, so the question of overlapping views cannot arise |
| **Measured exogenous market state** | One orchestrator's state vector is agent embeddings, task metric and its own hyperparameters, with no environment block at all. The feature-conditioned combination method uses properties of the series being forecast, computed once from history |

Drop any clause and a named system already does it. That is the test, and it is the reason the contribution is stated as a conjunction rather than as an idea.

---

## Part 3. Lineage, which is the stronger framing

> The nearest named ancestor is feature-conditioned forecast combination. The difference is one sentence: its features are properties of the series itself, computed once from the history, while mine are properties of market state, measured at each step and exogenous to the agent being weighted.

Positioning the contribution as a generalisation along an identified axis is more defensible than positioning it as new machinery, and it pre-empts the examiner who knows that literature. Time-varying weights also have a lineage, through the Kalman filter and smooth-transition line, and saying so costs nothing.

**Self-rated novelty 4 out of 5** for the orchestration operator, 3 for the cost work, and 3.5 for the persistence hypothesis. The supervisor rated the formulation 4.5 to 4.7 on 29 September and identified it as the point where this moved from an application architecture into a testable technical research contribution.

---

## Part 4. The second contribution, under-sold until recently

Worth one line on the slide because it is the part that survives even if the main comparison returns a null.

**Confidence computed from the structure of each agent's output rather than asked for.** Four mechanisms across four unlike architectures: whether the extracted program parses and whether every argument traces to a retrieved figure, with step count as a calibrated difficulty proxy at 67.61, 59.08 and 22.78 percent across one, two and three-plus steps; realised interval width at target coverage, so a drifted model widens and down-weights itself; Theil's $U2$ against the random walk; and a rolling loss ratio against a fixed benchmark. Then, across all four, each raw score mapped through its own empirical accuracy-at-threshold curve, which lands every agent in the same unit.

The negative evidence is strong enough to be the argument on its own. One published system declares a confidence field in its output contract, puts it in a figure, and never computes with it. Another feeds three model-authored expected returns straight into an exact optimiser with no calibration and no realised-versus-predicted record. Two published systems visibly ducked this, and a mechanism for it is a contribution.

**State the limit in the same breath.** Whether several backward-looking competence estimates can be made comparable across four architectures is an open question. Having several mechanisms is progress on the problem rather than a solution to it.

---

## Part 5. What is not claimed

Pre-empting is cheaper than defending, and every item here was a claim at some point and was withdrawn or demoted on evidence. This belongs partly on slide 6 and partly on slide 20, and it should appear once.

| Not claimed | Why |
|---|---|
| That size-dependent execution cost is unmodelled | Two reviewed papers implement it. Withdrawn, and the novelty rating moved with it |
| That volatility is not operationalised in agent systems | The target-volatility scaler operationalises level daily. Only the persistence half survives |
| That structure-aware retrieval over filings is novel | Verified prior art on this market, same department and university |
| That layered explainability is a research gap | Combining existing explanation tools is useful engineering. Demoted to a design requirement on 13 September |
| That evaluation discipline is a contribution | It is a mandatory methodology requirement. What does not exist is a CSE baseline set produced under it |
| That dataset creation is a main theoretical contribution | Domain contribution only, per the supervisor on 13 September |
| That the CSE is scientifically unique | It is a frontier-market stress-test environment where reliability varies, and that is the defensible framing |
| That the literature on modular transaction-cost layers has been fully swept | One relevant 2026 paper is paywalled and unread, and that is stated rather than hidden |

---

## Part 6. The paragraph, if one is needed

Already written in [[Contribution to Knowledge]] Part 3 and reproduced here because slide 6 or the handout may need it in continuous prose rather than as a table. It is long for a slide and right for a handout.

> This research contributes a market-state-conditioned orchestration operator for multi-agent financial decision systems: a continuous, agent-level weighting function over methodologically heterogeneous agents resolving to a single shared decision, conditioned on measured liquidity, volatility level, volatility persistence and a per-agent structural confidence score, with an abstention channel that lets an agent's influence fall to a floor when its input channel is absent. Its nearest named ancestor is feature-conditioned forecast combination, and the contribution is positioned as a generalisation along an identified axis. Two supporting mechanisms are contributed as inputs to that operator: a depth-conditioned execution-cost function embedded within the allocation objective rather than deducted after it, and a persistence-conditioned schedule governing how quickly exposure is restored following a volatility shock. The accompanying knowledge contribution is attributable evidence, through a five-arm comparison and per-input ablation, on whether state-aware orchestration earns its place on a market where channel reliability varies substantially, together with a CSE baseline set produced under a walk-forward, cost-aware, regime-decomposed protocol. These are stated as candidate contributions not identified in the literature reviewed to 2026-03-09, to be further validated against recent work.

---

## Part 7. Open decisions

1. **Whether the self-rated novelty figures appear on the slide.** They are honest and they invite the question of who rated them. The supervisor's own rating of the formulation is the stronger number to carry.
2. **How Part 5 is split between slide 6 and slide 20.** It should appear once. My reading is that slide 6 carries two or three items inline and slide 20 carries the full table, because slide 20 is the limitations slide.
3. **Whether the third row of Part 1 is presented as a contribution at all**, given that the experiment behind it was cut from the 25 October gate. Presenting it as a pre-registered experiment with the baseline identified and the environment chosen is defensible; presenting it as a contribution is not.

---

**Related notes.** [[Contribution to Knowledge]] for the full six technical contributions and seven knowledge contributions. [[04 Evidence to Research Gap]] for the evidence this rests on. [[20 Scope, Limitations and Closing Defence]] for what is not claimed. [[07 Research Questions, Aim and Objectives]] for the questions these contributions answer.

**Language discipline applies here too.** No "first", "nobody", "never". These are candidate contributions not identified in the literature reviewed to a stated cutoff, and the cutoff is attached.
