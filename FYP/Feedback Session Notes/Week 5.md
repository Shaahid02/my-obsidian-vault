---
date: 2026-10-19
type: panel-feedback-notes
week: 5
room: Room 2
project: FYP — Multi-Agent Financial Decision Systems for the CSE
panel: [Sanjula Samarasekara]
tags: [fyp, panel-feedback, week-5, datasets, poc, defence, scope]
status: synthesised
---

# Panel Feedback — Week 5

| | |
|---|---|
| **Panel member** | Mr Sanjula Samarasekara (Room 2) |
| **Date and time** | 19 October 2026, 20:20 |
| **Present** | Sanjula Samarasekara, Shaahid Fathul |

**Focus:** the dataset window, starting the PoC, the provenance of the weighting equation, and preparing a defence for news-driven market movement given that sentiment is out of scope.

**Transcript:** [[Week 5 transcript]]
*Previous panel session:* [[Week 4]]
*Same panel member as:* [[Week 3]]
*Nearest supervisor meeting:* [[29-09-2026]]

> **Second session with the same panel member.** Unlike Weeks 3 and 4, this one is continuous with an earlier session. He remembered the project and did not revisit the Week 3 technical-contribution challenge.

> **Transcription caveat.** Uncorrected Otter.ai auto transcript. "PPA" is the PPRS; "FIGA" is FIGARCH; "waiting" is weighting; "your Excellency" appears where the examiners are meant; "Intercedeon" at 2:01 is unintelligible; the supervisor's name at 9:30 is mis-transcribed. Quotes are reproduced as transcribed.

---

## 0. Items Raised, Carried In From Week 4

| # | Item | Outcome |
|--:|---|---|
| 1 | Where the PoC data window should start | **Answered**, see §2.1. Note that it was answered by a different panel member from the one who deferred it. |
| 2 | Whether grouping volatility and liquidity into one PoC agent conflicts with defining them separately | **Not raised.** Carry to Week 6. |
| 3 | Whether next-day direction is adequate as the PoC instrument | **Not raised.** Carry to Week 6. |
| 4 | Whether the mechanism with its ablation satisfies the technical-contribution requirement | **Raised, not answered**, see §2.3. |

---

## 1. Outcome in Brief

- **Start the PoC now.** Stated as the next step, with the literature work treated as sufficient to support it.
- **The dataset window was given directly:** 2010 to 2026, with data to Q2 2026 accepted as an adequate end point. This answers the question left open in [[Week 4]], though it sits at a different scale from the PoC sizing given there. See §3.
- **The substantive challenge is about defence, not scope.** He asked how the system accounts for news-driven movement when it has no sentiment component, and was explicit that he was not asking for sentiment to be reintroduced or for a dataset to be built.
- **A provenance question was put to me** about whether the weighting equation came from an AI tool.
- **My question about the adaptive weighting design was not answered.** The reply went to an unrelated example and did not return.
- He described the idea as feasible, which is a softening relative to [[Week 3]], where the challenge was whether it carried a technical contribution.
- Administrative: group resolved as group four, roughly row 30 on the sheet.

### Directives and positions taken

| # | Point | Raised by | Status |
|--:|---|---|---|
| 1 | Start the PoC now, before the PPRS submission | Sanjula | Directive |
| 2 | Dataset from 2010 to 2026, Q2 2026 acceptable as the end | Sanjula | Directive, not yet confirmed with supervisor, scale differs from [[Week 4]] |
| 3 | Prepare a defence for news-driven movement without a sentiment component | Sanjula | Directive, framed as preparation rather than redesign |
| 4 | Be able to account for the derivation of the weighting equation | Sanjula | Implied, from the question asked |
| 5 | Do not change the idea, do not build a new dataset | Sanjula | Explicit constraint on how 3 is to be satisfied |

---

## 2. Feedback Points

### 2.1 Dataset window

