Purpose-built RAG framework for financial QA over long, multimodal filings (10-Ks, 10-Qs, 8-Ks, investor presentations). Point of reference: a single Morgan Stanley 10-Q runs ~120 pages with 275+ tables and ~200 figures, way past what a normal RAG pipeline can handle cleanly.

> [!info] Why standard RAG struggles here
> - **Length & cost:** document length blows past LLM token limits, driving up API cost and making end to end processing infeasible.
> - **Mixed formats:** tables and charts lose their structure once flattened into plain text, which obscures the numerical context financial QA actually needs.
> - Standard pipelines make this worse with fixed-size non-overlapping chunks (splits explanations/numbers across boundaries), treating tables/charts as plain text, and static top-𝑘 retrieval (redundant or barely relevant snippets).

**Three things this paper adds:**
1. **Batch multimodal extraction:** small groups of table/chart images get sent to a lightweight multimodal LLM, which returns structured JSON plus a short text summary. Keeps the numeric relationships and visual detail intact for indexing.
2. **Semantic chunk merging & thresholded retrieval:** over-segmented text chunks get recombined by embedding similarity and indexed in FAISS with modality-specific similarity thresholds (80% for text vs 65% for images) so marginal context gets filtered out.
3. **Tiered fallback:** queries first try high-similarity text only. If that's not enough, retrieval escalates to table and image context, combining text + table + image when needed.

Runs on commodity/free-tier hardware and still beats ChatGPT-4o (free tier) by **19 percentage points** on complex financial QA across text, tables, images, and combined reasoning.

#### Related Work
Sits itself against SELF-RAG (self-reflective retrieval critique), T-RAG (tree based hierarchical retrieval), MoG/DRAGIN (dynamic chunk sizing and retrieval timing), Late Chunking (deferring segmentation until after embedding), and DPR as the dual-encoder retrieval baseline. On the eval side it brings up eRAG/DPA-RAG (retrieval relevance vs downstream generation) and ClashEval/vRAG-Eval (behaviour under noisy/conflicting retrieval).

Financial-domain specific work it cites:
- **PDFTriage:** flattening PDFs to plain text loses layout/context, so it proposes layout-aware retrieval instead.
- Smith et al. on structural segmentation. This is actually the same paper as [[Financial Report Chunking for Effective Retrieval Augmented Generation]] already in this vault, they showed structural segmentation improves retrieval accuracy.
- **Fin-RAG:** improves accuracy using tree-based retrieval with metadata clustering.

Gap it's trying to close: existing financial RAG systems retrieve snippets per modality but don't really align and synthesize across text, tables, and figures together. That coordinated cross-modal reasoning is where most prior work falls short.

#### Models and Tools Used
- **Table detection:** Detectron2Layout, pre-trained on TableBank.
- **Image/figure detection:** Pdfminer's layout analysis (LTImage/LTFigure).
- **Multimodal summarization:** quantized Gemma3:12B and LLaMA-3.2-11B-Vision-Instruct, run through Ollama.
- **Embeddings:** BAAI/bge-base-en-v1.5 via SentenceTransformer.
- **Approximate retrieval:** FAISS (IVF-PQ index).

Worth noting: quantization cuts Gemma3:12B's 24GB GPU footprint by about 65% while keeping over 90% of its original accuracy, which is what makes single-GPU deployment on commodity hardware realistic for both models.

**Baseline framework** used for comparison: standard RAG with fixed-size non-overlapping text chunks, same bge embeddings + FAISS IVF-PQ, but no multimodal parsing at all. Tables/charts are flattened into raw text or just ignored, no JSON conversion or captioning.

#### Proposed System
Each PDF gets split into three retrievable chunk sets, text, table, and image, all embedded into separate per-modality FAISS indexes. A query triggers tiered retrieval (text-only first, escalating to text+table+image) before a final LLM call generates the answer.
![[Pasted image 20260913132812.png]]

