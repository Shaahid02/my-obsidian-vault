Hybrid ABSA framework for banking customer feedback in English, Sinhala, Singlish, and Sinhala-English code-mixed text, built specifically to be explainable rather than just accurate.

Core motivation: brand reputation in banking depends on catching negative sentiment fast, but Sri Lankan customer feedback is rarely clean English. It's a mix of English, Sinhala, Singlish (Sinhala written in English letters), and code-mixed sentences that switch language mid-sentence. Generic sentiment models and commercial tools like Brandwatch and Meltwater don't support Sinhala or code-mixed input at all, so a bank has no way to monitor a big chunk of its actual feedback.

> [!info] Code-mixed / Singlish
> Singlish here isn't Singaporean English, it's romanized Sinhala (Sinhala words typed with English letters). Code-mixed text is a sentence that switches between Sinhala/Singlish and English within the same review, e.g. "Customer service ගොඩක් හොඳයි" (customer service is very good).

#### Gap it's addressing

- Sinhala has very few annotated datasets, which limits model training and generalization.
- Code-mixed text breaks normal tokenization and syntactic parsing.
- Banking-specific vocabulary ("mobile banking," "loan approval delays") isn't captured well by generic pretrained models.
- Even where multilingual models work, they're black boxes, which is a real problem when AI output affects financial decisions and customer trust.
- Explainability work (SHAP, LIME) exists for high-resource languages but is barely explored for low-resource, code-mixed languages like Sinhala.

The paper's response is a hybrid framework: XLM-RoBERTa + a domain-specific Sinhala/Singlish lexicon correction layer for the local languages, BERT-base-uncased for English, wrapped in an Aspect-Based Sentiment Analysis (ABSA) layer, with SHAP and LIME bolted on for explainability.

#### Related Work (as covered in the paper)

- Early ML approaches (SVM, Naive Bayes) need manual feature engineering and don't adapt well to dynamic language patterns.
- Corpus-based lexicons have been shown to help Sinhala sentiment classification specifically.
- Traditional lexicon methods like SentiWordNet underperform in financial text because of domain vocabulary gaps.
- Transformer models (BERT, XLM-RoBERTa) automate feature extraction and beat lexicon methods across languages, but multilingual models still lose accuracy on low-resource languages without further fine-tuning. Best reported Sinhala-only result cited is XLM-R-large at 75.9% accuracy, which this paper treats as the number to beat.
- GPT-based zero-shot models are flagged as impractical here, not because of accuracy but because of compute cost, hallucination risk, data privacy, and social bias concerns in domain-specific customer review contexts.

#### Data

Custom dataset, not reused from elsewhere: 10,000 English + 5,000 Sinhala/Singlish/code-mixed banking reviews (about 1,667 each), scraped from review sites, social media (Facebook, Twitter, YouTube), and Kaggle, including an existing annotated Sinhala news comment dataset. Cleaned for garbage values, duplicates, ads, non-text content. Labeled Positive/Neutral/Negative and tagged into five banking aspects: Customer Support, Loan and Credit Services, Digital Banking Experience, Transactions and Payments, Trust and Security. Aspect tagging itself came from the authors' own earlier keyword-extraction/classifier work, not built fresh for this paper.

Class balance was enforced across sentiment labels, aspects, and language variants, and back-translation/lexical substitution were used for augmentation.

**Tokenization** is language-aware: WordPiece for English, SentencePiece with BPE for Sinhala/Singlish/code-mixed. The reasoning given is that SentencePiece splits unseen/rare Sinhala words into subword units instead of dropping them as out-of-vocabulary, and this also lets the model transfer knowledge between the English and Sinhala halves of a code-mixed sentence.

#### Methodology

Two separate pipelines feeding into one ABSA output:

1. **English**: fine-tuned BERT-base-uncased, compared against DistilBERT, FinBERT, and SVM baselines.
2. **Sinhala/Singlish/code-mixed**: XLM-RoBERTa for multilingual representation + BERT-base for the English segments inside code-mixed text + a custom lexicon correction module as a post-processing step.

A real practical problem they call out: a single review can carry conflicting sentiment across sub-topics (e.g. "loan approval was smooth but interest rates were too high"). Their fix is a softmax-based aggregation across aspect-level scores:

```
S_softmax = e^(S_aspect) / Σ e^(S_aspect)
S_final = Σ(S_softmax × P_aspect) / Σ P_aspect
```