| | |
|---|---|
| **Said** | > "2010, and have the complete the complete completed dataset until 2026." |
| **My question** | Whether Q2 2026, which is as far as the data I have been given runs, is sufficient or whether I should go beyond it. |
| **Said** | > "No, immediately I'm going to do a somewhat prediction." · > "2026 is enough." |
| **Raised by** | Sanjula Samarasekara |
| **My reading** | This answers the start-point question I raised in [[Week 4]] §2.5 and did not get an answer to, and it resolves it in a direction I had not proposed. My own candidates were an end at 2026 Q3 and a start at the S&P standardisation of roughly June 2024. A 2010 start is far longer than that and far longer than the two to five years given for the PoC in [[Week 4]]. I read the two as answering different questions, full study scope here against PoC sizing there, but that reading is mine and neither panel member said it. The length also has a bearing on the coverage test I adopted in [[Week 4]], since a 2010 to 2026 window certainly contains both normal and low-liquidity conditions and additionally spans the 2022 crisis period and COVID. |
| **Action** | Record 2010 to 2026 Q2 as the candidate full-study window and take it to the supervisor alongside the [[Week 4]] PoC sizing, rather than treating either as settled. Check how far back the data I can actually obtain runs, given the gaps already found around 2012. |
| **Status** | Open, needs supervisor confirmation |

### 2.2 Start the PoC

| | |
|---|---|
| **Said** | > "it's better to start the POC now [...] since you have done the literature review properly and you have went through the papers, not only gaps. Like you have proper idea about the market and everything now. So it's better to start the POC and see the feasibility of this idea." |
| **On feasibility** | > "this idea is in any way feasible, but like I guess for the even before the PPA [PPRS] submission, also like you can come up with a proper POC and like score some good marks." |
| **Raised by** | Sanjula Samarasekara |
| **My reading** | Consistent with [[20-09-2026]], where the supervisor approved the start of the PoC, and with the [[Week 4]] sequence. The feasibility remark is a change in register from [[Week 3]], where the same person questioned whether the work carried a technical contribution at all. I would not read it as that challenge being withdrawn, since it was not discussed in this session. |
| **Action** | None beyond what is already scheduled. The PoC is already the Week 5 and Week 6 priority. |
| **Status** | Consistent with existing plan |

### 2.3 The adaptive weighting design, question not answered

| | |
|---|---|
| **My question** | > "Just a small question on the way adaptive waiting [weighting] part. So this is the thing that I plan on going through. Do you think there's anything I need to change around here?" |
| **What followed** | An unintelligible word at 2:01, then an account of a system he had worked on: > "we provide the software solution to them, not like not like this prediction detection or like what they do what they should do with their like stocks and all buy and selling like we didn't handle that part. We just gave the platform to like buy the stocks and sell it." |
| **Raised by** | Shaahid Fathul |
| **My reading** | The reply does not address the mechanism. He appears to be setting out the limits of his own prior exposure to this kind of system rather than evaluating the design, and the conversation then moved to the news question without returning. I am recording this as unanswered rather than as tacit approval, because reading silence as endorsement is exactly the kind of inference that will not survive a viva. |
| **Action** | Re-ask in Week 6, with the mechanism and its ablation shown explicitly rather than as a diagram to react to. |
| **Status** | Unanswered, carried to [[Week 6]] |

### 2.4 Provenance of the weighting equation

| | |
|---|---|
| **Said** | > "So I don't know like so any you also derive this equation from AI, you know." |
| **My answer in session** | That it came from the papers I read as well, including work on the Colombo Stock Exchange using FIGARCH, and that the derivation drew on those. |
| **Raised by** | Sanjula Samarasekara |
| **My reading** | The question was put in passing and not pressed, but it is the kind of question that is easier to answer with a document than in the moment. I should be able to show the path from specific reviewed papers to the formalisation, naming which paper supports which term. The volatility and persistence terms have the clearest support in the corpus, through the CSE volatility memory and ARMA-GARCH work. The confidence term has the thinnest paper trail of the four and is the one I am least able to source on demand. |
| **Action** | Write a short derivation note mapping each term of $w_{i,t} = f(L_t, V_t, P_t, C_{i,t})$ to the reviewed papers that support it, and flag any term that rests on my own reasoning rather than on a source. |
| **Status** | Open |

