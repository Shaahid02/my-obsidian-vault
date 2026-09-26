ConvFinQA is Chen et al., EMNLP 2022, the same UC Santa Barbara and J.P. Morgan group that produced [[FinQA, A Dataset of Numerical Reasoning over Financial Data]] a year earlier, and it is best read as the sequel to that paper rather than as a standalone dataset, because the conversations in it are literally FinQA's multi-hop questions taken apart and reassembled turn by turn. Like FinQA and [[TAT-QA, A Question Answering Benchmark on a Hybrid of Tabular and Textual Content in Finance]] it speaks to <font color="#ffc000">A<sub>F</sub>, the fundamental and retrieval channel</font>, and to the evaluation layer, and to nothing else, so I am reading it as prior art on the task rather than as an architectural template for the orchestrator.

It earns its own note for one reason, which is that it is the only paper of the three that tests what happens when the same reasoner is asked a *sequence* of dependent questions over one report, and that is the shape my orchestrator will actually use if it interrogates $A_F$ more than once per decision. The answer it gives is discouraging in a specific and useful way: the best model reaches 68.90% execution accuracy overall but 52.38% on the part of a conversation that switches to a new aspect of the report while still referring back, and 34.38% by the sixth turn, and the authors state plainly that once a turn is predicted wrong there is very little chance the turns after it are right. That is an error-propagation result, and it is the thing I want from this paper.

> [!info] Dependency distance
> The paper's measure of how much conversational history a question needs, defined as how many previous questions must be seen to answer the current one, counted by expert annotators over a 200-turn sample. Distance 0 means the question stands alone. The distribution runs 39.5% at 0, 28.0% at 1, 19.0% at 2, 12.5% at 3 and 1.0% beyond 4, so just over 60% of questions carry a dependency and the long tail is thin. Execution accuracy and program accuracy are unchanged from FinQA and are defined in that note.

![[Pasted image 20260926150001.png]]

#### Gap it's addressing

The claim is a gap at the intersection of two literatures that had not met. Conversational QA existed in SQA, CSQA, CoQA and QuAC, but those target table navigation, knowledge-graph reasoning, co-reference and open-ended exploration respectively, all in the general domain. Numerical reasoning QA existed in DROP, MathQA, FinQA and TAT-QA, but every one of them is single-turn, so the reasoning chain lives inside one question rather than across several. ConvFinQA is positioned as the first dataset where the chain of numerical reasoning runs *through* the conversation, in a domain where sequential questioning is how the work is actually done, an analyst pulling a figure, then another, then a difference, then the same difference for the prior year.

There is a second framing underneath the dataset one that the introduction is explicit about and that I find the more interesting of the two: whether complex reasoning is better solved by specialised neural symbolic architectures trained on full data or by prompting a sufficiently large pre-trained model, and the paper sets out to test both on the same task rather than to advocate for either. That is a fair question to ask in 2022 and the paper's answer is unambiguous on its own evidence, though it is scoped to one model and shallow prompting in a way I have to respect.

The framing I am less convinced by is that the dataset represents natural conversation. The conversational flow is simulated from reasoning programs and then written up by annotators, so naturalness here is a property of the rewriting rather than an observation of how analysts actually query reports, and no real dialogue was collected to compare against. I will take that up in limitations rather than relitigating it as I go.

#### Data and setup

Construction is two stages. First, <font color="#ffff00">conversational QA flow simulation</font> produces a skeleton where every turn carries reasoning semantics but no text. For a Type I simple conversation, one FinQA multi-hop question's program is decomposed so each operation becomes one turn, and a number-selection turn is randomly inserted before any turn that introduces a new number from the report, which models the questioner reading a value off the page before computing with it. For a Type II hybrid conversation, two FinQA questions over the same report are each decomposed that way and the two skeletons are concatenated, which models a questioner moving to a second aspect of the same filing. Second, <font color="#ffff00">question composition</font> hands the skeleton and the report to expert annotators recruited on UpWork with CPA or MBA backgrounds, who write the text of each turn, and who are explicitly instructed to identify redundancy, compress unnecessary turns using references to earlier context, and discard the example outright if no natural conversation can be written over the skeleton.

