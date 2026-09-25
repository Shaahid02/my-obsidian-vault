Luo, Li, Ko, An, Xu, Tang, Wong, Gao, Lai, Zhang and Liu, City University of Hong Kong and collaborators, ACL 2026 Volume 3 System Demonstrations, pages 68 to 77, open source under Apache 2.0 at `github.com/CityU-MLO/qfinzero`. This is not a method paper and it does not propose an agent, it proposes the layer underneath one, a unified agent-callable toolchain standardising multi-frequency price access, structured news and event retrieval, and stateful brokerage simulation behind consistent JSON schemas and time-aligned interfaces. I am reading it as tooling and as a template for the evaluation harness I still have to build, not as a methodological template for the orchestrator, because it sits at the opposite end of the stack from my main gap. It is the most directly useful engineering reference I have read so far, and it is also the paper that most clearly tells me which parts of my system are plumbing rather than contribution.

> [!info] MCP
> The Model Context Protocol is a schema for exposing tools to an LLM so any compliant client can discover what calls exist, what arguments they take and what comes back, without the tool author and the agent author agreeing on anything bespoke. QFinZero ships an MCP server compatible with LangGraph, which is why its modules are usable from an agent framework it does not itself provide.

#### Major differences to mine

The first and largest is that this is an environment rather than an agent. There is no orchestration here, no weighting, no policy, nothing deciding which of several opinions to act on. Figure 3 shows an analysis agent handing off to a trading agent in a fixed pipeline with no adaptive influence between them, the same fixed-influence pattern already documented in [[A Multimodal Foundation Agent for Financial Trading, Tool-Augmented, Diversified, and Generalist|FinAgent]] and [[AlphaAgents, Large Language Model Based Multi-Agents for Equity Portfolio Constructions|AlphaAgents]]. So the paper contributes nothing to the weighting problem and does not compete with it either.

The second is the market. Everything is built on US equities, options and crypto, ingested from three commercial providers, the NASDAQ API for economic and earnings calendars, MASSIVE for price data, and BENZINGA for news, earnings calendars and guidance. The CSE has no options market, no minute-level vendor feed I can license, and no news API with ticker-tagged significance ratings. <font color="#ff0000">The data layer is a design pattern I can copy, not software I can run.</font>

The third is execution. The Paper Money Broker models the order lifecycle and the account, which is more than the buy/hold/sell triad most of the agent literature uses, but it does not model the book, so it solves the API-shape half of execution realism and leaves the price-formation half that my first sub-gap is about untouched.

The fourth is what the evaluation measures. The benchmark scores tool correctness and execution consistency, explicitly not financial return, so it says whether an agent can call an API without malforming it and nothing whatsoever about whether the agent trades well. A defensible scoping decision, but it means no result in this paper is evidence about strategy performance.

Table 1 is the paper's framing of the gap, and the column carrying the argument is Human Feed, whether market data and news are pre-curated and handed to the agent or retrieved by the agent itself. Of seven recent systems, six are pre-curated, and several are in my own reading list.

![[Pasted image 20260925180001.png]]

#### The system

Storage is tiered by access pattern rather than uniformly, and that is the part worth stealing. High-volume news goes into MongoDB as documents with only essential fields retained, title, related tickers, release time, source URL, publisher, plus optional significance ratings where the provider supplies them. Calendar data, earnings and macroeconomic events, is naturally tabular and goes into a relational store, SQLite in their demonstration, with multi-column indexes on date, country and ticker. Price data is kept at two time scales, minute and daily, as Parquet in a partitioned layout indexed by symbol and year, on the reasoning that price is high-volume, append-only and read sequentially during replay, so a database would be overhead. Refresh is roughly fifteen minutes behind for MASSIVE price and option data and daily for news and calendars, which the authors state plainly is sufficient for backtesting and not for low-latency trading.

Three modules sit on top. <font color="#ffff00">Unified Price Query</font> abstracts over frequency and instrument type so an agent asks for a series without knowing whether it is daily equity, minute equity, crypto or an option chain. <font color="#ffff00">Event Stream Pipeline</font> normalises heterogeneous feeds along temporal scope, ongoing against recently released against scheduled future events, market scope, macro against corporate against derivatives, and information type, then indexes everything with temporal, ticker and event-type tags. <font color="#ffff00">Paper Money Broker</font> closes the loop with order states, positions, balances, transaction logs and margin-aware account dynamics under configurable execution rules.

