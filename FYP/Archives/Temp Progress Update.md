# Progress Update — §9.2 Task Audit

**Against:** [[20-09-2026]] §9.2 Task Audit — Items Below the 4.5 Threshold
**Period:** Week 1, 21–27 September 2026 (27 h allocated)
**Status:** literature and gap foundation significantly improved; dataset foundation partially closed, one component outstanding

---

## 1. Movement against the audit

| Task                                |       20 Sep |       Now | What moved it                                                                                                                                       |
| ----------------------------------- | -----------: | --------: | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Historical CSE data depth**       |       🔴 1.5 |   **4.0** | OHLCV extracted for **270 companies over 10 years**. No longer a blocker — see §4                                                                   |
| Recent CSE literature completeness  |          2.0 |   **4.5** | Literature base expanded to **53 reviewed papers**, including the missing 2025–2026 CSE and agent work                                              |
| Remaining absolute novelty language |          3.5 |   **4.5** | Swept across all literature reviews and both matrices — see §3                                                                                      |
| Volatility dataset availability     |          3.5 |   **4.5** | Index track confirmed (10 y daily, 1 Jul 2014 – 30 Jun 2024); per-counter now covered by the same extraction                                        |
| Scientific CSE framing              |          2.5 |   **4.0** | Three overstated claims withdrawn and replaced with narrower, evidenced ones — see §3                                                               |
| Integrated dataset schema           |          2.0 |   **3.5** | Dataset matrix expanded 21 → 28 sources with required fields, licence and agent mapping per source. Final ticker-date schema still to be frozen     |
| Evaluation methodology              |          4.0 |   **4.5** | Conditioning set fixed, ablation design specified — see §2                                                                                          |
| **Liquidity data availability**     |          3.5 | **2.5 ↓** | *Revised down deliberately.* Confirming what's needed showed the required fields are **not** in what I hold. This is now the critical path — see §5 |
| Final main gap wording              | Almost ready | **Ready** | Research Gap note rewritten against all 53 reviews                                                                                                  |
| Exact technical contribution        | Almost ready | **Ready** | Stated as a single claim with every clause load-bearing — see §2                                                                                    |

**Unchanged and still outstanding:** Research questions (1.0), Aim and objectives (1.0), Final pipeline (2.0), Explicit Task–Domain–Constraint definition (3.0), Requirement Elicitation (unrated). These are Week 2 work and are not blocked by anything.

> One rating went **down**, and that's the honest result of the week. "Liquidity data availability 3.5" assumed the variables were obtainable. Checking properly showed they aren't in what I have. Better to find that now than in Week 4.

---

## 2. Literature expansion and the consolidated matrix

**53 papers reviewed** and consolidated into `Matrices/Consolidated Research Matrix.xlsx`, now five sheets: Literature Survey (53 × 24), Research Gap Analysis, Conditioning Set, Reclassified Components, Dataset (28 × 23).

### What the expansion changed about the gap

**The main gap got stronger by getting more precise.** The previous wording was that the agent-combination rule is *fixed at design time*. That understates it. In TradingAgents, FinVision and Park's system there is **no weight vector at all** — combination happens through a facilitator prompt, a concatenated prompt, and a free-text summary respectively. There is no quantity that could be made time-varying. Three unrelated designs landing on the same non-mechanism is evidence about the field rather than about three papers, and the ACM CSUR review of 167 RL papers states the same thing directly: coordination protocols among agents are underexplored.

**The defence is now five systems wide, not one.** Naming only MacroHFT was too narrow:

| System | Closest on | Why it doesn't close the gap |
|---|---|---|
| HedgeAgents | the mechanism itself — a solved constrained optimisation over an explicit weight vector | weights are over **assets**, not agents (1:1 mapping). Never asks which *method* to trust |
| MacroHFT | continuous state conditioning | six **identical** DDQNs on one stream — conditioning without heterogeneity |
| Jung & Lee | a genuinely heterogeneous agent pool | a fixed prompt template sits exactly where weighting should be; degrades 10.36 points and cannot notice |
| TRIAG | orchestrator as learned coordinator | state vector has **no environment block**; carries a confidence field and never computes with it |
| Automate Strategy Finding | — | **demoted to Baseline 2.** Does selection, not weighting; its weights carry no time index |

