---
status: current
created: 2026-10-23
revised: 2026-10-24
written_against: "[[PoC Specification]]; [[29-09-2026]]; [[Research Gap (Final Statement)]]; [[07 Research Questions, Aim and Objectives]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 13 of the PP live presentation template. Two of the template's four rows, the evaluation protocol and the validity controls, are the strongest methodology material in the vault and are lifted from [[PoC Specification]] Part 9. The other two, the research design and the development process, have never been named anywhere, and naming them is a decision rather than new research. Sentiment is out of scope throughout.*

---

## Why this note exists

[[29-09-2026]] §11.4 scheduled this for 13 October with an instruction and a warning attached:

> Select and justify research methodology; select development methodology; explain why the two are distinct.
> The official template specifically warns that **Agile alone is not a research methodology**.

Neither was selected. The gap is not in the thinking, it is in the labelling: the project has a coherent research design and a visible working process, and neither has been called by its name.

---

## Part 1. The four layers

The template's own table, filled.

> [!important]
> **Both labels fixed 24 October.** The research design is **design science research**, with a controlled comparative experiment as its evaluation strategy. The development process is **evolutionary prototyping, managed through stage gates**.

| Layer | What it controls | This project |
|---|---|---|
| **Research design** | How the knowledge claim is investigated | **Design science research**, with a controlled comparative experiment as the evaluation strategy |
| **Development process** | How the artefact is built | **Evolutionary prototyping, managed through stage gates**, with acceptance criteria written before each increment |
| **Evaluation protocol** | How evidence is collected and interpreted | Walk-forward, cost-aware, regime-decomposed, with five arms and per-input ablation |
| **Validity controls** | How bias and weak inference are reduced | Point-in-time enforcement, arm fairness, oracle pricing of estimation cost, pre-registration, and a stated screening rule on unfalsifiable measurements |

---

## Part 2. Research design, and why it is this one

**Design science research.** The object of study is a mechanism that does not exist to be observed, so it has to be constructed before anything can be learned about it, and the knowledge claim is about the constructed artefact's behaviour rather than about a naturally occurring phenomenon. That is the design science shape: build an artefact to address a problem class, then evaluate it against alternatives under stated conditions.

**Why the standard label rather than a plainer description.** A phrase such as "constructive and comparative experimental study" says the same thing and is self-explanatory, but it is not a recognised methodology, so it invites the question of what methodology that is. Design science research is standard vocabulary in software engineering and carries its own expectations, which the evaluation strategy below then meets.

**With a controlled comparative experiment as the evaluation.** The research question is comparative in form, so the evidence has to come from running competing weighting schemes over identical inputs and measuring the difference. The controls are what make it an experiment rather than a demonstration: identical data, identical agents, identical everything except the weighting function.

**Why not a case study.** A case study would describe how the system behaves on the CSE. The question is whether state conditioning earns its place against named alternatives, which needs a comparison and a counterfactual, not a description.

**Why not a pure experiment without the design component.** There is no existing implementation of the operator to experiment on. Construction is a necessary part of the method, and pretending otherwise would hide where most of the work goes.

> [!NOTE]
> The CSE is the **evaluation setting**, not the research subject. The honest framing, which [[29-09-2026]] §3.2 prescribes, is that it provides a frontier-market setting in which agent reliability may vary materially over time. The claim is that the quantity is operationally useful, not that this market is unique.

---

## Part 3. Development process, and the evidence for it

**Evolutionary prototyping, managed through stage gates.** A prototype is built small, evaluated against criteria written before it, and then grown into the delivered artefact rather than discarded. Increments are bounded by an hour budget and closed by a gate with a stated condition.

**Why prototyping is the accurate label here, and not incremental delivery.**

- **It is the module's own structure.** No prototype is required at the proposal, a **working prototype** is required at IPD, and a **fully functional prototype** at the end. The process model and the deliverable ladder are the same thing.
- **It is what the panel directed.** [[Week 4]] §2.6 is explicit: do not start by building four agents or the complete framework, and first test whether adaptive weighting provides measurable value over a simple baseline. That is prototyping logic, build small to learn, rather than incremental delivery of a known design.
- **Evolutionary rather than throwaway.** The data layer, the as-of cursor and the agent output contract are built to carry forward. The standing rule that lookahead cannot be retrofitted only makes sense if the prototype becomes the system, which is the defining property of the evolutionary variant.

