FinQA is Chen et al., EMNLP 2021, out of UC Santa Barbara with J.P. Morgan, Penn State and CMU, and it is the paper that turned numerical question answering over real financial reports into a task with a dataset, a domain specific language and a baseline attached. It speaks to exactly one agent in my architecture, <font color="#ffc000">A<sub>F</sub>, the fundamental and retrieval channel</font>, and to the evaluation layer, and to nothing else, so I am reading it as a task specification and prior art rather than as an architectural template for the orchestrator.

It matters more than a benchmark paper normally would, because [[Neo4j Graph-RAG for CSE]] left $A_F$ with one honest place to differentiate, the numbers inside the financial statement tables rather than the entity relationships around them, and that note closed on the observation that tabular financial data was explicitly out of scope there. FinQA is the paper that says what the in-scope version of that task actually is, and its headline result, 61.24% execution accuracy against a human expert upper bound of 91.16%, is the number I should be carrying as my prior on how hard numeric extraction from reports is before any CSE-specific difficulty is added.

> [!info] Execution accuracy and program accuracy
> Execution accuracy asks whether the final number is right. Program accuracy asks whether the generated reasoning program is right, checked by replacing every argument with a symbol and testing whether two symbolic programs are mathematically equivalent, so that `add(a1,a2), add(a3,a4), subtract(#0,#1)` and `add(a2,a1), add(a4,a3), subtract(#0,#1)` count as the same program. The paper is explicit that execution accuracy overestimates, because a model can hit the right answer by chance, and program accuracy produces false negatives, because a question can have several genuinely correct programs the equivalence check does not catch. Reporting both and letting the gap between them stand is the useful part of the design.

#### Gap it's addressing

The claim is that no existing dataset makes a model do multi-step numerical reasoning over heterogeneous real-world financial documents. DROP has discrete reasoning over text but on Wikipedia and with mostly one-step calculation, and the top systems on it use prediction heads specialised per calculation type rather than generating a program. HybridQA spans table and text but is not aimed at numerical reasoning. MathQA and MaWPS do generate solution programs, but from short self-contained word problems with no retrieval step and no document around them. WikiTableQuestions, Spider and TabFact organise numeric information in structured tables without the surrounding narrative. On the finance side the authors point out that financial NLP at the time was largely fraud detection and sentiment classification, with FiQA being opinion-based question answering out of forums and social media rather than reasoning over statements.

So the gap is the intersection: retrieval over a long heterogeneous page, multi-step arithmetic over numbers drawn from both a table and the prose around it, and a fully annotated reasoning program so the result is explainable rather than just scored. That framing is worth keeping because it is the same intersection $A_F$ sits in, and it is a different problem from the one the CSE Graph-RAG work solved.

![[Pasted image 20260925210001.png]]

#### Data and setup

The source is FinTabNet, earnings reports of S&P 500 companies from 1999 to 2019, with tables already annotated. The filtering is aggressive and is the thing to notice: they keep only pages with at most one table, they drop tables with over 20 rows, over 2 description headers, nested structures or catalog-like content, and they merge the two-header cases into a single header. That leaves 12,719 candidate pages, from which 2,789 report pages end up annotated into 8,281 question and answer pairs, split 6,251 train, 883 validation and 1,147 test with no report overlapping between sets.

Annotation was eleven US-based finance professionals, CPAs and MBAs, hired on UpWork, interviewed on four example pages for $30 and then paid $2.00 per question at an average $35.00 per hour, over eight weeks. Each writes a meaningful financial question, composes the reasoning program in at most five operation slots, and marks the supporting text sentences and table rows. They say plainly that MTurk workers could not do this task, and the crowd result later confirms it.

The composition statistics are where the difficulty is hiding, and they are worth scanning as a grid rather than reading as prose:

| | Share |
| --- | --- |
| Questions answerable from table only | 62.43% |
| Questions answerable from text only | 23.42% |
| Questions needing both | 14.15% |
| One supporting fact | 46.30% |
| Two supporting facts | 42.63% |
| More than two | 11.07% |
| One-step programs | 59.10% |
| Two-step programs | 32.71% |
| Three or more steps | 8.19% |

