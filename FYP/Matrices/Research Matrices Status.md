---
tags:
  - status
status: current
date: 2026-10-11
---
# Research Matrices — status

> [!note] Provenance
> Rescued from the Claude project on 18 October 2026, where it was the only copy. Two dated sections: the 11 October 2026 update on top, the 27 September 2026 status beneath it.

## 11 Oct 2026 update — Literature Survey Matrix v6

Count unchanged at **59 papers, all reviewed**. Nothing added, nothing removed. v6 changes what one row is allowed to be used for, and fixes a column fault.

**1. P54 (EDGE, Ardia, Guidotti & Kroencke 2024, JFE) demoted to last resort, and may never be used at all.** The stated reason is that it is **unvalidated on thin and frontier markets**: the paper's empirical work is CRSP–TAQ US equities plus a Binance crypto section with no quote benchmark at all, and its own numbers put the estimator at its weakest exactly where the CSE sits — 25.63% of daily-price estimates non-positive, 41% of large-cap stock-months negative before truncation, thinnest simulated panel ~4 expected trades/day with no-trade days forward-filled. A monthly window on the per-counter archive gives ~21 observations, squarely inside that regime. On a market with no quote data, the estimate could not be falsified even in principle.

The row is kept in full, marked amber, with the superseded v5 text retained as the record of the evaluation (same convention as the Dataset sheet's excluded rows). What survives: the infrequent-trading bias result (CS returns exactly zero below ~13 trades/day, AR biased down ~⅓) as citable external evidence that thin-book calibration is real, and the frequency result (a month of minute prices beats a year of daily prices) as a reason to ask about any intraday CSE feed. Withdrawn: EDGE as the cost model's measurement half, the two candidate L_t inputs (measured spread, τ_t staleness), and the quarterly/monthly window decision.

**Consequence for Sub-gap 1 — now two caveats, not one.** v5's answer to the missing CSE quote data was the EDGE proxy route, which made the measurement half of Sub-gap 1 look closed. It is open again. Sub-gap 1 now rests on proxies for illiquidity rather than on any measurement of what a trade pays. The CSE request for bid/ask and depth is no longer a validation step for an estimator already built — **it is the only route to a measured spread**, and should be pressed accordingly.

**2. Column alignment fixed in the standalone matrix.** P54–P60 had `Speaks To / Effect on the Gaps` and `My Note` transposed; P01–P52 were correct. Anything that read either column on those seven rows read the wrong field. Note that the two workbooks use **opposite column orders** — standalone has W = Speaks To / X = My Note, consolidated has W = My Note / X = Speaks To — each correctly declared in its own header row. The consolidated workbook was already internally consistent and needed no swap.

**3. Diebold & Inoue, *Long memory and regime switching* — dropped.** v5's "Still outstanding" carried it as the one obtainable paper left to review and enter. It is no longer planned for entry; the review note has been deleted and the outstanding item cleared. It has no row, no grid entry and no vault note, and nothing in either matrix references it.

**4. Autofilter range** was stale at A1:X54 (silently excluding P55–P60) and is now A1:X60. **Colour key** corrected — the v5 key did not describe the sheet it was attached to.

### Propagation — complete as of 11 Oct 2026

All amended rows are marked amber.

- **Vault note — `Literature Reviews/Efficient estimation of bid–ask spreads from open, high, low, and close prices.md`.** Opens with a dated `[!DANGER]` decision block. The opening paragraph that made the case for adopting it is kept and annotated rather than rewritten. A lead-in to Limitations explains why the frontier-validation gap outranks the other four: the market it would be applied to is also the market that cannot supply the data to check it, so the weakness and the remedy are foreclosed together. *Why this matters for my project* is rewritten around three survivals, three withdrawals and one revival condition, with the 4 Oct six-bullet reading kept beneath it under **Superseded**. Frontmatter carries `decision: last resort — may never be used`.
- **Research Papers Grid #61 — deliberately NOT edited.** The decision lives in the note the grid entry links to, which keeps one source of truth rather than two.
- **Dataset sheet D23** (Consolidated workbook) — Suitability 4 → **1**, Decision now "LAST RESORT - DO NOT COMPUTE AS A COMPONENT. May never be computed at all." *Which Agent It Feeds* is now NONE (A_L and the evaluation layer run on the proxies). *Verification Status* records that the method is peer-reviewed but **not verifiable on this market**. The revival condition is written into the justification, and the superseded justification is retained beneath it.
- **Sub-gap 1** — amended in **both** the Consolidated workbook's Research Gap Analysis sheet and the standalone *Refined Research Gap Analysis Matrix v5*. Both caveats now sit in *Risk & Failure Mode* and are flagged in *Decision*; *Required Data* records that the bottom rung of the data ladder has no spread measurement on it. v5's Read Me carries a dated amendment note.
- **Conditioning Set L_t** — no change needed. It already named the high–low range proxy as "the survivor if bid-ask data never arrives" and never leaned on EDGE.

**What is left is a decision, not bookkeeping.** Sub-gap 1 is now defended on proxies rather than on a measured spread. The CSE request for bid/ask and depth is the only route to closing that, so it should be the priority item in that letter rather than one line among several.

---

# Earlier status (27 Sep 2026)

Files in `Obsidian Vault/FYP/Matrices/`:

- **Consolidated Research Matrix.xlsx** — 5 sheets, all now current: Literature Survey (53×24), Research Gap Analysis (v5), Conditioning Set, Reclassified Components, **Dataset (28×23, updated 27 Sep)**
- **Refined Research Gap Analysis Matrix v5.xlsx** — 6 sheets. Two new: **Conditioning Set**, **Prior Work Contrast** (replaces MacroHFT Positioning)
- **Literature Survey Matrix.xlsx** — 53 papers × 24 cols, new **Speaks To / Effect on the Gaps** column
- Dataset Comparison Matrix.xlsx — standalone file, **still the old 21-row version**; the consolidated workbook's Dataset sheet supersedes it

Sentiment out of scope throughout (supervisor, 20 Sep 2026, Final). Sentiment papers retained in the survey matrix under the granted exception.

## Dataset sheet — 27 Sep revision

**Removal checklist item 6 is now done on the consolidated workbook.** Seven rows marked EXCLUDED FROM SCOPE and greyed, kept as a record that they were evaluated rather than deleted: D12–D14 (Sinhala sentiment corpora), D15–D17 (Daily FT, EconomyNext, Daily Mirror Business), D19 (Sri Lanka Equity Forum). D18 survives as a **disclosure feed**, not a text signal — it is how the D07 report PDFs are discovered and it carries the announcement timestamp that makes point-in-time retrieval possible.

Column R rewritten throughout to the A_T / A_F / A_V / A_L vocabulary. Stale cross-references fixed: D07 "G4", D08 "G1", D09 and D11 "check D13 first" (D13 renumbered to a Sinhala corpus in the 21-row version).

Seven rows added:

| ID | Row | Decision |
|---|---|---|
| D22 | ASPI ten-year daily series, 1 Jul 2014 – 30 Jun 2024, ~2,400 obs | **USE — the confirmed index track** |
| D23 | Listing/delisting register with effective dates | **REQUIRED, NOT OBTAINED** |
| D24 | Counter liquidity screen and tier table (derived from D20) | **COMPUTE NEXT** |
| D25 | Moratuwa CSE Graph-RAG corpus + code | USE as prior art; **contact the authors** |
| D26 | FinQA (CDLA-Permissive) | A_F development only |
| D27 | ConvFinQA + TAT-QA (**TAT-QA non-commercial**) | Taxonomy and probe design |
| D28 | Level-III / LOB message data | Evaluate via the tick-size test first |

*(Note: the Dataset sheet has since been renumbered — the current D22 is the per-security CSE OHLCV extraction and D23 is the EDGE-derived spread estimate, now demoted.)*

**D20 changes the per-counter picture and open item 1 should be restated.** The Chindara archive is **2025-04-10 to 2026-09-18 — 374 trading days, 112,722 records**, verified by parsing the committed CSV. That is ~300 counters, not the ~200 × ~240 days the earlier note assumed. At L=30 it gives roughly 345 windows per counter and **~100,000 sequences**, materially above the 40–50k working figure. D21 (own TradingView scraper, `alt_scraper.py` run from 2021-01-01) may extend this further per symbol, pending a ToU resolution.

## What the 53 reviews changed

**Main gap — stronger, defence wider.** Reformulated from "weights are fixed at design time" to **"most existing systems have no quantity that could be weighted."** Stated three times across three unrelated designs (TradingAgents' one-sentence facilitator, FinVision's concatenated prompt, Park's free-text summary), so it's a property of the field. External validation: ACM CSUR review of 167 RL papers states coordination protocols among agents are underexplored.

**The single-MacroHFT defence no longer holds.** Five-way contrast now:

| System | Nearest on | Defeated by |
|---|---|---|
| **HedgeAgents** | orchestration mechanism — a *solved* constrained optimisation over an explicit weight vector | weights over **assets** not agents (1:1 mapping), threshold hand-set and never revisited |
| MacroHFT | continuous state conditioning | homogeneity — six identical DDQNs on one stream |
| Jung & Lee | heterogeneous pool (technical/on-chain/macro/social/news) | fixed prompt template where weighting should be |
| TRIAG | orchestrator as learned coordinator | state vector has **no environment block**; confidence field never computed with |
| Automate Strategy Finding | — | **demoted to Baseline 2.** BlackRock survey nominates it as the field's adaptive gating mechanism; the primary paper does selection, not weighting, and its weights carry no time index |

Surviving claim: *continuously vary the influence weight of methodologically heterogeneous agents, over a single shared decision, as a function of measured exogenous market state.* Every clause load-bearing.

**Sub-gap 1 — narrowed, novelty 3.5–4 → 3.** Generic claim withdrawn: Chen et al. (ICAIF '22) queue-reactive LOB simulator quantifies ignoring impact at 3.04 bps; Wang, Gao & Li (Finance and Stochastics 2026) implement Almgren-Chriss in closed form. **That second paper is the supervisor's cited 2026 market-impact work — open item 2 closed, they were right.** Surviving: no nonlinear impact form anywhere, no participation-rate sweep anywhere, no thin-book calibration anywhere, and no allocation system embedding cost *inside* the objective rather than deducting after. *(See the 11 Oct update above — the measurement half is open again and the sub-gap now carries two caveats.)*

**Sub-gap 2 — sharpened, rating holds 3.5.** Broad claim withdrawn: Deep Learning for Portfolio Optimization operationalises volatility *level* daily via a target-volatility scaler, and that non-learned scaler does most of the risk work (Sharpe 0.929→1.526). What survives is the **persistence** half, now aimed at that named component: an EWMA half-life assumes exponential decay, exactly what the CSE long-memory result contradicts. **Testable on the source paper's own four-ETF setup before any CSE data** — takes the blocker off this component's path. Run it first.

## Conditioning set — resolved

| Term | Status |
|---|---|
| L_t liquidity | **KEEP**, strengthened. Granger on CSE: volume → ASPI at p=0.0041. Three jobs from one measurement. Runs on Amihud, turnover, zero-return frequency and the high–low range — no EDGE component |
| V_t volatility | **KEEP**, specify estimator (Parkinson/Garman-Klass — 5-min RV unavailable), pin window |
| P_t persistence | **KEEP**, now locally evidenced. Three CSE papers detect clustering and discard it (ARCH stat 86.55 on ASPI, addressed only with robust SEs) |
| C_i,t confidence | **REDEFINED** — structural property of the output, not a self-report. Four notes converge |
| Abstention channel | **ADD** — the one structural addition. A_F expected unusable >50% of the time |
| Pairwise conflict score | Pre-registered test, not adopted |
| Macro block | **REJECTED** — ARDL adj R²=0.189 on five macro vars over a decade; Granger nulls for money supply and inflation |

Four-agent pool **confirmed unchanged** — no note in 53 proposes adding or removing an agent.

## Open items

**Closed:** CSE Neo4j Graph-RAG verified (Shamila, Silva & Talagala, ERU 2025, DOI 10.31705/ERU.2025.35, Moratuwa — same dept, reachable, public repo, best lead on data access). Almgren-Chriss citation verified. Confidence mechanism now specified. Sentiment sources cleared from the Dataset sheet. EDGE propagation complete (11 Oct).

**Open:**
1. **Per-counter CSE data** — restated 27 Sep. Index track secure. Per-counter archive is **374 days × ~300 counters ≈ 100k sequences at L=30**, better than previously assumed. The binding question is now *how many counters clear a liquidity screen*.
2. **Listing/delisting register** — hard blocker. Without it the universe is survivorship-biased in the direction that flatters returns. Ask by name; if refused, state the bias and its direction.
3. Minimum estimation window for persistence + turbulence indicator — resolve together in one experiment.
4. CSE R&D letter — **one consolidated request**: per-counter history, delisting register, and the microstructure feature list. **Raised to the top item on 11 Oct: bid/ask and depth are now the only route to a measured spread, not a validation extra.**
5. Put the narrowed CSE justification to the supervisor (my reading, not theirs), together with the two Sub-gap 1 caveats.
6. **Run the three blocker-independent experiments now:** the liquidity screen, the cost-parameter sweep on Guo et al.'s own datasets, and tick-size classification on CSE counters from top-of-book alone. The last is decisive and nearly free.
7. Re-check the gap statement before submission (Agentic Trading snapshot closed 2026-03-09).
8. **Prior Work Contrast sheet** still lives only in v5, not in the consolidated workbook.

## Corrections

- **84.4% page-retrieval must not be quoted on its own.** Aggregation that never ran end-to-end, beats its comparator by one question out of 141. Citable: 53.19% vs 48.23% manual, not clearing a 95% interval. P07 now reports it with the debunking attached.
- P31 quotes "the experiment nobody in this line of work has run" from the vault note — unscoped absolute, needs the permitted form if it migrates into the proposal. *(Swept in v5 — the instance sat in P30, not P31.)*
- Bibliographic gaps: P26 venue, P30 year+venue, P44 year (EJOR 270(2) → recoverable).
- P53 Smart Trading Rule — removed in v5; paywalled and unobtainable. The ID stays vacant deliberately.
