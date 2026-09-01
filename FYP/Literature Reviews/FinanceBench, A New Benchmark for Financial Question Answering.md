
Focuses on the shortcomings of RAG for financial questioning.
Provides the [dataset](https://github.com/patronus-ai/financebench) for evaluating this shortcoming.

Challenges faced by LLMs in financial domain:
	- Needs domain-specific knowledge about financial topics and terminology
	- Needs up-to-date financial information and to understand relevant financial news
	- Financial questions often involve numerical reasoning, an area in which LLMs often make mistakes when asked to make calculations
	- Needs to handle both unstructured inputs (e.g. qualitative questions in the form of free-text) and structured inputs (such as tabular data)
	- Needs to handle multiple bits of information (sometimes from multiple documents) and parse long passages of text

There multiple ways to assess a LLMs performance in interpreting financial data.

<font color="#ffc000">FiQA</font> was introduced with a focus on aspect based sentiment analysis and “opinionated Question Answering”. However, it is limited as sentiment analysis comprises only a small proportion of
the questions that financial analysts ask about companies. It is a high-quality open-source dataset of over 8,000 question and answer pairs, written by financial experts.

 <font color="#ffc000">ConvFinQA</font> was built on FiQA, instead of stand-alone questions, each interaction can involve several questions that may depend on the previous questions/answers. This is a more realistic and more complex testing setup. ConvFinQA comprises 3,892 conversations with 14,115 questions.

<font color="#ffc000">FINANCEBENCH</font> is a benchmark dataset that comprises 10,231 questions, answers, and evidence
triplets. It covers 40 companies that are publicly traded in the USA and 361 public filings, released
between 2015 and 2023, including 10Ks, 10Qs, 8Ks, and Earnings Reports.

Each entry in FINANCEBENCH includes the question itself (e.g. “What is Boeing’s FY2022 cost of goods sold (in USD millions)? ”), the answer (e.g. “$63,078 million”), an evidence string (which contains the information needed to verify that the answer to the question is correct) and a page number from the relevant document.

There are three types of questions in FINANCEBENCH,
	1.  **25 Domain related questions**
		These questions are generically relevant to financial analysis of a publicly-traded company, such as whether it has paid a dividend in the last year, or whether operating margins are consistent throughout multiple financial periods
	2. **Novel Generated Questions**
		Annotators were directed to use their knowledge and experience to ask questions that are realistic (in the sense that they relate to important information a financial analyst would want to know); varied (in the sense that they should utilize different parts of the reports, cover different topics, and are phrased differently); and challenging (in the sense that they should not be purely extractive but, instead, involve reasoning)
	3. **Metrics Generated Questions**
		Annotators extracted 18 specific metrics ("base metrics") from the three main financial statement, these were then used to construct a series of derivative metrics (metrics whose values are derived from the base metrics). For example, net income margin is derived from the two base metrics: (1) net income and (2) total revenue. Questions and answers were then constructed from both the base and the derivative metrics, using templates that were specific to each combination of metric, company, fiscal year, and financial statement(s). In some cases, the questions were purely extractive (e.g. “What is the FY2019 unadjusted operating income (as reported by management) for Amazon?”)

A taxonomy was created to better understand the strengths and weaknesses of AI QA tools. 
There are three types of questions in the taxonomy:
	1. **Numerical reasoning :** refers to performing mathematical calculations or comparing numerical data.
	2. **Logical reasoning:** refers to using logical deductions to evaluate, contrast, or make judgments regarding the information in the filings. It includes qualitatively assessing information about the company and assessing numerical calculations, such as evaluating computed values.
	3. **Information Extraction:**  refers to extracting specific data or textual content from the filings

Vector store was used to store the documents as is the convention when it comes to RAG.
A shared vector store was created which used Chroma Database, langchain implementation and OpenAI embeddings.

Overall models that have longContext perform better. Giving too much does cause it to be lost.

**Overall Peformance**
![[Pasted image 20260901111432.png]]![[Pasted image 20260901111509.png]]
- **Correct Answer**: desired behavior of models
- **Incorrect Answer:** vary, from calculations that are off by small margins to several orders of magnitude, and from making up legal information to giving the wrong direction for an effect
- **Failure to Answer:** if the model explicitly states that it cannot answer because it does not have access to the right information then it is a failure to answer
![[Pasted image 20260901111825.png]]