arXiv preprint 2011.07280v1, November 2020, Senevirathne, Demotte, Karunanayake, Munasinghe and Ranathunga out of the Department of Computer Science and Engineering, University of Moratuwa. A document-level, four-class sentiment classification study on Sinhala news comments, comparing fourteen deep learning architectures from vanilla RNN through to capsule networks, and releasing what is still the largest publicly annotated Sinhala sentiment dataset, 15,059 comments labelled POSITIVE, NEGATIVE, NEUTRAL and CONFLICT, alongside a 9.48 million token unannotated corpus used to train the word embeddings.

This is the foundational resource paper for the Sinhala side of my sentiment component, and I read it primarily as a dataset and baseline contribution rather than a modelling one. It is the paper that establishes what the Sinhala sentiment ceiling actually looks like when nobody has a pretrained language model to lean on, and the honest answer it gives, roughly 63% weighted accuracy across fourteen architectures that differ from each other by less than three points, is more useful to me than any single model in it. Where [[Enhancing Multilingual Sentiment Analysis with Explainability for Sinhala, English, and Code-Mixed Content]] gives me the modern modelling approach for Sinhala and code-mixed text, this gives me the corpus, the embeddings, the preprocessing rules and the baseline number those later results have to be read against.

> [!important] The label set is four-class, and the fourth class is the interesting one
> Most Sinhala sentiment work before this is binary, POSITIVE against NEGATIVE. This paper adds NEUTRAL and, unusually, <font color="#ffc000">CONFLICT</font>, a comment carrying both positive and negative opinion at once. That is the same problem [[Enhancing Multilingual Sentiment Analysis with Explainability for Sinhala, English, and Code-Mixed Content]] handles with softmax aggregation across aspects, and it is a problem I will have on CSE commentary, where a post is routinely bullish on one counter and bearish on the market in the same breath.

#### Gap it's addressing

- **Sinhala is morphologically rich and under-resourced, and the two facts compound.** There are no publicly available sentiment lexicons, no POS taggers of usable quality, and no pretrained contextual model, so the auxiliary linguistic knowledge that carries English sentiment analysis, the lexicon features of Qian et al. and the POS features used across the Indic work, is simply unavailable. The authors' framing is that this forces an end-to-end deep learning approach using language-independent features, not because it is preferable but because nothing else is on the table.
- **The only prior annotated dataset is small, single-source and binary.** Liyanage's 5,010 to 9,060 comment set came from one news site, Lankadeepa, carried only POSITIVE and NEGATIVE, and had a Cohen's kappa of 0.52 on the multi-label annotation. CONFLICT was never captured at all.
- **Only two prior deep learning studies exist for Sinhala sentiment, both binary and both narrow.** Liyanage used LSTM and CNN+SVM, and Demotte et al. used Sentence-State LSTM on the same data. Neither covers more than three architectures and neither attempts multi-class.
- **BERT is ruled out rather than compared against.** The authors state plainly that no pretrained Sinhala model existed and that they did not have the capacity to build one, and they add the more general objection that for an under-resourced language there is not enough text to learn contextual information the way English models do with billions of words. <font color="#ff0000">This is the single largest thing that has changed since 2020</font>, and it scopes every result in the paper to the pre-transformer era for Sinhala.

#### Data and setup

Comments were crawled from two Sinhala news sites, Lankadeepa and GossipLanka, covering 2016/06 to 2020/05 across politics, sports, crime, economy, society and culture. From GossipLanka, 12,776 articles yielding 30,000 comments were extracted, averaging 8 comments per article. The final annotated set is 15,059 comments, 9,059 re-annotated from Liyanage's Lankadeepa data plus 6,000 newly crawled from GossipLanka.

The class distribution is the number to hold onto for the rest of this note, because every headline metric in the paper is a weighted average over it:

| Class | Count | Share |
| --- | --- | --- |
| NEGATIVE | 7,665 | 50.9% |
| NEUTRAL | 3,080 | 20.5% |
| POSITIVE | 2,403 | 16.0% |
| CONFLICT | 1,911 | 12.7% |

