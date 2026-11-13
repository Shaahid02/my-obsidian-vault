/* NoughtsCrosses
 * Author: Shahid.f
 * Creation date: 11/12/2026
 */
MACHINE 
	NoughtsCrosses
SETS
	Players = {Noughts, Crosses};
	Results = {Success, Failure};
	Outcomes = {Noughts_win, Crosses_win, Draw, Ongoing}
CONSTANTS
	Grid, winningSubsets
PROPERTIES
	Grid = (1..3)*(1..3) &
	winningSubsets <: POW(Grid) &
	winningSubsets = { {1}*(1..3), {2}*(1..3), {3}*(1..3), 
			(1..3)*{1}, (1..3)*{2}, (1..3)*{3}, 
			id(1..3), {1|->3, 2|->2, 3|->1}}
VARIABLES
	noughts, crosses, currentOutcome, turn
INVARIANT
	noughts <: Grid & crosses <: Grid & noughts /\ crosses = {} & currentOutcome: Outcomes & turn:Players
INITIALISATION
	noughts := {} || crosses := {} || currentOutcome := Ongoing || turn:= Crosses
OPERATIONS
	
	res <-- placeSymbol(pp) =
	PRE
	    pp: Grid
	THEN
	    IF
	        pp:noughts\/crosses or currentOutcome /= Ongoing
	    THEN
	        res:= Failure
	    ELSE
	        IF
	            turn = Crosses
	        THEN
	            crosses := crosses \/ { pp } ||
	            turn:= Noughts ||
	            IF
	                POW(crosses \/ {pp}) /\ winningSubsets /= {}
	            THEN
	                currentOutcome:= Crosses_win
	            ELSIF
	                noughts \/ crosses \/ {pp} = Grid
	            THEN
	                currentOutcome:= Draw
	            ELSE
	                currentOutcome:= Ongoing
	            END ||
	            res:= Success
	            
	        ELSE
	            noughts := noughts \/ { pp } ||
	            turn:= Crosses ||
	            IF
	                POW(noughts \/ {pp}) /\ winningSubsets /= {}
	            THEN
	                currentOutcome:= Noughts_win
	            ELSIF
	                noughts \/ crosses \/ {pp} = Grid
	            THEN
	                currentOutcome:= Draw
	            ELSE
	                currentOutcome:= Ongoing
	            END ||
	            res:= Success
	            
	        END
	    END
	END
END





