---
title: Pre-Implementation Research Closure
created: 2026-11-27
status: current
written_against: "Vault working docs to 2026-11-26; Claude outputs/FIXES.md and PoC_after_review.zip (commit f1898cc); fyp-dataset extracted/ outputs built 2026-11-23 (regression suite 20 of 20 PASS); 59 review notes; targeted literature currency check run 2026-11-27"
tags:
  - working-doc
  - reconciliation
---

# Pre-Implementation Research Closure, 27 November 2026

## 0. What this note is

A sweep of the vault and the dataset repository before the full implementation starts, to find what is still open on the research side, what has gone stale, and where two sources disagree. Filings and $A_F$ are out of scope for this pass, as asked.

**What was checked.** Every working document (Research Gap, Research Gap (Final Statement), Contribution to Knowledge, PoC Specification, PoC Build Plan, PoC Data Build, Dataset Reconciliation, the matrices status and audit notes, proposal notes 03 to 22), the two latest supervisor notes, FIXES.md and the PoC repository inside `PoC_after_review.zip`, the dataset README, DATA_CLEANING.md (DC-01 to DC-42), every build and validation log, the three matrices as workbooks, and all 59 review notes by search. Figures marked *recomputed* below were computed independently from the dataset outputs, not copied from a log.

**What was not checked.** No review note was re-checked against its source paper. The PoC `out/` folder is not in the archive, so PoC figures are quoted from `acceptance_L.txt` and FIXES.md rather than recomputed. The literature check in §3 is targeted, not a sweep.

**How to read it.** Section 1 is the list of decisions that have to be taken before the build, each with its evidence and a proposal. Nothing in Section 1 is decided by this note. Sections 2 to 6 are conflicts, factual corrections, data risks and housekeeping, which are less a matter of judgement.

---

## 1. Decisions to take before the build

### D1. The PoC result has been seen, so the full run needs a declared pre-registration v2

**Evidence.** The PoC ran all 16 folds (test span 2017-12-28 to 2026-06-30, *recomputed*) on 15 dev counters. The pre-registered rule failed on both halves: median per-fold delta $-0.286$ against a $B_1$ IQR of $0.683$; daily P&L difference HAC $p = 0.016$, bootstrap $p = 0.030$, per-fold $t$ $p = 0.048$, all with $P$ below $B_1$. Several design questions are now open because of that result (D3 to D5).

**The problem.** The full-universe run reuses the same 16 time windows. It is out of sample in the cross-section only, and CSE counters co-move, so the dev result is partly informative about the full result. Any change made after seeing the PoC and then tested on the full universe is a post-hoc change, whatever it is called. I have not found a pilot or confirmatory split defined anywhere in the vault.

**Proposed.** (a) Call the 15-counter run the pilot. (b) Define the confirmatory set as the 218 candidates not in the dev universe. (c) Freeze a "Pre-registration v2" block before any full run, listing every change from v1 with the reason and the date, and tagged post-pilot. (d) Always report the v1 specification of $P$ on the confirmatory set beside any amended $P$, so the amendment's effect is visible rather than absorbed. This keeps the attributability argument intact without pretending the pilot was not seen.

### D2. The margin half of the decision rule may be close to unattainable

**Evidence.** The rule needs $\mathrm{median}_k(\Delta_k) > \mathrm{IQR}(R_{B_1,k})$. On the PoC, $\mathrm{IQR}(R_{B_1,k}) = 0.683$ per fold, about 3.9 times $B_1$'s own mean net return per fold (0.175). Converted to the daily test series, $0.683 / 125 = 5.5 \times 10^{-3}$ per day, while the HAC standard error of the daily difference is $3.249 \times 10^{-3} / 2.421 = 1.34 \times 10^{-3}$. *Recomputed* from the acceptance report: the margin half needs an effect of roughly four HAC standard errors, where the significance half needs roughly two. This is approximate, because the rule uses the median and the test uses the mean.

**My reading.** $B_1$'s fold-to-fold IQR is mostly common market variation across six-month windows, and that variation is shared by both arms, so it is not the noise in a paired comparison. Comparing a paired difference against one arm's unpaired dispersion mixes the two. It also does not get easier with more counters: the effect and $B_1$'s IQR both scale with the cross-section. This is the "weighting helps and the test cannot see it" failure mode that Research Gap (Final Statement) asks to separate from the field's prior, and the supervisor raised the rule as High on 2 November.

