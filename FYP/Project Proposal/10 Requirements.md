---
status: current
created: 2026-10-23
revised: 2026-10-24
written_against: "[[PoC Specification]]; [[PoC Data Build]]; [[PoC Build Plan]]; [[Data Cleaning Checklist]]; [[Contribution to Knowledge]]; [[07 Research Questions, Aim and Objectives]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 10 of the PP live presentation template. Requirements elicitation has been an outstanding supervisor instruction since 20 September and was rated 1.0 in the deliverables tracker. Almost nothing here is a new decision: the material already exists in [[PoC Specification]] Parts 0 and 4 to 8, [[PoC Data Build]], [[Data Cleaning Checklist]] and the exclusion tables, and this note converts it into requirement form with a source and an acceptance test attached to each. Sentiment is out of scope throughout.*

---

## Why this note exists

The rubric's largest single criterion, **Initial Requirements and Indicative Solution at 20 percent**, assesses requirements and the technical concept together, and its wording is explicit that neither can carry the mark alone. The template's own warning on slide 10 is that requirements must be traceable to evidence and must connect to design, testing and evaluation.

The vault has the design decisions and the evidence behind them. What it has not had is the middle column: the statement of what the system must do, with the reason it must, and the thing that would show it does.

> [!NOTE]
> The **source and rationale** column is where this scores. Nearly every decision in the spec already carries the paper, the measurement or the supervisor decision that forced it, which is unusual at proposal stage. A requirement that cites a published failure is worth more than one that cites a preference.

**Priority** uses MoSCoW. Must means the 25 October gate or the research claim fails without it. Should means the claim is weaker without it. Could means it is wanted and droppable.

> [!important]
> **Decided 24 October: five requirements go on the slide, one per category**, each chosen because its source column cites a paper or a measurement rather than a preference. That is the template's own layout for this slide, and the source column is the strongest thing in this note, so the exemplars should show it. The full set of 41 is a backup slide.
>
> The exemplars: **FR1** the as-of cursor, **NFR3** reproducibility, **DR2** corporate-action handling, **MAI1** structural confidence, **B2** no fifth agent. Each cites a published failure or a measurement on this dataset.

**Two priorities were revised on 24 October**, both upward, and both are recorded in Part 7.

---

## Part 1. Functional requirements