![[Pasted image 20260926150002.png]]

The skip-and-reference instruction is the part carrying the weight, because it is what turns a mechanical decomposition into something with genuine anaphora in it, and it is also why the hybrid conversations end up harder than the simple ones rather than just longer.

The resulting statistics, with the ones I care about pulled out:

| | Value |
| --- | --- |
| Conversations / questions | 3,892 / 14,115 |
| Train / dev / test conversations | 3,037 / 421 / 434 |
| Simple / hybrid conversations | 2,715 / 1,177 |
| Report pages | 2,066 |
| Avg questions per conversation | 3.67 |
| Avg question length | 10.59 tokens |
| Avg / max input tokens (text and table) | 675.61 / 2,338 |
| Number selection questions | 34.73% |
| 1-step / 2-step / 3-step programs | 35.10% / 25.41% / 4.75% |
| Supporting facts from table / text / both | 59.18% / 25.56% / 15.26% |

The operation mix is 40.49% subtract, 33.43% divide, 18.80% add and 6.92% multiply, which is the same change-and-ratio shape FinQA showed with the two leaders swapped, and the DSL is <font color="#ffc000">six operations only</font>, add, subtract, multiply, divide, exp and greater, with FinQA's four table aggregations dropped. So the reasoning here is longer in turns but narrower in operations than its parent dataset, which is worth holding onto when comparing the headline numbers.

Human bounds come from a 200-question sample. Two expert annotators reach 89.44% execution and 86.34% program accuracy with agreement above 85% on both metrics, while MTurk workers reach 46.90% and 45.52% with agreement below 60%, the same expert-versus-crowd gap FinQA reported and the same argument that the task needs domain expertise rather than care. Annotators were paid around $4.00 per simple conversation and $7.00 per hybrid one, at an average $60.00 per hour.

The task is formally the same as FinQA's with the conversation history added to the conditioning set:

$$P(A \mid T, B, Q_n) = \sum_i P(G_i \mid T, B, Q_0, Q_1, \dots, Q_{n-1})$$

where:
- $T$ is the report text, $B$ the structured table, $Q_n$ the current question
- $G_i$ ranges over the programs that evaluate to the answer $A$, so the sum is again why program accuracy undercounts
- the whole prior question sequence $Q_0 \dots Q_{n-1}$ enters the conditioning set, and the entire difficulty of the paper lives in that one addition

Programs remain a flat sequence $\text{op}_1[\textbf{args}_1], \dots, \text{op}_n[\textbf{args}_n]$ where an argument can be $\#k$, the result of step $k$, and a turn's program may reference numbers first surfaced several turns earlier.

#### Model architecture and training

There is no new architecture here, which is the right call for a dataset paper and does mean the modelling contribution is thin. FinQANet is carried over from FinQA unchanged in structure, with the conversation context up to the current turn concatenated into the retriever's input and into the generator's input, and it reaches 86.38% recall for the top three retrieved facts, marginally below the 89.66% the same retriever reached on FinQA's single-turn task. GPT-2 medium and T5 large are run as standalone generative baselines, and encoders are varied across BERT base and large and RoBERTa base and large.

For the prompting side the model is GPT-3 `text-davinci-002` under four settings: Answer-only, which generates the execution result directly; Program-original, generating the FinQA DSL; Program-normal, generating the same computation in conventional notation so that `add(a1, a2)` becomes $a_1 + a_2$; and Chain of Thought, a natural-language explanation before the program. Each is run with three different sets of ten exemplars and the standard deviation across sets is reported, which is more discipline than either FinQA or TAT-QA showed. Two cost concessions matter for how I read the results: retrieval is only run on a 300-example sample of the test set, and program generation is run on the full test set using gold retrieval, so the prompting numbers are generous on retrieval and still lose.

#### Findings