**Surviving claim:** continuously vary the influence weight of *methodologically heterogeneous* agents, over a *single shared decision*, as a function of *measured exogenous market state*.

### The conditioning set — identified and fixed

This was the missing scaffolding. The weighting function w(i,t) = f(L_t, V_t, P_t, C_{i,t}) previously had no specification of which state variables or why. All terms now resolved against the literature:

| Term | Decision | Basis |
|---|---|---|
| **L_t** liquidity | **Keep** | Granger causality on CSE runs volume → ASPI at p = 0.0041 |
| **V_t** volatility | **Keep**, estimator pinned | Parkinson / Garman-Klass. 5-minute realised volatility is unavailable on this market |
| **P_t** persistence | **Keep** | Three CSE papers detect clustering (ARCH statistic 86.55 on ASPI) and address it only with robust standard errors |
| **C_{i,t}** confidence | **Redefined** | Not a self-report — a *structural* property of the output. For A_F: does the extracted program parse, does every argument trace to a retrieved figure, step count |
| **Abstention channel** | **Added** | The one structural addition. A_F is expected unusable >50% of the time, so the orchestrator must be built for a frequently-absent channel |
| **Macro block** | **Rejected** | ARDL gives adjusted R² = 0.189 across five macro variables over a decade, with Granger nulls for money supply and inflation. Not worth an agent |

Pairwise conflict score and distribution-shift detection are recorded as **pre-registered tests**, not adopted components. The four-agent pool $(A_T, A_F, A_V, A_L)$ is confirmed unchanged — not one of the 53 notes proposes adding or removing an agent.

**Evaluation design follows directly:** Baseline 1 equal weight → Baseline 2 static learned weight → proposed dynamic state-aware, then each state input ablated individually so its contribution is attributable.

---

## 3. Scientific framing — claims withdrawn

Three claims were too strong for the evidence and have been narrowed in both the Research Gap note and the matrices. All are marked in-place so the change is visible rather than silent.

