

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

Which mandates the necessity for developing a risk management framework.

