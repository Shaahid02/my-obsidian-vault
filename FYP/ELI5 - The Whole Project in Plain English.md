*Revised 27 October 2026. Three things in this note had gone out of date: how much price history there is, what trading-activity data is held, and whether the company accounts had been collected. All three are corrected below and the old wording is noted where the change matters to an argument rather than just to a number. Created 12 October 2026. The whole project with no jargon. Everything here is said properly in [[Research Gap]] and [[Contribution to Knowledge]]. This note is for explaining it out loud: to a panel in the first two minutes, to a family member, or to yourself at the point where the detail has stopped making sense.*

---

## The one-minute version

Imagine four advisers helping you decide whether to buy a share.

- One reads **price charts**.
- One reads **company accounts**.
- One watches **how wild the market is**.
- One watches **how easy it is to actually buy and sell**.

They each give you an opinion. Somebody has to turn four opinions into one decision.

Right now, almost every published system does that badly. Most of them do not even have a dial to set. They paste the four opinions into one block of text and let a language model read it. There is nothing you could turn up or down, because there is no number anywhere that represents how much each adviser is being listened to.

**That is a problem, because advisers are not equally good all the time.** The one who reads company accounts is useless when the most recent accounts are eleven months old. The one who reads price charts is unreliable when the share barely trades, because the prices on the screen are stale. But neither of them will tell you that. Ask an AI adviser a question it has no information about and it does not say "I don't know." It gives you a confident answer about nothing.

**So the project is this.** Build the dial. Make it move by itself, continuously, based on things you can actually measure about the market today: how easy it is to trade, how wild things are, how long the last shock is taking to fade, and how structurally sound each adviser's answer looks. Then test whether the moving dial beats a fixed one.

The test market is the **Colombo Stock Exchange**, because that is where adviser reliability swings the most. On a deep market like the Nasdaq everything trades constantly and everyone files on time, so the four advisers are roughly equally good and a fixed dial is roughly fine. In Colombo, on any given day, some of those information channels are live and some are empty.

---

## The pieces, one at a time

### What an "agent" is here

A component that looks at one kind of information and produces one opinion. Four of them. They are deliberately built differently from one another, because if they all worked the same way they would all be wrong at the same time, for the same reason, and having four of them would buy nothing.

### What "orchestration" means

The thing that turns several opinions into one decision. The shorthand is:

$$w_{i,t} = f(L_t,\ V_t,\ P_t,\ C_{i,t})$$

In words: **how much we listen to adviser $i$ today depends on four things we can measure.**

- $L$ is **liquidity**. How easy is it to buy and sell right now, and how much does a trade move the price against you.
- $V$ is **volatility**. How violently is the market moving right now.
- $P$ is **persistence**. How slowly do shocks fade on this market. Not how bad things are, but how long bad things last.
- $C$ is **confidence**, but confidence measured rather than asked for. More on this below, because it is the sneaky-good part.

### Why persistence is a separate thing from volatility

This trips people up, so here is the picture.

Throw a stone into a pond. **Volatility** is how big the splash is. **Persistence** is how long the ripples take to die away.

Standard models assume the ripples die away fast, exponentially. Research on the Colombo exchange says they do not. They die away slowly, lingering long after the stone has sunk.

Why that matters practically: after a crash, a standard risk system looks at today's calm surface and says "fine, back to normal, put the money back in." If the ripples are still travelling, it has put the money back too early. Colombo took the Easter attacks, then COVID, then the 2022 crisis, one after another, so this is not a theoretical worry.

### Why trading costs are their own problem

Most systems assume trading is free, or that it costs a flat percentage.

On a big market that is nearly true. If you buy a thousand pounds of Apple, nobody notices.

On a thin market your order can be a big slice of everything that trades that day, so **buying pushes the price up before you have finished buying.** The cost depends on how big your order is relative to how much is available. I have not found a paper, for any market, that maps out the shape of that relationship by steadily increasing the order size and seeing what happens.