| ID | Requirement | Source and rationale | Acceptance evidence | Pri |
|---|---|---|---|---|
| **FR1** | The data layer shall expose a single as-of cursor, and every component shall obtain data by query against it rather than by receiving a dataframe | Point-in-time correctness, [[Contribution to Knowledge]] C6. Two documented failures on this market sit either side of it: the CSE Graph-RAG snapshot with no as-of field, and the firm-specific-factors study selecting the top twenty counters by 2023 capitalisation and backfilling to 2013 | A query whose timestamp exceeds the cursor raises an exception. Demonstrated by a deliberate violation test in the run log | Must |
| **FR2** | Every agent shall return the common output contract: `signal`, `confidence_raw`, `confidence_calibrated`, `state`, `as_of`, `diagnostics` | [[PoC Specification]] §5.1. The pool is not weightable at all unless the outputs are comparable in shape | A1, one ticker-date passes through every agent, the state vector, the orchestrator and the decision with no manual step | Must |
| **FR3** | The agent `state` field shall distinguish `ok`, `abstain`, `unparseable` and `no_data`, and these shall route differently | [[Contribution to Knowledge]] C3 element 2. Collapsing `unparseable` into `abstain` loses the distinction between an absent channel and a broken output | Routing test showing `unparseable` produces a hard zero and `abstain` produces the floor | Must |
| **FR4** | The orchestrator shall compute a weight per agent per step as a function of the state vector and the calibrated confidence, $s_{i,t} = \beta_i^\top x_t + \gamma_i c_{i,t}$ with $x_t = [1, L_t, V_t, P_t]^\top$ | [[Contribution to Knowledge]] C1. This is the contribution; without it there is no project | A2, weight trace not constant over time, with the entropy series $H_t$ | Must |
| **FR5** | Weights shall be normalised over agents not in the `unparseable` set and shall guarantee each remaining agent at least a floor $\phi$ | [[PoC Specification]] §6.3. Geweke and Amisano find individually poor forecasts can still help in combination, which is the argument for shrinking toward a floor rather than driving to exactly zero | Weights sum to one and the minimum is at least $\phi$ across every run | Must |
| **FR6** | The liquidity state shall modulate the technical agent's confidence, $C'_{T,t} = C_{T,t} \cdot g(L_t)$ with $g$ decreasing in illiquidity | [[29-09-2026]] §7.4. Poor liquidity does not only make a trade expensive, it makes the price series feeding the technical agent noisier. One measurement, two uses | A3, the sensitivity sweep recording $\partial w / \partial L$ over the observed range of $L_t$ on a frozen date | Must |
| **FR7** | The system shall run five weighting arms, $B_1$ equal, $B_2$ static learned, $B_3$ discounted inverse-MSE with no market state, $P$ the proposal, $O$ oracle, over identical cached agent outputs | [[PoC Specification]] Part 7. The CSE Graph-RAG paper's fatal flaw is that its proposed system received both the graph and the agent scaffolding while its baseline received neither | A5, agent outputs byte-identical across all five arms | Must |
| **FR8** | The system shall run one ablation per state input, $P - L_t$, $P - V_t$, $P - P_t$, $P - C_{i,t}$, and report an attributable delta for each | [[Contribution to Knowledge]] K1. The ablations are what make the answer attributable rather than a single number | A6, ablation table, one row per removed input | Must |
| **FR9** | The orchestrator shall expose the proposed allocation before it is committed, not only the final decision | [[PoC Specification]] §6.5. Building it to return only a decision forecloses putting execution cost inside the objective, which SQ1 needs | Proposed allocation present in the run artefact | Should |
| **FR10a** | The system shall compute and emit the **weight entropy series** $H_t$ and the **liquidity sensitivity** $\partial w / \partial L$ as standard output | Acceptance criteria A2 and A3 are defined on these two quantities, so they are not optional. Entropy collapse is an observed failure mode in a reviewed system rather than a hypothetical one | A2 and A3 themselves | **Must** |
| **FR10b** | The system shall compute and emit the remaining pre-registered diagnostics: pairwise agent error correlation, volatility and liquidity agent collinearity, the fundamental agent's weight trajectory around reporting dates, the oracle gap, and a quiet against stressed decomposition | [[Contribution to Knowledge]] Part 5. Each corresponds to a named risk, and each is much better found by me than by an examiner | Five diagnostics present in the evidence pack | Should |

---

## Part 2. Non-functional requirements

| ID | Requirement | Source and rationale | Acceptance evidence | Pri |
|---|---|---|---|---|
| **NFR1** | A cursor violation shall raise an exception rather than emit a warning | [[PoC Specification]] §4.1. Lookahead is the one property in this project that cannot be retrofitted, so it has to fail loudly | Violation test asserts the exception | Must |
| **NFR2** | Agents shall execute once per run, and the arms shall consume cached outputs | [[PoC Specification]] Part 12. A5 is architecturally unachievable any other way | Byte comparison across the five arm output files | Must |
| **NFR3** | Runs shall be reproducible from a released pipeline, with seeds and configuration recorded | [[PoC Specification]] Part 9. Three documented instances exist in the reviewed set of published financial ML results that cannot be checked as published | Two runs at the same seed produce identical artefacts | Must |
| **NFR4** | The orchestrator's stability shall be swept across its regularisation setting and reported, not tuned to a favourable value | [[Contribution to Knowledge]] C1. An observed Sharpe sign-flip as L2 moves from 0.001 to 0.002, on a universe larger and a history longer than the CSE offers, is the reason the form is low capacity in the first place | Sweep table in the evidence pack, including the unfavourable settings | Must |
| **NFR5** | Every directional result shall carry class balance, Matthews correlation and cost-adjusted return on the same row | [[PoC Specification]] Part 9. The local example of why is accuracy 0.5837 at MCC 0.1493 | Result schema check on every output table | Must |
| **NFR6** | Trade counts shall be equalised before arms are compared, with exposure time, holding period and turnover reported as fixed columns | [[Research Gap (Final Statement)]], evaluation commitment 8 | Fixed columns present in the comparison table | Must |
| **NFR7** | Agent outputs, state series and weights shall be logged at one row per ticker-date so that any decision can be reconstructed after the fact | [[Contribution to Knowledge]] K7. The weight vector is the decision-level explanation, and an explanation that was not recorded is not an explanation. Promoted to Must on 24 October: the logging is cheap and K7 is unverifiable without it | Run artefact schema, and any decision reconstructable from the log alone | **Must** |

