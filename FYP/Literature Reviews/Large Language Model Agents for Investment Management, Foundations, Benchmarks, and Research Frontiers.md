Saha, Lyu, Saxena, Zhao and Mehta, all five at BlackRock, ICAIF '25 Singapore, pages 736 to 744, nine pages of which two are references. This is a map rather than a method: there is no system, no dataset, no experiment and not a single equation anywhere in it, and every number on the page is a citation index. I am reading it for positioning, not for technique, and on that job it earns its slot, because it is the first survey I have read that annotates each reviewed system with which stages of an agent workflow that system actually implements. That annotation is the closest thing I have to direct evidence for the claim the whole project rests on, that coordinating heterogeneous agents is treated as a solved detail rather than as a design problem.

The scoping is narrow in a way that helps me. Consumer banking, fraud detection and anti-money laundering are explicitly out. The survey positions itself against two alpha-generation surveys spanning statistical models through to LLMs, against three broad LLMs-in-finance surveys that it says do not address agent frameworks in a trading or investment context, and against two that cover interpretability, governance and evaluation for general LLM agents rather than financial ones. What it claims for itself is a targeted review of generative AI inside trading and investment specifically, organised by function and by architecture, plus a compiled set of benchmark datasets.

#### The two maps it offers

Figure 1 is a ten-stage reference workflow for a financial LLM agent: user input and task perception, memory and context management, planning and task decomposition, reasoning plus action execution, observation and feedback handling, memory update, reflection and self-evaluation, multi-agent collaboration, output synthesis, evaluation. It is presented as a linear chain with single arrows, which is already a modelling choice worth noticing, since reflection and memory update are loops in every system that has them.

![[Pasted image 20260925190001.png]]

Figure 2 is the payload. Thirty-one named systems are sorted into seven use-case branches, Information Retrieval, Investment Research, Trading Agents, Portfolio Optimization and Quant Investment Strategy, Financial Risk Management, LLM Agents as Financial Advisors, Market Simulation and Testing Financial Theory, and each system is tagged with the stage numbers it implements. Read the tags rather than the branches, because the branches are conventional and the tags are not.

![[Pasted image 20260925190002.png]]

I counted the tags myself, the survey does not report these figures, so treat the table as my tally over Figure 2 and not as a result the paper states.

| Stage | What it covers | Systems tagged, of 31 |
| --- | --- | --- |
| 2 Memory | short and long term memory, summarisation | 12 |
| 7 Reflection | self-evaluation and improvement | 9 |
| 8 Multi-agent collaboration | ask-respond, debate | 13 |
| 10 Evaluation | evaluation inside the agent loop | 5 |

Two columns of that matter. <font color="#ffc000">Fewer than half the systems in a survey of multi-agent financial AI carry a multi-agent collaboration stage at all</font>, and of the thirteen that do, the survey's own worked examples of what collaboration means are ask-respond and debate. Both are protocols for producing one text from several texts. Neither is a weighting.

#### Where the weighting problem should sit, and does not

Stage 9, Output Synthesis, is a single undifferentiated box with no example patterns attached. Everything my project is about happens inside it and the survey has nothing to say about what goes on there. Written out, the difference between the surveyed synthesis step and what I am proposing is one term:

$$\text{Stage 9 as surveyed:}\quad D_t = g\big(A_{1,t},\dots,A_{n,t}\big) \qquad\text{against}\qquad D_t = \sum_i w_{i,t}\big(L_t, V_t, P_t, C_{i,t}\big)\, A_{i,t}$$

where $g$ is an unspecified aggregator, usually an LLM manager prompted to reconcile the agents, and $w_{i,t}$ is a weight that responds to liquidity, volatility, persistence and the agent's own confidence. The survey never distinguishes the two, which is the gap stated in the field's own vocabulary rather than mine.

Table 1 is the paper's only side-by-side comparison, four flagship research systems against six capabilities, and I have retyped it because the last row is the one that carries an argument. Read down Adaptive Agent Architecture and ignore the rest.

| Capability | FinRobot | MarketSenseAI | FinVerse | FinGPT Agent |
| --- | --- | --- | --- | --- |
| Agent type | 3-role Chain-of-Thought | 5 discrete functional agents | autonomic agents with code execution | multi-agent on fine-tuned LLM |
| Core innovation | structured CoT mimicking analyst cognition | multimodal sentiment-aware signal synthesis | executable analytics with 600+ financial APIs | layered stack, multimodal fusion, contrastive retrieval, optimisation |
| Qualitative context | SEC filings, earnings reports | stock news, pricing data, earnings calls | multiple categories including APIs and filings | multimodal news, visual charts, filings |
| RAG integration | partial, initial data ingestion | yes, HyDE plus expert documents | yes, chunked document retrieval | yes, with fine-tuned LLM |
| Tool or code execution | no | no | yes, code interpreter plus API calls | no |
| Adaptive agent architecture | **no, sequential** | **no** | **partial, planning loop plus self-reflection** | **RLHF** |

