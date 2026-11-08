/* Student
 * Author: User
 * Creation date: 10/9/2026
 */
MACHINE
    Student
    
SETS NAMES={Alex, Bob, Charles}; MESSAGE={Yes, No}
    
CONSTANTS
    passMark
PROPERTIES
    passMark: NAT & passMark=40
    
VARIABLES
    name, mark
INVARIANT
    name:NAMES & mark: NAT & mark <=100
    
INITIALISATION
    name:=Alex || mark:= 65
   
OPERATIONS
    
    
    result <--isPassed=
    IF mark>=passMark
    THEN
        result:= Yes
    ELSE
        result := No
    END;
    
    result <--canVote(age)=
    PRE age : NAT1
    THEN
      
        IF age>=18
        THEN
            result:= Yes
        ELSE
            result:= No
        END
    END
    
    
    
    

END