- **The best neural symbolic model reaches 68.90% execution and 68.24% program accuracy against expert humans at 89.44% and 86.34%, and this is higher than FinQA's 61.24% for a reason that is not difficulty.** Gold supporting facts lift it to 77.32% and 76.46%, so roughly 8.4 points of the 20.5-point gap to experts is retrieval and the remaining 12 is reasoning, a better retrieval-to-reasoning split than FinQA's 9-and-21. The headline is flattered by decomposition: 34.73% of questions are single number selections and those score 82.54%, while the questions that need a program score 62.14%, which is the number directly comparable to FinQA's 61.24% and is essentially identical to it. Encoder scaling behaves as before, 55.03% at BERT-base to 68.90% at RoBERTa-large.

![[Pasted image 20260926150003.png]]

- **Accuracy declines monotonically with conversation turn and the decline is steep for a task where each turn is individually simple.** Reading both model families off the per-turn figures gives a pattern I want to keep in front of me:

| Turn | FinQANet exec | GPT-3 exec |
| --- | --- | --- |
| 1 | 75.58 | 72.81 |
| 2 | 70.74 | 29.03 |
| 3 | 66.15 | 56.77 |
| 4 | 63.96 | 33.12 |
| 5 | 63.90 | 45.95 |
| 6 | 34.38 | 25.22 |

  The trained model degrades gracefully to turn 5 and then drops, while GPT-3 oscillates violently, and the authors attribute the second-turn collapse to that turn almost always making a reference back to the first. The paper also states, from manual inspection rather than from a measurement, that once a turn is wrong the subsequent turns are rarely right, which is the compounding claim and the single most important sentence in the paper for me.

- **Switching aspect mid-conversation is harder than length alone explains.** Simple conversations score 72.37%, hybrid ones 60.99%, and within the hybrid conversations the first part scores 68.11% and the second part 52.38%. Since 65.0% of the second question sets were judged by annotators to depend on the first, the second-part number is measuring reference resolution across a topic change rather than fatigue over turns, and it is 16 points below the first part of the very same conversations.

- **Prompting loses badly on this task, on this model, with these prompts.** Program-normal is the best prompting setting at 45.15% execution and 38.88% program accuracy against FinQANet's 68.90% and 68.24%, Program-original is 40.81% and 36.62%, CoT is 40.63% and 33.84%, and Answer-only is 24.09%. Every one of them sits at or below the MTurk crowd's 46.90%. Two details are more informative than the ranking: CoT underperforms plain program generation here, which is the opposite of what CoT does on general math word problems, and the exemplar-set standard deviations of ±4.68 and ±2.77 mean the gap between Program-original and Program-normal is roughly one standard deviation and should not be read as established.

![[Pasted image 20260926150004.png]]

- **GPT-3 inverts the difficulty profile, which localises its failure precisely.** FinQANet scores 82.54% on number selection and 62.14% on program questions; GPT-3 scores 35.32% on number selection and 55.56% on program questions. The model can do the arithmetic and cannot resolve *what value in the subsequent year* refers to, even when the prompt instruction explicitly describes the conversational setting. Its execution-minus-program gap of 48.85% against 42.14% is much wider than the trained model's 68.90% against 68.24%, which the authors read as GPT-3 reaching answers from its own pre-trained habits without producing the program that justifies them, and that reading is consistent with Answer-only clearing 24.09% at all.

- **More exemplars saturate quickly and format familiarity matters more than format expressiveness.** Execution accuracy runs 43.52% at 5 exemplars, 48.85% at 10, 49.31% at 15, 50.30% at 20 and 49.90% at 25, so roughly five points of headroom between 5 and 20 and nothing after. That Program-normal beats Program-original at all is attributed to $a_1 + a_2$ appearing far more often in pre-training than `add(a1, a2)`, with the authors noting GPT-3 makes frequent grammar errors in the DSL form, which is a statement about surface familiarity rather than about reasoning.

#### Limitations

