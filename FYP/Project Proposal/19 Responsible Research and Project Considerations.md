---
status: current
created: 2026-10-23
written_against: "[[16-06-2026]]; [[20-09-2026]]; [[29-09-2026]]; [[Scope sentiment analysis dropped]]; [[PoC Data Build]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 19 of the PP live presentation template. Three of the template's five rows are extractable from existing decisions; two, accessibility and EDI, and sustainability, had nothing to build on and are composed here. This note does not cover the Ethics Application itself, which is a separate mandatory submission and is tracked in [[29-09-2026]] §11.6. Sentiment is out of scope throughout.*

---

## Why this note exists, and the test it has to pass

This slide carries a whole 10 percent criterion on its own, with light support from the data strategy slide, which makes it one of the two densest slides in the deck. The template's instruction is also the hardest to satisfy:

> Responsible considerations should change design, methodology or governance decisions. Avoid generic statements.

And the rubric's own expectation, from [[29-09-2026]] §8.1, is "**Risk/ethics: project-specific, not generic**."

So the structure below leads with the three decisions that responsible considerations actually changed, and then fills the template's five rows. A row with no decision attached is marked as such rather than padded.

> [!important]
> **The mandatory ethics requirement is separate from this slide and is a qualifying condition.** The signed Ethics Application must be submitted by the assessment deadline, and failure to submit gives an overall Project Proposal mark of zero regardless of the rubric marks. It is listed as Not Started in the deliverables tracker with a 1 November target. Nothing on this slide substitutes for it.

---

## Part 1. Three decisions responsible considerations actually changed

This is the part that answers the template's instruction, and it is worth leading with because most proposals cannot do it.

**1. The sentiment component was removed, and that removed an entire ethical exposure.** The component would have required primary data collection from public forums and social media, manual annotation, platform access under terms of use, and redistribution rights over collected text. [[13-09-2026]] §7.1 lists "address ethics, privacy, platform terms and redistribution rights" as one of thirteen required steps. The decision was taken on scope and risk grounds on 20 September, status Final, and the ethical consequence is that this project now collects no personal data, involves no human participants and touches no platform terms. The honest framing is that the ethical simplification was a consequence of the scope decision rather than its motivation, and the consequence is real either way.

**2. A measurement method was rejected because its output could not be checked.** The planned effective-spread estimator was demoted to last resort on 11 October. It is unvalidated on thin and frontier markets, and the CSE has no quote data to check it against, so a spread produced that way could not be falsified even in principle. The general rule extracted from that decision is now a stated methodological commitment: **do not adopt a measurement whose output cannot be checked against anything observable on the market it will be applied to.** Applied consistently it is uncomfortable rather than convenient. It cost the project the measurement half of one of its sub-gaps, and the cost is the evidence that the rule is real.

**3. Official licensed data was purchased rather than scraped.** [[20-09-2026]] decision 4 prefers existing and official CSE sources over scraping, Confirmed, and §8.2 is explicit that scraping is not recommended first. The Data Library was purchased at the student rate for the full set rather than assembling the same material by scraping, and the base panel is the official extraction rather than the API scrape. The research consequence is also favourable, since the official set carries 46 securities absent from the API, a 12.8 percent gap spanning a sovereign default, but the ordering of the decision was licensing first.

---

## Part 2. The five areas

