---
status: current
created: 2026-10-23
written_against: "[[PoC Specification]]; [[PoC Data Build]]; [[PoC Build Plan]]; [[10 Requirements]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 11 of the PP live presentation template. The component structure already exists in prose across [[PoC Specification]] Parts 4 to 8; what has been missing is a layered view, the interfaces between layers, and any statement of the implementation technology. Architecture was scheduled for 17 October in [[29-09-2026]] §11.4 and was rated 2.0 in the deliverables tracker. Sentiment is out of scope throughout.*

---

## Why this note exists, and the rubric constraint behind it

The rubric's requirements criterion is worth 20 percent and its wording is the binding part:

> A strong requirements specification cannot, by itself, receive a high mark if the technical concept is absent. Equally, listing a technology stack cannot compensate for unclear requirements or use.

So [[10 Requirements]] and this note are a pair, and neither carries the criterion alone. The template's slide 11 asks for layers with a responsibility, a key decision and an uncertainty to verify, and then for an explanation of **why this architecture is suitable for the research questions**. That last part is the one most likely to be skipped and it is the one the criterion is actually about.

---

## Part 1. The layered view

Five layers. The template's table names a user interface layer; this project replaces it with run control, for the reasons in [[09 Stakeholders, Users and Context of Use]] Part 2.

| Layer | Responsibility | Key decision | Uncertainty to verify |
|---|---|---|---|
| **Run control** | Run specification: universe, window, arm, ablation, seed, configuration. No interactive interface | Batch pipeline rather than an application. [[29-09-2026]] §11.8 removes UI work on the grounds that it would reduce proposal quality | None material at proposal stage. Recorded as boundary requirement B6 |
| **Data layer** | Per-item loaders, security master and trading calendar, corporate-action handling, the ticker-date spine, the as-of cursor, bar validation | One cursor enforced at the layer for all four channels rather than per-agent filtering. Components receive queries, never dataframes | The corporate-action-adjusted series does not exist yet and depends on the Data Library register. The interim rule is detect and exclude |
| **Agent layer** | Four agents, each consuming a different kind of evidence, each emitting the common output contract and a structurally computed confidence | Methodological heterogeneity preserved deliberately, not one backbone with four prompts | Whether the pool is as heterogeneous as the diagram implies. Measured by pairwise error correlation, with volatility against liquidity checked separately for collinearity |
| **State and orchestration layer** | The liquidity composite $L_t$, volatility level $V_t$, persistence $P_t$, the calibration transform, the weighting function, abstention routing, the liquidity-to-reliability coupling | Low-capacity gated linear form, no pairwise interaction term, abstention shrinks to a floor rather than to zero | Entropy collapse, weights inert against $L_t$, and the orchestrator's own stability under small regularisation changes |
| **Evaluation and reporting** | The five-arm harness over cached agent outputs, the four ablations, the diagnostics set, significance testing, the evidence pack | Agents run once and all arms consume the cache, which is the only way outputs stay byte-identical across arms | The oracle gap, which prices estimation cost in this project's own data and units |

---

## Part 2. Data flow and build order

The dependency chain is from [[PoC Data Build]] §1 and nothing in it can be reordered except the filings harvest, which is independent of everything else and is therefore the thing to start early despite the fundamental agent being built last.

```
A0 loaders ──► A1 master + calendar ──► A2 adjusted panel ─┬──► A_T technical
                                                           ├──► A_V volatility
              A3 shares outstanding ──────────────────────►│
              A4 crossing-stripped volume ────────────────►├──► A_L liquidity
              A5 float ────────────────────────────────────┤
              A6 spread, EDGE and CHL ────────────────────┘

              A7 filings corpus ───────────────────────────►  A_F fundamental

{A_T, A_V, A_L, A_F} ──► state vector {L_t, V_t, P_t, c_i,t} ──► orchestrator
                                                                      │
                                              cached outputs ──► five arms ──► ablations ──► diagnostics
```

**The ordering rule that matters.** The as-of cursor comes before any agent. [[PoC Build Plan]] §4 protects this explicitly, and the reason is that lookahead is the one property here that cannot be retrofitted once agents have been built against raw frames.

---

## Part 3. The agents

Four, unchanged across all 59 reviews, and provisional rather than settled.

| Agent | Evidence it consumes | Proof-of-concept form | Confidence mechanism |
|---|---|---|---|
| $A_T$ technical | Adjusted OHLCV | Standard feature set, simple predictor, deliberately plain | Theil's $U2$ against the random walk. $U2 \geq 1$ means the channel does not beat "tomorrow is like today" and gets no weight that day |
| $A_V$ volatility | High and low from the adjusted panel | Parkinson on the daily bar, with GJR-GARCH or FIGARCH for the forecast | Realised interval width at target coverage, so a drifted model widens and down-weights itself with nobody asking it anything |
| $A_L$ liquidity | Crossing-stripped volume, turnover, float, trading frequency | Directional view off the $L_t$ composite | Rolling loss ratio against a fixed benchmark, unit-free |
| $A_F$ fundamental | Per-company filings, not yet collected | Retrieval, numeric extraction, program emission. Minimal, and acceptably stubbed at proposal stage | Does the extracted program parse, does every argument trace to a retrieved figure, and step count as a calibrated difficulty proxy at 67.61, 59.08 and 22.78 percent for one, two and three-plus steps |

> [!WARNING]
> $A_F$ is the agent most likely to be stubbed at the 25 October gate, and [[PoC Build Plan]] §2 already plans for three live agents with the fundamental agent emitting the contract in state `no_data`. What is acceptable is reporting it as stubbed. What is not acceptable is it being silently absent, because the on-and-off ablation depends on it existing in the framework.

