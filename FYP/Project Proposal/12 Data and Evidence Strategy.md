---
status: current
created: 2026-10-23
written_against: "[[PoC Data Build]]; [[Data Cleaning Checklist]]; [[Dataset Profile 2026-10-20]]; [[Data Library Profile Items 01-39]]; [[Research Matrices Status]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 12 of the PP live presentation template. This is the best-evidenced slide in the deck and the one most at risk of drowning in detail, because the data work has produced far more material than a slide can hold. The template's framing is the filter: state what data is needed, why it is legitimate, and how it supports evaluation. Sentiment is out of scope throughout.*

---

## Why this note exists

Data strategy sits inside the requirements criterion and also feeds the responsible-considerations criterion through licensing. The supervisor's expectation from [[29-09-2026]] §8.1 is the bar: **provenance, quality, limitations and legality clearly defended**.

All four are available. What this note does is choose which figures carry them.

> [!WARNING]
> **Do not quote superseded figures.** [[ELI5 - The Whole Project in Plain English]] and [[PoC Specification]] §4.3 both predate the 18 to 21 October corrections and still say 374 trading days per counter, 270 counters, and turnover unavailable long-horizon. The current figures are in Part 1 and all three of those statements are wrong.

---

## Part 1. What is held

| Element | Current position |
|---|---|
| Base panel | The official daily share price extraction, **not** the API scrape |
| Universe | 357 equity securities trading in the window, 333 voting and 24 non-voting, with rights, warrants, preference and unit instruments excluded. 356 have at least 60 aligned days |
| Observations | Roughly **853,535 traded rows** |
| Calendar | **3,920 validated trading days**, 2010 to 2026-06-30, matching both the Data Library annual market-day figure and the exchange annual reports for all 17 years |
| Per-counter depth | Median roughly **3,400 days**, 10th percentile 1,081 |
| Turnover and trade count | **Held across the full span**, confirmed 18 October. Amihud and the turnover ratio therefore enter the liquidity composite over the whole window rather than a fragment |
| Index track | ASPI clean across the window at 15.1 percent annualised volatility, with annual figures from 5.6 percent in 2017 to 31.6 percent in 2022 |
| Corporate actions | Registers for splits, dividends, bonus issues, scrip dividends and rights issues, inside the purchased Data Library |
| Float | Quarterly public holding, 2012 to 2026 H1 |
| Bid, ask, depth | <font color="#ff0000">Not held, and not available in any of the Data Library's forty items.</font> The outstanding request to the exchange is the only route |

**The honest wording for what is missing**, prescribed at [[29-09-2026]] §5.7: long-horizon bid, ask and depth history aligned to the price series has not yet been secured. Do not say turnover and market cap are unavailable, because they are held.

---

## Part 2. The template's table

Data need, source, quality check, control. Four rows as the template asks, with the fourth adapted since there are no participants.

| Data or evidence need | Source and collection route | Quality check | Legal or governance control |
|---|---|---|---|
| **Price and volume panel**, the spine for three of four agents | Official CSE Data Library daily share price lists, purchased at the student rate. Loaders assert expected row counts and date ranges per item | Bar validity on load, high at least close at least low. Turnover reconciled against the published annual figures at **0.13 percent** for every year except 2016 at 0.8 percent. Panel cross-checked against an independent trade archive at **99.93 percent close agreement across 817k rows** | Licensed purchase rather than scraping. Licensing and reuse terms recorded as a field on every dataset row |
| **Corporate actions**, the precondition for every return | Data Library registers 01 to 05, joined to the panel through a company-name to security-ID crosswalk built from the issued-quantity series | Each year's actions applied to the year-end share count and confirmed against the next year-end, **per security per year rather than in aggregate**, because offsetting errors cancel in a total. Fifteen annual anchors inside the window mean the actions interpolate between known endpoints | Official registers rather than inferred adjustments |
| **Liquidity inputs**, for the state vector and the cost model | Turnover, trade count, float, and crossing trades stripped out at daily per-security granularity | Crossings run from 8.8 percent of annual market turnover in 2021 to 47.4 percent in 2017, median 12.5 percent per security. Stripped and unstripped series reported side by side | Same licensed source |
| **Filings corpus**, for the fundamental agent | <font color="#ffc000">Not yet collected.</font> Link harvesting from the announcements feed, since filenames are opaque identifier and timestamp pairs | A publication-date field on every document, text-native rather than scanned, with coverage measured by a probe set rather than imported from a benchmark figure | Exchange terms respected. Documents retained for research use, not redistributed |
| **Benchmark and development datasets**, for building and testing the fundamental agent's extraction | Public financial question-answering benchmarks | Used for taxonomy, probe design and development only | Licences respected individually. One is marked non-commercial and another is permissive, so neither is redistributed |

---

## Part 3. The four findings that changed the design

