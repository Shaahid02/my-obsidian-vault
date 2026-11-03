---
date: 2026-11-02
type: viva-preparation
project: FYP, Adaptive Multi-Agent Orchestration for the Colombo Stock Exchange
module: 6SENG010C Software Engineering Final Project
tags: [fyp, viva, project-proposal, question-bank]
---

# Project Proposal Viva Question Bank

**Source:** prepared alongside the review in [[02-11-2026]], from the 22-slide Project Proposal dated 1 November 2026, the Ethics Declaration, the research matrices and the official Software Engineering Project Proposal materials.

**Scope:** all nine assessment criteria, the proposed research mechanism, datasets, algorithms, experiments, Software Engineering artefacts, feasibility, ethics and academic integrity.

> The objective is to be able to defend the proposal at an outstanding academic standard, not to memorise the presentation. A strong answer demonstrates independent understanding.

> **Supervisor instruction, 2 November 2026:** study this bank after submission, beginning with the 25 critical questions in Part A. See [[02-11-2026]] section 2.2.

The questions are deliberately more demanding than a typical live viva. They form a preparation bank; an examiner will select only a subset.

### Priority bands

| Band | Covers |
|---|---|
| **P0** | Critical defence: originality of the research, mathematical correctness, dataset contradictions, feasibility, mandatory ethics compliance, validity of the evaluation |
| **P1** | Core rubric: quality of requirements, architecture, development methodology, testing, planning, risk, critical literature analysis |
| **P2** | Advanced and follow-up: deeper understanding, methodological alternatives, robustness, limitations, generalisation |

For every answer, be ready to explain **what was decided, why, which evidence supports it, what alternatives were considered, how it will be verified, and what happens if it fails**.

---

### How to use this question bank

Preparation priorities

P0

Critical defence questions

Questions concerning the originality of the research, mathematical correctness, dataset contradictions, feasibility, mandatory ethics compliance and validity of the evaluation.

P1

Core rubric questions

Questions that establish the quality of requirements, architecture, development methodology, testing, planning, risk and critical literature analysis.

P2

Advanced and follow-up questions

Questions testing deeper understanding, methodological alternatives, robustness, limitations and generalisation.

For every answer, the student should be ready to explain what was decided, why it was decided, which evidence supports it, what alternatives were considered, how it will be verified and what happens if the approach fails.

The questions are deliberately more demanding than a typical live viva. They form a preparation bank; an examiner will select only a subset during the assessment.

## Part A: The 25 questions that must be answered exceptionally well

These are the highest-priority questions across the entire project. Failure to answer several of them convincingly could substantially weaken an otherwise strong proposal.

1. **P0** What is the exact unresolved Software Engineering research problem your project addresses?
2. **P0** What is your single most important technological contribution to the Body of Knowledge?
3. **P0** How does your proposed mechanism differ fundamentally from existing feature-conditioned forecast combination?
4. **P0** Is your contribution a new algorithm, a modification of an existing algorithm, a coordination framework or an application-specific integration?
5. **P0** What evidence demonstrates that your proposed research gap actually exists in the literature reviewed?
6. **P0** Why is a dynamically weighted group of heterogeneous agents preferable to one model, equal weighting or conventional ensemble learning?
7. **P0** What is the mathematical definition of your proposed market-state-conditioned weighting operator?
8. **P0** How will you estimate and compare the confidence of four architecturally different agents?
9. **P0** How can outputs representing technical signals, fundamental evidence, volatility and liquidity be combined meaningfully within one weighting function?
10. **P0** Why are volatility and liquidity implemented as agents rather than state estimators or decision constraints?
11. **P0** How do you know that your proposed state-conditioning mechanism is not simply replicating recent performance-reactive weighting?
12. **P0** Why is equal weighting your primary baseline, and what would you conclude if it outperforms your proposed approach?
13. **P0** How did you define the statistical success criterion involving the interquartile range across 16 folds, and why is it appropriate?
14. **P0** How will you prevent look-ahead bias throughout market data processing, corporate-action adjustment and financial-document retrieval?
15. **P0** How will you prevent survivorship bias and ensure the historical security universe reflects actual tradability at each decision date?
16. **P0** Why does your proposal report 355 securities while an earlier Dataset Matrix records 323, including rights-issue securities?
17. **P0** Can you demonstrate the evidence supporting your reported 99.93% close-price agreement, 0.13% turnover reconciliation and corporate-action corrections?
18. **P0** How can you justify execution-cost modelling without actual CSE bid, ask or order-book depth data?
19. **P0** Does your proposed nonlinear execution-cost function preserve the convexity of your allocation objective? Prove or qualify your answer.
20. **P0** Why do you need 16 walk-forward folds, five comparison arms, five seeds and multiple ablations? Is this achievable within the project schedule?
21. **P0** What are the complete Functional, Non-functional, Data, Model/AI and Boundary Requirements of your proposed software artefact?
22. **P0** How does your proposed architecture satisfy the requirements, research questions and evaluation criteria?
23. **P0** What is the difference between your Design Science Research methodology, evolutionary-prototyping process and experimental evaluation methodology?
24. **P0** Why does your Ethics Declaration state 6SENG010W while your Project Proposal identifies 6SENG010C, and what is the status of separate supervisor acceptance?
25. **P0** If you could implement only the minimum necessary components to answer your main research question, what exactly would you build, test and evaluate?

These 25 questions should be answered confidently before spending time on lower-priority viva preparation.

## Part B: Questions organised by the official marking rubric

### Criterion 1: Problem or Opportunity and Project Goal (10%)

Slides 1–4 and 20 | Priority P1

1. What is the difference between the practical problem faced by financial decision-makers and the research problem addressed by this Software Engineering project?
2. Why is unreliable agent coordination a significant problem rather than simply a limitation of individual forecasting models?
3. What evidence suggests that the reliability of an agent's information channel changes across different market conditions?
4. Does a model's poor forecasting performance necessarily imply that its aggregation mechanism is inadequate?
5. Are the documented failures in FinAgent, AlphaAgents and the CSE forecasting study causally attributable to fixed or ineffective coordination? How would you establish that?
6. Why does the absence of an explicit weight vector constitute a limitation? Could prompt-based coordination adapt implicitly?
7. Can a prompt-based system respond to changing conditions without maintaining numerical influence weights?
8. What problem does your proposed system solve that a conventional weighted ensemble cannot?
9. What is the actual decision produced by the system: trade/no-trade, directional prediction, position size, portfolio allocation or something else?
10. What happens to an investor if the Fundamental Agent relies on a report that is eleven months old?
11. How do stale evidence, incorrect evidence and unavailable evidence differ?
12. Who will operate the proposed software artefact, and who will benefit from the research?
13. What measurable outcomes would show that the technical problem has been addressed?
14. Why is the Colombo Stock Exchange suitable for investigating this problem?
15. Would the research problem still exist if the Colombo Stock Exchange were replaced by another market?
16. What specific outcome would demonstrate that the original problem statement or motivating hypothesis was incorrect?
17. Why is this an appropriate Software Engineering Final Year Project rather than solely a finance or investment-management study?
18. Can you explain the research problem, the proposed solution and its significance in 60 seconds without referring to your slides?

