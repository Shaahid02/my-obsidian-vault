---
status: current
created: 2026-10-23
revised: 2026-10-29
written_against: "[[Data Cleaning Checklist]]; [[PoC Specification]]; [[PoC Data Build]]; [[10 Requirements]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 15 of the PP live presentation template. Testing design was scheduled for 25 October in [[29-09-2026]] §11.5 and has not been written, but one row of the template's table is already populated with executed results rather than plans: the data verification suite in [[Data Cleaning Checklist]] Stage 6. Sentiment is out of scope throughout.*

> [!NOTE]
> **Revised 29 October 2026.** Two corrections and four decisions. The traceability table traced three research questions that [[07 Research Questions, Aim and Objectives]] has since renamed and, in one case, withdrawn. Seven **Must** requirements carried no test anywhere in the note, which matters more than usual because linking tests to requirements is this note's whole purpose and the traceability chain is a planned backup slide. The seven are now covered. The behavioural checks are confirmed as living here rather than on slide 14, and a testing timeline has been added, because the note was a snapshot and the criterion rewards showing testing develop.

---

## Why this note exists, and one caveat up front

The template's instruction on this slide is short and exacting:

> Link tests to requirements and research questions. Testing is not an afterthought at final submission.

Most proposals answer this with intentions. This one can answer part of it with numbers, because the data layer has already been verified against external sources and the results are recorded. That is the strongest testing evidence available at proposal stage and it should lead.

> [!WARNING]
> **Caveat on scope.** Much of the executed evidence below lives in the `FYP Dataset` repository rather than in this vault, in `docs/poc_build_verification_2026-10-21.md` and `docs/data_cleansing_tasks.md`. This note restates the findings recorded in [[Data Cleaning Checklist]] and [[PoC Data Build]] and does not re-verify them. Anything presented on the slide should be traceable to a file in that repository.

---

## Part 1. The five test areas

| Area | Purpose | Status | Evidence |
|---|---|---|---|
| Unit and component | Verify isolated logic: estimators, the calibration transform, the normalisation, the composite construction | `[CONFIRMED 29 OCTOBER 2026]` **Planned, and none exist today.** No unit suite is in the repository at this date. Targets named in Part 3, scheduled in Part 7 | Test results, once written |
| Integration | Verify components communicate correctly end to end and that the arms consume the cache rather than re-running | **Specified as acceptance criteria.** A1 and A5 are integration tests in all but name | A1 run artefact, A5 byte comparison |
| Requirements-based system tests | Check each Must requirement is satisfied | **Specified.** Acceptance evidence is already attached to every requirement in [[10 Requirements]] | The traceability table in Part 4 |
| Data and model checks | Detect leakage, bad data, drift, collinearity and degenerate behaviour | **Partly executed, with numbers** | [[Data Cleaning Checklist]] Stage 6, plus the pre-registered diagnostics |
| Usability, accessibility, security | Assess responsible use and quality constraints | **Mostly not applicable at proposal stage**, and said so rather than faked | Part 5 |

---

## Part 2. Data validation, already executed

This is the part to lead with, because it is evidence rather than intention. Each of these is a check that was run against an external reference and passed, which makes it a regression baseline: a later run that fails one of them is a new defect.

