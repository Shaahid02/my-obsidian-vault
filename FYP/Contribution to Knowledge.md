---
status: current
revised: 2026-10-12
written_against: 59 reviews
tags:
  - working-doc
---
*Created 12 October 2026, against all 59 literature reviews. Companion to [[Research Gap]], which states what the literature lacks. This note states what this research produces. Sentiment is out of scope throughout.*

---

### Why this note exists

Every document in this vault so far has been framed as a **gap** document: what the literature fails to do. A gap is an absence. A contribution is a thing that exists at the end which did not exist at the start. The contribution has been present all along as a column in the matrix, buried inside fifteen-column cells, and nowhere as a short declarative statement. That is what the criticism was about, and it is a presentation failure rather than a substance failure.

Two things are separated here that have been merged until now:

- **Technical contribution**: mechanisms and artefacts built.
- **Contribution to the body of knowledge**: claims that survive the experiments and that somebody else can cite.

They are not the same list, and a proposal should carry both.

---

## Part 1. Technical contributions

### C1. The state-conditioned orchestration operator. Primary.

$$w_{i,t} = f(L_t,\ V_t,\ P_t,\ C_{i,t})$$

A continuous, agent-level weighting function over methodologically heterogeneous agents resolving to a **single shared decision**, conditioned on **measured exogenous market state**, implemented as a low-capacity gated linear or shallow-regression form rather than a network.

**Why low capacity rather than a network.** The regularisation sign-flip observed in the source portfolio work, where the Sharpe ratio reverses sign as L2 moves from 0.001 to 0.002 on a universe larger and a history longer than the CSE offers, is the reason. The orchestrator's own stability has to be swept and reported rather than tuned once.

**What makes it a contribution rather than an architecture.** Each clause defeats a named nearest neighbour, and the clause is the contribution:

| Clause | What it is defined against |
| --- | --- |
| **Continuously** | HedgeAgents re-solves on a 30-day calendar clock with a fixed amplitude alarm between |
| **Influence weight** | Automate Strategy Finding varies *selection*, TRIAG varies the *learning rate*, HedgeAgents varies *trigger timing*. None varies influence |
| **Methodologically heterogeneous** | MacroHFT runs six architecturally identical DDQNs, TRIAG three instances of one 1.5B backbone, Jung and Lee five GPT-4o agents from fixed templates |
| **Single shared decision** | HedgeAgents splits capital across three separate books under a one-to-one agent-to-asset mapping, so the question of how much weight to give an agent whose view overlaps another's cannot arise |
| **Measured exogenous market state** | TRIAG's state vector is agent embeddings, task metric and own hyperparameters. No environment block at all. FFORMA's features are properties of the series being forecast, computed once from history |

**The lineage, which is a stronger framing than novelty.** The nearest named ancestor is **FFORMA**, feature-conditioned forecast combination, and the difference is one sentence: *its features are properties of the series itself, computed once from the history, while mine are properties of the market state, measured at each step and exogenous to the agent being weighted.* Time-varying weights also have a lineage, the Kalman filter and smooth-transition line. Positioning the contribution as a generalisation along an identified axis is more defensible than positioning it as new machinery, and it pre-empts the examiner who knows the forecasting literature.

**Self-rated novelty 4 / 5.** The supervisor rated the formulation 4.5 to 4.7 on 29 September and identified it as the point where this moved from an application architecture into a testable technical research contribution.

---

### C2. The structural confidence operator $C_{i,t}$.

The contribution is a method for making confidence **comparable across architecturally unlike components** by computing it from the structure of each component's output rather than by asking the component how sure it is.

