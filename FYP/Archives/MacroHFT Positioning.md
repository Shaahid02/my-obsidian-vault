---
tags:
  - positioning
status: partly-superseded
date: 2026-09-20
---
# MacroHFT positioning — agreed defence (20 Sep 2026)

> [!note] Provenance and status
> Rescued from the Claude project on 18 October 2026, where it was the only copy. Partly superseded: `Research Matrices Status` records that the **Prior Work Contrast** sheet in Refined Research Gap Analysis Matrix v5 replaces the MacroHFT Positioning sheet referenced below, and that the single-MacroHFT defence has since widened into a five-way contrast. The agreed gap wording and the two caveats are still live.

MacroHFT (Zong et al., KDD '24) is the paper the main research gap must survive. It is already state-aware orchestration: a hyper-agent conditioned on trend slope and realised volatility emits softmax weights over six DDQN sub-agents and mixes their Q-values. It is in the reading list, so an examiner will find it.

Full contrast table lives on the **MacroHFT Positioning** sheet of `Research Gap Analysis Matrix.xlsx`.

## Agreed main gap wording (now the gap statement in the matrix)

> While existing hierarchical reinforcement learning architectures (e.g. MacroHFT) demonstrate state-aware Q-value mixing over homogeneous Q-learning sub-agents using short-term price trend and volatility tertiles, current frameworks lack a market-state-aware orchestration mechanism for heterogeneous, multi-modal financial agents that dynamically adapts agent influence and risk exposure under frontier-market execution friction (L_t) and persistent volatility long-memory conditions (d_t).

Cites MacroHFT before the examiner does, bounds what it covers, puts the open question outside those bounds.

## Three primary axes

| Axis | MacroHFT | This framework |
|---|---|---|
| **Agent architecture** | Six mathematically identical dueling DDQN sub-agents on one numerical price/LOB stream; single-asset, long-only, binary position | Heterogeneous agents across modalities — Sinhala/Singlish sentiment, fundamental RAG over CSE reports, macro, technical |
| **State space & econometrics** | Trend slope + realised volatility tertiles over a 60-min window. No long memory, no hyperbolic decay | FIGARCH fractional integration parameter (d_t) + forecast conditional variance + Amihud illiquidity (L_t) |
| **Execution friction** | Fills at next close minus flat 0.02% (2 bps). No slippage, queue position, partial fills or impact — despite 5 LOB levels feeding the state | Order-size and liquidity-conditioned cost, parent orders split across the turnover profile, impact fed back into reward and weighting |

Two supplementary axes (task/market, evaluation protocol) are held in reserve for the viva, not led with — domain difference and evaluation standards are not contributions.

**Strongest axis is execution friction**, because MacroHFT's own numbers make the point: 19/20/38/138 trades over ~4 months means the fee never binds, so the paper carries no evidence either way about whether its mechanism survives realistic friction.

**Weakest-looking axis is agent architecture**, so it needs the supporting evidence: identical architectures on slices of one stream share a failure mode. FinAgent's ETHUSD result (auxiliary strategies alone return 16% vs buy-and-hold 29%) and AlphaAgents dropping its sentiment agent for thin coverage are the documented cases of independent channel failure that heterogeneity creates and homogeneity does not.

> [!warning] The agent-architecture axis has moved since this was written
> The sentiment channel named in the table above was dropped on 20 September 2026 ([[Scope sentiment analysis dropped]]). The heterogeneity claim now rests on $A_T$ technical, $A_F$ fundamental/RAG, $A_V$ volatility/risk and $A_L$ liquidity, which is still genuinely heterogeneous evidence, but the wording here predates the cut.

## Two caveats added to the supervisor's framing

**1. The mixture may not stay a mixture.** MacroHFT's Figure 5 shows a near-binary policy — the bear sub-agent holds ~0.85 of the weight in one configuration, three of six curves sit barely off the floor for the whole test period. This is a problem for *our* design, not for the contrast. If our orchestrator's weights collapse the same way, the mechanism reduces to regime-based selection, the heterogeneity axis does all the work, and "adaptive" stops earning its place.

→ Pre-register the **entropy of the learned weight distribution** as a reported diagnostic. Implement the cheaper router first, measure it, add the mixture only if the weight trace shows genuine blending. That also supplies the ablation MacroHFT never ran.

**2. Avoid the word "integration."** Describing the contribution as the *integration* of d_t and L_t into an orchestration layer invites back the exact objection the original critique made — "A + B + C + D have not previously been combined" is integration, not novelty.

→ State it as an ablation result instead: agent influence conditioned on liquidity and persistence outperforms (a) fixed weighting, (b) MacroHFT's trend-and-realised-volatility conditioning set, and (c) a hard regime router, on CSE data across regimes, with the persistence and liquidity terms individually ablated. If those ablations come back flat, the honest finding is that the extra conditioning does not pay on this market — and that is reportable.

## Where each piece goes

- Three primary axes → literature review chapter, as a contrast table in the MacroHFT discussion (follows the cross-paper table convention in the style note)
- Gap wording → gap statement
- Axes 4–5 → viva reserve
- Entropy diagnostic → experimental protocol, pre-registered

## Related

- [[MacroHFT, Memory Augmented Context-aware Reinforcement Learning On High Frequency Trading]] — the review note
- [[Research Matrices Status]] — records the five-way contrast that widens this defence
- [[Scope sentiment analysis dropped]] — the cut that changes the agent-architecture row