- **The conversations are simulated from programs and were never validated against real analyst dialogue.** Two construction mechanisms, decomposition of one multi-hop question and concatenation of two, generate every conversation in the dataset, and the paper says plainly that this does not cover all real-world cases. The consequence I care about is that the hardest class in the results, the second part of a hybrid conversation at 52.38%, is produced by concatenating two questions that a FinQA annotator happened to write about the same report, and the correlation between those two aspects is an artefact of that annotator's choices rather than of how an analyst moves through a filing. The difficulty is real, whether it is representative is untested.

- **Every FinQA filtering constraint is inherited and the operation vocabulary is narrowed on top.** Single-table pages, at most 20 rows, flattened multi-headers, no nested structures, S&P 500 filings from FinTabNet, page-local questions with inputs averaging 675.61 tokens. Nothing crosses a document, nothing crosses a filing year, there is no as-of notion, and the four table aggregation operations are gone, leaving six. A system scoring 68.90% here has demonstrated conversational reference resolution over one clean page, and nothing about locating that page.

- **The neural symbolic results are single-run point estimates while the prompting results are not, so the two halves of the paper are not held to the same standard.** RoBERTa-base at 64.95% against RoBERTa-large at 68.90% has no interval attached and no significance test, and given that the prompting side shows exemplar-set variance of ±4.68 on the same task, assuming the trained side has negligible seed variance is an assumption rather than a finding. The headline comparison of 68.90% against 45.15% is wide enough to survive this; the within-family rankings are not.

- **The prompting conclusion is scoped to one 2022 model with deliberately shallow prompting, and the paper says so.** Only `text-davinci-002`, no extensive prompt engineering because of API cost, retrieval evaluated on 300 examples, generation given gold retrieval, and the authors explicitly leave larger models and better prompting to future work. So *neural symbolic beats prompting* is not a claim I can carry into 2026, and I should not cite the 45.15% as though it says anything about a current model. What does survive is the mechanism, a model that computes correctly but resolves references to prior turns incorrectly, and that is a hypothesis to test on my own stack rather than a settled result.

- **The turn-6 collapse rests on very few examples.** Conversations average 3.67 questions, only 1.0% of questions have a dependency distance beyond 4, and no per-turn sample sizes are reported, so 34.38% at turn 6 is a thin tail and I should quote the monotone decline from 75.58% to 63.90% across turns 1 to 5 as the solid finding and treat the sixth-turn number as suggestive.

- **Nothing in the dataset or the metrics addresses detecting a wrong turn before it poisons the next one.** The compounding claim is stated from manual inspection and never measured, there is no conditional accuracy given the previous turn was correct, no abstention option, and no confidence output anywhere, so the models always answer. For a benchmark whose central finding is that errors propagate through a chain, the absence of any measurement of propagation, and of any mechanism for a model to decline a turn it cannot ground, is the most consequential thing missing.

#### Why this matters for my project

- **Query $A_F$ with atomic, self-contained requests and do not build a conversational interface to it.** The evidence is the 75.58% to 63.90% decline across five turns, the 52.38% on hybrid second parts, and the propagation claim, all on a task where each individual turn is easier than what I would ask. The orchestrator already holds the state it needs, so resolving *that value in the subsequent year* into an explicit entity, period and line item before the call costs me nothing and removes the failure mode the paper spends its results section documenting. This is a cheap design decision that I would probably have got wrong by default, since a chat-style agent interface is the obvious thing to build.

- **Where chaining genuinely cannot be avoided, chain over typed quantities rather than over text.** The paper's own mechanism is the $\#k$ reference, a pointer to a computed result rather than a phrase, and my equivalent is a resolved quantity carrying value, scale, currency, period and the source rows it came from, per the typed-output decision from the TAT-QA note, passed back in explicitly on the next call. A pointer can be re-executed and checked; an anaphor can only be re-interpreted, and 52.38% is what re-interpretation costs on clean single-page inputs.

- **This is the third independent estimate of how hard the numeric fundamental task is, and read correctly it agrees with the other two rather than improving on them.** The comparison across the three is the artefact worth keeping:

