

> [!NOTE] 
> *“Reinforcement learning is learning what to do–how to map situations to actions–so as to maximise a numerical reward signal.”*


Risk Performance Measures (RPM) such Sharpe Ratio

The general pattern of normal ML training is
	1. The training of an ML model such as a Support Vector Machine (SVM), NN, or Decision Tree with a specific dataset (features), followed by the generation of a forecast or signal over 𝑛 periods ahead.
	2. The integration of this forecast or signal into a trading system to determine actual trading action or holdings (e.g., buy, sell, or hold in three discrete representations) at a single stock or portfolio level.

This method does not work well because
	1.  **Unsuitable Optimization metrics**: They focus on minimizing <font color="#ffff00">forecast error</font> which is often misaligned with the practical needs of financial trading, where <font color="#ffc000">RPMs like SR</font> is more relevant. This leads to suboptimal outcomes.
	2.  **Limited computational agility**: The two step process in supervised learning increases complexity and slows predictions. Creates a roadblock because market conditions can change rapidly.
	3. **Limited integration of the financial environment**: Traditional methods such as the conventional portfolio optimisation consist of a process that involves two distinct steps: first, calculating the expected returns and the covariance matrix of the assets; second, using these inputs in mean-variance optimisation to manage a predefined risk budget. The separation of these steps can limit the cohesion and adaptability of the framework. In contrast RL integrates this two step process into one promoting a more cohesive framework.
	4.  **Limited consideration of restraints**: Traditional frameworks typically incorporate constraints like transaction costs and liquidity in a static manner, relying on predefined assumptions that may not accurately capture the dynamic nature of financial markets. In contrast, RL frameworks allow for real-time integration of these constraints. However, it is important to note that RL models often simplify transaction costs as fixed and assume certainty of execution, overlooking market realities like varying bid/ask spreads. Some studies address these complexities by incorporating execution and slippage costs.
	5. **Adaptability to Changing Market Conditions:** Financial markets are inherently dynamic and continuously evolving. Traditional methods, may struggle to capture these changes promptly, often proving slow to adapt to shifting market conditions. In contrast, RL algorithms are capable of continuously learning and adapting in real time. Dynamic models itself can be trained to generalize across unseen transition functions, thereby enabling <font color="#ffc000">zero-shot adaptation</font>

QF’s complexity and dynamism considerably surpass RL’s conventional learning tasks.


> [!WARNING] Black Box Issue
> Interpretability is crucial in finance as stakeholders must understand how an algorithm arrives at its decisions and validate its recommendations


### Simplified View 
![[Pasted image 20260827203129.png]]
The agent receives information about the state 𝑆𝑡 ∈ S and a reward at time 𝑡 and reacts upon this information with actions 𝐴𝑡 ∈ A. The resulting action feeds back to the environment, and the system generates a new state 𝑆𝑡+1 and a new numerical reward 𝑅𝑡+1 ∈ R ⊂ R at time 𝑡 + 1.5 The goal is to learn a policy to maximize the expected total reward, which effectively creates a trajectory that can be represented as follows:

			𝑆0, 𝐴0, 𝑅1, 𝑆1, 𝐴1, 𝑅2, ...

### Multi Agent System

Extends the single agent paradigm where multiple agents interact either competitively or cooperatively.

![[Pasted image 20260827204351.png]]
- **Agents:** Each agent 𝑖 has its own set of states 𝑆𝑖 , actions 𝐴𝑖 , and policies 𝜋𝑖 . Agents can have distinct state spaces 𝑆𝑖 depending on their roles and the information they can access. Similarly, agents can have distinct action spaces 𝐴𝑖 , reflecting their different capabilities or roles in the environment.
- **State Space:** The joint state space 𝑆 is a combination of all individual states 𝑆 = 𝑆1 × 𝑆2 × . . . × 𝑆𝑛 .
- **Action Space:** The joint action space 𝐴 is the Cartesian product of all individual action spaces 𝐴 = 𝐴1 × 𝐴2 × . . . × 𝐴𝑛 .
- **Reward Function:** The reward function 𝑅 : 𝑆 × 𝐴 → R𝑛 provides a vector of rewards for all agents, where each component 𝑅𝑖 corresponds to the reward received by agent 𝑖.
- **Policies:**  Each agent follows a policy 𝜋𝑖 : 𝑆𝑖 → 𝐴𝑖 , mapping states to actions.
- **Objectives:** The goal is to find a set of policies, 𝜋 = (𝜋1, 𝜋2, . . . , 𝜋𝑛 ), where each policy 𝜋𝑖 maximises the cumulative reward for its respective agent. Depending on the application, this may involve maximising the cumulative reward for all agents collectively or maximising individual rewards independently.
- **Information Sharing:** Agents share observations or information to enhance decision-making, leading to more informed actions and better performance
- **Shared States:** Agents access a global or subset of shared states, enabling coordinated actions
- **Joint Actions:** Agents coordinate actions to achieve common goals, such as synchronizing trades to influence market prices
- **Cooperative and Competitive Interactions:** Agents work cooperatively for joint rewards or competitively for individual rewards, depending on the financial application