**Semantic Chunking & Indexing**
1. Segment the narrative into sentences.
2. Form overlapping sliding-window blocks (window size 𝑤, overlap 𝑜).
3. Embed each sentence, compute cosine distance between consecutive sentence embeddings, mark any distance above the 95th percentile as a split point.
4. Split blocks at those breakpoints into semantic chunks.
5. Merge any chunk pairs whose cosine similarity is above a high threshold (0.85) to cut down redundancy.
6. Build a FAISS HNSW/IVF-PQ index for sub-second k-NN lookup at scale (|C| > 10⁵).

This chunking + merging step alone cuts total chunks (and tokens sent to the LLM) by roughly 40 to 60%. Lower cost and lower latency without giving up retrieval quality.

**Batch Multimodal Extraction (Algorithm 1)**
- Detected table/figure regions get cropped and batched (batch size 𝐵) into single multimodal prompts, each one listing the exact filenames so the structured output can be matched back to the right image.
- Tables produce (description, JSON) pairs, the description gets embedded and indexed into the table index alongside its JSON.
- Images/charts get a 3 to 6 sentence summary each (explicitly told to ignore non-data visuals like logos/watermarks), embedded into the image index.
- **Coverage guarantee:** if a filename is missing from a batch response (LLM omission or low confidence), a stub gets written and retried as a single-image prompt. Nothing gets silently dropped.![[Pasted image 20260913132921.png]]

