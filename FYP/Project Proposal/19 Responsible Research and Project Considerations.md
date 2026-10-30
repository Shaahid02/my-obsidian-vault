---
status: current
created: 2026-10-23
revised: 2026-10-30
written_against: "[[16-06-2026]]; [[20-09-2026]]; [[29-09-2026]]; [[Scope sentiment analysis dropped]]; [[PoC Data Build]]"
tags:
  - working-doc
  - proposal
---
*Created 23 October 2026, for slide 19 of the PP live presentation template. Three of the template's five rows are extractable from existing decisions; two, accessibility and EDI, and sustainability, had nothing to build on and are composed here. This note does not cover the Ethics Application itself, which is a separate mandatory submission and is tracked in [[29-09-2026]] §11.6. Sentiment is out of scope throughout.*

---

> [!NOTE]
> **Revised 30 October 2026.** This criterion scored **48 of 100** in the [[24-10-2026]] assessment, the second lowest, marked Critical. §6.6 carries a twenty-one item checklist. Part 1 already satisfied the hardest item on it, connecting every material risk to a concrete design decision, and the rest was thinner than it read. Four additions follow: data governance and secure handling, the reproducibility plan against licensing, evaluation bias as a responsible item rather than a methodological one, and the half of the abstention argument that was missing.
>
> **Two things are deliberately not here.** The ethics application **is not mentioned on any slide**, decided 30 October; it remains a mandatory submission and is tracked in [[29-09-2026]] §11.6. And the SDG connection the rubric's upper bands invite is not attempted, because a forced one reads worse than none.

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

> [!important]
> **`[CONFIRMED 30 OCTOBER 2026]` The acquisition is complete and the record has to be corrected to match.** [[24-10-2026]] §6.6 raised this as the reason the criterion scored 48: slide 9 states the Data Library was purchased, while **D24's Verification Status says its contents have not been purchased or inspected, and D25 records the corporate-action files as not obtained** despite its own Decision field saying otherwise.
>
> **The position is that the Data Library was purchased, delivered, inspected and verified**, and the corporate-action registers inside it are what the adjusted panel was built from on 23 October. The objection was never about the purchase, it was about a research record that contradicted itself.
>
> **So the fix is to the worksheets, not to this note.** D24 and D25 must be updated to match before the slide claims a resolved licensing position, because an examiner reading both will find the contradiction rather than the resolution. Until they agree, four statuses stay distinct as §7 requires: a source identified, a dataset downloaded, a derived dataset constructed, and that derived dataset validated.

---

## Part 2. The five areas

| Area | Project-specific issue | Decision or mitigation |
|---|---|---|
| **Ethics and participants** | No human participants, no personal data, no primary data collection from people. Nobody to consent because nobody is involved | Ethics Application completed and submitted as the mandatory qualifying condition. The sentiment removal is what makes the application simple, and the decision is documented rather than implied |
| **Legal, IP and data protection** | Exchange data is licensed material with reuse terms. One historical source carried terms-of-use concerns. Third-party benchmark datasets carry different licences from each other | Data Library purchased at the student rate; official extraction as the base panel; scraping avoided where an official route exists; licensing and reuse terms recorded as a field on every dataset row; the available CSE API documentation noted as community-produced rather than official. Benchmark licences respected individually, with one marked non-commercial and another permissive, so they are used for development and taxonomy rather than redistributed |
| **Security and safety** | The exposure here is not confidentiality, it is **false confidence**: a system emitting a well-formed directional signal from an information channel that is empty today | Positioned as a research prototype and decision-support simulation framework, explicitly not financial advice and not a trading bot. The abstention channel exists so influence falls when a channel is absent. Simulated slippage presented as simulated, since there is no ground-truth execution data to validate a CSE simulator against. Survivorship bias reported rather than carried. Null results reported rather than hidden.<br><br>`[ADDED 30 OCTOBER 2026]` **These reduce the risk and do not remove it**, and saying so is part of the control. Abstention fires when a channel is *detectably* absent, so it cannot catch a channel that is present and wrong. Confidence calibration is fitted on past accuracy, so it is a claim about conditions already seen rather than a guarantee about the next day. **Both fail in the same direction, towards unwarranted confidence**, which is why the system is positioned as experimental decision support rather than advice, and why no number it produces is presented without the conditions it was produced under |
| **Accessibility and EDI** | No interface exists, so there is no interface accessibility surface at proposal stage. What does apply is **representational**: a liquidity screen that silently removes thin counters would concentrate the findings on the largest and most liquid part of the market, which is the part the research is least about | The count of counters the screen removes is reported as a liquidity statistic in its own right rather than as housekeeping. The universe is stratified across the liquidity cross-section rather than selected from the top. The corporate-action exclusion's direction of bias is reported, since counters that split are disproportionately ones that rose. If an interface enters scope at IPD or later, WCAG 2.2 AA applies and the obligation arrives with it |
| **Sustainability and professional** | Compute cost, and the professional obligation not to overclaim | The orchestrator is a low-capacity form rather than a network, argued on statistical grounds and cheaper as a consequence. Agents execute once per run with the arms consuming cached outputs, so five arms cost one agent pass rather than five. No reinforcement learning training of any component. Professionally: a standing language rule against absolute claims, claims scoped to the conditions they were tested under, withdrawn claims recorded rather than quietly dropped, and the pipeline released for reproducibility |

---

## Part 2a. Data governance, licensing and what can be released

`[ADDED 30 OCTOBER 2026]` §6.6 asks for the licence and permitted use of every principal dataset, access controls and secure handling, a decision on what may legally be distributed, and a reproducibility plan that does not depend on redistributing licensed data. None of it was written.