> [!WARNING]
> **One qualifier that has to be said out loud, because it pre-empts the obvious challenge.** Classic prototyping is a requirements-elicitation strategy: you build in order to discover what is needed. **That is not what the prototype is for here.** The requirements in [[10 Requirements]] are derived from literature and from measurements on this dataset, which is what the source column of every requirement shows. The prototype validates **mechanism feasibility**, specifically whether changing liquidity changes the weights, the decision, or both. Without this qualifier an examiner can reasonably ask why the requirements cite papers if they came from a prototype.

The evidence that the gated half is the actual process rather than a label applied retrospectively:

- [[PoC Specification]] Part 0 opens with the acceptance criteria and says why: *"Written first, deliberately, so the build is measured against them rather than against how much got implemented."*
- Weekly gates at 4, 11, 18 and 25 October and 1 November, each with a stated condition rather than a date alone.
- A dated change freeze, 18 October, barring new agents, datasets, research gaps or technologies.
- Hour budgets per increment, including the reduced 36-hour re-cut in [[PoC Build Plan]] §0 when the earlier plan did not survive contact.
- Explicit droppability, with [[PoC Build Plan]] §4 naming which task to drop first if a day overruns, and which one cannot be dropped at any price.

**Why not Agile as the label.** Two reasons. The template warns against it as a research methodology, which is the lesser reason. The larger one is that the ceremony is absent: there are no sprints, no standups and no backlog grooming here, there are gated increments against pre-written acceptance criteria. Claiming a process not actually followed is the kind of thing that does not survive a question.

**Where the feedback comes from.** Weekly panel sessions and supervisor meetings, handled as a documented loop rather than as ad hoc advice. That is [[16 Iteration, Feedback, Change and AI Verification]] rather than this note, and the two slides should not repeat each other.

---

## Part 4. Why the two are distinct, in one line each

The template asks for this explicitly and it is worth a sentence rather than a paragraph.

> The **development process** governs how the artefact gets built and in what order. The **research design** governs what would count as having learned something from it. Gating an increment tells me the orchestrator runs; it tells me nothing about whether state conditioning earns its place, and only the five-arm comparison with its ablations can answer that.

---

## Part 5. Evaluation protocol

Not novel, and not claimed as novel. What does not exist in the literature I have covered is a CSE baseline set produced under it.

| Commitment | Detail |
|---|---|
| **Commitment zero** | Returns computed on a corporate-action-aware series, because every number below this depends on it |
| Splits | Chronological, walk-forward with adaptive retraining |
| Seeds | Multiple, with repeated windows, and dispersion reported rather than the best run |
| Regimes | Decomposed across the Easter attacks, COVID and the 2022 crisis. The ASPI carries 15.1 percent annualised volatility over the window with annual figures running from 5.6 percent in 2017 to 31.6 percent in 2022, so the regime variable has real variation and does not need hand-dating |
| Costs | Sensitivity sweep rather than a single assumption, with friction charged in quiet periods too |
| Significance | HAC-adjusted and bootstrap. Note the standing warning that standard errors for a combined forecast are nontrivial, because the weights are random and correlated with the forecasts |
| Every directional row | Class balance, Matthews correlation and cost-adjusted return together. The local example of why is accuracy 0.5837 at MCC 0.1493 |
| Trade counts | Equalised before comparison, with exposure time, holding period and turnover as fixed columns |
| Abstention | Evaluated economically or not at all: return per traded day, total return with abstained days held flat, cost per turn, alongside the coverage-accuracy pair |
| Reproducibility | Pipeline released. Three documented instances exist in the reviewed set of published financial ML results that cannot be checked as published |

**The five arms, and what each exists to rule out.** $B_1$ equal weight is the field's hardest benchmark. $B_2$ static learned weight rules out a fixed learned weight getting there too. $B_3$ discounted inverse-MSE with no market state is the arm that actually threatens the contribution, because if reacting to recent agent performance does as well, the state conditioning is not earning its place. $P$ is the proposal. $O$ is an oracle fitted on the test window, which prices estimation cost in this project's own data and units.

---

## Part 6. Validity controls

