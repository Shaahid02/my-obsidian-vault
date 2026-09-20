2024 4th International Conference on Advanced Research in Computing (ICARC), pp. 61 to 66, Dinushan and Wijegunasekara out of the Department of Software Engineering, Faculty of Computing and Technology, University of Kelaniya. A monthly forecasting study that predicts the next month's value of the ASPI and the S&P SL20 separately, using nine Sri Lankan macroeconomic series, the S&P 500 as a proxy for global conditions, and a Twitter sentiment score, with the feature set narrowed by correlation, lag search, forward stepwise regression and p-value pruning before six model families are trained and compared on MAE. DOI 10.1109/ICARC61713.2024.10499774.

This is the paper in my set that comes closest to the input side of what I'm building, it is the only CSE study I have that puts macroeconomic indicators and text sentiment into the same feature vector and then actually fits models on the result, and the variable selection work is genuinely useful to me. The modelling and the evaluation are a different matter. The paper's own headline methodological finding, that <font color="#ffc000">shuffling the dataset before splitting improves accuracy</font>, is the thing I need to be most careful about, because on a 156-row monthly series shuffling is not a training trick, it is look-ahead leakage, and every number in the paper that looks impressive sits in the shuffled column. So I read this as a strong feature-engineering contribution wrapped around an evaluation protocol I cannot reuse, which makes it a good companion to [[Adaptive Stock Market Portfolio Management and Stock Prices Prediction Platform for Colombo Stock Exchange of Sri Lanka]], the other local paper where the protocol was never fixed before the build started.

> [!WARNING]
> **The sentiment variable is one Twitter account.** Tweets were scraped with SNScrape from the "Financial Chronicle" (`ChronicleLK`) handle, so what the paper calls Sri Lankan market sentiment is the editorial tone of a single English-language financial publisher, not investor sentiment. Every claim in the paper about sentiment influencing the indexes is scoped to that one feed, and the S&P 20 result, where Twitter is the single strongest correlate, rests entirely on it.

#### Gap it's addressing

- **Existing CSE prediction work is company-level, daily, and fed on past prices.** The related work section surveys ARIMA and BPNN on ASPI weekly data, RNN variants on COMB, RCL and JKH, LSTM on selected bank counters, ARIMA on AEL, and Random Forest on announcement-driven forecasts for CTC, DIAL and JKH, and the authors' summary is that most of this uses past stock data as the independent variable and treats the problem as pure time series analysis.
- **Sentiment has been used locally but narrowly.** Where sentiment appears in the surveyed work it is attached to specific companies rather than to the market, and the foreign studies that combine sentiment with prices (Dow 30 with LSTM, AAPL with LR and SVM) do not transfer their variable choices to a frontier market.
- **The macro literature on Sri Lanka stops at correlation.** The second half of the related work reviews impact studies on money supply, exchange rate, GDP, inflation, interest rates, treasury bills and oil consumption against the ASPI and ASTRI, and the authors note that these establish direction of association without anyone folding the variables into a predictive model. The contribution claimed is exactly that bridge, take the macro variables the impact literature already validated, add global conditions and sentiment, and predict the index rather than describe it.

#### Data and setup

Monthly data from January 2010 to December 2022, <font color="#ffc000">156 rows per index</font>, with ASPI and S&P 20 series taken from investing.com. One missing value, April 2020 for the S&P 20, was filled with the average of March 2020 and May 2020.

- **Macroeconomic variables, nine of them**, from CBSL and tradingeconomics: Average Weighted Lending Rate (AWLR), Sri Lanka exports, monthly average USD exchange rate, broad money M2b, currency in circulation, tourist earnings, unemployment rate, industrial production and CPI.
- **Global conditions** are represented by the S&P 500 index alone, also from investing.com, standing in for both the global economic environment and global investor sentiment.
- **Sentiment** comes from the `ChronicleLK` Twitter feed via SNScrape. Four NLP models were scored against a Kaggle dataset, TextBlob at 0.659, Vader at 0.756, Flair at 0.796 and a <font color="#ffff00">Transformers RoBERTa</font> model at 0.864, and RoBERTa was selected on that basis. Each tweet was then labelled positive, negative or neutral, mapped to +1, -1 and 0, and the scores aggregated to a monthly figure.

The 39-month test partition that comes out of the 75/25 split is the number to keep in mind for the rest of the note, because every model comparison in the paper is decided on it.

#### Feature selection

Selection runs in three stages and all three happen on the full dataset before any split. First, correlation between each index and each independent variable at a one-month lag. Then, for each variable, the lag is swept month by month and the lag with the highest correlation is kept. The paper's reading bands are stated explicitly, above 0.75 perfect, 0.5 to 0.75 good, 0.4 to 0.5 moderate, 0.3 to 0.4 weak, mirrored on the negative side, and anything between -0.3 and 0.3 treated as no correlation.

