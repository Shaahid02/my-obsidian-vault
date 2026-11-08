MACHINE 
	NoughtsCrosses
SETS
	Players = {Noughts, Crosses};
	Results = {Success, Failure}
CONSTANTS
	Grid, winningSubsets
PROPERTIES
	Grid = (1..3)*(1..3) &
	winningSubsets <: POW(Grid) &
	winningSubsets = { {1}*(1..3), {2}*(1..3), {3}*(1..3), 
			(1..3)*{1}, (1..3)*{2}, (1..3)*{3}, 
			id(1..3), {1|->3, 2|->2, 3|->1}}
VARIABLES
	noughts, crosses
INVARIANT
	noughts <: Grid & crosses <: Grid & noughts /\ crosses = {}
INITIALISATION
	noughts := {} || crosses := {}
OPERATIONS

	res <-- placeNought(pp) = 
	PRE
		pp : Grid
	THEN
		IF 
			pp : noughts \/ crosses
		THEN
			res := Failure
		ELSE
			noughts := noughts \/ { pp } ||
			res := Success
		END
	END;

	res <-- placeCross(pp) = 
	PRE
		pp : Grid
	THEN
		IF 
			pp : noughts \/ crosses
		THEN
			res := Failure
		ELSE
			crosses := crosses \/ { pp } ||
			res := Success
		END
	END


END




