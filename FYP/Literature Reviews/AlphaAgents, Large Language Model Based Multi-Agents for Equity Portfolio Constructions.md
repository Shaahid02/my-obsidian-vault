arXiv preprint (2508.11152v1), August 2025, Zhao, Lyu, Jones, Garber, Pasquali and Mehta, all six out of BlackRock. Three specialist LLM agents, fundamental, sentiment and valuation, each analyse a stock from their own data and toolset, then argue to consensus on a BUY or SELL. It contributes two things, debate as a hallucination check and investor risk tolerance embedded in the prompt rather than applied as a filter afterwards, and it stops at stock selection, feeding a screened list to Mean-Variance Optimization or Black-Litterman, and it never produces weights itself.

Worth reading mainly because it takes the opposite position to [[FinCon, A Synthesized LLM Multi-Agent System with Conceptual Verbal Reinforcement for Enhanced Financial Decision Making]] on the one architectural question I actually have to answer. FinCon routes everything through a manager and forbids lateral chatter because peer-to-peer discussion is an unpriced cost. AlphaAgents makes debate the point, because disagreement is the only signal you get that an agent is hallucinating. Neither runs the comparison that would settle it, so I have two credible positions and an open question, which is where I should leave it.

## Major differences to mine

No social media or code-mixed sentiment path. Sentiment comes from Bloomberg news bodies, analyst ratings and disclosures, all English, all institutional. CSE sentiment lives in Sinhala and Singlish retail chatter, which is the problem [[Enhancing Multilingual Sentiment Analysis with Explainability for Sinhala, English, and Code-Mixed Content]] is built around.

The <font color="#ff0000">information density assumption</font> is the hard blocker, and this paper supplies the evidence itself rather than making me infer it. The sentiment agent was dropped from the single-agent portfolio comparison entirely because there was insufficient news coverage across some of the fifteen stocks. Fifteen US technology large caps, and the news was still too thin. That is the CSE failure mode, at far greater severity, coming from the paper's own experiment.

No risk calculating agent. Risk enters only as a prompt adjective, the agents are told the investor is risk-averse or risk-neutral and reason about volatility qualitatively from there. FinCon at least computes CVaR on realised PnL, which is backward looking but is a number. Nothing here carries volatility persistence, which [[Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange]] shows is measurable and material on the CSE.

No transaction costs, no slippage, no liquidity constraint, no turnover penalty. Equal weights at selection, held four months, rebalancing not modelled. On a thin whale-dominated market that omission does most of the work, and it is the gap [[Deep Reinforcement Learning Framework for Diversified Dynamic Portfolio Allocation Across Global Equity Markets]] closes by putting turnover inside the reward.

Fundamentals arrive as 10-K and 10-Q filings[^1], a fixed schedule with fixed sections and machine-readable structure. CSE annual reports are PDFs of varying structure with no MD&A equivalent, so the Report RAG tool is not portable as-is even though the idea behind it is.

## Standout features

<font color="#ffff00">Reflection-enhanced prompting</font>, the sentiment agent summarises, critiques its own summary, then refines, instead of extracting directly.

Multi-agent debate as an explicit hallucination control, round robin, consensus as the stopping condition rather than a fixed round count.

<font color="#ffc000">Risk tolerance written into the agent instructions</font>, so the same agent reasons differently about the same stock under different investor profiles.

An <font color="#ffc000">observability platform (Arize Phoenix)</font> as the evaluation layer, scoring faithfulness and relevance per retrieval and monitoring whether the valuation agent actually called its calculator.

Every quantitative figure computed by a tool outside the model and passed in, so a wrong number has to come from the tool rather than from GPT-4o doing arithmetic in-context.

Full debate transcripts logged and human-reviewable, with the ability to override the agents' conclusion.

#### How the system works

Each agent sees only the data its role needs, and the partition is effectively the system's interface spec.

