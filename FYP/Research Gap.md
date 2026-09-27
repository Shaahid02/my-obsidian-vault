*Revised 27 September 2026 against all 53 literature reviews. Sentiment is out of scope (supervisor, 20 September 2026, Final) - see `Scope sentiment analysis dropped.md`. Three claims in the previous version were too strong and have been narrowed; they are marked **[narrowed]** where they appear.*

---

### Main gap, the orchestration problem

**The setup.** You have four agents - $A_T$ technical, $A_F$ fundamental, $A_V$ volatility, $A_L$ liquidity. Each looks at something different and produces a signal. Something has to turn several signals into one decision.

**What every existing system does.** [narrowed - and the narrowing made it stronger.] The old wording was "the combination rule is fixed at design time." That understates it. In most of these systems **there is no quantity that could be weighted in the first place.** TradingAgents combines through a one-sentence facilitator prompt. FinVision concatenates the analyst outputs into a single prompt. Park's system passes a free-text summary. There's no vector, no coefficient, nothing to make time-varying, so the question "how are the weights set?" doesn't even have an answer to criticise.

Three unrelated designs arriving at the same non-mechanism is evidence about the field, not about three papers. The ACM CSUR review of 167 RL papers says it outright: coordination protocols among agents are underexplored.

**Why that's a problem.** An agent's reliability is not constant, it depends on what's happening and what data exists today. And the failure is worse than "weak signal," because these agents don't abstain. Ask A_F about a counter whose last annual report is eleven months stale and it doesn't say "I don't know." It produces a confident number about nothing.

Two documented cases, both from your own notes:

- **FinAgent's auxiliary strategies on ETHUSD** returned 16% against buy-and-hold's 29%. Actively worse than doing nothing. They were tuned to US large-cap dynamics, the dynamics changed, and nothing in the design could notice.
- **AlphaAgents deleted an entire agent by hand** because its input channel was too thin across fifteen US megacaps. A human noticed and intervened. The system had no way to. (Their thin channel was news; ours is filings. The structure of the failure is the same, and it's why the abstention channel is in the design rather than bolted on later.)

**What's missing.** Nothing adapts an agent's influence to how reliable that agent is right now.

**The four systems that get closest, and why none of them closes it.** Naming only MacroHFT is no longer a sufficient defence:

| System                        | Nearest on                                                                                       | Why it doesn't close the gap                                                                                                                                                                            |
| ----------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **HedgeAgents**               | the mechanism itself, a genuinely solved constrained optimisation over an explicit weight vector | the weights are over **assets**, not agents. One agent per asset, 1:1, so it never asks which *method* to trust. Threshold hand-set and never revisited                                                 |
| **MacroHFT**                  | continuous conditioning on market state                                                          | six **identical** DDQNs on one data stream. Conditioning without heterogeneity                                                                                                                          |
| **Jung & Lee**                | a genuinely heterogeneous pool                                                                   | a fixed prompt template sits exactly where the weighting should be. Degrades 10.36 points and can't notice                                                                                              |
| **TRIAG**                     | an orchestrator that learns to coordinate                                                        | its state vector has **no environment block**. Carries a confidence field and never computes with it                                                                                                    |
| **Automate Strategy Finding** | -                                                                                                | **demoted to Baseline 2.** The BlackRock survey nominates it as the field's adaptive gating mechanism; read the primary paper and it does selection, not weighting, and its weights carry no time index |

**The claim that survives all five.** Continuously vary the influence weight of *methodologically heterogeneous* agents, over a *single shared decision*, as a function of *measured exogenous market state*. Every clause is load-bearing, drop "heterogeneous" and MacroHFT has it, drop "agents" and HedgeAgents has it, drop "measured exogenous state" and TRIAG has it.

**Why the CSE.** This is where reliability varies most. On the Nasdaq every counter has deep liquidity and current filings, so the gaps between agents are small and a fixed weighting is roughly fine. On the CSE, on any given day, some channels are live and others are empty. Not noticing costs you more.

---

### Sub-gap 1,  what a trade actually costs

**The question.** When you decide to trade, what does it cost you?

**What existing systems assume.** Most: nothing, fill at the close. Better ones: a flat percentage, MacroHFT 0.02%, Kashif & Ślepaczuk 2bps. FreQuant charges 33–40bps and solves the genuinely hard part, that the fee reduces capital which changes the weights which changes the fee.

**[narrowed.] The old claim was that nobody models cost as a function of order size against depth. That is no longer defensible.** Two papers do:

- **Chen et al. (ICAIF '22)** build a queue-reactive LOB simulator and quantify the error from ignoring impact at 3.04 bps.
- **Wang, Gao & Li (Finance and Stochastics, 2026)** implement Almgren-Chriss in closed form. **This is the 2026 market-impact work your supervisor cited.** They were right; that open item is closed.

**What still survives, and it's narrower but cleaner.** Four things, and the fourth is the one that matters most:

1. Both existing treatments use a **linear or square-root** impact form. Neither tests a nonlinear one against data.
2. **No participation-rate sweep anywhere.** Nobody varies order size as a fraction of daily volume and reports how the result moves.
3. **No thin-book calibration.** Both are calibrated on deep markets. A frontier market's book is a different object.
4. **No allocation system puts cost inside the objective.** Every one of them deducts it afterwards. If the cost of a rebalance doesn't enter the function being optimised, the optimiser has no reason to prefer a cheaper path to the same position.

Revised novelty: **3**, down from 3.5–4. That's a fair rating and you should offer it before anyone asks.

**Why it's real here.** Dissanayake & Nanayakkara find unexpected illiquidity shocks depress CSE returns significantly (−0.084 to −0.097), small caps more than large. Liquidity is a first-order effect on this market.

**The part that connects it upward.** This isn't a separate topic. The same measurement, Amihud illiquidity, turnover, zero-return frequency,  that tells you what a trade costs also tells you how much to trust a price-derived signal, because in a thin market the price series feeding $A_T$ is itself noisier. One measurement, two uses. On the CSE it has a third: Granger causality runs from volume to ASPI at p = 0.0041, so liquidity is a state variable here in a way it demonstrably isn't everywhere.

---

### Sub-gap 2, how long a shock lasts

**The distinction that matters.** Two different things about volatility:

- **Level**: how violent is it right now? Standard GARCH gives you this.
- **Persistence**: how slowly does a shock decay? This is what FIGARCH's *d* measures.

Standard GARCH assumes shocks decay exponentially, so fast. Long memory means hyperbolic decay: slow, lingering after the event has technically passed.

**[narrowed.] The old claim covered both halves. It shouldn't have.** *Deep Learning for Portfolio Optimization* already operationalises volatility **level**, daily, through a target-volatility scaler $σ_tgt$ / $σ_{i,t−1}$. Worse for the old wording: that scaler is not learned, and it does most of the risk work in the paper, Sharpe goes 0.929 → 1.526. So "nobody operationalises volatility" is wrong, and a reader who knows that paper will say so.

**What survives is the persistence half, and it now has a named target.** An EWMA half-life assumes exponential decay. That is precisely the assumption the CSE long-memory result contradicts. So the claim isn't "volatility is ignored", it's that the one component doing the risk work assumes a decay shape the local data says is wrong.

Rating holds at **3.5**, and it's better evidenced than before.

**What the CSE literature established.** Riyath finds long memory on ASPI and SL20 across all three regimes. Samarawickrama & Pallegedara find persistence close to 1. Three CSE papers detect volatility clustering (ARCH statistic 86.55 on ASPI) and address it only with robust standard errors, they measure it, publish the coefficient, and stop.

**What the agent literature does for risk.** FinCon: CVaR on realised PnL, backward-looking, tells you what already happened. FinHEAR: samples risk sensitivity from a hand-set Beta, assumed, not measured. FinMem: a three-day return sign test. AlphaAgents: a prompt adjective. FinAgent: reports six risk metrics and feeds none of them back.

**So the gap is a disconnection.** There's a measured quantity on one side and a decision that needs it on the other, and nothing joins them. After a shock, a GARCH-calibrated risk layer thinks things have normalised while they haven't, which on a market that took the Easter attacks, COVID and the 2022 crisis in sequence is a real failure mode.

**The subtlety your supervisor was right about.** *d* is slow-moving by construction. It is not a daily trading signal. So you pair it with a forecast conditional variance: **variance says how bad now, persistence says how long.** Together they set a *decay schedule* on exposure rather than a point-in-time cap.

**The honest limit.** Lahmiri & Bekiros found persistence doesn't distinguish crypto from equities. So you can't argue the CSE is special *because of* its persistence. You argue the quantity is operationally useful, not that it's unusual here.

**The part that unblocks you.** Because the target is now a named component of a published system, **you can test this before you have any CSE data at all**, swap the EWMA half-life for a persistence-aware decay schedule on that paper's own four-ETF setup and see whether the Sharpe improves. If it does, you have a result independent of the data-access question. Run it first.

---

### What the orchestrator actually conditions on

The weighting function is $w_{i,t}$ = f($L_t$, $V_t$, $P_t$, $C_{i,t}$), and every term in it is now settled:

| Term                     | Status after 53 reviews                                                                                                                                                                                                                  |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **$L_t$** liquidity      | **Keep**, strengthened,  volume → ASPI Granger at p = 0.0041                                                                                                                                                                             |
| **$V_t$** volatility     | **Keep**, but pin the estimator. Parkinson or Garman-Klass; 5-minute realised volatility is unavailable on this market                                                                                                                   |
| **$P_t$** persistence    | **Keep**, now locally evidenced rather than assumed                                                                                                                                                                                      |
| **$C_{i,t}$** confidence | **Redefined.** Not a self-report, a *structural* property of the output. For $A_F$: does the extracted program parse, does every argument trace to a retrieved figure, how many reasoning steps. Four independent notes converge on this |
| **Abstention**           | **Added.** The one structural addition from the expansion. $A_F$ is expected to be unusable more than half the time, so the orchestrator has to be built for a channel that is frequently absent rather than occasionally imperfect      |
| **Macro block**          | **Rejected.** ARDL gives adjusted R² = 0.189 on five macro variables over a decade, with Granger nulls for money supply and inflation. Not worth an agent                                                                                |

Pairwise conflict score and distribution-shift detection are **pre-registered tests**, not adopted components, worth stating that way so nobody thinks you quietly dropped them.

The four-agent pool is **unchanged**: not one of the 53 notes proposes adding or removing an agent.

---

### How the three fit

This is the part worth internalising, because it's what makes it one thesis rather than three.

**The main gap is the mechanism. The sub-gaps are the two inputs it runs on.**

- **Liquidity state** → what a trade costs, *and* how much to trust price-derived signals
- **Persistence + forecast variance** → how much exposure to take, *and* how long to keep it reduced

So the sub-gaps aren't supporting work that happens to be nearby. They're the content of the state the orchestrator conditions on. Strip them out and the main gap is an empty function signature, "weights depend on market state" with nothing specified about which state or why those variables.

That's also why the ordering in the matrix matters: if either sub-gap fails to produce a usable signal, the main gap loses one of its two legs. Which is the same concentration risk as the data-depth question, arriving from a different direction.

**What changed about that risk.** It's smaller than it was. Sub-gap 2 is now testable on someone else's published setup before any CSE data arrives. And the per-counter archive turns out to be 374 trading days across roughly 300 counters,  about 100,000 training sequences at a 30-day lookback, not the 40–50k the earlier working assumption gave. The index track (ten years daily, 1 July 2014 – 30 June 2024) was never in doubt. The binding question was never *how many years exist*; it's **how many counters clear a liquidity screen**, and that's answerable this week from data already in hand.

---

### How to say it in one paragraph

> Multi-agent LLM trading systems combine their agents' outputs through a fixed rule, and in most cases through no explicit rule at all, just a prompt that concatenates them. That's fine when every agent is roughly equally reliable, which is roughly true on a deep market with continuous disclosure. On a frontier market it isn't: liquidity dries up, filings go stale, and an agent whose input has vanished still returns a confident answer. I'm building an orchestrator that varies each agent's influence continuously as a function of measured market state, liquidity, volatility, volatility persistence, and a structural confidence score, and I'm testing it against an equal-weight baseline and a static learned-weight baseline, with each state input ablated so the contribution of each one is attributable. The two sub-gaps supply the state: one measures what a trade costs against available depth, the other measures how long a volatility shock actually takes to decay.

**Two things to never say**, per the scope rules: no "first / nobody / never / no dataset exists", use *"I have not found that evaluation in the literature I have covered."* And no sentiment component, in any form, anywhere.