### Criterion 2: Background and Evidence (10%)

Slides 3–6, 8 and 21 | Priority P1

#### Literature selection and critical analysis

1. Why did you select these 59 papers, and how did you determine that the coverage was sufficiently representative?
2. What were your search terms, databases, inclusion criteria and exclusion criteria?
3. How many papers are peer-reviewed publications, preprints, surveys and working papers?
4. How did you establish that a paper was technically relevant rather than merely connected to financial forecasting?
5. Which six prior systems are most directly relevant to your proposed contribution?
6. What exactly does TradingAgents contribute, and which of its limitations are important for your research?
7. How does FinVision combine heterogeneous analysis outputs?
8. How does HedgeAgents optimise weights, and why is its asset-weighting problem different from your agent-influence problem?
9. How does MacroHFT incorporate market-state information?
10. If MacroHFT already uses market-state conditioning, why does your proposal remain novel?
11. What does TRIAG contribute to learned agent coordination, and what limitation does your proposal specifically address?
12. How is the CSE work by Pavithya et al. similar to your proposed system?
13. What is technically wrong, if anything, with the fixed 3:1 weighting used in that CSE study?
14. What is Automate Strategy Finding, and why does its selection or weighting mechanism not fully address your problem?
15. What is the most relevant prior work in feature-conditioned forecast combination?
16. Which existing work most seriously challenges your novelty claim?
17. How does the 50-year forecast-combination review influence your choice of baselines?
18. Which previous studies report adaptive weighting methods that fail to outperform simple averages?
19. Which papers influenced your choice of liquidity variables?
20. Which papers justify volatility persistence as a potentially useful control signal?
21. Which papers support the use of structurally estimated rather than self-reported confidence?
22. Why have you excluded sentiment analysis despite the availability of sentiment-based trading literature?
23. What research claims did you withdraw after reviewing stronger prior work?
24. You report that only four of 59 papers are reproducible from the publication alone. What exact reproducibility criteria did you use?
25. Can you identify the four papers, explain why they passed and show how the other papers were classified?
26. How did your literature review directly change the functional requirements and architecture?
27. Can you demonstrate a complete evidence chain from one research paper to a limitation, requirement, design decision and evaluation test?
28. Which important evidence remains unavailable or uncertain, and how does that affect your proposal?

### Criterion 2: Research Gap, Novelty and Contribution to the Body of Knowledge

Primarily Slides 4–8 and Research Gap Matrix | Priority P0/P1

#### Main research gap

1. State the main research gap in one technically precise sentence.
2. Why have you identified a gap in agent influence weighting rather than in financial prediction accuracy?
3. Is there a difference between dynamically weighting agents and dynamically weighting model predictions?
4. How does your approach differ from mixture-of-experts models and conventional gating networks?
5. What is the significance of agents being methodologically heterogeneous, rather than merely having different prompts?
6. Why must the agents contribute to one shared decision?
7. What does market-state-conditioned mean operationally?
8. Are liquidity and volatility necessarily exogenous in the econometric sense? If not, why do you describe them as exogenous market-state inputs?
9. What is the relationship between agent reliability and market-state conditioning?
10. Why is a low-capacity gating operator preferable to a more expressive neural network?
11. What is novel about the coordination procedure beyond adding features to an existing weighting model?
12. Is the proposed contribution methodological, architectural, algorithmic or empirical? Which classification is most defensible?
13. How does the abstention channel change the orchestration problem?
14. Is abstention itself novel? If not, what part of its integration is potentially original?
15. How will you establish whether the orchestration mechanism improves decisions rather than merely producing changing weights?
16. Could a static learned weighting method produce equivalent performance? What would that imply?
17. Could a performance-reactive weighting method explain all apparent benefits of state conditioning?
18. What baseline would most directly falsify your claimed methodological contribution?
19. If the proposed operator cannot outperform equal weighting, does your technical contribution disappear?
20. If the new operator reproduces an existing feature-conditioned forecast-combination method, what additional work would be needed to justify novelty?

#### Supporting Sub-gap 1: Liquidity and execution friction

21. Why was the original broad execution-cost novelty claim withdrawn?
22. What do Chen et al. and Wang, Gao and Li already accomplish?
23. What precise limitation remains after accounting for existing queue-reactive and Almgren–Chriss approaches?
24. How does liquidity affect both the reliability of price-derived signals and the economic cost of executing decisions?
25. What is genuinely new about incorporating both effects into a shared decision mechanism?
26. Can you claim a new market-impact model without observed order-book depth or execution data?
27. Why is a proxy-based execution-cost experiment a valid supporting investigation rather than a validation of actual CSE trading costs?
28. How would you determine whether execution-cost conditioning contributes value independently of liquidity-based agent weighting?

#### Supporting Sub-gap 2: Volatility persistence

29. What is the difference between volatility level and volatility persistence?
30. How do EWMA, GARCH and FIGARCH represent volatility behaviour differently?
31. Why might a persistence estimate change the schedule for restoring exposure after a volatility shock?
32. Is persistence-aware exposure control a separate research contribution or a supporting input to your orchestration mechanism?
33. Why does your latest presentation emphasise confidence comparability as SQ2 rather than volatility persistence?
34. What happens to the project if the persistence component is removed?
35. How would you test whether persistence adds predictive or decision value beyond the current volatility level?

### Criterion 3: Research Questions, Aim, Objectives and Success Criteria

Slide 7 | Priority P1

1. What is your overall research aim?
2. How does the main research question arise directly from the research gap?
3. Why is the main question phrased as “How should influence be adapted?” rather than “Does dynamic weighting outperform static weighting?”
4. What exact experiment will answer the main research question?
5. What outcome would constitute a complete answer if the proposed method performs poorly?
6. How does Supporting Question 1 differ from the main question?
7. What experiment specifically isolates liquidity-sensitive agent reliability?
8. What separate experiment isolates execution-cost integration?
9. What is Supporting Question 2 intended to discover about heterogeneous confidence?
10. How will you measure whether different confidence estimates have become comparable?
11. What would constitute evidence that the proposed confidence-alignment process is unsuccessful?
12. Where is volatility persistence evaluated within the final research-question structure?
13. What are Objectives O1–O6, individually?
14. Is each objective a research objective, an engineering objective or both?
15. How is every objective measurable?
16. How does each objective connect to at least one requirement, experiment or artefact?
17. What is the meaning of acceptance criteria A1–A6?
18. Why is the proposed IQR-based primary success criterion appropriate?
19. What are the exact conditions under which the student would accept or reject each hypothesis?
20. Can the project satisfy its research aim even when the primary hypothesis is not supported?