| Check | Result | Why it is a test rather than a statistic |
|---|---|---|
| Share-count reconciliation | Each year's splits, bonuses, scrip dividends and final rights allotments applied to the year-end issued quantity and confirmed against the next year-end, **per security per year rather than in aggregate** | Offsetting errors cancel in a total, so the per-security form is what makes a residual point at a missed or misdated event. Fifteen annual anchors inside the window mean the actions interpolate between known endpoints rather than extrapolating from one |
| Turnover reconciliation against the Data Library annual figures | **0.13 percent for every year except 2016 at 0.8 percent** | Any regression against this is a new bug, which is exactly what a baseline is for |
| Panel against the independent trade archive | **99.93 percent close agreement across 817k rows** | A second source agreeing to three decimal places is a stronger check than an internal consistency rule |
| Implied VWAP inside the daily range | **99.82 percent of rows, 1,713 of 970,264 outside** | This is what isolated the published close as the anomalous field rather than the high, low or volume, which is a diagnosis rather than a count |
| Index cross-check | Items 07 and 11 agree exactly on the ASPI for all **3,443 dates** from 2012 to 2026-06-30 | Recorded so it is not re-investigated, which is itself part of a working QA record |
| Trading calendar validation | **3,920 trading days** matching both the Data Library annual market-day figure and the exchange annual reports for all 17 years | The calendar underpins every alignment decision downstream |
| Bar validity | High, low, open and close consistency asserted on load | Caught a real defect: at least one security, ASPM.N0000, prints a close outside its own high-low range |
| Structural integrity | No duplicate rows, no negative values, trade count 100 percent populated from 2012 | Clean results recorded alongside the failures, which is what makes the record credible |

**One stated limit on this suite.** [[Data Cleaning Checklist]] closes with an explicit list of files checked for structure and coverage only, and the honest conclusion attached to it: given that every file examined so far has carried at least one defect, the unexamined ones should not be assumed clean. That sentence belongs on the slide, because it shows the testing has a scope rather than a claim of completeness.

---

## Part 3. Tests planned against the orchestration and data layers

Named targets rather than a general promise. Each one maps to a requirement. `[EXTENDED 29 OCTOBER 2026]` Six rows added for **Must** requirements that previously had no test named anywhere in this note.

| Test | What it asserts | Requirement |
|---|---|---|
| Cursor violation | A query past the as-of cursor raises, and does not warn and continue | FR1, NFR1 |
| Contract conformance | Every agent returns all six fields with the declared types, and `as_of` equals the cursor | FR2 |
| State routing | `unparseable` yields a hard zero and removal from the simplex; `abstain` yields the floor; the two do not collapse | FR3 |
| Simplex invariant | Weights sum to one and no non-unparseable agent falls below $\phi$, asserted on every step of every run | FR5 |
| Arm isolation | Agent output files byte-identical across all five arms | FR7, NFR2 |
| Seed determinism | Two runs at the same seed produce identical artefacts | NFR3 |
| Calibration monotonicity | The accuracy-at-threshold transform is monotone and bounded in $[0,1]$ | MAI2 |
| Gate behaviour | The technical agent receives no weight on days where Theil's $U2 \geq 1$ | MAI3 |
| Result schema | No directional result is emitted without class balance, Matthews correlation and cost-adjusted return on the same row | NFR5 |
| Stability sweep is run, not tuned | The regularisation sweep executes and its full range is reported, with no code path selecting a favourable setting | NFR4 |
| Trade-count equalisation | No arm comparison is emitted unless trade counts are equalised and exposure time, holding period and turnover are present as fixed columns | NFR6 |
| Decision reconstruction | A decision sampled at random is rebuilt from the per-ticker-date log alone, agent outputs, state series and weights, and matches the original. **This is the test that makes contribution K7 verifiable**, since an explanation that was not recorded is not an explanation | NFR7 |
| Zero-return against non-trading | The two are held in separate fields, with volume rather than price change deciding and the exchange calendar separating them, asserted on the panel | DR5 |
| Survivorship proxy is labelled | Any survivorship statement carries the series-end-date proxy label and the residual bias, and no run emits a tradability mask presented as point-in-time | DR9 |
| Ex-date reliability is honoured | Every corporate-action event carries `ex_date_basis`, and any daily-return model drops or flags the events marked approximate | DR10 |

---

## Part 4. Model and behavioural checks

These sit between testing and evaluation. They do not assert correctness, they detect the failure modes that would make a correct-looking result meaningless, and each corresponds to a named risk.

