---
status: current
revised: 2026-10-22
written_against: 59 reviews
tags:
  - working-doc
  - supervisor-facing
---
## Main gap, the orchestration problem

Four agents, $A_T$ technical, $A_F$ fundamental, $A_V$ volatility, $A_L$ liquidity. Each produces a signal, and something has to turn several signals into one decision.

In the systems I have reviewed, that combination is fixed at design time, and in most cases there is no quantity that could be weighted in the first place. TradingAgents combines through a one-sentence facilitator prompt, FinVision concatenates analyst outputs into a single prompt, Park's system passes a free-text summary. There is no vector and no coefficient, so the question "how are the weights set" has no answer to criticise. The ACM CSUR review of 167 RL papers states it directly: coordination protocols among agents are underexplored.

This matters because an agent's reliability is not constant. It depends on what the market is doing and on what data exists today. The failure mode is worse than a weak signal, because these agents do not abstain: ask $A_F$ about a counter whose last annual report is eleven months stale and it returns a confident number about nothing.

### Five documented cases

- **FinAgent's auxiliary strategies on ETHUSD** returned 16% against buy-and-hold's 29%, tuned to US large-cap dynamics that then changed, with nothing in the design able to notice.
- **AlphaAgents deleted an entire agent by hand** because its input channel was too thin across fifteen US megacaps. A human noticed and intervened; the system had no way to. Their thin channel was news, mine is filings, and the structure of the failure is the same.
- **Jung and Lee** measure a 10.36-point total-return degradation from a text agent the architecture cannot notice.
- **Pavithya et al. (2021), on the CSE itself.** Two heterogeneous models, one shared decision, combination fixed once at three to one in favour of the text model because that model scored higher in individual testing on a different and easier task. The normalisation also makes realised influence depend on how many articles appeared that day, which is an availability-weighted scheme nobody designed and nobody analysed. Cited as a fixed-influence failure case, not as a component to rebuild.
- **[[PIXIU, A Comprehensive Benchmark, Instruction Dataset and Large Language Model for Finance|PIXIU]]** documents the complementary failure, where the agents cannot fail independently in the first place. FinMA-7B-trade scores 0.03 F1 on FPB against 0.94 for its NLP-tuned sibling, 0.16 against 0.85 on FiQA-SA, and MCC 0.03 on ACL18, the task it was specialised for. My reading is that this is the documented case for keeping the four agents architecturally separate, scoped to one backbone, one instruction set and one benchmark suite rather than carried as a general result about shared backbones.

Pavithya et al. also settles a design question: an agent's weight cannot be set from its own in-domain score. It has to come from measured marginal contribution to the joint decision, by ablation on held-out windows.

### What is missing

Nothing in the literature I have covered adapts an agent's influence to how reliable that agent is right now, as a function of measured conditions outside the agent.

### The claim that survives the prior-work contrast

Continuously vary the influence weight of *methodologically heterogeneous* agents, over a *single shared decision*, as a function of *measured exogenous market state*.

Every clause is load-bearing.

| System | Nearest on | Why it does not close the gap |
| --- | --- | --- |
| **HedgeAgents** | a solved constrained optimisation over an explicit weight vector | the weights are over **assets**, one agent per asset, so it never asks which *method* to trust |
| **MacroHFT** | continuous conditioning on market state | six **identical** DDQNs on one data stream. Conditioning without heterogeneity |
| **Jung and Lee** | a genuinely heterogeneous pool | a fixed prompt template sits where the weighting should be. Degrades 10.36 points and cannot notice |
| **TRIAG** | an orchestrator that learns to coordinate | its state vector has **no environment block**. Carries a confidence field and never computes with it |
| **FFORMA** | feature-conditioned learned weights over a heterogeneous pool | its features are properties of the series being forecast, computed once from history. Not exogenous, not measured per step, not market state |
| **Automate Strategy Finding** | nominated by the BlackRock survey as the field's adaptive gating mechanism | the primary paper does selection, not weighting, and its weights carry no time index. Demoted to Baseline 2 |

### Lineage rather than novelty

The weighting function is a time-varying feature-conditioned linear combination, and the forecast combination literature contains both halves separately: time-varying weights through the Kalman filter and smooth-transition line, feature-conditioned weights through FFORMA. FFORMA is the nearest named ancestor, and the difference is one sentence: its 42 features are properties of the series itself, computed once from history, while mine are properties of market state, measured at each step and exogenous to the agent being weighted.

