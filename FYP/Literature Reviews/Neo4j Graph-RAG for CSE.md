This is the paper my matrix has been carrying as an unverified supervisor-supplied citation, the 2025 CSE Neo4j Graph-RAG work that closed former G4, and it is now verified: Shamila, Silva and Talagala, Department of Computer Science & Engineering, University of Moratuwa, ERU Symposium 2025, DOI 10.31705/ERU.2025.35. It builds a Neo4j knowledge graph of Colombo Stock Exchange corporate structure out of annual report PDFs and puts a LangGraph agent in front of it that turns natural-language questions into Cypher. It speaks to exactly one part of my architecture, <font color="#ffc000">$A_F$, the fundamental and retrieval channel</font>, and to nothing else in it, so I am reading it as tooling and prior art rather than as a methodological template.

Two things need saying before anything else. First, this is a two-page extended abstract, not a full paper, so almost every number in it arrives without the apparatus that would let me weigh it. Second, that weakness does not give me back the novelty. Priority is priority, and structure-aware retrieval over CSE annual reports is now published work from a local group, which is the point the supervisor was making when they said the literature search was incomplete.

> [!info] Graph-RAG
> Standard RAG retrieves text chunks by vector similarity and hands them to an LLM. Graph-RAG retrieves from a knowledge graph instead, or in addition, so the retrieval step can traverse explicit typed relationships between entities rather than relying on those relationships happening to co-occur inside one chunk. The claimed advantage is on multi-hop questions, where the answer is an intersection or a chain that no single chunk contains.

#### Major differences to mine

The system is a question-answering interface over corporate structure. It answers who the directors are, who the auditor is, which subsidiaries a company owns, which directors sit on two boards. Mine needs a fundamental agent that emits a signal an orchestrator can weigh against a technical, a volatility and a liquidity agent, which means it needs the numbers in the financial statements, not the entity relationships around them. The paper is explicit that tabular financial data is out of scope and lists layout-aware parsing of tables as future work, so the gap between what it built and what $A_F$ has to be is precisely the part it did not do.

The second difference is temporal. Their graph is a static snapshot assembled from annual reports, with no as-of versioning, and the one sample query that mentions a year gets the year from the report text. Everything else in my system is a time series evaluated over a backtest window, so a fundamental channel has to be point-in-time correct or it leaks.

#### The pipeline

Annual report PDFs are chunked with a context-aware semantic strategy at a fixed window of roughly 1000 characters, preserving paragraph and section boundaries, and each chunk is embedded with Google Text Embedding 004 under a 3000-token input budget per document, into ChromaDB. Gemini 2.5 Pro then runs the extraction, but not over the whole document: it retrieves the top-5 relevant chunks per query and extracts entities into JSON inside a 500-token extraction context window. This is the paper's actual contribution, and it is worth naming plainly, <font color="#ffff00">question-driven targeted extraction</font> instead of full-document extraction.

The metric they define for it is Data Capture, the percentage of ground-truth entities and relationships successfully recovered from the benchmark subset, where a success requires both the correct number of entities and all the relationships attached to specific high-value fields such as entity type `DIRECTOR` with relationship type `HOLDS_POSITION`:

$$\text{Data Capture} = \frac{\left|\{e \in E_{gt} : e \text{ extracted}\}\right| + \left|\{r \in R_{gt} : r \text{ extracted}\}\right|}{|E_{gt}| + |R_{gt}|}$$

where:
- $E_{gt}$ is the set of manually annotated ground-truth entities in the benchmark subset
- $R_{gt}$ is the set of ground-truth relationships on the high-value fields
- the denominator is never stated numerically anywhere in the paper

Consolidation is the other piece worth taking. Entity names are unified by a custom fuzzy matching pipeline with type-specific similarity functions, strict surname and initials for people, normalised token-sort and word overlap for companies, and then a <font color="#ffff00">Human-in-the-Loop clustering interface</font> lets a reviewer merge or split clusters before variants are mapped onto canonical entity nodes under a rigid schema of `DIRECTS`, `OWNS`, `AUDITED_BY` and similar. Querying is a LangGraph/LangChain agent that decomposes a complex question into sub-queries, entity lookup then relationship traversal, and applies lightweight self-verification loops that reformulate and retry a sub-query returning incomplete or invalid output.