| Threat | Control |
|---|---|
| Lookahead | A single as-of cursor at the data layer, enforced for all four channels, with violations raising an exception rather than warning |
| Unfair comparison | Arms differ only in the weighting function. Agents run once, arms consume cached outputs, and byte-identical agent outputs across arms is an acceptance check rather than an aspiration |
| Estimation cost mistaken for conceptual failure | The oracle arm. A gain at the oracle with no gain at the estimate is an estimation problem with a number attached, not a refuted hypothesis, and the pre-registration separates the two failure modes before the run |
| Outcome-driven analysis | The pre-registration block, fixed before the first full run, covering the primary metric, the win margin, the test, the estimator, the floor and the universe |
| Overfitting the conditioning set | Any addition must beat the existing set out of sample on the ablation protocol, with the static learned-weight arm retained as the shrinkage-equivalent control |
| Tuning to a favourable setting | The orchestrator's own regularisation swept and reported, including the unfavourable settings |
| Unfalsifiable measurement | A stated screening rule: do not adopt a measurement whose output cannot be checked against anything observable on the market it will be applied to. Applied consistently, it cost the project its planned spread estimator |
| Selective reporting | A null is an acceptable outcome, decided in advance, and failure is recorded rather than hidden |

---

## Part 7. Threats to validity that remain

Stated here so they appear on the limitations slide rather than in an answer under pressure.

- **Ex-date timing, which replaces the corporate-action threat.** `[CORRECTED 24 OCTOBER 2026]` The adjusted panel was built on 23 October, so the detect-and-exclude workaround and its exclusion bias no longer apply. What remains is narrower and still real: **no documented date is an ex-date**, the ex-dates were recovered from measured price drops, and `corporate_actions.csv` records reliability in `ex_date_basis` with **259 events marked approximate**. Daily-return models drop or flag a few days around those events; longer-horizon returns are unaffected. The superseded wording read: *the primary series is unadjusted, confirmed by inspection on 18 October, so the PoC runs on a detect-and-exclude subset.*
- **Survivorship.** No listing and delisting register with effective dates is held, so series-end dates serve as an explicit proxy and the residual bias is reported rather than carried.
- **Simulated slippage is not measured slippage.** There is no ground-truth execution data to validate a CSE simulator against, so it is presented as simulated.
- **Persistence estimator stability.** $\hat{d}$ on short rolling windows is a named risk, with per-regime estimation and a slower-moving cap as the fallback, and the instability reported either way.
- **Heterogeneity is asserted until measured.** If the technical and volatility agents produce errors correlating highly on CSE data, the pool is less diverse than the architecture implies and the error-cancellation argument weakens accordingly.
- **The gap statement has a cutoff.** 2026-03-09, attached explicitly, and worth re-checking before submission.

---

## Part 8. Settled and open

### Settled 24 October

| Item | Decision |
|---|---|
| Research design | **Design science research**, with a controlled comparative experiment as the evaluation strategy |
| Development process | **Evolutionary prototyping, managed through stage gates**, with the qualifier in Part 3 that the prototype validates mechanism feasibility rather than eliciting requirements |
| Slide 13 against slide 14 | **Slide 13** carries the two methodologies, why they are distinct, and the validity controls. **Slide 14** carries the comparators, metrics, protocol, ablations and success criteria |
| Corporate-action threat | Superseded. Replaced in Part 7 by the narrower ex-date timing threat |

### Still open

Nothing in this note.

> [!NOTE]
> **Two further threats in Part 7 may need revising once backlog item B1 is cleared.** The filings corpus now exists, 22,893 documents dated by CSE announcement date, which changes what can be said about the fundamental channel. Part 7 does not currently carry a threat about it, and once the corpus is profiled for text-native against scanned coverage, an extraction-quality threat may belong there.

---

**Related notes.** [[PoC Specification]] Part 9 for the protocol in full. [[07 Research Questions, Aim and Objectives]] for what the method is answering. [[15 Testing, QA and Traceability]] for verification as distinct from evaluation. [[16 Iteration, Feedback, Change and AI Verification]] for the feedback loop this process runs inside.

**Language discipline applies here too.** No "first", "nobody", "never". The permitted form is *"I have not found that evaluation in the literature I have covered."*
