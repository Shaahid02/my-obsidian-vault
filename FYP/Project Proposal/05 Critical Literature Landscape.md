---
status: current
created: 2026-10-23
written_against: "[[_Corpus Index]]; [[Research Matrices Status]]; [[Research Gap (Final Statement)]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 5 of the PP live presentation template. The corpus is the strongest asset in this project and it is also the easiest thing to present badly, because the temptation is to show how many papers were read. The template's instruction is explicit: synthesis, not summaries, grouped by theme, with findings compared and tensions identified. Sentiment is out of scope throughout.*

---

## Why this note exists

Slide 5 sits inside the 10 percent evidence criterion and shares it with three other slides, so it carries roughly two and a half marks. The work behind it is worth far more than that, which means the discipline on this slide is subtraction: show the shape of the corpus, the three or four tensions inside it, and nothing else.

---

## Part 1. The corpus in one table

Generated from the notes' own properties, so these figures are reliable rather than estimated.

| Measure | Value |
|---|---|
| Notes indexed, all complete | **59** |
| CSE-facing | 12 |
| Sri Lanka, non-market data | 2 |
| Reports an out-of-sample evaluation | 41 yes, 18 no |
| Reproducible from the paper alone | 4 yes, 34 partial, 21 no |
| Missing a citekey | 0 |

**By stream.** Multi-agent LLM systems 15, forecasting 8, retrieval and financial QA 8, sentiment 5 retained as background, portfolio 4, volatility 4, execution 3, macro-finance 3, benchmarks 2, corporate finance 2, microstructure 2, reinforcement learning for trading 2, calibration 1.

**By role in this project.** Protocol source 18, baseline 8, gap evidence 8, dataset 7, local context 6, cautionary specimen 5, survey 4, tooling 3.

> [!NOTE]
> The **role** breakdown is the one to show, not the stream breakdown. Stream counts say what was read. Role counts say what each paper is doing for the project, which is the difference between a reading list and a literature review. Eight papers are carried explicitly as gap evidence and five as cautionary specimens, which is a position rather than a summary.

---

## Part 2. The three themes

The template asks for problem domain, methods, and evaluation. Each theme below ends with the tension that makes it worth presenting.

### Theme 1. The problem domain, frontier market behaviour

Fourteen CSE and Sri Lanka papers, carried mostly as local context and cautionary specimens.

What is established: illiquidity shocks depress returns at $-0.084$ to $-0.097$ with small caps more affected; trading volume Granger-causes the index at $p = 0.0041$ while money supply and inflation reach nothing; long memory is found on both the index and the large-cap index across all three regimes, with a second study putting persistence close to 1; macro linkages break across 2014 to 2022; and mean institutional ownership runs at 66.1 percent against insider ownership of 5.7 percent.

**The tension.** The local literature measures these quantities carefully and consumes none of them. Three CSE papers detect volatility clustering and address it only with robust standard errors. The modelling in several is ordinary and the evaluation is what separates them. So the domain evidence is strong enough to justify a design and is not itself a design.

### Theme 2. Methods, how heterogeneous evidence gets combined

Thirty-two papers across multi-agent systems, forecasting, portfolio allocation, reinforcement learning and retrieval.

What exists: multi-agent architectures with genuinely different analysts; feature-conditioned forecast combination with a learned weighting function; continuous conditioning on market state across identical components; constrained optimisation over an explicit weight vector across assets; and an orchestrator that learns to coordinate from its own internal state.

**The tension.** Every necessary clause exists somewhere and no reviewed system holds them together. Several carry no weighting quantity at all, combining through a prompt rather than a coefficient, which means the design choice is invisible rather than wrong. One declares a confidence field, draws it in a figure, and never computes with it. Another feeds three model-authored expected returns straight into an exact optimiser with no calibration, which is precision applied to uncalibrated inputs.

### Theme 3. Evaluation, what counts as having shown something

Protocol sources are the largest role category at 18, plus 4 surveys and 2 benchmark papers.

What the strong work does: walk-forward with adaptive retraining, chronological splits, multiple seeds with dispersion, regime decomposition, cost sensitivity sweeps, ablation, HAC-adjusted and bootstrap significance testing, and ratios to a named baseline with a model confidence set attached.

**The tension, and it is the sharpest one.** Only 41 of 59 report an out-of-sample evaluation, and only 4 are reproducible from the paper alone against 21 that are not. A benchmark paper in the corpus documents a trading-tuned model scoring 0.03 F1 where its NLP-tuned sibling scores 0.94, which is a result that only surfaces because someone evaluated across tasks rather than within one. One local study reports in-sample $R^2$ of 0.576 and within $R^2$ of 0.090 with no out-of-sample result at all, which is simultaneously a gap and a baseline to beat.

---

## Part 3. What the corpus settled, and what it left open

Worth one line each on the slide, because it shows the literature changing decisions rather than decorating them.

| The literature settled | How |
|---|---|
| Equal weighting is the primary benchmark, not one arm among several | Fifty years of combination evidence that it is hard to beat |
| An abstaining agent shrinks toward a floor rather than to zero | Individually poor forecasts can still help in combination |
| No pairwise interaction term in the orchestrator | Three separate results that ignoring error covariances is the better practical choice, because covariance estimates are unstable |
| The orchestrator is low capacity | An observed performance sign-flip under a small regularisation change, on a larger universe and a longer history than this one |
| An agent's weight cannot come from its own in-domain score | The local 2021 study that set one at three to one on exactly that basis |

| The literature left open | Status |
|---|---|
| Whether structural confidence estimates can be made comparable across unlike architectures | Stated as open. Four mechanisms, one candidate common unit, no settled answer |
| How to interpret combination weights | Listed by the combination literature itself as one of its open research questions |
| When feature-conditioned weighting beats a simple average | The review states plainly there is no comprehensive quantitative guidance |

---

## Part 4. Three corrections made to my own record

Worth having ready rather than presenting, because it answers the question of how carefully the corpus was actually read.

A provenance audit required every quoted span in the survey matrix to be verbatim in the note it came from. It produced thirteen substantive corrections, four adjudicated against the source PDFs. One note had reversed a paper's own ablation finding, two asserted something the note explicitly withholds, one quoted one strategy's turnover for another's, and one carried a metric gain that appears at no horizon in the paper. All 1,621 quoted spans are now traceable.

Separately, three claims were withdrawn on evidence rather than defended: that size-dependent execution cost is unmodelled, withdrawn once two implementations were found; that volatility is not operationalised in agent systems, narrowed to the persistence half only; and that structure-aware retrieval over filings is novel, withdrawn as verified prior art on this market from the same university.

---

## Part 5. Open decisions

1. **Which three clusters appear on the slide.** The template's own suggestion is problem domain, methods and evaluation, which is what Part 2 uses. An alternative split by role, gap evidence against protocol sources against cautionary specimens, is more distinctive and less conventional.
2. **Whether the reproducibility figure is shown.** Four of 59 reproducible from the paper alone is a striking number and it supports the reproducibility commitment in the methodology. It also invites a question about whether this project will meet its own standard.
3. **Where the corrections in Part 4 live.** They are evidence of rigour and they belong on slide 16 or in backup, not on slide 5, or the literature slide turns into a slide about process.

---

**Related notes.** [[_Corpus Index]] for the generated per-note table. [[04 Evidence to Research Gap]] for how this evidence becomes a gap. [[08 Existing Solutions and Baselines]] for the systems treated as comparators. [[Research Matrices Status]] for the audit record.

**Language discipline applies here too.** The permitted form is *"I have not found that evaluation in the literature I have covered."* Counts are of my own corpus and are scoped to it, not to the field.