| | FinQA | TAT-QA | ConvFinQA |
| --- | --- | --- | --- |
| Questions | 8,281 | 16,552 | 14,115 |
| Turns per item | 1 | 1 | 3.67 avg |
| Retrieval in task | Yes, top-3 | No | Yes, top-3 |
| Reasoning output | Program, ≤5 steps | One of 10 operators | Program, ≤3 steps |
| Operations | 10 | 10 | 6 |
| Best model | 61.24 exec | 58.0 F<sub>1</sub> | 68.90 exec |
| Expert human | 91.16 exec | 90.8 F<sub>1</sub> | 89.44 exec |
| Hard-class score | 43.80 table-text | 42.5 arithmetic | 52.38 hybrid 2nd part |

  The 68.90% is not evidence that conversational is easier, it is evidence that a third of the questions are single-value lookups scoring 82.54%; the comparable program-question number is 62.14% against FinQA's 61.24%. The planning band for $A_F$ on computed quantities over CSE filings stays where the other two notes put it, below 50%, and the three papers now agree on that rather than one of them arguing it.

- **Return the components alongside every computed quantity.** Number selection at 82.54% against program questions at 62.14% is a 20-point reliability gap between reading a stated figure and computing with it, on the same model over the same reports. If $A_F$ emits the operands and the operation as well as the result, the orchestrator can recompute the arithmetic itself, the attribution layer gets the two source rows rather than a number, and the 82.54% component of the pipeline is separable from the 62.14% component instead of both being hidden inside one output.

- **Reference resolution across turns is the same failure as reference resolution across documents, which is the CSE-specific version of this risk.** Sri Lankan annual reports lean on phrases like *the corresponding period* and *as restated*, quarterly statements refer back to the annual ones, and comparative columns are labelled by position rather than by date. The paper shows a model that computes correctly and dereferences incorrectly, and a filing that dereferences across documents rather than across turns is at least as exposed. The practical consequence is that period resolution belongs in the retrieval and typing layer, resolved against an explicit fiscal calendar, and never left to the reasoner to infer from context.

- **The operator vocabulary question is now settled across three papers and I can stop revisiting it.** ConvFinQA's mix is 40.49% subtract and 33.43% divide, FinQA's is 45.29% divide and 28.20% subtract, and TAT-QA's two largest ablation gains were Difference at 5.9 points and Change ratio at 5.0. Level, difference, ratio and growth rate is the closed vocabulary, anything outside it gets declined rather than attempted, and this is the last time it needs arguing.

- **Add conditional accuracy to the $A_F$ probe set, since the paper names the metric it needed and did not build it.** Alongside the answer-source split borrowed from TAT-QA, I should record, for any multi-step quantity, whether each intermediate was right and score the final answer conditional on the intermediates being right. That separates a channel that is wrong because the arithmetic is hard from one that is wrong because step three inherited a bad number from step two, and the two have different fixes. On a probe set of ten to twenty questions this is bookkeeping rather than work, and it is the one measurement all three of these papers leave on the table.

> [!WARNING]
> 68.90% is not comparable to FinQA's 61.24% despite being the same metric, the same model family and the same underlying reports, because a third of ConvFinQA's questions are single number selections. Cite 62.14%, the program-question figure, when comparing across the two, and cite the 89.44% expert bar and the roughly 20-point gap to it as the portable finding.

> [!important]
> The prompting result is the part of this paper most likely to be misread in my review chapter. It says that one 2022 model with ten-shot prompting and no prompt engineering reached 45.15% where a trained specialised model reached 68.90%, and it does not say that prompting an LLM cannot do financial numerical reasoning. The durable content is the failure mechanism, correct arithmetic paired with broken reference resolution, and the right use of it is as a hypothesis I test on whatever model $A_F$ ends up using, with the two question shapes from the breakdown, not as a citation against LLM-based extraction.

> [!NOTE]
> Dataset and code are public at github.com/czyssrs/ConvFinQA, built on top of FinQA and therefore on FinTabNet. Because the conversations are synthesised from FinQA programs, the pairing is already aligned, so the two can be used as one probe corpus with and without conversational context, which is the cheapest available ablation on whether my own reference-resolution layer is doing anything.