Three annotators were used, with 7,000 of the 15,059 comments double-annotated to measure agreement. The reported Cohen's kappa is 0.65, up from Liyanage's 0.52, and the annotation rule is simple: purely negative or purely positive gets that label, no opinion either way gets NEUTRAL, and both together get CONFLICT.

Kappa is the statistic the paper's whole discussion section hangs on, so it is worth writing down what it measures:

$$\kappa = \frac{p_o - p_e}{1 - p_e}$$

where:
- $p_o$ is the observed proportion of comments the two annotators labelled identically
- $p_e$ is the proportion they would be expected to agree on by chance given their marginal label frequencies
- $\kappa = 0.65$ therefore means roughly 65% of the agreement available above chance was achieved, which is conventionally read as substantial but not strong

The unannotated corpus is separate and larger: 16,840 news articles plus their comments, 9.48 million tokens, used solely to train Word2Vec and fastText models. Code, embeddings and annotated data are all released publicly, which is the part of this paper with the longest shelf life.

#### Pre-processing and feature selection

Sinhala did not originally carry punctuation and has borrowed it from English, so the authors treat punctuation removal as an empirical question rather than a convention. The result is the cleanest small experiment in the paper, and it lands on a rule I intend to reuse.

![[Pasted image 20260920180001.png]]

Stripping all punctuation lifts holdout accuracy from 58.57% to 61.75%, and stripping everything except the question mark lifts it again to 63.35%, a 4.78 point gain over the raw text. The reasoning given is that question marks in Sinhala news comments are mostly attached to negative sentiment, so the mark itself is a usable feature while commas and full stops are noise. Worth noting that the weighted F1 does not move the same way, 61.09% without any punctuation against 61.00% with the question mark retained, and the paper bolds 61.00 as the best F1 in that column when it is not. The accuracy gain is real and the F1 difference is inside noise, but the bolding is careless, and it is the first of several places where the table and the claim disagree.

Tokenization uses the `sinling` Sinhala tokenizer, and all characters outside Sinhala unicode, the question mark, space and decimal digits are filtered out, which also handles the Singlish and English comments that GossipLanka's unmoderated comment section allows through. Feature selection is a non-choice, the authors state that lexicons and POS tags do not exist and that bag of words, n-grams and TF-IDF underperform on Sinhala, so they go straight to word embeddings.

fastText beats Word2Vec at every single one of the nine dimensions tested, which on a morphologically rich language is the expected direction and is the reason I care about this table.

![[Pasted image 20260920180002.png]]

The mechanism is subword composition. fastText represents a word as the sum of the vectors of its character n-grams rather than as an atomic unit:

$$\mathbf{v}_w = \sum_{g \in \mathcal{G}_w} \mathbf{z}_g$$

where:
- $\mathcal{G}_w$ is the set of character n-grams making up word $w$, plus the word itself
- $\mathbf{z}_g$ is the learned vector for n-gram $g$

For Sinhala this matters because inflection multiplies surface forms of the same stem, so a word-level model like Word2Vec either sees each form as unrelated or drops the rare ones as out-of-vocabulary, while fastText shares parameters across forms and produces a vector for words it never saw in training. The same argument is why [[Enhancing Multilingual Sentiment Analysis with Explainability for Sinhala, English, and Code-Mixed Content]] uses SentencePiece with BPE rather than word-level tokenization.

The dimension choice is less interesting than the paper makes it. fastText at 300 gives 64.23%, but 200 gives 63.94% and 450 gives 63.88%, and the entire fastText column spans 1.66 points across a nine-fold sweep. Dimension was fixed at 300 for everything afterwards on the strength of a difference of about a quarter of a point over its nearest neighbour, on a single holdout split.

#### Model architecture and training

Fourteen configurations in four groups, all sharing an embedding layer initialised from the fixed 300-dimension fastText vectors, a softmax output over four units, and categorical cross-entropy loss. Everything was run in Google Colab Pro on T4 and P100 GPUs, with 10-fold cross validation for the model comparison and an 80/20 holdout for the preprocessing and embedding experiments.