### Criterion 3: Initial Requirements and Indicative Solution (20%)

Slides 9–12 | Highest-weighted criterion | Priority P1

#### Requirements elicitation and specification

1. What methodology did you use to elicit requirements for a research-oriented financial decision-support artefact?
2. Why did you choose documentary and technical evidence rather than human-participant interviews?
3. Who are the principal stakeholders, and how do their responsibilities influence the requirements?
4. How did you distinguish stakeholder needs from technical implementation assumptions?
5. How were the 43 requirements derived?
6. What are the 11 Functional Requirements, and why is each necessary?
7. What are the seven Non-functional Requirements, and how are they measured?
8. What are the ten Data Requirements?
9. What are the seven Model/AI Requirements?
10. What are the eight Boundary Requirements?
11. Why are exactly three requirements classified as Should?
12. How did you prioritise requirements?
13. What evidence supports the priority of each Must requirement?
14. Can you identify any requirements that are actually design decisions rather than externally justified needs?
15. What is the acceptance criterion for FR1, the point-in-time data-access requirement?
16. Why should a cursor violation raise an exception rather than issue a warning?
17. What are the six fields required by FR2's common agent-output contract?
18. How will you verify contract conformance across architecturally different components?
19. What makes a non-functional requirement such as reproducibility objectively testable?
20. What is the difference between a Data Requirement and a Model/AI Requirement?
21. Why is logging weight entropy a system requirement rather than merely an experimental metric?
22. What is the significance of carrying `ex_date_basis` as a field?
23. Can you demonstrate a complete traceability path from a cited research problem to a functional requirement, architecture component and test case?
24. How would a requirement be updated if the underlying research evidence were found to be incorrect?
25. Which requirement would be most damaging to remove, and why?

#### Indicative technical solution

26. Describe the complete proposed system architecture without looking at Slide 11.
27. Why have you divided the system into five layers?
28. What are the responsibilities of the Data Layer?
29. Why do all components access market information through one point-in-time query interface?
30. What are the responsibilities of the Agent Layer?
31. What is the role of the State Layer?
32. What is the role of the Orchestration Layer?
33. Why is the Evaluation Layer architecturally separate?
34. How does information flow from raw historical data to a final decision?
35. What is the difference between a recommendation signal and an execution constraint?
36. Why should an evaluator trust your architecture to enforce temporal consistency?
37. How is a cached output made identical across all experimental arms?
38. What happens when a component fails to produce a valid output?
39. How does the architecture handle conflicting agent recommendations?
40. What happens when the Fundamental Agent abstains because no relevant filing is available?
41. What happens if all four agents abstain simultaneously?
42. Which design choices were made specifically to support experiment reproducibility?
43. Why did you choose a batch research pipeline instead of a user-facing application?
44. Which architectural decisions are irreversible or particularly costly to change later?
45. Which formal design artefacts are required by your selected software development methodology?

## Part C: Deep technical defence of the proposed system

These questions supplement the official rubric and are particularly important because the student is proposing a technical contribution, not simply building a conventional information system.

### 1. Agent architecture and heterogeneity

Slides 6, 10 and 11 | Priority P0/P1

#### General agent design

1. What exactly qualifies a component as an agent in your proposed architecture?
2. Are your four agents autonomous, goal-directed entities, or specialised forecasting and analysis modules?
3. Which properties distinguish an agent from an ordinary software component?
4. What makes the four agents methodologically heterogeneous?
5. Do all four agents solve the same prediction or decision problem?
6. If their objectives differ, how can their outputs be meaningfully weighted together?
7. What common decision space must they share for the weighting operator to be mathematically valid?
8. Is each agent required to produce a directional signal, an expected return, an allocation recommendation or a structured opinion?
9. How will incompatible agent outputs be normalised?
10. Does a higher agent weight always imply a larger financial position?
11. How does the architecture prevent an individual agent from dominating decisions solely because its outputs have a larger numerical scale?
12. Why did you choose four agents instead of two, three or five?
13. What experiment will establish whether all four agents are necessary?
14. What would happen if two agents consistently produced highly correlated outputs?
15. How will you detect duplicate evidence or shared dependencies between agents?

#### Technical Agent: $A_T$

16. What precise information does the Technical Agent receive?
17. Which technical indicators, features or models will it use?
18. Why are those features appropriate for thinly traded securities?
19. How will you distinguish genuine price stability from stale prices caused by no trading?
20. How will you determine the Technical Agent's confidence when trading activity is limited?
21. How will you benchmark the Technical Agent against a simple random-walk or no-skill model?

#### Fundamental Agent: $A_F$

22. What specific financial information will the Fundamental Agent extract from company filings?
23. Why is retrieval-augmented generation appropriate for this component?
24. How will you distinguish correct document retrieval from correct financial reasoning?
25. How will you prevent the agent from using a report published after the simulated decision date?
26. How will the system handle scanned reports, inconsistent financial tables and missing values?
27. How will the Fundamental Agent determine whether a numerical conclusion is supported by the retrieved document?
28. How will you evaluate the accuracy of numerical extraction, calculation and reasoning separately?
29. What does the agent output when relevant filings are unavailable?
30. How will you ensure the system does not fabricate evidence when retrieval fails?
31. Is Graph-RAG necessary, given that existing CSE Graph-RAG research already addresses a related problem?
32. How will you demonstrate that adding the Fundamental Agent improves or changes the shared decision?

#### Volatility Agent: $A_V$

33. Is the Volatility Agent forecasting future risk, recommending exposure or both?
34. Which target variable is it predicting?
35. Why would you choose GARCH, GJR-GARCH, FIGARCH or a combination of them?
36. How will you determine whether volatility persistence estimates are stable enough to use?
37. What happens when the required estimation window is unavailable?
38. How will volatility uncertainty influence the orchestrator rather than merely control portfolio exposure?

#### Liquidity Agent: $A_L$

39. What exact output does the Liquidity Agent generate?
40. Is it providing an assessment of liquidity, an execution-cost estimate or an independent investment recommendation?
41. How is the Liquidity Agent's output different from the liquidity state variable LtL_tLt?
42. Is it possible that liquidity information will be counted twice in the weighting mechanism?
43. How will you measure the additional value of this component?
44. What happens when reliable liquidity information is unavailable?
45. How will you justify treating the Liquidity Agent as a voting agent rather than as a constraint provider?

