TAT-QA is Zhu et al., ACL-IJCNLP 2021, out of the National University of Singapore with 6Estates, Sichuan University and Bloomberg, and it is the sibling paper to [[FinQA, A Dataset of Numerical Reasoning over Financial Data]], published the same year on almost the same problem with a materially different set of design choices. Like FinQA it speaks to <font color="#ffc000">A<sub>F</sub>, the fundamental and retrieval channel</font>, and to the evaluation layer, and to nothing else, so I am reading it as prior art on the task rather than as an architectural template for the orchestrator.

The reason it earns its own note rather than a paragraph appended to the FinQA one is that the two papers disagree, and the places they disagree are exactly the places where I have a design decision to make for $A_F$. FinQA generates an executable program over a ten-operation DSL and retrieves before it reasons. TAT-QA tags evidence in place, applies exactly one of ten aggregation operators, and is handed the relevant page rather than finding it. FinQA flattens multi-header tables and caps them at 20 rows; TAT-QA deliberately keeps the messy structure and reports that <font color="#ffc000">79% of its tables have two or more row headers</font>. And TAT-QA adds one thing FinQA has no equivalent of at all, a <font color="#ffff00">scale prediction head</font>, which turns out to be the single most directly transferable idea in the paper for CSE filings.

> [!info] Hybrid context, and scale
> A *hybrid context* in TAT-QA is one table plus at least two surrounding paragraphs that describe, analyse or complement it, which is a much tighter coupling than HybridQA's hyperlinks from table cells to Wiki pages. *Scale* is the magnitude a number carries but usually does not state, thousand, million, billion or percent, typically declared once in a table header or a paragraph and then omitted from every cell beneath it. TAT-QA treats predicting it as part of getting the answer right, so "0.22" and "0.22 million" are different answers, and the model has a dedicated classifier for it.

#### Gap it's addressing

The claim is that QA over hybrid data, where a numeric table and the prose around it are semantically interdependent, is largely neglected. Textual QA covers SQuAD-style reading comprehension and DROP's discrete reasoning; KB and tabular QA cover Freebase, WikiTableQuestions and Spider; HybridQA is the one existing hybrid dataset but its table-to-text connection runs through manually inserted hyperlinks to Wikipedia pages, which the authors describe as relatively loose. Real financial reports are not like that, the paragraph beneath a revenue table restates, disaggregates and qualifies the figures in it, and answering a useful question often needs a number from the table reconciled against a sentence from the prose.

So the gap is the intersection of three things: genuine hybrid context rather than linked context, numerical reasoning over it, and enough annotated derivation that the reasoning can be checked rather than only scored. That is close to FinQA's framing, and the two papers cite the same absence, but TAT-QA's version is broader in what it admits as a question and narrower in what it admits as a computation, which is the trade I want to look at carefully.

![[Pasted image 20260925220001.png]]

The right-hand panel is effectively the dataset's specification, eight reasoning types with their shares and the derivation that produces each answer. Word Matching at 38.06% and Set of spans at 11.94% need no arithmetic at all, which is half the dataset before any numerical reasoning is required, while Composition at 19.69% and Subtraction at 16.17% carry most of the difficulty.

#### Data and setup

Roughly 500 financial reports from the past two years are downloaded from annualreports.com, tables are detected with the TableBank model of Li et al. (2019) and extracted with Apache PDFBox, and tables outside 3 to 30 rows and 3 to 6 columns are dropped, leaving about 20,000 candidates. Around 30 university students majoring in finance or a similar discipline annotate, hired only after scoring 95% on a screening test, working at about two hybrid contexts per hour over three months. Every annotation goes through two-round validation by five verifiers, one checking and returning it for fixes, a different one approving afterwards. <font color="#ffc000">About two thirds of the candidate tables are discarded</font> during annotation for lacking enough relevant surrounding paragraphs.

The result is 16,552 question-answer pairs over 2,757 hybrid contexts from 182 reports, split by context so no context spans two splits: 2,201 contexts and 13,215 questions in train, 278 and 1,668 in dev, 278 and 1,669 in test. Tables average 9.4 rows and 4.0 columns with 4.8 associated paragraphs of 43.6 words each, questions average 12.5 words and answers 4.1.