> [!WARNING] Market Predictability
> Unlike controlled simulation environments, real-world markets are unpredictable and influenced by myriad factors such as information asymmetry, variable transaction costs, taxes, and noise traders, which can significantly affect model performance 

### Critical conditions for RL in QF
1. **Transition from Simulation to Real World Application:** Mandates the necessity for the development of a risk management framework. 
2. **Sample Efficiency:** Techniques such as model-based RL, experience replay, and transfer learning are valuable. Helps to simulate various market conditions to create synthetic data in a stock-trading scenario. This data helps the model learn how to handle different market situations.
3. **Online vs Offline RL Settings:**<font color="#ffc000"> Online learning </font>in QF refers to agents learning and adapting continuously as new data arrive.  However, this can be highly impractical in HFT, where decisions occur in microseconds to milliseconds. In contrast, <font color="#ffc000">offline RL </font>uses historical data to develop strategies without continuous interaction with the environment. This method is particularly useful for backtesting and strategy development.
4. **On-Policy vs Off-Policy Frameworks:** <font color="#ffc000">On-policy algorithms</font>, such as Proximal Policy Optimisation (PPO), use data generated only from the current policy. This means that only actions taken by the current policy generate data at each training iteration. On-policy algorithms are typically more stable and exhibit lower variance because they learn directly from the policy they are improving and  practical in HFT due to the vast amount of data available despite being sample inefficient. <font color="#ffc000">Off-policy methods</font>, such as DQN, do not have this limitation, allowing them to use data generated from different policies. This makes off-policy methods more sample-efficient, as they can reuse past experiences stored in memory. Also could be used in HFT due to their ability to process large amounts of data, although they may require longer training times, which is crucial in the HFT context. 

### Main Reinforcement Learning Methods
#### 1. Value-Based Methods/ MDP Framework (Critic Only)
Value-based methods in RL focus on directly actions of the agent to derive the best policy.
Core Framework:
	1. **Define a Finite Set of States S<sub>t</sub>** at each time point t (Includes info like financial accounting data, prices, sentiment, and technical indicators.)
	2. **Define a Set of Actions A<sub>t</sub>** at each time point t (i.e. Buy, Sell, Hold) <font color="#ffc000">discrete</font>
	3. **Establish transition probabilities**, which define state transitions based on actions
	4. **Formulate a reward function R<sub>t</sub>** which provides feedback  to agent 
	5. **Create a Policy 𝜋,** which <font color="#ffc000">maps states to actions</font> for agent to follow
	6. **Construct a Value Function V**, which maps states to the agent’s expected total discounted reward from a given state until the episode’s end under policy 𝜋

Agent continuously interacts with the market (actions), and through trial and error aims to discover the best possible strategy known as the <font color="#ffc000">optimal policy</font> (𝜋 = 𝜋<sup>*</sup>). Applies <font color="#ffc000">Markov Decision Problem </font>(MDP) to financial trading.

These methods employ algorithms like Q-Learning and SARSA to optimise the expected total reward. But these algorithms are proven to converge to the optimal solution with probability 1. They are traditionally used in tabular settings.

Major drawback: High bias
#### 2. Policy-Based Methods (Actor Only)
 Policy-based methods in RL focus on directly optimising the policy that dictates the agent’s actions. This approach can be particularly advantageous in environments with continuous action spaces and complex dynamics.
 
 The RRL framework is particularly suited for financial applications because it can capture the temporal dependencies and sequential nature of trading decisions.

Under the standard RRL framework, the trading position (action) $A_t$ at time $t$ is represented as [51]: $$A_t = A(\theta_t : A_{t-1}, I_t) \in {-1, 0, 1}$$