### 2. Formal mathematical defence of the orchestration mechanism

Slides 6, 7, 11, 14 and backup derivation | Priority P0

The student should be prepared to derive and explain the proposed weighting function:

$$w_{i,t}=f(L_t,V_t,P_t,C_{i,t})$$

1. Define every variable and index in the equation.
2. What is the range and unit of each input?
3. Does ttt represent a day, observation, decision event or continuous time?
4. How often are weights recalculated?
5. Is the function fff shared across agents or separately parameterised for each agent?
6. Is fff linear, nonlinear, gated, learned or optimised?
7. What exactly is the low-capacity gated-linear formulation mentioned on Slide 11?
8. How will you estimate its parameters without overfitting?
9. What is the training objective?
10. What constraints must the weights satisfy?
11. Must weights be non-negative?
12. Must the weights sum to one?
13. If you use a simplex constraint, what happens when an agent abstains?
14. What happens if all agent confidence values are zero?
15. Can the operator assign zero weight to a valid but consistently poor agent?
16. What prevents the operator from permanently excluding the Fundamental Agent?
17. How will you establish that changes in weights are genuinely driven by market state?
18. How will you distinguish useful conditional adaptation from arbitrary weight fluctuations?
19. What is weight entropy, and why is it an important diagnostic?
20. What does entropy collapse mean in your context?
21. Can a system with frequently changing weights still behave almost identically to equal weighting?
22. How will you determine whether weights are sensitive to liquidity while other variables are controlled?
23. How will you identify collinearity between liquidity and volatility?
24. What happens if market conditions and recent agent performance are highly correlated?
25. How will you determine which input is responsible for a particular weighting change?
26. Why not use a conventional softmax gating network?
27. Why not use a Bayesian model average or online expert-weighting algorithm?
28. Why not use a standard portfolio optimiser without an agent-level weighting mechanism?
29. How will regularisation affect the stability and interpretability of the weights?
30. How will you explain the result if the weighting function becomes numerically unstable?
31. How will you quantify the complexity cost of the proposed operator?
32. What mathematical and empirical conditions must hold before you can claim the operator contributes new knowledge?

### 3. Confidence calibration and abstention

Slides 6, 7, 11, 14 and Conditioning Set | Priority P0/P1

1. What is the difference between confidence, predictive probability, calibration and uncertainty?
2. Why is an LLM's self-reported confidence not sufficient?
3. What does structural confidence mean?
4. What structural indicators determine confidence for the Fundamental Agent?
5. How does the Technical Agent's confidence depend on out-of-sample predictive competence?
6. What is Theil's U2U_2U2, and when is it appropriate?
7. How will the Volatility Agent's confidence be measured?
8. What role might conformal prediction play in volatility uncertainty estimation?
9. Why is conformal prediction not itself a new contribution of this project?
10. How will the Liquidity Agent's reliability be estimated?
11. How can different confidence estimators be mapped onto one common scale?
12. What is the ground-truth outcome used for calibration?
13. If different agents predict different targets, how can their confidence scores be meaningfully compared?
14. What is an accuracy-at-threshold curve?
15. Why does monotonicity matter when constructing a confidence mapping?
16. How will the calibration mapping be learned without using future observations?
17. How will you select a threshold without optimising it on the held-out test set?
18. How will you evaluate calibration error?
19. What happens when confidence decreases but the agent remains directionally correct?
20. What happens when an agent produces a well-formed output unsupported by its evidence?
21. How is an invalid output different from a low-confidence output?
22. What conditions trigger abstention?
23. Should abstention reduce a weight gradually or set it immediately to zero?
24. What is the coverage–accuracy trade-off?
25. How will abstention affect total financial performance when days without decisions are included?
26. Does “held flat” mean retaining an existing position or closing it and holding cash?
27. How will you account for the transaction costs associated with changing exposure because of abstention?
28. What would demonstrate that abstention is economically harmful despite improving conditional accuracy?
29. What is the expected consequence if cross-agent confidence cannot be calibrated reliably?
30. Can the main research question still be answered without a successful confidence-alignment mechanism?

### 4. Dataset strategy, provenance and quality

Slides 9, 12, 15, 17 and 19 | Priority P0/P1

#### Dataset selection and provenance

1. Which dataset is your authoritative primary market-data source?
2. What does the official CSE Data Library provide that the public API does not?
3. Why was the official Data Library selected?
4. Was the dataset genuinely purchased, and what evidence documents the acquisition?
5. How many raw securities are in the original files?
6. How many are genuine ordinary securities after removing rights issues or other non-investable instruments?
7. How many pass your eligibility criteria?
8. Why does the proposal refer to 355 core securities and 233 candidate securities?
9. How do these figures relate to the earlier 323-security extraction?
10. Why does the presentation describe 46 securities absent from the earlier API dataset?
11. What is the exact final observation count?
12. How were duplicate and invalid observations identified?
13. What is the actual date range of the final usable dataset?
14. Why was July 2012–June 2026 chosen for evaluation?
15. What is the difference between raw dataset coverage and usable per-security history?
16. Can you reproduce the dataset-selection process from the source files and documented rules?

#### Dataset preprocessing and validation

17. What data-quality checks have already been performed?
18. How was the reported 99.93% close-price agreement calculated?
19. What dataset was used as the independent comparison?
20. What explains the remaining 0.07% disagreement?
21. What does the reported 0.13% turnover discrepancy mean?
22. How was the 99.82% VWAP-in-range result established?
23. What kinds of source-data anomalies were found?
24. How were corporate-action adjustments applied?
25. What is the difference between an adjusted close and a total-return-adjusted close?
26. Why must ex-dates be distinguished from announcement dates and payment dates?
27. What does it mean that 259 ex-dates are approximate?
28. What risks arise from approximate corporate-action dates?
29. What were the 31 documented corporate-action corrections?
30. How was each correction verified?
31. How will uncertain adjustment dates be handled during backtesting?
32. What happens to observations affected by unresolved corporate-action inconsistencies?
33. How will missing trading days be distinguished from days with zero turnover?
34. How will you reconstruct the historical investable universe when securities enter, exit or become suspended?
35. How will you prevent survivorship bias from excluding securities that were subsequently delisted?
36. How will your liquidity screen avoid using information from future periods?

#### Filings and fundamental data