None of the four adapts how much any component counts. FinVerse's partial credit is a planning loop that decides what to do next, and FinGPT's RLHF tunes one model's outputs rather than the influence of several producers on one decision. This is the same fixed-influence pattern I have already documented in [[A Multimodal Foundation Agent for Financial Trading, Tool-Augmented, Diversified, and Generalist|FinAgent]], [[AlphaAgents, Large Language Model Based Multi-Agents for Equity Portfolio Constructions|AlphaAgents]] and [[QFinZero, A Unified Financial Toolchain for LLM-Based Trading Agents|QFinZero]], now visible across a wider sample.

The one exception the survey names is a three-stage system in the portfolio branch, reference 20, in which LLMs first extract alpha signals from multimodal financial data, pass them to specialised trading agents that evaluate performance under various market conditions, and then combine the validated signals through what the survey calls a <font color="#ffff00">dynamic weighting mechanism</font>, described elsewhere in the same paragraph as an <font color="#ffff00">adaptive gating mechanism</font> that tunes the influence of each signal in real time under shifting market conditions. Two sentences, no detail, no results. That is the nearest published prior art to my orchestrator that I have found, and the survey is the thing that found it for me. Two lesser near-misses sit beside it: an adaptive collaboration design in which agent groups coordinate flexibly according to task demand, built on AutoGen GroupChat over Dow Jones 10-K filings, and a confidence-aware critic that adaptively refines only low-confidence prompts without external signals, which is a mechanism for producing something like $C_{i,t}$ without a labelled target.

#### Evaluation and benchmarks

Section 3 sorts evaluation into four families: financial metrics, Sharpe, Sortino, Calmar, cumulative and annualised return, volatility, max drawdown, information coefficient and its rank variant; accuracy and reasoning metrics, classification accuracy, F1, exact match, SQL validity; <font color="#ffc000">behavioural fidelity metrics</font>, trading flow, position tracking, strategy adherence, responsiveness to events, agent longevity; and user-centric evaluation, usefulness, robustness, human alignment, elicitation accuracy, task completion, report readability. The distribution across Table 2 is the finding, not the taxonomy: financial metrics carry fourteen papers, accuracy and reasoning twelve, behavioural fidelity three.

![[Pasted image 20260925190003.png]]

Table 3 compiles seven benchmarks and their data. I have kept the goal and modality columns because the pattern across them is uniform and it is the pattern that matters.

| Benchmark | Goal | Data |
| --- | --- | --- |
| FinBen | holistic evaluation across financial AI | textual news, numerical reports |
| FinDABench | structured financial data reasoning | tabular company-level financials |
| INVESTORBENCH | simulated decision-making under complexity | news, macro indicators, investor profiles |
| Standard Benchmarks Fail | risk awareness and robustness testing | repurposed financial datasets |
| FinAR-Bench | fundamental equity analysis from documents | 10-Ks, earnings transcripts, stock prices |
| FinAgentBench | multi-step reasoning in agentic retrieval | SEC filings, transcripts, expert-annotated queries |
| StockBench | profitability, risk management, decision-making | news, stock-level prices, key company metrics |

The survey's own reading of interactivity across these is slightly damning: INVESTORBENCH is the only fully interactive agent-environment loop, two others are static and score reasoning over fixed inputs, FinBen supports multiple roles but its multistep decision sequences do not support dynamic environment feedback, and one benchmark uniquely evaluates an agent as a portfolio allocator under stress, prioritising robustness over performance.

> [!WARNING]
> Every one of the seven is built on US disclosure infrastructure, SEC filings, 10-Ks, earnings-call transcripts and US-tagged news feeds. <font color="#ff0000">None of them is portable to the CSE</font>, and no CSE-comparable frontier market appears anywhere in the survey. The compilation is useful to me as a design reference for what an evaluation should contain, and as nothing else.

#### Findings

- **<font color="#ffc000">The field's own reference workflow has no stage for deciding how much each agent counts.</font>** Ten stages cover perception, memory, planning, execution, feedback, reflection, collaboration, synthesis and evaluation, and the one that would hold a weighting function, Stage 9, is a single box with no example patterns while every other stage that matters gets two or three. The collaboration stage that does exist is exemplified as ask-respond and debate, both of which reconcile text into text. On this survey's evidence, the question of how much a given agent should count under given market conditions is not a question the field currently has a slot for, which is what I have been asserting from individual papers and can now assert from a taxonomy.

