---
status: current
revised: 2026-10-12
written_against: 59 reviews
tags:
  - working-doc
---
*Revised 12 October 2026 against all 59 literature reviews. Supersedes the 27 September version, which was written against 53. Sentiment is out of scope (supervisor, 20 September 2026, Final), see `Scope sentiment analysis dropped.md`. Claims narrowed in the previous revision are still marked **[narrowed]**. Claims changed in this revision are marked **[new]**.*

---

### What changed in this revision, in one place

Six reviews were added since the 53-paper version and three of them move the argument rather than decorating it.

| Change | Driver | Where it lands |
| --- | --- | --- |
| The main gap now has a named strongest objection and an answer to it | [[Forecast combinations, An over 50-year review]], the forecast combination puzzle | New section below, placed before the prior-work contrast |
| $C_{i,t}$ has a mechanism for every agent rather than for one | [[Adaptive Conformal Inference Under Distribution Shift]] for $A_V$, [[FinQA, A Dataset of Numerical Reasoning over Financial Data]] and [[ConvFinQA, Exploring the Chain of Numerical Reasoning in Conversational Finance Question Answering]] for $A_F$, [[HLOB – Information persistence and structure in limit order books]] for the common scale | Conditioning set table |
| Abstention is reclassified from a bespoke addition to named prior art, and the design changes with it | Time-varying subset selection, Li et al. 2022 via the combination review | Conditioning set table, abstention row |
| $L_t$ gains a construction recipe and a parsimony constraint | [[Predicting Financial Market Stress with Machine Learning]] | Conditioning set table, and the new parsimony section |
| Sub-gap 1's measurement half reopened | EDGE demoted to last resort on 11 October, Smart Trading Rule unobtainable | Sub-gap 1, both caveats stated together |
| The CSE justification is rebuilt on local evidence rather than on assertions about the Nasdaq | Supervisor, 29 September; evidence from the three CSE papers added for this purpose | Why the CSE section, rewritten |

The four-agent pool is still unchanged. Not one of the 59 notes proposes adding or removing an agent.

---

### Main gap, the orchestration problem

**The setup.** You have four agents, $A_T$ technical, $A_F$ fundamental, $A_V$ volatility, $A_L$ liquidity. Each looks at something different and produces a signal. Something has to turn several signals into one decision.

**What every existing system does.** [narrowed, and the narrowing made it stronger.] The old wording was "the combination rule is fixed at design time." That understates it. In most of these systems **there is no quantity that could be weighted in the first place.** TradingAgents combines through a one-sentence facilitator prompt. FinVision concatenates the analyst outputs into a single prompt. Park's system passes a free-text summary. There is no vector, no coefficient, nothing to make time-varying, so the question "how are the weights set?" does not have an answer to criticise.

Three unrelated designs arriving at the same non-mechanism is evidence about the field, not about three papers. The ACM CSUR review of 167 RL papers says it outright: coordination protocols among agents are underexplored.

**Why that is a problem.** An agent's reliability is not constant, it depends on what is happening and what data exists today. And the failure is worse than "weak signal," because these agents do not abstain. Ask $A_F$ about a counter whose last annual report is eleven months stale and it does not say "I don't know." It produces a confident number about nothing.

**Four documented cases, and the fourth is local. [new]**

- **FinAgent's auxiliary strategies on ETHUSD** returned 16% against buy-and-hold's 29%. Actively worse than doing nothing. They were tuned to US large-cap dynamics, the dynamics changed, and nothing in the design could notice.
- **AlphaAgents deleted an entire agent by hand** because its input channel was too thin across fifteen US megacaps. A human noticed and intervened. The system had no way to. Their thin channel was news, ours is filings. The structure of the failure is the same, and it is why the abstention channel is in the design rather than bolted on later.
- **Jung and Lee** measure a 10.36-point total-return degradation from a text agent the architecture cannot notice.
- **[new] Pavithya et al. (2021) on the CSE itself.** Two heterogeneous models, one shared decision, and a combination rule fixed once at three to one in favour of the text model because that model scored higher *in individual testing on a different and easier task*. The contrast is cleaner here than against any of the LLM systems, because this paper actually has an explicit weight vector to point at. Worse, the normalisation makes the realised influence depend on how many articles happened to appear that day, which is an availability-weighted scheme nobody designed and nobody analysed. Per the scope rules this is cited as a fixed-influence failure case, not as a component to rebuild.

