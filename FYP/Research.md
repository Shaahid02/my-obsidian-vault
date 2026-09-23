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

## Theoretical Formulation and Mathematical Grounding

To formalize the integration of these fifteen reference works into a single software engineering pipeline, the mathematical boundaries of the Multi-Agent framework are established below.

### 4.1. Layout-Aware Retrieval (LFRAG) and Tiered Fallback

To solve the table serialization and context loss issue highlighted in FinanceBench and Yepes et al., let a query vector be $q\in\mathbb{R}^D$ and the document block embedding be $b\in\mathbb{R}^D$.7 The matching score is calculated via cosine similarity:

  

$$\text{Sim}(q,b)=\frac{q\cdot b}{\Vert{}q\Vert{}\Vert{}b\Vert{}}$$

Let $T$ represent the narrative text retrieval context, and let $\theta_{\text{text}}$ represent the minimum acceptable semantic threshold.7 The text context set is defined as:$$T={c\in C_{\text{text}}\mid\text{Sim}(q,E(c))\ge\theta_{\text{text}}}$$If the retrieved set is sparse ($\vert{}T\vert{}<n$), the system triggers the tiered fallback escalation, fetching tabular context $T_{\text{tbl}}$ and image context $T_{\text{img}}$ using modality-specific thresholds 7:

  

$$T_{\text{tbl}}=\text{Top-m}\{c\in C_{\text{table}}\mid\text{Sim}(q,E(c))\ge\theta_{\text{table}}\}$$

  

$$T_{\text{img}}=\text{Top-p}\{c\in C_{\text{image}}\mid\text{Sim}(q,E(c))\ge\theta_{\text{image}}\}$$

The final augmented context $C_{\text{final}}$ compiled for generation is:

  

$$C_{\text{final}}=T\cup T_{\text{tbl}}\cup T_{\text{img}}$$

### 4.2. Volatility Memory Modeling (ARMA-FIGARCH)

To integrate the long-memory dynamics of Mohamed Riyath and the leverage-effect modeling of Samarawickrama & Pallegedara into the Volatility Risk Analyst Agent, for a return series $r_t$, let the innovation residual be $\epsilon_t=r_t-\mu_t$.8 The conditional variance $h_t$ is modeled via the ARMA-FIGARCH($1,d,1$) process 2:

  

$$h_t=\omega\left[1-\beta(L)\right]^{-1}+\left\{1-\left[1-\beta(L)\right]^{-1}\phi(L)(1-L)^d\right\}\epsilon_t^2$$

where $L$ is the lag operator 2, $\omega$ is the baseline variance, $\beta$ and $\phi$ are autoregressive and moving average parameters 8, and $d\in(0,1)$ is the fractional integration parameter representing long-term volatility memory persistence.2

### 4.3. Liquidity-Aware Execution Slippage

To address the market-friction gaps highlighted by Pippas et al., the Trader Agent schedules order execution to mitigate the severe illiquidity of the CSE.9 A parent order $V_{\text{parent}}$ is split into smaller tranches $v_i$ across intraday intervals based on the historical volume profile 1:

  

$$v_i=V_{\text{parent}}\times\left(\frac{\bar{V}_i}{\sum_{j=1}^{M}\bar{V}_j}\right)$$

where $\bar{V}_i$ is the historical average volume of interval $i$.1 The transaction slippage penalty, measured in basis points (bps) against the market VWAP, is formulated as 1:

  

$$\text{Slippage}=\left(\frac{P_{\text{actual}}-P_{\text{VWAP}}}{P_{\text{VWAP}}}\right)\times10,000$$

### 4.4. Deep Reinforcement Learning Portfolio Reward Shaping

Aligning with Kashif & Ślepaczuk, the action space $a_t$ corresponds to continuous portfolio weight adjustments. The reward function $R_t$ is shaped to incorporate transaction costs, turnover penalties, and volatility-adjusted risk:

  

$$R_t=r_t-\lambda_{\text{cost}}\Vert{}a_t-a_{t-1}\Vert{}_1-\gamma_{\text{risk}}h_t$$

where $r_t$ is the portfolio return at step $t$, $\lambda_{\text{cost}}$ is the transaction cost coefficient, and $\gamma_{\text{risk}}$ is the risk-aversion penalty scaled by the conditional variance $h_t$ calculated by the FIGARCH model.

#### Works cited

1. Hierarchical Deep Reinforcement Learning for VWAP Strategy Optimization - arXiv, accessed May 28, 2026, [https://arxiv.org/pdf/2212.14670](https://arxiv.org/pdf/2212.14670)
    
2. Modeling long-term volatility memory dynamics in the Colombo Stock Exchange, accessed May 28, 2026, [https://www.emerald.com/irjms/article/5/1/21/1251352/Modeling-long-term-volatility-memory-dynamics-in](https://www.emerald.com/irjms/article/5/1/21/1251352/Modeling-long-term-volatility-memory-dynamics-in)
    
3. LFRAG: Layout-oriented Fine-grained Retrieval-Augmented Generation on Multimodal Document Understanding - arXiv, accessed May 28, 2026, [https://arxiv.org/pdf/2605.22829](https://arxiv.org/pdf/2605.22829)
    
4. [2504.13545] Enhancing Multilingual Sentiment Analysis with Explainability for Sinhala, English, and Code-Mixed Content - arXiv, accessed May 28, 2026, [https://arxiv.org/abs/2504.13545](https://arxiv.org/abs/2504.13545)
    
5. Leveraging Contrastive Semantics and Language Adaptation for Robust Financial Text Classification Across Languages - MDPI, accessed May 28, 2026, [https://www.mdpi.com/2073-431X/14/8/338](https://www.mdpi.com/2073-431X/14/8/338)
    
6. Explainable Multilingual Sentiment Analysis for Sinhala, English and Code-Mixed Banking Reviews - IEEE Xplore, accessed May 28, 2026, [https://ieeexplore.ieee.org/document/11361448/](https://ieeexplore.ieee.org/document/11361448/)
    
7. MultiFinRAG: An Optimized Multimodal Retrieval-Augmented Generation (RAG) Framework for Financial Question Answering - arXiv, accessed May 28, 2026, [https://arxiv.org/html/2506.20821](https://arxiv.org/html/2506.20821)
    
8. Revolutionizing Hedge Fund Risk Management: The Power of Deep Learning and LSTM in Hedging Illiquid Assets - MDPI, accessed May 28, 2026, [https://www.mdpi.com/1911-8074/17/6/224](https://www.mdpi.com/1911-8074/17/6/224)
    
9. Role of Market Liquidity in Sentiment-Based Return Predictions: Evidence from Sri Lanka - EconJournals.com, accessed May 28, 2026, [https://econjournals.com/index.php/ijefi/article/download/18020/8588/42220](https://econjournals.com/index.php/ijefi/article/download/18020/8588/42220)
    
10. Liquidity and Autocorrelations in Individual Stock Returns - ResearchGate, accessed May 28, 2026, [https://www.researchgate.net/publication/4913477_Liquidity_and_Autocorrelations_in_Individual_Stock_Returns](https://www.researchgate.net/publication/4913477_Liquidity_and_Autocorrelations_in_Individual_Stock_Returns)
    
11. FYP Research Ideas.pdf