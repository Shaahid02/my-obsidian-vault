# Standing scope decision: sentiment analysis is out

**Taken in the supervisor meeting of 20 September 2026, status Final** ([[20-09-2026]] §6). Confirmed to Claude on 23 September 2026. **This overrides anything in the older project docs that assumes a sentiment component.** Apply it to every literature review, matrix revision and chapter draft from here on, without being asked again.

## The decision

Sentiment analysis is dropped from the core project. No Sinhala, Singlish or code-mixed corpus, no sentiment model, no sentiment agent, no polarity mapping, no conditional sentiment weighting hypothesis.

## Why, in the supervisor's terms

Two separate arguments, and the second is the one worth carrying into write-ups because it is positive rather than defensive.

**Risk.** Sentiment had become a second research problem sitting inside the first: primary data collection, manual annotation, annotator disagreement, ethics and platform access, language adaptation, code-mixed NLP, dataset validation. That could consume half the FYP and none of it directly proves the main contribution.

**Attribution.** With a technical model, a sentiment model, RAG, fundamental analysis, FIGARCH, a liquidity model, RL and an LLM manager all in one system, a 5% return improvement cannot be traced to any of them. A narrower architecture makes the contribution measurable. The supervisor's phrasing is worth quoting: _three or four well-defined agents are better research than six loosely justified agents_. The research question was never how many agents can be connected, it is how heterogeneous agent outputs should be coordinated under changing market conditions.

The supervisor's position is that everything carrying the novelty survives the cut: liquidity, volatility memory, adaptive orchestration, heterogeneous agent interaction, friction-aware evaluation.

## The architecture this leaves, which is provisional

**Only the scope cut is final.** Everything in this section and the next is a working proposal carried forward so there is something concrete to test papers against, and the remaining literature reviews are expected to change it. The meeting note says so itself: the main gap wording and the exact technical contribution are both _almost ready_ rather than settled, novelty is ready for PoC but not frozen for the thesis claim, and the literature stage is not closed.

As it currently stands, four agents, from the minimum implementation diagram of 21 September. There is no macro agent and no fifth channel.

$$\text{Market Data} \rightarrow {A_T\ \text{Technical},\ A_V\ \text{Volatility/Risk},\ A_L\ \text{Liquidity}}, \qquad \text{CSE Reports} \rightarrow A_F\ \text{Fundamental/RAG}$$

$${A_T, A_F, A_V, A_L} \rightarrow \text{Adaptive Orchestrator}, \qquad w_{i,t} = f(L_t, V_t, P_t, C_{i,t}), \qquad \text{Decision}_t = \sum_i w_{i,t} A_{i,t}$$

where $L_t$ is the liquidity state, $V_t$ volatility, $P_t$ persistence and $C_{i,t}$ agent $i$'s confidence, and the decision then goes to friction-aware evaluation. The heterogeneity claim rests on Technical $\neq$ Fundamental $\neq$ Risk $\neq$ Liquidity being genuinely different evidence, which is what separates the pool from MacroHFT's six identical DDQN sub-agents.

The conditioning set is the part most likely to move. Those four variables are a hypothesis about what agent weighting should respond to, not a result, and the whole point of reading further is to find out whether persistence earns its slot, whether confidence can be made comparable across four heterogeneous producers at all, and whether something absent from the list belongs in it. A review that bears on any of this should say so and propose the revision rather than writing around the current form.

## The evaluation design that comes with it

This is the reason the cut improves the research rather than only shrinking it, so it belongs in any review that touches orchestration. It is the most stable part of the current plan, since the three-way comparison holds whatever the agent set turns out to be, but the ablated inputs follow the conditioning set and move with it.

|Configuration|Weighting scheme|
|---|---|
|Baseline 1|Equal weight|
|Baseline 2|Static learned weight|
|Proposed|Dynamic state-aware weight|

Then each state input is ablated on its own: Adaptive $-$ Liquidity, Adaptive $-$ Volatility, Adaptive $-$ Persistence, Adaptive $-$ Confidence. Baseline 2, a static _learned_ weight, is the one that matters most and the one my earlier matrix wording was missing, because beating equal weighting proves very little if a fixed learned weight gets there too.

## What this removes from the gap matrix

