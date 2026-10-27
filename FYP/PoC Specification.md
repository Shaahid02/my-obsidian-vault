---
status: current
revised: 2026-10-27
written_against: 59 reviews; Research Gap; Contribution to Knowledge; 18-21 October data build; 26 October filings harvest
tags:
  - working-doc
---
*Created 13 October 2026, against [[Research Gap]] (59 reviews), [[Contribution to Knowledge]], [[Temp Progress Update]] and the revised plan in [[29-09-2026]]. This note states what gets built and what counts as the build succeeding. It does not restate why — that is in the gap and contribution notes. Sentiment is out of scope throughout.*

> [!NOTE]
> **Revised 27 October 2026, data availability only.** This note was written on 13 October, before the 18 to 21 October data build and before the filings corpus was harvested on 26 October. Every figure it carried for universe size, per-counter depth, turnover, trade count and filings was superseded by that work. Those figures are corrected below and each correction is marked `[CORRECTED 27 OCTOBER 2026]`, with the superseded text kept rather than deleted so the record of what was believed on 13 October survives.
>
> **Nothing else has been revised.** The acceptance criteria, the agent contracts, the orchestrator design, the arms, the ablations and the build order still stand as written on 13 October and have not been re-checked against the current position. The authoritative data figures are Part 1 and Part 1a of [[12 Data and Evidence Strategy]].

---

## Why this note exists

The research record is strong and the schedule is written, but the PoC exists in the vault only as schedule rows: *"implement the adaptive weighting function"*, *"run the ablations"*. Those are tasks, not a specification. Between them and working code sit roughly forty decisions — the agent output contract, how weights normalise, what an abstention actually does to the simplex, what gets logged — and if those are taken ad hoc on 18 October under time pressure they will be taken badly.

Everything here is already implied by the research notes. This note just makes it executable and puts the acceptance criteria before the code rather than after it.

**One framing to hold onto.** The PoC is not a trading system and must not be built as one. It is an existence proof for one sentence, and that sentence is already written in [[29-09-2026]] §7.10:

> **A small PoC shows changing liquidity actually changes the weights, the decision, or both.**

If the PoC demonstrates that and nothing else, it has done its job.

---

## Part 0. Acceptance criteria

Written first, deliberately, so the build is measured against them rather than against how much got implemented.

### The 25 October gate, from [[29-09-2026]] §11.5

> The PoC demonstrates **data → agents/components → state variables → orchestration → baseline comparison**.

### Operationalised as six binary checks

| # | Check | Evidence produced |
| --: | --- | --- |
| **A1** | One ticker-date sample passes end to end through all four agents, the state vector, the orchestrator and the decision, with no manual step | Saved run artefact, one row per ticker-date |
| **A2** | The weight vector $w_{i,t}$ is not constant over time | Weight trace plot plus entropy series $H_t$ |
| **A3** | The weight vector responds to $L_t$ specifically, holding the rest fixed | Sensitivity run: sweep $L_t$ over its observed range on a frozen date, record $\partial w / \partial L$ |
| **A4** | At least one decision flips sign between the equal-weight arm and the state-conditioned arm | Disagreement count between arms, with the dates listed |
| **A5** | Five arms run on identical data, identical agents, identical everything except the weighting function | Five output files, byte-identical agent outputs across all five |
| **A6** | Four ablations run and each produces an attributable delta | Ablation table, one row per removed state input |

**A3 is the one that matters.** A2 can be satisfied by noise. A3 is the mechanism.

### Explicitly not required by the PoC

Profitability. Statistical significance. `[CORRECTED 27 OCTOBER 2026]` Full-universe coverage, which is **355 core securities and 233 candidates** rather than the 270 written here. The fundamental agent working well. Hyperparameter tuning. A UI. Any of the Level B microstructure work. Per [[29-09-2026]] §11.8, time spent on these *reduces* proposal quality.

---

## Part 1. Scope and the freeze

**Hard rule, [[29-09-2026]] decision 6: no additional agents, datasets, research gaps or technologies after 18 October.** This note is written on 13 October and is the last point at which the component list can change.

### What is in

Four agents, unchanged across all 59 reviews — $A_T$ technical, $A_F$ fundamental, $A_V$ volatility, $A_L$ liquidity. One orchestrator. Four state inputs. Five arms. Four ablations. Two PoCs.

### What is out, and why each one is out

