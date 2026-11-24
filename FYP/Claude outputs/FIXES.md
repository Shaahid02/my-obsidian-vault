# FIXES: the code review of 2026-11-23 and what each defect carried

The review before the full-universe run found defects across the data layer, the state
vector, the agents, the orchestrator, the baselines and the tests. They were fixed one at a
time in priority order, and the arms were re-run after each, so that the movement in the
result can be attributed to a specific defect rather than to the batch. Each fix is its own
commit, and every behavioural fix carries a regression test that fails on the code before it.

## How to read the progression

Quick mode: one seed, no sweeps, 15 dev counters, 16 folds, 50 bps. Each row is
cumulative: it includes every fix above it. Figures are net return, mean per fold.
`d P-L` is the gain from removing L_t from the orchestrator's state vector (positive means
P is better without it). `A3` is the largest weight swing as L_t is swept. `HAC p` is the
paired test of P against B1.

| step | B1 | B2 | B3 | P | O | d P-L | A3 | HAC p | rule |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 baseline | -0.0243 | +0.0368 | +0.0519 | -0.0098 | -0.0000 | +0.0482 | 0.047 | 0.873 | FAIL |
| 1 L_t composition | -0.0723 | +0.0312 | -0.0108 | -0.0152 | -0.0184 | +0.0502 | 0.080 | 0.610 | FAIL |
| 2 abstention routing | -0.0723 | -0.1835 | -0.0739 | -0.3450 | -0.1669 | +0.1119 | 0.480 | 0.016 | FAIL |
| 3 A_V GARCH arithmetic | -0.0567 | -0.1735 | -0.0555 | -0.3367 | -0.1539 | +0.1125 | 0.482 | 0.013 | FAIL |
| 4 as-of depth rules | -0.0567 | -0.1744 | -0.0556 | -0.3362 | -0.1545 | +0.1122 | 0.483 | 0.014 | FAIL |
| 5 B3 per ticker | -0.0567 | -0.1744 | -0.1118 | -0.3362 | -0.1545 | +0.1122 | 0.483 | 0.014 | FAIL |
| 6 one forward return | +0.0347 | -0.0618 | -0.0199 | -0.2586 | -0.0942 | +0.1457 | 0.423 | 0.011 | FAIL |
| 7a scales on voting rows | +0.0347 | -0.0497 | -0.0193 | -0.2559 | -0.0926 | +0.1556 | 0.420 | 0.012 | FAIL |
| 7b positions from the vote | +0.2335 | +0.0900 | +0.1251 | -0.1321 | +0.1007 | +0.1759 | 0.420 | 0.022 | FAIL |
| 8+9 A4, confidence fill | +0.2335 | +0.0900 | +0.1251 | -0.1322 | +0.1006 | +0.1759 | 0.420 | 0.022 | FAIL |
| 10 tests on daily P&L | +0.2335 | +0.0900 | +0.1251 | -0.1322 | +0.1006 | +0.1759 | 0.420 | 0.033 | FAIL |
| 11 V_t and P_t measurement | +0.2491 | +0.1114 | +0.1407 | -0.0826 | +0.0928 | +0.1522 | 0.441 | 0.062 | FAIL |
| 12 A_T standardised ridge | +0.1752 | -0.1199 | +0.0921 | -0.2312 | -0.1084 | +0.0529 | 0.542 | 0.016 | FAIL |
| 13 housekeeping | +0.1752 | -0.1199 | +0.0921 | -0.2307 | -0.1087 | +0.0527 | 0.542 | 0.016 | FAIL |

The HAC p-values before step 10 were computed on panel rows and are not comparable with
those after it; see fix 10.

## Which defects carried the result

Three fixes moved P by more than 0.05, and they did so for different reasons.

- **Fix 2 (abstention routing), P -0.015 to -0.345.** The largest single movement. Before
  it, an abstaining agent was weighted as if it were in state ok. Routing abstention as
  the specification requires moved weight off A_T on about half its rows. The reading I
  take from the evidence: A_T is still the most accurate agent on the rows where it
  abstains (current panel: hit 0.5345 on A_T's abstained rows, against 0.4992 for A_V
  and 0.5109 for A_L over all their rows), so the pre-registered criterion U2 >= 1
  removes the strongest channel from the vote. The criterion is pre-registered and has
  not been changed; this is recorded as a finding about it.
