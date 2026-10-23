---
status: current
created: 2026-10-23
written_against: "[[16-06-2026]]; [[29-09-2026]]; [[Research Gap (Final Statement)]]; [[Contribution to Knowledge]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 9 of the PP live presentation template. Stakeholder identification was scheduled for 9 October in [[29-09-2026]] §11.3 and did not happen, and no stakeholder is named anywhere else in the vault, so this note has more composition in it than the others. The positioning it rests on is not new: it comes from [[16-06-2026]] §4. Sentiment is out of scope throughout.*

---

## Why this note exists, and the one decision it turns on

The template's slide 9 asks for primary users, secondary stakeholders, institutional stakeholders and wider impact, each with an evidence source and a design implication. That table is straightforward to fill for a product and awkward to fill for a research prototype, and getting the framing wrong makes the rest of the deck incoherent.

The framing was settled long before this note, in [[16-06-2026]] §4:

> This framing is deliberately **not** "trading bot" or "strategy orchestration". It avoids overclaiming, avoids presenting the system as financial advice, and positions the work as a **research prototype / decision-support simulation framework**.

Everything below follows from that. **There is no end user operating this system in proposal scope**, and saying so plainly is stronger than inventing one. What there is instead is a researcher who operates it, a class of decision-maker whose problem motivates it, a group who would be exposed if it were deployed, and institutions whose data and prior work it depends on.

> [!important]
> This is the slide where an invented persona would be visible immediately, because there is no user research behind one. The honest version is defensible and the fabricated version is not, and the rubric's criterion on initial requirements asks for intended users and interactions, not for personas.

---

## Part 1. The stakeholder table

Four columns, matching the template. Every evidence source is something already in the vault.

| Stakeholder | Need or responsibility | Evidence source | Design implication |
|---|---|---|---|
| **Primary operator: the researcher running the experiments** | Runs that are reproducible, comparisons that are fair, and results attributable to a named cause rather than to a configuration difference | Three documented instances in the reviewed set of published financial ML results that cannot be checked as published. The CSE Graph-RAG paper's proposed system got both the graph and the agent scaffolding while its baseline got neither | Agents run once and all five arms consume the same cached outputs, which is what makes A5 achievable. Seeds recorded, pipeline released, pre-registration fixed before the run |
| **Motivating decision-maker: an investor or analyst allocating on a thin market** | Not to receive a confident directional signal from an information channel that is empty today | AlphaAgents deleted an entire agent by hand because its input channel was too thin across fifteen US megacaps. Three separate CSE studies hand-collected fundamentals from annual report PDFs. Pavithya et al. had the exchange's own announcement feed in 2021 and abandoned it as too thin to train on | The abstention channel, the confidence floor $\phi$, and `unparseable` as a distinct outcome state from `abstain`. An agent's influence falls when its channel is absent rather than a human noticing and intervening |
| **Exposed party: retail participants on the CSE, if a system of this kind were deployed** | Not to be exposed to false confidence, and not to have thin-market execution cost hidden from them | Mean institutional ownership of 66.1% against insider ownership of 5.7%, so available depth is worse than a capitalisation-based estimate suggests. Unexpected illiquidity shocks depress CSE returns at $-0.084$ to $-0.097$, small caps more than large | The research-prototype framing rather than a deployable recommender. Simulated slippage presented as simulated, since there is no ground-truth execution data to validate a CSE simulator against. Survivorship bias reported rather than silently carried |
| **Data provider: the Colombo Stock Exchange** | Licensed and terms-compliant use of its published data, and no scraping where an official route exists | [[20-09-2026]] decision 4, prefer existing and official CSE sources over scraping, Confirmed. The Data Library purchased at the student rate. The available CSE API documentation is community-produced rather than formal exchange developer documentation | The official daily share price extraction is the base panel rather than the API scrape. Licensing and reuse terms recorded as a field on every dataset row. The outstanding request for bid, ask and depth goes through the exchange rather than around it |
| **Adjacent research group: the CSE Graph-RAG work at Moratuwa, same department** | Results and artefacts that can be checked and built on, and prior work credited rather than re-claimed | That system builds a static snapshot with no as-of field, which is a lookahead hazard in a backtest rather than an inconvenience | The single as-of cursor at the data layer, point-in-time correctness as a stated contribution, and structure-aware retrieval explicitly **not** claimed as novel because it is verified prior art on this market from the same university |
| **Academic stakeholders: supervisor, panel and examiners** | Claims that are auditable, scoped to the evidence, and separable from the student's own reasoning | The standing language rule, the dated revision headers, and the withdrawn-claims table in [[Contribution to Knowledge]] Part 4 | Every claim scoped to the conditions it was tested under. Paper claim, evidence and my reading kept visibly separate. Corrections recorded in place rather than rewritten silently |