37. How were the 22,893 company documents collected?
38. Are these unique documents, or could multiple announcements reference the same report?
39. How are the documents linked to securities?
40. How is the actual publication date determined?
41. Why is the date embedded in a filename not necessarily sufficient proof of point-in-time availability?
42. How will you handle filing corrections, withdrawn announcements or revised financial statements?
43. How will you evaluate the Fundamental Agent when no filing is available for a security?
44. What evidence demonstrates the corpus is suitable for financial numerical reasoning?

#### Liquidity and cost data

45. What are the differences between volume, turnover, trade count, market capitalisation, float and order-book depth?
46. What is Amihud illiquidity, and what does it measure?
47. What are the limitations of using daily turnover or Amihud as a proxy for actual executable liquidity?
48. What does the available CSE dataset tell you about non-trading frequency?
49. How will you construct a point-in-time liquidity state?
50. How can crossing transactions distort the interpretation of liquidity?
51. What is the significance of the reported 8.8%–47.4% range for crossings?
52. Why are bid, ask and depth necessary for validating some proposed execution-cost claims?
53. What cost assumptions can you defend without those fields?
54. What analysis will you omit if the necessary microstructure data cannot be obtained?
55. How will you distinguish measured data, derived features, approximations and unvalidated simulated costs?

## Part D: Research methodology, evaluation and Software Engineering defence

### 1. Research methodology and experimental design

Slides 7, 13 and 14 | Priority P0/P1

#### Research methodology

1. Why is Design Science Research an appropriate methodology for this project?
2. What are the main stages of Design Science Research, and how does each apply to your work?
3. What is the research artefact in the context of Design Science?
4. What new knowledge will be produced by evaluating the artefact?
5. How is your proposed research different from simply benchmarking financial forecasting systems?
6. What is the difference between research methodology and development methodology?
7. How will the research be reproducible by another independent investigator?
8. What are the main threats to internal validity?
9. What are the main threats to external validity?
10. What are the main threats to construct validity?
11. What are the main threats to statistical-conclusion validity?
12. How will you distinguish conclusions supported by evidence from interpretations or hypotheses?

#### Baseline design

13. Why is equal weighting the primary baseline?
14. What is the exact equal-weight calculation when some agents abstain?
15. How is the static learned-weight baseline trained?
16. Which inputs does the static baseline receive?
17. How does the inverse-MSE performance-reactive baseline work?
18. Why is inverse-MSE an appropriate representation of performance-adaptive weighting?
19. What performance metric is used for the inverse-MSE calculation when agents predict different targets?
20. How do you ensure the inverse-MSE baseline does not use future performance?
21. What information can the proposed dynamic operator access that the baseline methods cannot?
22. Could giving the proposed operator additional information create an unfair comparison?
23. Why must all experimental arms receive byte-identical cached outputs?
24. What does it mean to compare methods while holding the agent pool constant?
25. How will you distinguish gains from better agents versus gains from better orchestration?
26. Why include an oracle?
27. What information does the oracle use from the test window?
28. Why must the oracle not be treated as an implementable baseline?
29. What is the interpretation of the gap between the oracle and the proposed method?
30. What would it mean if the proposed method appeared to outperform the oracle?

#### Walk-forward evaluation

31. Why did you choose a rolling window instead of an expanding window?
32. Why is the training window 1,250 trading days?
33. Why is each test window 125 trading days?
34. Why are there 16 folds?
35. Are the folds overlapping or non-overlapping, and what implications does this have for statistical testing?
36. Can the intended CSE dataset provide the required history for all eligible securities?
37. How will securities with shorter trading histories be treated?
38. How often will models and confidence mappings be retrained?
39. What information becomes available between successive folds?
40. How will hyperparameters be selected without contaminating the test window?
41. How will preprocessing be fitted and applied inside each fold?
42. How will the point-in-time document retrieval system respect the simulation date?
43. How will you prevent results from being influenced by decisions taken after seeing held-out performance?

#### Performance metrics and statistical testing

44. What is the primary outcome metric, and why is it appropriate?
45. How is cost-adjusted portfolio return calculated?
46. How will returns be compared when the methods trade at different frequencies?
47. What is the difference between per-traded-day return and total-period return?
48. Why must abstained days be included when measuring total economic performance?
49. Which risk-adjusted metrics will you report?
50. How will turnover, transaction costs and drawdown be represented?
51. Why can classification accuracy be misleading in financial decision-making?
52. What is Matthews correlation coefficient, and why report it alongside F1?
53. What is the class balance of the prediction targets, and how will it affect metric interpretation?
54. What is the statistical definition of your median per-fold improvement?
55. What is the exact distribution used to calculate the equal-weight baseline's interquartile range?
56. Why should the interquartile range determine the minimum practically important improvement?
57. Why is a 5% statistical significance threshold appropriate?
58. What is HAC-adjusted inference, and why is it needed for financial time series?
59. Which HAC lag or bandwidth-selection method will be used?
60. Why is an ordinary independent-observation bootstrap potentially inappropriate?
61. What block-bootstrap or alternative dependent-data resampling procedure will you use?
62. How will you account for the comparison of five arms and numerous ablations?
63. What is the difference between a statistically significant improvement and an economically meaningful improvement?
64. How will results from different random seeds be aggregated?
65. What actually changes when a different random seed is used?
66. How will the project interpret a result that is positive on average but negative in several market regimes?
67. What result would justify concluding that state-aware orchestration is not worthwhile?

#### Ablation and robustness

68. What is an ablation study?
69. Why is ablation essential for your proposed research contribution?
70. What happens when liquidity conditioning is removed?
71. What happens when volatility-level conditioning is removed?
72. What happens when persistence conditioning is removed?
73. What happens when confidence conditioning is removed?
74. What happens when the Fundamental Agent is removed?
75. How will you isolate the effects of liquidity-conditioned reliability from execution-cost conditioning?
76. What is the purpose of measuring agent error correlation?
77. What is the purpose of the weight-entropy diagnostic?
78. How will you establish whether the weights genuinely respond to changing market state?
79. How will you determine whether a weighting change produces a useful decision change?
80. Why test separately across the Easter attacks, COVID-19 and the 2022 Sri Lankan economic crisis?
81. How will you avoid defining market regimes using information unavailable at the time?
82. How will you evaluate robustness across liquid and illiquid securities?
83. What conclusions would remain valid if none of the ablations showed an improvement?

### 2. Software development methodology and lifecycle

Slides 11, 13, 15–17 | Priority P1