The lag sweep is where the interesting structure shows up, and Table III is the table to read for it, because the monetary variables all move from weak or moderate at one month to good at four to six months.

![[Pasted image 20260920120002.png]]

AWLR goes from -0.497 at lag 1 to -0.643 at lag 6, currency in circulation from 0.566 to 0.577 at lag 5, broad money M2b from 0.535 to 0.544 at lag 5, and the exchange rate from 0.456 to 0.480 at lag 4. The selection rule is a per-variable argmax:

$$k_i^{*} = \arg\max_{k \in \{1,\dots,K\}} \left| \operatorname{corr}\left(X_{i,t-k},\, Y_t\right) \right|, \qquad \rho_i^{*} = \operatorname{corr}\left(X_{i,t-k_i^{*}},\, Y_t\right)$$

where:
- $Y_t$ is the index level in month $t$, not a return, which matters for how these correlations should be read
- $k_i^{*}$ is the retained lag for variable $i$, and $K$ is never stated, so the number of comparisons behind each reported $\rho_i^{*}$ is unknown
- $\rho_i^{*}$ is the figure carried into the stepwise stage, and it is a maximum over $K$ candidates rather than a single pre-specified test

Forward stepwise regression then adds variables one at a time on multiple R, R square and adjusted R square, and a p-value pass at 0.05 removes the least significant variable and repeats until everything clears. For the ASPI the full eight-variable set reaches multiple R of 0.860, R square 0.740 and adjusted R square 0.726, then CPI is dropped at p = 0.094 and the remaining seven all clear. For the S&P 20 the five-variable set reaches multiple R of 0.691, R square 0.477 and adjusted R square 0.460, then the exchange rate is dropped at p = 0.317 and four variables survive.

The two final sets barely overlap, which is the paper's most substantive result and the reason the table below is worth keeping:

| Final set | ASPI (7 variables) | S&P SL20 (4 variables) |
| --- | --- | --- |
| AWLR | lag 6, -0.643 | dropped, -0.259 |
| Sri Lanka exports | lag 1, 0.558 | dropped, 0.188 |
| Exchange rate | lag 4, 0.480 | dropped at p = 0.317 |
| Broad money M2b | lag 5, 0.544 | dropped, -0.278 |
| Currency in circulation | lag 5, 0.577 | dropped, -0.250 |
| S&P 500 | lag 1, 0.615 | dropped, -0.164 |
| Twitter sentiment | lag 1, 0.362 | lag 1, 0.457 |
| Unemployment rate | dropped, 0.067 | lag 1, -0.414 |
| Industrial production | dropped, -0.055 | lag 7, 0.354 |
| Tourist earnings | dropped, -0.075 | lag 1, 0.313 |

Sentiment is the only variable that survives for both, and it is the weakest surviving correlate for the ASPI and the strongest for the S&P 20.

#### Model building and training

Six model families are trained per index, Decision Tree, Random Forest, SVR, ANN, CNN and a multivariate LSTM, on a 75/25 `train_test_split` with `random_state` set to 0. The pipeline is run twice over, once with the selected influential variables and once with those variables plus the previous month's index value, and each of those is run under two splitting regimes, shuffled and non-shuffled.

![[Pasted image 20260920120001.png]]

The only evaluation metric is mean absolute error, reported in raw index points:

$$\text{MAE} = \frac{1}{n} \sum_{i=1}^{n} \left| y_i - x_i \right|$$

where $y_i$ is the predicted value, $x_i$ the actual value and $n$ the number of test points. The model with the lowest MAE per configuration is declared the best, and no other metric, no baseline and no significance test appears anywhere in the paper.

#### Findings

