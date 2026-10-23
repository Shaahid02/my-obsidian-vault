---
status: current
created: 2026-10-23
written_against: "[[Panel Rooms]]; [[Week 3]]; [[Week 4]]; [[Week 5]]; [[29-09-2026]]; [[Research Matrices Status]]; [[Literature Review Validation Prompt]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 16 of the PP live presentation template. This is the slide with the most existing evidence and the least existing writing: the feedback loop, the change record and the verification of AI-assisted work are all documented across the vault and none of it has been stated as a process. It also closes [[Week 5]] outstanding action 2, the derivation note. Sentiment is out of scope throughout.*

---

## Why this note exists

The rubric's methodology criterion names this directly, which is easy to miss because the words sit at the end of a long sentence:

> ...how iteration, feedback and change will be managed; and how the planned use of AI and verification of its outputs will be addressed.

It is scored, it is inside the 15 percent criterion, and the template recommends an AI-use and verification backup slide specifically for examiner questioning. There is also a live reason: in [[Week 5]] §2.4 a panel member asked directly whether the weighting equation came from an AI tool. That question was answered in the room and not on paper, and a document answers it better than a sentence does.

---

## Part 1. How feedback is captured and converted

The loop runs on two cadences and they work differently.

| Source | Cadence | How it is captured |
|---|---|---|
| Panel feedback sessions | Weekly | Recorded, transcribed, then synthesised into a note with the raw transcript kept beside it |
| Supervisor meetings | Roughly fortnightly | Same structure, with decisions carrying an explicit status |

**The structure each session note uses is the part worth showing**, because it is what stops advice turning into assumption. Every feedback point is split into four distinct claims that are not allowed to merge:

1. **Said**, a verbatim quote from the transcript.
2. **My reading**, labelled as mine.
3. **Action**, what it changed.
4. **Status**, open, in progress, done, deferred or rejected with a reason.

Directives are separated from opinions. [[Week 4]] §2.4 is the clearest case: a panel member offered a view on the technical contribution and explicitly hedged it as his own, so it is recorded as "Opinion, referred to the supervisor" rather than as a requirement. [[Week 5]] §2.3 is the mirror case: I asked a question, the answer went elsewhere and did not return, and it is recorded as unanswered rather than as tacit approval, because reading silence as endorsement is exactly the inference that does not survive a viva.

**Conflicts between sources are surfaced rather than reconciled quietly.** The panel member changes week to week, so [[Panel Rooms]] carries a standing instruction to assume nothing said in an earlier session has been heard. Two points so far have been answered by a different member from the one who raised them, the data window being the clearest, deferred in Week 4 at one scale and answered in Week 5 at a very different one. Both are carried to the supervisor together rather than one being chosen silently.

**Outstanding actions carry forward with provenance.** Each session note ends with a numbered action table, and the next session opens with what was carried in and whether it was raised. Items that were not raised are marked as not raised rather than quietly dropped.

---

## Part 2. How change is managed

Four mechanisms, all already in use.

| Mechanism | What it does | Example |
|---|---|---|
| **A dated change freeze** | Bars new agents, datasets, research gaps or technologies after 18 October | Supervisor, 29 September, recorded as a hard rule. [[PoC Build Plan]] §2 treats fixing the component list as the act of freezing it |
| **Dated revision headers** | Every working document states when it was last revised and what it was written against | The frontmatter convention across the vault |
| **Corrections in place, not rewrites** | A superseded statement is marked and left visible rather than edited away | Nine cells flagged `[CORRECTED 18 OCTOBER 2026]` in the gap matrix rather than silently updated |
| **Superseded text retained beneath** | The earlier reasoning is kept as the record of how the decision was reached | The demoted spread estimator keeps its original adoption argument annotated rather than deleted, with a revival condition attached |

**Four worked examples of change, each with a different cause.** These are more persuasive than the mechanisms, because they show the process producing outcomes that cost something.

- **Scope reduced on supervisor instruction.** Sentiment dropped on 20 September, status Final, with a twelve-location removal checklist so the decision propagated rather than being remembered selectively.
- **A method withdrawn on evidence.** The planned spread estimator demoted to last resort on 11 October, because it is unvalidated on thin and frontier markets and the CSE has no quote data to check its output against, so a number produced that way could not be falsified even in principle.
- **A claim withdrawn because the literature contradicted it.** The claim that size-dependent execution cost is unmodelled, withdrawn once two papers were found that implement it, with the self-rated novelty moved down at the same time rather than left where it was.
- **A figure corrected against the project's own data.** The per-counter history quoted as 374 trading days turned out to be a superseded archive. The current extraction runs to a median of roughly 3,400 days per counter, and the correction weakened one of my own arguments, which is recorded as such.

That last one is the example to use if asked, because the correction cost something: the forecast-combination argument that limited data favours equal weights is a weaker argument at 3,400 days than at 374, and the record says so plainly rather than keeping the convenient version.

---

## Part 3. AI use and verification

Stated as a table, matching the template's own three columns.