**Options.** Keep it and report its power explicitly; scale the margin to the IQR of the paired differences $\{\Delta_k\}$ instead; or use a fixed economic margin. Any change goes into D1's v2 block as post-pilot. It would not change the pilot verdict, since $P$ is significantly below $B_1$.

### D3. The cost level is not grounded in the CSE fee schedule

**Evidence.** The vault commits to a cost sweep, and I have not found the levels fixed in any working document. The PoC chose 0, 25, 50 and 100 bps per unit of position change, with 50 bps primary, as an in-build choice. The CSE publishes a transaction cost of 1.12% for equity transactions up to Rs 100 million, with effect from 27 June 2017 (brokerage 0.640%, CSE 0.084%, CDS 0.024%, with SEC cess 0.072% and the 0.30% share transaction levy making up the rest per broker breakdowns), stepping down above Rs 100 million. So the PoC primary is about 45% of the statutory fee per side, before any spread or impact. The schedule has also changed inside the window: press reports describe a period after the levy was removed when the total was 0.82%, so a single number across 2012 to 2026 is not right either.

**Why it matters now.** The PoC's own reading is that the deficit is cost, not direction: $P$ beats $B_1$ at 0 bps (+23.98 against +22.32, summed, seed 0) and is the worst arm by 50 bps. At 100 bps every arm is negative. At a statutory 112 bps the comparison is mostly about turnover control. Separately, note 14 commits to equalising trade counts before comparing arms, and the PoC does not: $P$'s turnover is 42% higher than $B_1$'s.

**Proposed.** (a) A dated fee schedule from CSE sources as the statutory floor, with the pre-June-2017 schedule sourced before use. (b) Primary cost = statutory fee, with spread and impact proxies on top as the sweep. (c) Report the trade-count-equalised comparison that note 14 promised. (d) Decide whether C4, cost inside the decision objective (PoC Specification §6.5), is built for the main run. The pilot is the strongest argument for it so far, but building it after seeing the pilot is a v2 amendment and must be declared as one.

### D4. $L_t$: ratify the deviation, and settle EDGE's role

**Evidence.** Pre-registration (note 07 Part 4, Research Gap (Final Statement), Research Matrices Status) defines $L_t$ as the first principal component of Amihud, turnover ratio, zero-return frequency and the high-low range. The PoC deviated twice, and records both as deviations (FIXES fix 1): the high-low range was removed because, built as a 20-day Parkinson range, it correlated at 1.0 with $V_t$; and PC1 was replaced by the equal-weighted mean of signed expanding z-scores because 389 of 1,495 refits (26%) loaded a "higher means worse" input negatively and $L_t$ flipped sign. The PCA version is kept as `L_pca`.

**Result.** Removing $L_t$ from the orchestrator's regressors improves $P$ by +0.053 (and by +0.203 on `L_pca`). Removing the liquidity-to-reliability coupling on $A_T$ costs $-0.026$. My reading, scoped to 15 counters and one run: $L_t$ as a trust discount on the price-derived agent (SQ1's mechanism) helps slightly; $L_t$ as a general softmax regressor hurts. That split is worth reporting as it stands rather than averaging away.

**The EDGE conflict.** Research Gap (Final Statement), Contribution C4 and PoC Specification Part 1 demote EDGE to last resort and state a screening rule: do not adopt a measurement whose output cannot be checked on the market it is applied to. DATA_CLEANING DC-38 (6 November, later) adopts EDGE on the cleaned layer as the main spread run, with CHL where opens are missing. The PoC config then names EDGE or CHL as the replacement for the range input in $L_t$. These cannot all stand. Either spread series are descriptive outputs only, which keeps the screening rule, or they become model inputs and the rule is revised in writing.

**Proposed.** Ratify $L_t$ = equal-weight mean of signed z-scored {Amihud, turnover ratio, zero-return frequency}, `L_pca` as robustness, $\tau_t$ still a candidate. Keep EDGE and CHL as descriptive series under DC-38 and out of the state vector, which keeps C4's screening rule true.