1. Why did you choose evolutionary prototyping instead of Waterfall, Scrum or another development model?
2. What aspects of the proposed system make iterative prototyping appropriate?
3. What is the relationship between the prototype and the final research artefact?
4. What are your intended development stages?
5. What is the objective of each stage?
6. What evidence must be produced before moving to the next stage?
7. Why must the point-in-time Data Layer be developed before the agents?
8. How will you verify that the common agent-output contract works before implementing the orchestration operator?
9. How will you implement and verify the component interfaces?
10. What coding standards and architectural principles will guide implementation?
11. How will you control changes to requirements after the PP?
12. What is your version-control and branching strategy?
13. How will experiments, datasets, model versions and parameters be recorded?
14. How will you incorporate supervisor feedback without losing traceability of decisions?
15. What is your process for documenting defects and implementing corrective actions?
16. How will you distinguish a defect in software implementation from a failure of the research hypothesis?
17. What is the intended deployment or execution environment?
18. Why is a batch pipeline appropriate for this artefact?
19. What is the minimum viable research prototype?
20. How will the development process ensure that software testing is not deferred until the end?

### 3. Software testing, QA and verification

Slide 15 | Priority P1

1. What are the differences between unit, integration, system, regression and acceptance testing?
2. Which components require unit tests?
3. What would a unit test for `DataLayer.query(ticker, fields, as_of)` verify?
4. How will you verify that a `CursorViolation` is raised when future information is requested?
5. What is the common agent-output contract conformance test?
6. How will you test invalid or missing agent outputs?
7. What does the simplex-invariant test verify?
8. What is an arm-isolation test?
9. How will you establish that cached outputs are identical across experimental arms?
10. How will you verify seed determinism?
11. How will you test the calibration transformation independently?
12. How will you test confidence-gating and abstention behaviour?
13. What is the expected behaviour when all agents abstain?
14. How will you test temporal alignment between market data and financial filings?
15. How will you validate the corporate-action-adjustment pipeline?
16. What data-validation tests are needed for OHLC consistency, turnover and missing days?
17. How will you test the stability of FIGARCH or other persistence estimates?
18. How will you verify the transaction-cost calculation?
19. How will you detect a technically correct but economically meaningless output?
20. How will you test weight entropy, liquidity sensitivity and collinearity diagnostics?
21. Which tests correspond to each Must requirement?
22. What evidence will demonstrate successful completion of each acceptance criterion?
23. What is the difference between software correctness and research-model validity?
24. Why is high code coverage alone insufficient evidence of system correctness?
25. How will you test third-party model or API behaviour when outputs may be nondeterministic?
26. How will you reproduce a failed experiment?
27. What is the process for identifying and reporting unresolved defects?
28. What evidence would be required to claim that the final artefact is sufficiently reliable for research use?

## Part E: Project management, ethics, scope and academic defence

### Criterion 5: Project Plan, Feasibility and Risk (10%)

Slides 17–18 | Priority P1

#### Project planning

1. What are the principal stages of your Final Year Project, from proposal through final submission?
2. What is the difference between a project milestone, a deliverable and a task?
3. How were the required activities identified and broken down?
4. What is your actual available study time each week?
5. How were the estimates of 288 hours before IPD and 216 hours afterwards calculated?
6. How did you calculate the 43-hour and 32-hour contingency allocations?
7. Why is 15% contingency sufficient?
8. Which tasks are on the project's critical path?
9. What dependencies exist between data preparation, agent development, orchestration, testing and evaluation?
10. What must be completed before the Interim Project Demonstration?
11. How will you demonstrate that the IPD prototype is meaningful rather than a collection of disconnected components?
12. Why must the experimental evaluation harness be designed before the implementation is complete?
13. What is the minimum implementation needed to answer the main research question?
14. What elements can be removed if the development schedule slips?
15. Which components must never be removed without fundamentally changing the research project?
16. Why have you identified persistence modelling as the first candidate for scope reduction?
17. What resources, libraries, computing facilities and third-party services are needed?
18. What costs or licence restrictions could affect implementation?
19. Why is the proposed development workload achievable by one final-year student?
20. How will you distinguish a missed milestone caused by poor planning from one caused by an external dependency?
21. How will you monitor actual progress against the plan?
22. Is 1 April 2027 the confirmed final-submission deadline for this particular Software Engineering module?
23. What is your contingency if the required experimental work takes longer than expected?

#### Risk management

24. How were the reported 34 project risks identified?
25. What scale was used to measure likelihood and impact?
26. Why is equal weighting outperforming your proposal classified as a high-risk event?
27. Should a negative research result necessarily be classified as project failure?
28. Which risks threaten successful software delivery, and which threaten the research contribution?
29. Which risks are within your control?
30. Which risks depend on external organisations?
31. What is your mitigation for unavailable historical bid/ask or depth data?
32. What is your fallback if the confidence estimates cannot be calibrated on a common scale?
33. What is your fallback if the persistence estimator becomes numerically unstable?
34. What happens if the Fundamental Agent produces valid responses too infrequently?
35. What happens if the orchestration weights collapse to one agent?
36. What happens if the system produces apparently strong performance because of look-ahead bias?
37. Why is point-in-time correctness treated as a non-negotiable requirement?
38. How would you detect an inaccurate corporate-action adjustment during evaluation?
39. What is the trigger for activating each major contingency?
40. How will you demonstrate that the project remains academically worthwhile if a supporting mechanism is abandoned?

### Criterion 6: Responsible Project Considerations (10%)

Slide 19 and the seven-page Ethics Declaration | Priority P0/P1

#### Ethics declaration and classification

1. Why does your project qualify for Class 1 ethical self-assessment based on its stated activities?
2. What distinguishes Class 1 from research requiring higher-level ethical review?
3. Why does your project not require human participants?
4. Are you planning interviews, surveys, user testing or evaluation by investors?
5. Would asking investors to assess the system's usefulness change the ethics requirements?
6. Would collecting opinions from financial experts constitute human-participant research?
7. What would you do if human-participant testing became necessary after submitting the Project Proposal?
8. What is the significance of the student confirmation dated 2 November 2026?
9. Does the Class 1 self-declaration constitute final supervisor acceptance?
10. Where and how is supervisor acceptance recorded?
11. Why does the ethics document state `6SENG010W` while the presentation uses `6SENG010C`?
12. Have you verified the permitted use of all datasets and third-party model services?
13. What happens if an ethics response becomes inaccurate after changing the project methodology?
14. What is the required procedure for revising the declaration?
15. What is the consequence of failing to submit the mandatory ethics declaration by the deadline?

#### Data protection, licensing and professional responsibility