| Agent | Mechanism | Source of the mechanism |
| --- | --- | --- |
| $A_F$ fundamental | Does the extracted program parse under the grammar. Does every argument trace to a retrieved figure rather than being invented. How many retries the retriever needed. Program step count as a calibrated difficulty proxy, accuracy running 67.61% / 59.08% / 22.78% across one, two and three-plus steps | FinQA, ConvFinQA, and the Cypher-validation signal from the CSE Graph-RAG work as a cross-check |
| $A_V$ volatility | Wrap the FIGARCH or GJR-GARCH forecast in adaptive conformal inference, and let $C_{V,t}$ be a function of realised interval width at the target coverage. A model that has drifted reports wider intervals and is down-weighted automatically | Gibbs and Candes, adaptive conformal inference |
| $A_T$ technical | Theil's U2 against the random walk, which also decides whether the channel gets any weight that day. Explicitly not a raw softmax, since a network whose edge has been arbitraged away has no reason to become less confident | Standard, plus the negative argument from the agent literature |
| $A_L$ liquidity | Rolling loss ratio against a fixed benchmark, unit-free and computable for anything emitting a forecast of the same target | GNNHAR |
| **All four** | Map each agent's raw score through **its own empirical accuracy-at-threshold curve**, estimated on a rolling validation window. That transform lands every agent in the same unit: probability of being right at the score just emitted. A softmax output and a posterior variance are not comparable; two points on an empirical accuracy curve are | The XAI abstention work |
| **All four, second candidate** | $p_\text{T}$, round-trip practicability, bounded in $[0,1]$ and defined purely on realised decisions and outcomes, computable for any component that emits a directional view regardless of how it arrived at one | HLOB |

**Why this is a contribution and not plumbing.** The negative evidence is strong enough to be an argument on its own. **TRIAG declares a confidence field in its output contract, puts it in a figure, and never computes with it**, appearing in no reward term, no fusion rule, no state block and no experiment. **HedgeAgents feeds three LLM-authored expected returns straight into an exact mean-variance-CVaR optimiser** with no calibration and no realised-versus-predicted record, which is a well-specified objective over uncalibrated inputs, inheriting the uncertainty of the inputs while hiding it behind the precision of the output. Two published systems visibly ducked this. A mechanism for it is a contribution.

**State the honest limit in the same breath.** Whether several backward-looking competence estimates can be made comparable across four architectures is an open question, and having several mechanisms is progress on the problem rather than a solution to it. Writing that down as unresolved is more useful than picking one and pretending.

---

### C3. The abstention channel, as time-varying subset selection.

An orchestrator designed for a channel that is **frequently absent** rather than occasionally imperfect. $A_F$ is expected to be unusable on more than half of computed questions over CSE filings, on two independent pipelines measuring 50% and 53.19%.

**The one-sentence framing, and it is the best sentence available in this project:**

> AlphaAgents deleted an entire agent by hand because its input channel was too thin. This automates that intervention and makes it conditional and reversible.

**Four design elements:**

1. The weight for an agent can fall to a floor on that agent's own reliability score, with the operating point at the **knee** of the coverage-accuracy frontier rather than at its end, and coverage reported alongside every accuracy figure.
2. **Unparseable output is a fourth outcome state** feeding a hard zero, distinct from low confidence.
3. The abstained-day exposure policy is stated explicitly, hold or go flat, since those are different strategies and the flat option carries a round-trip cost each time on the CSE.
4. Abstention is evaluated **economically**: return per traded day, and total return with abstained days held flat, reported alongside the coverage-accuracy pair. Confidence concentrating on small-move days is exactly what makes a high-accuracy selective rule lose to buy-and-hold.

**Position it in the literature's own vocabulary rather than as bespoke machinery.** This is time-varying subset selection, achieved by applying a threshold to a time-varying weighting scheme. The combination literature assesses subset selection as scantly attended to, mostly trimming on expertise alone, and mostly ad hoc without statistical rationale, so a principled rule driven by a structural property of the output is defensible ground.

**One design decision changed as a result, and it should be stated as a change.** Geweke and Amisano's finding that individually poor forecasts can still help in combination is an argument for **shrinking an abstaining agent's weight toward a floor rather than driving it to exactly zero**. The hard zero is reserved for unparseable output, which is a different case.