| Excluded | Reason |
| --- | --- |
| Any fifth agent, including macro | Rejected on evidence: ARDL adjusted $R^2 = 0.189$ over five macro variables, Granger nulls for money supply and inflation |
| Sentiment in any form | Supervisor, 20 September, Final |
| Level B microstructure execution | Bid/ask and depth not held. Level A proxy route only — [[29-09-2026]] §7.8 |
| EDGE spread estimation | Demoted to last resort 11 October. Unfalsifiable on this market |
| A learned network orchestrator | Low-capacity form is a stated design decision, not a shortcut. See §6.1 |
| RL training of any component | Not in the PP-stage plan and not needed for any acceptance criterion |
| Pairwise conflict, distribution shift, market-wide $L_t$, information filtering networks | Pre-registered as *tests*, not adopted components. They stay in the note as named future work |

---

## Part 2. Gate 0 — three cheap tests that precede the build

All three are specified in the research notes as things to run *before* committing to what sits on top of them. None currently appears in the 29 September schedule. Each costs hours, not days, and each can delete work.

### 0.1 The quantile-AR(1) scoping test on $L_t$

From [[Research Gap]], parsimony section. The BIS stress paper's forest beat a one-lag quantile AR in two markets of three.

> **If a quantile AR(1) on $L_t$ is as good as anything richer, the orchestrator conditions on the lag and the state-forecasting machinery is dead weight.**

Run it on the index track (ten years daily, secure) and on a handful of liquid counters. Output is one sentence: either the state-forecasting layer is justified or it is cut. Cutting it *simplifies the PoC*, which is the good outcome at this stage.

### 0.2 Tick-size classification

From [[HLOB – Information persistence and structure in limit order books]], via [[Research Gap]] Sub-gap 1. Compute $\langle\sigma\rangle / \theta$ — average spread over tick size — needing only best bid, best ask and the exchange tick schedule.

Large-tick means a compact learnable book. Small-tick means HLOB's own ceiling, MCC near 0.05, is what any microstructural route would be aiming at. **If small-tick, Level B closes at almost no cost and that is a reportable finding**, not a failure.

Blocked on bid/ask, which is not held. Run it the day that data arrives; until then record it as blocked rather than silently skipped.

### 0.3 The D17 per-counter liquidity screen

Flagged as priority action 10 in [[29-09-2026]] and as requiring no external data. It determines the actual experimental universe, and per §5.9 the important question is not whether ten years exist but **how many counters survive the screen**.

Compute per counter:

| Statistic | Notes |
| --- | --- |
| History length in trading days | `[CORRECTED 27 OCTOBER 2026]` **Computed. Median roughly 3,400 days, 10th percentile 1,081.** The 374-day / 10-year tension recorded below is resolved |
| % of days with non-zero volume | |
| Zero-return frequency | Recorded **separately** from non-trading |
| $\tau_t$ rate | Fraction of days where open or close coincides with high or low. Needs no estimator and is falsifiable, unlike a spread estimate |
| Median and mean volume, ADV | |
| Median turnover | `[CORRECTED 27 OCTOBER 2026]` **Held across the full span**, confirmed 18 October. The D13 17-month restriction written here no longer applies |
| Amihud | `[CORRECTED 27 OCTOBER 2026]` **Computable over the whole window** for the same reason |
| Missing-day count | |

> **The count of counters the trading-day filter removes on an average day is itself a liquidity statistic worth reporting** — [[Contribution to Knowledge]] K5.

### 0.4 A documentation conflict to resolve while doing 0.3

> [!NOTE]
> **Resolved 27 October 2026.** The screen was run and the conflict below is closed. The authoritative figures are **355 core securities and 233 candidates**, over a window of **2012-07-01 to 2026-06-30**, with **3,920 validated trading days** in the calendar and a **median per-counter depth of roughly 3,400 days**, 10th percentile 1,081. Neither of the two figures the paragraph below sets against each other was right: 374 days was never a per-counter depth, and the 270 x 10-year envelope was both the wrong count and the wrong span. [[ELI5 - The Whole Project in Plain English]] was corrected on 27 October and is safe to quote from again. The paragraph below is kept as the record of the conflict, not as a live instruction.

[[Research Gap]] and [[ELI5 - The Whole Project in Plain English]] both state **374 trading days per counter**. [[Temp Progress Update]] states **270 companies across 10 years**, correctly caveated as an envelope rather than realised coverage. Read side by side these contradict, and [[29-09-2026]] §5.3 separately records that the 270 × 10-year dataset has no row in the Dataset Matrix at all.

The screen in 0.3 produces the authoritative number. **Nothing in the PoC should quote either figure until it does.** This is the same documentation-integrity problem the supervisor raised, one layer further in, and it sizes the experiment.

---

## Part 3. PoC-B — the persistence experiment

**Build this first.** Three separate notes say so. It needs no CSE data, which takes Sub-gap 2 off the critical path entirely, and until it runs the sub-gap is a hypothesis rather than a contribution ([[29-09-2026]] §3.4).