### D5. Abstention is only exercised for one agent, and $\phi$ and the exposure policy are not open

**Evidence.** Coverage is 1.000 in every arm because only $A_T$ has an abstention rule. C3 (the abstention channel) is therefore untested except through $A_T$. And the one rule that exists removes the most accurate channel: $A_T$ abstains on about 53% of usable rows under $U2 \ge 1$, with a hit rate of 0.5345 on those rows, above $A_V$ (0.4992) and $A_L$ (0.5109) on all theirs. Routing that abstention correctly was the largest single movement in the result (FIXES fix 2).

**A conflict that resolves in the pre-registration's favour.** PoC Specification Part 10 (revised 1 November) says no value for $\phi$ exists anywhere in the vault, and the PoC config treats $\phi$ and the exposure policy as OPEN on that basis. That is not right: PoC Build Plan §3 (18 October) and note 07 Part 4 fix $\phi = 0.05$ as the pre-registered primary and the abstained-day exposure as **hold**, both before any run. The PoC's default $\phi$ was 0.05 anyway, so the pilot's primary result was run at the pre-registered value. The PoC README's "(knee at 0.02)" also disagrees with its own acceptance report, which places the knee at 0.150.

**Proposed.** (a) Record $\phi = 0.05$ and hold as the v1 values and correct Part 10. (b) Pre-register abstention rules for $A_V$ and $A_L$ in v2, for example conformal interval width above a threshold for $A_V$ and a loss ratio at or above 1 against its benchmark for $A_L$, so that C3 is tested at all. (c) Keep $U2 \ge 1$ in the v1 arm. If a changed $A_T$ rule is wanted, add it as a declared v2 arm rather than replacing v1.

### D6. The gap statement needs updating for post-cutoff work, and one claim conflicts with two review notes

**Post-cutoff literature.** The gap statement carries a 2026-03-09 cutoff and asks to be re-checked. A targeted check found one paper that sits close to the main claim:

- **Market Regime Council** (Pei, Ge, Zheng and Cartlidge, arXiv 2605.24490, 2026). *Paper's design:* three specialist LLM agents on separate information channels (price, on-chain, macro and sentiment), all on one Qwen3-VL backbone; per-period Shapley credit from realised coalition performance, mixed with a uniform prior; each agent's weight multiplied by a regime scalar interpolated from a continuous score $\xi_t = \tanh(r_{30d}/\sigma_{30d})$, with hand-set bull, neutral and bear anchors fixed before evaluation; one shared portfolio; equal weight as a baseline. *Evidence:* 13 crypto assets, 1,037 daily periods, 2023-03 to 2025-12; Sharpe 1.51 against equal weight's 1.14 at 0 bps, narrowing to 1.23 against 1.13 at 10 bps. *My reading:* this is a measured exogenous market-state variable continuously scaling the influence of channel-distinct agents over a single decision. The sentence "Nothing in the literature I have covered adapts an agent's influence ... as a function of measured conditions outside the agent" no longer holds for the literature as it now stands. What still separates this project, as clauses rather than as novelty: methodological heterogeneity (MRC's agents share one backbone, which is the PIXIU concern in reverse), a learned $f$ against hand-set anchors, a multi-variable conditioning set (liquidity, volatility level, persistence, structural confidence) against one price momentum-to-volatility score, structural confidence, and a cost-aware frontier-equity evaluation against a 0 bps crypto primary. It is also a second instance of an edge over equal weight shrinking as cost is charged, which is the pilot's pattern.
- **Near neighbours on the performance-reactive side**, read at abstract or summary level only: a hierarchical multi-agent system on CSI 300 (arXiv 2510.21147, October 2025, before the cutoff) that weights Fundamental, Technical, Report and News agents daily by PPO on agent-performance state only, with no market-state variable; and Agent4Crypto (arXiv 2611.12269) with a PPO gate over trader styles. These are published instances of the $B_3$ class, which strengthens $B_3$ as the arm that threatens the contribution.