That fourth case also settles a design question. **An agent's weight cannot be set from its own in-domain score.** It has to come from measured marginal contribution to the joint decision, by ablation on held-out windows. Pavithya et al. is the proof of what happens otherwise.

**What is missing.** Nothing in the reviewed set adapts an agent's influence to how reliable that agent is right now, as a function of measured conditions outside the agent.

---

### The strongest objection to the main gap, and the answer **[new]**

This belongs before the prior-work contrast, because it is a stronger objection than any of the five systems and it comes from a literature the agent papers do not cite.

**The objection.** [[Forecast combinations, An over 50-year review]] documents the **forecast combination puzzle**: across fifty years of evidence, the equally weighted combination is persistently hard to beat, and the usual reason sophisticated schemes lose is that weight-estimation error exceeds the gain from better weights. The review derives two guidelines that cut in opposite directions for this project:

1. With limited historical data, the simple average or weights ignoring covariances are recommended. My per-counter archive is 374 trading days, so this points at equal weights.
2. Structural change affects sophisticated schemes more than the simple average, and changing weights are a legitimate response to it. This is the entire premise of conditioning on state.

Which effect dominates on this data is the experiment. The review is explicit that there is no comprehensive quantitative guidance on when to choose which, so **an answer on a thin frontier market is a contribution even if the answer is that equal weights win.**

**Three things follow, and all three strengthen the position rather than weakening it.**

**First, the contribution now has a named lineage, which is a better framing than novelty.** The weighting function $w_{i,t} = f(L_t, V_t, P_t, C_{i,t})$ is a time-varying feature-conditioned linear combination, and this literature contains both halves separately: time-varying weights through the Kalman filter and smooth-transition line, feature-conditioned weights through FFORMA. **FFORMA is the nearest named ancestor and the difference is one sentence: its 42 features are properties of the series itself, computed once from the history, while mine are properties of the market state, measured at each step and exogenous to the agent being weighted.** That reads as a generalisation along an identified axis rather than as new machinery, and it is the framing to reuse.

**Second, equal weights is the field's hardest benchmark, which makes Baseline 1 the right baseline and raises the bar.** Say this out loud before anyone else does. If the state-conditioned weighting fails to beat equal weights on the CSE, that is the expected outcome under the field's prior, not a surprise.

**Third, the falsification conditions have to be pre-registered, and two new arms are needed.**

- **A discounted inverse-MSE arm.** Weights that merely react to recent agent performance, with no market state at all. This is the baseline that actually threatens the contribution: if reacting to recent performance does as well as conditioning on measured state, the state conditioning is not earning its place.
- **An oracle-weight arm.** Weights fitted on the test window itself. The gap between oracle and estimated performance is the estimation cost measured in my own data and my own units. No gain under oracle weights means the conditioning hypothesis is wrong. A gain under oracle but not under estimated weights means it is an estimation problem I can put a number on. One extra pass of the same pipeline.

The pre-registration has to separate two failure modes that look identical in the output: the weighting genuinely not helping, which is the field's prior, against the weighting helping and the two-step test being unable to see it. The first says abandon the conditioning, the second says change how it is estimated or tested. The review also warns that standard errors for a combined forecast are nontrivial because the weights are random and correlated with the forecasts, which is a direct warning about significance testing on the weighted output.

**One design decision this settles and one it changes.** It settles the absence of a pairwise interaction term: Bates and Granger, Newbold and Granger, and Winkler and Makridakis between them say ignoring error covariances is the better practical choice because covariance estimates are unstable, and with four agents the full matrix costs ten parameters out of 374 days. That is now a cited choice rather than a simplification. What it changes is the abstention floor, below.

---

### The five-way prior work contrast

Naming only MacroHFT is not a sufficient defence.