The 29 September schedule places it on Sun 25 Oct. Given that the CSE data bottleneck is unresolved and this experiment is immune to it, **moving it ahead of PoC-A's agent build is the lower-risk ordering.**

### B.1 Reproduce the baseline

Rebuild the target-volatility scaler from *Deep Learning for Portfolio Optimization* on that paper's own four-ETF environment. Verify the reproduction approximately matches reported behaviour — the paper's Sharpe moves 0.929 → 1.526 and the scaler, which is *not learned*, does most of that work.

$$\text{scaler}_t = \frac{\sigma_{\text{tgt}}}{\hat{\sigma}_{t-1}}, \qquad \hat{\sigma}^2_t = \lambda\hat{\sigma}^2_{t-1} + (1-\lambda)r^2_{t-1}, \qquad \text{half-life } h = \frac{\ln 0.5}{\ln \lambda}$$

**If the reproduction does not approximately match, stop and report that.** A failed reproduction is itself a finding and is cheaper to report than to paper over.

### B.2 Substitute persistence-aware decay

The EWMA half-life assumes exponential decay. That is the assumption the CSE long-memory results contradict. Replace $\hat{\sigma}_{t-1}$ with a multi-step FIGARCH forecast whose shock impulse decays hyperbolically, $\psi_k \sim k^{d-1}/\Gamma(d)$, rather than geometrically at $\lambda^k$:

$$h_t = \omega\left[1-\beta(L)\right]^{-1} + \left\{1 - \left[1-\beta(L)\right]^{-1}\phi(L)(1-L)^d\right\}\epsilon_t^2$$

The re-levering schedule then follows the forecast path. **Variance says how bad now, persistence says how long** — the supervisor's distinction, and the reason $d$ alone is not a daily trading signal.

### B.3 What gets reported

| Output | Required |
| --- | --- |
| Reproduction fidelity against published numbers | Yes |
| Sharpe, drawdown and recovery profile, baseline vs proposed | Yes |
| Stability of $\hat{d}$ over the rolling window | Yes — this is a named risk |
| Behaviour when $\hat{d}$ estimation is unstable | Yes, with the per-regime fallback |
| **A null result, if that is what happens** | **Yes.** [[29-09-2026]] §11.5: *record failure if no improvement occurs — do not hide it* |

---

## Part 4. The data layer

### 4.1 The as-of cursor — build this first, before any agent

[[Contribution to Knowledge]] C6. A **single** as-of cursor enforced at the data layer for all four channels, not per-agent filtering. Every retrieved document carries a publication-date field; the retrieval filter is keyed to the simulation clock.

This is the cheapest contribution in the project and the easiest to lose by building agents first and retrofitting the clock. Two documented failures on this market sit on either side of it: the CSE Graph-RAG snapshot with no as-of field at all, and the firm-specific-factors study selecting the top twenty counters by 2023 capitalisation and backfilling to 2013.

**Implementation rule:** no component receives a dataframe. Every component receives a query against the data layer, and the data layer refuses any row whose timestamp exceeds the cursor. Make the violation an exception, not a warning.

### 4.2 Schema

One ticker-date table as the spine. Every column marked raw or derived, with its source recorded. Temporal alignment rule and missing-value treatment defined once, at the layer, not per agent.

### 4.3 What is held, and what the PoC therefore runs on

> [!important]
> **`[CORRECTED 27 OCTOBER 2026]` This table is superseded.** It was written on 13 October against the position before the data build. Six of its eight rows have changed status. The current table is immediately below; the 13 October version is kept after it.

| Field | Status at 27 October | Consequence for the PoC |
| --- | --- | --- |
| Date, ticker, OHLC, volume | ✅ Held. **355 core securities, 233 candidates**, roughly 853,535 traded rows, median depth roughly 3,400 days | Spine |
| Adjusted panel | ✅ Held. Built 23 October, carrying `adj_close` and `tr_close`, with 31 register corrections | Returns are computable without the detect-and-exclude workaround |
| Index track | ✅ Held. ASPI clean across 2012-07-01 to 2026-06-30 | Three labelled regimes inside the window: Easter attacks, COVID, 2022 crisis. **The evaluation benchmark is ASTRI, not a price index** |
| Turnover / trading value | ✅ Held across the full span, confirmed 18 October | Amihud and the turnover ratio enter the liquidity composite over the whole window |
| Number of trades | ✅ Held | Trade intensity available |
| Market capitalisation | ✅ Held, with quarterly float 2012 to 2026 H1 | Size tiering available. **Stratification is float-adjusted**, raw reported alongside as robustness |
| Filings corpus | ✅ Held. 22,893 documents, 2012-01-01 to 2026-10-04, roughly 340 counters, every filename prefixed with the CSE announcement date | $A_F$ has a corpus, and the as-of cursor filters on publication date rather than reporting-period end. Usable coverage on numerically demanding questions is still to be measured |
| Bid / ask / depth | ❌ Not held, and not available in any of the Data Library's forty items | **The only remaining gap.** Level B closed, tick-size test blocked, cost work runs on proxies for illiquidity |
| Listing / delisting register | ❌ Not held | **Survivorship bias is present and must be reported, not silently carried.** Series-end dates used as a labelled proxy |

