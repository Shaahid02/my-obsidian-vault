KDD '24, Jeon, Park, Park and Kang, out of Seoul National University and DeepTrade Technologies. Daily-bar long-short portfolio optimization across six markets, five equity and one crypto, where the whole state representation is built in the <font color="#ffc000">frequency domain</font> rather than the time domain, the price tensor passing through a 1-d Discrete Fourier Transform before the policy network sees anything, with a DDPG actor-critic on top and an explicitly solved proportional transaction fee model underneath. Two modules carry it, a Frequency State Encoder that turns each asset's spectrum into an embedding and a Portfolio Generator that scores assets against each other and keeps only the top $|\mathcal{G}|$. No code release is mentioned.

This is the third RL portfolio paper in the vault and it brackets the other two rather than duplicating either. [[Deep Reinforcement Learning Framework for Diversified Dynamic Portfolio Allocation Across Global Equity Markets]] is cross-sectional allocation with a continuous Dirichlet action, an LSTM time-domain encoder and sixteen walk-forward folds, [[MacroHFT, Memory Augmented Context-aware Reinforcement Learning On High Frequency Trading]] is single-asset timing with a binary action and a hard partition of the data by trend and volatility, and FreQuant is cross-sectional long-short allocation with hard top-$k$ selection, a spectral encoder and one fixed split per market. What makes it the most interesting of the three for the CSE is the representation rather than the architecture: the one solid quantitative result anyone has established about the Colombo exchange is that its volatility has <font color="#ffc000">long memory</font>, and long memory is by definition a statement about the low-frequency end of a spectral density, so a state encoder working in frequency space is the natural home for that result rather than an exotic add-on. Worth flagging too that FreQuant charges 0.33% to close a long and 0.4% to close a short, sixteen to twenty times the 2 bps assumed in both other papers.

> [!NOTE]
> **"Frequency" here does not mean what it means in MacroHFT.** There it is the sampling rate of the data, minute bars. Here it is Fourier frequency, cycles per day measured inside a 256-day lookback window, and the underlying data is daily. The 8th component of a 256-day window is a pattern repeating every 32 days, so this model's "high frequency" features are short-cycle oscillations in a daily series, not intraday activity. Both papers sit in my RL folder and use the same word for unrelated things.

#### Gap it's addressing

- **Time-domain encoders smooth away the events that matter most.** RNN averaging and attention's blending of temporal information both help identify prevalent trends but diminish the significance of abrupt changes, treating them as anomalies or outliers rather than signals, so crucial market shifts get overlooked and losses follow. Note this is a loss-avoidance framing rather than an alpha framing, the same place MacroHFT's practical win turned out to be.
- **Movement-prediction models lack what a portfolio decision needs.** Prior attention-based prediction and multi-frequency feature extraction inside recurrent units is criticised for having no access to adjusted rewards with transaction fees or adjusted portfolio weights, which is an argument for solving allocation end to end rather than bolting an allocator onto a forecaster.
- **Existing deep RL portfolio methods still cannot capture sudden events.** Attention, asset correlations, high-frequency data, expert signals and news have all been tried, and capturing abrupt asset signals is named as what remains.

The three stated design challenges are multi-granular asset representation, portfolio generation with asset correlation, and stabilising DDPG given the parameter count. The third is an admission that the method as designed is hard to train, and the periodicity guidance exists to fix a problem the architecture creates.

Underneath all of it sits an assumption the paper never tests, that <font color="#ffc000">prevalent patterns live at low frequencies and abrupt shifts at high ones</font>. That is a reasonable heuristic and not what the mathematics says, since a jump inside a finite window spreads energy across the whole spectrum rather than concentrating it at the top.

#### Data and setup

Six markets, three newly collected and three reused from prior work, one fixed train and test split each, no validation period reported and no walk-forward. The number of assets actually held is a per-market hyperparameter, so it belongs in the same table:

| Market | # Assets | Training period | Testing period | Assets held ($\lvert\mathcal{G}\rvert$) |
| --- | --- | --- | --- | --- |
| U.S. | 224 | 1992.08 - 2013.08 | 2013.09 - 2022.11 | 40 |
| KR | 528 | 2001.01 - 2016.06 | 2016.07 - 2022.11 | 80 |
| Crypto | 44 | 2019.01 - 2021.10 | 2021.11 - 2022.11 | 16 |
| CN | 34 | 2009.01 - 2017.09 | 2017.10 - 2020.12 | 14 |
| JP | 118 | 2013.08 - 2021.03 | 2021.04 - 2023.12 | 25 |
| U.K. | 21 | 2011.09 - 2020.07 | 2020.08 - 2023.12 | 10 |

What to look for there is the spread of test lengths, nine years on the U.S. market against thirteen months on crypto, which means the six ARR figures are not comparable to each other as evidence even though they are printed in one row. The U.K. row is the one I care about, 21 assets with 10 held, the only configuration anywhere near CSE breadth.

State is three things, an asset price feature tensor $X_t^{\text{Asset}} \in \mathbb{R}^{J \times N \times T}$, a market index tensor $X_t^{\text{Market}} \in \mathbb{R}^{1 \times 1 \times T}$ and the current weights $w'_t \in \mathbb{R}^{N+1}$, with the window fixed at $T = 256$ days. The action is a long-short weight vector $v_t \in \mathbb{R}^{N+1}$, cash non-negative at $v_{t,0} \geq 0$, assets in $[-1, 1]$, and an $L^1$ budget $\sum_{i=0}^{N}|v_{t,i}| = 1$, so a negative weight is a short and its magnitude is the share of budget committed. Reward is realised profit and loss minus the fee actually paid, with a margin-call term that forcibly closes a short and caps its loss at the initial invested amount when the price doubles within a step.