where:

- $\theta_t$ represents the learned parameter vector [51].
- $A_{t-1}$ is the agent's prior trading action (or position) at time $t-1$ [51].
- $I_t$ represents the current state information set, composed of lagged asset prices $z_t$ and external variables $y_t$ [51].

A common single-layer neural implementation models the trading position using the sign activation function [52]: $$A_t = \text{sign}(u A_{t-1} + v_0 r_t + v_1 r_{t-1} + \dots + v_m r_{t-m} + \omega)$$

where $r_t$ denotes price returns, and $\theta_t = \theta = {u, v_i, \omega}$ represents the parameter set to be optimized [52].

To train the model, the system directly maximizes an objective performance function, $U_t(\theta)$, which can represent cumulative wealth, utility, or risk-adjusted ratios like the Sharpe Ratio [52, 93]. A representative reward formulation is the additive profits utility function with transaction costs [53]: $$U_t(\theta) = P_T = \sum_{t=1}^T R_t = \mu \sum_{t=1}^T \left{ r_t^f + A_{t-1}(r_t - r_t^f) - \delta_t |A_t - A_{t-1}| \right}$$

where $P_T$ is the cumulative profit, $\mu > 0$ is a fixed position size, $r_t$ and $r_t^f$ are the returns of the risky and risk-free assets, respectively, and $\delta_t$ denotes transaction costs incurred during position transitions [53].

RRL parameters are optimized online via stochastic gradient ascent: $\Delta \theta_t = \rho \frac{dU_t(\theta)}{d\theta}$, where the cross-temporal gradients are computed as [54, 55]: $$\frac{dU_t(\theta)}{d\theta} = \frac{dU_t(\theta)}{dR_t} \left{ \frac{dR_t}{dA_t} \frac{dA_t}{d\theta} + \frac{dR_t}{dA_{t-1}} \frac{dA_{t-1}}{d\theta} \right}$$

Numerous variations of this framework have been proposed, including the addition of hidden layers to capture complex patterns (DRRL) [56] or threshold extensions to handle regime shifts [74].	
 
A significant advantage of Policy-based methods is the continuous action space for the agent:
	Consider a portfolio of stocks: with the Value-based approach, portfolio weights can only take discrete values like buy, sell, or hold. In contrast, the Policy-based approach allows portfolio weights to assume any value in [0, 1] in the long-only case

Policy-based methods require a differentiable reward function

Major drawback: High variance
#### 3. Actor-Critic Method (Hybrid)
Combines the previous two methods and treats them as modules which creates a core framework:
	1. **Actor Module:** Responsible for selecting actions based on the current state. It learns a policy, which is a mapping from states to actions. This policy can be,
		1.<font color="#ffc000"> Deterministic</font>: The Actor always chooses the same action for a given state
		2. <font color="#ffc000">Stochastic</font>: The Actor chooses actions according to a probability distribution
	2. **Critic Module:** The Critic evaluates the action taken by the Actor by computing a value function. This value function estimates the expected cumulative reward (discounted over time) of being in a given state and taking a particular action.
	3. **Advantage Function:** The advantage function helps to determine how much better or worse a particular action is compared to the average action taken from that state. It is defined as:
$$
				𝐴(𝑆𝑡 , 𝐴𝑡 ) = 𝑄 (𝑆𝑡 , 𝐴𝑡 ) − 𝑉 (𝑆𝑡 ), 
		$$
							Q : Action Value function
							V: State Value function
	4.  **Gradient Ascent:** Both the Actor and the Critic are trained using gradient ascent. The Actor updates its policy parameters to maximise the expected cumulative reward, while the Critic updates its parameters to provide more accurate evaluations of the actions.
	5.  **TD Error:** Temporal Difference (TD) error is used to update both the Actor and the Critic. It is the difference between the expected reward and the actual reward received, given by:				$$𝛿𝑡 = 𝑅𝑡+1 + 𝛾𝑉 (𝑆𝑡+1) − 𝑉 (𝑆𝑡 ).$$
Most compelling of the four primary approaches, as it combines the advantages of both Policy-based and Value-based RL methods. Therefore able to diminish each others shortcomings. High variance and high bias respectively.

#### 4. Model-Based Methods (Model)

Least researched area.