| Feature | Availability | Description |
| --- | --- | --- |
| Ticker | All agents | Unique symbol of a publicly traded company's stock |
| Price (OHLC) | Valuation agent | Initial, highest, lowest and final trading price within a period |
| Volume | Valuation agent | Total shares traded during a specific period |
| 10-K / 10-Q | Fundamental agent | Financial disclosure data, prospectus and financial statements |
| Bloomberg ID | Sentiment agent | Ticker's identifier for Bloomberg News |
| News body | Sentiment agent | Article text covering news, disclosures and analyst rating changes |

Scanning the availability column, no agent sees more than two features and no two agents share anything past the ticker, so there is <font color="#ffc000">no redundancy anywhere in the system</font>. Each signal has exactly one agent responsible for it and no second opinion on it, which is why the sentiment agent's news failure kills that channel outright instead of just weakening it.

![[Pasted image 20260809205115.png]]

Role prompts are short and given verbatim, worth keeping in full because the phrasing is load-bearing.

|                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Valuation Agent   | As a valuation equity analyst, your primary responsibility is to analyze the valuation trends of a given asset or portfolio over an extended time horizon. To complete the task, you must analyze the historical valuation data of the asset or portfolio provided, identify trends and patterns in valuation metrics over time, and interpret the implications of these trends for investors or stakeholders.                                                                                                                                                                             |
| Sentiment Agent   | As a sentiment equity analyst your primary responsibility is to analyze the financial news, analyst ratings and disclosures related to the underlying security; and analyze its implication and sentiment for investors or stakeholders.                                                                                                                                                                                                                                                                                                                                                   |
| Fundamental Agent | As a fundamental financial equity analyst your primary responsibility is to analyze the most recent 10K report provided for a company. You have access to a powerful tool that can help you extract relevant information from the 10K. Your analysis should be based solely on the information that you retrieve using this tool. You can interact with this tool using natural language queries. The tool will understand your requests and return relevant text snippets and data points from the 10K document. Keep checking if you have answered the users' question to avoid looping. |

"Based solely on the information that you retrieve using this tool" is a grounding constraint and "keep checking if you have answered the users' question to avoid looping" is a termination heuristic, both patched in at the prompt level because the agent loop has no mechanism for either, and neither is measured.

Tooling, briefly. The valuation agent gets a calculator for annualised return and volatility so the LLM never does the arithmetic. The sentiment agent gets an LLM summarisation tool rather than retrieval, and the paper is deliberate about the distinction, summarisation lets the agent read everything and form an opinion where RAG only surfaces query-matching fragments, so it is a coverage-versus-precision choice and they pick coverage. The fundamental agent gets a yfinance Report Pull Tool with iterative call checks, plus a Report RAG Tool that chunks by report section, embeds with GPT-4o, and is invoked repeatedly against a fixed question set covering cash flow and income, operations and gross margin, areas of concern, and progress towards stated objectives. Section-boundary chunking is the same conclusion [[Financial Report Chunking for Effective Retrieval Augmented Generation]] reaches independently, which makes it a reasonably strong prior for my own pipeline.

<font color="#ffc000">Microsoft AutoGen</font> provides the group chat and assistant agent infrastructure, AutoGen Studio is the interface, GPT-4o is the backbone for every agent after testing several GPT models.

> [!NOTE] Multi-Agent Debate
> Round robin. Each agent receives the query plus peer analyses and gets at least two turns, and discussion continues until consensus. The coordinator prompt supplies the binding constraint, "Each agent can not decide for the whole group. They are tasked with coming to a consensus. You must invoke all agents before deciding to Terminate."

> [!WARNING] Consensus is not correctness
> The stopping rule is agreement, not accuracy, and three agents on the same backbone can converge on the same wrong answer with nothing in the design able to tell that case apart from a successful debate. The hallucination-reduction claim needs agent errors to be at least partly independent, and one GPT-4o driving all three is exactly the condition under which they are not. Untested here.

Evaluation runs on three layers. Phoenix scores retrieval faithfulness and relevance for the fundamental and sentiment agents, the valuation agent has no easy ground truth so the mitigation is the calculator plus monitoring that it was actually called, and humans review debate transcripts for logical coherence. Back-testing is the downstream metric, with risk-adjusted return tracked by a rolling Sharpe ratio over a window $w$:

$$S_{\text{rolling}}(t) = \frac{\overline{R_{p,t-w+1:t}} - R_f}{\sigma_{p,t-w+1:t}}$$

where:

- $\overline{R_{p,t-w+1:t}}$ is the mean portfolio return over the trailing window of length $w$
- $\sigma_{p,t-w+1:t}$ is the standard deviation of portfolio return over that window
- $R_f$ is the risk-free rate, here the one-month treasury

The rolling form is right for a window this short, a single Sharpe over four months says almost nothing about stability, but $w$ is never stated, which makes the curves impossible to reproduce.

Setup: fifteen randomly selected technology stocks acting as both the picking pool and the equal-weight benchmark, agents run on January 2024 data, selection on 1 February 2024, four months of monitoring. Portfolios built for the valuation agent, the fundamental agent and the multi-agent system, with no sentiment-agent portfolio for the coverage reason above.

#### Findings

- **In the risk-neutral setting the multi-agent portfolio beats both single-agent portfolios and the benchmark** on cumulative return and rolling Sharpe over the four months. The explanation offered is a horizon argument, sentiment and valuation work off a one to three month window and suit short-term forecasting, the fundamental agent works off 10-K material and captures long-term potential, and combining them balances the two. Plausible, and consistent with the selection behaviour below, but it is asserted, not isolated, no configuration varies horizon while holding the rest fixed.
- **The absolute numbers are much worse than "outperforms" implies.** In Figure 6 cumulative return sits below zero for most of the window, bottoming near -0.10, and rolling Sharpe is negative throughout, roughly -0.10 to -0.45. So the risk-neutral result is smaller losses than the benchmark over four months, not positive risk-adjusted return. Relative comparison is the right frame and the finding stands, but no Sharpe or return figure appears anywhere in the text, so the only way to see the sign of the result is to read the axis.
- **Selection behaviour differs interpretably, and one agent contributes nothing.** Under a risk-neutral profile the valuation agent reproduces the benchmark portfolio directly, so it is not differentiating from the market baseline at all, the fundamental agent expands beyond the benchmark, and the multi-agent system keeps most of the fundamental picks but curates them down. The valuation agent collapsing onto the benchmark is the most diagnostic observation in the results, it means the comparison against that agent is really a second comparison against the benchmark.
- **Under a risk-averse profile every agent portfolio underperformed the benchmark**, because the technology sector rallied and the risk-averse agents excluded the volatile names that drove it. The paper reads this as the standard risk-return tradeoff in a bullish market, which is fair, but it also means the risk-averse arm tests the sector regime more than it tests the agents. Within that arm the multi-agent portfolio still did relatively better than either single agent, with slightly lower volatility and reduced drawdowns, which the authors correctly call limited in scope.
- **The risk-seeking profile was indistinguishable from risk-neutral** and was cut from the evaluation, which the authors read as a limitation of prompt-based differentiation between adjacent profiles. I think that read is correct and under-explored. Prompt conditioning appears to give coarse control, averse versus not-averse, rather than a graded dial, which matters for anyone treating a natural-language risk profile as a continuous parameter. One observation on one setup, not formally measured, so I am filing it as a flag to test, not a result.

#### Limitations

