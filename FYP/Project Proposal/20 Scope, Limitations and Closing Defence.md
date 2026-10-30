---
status: current
created: 2026-10-23
revised: 2026-10-30
written_against: "[[Contribution to Knowledge]]; [[PoC Specification]]; [[Week 5]]; [[Scope sentiment analysis dropped]]; [[29-09-2026]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 20 of the PP live presentation template. This slide carries the scope criterion almost on its own, which makes it one of the two densest in the deck, and it is also the last thing the panel hears before questions. It additionally holds [[Week 5]] outstanding action 1, the news and sentiment exclusion defence, which was the highest-value item from that session and does not exist anywhere yet. Sentiment is out of scope throughout.*

---

> [!NOTE]
> **Revised 30 October 2026.** This criterion scored **69 of 100** in the [[24-10-2026]] assessment, the strongest of the four weak ones, with a seventeen item checklist in §6.7. Four additions: the justification for four voting agents, which answers a direct architectural challenge; the minimum viable research artefact; the priority order for what gets cut; and a narrowing of the execution-cost claim. The sub-gap classification §6.7 also asks for is deliberately left as it stands.

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

## Part 1a. Why four voting agents, and why liquidity and volatility vote

`[ADDED 30 OCTOBER 2026]` [[24-10-2026]] §6.7 puts a direct architectural question: the liquidity and volatility components **"may operate more naturally as state estimators or constraints than as independent voting agents"**, and the architecture must justify whichever design is chosen. §6.7 also asks for four agents to be justified against three or fewer. Both are answered here, because they are the same question.

**The decision is four voters.** $A_T$ technical, $A_F$ fundamental, $A_V$ volatility and $A_L$ liquidity each emit the common output contract and each receive a weight.

### The objection, stated at its strongest

There is a sharper version of §6.7's point than §6.7 makes, and it is the one worth pre-empting. If $A_L$ casts a vote **and** supplies $L_t$, the operator would be conditioning its weights on a quantity produced by one of the things it is weighting. That is circular in a way $A_T$ and $A_F$ are not, and the pre-registered collinearity diagnostic half-concedes it by testing whether the volatility and liquidity constructs measure the same thing.

### Why it does not hold in this design, and what does survive of it

**The state vector is not built from agent output.** $L_t$, $V_t$ and $P_t$ are computed at the state layer directly from market data, the BIS market-condition-indicator recipe for liquidity and range estimators for volatility, not from what $A_V$ or $A_L$ emitted. The agents and the state share a **data source**; they do not share an **output path**. No agent's vote feeds the weight it receives.

**What does survive is weaker and is worth conceding.** $A_L$'s directional view and $L_t$ both derive from the same volume and turnover series, so they will correlate, which means $A_L$'s influence is modulated by something correlated with its own inputs. That is a correlation, not a feedback loop, and it is reported rather than argued away: the pairwise agent error correlation and the volatility-liquidity collinearity check are both pre-registered for exactly this.

### The justification for four

**Error cancellation is the argument, and it is the only one being made.** The case for a pool is that methodologically unlike estimators make unlike errors, so combining them cancels some of that error. That argument requires genuine heterogeneity, and heterogeneity across four unlike methods is the thing being tested rather than assumed. Three would be defensible; four is chosen because dropping either of the market-state agents removes a whole error mode rather than a redundant one, and because the pool is still small enough that every member is inspectable.

**And it is falsifiable, which is the part that matters.** The per-input ablation is what measures whether each agent earns its vote. If the ablation shows an agent contributes nothing attributable, that is a reportable finding and the set shrinks. **The agent set remains provisional rather than settled**, which is the standing position across this project, and the ablation is the instrument that would settle it.

> The honest form of the claim: four agents is a design under test, not a result. If the pairwise error correlations come back high, the error-cancellation argument weakens accordingly and is reported as weakened.

---

## Part 2. Feasible boundaries

`[UPDATED 30 OCTOBER 2026]` Nine exclusions, each with a reason. The rubric rewards deliberate boundaries, and a boundary without a reason reads as something that was not reached.

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
| `[NARROWED 30 OCTOBER 2026]` A **validated** depth-conditioned execution-cost model | See the narrowing below. The model is designed and simulated, not validated, and the claim is cut to match |

