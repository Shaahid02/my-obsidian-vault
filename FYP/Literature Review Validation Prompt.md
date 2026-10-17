# Literature Review Validation Prompt

For strict academic validation of a review note against its source paper. Written for NotebookLM with both the source PDF and the Markdown review selected, but portable to any model that can hold both.

Revision note, 17 Oct 2026: added the provenance checks (B, C, D below) after a validation pass on the Neo4j Graph-RAG note returned "Must fix: none found" while the note contained a formula the paper does not have and an unstated claim about the paper's baseline. The original prompt only ever checked my file against the source and never checked for material I had added with no source at all.

---

The selected sources contain (1) an original research paper and (2) my Markdown
literature review of that paper. Act as a strict academic peer reviewer and
verify my review against the source.

## What my file is

My review is a deliberately selective research note, not a summary. It has a
length budget and omits material on purpose. Two consequences:

- An omission is only a finding if including it would change a conclusion,
  scope a claim, or alter a decision already in my file. "The paper also
  mentions X" is not a finding. Say so explicitly when an omission is defensible.
- The section titled "Why this matters for my project" contains MY OWN design
  decisions and inferences, not claims about the paper. Do not test it for
  source fidelity. Test it only for whether the boundary is visible: flag any
  place where my inference is phrased so that a reader would take it as
  something the paper found or recommended. Report that verdict on its own
  line, not inside the "Checked and correct" list.

## Evidence rules — apply to every single finding, in every severity tier

- A source quote must be a contiguous verbatim span of the paper, in quotation
  marks, that I could locate with ctrl-F in the PDF, with section number and
  page. If you cannot produce such a span, write "no supporting span found"
  and mark the item unverified. Never place wording taken from my file inside
  a block labelled as a source quote, and never label a paraphrase as verbatim.
- Never paraphrase a statistical procedure, a model architecture, or a
  numerical result.
- State for each verification whether it came from the text layer or from a
  figure, diagram or scanned table. You cannot reliably read labels inside a
  rasterised image: if a claim depends on them, say so and mark it unverified
  rather than inferring the labels from the surrounding prose.
- Before claiming I omitted something, search my file for the specific figure
  or term and state what you searched for. This applies to Consider items too,
  not only to Must fix and Should add. If the number is present but the
  surrounding interpretation is not, say that precisely rather than calling it
  a missing data point.
- Before claiming an inaccuracy, quote the exact sentence from my file.
- If a category has no findings, write "none found". Do not manufacture
  findings to fill a category. But "none found" under Must fix is itself a
  strong claim: before writing it, identify the three load-bearing claims my
  file makes about the paper and state what you did to try to falsify each.

## Verify, in this order

**A. Factual accuracy.** Numbers, architectures, sample sizes, dates, test
statistics, parameter counts. Check every figure I quote, including ones that
look routine. Also check that I attribute each figure to the right table,
figure or section.

**B. Constructed content.** For every formula, equation, metric definition,
schema, notation or table in my file, state which of three cases applies: the
source contains it as given, the source defines it in prose only and I have
formalised it, or the source does not contain it at all. Where I have
formalised a verbal definition, check the formalisation is faithful, and in
particular whether an all-or-nothing or conjunctive criterion has become a
proportional, averaged or partial-credit one, or the reverse. A formula the
paper does not state, presented so a reader would take it as the paper's, is a
Must fix even when it is a reasonable reading.

**C. Claims the source is silent on.** Distinct from claims the source
contradicts. List every statement in my file describing the paper, its
baseline, its corpus, its procedure or its authors' choices that the source
neither states nor implies. Silence is the finding. Do not resolve it in my
favour or in the paper's, and do not treat a plausible inference as verified
because it is plausible. Where the honest position is "the paper does not say",
propose replacement text that says exactly that, since an unspecified baseline
or an unreported corpus size is usually a stronger criticism than the guess I
made about it.

**D. Extra-source factual claims.** Statements of background fact that the
paper does not supply at all: market sizes, listing counts, dates, regulatory
facts, other papers' results. Do not attempt to verify these against the
source. Flag each one as needing its own citation, or as needing to be marked
in my text as coming from outside the paper.

**E. Characterisation accuracy.** Does my file accurately describe HOW the
paper treats something, not just what the number is? Specifically flag any
place where I say or imply the authors glossed over, buried, failed to test,
failed to report, or asserted without evidence something they in fact
reported, tested, or explained. Misdescribing the authors' own treatment is as
serious as misquoting a number. Check the reverse direction too: any place I
credit the authors with reporting or testing something they only asserted.

**F. Material omissions.** Findings, limitations or caveats whose absence
changes an argument I make. For each, name the argument in my file it would
change. Rank by that, not by prominence in the paper.

**G. Unsupported or overstated claims.** Claims I attribute to the paper that
the paper does not support, and claims stated more strongly than the evidence
allows. Flag any place where I report a metric as a conclusion, treat an
author interpretation as a tested result, or state something unconditionally
that was shown only under the paper's specific sample, costs, market or period.

**H. Hedging and scope discipline.** Flag absolutes (proves, always, never,
the best, X doesn't work) and any claim not scoped to the conditions it was
tested under.

## Internal consistency of the source

Note any place where the paper contradicts itself across sections, figures or
captions, or where a figure's content does not match how the body text
describes it. These are findings about the paper rather than about my file,
and they belong in my limitations section, so report them separately under
their own heading.

## Output

Group findings by severity, not by category:

- **Must fix** — factual errors, mischaracterisations of the paper, formulas
  or claims the source does not contain, claims the source contradicts.
- **Should add** — omissions that change an argument. For each, say what in my
  file it strengthens or weakens, and propose what to cut to make room.
- **Consider** — defensible either way. One line each, each stating the search
  you ran against my file first.
- **Source inconsistencies** — contradictions within the paper itself.
- **Boundary verdict** — one line on the "Why this matters for my project"
  section.
- **Checked and correct** — the substantive figures and claims you verified as
  accurate, each carrying its quoted span, so I know the coverage of your
  pass. Omit anything you verified only by paraphrase, and do not list
  stylistic or structural judgements here.

For each Must fix and Should add, give the exact string from my Markdown to
replace and the replacement text, so the edit is mechanical.
