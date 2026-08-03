Very similar to mine.

Major differences being it is applied to very fluid stock markets such as the NYSE. Mine will be on the CSE, which is more turgid/ less fluid. Which means have to create equations to account for that turgidity. And also the fact that the market is dominated by [[#^b7c914|whales]].

Another major difference is when it comes to language for sentiment analysis. This paper does it in english, where as I'll have to extract sentiment from english, singlish, and sinhala.

I might also include an algotrading mechanism. (ML Component)

![[Pasted image 20260803235356.png]]

Overall required components
	1. Analysts team
	2. Research team
	3. Trader
	4. Risk Management team
	5. Fund Manager

Roles defined by the paper
	1. **Fundamentals Analyst** - Analyzes financial statements, earnings reports, insider transactions. Assess company's intrinsic value
	2. **Sentiment Analyst** - Gauge market sentiment through processing large volumes of social media posts, sentiment scores, and insider sentiments
	3. **News Analyst** - Analyze news articles, government announcements and other macro    economic indicators
	4. **Technical Analyst** - Calculate and select relevant technical indicators, such as MACD and RSI
	5. **Researcher**
		i. **Bullish Researcher** - Agents advocate for investment opportunities by highlighting positive indicators
		ii. **Bearish Researcher** - Agents focused on potential downsides, risks, and unfavorable market signals
	6. **Trader** - Execute trade decisions based on analysis provided by Analysts team and Research team
	7. **Risk Manager** - Assesses market volatility, liquidity, and counterparty risks. Implement risk minimization strategies, and provide feedback back to the analyst and research agents. Essentially creating a feedback loop. 

All agents follow the [ReAct prompting framework](https://arxiv.org/abs/2210.03629) 

### [Agent Workflow](Excalidraw/Research_Diagrams.excalidraw.md#^frame=Agent Flow)

![[Research_Diagrams.excalidraw|1000]]

### LLMs Used

Quick thinking models like gpt-4o-mini and gpt-4o for low depth tasks like summarization, data retrieval, and converting tabular data to text

Deep thinking models like o1-preview for reasoning intensive tasks like decision making, evidence based report writing, and data analysis.

*Whales - People with very large incomes that control the market by having the ability to move large amounts of stock ^b7c914