### 2.5 News-driven movement, and defending the exclusion

This is the substantive point of the session.

| | |
|---|---|
| **Said** | > "So don't you think the public news and all are affecting on this volatility and liquidity and everything?" |
| **My answer in session** | That they do, that a sentiment agent was originally part of the design, and that it was dropped because building the dataset would have been a separate undertaking. |
| **Said** | > "after going through my mentees' paper also like what I understood is okay. These news are actually running a major role in the stock market in Sri Lanka, right? So if your Excellency [the examiners] will ask any question related to that, like I think you should have solid answer rather than telling like [...] you're unable to find any proper data set." |
| **The alternative he set out** | > "either you should be capable enough to tell that with these technical fundamental volatility and liquidity agents. You can predict or you can detect the thing that you want to do accurately, rather than like using news or something else". |
| **The worked example** | > "let's assume okay, we'll take an instance and see, like with Trump's tweet and all, like the oil market went crazy [...] and the stocks of those companies also went crazy [...] even though news hasn't used in your system, but that fluctuation of that stock of that oil company, like you should be capable enough to like okay detect it or predict it properly for that particular time". |
| **The examiner question he predicts** | > "you are getting a result like this, but the actual fluctuation is something like this. Can you explain it?" |
| **Explicit limits on what he is asking** | > "I'm not undermining your project. I'm telling like another aspect that examiners can go and ask." · > "you don't have to change the idea. You don't have to come up with a new data set and make this your project very complex. I'm asking you to be ready for that aspect also." |
| **Why he thinks it is worth marks** | > "if you can defend why you haven't used it properly, then [...] you can score marks because that is something that you know you are in scope and out scope properly." |
| **Raised by** | Sanjula Samarasekara |

**My reading.** This is not a request to reintroduce sentiment, and he said so twice in different words. It is a request for a defensible account of the exclusion, which is a different deliverable and one the project does not currently have in a form I could present.

I see two separable claims in what he said and they need different treatment. The first is that news materially affects the Sri Lankan market. He attributes this to his mentees' papers and did not cite them, so for my purposes it is an assertion made in session rather than evidence I can use, though the corpus does contain local work bearing on it. The second is that examiners are likely to ask about it. That is a prediction about the viva, not a claim about the market, and it does not need evidence to be worth acting on.

The defence I think is available, stated as my own reasoning rather than as something established: news reaches the system through its measured consequences. A news shock shows up as a change in volatility, in persistence and in liquidity, and those are precisely the quantities in the conditioning set. The system does not read the news and does not claim to anticipate it, but it is designed to respond to the market state the news produces, and the confidence and abstention terms exist for the case where agent inputs have gone stale relative to that state. The honest limit of this defence is that it is reactive rather than anticipatory, and I should say so rather than overclaim. The oil example he gave is a shock originating outside the market in question, which is the hardest case for this argument and therefore the one to prepare.

**Action.** Write a scope-exclusion defence covering: why sentiment was excluded, including the supervisor's attribution and ablation-validity reasoning from [[20-09-2026]] §6.1 and §6.3; what the system does instead; what it does not claim; and a worked response to the exogenous-shock case. Draw on [[Scope sentiment analysis dropped]], the retained sentiment papers held as background and as fixed-influence failure cases, and [[Role of Market Liquidity in Sentiment-Based Return Predictions, Evidence from Sri Lanka]] for the local evidence.
**Status.** Open, and the highest-value item from this session.

---

## 3. Interaction with Existing Direction