Constructing a model of the environment, which is then used to simulate and plan actions

Core Framework:
	1. **Define a Finite Set of States S<sub>t</sub>** at each time point t (Includes info like financial accounting data, prices, sentiment, and technical indicators)
	2. **Define a Set of Actions A<sub>t</sub>** at each time point t (i.e. Buy, Sell, Hold) <font color="#ffc000">discrete</font>
	3. **Learn transition probabilities,** construct a model that predicts the next state S<sub>t+1</sub> and reward R<sub>t+1</sub> given the current state and action. Model can be a neural network or any other function approximator.
	4. **Formulate a Reward Function R<sub>t</sub>,** numerical feedback to agent in response to its preceding action. (Profit, risk, transaction cost)
	5. **Planning and policy optimisation,** used to simulate future states and rewards, allowing the agent to plan and optimise actions. (Monte Carlo Tree Search, Dynamic Programming)

Standout qualities/problems:
	1. **Learning Speed:** Model-based RL methods typically learn faster than model-free approaches by using the learnt model for planning and action optimisation, crucial for timely financial market decisions.
	2. **Computational Complexity:** Simulating and planning with complex financial models is computationally intensive, requiring efficient algorithms and high-performance computing, especially for HFT applications.
	3. **Risk Management:** Robust risk management is vital. Model-based RL can simulate extreme market scenarios to assess potential risks, helping to develop strategies that maximise returns and manage risks effectively.

### Environment Modeling, Features, and Extraction Mechanisms

> [!important]
> In the RL framework, the environment characterises the current state of the system. The agent, the learner, and decision maker interact with this environment, selecting actions based on state information.

This requires the agent and environment to be mutually exclusive, providing distinct boundaries for rewards, actions, and states.

External factors affecting the environment,
	- Stock indices
	- Interest rates
	- Commodity prices
	- Macroeconomic causes
	- Politics
	- Natural risks

The MDP framework can only be applied if the environment is fully observable and future states depend only on the current state and action, a property which is known as <font color="#ffc000">Markov property</font>

<font color="#ff0000">This is not possible in a financial context</font>, due to above listed factors.

Therefore given the complexity and partial observability of financial markets, a <font color="#ffc000">Partially Observable Markov Decision Process (POMDP)</font> framework is more appropriate.  In Partially Observable (PO) environments, the transition probabilities between states in financial markets are typically not explicitly modelled. Instead, historical data and statistical methods, such as<font color="#ffc000"> LSTM or RNN</font> , are used to approximate these transitions.

> [!warning] Unpredictability
> This approach acknowledges the inherent randomness and partial observability offinancial markets, making exact environment representation virtually impossible.
#### Features

To manage randomness , avoid the curse of dimensionality, and address interpretability issues strategic feature selection is necessary.

State representation commonly incorporates discrete state, technical analysis, pricing data, macroeconomic indicators, sentiment data, current position, and Limit Order Book (LOB) data.

1. **Price History**
	Price history, represented as Open-High-Low-Close-Volume (OHLCV) bars, serves as the fundamental bedrock of state construction. However , raw OHLC features exhibit extremely high collinearity, which can inject input noise and degrade function approximation stability

	Therefore <font color="#ffc000">market volatility</font> which is an important metric for risk management and regime shift detection should also be considered. Features include:
		-  **Historical Standard Deviations**: Rolling standard deviations of log-returns across varying temporal horizons.
		- **GARCH Volatility**: Generalized Autoregressive Conditional Heteroskedasticity features, first integrated into policy-gradient RRL frameworks by Zhang and Maringer to capture time-varying volatility clusters.
		- **Covariance Matrices**: Full rolling covariance matrices of asset returns are modeled directly in state spaces to enable dynamic cross-sectional risk budgeting .
		- **Regime-Switching Extensions**: Volatility-driven threshold rules used to identify structural market regimes (e.g., bull, bear, or sideways markets) and dynamically switch underlying agent parameters.

2. **Technical Analysis**
	Technical analysis employs indicators and rules to predict price directions based on past price and volume data. Indicators such as Moving Average (MA), Exponential Moving Average (EMA), Moving Average Convergence/Divergence (MACD), Japanese candlestick, and Relative Strength Index (RSI) are widely used to represent environments within Reinforcement Learning.

