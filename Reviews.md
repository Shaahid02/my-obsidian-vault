# Academic Peer Review & Verification Report

**Review Target:** `The_Relationship_between_Macroeconomic_Variables,_Trading_Vo.md`  
**Original Reference Document:** Dissanayake et al. (2026), _The Relationship between Macroeconomic Variables, Trading Volume and Stock Returns: Granger Causality Evidence from the Colombo Stock Exchange_, _Journal of Business and Technology_, Vol. 10 No. 1, pp. 120–135.

---

### 1. Factual Inaccuracies, Misinterpretations, & Incorrect Data Points

- **Bivariate vs. System VAR Parameter Count Expansion (`Model and estimation`):**
    - **Review Statement:** States that _"in a five-variable system each extra lag adds 25 parameters, which is why SC and AIC land three lags apart"_.
    - **Paper Context & Correction:** Dissanayake et al. execute **pairwise (bivariate)** Granger causality regressions between the All Share Price Index (ASPI) and each individual variable (Exchange Rate, Money Supply, NCPI, Trading Volume) rather than estimating a single 5-variable Vector Autoregression (VAR). In a 2-variable system, each additional lag adds **4 parameters** (2 parameters per equation), not 25. Correcting this parameter expansion math will ensure the lag-penalty critique remains accurate.
- **Dual Citation of Robust Standard Errors (`Model and estimation`):**
    - **Review Statement:** Attributes the application of robust standard errors solely to Stock and Watson (2015).
    - **Paper Source:** While Section "Data Validation" (page 130) cites Stock and Watson (2015), Section "Descriptive Statistics" (page 128) additionally cites Patra and Poshakwale (2006) for using robust standard errors to handle heteroscedasticity in financial time series.

---

### 2. Major Conclusions & Limitations Failed to Include

- **Challenge to Arbitrage Pricing Theory (APT) vs. Support for MDH:**
    - **Omission:** The review highlights the Mixture-of-Distributions Hypothesis (MDH; Clark, 1973), but omits the authors' explicit theoretical critique of macro-finance models.
    - **Paper Grounding:** In Section "Theoretical Implications" (page 132), Dissanayake et al. emphasize that the absence of causal transmission from money supply and inflation **directly challenges Arbitrage Pricing Theory (APT)**, which assumes systematic macroeconomic risk factors are priced in equilibrium. The authors conclude that in volatile emerging/frontier markets, market microstructure variables supersede broad macroeconomic fundamentals.
- **Three-Pillar Practical & Policy Implications:**
    - **Omission:** The review focuses on how these findings justify conditioning an algorithmic trading orchestrator on microstructure state, but omits the paper's explicit practical recommendations for three core stakeholder groups (page 132):
        1. **Regulators & Central Banks:** Incorporate trading volume into real-time market monitoring frameworks to detect early volatility shocks, and monitor ASPI movements to anticipate exchange rate pressures.
        2. **Investors & Portfolio Managers:** Pivot short-term asset allocation and currency risk management toward real-time trading volume trends and equity index signals rather than lagging macro prints.
        3. **Corporate Issuers:** Focus on active corporate communications and market liquidity, as investor sentiment and market activity impact share valuations more directly than broader macroeconomic trends.
- **Author-Stated Future Research Agenda:**
    - **Omission:** While the review notes the need for VECM and Johansen cointegration under limitations, it omits two additional future research avenues explicitly outlined by the authors (page 132):
        1. **Broader Macroeconomic Feature Sets:** Incorporating interest rates (e.g., AWPR/AWDR) and real GDP growth.
        2. **Cross-Country Comparative Studies:** Running identical Granger causality frameworks across other South Asian frontier markets facing severe external debt and currency crises (e.g., Pakistan and Bangladesh).

---

### 3. Claims in the Review NOT Explicitly Supported by the Paper

- **Conjecture on EViews ADF Specification:**
    - **Review Claim:** In `Limitations` (Bullet 1), the review asserts that the anomalous ADF statistic (\(-5.0724\), \(p = 0.0000\)) for log ASPI level was likely caused by choosing a _"trend plus intercept against intercept only"_ specification in EViews.
    - **Paper Grounding:** While this is a plausible econometric explanation for obtaining stationarity on a level equity index, Dissanayake et al. **do not state** which deterministic terms (none, intercept, or trend and intercept) or lag selection criteria were specified during their unit root testing. Presenting this specific EViews configuration as a confirmed fact rather than an inferred hypothesis goes beyond the paper's text.
- **Project-Specific Architectural Extrapolations (`Why this matters for my project`):**
    - The review outlines plans to substitute monthly volume into a daily liquidity state variable (\(L_t\)), pair it with ARDL \(R^2\) values, use volume as a validation partner for LLM sentiment agents, and build a multi-crisis out-of-sample evaluation matrix. These are custom research design commitments. Ensure these remain clearly demarcated as personal project extensions rather than empirical findings or recommendations established by Dissanayake et al. (2026).

---

### 4. Specific Section-by-Section Editing Guidance

1. **`Model and estimation` (Lag Selection Paragraph):**
    - **Edit:** Adjust the parameter penalty sentence: _"In a pairwise (bivariate) Granger causality framework, each additional lag adds 4 parameters across the two equations, making the Schwarz Criterion (SC) penalize higher lags significantly faster than AIC on a 105-observation sample."_
2. **`Findings` / Theoretical Implications:**
    - **Edit:** Add a bullet explicitly referencing the **Arbitrage Pricing Theory (APT)** challenge: _"The failure of money supply and inflation to Granger-cause stock returns challenges traditional Arbitrage Pricing Theory (APT) models, suggesting that in post-crisis frontier markets, prices are driven by immediate microstructure signals rather than macro equilibrium factors."_
3. **`Findings` / Practical Implications:**
    - **Edit:** Add a summary paragraph outlining the paper's practical recommendations for **regulators** (using volume for volatility oversight), **portfolio managers** (relying on market activity over macro indicators), and **corporate issuers** (focusing on liquidity and investor relations).
4. **`Limitations`:**
    - **Edit:** Incorporate the authors' proposed future research extensions from page 132: testing interest rate/GDP variables and expanding the framework to comparative frontier markets like Pakistan and Bangladesh.

---

💡 **Next Steps:** Would you like me to generate an updated, fully verified Markdown file incorporating these edits or assist with verifying any other paper in your literature review?