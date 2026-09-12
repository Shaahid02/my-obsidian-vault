Revolves around chunk primary by structural element components of documents. Dissecting documents into these constituent elements.

Framework that evaluates how chunking based on element types annotated by document understanding models contributes to the overall context and accuracy of the information retrieved.

> [!info] RAG
> In RAG, instead of answering a user query directly using an LLM, the user query is used to retrieve documents or segments from a corpus and the top retrieved documents or segments are used to generate the answer in conjunction with an LLM.

This segmenting is called chunking. After chunking it is indexed by a <font color="#ffc000">retrieval system</font> and recovered and processed as required.  

The retrieval system in RAG can use traditional retrieval systems using bag-of-words methods or a vector database. If a vector database is used, then an embedding needs to be obtained from each chunk, thus the number of tokens in the chunk is relevant since the neural networks processing the chunks might have constraints on the number of tokens. As well, different chunk sizes might
have undesirable retrieval results.

This study uses financial reports from the US SEC. (Company reports that are publicly traded)

 Various strategies have been developed for text chunking:
	 - **Fixed Size Strategy:** divides text into uniform segments, but it often overlooks the underlying textual structure
	 - **Recursive Strategy:** iteratively subdivides text using separators like punctuation marks, allowing it to adapt more fluidly to the content
	 - **Contextual Strategy:** takes this a step further by employing NLP techniques such as sentence segmentation to represent the meaning in context
	 - **Hybrid Strategy:** combines different approaches, offering greater flexibility in handling diverse text types

This paper explores chunking based on element types (document structure), which involves analyzing the inherent structure of documents, such as headings, paragraphs, tables, to guide the chunking process.

However this issue can also be addressed by Markdown and LaTeX based chunking.

#### **RAG Pipeline** 
![[Pasted image 20260909115901.png]]

**Indexing and Retrieval**

VectorDB used: Weaviate
Encoder model: [sentence transformer](https://huggingface.co/sentence-transformers/multi-qa-mpnet-base-dot-v1)

In this experiment the top 10 chunks are retrieved for each question.
![[Pasted image 20260909120726.png]]
**Generation**

LLM used: GPT-4

Once the vector database has retrieved the top-10 chunks based on a question, the generation module generates the  based on the prompt.
![[Pasted image 20260909121151.png]]
**Chunking**
Baseline chunking method: One of (n ∈ {128, 256, 512})

Chunking was done:
	Based on the number of tokens
	Process documents using computer vision and natural language processing to extract elements

The list of elements considered are provided by the [Unstructured open source library](https://docs.unstructured.io/welcome)

> [!info] Chipper
> Chipper, a vision encoder decoder model inspired by Donut to showcase the performance difference. The Chipper model outputs results as a JSON representation of the document, listing elements per page characterized by their element type. Additionally, Chipper provides a bounding box enclosing each element on the page and the corresponding element text

 Given the structure of finance reporting documents, structural chunking efforts were concentrated on processing titles, texts, and tables. The following steps were taken to generate element based chunks:
	 - if the element text length is smaller than 2,048 characters, a merge with the following element is attempted.
	 - iteratively, element texts are merged following the step above till either the desired length is achieved, without breaking the element.
	 - if a title element is found, a new chunk is started.
	 - if a table element is found, a new chunk is started, preserving the entire table.

After the derivation, 3 types of metadata are generated to enrich the content and support efficient indexing. The first two are generated via prompt templates:
	1.  Up to 6 representative keywords of the composite chunk
	2.  A summarised paragraph of the composite chunk
	3.  Naive representation using the first two sentences from a composite chunk like a prefix (in case of tables: the description of the table, which is typically identified in the table caption)

**Dataset**
The [[FinanceBench, A New Benchmark for Financial Question Answering|FinanceBench]] dataset was used for evaluation.
#### Results
Evaluation is grounded in factual accuracy, which allows us to measure the effectiveness of each configuration by its precision in retrieving answers that match the ground truth, as well as its generation abilities.

**Evaluation analysis was based on 3 major parts:**
	1. **Chunking Efficiency**
		Observe the relationship between accuracy and total chunk size. Table 3 shows the number of chunks derived from each one of the processing methods. Unstructured element-based chunks are closer in size to Base 512, and as the chunk size decreases for the basic chunking strategies, the total number of chunks increases linearly
		![[Pasted image 20260912195600.png]]
	2. **Retrieval Strategy**
		 Page numbers in the ground truth to calculate the page-level retrieval accuracy. ROUGE and BLEU scores were used to evaluate the accuracy of paragraph-level retrieval compared to the ground truth evidence paragraphs.
		 When compared to Unstructured element-based chunking strategies, basic chunking strategies seem to have higher page-level retrieval accuracy but lower paragraph-level accuracy on average
		 A fascinating discovery is that when various chunking strategies are combined, it results in enhanced retrieval scores, achieving superior performance at both the page level (84.4%) and paragraph level (with ROUGE at 0.568% and BLEU at 0.452%).
		 ![[Pasted image 20260912200513.png]]
	3. **Q&A Accuracy**
		In addition to manual evaluation, we have investigated an automatic evaluation using GPT-4. GPT-4 compares how the answers provided by our method are similar to or different from the FinanceBench gold standard.
		The following prompt template was used for the automatic eval
		![[Pasted image 20260912200934.png]]
		Results show that element-based chunking strategies offer the best question-answering accuracy, which is consistent with page retrieval and paragraph retrieval accuracy. And also this approach stands out in <font color="#ffc000">efficiency</font>.  Element-based chunking achieves the highest retrieval scores with only half the number of chunks required compared to methods that do not consider the structure of the documents (62,529 v.s. 112,155)
		![[Pasted image 20260912201321.png]]
#### Discussion
We have observed that using basic 512 chunking strategies produces results most similar to the Unstructured element-based approach, which may be due to the fact that 512 tokens share a similar length with the token size within our element-based chunks and capture a long context, but fail keep a coherent context in some cases, leaving out relevant information required for Q&A

The findings support existing research stating that the best basic chunk size varies from data to data. These results show, as well, that element-based chunking adapts to different documents without tuning. This method relies on the structural information that is present in the document’s layout to adjust the chunk size automatically.

The paper experimented as well with variations of the verbs using in the prompt, e.g. changing referencing with using, which seemed to lower the quality of the answers generated. This shows that prompt engineering is a relevant factor in RAG.
#### Conclusion
Results show that our element based chunking strategy improves the state-of-the-art Q&A for the task, which is achieved by providing a better chunking strategy for the processed document.

<font color="#ffc000">Prompt engineering is a relevant factor in RAG as well.</font>