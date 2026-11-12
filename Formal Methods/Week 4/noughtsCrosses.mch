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
	            res:= Success ||
	            IF
	                POW(crosses) /\ winningSubsets /= {}
	            THEN
	                currentOutcome:= Crosses_win
	            ELSIF
	                noughts \/ crosses = Grid
	            THEN
	                currentOutcome:= Draw
	            ELSE
	                currentOutcome:= Ongoing
	            END
	            
	        ELSE
	            noughts := noughts \/ { pp } ||
	            turn:= Crosses ||
	            res:= Success ||
	            IF
	                POW(noughts) /\ winningSubsets /= {}
	            THEN
	                currentOutcome:= Noughts_win
	            ELSIF
	                noughts \/ crosses = Grid
	            THEN
	                currentOutcome:= Draw
	            ELSE
	                currentOutcome:= Ongoing
	            END
	            
	        END
	    END
	END
	
	    
	            
	        


END