**The honest wording for what is missing**, under the [[29-09-2026]] §5.7 rule: *long-horizon bid, ask and depth history aligned to the price series has not yet been secured.* Do not write that turnover or market capitalisation are unavailable, because both are held.

<details><summary>The superseded 13 October table, kept as record</summary>

| Field | Status | Consequence for the PoC |
| --- | --- | --- |
| Date, ticker, OHLC, volume | ✅ Held, 270 counters | Spine |
| ASPI index track, 1 Jul 2014 – 30 Jun 2024 | ✅ Held, ~2,400 obs | Three labelled regimes: Easter attacks, COVID, 2022 crisis |
| Turnover / trading value | ❌ Not held long-horizon (D13 has 17 months) | Amihud and turnover ratio unavailable for most of the window |
| Number of trades | ❌ Not held | — |
| Bid / ask | ❌ Not held | Level B closed; tick-size test blocked |
| Market capitalisation | ❌ Not held long-horizon | Size tiering unavailable |
| Listing / delisting register | ❌ Not held | **Survivorship bias is present and must be reported, not silently carried** |

Its honest-wording rule read: do not write "turnover and market cap are unavailable", because D13 has them for 17 months. Write: *long-horizon turnover, trade-count, bid/ask and market-cap history aligned to the ten-year OHLCV series has not yet been secured.* That wording is now wrong in the other direction and must not be reused.

</details>

---

## Part 5. The agents

### 5.1 The common output contract

Every agent returns the same structure, whatever it is internally. This is what makes the pool weightable at all and it is the single most load-bearing piece of plumbing in the PoC.

| Field | Type | Notes |
| --- | --- | --- |
| `signal` | float in $[-1, 1]$ | Directional view. Sign is the decision, magnitude is conviction |
| `confidence_raw` | float | Agent-native, **not comparable across agents** |
| `confidence_calibrated` | float in $[0,1]$ | $c_{i,t}$ after the accuracy-at-threshold transform. This is what the orchestrator sees |
| `state` | enum | `ok` · `abstain` · `unparseable` · `no_data` |
| `as_of` | timestamp | Must equal the cursor |
| `diagnostics` | dict | Agent-specific, logged not consumed |

**`unparseable` is a distinct state from `abstain`**, and they route differently in §6.3. Collapsing them loses [[Contribution to Knowledge]] C3 element 2.

### 5.2 Minimum viable implementation per agent

The PoC needs each channel to *exist and emit the contract*, not to be good.

| Agent | PoC implementation | Confidence mechanism |
| --- | --- | --- |
| $A_T$ technical | Standard feature set over OHLCV, simple predictor. Deliberately plain | Theil's $U2$ against the random walk: $U2 = \sqrt{\sum(\hat{y}-y)^2} / \sqrt{\sum(y_{\text{naive}}-y)^2}$. $U2 \geq 1$ means the channel does not beat "tomorrow is like today" and gets no weight that day |
| $A_V$ volatility | Parkinson or Garman-Klass on the daily bar, GJR-GARCH or FIGARCH for the forecast | Adaptive conformal inference wrapper; $C_{V,t}$ a function of realised interval width at target coverage. A drifted model reports wider intervals and down-weights itself with nobody asking it anything |
| $A_L$ liquidity | Computed from the composite in §5.3, emitting a directional view | Rolling loss ratio against a fixed benchmark. Unit-free |
| $A_F$ fundamental | **Minimal.** Retrieval over whatever filings exist, numeric extraction, program emission | Does the program parse under the grammar · does every argument trace to a retrieved figure rather than being invented · step count as a calibrated difficulty proxy |

**On $A_F$ and the step-count proxy.** Published accuracy runs 67.61% / 59.08% / 22.78% across one-step, two-step and three-or-more-step programs. So step count alone tells you how much to trust the answer without asking the model anything.

**On $A_F$'s expected coverage — correct the wording now.** Per [[29-09-2026]] §4.2, the >50% unusable figure comes from other financial-QA pipelines, not from the CSE corpus. The PoC must write:

> Working hypothesis based on benchmark evidence: $A_F$ may have low usable coverage on numerically demanding CSE questions.

