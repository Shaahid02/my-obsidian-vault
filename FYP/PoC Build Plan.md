---
status: current
created: 2026-10-18
written_against: "[[29-09-2026]]; [[Week 4]]; [[PoC Specification]]"
tags:
  - working-doc
---
*Created 18 October 2026, against the revised plan in [[29-09-2026]], the panel directives in [[Week 4]], and [[PoC Specification]]. This note does not replace the spec. The spec says what the PoC is; this note says what gets built in the hours that remain, where the supervisor and the panel point in different directions, and how each difference is resolved. Sentiment is out of scope throughout.*

---

## 0. The constraint this note is written under

No code exists on 18 October. The spec's build order assumed Gate 0 complete by 15 October, PoC-B by 17 October and the data layer by 17 October. None of that happened, so the build order has to be re-cut against the hours actually available.

Availability per [[29-09-2026]] §11.1, from today to the 25 October gate:

| Day | Hours |
|---|--:|
| Sun 18 Oct | 12 |
| Mon 19 Oct | 0 |
| Tue 20 to Fri 23 Oct | 2 each |
| Sat 24 Oct | 4 |
| Sun 25 Oct | 12 |
| **Total** | **36** |

Thirty-six hours, from nothing, to the gate in [[29-09-2026]] §11.5: *data to agents to state variables to orchestration to baseline comparison*.

**The useful consequence.** [[Week 4]] §2.6 prescribes a PoC deliberately smaller than the spec's, and §2.6 is explicit that four agents and the full LLM framework are not where to start. At 36 hours the small version is not a compromise, it is the only version that reaches a gate at all. The two sources arrive at "smaller" from different directions and the overlap is what gets built.

**Today is also the freeze date.** [[29-09-2026]] decision 6 bars new agents, datasets, gaps or technologies after 18 October. The component list fixed in §2 below is therefore the final list, and fixing it is itself the freeze.

---

## 0a. Amendment, 18 October 2026, evening

Written after reading the rebuilt Dataset sheet and [[Research Matrices Status]]. The dataset record changed today, after [[PoC Specification]] was written on 13 October, so three statements in §2 to §4 below are superseded. They are marked `[CORRECTED 18 OCT]` in place rather than rewritten silently. Three findings matter to the build.

**1. The primary series is not adjusted for corporate actions, and this is the binding data constraint.** D22 is unadjusted, confirmed by inspection today. JKH closes at 212.50 on 2024-10-28 and 21.20 on 2024-11-06, a share split rendered as a return of minus ninety percent; AAF shows plus 767 percent in 2019. Everything the PoC produces sits downstream of a return, so the direction label, Parkinson on a split-day range, Amihud, the confidence calibration and every arm comparison are all affected. D26, the adjusted series, is what the build should consume and it does not exist. It depends on D25, inside the D24 Data Library purchase at Rs 1,500, not yet bought, delivery time unknown.

**Interim rule for the PoC, to be written into the pre-registration block:**

| Step | Action |
|---|---|
| Purchase | Initiate the D24 order today, independent of the PoC. The real system needs it and the lead time is unknown |
| Detect | Jump detector as the **first** task on the spine, before the liquidity screen. Flag days where the close-to-close ratio sits near a simple split ratio with no matching turnover behaviour |
| Exclude | Select the 5 to 10 PoC counters from those with no detected event inside the window. With roughly 292 ordinary counters available this is cheap. State the rule and report how many counters it removed |
| Carry | Dividends will not be caught by ratio snapping. Roughly one mislabelled day per dividend per counter survives, on the order of one percent of counter-days. Quantify it, report it as a known label error, correct it when D25 arrives |
| Bias | Counters that split are disproportionately ones that rose. Report the direction of the exclusion bias |

**2. Turnover and trade count are held across the full span**, not only the 17 months the spec's §4.3 assumed. D22 carries `turnover` and `trade_volume` from 2012-01-02 to 2026-10-02. Amihud and the turnover ratio therefore enter the $L_t$ composite over the whole window rather than a fragment, which is a stronger composite than §3 below assumes.

**3. Per-counter history is median roughly 3,400 days**, not 374. The 374 figure was the superseded Chindara archive. Coverage is uneven, with the 10th percentile at 1,081 days, but $\hat{d}$ is estimable per counter for well-covered securities.

