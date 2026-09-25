Kou, Yu, Luo, Peng, Li, Liu, Dai, Chen, Han and Guo, HKUST, HKUST Guangzhou and Peking University, arXiv:2409.06289v4 dated 3 November 2025, seventeen pages with a seven-page appendix, code at `github.com/kouzhizhuo/Automate-Strategy-Finding-with-LLM-in-Quant-investment`. I came to this from the [[Large Language Model Agents for Investment Management, Foundations, Benchmarks, and Research Frontiers|BlackRock survey]], which describes it as employing an adaptive gating mechanism that tunes the influence of each signal in real time under shifting market conditions. That is not what the paper does, and the difference is the most useful thing I got out of reading it.

<font color="#ffc000">The adaptivity here is at selection, not at weighting.</font> Which alpha factors enter the strategy depends on the market state, because the market state is passed to the two evaluating agents. How much each selected factor counts is a weight vector produced once by a small MLP trained on a fixed historical window, and it carries no time index anywhere in the paper's equations or in its algorithm listing. So this is not a competitor to my orchestrator. It is the strongest published instantiation I have of <font color="#ffc000">Baseline 2, the static learned weight</font>, which the supervisor identified as the baseline that actually matters, and it is the reference design I should implement that arm against.

#### Gap it's addressing

The stated problem is the brittleness of deep learning models in quantitative finance, decomposed into three challenges: traditional alpha mining methods are rigid and do not adapt to dynamic markets, machine learning approaches struggle to integrate diverse data, and strategies do not adapt to market variability. The proposed answer is a three-stage pipeline, LLMs generate executable alpha factor candidates from the alpha-mining literature, a multi-agent evaluation filters them on market status and predictive quality while maintaining category balance, and a weight optimisation stage combines the survivors.

Worth separating from the framing: the paper is not proposing a new way to combine heterogeneous *analysts*. Every object in the system is a formulaic alpha, a short arithmetic expression over OHLCV and fundamentals such as `CLOSE - DELAY(SMA(CLOSE, 14), 7)`. The two agents both evaluate those same expressions. This is one evidence type scored two ways, not four evidence types that have to be reconciled, and that distinction is the same one I had to make about the heterogeneous-discussion system in the survey.

![[Pasted image 20260925200001.png]]

#### Data and setup

Six primary features, open, high, low, close, volume and volume-weighted average price, plus quarterly and annual reports of index constituents, spanning January 2019 to June 2024 across SSE50, CSI300 and SP500. The main backtest is SSE50 with training January 2021 to June 2022, validation July to December 2022, and test January 2023 to January 2024. The cross-market study in Table 5 uses rolling annual partitions with six-month test windows, H1 2021, H1 2022 and H1 2023, for CSI300 and SP500.

The seed alpha library comes from eleven documents given to GPT-4o, including Kakushadze's *101 Formulaic Alphas* and Lopez de Prado's *Causal Factor Investing*, yielding a stated nine categories and 100 seed alphas. The counts do not hold up across the paper: the appendix taxonomy is introduced as eight categories and then lists nine, and the actual experimental prompt in A.7 describes 37 factors in eight groups. <font color="#ffc000">Liquidity is a category in the taxonomy, is absent from the eight groups the experiment's prompt actually names, and is absent from the five categories evaluated in Table 2, yet two liquidity expressions appear in the twelve selected alphas of Table 3.</font> That is worth noticing rather than only complaining about, because it is the same under-examination of the liquidity channel I have been finding elsewhere.

Portfolio construction is in A.8 and matters more than its placement suggests: daily reconstruction, rank all securities by composite alpha, take the top $k = 13$, limit churn to $n = 5$ names per day, equal weight across holdings. That is roughly 38% daily turnover, which the paper states and then never prices.

#### Model architecture and training

The two agents in Phase 2 each score every candidate alpha $\alpha_{ij}$ in category $j$ against the market condition $\mathcal{M}^{(t)}$, one on expected predictive power and one on risk character:

$$\theta_{ij} = \mathbb{E}\Big[IC\big(\alpha_{ij} \mid \mathcal{M}^{(t)}\big)\Big] \qquad\qquad \rho_{ij} = f_{\text{risk}}\big(\alpha_{ij}, \mathcal{M}^{(t)}\big)$$

where:
- $\theta_{ij}$ is the Confidence Score Agent's output, the expected information coefficient of that alpha conditional on the current market state
- $\rho_{ij}$ is the Risk Preference Agent's output, scoring how the alpha behaves under different risk scenarios
- $IC$ is the correlation between predicted alpha values and realised future returns

The two are mixed linearly and the best-scoring alpha in each category is kept, subject to a confidence threshold, which is what enforces category diversity:

$$\alpha^{*}_{j} = \arg\max_{\alpha_{ij}} \big[\, w_c \cdot \theta_{ij} + w_r \cdot \rho_{ij} \,\big]$$

Phase 3 then trains a three-layer MLP, input width equal to the number of selected alphas, ten ReLU hidden nodes, one output, mapping historical daily alpha values to future yields by backpropagation with a held-out validation set. Its learned parameters become the combination weights, and the composite signal for stock $i$ is:

$$\alpha^{(t)}_{i} = \sum_{j=1}^{|\mathcal{A}|} w_j \cdot \alpha^{(t)}_{ij}$$

<font color="#ff0000">Read the subscripts.</font> The alpha values carry $t$, the weights do not, here or in Algorithm 2 line 30 or in the paper's equation 8. The abstract's "dynamic weight optimization that adapts to market conditions" and the survey's "real time" gating both describe $w_{j}$ as though it were $w_{j}^{(t)}$, and nothing in the method produces that. The weights change when the model is retrained on a new window, which is retraining, not gating.

![[Pasted image 20260925200002.png]]

#### Findings

- **<font color="#ffc000">The adaptive component is the selection step, and it is the component the ablation actually supports.</font>** Removing the Confidence Score Agent drops out-of-sample IC from 0.047 to 0.032, a 31.9% fall, and removing the Risk Preference Agent drops it to 0.039, on SSE50 data from 2010 to 2022. The regime breakdown in Table 8 localises it: the full model holds out-of-sample IC at 0.051 bull, 0.042 bear and 0.045 sideways, while without the confidence agent the bear-market figure collapses to 0.021, half the full model's. On this sample, conditioning *which* factors are used on the market state is doing real work, and it is doing most of it when conditions are bad. That is a result about state-conditional selection, and I can use it as such.

| Configuration | IC in-sample | IC out-of-sample | Sharpe |
| --- | --- | --- | --- |
| Full model | 0.059 | 0.047 | 1.94 |
| Without Confidence Score Agent | 0.054 | 0.032 | 1.51 |
| Without Risk Preference Agent | 0.056 | 0.039 | 1.34 |

- **The two metrics in that ablation disagree about which agent matters, and the paper reports only one of the answers.** On IC the confidence agent is the more important of the two, 0.032 against 0.039 when each is removed, and the text concludes from this that the confidence agent plays the more critical role. On Sharpe the ordering reverses, 1.51 without confidence against 1.34 without risk. The paper's narrative follows IC and does not mention that its own table contradicts it on the risk-adjusted metric, and the body text quotes the full model's Sharpe as 1.73 where Table 7 prints 1.94.

- **The headline 53.17% is gross, on 38% daily turnover, against a benchmark of $-13.22$%.** Table 4 reports final return, Sharpe, volatility, Sortino and Calmar with no cost column, and A.8 says only that the turnover level "demonstrates favorable characteristics in our transaction cost modeling" without giving a rate anywhere in the paper. A daily top-13 book replacing five names a day is a high-cost design, and the fact that the two LLM baselines it beats, [[FinCon, A Synthesized LLM Multi-Agent System with Conceptual Verbal Reinforcement for Enhanced Financial Decision Making|FinCon]] at 22.47% and SEP at 17.89%, are also reported gross does not make the comparison cost-neutral, because turnover differs between them and is reported for none of them.

![[Pasted image 20260925200003.png]]

- **<font color="#ff0000">The Sharpe ratio is reported on at least three mutually incompatible scales and the convention is never stated.</font>** Table 4 gives the strategy 0.287 on the 2023 SSE50 test with 0.762% volatility, which reads as a daily figure. Table 7's ablation gives the same architecture 1.94. Table 9's sensitivity study gives values up to 11.39, and Table 10's hyperparameter study reaches 13.33. No equity strategy has a Sharpe of 13, so at least two of these tables are measuring something other than what the label says, and because the paper never defines the convention I cannot tell which. The practical consequence is that only the within-table comparisons are readable and no number here can be carried into a sentence of mine.

- **The sensitivity studies show instability rather than sensitivity.** Sweeping the confidence-to-risk mixing weight gives overall Sharpe values of 8.10, $-2.68$, 11.39, $-5.10$, $-8.04$, 9.00 and $-4.35$ across the seven settings from all-confidence to all-risk, so the sign flips between adjacent configurations three times and the chosen 0.6 / 0.4 optimum sits directly between two negative results. The hyperparameter table behaves the same way, with regularisation 0.0005, 0.001 and 0.002 giving $-1.88$, 13.33 and $-6.91$. Whatever the Sharpe scale is, a surface that alternates sign under a one-step parameter change is not a surface with an optimum on it, and the reported configuration is better described as the best of a noisy sweep than as a tuned choice.

