# Literature Review Style Note

Derived from four existing reviews in the vault: AlphaAgents, Deep RL Framework (Kashif & Ślepaczuk), Financial Report Chunking for RAG, and The Evolution of RL in Quantitative Finance.

## Structure is not fixed. Depth scales with relevance to the project.

Papers that are direct methodological templates get the full treatment:

- An opening paragraph placing the paper and saying plainly how it relates to my work
- `#### Gap it's addressing`
- `#### Data and setup`
- `#### Model architecture and training`
- `#### Findings`
- `#### Limitations`
- `#### Why this matters for my project`

Papers that are background or tooling follow the paper's own shape instead (pipeline, results, discussion, conclusion), or open with `## Major differences to mine` and `## Standout features` before the summary.

Two things appear regardless of format: how the paper differs from what I'm building, and what's worth taking from it.

## Length

Depth scales with relevance, but relevance has no natural ceiling, so the budget has to come from somewhere else. A full-treatment review of a standard conference paper, roughly ten to twelve pages, targets **around 18,000 characters and does not exceed 25,000**. Background and tooling notes get half that. A journal-length paper or a survey can run longer, but the extra length has to come from the paper containing more, not from me arguing at greater length about the same things.

Section budgets, which are the part that actually binds:

| Section | Budget |
| --- | --- |
| Findings | 5 to 6 bullets |
| Limitations | 5 to 6 bullets |
| Why this matters for my project | 6 to 8 bullets |
| Display formulas | 3 to 4 |
| Figures and images | 3 to 4 |

These are budgets, not limits, and the distinction matters. The point is to force selection while I'm writing rather than leaving everything in because each piece is individually defensible. A ten-page paper with two contributions does not support eleven distinct limitations, and if I have eleven, most of them are the same three observations wearing different hats.

If a section genuinely needs to overrun, the honest move is to overrun it and cut somewhere else, not to let the whole note inflate.

## Say it once

Every criticism gets exactly one home. The gap section raises what the paper assumes and states, the findings report what the evidence shows, the limitations adjudicate where it runs out, and the last section converts what survives into decisions. A point that appears in three of those is not three points, and the repetition reads as padding even when each instance is well argued.

The common failure is a premise I doubt: it gets questioned when I describe the paper's framing, questioned again when a result fails to support it, and questioned a third time in limitations. Pick the section where it lands hardest, usually limitations, and let the earlier mentions be a clause rather than a paragraph.

## Voice

First person, contractions, direct verdicts. I say when something works and when it doesn't: the extra self-attention machinery isn't paying for itself here, this is a useful prior against defaulting to the most complex encoder, the paper is upfront about this itself. Evaluative, not neutral summary.

But the verdicts are scoped to what the paper actually shows. This is research, and the point of the review is to evaluate the evidence and find where it runs out, so no absolutes that the paper hasn't earned.

- **Scope every claim to the conditions it was tested under.** "Isn't paying for itself here" works because *here* does the scoping: this dataset, this sample, these costs. Without that qualifier it becomes a claim about Transformers in general, which no single paper can support. Prefer "on this sample", "under 2 bps costs", "in this market", "across these sixteen folds" over bare assertions.
- **Keep the paper's claim, its evidence, and my read of it visibly separate.** The DRL note does this well: regime dependence is *mostly asserted rather than tested*, and the hierarchical-policy result *isn't a clean ablation since other design choices co-vary*. Say which of the three I'm reporting whenever it isn't obvious.
- **Don't upgrade a metric into a conclusion.** Higher IR2 is higher IR2, not "RL outperforms", especially when the significance tests don't clear. Report the economic result and the formal test side by side and let the gap between them stand.
- **Where the evidence is absent, name the open question instead of answering it.** That absence is the gap, and finding it is the primary job of the review, so an unresolved question written down plainly is a better outcome than a confident sentence papering over it.
- Avoid *proves*, *always*, *never*, *the best*, *X doesn't work*. Use *suggests*, *is consistent with*, *the authors read this as*, *on this evidence*. Hedging is not weak writing here, an overclaim I can't defend is the thing that costs me later.

## Sentences

Long and comma-chained. Clauses pile up with commas where most writing would use an em dash, a semicolon, or a full stop. **Never use em dashes.** Parallel repetition for emphasis is normal: same MDP framing, same SAC backbone, same reward structure.

## The last section does the real work

"Why this matters for my project" is bullets that convert each finding into a decision for my own build, always tied back to the CSE. Not a recap.

**No gap-matrix IDs in the prose.** Don't write G1, G2, G7 or anything of that shape anywhere in a review. Name the thing itself instead: execution friction in a thin book, volatility persistence, sentiment resources, structure-aware retrieval, layered explainability, evaluation discipline. The reviews have to read on their own without the matrix open beside them, and the IDs are numbering that will move. Same applies in the findings and limitations sections, not just the last one.

