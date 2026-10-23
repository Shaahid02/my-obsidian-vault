---
status: current
created: 2026-10-23
written_against: "[[Contribution to Knowledge]]; [[PoC Specification]]; [[Week 5]]; [[Scope sentiment analysis dropped]]; [[29-09-2026]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 20 of the PP live presentation template. This slide carries the scope criterion almost on its own, which makes it one of the two densest in the deck, and it is also the last thing the panel hears before questions. It additionally holds [[Week 5]] outstanding action 1, the news and sentiment exclusion defence, which was the highest-value item from that session and does not exist anywhere yet. Sentiment is out of scope throughout.*

---

## Why this note exists

Three jobs on one slide. Show that the work is substantial enough for a final-year project, show that it is bounded enough to finish, and close with a defence that survives the first question. The scope criterion is worth 10 percent on this slide alone, and scope also appears in the cross-cutting row of every grade band, so it is being assessed everywhere and summarised here.

---

## Part 1. Substantial software engineering work

The template asks what makes the artefact technically and analytically challenging. The answer is not the agent count.

| Element | Why it is substantial |
|---|---|
| **A point-in-time data layer over a market with no clean panel** | Five corporate-action registers joined through a name crosswalk, with rights issues requiring a theoretical ex-rights price reconstruction, announced terms for the price adjustment and final allotment for the share count, and ex-dates recovered by clustering rights-instrument trading episodes. At least ten source items change layout, units or meaning partway through their own history, and three fail silently |
| **A weighting mechanism that has to be estimated, not just implemented** | The operator is small by design, and the engineering is in making it attributable: cached agent outputs so five arms are comparable, per-input ablation, an oracle arm, stability sweeps, and six diagnostics each tied to a named failure mode |
| **Four heterogeneous agents behind one contract** | The contract is the load-bearing plumbing, because a softmax output and a posterior variance are not comparable and the calibration transform is what makes them so |
| **An evaluation harness rather than a backtest** | Walk-forward with adaptive retraining, regime decomposition, cost sweeps, trade-count equalisation, HAC and bootstrap testing, and abstention evaluated economically |
| **A verified data pipeline** | Reconciled against published annual figures at 0.13 percent and against an independent archive at 99.93 percent close agreement across 817k rows, with a validated 3,920-day calendar matching the exchange's own reports for all 17 years |

---

## Part 2. Feasible boundaries

Eight exclusions, each with a reason. The rubric rewards deliberate boundaries, and a boundary without a reason reads as something that was not reached.

| Excluded | Reason |
|---|---|
| Sentiment in any form | Supervisor, 20 September, Final. It had become a second research problem inside the first |
| Any fifth agent, including macro | Rejected on evidence, not on time: adjusted $R^2$ of 0.189 across five macro variables over a decade, with Granger nulls for money supply and inflation |
| Microstructure execution | Bid, ask and depth are not held and are in none of the forty purchased items. The proxy route was declared as the plan in advance, not adopted after a failure |
| A spread estimator from daily prices | Demoted on 11 October because it is unvalidated on thin markets and this market has no quote data to check it against, so the output could not be falsified even in principle |
| A learned network orchestrator, and reinforcement learning | Low capacity is a cited design decision. An observed performance sign-flip under a small regularisation change, on a larger universe than this one, is the argument |
| An end-user interface | Operated as a batch research pipeline. Advanced interface work was removed from the plan on the grounds that it would reduce proposal quality |
| New components after 18 October | Hard rule with a named date |
| Profitability as an acceptance condition | The claim is about whether conditioning earns its place, not about returns |

**The priority rule behind all of it**, which is the supervisor's: stop trying to make every component novel, and make the main orchestration contribution exceptionally well evidenced, implemented and evaluated.

---

## Part 3. Limitations

Stated as limits on the claim rather than as apologies.

- **One market, one window, one universe.** Nothing here supports a general claim about frontier markets. The CSE is a stress-test setting where reliability varies, and that is the defensible framing rather than uniqueness.
- **Simulated, not measured, execution.** There is no ground-truth execution data on this market to validate a simulator against.
- **Proxies, not a measurement, for what a trade costs.** The cost term rests on illiquidity proxies because no validated spread measurement exists here, and validating it is what the outstanding exchange request is for.
- **Survivorship is present and proxied.** No listing register with effective dates exists, so series-end dates stand in and the residual bias is reported.
- **Corporate actions are handled by exclusion at proposal stage.** The adjusted series does not exist yet, and counters that split are disproportionately ones that rose, so the exclusion has a direction.
- **Comparability of confidence across four architectures is an open question**, stated as open rather than resolved.
- **The persistence contribution is a pre-registered experiment, not a result.**
- **The literature has not been fully swept.** One relevant 2026 paper on modular transaction-cost layers is paywalled and unread, and the gap statement carries a 2026-03-09 cutoff.