---

## Part 3. Data requirements

These carry more evidence behind them than any other group, because the data work is the part of the build that is furthest along.

| ID | Requirement | Source and rationale | Acceptance evidence | Pri |
|---|---|---|---|---|
| **DR1** | The base panel shall be built from the official daily share price extraction rather than from the API scrape | [[PoC Data Build]] §3. The official set carries 46 securities absent from the API, a 12.8 percent gap of 359, and that exclusion spans a sovereign default | Security count reconciliation on load | Must |
| **DR2** | Returns shall be computed on the corporate-action-adjusted panel | `[CORRECTED 27 OCTOBER 2026]` The motivating defect stands: JKH closed at 212.50 on 2024-10-28 and 21.20 on 2024-11-06, a split rendered as a 90 percent fall. **The adjusted panel was built on 23 October**, so the detect-and-exclude workaround in the superseded wording is withdrawn | Adjusted panel present, with its 31 register corrections each confirmed against both price and issued quantity | Must |
| **DR3** | Bar validation shall run on load, asserting high $\geq$ close $\geq$ low and high $\geq$ open $\geq$ low, with rights instruments excluded from the universe | [[PoC Build Plan]] §0a. At least one security, ASPM.N0000, prints a close outside its own high-low range, and 17 of 334 counter files are rights instruments | Validation report on every load, with violations listed rather than dropped silently | Must |
| **DR4** | Volume-derived liquidity measures shall be computed on crossing-stripped volume, with the stripped and unstripped versions reported side by side | [[PoC Data Build]] §5. Crossings run from 8.8 percent of annual market turnover in 2021 to 47.4 percent in 2017, with a per-security median of 12.5 percent and a 90th percentile of 53.0 percent. A crossing is a pre-negotiated transfer that consumed no book depth, so uncorrected measures overstate liquidity | Both series present, and the above-100-percent cases resolved or excluded with the reason stated | Must |
| **DR5** | Zero-return days shall be recorded separately from non-trading days, with volume rather than price change deciding, and the exchange calendar separating the two | [[PoC Specification]] §0.3. The two are different observations and conflating them corrupts both the liquidity screen and the directional metric | Both columns present in the per-counter profile | Must |
| **DR6** | Every document retrievable by the fundamental agent shall carry a publication-date field, and the retrieval filter shall be keyed to the simulation clock | [[Contribution to Knowledge]] C6. Filenames in the announcements feed are opaque identifier and timestamp pairs, so the date has to be captured at harvest rather than inferred later | Ingestion rejects any document without a publication date. `[CORRECTED 27 OCTOBER 2026]` **The corpus exists and satisfies this**: 22,893 documents harvested 2012-01-01 to 2026-10-04, each filename prefixed with the CSE announcement date, which is the publication date rather than the reporting-period end. A 22-file probe across four counters and both document types found an extractable text layer in every file, 507 to 3,485 characters per page, so no OCR stage is required on that sample | Must |
| **DR7** | Known structural breaks shall be handled in the methodology rather than discovered in a post-mortem: SLFRS 16 in 2019 for lease-sensitive and PPE-derived fundamental features, nominal price distortion across 2020 to 2023 for rupee-denominated features, and the price-granularity break at 2021-01 for any tick-based or discreteness feature | [[Research Gap (Final Statement)]] and [[PoC Data Build]] §7. The 2011 to 2016 and 2020 series sit entirely on a 10-cent grid while 2021 onward runs 5.4 to 12.9 percent off it | Each break named in the methodology with its treatment stated before the run | Must |
| **DR8** | The experimental universe shall be selected by the liquidity screen and stratified across the liquidity cross-section, and the count of counters the screen removes shall be reported as a result | [[Contribution to Knowledge]] K5 and [[PoC Build Plan]] §3. Selecting the ten most liquid counters leaves $L_t$ with little variation, and A3 then has nothing to detect | Per-counter screen table reported by tier, plus the removal count | Must |
| **DR9** | Survivorship limitations shall be reported rather than carried silently, using series-end dates as an explicit proxy for a tradability mask | [[PoC Build Plan]] §0a. Data Library item 06 holds 119 delisted company names with no effective dates, so a point-in-time tradability mask is not possible and the proxy has to be labelled as one | Limitation stated in the protocol and on the limitations slide | Must |
| **DR10** | Ex-date reliability shall be carried as a field, and events whose ex-date was inferred rather than documented shall be dropped or flagged in any daily-return model | `[ADDED 27 OCTOBER 2026]` No documented date in the registers is an ex-date. Ex-dates were recovered from measured price drops, and `corporate_actions.csv` records reliability in `ex_date_basis` with **259 events marked approximate** | The flag is present on every event, and the daily-return models exclude or mark the approximate window. Longer-horizon returns are unaffected | Must |