| Group | Members | Design intent |
| --- | --- | --- |
| Vanilla sequence models | RNN, LSTM, GRU, BiLSTM | Baselines, Adadelta at lr 0.95, He initialisation, 0.5 dropout, ReLU |
| CNN hybrids | CNN + GRU / LSTM / BiLSTM | CNN extracts coarse local n-gram features, fed to the sequential layer |
| Stacked | 2 and 3 layer LSTM and BiLSTM | Upper layers extract richer contextual representation |
| Recent architectures | HAHNN, Capsule-A, Capsule-B | Word and sentence level attention; capsules for order and pose |

Regularization is dropout plus L1/L2 plus early stopping on the vanilla models. Hyper-parameters were optimized over hidden units, dropout, L1/L2 factors, optimizer, learning rate, and for the CNN layers the number of filters, kernel size and dilation rate. Capsule networks use margin loss with margin 0.2, 16-dimensional capsules, 16 filters per capsule layer and three capsule layers, with capsule-A restricted to 3-gram features and capsule-B using 3, 4 and 5-gram features. HAHNN uses Adam at lr 0.001 with decay 0.0001, dropout 0.2 and filter sizes 3, 4 and 5.

All reported metrics are weighted averages over the four classes, which given the 50.9% NEGATIVE share is the choice that determines how the results read:

$$F_1^{\text{weighted}} = \sum_{c \in C} \frac{n_c}{N} \cdot \frac{2 P_c R_c}{P_c + R_c}$$

where:
- $n_c$ is the support of class $c$ in the evaluation fold and $N$ the total
- $P_c$ and $R_c$ are per-class precision and recall
- the weights are the class shares above, so NEGATIVE alone carries half the score and CONFLICT carries an eighth

#### Findings

- **Fourteen architectures spanning four generations of design land within three points of each other, and that is the finding.** Ignoring the vanilla RNN, every model in Table 3 sits between 61.16% and 63.81% accuracy and between 53.17% and 59.42% weighted F1. Capsule networks, hierarchical attention, stacking to three layers and CNN hybridisation all fail to separate themselves from a plain BiLSTM, which reaches 63.81% on its own. On this dataset the architecture is not the binding constraint, the data is, and the authors more or less say so in the discussion.

  ![[Pasted image 20260920180003.png]]

- **The paper's own best-model claim is not supported by its own table, on either metric.** The text states that capsule-B went beyond all the other experimented models at 63.23% accuracy and 59.11% weighted F1. BiLSTM records a higher accuracy at 63.81%, and Stacked BiLSTM 3 records a higher F1 at 59.42%, so capsule-B is best on neither. It is the best compromise across the two, which is a defensible thing to select for, but it is not what the sentence says, and the surrounding discussion about capsule architectures capturing exact order and pose is then built on a comparison that does not hold.
- **Attention underperformed, and the explanation offered is plausible and untested.** HAHNN lands at 61.16% accuracy, below the plain BiLSTM, and the authors attribute this to most comments being short, which limits the deeper neural representation attention is supposed to buy. That reading is consistent with the evidence but is asserted rather than shown, no comment-length distribution is reported and no length-stratified breakdown is given, so on this evidence it is a hypothesis about why attention did not help rather than a demonstration.
- **CNN hybridisation actively hurt most of the models it was applied to.** CNN+GRU at 61.59% and CNN+LSTM at 61.89% sit below their own base models at 62.78% and 62.88%, and only CNN+BiLSTM comes close to holding level. The authors attribute this to not having enough data to fit the extra trainable parameters, which is the same constraint that explains the flat architecture comparison above, and it is the second time in the paper the answer is sample size.
- **Four rows in Table 3 report a recall that differs from the reported accuracy, which cannot happen under weighted averaging.** For RNN, LSTM, Stacked BiLSTM 3 and HAHNN the recall column reads 54.98, 51.93, 46.63 and 48.54 against accuracies of 58.98, 62.88, 63.13 and 61.16, while the other ten rows have the two columns identical as weighted averaging requires. Those four rows are also the ones carrying anomalously high precision, 70.95 for LSTM and 71.08 for HAHNN against a 59 to 61 norm. The likely explanation is that some rows were macro-averaged and others weighted, and if so the table is not internally comparable, which matters because the best-model selection is made from it.