The resulting graph is company-centric, a star of typed edges around each listed entity, which is what Fig. 1 shows for Dialog Axiata PLC.

![[Pasted image 20260923235001.png]]

#### Findings

- **The headline result is a chunking and context-budget result, not a graph result.** Feeding entire reports to the LLM lost roughly 50% of the data to context window limits, while the question-driven retrieval pipeline reached over 85% entity capture on a manually annotated subset. Both figures come from their own pipeline at two stages of its development rather than from an external baseline, so this is a before-and-after on one system. It lands in the same place as the element-based chunking result in [[Financial Report Chunking for Effective Retrieval Augmented Generation]] by a different mechanism: that paper adapts the chunk to document structure, this one leaves the chunk fixed and makes the retrieval question-driven so the extractor only ever sees relevant text.

- **Graph RAG scored 9.2/10 against 6.1/10 for a standard RAG baseline, a 50% relative improvement, with the largest gains on multi-hop relational queries.** The benchmark is ten queries with manually extracted ground truth, scored on a 1 to 10 correctness scale. Ten queries, hand-scored, with no statement of who scored them or whether more than one person did, is an illustration rather than a measurement, and I should carry the direction of this result and not the magnitude.

- **The most transferable number is the reliability one: query failure rate fell from around 30% to under 2%** once the Neo4j subagent did query decomposition and self-correction retry. That is a claim about agent scaffolding rather than about retrieval quality, and it is the figure I would actually cite, because a 30% baseline failure rate on natural-language-to-Cypher is a useful prior on how unreliable that translation step is before you wrap it.

- **The graph holds over 6,000 unique entities** across companies, directors, executives, subsidiaries, auditors, products and sectors, which they describe as comprehensively capturing CSE corporate structure. The number of source annual reports is never given, so I cannot tell whether that covers the roughly 280 listed companies or a fraction of them, and the word comprehensively is doing work the paper does not support.

- **Fidelity depends on a human in the loop.** Expert review of the fuzzy-match clusters sits inside the consolidation step, before canonicalisation, so the capture and accuracy figures are those of a semi-automated pipeline. The paper is upfront that the HIL interface is there by design, but it never reports how many clusters needed intervention, which is the number that would tell me what a fully automated run costs in accuracy.

- **Tabular financial data is explicitly not handled**, stated in the conclusion and carried into future work as layout-aware parsing. The entity graph captures who governs and who owns; the revenue, margin, segment and EPS tables that a fundamental signal would be built from are untouched.

#### Limitations

- **The evidence base is two pages and cannot be reproduced from what is printed.** No corpus size, no company or year coverage, no annotated-subset size, no ablation over chunk size, embedding model or top-$k$, no description of the standard RAG baseline beyond the phrase without graph reasoning. Every design choice in the pipeline, 1000-character windows, 3000-token document budget, 500-token extraction window, top-5 retrieval, arrives as a stated constant with no tuning evidence behind it, so I can adopt them as reasonable defaults but not as validated ones.

- **The comparison does not isolate the graph.** Their system has both a Neo4j store with Cypher traversal and an agent that decomposes queries and retries on failure; the baseline has neither. Since they separately report that decomposition and retry alone took failure rate from about 30% to under 2%, a large part of the 9.2 against 6.1 could be the scaffolding rather than the graph, and the paper does not run the intermediate configuration that would tell them apart. The multi-hop gain is the part most plausibly attributable to traversal, but it is asserted as where the gains concentrated rather than reported per query class.

- **The Data Capture denominator is missing.** Over 85% entity capture on a manually annotated subset, with the subset unspecified, is not a figure I can compare against anything, and the definition is strict enough, correct entity count and all relationships on high-value fields, that the same pipeline would score very differently under a looser reading. The 50% loss figure it improves on is their own earlier naive approach, which makes the comparison a design history rather than a benchmark.

- **Nothing is reported on cost or latency**, although future work names latency in natural-language-to-Cypher generation as a target for caching and query optimisation, which implies it was a problem. Running Gemini 2.5 Pro over retrieved chunks of every annual report of every listed company is a recurring cost with a real number attached, and I have no estimate of it from here.

- **The graph is a point-in-time snapshot with no temporal model.** Board composition, ownership and auditor appointments change between reports, and there is no as-of field in the schema as described, so a query like the directors common to two companies in 2023 is answerable only because the year happens to be in the source text. For a backtest this is a lookahead hazard rather than an inconvenience.

