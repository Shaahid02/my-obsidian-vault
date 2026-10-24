---
status: current
created: 2026-10-23
revised: 2026-10-24
written_against: "[[Research Gap (Final Statement)]]; [[ELI5 - The Whole Project in Plain English]]; [[29-09-2026]]; [[07 Research Questions, Aim and Objectives]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 3 of the PP live presentation template. The problem and its significance are the strongest material in the vault; what has been missing is a stated goal and a stated set of outcomes, which is why this criterion was marked partial rather than complete. Sentiment is out of scope throughout.*

---

## Why this note exists

The rubric's first criterion assesses the clarity and significance of the problem **including the intended product, project goal and outcomes**. The gap statement covers the problem and its significance thoroughly. It does not say what will be built, what will exist at the end, or how anyone would know the project succeeded, and the slide's own table has a row for each of those.

---

## Part 1. The problem

Stated in the order the slide needs it: what the problem is, who it affects, what the current approaches do, and why that fails here.

**The problem.** Four agents, technical, fundamental, volatility and liquidity, each produce a signal, and something has to turn several signals into one decision. In the systems I have reviewed that combination is fixed at design time, and in most cases there is no quantity that could be weighted in the first place. TradingAgents combines through a one-sentence facilitator prompt, FinVision concatenates analyst outputs into a single prompt, and a third passes a free-text summary. There is no vector and no coefficient, so the question of how the weights are set has no answer to criticise.

**Why that matters.** An agent's reliability is not constant. It depends on what the market is doing and on what data exists today. The failure mode is worse than a weak signal, because these agents do not abstain: ask the fundamental agent about a counter whose last annual report is eleven months stale and it returns a confident number about nothing.

**Who it affects.** The researcher building such a system, who cannot attribute a result to a mechanism that has no parameter. The decision-maker relying on the output, who cannot tell a live channel from an empty one. And, if such a system were deployed, retail participants on a thin market, who are least able to absorb a cost the model has assumed away. [[09 Stakeholders, Users and Context of Use]] carries the full set.

---

## Part 2. Evidence of significance

Five documented cases, each a published system or study rather than an assertion. This is the content that makes the problem a problem rather than an observation.

**Decided 24 October: three go on the slide, two are held for questions.**

| Case | On slide | What it shows |
|---|:---:|---|
| **Pavithya et al. (2021), on the CSE itself** | ✅ | Two heterogeneous models, one shared decision, combination fixed once at three to one in favour of the text model because that model scored higher in individual testing on a different and easier task. The normalisation also makes realised influence depend on how many articles appeared that day, which is an availability-weighted scheme nobody designed and nobody analysed |
| **AlphaAgents** | ✅ | An entire agent was deleted by hand because its input channel was too thin across fifteen megacaps. A human noticed and intervened; the system had no way to |
| **FinAgent on ETHUSD** | ✅ | Auxiliary strategies returned 16 percent against buy-and-hold's 29 percent, tuned to large-cap dynamics that then changed, with nothing in the design able to notice |
| **Jung and Lee** | held | A measured 10.36 point total-return degradation from a text agent the architecture cannot notice |
| **PIXIU** | held | The complementary failure, where agents cannot fail independently in the first place. One trading-tuned model scores 0.03 F1 against 0.94 for its NLP-tuned sibling on the same benchmark family, which is the documented case for keeping agents architecturally separate |

**Why these three, and in this order.** They are the same structural failure in three different settings, which is a stronger argument than three instances of one setting. Pavithya is the fixed dial on this exact market, with a visible coefficient to point at. AlphaAgents is the channel going thin and a human having to intervene, which is the sentence that explains the abstention design in one line and carries slide 3 forward to slides 9 and 10. FinAgent is the system tuned once to conditions that then changed, with nothing in the design able to notice.

**Scope the FinAgent case when stating it.** That result is on a crypto pair rather than on equities, so it is evidence that the failure mode is not market-specific rather than evidence about the CSE. Saying so is what keeps the three-case argument honest.

Pavithya et al. also settles a design question beyond the illustration: an agent's weight cannot be set from its own in-domain score, it has to come from measured marginal contribution to the joint decision.

---

## Part 3. Why the Colombo Stock Exchange

The framing matters here and the wording is the supervisor's prescription from [[29-09-2026]] §3.2. The CSE is a frontier-market stress-test environment rather than a scientifically unique one.

- Most counters do not trade every day. A local factor-model study moves to weekly data for that reason.
- Unexpected illiquidity shocks depress returns at $-0.084$ to $-0.097$, small caps more than large.
- Trading volume Granger-causes the index at $p = 0.0041$, while money supply and inflation reach nothing.
- Relationships are not stable across the window a static system would be evaluated on. Traditional macro linkages break over 2014 to 2022, and a 2021 extension weakens a main coefficient from $-0.232$ to $-0.123$.
- The fundamental channel is structurally thin rather than occasionally thin. Three separate CSE studies hand-collected fundamentals from annual report PDFs, and one team had the exchange's own announcement feed in 2021 and abandoned it as too thin to train on.
- Mean institutional ownership of 66.1 percent against insider ownership of 5.7 percent, so available depth is worse than a capitalisation-based estimate suggests.