**Two further data facts that bound the build.** Of 334 counter files, 17 are rights instruments and belong out of the universe, and 61 securities end before 2026-10-02, which mixes delistings, suspensions and dormancy. D16 holds 119 delisted company names with no effective dates, so a point-in-time tradability mask is not possible; use the D22 series-end dates as a proxy, say plainly that they are a proxy, and report the residual bias. At least one security, ASPM.N0000, prints a close outside its own high-low range, so a high $\geq$ close $\geq$ low validation runs before anything is trusted. No bid, ask or depth is held, and none of D24's forty files contains any.

---

## 1. Where 29-09 and Week 4 differ, and how each is resolved

Five differences. None of them is a contradiction once the role of each instruction is separated from its content.

| # | [[29-09-2026]] | [[Week 4]] | Resolution | Closes |
|--:|---|---|---|---|
| 1 | D17 screen over the held OHLCV set; three labelled regimes across a ten-year envelope | 5 to 10 counters, small number of years | The screen runs over everything held, because it is what **selects** the 5 to 10 and because the surviving count is itself a reported result (K5). The experiment runs on the selection. One task, two outputs | |
| 2 | Four agents; $A_F$ on and off required by A6 | Do not start with four agents or the full LLM framework | Three live agents, $A_T$, $A_V$, $A_L$, all OHLCV-derived and cheap. $A_F$ emits the contract in state `no_data` and is built only if A3 passes early. Reported as stubbed, not omitted | Action 4 |
| 3 | $A_V$ and $A_L$ distinct; $V_t$, $P_t$, $L_t$ separate in the conditioning set | §2.3 insists the two constructs are distinct; §2.6 step 2 groups them into one agent | Separate from the start. Splitting them costs close to nothing once the bars are loaded, and the grouping in §2.6 reads as sequencing rather than design. This is the answer to the open question in [[Week 4]] §6 | Actions 3, 4 |
| 4 | Decision-level, friction-aware evaluation | Next-day direction, with unchanged prices clearly handled | Direction is the PoC **instrument**; friction-aware metrics sit on the same row, which [[PoC Specification]] Part 9 already commits to. The protocol states which claim each metric supports, which is also what §2.7 asks for | Actions 5, 8 |
| 5 | PoC-B on Sun 25 Oct; the spec pulls it ahead of the agent build | Not addressed | PoC-B does not fit in 36 hours alongside PoC-A. Cut from the gate, carried as pre-registered next work. See §6. Raise it rather than reorder silently, per [[PoC Specification]] Part 13 item 3 | |

**One point not to carry into the build.** [[Week 4]] §2.2 quotes back the claim that existing multi-agent frameworks use fixed weights and asks for it to be verified. That is the wording [[29-09-2026]] §3.1 directed retiring, in favour of the observation that many of the reviewed systems carry no explicit weighting quantity at all. Verify the current formulation, not the superseded one. This is matrix work rather than build work and it does not belong in these 36 hours.

---

## 2. The component list, frozen today

### In

| Component | Form |
|---|---|
| Data layer | As-of cursor, ticker-date spine, loader. Cursor violations raise |
| $A_T$ technical | Standard OHLCV features, simple predictor. Theil's $U2$ as the raw confidence |
| $A_V$ volatility | Parkinson on the daily bar. Rolling loss as the raw confidence |
| $A_L$ liquidity | Directional view off the §3 composite. Rolling loss ratio as the raw confidence |
| $A_F$ fundamental | Contract-emitting stub, state `no_data`. Built only if time remains after A3 |
| State vector | $L_t$ composite, $V_t$, $P_t$, $c_{i,t}$ |
| Orchestrator | Gated linear, softmax with abstention floor, hard zero on `unparseable`, $g(L_t)$ reliability coupling |
| Arms | $B_1$, $B_2$, $B_3$, $P$, $O$ off cached agent outputs |
| Ablations | $P-L_t$, $P-V_t$, $P-P_t$, $P-C_{i,t}$ |

### Out, with the reason

