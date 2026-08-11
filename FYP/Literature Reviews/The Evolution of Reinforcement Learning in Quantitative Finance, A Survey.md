Risk Performance Measures (RPM) such Sharpe Ratio

The general pattern of normal ML training is
	1. The training of an ML model such as a Support Vector Machine (SVM), NN, or Decision Tree with a specific dataset (features), followed by the generation of a forecast or signal over 𝑛 periods ahead.
	2. The integration of this forecast or signal into a trading system to determine actual trading action or holdings (e.g., buy, sell, or hold in three discrete representations) at a single stock or portfolio level.

This method does not work well because
	1.  **Unsuitable Optimization metrics**: They focus on minimizing <font color="#ffff00">forecast error</font> which is often misaligned with the practical needs of financial trading, where <font color="#ffc000">RPMs like SR</font> is more relevant. This leads to suboptimal outcomes.
	2.  **Limited computational agility**: The two step process in supervised learning increases complexity and slows predictions. Creates a roadblock because market conditions can change rapidly.
	3. **Limited integration of the financial environment**: Traditional methods such as the conventional portfolio optimisation consist of a process that involves two distinct steps: first, calculating the expected returns and the covariance matrix of the assets; second, using these inputs in mean-variance optimisation to manage a predefined risk budget. The separation of these steps can limit the cohesion and adaptability of the framework. In contrast RL integrates this two step process into one promoting a more cohesive framework.
	4.  **Limited consideration of restraints**: 