| Confidence weight | Risk weight | Bull | Bear | Overall |
| --- | --- | --- | --- | --- |
| 1.0 | 0.0 | 4.32 | 6.60 | 8.10 |
| 0.8 | 0.2 | −3.41 | −7.23 | −2.68 |
| **0.6** | **0.4** | **8.70** | **10.37** | **11.39** |
| 0.5 | 0.5 | −0.49 | −1.62 | −5.10 |
| 0.4 | 0.6 | −4.27 | −4.41 | −8.04 |
| 0.2 | 0.8 | 5.68 | 8.51 | 9.00 |
| 0.0 | 1.0 | −0.61 | 1.78 | −4.35 |

- **The downside-protection claim holds in the two bear windows and fails in the other four.** Across the six cross-market test windows, maximum drawdown is deeper than the benchmark's in four, $-19.40$ against $-10.86$ and $-17.03$ against $-8.44$ on CSI300, $-7.89$ against $-4.23$ and $-11.52$ against $-7.75$ on SP500, and shallower only in the H1 2022 downturn in both markets. So the counter-cyclical behaviour the paper emphasises is real in the windows where the index fell hard, and the abstract's general claim of downside protection is not supported by its own Table 6 in rising markets.

#### Limitations

- **<font color="#ff0000">The comparison that would isolate the weighting stage is not run.</font>** Both ablations remove an *agent* from the selection phase. Neither removes the MLP, so there is no arm anywhere in the paper showing what an equal-weighted combination of the same twelve selected alphas would have returned, and therefore no evidence that learning the weights contributes anything over the selection that precedes it. There are also no significance tests, no seeds, no repeated runs and no confidence intervals on any figure in the paper, so a 53.17% single backtest against 22.47% carries no attached uncertainty. This is the limitation that most directly shapes my own design, because the missing arm is exactly the comparison my three-way weighting study is built to make.

- **Look-ahead exposure is structural and unaddressed.** GPT-4o, whose training data extends well past the 2023 test period, is asked in the A.7 prompt to "select the factors that will perform best in the last quarter of the SSE 50" for the test window, from a factor library assembled out of published alpha research whose historical performance on Chinese equities is itself in the model's training corpus. The paper offers no contamination check, no held-out-by-construction factor set, and no comparison against a model with an earlier cutoff. That does not mean the result is contaminated, it means the paper provides nothing that would let me rule it out, and the effect would look exactly like the reported outperformance.

- **Internal inconsistencies are frequent enough to affect how much weight any single figure can bear.** The seed alpha count is 100 in the method and 37 in the experimental prompt, the categories are nine in the method, eight-then-nine in the appendix and eight in the prompt, the full model's Sharpe is 1.73 in the text and 1.94 in the table, the SSE50 benchmark return is $-11.73$% in the text and $-13.22$% in Table 4, equation 1 defines $IC = \sigma(u,v)$ with $\sigma$ described as a correlation coefficient, and page 4 carries an unresolved `Algorithm ??` reference. Individually trivial, collectively a reason to treat the reported numbers as indicative rather than exact.

- **The composite signal's information coefficient is negative and the sign convention is never given.** Table 3's weighted combination scores $-0.0587$ against individual alphas in the $\pm 0.02$ range, and the text calls this "quite high", reading the magnitude and ignoring the sign. Since A.8 ranks securities by composite alpha and buys the top thirteen, a negatively correlated composite would select the worst-ranked names unless a sign flip is applied somewhere the paper does not describe. The same confusion recurs when removing one alpha is said to make the combination "drop" from $-0.0587$ to $0.0491$.

- **Multimodality is claimed in the abstract, drawn in Figure 1 and tabulated in the appendix, and never used.** Table 11 lists audio data, financial morning news radio and market discussion radio, and video data, CCTV Securities Information Channel, as framework inputs. No experiment in the paper uses audio or video, and the dataset summary in Table 1 contains only OHLCV, VWAP, financial reports and factor performance metrics. The multimodal architecture is a taxonomy presented as a capability.

#### Why this matters for my project

- **This is my static-learned-weight baseline, and I should build that arm to this design rather than to a strawman.** Baseline 2 is the one the supervisor singled out, because beating equal weighting proves little if a fixed learned weight gets there too, and until now I had no reference implementation of it. A small MLP over the selected agent outputs, trained on a historical window with a held-out validation split, is a fair and published version of that arm. The comparison this paper never runs, equal weight against learned static weight over an identical input set, is the first half of my experimental design, and I can now say plainly in the write-up that the nearest prior work does not report it.