Then measure it with the probe set. **Do not present 50–53% as an established CSE fact.**

**$A_F$ is the agent most likely to be partly stubbed at 18 October, and that is acceptable.** What is not acceptable is $A_F$ being silently absent, because A6 requires $A_F$ on/off inside the full framework.

### 5.3 The common confidence scale

The one piece that makes four incomparable numbers comparable. Map each agent's raw score through **its own empirical accuracy-at-threshold curve**, estimated on a rolling validation window, landing every agent in the same unit: *probability of being right at the score just emitted*.

$$c_{i,t} = \widehat{\Pr}\left(\text{correct} \mid \text{confidence\_raw}_{i,t}\right)$$

A softmax output and a posterior variance are not comparable. Two points on an empirical accuracy curve are.

**State the limit in the same breath, every time.** Whether several backward-looking competence estimates can be made comparable across four architectures is open. Having mechanisms is progress on the problem, not a solution to it — [[Contribution to Knowledge]] C2 and K2.

---

## Part 6. The state vector and the orchestrator

### 6.1 $L_t$, the liquidity composite

Upgraded in the 12 October revision from a single Amihud number to the BIS market-condition-indicator recipe:

1. Sign every input so that **higher means worse**
2. Z-score each
3. First principal component over an expanding window starting from a three-year block
4. Re-normalise

**Inputs available to the PoC at Level A:** zero-return frequency, the high-low range, $\tau_t$, and volume-derived measures. Amihud and the turnover ratio enter only where turnover exists.

Two near-free habits to adopt, both from the BIS paper: run the **full-sample PCA alongside the rolling one and plot both**, which is direct evidence of how much look-ahead a naive construction would have injected; and report attribution only for components clearing their own out-of-sample benchmark.

### 6.2 $V_t$ and $P_t$

$V_t$: estimator pinned to Parkinson or Garman-Klass, because five-minute realised volatility is unavailable on this market.

$$\sigma^2_{\text{P}} = \frac{1}{4\ln 2}\left(\ln \frac{H}{L}\right)^2, \qquad \sigma^2_{\text{GK}} = \frac{1}{2}\left(\ln \frac{H}{L}\right)^2 - (2\ln 2 - 1)\left(\ln \frac{C}{O}\right)^2$$

Freeze which one before the run, not after seeing results.

$P_t$: the fractional differencing parameter $d$. Report the estimator's own stability on the rolling window; fall back to per-regime estimation if unstable. This is a named risk, not a hypothetical.

### 6.3 The orchestrator

$$s_{i,t} = \beta_i^\top x_t + \gamma_i\, c_{i,t}, \qquad x_t = [1,\ L_t,\ V_t,\ P_t]^\top$$

**Low capacity — gated linear or shallow regression, not a network.** The reason is on the record: the regularisation sign-flip observed in the source portfolio work, where the Sharpe ratio reverses sign as L2 moves from 0.001 to 0.002, on a universe larger and a history longer than the CSE offers. The orchestrator's own stability has to be **swept and reported**, not tuned once.

No pairwise interaction term. This is now a cited choice rather than a simplification — Bates and Granger, Newbold and Granger, and Winkler and Makridakis all find that ignoring error covariances is the better practical choice because covariance estimates are unstable, and with four agents the full matrix costs ten parameters against a few hundred days.

**Normalisation, with the abstention floor. Proposed form, needs one decision:**

Let $U_t$ be the set of agents in state `unparseable` — these receive a **hard zero** and are removed from the simplex before anything else. Let $K$ be the number of remaining agents and $\phi$ the floor.

$$\tilde{w}_{i,t} = \frac{\exp(s_{i,t})}{\sum_{j \notin U_t}\exp(s_{j,t})}, \qquad w_{i,t} = (1 - K\phi)\,\tilde{w}_{i,t} + \phi$$

This guarantees every non-unparseable agent at least $\phi$, sums to one, and implements the design change Geweke and Amisano forced: **shrink an abstaining agent toward a floor rather than to exactly zero**, because individually poor forecasts can still help in combination. The hard zero is reserved for output that does not parse, which is a different case.

> ⚠️ $\phi$ is a free parameter and the note does not currently fix it. Set it at the **knee of the coverage-accuracy frontier**, not at its end, and report coverage alongside every accuracy figure. Sweep it; do not pick it.

Decision then:

$$\text{Decision}_t = \sum_i w_{i,t}\,A_{i,t}$$

### 6.4 The liquidity-to-reliability coupling

This is where Sub-gap 1 integrates with the main contribution rather than sitting beside it, and it is what A3 tests:

$$C'_{T,t} = C_{T,t} \cdot g(L_t), \qquad g \text{ decreasing in illiquidity}$$