**Conflict with review notes.** Research Gap (Final Statement), Sub-gap 1 claim 4 reads "No allocation system puts cost inside the objective. Every one deducts it afterwards." The Guo et al. review note records that the cost term enters the objective linearly, and the FreQuant note records fee-adjusted rewards. The notes win. What survives is narrower: in the reviewed set, cost enters objectives as a constant rate, and I have not found a state- or depth-dependent cost inside an allocation objective. Contribution C4 already says this; the gap statement contradicts it.

**Proposed.** Add MRC to Prior Work Contrast and to the main-gap table in Research Gap (Final Statement) and Contribution C1. Restate the main gap's "what is missing" sentence in clause form. Revisit the self-rated novelty of 4 / 5. Whether MRC gets a full review note is a scope question, given the 2 November decision not to expand the survey; a contrast entry is the minimum the gap statement needs. Move the cutoff to 2026-11-27 for the targeted check, stated as targeted.

### D7. Persistence: run PoC-B or formally descope C5

PoC-B, the four-ETF reproduction that would turn Sub-gap 2 from a hypothesis into a result, has not been run. It was cut from the 25 October gate (PoC Build Plan §6), and RQ3 was withdrawn on 24 October. In the pilot, removing $P_t$ moves $P$ by +0.0008, and the stability of $\hat d$ over rolling windows, a named risk, is not reported. Gate 0.1 (quantile AR(1) on $L_t$) was also never run; the Build Plan marks it droppable, with contemporaneous conditioning as the default. **Proposed:** either schedule PoC-B as a bounded task in the implementation plan, or move C5 to future work in Contribution to Knowledge, and record Gate 0.1 as dropped in either case.

### D8. Return basis: DC-41 supersedes five vault notes

DC-41 (6 November) makes price-only `adj_close` against the ASPI primary, with `tr_close` against ASTRI as robustness, and the PoC follows it. Notes 11, 12 (line 152), 14, 17 and `_Proposal Notes Index` (line 234) still say `tr_close` against ASTRI is primary. **Proposed:** record DC-41 as the decision in those notes, keeping their reasoning as superseded text.

---

## 2. Conflicts found, and which source wins

| Item | Source A | Source B | Resolution |
| --- | --- | --- | --- |
| Cost inside the objective | Research Gap (Final Statement) Sub-gap 1 claim 4: no allocation system does it | Guo et al. note (cost enters the objective linearly); FreQuant note (fee-adjusted rewards) | **Notes win.** Rescope, see D6 |
| Main gap, "nothing adapts influence to measured conditions" | Research Gap (Final Statement), cutoff 2026-03-09 | Market Regime Council, 2026 | Rescope to clauses, see D6 |
| $\phi$ and exposure policy | PoC Specification Part 10: no value exists | PoC Build Plan §3 and note 07 Part 4: 0.05 and hold | **Build Plan and 07 win** (earlier and explicit). See D5 |
| Volatility estimator | PoC Specification Part 10 and Part 13: to fix | Note 07 Part 4, Build Plan §3, PoC: Parkinson, frozen | Parkinson. Update Part 10 |
| $L_t$ inputs and construction | Note 07, Research Gap (Final Statement), Matrices Status: PC1 incl. high-low range | PoC fix 1: equal-weight z-mean, no range | Ratify the PoC version as a declared deviation, see D4 |
| EDGE | Research Gap (Final Statement), C4, PoC Spec Part 1: last resort, screening rule | DC-38: adopted as the main spread run; PoC config: candidate $L_t$ input | See D4 |
| Return basis | Notes 11, 12, 14, 17, Index: `tr_close` vs ASTRI | DC-41: `adj_close` vs ASPI | DC-41 (later, user decision) |
| Conformal depth constraint | Note 07 Part 4 table: "no longer constrained" | Same note, "What 1250 days costs the thin strata", and PoC Spec Part 10: depth threshold | Depth threshold, which is also what the PoC implements |
| Trade-count equalisation | Note 14: equalised before comparison | PoC: not equalised | Implement, see D3 |
| Data-build decision 8, volatility return construction | PoC Data Build §8: open | PoC fixes 6 and 11: traded-day returns, one forward-return definition | Record as decided |
| Data-build decisions 1 and 4 | PoC Data Build §8: not marked decided | DC-37 (closes admitted) and DC-38 (cleaned layer) | Mark decided |