> [!important]
> **`[NARROWED 30 OCTOBER 2026]` The execution-cost claim is cut to what the data can carry.** [[24-10-2026]] §7 lists this as **Critical**: sub-gap 1 proposes a nonlinear depth-conditioned execution-cost model while order-book and spread information are unavailable or unvalidated. §6.7 adds that a new market-impact model should not be developed unless data and novelty justify it.
>
> **What is claimed now.** A depth-conditioned cost function embedded **inside** the allocation objective rather than deducted after it, driven by illiquidity proxies, and evaluated under a **cost sensitivity sweep rather than a single assumption**. The contribution being claimed is the placement of cost inside the objective and the sweep around it, which is a design and evaluation claim that the available data fully supports.
>
> **What is no longer claimed.** A calibrated or validated market-impact curve. There is no order-book data on this market to fit one against and no quote data to check it with, which is why the spread estimator was demoted on 11 October. Any cost-curve shape reported is a **property of the simulation under stated proxy assumptions**, not a measurement of this market.
>
> **What would lift the narrowing.** The outstanding bid, ask and depth request to the exchange. If it is answered, validation becomes possible and the claim can be widened with evidence. If it is not, the narrowed claim stands and nothing collapses, because the proxy route was declared as the plan in advance rather than adopted after a failure.

**The priority rule behind all of it**, which is the supervisor's: stop trying to make every component novel, and make the main orchestration contribution exceptionally well evidenced, implemented and evaluated.

---

## Part 2a. The minimum viable research artefact, and what gets cut first

`[ADDED 30 OCTOBER 2026]` §6.7 asks for the minimum viable research artefact required to test the main contribution, for the primary baseline comparison to be prioritised over optional experiments, and for essential ablations to be separated from exploratory ones. It also names the danger this answers directly:

> The most important danger is that significant effort goes into the execution-cost model, financial RAG component or data-processing infrastructure, leaving insufficient time to evaluate the main research contribution.

### Required. Without any one of these there is no answer to the main question

| Component | Why it cannot be dropped |
|---|---|
| The **point-in-time data layer** with the as-of cursor | No result is admissible without it, and it cannot be retrofitted |
| The **common output contract** | Without it there is no weightable quantity, which is the gap itself |
| At least **two methodologically unlike agents** emitting the contract | Heterogeneity is the premise. Four is the design, two is the floor below which the question stops existing |
| The **state vector**, at minimum $L_t$ | $L_t$ is the input the main question is about |
| The **orchestration operator**, low-capacity form, with the abstention floor | This is the contribution |
| Arms $B_1$, $P$ and $B_3$ over byte-identical cached outputs | $B_1$ is the hardest benchmark and the pre-registered primary. **$B_3$ is required, not optional**, because without it the result cannot distinguish state conditioning from mere reactivity to recent agent performance, which is the objection that most threatens the claim |
| The **A3 sensitivity sweep** | The acceptance criterion the mechanism rests on |
| The **four per-input state ablations** | These make the answer attributable rather than a single number, which is what the main question asks for |
| Cost-adjusted return over the full window, with class balance and Matthews correlation on the same row | The metric the pre-registration names |

### Enhancement. Valuable, and droppable in this order

| Dropped first | What is lost |
|---|---|
| 1. The **persistence re-levering schedule**, sub-gap 2 | A supporting experiment that sits off the critical path entirely and runs on a published paper's own environment. Already cut once, from the proposal period |
| 2. The **oracle arm** $O$ | The estimation-cost reading. The result survives without it; the diagnosis of a null becomes coarser |
| 3. The **static learned arm** $B_2$ | One comparator. $B_3$ is the one that carries the threatening objection, so $B_2$ goes first of the two |
| 4. The **remaining five diagnostics**, FR10b | Depth of explanation, not the result |
| 5. The **cost term inside the objective**, sub-gap 1 | A contribution in its own right, which is why it is low on this list rather than off it |
| 6. The **fundamental agent built live** | Falls back to the stub, which keeps the framework four-agent and the ablation structure intact, reported as stubbed |

**$A_F$ sits last deliberately.** It is the component §6.7 warns could absorb the time, and it is also the one with the cleanest declared fallback, so it can be deferred late without the design changing shape.

### The rule, in one line

**Nothing proceeds past the required list until $B_1$ against $P$ has run end to end on cached outputs.** That ordering is what converts the warning above into a rule rather than an intention.

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