where S_aspect is the raw model score per aspect and P_aspect is that aspect's softmax probability. This is meant to stop one extreme score from dominating the aggregated sentiment when a review is genuinely mixed.

The lexicon module is hand-built for Sinhala/Singlish/code-mixed banking terms specifically, things like "hari hodai" (very good) or "app eka lag wenawa" (app lags), which formal-corpus-trained transformers tend to miss entirely. It's applied as a correction step on top of the transformer output rather than replacing it.

#### Explainability

SHAP and LIME are layered on top of the BERT-based sentiment model:

- **SHAP** gives global, feature-level attribution (which words matter across the model generally).
- **LIME** gives local, per-instance explanations (why this specific prediction came out this way), and is combined with TF-IDF keyword extraction for per-aspect highlighting.

They report LIME working noticeably better than SHAP on short, code-mixed, informal reviews, since SHAP struggles more with that kind of sparse/mixed input while LIME's local perturbation approach handles conjunction-based context (e.g. correctly weighting "but" heavily in "fast na, but they reply"). SHAP is described as the more computationally expensive of the two, which matters if this is meant to run close to real time.

Explanation outputs were manually spot-checked for consistency rather than assumed reliable, since XAI methods themselves can be inconsistent especially in low-resource settings.
![[Pasted image 20260913181612.png]]
#### Results

English (BERT-base-uncased was the final model):

| Model | Accuracy | F1 |
|---|---|---|
| SVM | 71.9% | 0.70 |
| BiLSTM | 84.0% | 0.81 |
| DistilBERT | 82.5% | 0.83 |
| FinBERT | 90.0% | 0.87 |
| BERT-base-uncased | 92.3% | 0.89 |

Interesting that plain BERT-base beat FinBERT here even though FinBERT is pretrained on financial text specifically. Suggests the banking-review domain gap that mattered more was informal/customer-facing language, not financial terminology per se.

Sinhala/Singlish/code-mixed (XLM-RoBERTa + lexicon was the final model):

| Model | Accuracy | F1 |
|---|---|---|
| SVM | 62.4% | 0.58 |
| Naive Bayes | 58.7% | 0.55 |
| XLM-RoBERTa (base) | 78.2% | 0.74 |
| GPT-4o (zero-shot) | 81.5% | 0.77 |
| XLM-RoBERTa + lexicon | 88.4% | 0.84 |

Adding the lexicon correction on top of base XLM-RoBERTa alone accounts for +10.2% accuracy and +0.10 F1, which is a bigger jump than I expected from what's essentially a rule-based patch layer. It also beat GPT-4o zero-shot by 6.9 points, which lines up with their argument that zero-shot generalist models don't reliably capture domain slang like "godak slow" or "app eka lag wenawa" without something anchoring them to the local vocabulary.

Aspect-level explainability example given for Digital Banking Experience: positive sentiment clustered around "app" and "bank," negative around "login" and "transactions," which is the kind of actionable, per-feature breakdown a plain accuracy number can't give a bank's product team. They report SHAP + LIME together cut misclassification by 6.3% at the aspect level, though it's not fully clear if that's from the explainability layer itself correcting anything or just from the review/validation process that came with it.

<font color="#ffc000">The core result worth remembering: lexicon correction was the single biggest lever for the low-resource languages, not a bigger transformer. For English, domain pretraining (FinBERT) actually helped less than expected, plain BERT fine-tuned on the review data won.</font>

#### Limitations they flag

- Negation, slang, and code-mixed structure are still hard, existing models (including theirs) don't fully solve this.
- ABSA still struggles when a single aspect carries multiple conflicting sentiments within a long review.
- No large-scale annotated dataset exists for Sinhala/Singlish/code-mixed in the financial domain specifically, so generalization beyond their curated set is uncertain.
- SHAP and LIME both got less consistent on low-resource, code-mixed inputs, and SHAP's compute cost limits real-time use.

#### Why this matters for my project

This is the clearest existing local-language reference for the sentiment component: it directly targets Sinhala/Singlish/code-mixed financial-adjacent text (banking reviews) with explainability baked in, which is exactly the gap I need to cover for local market sentiment. It's not stock-market-specific and not applied to news/social sentiment for trading, but the hybrid XLM-RoBERTa + lexicon approach and the softmax aggregation for conflicting sentiment are both directly reusable ideas. The explainability layer (SHAP/LIME) is also a good template for how to justify a sentiment agent's output inside a multi-agent trading pipeline rather than treating it as another black box.
