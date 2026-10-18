---
date: 2026-10-12
type: panel-feedback-transcript
week: 4
project: FYP - Multi-Agent Financial Decision Systems for the CSE
tags:
  - fyp
  - panel-feedback
  - transcript
  - week-4
status: placeholder
---

# Panel Feedback Transcript — Week 4

> **Verbatim record.** Do not edit, summarise, tidy or correct this file. Mark inaudible stretches `[inaudible]` and speaker guesses `[?]` rather than filling them in. All synthesis belongs in [[Week 4]].

|                       |                                |
| --------------------- | ------------------------------ |
| **Session date**      | 10/12/2026                     |
| **Time**              | 21:30                          |
| **Present**           | Salitha Perera, Shaahid Fathul |
| **Panel members**     | Salitha Perera                 |
| **Transcript source** | Live recording                 |
| **Accuracy caveat**   | Auto transcipt                 |

*Synthesis note:* [[Week 4]]

---

<!-- Paste the transcript below this line. Keep speaker labels. Change nothing else. -->

Salitha 0:00
The strongest part is not use of different agents itself, right? It is the proposed market condition, where we can listen.

Shaahid Fathul 0:12
Yeah.

Salitha 0:12
But you know, like it determines actually how much each agent should influence, right? To the finance. output. Anyway, right, the research gap need strong evidence. Like your gap is now fine, right? But like you are currently claims that the existing multi-agent frameworks use fixed weight, while the proposed system will dynamically adjust the importance of each agent for the CAC. That's what you told, no? Yes. Right. The hypothesis is promising. Right. But you haven't confirmed the research gap. No. When you are confirming the research gap. I mean, you should have stronger evidence, right?

Shaahid Fathul 1:07
Okay.

Salitha 1:08
You have to verify these, like one, like some of the areas that I have noticed when you are explaining. You have to do investigation and verify whether these areas are actually the gaps is exist or right. You can like you know, you can do kind of existing multi-agent financial financial analysis systems. Genuinely use fixed values, or do they use adaptive weighting? Are you able to understand,

Shaahid Fathul 1:41
yeah.

Salitha 1:41
And you have to check whether they are the confident-based aggregation can be there, right? And what kind of market recommend detection method they are using, something like that. You have you have to check, and you have to check whether whether the existing studies have investigated adaptive financial prediction, or they are going with decision making. In you know, like that is also you have to check, right? Another thing that you want to consider is like does the CSE create specific challenges that existing methods do not address, right? Yeah. And can the proposed method, whatever the your solution, right, demonstrably address those challenges what you have identified from the existing things. That is also you have to investigate and see, right? Okay. Basically, your literature should compare existing systems by different like aggregation methods, market index, right? And treatment of you know liquidity, different different things, and you can consider the evaluation results, Right, then compare them and do investigation of these kind of areas, right? And you have to come up with a stronger evidence. Is that clear? Yeah. And you know, like you are talking about volatility and liquidity, no?

Shaahid Fathul 3:17
Yeah.

Salitha 3:18
Right. They are two different things. Yes. Then you have to, like you know, like like when you are using these concepts, right? They should not be treated as same thing because they are two different things, right? Then you have to identify like what is the meaning of this volatility agent, and what is the liquidity agent? Something like that, right? Separately, you have to identify the requirements of these two, right, and do the you know like design accordingly. Is that clear?

Shaahid Fathul 4:01
Yes, sir.

Salitha 4:02
That is also you need to consider, right?

Shaahid Fathul 4:05
Okay. Then

Salitha 4:05
your main technical contribution should be like this is my thought right book, but you can ask from sir also, right? Like if you can investigate the liquidity And the market regime, we are adaptive weighting mechanism, right? It will be a good technical contribution for you instead of always giving four agent equal influence, right, or something like that. Is that clear?

Shaahid Fathul 4:38
Yes, sir.

Salitha 4:40
Right, that is what I can tell you. Like, like you know, when we are simply adding two agents, is not a strong technical contribution itself. No.

Shaahid Fathul 4:52
Yeah.

Salitha 4:52
Right. The you have to investigate whether the technical contribution could be like adaptive. You know that adaptive weighting method that estimate the useful of each hurdent under different liquidity and volatility, or else you have to see whether the market regime aware methods Changes how agent outputs are combined, and you know trading conditions change, or else finally check right whether the reliability aware mechanism that reduce the influence of agents right when their input data as they are stale or unrealable, or something like that. You have to check. Is that clear? Yes. Don't try to simply, you know, adding two agents together because it won't make a strong contribution for

Shaahid Fathul 5:56
you. Yeah. Right. Yeah.

Salitha 5:58
Like for me, I thought if you can do a kind of a adaptive weighting method that estimate a useful, I mean usefulness of each agent under different liquidity and volatility, right? It will be a good contribution, right? But you know, like maybe because of the data set data set feasibilities, it can be changed. But before you, you know, committing into the design, right? First of all, do a good investigation and see whether you are having a good feasible data set.