| Claim | Status | What replaced it |
|---|---|---|
| "No system models transaction cost as a function of order size against depth" | **Withdrawn** | Chen et al. (ICAIF '22) and Wang, Gao & Li (Finance and Stochastics, 2026) both do. What survives: no nonlinear impact form, no participation-rate sweep, no thin-book calibration, and **no system puts cost inside the objective** rather than deducting after. Sub-gap 1 novelty revised **3.5–4 → 3** |
| "Volatility is not operationalised in agent systems" | **Withdrawn** | *Deep Learning for Portfolio Optimization* operationalises volatility **level** daily via a target-volatility scaler, and that non-learned scaler does most of the risk work (Sharpe 0.929 → 1.526). What survives is the **persistence** half, now aimed at a named component: an EWMA half-life assumes exponential decay, which is what the CSE long-memory results contradict. Rating holds 3.5 |
| "Weights are fixed at design time" | **Replaced, stronger** | Most systems have no quantity that could be weighted at all (§2) |

**Supervisor's cited 2026 market-impact paper: verified and correct.** Wang, Gao & Li implement Almgren–Chriss in closed form. That open item closes in the supervisor's favour and the sub-gap has been narrowed accordingly rather than defended.

**"Nobody / never / first" language** removed from all literature reviews and both matrices, replaced throughout with the permitted form: *"I have not found that evaluation in the literature I have covered."*

**Sentiment** remains out of scope per the 20 September decision. Sentiment sources are now marked `EXCLUDED FROM SCOPE` in the dataset matrix rather than deleted, so the record shows they were evaluated. Sentiment *papers* are retained in the literature survey under the granted exception.

---

## 4. Dataset — what is now secured

**OHLCV extracted for 270 companies across the past 10 years.** This is the item that was rated 1.5 and flagged as the critical blocker. It is no longer that.

| Field | Status |
|---|---|
| Date | ✅ Held |
| Ticker | ✅ Held, 270 counters |
| OHLC | ✅ Held, 10 y |
| Volume | ✅ Held, 10 y |
| Turnover / trading value | ❌ **Not held** |
| Number of trades | ❌ **Not held** |
| Bid / ask | ❌ **Not held** |
| Market capitalisation | ❌ **Not held** |

The index track was independently secure in any case — ASPI daily, 1 July 2014 – 30 June 2024, ~2,400 observations, spanning the Easter attacks, COVID and the 2022 crisis as three labelled regimes.

**Caveat to profile before quoting the number.** 270 counters × 10 years is the *envelope*, not the realised coverage — many counters listed partway through the window, and some will have long non-trading stretches. The per-counter profiling job (trading-day frequency, median turnover, zero-return frequency separated from non-trading, Amihud) is queued and needs no new data. **That screen, not the year count, is what actually sizes the experiment**, and it also produces the first empirical fit of L_t.

---

## 5. Dataset — what is still missing, and the two routes

**Current main task.** The remaining fields are not cosmetic. They are what three of the four components are built on:

- **Turnover and number of trades** → A_L, the Amihud illiquidity measure, and L_t. Without them, liquidity state is proxied by volume alone, which is materially weaker
- **Bid / ask** → the execution-friction model in Sub-gap 1, and the tick-size classification that decides whether the microstructural route is open at all
- **Market capitalisation** → the size tiering that the CSE literature says matters (illiquidity shocks hit small caps at −0.071 vs −0.060 for large)

Two routes, and they are **not mutually exclusive**:

### Route A — MyCSE Platinum subscription
Reported to provide all available historical data. Fast, self-service, no dependency on anyone else's response time.

> **Two things to confirm before paying.** (1) Whether it includes **historical** bid/ask depth or only live depth — subscriptions commonly give real-time order book but historical OHLCV only. (2) Whether the terms permit **academic use and publication of derived results**. A dataset I can't describe in the thesis is not usable.

### Route B — Formal data request to the CSE
Slower and uncertain, but free, unambiguous on permissions, and it can ask for things no subscription tier carries.

**One consolidated request, not several.** A_L and the evaluation layer are gated on identical data, so they go in one letter, which should also ask for:

- the **listing and delisting register with effective dates** — without it the universe is survivorship-biased in the direction that flatters returns, and the counters that delisted through the 2022 crisis are disproportionately the thin ones this research is about
- any **level-III or multi-level depth** data, even if the answer is no, so the microstructure question is closed on the record rather than by assumption

**Recommended: run both in parallel.** Send the letter first because it costs nothing and its lead time is the binding constraint; evaluate the subscription against the two confirmations above while waiting. If the subscription turns out to carry historical turnover and depth under acceptable terms, it resolves the critical path immediately and the letter becomes the fallback plus the delisting register, which no subscription tier is likely to carry anyway.

---

## 6. What this leaves for Week 2 (28 Sep – 4 Oct)

1. **Send the CSE data request letter** — highest priority, longest lead time, zero cost
2. **Verify the MyCSE Platinum contents and terms** against the two questions in §5
3. Run the per-counter liquidity profiling on the data already held (§4) — no external dependency
4. Write formal **research questions, aim and objectives** — both still at 1.0 and both unblocked
5. Freeze the **final ticker-date dataset schema**
6. Run the Sub-gap 2 persistence test on the source paper's own four-ETF setup — it validates the component **without any CSE data**, which takes that sub-gap off the critical path entirely

---

## 7. Open items carried forward

- Prior Work Contrast sheet exists only in `Refined Research Gap Analysis Matrix v5.xlsx`, not yet in the consolidated workbook
- Bibliographic gaps: P26 venue, P30 year and venue, P44 year
- `Smart Trading Rule` review note is an empty file and likely bears on Sub-gap 1
- Requirement Elicitation still has no rating and no slot in the schedule