3. **Fundamental Data and Factor Investing**
	Traditional asset pricing and portfolio construction rely on **factor investing** to explain cross-sectional expected returns . These stylised factors, backed by decades of empirical research, include value, momentum, size (market capitalization), quality, and low beta.
	
	Integrating fundamental accounting data (e.g., Price-to-Earnings, Debt-to-Equity, and return on equity) into daily RL trading systems presents a severe temporal mismatch. Accounting data is updated quarterly, whereas trading agents typically operate on daily or intraday frequencies, limiting the utility of fundamental metrics as rapid trading signals.

4. **Microstructure, Alternative, and Exogenous Features**
	In high-frequency trading (HFT), market-making, and optimal trade execution, macro-level daily indicators are useless. Instead, models require **Limit Order Book (LOB)** features to capture microsecond-level liquidity dynamics:
		- **Order Book Microstructure**: Bid-ask spreads, order book depth (volume at individual price levels), order flow imbalances, and the expected time to fill limit orders.
		- **Book Exhaustion Rate (BER)**: A critical real-time liquidity depletion metric used by Zhao and Linetsky to protect market-making agents from adverse selection risk and toxic order flow.
		- **Execution Metrics**: Elapsed execution time and remaining inventory sizes to enforce dynamic liquidation deadlines.
	
	Beyond structured market data, the literature increasingly incorporates **alternative data** to extract non-price signals:
		 - **Sentiment Signals**: Textual sentiment indicators extracted from Reuters News Corpus, Twitter streams, and Thomson Reuters News Analytics. Natural Language Processing (NLP) models transform unstructured text into continuous sentiment scores, which significantly reduce market uncertainty in state representations
		  - **Macroeconomic Context**: Exogenous indicators such as central bank policy rates, inflation metrics, GDP growth, and the slope of the US Treasury yield curve are used as risk indicators to model cyclical asset class rotations.
		  - **Alternative Networks**: Environmental, Social, and Governance (ESG) scores and supply chain network linkages represent promising emerging features to capture firm-level interconnections and systemic risks.

#### Feature Selection and Extraction Frameworks

![[Excalidraw/Research Pipeline.md#^frame=Deep Learning-Based Feature Extraction|1800]]

- **Temporal and Memory-Based Modeling (RNNs & LSTMs)**: Since financial data is inherently sequential, RNNs and LSTMs are vital for capturing temporal dependencies. LSTMs resolve the vanishing gradient problem in deep networks and utilize dedicated memory cells to preserve trading action history. This is highly advantageous for capturing transaction cost structures, as the agent's current position dictates future holding costs. Advanced implementations combine LSTMs with autoencoders, using the autoencoder to compress high-dimensional data (like LOB) into latent states, which the LSTM then uses to map sequential dependencies.
- **Spatial and Cross-Sectional Modeling (CNNs & ResNets)**: Transitioning from purely temporal modeling, Convolutional Neural Networks (CNNs) introduce a powerful spatial feature extraction paradigm. In portfolio management, CNNs are deployed to analyze multi-asset cross-sectional relationships. Early frameworks utilized an _Ensemble of Identical Independent Evaluators_ to independently extract features for each asset. Modern deep structures leverage Deep Residual Networks (ResNet) to stabilize gradients in very deep networks , and _Inception Networks_ to perform multi-scale temporal convolutions, capturing short-term spikes and long-term trends simultaneously.
- **Graph and Attention-Gated Mechanisms**: To model systemic connections, researchers utilize Graph Convolutional Networks (GCNs) like _DeepPocket_, mapping spatial relationships based on sector groupings or supply chain networks. Furthermore, the integration of **<font color="#ffc000">Attention Mechanisms</font>** marks a significant advancement in quantitative RL. Attention weights dynamically scale the importance of different features and time steps, enabling the network to focus on high-impact events (e.g., news releases or rapid price breakouts) while ignoring ambient market noise.
- **Generative and Re-scaling Techniques**: To combat severe financial data scarcity especially in short-lived options contracts or emerging assets researchers deploy Generative Adversarial Networks (GANs) for synthetic data augmentation and Gated Recurrent Units (GRUs) for streamlined sequence modeling.

#### Action Modelling and Reward Functions in Finance
The action space $A_t$ defines how an agent interacts with the market, while the reward signal $R_t$ specifies the mathematical objective the agent seeks to optimize over time. The design of these components determines both the physical realism of the trading strategy and the convergence properties of the underlying learning algorithms.