Inputs are short by modern standards, 628.11 tokens of text and 59.42 of table on average, 687.53 combined, with a maximum of 2,679, and questions average 16.63 tokens. Among operations, `divide` dominates at 45.29% and `subtract` follows at 28.20%, which is simply what ratio and change analysis looks like when you write it down.

The DSL is ten operations, six mathematical, `add`, `subtract`, `multiply`, `divide`, `exp`, `greater`, and four table aggregations over a named row, `table-max`, `table-min`, `table-sum`, `table-average`. A program is a flat sequence where later steps reference earlier results by position:

$$\text{op}_1[\textbf{args}_1],\ \text{op}_2[\textbf{args}_2],\ \dots,\ \text{op}_n[\textbf{args}_n]$$

where each argument is a number from the report, a table row name, or the special token $\#k$ denoting the result of step $k$. The task is then to generate that program and execute it, with the answer probability marginalised over all programs that reach it:

$$P(A \mid T, E, Q) = \sum_i P(G_i \mid T, E, Q)$$

where:
- $T$ is the structured table on the page, $E$ the unstructured text, $Q$ the question
- $G_i$ ranges over the set of correct programs evaluating to $A$
- the sum is the formal statement of why program accuracy undercounts, since several $G_i$ are valid and the metric scores against one

#### Model architecture and training

FinQANet is deliberately a two-stage retriever-generator rather than an end-to-end long-document model. The retriever turns every table row into a sentence through a template, so the last row of the example page becomes 'the risk-free interest rate of 2006 is 5%', concatenates each candidate fact with the question, and trains a BERT-base classifier over them, keeping the top three ranked facts reordered into document order. They tried a sliding window over the report instead and report that it falls well behind, and they note that longer inputs to the second stage lower generator performance, which is why the cutoff is three.

The program generator is an LSTM decoder over a copy-and-generate output space built from three sources, the numbers and row names in the retrieved input, the DSL special tokens, and step memory tokens $\{m_i\}$ standing for $\#0$, $\#1$ and so on. At decoding step $T$ it computes attention over the input and over the decoding history, forms a context vector, and scores every candidate token:

$$c_T = W_c[att_p; att_h; h_T], \qquad w_T = \text{softmax}(H'_T \cdot c_T)$$

where $H'_T = W_h[H; H \circ att'_p]$ is the token embedding matrix reweighted by a second attention over the input, and $h_T$ is the decoder state. The piece that is actually novel here is small and mechanical: at the end of each completed `operation[args]` unit, the embedding of the corresponding step memory token is overwritten with that step's context vector, so a reference to $\#0$ later in the sequence carries what step 0 did rather than being an opaque symbol. Grammar masks at each decoding step keep the output structurally valid.

![[Pasted image 20260925210002.png]]

Encoders tested are BERT base and large, RoBERTa base and large, and FinBert, all with Adam, batch 32 for the base models and 16 for the large ones under GPU memory constraints, on TITAN RTX hardware.

#### Findings

- **The best system reaches 61.24% execution and 58.86% program accuracy, against 91.16% and 87.49% for finance professionals and 50.68% and 48.17% for the MTurk crowd.** So the model clears the non-expert human and sits thirty points below the expert, and the two humans who validated the sample agreed with each other 92.65% of the time on execution, which makes the expert bar a real one rather than an annotation artefact. Giving the model gold retrieval instead of its own lifts it to 70.00% and 68.76%, so roughly nine points of the thirty-point gap is retrieval and the remaining twenty-one is reasoning.

- **The program is load-bearing, not decoration.** Keeping the architecture identical but generating the answer directly instead of the program collapses execution accuracy to 0.30%, an end-to-end pre-trained Longformer over the whole report gets 21.90%, and a retriever plus Seq2seq generator gets 19.71%. Against NeRd, which generates the same programs in nested form without step memory tokens, FinQANet at BERT-base is 50.00% versus 48.57%, a much smaller margin, so on this evidence the large gains come from generating a program at all and only a modest part from the step memory structure.