**Tiered Retrieval & Decision Function**
Parameters n=6 (minimum text chunks), m=4 (table fallback fetch), p=3 (image fallback fetch), all tuned by trial and error on a holdout set.
1. Text-only retrieval above θtext. If ≥ n hits, answer straight from text.
2. Otherwise fall back to top-m table chunks above θtable.
3. And top-p image summaries above θimage.
4. Combine whatever non-empty sets came back (including each table's JSON + summary) into one final LLM call.

Every LLM call also carries a system prompt telling it to say "insufficient information" instead of hallucinating when the context doesn't support an answer.

**Threshold Calibration**
Swept θtext from 0.55 to 0.85 and (θtable, θimage) from 0.55 to 0.75 on a held-out query set, optimizing a combined context-relevance + accuracy metric under a context-size budget. Final values landed at θtext = 0.70, θtable = 0.65, θimage = 0.55. Makes sense that text has the stricter bar since image/table summaries are noisier and need a lower threshold to even get considered once fallback kicks in.

#### Evaluation Setup
- **Dataset:** financial filings pulled from SEC EDGAR (10-Q, 10-K, 8-K w/ EX-99.1, DEF 14A) via the SEC API, converted to PDF.
- **300 manually written questions** across four tiers:
	1. Text-based (146), straightforward, answerable from narrative text alone.
	2. Image-based (42), requires reading values off charts/graphs (e.g. finding the peak bar in a VaR bar chart).
	3. Table-based (72), requires locating the right row/column in a table.
	4. Text + image/table combined (40), requires resolving a term/entity from text first (e.g. "Lighting department" = "Decor" product line, or "NQDCP" = Non-Qualified Deferred Compensation Plan) then looking the value up in a table.
- Answers are kept to short values/terms and checked so they don't appear verbatim anywhere else in the document, to cut down on ambiguity.
- **Why manual evaluation:** exact-match breaks on unit differences ("1 billion" vs "1,000 million"), BERTScore doesn't make sense for numeric answers, and LLM-as-judge brings in evaluator bias. Manual eval is more work but avoids all three issues.

#### Results
Baseline basically collapses on anything non-text: 0% on image and combined questions, next to 0% on tables too. Confirms that flattening tables/figures into plain text (or skipping them) is a real failure mode, not just a theoretical worry.

- **Text-based (146q):** MultiFinRAG+Gemma3 hits 90.4%, up from 75.3%/76.7% baseline (Llama/Gemma), and 4.1% above ChatGPT-4o (86.3%).
- **Image-based (42q):** MultiFinRAG+Gemma3 gets 66.7% vs ChatGPT-4o's 23.8%, over 40 points higher. Baseline scores 0% on both models.
- **Table-based (72q):** MultiFinRAG+Gemma3 at 69.4% vs ChatGPT-4o's 44.4%, over 25 points higher. Baseline barely clears 5.6%.
- **Text+image/table (40q):** MultiFinRAG+Gemma3 at 40.0% vs ChatGPT-4o's 15.0%. Baseline is 0% on both models here too.
- **Total (300q):** MultiFinRAG+Gemma3 lands at 75.3%, beating ChatGPT-4o's 56.0% by 19.3 points, and well above the 33.3/36.7% baseline.

Gemma3 consistently beats LLaMA-3.2-11B-Vision-Instruct as the multimodal summarizer/generator across every category, sharpest gap on tables (69.4% vs 13.9%). Comes down to Gemma3 producing better table/image descriptions that feed into the retrieval index.

Gap to ChatGPT-4o is smallest on text-only questions (+4.1%) and biggest on image/table questions, exactly where a generic LLM without structured extraction would struggle most. Qualitative failures on both sides point to the same root cause though: ChatGPT-4o sometimes answers from its own background knowledge instead of the actual document (e.g. inventing "$0 million restricted cash" that's nowhere in the filing, but also correctly expanding "NQDCP" purely from prior knowledge in one case). Grounding in the actual document seems to be the real differentiator here, not raw model capability.

**Efficiency & cost:** roughly 25 minutes to process a 200-page/200-table/150-image filing on a free-tier Google Colab T4 GPU (16GB RAM). Both baseline and MultiFinRAG ran on free-tier compute at zero cost, and the >60% token reduction from chunking/merging directly lowers per-query LLM spend too.

#### Discussion & Limitations
They're upfront that this paper only reports end-to-end QA accuracy, retrieval-level metrics (precision/recall of retrieval itself) were collected during development but left out here "due to space constraints," promised for a follow-up paper. That's a gap worth flagging, can't tell from this paper alone how much of the accuracy gain is from better retrieval vs better generation/summarization.

Also all 300 QA pairs were verified by the authors' own team (domain experts), not external annotators or real users. Fine for a first pass but limits how independent the evaluation really is.

**Future work they flag:**
- Module-wise ablations, isolate batch extraction vs tiered fallback contributions separately.
- Structured-data pipeline for large tabular attachments (CSV/Excel) beyond the current JSON+summary stage, normalize into a lightweight DB with an NL query interface.
- Cross-document & longitudinal analysis, unified multi-document index, paired-chunk retrieval (Q1 vs Q2), automated trend narratives.
- Robustness to OCR/layout noise, ensembling OCR/layout engines, consistency checks (row-sum invariants, unit sanity), small fine-tuned correction LLMs.
- Extended domain coverage: S-1 filings, prospectuses, earnings-call transcripts.
- Fine-tuning/domain adaptation, LoRA-based generator customization, contrastive retrieval training.
- Web-article ingestion for real-time multimodal Q&A (headless-browser rendering, DOM table extraction, optionally pre-filtered by the same authors' own FANAL/CANAL news-alerting classifiers, kind of a nice full-circle plug for their own prior work).

#### Conclusion
<font color="#ffc000">The real win isn't a bigger model, it's structured modality-aware extraction (JSON + summary per table/figure) plus a tiered escalation policy. That's what lets a small quantized open-source model beat a much larger proprietary one specifically on the multimodal questions, because it's actually grounded in the parsed table/image content instead of guessing from text alone.</font>

Related notes in this vault worth cross-checking: [[FinanceBench, A New Benchmark for Financial Question Answering]] for the dataset/question-type taxonomy this kind of eval borrows from, and [[Optimizing LLM Based Retrieval Augmented Generation Pipelines in the Financial Domain]] for the same Gemma-beats-smaller-Llama pattern showing up again in a completely different RAG setup.