This is the part that makes the slide a strategy rather than an inventory. Each is a measurement on this dataset that forced a decision.

**1. The primary series is not adjusted for corporate actions.** Confirmed by inspection on 18 October: one counter closes at 212.50 on 2024-10-28 and 21.20 on 2024-11-06, a split rendered as a return of minus ninety percent, and another shows plus 767 percent in 2019. Everything the system produces sits downstream of a return, so the direction label, the range-based volatility estimate, Amihud, the confidence calibration and every arm comparison are all affected. The interim rule is detect and exclude, with the exclusion rule, the residual dividend label error and the direction of the bias all reported, since counters that split are disproportionately ones that rose.

**2. Crossings make a counter look liquid without being liquid.** A crossing is a pre-negotiated transfer that consumed no book depth, so Amihud, relative volume, turnover ratio and trade intensity all divide by volume they assume is continuous order-book trading. Left uncorrected the liquidity state is systematically wrong in the direction of overstating liquidity. The contamination is bounded: the estimator inputs are board-only and uncontaminated, so the problem is confined to the volume-derived measures.

**3. The published close is often not a traded price.** 6.4 percent of rows carry a close outside the day's high-low range, and **99.9 percent of those have a close equal to the previous close**, with a median high-low range of zero. A single trade printed away from a carried-forward reference price. This appears in the official files and is not an extraction defect. It is also a candidate staleness variable with a cleaner interpretation than zero-return frequency, and I have not found it quantified for the CSE in the literature I have covered.

**4. Liquidity stratification is feasible and wide.** Median daily turnover spans a factor of 114 from the least to the most liquid quintile, and the degenerate-day rate by a factor of 27. A pooled estimate would conceal the regime the contribution is about, so the universe is stratified rather than averaged, and the candidate set is 234 voting securities trading on at least 60 percent of aligned days with at least 2,000 aligned days.

---

## Part 4. Limitations carried rather than hidden

| Limitation | Treatment |
|---|---|
| No listing and delisting register with effective dates | Series-end dates used as an explicit proxy, labelled as a proxy, residual bias reported. Voluntary delistings cannot be separated from failures |
| No bid, ask or depth | The microstructure route is closed and the cost work runs on proxies for illiquidity. Stated as a bounded fallback that was declared in advance rather than discovered |
| The adjusted series does not exist yet | Depends on the purchased registers. The proof of concept runs on a detect-and-exclude subset in the meantime |
| Three known structural breaks | Named and handled in the methodology: the 2019 accounting standard change for lease-sensitive and PPE-derived features, nominal price distortion across 2020 to 2023 for rupee-denominated features, and a price-granularity break at 2021-01 for tick-based features |
| Files checked for structure only | Several Data Library items have been checked for structure and coverage but not content. Given that every file examined so far has carried at least one defect, the unexamined ones are not assumed clean |

---

## Part 5. Why this supports the evaluation

The template's last instruction is that data strategy is part of the research design. Three links worth stating.

- **Point-in-time correctness** is why the data layer holds the cursor rather than each agent filtering. Without it, a favourable comparison against equal weights says nothing.
- **Stratification** is why the experimental universe is selected across the liquidity cross-section rather than from the top. Selecting the ten most liquid counters leaves the liquidity state with little variation, and the mechanism then has nothing to respond to.
- **The screen itself is a result.** The count of counters the trading-day filter removes on an average day is a liquidity statistic worth reporting, not housekeeping before the real work.

---

## Part 6. Open decisions

1. **Whether rows with a close outside the high-low range are dropped or admitted as degenerate observations.** The two treatments give different usable sample sizes and different corrections, and the choice does not follow from the source method. Settle it, document the reasoning, and report the sample size both ways.
2. **Float-adjusted or raw liquidity stratification.** Nearly a third of the bottom quintile changes identity depending on which is used. My reading is that float-adjusted is the better measure of tradeable liquidity on a market where half the counters have under a quarter of shares in public hands, with the raw version alongside as a robustness check.
3. **Panel end at 2026-06-30, or spliced forward.** Decide on source-consistency grounds.
4. **The full-study window.** A panel member gave 2010 to 2026 in [[Week 5]] §2.1 and a different one gave two to five years for the proof of concept in [[Week 4]] §2.5. They most likely answer different questions, but neither said so, so both go to the supervisor together rather than one being chosen silently.

---

**Related notes.** [[PoC Data Build]] for the dependency chain and the per-artefact detail. [[Data Cleaning Checklist]] for the verification suite. [[Dataset Profile 2026-10-20]] for the stratification and degeneracy profiling, noting that five of its figures are superseded. [[19 Responsible Research and Project Considerations]] for the licensing position.

**Language discipline applies here too.** Figures are measurements on this dataset over this window and are scoped to it, not presented as general claims about the market.
