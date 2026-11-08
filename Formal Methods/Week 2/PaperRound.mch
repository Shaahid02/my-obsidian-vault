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
    END           
    
      
END /* PaperRound */