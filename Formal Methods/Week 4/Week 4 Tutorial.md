The mch file above contains a version of the "Noughts and Crosses" game we discussed at the end of lecture 3.

We want to make the following changes:

**Exercise 4.1:** Introduce a new set of **outcomes** to represent the state of the game after a move. The possibilities are: Noughts win, Crosses win, Draw, or Ongoing (game not over yet). Also introduce a variable **currentOutcome** and make sure to give it a suitable invariant and initialisation.

**Exercise 4.2:** Introduce a variable **turn** to keep track of whose turn it is, with a suitable invariant and initialisation.

**Exercise 4.3:** Introduce an operation **res <-- placeSymbol( pp)** to replace the placeNought and placeCross operations. It should do the following:

- **Fail** if the square pp is already occupied **or** the game is already over.
- Otherwise
- **Succeed**
- place the **current player's symbol** in the square
- change the **turn** variable
- update the **current outcome**

**Exercise 4.4:** Introduce an operation **reset** which lets you start over.