- **Adaptive architecture is rare and shallow across the systems the survey compares directly.** Of the four in Table 1, two are marked as having none at all, one has a planning loop that chooses the next action rather than the weight on an opinion, and one has RLHF inside a single model. That is a stronger sample than my previous evidence, which was two systems I had read in full, though it is still four systems chosen by the authors without a stated criterion.

- **One in-scope precedent exists and the survey gives it two sentences.** The three-stage alpha system with a dynamic weighting mechanism and an adaptive gating mechanism over validated signals is, on this description alone, doing something structurally similar to what I am proposing. What the survey does not say is what the gate conditions on, whether the weights are learned or heuristic, what the baselines were, or whether the gating was ablated. Until I read the primary paper I cannot say whether it occupies my gap, narrows it or leaves it open, and I should not write another sentence about my novelty before I do.

- **Evaluation sits outside the agent in almost every system, and behavioural evaluation barely exists.** Five of the thirty-one systems carry an evaluation stage in their own workflow, which is my tally and means evaluation as an internal loop component rather than whether the paper ran experiments. The Table 2 distribution points the same way from the other side, three papers in behavioural fidelity against fourteen in financial metrics, so responsiveness to events, strategy adherence and position tracking are named as a category and then almost never reported. The survey states plainly that there is no unified protocol for evaluating LLM agents in finance and that current assessments rely heavily on narrow backtests or synthetic prompts, often ignoring intermediate behaviours.

- **The heterogeneity that the survey does document is heterogeneity of reading, not of evidence.** The Heterogeneous Agent Discussion system it highlights has multiple agents independently interpret the same financial text and then discuss to synthesise a sentiment, which the survey calls a society of heterogeneous agents. That is several readings of one input, and the survey treats it as the representative case of heterogeneity. My claim is a different one, four agents consuming genuinely different evidence, and the distinction matters enough that I should make it explicitly rather than letting the shared word carry it.

- **Two items on the open-challenges list bite specifically in a thin market.** Hallucination is called out as worst in sparse or high-stakes financial domains, and interpretability is qualified by the cited finding that natural-language justifications are often not faithful to the model's internal reasoning. Both are asserted from other people's work rather than measured here, and both point the same way for a market with few analysts and thin news flow.

#### Limitations

- **<font color="#ff0000">There is no review protocol, so coverage cannot be checked.</font>** No search strategy, no databases, no query strings, no inclusion or exclusion criteria, no date range, no count of papers screened against papers retained. For a survey whose central artifact is a taxonomy over thirty-one systems, the absence of any account of how those thirty-one were chosen means the branch structure cannot be distinguished from the authors' reading list, and an empty cell in the taxonomy cannot be read as a gap in the field. This is the limitation that most constrains how hard I can lean on the paper, and it is the reason my own tally is stated as a tally rather than as evidence about the literature as a whole.

- **Nothing in it is evidence.** No results are compared, no numbers are quoted from the primary papers, no equations appear, and Table 1's cells are one-word or one-phrase judgements with no sourcing, so a reader cannot tell whether "no" in the adaptive architecture row means the authors checked and found nothing or that the primary paper did not use the word. The survey is a reading guide, and any sentence of mine that uses it as a warrant for a claim about how well anything performs is a sentence I have mis-sourced.

- **The stage annotations are the most valuable thing in the paper and the least documented.** Nowhere is there a definition of what qualifies a system as implementing a stage, so the difference between a system with a real memory module and one that concatenates recent context into a prompt is invisible, and the same is true of the collaboration stage that my whole reading of Figure 2 turns on. I am relying on these tags, so it is worth being blunt that they are unaudited, and the honest version of my tally is that thirteen of thirty-one systems were judged by these authors to collaborate, on a criterion they did not state.

- **Primary papers' priority claims are repeated without adjudication, and one self-citation is unflagged.** The survey writes that one trading system is, to its knowledge, the first to combine multimodal perception, tool-augmented reasoning, diversified memory and dual-level reflection, which is that paper's own abstract restated in the survey's voice, and separately three of the five authors are authors of AlphaAgents, which appears in the portfolio branch and in Table 2 without disclosure. Neither is serious alone, and together they fit a survey that summarises claims rather than testing them.

- **The open-challenges section is a list of headings, not a prioritisation.** Thirteen challenges get one paragraph each, evaluation gaps beside data privacy beside multimodal integration beside continual learning, with no argument about which is binding and no indication of which are near-term engineering against open research. It tells me what is hard, which I knew, and not what to do first, which is what a frontiers section is for.

#### Why this matters for my project