Poor liquidity does not only make a trade expensive. It makes the price-derived evidence supporting that trade less trustworthy, because the price series feeding $A_T$ is itself noisier when the counter barely trades. **One measurement, two uses** — and on the CSE a third, since volume Granger-causes the index at $p = 0.0041$.

### 6.5 Cost inside the objective

Out of scope for the PoC's first pass, in scope for the spec because the design must not foreclose it. The target form:

$$\max_{a_t}\left[U(a_t) - \lambda\,C(a_t, L_t)\right], \qquad \rho_t = \frac{Q_t}{ADV_t}, \qquad C_t = f(\rho_t, L_t)$$

The orchestrator must therefore expose the proposed allocation *before* it is committed, not only the final decision. Building it to return only a decision closes this door.

**Calibrate the participation sweep against float, not shares outstanding** — mean institutional ownership on this market is 66.1% against insider 5.7%, so available depth is far worse than capitalisation suggests.

---

## Part 7. The five arms

Per [[Research Gap]], evaluation commitments 1 and 2. **Three arms is not enough.**

| Arm | Weighting | What it exists to rule out |
| --- | --- | --- |
| $B_1$ | Equal weight | The field's hardest benchmark. Fifty years of forecast-combination evidence says this is hard to beat, and the usual reason sophisticated schemes lose is that weight-estimation error exceeds the gain |
| $B_2$ | Static learned weight | Beating equal weighting proves little if a fixed learned weight gets there too. Reference implementation: Automate Strategy Finding |
| $B_3$ | Discounted inverse-MSE, **no market state** | **The arm that actually threatens the contribution.** If reacting to recent agent performance does as well as conditioning on measured state, the state conditioning is not earning its place |
| $P$ | State-conditioned — the proposal | |
| $O$ | Oracle, weights fitted on the test window | Prices the estimation cost in your own data and units. One extra pass of the same pipeline |

Plus a **Stock and Watson inverse-$k$ sweep**: one parameter, mapping the whole continuum from equal weights to winner-take-all.

**The non-negotiable fairness rule.** $B_2$ must be identical to $P$ in every respect except the weighting function. The CSE Graph-RAG paper's fatal flaw is that its proposed system got both the graph and the agent scaffolding while its baseline got neither. Do not reproduce it. **A5 exists to enforce this**: agent outputs must be byte-identical across all five arms, which is only achievable if the agents run once and the arms consume the same cached outputs.

### Reading the oracle gap

| Oracle result | Estimated result | Conclusion |
| --- | --- | --- |
| No gain | — | The conditioning hypothesis is wrong. Report it |
| Gain | Gain | The mechanism works |
| Gain | No gain | An **estimation** problem with a number attached, not a conceptual failure |

The pre-registration must separate the two failure modes that look identical in the output: the weighting genuinely not helping, which is the field's prior, versus the weighting helping and the test being unable to see it. The first says abandon the conditioning; the second says change how it is estimated.

---

## Part 8. Ablations and diagnostics

### 8.1 Ablations — one state input at a time

$P - L_t$ · $P - V_t$ · $P - P_t$ · $P - C_{i,t}$

Plus **$A_F$ on and off inside the full framework, which is required rather than optional.**

Then, for the liquidity coupling specifically: $P - \text{LiquidityReliability}$ and $P - \text{CostObjective}$, separating whether any improvement comes from changing agent trust, changing execution decisions, or both.

### 8.2 Pre-registered diagnostics

These are not optional extras. Each corresponds to a named risk in [[Contribution to Knowledge]] Part 5, and each is much better found by you than by an examiner.

| Diagnostic | Computation | The risk it tests |
| --- | --- | --- |
| **Weight entropy over time** | $H_t = -\sum_i w_{i,t}\ln w_{i,t}$ | Entropy collapse — the orchestrator converging on near-constant weights. MacroHFT's own weight trace is near-binary with three of six curves barely off the floor, so this is observed, not hypothetical |
| **Agent error correlation** | Pairwise over the four agents | The heterogeneity claim is load-bearing and currently asserted. If $A_T$ and $A_V$ correlate at 0.8 the pool is less diverse than the diagram implies and the error-cancellation argument weakens |
| **$A_V$/$A_L$ collinearity** | Idiosyncratic risk estimate against turnover | If those move together the two agents are partly measuring the same thing and the state vector has a collinearity problem |
| **$A_F$ weight trajectory around reporting dates** | Weight series, annotated with filing dates | Tests whether the mechanism is *conditional* or merely *selective* — i.e. whether the orchestrator zeroes $A_F$ permanently, leaving heterogeneity on paper while the system behaves as three agents |
| **Oracle gap** | $O$ minus $P$ | Estimation cost |
| **Quiet vs crisis decomposition** | Weights and performance, split | The trap is an orchestrator whose weights move impressively in the two or three most volatile months and are inert otherwise |