---

### C4. Depth-conditioned execution cost inside the allocation objective. Supporting.

A nonlinear, depth-conditioned execution-cost function substituted into Guo et al.'s transaction remainder factor so that it stays **inside** the convex allocation objective rather than being deducted after the fact, plus a **participation-rate sweep** establishing the shape of the cost curve in order size.

**Positioning, per the supervisor on 29 September:** a supporting methodological contribution required by the main orchestration framework, not a second major independent novelty. Self-rated **3 / 5**, which the supervisor called sensible.

**Two caveats that must be stated together, before anyone asks:**

1. A potentially overlapping 2026 paper on modular transaction-cost layers was identified, judged relevant, and could not be obtained because it is paywalled. Its contents are unknown to me, so this is not presented as though the literature had been fully swept.
2. The measurement half is open. EDGE was demoted to last resort on 11 October because it is unvalidated on thin and frontier markets and the CSE has no quote data to check its output against, so an EDGE spread here could not be falsified even in principle. The cost term therefore rests on proxies for illiquidity rather than on a measurement of what a trade pays. The defensible form is that the cost function is calibrated on proxies because no validated spread measurement exists for this market, and that validating it is what the CSE data request is for.

**A methodological rule that fell out of that decision, and it generalises.** Do not adopt a measurement whose output cannot be checked against anything observable on the market it will be applied to. That belongs in the methodology chapter as a stated screening rule, and it is a small contribution in its own right because it is the kind of thing that transfers to the next imported method.

---

### C5. Persistence-conditioned re-levering. Currently a hypothesis.

The fractional differencing parameter $d$ as the quantity governing the **post-shock exposure-restoration schedule**, replacing the EWMA half-life that the standard target-volatility scaler assumes. Paired with a forecast conditional variance so that variance says how bad now and persistence says how long.

**Status, and say it this way.** Per the supervisor on 29 September, until the experiment exists this is a good **hypothesis**, not a demonstrated contribution. The experiment that converts it runs on the source paper's own four-ETF setup and needs no CSE data, which takes this component off the critical path entirely. **Run it first.**

Self-rated **3.5 / 5**.

---

### C6. Point-in-time correctness over frontier filings. Small and real.

A single as-of cursor enforced at the data layer for all four channels, rather than per-agent filtering, with a publication-date field on every retrieved document and a retrieval filter keyed to the simulation clock.

**Why it counts.** The CSE Graph-RAG work builds a static snapshot with no as-of field, which is a lookahead hazard rather than an inconvenience in a backtest, and I have not found a paper in the reviewed set that enforces this. The firm-specific-factors study supplies the concrete failure on the same market from the other direction: selecting the top twenty counters by 2023 capitalisation and backfilling to 2013. Both the right and the wrong version of this decision are now documented on the CSE.

---

## Part 2. Contributions to the body of knowledge

These are claims somebody else can cite, and they hold whichever way the results go.

### K1. Attributable evidence on whether adaptive orchestration earns its place where channel reliability varies.

The five-arm design, equal weight, static learned weight, performance-reactive, state-conditioned, and oracle, with each state input ablated individually, is what makes the answer attributable rather than a single number.

**The reason this is a contribution regardless of sign.** The forecast combination literature's fifty-year finding is that equal weights are hard to beat and that sophisticated schemes usually lose to estimation error. Its two guidelines cut in opposite directions here: limited data argues for the simple average, structural change argues for changing weights. The review states that there is **no comprehensive quantitative guidance on when to choose which**. An answer on a thin frontier market is a contribution even if the answer is that equal weights win.

**Decide now that a null is an acceptable outcome, and pre-register the margin and the test before the run.**

### K2. Whether structural confidence estimates can be made comparable across unlike architectures.

Open question, stated as open. The deliverable is the comparison across four mechanisms on one pool, plus the accuracy-at-threshold transform as the candidate common unit.

### K3. A CSE baseline set produced under a defensible evaluation protocol.