|v3 component|Status|
|---|---|
|Former G3, Multilingual Sinhala Financial Sentiment|**Removed.** Not a contribution of any kind.|
|Former G5, Conditional Sentiment Weighting|**Removed as worded.** The underlying question, whether the orchestrator learns an agent's market-conditional value rather than assuming a fixed mapping, survives as $C_{i,t}$ inside the main gap and is no longer a sentiment claim.|
|Main gap, heterogeneity claim|**Re-worded** around the four agents above.|
|Former G4, structure-aware RAG|**Promoted** from demoted system feature to $A_F$, the framework's only text channel. Still not claimed as novel, and the 2025 CSE Graph-RAG prior art still stands.|
|Former G6, layered XAI|**Re-scoped.** LIME over sentiment tokens is out. Attribution is RAG citation tracing, SHAP over risk features, interpretable FIGARCH and GJR-GARCH parameters, and the orchestrator's weight vector.|
|Former G7, evaluation protocol|**Trimmed.** Macro-F1 with per-class breakdown was sentiment-model instrumentation. The RAG correct / incorrect / failure-to-answer taxonomy stays and now carries more of the component-level evidence.|

## The removal checklist, and where it stands

The supervisor was explicit that removing one box from a diagram is not sufficient, and gave twelve locations ([[20-09-2026]] §6.4). Current status:

|#|Location|Status|
|---|---|---|
|1|Research problem|Not started|
|2|Research gap|**Done** in matrix v4|
|3|Research questions|Not started, and the RQs are unwritten anyway|
|4|Objectives|Not started, unwritten anyway|
|5|Architecture|**Done**, four-agent diagram of 21 Sep|
|6|Dataset matrix|Not started, still lists sentiment sources|
|7|Agent definitions|**Done** in matrix v4|
|8|Experimental design|Partly, the supervisor's three weighting schemes need writing in|
|9|Ablation plan|Partly, the four state-input ablations need writing in|
|10|Novelty statement|**Done**, no sentiment language survives|
|11|Expected contribution|**Done** in matrix v4|
|12|Literature-review synthesis|Not started, and the synthesis is unwritten|

**Exception the supervisor granted:** sentiment papers stay in the Literature Survey Matrix, because they evidence that the area was investigated and then excluded from scope. So the Sinhala sentiment, Sri Lanka liquidity-sentiment and related notes are not deleted from the vault.

## Rules for every literature review from here

1. **Never propose a sentiment component in the last section.** A paper's sentiment result is reported in findings when the paper has one, and it converts into a decision about orchestration, evaluation or execution, not into a sentiment design.
2. **Sentiment ablations are still evidence for the main gap.** A paper showing a text or sentiment agent degrading a system with no mechanism to notice is a fixed-influence failure case and belongs alongside FinAgent and AlphaAgents. The reading changes, the citation does not. This is consistent with the supervisor's Literature Matrix exception.
3. **Cite the sentiment notes as background, never as a pipeline to build.** They stay in the vault and can be cited on market microstructure and on why the area was excluded.
4. **Say which of the four agents a paper speaks to**: $A_T$ technical, $A_F$ fundamental and retrieval, $A_V$ volatility and risk, $A_L$ liquidity, or the orchestrator itself, or the friction-aware evaluation layer. "Heterogeneous agents" on its own is no longer specific enough to be useful.
5. **Treat the agent set and the weighting function as open.** They are provisional, and refining them into a stronger and more viable gap is the job the remaining reviews are doing. A review that finds evidence for adding, dropping or redefining an agent, or for changing what the orchestrator conditions on, should state that as a proposed revision in its last section. Do not present the current four agents or the current conditioning set as settled in any write-up.
6. **Keep novelty language scoped.** The permitted form is a candidate technical contribution not identified in the reviewed literature, to be further validated against recent work. No nobody, never or first, and the claim is not frozen for the thesis yet.

## Two things to hold onto

**The blocker moved, it did not disappear.** Sentiment was the largest scope risk and is resolved. The critical outstanding item is now a sufficiently long, clean, legally usable individual-stock CSE historical dataset with date, ticker, OHLC, volume and turnover. Twelve to eighteen months of data makes the whole experimental design questionable, and the only confirmed ready-made set covers February 2025 to February 2026. Any review that bears on data depth or on minimum estimation windows should be read against that.

**My own reservation, which is not the supervisor's view.** The sentiment-language problem was one of three legs under the argument for the CSE specifically rather than any thin frontier market, and it is gone, leaving liquidity and microstructure. The supervisor's retained list addresses novelty and does not speak to this, so I am not contradicting them, but it is worth putting to them directly rather than discovering it in a viva.