| Source | Permitted use | Handling | May it be released |
|---|---|---|---|
| **CSE Data Library**, 40 items | Purchased at the student rate. **Non-commercial research use** | Held locally. No credentials retained beyond the purchase transaction. Not placed in any public repository | **No.** The derived panel is not redistributed either, since it is a transformation of licensed material |
| **Filings corpus**, 22,893 documents | Harvested from the public announcements feed. Research use, not redistribution | Held locally, read-only in the pipeline | **No.** The harvest script is released, the documents are not |
| **CSE API extraction** | Documentation is community-produced rather than official, so the terms are inferred rather than granted. It is **not** the base panel, which is the official extraction | Retained only as the cross-check that produced the 99.93 percent agreement figure | **No**, and nothing in the research depends on it being releasable |
| **Benchmark datasets** for building the fundamental agent | Licences respected individually. One **non-commercial**, one permissive | Standard public downloads | Per their own licences, which are cited rather than relied upon |
| **Third-party code and models** | `[ADDED 30 OCTOBER 2026]` Python scientific stack under permissive licences. **The model backbone is still open**, so whichever is chosen brings its own terms, and licence is added to the four selection criteria rather than checked afterwards | Dependency versions pinned so the licence set is knowable | Yes, with the licence set documented |

### The reproducibility plan, given that the data cannot travel with it

This is the item that would otherwise contradict itself, since [[14 Evaluation and Experimental Design]] and this note both promise a released pipeline while the data underneath it is licensed.

**What is released: code, configuration and the acquisition route.** The full pipeline, the loaders with their assertions, the seeds, the pinned dependency versions, and a documented procedure for obtaining the same Data Library items at the same student rate. **What is not released: the data, raw or derived.**

**What that costs, said plainly.** Someone cannot rerun this by cloning a repository. They must buy the same items first. That is weaker reproducibility than releasing a dataset, and it is the strongest form available without breaching the licence. The alternative, releasing licensed data to look more reproducible, is not one.

---

## Part 2b. Who a biased evaluation would mislead

`[ADDED 30 OCTOBER 2026]` §6.6 names survivorship, liquidity concentration and excluded inactive securities under this criterion. They are already recorded as methodological limitations in [[12 Data and Evidence Strategy]] and [[20 Scope, Limitations and Closing Defence]]. The responsible framing is a different question about the same facts: not what the evaluation cannot support, but **who would be misled if someone read it as support anyway**.

| Bias | Which way it points | The design decision it produced |
|---|---|---|
| **Survivorship** | Flattering. No listing and delisting register with effective dates exists, so counters that failed are underrepresented and any return estimate is optimistic | Series-end dates used as a **labelled proxy**, the residual bias reported, and the inability to separate voluntary delistings from failures stated rather than glossed |
| **Liquidity concentration** | Flattering, and in the direction that matters most here. A screen that quietly removes thin counters concentrates the finding on the part of the market the research is least about | The universe is **stratified across the cross-section rather than selected from the top**, and the count the screen removes is reported as a liquidity statistic in its own right |
| **Excluded inactive securities** | Flattering. Dropping close-outside-range rows would remove 15.4 percent of the least liquid quintile against close to nothing of the most liquid | Those rows are **retained with a flag** rather than dropped, which was decided on 24 October specifically because dropping them biases the universe towards the liquid end |
| **Corporate-action exclusions** | Flattering. Counters that split are disproportionately ones that rose | Direction of the bias reported alongside the exclusion count |

**Every one of these points the same way, and that is the point worth making.** Each bias, left alone, would make the results look better than they are, and the group most exposed to an over-optimistic result on this market is the one least able to absorb the execution cost it would hide.

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
- `[RESOLVED 30 OCTOBER 2026]` ~~The licensing position depends on a purchase whose delivery terms are partly unknown.~~ **The Data Library was purchased, delivered, inspected and verified**, and the corporate-action registers inside it are what the adjusted panel was built from on 23 October. What replaces this weakness is narrower and is recorded in Part 1: **D24 and D25 still contradict that position** and have to be corrected.
- `[ADDED 30 OCTOBER 2026]` **The secure-handling position is modest rather than engineered.** There are no accounts, no network service and no personal data, so the controls are that files are held locally, no credentials are retained, and nothing licensed is redistributed. That is proportionate to the exposure and it is not an access-control system, which is said rather than implied.

---

## Part 5. Open decisions

`[UPDATED 30 OCTOBER 2026]`

1. ~~Whether the ethics application is mentioned on the slide at all.~~ **Closed 30 October: it is not mentioned on any slide.** The rubric states the mandatory submission is not scored through this criterion, so it buys nothing on a slide already carrying a whole 10 percent alone. **It remains mandatory and remains a qualifying condition**, tracked in [[29-09-2026]] §11.6, and non-submission still voids the entire proposal mark. Not presenting it is a presentation decision and changes nothing about submitting it.
2. **Whether the representational EDI argument is persuasive or looks like reaching.** It is the honest version and it is thin. The alternative is to say the category applies weakly to a non-interactive research pipeline and say why, which is also honest and shorter.
3. **The accessibility commitment for a future interface.** WCAG 2.2 AA is proposed. Committing to a standard for work not yet in scope is cheap now and binding later.

---

**Related notes.** [[Scope sentiment analysis dropped]] for the decision and its reasoning. [[20-09-2026]] §8.2 for the data-source position. [[PoC Data Build]] for the licensing and provenance detail per source. [[09 Stakeholders, Users and Context of Use]] for the exposed parties this note's controls protect. [[29-09-2026]] §11.6 for the Ethics Application schedule.

**Language discipline applies here too.** No "first", "nobody", "never". Nothing here claims a societal benefit the project does not deliver.