---

## 3. Factual corrections

**Per-counter depth is span, not trading days.** The vault's "median roughly 3,400 days, 10th percentile 1,081" (notes 12, PoC Specification, PoC Build Plan) matches `window_aligned_days`, the calendar span on the trading calendar: median 3,442, p10 1,081 over the 355 core (*recomputed*). Days actually traded are lower: median 2,723, p10 900, with 71 core securities under 1,250 traded days. For the 233 candidates the figures are median 3,130 and p10 2,241 traded days, and **none** is under 1,250 by the window end. Two consequences: the "thin tail that cannot supply a conformal window" sits almost entirely outside the candidate set, so inside the experiment the depth threshold bites only as-of on early rows (which is how FIXES fix 4 now applies it); and the "contribution is about the thin end" framing has to be scoped to what the candidate screen keeps, which is counters trading on at least 60% of days.

**The 46 against 359 residual closes.** Dataset Reconciliation §6 left it open. The API scrape has 334 per-security files: 292 .N, 21 .X, 17 .R, 2 .P and 2 .U (*recomputed* from the directory). So 313 voting and non-voting securities are shared, and every one matches an official symbol. 46 of 359 equity securities (12.8%) are absent from the API; 44 of the 357 in-window (12.3%), the other two being HDEV and SUGA; 5 of those still trade in 2026. The D22 breakdown "283 .N, 21 .X, 2 .P, 17 .R" is wrong: 323 is the company count in `all_companies.json`, not the file count. The 46, 44 and 12.8% figures can be quoted again, each with its denominator.

**Contribution K5 still describes D22.** It quotes 323 securities and 829,070 observations. Since 24 October the panel is D27: 355 core, 233 candidates, 853,535 universe rows.

**Dataset Reconciliation §7, D17 profiling "not computed".** It is computed: `extracted/liquidity/strata.csv` and `extracted/profile/security_profile.csv`. Close the item.

**Free float has local measurement now.** Research Gap (Final Statement) infers thin float from an ownership study (institutional 66.1%, insider 5.7%). Item 17 gives it directly: median float 24.5% over 350 core securities, 51% under 25% (*recomputed*; DC-36). The measured figure is the stronger evidence.

**Test span.** First test day is 2017-12-28, not "roughly mid-2018" (*recomputed*; folds anchored at 2026-06-30). Easter 2019, COVID and the 2022 crisis are all inside test blocks, as intended.

**Forecast combination dead zone.** The review note computes the $O(T^{-1/4})$ zone as about 0.23 at 374 days. At the 1,250-day training window it is about 0.17, and at the candidates' median traded depth of 3,130 about 0.13. With three agents equal weight is 0.33, with four 0.25. The note's conclusion, that the comparison should move to the index track, no longer follows.

**PoC README.** The "L_t inputs" row in the frozen-decisions table still lists the high-low range, the knee is given as 0.02 against the report's 0.150, and `config.py`'s $L_t$ comment still describes PC1. Documentation only.

---

## 4. Dataset: what is solid, and what the build has to carry

**Solid.** The regression suite passes 20 of 20 at the current build. Calendar 17 of 17 years matching the official count; close agreement with the API 99.93% over 817,322 rows; 516 of 516 corporate-action events mapped; split jumps removed at every material ex-date; shares outstanding within 1% of item 16 on 96.4% of security-years. Universes reproduce: 359 equity, 355 core, 233 candidate, DOCK excluded.

**Risks the build has to handle**, counted over the 233 candidates inside the test span (*recomputed*):