| Panel point | Existing position | Source | Conflict? | Resolution |
|---|---|---|---|---|
| Be ready to answer on news-driven movement | Sentiment analysis is out of scope, **Final** | Supervisor, 20 September 2026 | **No** | He explicitly ruled out changing the idea or building a dataset. This is a request for defence material, not for a component. The scope decision stands untouched. Recorded here because the standing checklist treats sentiment mentions as potential conflicts and this one is not. |
| Dataset 2010 to 2026 | PoC on 5 to 10 stocks over two to five years | [[Week 4]] §2.5 | **Partial** | Most likely different scales, full study against PoC, but neither panel member said so and the two were given by different people a week apart. Put both to the supervisor rather than choosing. |
| Start the PoC now | PoC approved to begin | [[20-09-2026]] §3 | No | Consistent, and reinforces the current priority. |
| The idea is feasible | Gap provisionally approved; novelty not frozen | [[29-09-2026]] §1 | No | A favourable remark in passing. It does not freeze anything and should not be quoted as approval. |
| Equation derived from AI? | The mechanism is the technical contribution | [[29-09-2026]] §3.1 | No | Not a challenge to the mechanism. It does mean the derivation needs a visible paper trail. |

**Standing items checked this session**

- Sentiment was raised, and the raising is **not** a conflict with the 20 September scope decision, for the reasons in §2.5. No change to scope.
- The agent set was described by me in session as four agents, technical, fundamental, volatility and liquidity, with sentiment as the dropped fifth. That matches the provisional set and was not challenged.
- The superseded fixed-weight wording did not come up.
- No absolute language was used by me in this session.
- The 18 October hard rule on new agents, datasets, gaps and technologies has now passed. Nothing in this session would breach it, since no new component was requested.

---

## 4. Carried Over from Week 4

| # | Item from [[Week 4]] | Status after this session |
|--:|---|---|
| 1 | Gap verification against the current formulation, not the fixed-weight wording | Not discussed. Still open. |
| 2 | Separate definitions and requirements for the volatility and liquidity agents | Not discussed. Still open. |
| 3 | PoC sequence reconciliation and prediction target | Not discussed. The instruction to start the PoC reinforces the urgency. |
| 4 | Data window start point | **Answered** in §2.1, by a different panel member, pending supervisor confirmation. |
| 5 | Technical-contribution framing to be put to the supervisor | Still open. Raised with the panel in §2.3 and not answered. |
| 6 | Group number unconfirmed | **Resolved.** Group four, roughly row 30 on the sheet. |

---

## 5. Outstanding Actions

| # | Action | Arising from | Links to | Done |
|--:|---|---|---|:---:|
| 1 | Write the scope-exclusion defence for news and sentiment, including the exogenous-shock case | §2.5 | [[Scope sentiment analysis dropped]], [[Contribution to Knowledge]] | ☐ |
| 2 | Write the derivation note mapping each term of the weighting function to its supporting papers, flagging unsourced terms | §2.4 | [[Contribution to Knowledge]], [[Research Gap]] | ☐ |
| 3 | Take the 2010 to 2026 Q2 window and the Week 4 PoC sizing to the supervisor together | §2.1, §3 | [[PoC Specification]] | ☐ |
| 4 | Check how far back obtainable CSE data actually runs, given the gaps found around 2012 | §2.1 | [[PoC Specification]] | ☐ |
| 5 | Re-ask the adaptive weighting design question in Week 6, mechanism and ablation shown explicitly | §2.3 | [[Week 6]] | ☐ |
| 6 | Carry forward the two Week 4 questions that were not raised | §0 | [[Week 6]] | ☐ |

---

## 6. Open Questions for the Next Session

- Does the adaptive weighting mechanism, shown with its ablation, need changing? Asked and not answered this session.
- Is 2010 to 2026 the full-study window with the Week 4 sizing applying to the PoC, or are the two in genuine conflict?
- Does grouping volatility and liquidity into one PoC agent conflict with the Week 4 instruction to define them separately?
- Is next-day direction adequate as the PoC instrument given that the thesis claim concerns decisions rather than forecasts?