- **Both sources are needed and the questions that need both are the hardest.** Restricting inference to table facts gives 45.81% and to text facts 15.80%, both far below the 61.24% full result. But on the question types, table-only questions score 67.38%, text-only 54.86%, and the questions requiring table and text together score 43.80%, which is the lowest of the three despite being only 14.15% of the data.

![[Pasted image 20260925210004.png]]

- **Accuracy falls off a cliff past two steps.** One-step programs score 67.61%, two-step 59.08%, and programs of three or more steps 22.78%. Programs containing a constant, typically a unit conversion like multiplying by 1,000 to put billions and millions on the same scale, or an implicit denominator like 3 for a three-year average, score 43.88%. Since three-or-more-step programs are only 8.19% of the data, this is a weakness the headline number mostly hides.

- **Retrieval is good enough that it is not the binding constraint.** The BERT retriever recalls 89.66% of gold facts in its top three and 93.63% in its top five, against 82.91% at top five for TF-IDF, and only 15% of the fifty manually inspected error cases are retriever failures. Of the rest, the authors split them roughly evenly between missing financial knowledge, knowing that drawn credit lines are committed minus available for instance, and numerical reasoning failures involving step count, unit conversion or matching numbers to the right year.

- **Domain-specific pretraining did not pay here.** FinQANet with FinBert scores 50.10%, essentially level with BERT-base at 50.00% and below BERT-large at 53.52%, with RoBERTa-large well ahead at 61.24%. The authors attribute this to FinBert's pretraining corpus being about 30M words of news articles, so on this task corpus scale beat domain match, which is a useful prior against reaching for a finance-tuned encoder reflexively.

![[Pasted image 20260925210003.png]]

#### Limitations

- **The filtering removes exactly the layouts that make real reports hard.** At most one table per page, no more than 20 rows, no nested structures, no more than two description headers, catalogs excluded, multi-header tables flattened. The paper is upfront that this is a first step and that complicated layouts are out of scope, but it means 61.24% is accuracy on a sanitised slice of already-well-structured US filings, and I should not read it as accuracy on annual report PDFs as they arrive.

- **Every question is page-local, so the retrieval problem is much shallower than the one a fundamental channel faces.** Inputs average 687.53 tokens and peak at 2,679, one page, one table, and the annotator wrote the question by looking at that page. Nothing crosses documents, nothing crosses filings, and there is no as-of or publication-date notion anywhere in the task, so a system that scores well here has not demonstrated anything about finding the right page in a 200-page report, reconciling restated figures, or retrieving point-in-time.

- **The DSL bounds what counts as a question.** Ten operations, a maximum of five annotation slots, no conditionals, no date arithmetic, no unit-aware types, and constants smuggled in as bare numbers. The unit conversion errors in the error analysis are a symptom of that last choice rather than a model failure: if the representation had carried units, the million-to-billion mismatch would have been a type error instead of a reasoning one. Questions a finance professional could not express in this DSL simply never entered the dataset, which makes the coverage claim circular in a way the paper does not discuss.

- **Both metrics are known to be biased and neither carries an interval.** The authors say execution accuracy overestimates and program accuracy produces false negatives, which is honest, but they then report point estimates from single runs with no seed variance, no confidence intervals and no significance testing between adjacent configurations. FinQANet at RoBERTa-base is 56.10% and at RoBERTa-large 61.24%, and I have no way of knowing from the paper how much of a five-point difference is noise.

- **The human upper bound rests on 200 examples and the question distribution is annotator-driven.** Two professionals answered a 200-question sample to produce the 91.16% figure, which is a reasonable sample for a bracket but thin for a headline comparison, and their 86.76% agreement on programs says even experts disagree on how to compute an answer about one time in seven. More importantly, the questions are what a finance professional thought was interesting about one page, which is not the same distribution as the quantities a trading system needs computed, and nothing in the paper argues that it is.

#### Why this matters for my project