[[Empirical Asset Pricing via Machine Learning|Gu, Kelly and Xiu]] support the premise independently, interacting 94 stock characteristics with eight macro state variables inside a single estimator through a Kronecker construction derived from the beta-pricing relation. Where mine differs is two clauses: their interaction weights are re-estimated once per annual refit and so do not vary at decision time, and they are weights on characteristics inside one model rather than on separate producers of a shared decision.

### The strongest objection, stated before anyone else states it

[[Forecast combinations, An over 50-year review|The forecast combination puzzle]]: across fifty years of evidence the equally weighted combination is persistently hard to beat, and the usual reason sophisticated schemes lose is that weight-estimation error exceeds the gain from better weights. Equal weights is therefore the field's hardest benchmark, which makes Baseline 1 the right baseline and raises the bar. If the state-conditioned weighting fails to beat equal weights on the CSE, that is the expected outcome under the field's prior rather than a surprise.

The review is explicit that there is no comprehensive quantitative guidance on when to choose which, so an answer on a thin frontier market is a contribution even if the answer is that equal weights win. Which effect dominates on this data is the experiment.

The falsification conditions are pre-registered, and the pre-registration has to separate two failure modes that look identical in the output: the weighting genuinely not helping, which is the field's prior, against the weighting helping and the two-step test being unable to see it. The first says abandon the conditioning, the second says change how it is estimated or tested.

### Why the CSE, as a frontier-market stress-test environment rather than a unique one

- **Most CSE counters do not trade every day.** [[Relationship between firm-level investment, idiosyncratic risk and ownership, an emerging market perspective|A local factor-model study]] moves to weekly data for that reason, which is the direct argument for a per-counter liquidity screen producing abstentions rather than stale-price signals.
- **Illiquidity shocks are a first-order effect on returns.** Dissanayake and Nanayakkara find unexpected illiquidity shocks depress CSE returns at $-0.084$ to $-0.097$, small caps more than large.
- **Liquidity leads the index and macro does not.** Granger causality runs from trading volume to the ASPI at $p = 0.0041$, while money supply and inflation reach nothing.
- **The relationships are not stable across the window a static system would be evaluated on.** Traditional macro linkages break over 2014 to 2022, and a 2021 extension weakens a main coefficient from $-0.232$ to $-0.123$.
- **The fundamental channel is structurally thin, not occasionally thin.** Three separate CSE studies hand-collected fundamentals from annual report PDFs, 167 firms with usable accounting data in one and 200 firm-years in another, and Pavithya et al. had the exchange's own announcement feed in 2021 and abandoned it as too thin to train on.
- **Volatility clusters and three CSE papers measure it and stop.** ARCH statistic 86.55 on the ASPI, addressed only with robust standard errors.
- **Free float is a fraction of capitalisation.** Mean institutional ownership of 66.1% against insider ownership of 5.7%, so order size against available depth is worse than a capitalisation-based estimate suggests.

Two structural breaks sit inside the window and both belong in the methodology rather than in an ablation: **SLFRS 16 in 2019**, which makes lease-sensitive and PPE-derived fundamental features non-comparable across that boundary, and the **nominal price distortion across 2020 to 2023**, which means rupee-denominated features need deflating or expressing as ratios.

The honest form of the argument is that reliability varies more here than on a deep market, and the above is the measured local evidence for that rather than an assertion about another market.

---

## Sub-gap 1, what a trade actually costs

**What existing systems assume.** Most assume nothing and fill at the close. Better ones charge a flat percentage, MacroHFT 0.02%, Kashif and Slepaczuk 2bps. FreQuant charges 33 to 40bps and solves the genuinely hard part, that the fee reduces capital which changes the weights which changes the fee.