Shaahid Fathul 6:41
Sure. In terms of data set, I have looked into a certain amount of it. So, through the Columbus Stock Exchange, the website itself, you can go all the way back. But there are some gaps, even from the website. When I like download data from the official website, there are gaps here and there, a day or two missing in a certain year, and the initial like 2012, there's like a month missing or something like that. So there are gaps from the official site itself. So as as another way of getting data is, I've emailed the CSC and they said they have a separate Google Drive containing data like this, and they they store Excel sheets there. So my hope is getting access to that to see whether those data complete or not. And another thing I had a problem with, sir, is where do I decide the cutoff point? Like if I take the data, like say the OHCL open high, close low, and volume data. So where do I start and where do I end? Like which year does this have to start and which year does this have to end? How do I get the idea for that?

Salitha 7:54
Then as a step, like as your next steps, what I can like you are talking about dataset scope or what kind of scope?

Shaahid Fathul 8:08
Yeah, the dataset scope. On one way, I can decide where it ends. So I could decide since I'm already if I were to start the build the BOC, I could say the data ends at 2026 Q3. So with September data ends, where do I decide the starting point? One point I was thinking was the CESC officially introduced the SNP, the Standard and Poor like official standardisation. They started that on around June 2024. For

Salitha 8:43
the yeah for the initial POC level, right? You can take five to 10 companies listed on Columbus Stock Exchange, right? And take three to five years historical daily data if they are available and reliable for you, right? And like dataset fields also, you have to concern.

Shaahid Fathul 9:06
Yeah.

Salitha 9:07
Like data, the open, high, low, close, volume, different, different things are there. Yeah. Right. And the data quality also you have to check. Yes. You have to check the missing values, man trading days, right? Different different things right. Start with the five five to 10 stocks for two to three years of daily data to test the feasibility of your you know the proposed solution right after that thing if it is successful you can expand the data set if necessary, but the data must be sufficient to test both the approaches. I mean, normal and low quality market conditions.

Shaahid Fathul 9:53
Yeah,

Salitha 9:54
I mean normal and no low liquidity marking. Yeah, market conditions. Right. As a next step, what I can suggest you to do is like first of all collect a small data set as I told you, right? And you can build simple agents, two agents, right? Technical agent and you know volatility and liquidity agent separately, right? You can add the fundamental agents later, but the like these two are the main all things in your system. Then you can define the like define what kind of thing the system going to predict for the POC. Yeah, I am talking about the VOC level. Are you can predict whether the next trading days closing price will increase or decrease, then compared with the previous days, you can predict those things, right? But clearly define how unchanged prices are handled. Is that clear? Yes, sir. And like create a fixed weight baseline approach for you, right? You can combine the agent outputs using you know equal weights, right? Then you can record the prediction accuse or whatever, right? It will be the baseline, you know, for your comparison, right?

Shaahid Fathul 11:21
Yeah.

Salitha 11:22
Then you can implement adaptive weighting as well. Right. Then once you have implement both the parts, I mean the fixed weight approach and the adaptive weighting approach, you can compare the results. No. Right. I'm talking about a very like the VOC level implementation with a small data set, then compare the five weights. I mean, five eight like you know the fixed weight approach and the adaptive weight approaches on the same historical period time period, right? Then you can check whether that adaptive weighting improves the prediction performance, especially you know during the periods of low trading activities. Right? Then you can see the findings and analyse them and see. Is that clear?

Shaahid Fathul 12:18
Yes, sir.

Salitha 12:19
Right. Anyway, after you in implementing your POC and testing it, right? The like you have to demonstrate mainly three things: whether the individual agents can generate predictions. That is also you have to decide based on the results, right? And whether the system can combine their outputs using fixed and adaptive weights. That is also you have to get an idea from the results.

Shaahid Fathul 12:48
Okay. Then,

Salitha 12:48
like you can see whether the two approaches can be compared using fair evaluation method. Right. Yeah. Like for initial implementation, do not start by building four agents or the complete LLM framework. First, test whether adaptive weighting provides measurable value over a simple baseline approach. Right. Also, like like if you are like it, if you intend to claim improved invest, I mean investment decisions or prediction accuracy alone will not be sufficient. No,

Shaahid Fathul 13:34
yeah,

Salitha 13:35
that is also there. Yeah, start with a kind of a small level, and if it is okay, then you can go for a real implementation that you have suggested. That's what I can tell you for now. Anyway, that like think about the main points that I have pointed out as a next step, what I can recommend you to do is start the POC. I mean, like create a kind of a baseline MC.

Shaahid Fathul 14:16
Okay.

Salitha 14:18
Okay. Can you tell me your ID?

Shaahid Fathul 14:23
Ah yes, 2022. 32.

Salitha 14:28
Okay.

Shaahid Fathul 14:29
16. One six.

Salitha 14:35
Okay.

Shaahid Fathul 14:36
Right. Thank you very much. Have a good night.

Salitha 14:40
Okay. Thank you. Bye bye.

This transcript was generated by https://otter.ai

