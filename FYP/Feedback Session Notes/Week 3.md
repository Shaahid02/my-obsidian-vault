---
date: 2026-10-05
type: panel-feedback-notes
week: 3
room: Room 2
project: FYP — Multi-Agent Financial Decision Systems for the CSE
panel: [Sanjula Samarasekara]
tags: [fyp, panel-feedback, week-3, technical-contribution, novelty, evidence]
status: synthesised
---

# Panel Feedback — Week 3

| | |
|---|---|
| **Panel member** | Mr Sanjula Samarasekara (Room 2) |
| **Date and time** | 5 October 2026, 19:30 |
| **Present** | Sanjula Samarasekara, Shaahid Fathul |

**Focus:** the evidential standard for stated claims, the market scope, and whether the project carries a technical contribution distinct from its research contribution.

**Transcript:** [[Week 3 transcript]]
*Nearest supervisor meeting:* [[29-09-2026]]
*Next panel session:* [[Week 4]]

> **Transcription caveat.** The transcript is an uncorrected Otter.ai auto transcript. "CAC", "CSC" and "CESC" are the CSE; "FIP" and "FIB" are the FYP; "PD" is PT (part time). Quotes below are reproduced as transcribed, including those errors.

---

## 1. Outcome in Brief

- **The research gap was not challenged.** The challenge was to the supporting statements around it, and to the technical contribution.
- **The central issue is technical contribution as distinct from research contribution.** In his view, adapting an existing agentic solution to CSE conditions reads as integration rather than as a contribution to computer science, and he indicated he would mark it that way.
- **Every claim about market conditions needs a recent published source behind it.** Assertion from observation is not acceptable to examiners.
- One concrete mechanism was suggested, a confidence threshold with a reliability gate, offered explicitly as a small integration rather than a large contribution.
- **Nothing was decided.** All points are advisory and none has yet been put to the supervisor.
- Administrative item left unresolved: the student ID and group could not be found on his sheet and the call ended mid-lookup.

### Directives and positions taken

| # | Point | Raised by | Status |
|--:|---|---|---|
| 1 | Support every market-condition claim with a recent paper or book | Sanjula | Directive, accepted in session |
| 2 | Establish a technical contribution separate from the research contribution | Sanjula | Directive, accepted in session, not yet taken to supervisor |
| 3 | Confidence threshold and reliability gate as a possible contribution element | Sanjula | Suggestion, offered as optional |
| 4 | Present a proper pipeline, not "LLM based agentic AI" as a description | Sanjula | Directive |
| 5 | Resolve group number and student ID against the panel sheet | Sanjula | Administrative, open |

---

## 2. Feedback Points

### 2.1 Evidence for stated claims

| | |
|---|---|
| **Said** | > "Just because we are seeing an issue in a particular domain, we cannot tell that is the issue. [...] We need evidence. [...] Examiners won't accept your like statements or anything. [...] if you are claiming something, you have to show either book or a published paper [...] you have to claim it with the recent research paper, recent recently published book". |
| **Scope** | > "I'm not worrying about your gap. I'm I'm worrying about the statements that you are like that it all time to time". |
| **Raised by** | Sanjula Samarasekara |
| **My reading** | This is the same standard the project already imposes on itself, applied to the connective statements around the gap rather than to the gap. The exposure is in the sentences that characterise CSE conditions, where I have at times asserted from observation instead of citing. It is consistent with the no-absolutes rule and with keeping a paper's claim, its evidence and my reading separate. |
| **Response in session** | I stated that the volatility claims are supported by papers I have read and can be cited. That is true for volatility persistence. It does not cover every market-condition statement in the working documents. |
| **Action** | Sweep [[Research Gap]] and [[Contribution to Knowledge]] for unsourced characterisations of CSE conditions, and attach a reviewed source to each or restate it as bounded and first person. |
| **Status** | Open |

### 2.2 Technical contribution, distinct from research contribution

| | |
|---|---|
| **Said** | > "I can see a research gap [...] What is the novelty in your research? [...] you can bring a solution to the research gap that you have identified in the problem domain. But to the technical domain, what is the novelty that you are going to bring? That is another question." |
| **On the current framing** | > "changing the agentic AI solution according to the CSC details okay I know it is. It is a contribution, but [...] according my point of view, like I don't take it as a like very big contribution. [...] If I will be the marker, like okay, I'll give marks for the research, but not for the contribution that you have done to the computer science." |
| **The analogy given** | > "IIT has the HR system, and IIT has the ticketing system and the leave system [...] just because we are merging things, just because we are using existing things, won't you like a good contribution? It's just we are using the same thing according to our requirement." |
| **What he asked for** | > "don't tell just you are going to use LLM based agentic AI. Like, you have to come up with a proper pipeline that will that way you can show to the examiners [...] that there is something that we can consider as a technical [contribution]". |
| **Raised by** | Sanjula Samarasekara |
| **My reading** | He was reacting to the project described as an architecture, which is how it reads if the orchestration mechanism is not foregrounded. The mechanism $w_{i,t} = f(L_t, V_t, P_t, C_{i,t})$ is the answer to this question, and the supervisor reached the same conclusion on 29 September, that the move from an application architecture to a testable mechanism is what makes it a technical contribution. He did not appear to have that mechanism in front of him during this session. I read this as a presentation failure on my side more than a disagreement about substance, though it also means the mechanism has to be stated as a mechanism, with inputs, outputs and an ablation, in every artefact where the project is described. |
| **Explicitly not asked for** | > "I'm not asking you to change the idea". |
| **Action** | Lead with the mechanism and its ablation in the next panel session and in the PPRS handout, not with the agent set. Check that [[Contribution to Knowledge]] states the contribution in computer science terms and not only in finance-domain terms. |
| **Status** | Open |

