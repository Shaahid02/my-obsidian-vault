/* PaperRound
 * Author: draegek
 * Creation date: 19/10/2023
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

    answer <-- getsPapers( houseNumber ) =
    PRE
        houseNumber : NAT1 & houseNumber : houseNumbers
    THEN
        answer := 1    
    END; 


    cancelPapers( houseNumber ) = 
    PRE
        houseNumber : NAT1  &  houseNumber : houseNumbers
    THEN 
        houseNumbers := houseNumbers - { houseNumber }
    END
    
      
END /* PaperRound */