| System | Nearest on | Why it does not close the gap |
| --- | --- | --- |
| **HedgeAgents** | the mechanism itself, a genuinely solved constrained optimisation over an explicit weight vector | the weights are over **assets**, not agents. One agent per asset, one to one, so it never asks which *method* to trust. Threshold hand-set and never revisited |
| **MacroHFT** | continuous conditioning on market state | six **identical** DDQNs on one data stream. Conditioning without heterogeneity |
| **Jung and Lee** | a genuinely heterogeneous pool | a fixed prompt template sits exactly where the weighting should be. Degrades 10.36 points and cannot notice |
| **TRIAG** | an orchestrator that learns to coordinate | its state vector has **no environment block**. Carries a confidence field and never computes with it |
| **FFORMA** | **[new]** feature-conditioned weights, learned, over a heterogeneous pool | its features are properties of the series being forecast, computed once from history. Not exogenous, not measured per step, and not market state |
| **Automate Strategy Finding** | - | **demoted to Baseline 2.** The BlackRock survey nominates it as the field's adaptive gating mechanism; read the primary paper and it does selection, not weighting, and its weights carry no time index |

**The claim that survives all six.** Continuously vary the influence weight of *methodologically heterogeneous* agents, over a *single shared decision*, as a function of *measured exogenous market state*. Every clause is load-bearing. Drop "heterogeneous" and MacroHFT has it, drop "agents" and HedgeAgents has it, drop "measured exogenous state" and both TRIAG and FFORMA have it.

**One claim in that sentence is now testable rather than asserted. [new]** "Methodologically heterogeneous" is load-bearing, and the combination literature gives the operational definition of diversity: low correlation among component errors. So run it on my own pool. If $A_T$ and $A_V$ produce errors correlating at 0.8 on CSE data, the pool is less diverse than the architecture diagram implies and the error-cancellation argument weakens accordingly. This is nearly free, it uses data the individual agent runs produce anyway, and it is much better found by me than by an examiner. The corroborating worry is specific: [[Relationship between firm-level investment, idiosyncratic risk and ownership, an emerging market perspective]] suggests checking the correlation between the idiosyncratic risk estimate and turnover, because if those move together then $A_V$ and $A_L$ are partly measuring the same thing and the state vector has a collinearity problem.

---

### Why the CSE, rebuilt on local evidence **[new, rewritten]**

The supervisor's instruction on 29 September was to stop resting this on assertions such as "on the Nasdaq every counter has deep liquidity" and to rest it instead on local evidence, framing the CSE as a **frontier-market stress-test environment** rather than as scientifically unique. That reframing is correct and it is also easier to defend. The evidence:

- **Most CSE counters do not trade every day.** [[Relationship between firm-level investment, idiosyncratic risk and ownership, an emerging market perspective]] estimates a factor model on CSE firms and moves to weekly data for that reason. A finance journal making that choice is a stronger warrant than anything available from the ML literature, and it is the direct argument for a per-counter liquidity screen that produces abstentions rather than stale-price signals.
- **Illiquidity shocks are a first-order effect on returns here.** Dissanayake and Nanayakkara find unexpected illiquidity shocks depress CSE returns significantly at $-0.084$ to $-0.097$, small caps more than large.
- **Liquidity leads the index and macro does not.** Granger causality runs from trading volume to the ASPI at $p = 0.0041$, while money supply and inflation reach nothing.
- **The relationships are not stable across the window a static system would be evaluated on.** Two independent CSE results point the same way: the traditional macro linkages break over 2014 to 2022, and the 2021 extension in the Fernando study weakens the main coefficient from $-0.232$ to $-0.123$. This is the clearest empirical case for an orchestrator that conditions on measured state rather than a fixed rule.
- **The fundamental channel is structurally thin, not occasionally thin.** Three separate CSE studies hand-collected their fundamentals from annual report PDFs, two of them with institutional access, 167 firms with usable accounting data in one and 200 firm-years in another. And Pavithya et al. had the exchange's own announcement feed in 2021 and had to abandon it as too thin to train on. That is what prices the retrieval problem and why $A_F$ is designed for a channel that is frequently absent.
- **Volatility clusters and three CSE papers measure it and stop.** ARCH statistic 86.55 on the ASPI, addressed only with robust standard errors.
- **Free float is a fraction of capitalisation.** Mean institutional ownership of 66.1% against insider ownership of 5.7%, so order size against available depth is worse than a capitalisation-based estimate suggests. The participation-rate sweep has to be calibrated against float rather than shares outstanding.

