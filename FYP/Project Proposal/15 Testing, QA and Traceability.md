---
status: current
created: 2026-10-23
written_against: "[[Data Cleaning Checklist]]; [[PoC Specification]]; [[PoC Data Build]]; [[10 Requirements]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 15 of the PP live presentation template. Testing design was scheduled for 25 October in [[29-09-2026]] §11.5 and has not been written, but one row of the template's table is already populated with executed results rather than plans: the data verification suite in [[Data Cleaning Checklist]] Stage 6. Sentiment is out of scope throughout.*

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
| Unit and component | Verify isolated logic: estimators, the calibration transform, the normalisation, the composite construction | **Planned.** Targets named in Part 3 | Test results |
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

## Part 3. Tests planned against the orchestration layer

Named targets rather than a general promise. Each one maps to a requirement.

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

---

## Part 4. Model and behavioural checks

These sit between testing and evaluation. They do not assert correctness, they detect the failure modes that would make a correct-looking result meaningless, and each corresponds to a named risk.

| Check | Computation | The risk it tests |
|---|---|---|
| Weight entropy over time | $H_t = -\sum_i w_{i,t}\ln w_{i,t}$ | Entropy collapse, the orchestrator converging on near-constant weights. Observed rather than hypothetical: MacroHFT's own weight trace is near-binary with three of six curves barely off the floor |
| Sensitivity to liquidity | $\partial w / \partial L$ swept over the observed range on a frozen date | Inert weights. This is A3, and it is the check that matters |
| Agent error correlation | Pairwise across the four agents | The heterogeneity claim is load-bearing and currently asserted rather than measured |
| Volatility and liquidity collinearity | Idiosyncratic risk estimate against turnover | If the two move together, two agents are partly measuring the same thing and the state vector has a collinearity problem |
| Fundamental agent weight trajectory | Weight series annotated with filing dates | Whether the mechanism is conditional or merely selective. If the orchestrator zeroes that agent permanently, heterogeneity survives on paper while the system behaves as three agents |
| Oracle gap | $O$ minus $P$ | Estimation cost, separating a failed hypothesis from a failed estimator |
| Quiet against stressed decomposition | Weights and performance split by regime | An orchestrator whose weights move impressively in the two or three most volatile months and are inert otherwise |

---

## Part 5. Usability, accessibility and security, stated honestly

The template asks for this row and the honest answer is mostly that it does not apply yet, which is better said than padded.

- **Usability.** There is no interface, so there is no usability surface. Boundary requirement B6 records this.
- **Accessibility.** Nothing to test for the same reason. If an interface enters scope at IPD or later, the obligation arrives with it, and that is recorded in [[19 Responsible Research and Project Considerations]] rather than assumed away.
- **Security.** No personal data, no user accounts, no credentials, no network service. The real exposure surface here is not confidentiality, it is **false confidence**: a system producing a well-formed directional signal from an information channel that is empty. The controls against that are functional rather than infrastructural, and they are tested above as state routing, the confidence gate and the abstention floor.

---

## Part 6. Traceability

The chain the 11 October gate asked for, closed at the test end. This is also the backup slide the template recommends preparing for questions.

| Research question | Requirements | Tests and checks | Evidence produced |
|---|---|---|---|
| RQ1 orchestration | FR2, FR3, FR4, FR5, FR7, FR8, MAI1, MAI2, MAI4 | Contract conformance, state routing, simplex invariant, arm isolation, calibration monotonicity | A1, A2, A4, A5, A6, five-arm table, per-input ablation deltas, entropy series |
| RQ2 liquidity | FR6, FR9, DR4, DR8, MAI6 | Sensitivity sweep, crossing-stripped against unstripped comparison | A3 plot, the two separating ablations, the screen table by tier |
| RQ3 persistence | DR7, MAI5 | Reproduction fidelity against published behaviour, $\hat{d}$ stability on rolling windows | Sharpe and recovery profile against baseline, stability report |
| Validity across all | FR1, NFR1, NFR2, NFR3, NFR5, DR1, DR2, DR3, DR6 | Cursor violation, seed determinism, result schema, Stage 6 suite | Exception log, identical artefacts, reconciliation figures |

---

## Part 7. Open decisions

1. **Whether a unit test suite exists in the repository today.** This note states unit tests as planned because the vault does not evidence them. If they exist, the slide should cite them rather than promise them.
2. **Coverage reporting.** The template's own wording is "test results, coverage where suitable". A coverage figure on a research pipeline is weak evidence; the requirement-to-test mapping in Part 6 is stronger, and only one of the two needs to be on the slide.
3. **Where the behavioural checks in Part 4 belong.** They are diagnostics in [[PoC Specification]] §8.2 and tests here. They should appear once, and slide 15 is the better home because the evaluation slide is already full.

---

**Related notes.** [[Data Cleaning Checklist]] for the executed verification suite. [[10 Requirements]] for the requirements each test closes. [[13 Methodology]] for evaluation as distinct from verification. [[PoC Specification]] §8.2 for the diagnostics.

**Language discipline applies here too.** Figures quoted are measurements on this dataset over this window and are scoped to it. No claim of complete coverage is made, and the unexamined files are named as unexamined.