| AI-assisted activity | Verification method | Evidence retained |
|---|---|---|
| Finding and shortlisting literature | Search filters set to peer-reviewed venues and recent years, then the paper itself read before entry. Central novelty claims anchored in peer-reviewed work rather than preprints, with roughly 14 preprints in the corpus flagged as such | The corpus index, with venue and year per entry |
| Drafting and structuring review notes | Each note written against the source paper and then put through a strict validation pass. The standing rule is that where a working document conflicts with a review note or with the paper, **the paper wins**, and the conflict is reported rather than reconciled silently | 59 review notes, all marked complete, plus the validation prompt and the skill that runs it |
| Populating the research matrices from the notes | A provenance audit requiring every quoted span in the matrix to be verbatim in the note it is drawn from, with disputed cases adjudicated against the source PDF | The audit moved 79 opening and 95 closing quotation marks and unquoted 101 spans, so that all 1,621 quoted spans are now traceable |
| Synthesis in the working documents | Cross-checking the synthesis back against the notes | **Thirteen substantive corrections** found, four adjudicated against source PDFs. One note had reversed a paper's own ablation finding; two asserted something the note explicitly withholds; one quoted one strategy's turnover for another's; one carried a metric gain that appears at no horizon in the paper |
| Deriving the weighting formulation | Term-by-term mapping to the reviewed papers that support each term, with any term resting on my own reasoning flagged as mine | Part 4 below |
| Code and data pipeline | Review against official documentation, plus the data verification suite as the backstop: external reconciliation rather than inspection alone | [[15 Testing, QA and Traceability]] Part 2 |

**What AI is not used for, stated plainly.** It does not decide what the contribution is, it does not decide what the evidence shows, and it is not cited as evidence. The template's own line is that AI should not be cited as academic evidence, and the corollary followed here is that an AI-produced summary is a prompt to read the paper rather than a substitute for reading it.

**The verification that matters most is the one that found errors.** A verification process that has never caught anything is not evidence of correctness. Thirteen corrections across 59 notes, four of them adjudicated against the original PDFs, is evidence the process runs.

---

## Part 4. Provenance of the weighting function

This closes [[Week 5]] outstanding action 2 and answers the question put in [[Week 5]] §2.4 about whether the equation came from an AI tool. The answer is that the form has a lineage in the forecast combination literature and each term has named support, with one honest exception.

$$w_{i,t} = f(L_t,\ V_t,\ P_t,\ C_{i,t})$$

| Term | What supports it | Strength of the trail |
|---|---|---|
| **The functional form** | Time-varying feature-conditioned combination. The nearest named ancestor is feature-conditioned forecast combination, and the difference is one sentence: its features are properties of the series being forecast, computed once from history, while these are properties of market state, measured at each step and exogenous to the agent being weighted | Strong. Positioned as a generalisation along an identified axis rather than as new machinery |
| **$L_t$ liquidity** | Trading volume Granger-causes the index at $p = 0.0041$ while money supply and inflation reach nothing. Illiquidity shocks depress returns at $-0.084$ to $-0.097$. Composite construction follows a published market-condition-indicator recipe | Strong, and locally measured |
| **$V_t$ volatility** | Range estimators pinned to Parkinson or Garman-Klass because five-minute realised volatility is unavailable on this market. Volatility clustering measured in three separate CSE studies | Strong |
| **$P_t$ persistence** | Long memory found on the ASPI and SL20 across all three regimes, with persistence close to 1 in a second study. Feasibility confirmed on this sample at $\hat{d} = 0.408$ on absolute returns | Strong, and locally measured |
| **$C_{i,t}$ confidence** | Step-count difficulty from the numerical-reasoning benchmarks, conformal interval width from the adaptive conformal inference work, Theil's $U2$ as standard, and the accuracy-at-threshold transform from the abstention literature | <font color="#ffc000">The thinnest of the four.</font> The individual mechanisms are sourced; the decision to make them comparable through one transform is my own reasoning, and whether four backward-looking competence estimates can be made comparable across four architectures is an open question |

Saying which term rests on my own reasoning is stronger than implying all four are equally sourced, and it matches how the contribution note already states the limit: having several mechanisms is progress on the problem rather than a solution to it.

---

## Part 5. Open decisions

1. **How much code-level AI verification to claim.** The data pipeline has external reconciliation behind it. The orchestration code does not exist yet, so the row in Part 3 is a stated intention and should be labelled as one on the slide.
2. **Whether the thirteen-corrections figure goes on the main slide or the backup.** It is the single most persuasive piece of evidence here, and it is also the kind of detail that invites a follow-up question, which is an argument for having the examples ready either way.
3. **Whether to show the session note structure itself.** A screenshot of one feedback point with its four rows would demonstrate the process in less time than describing it.

---

**Related notes.** [[Panel Rooms]] for how the sessions are tracked and why the panel is not treated as one voice. [[Week 3]], [[Week 4]] and [[Week 5]] for the sessions themselves. [[Research Matrices Status]] for the correction record. [[15 Testing, QA and Traceability]] for verification of the build as distinct from verification of the research.

**Language discipline applies here too.** No "first", "nobody", "never". AI-assisted output is labelled as verified against a source or as unverified, never as self-evidently correct.