Expected coverage is a hypothesis, not a fact: $A_F$ may have low usable coverage on numerically demanding CSE questions, based on benchmark evidence from other financial-QA pipelines. The 50 to 53 percent figure is **not** a measured CSE result and must not be presented as one.

---

## Part 4. The mechanism

Three expressions carry the contribution. Everything else is plumbing around them.

The weight, conditioned on measured market state and the agent's own calibrated confidence:

$$s_{i,t} = \beta_i^\top x_t + \gamma_i\,c_{i,t}, \qquad x_t = [1,\ L_t,\ V_t,\ P_t]^\top$$

The normalisation, with a hard zero for unparseable output and a floor for everything else, where $U_t$ is the unparseable set, $K$ the number of remaining agents and $\phi$ the floor:

$$\tilde{w}_{i,t} = \frac{\exp(s_{i,t})}{\sum_{j \notin U_t}\exp(s_{j,t})}, \qquad w_{i,t} = (1 - K\phi)\,\tilde{w}_{i,t} + \phi$$

And the decision, which is the single shared output the whole heterogeneous pool resolves to:

$$\text{Decision}_t = \sum_i w_{i,t}\,A_{i,t}$$

The clause that makes this a contribution rather than an architecture is that each part of it defeats a named nearest neighbour: continuous against a 30-day calendar clock, influence against selection or learning rate, heterogeneous against six identical networks, a single shared decision against one agent per asset, and measured exogenous state against a state vector with no environment block at all.

---

## Part 5. Technology

| Element | Position | Basis |
|---|---|---|
| Language and scientific stack | **Python**, with the standard numerical, statistical and econometric libraries | Already evidenced by the `FYP Dataset` repository, which carries the extraction and cleaning pipeline, the verification suite and version-controlled commits |
| Data storage | Flat columnar files over the ticker-date spine, with the loaders and the security master in the repository | Established by the existing build. No database is needed at this scale and adding one would be new technology under the 18 October freeze |
| Volatility and persistence estimation | Range estimators and fractionally integrated GARCH from established econometric libraries | Parkinson frozen as the estimator, per [[PoC Build Plan]] §3 |
| Orchestrator | A low-capacity gated linear or shallow regression form, not a deep framework | [[10 Requirements]] MAI4 |
| **Backbone for $A_F$** | <font color="#ff0000">Open decision, stated as open.</font> Selection criteria recorded below | Nothing is committed anywhere in the vault. LangGraph appears only as a candidate in [[16-06-2026]] §5.1 and as "implementation technology" in [[13-09-2026]] §4.8 |
| **Orchestration framework** | <font color="#ff0000">Open decision.</font> The four-agent pipeline is a directed flow that plain Python can express, so a framework has to earn its place | Same as above |

**Selection criteria for the two open items**, so that the decision is principled when it is made rather than defaulted into:

1. It must support point-in-time retrieval, since FR1 and DR6 are not negotiable.
2. It must allow the agent output contract to be enforced, since FR2 is what makes the pool weightable.
3. It must allow deterministic replay at a fixed seed, since NFR3 requires it and byte-identical outputs across arms under NFR2 depend on it.
4. Cost and data control matter, because the filings corpus is third-party material under exchange terms.

> [!NOTE]
> Naming Python is a specification of something the build already does, not an addition under the 18 October hard rule. Choosing a backbone and a framework is a genuine decision and is deliberately left open rather than quietly settled, which is the same convention the conditioning set uses: specified rather than resolved.

---

## Part 6. Why this architecture suits the research questions

This is the part slide 11 actually asks for, and the part that distinguishes a design from a diagram.

- **The cursor exists because RQ1's answer is worthless under lookahead.** If the weighting operator can see the future, a favourable comparison against equal weights says nothing. Two published studies on this market show the failure from either side, one with no as-of field at all and one backfilling a 2023 universe to 2013.
- **The cached-arm structure exists because RQ1 is a comparison and the comparison has to be fair.** The only difference permitted between arms is the weighting function. That is an architectural property, not a discipline, because agents running once and arms consuming the cache is the only way to guarantee it.
- **The common output contract exists because weighting is only meaningful over comparable outputs.** A softmax and a posterior variance cannot be combined, so the calibration transform is load-bearing rather than cosmetic.
- **The abstention routing exists because the motivating failure is an absent channel rather than a weak signal.** A system built for occasionally imperfect inputs would handle the fundamental channel wrongly on this market.
- **The exposed allocation exists because RQ2 needs execution cost inside the objective.** Returning only a decision would close that door permanently.
- **The low-capacity form exists because the data does not support more.** An observed Sharpe sign-flip as regularisation moves from 0.001 to 0.002, on a universe larger and a history longer than this one, is the argument against a network here.

---

## Part 7. Open decisions

1. **The backbone for $A_F$ and whether an orchestration framework is used.** Criteria above; decision outstanding.
2. **Interfaces between layers are described but not specified.** The data layer's query interface is the one that needs a signature, because FR1 depends on it.
3. **Whether the diagram presented on the slide is the five-layer view or the dependency chain.** The layer view suits the criterion better; the dependency chain explains the build order. One on the slide, the other in backup.
4. **Whether the fundamental agent appears in the architecture diagram as live or as stubbed.** It should appear, with its status labelled, since the ablation needs it present in the framework.

---

**Related notes.** [[10 Requirements]] for what each component must do and how it is accepted. [[PoC Specification]] Parts 4 to 8 for the full reasoning. [[PoC Data Build]] for the data layer dependency chain. [[09 Stakeholders, Users and Context of Use]] for why there is no interface layer.

**Language discipline applies here too.** No "first", "nobody", "never". The agent set and the conditioning set remain provisional.