Two structural breaks sit inside the window and both need stating in the methodology rather than discovering in an ablation: **SLFRS 16 in 2019** makes any lease-sensitive or PPE-derived fundamental feature non-comparable across that boundary, and the **nominal price distortion across 2020 to 2023** means rupee-denominated features need deflating or expressing as ratios.

The honest form of the argument is this. Reliability varies more here than on a deep market, and the above is the measured evidence for that, on this market, rather than an assertion about another one.

---

### Sub-gap 1, what a trade actually costs

**The question.** When you decide to trade, what does it cost you?

**What existing systems assume.** Most: nothing, fill at the close. Better ones: a flat percentage, MacroHFT 0.02%, Kashif and Slepaczuk 2bps. FreQuant charges 33 to 40bps and solves the genuinely hard part, that the fee reduces capital which changes the weights which changes the fee.

**[narrowed.] The old claim was that nobody models cost as a function of order size against depth. That is no longer defensible.** Two papers do:

- **Chen et al. (ICAIF '22)** build a queue-reactive LOB simulator and quantify the error from ignoring impact at 3.04 bps.
- **Wang, Gao and Li (Finance and Stochastics, 2026)** implement Almgren-Chriss in closed form. **This is the 2026 market-impact work the supervisor cited.** They were right, that open item is closed.

**What survives, narrower but cleaner.** Four things, and the fourth matters most:

1. Both existing treatments use a **linear or square-root** impact form. Neither tests a nonlinear one against data.
2. **No participation-rate sweep anywhere.** Chen et al. run everything at one inventory and horizon, Wang et al. everything at 10% of ADTV, so the shape of the cost curve in order size is empirically untested across the set.
3. **No thin-book calibration.** Both are calibrated on deep markets, universes trading two to 115 million shares a day. A frontier market's book is a different object.
4. **No allocation system puts cost inside the objective.** Every one deducts it afterwards. If the cost of a rebalance does not enter the function being optimised, the optimiser has no reason to prefer a cheaper path to the same position. Guo et al.'s transaction remainder factor is the container that lets a cost term stay inside a convex objective, and substituting a state-dependent cost into it is the constructive move.

Novelty **3**, down from 3.5 to 4. That is a fair rating and it should be offered before anyone asks.

**Two caveats, and they must be stated together. [new]**

**(1) A potentially overlapping paper could not be obtained.** *Smart Trading Rule: A Modular Machine Learning Framework for Portfolio Optimization with Transaction Costs*, Journal of Financial Data Science 8(2), 2026, was identified, judged relevant to the modular transaction-cost layer, and is paywalled. Its contents are unknown to me. The supervisor's position on 29 September was that it may materially narrow this sub-gap and that the sub-gap should not be defended as final until it had been read. Removing its row from the matrix removed the reminder, not the risk. So Sub-gap 1 is not presented as though the literature had been fully swept.

**(2) The measurement half is open again.** The v5 answer to the CSE's missing quote data was EDGE, the Ardia, Guidotti and Kroencke effective-spread estimator from daily OHLC. On 11 October it was **demoted to last resort and may never be used**. The reason is not availability, the method is public, free and runs on data I hold. The reason is that **it is unvalidated on thin and frontier markets**: the paper's empirical work is CRSP and TAQ US equities plus a Binance section with no quote benchmark at all, so no emerging or frontier market appears anywhere in it, and its own numbers put it at its weakest exactly where the CSE sits, 25.63% of daily-price estimates non-positive and 41% of large-cap stock-months negative before truncation. The CSE has no quote data to check the output against, so an EDGE spread here **could not be falsified even in principle**, which is worse than having no number because a number invites use.

So the cost term rests on proxies for illiquidity, Amihud, turnover, zero-return frequency and the high-low range, rather than on any measurement of what a trade pays. Say that in the write-up rather than leaving it to be found. **The practical effect is that the CSE request for bid and ask and depth is no longer a validation extra. It is the only route to a measured spread, and it should be pressed as the priority item in that request.**

**Three things survive from EDGE at no cost, and they are worth keeping separate from the estimator. [new]**

- **The infrequent-trading bias result.** Below roughly ten trades a day Corwin-Schultz returns zero and Abdi-Ranaldo is materially biased. This is citable external evidence that thin-book calibration is a real problem rather than a rhetorical one. Cite it to the simulation and word it accordingly: low-frequency spread estimators assuming continuous observation are demonstrably biased toward zero at trade counts in the range the CSE occupies.
- **The $\tau_t$ rate**, the fraction of days on which the open or close coincides with the high or low. This needs no estimator, no benchmark and no minimum observation count. It is a count over the price series, so it is falsifiable in the way the estimator is not, and it is a candidate staleness measure cleaner than zero-return frequency because it separates a counter that traded in a narrow range from one that did not trade at all.
- **The frequency result.** A month of minute prices is worth vastly more to a cost model than a year of daily prices, roughly $390^{3/2}$ against $\sqrt{252/21}$. If any intraday CSE feed exists at any granularity it is worth more than extending the daily archive backwards. That is a question for the supervisor regardless of what happens to EDGE.

**The screening rule this produced, and it generalises. [new]** Do not adopt a measurement whose output cannot be checked against anything observable on the market it will be applied to. Applied consistently it is uncomfortable rather than convenient: the volatility estimator is in a related position, since five-minute realised volatility is unavailable here. The difference is one of degree and it should be stated: a range-based volatility estimator can at least be scored against realised squared returns on the same daily series, where an effective spread has no observable counterpart on the CSE at any frequency. That distinction belongs in the methodology chapter as a stated screening rule.

**A cheap go or no-go test that comes before all of this. [new]** [[HLOB – Information persistence and structure in limit order books]] organises everything by tick-size class, defined relative to the spread rather than the price: large-tick means the spread is pinned near one tick and the book is compact and learnable, small-tick means the spread spans many ticks and "level 3" stops referring to a fixed distance from the touch. Computing $\langle\sigma\rangle / \theta$ needs only best bid, best ask and the exchange tick schedule. If the liquid CSE counters come out small-tick, HLOB's own small-tick results at the longest horizon, MCC 0.05, are the expected ceiling and the microstructural route closes at almost no cost. **Run this before committing to any microstructural component, and before the data-depth question rather than after it.**

**The part that connects upward.** This is not a separate topic. The same measurement that tells you what a trade costs also tells you how much to trust a price-derived signal, because in a thin market the price series feeding $A_T$ is itself noisier. One measurement, two uses. On the CSE it has a third: volume Granger-causes the index at $p = 0.0041$, so liquidity is a state variable here in a way it demonstrably is not everywhere.

---

### Sub-gap 2, how long a shock lasts

**The distinction that matters.** Two different things about volatility:

- **Level**: how violent is it right now? Standard GARCH gives you this.
- **Persistence**: how slowly does a shock decay? This is what FIGARCH's *d* measures.

Standard GARCH assumes shocks decay exponentially, so fast. Long memory means hyperbolic decay: slow, lingering after the event has technically passed.

**[narrowed.] The old claim covered both halves. It should not have.** *Deep Learning for Portfolio Optimization* already operationalises volatility **level**, daily, through a target-volatility scaler $\sigma_{tgt} / \sigma_{i,t-1}$. Worse for the old wording: that scaler is not learned, and it does most of the risk work in the paper, Sharpe going 0.929 to 1.526. So "nobody operationalises volatility" is wrong, and a reader who knows that paper will say so.

**What survives is the persistence half, and it now has a named target.** An EWMA half-life assumes exponential decay. That is precisely the assumption the CSE long-memory result contradicts, so after a shock the scaler re-levers on a schedule that is too fast and exposure returns while the shock is still decaying hyperbolically. The claim is not "volatility is ignored," it is that the one component doing the risk work assumes a decay shape the local data says is wrong. The original authors concede the opening themselves, their conclusion noting that the volatility estimates are lagged and proposing forward volatility inference as future work, so this answers a stated future-work item rather than inventing a grievance.

Rating holds at **3.5**.

**What the CSE literature established.** Riyath finds long memory on the ASPI and SL20 across all three regimes. Samarawickrama and Pallegedara find persistence close to 1. Three CSE papers detect volatility clustering and address it only with robust standard errors.

**A mechanism-level reason to expect slow decay, independent of the statistics. [new]** [[Relationship between firm-level investment, idiosyncratic risk and ownership, an emerging market perspective]] finds that a one standard deviation rise in idiosyncratic risk cuts firm capital spending by 17.48% of the mean investment rate. If a volatility shock propagates into fundamentals with a lag measured in reporting periods, the real activity it suppresses takes just as long to come back. That is a better sentence for the proposal than another citation of a $d$ estimate, because it gives a reason rather than a measurement.

**What the agent literature does for risk.** FinCon: CVaR on realised PnL, backward-looking. FinHEAR: samples risk sensitivity from a hand-set Beta, assumed rather than measured. FinMem: a three-day return sign test. AlphaAgents: a prompt adjective. FinAgent: reports six risk metrics and feeds none of them back.

**So the gap is a disconnection.** There is a measured quantity on one side and a decision that needs it on the other, and nothing joins them. After a shock, a GARCH-calibrated risk layer thinks things have normalised while they have not, which on a market that took the Easter attacks, COVID and the 2022 crisis in sequence is a real failure mode.

**The subtlety the supervisor was right about.** *d* is slow-moving by construction. It is not a daily trading signal. So you pair it with a forecast conditional variance: **variance says how bad now, persistence says how long.** Together they set a *decay schedule* on exposure rather than a point-in-time cap.

**The honest limit.** Lahmiri and Bekiros found persistence does not distinguish crypto from equities. So you cannot argue the CSE is special *because of* its persistence. You argue the quantity is operationally useful, not that it is unusual here.

**The part that unblocks you.** Because the target is now a named component of a published system, **you can test this before you have any CSE data at all.** Swap the EWMA half-life for a persistence-aware decay schedule on that paper's own four-ETF setup and see whether the Sharpe improves. If it does, you have a result independent of the data-access question. Run it first.

**Status, stated honestly.** Per the supervisor on 29 September, until that experiment exists this is a strong **hypothesis**, not a demonstrated contribution. Say it that way.

---

### What the orchestrator actually conditions on

The weighting function is $w_{i,t} = f(L_t, V_t, P_t, C_{i,t})$ and every term is settled.

| Term | Status after 59 reviews |
| --- | --- |
| **$L_t$** liquidity | **Keep**, strengthened, volume to ASPI Granger at $p = 0.0041$. **[new]** Construction upgraded from a single Amihud number to a composite built on the BIS market-condition-indicator recipe: sign every input so higher means worse, z-score, take the first principal component over an expanding window starting from a three-year block, re-normalise. Inputs are Amihud, turnover ratio, zero-return frequency, the high-low range, and $\tau_t$ as a candidate. This costs nothing that is not already being computed for the cost model |
| **$V_t$** volatility | **Keep**, estimator pinned. Parkinson or Garman-Klass, since five-minute realised volatility is unavailable on this market |
| **$P_t$** persistence | **Keep**, now locally evidenced rather than assumed, and with a mechanism-level reason behind the statistics |
| **$C_{i,t}$** confidence | **Redefined, and now specified for all four agents. [new]** Not a self-report, a *structural* property of the output. $A_F$: does the extracted program parse, does every argument trace to a retrieved figure, how many steps (step count is a calibrated difficulty proxy at 67.61 / 59.08 / 22.78 per cent for one, two and three-plus steps). $A_V$: wrap the FIGARCH or GJR-GARCH forecast in adaptive conformal inference and let $C_{V,t}$ be a function of realised interval width at the target coverage, so a drifted model reports wider intervals and is automatically down-weighted. $A_T$: Theil's U2 against the random walk. **Across all four**, map each agent's raw score through its own empirical accuracy-at-threshold curve estimated on a rolling validation window, which lands every agent in the same unit, probability of being right at the score just emitted. $p_\text{T}$, round-trip practicability, is a second cross-architecture candidate computable for anything emitting a directional view |
| **Abstention** | **Kept, reclassified, and the design changed. [new]** This is **time-varying subset selection**, named prior art, achieved by applying a threshold to a time-varying weighting scheme (Li et al. 2022). Present it in that vocabulary. Two consequences. The combination literature calls subset selection scantly attended to and mostly ad hoc, so a principled rule driven by a structural property of the output is defensible ground. And Geweke and Amisano's finding that individually poor forecasts can still help in combination is an argument for **shrinking an abstaining agent's weight toward a floor rather than driving it to exactly zero**, which reverses the earlier design decision. Unparseable output remains a fourth outcome state feeding a hard zero, which is a different case |
| **Macro block** | **Rejected.** ARDL gives adjusted $R^2 = 0.189$ on five macro variables over a decade, with Granger nulls for money supply and inflation. Not worth an agent. One caveat: USD/LKR leads the index at a two-month lag, $p = 0.0015$, so if any macro variable is carried it is that one, as a slow lagged feature into $A_F$'s context, not as a fifth agent |

**Candidates, pre-registered as tests rather than adopted components.** Pairwise conflict score. Distribution-shift estimate, now with a concrete method attached: the adapted miscoverage level $\alpha_t$ from adaptive conformal inference is a continuous state variable rather than an alarm, with no threshold to hand-tune. **[new]** A market-wide $L_t$ alongside the counter-level one, which is the cross-sectional analogue of the BIS cross-market spillover finding. **[new]** An information filtering network computed over the *agents' output signals* rather than over price levels, which would give the orchestrator a filtered dependency graph among components and a principled way to notice when two supposedly independent agents have started agreeing for the same reason.

State that these are pre-registered tests, so nobody thinks they were quietly dropped.

---

### The parsimony constraint, and a scoping test that comes first **[new]**

[[Predicting Financial Market Stress with Machine Learning]] is a BIS working paper doing, at market level and monthly, something close to what $L_t$ and $V_t$ are supposed to be. Two results from it constrain this design directly.

**The parsimony warning.** Eighty-four monthly observations against 44 predictors produced a model that beat its benchmark **in-sample everywhere and lost out-of-sample everywhere**, at monthly frequency on the deepest markets in the world. The conditioning set here is four state variables plus a per-agent confidence term, which is far smaller, but the training sample is 374 trading days per counter and the pressure to widen the state vector as reviews suggest additions is exactly what produced that result. **The commitment is that any proposed addition to $f(L_t, V_t, P_t, C_{i,t})$ has to beat the existing set out-of-sample on the ablation protocol, not in-sample, and the static learned-weight baseline stays in as the shrinkage-equivalent control.**

**The scoping test, and it comes before the agent build.** In that paper the forest beat a one-lag quantile AR in two markets out of three, and the market where it failed was the Treasury market, the one whose state is least predictable from anything other than itself. The CSE analogue is a direct check: **if a quantile AR(1) on $L_t$ is as good as anything richer, the orchestrator conditions on the lag and the state-forecasting machinery is dead weight.** That is a cheap test and it should be run before anything is built on top of it.

**A refinement worth testing rather than assuming.** Their framing is that the useful question is the 90th percentile of stress three months out, not the expected level. An orchestrator that down-weights $A_T$ when liquidity is already bad is *reacting*; one that down-weights it when the upper tail of the liquidity state is forecast to widen is *anticipating*. The horizon does not transfer, theirs is a policy horizon and mine is days to a few weeks, so the honest version is a named experiment: test a short-horizon quantile forecast of $L_t$ on CSE data and report whether it beats the contemporaneous value as a conditioning input.

**Two methodological habits to adopt from it at near-zero cost.** Run the full-sample PCA alongside the rolling one and plot both, which produces direct evidence of how much look-ahead bias a naive construction would have injected. And report attribution only for components whose out-of-sample performance clears their own benchmark, since SHAP explains what the model does, not what the market does.

---

### How the three fit

This is the part worth internalising, because it is what makes it one thesis rather than three.

**The main gap is the mechanism. The sub-gaps are the two inputs it runs on.**

- **Liquidity state** gives you what a trade costs, *and* how much to trust price-derived signals
- **Persistence plus forecast variance** gives you how much exposure to take, *and* how long to keep it reduced

So the sub-gaps are not supporting work that happens to be nearby. They are the content of the state the orchestrator conditions on. Strip them out and the main gap is an empty function signature, "weights depend on market state" with nothing specified about which state or why those variables.

That is also why the ordering in the matrix matters: if either sub-gap fails to produce a usable signal, the main gap loses one of its two legs.

**What changed about that risk.** It is smaller than it was. Sub-gap 2 is testable on someone else's published setup before any CSE data arrives. The per-counter archive is 374 trading days across roughly 300 counters, about 100,000 training sequences at a 30-day lookback, and a four to five day lookback is better supported by the only local evidence on window length, which would yield far more. The index track, ten years daily from 1 July 2014 to 30 June 2024, was never in doubt. The binding question was never *how many years exist*, it is **how many counters clear a liquidity screen**, and that is answerable from data already in hand.

**One new constraint on that.** Adaptive conformal inference, the method behind $C_{V,t}$, is calibrated in its source on a 1250-day refit window with calibration scores from the same window. Five years of daily data per counter against 374 days in the archive. On the index track it transfers as written; on the per-counter track it does not, and the honest options are a shorter joint window with the calibration degradation reported, or pooling scores across counters, which breaks the per-counter conditioning the method relies on. This belongs in the data-depth discussion as a named requirement with a number attached.

---

### The evaluation commitments this note implies

Collected in one place because they are now scattered across six reviews.

1. **Baselines, five arms not three.** Equal weight. Static learned weight (Automate Strategy Finding is the reference implementation). Discounted inverse-MSE performance weighting, no market state. State-conditioned, the proposal. Oracle weights fitted on the test window. Plus a Stock and Watson inverse-$k$ sweep, which is one parameter and maps the whole continuum from equal weights to winner-take-all.
2. **Baseline 2 must be identical to the proposed system in every respect except the weighting function.** The CSE Graph-RAG paper's fatal flaw is that its proposed system got both the graph and the agent scaffolding while its baseline got neither. Do not reproduce it.
3. **Ablate one state input at a time**, so each one's contribution is attributable. $A_F$ on and off inside the full framework is required, not optional.
4. **Pre-registered diagnostics**: weight-distribution entropy over time, agent error correlation, and the oracle gap.
5. **Report quiet sub-periods separately from crisis windows.** The trap is an orchestrator whose weights move impressively in the two or three most volatile CSE months and are inert the rest of the time. A better loss on a state variable is not a better decision.
6. **Evaluate abstention economically or not at all.** Return per traded day, total return with abstained days held flat, and cost per turn, alongside the coverage-accuracy pair. State the abstained-day exposure policy explicitly, hold or go flat, since the flat option carries a round-trip cost each time.
7. **Every directional result carries class balance, Matthews correlation and cost-adjusted return on the same row.** Accuracy 0.5837 at MCC 0.1493 is the local example of why.
8. **Equalise trade counts before comparing**, report exposure time, holding period and turnover, and commit to dispersion and a paired significance test before seeing numbers.
9. **Release the pipeline.** Three documented instances now exist in the reviewed set of published financial ML results that cannot be checked as published, the latest being five of six baselines reimplemented in HLOB because original code was unavailable.

---

### How to say it in one paragraph

> Multi-agent LLM trading systems combine their agents' outputs through a fixed rule, and in most cases through no explicit rule at all, just a prompt that concatenates them. That is fine when every agent is roughly equally reliable, which is roughly true on a deep market with continuous disclosure. On a frontier market it is not: liquidity dries up, filings go stale, and an agent whose input has vanished still returns a confident answer. I am building an orchestrator that varies each agent's influence continuously as a function of measured market state, liquidity, volatility, volatility persistence, and a structural confidence score, and I am testing it against an equal-weight baseline, a static learned-weight baseline, and a performance-reactive baseline that sees no market state at all, with each state input ablated so the contribution of each one is attributable. The nearest named ancestor is feature-conditioned forecast combination, and the difference is that its features are properties of the series being forecast while mine are exogenous properties of the market, measured at each step. The two sub-gaps supply that state: one measures what a trade costs against available depth, the other measures how long a volatility shock actually takes to decay.

---

### Language discipline, unchanged

**Two things to never say.** No "first / nobody / never / no dataset exists." The permitted form is *"I have not found that evaluation in the literature I have covered"*, or bounded in the first person, *"the first concrete answer I have."* And no sentiment component, in any form, anywhere.

**The gap statement has a shelf life.** The Agentic Trading snapshot closed on 2026-03-09 with 18 of 19 primary studies from 2024 onward, so any claim about what the literature does not report carries that cutoff. Attach it explicitly and re-check before submission.

**Related notes.** [[Contribution to Knowledge]] states what this produces rather than what the literature lacks. [[ELI5 - The Whole Project in Plain English]] is the same material without the jargon.