> [!important]
> **Decided 29 October: these live here, not on slide 14.** The same seven appear in [[14 Evaluation and Experimental Design]] Part 5, and they should appear once. Slide 14 is already carrying five arms, three ablation families, an eleven-row protocol and the success criteria, so it keeps one line pointing here. The **Requirement** column is new and closes two coverage gaps at no cost: the first two checks are what **FR10a** requires as standard output, which is why it was promoted to Must, and the remaining five are **FR10b**.

| Check | Computation | The risk it tests | Requirement |
|---|---|---|---|
| Weight entropy over time | $H_t = -\sum_i w_{i,t}\ln w_{i,t}$ | Entropy collapse, the orchestrator converging on near-constant weights. Observed rather than hypothetical: MacroHFT's own weight trace is near-binary with three of six curves barely off the floor | **FR10a**, A2 |
| Sensitivity to liquidity | $\partial w / \partial L$ swept over the observed range on a frozen date | Inert weights. This is A3, and it is the check that matters | **FR10a**, A3 |
| Agent error correlation | Pairwise across the four agents | The heterogeneity claim is load-bearing and currently asserted rather than measured | FR10b |
| Volatility and liquidity collinearity | Idiosyncratic risk estimate against turnover | If the two move together, two agents are partly measuring the same thing and the state vector has a collinearity problem | FR10b |
| Fundamental agent weight trajectory | Weight series annotated with filing dates | Whether the mechanism is conditional or merely selective. If the orchestrator zeroes that agent permanently, heterogeneity survives on paper while the system behaves as three agents | FR10b |
| Oracle gap | $O$ minus $P$ | Estimation cost, separating a failed hypothesis from a failed estimator | FR10b |
| Quiet against stressed decomposition | Weights and performance split by regime | An orchestrator whose weights move impressively in the two or three most volatile months and are inert otherwise | FR10b |

---

## Part 5. Usability, accessibility and security, stated honestly

The template asks for this row and the honest answer is mostly that it does not apply yet, which is better said than padded.

- **Usability.** There is no interface, so there is no usability surface. Boundary requirement B6 records this.
- **Accessibility.** Nothing to test for the same reason. If an interface enters scope at IPD or later, the obligation arrives with it, and that is recorded in [[19 Responsible Research and Project Considerations]] rather than assumed away.
- **Security.** No personal data, no user accounts, no credentials, no network service. The real exposure surface here is not confidentiality, it is **false confidence**: a system producing a well-formed directional signal from an information channel that is empty. The controls against that are functional rather than infrastructural, and they are tested above as state routing, the confidence gate and the abstention floor.

---

## Part 6. Traceability

The chain the 11 October gate asked for, closed at the test end. This is also the backup slide the template recommends preparing for questions.

`[CORRECTED 29 OCTOBER 2026]` Relabelled against [[07 Research Questions, Aim and Objectives]]. The table previously traced RQ1, RQ2 and RQ3; those are now **MRQ** and **SQ1**, **SQ2**, and the persistence work is no longer a research question at all. Its tests are real and are kept as a supporting experiment rather than deleted.

| Question or experiment | Requirements | Tests and checks | Evidence produced |
|---|---|---|---|
| **MRQ** orchestration | FR2, FR3, FR4, FR5, FR7, FR8, FR10a, FR10b, NFR4, NFR6, MAI1, MAI2, MAI3, MAI4 | Contract conformance, state routing, simplex invariant, arm isolation, calibration monotonicity, gate behaviour, stability sweep is run not tuned, trade-count equalisation, and the behavioural checks in Part 4 | A1, A2, A4, A5, A6, five-arm table, per-input ablation deltas, entropy series |
| **SQ1** liquidity | FR6, FR9, DR4, DR5, DR8, MAI6 | Sensitivity sweep, crossing-stripped against unstripped comparison, zero-return against non-trading | A3 plot, the two separating ablations, the screen table by tier |
| **SQ2** confidence on a common scale | FR3, MAI2, MAI4 | Calibration monotonicity, state routing separating `abstain` from `unparseable` | The accuracy-at-threshold curves per agent, and the coverage-accuracy pair |
| **Persistence experiment**, a supporting experiment rather than a research question | DR7, MAI5 | Reproduction fidelity against published behaviour, $\hat{d}$ stability on rolling windows | Sharpe and recovery profile against baseline, stability report |
| Validity across all | FR1, NFR1, NFR2, NFR3, NFR5, NFR7, DR1, DR2, DR3, DR6, DR9, DR10 | Cursor violation, seed determinism, result schema, decision reconstruction, survivorship proxy label, ex-date reliability, Stage 6 suite | Exception log, identical artefacts, reconciliation figures, a reconstructed decision |