- **This is the task specification for the numeric half of $A_F$, and the pair with the CSE Graph-RAG paper draws the boundary cleanly.** That paper builds the entity graph and states that statement tables are future work; this one does the statement tables and ignores entity structure. In the review chapter that pairing is how I justify $A_F$ as a system component built on published task definitions, with the contribution sitting in the orchestration rather than in the retrieval.

- **The retrieve-then-program design is the first concrete answer I have to how $C_{F,t}$ gets computed.** A program is checkable in ways free text is not: whether it parses under the grammar, whether every argument traces to a retrieved number or row rather than being invented, how many retries the retriever needed, and how many steps the program has. That last one is a calibrated difficulty proxy on this evidence, since accuracy runs 67.61%, 59.08% and 22.78% across one, two and three-plus steps, so step count is a feature the orchestrator can read without asking the model how sure it is. This pushes the standing open question about comparable confidence forward for one of the four producers, and it is a different mechanism from the Cypher-validation signal in the Graph-RAG note, which is useful because two mechanical signals on the same channel can be cross-checked.

- **It also settles what $A_F$ should emit for the attribution layer.** The re-scoped explainability plan is RAG citation tracing plus SHAP over risk features plus interpretable volatility parameters plus the weight vector, and an executable program with arguments pointing at specific retrieved rows fits that plan better than a natural-language rationale, because it can be re-executed and checked rather than read and believed.

- **Keep $A_F$'s output vocabulary to one and two-step quantities and say so as a design decision rather than a limitation.** Gross margin, operating margin, return on equity, year-on-year growth, debt to equity, are each one `divide` or one `subtract` feeding one `divide`, which is where this paper's accuracy sits at 67.61% and 59.08%. Anything needing three or more chained operations lands in the 22.78% band, and the honest move is to not ask the channel for those at all rather than to ask and then discover the error rate in the backtest.

- **Expect CSE performance below FinQA's headline, because the hardest class here is over-represented there.** Table-text questions score 43.80%, the worst of the three, and Sri Lankan annual reports lean heavily on narrative that restates and qualifies the statement figures, so the proportion of quantities that need a number from the table reconciled with a sentence from the prose is higher than the 14.15% in this dataset. Combined with the layout filtering, I should set expectations for $A_F$ nearer 40% than 60% on first build and design the orchestrator to tolerate a channel that is wrong a lot.

- **Do not default to a finance-pretrained encoder.** FinBert at 50.10% against BERT-large at 53.52% and RoBERTa-large at 61.24% is one dataset and one task, so I will not generalise it, but it is enough to stop me assuming a finance-domain model is the obvious choice for $A_F$ and to make me benchmark against a general model of similar or larger scale before committing.

- **There is no CSE equivalent of this dataset and building one is out of scope, so $A_F$'s evaluation has to be designed around that absence.** Eight weeks of eleven CPAs at $2.00 per question is not available to me, and the FinTabNet licensing and the annotations do not transfer to CSE filings. What does transfer at low cost is the shape of the evaluation: a small hand-checked probe set over a handful of CSE annual reports, scored under the correct, incorrect and failure-to-answer taxonomy already in the plan, reported with both a did-it-get-the-number and a did-it-get-the-computation metric, and bracketed by my own answers and a second reader's so the numbers have a ceiling and a floor around them. Ten to twenty questions done properly is worth more here than a large set scored automatically against nothing.

> [!WARNING]
> 61.24% is not a portable number. It is execution accuracy on single-table pages of S&P 500 filings with questions written by the same people who wrote the programs, single run, no interval. Cite it as the order of magnitude of the task's difficulty and as the size of the gap to expert humans, and do not let it become a target or a baseline for anything I build on CSE reports.

> [!NOTE]
> Dataset and code are public at github.com/czyssrs/FinQA, built over FinTabNet under CDLA-Permissive, with the annotation interface built on Turkle. Worth pulling the DSL and the program executor directly rather than reimplementing, and worth checking whether the retriever's row-to-sentence templating survives contact with CSE table formatting before assuming it does.