- **Fix 7b (positions from the vote), B1 +0.035 to +0.234, P -0.256 to -0.132.** The
  weights were learned against conviction-rescaled signals but applied to raw ones. This
  is a design decision rather than a reading of the specification, and it changes
  position sizing for every arm, which is why every arm moved.
- **Fix 12 (A_T ridge standardisation), P -0.083 to -0.231.** A correct fix that made P
  worse: A_T's forecasts changed and it now abstains on more rows (about 53% of usable
  rows), which pushes weight onto the two weaker agents through the same mechanism as
  fix 2.

Fix 11 moved P the other way (-0.132 to -0.083) and for a few steps took the HAC test
above 0.05. Fix 12 reversed that. The direction of P against B1 did not change at any
step from 2 onward.

Fixes 3, 4, 5, 7a, 8, 9 and 13 were each worth less than 0.01 on P. They were correctness
fixes (GARCH arithmetic, as-of leaks, a one-day cross-ticker leak in B3, test and
reporting errors) and are kept because a result resting on them would not survive
examination, not because they changed the answer.

## The fixes

**0. run_arms --quick crashed in the seed-dispersion report.** With one seed, `max()` of an
empty list raised after the CSVs were written but before `acceptance.txt`, so a quick run
silently left a stale acceptance report behind.

**1. L_t composition, orientation and de-skew.** (a) The high-low range input was V_t
divided by sqrt(240), correlation 1.0 on every ticker, so liquidity and volatility were
not separately identified in x_t; it is removed and `build_state` now refuses any input
correlated above 0.95 with V_t. (b) PC1 is replaced by the equal-weighted mean of the
signed, expanding-z-scored inputs: 389 of 1,495 refits (26%; 100% on HUNT) loaded a
"higher means worse" input negatively, and L_t reversed sign when that contrast rotated
(VONE 2016-04-05, YORK 2021-06-30 and 2021-08-06). The PCA composite is kept as `L_pca`.
(c) Amihud and turnover are de-skewed with asinh over an expanding median, replacing
log1p, which was a near-identity at these magnitudes. **(a) and (b) are deviations from the
pre-registered recipe** and are recorded in `config.LT_INPUTS`.

**2. Abstention routed into the weights.** `softmax_floor` never received the abstain flag.
An abstaining agent now gets exactly the floor phi and is excluded from the softmax share
(§6.3); unparseable and no_data still take a hard zero; B1 stays pure equal weight.
Non-finite scores now raise rather than silently becoming equal weights.

**3. A_V GARCH arithmetic.** A refit day advanced arch's one-step forecast a second time on
r[t-1]; the between-refit recursion used r where arch's constant-mean parameters require
r - mu; the EWMA fallback conditioned on r[t] while GARCH conditioned on r[t-1]. The test
reproduces arch's conditional variance to rtol 1e-6 and fails on the old code with a 3.0%
sigma error.

**4. Depth rules applied as-of.** A_V's conformal-versus-QLIKE choice and P_t's counter-
versus-index choice used the whole series' traded-day count, so a counter that eventually
crossed the threshold was treated as having crossed it from day one (46% of traded days on
the dev universe). Both are now decided per row. A_V's calibration is fitted per mechanism.

**5. B3 per ticker, warmed on the training window.** One accumulator over a date-major panel
leaked same-date outcomes across tickers (92% of rows in the last fold), and the 0.97
discount gave about 2.4 trading days of memory rather than 33.

**6. One definition of the forward return.** The panel and calibration used the next
calendar row and discarded returns spanning a non-trading day; A_T and A_L scored
themselves on the next traded close. `forward_return_traded` is now the single definition.
On HUNT the old definition discarded 29.5% of return episodes, and they were the quieter
ones.

**7a. Conviction scales on voting rows only.** Averaging in no_data zeros over-amplified
frequently silent agents.

**7b. Positions from the rescaled vote.** See above. A design decision.

**8. A4 counts decision sign flips**, not realised-return sign flips, which flip whenever
cost crosses a small gross return.

**9. Missing calibrated confidence uses the agent's training-window mean**, not 0.5, which
is not neutral under a signed gamma.