---

## Part 4. The scope-exclusion defence for news

[[Week 5]] §2.5 is the reason this section exists. A panel member asked how the system accounts for news-driven movement when it has no sentiment component, was explicit twice that he was not asking for sentiment to be reintroduced or for a dataset to be built, and was equally explicit that a solid answer is worth marks because it shows scope was set deliberately.

**The defence, stated as my own reasoning rather than as something established.**

News reaches this system through its measured consequences. A news shock shows up as a change in volatility, in persistence and in liquidity, and those are precisely the quantities in the conditioning set. The system does not read the news and does not claim to anticipate it. It is designed to respond to the market state the news produces, and the confidence and abstention terms exist for the case where an agent's inputs have gone stale relative to that state.

**Three things to say alongside it, because the defence is weaker without them.**

1. **The honest limit.** This is reactive rather than anticipatory, and the hardest case is a shock originating outside the market being traded, which is the example the panel member gave. For that case the answer is that the system detects the consequence quickly rather than predicting the cause, and the evaluation reports what that costs.
2. **Why it was excluded, and it was not for lack of interest.** Sentiment would have required primary collection, manual annotation, annotator disagreement, platform access and code-mixed language work, which is a second research problem inside the first and none of it directly tests the main contribution.
3. **What was kept.** Sentiment papers remain in the corpus as background and, more usefully, as fixed-influence failure cases. The clearest local example of the problem this project addresses is a CSE study that fixed a combination at three to one in favour of a text model, which is a sentiment paper being used as evidence for the gap rather than as a component.

---

## Part 5. The closing defence

The template's four prompts, answered in one line each. These are the last sentences of the presentation and are worth rehearsing verbatim.

| Prompt | Answer |
|---|---|
| **This project addresses...** | How the influence of methodologically heterogeneous agents should be set over a single shared decision when the reliability of their evidence channels varies with market conditions |
| **It is needed because...** | In the systems I have reviewed, that influence is fixed at design time, and in most of them there is no weight object to vary at all, while five documented cases show reliability varying and the architecture unable to notice |
| **The proposed contribution is...** | A continuous, agent-level, state-conditioned weighting operator with an abstention channel, positioned as a generalisation of feature-conditioned forecast combination along one named axis, together with attributable evidence on whether it earns its place |
| **The scope is credible because...** | The boundaries are stated with reasons, the hardest benchmark is pre-registered as the primary one, a null is an acceptable outcome decided in advance, and the fallbacks for the two live data risks were declared before either one bit |

---

## Part 6. Generalisation, and what can be learned beyond one dataset

The template asks what is learned beyond a single feature demo. Three things that hold regardless of which way the comparison goes.

- **Whether structural confidence estimates can be made comparable across unlike architectures**, which is an open question in its own right and is answered partially by the comparison of four mechanisms on one pool.
- **A measured cost-curve shape in order size**, which I have not found for any market in the reviewed set, not only for this one.
- **A worked case of the combination literature's own open question**, how to interpret combination weights, since the operator produces a weight per agent per step as a readable function of named market-state inputs. The caveat travels with it: a weight being readable is not the same as it being correct.

---

## Part 7. Open decisions

1. **How Part 2 and Part 3 split against slide 6.** The withdrawn-claims table appears in both notes. It should be said once, and this slide is the better home because it is the limitations slide.
2. **Whether the news defence is on the slide or held for questions.** It was raised as preparation for examiner questioning rather than as a slide requirement. One line on the slide with the full argument ready is probably right.
3. **Whether the closing defence is spoken or shown.** Shown and spoken is repetitive. Spoken, with the four prompts on screen as headings only, is stronger.

---

**Related notes.** [[Contribution to Knowledge]] Part 4 for the withdrawn claims and Part 5 for the risks. [[PoC Specification]] Part 1 for the exclusions. [[Scope sentiment analysis dropped]] for the scope decision and its reasoning. [[Week 5]] §2.5 for the session that produced the news question. [[22 Backup and Q&A Preparation]] for what to have ready behind this slide.

**Language discipline applies here too.** The permitted form is *"I have not found that evaluation in the literature I have covered."* The defence in Part 4 is labelled as my own reasoning rather than as established.