The distribution that actually matters is answer type against answer source, because it is the axis the results are later broken down on and the one I want to borrow for my own evaluation:

| | Table | Text | Table-text | Total |
| --- | --- | --- | --- | --- |
| Span | 1,801 | 3,496 | 1,842 | 7,139 |
| Spans | 777 | 258 | 1,037 | 2,072 |
| Counting | 106 | 5 | 266 | 377 |
| Arithmetic | 4,747 | 143 | 2,074 | 6,964 |
| Total | 7,431 | 3,902 | 5,219 | 16,552 |

Two things jump out. Arithmetic is 42% of the dataset and it is overwhelmingly table-sourced, 4,747 of 6,964, which is what you would expect since the numbers live in the table. And the table-text class, the one that needs both sources, is 5,219 questions or 31.5%, against 14.15% in FinQA, so TAT-QA is substantially heavier on exactly the class both papers find hardest.

A direct comparison of the two datasets is the most useful single artefact I can take from this note, because the design choices are visibly different and I have to pick from them:

| | FinQA | TAT-QA |
| --- | --- | --- |
| Questions | 8,281 | 16,552 |
| Contexts | 2,789 pages | 2,757 hybrid contexts |
| Source | FinTabNet, S&P 500, 1999 to 2019 | annualreports.com, two-year window |
| Annotators | 11 finance professionals, paid per question | ~30 finance undergraduates, screened at 95% |
| Table structure | Capped at 20 rows, headers merged to one | 3 to 30 rows, 79% have 2+ row headers |
| Retrieval | Trained retriever over facts, top-3 | None, hybrid context given |
| Reasoning output | Executable program, up to 5 steps | One operator from a fixed set of 10 |
| Scale handling | Not modelled, constants smuggled in | Dedicated 5-class classifier |
| Needs both sources | 14.15% | 31.5% |
| Best model vs human | 61.24% vs 91.16% exec acc | 58.0 vs 90.8 F<sub>1</sub> |

#### Model architecture and training

TagOp is deliberately not a program generator. The question, the table flattened row by row, and the paragraphs are concatenated and fed to RoBERTa, every sub-token is independently tagged Inside or Outside, and cells or spans whose sub-tokens are tagged I become the supporting evidence. One aggregation operator is then selected and applied to that evidence to produce the answer, and a scale is predicted separately and attached.

![[Pasted image 20260925220002.png]]

The ten operators are Span-in-text, Cell-in-table, Spans, Sum, Count, Average, Multiplication, Division, Difference and Change ratio, the last being the growth-rate calculation over the top two ranked numbers. <font color="#ff0000">Exactly one operator is applied per question</font>, so there is no composition in the FinQA sense, and what TAT-QA calls a Composition question is handled by having pre-built a Change ratio operator that performs the two-step calculation internally.

Three of the four heads are worth writing down. For the operators where argument order changes the result, Difference, Division and Change ratio, a separate classifier decides whether to use the two top-ranked numbers in input order or reversed:

$$\mathbf{p}^{\text{order}} = \text{softmax}(\text{FFN}(\text{avg}(h_{t1}, h_{t2})))$$

where $h_{t1}$ and $h_{t2}$ are the representations of the two highest-probability tagged tokens, each token's probability being the maximum over its sub-tokens and its representation the average over them. This is a small mechanical patch rather than a modelling idea, and it exists only because the operator set is fixed and cannot express operand order itself, which is a cost of the design choice rather than a feature of it.

Scale is a five-way classification over None, Thousand, Million, Billion and Percent, taken from the concatenation of the sentinel token with pooled table and paragraph representations:

$$\mathbf{p}^{\text{scale}} = \text{softmax}(\text{FFN}([[\texttt{CLS}]; h_{tab}; h_p]))$$

where:
- $h_{tab}$ is the average-pooled representation over the flattened table's tokens
- $h_p$ is the average-pooled representation over the paragraph tokens
- ";" denotes concatenation, and the predicted numeric or string answer is then multiplied or concatenated with the predicted scale before being compared against ground truth

Training is a plain sum of four negative log-likelihoods, one per head, which is the compact statement of the whole architecture:

$$\mathcal{L} = \text{NLL}(\log(\mathbf{P}^{\text{tag}}), \mathbf{G}^{\text{tag}}) + \text{NLL}(\log(\mathbf{P}^{\text{op}}), \mathbf{G}^{\text{op}}) + \text{NLL}(\log(\mathbf{P}^{\text{scale}}), \mathbf{G}^{\text{scale}}) + \text{NLL}(\log(\mathbf{P}^{\text{order}}), \mathbf{G}^{\text{order}})$$

where the order term is supervised only when the ground-truth operator is one of the three order-sensitive ones, and where only the first occurrence of an evidence string is kept when it appears more than once in the hybrid context, which is a simplification the paper notes without examining.

Evaluation is Exact Match and the numeracy-focused F<sub>1</sub> from DROP, with two modifications the authors are right to make: the sign of a value is preserved rather than dropped, since a negative in a financial statement means something, and F<sub>1</sub> is set to zero unless the predicted number multiplied by the predicted scale matches exactly, so scale errors are not partially credited.

#### Findings

- **TagOp reaches 50.1 EM and 58.0 F<sub>1</sub> on test against human performance of 84.1 and 90.8, so the model sits roughly 33 F<sub>1</sub> points below the expert bar.** The 11.1-point F<sub>1</sub> headline is over NumNet+ V2 at 46.9, and the collapse of the other baselines is the more informative part: TaPas for WTQ, a table-native model, manages 22.8 and HyBrider, the model built for HybridQA, manages 7.5. The reading I take is that models specialised to one modality do not transfer to genuinely coupled hybrid context, which supports the dataset's premise, though it is also partly an artefact of adapting baselines to a task they were not designed for, and the paper says as much about HyBrider.

![[Pasted image 20260925220003.png]]

- **84% of errors are evidence extraction failures, not reasoning failures, which is close to the inverse of FinQA's error profile.** Over 100 sampled test errors, Wrong Evidence is 55% and Missing Evidence 29%, against Wrong Calculation 9%, Unsupported Calculation 4% and Scale Error 3%. FinQA's dedicated retriever recalled 89.66% of gold facts in its top three and accounted for only about 15% of its errors. On this evidence the tagging-in-place design is where TagOp loses, and the comparison across the two papers is the strongest argument I have seen for separating retrieval from reasoning rather than folding both into one tagged sequence.

![[Pasted image 20260925220004.png]]

- **Arithmetic is the floor, at 42.5 EM and 42.5 F<sub>1</sub> against 54.1/67.9 on Span, 60.0/75.1 on Spans and 62.5/62.5 on Counting.** The operator ablation agrees about where the value is: adding Difference lifts test EM by 5.9 points and Change ratio by another 5.0, the two largest single-operator gains in the whole table, while Sum adds nothing and Multiplication is flat to slightly negative. The authors attribute the latter to those instances being rare enough in the test set to be noise, which is fair, and it also means the ten-operator inventory is carrying roughly four operators' worth of measurable weight.

- **The table versus text comparison depends on which metric you read, and the paper only reports one side of it.** Table-sourced questions score 47.8 EM against text-sourced at 43.3, which is the basis for the claim that cells have clearer boundaries than text spans, but on F<sub>1</sub> the ordering reverses sharply, 49.3 for table against 68.7 for text. The reconciliation is that text questions are mostly Span and Spans where partial credit is available, while table questions are mostly Arithmetic where a number is right or it is not, so the EM-versus-F<sub>1</sub> gap is measuring answer type as much as answer source. The best-performing source is actually table-text at 58.3 EM, which cuts against the intuition that needing both should be hardest, and the paper does not comment on this.

- **Scale prediction works well and costs almost nothing.** Per-class test accuracy is 90.1 on None, 95.3 on Thousand, 90.2 on Million and 95.9 on Percent, and scale contributes only 3% of sampled errors. That said, None is 50.3% of the test set and Billion has too few instances to report, so this is a four-way problem with a majority class in practice, and the 90%+ figures should be read as "a shallow classifier over pooled representations is enough for this", not as evidence that scale is solved in general.