Competitors are five, all long-short: Cross-Sectional Mean reversion and Buying-Loser-Selling-Winner on the traditional side, AlphaStock, DeepTrader and MetaTrader on the learned side. Metrics are two, Annualized Rate of Return and Annualized Sharpe Ratio, with Portfolio Value $\prod_{t=2}^{t'}(1 + r_{t-1})$ plotted separately. No drawdown, no turnover, no trade count, which is thin for a long-short paper and well behind MacroHFT's six-metric panel.

Hyperparameters worth recording: actor learning rate $1 \times 10^{-4}$ and critic $5 \times 10^{-5}$, regularization coefficient $\lambda = 0.5$, buffer 10,000, batch size 8, $\gamma = 0.99$, 150 episodes, 4 FSE blocks, 2 fusion units, 5 event-filters each, complex projection dimension 64, 10 predefined periodicities, all on one GTX 1080 Ti. Fees are $f_l = 0.33\%$ closing long and $f_s = 0.4\%$ closing short, the asymmetry justified because the market treats a short as a borrowed asset and charges interest before realization.

> [!WARNING]
> The rebalancing frequency $r_f$ is defined in the problem formulation and then never given a value, not in Table 4 and not in the experimental setup. Since the fee is charged per closing position at 33 to 40 bps, annual cost drag is entirely determined by how often the portfolio rebalances, so without $r_f$ the reported returns cannot be checked against the stated fee structure at all. That is the biggest reproducibility hole in the paper and it sits directly on top of its most transferable contribution.

#### Model architecture and training

![[Pasted image 20260919222001.png]]

Asset and market inputs each pass a $1 \times 1$ convolution along the feature dimension, then go through $M = 4$ parallel Frequency State Encoder blocks operating on progressively shorter segments of the window, $\tilde T_m = \lfloor T/2^{m-1}\rfloor$, so the four blocks see the last 256, 128, 64 and 32 days. Each block runs a 1-d DFT along the temporal axis:

$$\hat X_k^{i,f} = \sum_{n=0}^{\tilde T - 1} X_n^{i,f} \cdot e^{-\frac{I 2\pi k}{\tilde T} n}$$

where:
- $X^{i,f} \in \mathbb{R}^{\tilde T}$ is the $f$-th feature map of the $i$-th asset over the segment
- $k$ indexes frequency, the physical frequency being $\frac{k}{\tilde T} \times$ sampling rate
- $I = \sqrt{-1}$

Hermitian symmetry means only $T_0 = \lfloor \tilde T/2 \rfloor + 1$ components are kept. Each retained component is called an <font color="#ffff00">Event</font>, the $k$-th periodic constituent of that asset, and their worked example is the clearest statement of what the representation holds: with daily data and $\tilde T = 256$, the 8th component is a pattern repeating every 32 days.

Three things then happen to that spectrum. The <font color="#ffff00">Multi-Event Fusion Network</font> applies a bank of five learned complex filters elementwise, concatenates the results and compresses along the frequency axis with a complex 1-d convolution, the filter parameters shared across assets so they represent market-wide periodic structure rather than per-ticker quirks. The <font color="#ffff00">Frequency-Relation Encoder</font> is a Transformer rewritten for complex vectors, the dot product replaced by the Hermitian inner product and softmax by a magnitude-based complex softmax, with attention running over <font color="#ffc000">frequencies within a single asset</font> rather than over assets or over time. Outputs from the four resolutions are linearly projected and concatenated into a context embedding, with the market embedding broadcast-added so every asset carries the same index signal.

The Portfolio Generator then runs a structurally identical complex Transformer across the asset dimension instead, producing asset-correlated embeddings, concatenates a learned cash bias and the current weights, takes the real part as a confidence score per asset, and normalises the top $|\mathcal{G}|$ magnitudes into weights with everything else set to zero. Sign survives the normalisation so a negative confidence becomes a short, and cash competes for a slot like any asset. The stated motivation for hard selection is that previous strategies hold a fixed number of shorts regardless of conditions and so fall short in clear bull markets.

The fee model is the part I would actually reuse. Fees are charged only on closing positions, and the difficulty is that the fee reduces capital, which changes weights, which changes the fee, so the system is self-referential:

$$v_i = \frac{w'_i - c_i + o_i}{1 - \Theta} \quad \forall i = 0, \dots, N, \qquad \Theta = \sum_{i=1}^{N} c_i^+ f_l + c_i^- f_s$$

where:
- $c_i \geq 0$ closes a long and $c_i < 0$ closes a short, $o_i > 0$ opens a long and $o_i < 0$ opens a short
- $x^+ = \max(x,0)$ and $x^- = -\min(x,0)$ are the positive and negative parts
- $\Theta$ is the total paid fee, itself a function of the closing weights being solved for

Algorithm 1 resolves this by fixed-point iteration, alternating between fixing $o_i$ and solving for $c_i$ and the reverse, projecting at each pass onto three constraints, $w'_i c_i \geq 0$ so closings only reduce positions in their own direction, $|c_i| \leq |w'_i|$ so a position cannot be closed beyond its size, and $(w'_i - c_i)o_i \geq 0$ so direction is preserved after opening.

Training is standard DDPG. The stabiliser is <font color="#ffff00">Predefined Periodicity Guidance</font>, a regularization term that penalises event-filter spectral mass everywhere except at the harmonics of chosen periods $\eta = 5, 10, 20$ days, weighted by $\lambda = 0.5$ and subtracted from the actor's gradient. The mask is constructed to vanish only at every $\lfloor \tilde T/\eta_f \rfloor$-th frequency index. The motivation is economic rather than numerical, the observation that markets show fundamental periodicities such as the Friday effect.

#### Findings

![[Pasted image 20260919222003.png]]

- **Best ARR on all six markets, best ASR on five of six, and the one loss is on the market with the longest test window.** ARR of 36.25%, 38.57%, 179.4%, 36.45%, 41.93% and 24.80% against best-competitor figures of 16.80, 27.84, 102.6, 29.40, 26.22 and 15.48. On ASR, DeepTrader takes 0.810 on the U.S. market against FreQuant's 0.770, so over the nine-year out-of-sample stretch, the longest here, the proposed method wins on return and loses on return per unit of risk. The paper's prose claims strong risk-profit performance by ASR without noting that exception, and it is the one I would most want explained, since a method pitched on resilience losing the Sharpe comparison over the longest window is exactly the result that needs addressing. The abstract's "up to 2.1× higher ARR" is also the U.S. market alone, the same ratio giving 1.39× on KR, 1.75× on crypto, 1.24× on CN and 1.60× on both JP and U.K., so the median improvement over the strongest baseline is nearer 1.6×.

- **Two of the five baselines are not functioning, and one of their numbers reveals that ARR is not a compound rate.** Cross-Sectional Mean reversion and Buying-Loser-Selling-Winner are negative on every market bar a single U.K. cell, reaching -84.36% and -145.0% on crypto. With an $L^1$ budget of 1 and short losses capped at the invested amount by the margin-call term, a compounded annual growth rate below -100% is unreachable, so ARR must be an annualized arithmetic mean of per-period returns. The paper gives no formula for either ARR or ASR. That matters because every headline ratio in the abstract is a ratio of an undefined quantity, and arithmetic annualization flatters volatile strategies against a geometric one. I am reporting this as an inference from the arithmetic, not as something the authors state.

- **The ablation is a clean sweep and the magnitudes are hard to believe on single runs.** Three variants, with the Frequency-Relation Encoder removed, with the complex Transformer replaced by two ordinary ones for real and imaginary parts, and with both, post ARR of 12.69, 13.21 and 7.213 on the U.S. market against the full model's 36.25, and 99.28, 116.7 and 93.32 on crypto against 179.4. The full model beats every variant on every market and the double ablation is consistently worst, so the two components are not redundant. But 13.21 to 36.25 is a 2.7× jump from restoring one module in a DDPG agent trained with batch size 8, and nothing in the paper separates that from run-to-run variance.

- **The market-shift experiment is the strongest argument in the paper and covers half the markets.**

  ![[Pasted image 20260919222005.png]]

  High-fluctuation days come from quantile-based outlier detection on the index's rate of change, the cutoff set so that $1 - P(-d < X \leq d) = 0.1$, giving thresholds of ±2.5% on U.S., ±5.5% on crypto and ±3.5% on KR. On those days FreQuant's total rate of return exceeds the next best model by <font color="#ffc000">+16.9 percentage points on U.S., +49.3 on crypto and +24.4 on KR</font>, with the runners-up negative on two of the three while FreQuant sits near +60%. This tests the paper's actual thesis more directly than anything else in it, which makes the absence of CN, JP and U.K. from the figure conspicuous and unexplained.

- **Periodicity guidance lowers reward variance in 21 of 24 cells, with one counterexample the paper does not mention.**

  ![[Pasted image 20260919222006.png]]

  Across four ten-episode blocks and six markets, variance with guidance is lower in 21 cells, tied in two CN cells, and higher in exactly one, JP episodes 21-30, where guidance gives 2.3(2.5) against 8.2(0.8) without it, worse on both mean and variance by a wide margin. The clearest supporting cells are U.S. episodes 21-30 at 3.7(0.4) against 1.7(4.7) and crypto 31-40 at 3.1(0.5) against 1.5(3.1). The stabilisation claim holds on this evidence, the word "consistently" in the paper's own description does not.

#### Limitations

- **One run per cell, one split per market, no seeds, no significance tests, no walk-forward.** Every number is a single training run on a single fixed split, and no validation period is described even though $\lambda$, $|\mathcal{G}|$ and the filter counts are clearly tuned. The U.S. model is trained once on data ending in 2013 and evaluated through to late 2022 with no refit and no drift monitoring, which stands in direct contrast to the sixteen-fold walk-forward with adaptive retraining in the Kashif and Ślepaczuk framework, and means there is no evidence that spectral structure learned in the 1990s and 2000s is still the right structure in 2022. Test windows are also wildly heterogeneous, nine years against thirteen months, with the crypto ARR of 179.4% both the largest number in the paper and the one annualized from the shortest window.

- **Two metrics, and the fee contribution is unrecoverable.** No maximum drawdown, which is the obvious omission given the margin-call mechanism exists precisely because short losses are unbounded, and no turnover or trade count, which matters more here than anywhere because the paper's own fee model makes turnover the dominant cost driver. Combined with the missing $r_f$, there is no way to reconstruct what the 33 to 40 bps actually cost. In MacroHFT the trade-count column turned out to be the single most informative thing in the results table.

- **The frequency premise is asserted and never ablated.** All three variants ablate the encoder over the spectrum, none removes the spectrum. There is no time-domain FreQuant, no version of the same architecture fed raw prices, and no comparison against a wavelet or short-time Fourier alternative, so the ablation table cannot distinguish "the frequency domain helps" from "the complex Transformer helps". The deeper issue is that a DFT over 256 days discards time localisation entirely, telling the model that a 32-day cycle exists somewhere in the window but not when, which is a strange choice for a method selling responsiveness to sudden events. The dyadic segmentation at 256, 128, 64 and 32 days recovers some of it and is effectively a crude wavelet scheme, and the paper never frames it that way or tests it against the real thing.

- **Universe construction and survivorship bias go unaddressed.** 224 U.S. assets spanning 1992 to 2022 and 528 KR assets from 2001, with no account of how the lists were formed, no mention of listings and delistings, and no tradability mask. This is precisely the correction the Kashif and Ślepaczuk framework builds explicitly from Bloomberg membership history, and its absence means some unknown share of the U.S. result could be a thirty-year survivorship filter. Three datasets are reused from prior work and may inherit their construction, but the three new ones are the authors' own and are not described.

- **The interpretability evidence is anecdotal throughout.** Sony's 2014 console launch and Brexit's effect on J.P. Morgan are two hand-picked assets with narratively matched events, the multi-periodic event-filter is one unguided filter from one run, and the Bitcoin and Holo case study is two assets over two months. All of it is coherent and none of it is measured, so the mechanisms are visible and their contribution is not quantified.

#### Why this matters for my project

- **Frequency-domain state is the natural representation for the one thing actually established about the CSE.** [[Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange]] gives FIGARCH $d$ estimates showing long memory in CSE volatility, and long memory is defined in exactly these terms, the spectral density diverging at the origin as

  $$f(\omega) \sim C\omega^{-2d} \quad \text{as } \omega \to 0^+$$

  where $d$ is the same fractional differencing parameter FIGARCH estimates and $C > 0$ a constant. The FIGARCH result is therefore a statement about the low-frequency end of the spectrum, and FreQuant's encoder consumes exactly that object. That gives me a cleaner architectural justification than the volatility-tertile route from MacroHFT: rather than discretising volatility into labels and training a specialist per label, the spectral representation hands the policy the low-frequency components directly. Both operationalise the same finding and I now have two routes, which is a better position than one.

- **Which of those two routes survives depends on CSE data depth, so design for both.** MacroHFT partitions the data by regime and trains six specialists, FreQuant decomposes the signal by frequency and trains one policy. Partitioning is expensive in sample size and the CSE's usable history is the open question gating everything, whereas a spectral encoder consumes the same series at every resolution and costs nothing in data. If depth turns out to be short, the frequency route survives and the six-specialist route does not.

- **The multi-resolution segmentation is cheap to transfer, and the wavelet version is a concrete novelty candidate.** Running the same encoder over 256, 128, 64 and 32-day windows is a handful of lines and is what gives the model any time localisation at all. A wavelet or short-time Fourier transform preserves when as well as what, which is the property a shift-responsive model should want, and nobody in this literature appears to have compared them on portfolio allocation. One extra encoder branch to test, and unlike most of my candidate contributions it does not depend on the CSE data situation resolving favourably.

- **The fee model is the only correct treatment in my set, and 33 bps still is not execution friction.** Fees reduce capital, which changes weights, which changes fees, and every other paper sidesteps this by charging a flat rate on turnover after the fact. The fixed-point iteration with its three directional constraints is fully specified in Algorithm 1 and can be lifted as-is, which matters on a market where realistic round-trip cost is likely well north of 2 bps. But a commission rate is not execution cost in a thin book, and there is still no spread, no market impact, no partial fill and no queue position anywhere here, so <font color="#ff0000">the execution-friction blind spot survives intact in the paper that pays costs the most attention</font>. My protocol needs a spread-and-impact layer on top of a fee model of this shape, plus the cost-sensitivity sweep none of these three papers runs.

- **Top-$k$ with a learned cash bias is the right action-space shape for thin breadth, and long-short probably is not.** The U.K. configuration holds 10 of 21 assets, the nearest thing here to the CSE. Hard selection means the policy never assigns weight to something it cannot trade, and cash competing for a slot gives it a principled way to stand aside, which matters far more on an exchange where liquidity disappears for stretches than on the Nasdaq, and it agrees with the Kashif and Ślepaczuk finding that cash-allowed configurations beat fully-invested ones on risk-adjusted terms. The long-short machinery is the opposite case: whether the CSE offers a practical short mechanism through securities borrowing and lending needs confirming in writing from the SEC and CSE rules rather than assuming, and if it does not, the action space collapses to $v_i \geq 0$, the margin-call branch disappears, $f_s$ becomes irrelevant and the fee fixed-point simplifies considerably. Worth resolving early since it decides how much of the formulation I reuse verbatim.

- **Periodicity guidance is a cheap stabiliser and a place to inject local knowledge.** One regularization term pushing filter magnitudes toward harmonics of chosen periods, and the priors used are just the trading week, fortnight and month. For the CSE the same weekly and monthly cycles are the obvious starting point, plus whatever the local calendar imposes, and there is a real question about whether Sri Lankan seasonality follows the shape of the Friday effect the paper cites. It is also a genuinely cheap way to keep a high-parameter model trainable on a small dataset, which is my situation, so it goes on the list beside the conditional adapter from MacroHFT.

- **The three-way contrast is what belongs in the review chapter, rather than three paper summaries in sequence.**

  | | Kashif and Ślepaczuk | MacroHFT | FreQuant |
  | --- | --- | --- | --- |
  | Task | Cross-sectional allocation | Single-asset timing | Cross-sectional long-short |
  | State domain | Time, LSTM plus attention | Time, LOB microstructure | Frequency, complex Transformer |
  | Action | Dirichlet over $N$+cash | Binary $\{0,1\}$ | Top-$k$ signed weights |
  | Regime handling | Post-hoc decomposition | Hard partition, 6 specialists | Multi-resolution spectrum |
  | Algorithm | SAC | Dueling DDQN | DDPG |
  | Costs | 2 bps flat | 2 bps flat | 33/40 bps, fixed-point solve |
  | Evaluation | 16-fold WFO, HAC and bootstrap tests | 1 split, 6 metrics, no tests | 1 split, 2 metrics, no tests |

  Read down the evaluation row and the most rigorous protocol belongs to the paper with the least impressive results, which is the point I want to make about this literature rather than a coincidence. Taking the union of what the three do well gives me a protocol none of them has: walk-forward with adaptive retraining and formal significance testing from Kashif and Ślepaczuk, the six-metric risk panel and trade counts from MacroHFT, and the properly solved fee model from FreQuant, plus seeds and a cost-sensitivity sweep. Since no CSE benchmark exists at all, that protocol is a contribution in its own right and not just hygiene.