| Excluded | Reason |
|---|---|
| PoC-B, the persistence re-levering experiment | Does not fit in 36 hours alongside PoC-A. Sub-gap 2 stays a hypothesis, which is what [[29-09-2026]] §3.4 already calls it |
| Adaptive conformal wrapper on $A_V$ | The common accuracy-at-threshold transform in [[PoC Specification]] §5.3 covers all agents uniformly and is cheaper. `[CORRECTED 18 OCT]` The 1250-day calibration constraint was withdrawn today because the archive clears it on both tracks, so this cut rests on the 36 hours alone, not on a data limitation |
| Gate 0.2 tick-size classification | Blocked on bid/ask, which is not held. Record as blocked, not skipped |
| Cost inside the objective | Already out of the first pass in the spec. The orchestrator still exposes the proposed allocation so the door stays open |
| Everything in [[PoC Specification]] Part 1 "what is out" | Unchanged |

### Three live agents and acceptance check A6

The four state-input ablations all run with three live agents, so A6 is satisfied. The $A_F$ on and off ablation runs only in the degenerate sense that a stub contributes nothing either way. Report it as not run against a live $A_F$, with the reason, rather than reporting a zero delta as a finding.

---

## 3. Decisions to fix before the first run

[[PoC Specification]] Part 10 leaves these open. At 36 hours they cannot be discovered during the run. Proposed values, to be written into the pre-registration block today.

| Item | Proposed | Reasoning |
|---|---|---|
| Volatility estimator | **Parkinson** | Garman-Klass carries a $(\ln C/O)^2$ term, and on a thin counter the open is often a stale or auction-set price. Parkinson uses the high-low range only. Report the $\tau_t$ rate alongside so the degeneracy where open or close coincides with high or low stays visible |
| $P_t$ estimation | `[CORRECTED 18 OCT]` **Per counter above a minimum history, index fallback below it** | The original entry here routed $P_t$ to the index on the grounds that the per-counter archive was far shorter. That rested on the 374-day figure, which was the superseded Chindara archive. Per-counter history is median roughly 3,400 days, so $\hat{d}$ is estimable per counter for well-covered securities. Set a minimum, estimate per counter above it, fall back to the D15 index estimate below it, and report which counters used which. $\hat{d}$ instability remains a named risk |
| Abstention floor $\phi$ | **0.05 as the pre-registered primary**, sweep as a robustness strip if Sunday allows | A full sweep before a primary result is not affordable. What matters for attributability is that the value was fixed in advance |
| Unchanged-price handling | Exact zero close-to-close return is `unchanged`. Excluded from the directional metric, retained in the economic metric with the position held flat | On this market an unchanged close often means no trade or a single trade at the same price, so it is a liquidity observation rather than a forecasting failure. The exclusion rate per counter is the zero-return statistic from the D17 screen, so it does double duty |
| Abstained-day exposure | **Hold**, not flat | The flat option carries a round-trip cost each time, which contaminates the abstention economics the spec asks to measure |
| Counter selection rule | **Stratified across the liquidity cross-section**, roughly three high, three mid, three thin | Selecting the ten most liquid counters leaves $L_t$ with little variation, and A3 then has nothing to detect. The mechanism needs liquidity to vary both across counters and within each counter |
| Window | **Approximately Jan 2021 to Dec 2024** | Contains the 2022 crisis as the stress regime, quiet 2021 before it and recovery after. Sits inside the 2 to 5 year band in [[Week 4]] §2.5. `[CORRECTED 18 OCT]` Archive depth is no longer the constraint, since D22 runs 2012-01-02 to 2026-10-02, so the window is chosen on the coverage test and corporate-action cleanliness rather than on what data exists. That is a partial answer to the start-point question left unanswered in [[Week 4]] §6 |

**The binding window test is coverage, not span.** Per [[Week 4]] §2.5 the window must contain both normal and low-liquidity conditions. Apply it per counter as well as at index level: each selected counter must show both a high and a low stretch by its own $L_t$ over the window, or the adaptive mechanism has nothing to react to for that counter. This is a selection criterion, not only a window criterion.

**Survivorship.** Selecting counters present across the whole window introduces survivorship bias, and no listing or delisting register is held. Report it, do not carry it silently.

---

## 4. Build order, 18 to 25 October

