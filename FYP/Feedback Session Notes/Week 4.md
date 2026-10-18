---
date: 2026-10-12
type: panel-feedback-notes
week: 4
room: Room 1
project: FYP — Multi-Agent Financial Decision Systems for the CSE
panel: [Salitha Perera]
tags: [fyp, panel-feedback, week-4, research-gap, poc, datasets, evaluation]
status: synthesised
---

# Panel Feedback — Week 4

| | |
|---|---|
| **Panel member** | Mr Salitha Perera (Room 1) |
| **Date and time** | 12 October 2026, 21:30 |
| **Present** | Salitha Perera, Shaahid Fathul |

**Focus:** what evidence is needed to confirm the gap, separating liquidity from volatility, the shape of the technical contribution, dataset feasibility, and a concrete PoC sequence.

**Transcript:** [[Week 4 transcript]]
*Previous panel session:* [[Week 3]]
*Nearest supervisor meeting:* [[29-09-2026]]

> **Transcription caveat.** The transcript is an uncorrected Otter.ai auto transcript. "CAC" is the CSE; "VOC", "BOC" and "MC" are the PoC; "hurdent" appears where "agent" is meant; "market recommend detection" appears where "market regime detection" is meant. Quotes are reproduced as transcribed.

---

## 1. Outcome in Brief

- **The direction was endorsed.** The strongest element is the market-state conditioning of agent influence, not the agent set itself.
- **The gap is accepted as a hypothesis but not as confirmed.** Confirming it requires a structured comparison of existing systems on specific axes, listed in §2.2.
- **Liquidity and volatility must be treated as separate constructs** with separately defined agents and separately identified requirements.
- **A concrete PoC sequence was given**, deliberately smaller than the full design: two agents, a small dataset, a fixed-weight baseline, then adaptive weighting, then compare the two on the same period.
- **Explicit instruction not to start by building four agents or the complete LLM framework.**
- Dataset feasibility is to be established before committing to the design.
- His technical-contribution view was offered as his own and referred back to the supervisor.

### Directives and positions taken

| # | Point | Raised by | Status |
|--:|---|---|---|
| 1 | Gap needs stronger evidence through structured comparison of existing systems | Salitha | Directive |
| 2 | Treat liquidity and volatility as distinct constructs, define each agent separately | Salitha | Directive |
| 3 | Technical contribution should be the adaptive weighting mechanism | Salitha | Opinion, explicitly referred to the supervisor |
| 4 | Do not start with four agents or the full LLM framework | Salitha | Directive |
| 5 | PoC on 5 to 10 stocks, small number of years, fixed-weight baseline first | Salitha | Directive, with an internal inconsistency on the span, see §2.5 |
| 6 | Establish dataset feasibility before committing to the design | Salitha | Directive |
| 7 | Prediction accuracy alone insufficient to claim improved investment decisions | Salitha | Directive |

---

## 2. Feedback Points

### 2.1 What he identified as the strongest element

| | |
|---|---|
| **Said** | > "The strongest part is not use of different agents itself, right? It is the proposed market condition [...] it determines actually how much each agent should influence, right? To the finance output." |
| **Raised by** | Salitha Perera |
| **My reading** | This is independent confirmation of the position reached with the supervisor on 29 September, that the mechanism rather than the agent count is the contribution. It also answers, from a different panel member, the concern raised in [[Week 3]] §2.2 about the project reading as integration. The difference between the two sessions appears to be what was put in front of each of them. |
| **Status** | Supportive, no action beyond keeping the mechanism foregrounded |

### 2.2 The gap needs stronger evidence