- **This is the citation for the positioning claim, scoped to what it can carry.** The permitted form is that a survey of thirty-one systems organises them by use case and by workflow stage without a stage for weighting agent influence, and that among the four systems it compares directly on adaptive architecture, none adapts the influence of one component on the decision. That is a claim about this survey's coverage, not about the literature, and I should pair it with the absence of a stated review protocol in the same sentence so the scoping is mine rather than something a reader catches me on.

- **The three-stage adaptive gating system goes to the top of the reading queue, before the gap wording is frozen.** It is the only described mechanism in the survey that conditions signal influence on market state, and the four things I need from it are what the gate conditions on, whether the weights are learned or heuristic, what it was compared against, and whether the gating itself was ablated. If it turns out to condition on volatility alone, the liquidity and persistence terms in my conditioning set are still open ground. If it conditions on a richer state than mine, the contribution has to move, most plausibly toward the heterogeneity of the producers rather than the adaptivity of the weights. **Resolved, see [[Automate Strategy Finding with LLM in Quant Investment]].** The primary paper's weights carry no time index: the adaptivity is at factor selection and the weighting is a static MLP trained once, so the survey's real-time gating description is not supported by the paper's own equations, and the system is my static-learned-weight baseline rather than a competitor to the orchestrator.

- **Behavioural fidelity gives my ablations a vocabulary and a second axis of results.** Responsiveness to events, strategy adherence and position tracking are named metric families that three papers in this survey report, and they are exactly what my state-input ablations should move. Dropping volatility from the conditioning set should show up as reduced responsiveness to volatility events, not only as a lower Sharpe, and reporting the behavioural change beside the return change is how I avoid the situation where the dynamic scheme beats the static learned weight by a margin too small to defend. This also gives the ablation table a row to fill when a return difference fails to clear significance on CSE-length data.

- **Liquidity has no branch, and that is worth one carefully scoped sentence rather than a claim.** The taxonomy has branches for trading, portfolio construction and risk management, my technical, fundamental and volatility channels all map onto one of them, and nothing in the seven branches or the thirty-one systems is a liquidity agent. Given there is no review protocol, this is consistent with liquidity being under-served in LLM agent work and is not evidence of it, so the way to use it is alongside the microstructure and liquidity notes already in the vault, never on its own.

- **Their evaluation verdict licenses building my own protocol, and the data blocker remains the real constraint.** The survey states there is no unified protocol and that existing assessments lean on narrow backtests and synthetic prompts, and every benchmark it compiles is built on US disclosure infrastructure that has no CSE analogue. So constructing a CSE evaluation is a necessity the field acknowledges rather than a shortcut I am taking. It does not help with the outstanding problem, which is still whether there is enough clean individual-stock CSE history to estimate anything on, and a benchmark table with no frontier market in it is a reminder that nobody is going to solve that for me.

- **Unfaithful chain-of-thought settles the shape of the explainability story.** If natural-language justifications are frequently not faithful to the reasoning that produced them, then an explanation layer that reports what the agents said about themselves is worth very little. What I already have is attribution over computed quantities, the orchestrator's weight vector, SHAP over risk features, interpretable volatility-model parameters, and citation tracing back to the retrieved passage, and all four are auditable in a way an LLM's narration is not. I should say this positively, as the reason for that design, rather than defending it later.

- **Two cautions to build a baseline against.** The survey reports a study that evaluates whether prompt-driven LLM agents merely reproduce classical strategies such as momentum or value, with agents neither trained nor aggregated and judged on theory-consistent behaviour rather than performance, which is a direct question to put to my technical agent: does it add anything over a prompted momentum rule on the same data. And the bilateral-exchange simulation in which prompt-encoded behavioural biases produce micro-level asymmetries that compound into power concentration and market collapse is a reminder that agent populations in thin books can move the thing they are trading. The first is a baseline I should run, the second is a caveat for the write-up rather than a design change, since my system is one participant.

> [!important]
> Cite this for the taxonomy, the stage annotations, the benchmark compilation and the no-unified-protocol statement. Never cite it for a performance claim, a comparison between systems, or evidence that any architecture works, because it contains no results of any kind. Where I want to say something about a system named in Figure 2, the citation is the primary paper, not the survey.

> [!NOTE]
> Follow-ups this generated, in order: the three-stage adaptive gating alpha system, **now read and written up in [[Automate Strategy Finding with LLM in Quant Investment]], where the survey's characterisation of it does not survive contact with the paper**; the position paper arguing standard benchmarks miss tail risk and proposing stress-test evaluation of an agent as a portfolio allocator, which speaks to both the volatility channel and the friction-aware layer; and the confidence-aware critic that refines only low-confidence outputs, which is the only mechanism in the survey for producing an agent confidence without a labelled target.