#### Limitations

- **The confusion matrix shows the model has largely learned to predict the majority class, and the weighted metrics hide it.** On the holdout set of 3,012 comments, per-class recall is 91.8% for NEGATIVE, 62.2% for POSITIVE, 21.8% for NEUTRAL and <font color="#ff0000">12.2% for CONFLICT</font>. 272 of the 384 actual CONFLICT comments, 70.8%, are predicted NEGATIVE, as are 344 of the 505 NEUTRAL ones, 68.1%.

  ![[Pasted image 20260920180004.png]]

  Recomputing from this matrix, overall accuracy is 64.1% and weighted F1 is 59.3%, matching the paper, but macro-F1 is 48.2%. <font color="#ffc000">The 11-point gap between the weighted and macro figures is the real result</font>, and reporting only the weighted number means the two classes the paper introduced as its contribution are the two it classifies worst, without that appearing anywhere in the headline. The authors do identify the misclassification direction in the discussion and attribute it to class imbalance, so this is a reporting choice rather than an oversight, but no class weighting, resampling or cost-sensitive loss is attempted in response.
- **No baseline of any kind appears, and the obvious one is close to the reported results.** NEGATIVE is 50.9% of the dataset, so a classifier that always predicts NEGATIVE scores roughly 51% accuracy against the best model's 63.23%, and the vanilla RNN's 58.98% beats it by eight points. Against a majority-class weighted F1 of about 34% the deep models do clearly better, but neither comparison is on the page, and without it a reader has no way to size the 63% figure. This is the same absence I flagged in [[Machine Learning-Driven Sri Lankan Stock Market Prediction, Harnessing Economic Indicators and Sentiment Analysis]], and it appears to be a pattern in the local literature rather than a one-off.
- **Treating the annotator kappa as an accuracy ceiling is a conflation, and it does a lot of unearned work in the discussion.** The paper states that the weighted accuracy of each experiment was bounded below 65% as a direct result of the inter-annotator agreement value. Kappa is a chance-corrected agreement statistic between two annotators on 7,000 comments, it is not an upper bound on classifier accuracy, and the numerical coincidence between 0.65 and 63% is exactly that. Label noise certainly does cap achievable accuracy and the direction of the argument is right, but the specific bound is not derivable from kappa, and framing it this way converts an open question, how much of the residual error is noise and how much is model capacity, into a settled one. The cheap test, measuring model accuracy on the subset where both annotators agreed, is available in their own data and is not run.
- **The two reported experiment protocols are not comparable, and the better numbers come from the weaker one.** Preprocessing and embedding selection use a single 80/20 holdout, giving 63.35% and 64.23%, while the model comparison uses 10-fold cross validation, where the best model reaches 63.23%. So the fastText 300 choice that fixes the input representation for every subsequent experiment was made on one split, and the headline 64.23% is not directly comparable to anything in the main results table. Given that the entire fastText column spans 1.66 points, that choice is within the variation a different split would produce.
- **The corpus covers one register, and the code-mixed part of it is filtered rather than handled.** Both sources are Sinhala news portals, the annotation is document-level over short comments, and no evaluation on any other domain or text type is reported, so the register here, anonymous commentary weighted towards politics and crime, may not be the register a downstream application needs. Underneath that, non-Sinhala unicode is stripped during preprocessing, so a comment written in romanized Sinhala or switching into English mid-sentence is mangled or emptied rather than classified, and since GossipLanka does not moderate for language this is silently discarding part of the crawled data at a proportion never reported.

#### Why this matters for my project