16. What permissions govern your use of the official Colombo Stock Exchange Data Library?
17. Does a non-commercial student licence automatically permit redistribution of the dataset?
18. Does purchasing historical data establish permission to send the records to third-party AI services?
19. How will you make the project reproducible without sharing restricted data?
20. What permissions apply to corporate announcements and company financial reports?
21. Can publicly accessible financial documents contain personal information?
22. How will you prevent unintended disclosure of identifiable or restricted content?
23. What personal or sensitive information might exist within reports processed by the Fundamental Agent?
24. How will API keys, downloaded data and experiment logs be protected?
25. Why is this project a research prototype rather than an investment-advice product?
26. What harm could arise if users interpret the system's simulated results as reliable trading guidance?
27. Why is calibration necessary but insufficient to guarantee trustworthy outputs?
28. How can abstention itself create financial risk?
29. What happens if an agent produces a confident but fabricated explanation?
30. How will you prevent misleading claims about achievable trading returns?
31. What is the difference between simulated slippage and real execution cost?
32. Could your securities-screening process introduce systematic representational bias?
33. How will you report the limitations of using only one stock exchange?
34. What are the environmental implications of repeatedly running multiple agents and LLM calls?
35. How does caching outputs reduce computational cost?
36. What accessibility or inclusion considerations remain relevant even without a graphical interface?
37. Which responsible-project considerations directly changed your original design?
38. Can you demonstrate the traceability of those changes to requirements or risk controls?

### Criterion 7: Appropriateness of Scope (10%)

Slides 2, 11, 17 and 20 | Priority P1

1. What are the exact boundaries of your proposed project?
2. Why is a four-agent architecture sufficient?
3. Why have you excluded a fifth macroeconomic agent?
4. Why was sentiment analysis removed from the final scope?
5. What were the technical, data and ethical reasons for excluding sentiment?
6. Why is a graphical user interface unnecessary for the research artefact?
7. Why have you rejected a large neural-network orchestrator?
8. Why is a conventional low-capacity operator more appropriate?
9. Why was the proposed spread estimator demoted?
10. Why have you excluded a full microstructure execution simulator?
11. How do the nine exclusions claimed on Slide 20 reconcile with the fewer exclusions visibly enumerated there?
12. What is the minimum complete version of the system that would still answer the primary research question?
13. What makes this project sufficiently challenging for a Level 6 Software Engineering degree?
14. Which implementation tasks contribute to the research, and which are merely supporting infrastructure?
15. Are you attempting too many independent contributions?
16. What would happen if the volatility-persistence experiment were removed?
17. What would happen if liquidity modelling were simplified?
18. Could you answer your main research question using only two decision-producing agents?
19. Which requirements establish the necessity of the other components?
20. How will you prevent supporting development work from consuming time needed for rigorous evaluation?
21. How will you decide whether an optional research enhancement should be rejected?
22. What conclusions can reasonably generalise beyond the CSE?
23. What cannot be generalised from one market and one historical period?
24. If your available implementation time were reduced by one-third, what would you retain and why?

### Criterion 8: Academic Practice and Referencing (5%)

Slides 4–8, 16 and 21 | Priority P1

1. Which academic referencing style is required for the proposal?
2. Why do important numerical claims need citations at the point where they are presented?
3. Where is the complete reference list for the submitted presentation?
4. How can the examiner trace the reported Granger-causality result to its original source?
5. Which paper supports the reported 10.36-point degradation?
6. Which paper supports the argument that equal weighting is difficult to outperform?
7. What is the source of the reported institutional-ownership figure?
8. Which sources underpin the proposed confidence-calibration techniques?
9. Which elements of the weighting formulation come directly from prior work?
10. Which elements are the student's original research proposal?
11. How do you distinguish a paper's reported result from your interpretation of that result?
12. What do the categories measured by me, reported by a tool, proposed threshold, read from a paper and counted over my own corpus mean?
13. How did you verify the numerical findings in your Literature Survey?
14. What caused the 13 reported corrections to the literature notes?
15. What was the paper whose ablation finding was initially interpreted incorrectly?
16. How was that mistake detected and corrected?
17. How were the 1,621 quoted spans checked against the original notes?
18. How did you handle papers that were inaccessible or available only through abstracts?
19. Why must a paywalled study not be described as fully reviewed?
20. How did you use AI tools during literature review and research synthesis?
21. How did you ensure AI-generated interpretations did not replace your own critical analysis?
22. What evidence demonstrates that you independently understand the proposed algorithms?
23. How will you acknowledge third-party code, datasets, models and libraries?
24. Why is merely including a bibliography insufficient if individual claims lack attribution?
25. How will you establish that your submitted presentation is an accurate representation of your actual research progress?

### Criterion 9: Communication of the Proposal (10%)

All 22 slides and live presentation | Priority P1/P2

#### Questions directly associated with the presentation slides

|Slide|Examiner question|
|---|---|
|1. Introduction|Can you explain the complete project in one minute without technical jargon?|
|2. Storyline|How do the research and Software Engineering parts support one another?|
|3. Problem|What is the main evidence that makes this a significant technical problem?|
|4. Evidence to gap|Why does the literature justify the exact gap you claim?|
|5. Literature|How was your literature categorised, and what is the most important contradiction in prior work?|
|6. Novelty|What exactly is new about the proposed mechanism?|
|7. RQs and objectives|How will each research question be answered objectively?|
|8. Existing solutions|Which existing approach is the strongest competitor and why?|
|9. Stakeholders|Who will use the system, and whose needs determined the requirements?|
|10. Requirements|Can you show the full set of requirements and trace each critical requirement to evidence?|
|11. Architecture|Can you draw and explain the complete system architecture without the slide?|
|12. Data|Can you prove that your selected datasets are sufficient, valid and legally usable?|
|13. Methodology|Why are your research and development methodologies appropriate?|
|14. Evaluation|What is your primary hypothesis, and exactly how will it be tested?|
|15. Testing|How will you distinguish correct implementation from scientifically valid evaluation?|
|16. AI and feedback|What evidence demonstrates independent verification and student ownership?|
|17. Project plan|Is the proposed implementation and evaluation schedule genuinely achievable?|
|18. Risk|Which single risk is most likely to undermine the research, and what is your fallback?|
|19. Responsible practice|What ethical, legal or professional concerns materially changed your design?|
|20. Scope|Why is the project sufficiently ambitious without being over-scoped?|
|21. Referencing|Where are the actual citations and complete reference list?|
|22. Backup evidence|Can you produce the full supporting artefacts claimed to be prepared?|

#### Oral communication and presentation control

