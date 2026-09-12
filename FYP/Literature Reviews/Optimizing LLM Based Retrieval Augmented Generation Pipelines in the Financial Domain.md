Explores the value of prompt engineering by benchmarking  6 LLMs in 15 retrieval scenarios,
exploring 9 prompts over 2 real world financial domain dataset.

**<font color="#ffc000">Models assessed:</font>** GPT-3.5-turbo-061,  GPT-4-0613, Llama-2-7B, Llama-2-13B, 

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
