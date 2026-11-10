/* PaperRound
 * Author: Shahid.f
 * Creation date: 11/10/2026
 */
MACHINE PaperRound
    

SETS
    Answers = {YES, NO}

    VARIABLES 
        houseNumbers
    
    INVARIANT 
        houseNumbers <: NAT1 

    INITIALISATION 
        houseNumbers := {} 


    OPERATIONS

    addNewHouse( newHouse ) =
    PRE
        newHouse : NAT1  &  newHouse /: houseNumbers
    THEN 
        houseNumbers := houseNumbers \/ { newHouse }
    END;

    numbHouses <-- howManyHouses =
    BEGIN
        numbHouses := card( houseNumbers )
    END;
    
    ans <-- getsPapers(houseNumber) = 
    PRE
        houseNumber: NAT1 & houseNumber : houseNumbers
    THEN
        ans := 1
    END;
    
    cancelPapers(houseNumber) =
    PRE
        houseNumber: NAT1 & houseNumber : houseNumbers
    THEN
        houseNumbers:= houseNumbers - {houseNumber}
    END
    
    
    
      
END /* PaperRound */