There is a second, subtler point, and it is the one that is actually a contribution. Every existing system calculates its ideal portfolio first and subtracts the trading cost afterwards. That is backwards. If the cost never enters the calculation, the system has no reason to prefer a cheaper route to the same destination. The cost should be **inside** the sum, not applied after it.

---

## The gaps, in plain words

### The main gap

Nothing in the papers I have read varies how much each adviser is listened to, continuously, based on measurable conditions outside that adviser, when the advisers work in genuinely different ways and all feed into one decision.

Several systems get **one part** of that right:

- One has a real dial with real mathematics behind it, but the dial controls how much money goes to each **share**, not how much attention goes to each **adviser**. It never asks which method to trust.
- One does move continuously with market conditions, but all six of its components are the same component, trained on the same data. It is adjusting between six copies of the same opinion.
- One has genuinely different advisers, which is the hard part, but where the dial should be there is a fixed paragraph of instructions. It lost 10.36 percentage points of return because one adviser went bad and nothing in the design could notice.
- One has a learning coordinator, but what it looks at is its own internal settings. It never looks out of the window at the market.

I have not found a system with all of it at once.

**There is also a local example, which is the most damning one.** A 2021 Colombo study combined two models and fixed the dial at three to one in favour of one of them, because that model had scored better on its own, on a different and easier test. The share each model actually got also drifted around depending on how many news articles happened to appear that day, which no one designed and no one analysed. That is the fixed-dial failure, on this exact market, with a visible dial to point at.

### Sub-gap one: what a trade really costs

Two papers do model cost against order size properly, and that was checked and admitted. What is still missing, across everything I have read: no curved cost relationship rather than a straight line, no sweep of order size to find the shape of the curve, no calibration to a thin market, and no system that puts the cost inside the calculation.

**Being honest about where this is weak.** There was a plan to measure the real trading spread from daily price data using a well-regarded 2024 method. That plan was dropped on 11 October. The method has not been tested on a thin market anywhere in that paper, and Colombo has no quote data to check its answer against, so a number produced that way could not be proven wrong even in principle. A number you cannot defend is worse than no number, because a number invites use. So the cost work currently runs on **indirect indicators** of how hard a share is to trade rather than a direct measurement of what trading costs. Say that out loud rather than letting someone find it.

### Sub-gap two: how long a shock lasts

Colombo researchers have measured the slow-fading property. They publish the number and stop. Meanwhile the portfolio systems that scale their risk up and down use a formula that assumes fast fading.

So there is a measured quantity on one side and a decision that needs it on the other, and nothing joining them.

The nice thing about this one is that **it can be tested without any Colombo data at all.** Take a published portfolio system, swap its fast-fading assumption for a slow-fading one, run it on that paper's own data, and see if the result improves. That removes this piece from the data-access bottleneck entirely. It should be the first experiment run.

---

## The contributions, in plain words

### 1. The dial itself. The main one.

A way of deciding how much to listen to each adviser, that updates continuously, from things measured about the market rather than things the advisers say about themselves.

**The honest framing.** This is not invented from nothing. There is an existing family of methods that sets combination weights from **features**, and the closest relative computes 42 features from the history of the thing being predicted. The difference, in one sentence: those features describe the thing being forecast, these describe the market conditions the forecaster is operating in, measured fresh at every step. Presenting it as "a known idea extended along a named axis" is stronger and safer than presenting it as brand new.

### 2. Measuring confidence instead of asking for it. Under-sold until now.

You cannot ask four very different components "how sure are you?" and compare the answers. The numbers do not mean the same thing.

So do not ask. **Look at the shape of what each one produced.**