- **The two Sri Lankan indexes are driven by visibly different things, and this is the result I'd keep even after discounting the evaluation.** The ASPI retains lending rate, exports, exchange rate, broad money, currency in circulation, the S&P 500 and sentiment, so it responds to monetary conditions and foreign markets, while the S&P SL20 retains only sentiment, unemployment, industrial production and tourist earnings, and every monetary variable and the S&P 500 fail to clear on it. The authors read this as the ASPI being broad-market and macro-sensitive while the twenty-counter index is more locally sentiment-driven, which is plausible, though on this evidence it is an association across 156 monthly observations rather than a tested mechanism.
- **Monetary variables lead the ASPI by four to six months, which no correlation-only study in the local literature reports.** The lag sweep is the paper's cleanest piece of work, and the fact that AWLR, M2b, currency in circulation and the exchange rate all improve at multi-month lags while exports, CPI, the S&P 500 and sentiment peak at one month is a structure worth carrying forward, with the caveat about argmax selection below.
- **Shuffling dominates every single comparison in the paper, by factors of three to five.** On the ASPI influential-variable dataset the best shuffled model is CNN at 304.54 against a best non-shuffled of 705.98, and the worst non-shuffled figure, Decision Tree at 1691.63, is more than five times its own shuffled score of 414.51.

  ![[Pasted image 20260920120003.png]]

  The paper reports this as models trained on shuffled data exhibiting a significantly lower error rate and treats it as a design recommendation, citing an earlier study that also suggested shuffling improves prediction. I read the same table as a leakage diagnostic rather than a result, and I come back to why in limitations.
- **Adding the previous month's index value helps, but the comparison the paper draws is not the one its tables support.** Like for like on the ANN, the ASPI non-shuffled error falls from 1254.35 to 956.30 and the shuffled error from 359.40 to 272.13, so the lagged target is doing real work. What the paper does not flag is that <font color="#ffc000">the multivariate LSTM, which held the best non-shuffled ASPI score at 705.98, is simply absent from the second experiment</font>, so the best honest number in the whole ASPI study belongs to a model that was never re-run in the configuration the paper concludes is better.

  ![[Pasted image 20260920120004.png]]

- **RoBERTa beats the lexicon and embedding baselines on the selection test, 0.864 against 0.796 for Flair, 0.756 for Vader and 0.659 for TextBlob.** That ordering matches what I'd expect and is a useful prior against reaching for TextBlob because it is easy, but the test set is a Kaggle sentiment dataset rather than Sri Lankan financial text, so this ranks the models on general English sentiment and not on the domain they were then deployed in.

| Configuration | Best shuffled | Best non-shuffled |
| --- | --- | --- |
| ASPI, influential variables | CNN, 304.54 | Multi-LSTM, 705.98 |
| ASPI, plus previous month's index | ANN, 272.13 | ANN, 956.30 |
| S&P 20, influential variables | ANN, 214.98 | Multi-LSTM, 310.08 |
| S&P 20, plus previous month's index | CNN, 147.86 | CNN, 230.55 |

#### Limitations

- **Shuffling a monthly index series before splitting is look-ahead leakage, and it invalidates the headline numbers rather than supporting them.** With 156 consecutive months randomly assigned, a test month sits between two training months that are one step away on a slow-moving, strongly autocorrelated level series, so the model interpolates rather than forecasts, and the reported improvement is the size of the leak, not the size of the gain. The multivariate LSTM shows this indirectly, it is the one model with no shuffled score at all because shuffling destroys the sequence it consumes, and it is also the best non-shuffled performer in both indexes on the first dataset. <font color="#ff0000">On this evidence the only numbers I can use are the non-shuffled ones</font>, and those are 705.98 for the ASPI and 310.08 for the S&P 20.
- **Feature selection runs on the full sample, which leaks a second time and inflates the selected correlations independently of the split.** The lag sweep, the stepwise regression and the p-value pruning all see the test months, so the seven variables retained for the ASPI were chosen partly on data the models are then scored against. The lag sweep compounds it, since each reported correlation is a maximum over an unstated number of candidate lags, and the gains from sweeping are small enough, 0.566 to 0.577 for currency in circulation and 0.456 to 0.480 for the exchange rate, that they sit comfortably inside what selecting the best of ten or twelve lags would produce by chance. Neither the number of lags tested nor any multiplicity adjustment is reported.
- **Every correlation is computed on non-stationary levels over a sample that ends in the 2022 crisis, with no differencing, unit root test or cointegration check.** Broad money, currency in circulation, CPI and the nominal ASPI all trend upward across 2010 to 2022 and all move violently in the final year, so a correlation of 0.544 between M2b and the ASPI level is consistent with two series sharing a trend and does not establish predictive content. This matters more here than it would elsewhere because the tail of the sample is a currency collapse and an inflation spike, exactly the period where nominal index levels and nominal monetary aggregates rise together for reasons that have nothing to do with the index being predictable. The paper does not test the assumption or report results on returns.
- **There is no baseline of any kind, so an MAE of 705.98 has nothing to be measured against.** The obvious comparison for a next-month index forecast is persistence, and it is one line:

  $$\text{MAE}_{\text{naive}} = \frac{1}{n}\sum_{i=1}^{n} \left| Y_{t_i} - Y_{t_i - 1} \right|$$

  which is the average absolute month-on-month move over the test window. Until that number is on the page next to 705.98 there is no way to tell whether the seven-variable model beat last month's closing level, and given that the ASPI trades in the thousands of index points and moves by a few percent in a typical month, the two figures could plausibly be close. No buy-and-hold comparison and no drift-only comparison appear either.