- **Adaptivity at selection and adaptivity at weighting are separable, and I should evaluate both.** This system conditions which factors are in the set on the market state and then weights them statically. Mine conditions the weights and keeps the agent set fixed. Those are different mechanisms and the paper's ablation shows the first one carries real signal, most of it in bear regimes, so the honest version of my study adds a configuration where agent *inclusion* is state-conditional and the weights are static. If that recovers most of the benefit, my contribution narrows to the weighting function specifically, and I would rather find that out in my own ablation than have it raised in a viva.

- **<font color="#ff0000">Keep the orchestrator low-capacity.</font>** A ten-node MLP over roughly twelve inputs, trained on a fifty-stock universe with eighteen months of daily data, produces a Sharpe surface that flips sign when L2 regularisation moves from 0.001 to 0.002. My universe is smaller, my confirmed usable CSE history is shorter, and my weighting function would sit downstream of four noisy agents. That argues for a weighting function with a handful of interpretable parameters, a gated linear form or a shallow regression on the four state variables, rather than a network, and it argues for reporting the stability sweep rather than only the tuned configuration.

- **The two-agent scoring scheme is a usable template for the agent-confidence term, with one caution attached.** Expected conditional information coefficient as a confidence score and a separate risk-character score, mixed linearly, is implementable for my four agents as each agent's historical hit rate conditional on the current liquidity and volatility state, and it needs no labelled confidence target. The caution is that the mixing ratio between the two components is exactly the parameter this paper's sensitivity table shows to be unstable, so if I adopt a two-component confidence I fix that ratio on the validation split and report the sweep, rather than selecting it on the test window as this paper appears to.

- **The liquidity factor definitions transfer to the CSE even though the experiment's factor set excludes them.** Amihud illiquidity as `ABS(RETURN) / VOLUME`, turnover as `VOLUME / SHARES_OUTSTANDING`, the high-low spread proxy `(HIGH - LOW) / CLOSE` and `VOLUME / MARKET_CAP` are all computable from the OHLCV and shares-outstanding data I expect to have, with no quote feed required, and the high-low proxy is the one that survives if I never get bid-ask data. That this paper defines a liquidity category, omits it from the groups its own experiment evaluates, and still ends up selecting two volume-based expressions into the final twelve is a small piece of support for treating the liquidity channel as under-examined rather than covered.

- **Gross returns on 38% daily turnover make the friction layer a contribution rather than housekeeping.** A daily top-13 book turning over five names a day is already expensive on SSE50, and on a CSE book with wider spreads and thinner depth it is not implementable at all. The cost model therefore comes from [[A reinforcement learning approach to optimal execution]] and [[Online portfolio selection with state-dependent price estimators and transaction costs]] calibrated on CSE spreads and depth, and my evaluation reports net alongside gross for every configuration. The turnover constraint itself, cap the number of names replaced per session rather than the fraction of capital traded, is a clean mechanism worth borrowing.

- **They name the stationarity assumption behind state-conditional weighting and do not test it, which is precisely my persistence ablation.** Their own limitations section states that the multi-agent evaluation presupposes persistent historical relationships between market conditions and alpha performance, an assumption that may prove tenuous during regime shifts. That is the assumption my $P_t$ term exists to handle, and the Adaptive minus Persistence configuration is the experiment nobody in this line of work has run. It also gives me the citation for why the persistence term belongs in the conditioning set at all, which had been the weakest-supported of the four.

- **Prompt hygiene needs to be a stated part of my method.** My agents will be LLM-driven over a period a frontier model may know, so the evaluation window must not be named in any prompt, the agent instructions must not ask which factors performed best in a period that overlaps the test set, and I should report a contamination check of some kind, at minimum a comparison against an earlier-cutoff or open-weight model on the same prompts. This paper is the reason to write that into the method rather than mention it in a limitations paragraph.

> [!important]
> Cite this as the reference architecture for state-conditional factor selection and as the static-learned-weight baseline. Do not cite any of its performance numbers. The Sharpe ratios are on undefined and mutually inconsistent scales, the returns are gross on 38% daily turnover, there are no significance tests, and the look-ahead exposure through a frontier model's knowledge of the 2023 test period is unaddressed. The ablation deltas within Table 7 and Table 8 are the one set of figures I would quote, and only as within-table comparisons.

> [!NOTE]
> The survey's description of this paper as real-time adaptive gating is wrong on the paper's own equations. Worth a line in the synthesis about reading primary sources before treating a survey's characterisation as prior art, and worth re-checking the other two follow-ups the survey generated before I let them into the gap argument.