The 17 October ordering the spec asks to protect still holds: the as-of cursor comes before any agent. Lookahead is the one thing in this project that cannot be retrofitted.

### Sun 18 Oct, 12h

| Hrs | Task | Output |
|--:|---|---|
| 3 | Data layer: as-of cursor, ticker-date schema, loader. Components receive queries, not dataframes. Cursor violation raises an exception. Bar validation on load: high $\geq$ close $\geq$ low, high $\geq$ open $\geq$ low. Drop the 17 rights instruments | Cursor violations raise. Validated spine |
| 1 | **Corporate-action jump detector**, per §0a. Ratio snapping against simple split ratios, no matching turnover behaviour. Runs before the screen | Flagged counter-days. Clean-counter list for the window |
| 2 | D17 per-counter screen over the held set: history length, % non-zero volume days, zero-return frequency recorded separately from non-trading, $\tau_t$ rate, median and mean volume, ADV, median turnover, Amihud, missing-day count. Volume, not price change, decides a zero-return day; the D15 exchange calendar separates non-trading from zero-volume | Per-counter table reported **by tier**, not reduced to one threshold |
| 2 | Apply the stratified selection rule, the per-counter coverage test and the clean-counter filter. Freeze the universe and the window. Write the §3 values and the §0a interim rule into the pre-registration block | Universe and window frozen |
| 2 | Gate 0.1: quantile AR(1) on $L_t$ over the index track | One sentence: the state-forecasting layer is justified or it is cut |
| 2 | Agent output contract in code. One stub agent emitting it. One ticker-date end to end | **A1** |

**If the day overruns, drop Gate 0.1.** It decides only whether the PoC can be made simpler, and the default without it is to condition on contemporaneous state, which is already the simpler option. The jump detector is not droppable: without it every return in the PoC is wrong on corporate-action days.

**Off the clock, today:** initiate the D24 Data Library purchase. Rs 1,500 at the student rate, which also buys items 06, 09, 16, 17, 21 and 29. It does not reach the 25 October gate and it is not meant to. It is what makes D26 possible afterwards.

### Tue 20 Oct, 2h
$A_T$ and $A_V$ emitting the contract over the selected counters.

### Wed 21 Oct, 2h
$A_L$, and the $L_t$ composite: sign every input so higher means worse, z-score, first principal component over an expanding window, re-normalise. $V_t$ from Parkinson. Run the full-sample PCA alongside the rolling one and keep both, which is direct evidence of the look-ahead a naive construction would have injected.

### Thu 22 Oct, 2h
$c_{i,t}$ calibration transform, rolling accuracy-at-threshold, applied uniformly to all agents. $P_t$ on the index track.

### Fri 23 Oct, 2h
Orchestrator: $s_{i,t} = \beta_i^\top x_t + \gamma_i c_{i,t}$, softmax with the $\phi$ floor, hard zero on `unparseable`, the $g(L_t)$ reliability coupling.

**Then, in the same session and before anything else, run the A3 sensitivity sweep.** Freeze one date, sweep $L_t$ over its observed range, record $\partial w / \partial L$. This is a change against the spec's ordering and it is deliberate: A3 is the check that matters, and running it on Friday leaves the weekend to respond if the weights turn out inert. Discovering it on Sunday night leaves nothing. **A2, A3**

### Sat 24 Oct, 4h
Five arms off cached agent outputs. Agents run once, arms consume the cache, which is the only way agent outputs stay byte-identical across arms. Add the normal against low-liquidity decomposition at this point rather than later, since it is what [[Week 4]] §2.6 step 6 asks the comparison to show. **A4, A5**

### Sun 25 Oct, 12h

| Hrs | Task |
|--:|---|
| 4 | Four ablations, one state input at a time. **A6** |
| 3 | Diagnostics: weight entropy $H_t$, pairwise agent error correlation, $A_V$ and $A_L$ collinearity, oracle gap, quiet against stressed decomposition |
| 1 | Stability sweep on the orchestrator's regularisation. Sweep and report, do not tune to the good value |
| 3 | Evidence capture: architecture diagram, one pipeline execution result, the baseline comparison table, one ablation result, the A3 sensitivity plot |
| 1 | Freeze PoC v1 |

---

## 5. What the PoC has to show, and what it does not