#### Why this matters for my project

- **This citation is now verified and the unverified flag comes off it in the matrix.** Shamila, Silva and Talagala, ERU Symposium 2025, DOI 10.31705/ERU.2025.35, University of Moratuwa. It settles the first open item from the 20 September matrix status note, and it is the specific published work I should cite when the review chapter explains why structure-aware retrieval over CSE reports is a system component and not a claimed contribution. Former G4 stays demoted.

- **It costs me a novelty claim I had already given up and hands me a build recipe in exchange.** Semantic chunking on section boundaries at around 1000 characters, question-driven retrieval of the top-5 chunks, extraction in a small window rather than over the whole document, type-specific fuzzy matching into canonical nodes. For $A_F$ that is a defensible starting configuration from a local group working on the same corpus, and it removes a research question I would otherwise have had to answer from scratch.

- **The differentiation for $A_F$ is numeric, not architectural.** Competing on graph versus vector retrieval over CSE reports is competing where this paper already is. What it does not do is extract the financial statement tables, and those are what a fundamental agent needs to emit a signal the orchestrator can weigh against a technical or a volatility agent. So $A_F$ should be built on numeric statement extraction, which puts it in [[MultiFinRAG, An Optimized Multimodal Retrieval-Augmented Generation Framework for Financial Question Answering]] and [[Financial Report Chunking for Effective Retrieval Augmented Generation]] territory, with the entity graph as an optional grounding layer rather than the main object.

- **The self-correction loop suggests a mechanical confidence signal for $C_{F,t}$.** Retrieval-grounded systems produce things an orchestrator can actually observe, whether the generated Cypher validated, how many retries a sub-query needed, whether every claim in the answer traced to a retrieved chunk. That is a very different quantity from an LLM's self-reported confidence and it is comparable across runs. It does not solve the standing problem of making confidence comparable across four heterogeneous producers, but it is the first concrete proposal I have for one of the four, and the fundamental agent is the one where I had least idea what to measure.

- **The fundamental channel is not gated by the price-data blocker.** Annual reports are published artefacts that stay downloadable, so $A_F$ can be built and evaluated on its own while the question of individual-stock OHLCV depth beyond February 2025 is still open. That makes it the sensible component to prototype first, which is a scheduling consequence rather than a research one, but it matters given how much of the design currently waits on that dataset.

- **Annual-report evidence refreshes once or twice a year, and that is an argument for the orchestrator rather than against the agent.** A channel whose underlying evidence barely moves between reporting dates, sitting alongside liquidity and volatility states that move daily, is a near-constant input, which is the fixed-influence failure mode already documented in FinAgent's auxiliary strategies and AlphaAgents' dropped sentiment agent. I should say so explicitly: $A_F$ is the clearest case in my own design for why weights have to be state-dependent, and its weight trajectory around reporting dates is a natural test for the pre-registered weight-entropy diagnostic.

- **The point-in-time problem transfers directly and needs designing in now.** If $A_F$ retrieves from a corpus of reports without an as-of filter tied to publication date, the backtest sees FY2023 figures before they were released. Their static graph is fine for an interactive QA tool and not fine for mine, so the fundamental channel needs a publication-date field on every document and a retrieval filter keyed to the simulation clock.

- **Evaluation discipline, taken from their weakest point.** Their proposed system got both the graph and the agent scaffolding while the baseline got neither, so the comparison cannot attribute the improvement. My three-way orchestration comparison has exactly the same exposure if the dynamic configuration quietly gains machinery the static learned weight does not have. Baseline 2 has to be identical to the proposed system in every respect except the weighting function, and the ablations on liquidity, volatility, persistence and confidence have to move one input at a time.

> [!WARNING]
> Cite this paper for priority and for the pipeline design, not for its numbers. Ten hand-scored queries and an unspecified annotation subset will not survive a viva question about evidence, and if I lean on 9.2 against 6.1 as though it were a benchmark result, the weakness becomes mine rather than theirs.

> [!NOTE]
> Same department, same university, 2025, with a public GitHub repository linked from the paper. Worth checking whether the extraction and consolidation code is reusable, and the authors are reachable, which also bears on the outstanding question of who to approach about CSE data access.