> [!NOTE]
> The honest form of the argument is that reliability varies more here than on a deep market, and the above is the measured local evidence for that rather than an assertion about another market. Do not claim the CSE is unique. Persistence, for instance, does not distinguish crypto from equities, so that particular door is closed.

---

## Part 4. The project goal

One statement, build and evaluate, consistent with the aim in [[07 Research Questions, Aim and Objectives]]. **Approved whole on 24 October, and it is delivered whole rather than compressed.**

> **Design, implement and evaluate a market-state-conditioned orchestration operator for multi-agent financial decision systems, and establish on CSE data under a cost-aware, regime-decomposed protocol whether conditioning agent influence on measured market state earns its place against fixed, static learned and performance-reactive weighting.**

**Why it is not compressed.** The second clause is what keeps a null inside the goal. Cut it and the goal becomes a promise to improve something, which is a claim the evidence may not support and which would then sit in tension with the pre-registered position that equal weights winning is an acceptable outcome.

**The intended product**, stated plainly so the slide's product row is not empty: a research pipeline comprising a point-in-time data layer, four heterogeneous agents behind one output contract, a state vector, a low-capacity orchestration operator with an abstention channel, and an evaluation harness running five weighting arms over identical cached agent outputs. There is no end-user interface, and that exclusion is deliberate rather than unfinished.

---

## Part 5. Expected outcomes

The rubric wants outcomes that are measurable or observable, and that align with the goal. **Five, as settled on 24 October.**

| # | Outcome | Observable as |
|--:|---|---|
| 1 | A working orchestration pipeline in which changing liquidity measurably changes the weights, the decision, or both | The A3 sensitivity sweep recording $\partial w / \partial L$, and the disagreement count between arms |
| 2 | Attributable evidence on whether state conditioning beats equal weighting, static learned weighting and performance-reactive weighting | The five-arm comparison with per-input ablation deltas, tested at a pre-registered margin |
| 3 | A comparison of four structural confidence mechanisms on one agent pool, with the accuracy-at-threshold transform as the candidate common unit | The calibration curves and the confidence ablation |
| 4 | A CSE baseline set produced under a walk-forward, cost-aware, regime-decomposed protocol | The baseline table, with the liquidity screen reported as a statistic in its own right |
| 5 | A corporate-action-aware, liquidity-screened, survivorship-reported CSE panel with the adjustment factors carried alongside | The dataset artefact and its verification record |

> [!NOTE]
> **A sixth outcome was removed on 24 October.** It read: *a stated and tested position on whether volatility persistence should govern post-shock re-levering*. It is removed because the experiment behind it was cut from the 25 October gate in [[PoC Build Plan]] §6, so listing it as an expected outcome would invite a question about a result that will not exist by 5 November.
>
> **Consequence to resolve in [[07 Research Questions, Aim and Objectives]].** RQ3 now has no outcome attached to it. Either RQ3 is demoted to a stated sub-hypothesis, or persistence returns as an outcome worded explicitly as a pre-registered experiment. The two notes have to agree, and they currently do not.

**Outcome 2 is the one that holds whichever way the result goes.** Fifty years of forecast-combination evidence says equal weights are hard to beat, and the review that documents this states plainly that there is no comprehensive quantitative guidance on when to choose which. An answer on a thin frontier market is worth having even if the answer is that equal weights win.

---

## Part 6. The alignment chain, in one line

Worth saying out loud on the slide, because the criterion assesses alignment and not just presence.

> Agent reliability varies with market state → nothing in the reviewed systems varies influence with measured market state → so build the operator that does → and test it against the three alternatives that could explain the same result → on a market where reliability demonstrably varies.

---

## Part 7. Settled and open

### Settled 24 October

| Item | Decision |
|---|---|
| Goal statement | Delivered whole, not compressed. The comparison clause stays |
| Failure cases on the slide | Three: Pavithya et al., AlphaAgents, FinAgent. Jung and Lee and PIXIU held for questions |
| Outcome 6, persistence | **Removed.** Five outcomes remain |

### Still open

1. **The knock-on to RQ3**, recorded in Part 5. Removing the persistence outcome leaves RQ3 without one, and the two notes have to be reconciled when [[07 Research Questions, Aim and Objectives]] is addressed.
2. **Nothing else.** This note is otherwise ready to build from.

---

**Related notes.** [[Research Gap (Final Statement)]] for the problem in full. [[07 Research Questions, Aim and Objectives]] for the aim and the success criteria. [[09 Stakeholders, Users and Context of Use]] for who is affected. [[20 Scope, Limitations and Closing Defence]] for what is not claimed.

**Language discipline applies here too.** No "first", "nobody", "never". Every figure is scoped to the study it comes from.