## Formatting

- `####` for section headers in the main reviews.
- Findings and limitations as bullets, each a full argued paragraph, not a fragment. Bold the key term when a bullet opens on one. **Fewer of them, though.** A bullet earns its slot by changing a decision or scoping a claim, not by being true, and anything that shares a conclusion with another bullet gets merged into it rather than standing alone. Full paragraphs and an unbounded bullet count is how a note doubles in size without saying anything more.
- Obsidian callouts for definitions and standing cautions: `> [!NOTE]`, `> [!info]`, `> [!WARNING]`, `> [!important]`.
- Inline highlighting with `<font color="#ffc000">` for key terms (the workhorse), `<font color="#ffff00">` for technique names, `<font color="#ff0000">` for hard blockers.
- Images as `![[Pasted image ...]]`, placed directly after the text they illustrate. Three or four per review, the ones carrying an argument I make in prose, not every figure worth looking at. Don't leave orphaned images in `Assets` when a figure gets cut.
- Wikilinks for cross-references to other vault notes, footnotes `[^1]` for definitional asides.
- Tab-indented sub-bullets under numbered items.

## Tables

Use a table wherever it carries the material better than prose would. The test is whether the same handful of attributes repeats across a fixed set of items, in which case a reader scanning down a column learns something that a paragraph buries.

Cases that earn one:

- **Verbatim reference material that is row-structured.** The per-agent prompts in AlphaAgents are the existing precedent: short label on the left, the full quoted text on the right, header row left blank because the columns don't need naming.
- **Configuration or variant grids.** The five DRL configurations vary encoder, policy structure, reward formulation, cash constraint and top-k, five items against five attributes, which reads far more clearly as a grid than as the running sentence it currently is.
- **Repeated metrics across markets, methods or datasets.** IR2 and drawdown per configuration per market, chunking strategy against page-level and paragraph-level retrieval accuracy, anything where the same columns recur.
- **Cross-paper comparisons.** Once three or more notes cover the same problem shape, one grid of paper against design dimension replaces three paragraphs of "unlike the other one". The RL portfolio table in the FreQuant note is the precedent.

Keep them working:

- Every table gets a lead-in sentence saying what to look for in it, the same rule as formulas.
- The figures that carry the argument still get quoted inline in the surrounding prose, so the point survives without the table.
- Keep the column count low and the cells short. Anything needing a sentence of judgement per row belongs in bullets underneath the table, not inside it.
- The paper's own large results tables can still come in as `![[Pasted image ...]]` when the whole thing matters. Retype into a markdown table when only a slice of it does.

## Formulas

Display LaTeX in `$$...$$`, inline in `$...$`. Include one only when it carries a mechanism that would otherwise take a paragraph to describe: reward functions, turnover, HHI, IR2, retraining thresholds. Every formula gets a plain-language lead-in, and a `where:` list when the symbols aren't self-evident. No formulas for descriptive statistics.

**Prose first, and three or four display formulas per review.** The inclusion test above is easy to satisfy over and over in a maths-heavy paper, so it needs something pushing back: if one sentence conveys what the mechanism does, write the sentence. Reserve the display formulas for the two or three pieces I would actually need to reimplement or would cite in the proposal, and describe the rest in words. A complex attention variant, for instance, is adequately conveyed by saying the dot product is replaced by the Hermitian inner product and the softmax by a magnitude-based version, without the equation.

## Numbers stay concrete

Quote the actual figures inline (IR2 = 0.46, 2 bps, 23 hours against 14, 62,529 versus 112,155) rather than saying the method was more efficient. This survives the length budget untouched, cutting a review means cutting arguments, never the numbers inside the ones that stay.

## Before saving

Three checks, in this order:

1. **Over budget?** Count the findings and limitations bullets and the display formulas against the table in Length. If any section is over, the cut comes from merging bullets that share a conclusion, not from shortening every bullet uniformly.
2. **Said twice?** Search for the two or three criticisms I care most about and check each appears in one section only.
3. **Formula that prose would cover?** For each display formula, try writing the one-sentence version. If the sentence works, use it.

## Open points

- Heading levels are inconsistent across the four source notes (`##`, `###` and `####` all appear as top-level sections). Pinned to `####` here; change if the other convention is preferred.
- The RL survey note reads differently from the rest, closer to a structured textbook digest than a review. Treated as a separate mode rather than folded into the main pattern.
- The four source notes predate the no-gap-IDs rule and several of them still carry G-references in the last section. They need a pass to strip those out, same substitutions as in the MacroHFT note.
- The existing notes predate the length budget and read long against it, MacroHFT at roughly 30k in particular. Not worth retrofitting on its own, but worth trimming whenever one of them is next revised.