| | |
|---|---|
| **Said** | > "your gap is now fine [...] you are currently claims that the existing multi-agent frameworks use fixed weight, while the proposed system will dynamically adjust the importance of each agent for the CAC. [...] The hypothesis is promising. Right. But you haven't confirmed the research gap." |
| **Checks he listed** | > "existing multi-agent financial analysis systems. Genuinely use fixed values, or do they use adaptive weighting" · > "whether they are the confident-based aggregation can be there" · > "what kind of market recommend [regime] detection method they are using" · > "whether the existing studies have investigated adaptive financial prediction, or they are going with decision making" · > "does the CSE create specific challenges that existing methods do not address" · > "can the proposed method [...] demonstrably address those challenges". |
| **How to structure it** | > "your literature should compare existing systems by different like aggregation methods, market index [regime], right? And treatment of you know liquidity, different different things, and you can consider the evaluation results". |
| **Raised by** | Salitha Perera |
| **My reading** | The structure he describes is a comparison matrix with columns for aggregation method, regime detection, liquidity treatment and evaluation protocol. That is close to what the Consolidated Research Matrix already does, so the work is partly extending existing sheets rather than starting new ones. One qualification matters: the claim he quoted back to me, that existing frameworks use fixed weights, is the formulation the supervisor already told me to retire on 29 September in favour of the sharper observation that many systems have no explicit weighting quantity at all. See §3. |
| **Action** | Add or extend matrix columns for aggregation method, regime detection method, liquidity treatment and evaluation protocol, across the close systems already identified. |
| **Status** | Open |

### 2.3 Liquidity and volatility are not the same thing

| | |
|---|---|
| **Said** | > "you are talking about volatility and liquidity, no? [...] They are two different things. [...] when you are using these concepts, right? They should not be treated as same thing because they are two different things [...] you have to identify like what is the meaning of this volatility agent, and what is the liquidity agent [...] Separately, you have to identify the requirements of these two, right, and do the design accordingly." |
| **Raised by** | Salitha Perera |
| **My reading** | The design already separates $A_V$ from $A_L$ and separates $V_t$, $P_t$ and $L_t$ in the conditioning set, so the distinction exists in the design. What he is pointing at is how they are described, where volatility and liquidity do at times appear in the same breath as a single frontier-market condition. This connects to the Week 3 point about statements rather than structure. It is also an argument for keeping the $V_t$ and $P_t$ separation explicit, since persistence is a third thing again. |
| **Action** | Write separate definitions and separate requirement statements for the volatility agent and the liquidity agent, and check that no document treats them as one condition. |
| **Status** | Open |

### 2.4 Technical contribution

| | |
|---|---|
| **Said, with his own hedge** | > "your main technical contribution should be like this is my thought right but you can ask from sir also, right? Like if you can investigate the liquidity And the market regime, we are adaptive weighting mechanism, right? It will be a good technical contribution for you instead of always giving four agent equal influence". |
| **What is not enough** | > "when we are simply adding two agents, is not a strong technical contribution itself." · > "Don't try to simply, you know, adding two agents together because it won't make a strong contribution". |
| **Three candidate forms he gave** | > "that adaptive weighting method that estimate the useful [usefulness] of each hurdent [agent] under different liquidity and volatility" · > "whether the market regime aware methods Changes how agent outputs are combined, and you know trading conditions change" · > "whether the reliability aware mechanism that reduce the influence of agents right when their input data as they are stale or unrealable". |
| **Feasibility caveat** | > "maybe because of the data set data set feasibilities, it can be changed. But before you [...] committing into the design, right? First of all, do a good investigation and see whether you are having a good feasible data set." |
| **Raised by** | Salitha Perera |
| **My reading** | All three forms are already inside $w_{i,t} = f(L_t, V_t, P_t, C_{i,t})$: the first is the liquidity and volatility conditioning, the second is regime awareness, the third is the confidence and staleness term. He arrived at them independently and marked them as his own view rather than a requirement, which makes them supporting evidence that the mechanism is the right place to put the contribution. The third form also matches what the Week 3 panel member suggested, from a different starting point. |
| **Action** | Record this convergence where the contribution is argued. Put the question of whether this framing is sufficient to the supervisor, as he suggested. |
| **Status** | Open |

### 2.5 Dataset scope and quality