Four decisions make this agent-facing rather than merely tidy: unified JSON schemas with consistent field names and explicit timestamps across every module, composable APIs each callable independently inside a reasoning loop, a <font color="#ffc000">time-consistent state abstraction</font> aligning price, event and portfolio state to precise timestamps, and environment decoupling, where one API surface serves historical replay, simulated streaming and live-like settings without the agent logic changing.

![[Pasted image 20260925180002.png]]

#### The benchmark and how it scores

Test instructions are generated by prompting a frontier LLM to role-play a financial trader and emit natural-language requests that exercise the toolchain, each paired with a gold tool-call trace and time constraints used for automatic scoring, with a stratified sample manually verified for schema validity and plausibility. Two task types are evaluated, single-step Tool Calling where one instruction maps to one expected call, and multi-step Task Planning where a workflow spans several calls across modules.

Scoring aligns each predicted call to an expected step by best match, then scores three things per step. Tool Match gives partial credit for landing in the right module, which is the one piece of the metric design I would not have guessed:

$$s^{TM}_k = \begin{cases} 1.0 & \text{exact tool-name match} \\ 0.5 & \text{correct family (UPQ / ESP / PMB), wrong tool} \\ 0.0 & \text{otherwise} \end{cases} \qquad TM = \frac{1}{K}\sum_{k=1}^{K} s^{TM}_k$$

where:
- $k$ indexes the expected steps of an episode and $K$ is the number of steps
- episode $TM$ is the mean over steps, and a reported figure is the mean over episodes

Parameter Accuracy recursively compares predicted arguments against required parameters, nested dicts and lists included, with partial credit for list overlap via Jaccard, a relative tolerance of $10^{-4}$ on numerics, and dependency placeholders such as `{session_id}` or `<from_step_1>` ignored rather than penalised. Time Alignment checks whether date and time arguments fall inside the declared tolerance for that field, and the bands are wide, exact for zero-second fields, plus or minus five minutes for intraday, plus or minus one calendar day for daily, plus or minus two days for loose windows, and thirty or sixty minutes for horizon-like constraints. The headline number simply averages the three:

$$\text{Overall} = \frac{100}{3}\left( TM + PA + TA \right)$$

| Model | TC · TM | TC · PA | TC · TA | TC Overall | TP · TM | TP · PA | TP · TA | TP Overall |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Gemini 2.5 Flash | 0.97 | 0.90 | 0.86 | 91.00 | 0.97 | 0.90 | 0.90 | 92.33 |
| Gemini 2.5 Pro | 0.97 | 0.90 | 0.86 | 91.00 | 0.96 | 0.91 | 0.93 | 93.67 |
| GPT-4.1 | 0.92 | 0.86 | 0.84 | 87.33 | 0.96 | 0.93 | 0.92 | 93.67 |
| GPT-4.1 Mini | 0.90 | 0.83 | 0.80 | 84.33 | 0.97 | 0.90 | 0.89 | 92.00 |
| DeepSeek Chat | 0.96 | 0.85 | 0.83 | 88.00 | 0.97 | 0.93 | 0.95 | 95.00 |
| Qwen2.5 7B Instruct | 0.91 | 0.68 | 0.76 | 78.33 | 0.91 | 0.84 | 0.88 | 87.67 |
| Llama 3.1 8B Instruct | 0.65 | 0.55 | 0.67 | 62.33 | 0.90 | 0.78 | 0.86 | 84.67 |
| Qwen3 4B Instruct | 0.93 | 0.84 | 0.82 | 86.33 | 0.91 | 0.86 | 0.82 | 86.33 |

Read down the PA and TA columns against TM, and read the two Overall columns against each other, those two comparisons are where everything interesting in this table lives.

#### Findings

- **<font color="#ffc000">Parameter grounding, not tool selection, is the bottleneck.</font>** TM sits between 0.90 and 0.97 for seven of the eight models, including Qwen3 4B at 0.93, while PA and TA are below TM in every single row without exception. The spread that produces the ranking comes almost entirely from arguments and timestamps, not from picking the wrong module. Llama 3.1 8B is the one break in the pattern at TM 0.65 on single-step calling, and it is also worst on PA at 0.55, so it fails at both rather than trading one against the other. Scoped to this schema, these tolerances and a benchmark whose size is never stated, this says selecting among a documented set of tools is close to solved for instruction-tuned models and constructing valid arguments is not.