Chronological splits, walk-forward with adaptive retraining, seeds and repeated windows, regime decomposition across the Easter attacks, COVID and the 2022 crisis, a cost-sensitivity sweep, HAC-adjusted and bootstrap significance testing, turnover and trade counts as fixed columns.

The protocol is not novel. **A CSE baseline set produced under it does not exist in the literature I have covered**, and the local warrant is in my own notes: three CSE papers now where the modelling is ordinary and the evaluation is what separates them. There is also a specific published baseline to beat out of sample for the fundamental channel, a linear six-variable model with in-sample overall $R^2$ 0.576 and within $R^2$ 0.090, which reports no out-of-sample result at all.

### K4. A participation-rate sweep establishing the shape of the cost curve in order size.

I have not found this for any market in the reviewed set, not just for the CSE. Chen et al. run everything at one inventory and horizon; Wang, Gao and Li run everything at 10% of ADTV.

### K5. A liquidity-screened per-counter CSE dataset, with the screen itself reported as a statistic.

270 counters of OHLCV over ten years as the envelope, with per-counter profiling for trading-day frequency, median turnover, zero-return frequency separated from non-trading, and Amihud. **The count of counters the trading-day filter removes on an average day is itself a liquidity statistic worth reporting.**

Domain contribution. Per the supervisor on 13 September, do **not** promote dataset creation to a main theoretical contribution.

### K6. A tick-size classification of CSE counters.

Needs only best bid, best ask and the exchange tick schedule, and it closes a question on the record rather than by assumption: whether the liquid CSE counters are large-tick, where the book is compact and learnable, or small-tick, where the published ceiling on learnability is an MCC near 0.05. Decisive and nearly free. If it comes out small-tick, the microstructural route closes at almost no cost and the friction work is daily-bar-based by necessity rather than by preference, which is a reportable finding either way.

### K7. The weight vector as a decision-level explanation. One sentence, not a section.

A decision annotated with how much weight the liquidity state put on the retrieval agent that day is attributable with no further instrumentation. The orchestration design produces this at no extra cost.

**Why this is not the explainability claim the supervisor demoted.** That claim was that combining existing XAI tools is itself a contribution, and it was correctly demoted to a design requirement. This is different: the combination literature lists **interpreting combination weights as one of its open research questions**, prompted by the observation that some schemes drive poor forecasts to zero asymptotically while individually bad forecasts can still be useful. The orchestrator produces a weight per agent per step as a readable function of named market-state inputs, which is a direct response to that question rather than a byproduct.

**Carry the caveat.** A weight being readable is not the same as it being correct. The claim is that the system exposes the quantity this literature itself lists as unexamined, not that exposing it is sufficient.

---

## Part 3. The paragraph for the proposal

> This research contributes a market-state-conditioned orchestration operator for multi-agent financial decision systems: a continuous, agent-level weighting function over methodologically heterogeneous agents resolving to a single shared decision, conditioned on measured liquidity, volatility level, volatility persistence and a per-agent structural confidence score, with an abstention channel that lets an agent's influence fall to a floor when its input channel is absent. Its nearest named ancestor is feature-conditioned forecast combination, and the contribution is positioned as a generalisation along an identified axis: existing feature-conditioned weights are functions of properties of the series being forecast, computed once from history, where these are functions of exogenous market state, measured at each step. Two supporting mechanisms are contributed as inputs to that operator: a depth-conditioned execution-cost function embedded within the allocation objective rather than deducted after it, and a persistence-conditioned schedule governing how quickly exposure is restored following a volatility shock. The accompanying knowledge contribution is attributable evidence, through a five-arm comparison and per-input ablation, on whether state-aware orchestration earns its place on a market where channel reliability varies substantially, together with a CSE baseline set produced under a walk-forward, cost-aware, regime-decomposed protocol. These are stated as candidate contributions not identified in the literature reviewed to 2026-03-09, to be further validated against recent work.