| | |
|---|---|
| **Said, on scale** | > "for the initial POC level, right? You can take five to 10 companies listed on Columbus Stock Exchange, right? And take three to five years historical daily data if they are available and reliable". |
| **Said, later in the same session** | > "Start with the five five to 10 stocks for two to three years of daily data to test the feasibility". |
| **Said, on quality** | > "the data quality also you have to check. [...] You have to check the missing values, man [non] trading days". |
| **Said, on coverage** | > "the data must be sufficient to test both the approaches. I mean, normal and low [liquidity] market conditions." · > "after that thing if it is successful you can expand the data set if necessary". |
| **Raised by** | Salitha Perera |
| **My reading** | The span he gave is inconsistent within the session, three to five years in one place and two to three in another, so I am treating the instruction as a small number of years rather than a fixed figure, and the binding constraint as the coverage requirement: the window must contain both normal and low-liquidity conditions. That coverage test is more useful than either number, because it is the one that determines whether the adaptive mechanism can be distinguished from the baseline at all. |
| **What I raised** | Gaps in the official CSE website downloads, a day or two missing in some years and roughly a month missing around 2012; an email to the CSE which reports a separate Google Drive of Excel sheets, access pending; and the question of where to set the start and end of the window. I floated ending at 2026 Q3 and starting at the S&P standardisation around June 2024. |
| **What he answered** | He did not answer the start-point question directly. He redirected to PoC scale, 5 to 10 stocks over a small number of years, with quality checks. |
| **Action** | Choose the PoC window by the coverage test rather than by a fixed start date, and document the choice. Continue pursuing CSE Google Drive access. |
| **Status** | Open, start-point question still unanswered |

### 2.6 The PoC sequence he prescribed

Given as an explicit next-step sequence, deliberately smaller than the full design.

| # | Step | As stated |
|--:|---|---|
| 1 | Collect a small dataset | 5 to 10 CSE stocks, small number of years of daily data, quality checked |
| 2 | Build two simple agents | > "Technical agent and you know volatility and liquidity agent separately, right? You can add the fundamental agents later" |
| 3 | Define the prediction target | > "whether the next trading days closing price will increase or decrease, then compared with the previous days [...] But clearly define how unchanged prices are handled" |
| 4 | Fixed-weight baseline | > "you can combine the agent outputs using you know equal weights, right? Then you can record the prediction accu[racy] [...] It will be the baseline" |
| 5 | Implement adaptive weighting | Same agents, state-dependent weights |
| 6 | Compare on the same period | > "compare the [...] fixed weight approach and the adaptive weight approaches on the same historical period [...] whether that adaptive weighting improves the prediction performance, especially you know during the periods of low trading activities" |

**What the PoC must demonstrate**, as he put it:

> "whether the individual agents can generate predictions" · "whether the system can combine their outputs using fixed and adaptive weights" · "whether the two approaches can be compared using fair evaluation method".

**Explicit constraint:**

> "for initial implementation, do not start by building four agents or the complete LLM framework. First, test whether adaptive weighting provides measurable value over a simple baseline approach."

**My reading.** The sequence is compatible with the existing PoC specification and mostly reorders it: the baseline-versus-proposed comparison is already the core experiment, and equal weight is already Baseline 1 in the supervisor's ablation table. Two differences are worth noting. He groups volatility and liquidity into one agent at step 2 while also insisting in §2.3 that the two constructs are distinct, which I read as sequencing for the PoC rather than a design statement. And his prediction target, next-day direction, is a narrower target than the orchestration mechanism ultimately needs, so it is a PoC instrument rather than the thesis evaluation.

**Action.** Reconcile the PoC specification against this sequence and record where it differs and why.
**Status.** Open

### 2.7 Evaluation claim limits

| | |
|---|---|
| **Said** | > "if you are like it, if you intend to claim improved invest[ment] [...] decisions or prediction accuracy alone will not be sufficient." |
| **Raised by** | Salitha Perera |
| **My reading** | Consistent with the friction-aware evaluation already in the design. If the claim is about decisions rather than forecasts, the evaluation has to carry transaction costs and execution friction, not accuracy alone. This is a constraint on what the PoC results can be said to show, and it should be written into the evaluation protocol before results exist rather than after. |
| **Action** | State in the evaluation protocol which claims accuracy supports and which require friction-aware metrics. |
| **Status** | Open |

---

## 3. Interaction with Existing Direction