---

## Part 2. Context of use

The template asks what the system is, who touches it and how. Stated plainly so that slide 11 does not have to invent an interface layer.

| Question | Answer |
|---|---|
| Who operates it | One researcher, in a batch environment |
| How it is invoked | A run specification naming the universe, the window, the arm, the seed and the ablation. Components receive queries against the data layer, never dataframes |
| What it produces | Run artefacts at one row per ticker-date, weight traces, the entropy series, the five-arm comparison table, ablation deltas, the diagnostics set and the A3 sensitivity plot |
| Who reads the output | The researcher, the supervisor, the panel and the examiners |
| What it does not do | Execute, recommend to a third party, or run live. It reconstructs decisions over a historical window under a stated cost model |
| Interface | <font color="#ffc000">None in proposal scope.</font> [[29-09-2026]] §11.8 removes advanced UI development and polishing a full trading application from the plan on the grounds that they would reduce proposal quality rather than improve it |

**Why no interface is the right answer rather than a gap.** The research question concerns how agent influence should be set, and an interface would not help answer it. Building one would consume hours from the mechanism, the comparison and the ablations, which are the things the 20 percent requirements criterion and the 15 percent methodology criterion actually assess. Stating the exclusion as a boundary requirement, which [[10 Requirements]] does as B6, is a stronger position than a thin dashboard.

**What would change if an interface entered scope.** It would come at IPD or later, it would be read-only over completed runs rather than interactive over live data, and it would bring accessibility obligations that currently do not apply. That is noted in [[19 Responsible Research and Project Considerations]] rather than hidden.

---

## Part 3. The stakeholder need that shaped the architecture most

Worth stating as one line on the slide, because it is the clearest evidence-to-design link in the project and it is the sentence the panel is most likely to remember.

> AlphaAgents deleted an entire agent by hand because its input channel was too thin. A human noticed and intervened, and the system had no way to. This automates that intervention and makes it conditional and reversible.

The need belongs to the motivating decision-maker, the evidence is a published system's own account of what it had to do, and the design implication is the abstention channel. That is the slide's four columns in a single example, and it connects slide 9 to slide 10 and slide 11 without repetition.

---

## Part 4. What this note does not have

Said here so it is not discovered in questioning.

- **No user research.** No interviews, no survey, no observational study. The needs above are inferred from published evidence and from the local market structure, not elicited from people. That is a limitation of the requirements process and it belongs on slide 20 as well as here.
- **No named organisation as a partner.** The exchange is a data provider, not a collaborator, and the outstanding data request is a request rather than an agreement.
- **No enrolled participants.** Which is the point that makes [[19 Responsible Research and Project Considerations]] simple: there is nobody to consent, because there is nobody involved.

---

## Part 5. Open decisions

1. **Whether the motivating decision-maker is described as an investor, an analyst or a portfolio manager.** The vault uses all three loosely. One term, used consistently across slides 3, 9 and 20, reads better than three.
2. **Whether the exchange is listed as a stakeholder or only as a data source.** Listing it carries an obligation to describe the relationship accurately, and the relationship is currently a purchase plus an unanswered request.
3. **Whether to name the Moratuwa group on the slide.** Naming adjacent work from the same university is good practice and it also pre-empts the question of whether this duplicates it.

---

**Related notes.** [[16-06-2026]] §4 for the positioning this note rests on. [[10 Requirements]] for B6, the boundary requirement that records the absence of an interface. [[11 Architecture and Indicative Solution]] for how the run control layer replaces an interface layer. [[19 Responsible Research and Project Considerations]] for the exposed-party obligations.

**Language discipline applies here too.** No "first", "nobody", "never". Needs inferred from published evidence are labelled as inferred, not as elicited.