- **This is the corpus and the embedding model I start from for the Sinhala sentiment agent, not a method to reimplement.** 15,059 four-class annotated comments, a 9.48 million token corpus, and released fastText vectors are a genuine head start on a resource that otherwise does not exist for Sinhala, and the licence is public. What I take is the data and the preprocessing, what I do not take is the architecture comparison, which the paper itself shows to be flat.
- **It sets the honest pre-transformer baseline my own numbers have to beat, and it names the gap that makes beating it possible.** 63% weighted accuracy and 59% weighted F1 on four-class Sinhala document sentiment is the figure to report alongside my own, with the explicit note that BERT was ruled out here for lack of a pretrained Sinhala model. That constraint has since lifted, and the 88.4% XLM-RoBERTa plus lexicon result in [[Enhancing Multilingual Sentiment Analysis with Explainability for Sinhala, English, and Code-Mixed Content]] is the measure of how much, which gives me a defensible arc from this paper to my own design rather than a bare assertion that transformers are better.
- **Macro-F1 and a per-class breakdown go into my results table as fixed columns, and weighted accuracy never travels alone.** The 11-point weighted-to-macro gap here is the cleanest demonstration in my set of how a respectable headline metric survives a model that gets 12% recall on a minority class, and financial sentiment on the CSE will be at least as imbalanced, since most commentary on a thin market is neutral or noise. A sentiment agent that is confidently wrong on the minority signal classes is worse than no agent, because the portfolio layer will act on it.
- **CONFLICT is the class I actually need and the one this paper handles worst, so mixed sentiment gets a designed answer rather than a fourth label.** Bullish-on-counter, bearish-on-market is the normal shape of CSE commentary, and a flat four-way softmax collapses it into NEGATIVE seven times out of ten here. The aspect-level decomposition with softmax aggregation from the multilingual explainability paper is the alternative I plan to adopt, scoring per target and aggregating, rather than asking one classifier to name the mixture.
- **Keep the question mark, drop the rest, and reuse fastText subwords as the fallback representation.** The 4.78 point gain from punctuation handling is cheap, source-specific and directly transferable to Sinhala financial text, and subword composition is the right default for a morphologically rich language whether it arrives as fastText n-grams or SentencePiece BPE. Where a pretrained model is unavailable or too heavy for the latency I need, fastText at 300 dimensions is the documented fallback and I do not need to re-run the dimension sweep to justify it.
- **The domain gap is my contribution boundary, and this paper is what makes that boundary concrete.** News-portal comments about politics, crime and sport are not financial text, there is no market data attached to any comment, and no downstream task beyond classification is attempted, so nothing here speaks to whether Sinhala sentiment carries return information on the CSE. [[Machine Learning-Driven Sri Lankan Stock Market Prediction, Harnessing Economic Indicators and Sentiment Analysis]] shows the local alternative is one English-language publisher's Twitter feed, and [[Role of Market Liquidity in Sentiment-Based Return Predictions, Evidence from Sri Lanka]] warns the sentiment-to-return sign does not transfer from the US literature, so the missing piece is a Sinhala financial sentiment resource evaluated against realised CSE returns rather than against an annotation set.
- **Annotation protocol is a deliverable, not an afterthought, and kappa gets reported honestly.** Three annotators, a documented tagging rule, and a double-annotated subset large enough to measure agreement is the standard to match when I build the financial sentiment labels, and I report kappa as an agreement statistic with the model also evaluated on the agreed-only subset, which separates label noise from model capacity instead of asserting a ceiling.
- **A single split does not decide a design choice in my pipeline.** Fixing the input representation on one 80/20 holdout and then running the model comparison under 10-fold cross validation is how a 1.66 point spread becomes a fixed constant, and my representation, lag and hyper-parameter choices are made under the same evaluation regime the final numbers are reported under.

[^1]: Weighted recall over classes is arithmetically identical to overall accuracy, since $\sum_c (n_c/N) \cdot (\text{TP}_c/n_c) = \sum_c \text{TP}_c / N$. That identity is what makes the four mismatched rows in Table 3 diagnosable as a mixed averaging scheme rather than a rounding issue.