---

## Part 4. Model and AI requirements

| ID | Requirement | Source and rationale | Acceptance evidence | Pri |
|---|---|---|---|---|
| **MAI1** | Agent confidence shall be computed from the structure of the agent's own output and shall not be self-reported | [[Contribution to Knowledge]] C2. TRIAG declares a confidence field in its output contract, puts it in a figure, and never computes with it. HedgeAgents feeds three LLM-authored expected returns straight into an exact optimiser with no calibration | No agent emits a self-assessed confidence anywhere in the pipeline | Must |
| **MAI2** | Each agent's raw score shall be mapped through its own empirical accuracy-at-threshold curve, estimated on a rolling validation window, so that every agent reports in the same unit | [[PoC Specification]] §5.3. A softmax output and a posterior variance are not comparable; two points on an empirical accuracy curve are | Calibrated confidence in $[0,1]$ for every agent, with the curve retained per window | Must |
| **MAI3** | The technical agent shall receive no weight on a day where Theil's $U2 \geq 1$ against the random walk | [[PoC Specification]] §5.2. A network whose edge has been arbitraged away has no reason to become less confident on its own, so the gate has to be external | Gate test, plus the count of gated days reported | Must |
| **MAI4** | The orchestrator shall be a low-capacity gated linear or shallow regression form rather than a network, with no pairwise interaction term | [[Contribution to Knowledge]] C1. Bates and Granger, Newbold and Granger, and Winkler and Makridakis all find that ignoring error covariances is the better practical choice because covariance estimates are unstable | Parameter count and functional form recorded, and the choice stated as a cited decision rather than a simplification | Must |
| **MAI5** | Any proposed addition to the conditioning set shall beat the existing set **out of sample** on the ablation protocol before adoption | [[Contribution to Knowledge]] Part 5. The cited warning is the BIS result, 44 predictors on 84 observations winning in sample everywhere and losing out of sample everywhere | Pre-registered, with the static learned-weight arm retained as the shrinkage-equivalent control | Must |
| **MAI6** | Abstention shall be evaluated economically: return per traded day and total return with abstained days held flat, reported alongside the coverage-accuracy pair | [[Contribution to Knowledge]] C3 element 4. Confidence concentrating on small-move days is exactly what makes a high-accuracy selective rule lose to buy-and-hold | Both economic figures present wherever a coverage-accuracy pair appears | Must |
| **MAI7** | The abstention operating point shall be set at the knee of the coverage-accuracy frontier rather than at its end, and coverage shall be reported alongside every accuracy figure | [[Contribution to Knowledge]] C3 element 1 | Frontier plotted, operating point marked, coverage on every accuracy row | Should |

---

## Part 5. Boundary requirements

Out of scope, each with the reason, because the rubric's scope criterion rewards deliberate boundaries and the examiner will ask about at least two of these.

| ID | Boundary | Reason |
|---|---|---|
| **B1** | No sentiment component in any form | Supervisor, 20 September 2026, **Final**. Sentiment papers stay in the corpus as background and as fixed-influence failure cases |
| **B2** | No fifth agent, including macro | Rejected on evidence: ARDL gives adjusted $R^2 = 0.189$ over five macro variables across a decade, with Granger nulls for money supply and inflation. The one exception carried is USD/LKR as a slow lagged feature into the fundamental agent's context, not as an agent |
| **B3** | No Level B microstructure execution | Bid, ask and depth are not held, and none of the Data Library's forty items contains any. The Level A proxy route is the declared fallback |
| **B4** | No EDGE spread estimate as a system component | Demoted to last resort on 11 October. The estimator is unvalidated on thin and frontier markets and the CSE has no quote data to check its output against, so an EDGE spread here could not be falsified even in principle |
| **B5** | No learned network orchestrator, and no reinforcement learning training of any component | The low-capacity form is a stated design decision rather than a shortcut, and RL is not needed for any acceptance criterion |
| **B6** | No end-user interface | [[29-09-2026]] §11.8. Operated as a batch research pipeline. See [[09 Stakeholders, Users and Context of Use]] Part 2 |
| **B7** | No new agents, datasets, research gaps or technologies after 18 October | Supervisor, 29 September 2026, **Hard rule** |
| **B8** | Profitability, statistical significance, full counter coverage, a working fundamental agent and hyperparameter tuning are not proposal-stage acceptance conditions | [[PoC Specification]] Part 0. Per [[29-09-2026]] §11.8, time spent on these reduces proposal quality rather than improving it |