- The accounts adviser outputs a small calculation. Does it parse? Does every number in it trace back to a real figure on a real page, or was one invented? How many steps long is it? Published results show accuracy falling from 68% to 59% to 23% as calculations go from one step to two to three or more, so **step count alone tells you how much to trust the answer**, without asking.
- The volatility adviser can be wrapped in a technique that produces a range rather than a point. When its model stops fitting reality, the range widens on its own. Wide range means trust it less. No one had to ask it anything.
- The chart adviser gets compared against the simplest possible forecast, "tomorrow will be like today." If it cannot beat that, it does not get a vote.
- Then, across all four, each one's score is passed through its own track record: *when this component said 0.7 in the past, how often was it actually right?* That turns four incomparable numbers into one comparable one: the probability of being right.

**Why this counts as a contribution rather than plumbing.** One published system declares a confidence field in its design, draws it in a diagram, and then never uses it anywhere. Another feeds three AI-generated forecasts directly into a precise mathematical optimiser with no check on whether those forecasts were ever any good, which is precision applied to guesswork. Two published systems visibly avoided this problem. Having a method for it is worth something.

### 3. Letting an adviser say nothing.

The accounts adviser is expected to be unusable **more than half the time** on Colombo companies. Not occasionally imperfect. Usually absent.

So the system is built for that from the start. An adviser's influence can fall to a floor when its information channel is empty, and this is recorded as a deliberate state rather than happening by accident.

**The best sentence in the whole project is this one:** a published system called AlphaAgents had this exact problem, and a human being solved it by deleting one of the advisers by hand. This automates that decision and makes it reversible, so the adviser comes back when its information does.

One refinement found in the forecasting literature: do not take an adviser all the way to zero. Even a weak opinion carries a little information. Turn it down to a floor instead. A genuinely broken output, something that does not even parse, is the different case that does get a hard zero.

### 4. Trading cost inside the sum. Supporting, not headline.

A cost model that depends on order size against available depth, placed inside the optimisation rather than subtracted afterwards, plus the order-size sweep I have not found published for any market. The supervisor was explicit: this supports the main contribution, it is not a second headline. Self-rated 3 out of 5.

### 5. Slow-fading shocks setting the recovery schedule. Still a hypothesis.

Using the measured slow-fading number to decide how quickly to put money back to work after a shock, instead of the fast-fading assumption everyone uses. Self-rated 3.5 out of 5. The supervisor's position is that **until the experiment runs, this is a good idea rather than a result**, and that is how it should be described.

### 6. Not accidentally cheating. Small but real.

In a backtest it is very easy to let the system see information it could not have had at the time. One published Colombo system built a knowledge graph with no dates attached at all. Another picked the twenty biggest companies as of 2023 and then tested backwards to 2013, which quietly guarantees it only ever held winners.

Having a single clock that every part of the system reads from, so no component can ever see the future, is a small methodological contribution and I have not found another paper in this set that does it.

### 7. What the system can say about itself. One sentence, not a section.

The dial settings **are** the explanation. "On this day the system gave the accounts adviser almost no weight, because trading had dried up and the last filing was ten months old." That explanation falls out of the design for free.

This is different from the explainability claim that was correctly rejected earlier. That one was "I will combine several existing explanation tools," which is engineering rather than research. This one is narrower: the forecast combination literature lists *how to interpret combination weights* as one of its own unanswered questions, and this design produces exactly that quantity as a readable function of named inputs.

---

## The strongest argument against the whole thing

Worth knowing, because somebody will raise it and it is better to raise it yourself.

**Fifty years of forecasting research says that simply averaging your advisers equally is surprisingly hard to beat.** The usual reason clever weighting schemes lose is that the error in estimating the weights costs more than the better weights gain.

That literature gives two rules of thumb, and they point in opposite directions here:

1. When you do not have much historical data, use the simple average. **This one has weakened, and the honest thing is to say so.** I used to think the archive held only a few hundred trading days per company. It holds about 3,400 for the typical one, so the data is not as thin as that rule assumes. What survives is subtler: many of these companies do not trade every day, so the number of days on the calendar overstates how much there actually is to learn from. **Still points at equal weights, but less firmly than it did.**
2. When conditions change structurally, the simple average handles it worst and changing weights are the right response. Colombo's relationships demonstrably break across 2020 to 2022. **Points at the moving dial.**