- **No numerical results anywhere.** The results section is entirely figures, with no table of returns, Sharpe or drawdown and no point estimate in the text, so every comparison is eyeballed off a chart. Weaker than the papers around it, FinCon at least tabulates CR, SR and MDD per configuration.
- **One sector, fifteen stocks, one four-month window, one selection date.** No repeated splits, no walk-forward, no significance testing, and the benchmark is an equal-weight portfolio of the same fifteen candidates. Against the sixteen out-of-sample folds in the DRL framework paper this is a demonstration, not an evaluation, and I should cite it for its design, not for its performance numbers.
- **Look-ahead risk from the backbone is never raised.** GPT-4o's pretraining plausibly covers February to June 2024, the exact test window, on fifteen heavily covered mega-cap technology names. No older-cutoff model, no pre-cutoff window, no mitigation attempted. I cannot size the effect and it may be small, but it is the first thing a reviewer would ask.
- **Forced consensus discards the most informative outcome.** The coordinator requires agreement before termination, so the system cannot report persistent disagreement, and a stock the agents genuinely cannot resolve looks identical in the output to one they agree on immediately.
- **Debate is never ablated.** Collaboration runs first to produce the analysis report, debate second to produce the recommendation, and both are always on, so none of the performance can be attributed to the debate mechanism specifically. Unfortunate, given debate is the headline contribution.
- **No portfolio optimization**, stated plainly in the conclusion. Honest scoping, not a flaw, but it means the back-test is evaluating a screen dressed as a portfolio.

#### Why this matters for my project

- **The sentiment agent's exclusion is the most transferable finding, and it is evidence, not conjecture.** It points the design two ways, either CSE sentiment comes from sources this paper does not consider, Sinhala and code-mixed retail discussion plus the liquidity-conditioned effect in [[Role of Market Liquidity in Sentiment-Based Return Predictions, Evidence from Sri Lanka]], or the sentiment agent needs an explicit abstain path so it reports no signal instead of generating confident text about nothing. The second is cheap and I want it regardless.
- **Treat strict data partitioning as a cost, not a feature.** Clean separation keeps each agent's task narrow, but with no redundancy a starved agent takes its entire signal channel down with it. On the CSE at least one channel will be thin for most tickers, so I want either deliberate overlap between agents or a confidence-and-abstain protocol that tells the aggregator which inputs are actually live for a given stock.
- **Take the calculator-tool pattern directly, it is the cheapest reliability win here.** Compute every figure outside the model, pass it in, verify the call in the observability layer. That is also where a CSE-specific risk measure enters cleanly, a FIGARCH-derived conditional volatility fed in as a computed input rather than left to the model to reason about qualitatively, which fixes the missing risk agent and keeps the number itself out of the LLM.
- **Build observability in from the start.** Per-retrieval faithfulness and relevance gives me a component-level evaluation story independent of the back-test, which matters a lot on the CSE where the back-test will be short, noisy and underpowered by construction. If the portfolio results come out inconclusive, and on CSE data depth they plausibly will, retrieval metrics are what shows the system works when the returns cannot.
- **Keep debate, but make disagreement reportable and vary the backbone.** A persistent-disagreement terminal state, logged with the dissenting arguments, turns the mechanism's most useful output into a flag rather than throwing it away, and it gives a free proxy for decision confidence, which is what AlphaAgents lists as future work for weighting allocations. Running different models, or at least different temperatures and prompting strategies, across agents is the other half, since debate only checks hallucination if the errors are partly independent.
- **Settle debate versus hierarchy with an experiment.** AlphaAgents and FinCon disagree and neither tests it. Running that comparison on CSE data is a contribution in itself and it is cheap, since the two protocols share most of their implementation.
- **Copy the modular positioning.** AlphaAgents screens and hands off to MVO or Black-Litterman, FinCon has the LLM pick direction and a Markowitz solver pick size. Two otherwise opposed designs both keep the language model out of sizing, which is a strong enough convergence to follow, and it gives me the clean insertion point for CSE liquidity and friction constraints, which belong in the optimizer rather than in a prompt.
- **Use this as the cautionary example on evidence standards.** Charts without numbers, one window, one sector, no significance test, and "outperforms" describing a period where both cumulative return and rolling Sharpe are negative throughout. I want the opposite in my own write-up, actual figures quoted, the economic result and the formal test side by side, and the sign of the absolute return stated rather than only the relative ranking.

[^1]: Form 10-K and Form 10-Q are mandatory reports that public companies file with the U.S. Securities and Exchange Commission (SEC). The 10-K is a detailed annual report with audited financial data, while the 10-Q is a shorter quarterly update with unaudited financial statements filed three times a year.