**10. Paired tests on the daily portfolio P&L difference.** The tests ran on date-major
panel rows, so the HAC lag and bootstrap blocks ran across tickers rather than along time.
They now run on the per-date sum (1,999 trading days) with a t reference, plus a per-fold
paired t. The report states how many of the three tests agree.

**11. V_t and P_t measurement.** Parkinson bars with high == low are now missing rather
than zero variance (they understated V_t by 5 to 16% on thin counters). GPH runs on the
traded-day series. The GPH standard error comes from the regression design.

**12. A_T features standardised inside the ridge fit**, with training-window moments. The
raw feature scales spanned 220:1, so one alpha shrank some features to nothing and left
others untouched.

**13. Housekeeping, no intended effect on results.** Multi-source queries align on the
sorted union of source dates (order-independent; previously 89% of probe queries depended
on field order); the cursor is normalised and returned, and a cursor before the window
raises; `Rows.last` skips trailing missing values; a name requested from two sources
raises; volume fields resolve to the calendar panel so zero-volume days survive; the
`AsOfView` docstring states its guarantee honestly (accidental widening is prevented,
deliberate circumvention is caught by the truncation tests rather than prevented);
contract state must be an `AgentState` and `confidence_raw` finite or None; `in_simplex`
is defined positively; calibration enforces the per-bin minimum; `knee` uses the chord-
distance construction and indexes the caller's list; `n_params` reports identified
parameters ((K - 1)p + K, so 11 for P rather than 15, 2 for B2 rather than 3); panel
guards for duplicate dates, mismatched agent and state dates, and missing agents; report
labels for the cost sweep (sums, seed 0), the parameter sweeps (last 8 folds, seed 0,
with B1 and P printed for the same folds) and the identical hold and flat rows.

## The full run after all fixes

Five seeds, sweeps on. Mean per fold over 16 folds and five seeds, 50 bps.

| arm | net | gross | cost | hit | MCC | params |
|---|---:|---:|---:|---:|---:|---:|
| B1 equal weight | +0.1752 | +1.3952 | 1.2201 | 0.5333 | +0.0672 | 0 |
| B2 static learned | -0.1198 | +1.6462 | 1.7660 | 0.5309 | +0.0679 | 2 |
| B3 discounted inverse-MSE | +0.0921 | +1.1417 | 1.0497 | 0.5263 | +0.0502 | 0 |
| P state-conditioned | -0.2308 | +1.4990 | 1.7297 | 0.5357 | +0.0686 | 11 |
| O oracle | -0.1087 | +1.4175 | 1.5262 | 0.5342 | +0.0628 | 11 |

Pre-registered rule: FAIL on both halves. Median per-fold delta -0.286 against a baseline
IQR of 0.683. Daily P&L difference: HAC p 0.016, stationary bootstrap p 0.030, per-fold
paired t p 0.048, all three with P below B1. P beats B1 in 3 of 16 folds.

**L_pca robustness run** (`run_arms.py --l-column L_pca`, `out/arms_L_pca/`): P -0.2600
against B1 +0.1592, rule FAIL, P below B1 on 2 of 3 tests (per-fold p 0.066), removing
L_t improves P by +0.2032. This run has 27,720 usable rows against 30,960, because the
rolling PC1 needs more history before it exists, so it is a robustness check on the
direction of the result rather than a same-rows comparison.

## Still open after the fixes

- **phi and the abstained-day exposure policy remain OPEN pre-registration items.** Both
  are swept. The exposure policy has no effect on this panel because the system never
  abstains: A_V and A_L have no abstention rule, so at least one agent is always in state
  ok.
- **The U2 >= 1 abstention criterion** is pre-registered and unchanged. Fix 2 and fix 12
  show it carries a large share of P's deficit. Changing it after seeing the result would
  be a post-hoc change and would have to be reported as one.
- **LOSS_SCALE (0.02) has not been swept.** It sets the target scale in the FFORMA loss.
- **The parameter sweeps run on the last 8 folds only**, seed 0, for run time.
- **A_F is not built**, so the A_F on/off ablation is reported as absent rather than run.
- **15 dev counters only.** None of this has been run on the full universe.