Two papers do model cost against depth: **Chen et al. (ICAIF '22)**, a queue-reactive LOB simulator quantifying the error from ignoring impact at 3.04 bps, and **Wang, Gao and Li (Finance and Stochastics, 2026)**, implementing Almgren-Chriss in closed form. The second is the 2026 market-impact work the supervisor cited, and that open item is closed.

### What survives, five claims

1. Both existing treatments use a **linear or square-root** impact form. Neither tests a nonlinear one against data.
2. **No participation-rate sweep in the reviewed set.** Chen et al. run everything at one inventory and horizon, Wang et al. everything at 10% of ADTV, so the shape of the cost curve in order size is empirically untested across the set.
3. **No thin-book calibration.** Both are calibrated on deep markets, universes trading two to 115 million shares a day. A frontier market's book is a different object.
4. **No allocation system puts cost inside the objective.** Every one deducts it afterwards. If the cost of a rebalance does not enter the function being optimised, the optimiser has no reason to prefer a cheaper path to the same position. Guo et al.'s transaction remainder factor is the container that lets a cost term stay inside a convex objective, and substituting a state-dependent cost into it is the constructive move.
5. **The passive side is absent across all three execution papers.** They are market-orders-only: no spread capture, no queue position, no partial fills, no cancellation, no fees. On a book where the spread is a large share of the round trip, that is not a detail, and it is the part of the cost model the CSE data request would make measurable.

**The cleanest reference case for why this sub-gap exists** is Gu, Kelly and Xiu. Their best strategy is an equal-weighted decile spread returning 3.3% per month at an out-of-sample Sharpe of 2.35, with monthly turnover of 114.08%, on a universe retaining sub-$5 stocks by explicit choice, and there are no transaction costs anywhere in the paper. Their own results bound what that leaves out: value weighting alone, with no costs introduced, drops NN3's Sharpe from 2.32 to 1.25 and OLS-3's from 0.89 to 0.27, which is a partial and unacknowledged cost estimate. Liquidity appears there as a predictor family and is absent as a friction, which is the division of labour this sub-gap sits inside.

**One design consequence.** Prefer a learned friction component over naive calibrate-then-plug-in. Wang et al. supply the evidence against their own route: estimation error in the impact parameters is amplified through the closed-form control, their statistically calibrated variant turning in $-905.742$ on AAPL at high risk aversion against the learned variant's $+102.285$. That is their result on their data, and the transfer argument is directional rather than calibrated: on CSE data the estimation error in those parameters would be worse rather than better.

### Two caveats, stated together

**(1) A potentially overlapping paper could not be obtained.** *Smart Trading Rule: A Modular Machine Learning Framework for Portfolio Optimization with Transaction Costs*, Journal of Financial Data Science 8(2), 2026, was identified, judged relevant to the modular transaction-cost layer, and is paywalled. Its contents are unknown to me. This sub-gap is therefore not presented as though the literature had been fully swept.

**(2) The measurement half is open.** EDGE, the Ardia, Guidotti and Kroencke effective-spread estimator from daily OHLC, is demoted to last resort and may never be used. The reason is not availability. It is that the method is unvalidated on thin and frontier markets: the empirical work is CRSP and TAQ US equities plus a Binance section with no quote benchmark, so no emerging or frontier market appears anywhere in it, and its own numbers put it at its weakest exactly where the CSE sits, 25.63% of daily-price estimates non-positive and 41% of large-cap stock-months negative before truncation. The CSE has no quote data to check the output against, so an EDGE spread here could not be falsified even in principle, which is worse than having no number because a number invites use.

So the cost term rests on proxies for illiquidity, Amihud, turnover, zero-return frequency and the high-low range, rather than on any measurement of what a trade pays. The practical effect is that the CSE request for bid, ask and depth is the priority item rather than a validation extra.

### The screening rule this produced

Do not adopt a measurement whose output cannot be checked against anything observable on the market it will be applied to. Applied consistently it is uncomfortable rather than convenient, since five-minute realised volatility is also unavailable here. The difference is one of degree: a range-based volatility estimator can at least be scored against realised squared returns on the same daily series, where an effective spread has no observable counterpart on the CSE at any frequency.

### The part that connects upward

The same measurement that tells you what a trade costs also tells you how much to trust a price-derived signal, because in a thin market the price series feeding $A_T$ is itself noisier. One measurement, two uses. On the CSE it has a third: volume Granger-causes the index at $p = 0.0041$, so liquidity is a state variable here in a way it demonstrably is not everywhere.

Self-assessed novelty **3**.

---

## Sub-gap 2, how long a shock lasts

**The distinction that matters.** **Level**, how violent it is right now, which standard GARCH gives. **Persistence**, how slowly a shock decays, which FIGARCH's $d$ measures. Standard GARCH assumes shocks decay exponentially. Long memory means hyperbolic decay, slow and lingering after the event has technically passed.

**Level is already operationalised, so the claim is only about persistence.** *Deep Learning for Portfolio Optimization* runs a daily target-volatility scaler $\sigma_{tgt} / \sigma_{i,t-1}$. That scaler is not learned and it does most of the risk work in the paper, Sharpe going 0.929 to 1.526.

**What survives is the persistence half, and it has a named target.** An EWMA half-life assumes exponential decay, which is precisely the assumption the CSE long-memory results contradict, so after a shock the scaler re-levers on a schedule that is too fast and exposure returns while the shock is still decaying hyperbolically. The claim is not that volatility is ignored, it is that the one component doing the risk work assumes a decay shape the local data says is wrong. The original authors concede the opening themselves, their conclusion noting that the volatility estimates are lagged and proposing forward volatility inference as future work.

### The state-of-the-art check

The obvious challenge is that the volatility forecasting literature has moved on from the allocation papers and may already do this. [[Forecasting realized volatility with spillover effects, Perspectives from graph neural networks|The strongest instance of that literature in my corpus]] is graph-based and properly evaluated, every number reported as a ratio to a HAR baseline with a model confidence set attached. Long memory appears in it only as the justification for the HAR lag structure, which the paper's own framing describes as the cheapest available way to reproduce the long-memory decay in the realised-volatility autocorrelation function without fitting a fractionally integrated model. It is absorbed into functional form: not estimated, not reported, not fed to anything downstream, and the paper ends at a loss ratio with no portfolio, no value-at-risk backtest and no cost-bearing application.

The honest form of the claim is therefore that in the volatility forecasting work I have covered, including its strongest instance, persistence is a modelling convenience rather than a quantity a decision consumes.

**A complexity cap comes with it.** One hop plus a nonlinearity is where the performance sits across both universes that paper tests. That bounds how much graph machinery $A_V$ needs. It is their result on their universes, so it is carried as a starting point and an ablation rather than as a settled ceiling.

### What the CSE literature established

Riyath finds long memory on the ASPI and SL20 across all three regimes. Samarawickrama and Pallegedara find persistence close to 1. Three CSE papers detect volatility clustering and address it only with robust standard errors.

**A mechanism-level reason to expect slow decay, independent of the statistics.** A one standard deviation rise in idiosyncratic risk cuts CSE firm capital spending by 17.48% of the mean investment rate. If a volatility shock propagates into fundamentals with a lag measured in reporting periods, the real activity it suppresses takes just as long to come back.

### What the agent literature does for risk

FinCon: CVaR on realised PnL, backward-looking. FinHEAR: risk sensitivity sampled from a hand-set Beta, assumed rather than measured. FinMem: a three-day return sign test. AlphaAgents: a prompt adjective. FinAgent: six risk metrics reported and none fed back.

### So the gap is a disconnection

There is a measured quantity on one side and a decision that needs it on the other, and nothing joins them. After a shock, a GARCH-calibrated risk layer thinks things have normalised while they have not, which on a market that took the Easter attacks, COVID and the 2022 crisis in sequence is a real failure mode.

$d$ is slow-moving by construction and is not a daily trading signal, so it pairs with a forecast conditional variance: **variance says how bad now, persistence says how long.** Together they set a decay schedule on exposure rather than a point-in-time cap.

**The honest limit.** Lahmiri and Bekiros found persistence does not distinguish crypto from equities, so I cannot argue the CSE is special because of its persistence. The argument is that the quantity is operationally useful, not that it is unusual here.

**The part that unblocks the build.** Because the target is a named component of a published system, this is testable before any CSE data arrives. Swap the EWMA half-life for a persistence-aware decay schedule on that paper's own four-ETF setup and see whether the Sharpe improves.

**Status.** Until that experiment exists this is a strong hypothesis, not a demonstrated contribution. Self-assessed novelty **3.5**.

---

## The weighting equation

$$w_{i,t} = f(L_t, V_t, P_t, C_{i,t})$$

The four terms are **specified, not closed**. Each is evidenced and computable, candidates are live for a fifth term, and the pool of four agents is unchanged by the reviews rather than confirmed by them.

| Term | Definition and status |
| --- | --- |
| **$L_t$** liquidity | **Keep**, strengthened, volume to ASPI Granger at $p = 0.0041$. Constructed as a composite on the BIS market-condition-indicator recipe: sign every input so higher means worse, z-score, take the first principal component over an expanding window starting from a three-year block, re-normalise. Inputs are Amihud, turnover ratio, zero-return frequency, the high-low range, and $\tau_t$ as a candidate. This costs nothing that is not already being computed for the cost model |
| **$V_t$** volatility | **Keep**, estimator pinned. Parkinson or Garman-Klass, since five-minute realised volatility is unavailable on this market |
| **$P_t$** persistence | **Keep**, locally evidenced rather than assumed, with a mechanism-level reason behind the statistics |
| **$C_{i,t}$** confidence | **Specified for three of the four, with $A_L$ open.** Not a self-report, a *structural* property of the output. $A_F$: does the extracted program parse, does every argument trace to a retrieved figure, and step count as a calibrated difficulty proxy at 67.61 / 59.08 / 22.78 per cent for one, two and three-plus steps. $A_V$: wrap the FIGARCH or GJR-GARCH forecast in adaptive conformal inference and let $C_{V,t}$ be a function of realised interval width at the target coverage, so a drifted model reports wider intervals and is automatically down-weighted. $A_T$: Theil's U2 against the random walk. $A_L$: no mechanism yet, so it stays on the open list rather than being papered over. **Across all four**, map each agent's raw score through its own empirical accuracy-at-threshold curve estimated on a rolling validation window, which lands every agent in the same unit, probability of being right at the score just emitted |
| **Abstention** | **Time-varying subset selection**, named prior art, achieved by applying a threshold to a time-varying weighting scheme (Li et al. 2022). Geweke and Amisano's finding that individually poor forecasts can still help in combination argues for **shrinking an abstaining agent's weight toward a floor rather than driving it to exactly zero**. Unparseable output remains a separate outcome state feeding a hard zero. The abstention design is forced on $A_T$ as well as $A_F$, since the CSE firm-level study moves to weekly returns on the ground that most CSE stocks are not traded daily |
| **Macro block** | **Rejected.** ARDL gives adjusted $R^2 = 0.189$ on five macro variables over a decade, with Granger nulls for money supply and inflation. One caveat: USD/LKR leads the index at a two-month lag, $p = 0.0015$, so if any macro variable is carried it is that one, as a slow lagged feature into $A_F$'s context, not as a fifth agent |

**Cross-architecture candidates for the common confidence scale.** $p_\text{T}$, round-trip practicability, computable for anything emitting a directional view, and the rolling QL loss ratio against a fixed benchmark, which is unit-free and computable for anything emitting a point or distributional forecast of the same target. Having two defined on different output types is progress on the problem rather than a solution to it.

**Pre-registered as tests rather than adopted components.** A pairwise conflict score. The adapted miscoverage level $\alpha_t$ from adaptive conformal inference as a continuous distribution-shift state variable, with no threshold to hand-tune. A market-wide $L_t$ alongside the counter-level one, the cross-sectional analogue of the BIS cross-market spillover finding. An information filtering network computed over the *agents' output signals* rather than over price levels, giving a filtered dependency graph among components and a principled way to notice when two supposedly independent agents have started agreeing for the same reason.

**The parsimony commitment.** Any proposed addition to $f(L_t, V_t, P_t, C_{i,t})$ has to beat the existing set out-of-sample on the ablation protocol, not in-sample, and the static learned-weight baseline stays in as the shrinkage-equivalent control. The same constraint applies to the orchestrator's own capacity: the argument for a low-capacity orchestrator, a gated linear form or shallow regression over the four state variables rather than a network, rests on an observed Sharpe sign-flip when L2 regularisation moves from 0.001 to 0.002 on a universe larger and a history longer than the CSE offers, so the orchestrator's own stability has to be swept and reported rather than tuned once.

**A heterogeneity check that is nearly free.** The combination literature gives the operational definition of diversity, low correlation among component errors, so run it on my own pool. If $A_T$ and $A_V$ produce errors correlating at 0.8 on CSE data, the pool is less diverse than the architecture diagram implies and the error-cancellation argument weakens accordingly. The corroborating worry is specific: check the correlation between the idiosyncratic risk estimate and turnover, because if those move together then $A_V$ and $A_L$ are partly measuring the same thing and the state vector has a collinearity problem.

---

## How the three fit

**The main gap is the mechanism. The sub-gaps are the two inputs it runs on.**

- **Liquidity state** gives what a trade costs, *and* how much to trust price-derived signals.
- **Persistence plus forecast variance** gives how much exposure to take, *and* how long to keep it reduced.

So the sub-gaps are not supporting work that happens to be nearby. They are the content of the state the orchestrator conditions on. Strip them out and the main gap is an empty function signature, weights depend on market state with nothing specified about which state or why those variables. That is also why the ordering matters: if either sub-gap fails to produce a usable signal, the main gap loses one of its two legs.

---
