# Zotero Integration Setup

How the plugin is wired into this vault, what the highlight colours mean, and the order to do things in.

## What it gives me

Highlight a PDF in Zotero, run one command in Obsidian, and the highlights arrive as Markdown grouped by colour, each with a page number and a link that opens Zotero at that exact page. The review gets written on top of them, in the same note, and re-running the import adds new highlights without touching what I've written.

## One-time setup

### 1. Better BibTeX in Zotero

Required, not optional. Download the `.xpi` from [retorque.re/zotero-better-bibtex](https://retorque.re/zotero-better-bibtex/installation/), then in Zotero go to **Tools → Add-ons → gear icon → Install Add-on From File**, pick the `.xpi`, restart Zotero.

Then pin the citekeys so they never shift: select every item in the library, right click, **Better BibTeX → Pin BibTeX key**. Without pinning, a citekey can change when metadata is edited and every `[@citekey]` referencing it silently breaks.

### 2. Quick Copy format in Zotero

**Zotero Settings → Export → Quick Copy → Item Format.** Set it to the citation style the proposal needs. Check it works by selecting an item and pressing `Ctrl+Shift+C`, which should put a formatted citation on the clipboard. The plugin will not import until this is working.

### 3. PDF Utility in Obsidian

**Settings → Zotero Integration → PDF Utility → Download.** This is a small helper binary the plugin uses to pull image annotations (cropped figures, tables) out of PDFs. Skip it and text highlights still work, but area selections come through empty.

### 4. The import format

**Settings → Zotero Integration → Import Formats → Add Import Format.**

| Field | Value |
| --- | --- |
| Name | `Literature Review` |
| Output Path | `Literature Reviews/{{title \| replace(":", ",") \| replace("/", "-")}}.md` |
| Image Output Path | `Assets` |
| Image Base Name | `{{citekey}}` |
| Bibliography Style | whichever style the proposal uses |
| Template File | `Support Materials/Zotero Templates/Literature Review Template.md` |

The output path replaces colons with commas, which is what the existing fifty-odd review filenames already do, so a paper titled `FinQA: A Dataset of...` lands as `FinQA, A Dataset of...`. Colons are illegal in Windows filenames anyway, so without the replace the import fails silently.

Images go to `Assets` to sit alongside the existing `![[Pasted image ...]]` files.

### 5. A citation format, for inline citing

**Settings → Zotero Integration → Citation Formats → Add Citation Format.** Name it `cite`, set the format to `Pandoc` for `[@citekey]` output, or `Formatted Citation` for a rendered citation. This gives the **Zotero Integration: cite** command, which searches the library from inside a note and inserts at the cursor.

## Highlight colours

The colours map onto the review's sections, so the annotation dump is already sorted into the shape the note needs. Zotero's highlight colours are fixed, so these are the assignments:

| Colour | Section it feeds |
| --- | --- |
| Purple | Gap it's addressing |
| Blue | Data and setup |
| Yellow | Model architecture and training |
| Green | Findings, and any number worth quoting |
| Red | Limitations and hard blockers |
| Orange | Formulas and figures to reproduce |
| Magenta | Why this matters for my project |
| Grey | Unsorted, context |

In Zotero the colours are picked from the highlighter dropdown in the PDF reader, and `Ctrl+1` through `Ctrl+8` assign them by position. Worth learning the four or five that get used constantly.

Orange is the one doing real work against the length budget. Three or four display formulas per review is the cap, so if more than four things end up orange, the extra ones get written as prose instead.

## Daily workflow

1. Read the PDF in Zotero, highlighting by colour. Comments on a highlight come through as a sub-bullet under it.
2. In Obsidian, `Ctrl+P` → **Zotero Integration: Literature Review**, search the paper, hit enter. The note is created in `Literature Reviews/` with the skeleton and the sorted annotations.
3. Write the review in the skeleton above the annotation block.
4. More reading later: re-run the same command on the same paper. New highlights are added, everything I've written stays.
5. When the review is done, delete the `Raw annotations` callout and the `%% begin annotations %%` / `%% end annotations %%` markers.

## Gotchas

**Zotero has to be running.** The plugin talks to it over a local port, so a closed Zotero means the command fails with a connection error.

**Anything outside the persist markers gets wiped on re-import.** The template wraps the review body in `{% persist "review" %}`, which becomes `%% begin review %%` and `%% end review %%` in the note. Writing above or below those markers means losing it the next time the import runs. The frontmatter is outside them too, so `stream`, `market` and `status` get reset unless those fields are moved inside a persist block or filled from Zotero.

**The existing reviews won't accept a re-import.** They have no persist markers, so running the import against one would overwrite the whole file. For a paper already written up, either leave it alone, or paste `%% begin review %%` above the prose and `%% end review %%` below it first, and make sure the filename the output path generates matches the existing filename exactly.

**Check variable names against the data.** `Ctrl+P` → **Zotero Integration: Data Explorer** shows the actual JSON for a selected item. If `venue` or `year` comes out blank in the frontmatter, it's because the field is named differently for that item type, and the Data Explorer says what it actually is. Conference papers in particular use `conferenceName` where journal articles use `publicationTitle`.

**Empty colour headings.** Sections for colours not used in a given paper still print their heading. Deleting them is fine, they're inside the annotations block which gets cut at the end anyway.