- **Multi-step planning scores higher than single-step tool calling for seven of the eight models, which is backwards.** The authors read it as step-level coordination being relatively stable once the tool interfaces are correctly understood, and I do not think that reading survives the size of the gap, Llama 3.1 8B going from 62.33 to 84.67 and Qwen2.5 7B from 78.33 to 87.67. The likelier explanation is mechanical, per-step averaging over four and five step episodes dilutes one bad step in a way a one-step episode structurally cannot. The paper reports no difficulty calibration between the two task sets, so the columns are not comparable and I would quote them separately rather than as evidence that planning is easier than calling.

- **The errors localise to timestamps and argument values, and the case study names them.** Figure 4 tags the four-step Earnings Put Protection episode with `wrong_time_value` and `wrong_param_value`, the five-step Covered Call episode with `wrong_tool_action` and `wrong_time_value`, and panel d shows a Session Setup call scored correct but carrying a date-format warning where the model supplied a bare date and the schema wanted a timezone-aware datetime. This matters more than it looks, because TA's bands are generous, plus or minus one calendar day for daily fields and plus or minus two days for loose windows, so a TA of 0.86 means a real fraction of calls miss by more than a full day. In an interactive assistant that is a rounding error, in a backtest it is a lookahead hazard.

- **Small open-weight models are viable for the tool layer.** Qwen3 4B Instruct reaches 86.33 on both task types, within a point of GPT-4.1's 87.33 on single-step calling, at a size two orders of magnitude smaller than the closed models beside it. Qwen2.5 7B is notably worse on PA at 0.68, so this is not a monotonic size story and it is one benchmark, but it is a useful prior against assuming the tool-invocation layer of an agent system needs a frontier model.

- **The <font color="#ffc000">`as_of_ts` cursor</font> is the piece with real generality.** The time-aligned data layer enforces an explicit cursor so every evaluation episode is anchored to a single point-in-time view of prices, news and events, and <font color="#ffff00">deterministic replay</font> then lets the same live-released window be re-run across models and prompt designs with bit-identical environment state. The authors frame this as removing a major source of variance in current live-benchmark practice, and the same property is what makes the environment usable for reinforcement-learning rollouts, which is the argument of their Section 6.

![[Pasted image 20260925180003.png]]

#### Limitations

- **The Overall column does not support the reading it invites, for two separate reasons.** The first is that the benchmark's size is never stated, no episode count, no task-type distribution, no seeds, and a manual verification pass over a stratified sample whose proportion is not given, so the one and two point gaps that order the top of the table, Gemini 2.5 Flash and Pro tying at 91.00 on calling then separating to 92.33 and 93.67 on planning, are uninterpretable without $n$. The second is that averaging TM, PA and TA weights three unlike failures equally: picking the wrong tool usually produces an error the agent can see, while a wrong argument or a wrong timestamp produces a plausible answer nothing downstream flags, so a model at TM 0.97 and TA 0.86 outranks one at TM 0.92 and TA 0.92 when for a backtesting use the second is safer. Carry the three components, read the table as three tiers, and leave Overall alone.

- **The instructions and the gold traces are both LLM-generated.** A frontier model role-plays a trader, emits the request, and the paired gold tool-call trace comes out of the same generation process, so the instruction distribution is whatever a frontier LLM finds natural to ask, which is plausibly correlated with what frontier LLMs find natural to answer, and the evaluated models include the same families. The manual pass checks schema validity and plausibility, a different thing from checking that the task distribution resembles what a deployed trading agent actually needs to do.

- **PMB simulates the brokerage, not the market.** Order lifecycle, margin, positions and logs are all there, and the paper's claim of more realistic evaluation than simplified buy/hold/sell abstractions is fair as a statement about the action space. But the case-study orders are 100 shares of AAPL and 200 of TSLA, sizes at which liquidity is never a constraint, and nothing in the paper models impact, partial fills or queue position. The framing invites a stronger reading of realism than the system supports, and anyone carrying this into a thin market would be carrying an assumption that does not hold there.