From [[29-09-2026]] §7.10, the sentence the whole build exists to make true:

> A small PoC shows changing liquidity actually changes the weights, the decision, or both.

From [[Week 4]] §2.6, the three things the panel asked it to demonstrate: that the individual agents can generate predictions, that the system can combine their outputs under fixed and adaptive weights, and that the two can be compared under a fair evaluation.

Those are the same requirement stated twice. A3 and A4 together are the evidence for both.

**Not required.** Profitability. Statistical significance. Full counter coverage. $A_F$ working. Hyperparameter tuning. A UI. Per [[29-09-2026]] §11.8 time spent on these reduces proposal quality rather than improving it.

**A null is an acceptable outcome**, provided the margin and the test were written down before the run. The forecast-combination literature's long-standing finding is that equal weights are hard to beat, and [[29-09-2026]] §8.3 says a modest or negative result does not damage the project when the hypothesis was justified and the test was honest.

---

## 6. What was cut, and what to say about it

| Cut | Status after the cut | What to write |
|---|---|---|
| PoC-B, persistence re-levering | Sub-gap 2 remains a hypothesis rather than a demonstrated contribution | This is already the position in [[29-09-2026]] §3.4. The PP presents it as a pre-registered experiment with the baseline identified and the environment chosen, which is more than most proposal-stage sub-gaps carry |
| Live $A_F$ | Three live agents, one contract-emitting stub | Report as stubbed with the reason. [[PoC Specification]] Part 12 already anticipates this |
| Adaptive conformal on $A_V$ | Common accuracy-at-threshold transform used throughout | Report the substitution and the reason, which is the 1250-day calibration window against a shorter archive |
| Gate 0.2 tick size | Blocked, not skipped | Blocked on bid/ask, which is not held |
| Per-counter $P_t$ | Market-level $P_t$ from the index track | State plainly that persistence is estimated at market level and that per-counter estimation was not attempted on these window lengths |

---

## 7. Carry to the supervisor

0. **The corporate-action problem and the interim rule in §0a.** This is the one that should be raised first. The PoC runs on a detect-and-exclude workaround rather than an adjusted series, and the supervisor should see that stated rather than discover it in the results. [[Research Gap]] now carries it as commitment zero in the evaluation section, because it is a precondition for every number below it.
1. **The PoC-B cut.** [[PoC Specification]] Part 13 item 3 already flags the ordering as a supervisor question. The cut is larger than the reorder and should not be made silently.
2. **Three agents rather than four, and $A_F$ stubbed.** This follows the panel directive in [[Week 4]] §2.6 and conflicts with the four-agent build in the 29 September Sunday 18 October task list. Confirm which takes precedence.
3. **The technical-contribution framing**, which [[Week 4]] §2.4 was explicitly offered as the panel member's own view and referred back to the supervisor. Outstanding action 9.
4. **The superseded fixed-weight wording** quoted back in [[Week 4]] §2.2, so the verification runs against the current formulation.
5. **Intraday data at any granularity**, independent of everything above. [[PoC Specification]] Part 13 item 6.

---

## 8. Week 4 outstanding actions this note addresses

| # | Action | Status after this note |
|--:|---|---|
| 3 | Separate definitions and requirement statements for the volatility and liquidity agents | §1 row 3 and §2 settle the build question. The written requirement statements are still owed |
| 4 | Reconcile the PoC specification with the prescribed sequence and record the differences | §1 |
| 5 | Define the PoC prediction target including unchanged prices | §3 |
| 6 | Select the PoC window by the coverage test and document the choice | §3 |
| 8 | State which claims accuracy supports and which need friction-aware metrics | §1 row 4. The protocol wording is still owed |

Actions 1, 2, 7, 9 and 10 are matrix, data-access or administrative work and sit outside these 36 hours.

---

**Related notes.** [[PoC Specification]] for what the PoC is and why each piece exists. [[29-09-2026]] for the schedule and gates. [[Week 4]] for the panel directives. [[Research Gap]] and [[Contribution to Knowledge]] for what the literature lacks and what this produces.

**Language discipline applies here too.** No "first", "nobody", "never". The permitted form is *"I have not found that evaluation in the literature I have covered."* The agent set and the conditioning set remain provisional.