---

## Part 9. Evaluation protocol

Not novel, and not claimed as novel. What does not exist in the reviewed literature is a **CSE baseline set produced under it** — [[Contribution to Knowledge]] K3.

| Commitment | Detail |
| --- | --- |
| Splits | Chronological. Walk-forward with adaptive retraining |
| Seeds | Multiple, with repeated windows. Report dispersion |
| Regimes | Decomposed across the Easter attacks, COVID and the 2022 crisis |
| Costs | Sensitivity sweep, not a single assumption. Friction charged in quiet periods too |
| Significance | HAC-adjusted and bootstrap. **Note the warning**: standard errors for a combined forecast are nontrivial because the weights are random and correlated with the forecasts |
| Every directional result | Carries class balance, Matthews correlation and cost-adjusted return **on the same row**. The local example of why: accuracy 0.5837 at MCC 0.1493 |
| Trade counts | Equalised before comparing. Report exposure time, holding period, turnover as fixed columns |
| Abstention | Evaluated **economically or not at all**: return per traded day, total return with abstained days held flat, cost per turn, alongside the coverage-accuracy pair. State the abstained-day exposure policy — hold or go flat — explicitly, since the flat option carries a round-trip cost each time |
| Reproducibility | Release the pipeline. Three documented instances exist in the reviewed set of published financial ML results that cannot be checked as published |

### Two structural breaks that must be handled, not discovered

**SLFRS 16 in 2019** makes any lease-sensitive or PPE-derived fundamental feature non-comparable across that boundary. **Nominal price distortion across 2020–2023** means rupee-denominated features need deflating or expressing as ratios. Both belong in the methodology, not in an ablation post-mortem.

### One data-depth constraint with a number attached

Adaptive conformal inference, the method behind $C_{V,t}$, is calibrated in its source on a **1250-day** refit window. That is five years of daily data per counter.

`[CORRECTED 27 OCTOBER 2026]` The sentence that followed here said the per-counter archive is far shorter than 1250 days. That was written before the depth was measured and it is wrong for most of the universe. **Median per-counter depth is roughly 3,400 days**, so a 1250-day refit window fits with roughly 2,150 days left to evaluate on. The constraint does not disappear, it relocates: **the 10th percentile is 1,081 days**, which does not accommodate the window at all, and the counters in that tail are precisely the thin end of the cross-section this project is about. So the problem now reads as a stratum-dependent one rather than a universal one, and it bites hardest exactly where the contribution is claimed.

On the index track the method transfers as written. On the per-counter track it transfers for the liquid strata and not for the thin ones. The two honest options are unchanged in kind: a shorter joint window with the calibration degradation reported, or pooling scores across counters, which breaks the per-counter conditioning the method relies on. A third is now available, namely applying the source window where depth allows and a declared fallback below a stated depth threshold, with the threshold and the affected counter count reported. **Pick one and say which, before running.**

---

## Part 10. Pre-registration block

Fill this in and freeze it **before** the first full run. The whole attributability argument depends on these being decided in advance.

| Item | Value | Status |
| --- | --- | --- |
| Primary metric | | ☐ To fix |
| Minimum margin counting as a win over $B_1$ | | ☐ To fix |
| Significance test and $\alpha$ | | ☐ To fix |
| Number of seeds / repeated windows | | ☐ To fix |
| Volatility estimator: Parkinson or Garman-Klass | | ☐ To fix |
| Abstention floor $\phi$, and the sweep range | | ☐ To fix |
| Abstained-day exposure policy: hold or flat | | ☐ To fix |
| Conformal window treatment: short joint, or pooled | | ☐ To fix |
| $L_t$ composite input list, final | | ☐ To fix |
| Experimental universe after the D17 screen | | ☐ Blocked on Gate 0.3 |

> **Decide now that a null is an acceptable outcome.** The forecast-combination literature's fifty-year finding is that equal weights are hard to beat; its two guidelines cut in opposite directions here — limited data argues for the simple average, structural change argues for changing weights — and the review states plainly that there is no comprehensive quantitative guidance on when to choose which. **An answer on a thin frontier market is a contribution even if the answer is that equal weights win** — provided the margin and the test were written down before the run rather than after.

---

## Part 11. Build order

Mapped onto the remaining schedule. The reordering against [[29-09-2026]] is deliberate and limited: Gate 0 inserted, PoC-B pulled forward.