- **<font color="#ff0000">The reproducibility argument is undercut by the data licensing.</font>** The authors are upfront that the framework relies on commercial providers and cannot redistribute raw datasets, so what is open-sourced is the schema, the ingestion pipeline and the scorer, not the corpus. Two groups running QFinZero are not running the same benchmark unless both hold NASDAQ, MASSIVE and BENZINGA subscriptions, which means deterministic replay guarantees reproducibility within a lab and not across labs. Given that a standardised, reproducible environment is the paper's central claim, this is the limitation that most constrains what it actually delivers.

- **Module naming is inconsistent between the prose and the implementation.** The body text names the news and calendar module ESP and gives worked calls as `ESP.calendar.earnings`, while the toolchain listing in Figure 3 and every trace in Figure 4 use `NPP`. Cosmetic in isolation, mildly ironic in a system-demonstration paper whose contribution is schema consistency, and worth knowing before reading the repository.

#### Why this matters for my project

- **Take the three-metric decomposition as the evaluation harness for my own tool layer.** Whatever my four agents turn out to be, each of them queries data by ticker and date range and the orchestrator consumes what they return, so a CSE analogue of tool match, parameter accuracy and time alignment certifies that layer independently of strategy performance. That separation is worth building early for a specific reason: when a backtest comes out badly I need to be able to say it was the strategy and not a malformed date range, and without a harness of this shape I cannot.

- **The `as_of_ts` cursor answers the point-in-time problem I raised against [[Neo4j Graph-RAG for CSE]] and generalises past the fundamental channel.** Every channel in my design has the same exposure, annual reports retrieved without a publication-date filter, news timestamped by scrape rather than release, a persistence estimate fitted on a window running past the decision point. Enforcing one cursor at the data layer, rather than asking four agents each to remember to filter, is both the correct place for it and the only version I can actually audit.

- **Environment decoupling is the design decision to copy verbatim.** One API surface serving historical replay, simulated streaming and live-like operation with agent logic unchanged means a live or paper-traded demonstration later is a configuration change rather than a rewrite. For a project that will almost certainly be evaluated on replay, keeping that path open cheaply is worth the small amount of extra interface discipline it costs now.

- **Take PMB's shape and not its fills.** The order lifecycle, the state machine, the margin-aware account and the transaction log are all things I would otherwise design badly from scratch. The execution rules are where my own contribution has to live instead, so the friction model comes from [[A reinforcement learning approach to optimal execution]] and [[Online portfolio selection with state-dependent price estimators and transaction costs]], calibrated on CSE spreads and depth.

- **Storage tiering transfers even though the data does not.** Parquet partitioned by symbol and year for OHLCV, a relational store with composite indexes on date and ticker for announcements and corporate actions, a document store for news text. CSE volumes are a small fraction of NASDAQ's so this is overengineering by their standard, but the access pattern a backtest generates is exactly theirs, long sequential reads over a fixed window repeated many times, which is the pattern the layout exists for.

- **The tool layer is its own engineering problem with its own two decisions, validation and model tier.** If PA and TA are where frontier models fail against a well-documented schema built by its own authors, my agents will fail there harder against a schema I wrote myself that no model has ever seen, so the Data Portal's verify-then-execute step is the pattern to copy, with strict argument validation and explicit typed failures rather than silently empty result sets, because an empty series that an agent reads as a flat market is the failure I will not notice. The second decision follows from Qwen3 4B reaching 86.33: if invocation runs acceptably on a small open-weight model the frontier budget belongs to the reasoning agents and the orchestrator, and that is worth testing on my own tool surface before committing to a tier.

- **It sharpens what my contribution is not.** Standardised, agent-callable financial tooling is now published, open source and Apache-licensed, so unified data access and order simulation are plumbing in my writeup rather than contributions, which is the same demotion I already made for structure-aware retrieval after the Neo4j paper. What survives is the weighting function over heterogeneous agents, and QFinZero says nothing about it at all, which is a useful confirmation as well as a narrowing, because the paper closest to my infrastructure has no opinion on my research question.

> [!important]
> Cite this for the evaluation protocol, the point-in-time cursor and the storage design, never as evidence about trading performance. It measures whether an agent can call an API correctly and explicitly disclaims financial return, so any sentence of mine that uses a QFinZero number to say something about how well agents trade is a misreading I put there myself.

> [!NOTE]
> Repository is Apache 2.0 with an MCP server for LangGraph, so the licence is not a constraint. Worth checking whether the PMB order lifecycle and the TM/PA/TA scorer are separable from the commercial data adapters, since those two pieces are the ones I would reuse directly and the adapters are the ones I cannot use at all.