- **146 corporate actions with approximate ex-dates** (101 scrip, 45 rights), plus 57 rights and 7 bonus issues with measured dates. The README advises dropping or flagging a few days around them; the PoC does neither. Single-day returns there are label noise for every agent.
- **Rights from 2022 are over-adjusted on thin counters.** The validation report shows the adjustment reducing the jump in only 18 of 37 material rights events from 2022, with the median absolute log return rising from 0.049 raw to 0.100 adjusted. These events are a subset of the above and should be masked rather than trusted.
- **192 adjusted close-to-close moves above 35%** in 55 candidates, 65 of them at prices above Rs 1. There is no jump flag or winsorisation in the PoC.
- **169 TradingView adjustment steps with no matching event**, in 17 securities. Possible missing corporate actions; worth a look at those 17 before they enter the confirmatory set.
- **Block transfers.** 93 traded days from 2012 have stripped turnover above 20% of shares outstanding. DC limitations say liquidity measures should winsorise them; $L_t$'s turnover input does not.
- **Tick-size break, January 2021.** DC-38 treats it as structural. The methodology lists two structural breaks (SLFRS 16 in 2019, the 2020 to 2023 price distortion) and not this one, though it affects the high-low range, $V_t$ on low-priced counters and any spread estimate.
- **Price-only returns put 1,425 dividend ex-dates into the labels** as mechanical negative moves. Small, around a third of a percent of test rows, and paired across arms, so low priority, but it should be stated.

---

## 5. Housekeeping

- **The 374-day figure is still in six review notes**, in their own-reading sections: Adaptive Conformal Inference (three places, including the step-size argument), Forecast combinations (four, including the dead-zone conclusion above), EDGE (two), Empirical Asset Pricing, Predicting Financial Market Stress, and the CSE quantitative-and-sentiment note. The match in the continuous-time execution note is a share count and is fine. The Literature Survey sheet carries 12 mirrored cells. Several are arguments rather than numbers, so this is a note revision, as Research Matrices Status already says.
- **Em dashes** remain in Research Matrices Status (50), the coherence audit (51), PoC Specification (38), Research Papers Grid (24), `_Corpus Index` (37, generated, so the source properties need it), two review notes (The Evolution of RL, 5; FinVision, 2) and one each in Dataset Profile, Data Library Profile and Data Cleaning Checklist. The three workbooks have none.
- **Absolutes.** "nobody designed and nobody analysed" appears in Research Gap (Final Statement) line 22 and Research Gap line 60. Sub-gap 1 claim 4 is covered in D6.
- **The coherence audit can be closed.** Its four actions were done on 18 October (Matrices Status). The four remaining "Not recorded in the note" cells in the survey sheet are bibliographic and accurate. The only live item is the 374 cells above.
- **Two gap documents both carry `status: current`.** Note 07 is written against Research Gap (Final Statement). Marking Research Gap.md as the working record would stop the two drifting.
- **PoC Specification Part 10** still shows the universe as "fixed but contested". Dataset Reconciliation settled it on 1 November.

---

## 6. Suggested order

1. Take D1 and D2 first. Every other amendment goes into the v2 block they create.
2. D5(a), D8 and the Section 2 table: corrections that do not need a decision.
3. D3, D4 and D5(b, c): the substantive design choices, recorded in v2 with dates.
4. D6: update the gap statement and contrast table before anything is written in the report.
5. D7: schedule or descope.
6. Section 4 masks and flags go into the data layer before the confirmatory run; Section 5 can run alongside the build.

The agent set and the conditioning set remain provisional throughout, and the pilot result does not change that.

---

**Sources outside the vault.**
- Pei, Ge, Zheng and Cartlidge, *Market Regime Council for Dynamic Credit Assignment in Multi-Agent LLM Decision Systems*, arXiv 2605.24490. https://arxiv.org/abs/2605.24490
- *Hierarchical AI Multi-Agent Fundamental Investing: Evidence from China's A-Share Market*, arXiv 2510.21147. https://arxiv.org/abs/2510.21147
- *Agent4Crypto*, arXiv 2611.12269. https://arxiv.org/abs/2611.12269
- Colombo Stock Exchange, Transaction Costs. https://www.cse.lk/pages/transaction-costs/transaction-costs.component.html
- EconomyNext, on the removal of the 0.3% share transaction levy and the 0.82% total. https://economynext.com/sri-lanka-share-trading-costs-still-high-volumes-low-3589/

**Related notes.** [[Research Gap (Final Statement)]], [[Contribution to Knowledge]], [[PoC Specification]], [[PoC Build Plan]], [[Dataset Reconciliation 2026-11-01]], [[07 Research Questions, Aim and Objectives]], [[14 Evaluation and Experimental Design]], [[02-11-2026]], `Claude outputs/FIXES.md`.