---

## Part 4. What this is not, said before anyone asks

Pre-empting is cheaper than defending. Each of these was a claim at some point in this project and each has been withdrawn or demoted on evidence.

| Not claimed | Why |
| --- | --- |
| That size-dependent execution cost is unmodelled | Chen et al. and Wang, Gao and Li both implement it. Withdrawn, and the novelty rating moved with it |
| That volatility is not operationalised in agent systems | The target-volatility scaler operationalises volatility *level* daily and does most of the risk work in its paper. Only the persistence half survives |
| That structure-aware retrieval over filings is novel | Verified prior art on this market, same department and university. $A_F$ is a system component built on published task definitions. Three things remain and only three are defended: numeric statement extraction, point-in-time correctness, and the orchestration that consumes the signal |
| That layered explainability is a research gap | Combining existing XAI tools is useful engineering. Demoted to a design requirement on 13 September |
| That evaluation discipline is a contribution | It is a mandatory methodology requirement. What does not exist is a CSE baseline set produced under it |
| That dataset creation is a main theoretical contribution | Domain contribution only |
| That the CSE is scientifically unique | Persistence does not distinguish crypto from equities. The CSE is a frontier-market stress-test environment where reliability varies, and that is the defensible framing |
| That EDGE closes the spread measurement problem | Demoted to last resort on 11 October. Unvalidated on thin markets and unfalsifiable on this one |
| That the literature on modular transaction-cost layers has been fully swept | One relevant 2026 paper is paywalled and unread |

---

## Part 5. Open risks against the contributions

| Risk | Which contribution | Mitigation already in the plan |
| --- | --- | --- |
| Entropy collapse, the orchestrator converging on near-constant weights | C1 | Weight-distribution entropy over time as a pre-registered diagnostic. MacroHFT's own weight trace is near-binary with three of six curves barely off the floor, so this is an observed failure mode and not a hypothetical one |
| The orchestrator zeroes $A_F$ permanently rather than conditionally, so heterogeneity survives on paper while the system behaves as three agents | C1, C3 | Weight trajectory around reporting dates is the natural test of whether the mechanism is conditional or merely selective |
| The pool is less heterogeneous than claimed | C1 | Measure error correlation across the four agents, and separately the correlation between the idiosyncratic risk estimate and turnover, since $A_V$ and $A_L$ may be measuring the same thing |
| State conditioning adds nothing beyond reacting to recent agent performance | C1, K1 | The discounted inverse-MSE arm. This is the baseline that actually threatens the contribution |
| Weights move only in the two or three most volatile months and are inert otherwise | C1, K1 | Report quiet sub-periods separately from crisis windows, with friction charged either way |
| The state vector grows as reviews suggest additions, and overfits | C1 | Any addition must beat the existing set **out of sample** on the ablation protocol. The BIS result, 44 predictors on 84 observations winning in-sample everywhere and losing out-of-sample everywhere, is the cited warning |
| Simulated slippage is not measured slippage | C4 | Present it as such. There is no ground-truth execution data to validate a CSE simulator against |
| The persistence estimate is unstable on short rolling windows | C5 | Report the estimator's own stability. Fall back to per-regime estimation and a slower-moving cap if it is not stable |
| Honest significance testing returns no significant outperformance | K1, K3 | Decide now that this is an acceptable outcome. The diversified-portfolio framework runs 16 folds with HAC and bootstrap tests and finds no significant mean-return outperformance anywhere |
| The gap statement has a shelf life | All | The Agentic Trading cutoff of 2026-03-09 is attached explicitly. Re-check before submission |

---

**Related notes.** [[Research Gap]] for what the literature lacks and why. [[ELI5 - The Whole Project in Plain English]] for the same material without the jargon. `Matrices/Refined Research Gap Analysis Matrix v5.xlsx` for the full fifteen-column defence and `Matrices/Consolidated Research Matrix.xlsx` for the 59-paper survey behind it.