| Panel point | Existing position | Source | Conflict? | Resolution |
|---|---|---|---|---|
| "existing multi-agent frameworks use fixed weight", quoted back as my claim, to be verified | The supervisor directed moving away from "existing systems use fixed weights" to the sharper claim that many have **no explicit weighting quantity at all** | [[29-09-2026]] §3.1 | **Partial** | The verification he asks for is worth doing, but the claim to verify is the superseded wording. Run the check against the current formulation, and note that the fixed-weight phrasing is no longer the position. Confirm with the supervisor before presenting it back to the panel. |
| Build two agents first, volatility and liquidity grouped | Four provisional agents, $A_T$, $A_F$, $A_V$, $A_L$, with $V_t$, $P_t$, $L_t$ separate in the conditioning set | Project definition; [[29-09-2026]] | **Partial** | Read as PoC sequencing, not as a design change. The agent set is provisional in any case. Flag the tension with §2.3 at the next supervisor meeting rather than resolving it silently. |
| Technical contribution is the adaptive weighting mechanism | The mechanism $w_{i,t} = f(L_t, V_t, P_t, C_{i,t})$ is the contribution | [[29-09-2026]] §3.1, [[20-09-2026]] §5 | No | Independent agreement, offered as opinion and referred to the supervisor. |
| Reliability-aware reduction of agent influence on stale data | $C_{i,t}$ and the abstention mechanism | Conditioning Set; [[29-09-2026]] §3.1 | No | Second independent convergence, the first being [[Week 3]] §2.3. |
| Prediction accuracy alone insufficient | Friction-aware evaluation retained as part of the contribution | [[20-09-2026]] §6.1 | No | Consistent, strengthens the existing position. |
| Establish dataset feasibility before design | Historical CSE data is the critical outstanding blocker | [[20-09-2026]] §9 | No | Consistent. Still the blocker. |

**Standing items checked this session**

- Sentiment analysis was not raised. No conflict with the 20 September scope decision (supervisor, **Final**).
- The agent set was discussed as changeable, which is consistent with its provisional status.
- No absolute novelty language was used by me in this session. The panel member's own phrasing is quoted as spoken and is not adopted as my wording.

---

## 4. Carried Over from Week 3

| # | Item from [[Week 3]] | Status after this session |
|--:|---|---|
| 1 | Technical contribution must be distinct from the research contribution | Addressed from the other direction. This session identified the adaptive weighting mechanism as the contribution, which is the answer to the Week 3 challenge. Both panel members now point at the mechanism. Not yet confirmed with the supervisor. |
| 2 | Support market-condition claims with recent published sources | Reinforced and sharpened. This session specifies the form the evidence should take, a structured comparison of existing systems rather than citation alone. |
| 3 | Confidence threshold and reliability gate | Independently proposed again as a reliability-aware mechanism. Two panel members, two routes, same component. |
| 4 | Resolve group number and student ID | ID taken by the panel member at the end of this session. Group number still unconfirmed. |

---

## 5. Outstanding Actions

| # | Action | Arising from | Links to | Done |
|--:|---|---|---|:---:|
| 1 | Extend the comparison matrix with aggregation method, regime detection, liquidity treatment and evaluation protocol columns | §2.2 | [[Research Matrices Status]], Consolidated Research Matrix | ☐ |
| 2 | Run the gap verification against the current formulation, not the superseded fixed-weight wording, and confirm with the supervisor | §2.2, §3 | [[Research Gap]] | ☐ |
| 3 | Write separate definitions and requirement statements for the volatility agent and the liquidity agent | §2.3 | [[PoC Specification]] | ☐ |
| 4 | Reconcile the PoC specification with the prescribed sequence and record the differences | §2.6 | [[PoC Specification]] | ☐ |
| 5 | Define the PoC prediction target including the handling of unchanged prices | §2.6 | [[PoC Specification]] | ☐ |
| 6 | Select the PoC window by the normal and low-liquidity coverage test, and document the choice | §2.5 | [[PoC Specification]] | ☐ |
| 7 | Pursue CSE Google Drive access and audit the resulting files for missing days and non-trading days | §2.5 | [[Research Gap]] | ☐ |
| 8 | State in the evaluation protocol which claims accuracy supports and which need friction-aware metrics | §2.7 | [[PoC Specification]] | ☐ |
| 9 | Put the technical-contribution framing to the supervisor, as he suggested | §2.4 | Next supervisor meeting | ☐ |
| 10 | Confirm group number | §4 | Administrative | ☐ |

---

## 6. Open Questions for the Next Session

- Where should the PoC data window start, given that the official CSE downloads have gaps and the S&P standardisation date of roughly June 2024 would leave a short series? The question was raised and not answered.
- Does the two-agent PoC sequence, with volatility and liquidity grouped, conflict with the instruction to define them separately, or is the grouping only for the first build?
- Is the next-day direction target adequate as the PoC instrument, given that the thesis claim concerns decisions rather than forecasts?
