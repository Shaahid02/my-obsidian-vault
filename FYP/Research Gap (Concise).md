---
status: current
revised: 2026-10-20
source: "[[Research Gap]]"
written_against: 59 reviews
tags:
  - working-doc
---
*Condensed from `Research Gap.md` (revised 18 October 2026, written against 59 reviews). Main gap and sub-gaps only. For the prior-work contrast table, the CSE justification, the conditioning set, the parsimony constraint and the evaluation commitments, see the full note. Sentiment is out of scope (supervisor, 20 September 2026, Final).*

---

### Main gap, the orchestration problem

**The setup.** Four agents, $A_T$ technical, $A_F$ fundamental, $A_V$ volatility, $A_L$ liquidity. Each looks at something different and produces a signal. Something has to turn several signals into one decision.

**What existing systems do.** In most of them there is no quantity that could be weighted in the first place. TradingAgents combines through a one-sentence facilitator prompt, FinVision concatenates the analyst outputs into a single prompt, Park's system passes a free-text summary. No vector, no coefficient, so "how are the weights set?" has no answer to criticise. Three unrelated designs arriving at the same non-mechanism is evidence about the field rather than about three papers, and the ACM CSUR review of 167 RL papers states it directly: coordination protocols among agents are underexplored.

**Why that is a problem.** An agent's reliability is not constant. It depends on what is happening and on what data exists today. The failure is worse than a weak signal, because these agents do not abstain. Ask $A_F$ about a counter whose last annual report is eleven months stale and it does not say "I don't know", it produces a confident number about nothing.

**Four documented cases.**

- **FinAgent's auxiliary strategies on ETHUSD** returned 16% against buy-and-hold's 29%, actively worse than doing nothing. Tuned to US large-cap dynamics, the dynamics changed, and nothing in the design could notice.
- **AlphaAgents deleted an entire agent by hand** because its input channel was too thin across fifteen US megacaps. A human noticed and intervened, the system had no way to. Their thin channel was news, mine is filings.
- **Jung and Lee** measure a 10.36-point total-return degradation from a text agent the architecture cannot notice.
- **Pavithya et al. (2021) on the CSE itself.** Two heterogeneous models, one shared decision, and a combination rule fixed once at three to one in favour of the text model because that model scored higher *in individual testing on a different and easier task*. The normalisation then makes realised influence depend on how many articles happened to appear that day, an availability-weighted scheme nobody designed. Cited as a fixed-influence failure case, not as a component to rebuild.

That fourth case settles a design question. **An agent's weight cannot be set from its own in-domain score.** It has to come from measured marginal contribution to the joint decision, by ablation on held-out windows.

**What is missing.** Nothing in the reviewed set adapts an agent's influence to how reliable that agent is right now, as a function of measured conditions outside the agent.

**The claim that survives the prior-work contrast.** Continuously vary the influence weight of *methodologically heterogeneous* agents, over a *single shared decision*, as a function of *measured exogenous market state*. Every clause is load-bearing. Drop "heterogeneous" and MacroHFT has it, drop "agents" and HedgeAgents has it, drop "measured exogenous state" and both TRIAG and FFORMA have it.

**The nearest named ancestor.** FFORMA, feature-conditioned forecast combination. The difference is one sentence: its features are properties of the series itself, computed once from the history, while mine are properties of the market state, measured at each step and exogenous to the agent being weighted. A generalisation along an identified axis, not new machinery.

**The strongest objection, and the answer.** The forecast combination puzzle: across fifty years of evidence the equally weighted combination is persistently hard to beat, because weight-estimation error usually exceeds the gain from better weights. Two guidelines cut in opposite directions, limited data favouring the simple average, structural change favouring changing weights. Which dominates on this data is the experiment, and the literature is explicit that there is no comprehensive quantitative guidance on when to choose which, so **an answer on a thin frontier market is a contribution even if the answer is that equal weights win.** Equal weights is therefore the field's hardest benchmark and the right Baseline 1, and the falsification conditions are pre-registered, including a discounted inverse-MSE arm with no market state and an oracle-weight arm fitted on the test window.

---

### Sub-gap 1, what a trade actually costs

**The question.** When you decide to trade, what does it cost you?

**What existing systems assume.** Most assume nothing and fill at the close. Better ones use a flat percentage, MacroHFT 0.02%, Kashif and Slepaczuk 2bps. FreQuant charges 33 to 40bps and solves the genuinely hard part, that the fee reduces capital which changes the weights which changes the fee.

