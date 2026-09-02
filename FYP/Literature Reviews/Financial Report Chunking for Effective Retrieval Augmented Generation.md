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