---

## Part 6. Traceability

Must requirements against the question they serve and the test that shows them satisfied. This is the chain the 11 October gate asked for, and the backup slide the template recommends.

| Question | Requirements | Test or evidence |
|---|---|---|
| **MRQ** orchestration | FR2, FR3, FR4, FR5, FR7, FR8, FR10a, NFR7, MAI4 | A1, A2, A4, A5, A6, the five-arm table, the per-input ablation deltas |
| **SQ1** liquidity | FR6, FR9, DR4, DR8, MAI6 | A3 sensitivity sweep, the two separating ablations, the participation-rate sweep |
| **SQ2** confidence comparability | MAI1, MAI2, MAI3 | Per-agent calibration curves, the $C_{i,t}$ ablation, the accuracy-at-threshold transform landing every agent in one unit |
| Persistence, sub-hypothesis under MRQ | DR7, MAI5 | The $P_t$ ablation. The reproduction experiment is pre-registered rather than run |
| All, validity | FR1, NFR1, NFR2, NFR3, NFR5, DR1, DR2, DR3, DR6 | Cursor violation test, byte-identical outputs, seed reproduction, schema checks, the Stage 6 verification suite |

---

## Part 7. Settled and open

### Settled 24 October

| Item | Decision |
|---|---|
| **FR10 split** | **FR10a** weight entropy and liquidity sensitivity promoted to **Must**, because acceptance criteria A2 and A3 are defined on them. **FR10b** the remaining five diagnostics stay Should |
| **NFR7 promoted** | To **Must**. The logging is cheap and contribution K7 is unverifiable without it |
| **FR9 kept as a functional requirement** | Not demoted to an architectural constraint. It is testable, the acceptance evidence is that the allocation appears in the run artefact, and reframing it would lose that test. Stays **Should** |
| **DR6** | Stays **Must**. `[UPDATED 27 OCTOBER 2026]` The *specified, not yet exercised* label is withdrawn: the corpus exists, every filename carries the CSE announcement date, and a 22-file probe found a text layer throughout |
| **DR10 added** | `[27 OCTOBER 2026]` Ex-date reliability carried as a field, with approximate events dropped or flagged in daily-return models. This is the residual data constraint that survives the adjusted panel |
| **MAI7** | Unchanged at Should |
| **Slide exemplars** | FR1, NFR3, DR2, MAI1, B2. Full set of 41 as a backup slide |
| **Traceability relabelled** | MRQ, SQ1, SQ2, with a new row for confidence comparability |

**Counts after the split and the 27 October addition:** 11 functional, 7 non-functional, **10 data**, 7 model and AI, 8 boundary. **43 requirements**, of which exactly three are Should, FR9, FR10b and MAI7, and the rest are Must. Those three are the first candidates to cut if the build runs short.

### Still open

Nothing in this note.

> [!NOTE]
> **DR2 is not an open decision here.** The corporate-action workaround is already item 0 on the carry-to-supervisor list in [[PoC Build Plan]] §7, which is the right place for it. It stays Must with the detect-and-exclude rule and the direction of the exclusion bias both stated.

---

**Related notes.** [[07 Research Questions, Aim and Objectives]] for what these requirements serve. [[11 Architecture and Indicative Solution]] for the components that implement them. [[15 Testing, QA and Traceability]] for the tests referenced in the acceptance column. [[PoC Specification]] and [[PoC Data Build]] for the full reasoning behind each decision.

**Language discipline applies here too.** No "first", "nobody", "never". Figures quoted are measurements on this dataset over this window and are scoped to it.
