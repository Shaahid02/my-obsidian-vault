### Main gap — the orchestration problem

**The setup.** You have several agents. Each looks at something different and produces a signal. Something has to turn several signals into one decision.

**What every existing system does.** The combination rule is fixed at design time. TradingAgents and FinVision give every analyst equal standing by construction. FinCon has a manager who reads all the reports, but the manager's judgement doesn't change with market conditions. AlphaAgents debates to consensus, every agent equal. FinAgent has five modules whose contributions never vary.

**Why that's a problem.** An agent's reliability is not constant — it depends on what's happening and what data exists today. And the failure is worse than "weak signal," because these agents don't abstain. Ask an LLM sentiment agent about a ticker with no news and it doesn't say "I don't know." It produces a confident opinion about nothing.

Two documented cases, both from your own notes:

- **FinAgent's auxiliary strategies on ETHUSD** returned 16% against buy-and-hold's 29%. Actively worse than doing nothing. They were tuned to US large-cap dynamics, the dynamics changed, and nothing in the design could notice.
- **AlphaAgents deleted its sentiment agent by hand** because news coverage was too thin across fifteen US megacaps. A human noticed and intervened. The system had no way to.

**What's missing.** Nothing adapts an agent's influence to how reliable that agent is right now.

**Why the CSE.** This is where reliability varies most. On the Nasdaq every ticker has dozens of news items a day and deep liquidity, so the gaps between agents are small and a fixed weighting is roughly fine. On the CSE, on any given day, some channels are live and others are empty. Not noticing costs you more.

---

### Sub-gap 1 — what a trade actually costs

**The question.** When you decide to trade, what does it cost you?

**What existing systems assume.** Most: nothing, fill at the close. Better ones: a flat percentage — MacroHFT 0.02%, Kashif & Ślepaczuk 2bps. The best (FreQuant) charges 33–40bps and solves the genuinely hard part, that the fee reduces capital which changes the weights which changes the fee.

**What's still missing in all of them.** Cost as a function of _your order size against available depth_. A flat rate says trading 100 shares and 100,000 shares costs the same percentage. Roughly true on the Nasdaq. False on the CSE, where your order can be a meaningful share of the day's volume and you move the price against yourself.

**Why it's real here.** Dissanayake & Nanayakkara find unexpected illiquidity shocks depress CSE returns significantly (−0.084 to −0.097), small caps more than large. Liquidity is a first-order effect on this market.

**The part that connects it upward.** This isn't a separate topic. The same measurement — Amihud illiquidity, turnover — that tells you what a trade costs also tells you how much to trust a price-derived signal, because in a thin market the price series feeding your technical agent is itself noisier. One measurement, two uses.

---

### Sub-gap 2 — how long a shock lasts

**The distinction that matters.** Two different things about volatility:

- **Level** — how violent is it right now? Standard GARCH gives you this.
- **Persistence** — how slowly does a shock decay? This is what FIGARCH's _d_ measures.

Standard GARCH assumes shocks decay exponentially, so fast. Long memory means hyperbolic decay: slow, lingering after the event has technically passed.

**What the CSE literature established.** Riyath finds long memory on ASPI and SL20 across all three regimes. Samarawickrama & Pallegedara find persistence close to 1. Both measure it, publish the coefficient, and stop.

**What the agent literature does for risk.** FinCon: CVaR on realised PnL, backward-looking, tells you what already happened. FinHEAR: samples risk sensitivity from a hand-set Beta — assumed, not measured. FinMem: a three-day return sign test. AlphaAgents: a prompt adjective. FinAgent: reports six risk metrics and feeds none of them back.

**So the gap is a disconnection.** There's a measured quantity on one side and a decision that needs it on the other, and nothing joins them. After a shock, a GARCH-calibrated risk layer thinks things have normalised while they haven't — which on a market that took the Easter attacks, COVID and the 2022 crisis in sequence is a real failure mode.

**The subtlety your supervisor was right about.** _d_ is slow-moving by construction. It is not a daily trading signal. So you pair it with a forecast conditional variance: **variance says how bad now, persistence says how long.** Together they set a _decay schedule_ on exposure rather than a point-in-time cap.

**The honest limit.** Lahmiri & Bekiros found persistence doesn't distinguish crypto from equities. So you can't argue the CSE is special _because of_ its persistence. You argue the quantity is operationally useful, not that it's unusual here.

---

### How the three fit

This is the part worth internalising, because it's what makes it one thesis rather than three.

**The main gap is the mechanism. The sub-gaps are the two inputs it runs on.**

- **Liquidity state** → what a trade costs, _and_ how much to trust price-derived signals
- **Persistence + forecast variance** → how much exposure to take, _and_ how long to keep it reduced

So the sub-gaps aren't supporting work that happens to be nearby. They're the content of the state the orchestrator conditions on. Strip them out and the main gap is an empty function signature — "weights depend on market state" with nothing specified about which state or why those variables.

That's also why the ordering in the matrix matters: if either sub-gap fails to produce a usable signal, the main gap loses one of its two legs. Which is the same concentration risk as the data-depth question, arriving from a different direction.