- **The operator classifier fails completely on its rare classes, which is a calibration warning rather than an accuracy one.** Test accuracy is 100.0 on Count and Average and 96.6 on Difference, but 0.0 on Multiplication and 0.0 on the catch-all Other, which together are 6.7% of test questions. A classifier that is perfect on some classes and never correct on others cannot have its posterior read as a single confidence number, and the paper reports the per-class breakdown only in an appendix table.

#### Limitations

- **There is no retrieval step at all, so the task is strictly shallower than the one $A_F$ faces.** The hybrid context is handed to the model already located, already paired with its paragraphs and already verified as coherent, and two thirds of candidate tables were discarded precisely because they lacked that coherence. FinQA at least had to rank facts within a page. Nothing here crosses a document, crosses a filing year, or involves finding the right page in a 200-page annual report, and there is no as-of or publication-date notion anywhere in the task.

- **One operator per question makes the compositionality claim circular.** Composition is 19.69% of reasoning types, but it is handled by having anticipated it and built a Change ratio operator, so the dataset contains the compositions the operator set can express and no others. The honest description is that TAT-QA covers eight reasoning patterns well rather than that it covers compositional numerical reasoning, and the Other class sitting at 6.6% of test with 0.0% operator accuracy is what the boundary of that coverage looks like when it shows up in the results. FinQA's flat program with step references is the more general representation on this comparison, and it pays for that generality with a sharp accuracy drop past two steps.

- **The question distribution is shaped by the annotation instructions in ways that inflate the easy classes.** Annotators are explicitly encouraged to write questions answerable without much finance knowledge and to reuse common words from the hybrid context, which is a reasonable choice for annotation throughput and is almost certainly why Word Matching is 38.06% of the dataset. Those are questions a keyword search would substantially handle, and they sit in the same headline number as the arithmetic ones. The annotators also authored the derivations, so the operator inventory was fitted to the questions and the questions written within the tool, the same circularity FinQA has and neither paper discusses.

- **Every number is a single-run point estimate with no interval, no seed variance and no significance test.** TagOp at 58.0 F<sub>1</sub> against NumNet+ V2 at 46.9 is a wide enough margin that I am not worried about it, but the per-class and per-operator breakdowns that I actually want to reason from, the 5.9-point Difference gain or the 42.5 on Arithmetic, carry no uncertainty at all, and the operator ablation is cumulative rather than leave-one-out so the individual contributions are confounded with ordering.

- **Domain knowledge is named as an error source and then left unquantified.** The gross profit margin example is a good one, the model has to know the formula is gross profit over revenue before any extraction or arithmetic helps, and the authors say integrating such knowledge needs further exploration. But this sits outside the five-way error taxonomy, so I cannot tell from the paper what share of the 55% Wrong Evidence bucket is actually a knowledge failure being recorded as an extraction failure, and for CSE reports with local accounting conventions I would expect that share to be larger rather than smaller.

- **The upstream extraction pipeline is asserted to work rather than measured.** Tables are detected by a model and extracted by PDFBox, errors are said to be caught manually during annotation, and tables outside 3 to 30 rows and 3 to 6 columns never enter. The dataset is therefore conditioned on the extractor having succeeded, with no reported figure for how often it did not, so nothing here informs me about the step most likely to break first on CSE filings.

#### Why this matters for my project

- **Scale prediction is the most directly transferable idea here, and it matters more for the CSE than it did for the source data.** Sri Lankan annual reports declare magnitude once in a header, "Rs. '000" or "Rs. Mn", sometimes switch between statements within the same report, and occasionally carry a second currency column. A numeric answer from $A_F$ that is not carried alongside an explicit scale is not a usable quantity, and the fix is cheap on this evidence, a shallow head over pooled representations reaching 90.1% to 95.9% per class. The design decision is that <font color="#ffff00">A<sub>F</sub> emits a typed quantity, value plus scale plus currency plus period</font>, and never a bare number, which also removes the unit-conversion error class that the FinQA note flagged as a representation problem rather than a model one.