| Area | Project-specific issue | Decision or mitigation |
|---|---|---|
| **Ethics and participants** | No human participants, no personal data, no primary data collection from people. Nobody to consent because nobody is involved | Ethics Application completed and submitted as the mandatory qualifying condition. The sentiment removal is what makes the application simple, and the decision is documented rather than implied |
| **Legal, IP and data protection** | Exchange data is licensed material with reuse terms. One historical source carried terms-of-use concerns. Third-party benchmark datasets carry different licences from each other | Data Library purchased at the student rate; official extraction as the base panel; scraping avoided where an official route exists; licensing and reuse terms recorded as a field on every dataset row; the available CSE API documentation noted as community-produced rather than official. Benchmark licences respected individually, with one marked non-commercial and another permissive, so they are used for development and taxonomy rather than redistributed |
| **Security and safety** | The exposure here is not confidentiality, it is **false confidence**: a system emitting a well-formed directional signal from an information channel that is empty today | Positioned as a research prototype and decision-support simulation framework, explicitly not financial advice and not a trading bot. The abstention channel exists so influence falls when a channel is absent. Simulated slippage presented as simulated, since there is no ground-truth execution data to validate a CSE simulator against. Survivorship bias reported rather than carried. Null results reported rather than hidden |
| **Accessibility and EDI** | No interface exists, so there is no interface accessibility surface at proposal stage. What does apply is **representational**: a liquidity screen that silently removes thin counters would concentrate the findings on the largest and most liquid part of the market, which is the part the research is least about | The count of counters the screen removes is reported as a liquidity statistic in its own right rather than as housekeeping. The universe is stratified across the liquidity cross-section rather than selected from the top. The corporate-action exclusion's direction of bias is reported, since counters that split are disproportionately ones that rose. If an interface enters scope at IPD or later, WCAG 2.2 AA applies and the obligation arrives with it |
| **Sustainability and professional** | Compute cost, and the professional obligation not to overclaim | The orchestrator is a low-capacity form rather than a network, argued on statistical grounds and cheaper as a consequence. Agents execute once per run with the arms consuming cached outputs, so five arms cost one agent pass rather than five. No reinforcement learning training of any component. Professionally: a standing language rule against absolute claims, claims scoped to the conditions they were tested under, withdrawn claims recorded rather than quietly dropped, and the pipeline released for reproducibility |

---

## Part 3. Societal considerations, stated briefly

Worth one line on the slide rather than a section, because overstating it is its own failure.

A system of this kind, if deployed rather than studied, would operate on a market where mean institutional ownership runs at 66.1 percent against insider ownership of 5.7 percent, so available depth is materially worse than capitalisation suggests, and where unexpected illiquidity shocks depress returns more for small counters than large ones. Retail participants are the group least able to absorb execution cost that a model has assumed away. That is the reason the cost treatment is inside the research question rather than bolted on afterwards, and the reason the framing is a research prototype rather than a recommender.

**What is not claimed.** No claim is made that this improves market access, informs policy, or benefits any group. It is an evaluation of a mechanism, and the societal consideration is about what would be true if someone deployed it, not about what this project delivers.

---

## Part 4. Where this is weakest

Said here so it is said by me rather than by an examiner.

- **Accessibility and EDI is composed rather than evidenced.** The representational argument in Part 2 is sound and it is the only thing in this project the category genuinely attaches to. There is no accessibility testing because there is nothing to test, and that will change the moment an interface exists.
- **No compute or energy figure exists.** The sustainability argument is structural, fewer parameters and one agent pass rather than five, and it is not backed by a measurement. A measured figure would be better and is not available.
- **The ethics form's content is not described anywhere in the vault.** It is scheduled and it is mandatory, and what it covers has never been written down, which is a gap in preparation rather than in the argument.
- **The licensing position depends on a purchase whose delivery terms are partly unknown.** The Data Library order was initiated with an unknown lead time, and the corporate-action register inside it is a precondition for the adjusted price series.

---

## Part 5. Open decisions

1. **Whether the ethics application is mentioned on the slide at all.** The rubric says the mandatory submission is not scored through this criterion, so mentioning it costs time on a dense slide. One line confirming it is submitted is probably worth it; a section is not.
2. **Whether the representational EDI argument is persuasive or looks like reaching.** It is the honest version and it is thin. The alternative is to say the category applies weakly to a non-interactive research pipeline and say why, which is also honest and shorter.
3. **The accessibility commitment for a future interface.** WCAG 2.2 AA is proposed. Committing to a standard for work not yet in scope is cheap now and binding later.

---

**Related notes.** [[Scope sentiment analysis dropped]] for the decision and its reasoning. [[20-09-2026]] §8.2 for the data-source position. [[PoC Data Build]] for the licensing and provenance detail per source. [[09 Stakeholders, Users and Context of Use]] for the exposed parties this note's controls protect. [[29-09-2026]] §11.6 for the Ethics Application schedule.

**Language discipline applies here too.** No "first", "nobody", "never". Nothing here claims a societal benefit the project does not deliver.