- **The sentiment pipeline is under-specified at the two points where it matters most.** The source is one English-language publisher's account, so Sinhala and Tamil retail commentary, which is where a large part of CSE investor sentiment actually lives, is structurally absent, and the monthly aggregation is described only as scores being aggregated, with no statement of whether that is a sum or a mean and no normalisation by tweet volume. A sum makes a busy news month look bullish purely on count, a mean discards intensity, and the two give different series. The RoBERTa model is also never validated on the deployed domain, so its 0.864 is out-of-domain accuracy carried into a different task.
- **One split, one metric, one seed, 39 test points, and no test of whether any model difference is real.** MAE alone says nothing about directional accuracy, which is what a forecast has to get right before it can inform a trade, and the gaps the paper decides on, CNN at 304.54 against ANN at 359.40 for instance, are well inside what a different `random_state` would move on a test set that small. No repeated runs, no cross-validation appropriate to time series such as a rolling or expanding window, no confidence intervals.

#### Why this matters for my project

- **This is the concrete local example that pins the no-shuffle rule into my evaluation protocol before I write model code.** My splits are chronological, with a rolling or expanding origin and a gap between train and test where features carry lags, and shuffled results do not appear in my write-up even as a comparison, because this paper shows how readily a three-to-five-fold improvement from leakage gets reported as a design finding and then cited forward.
- **Feature selection moves inside the training fold in my pipeline, for the same reason.** Lag choice, variable screening and any significance pruning get re-run on each training window rather than once on the full history, and the lag I report is the one chosen on data the model was allowed to see. If I sweep lags at all I state the candidate set and treat the resulting correlation as selected rather than tested.
- **I work on returns, not levels, and I say so explicitly in the proposal.** [[Modeling Long-Term Volatility Memory Dynamics in the Colombo Stock Exchange]] finds persistent long memory in ASPI volatility across every regime it tests and [[Sri Lankan Stock Market Volatility Analysis, An ARMA-GARCH Approach]] finds persistence close to unity with a significant leverage effect on 2018 to 2022 ASPI, so the series my models see is differenced and the volatility structure is modelled rather than assumed away, which is also what makes the 2022 tail usable instead of dominating every correlation.
- **Persistence and buy-and-hold go into my results table as fixed columns, not as an afterthought.** Together with [[Adaptive Stock Market Portfolio Management and Stock Prices Prediction Platform for Colombo Stock Exchange of Sri Lanka]], which reported a spread of 4.88% to 18.51% on three US stocks as more than 80% accuracy, this is the second CSE-facing paper in my set where an unbenchmarked error figure carries the conclusion, and the absence of a naive comparison is the single cheapest thing to fix in the local literature.
- **The lag structure is a reusable prior for my macro features, once re-estimated properly.** AWLR at six months, M2b and currency in circulation at five, exchange rate at four, exports and CPI and the S&P 500 at one is a sensible starting grid for a Sri Lankan macro feature block, and it saves me searching from scratch, provided I re-estimate on differenced series inside the training window rather than importing these numbers as findings.
- **The ASPI against S&P SL20 divergence tells me which index to benchmark against and where the sentiment layer earns its keep.** If sentiment is the strongest surviving correlate for the twenty-counter large-cap index and the weakest for the broad index, then my sentiment component should be evaluated on liquid large caps where it has the best chance of showing signal, while my macro component is tested against the broad index, and I report both rather than one headline number.
- **The single-English-account sentiment source is the clearest statement I have of the resource gap my own work is claiming.** One publisher's feed is a news-tone proxy, not investor sentiment, and nothing in it is Sinhala, which is why building a Sinhala and code-mixed financial sentiment resource is a contribution rather than an implementation detail. [[Enhancing Multilingual Sentiment Analysis with Explainability for Sinhala, English, and Code-Mixed Content]] gives me the modelling side of that, and [[Role of Market Liquidity in Sentiment-Based Return Predictions, Evidence from Sri Lanka]] gives me the warning that the sentiment-to-return sign does not transfer from the US literature, so I validate direction on CSE data instead of assuming the positive association this paper reports.
- **A monthly index-level forecast says nothing about whether the trade is executable, which is the part I have to add.** There are no counters, no volumes, no spreads and no costs anywhere in this paper, so it cannot speak to thin trading, price bands or whale-dominated order flow, and my own evaluation stays per-counter with execution assumptions attached, because an index-point error on a monthly aggregate is not a number a CSE investor can act on.
