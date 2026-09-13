Explores the value of prompt engineering by benchmarking  6 LLMs in 15 retrieval scenarios,
exploring 9 prompts over 2 real world financial domain dataset.

**<font color="#ffc000">Models assessed:</font>** GPT-3.5-turbo-0613,  GPT-4-0613, Llama-2-7B, Llama-2-13B, Llama-2-7B-chat, Llama-2-13B-chat

Given a user query, a typical RAG system employs a retriever system to fetch a list of documents likely relevant to the query from an information source (Retrieval). The documents are then fed into the context of the LLM, with users’ query / conversation history, and specific instructions / prompts on how to generate a response "grounded" in retrieved information (Generation)
![[Pasted image 20260913004818.png]]
This study benchmarks LLMs answer generation quality and explores the following aspects:
	1. Comparing different generative LLMs as answer generation models against each other and baseline (purely extractive) model
	2. Examining how various LLMs handle differences in the quality of information retrieval
	3. Exploring the impact of varying prompts on answer quality of RAG pipelines

For this study two curated datasets were used from the banking sector featuring real user queries.

In addition to generation quality, LLM's ability to adhere to instructions on aspects such as answer style, citation output format etc was also evaluated.

This study ran 1620 experiments to assess 6 LLMs in 15 retrieval conditions using 9 prompts over 2 datasets for 2 performance aspects.

Two RAG datasets from queries against two corpora were developed:
	1. **Banking Webpages:** Public webpages with general information on banking products
	2. **Banking Policy Guides:** Internal guides for customer service executives detailing policies and protocols for customer assistance

These were chunked webpages/articles into about 100 word document chunks (also referred as documents) while preserving sentence boundaries. Chunks with majority content in a non-English
language or those with fewer than 10 words were dropped.

#### Simulated Scenarios

**How does absence of retrieved "gold" document influence answer generation?**
	Created two retrieval conditions: Retriever-Only (returning the retrieved set which may or may not contain gold chunk(s)) versus Retriever-W-GT (guaranteed to have gold document to the retrieved list)

**How does the number of documents retrieved influence answer generation?**
	Created three conditions varying in the number of documents displayed to generation models: top_3, top_5, top_20

**How does order of retrieved documents influence answer generation?**
	Manipulated the display order of retrieved documents during LLMs’ response generation. For Retriever-Only, we added a new condition where we simply shuffled the order of the documents to judge the sensitivity to order in general. For Retriver-W-GT, we added two conditions where we injected the gold document in the first or last position. In summary, we created 15 retrieval conditions. For retrieval_only, we designed 2 (retriever_only, retriever_only_shuffled) x 3 (top 3, 5, 20); for retriever_w_gt, we designed 3 (retriever_w_gt, retriever_w_gt_first, retriever_w_gt_last) x 3 (top 3, 5, 20)

#### Prompts

In this work, the effect of prompting on generation in RAG pipelines was investigated. In particular, a set of prompts with variations in factors such as the verbosity of instructions, the need for direct quoting, explicit introduction of metrics within prompts, the requirement for citations, and specific response formatting, among other aspects were created.

|                                           |                                           |
| ----------------------------------------- | ----------------------------------------- |
| ![[Pasted image 20260913011548.png\|320]] | ![[Pasted image 20260913012148.png\|358]] |
![[Pasted image 20260913011634.png|337]]
#### Evaluation
Assessed based on the <font color="#ffc000">answer quality</font> and <font color="#ffc000">instruction following ability</font>.
	**Answer Quality**
		Measured using **Token F1 score** comparing generated responses against human annotated reference answer spans.
	**Instruction Following Ability**
		- **Structured Formatting Compliance**: Percentage of outputs adhering to exact syntax (`|||` delimiter or parseable JSON schema).
		- **Language Style (Quoting)**: Percentage of response sentences extracted verbatim from retrieved chunks.
		- **Completion-to-Reference Ratio**: Ratio of model output length to reference answer length (detecting over-generation and copying tendencies).

#### Empirical Results & Findings

**Retrieval Quality & Context Sensitivity**
- **Gold Document Absence & Pseudo-Helpfulness**: In `Retriever-Only` settings where the gold document is missing, LLMs frequently exhibit "pseudo-helpfulness"—attempting to generate an answer from marginally relevant distractors or hallucinating, rather than outputting "No Answer Found".
- **Distractor Noise Sensitivity**: In `Retriever-W-GT` settings, increasing context depth from Top-3 to Top-20 leads to a decline in Token F1 across all models due to the presence of distractor documents.
- **Position Bias (Lost-in-the-Middle)**: Placing the gold chunk in position 1 (`Gold Doc First`) yields significantly higher accuracy than placing it last (`Gold Doc Last`), particularly when context size is large (Top-20).

**LLM Model Comparison**
- **Overall Performance Hierarchy**: $\text{GPT-4} \gg \text{GPT-3.5-turbo} \gg \text{Llama-2-13B} > \text{Llama-2-13B-chat} \approx \text{Llama-2-7B} \approx \text{Llama-2-7B-chat}$
- All generative LLMs significantly outperformed the extractive RoBERTa baseline.
- Commercial OpenAI models demonstrated vastly superior distractor resistance, context reasoning, and answer precision compared to 7B/13B open-source alternatives.

 **Prompt Sensitivity**
- **OpenAI Resilience**: GPT-4 ($<4%$ variance across prompts) and GPT-3.5-Turbo ($\sim 6%$ variance) proved highly robust to prompt variations.
- **Open-Source Instability**: Llama-2 base models exhibited extreme sensitivity to prompt wording ($\sim 15%$ Token F1 variance).
- No single prompt feature (verbosity, explicit metric mention, or citation format) consistently boosted answer generation quality across models.

 **Instruction-Following & Metric Hacking**
- **Structured Compliance**: GPT-4 and GPT-3.5-Turbo achieved $>94%$ compliance across both JSON and pipe formats. Llama-2 models failed JSON parsing almost completely ($<0.1%$) and had low citation accuracy ($\le 57.6%$).
- **Metric Hacking via Copying**: Llama-2 base models inflated their Token Recall / F1 artificially by copying multiple consecutive lines from source chunks verbatim, resulting in a completion-to-reference ratio of $2.9 - 3.0$ (3x expected length).

#### Practical RAG Architecture Recommendations
- **Prioritize Retrieval Recall**: Maximize retriever recall as the first line of defense; unretrieved gold documents directly trigger pseudo-helpfulness and hallucinations.
- **Implement Re-ranking for Position & Precision**: Use re-rankers or fine-tuned retrievers to ensure gold documents are ranked at Position 1, directly counteracting lost-in-the-middle degradation and distractor sensitivity.
- **Model Tiering**: Leverage frontier commercial LLMs (GPT-4 tier) for applications requiring strict structured outputs, citation extraction, or complex multi-document reasoning.
- **Prompt Simplification for Smaller Open-Source LLMs**: When deploying 7B–13B open-source models, use concise, simple instructions and avoid demanding complex structured formats (like JSON) or multi-constraint prompts.