- **Between the two papers, retrieve-then-reason is better supported than tag-in-place, so $A_F$ keeps a retrieval stage.** 84% of TagOp's errors are evidence extraction against roughly 15% for FinQA's retriever, and while the two are not measured on the same data so this is not a controlled comparison, the direction is consistent and the mechanism is intuitive: a tagger asked to find evidence and a reasoner asked to use it are competing for the same encoder. This also keeps $A_F$ compatible with the structure-aware retrieval work in [[Neo4j Graph-RAG for CSE]] and [[Financial Report Chunking for Effective Retrieval Augmented Generation]], which a single-sequence tagging design would not be.

- **Choose the operator vocabulary from what the orchestrator needs, not from what annotators happened to write, and keep it closed.** Difference and Change ratio contributed 5.9 and 5.0 EM points, the two largest gains in the ablation, and those are year-on-year change and growth rate, which is most of what a fundamental channel is asked for. Sum and Multiplication contributed nothing measurable here. Combined with the FinQA note's conclusion that one and two-step quantities are the reliable band, the working decision for $A_F$ is a short closed vocabulary covering level, difference, ratio and growth rate, with anything outside it declined rather than attempted.

- **This gives me a second mechanical confidence signal for $C_{F,t}$, and a warning about how to use it.** FinQA offered program step count; TAT-QA offers the operator classifier posterior, the tagging margin on the selected evidence, and whether the predicted scale fell in a rare class. But operator accuracy runs from 100.0 on Count and Average down to 0.0 on Multiplication and Other, so a single posterior is not comparable across classes and I would need per-operator reliability estimated on my own probe set before the orchestrator can read it. That is a concrete, small piece of the standing open question about making confidence comparable across four heterogeneous producers, and it is the second time the answer for $A_F$ has turned out to be a structural property of the output rather than a self-reported score, which is worth noting as a pattern.

- **Row-header hierarchy has to survive whatever $A_F$ uses to read a statement.** 79% of TAT-QA's tables have two or more row headers, TagOp flattens the table row by row into a token sequence, and table-sourced questions score 47.8 EM, the lowest of the three sources on that metric. I cannot attribute the one to the other from this paper since it reports no ablation on flattening, so I am recording it as a hypothesis rather than a finding, but CSE statements have the same nested line-item structure and often deeper, and the cautious design is a structured extraction step that preserves the hierarchy rather than a flattened string handed to an encoder.

- **Expect the CSE version of this task to be harder than either paper's headline suggests, and design the orchestrator for a channel that is frequently wrong.** Arithmetic sits at 42.5 here and FinQA's table-text class at 43.80, two independent datasets putting the hard class in the low 40s on clean English filings with the relevant page already located. TAT-QA also carries 31.5% table-text against FinQA's 14.15%, and CSE annual reports lean heavily on narrative restating and qualifying statement figures, so that proportion is higher again. This is a replication of what the FinQA note already concluded rather than new information, which is itself useful, the sub-50% expectation for $A_F$ on computed quantities is now supported twice.

- **Borrow TAT-QA's reporting axes and its verification design for the $A_F$ probe set, and do not attempt to borrow its scale.** Three months, 30 screened annotators, five verifiers and 16,552 questions is not available to me, same conclusion as FinQA's eleven CPAs. What transfers at low cost is the answer-source split as the reporting axis, table only against text only against both, since both papers show the classes behave differently and the both class is the CSE majority case, and the two-round validation pattern of one checker then a different approver, which is affordable at ten to twenty questions. I should also report EM and F<sub>1</sub> side by side rather than picking one, because this paper is a clean example of the two disagreeing on direction, 43.3 against 68.7 on text-sourced questions, and a single metric would have hidden that the disagreement is about answer type rather than source.

> [!WARNING]
> 58.0 F<sub>1</sub> is not a portable number and is not comparable to FinQA's 61.24% execution accuracy despite looking similar. Different metric, different task formulation, different table filtering, and TAT-QA hands the model the page while FinQA makes it retrieve. Cite them together as two independent estimates that hybrid financial QA sits roughly 30 points below expert humans, and do not construct a ranking between them.

> [!NOTE]
> Dataset is public for non-commercial use at nextplusplus.github.io/TAT-QA. The scale taxonomy and the answer-type and answer-source split are worth lifting directly into my probe set design. The TagOp code is worth reading for the scale head specifically, and less so for the rest, given the evidence-extraction failure rate.
