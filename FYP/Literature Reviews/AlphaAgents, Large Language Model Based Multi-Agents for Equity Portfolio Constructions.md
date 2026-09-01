## Major differences to mine

No social media agent
Wont work for the CSE (fluidity)
No risk calculating agent

## Standout features

Reflection enchanced prompting
Multi Agent Debate
Utilize Observability tool

# Paper Summary

Explores how LLM based agentic system can mitigate cognitive biases.

Mitigating AI-specific issues such as hallucination through collaborative task delegation to
unbiased AI agents.

look into FinVerse 

Prior studies often emphasize chain-of-thought prompting but neglect structured agent interaction strategies. Moreover, the role of agent-specific risk tolerance in shaping financial decision outcomes has received little attention.

Study consists of three specialized micro agents
	1. **Fundamental Agent**
		Qualitatively and quantitatively analyzes an equity’s projected trajectory and financial performance. Uses 10-K and 10-Q reports[^1].
	2. **Sentiment Agent**
		 Analyze financial news and provide recommendations based on the prevailing sentiment toward an equity and its potential impact on stock prices.
	3. **Valuation Agent**
		Analyze stock prices and volumes, providing a valuation assessment to inform the stock’s relative significance within a portfolio.

The three specialized AI agents collaborate to analyze individual stocks and produce comprehensive stock analysis reports. The agents may reach differing conclusions when analyzing the same problem, due to either reasoning divergences or underlying hallucination issues. To address this, the framework incorporates an internal debating mechanism, allowing agents to engage in discussions when their analyses diverge. This process continues until consensus is achieved, thereby improving the multi-agent reasoning capability and reducing hallucinations.

![[Pasted image 20260809205115.png]]

> [!NOTE] Role Prompting
> Role prompting is a prompt engineering technique that involves guiding a conversational agent by assigning it a specific role or context.

## Prompts used for each Agent
|                   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | 
| Valuation Agent   | As a valuation equity analyst, your primary responsibility is to analyze the valuation trends of a given asset or portfolio over an extended time horizon. To complete the task, you must analyze the historical valuation data of the asset or portfolio provided, identify trends and patterns in valuation metrics over time, and interpret the implications of these trends for investors or stakeholders.                                                                                                                                                                             |
| Sentiment Agent   | As a sentiment equity analyst your primary responsibility is to analyze the financial news, analyst ratings and disclosures related to the underlying security; and analyze its implication and sentiment for investors or stakeholders.                                                                                                                                                                                                                                                                                                                                                   |
| Fundamental Agent | As a fundamental financial equity analyst your primary responsibility is to analyze the most recent 10K report provided for a company. You have access to a powerful tool that can help you extract relevant information from the 10K. Your analysis should be based solely on the information that you retrieve using this tool. You can interact with this tool using natural language queries. The tool will understand your requests and return relevant text snippets and data points from the 10K document. Keep checking if you have answered the users’ question to avoid looping. |

## Tools

The sentiment agent employs <font color="#ffff00">reflection-enhanced prompting</font>, in which the model is explicitly instructed to reason, critique, and refine its summary. The model is encouraged to reason through or evaluate the content before summarizing, often involving multiple steps like summarizing, critiquing, and refining, which leads to more coherent and insightful summaries compared to direct extractive methods.

For the fundamental agent
	1. **Report Pull Tool** - pulls the relevant reports to the specific stock.
	2. **Report RAG Tool** - leverages context trucking based on report sections to keep relevant information and uses GPT 4-o as embedding model. Performs an analysis answering questions relevant to cash flow and income, operations and gross margin, areas of concern and progress towards its stated objectives.

Utilizes the <font color="#ffc000">Microsoft AutoGen</font> framework as the infrastructure for our multi-agent system, leveraging its group chat and assistant agent capabilities.

Autogen Studio serves as the user interface.


> [!NOTE] Multi Agent Debate
> Debate is managed via a round robin approach. Each agent receives the query along with peer analyses and the discussion continues until consensus is reached. Each agent gets two turns to present their arguments / findings.

## RAG Evaluation

Uses an observability platform called [Arize Phoenix](https://github.com/arize-ai/phoenix)


[^1] 

[^1]: Form 10-K and Form 10-Q are mandatory reports that public companies file with the U.S. Securities and Exchange Commission (SEC). The 10-K is a detailed annual report with audited financial data, while the 10-Q is a shorter quarterly update with unaudited financial statements filed three times a year.