---

## Part 7. How testing develops across the project

`[ADDED 29 OCTOBER 2026]` The criterion rewards showing that testing develops rather than listing it once, and this note was a snapshot: executed data checks on one side, planned orchestration tests on the other, with nothing about when the planned ones arrive. Stages follow [[17 Project Plan, Milestones and Dependencies]] Part 1, so the dates after 5 November carry that note's **TBC** until they are confirmed.

| Stage | What comes online | What it means is true at the gate |
|---|---|---|
| **Now to PP, to 5 Nov 2026** | Data and model checks already executed and recorded, which makes them a regression baseline rather than a one-off. Integration behaviour specified as acceptance criteria A1 and A5. **No unit suite exists** | The Stage 6 figures are evidence on the slide, and the absence of unit tests is stated rather than implied |
| **PP to IPD, TBC** | Unit suite written alongside the orchestration build, starting with cursor violation, contract conformance and the simplex invariant, because those three protect properties that cannot be retrofitted afterwards. Requirements-based system tests for the Must set | A working prototype means every Must requirement has a test that runs |
| **IPD to final build, TBC** | Remaining orchestration tests. The NFR4 stability sweep and the NFR7 decision reconstruction. Data requirement checks DR5, DR9 and DR10 closed | Feature complete means no Must requirement is untested |
| **Testing and evaluation, TBC** | The Part 4 behavioural checks run at full scale as part of the evaluation rather than as a separate pass. NFR6 trade-count equalisation asserted on every comparison | The diagnostics are reported whether or not they are favourable |
| **Report and finalisation, TBC** | Regression run of the whole suite against the frozen artefact | Results are reproducible from the released pipeline |

---

## Part 8. Open decisions

`[UPDATED 29 OCTOBER 2026]` All three below were closed on 29 October. The closures are recorded rather than deleted.

1. ~~Whether a unit test suite exists in the repository today.~~ **Closed 29 October: none exist.** The note says planned because planned is accurate, and Part 7 says when they arrive. Claiming a suite that is not there is the one version of this that fails under questioning.
2. ~~Coverage reporting.~~ **Closed 29 October: show the requirement-to-test mapping, and say in one line why a coverage percentage is not the measure here.** The template asks for "coverage where suitable", so a stated reason reads better than an omission. The reason is that coverage counts lines executed, while the risk on a research pipeline is a correct-looking result from a wrong assumption, which the mapping in Part 6 and the behavioural checks in Part 4 are what actually address.
3. ~~Where the behavioural checks in Part 4 belong.~~ **Closed 29 October: here, on slide 15**, tied to FR10a and FR10b. [[14 Evaluation and Experimental Design]] Part 5 keeps one line pointing at them.

---

**Related notes.** [[Data Cleaning Checklist]] for the executed verification suite. [[10 Requirements]] for the requirements each test closes. [[13 Methodology]] for evaluation as distinct from verification. [[PoC Specification]] §8.2 for the diagnostics.

**Language discipline applies here too.** Figures quoted are measurements on this dataset over this window and are scoped to it. No claim of complete coverage is made, and the unexamined files are named as unexamined.