**[narrowed.]** The old claim was that nobody models cost as a function of order size against depth. Two papers do: **Chen et al. (ICAIF '22)** build a queue-reactive LOB simulator and quantify the error from ignoring impact at 3.04 bps, and **Wang, Gao and Li (Finance and Stochastics, 2026)** implement Almgren-Chriss in closed form.

**What survives, narrower but cleaner.**

1. Both existing treatments use a **linear or square-root** impact form. Neither tests a nonlinear one against data.
2. **No participation-rate sweep in the reviewed set.** Chen et al. run everything at one inventory and horizon, Wang et al. everything at 10% of ADTV, so the shape of the cost curve in order size is empirically untested across the set.
3. **No thin-book calibration.** Both are calibrated on deep markets, universes trading two to 115 million shares a day. A frontier market's book is a different object.
4. **No allocation system puts cost inside the objective.** Every one deducts it afterwards. If the cost of a rebalance does not enter the function being optimised, the optimiser has no reason to prefer a cheaper path to the same position.

Novelty **3**, down from 3.5 to 4, and that rating should be offered before anyone asks.

**Two caveats, stated together.**

1. **A potentially overlapping paper could not be obtained.** *Smart Trading Rule*, Journal of Financial Data Science 8(2), 2026, is paywalled and its contents are unknown to me. It may materially narrow this sub-gap, so Sub-gap 1 is not presented as though the literature had been fully swept.
2. **The measurement half is open again.** EDGE was demoted to last resort on 11 October, not for availability but because it is unvalidated on thin and frontier markets, and the CSE has no quote data to check its output against, so an EDGE spread here could not be falsified even in principle. The cost term therefore rests on proxies for illiquidity, Amihud, turnover, zero-return frequency and the high-low range, rather than on any measurement of what a trade pays.

**The part that connects upward.** The same measurement that tells you what a trade costs also tells you how much to trust a price-derived signal, because in a thin market the price series feeding $A_T$ is itself noisier. One measurement, two uses, and on the CSE a third, since volume Granger-causes the index at $p = 0.0041$.

---

### Sub-gap 2, how long a shock lasts

**The distinction that matters.** **Level**, how violent is it right now, which standard GARCH gives you, against **persistence**, how slowly a shock decays, which is what FIGARCH's $d$ measures. Standard GARCH assumes exponential decay, so fast. Long memory means hyperbolic decay, slow and lingering after the event has technically passed.

**[narrowed.]** The old claim covered both halves and should not have. *Deep Learning for Portfolio Optimization* already operationalises volatility **level**, daily, through a target-volatility scaler $\sigma_{tgt} / \sigma_{i,t-1}$, and that scaler is not learned yet does most of the risk work in the paper, Sharpe going 0.929 to 1.526.

**What survives is the persistence half, and it has a named target.** An EWMA half-life assumes exponential decay, which is precisely the assumption the CSE long-memory result contradicts, so after a shock the scaler re-levers on a schedule that is too fast and exposure returns while the shock is still decaying hyperbolically. The claim is not that volatility is ignored, it is that the one component doing the risk work assumes a decay shape the local data says is wrong. The original authors concede the opening themselves, proposing forward volatility inference as future work.

Rating holds at **3.5**.

**What the CSE literature established.** Riyath finds long memory on the ASPI and SL20 across all three regimes, Samarawickrama and Pallegedara find persistence close to 1, and three CSE papers detect volatility clustering and address it only with robust standard errors.

**What the agent literature does for risk.** FinCon uses CVaR on realised PnL, backward-looking. FinHEAR samples risk sensitivity from a hand-set Beta, assumed rather than measured. FinMem uses a three-day return sign test. AlphaAgents uses a prompt adjective. FinAgent reports six risk metrics and feeds none of them back.

**So the gap is a disconnection.** A measured quantity on one side, a decision that needs it on the other, and nothing joining them.

**The subtlety the supervisor was right about.** $d$ is slow-moving by construction and is not a daily trading signal, so you pair it with a forecast conditional variance. **Variance says how bad now, persistence says how long.** Together they set a *decay schedule* on exposure rather than a point-in-time cap.

**The honest limit.** Lahmiri and Bekiros found persistence does not distinguish crypto from equities, so you cannot argue the CSE is special *because of* its persistence. You argue the quantity is operationally useful, not that it is unusual here.

**Status.** Until the swap experiment exists on that paper's own four-ETF setup, this is a strong **hypothesis**, not a demonstrated contribution.

---

### How the three fit

**The main gap is the mechanism. The sub-gaps are the two inputs it runs on.**

- **Liquidity state** gives you what a trade costs, *and* how much to trust price-derived signals.
- **Persistence plus forecast variance** gives you how much exposure to take, *and* how long to keep it reduced.

The sub-gaps are not supporting work that happens to be nearby, they are the content of the state the orchestrator conditions on. Strip them out and the main gap is an empty function signature, "weights depend on market state" with nothing specified about which state or why those variables. If either sub-gap fails to produce a usable signal, the main gap loses one of its two legs.

---

### Language discipline

No "first / nobody / never / no dataset exists". The permitted form is *"I have not found that evaluation in the literature I have covered"*, or bounded in the first person. No sentiment component, in any form, anywhere. The gap statement carries the Agentic Trading snapshot cutoff of 2026-03-09 and should be re-checked before submission.

**Related notes.** [[Research Gap]] is the full version with the prior-work contrast, the CSE justification, the conditioning set and the evaluation commitments. [[Contribution to Knowledge]] states what this produces rather than what the literature lacks. [[ELI5 - The Whole Project in Plain English]] is the same material without the jargon.