| When | Build | Gate |
| --- | --- | --- |
| **13–15 Oct** | Gate 0.1 and 0.3. Resolve the 374-day / 10-year conflict. Freeze the experimental universe | Universe known |
| **15–17 Oct** | PoC-B: reproduce the scaler, substitute persistence decay, report | Sub-gap 2 is a result or a reported null |
| **17 Oct** | Data layer: as-of cursor, schema, loader. **Nothing else before this** | Cursor violations raise |
| **18 Oct** | Agent output contract. Four agents emitting it. Equal-weight combiner. One ticker-date end to end | **A1. Freeze — no new components after today** |
| **20 Oct** | State vector: $L_t$ composite, $V_t$, $P_t$, $c_{i,t}$ calibration transform | State series exist |
| **21 Oct** | Orchestrator: gated linear, floor, abstention routing, liquidity coupling | **A2, A3** |
| **22 Oct** | Five arms off cached agent outputs | **A4, A5** |
| **23–24 Oct** | Four ablations. Diagnostics. Stability sweep on the orchestrator | **A6** |
| **25 Oct** | PoC evidence capture: architecture diagram, one pipeline result, baseline comparison, one ablation. Freeze PoC v1 | **25 Oct gate** |

**The 17 October ordering is the one to protect.** Building agents before the as-of cursor exists is how lookahead gets in, and it is the one contribution in this project that cannot be retrofitted.

---

## Part 12. Risks against the PoC specifically

| Risk | Signal | Fallback |
| --- | --- | --- |
| $A_F$ unbuildable in time | Retrieval over CSE filings proves slower than estimated | Stub it against the probe set, but keep it emitting the contract so the on/off ablation still runs. Report it as stubbed |
| Weights are inert — A2 or A3 fails | Entropy flat, $\partial w/\partial L \approx 0$ | This is a **finding**, not a build failure. Report the sensitivity sweep and investigate whether it is the form, the scaling or the state |
| Orchestrator unstable across regularisation | Sharpe or metric sign-flips under small L2 changes | Expected and pre-empted. **Sweep and report** rather than tuning to the good value |
| Agent outputs not byte-identical across arms | A5 fails | Architectural, not incidental: run agents once, cache, have arms consume the cache |
| $\hat{d}$ unstable on short windows | Wide variation across rolling estimates | Per-regime estimation and a slower-moving cap. Report the instability |
| Universe collapses after the D17 screen | Few counters survive | The surviving count **is a result** — K5. Run on what survives and report the screen |
| Simulated slippage mistaken for measured slippage | — | Present it as simulated. There is no ground-truth execution data to validate a CSE simulator against |
| Scope creep back into the PoC | Any new agent, dataset or technology after 18 Oct | Hard rule. Decision 6 |

---

## Part 13. Open decisions

Things this spec cannot settle and that someone has to.

1. **$\phi$, the abstention floor.** No value is anywhere in the vault. §6.3 proposes setting it at the knee of the coverage-accuracy frontier and sweeping it.
2. **Parkinson or Garman-Klass.** Both named, neither chosen. Freeze before running.
3. **Where PoC-B sits in the order.** This spec moves it ahead of the agent build against the 29 September schedule. Worth a line to the supervisor rather than a silent reordering.
4. **The conformal window compromise.** `[UPDATED 27 OCTOBER 2026]` Reframed by the measured depth in Part 9. The choice is no longer forced across the whole universe, since the median counter carries roughly 3,400 days against the 1250-day requirement. It is forced below roughly the 10th percentile, 1,081 days. Short joint window with reported degradation, pooled scores breaking per-counter conditioning, or a depth threshold with a declared fallback beneath it. All three are defensible; only one can be run, and the threshold and affected counter count must be reported either way.
5. **Whether the state-forecasting layer survives Gate 0.1.** If the quantile AR(1) wins, the PoC gets simpler. Decide the response before seeing the result.
6. **Intraday data, regardless of EDGE.** A month of minute prices is worth vastly more to a cost model than a year of daily prices, roughly $390^{3/2}$ against $\sqrt{252/21}$. If any intraday CSE feed exists at any granularity it is worth more than extending the daily archive backwards. This is a supervisor question and it is independent of everything else here.

---

**Related notes.** [[Research Gap]] for what the literature lacks. [[Contribution to Knowledge]] for what this produces. [[ELI5 - The Whole Project in Plain English]] for the same material without jargon, corrected 27 October. [[12 Data and Evidence Strategy]] for the authoritative data figures this note was corrected against. [[29-09-2026]] for the schedule and gates this spec is built against. [[Scope sentiment analysis dropped]] for the standing scope decision.

**Language discipline applies here too.** No "first / nobody / never". The permitted form is *"I have not found that evaluation in the literature I have covered."* The gap statement carries a 2026-03-09 cutoff and should be re-checked before submission.