1. How would you explain your project to a Software Engineering examiner unfamiliar with financial markets?
2. Can you define your main contribution in fewer than three sentences?
3. Why is your contribution more than a new application of existing tools?
4. Can you draw the architecture on a whiteboard and explain the relationships?
5. Can you explain the weighting equation without reading from the slide?
6. Can you justify the selection of every major algorithm?
7. Can you explain the experiment sufficiently clearly that another researcher could reproduce it?
8. How would you respond if an examiner identifies a relevant paper that challenges your novelty?
9. How would you respond if a statistical expert disputes your success criterion?
10. How would you respond if a finance specialist disputes your execution-cost assumptions?
11. How would you respond if an examiner finds an error in your dataset counts?
12. How would you demonstrate ownership if an examiner asks about a research decision not explicitly stated on the slides?
13. How would you distinguish a limitation you already knew about from a new weakness identified by the examiner?
14. What would you do if an examiner challenges the feasibility of the four-agent architecture?
15. Can you explain why the project is worthwhile even if equal weighting performs better?
16. What is the strongest argument against your project, and how do you address it?
17. Which research decisions are provisional, and what evidence is needed to finalise them?
18. What would you change if you were restarting the research from the beginning?
19. Can you complete the presentation within the officially prescribed time?
20. Are the slides readable, correctly referenced and free of residual template instructions?
21. Can you answer questions without relying on a script or memorised wording?
22. Can you clearly distinguish the work already completed from work planned after submission?

## Part F: Particularly difficult examiner challenges

These are designed to test whether the student genuinely understands the research rather than simply knowing the contents of the PowerPoint.

### Advanced cross-examination

1. Your project claims a new orchestration mechanism, but feature-conditioned forecast combination already exists. Why should this be considered a meaningful contribution to Computer Science?

2. You describe four heterogeneous agents. If two are effectively risk or liquidity estimators rather than decision-making entities, is the research really a four-agent system?

3. Your liquidity variable affects both agent reliability and execution cost. How will you prove that the mechanism is not rewarding or penalising the same evidence twice?

4. If an agent produces a signal on a completely different target from another agent, what mathematical meaning does their weighted average have?

5. Why would historical prediction accuracy be a valid measure of current reliability under market distribution shift?

6. If every agent is badly calibrated, what benefit does normalising the confidence values provide?

7. Your weighting operator responds to market conditions. How will you show that it is not simply an overfitted regime-specific ensemble?

8. If equal weighting is difficult to outperform because learned weights suffer estimation error, why does adding state-dependent parameters not make your method even more vulnerable?

9. How many independent effective observations do you really have after accounting for overlapping windows, temporal dependence, correlated securities and repeated evaluation?

10. Why would an improvement over 16 folds be statistically meaningful if those folds share similar training histories?

11. If the primary outcome is full-window portfolio return, why is its success threshold based on an interquartile range computed over fold-level values?

12. Could your oracle upper bound be misleading because it uses future information and therefore has an entirely different information advantage?

13. How can you evaluate a transaction-cost-sensitive optimiser when actual CSE market-impact parameters are unknown?

14. How will you justify a convex optimisation claim if you introduce a nonlinear execution-cost function without demonstrating convexity?

15. How do you know that a volatility-persistence estimate measured over a long history is useful for the short-horizon decisions your agents make?

16. If persistence is necessary for the project, why is it absent as an explicit supporting research question in your final deck?

17. How will you distinguish a genuine shift in market state from measurement noise in illiquid securities?

18. If your Fundamental Agent abstains most of the time, why is it necessary to incur the cost and complexity of building it?

19. If the adaptive operator eventually learns to rely almost entirely on one agent, what remains of the claimed heterogeneous orchestration contribution?

20. Your dataset is described as official and validated. Can you reproduce the reported reconciliation results and explain every material discrepancy?

21. If the final research data are not permitted to be redistributed, what level of independent reproducibility can you genuinely claim?

22. How can you claim Class 1 ethical compliance while the legal basis for some data and third-party API transfers still requires verification?

23. Your risk register classifies equal weighting winning as a critical risk. Isn't that a scientifically legitimate result rather than a threat to the project?

24. If the main contribution is orchestration rather than forecasting, why are you implementing so many separate financial modelling techniques?

25. What is the simplest alternative explanation for any improvement observed in your proposed system, and how will your experiments rule it out?

26. Which result would cause you to reject your own primary hypothesis?

27. What part of the research could remain publishable if the proposed mechanism fails to improve economic performance?

28. Can you identify one result in your Literature Survey that contradicts your preferred research direction?

29. What would prevent another researcher from reproducing your result, even after you release the source code?

30. Which single assumption in your methodology is most dangerous, and how will you test it?

## Part G: Final viva readiness checklist

The student should not simply rehearse hundreds of questions sequentially. Use the question bank to test five specific capabilities.

**Defence capability assessment**

- [ ] Explain the problem, research gap and main contribution clearly without slides.

- [ ] Distinguish the proposed mechanism from the strongest existing algorithms.

- [ ] Write and explain the weighting function, all variables, constraints and confidence mapping.

- [ ] Defend the four-agent architecture and the common decision/output semantics.

- [ ] Demonstrate the claimed requirements, datasets, risks and research evidence.

- [ ] Explain and defend the complete training, validation and testing protocol.

- [ ] Justify the statistical success criterion, baselines, ablations and negative-result interpretation.

- [ ] Defend ethics, licensing, security, scope and implementation feasibility.

- [ ] Identify limitations honestly and propose technically justified fallbacks.

- [ ] Answer unfamiliar examiner questions independently using evidence and reasoning.

Reset

### My recommendation for the student's preparation

- [ ] The student has made substantial progress in research conceptualisation. The greatest danger during the viva is now not a lack of literature or a lack of technical ambition. It is the possibility of being unable to justify some of the assumptions, equations, dataset figures and evaluation choices stated confidently in the presentation.

I would require the student to conduct three rounds of viva preparation:

- [ ] Round 1, Research defence: Focus on the 25 critical questions, novelty, the closest prior work, research questions and the Body of Knowledge contribution.

- [ ] Round 2, Technical defence: Focus on the agent architecture, common output contract, confidence calibration, weighting function, dataset construction, statistical methodology and fair comparisons.

- [ ] Round 3, Software Engineering and assessment defence: Focus on the 43 requirements, architecture traceability, development process, testing, full project schedule, risk register, Ethics Declaration, academic integrity and all 22 slides.

During every mock viva, ask follow-up questions such as “Why?”, “What evidence supports that?”, “What alternative did you reject?”, “How will you test it?” and “What happens if your assumption is wrong?”

- [ ] A student targeting 100/100 must demonstrate independent intellectual ownership, defensible methodological choices, rigorous Software Engineering, and the ability to discuss both strengths and limitations under critical examination.

- [ ] The submission deadline remains 5 November 2026. As previously instructed, further implementation should remain set aside until after submission; this question bank is for preparing the academic and technical defence of the proposal, not for adding new development work.