### 2.3 Confidence threshold and reliability gate

| | |
|---|---|
| **Said** | > "you have stated something like there is an issue that if the models can't give the correct predictions, still they are giving something that is a main issue. [...] in that case, you can just use the confidence level or threshold, and use a reliable gate, reliability gate, and just tell that if the answer is not coming with the proper threshold or proper confidence, you can just say okay, I I'll still give the answer, but with this confidence level. [...] make sure to like take some expertise knowledge from someone else or something else". |
| **His own weighting of it** | > "That is a just like small integration part. You don't have to do a like like a huge contribution to that." |
| **Raised by** | Sanjula Samarasekara |
| **My reading** | This converges with the agent-confidence term $C_{i,t}$ and the abstention mechanism already defined in the Conditioning Set, so it is not a new component so much as independent support for one that is already in the design. He offered it as a modest addition, which is a weaker claim than treating confidence gating as the contribution. Worth noting that the Week 4 panel member independently proposed a reliability-aware mechanism as well (§2.4 of [[Week 4]]). |
| **Action** | Note the convergence in the Conditioning Set row for $C_{i,t}$. Do not promote confidence gating to the headline contribution on the strength of a suggestion offered as small. |
| **Status** | Open |

### 2.4 Market scope

| | |
|---|---|
| **Said** | > "if you're going to do this project, will they be only able to give stock predictions or whatever the predictions only for the CAC or what?" |
| **My answer in session** | CSE only, on the basis that it is a frontier market with low participation by both listed companies and investors; not transferable to a deep market such as the NYSE; transferability to other frontier markets stated as uncertain. |
| **Raised by** | Sanjula Samarasekara |
| **My reading** | The answer was accepted without pushback. The uncertainty I expressed about other frontier markets is the correct position and should be kept in that form in the write-up rather than being either dropped or inflated into a generalisation claim. |
| **Action** | Keep the CSE as a stress-test setting framing from [[29-09-2026]] §3.2, and scope any transferability statement to what has been evaluated. |
| **Status** | Carried as a standing framing rule |

### 2.5 Architecture question

| | |
|---|---|
| **Said** | > "So your agentic AI is like based on LLM or like any other architecture." |
| **My answer in session** | Mostly LLM based. |
| **My reading** | Asked as context for the technical-contribution question in §2.2 rather than as a challenge in itself. |
| **Status** | Closed |

---

## 3. Interaction with Existing Direction

| Panel point | Existing position | Source | Conflict? | Resolution |
|---|---|---|---|---|
| Technical contribution is weak if it is integration of existing parts | The contribution is the orchestration mechanism, not the architecture; "that is the point where this moved from an application architecture into a testable technical research contribution" | [[29-09-2026]] §3.1 | No | Same direction. The panel point is that the mechanism was not visible in how I presented it. Fix the presentation, not the design. |
| Confidence threshold and reliability gate | $C_{i,t}$ and an abstention mechanism are already defined in the Conditioning Set | [[29-09-2026]] §3.1 | No | Independent convergence. Record as support, not as a new component. |
| Claims need recent published sources | No absolutes; claims scoped to the conditions they were tested under; paper claim, evidence and my reading kept separate | Project standing constraints; [[29-09-2026]] §3.1 | No | Reinforces the existing rule. The gap is in execution across the working documents, not in the rule. |
| CSE-only scope | CSE framed as a frontier-market stress-test setting, not as scientifically unique | [[29-09-2026]] §3.2 | No | Consistent. |

**Standing items checked this session**

- Sentiment analysis was not raised. No conflict with the 20 September scope decision (supervisor, **Final**).
- The agent set and conditioning set were not treated as fixed by the panel member.
- No absolute novelty language was used by me in this session.

---

## 4. Outstanding Actions

|   # | Action                                                                                                                                    | Arising from          | Links to                                             | Done |
| --: | ----------------------------------------------------------------------------------------------------------------------------------------- | --------------------- | ---------------------------------------------------- | :--: |
|   1 | Sweep the working documents for unsourced CSE market-condition statements and attach a reviewed source or rewrite as bounded first person | §2.1                  | [[Research Gap]], [[Contribution to Knowledge]]      |  ☐   |
|   2 | Restate the contribution in computer science terms, mechanism first, with the ablation that makes it measurable                           | §2.2                  | [[Contribution to Knowledge]], [[PoC Specification]] |  ☐   |
|   3 | Lead with the mechanism rather than the agent set in the next panel session and the PPRS handout                                          | §2.2                  | PPRS handout                                         |  ☐   |
|   4 | Record the independent convergence on confidence and reliability gating in the Conditioning Set                                           | §2.3, [[Week 4]] §2.4 | [[Research Matrices Status]]                         |  ☐   |
|   5 | Resolve group number and student ID against the panel sheet                                                                               | §1                    | Administrative                                       |  ☐   |

---

## 5. Open Questions for the Next Session

- Does the orchestration mechanism, presented as a mechanism with its ablation, satisfy the technical-contribution requirement raised here, or is something further expected?
- Is a confidence and reliability gate counted as part of the technical contribution or as supporting engineering?
- What form of evidence is expected for market-condition statements where the reviewed local literature is thin?