Which effect wins on this data is the experiment, and the review that documents both rules says plainly that there is **no comprehensive guidance on when to choose which**. So an answer on a thin frontier market is worth having even if the answer is "equal weights won."

That last point is the one to internalise. **A negative result here is still a result**, provided the margin and the test are written down before the run rather than after.

---

## How the three pieces fit together

This is what makes it one project instead of three.

**The main gap is the machine. The two sub-gaps are the fuel.**

- How easy it is to trade tells you two things at once: what a trade costs, and how much to trust an adviser who reads prices (because on a thin market the prices themselves are noisy).
- How long shocks last tells you two things at once: how much risk to take, and how long to keep it reduced.

Without the sub-gaps the main gap is an empty promise. "The weights depend on market conditions" means nothing until you say which conditions and why those ones.

---

## Why Colombo specifically

The honest version, which is also the easier one to defend. Not "this market is scientifically unique." It is a **stress test**: a place where adviser reliability swings enough to tell a moving dial apart from a fixed one. The evidence, all of it local and measured:

- A finance journal studying Colombo companies switched to weekly data because **most shares do not trade every day**.
- Unexpected drops in tradability push returns down measurably, smaller companies more than larger ones.
- **Trading volume predicts the index. The economy-wide indicators do not.** That is unusual and it is the argument for putting liquidity at the centre.
- Relationships that held before 2020 weaken or break afterwards, found independently by two different studies. That is the clearest case for a system that adapts rather than one that is fixed.
- Company accounts are genuinely hard to get at. Three separate studies hand-typed their figures out of PDF annual reports, two of them with institutional access. One team had the exchange's own announcement feed and had to abandon it as too thin to use.
- About two thirds of shares are held by institutions, so the amount actually available to trade is far smaller than the company's size suggests.

---

## Where the project actually stands

| Piece | Honest status |
| --- | --- |
| The main idea, the moving dial | Provisionally approved by the supervisor as the central direction. The best-rated part |
| Measuring confidence structurally | Mechanism now exists for all four advisers. Whether the four are truly comparable is open, and said to be open |
| Letting an adviser abstain | Designed, and now positioned in the forecasting literature's own vocabulary rather than as something bespoke |
| Trading cost | Narrowed honestly, rated 3 out of 5, and carrying two caveats that have to be stated together |
| Slow-fading shocks | A strong hypothesis. Becomes a contribution when one experiment runs, and that experiment needs no Colombo data |
| Price data | 355 companies, mid-2012 to mid-2026. Secured, and now corrected for share splits and similar events, which it was not until late October |
| Trading-activity data | Turnover and the number of trades are held across the whole period, which I previously recorded as missing. **Bid, ask and depth are still missing**, and that is now the only data gap that bites |
| Company accounts | **Secured.** 22,893 filings covering 2012 to 2026, each one carrying the date it was published, which is what stops the system reading a report before it existed |

**The single most important practical consequence, and it has narrowed.** Most of what was blocking this project in October has since been secured: the price history, the trading activity, the corrections for share splits, and the company accounts. One gap is left. The request to the exchange for bid, ask and depth data is the only route to a real measurement of what a trade costs on this market, so it should be the headline item in that request rather than one line among several. Everything else can proceed without it, using indirect indicators, provided that is said out loud.

---

## Four sentences for when somebody asks what you are doing

> Systems that combine several AI analysts into one trading decision almost always combine them the same way every day, regardless of conditions. That is fine when all the analysts are equally reliable, which is roughly true on a big market, and false on a small one where some information channels regularly go empty. I am building the thing that adjusts how much each analyst is listened to, continuously, based on measurable conditions, and testing it against the fixed alternatives on the Colombo Stock Exchange. The honest framing is that this extends a known family of methods along one named axis, and the test is designed so that "it did not help" is a publishable answer too.
