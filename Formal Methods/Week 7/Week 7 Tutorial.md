**Exercise 1:**

For each of these formulas, figure out what they mean and whether they are true:

- !(x,y).(x:NAT1 & y:NAT1 & (x mod y)=0 => x>=y)
- !(x).(x:NAT1 => #(y).(y:NAT1 & x<y & y<2*x))
- #(x,y).(x:NAT1 & y:NAT1 & (x+1) mod y = 0 & (y+1) mod x = 0)

**Exercise 2:**

In this exercise we want to model a simplified version of the "mine sweeper" game. The player can guess squares until they hit a mine; their score is the number of near misses(i.e. guesses which are next to a mine). Starting with this incomplete machine:

MACHINE Minefield
DEFINITIONS
    adjacent(pp,qq) == // TO DO
CONSTANTS
    Grid, Mines
PROPERTIES
    Grid = (1..8)*(1..8) & Mines <: Grid & Mines = {(2,2),(1,5),(6,3),(4,7),(5,2)}
VARIABLES
    // All the guesses made so far, and the number of near misses
    guesses, nearMisses
INVARIANT
    guesses<:Grid & nearMisses:NAT
INITIALISATION
    guesses:={} || nearMisses:=0
END

Add the following missing parts:

- the definition of isAdjacent which should be true if points pp and qq are adjacent, i.e. their x and y coordinates both differ by at most 1
- an operation gameOver which returns **Yes** if the set of guesses includes one of the mines, and **No** otherwise (you will also need to add the set of responses)
- an operation makeGuess(pp) which
- fails if pp has already been guessed
- fails if a mine has been guessed
- otherwise succeeds, adding the new guess to the guesses set. If the guess is adjacent to a mine, it also increases nearMisses.

**Exercise 3:**

This machine represents a graph:

MACHINE Graph
DEFINITIONS
    symmetric(RR) == // TO DO
SETS
    Colours = {red, green, blue, purple}
CONSTANTS
    Vertices, Edges, Colourings, Degrees
PROPERTIES
    Vertices <: NAT1 & Vertices = 1..6 &
    Edges <: Vertices*Vertices & Edges = symmetric({(1,3),(1,4),(1,6),(2,3),(2,5),(3,4),(3,6),(4,5),(5,6)}) &
    // TO DO: properties of Colourings and Degrees

Add the missing definition and properties:

- symmetric should complete a relation by adding the pairs going the other way, i.e. if RR contains (2,7) then symmetric(RR) should contain (2,7) and (7,2).
- Colourings should contain all colourings of the graph, i.e. ways of assigning colours to all vertices such that adjacent vertices never have the same colour.
- Degrees should assign to each Vertex its degree, i.e. the number of adjacent vertices.