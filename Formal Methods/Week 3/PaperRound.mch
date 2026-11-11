/* PaperRound
 * Author: Shahid.f
 * Creation date: 11/10/2026
 */
MACHINE PaperRound
    

SETS
    Answers = {YES, NO};
    MESSAGES = {House_has_paper, House_does_not_have_paper, House_removed_successfully, House_does_not_have_a_paper_delivery, House_gets_delivered_paper_and_magazine, House_gets_delivered_paper, House_gets_delivered_magazine, House_does_not_have_magazine_or_paper_delivery, Stopped_magazine_and_paper_delivery, House_gets_nothing_delivered}

    VARIABLES 
        houseNumbers,
        magazineSet
    
    INVARIANT 
        houseNumbers <: NAT1 & card(houseNumbers) <= 10 &
        magazineSet <: NAT1 & magazineSet <: houseNumbers

    INITIALISATION 
        houseNumbers := {} ||
        magazineSet:= {}


    OPERATIONS

    addNewHouse( newHouse ) =
    PRE
        newHouse : NAT1  &  newHouse /: houseNumbers & card(houseNumbers) < 10
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
        houseNumbers:= houseNumbers - {houseNumber} ||
        magazineSet:= magazineSet - {houseNumber}
    END;
    
    house <-- firstHouse =
    PRE
        houseNumbers /= {}
    THEN
        house := min(houseNumbers)
    END;
    
    house <-- lastHouse =
    PRE
        houseNumbers /= {}
    THEN
        house := max(houseNumbers)
    END;
    
    message <-- hasPaper(houseNumber) =
    PRE
        houseNumber: NAT1
    THEN
        IF
        houseNumber: houseNumbers
        THEN
            message:= House_has_paper
        ELSE
            message := House_does_not_have_paper
        END
    END;
    
    message <-- stopDelivery(houseNumber) =
    PRE
        houseNumber: NAT1
    THEN
        IF
            houseNumber: houseNumbers
        THEN
            houseNumbers:= houseNumbers - {houseNumber} ||
            magazineSet:= magazineSet - {houseNumber} ||
            message:= House_removed_successfully
        ELSE
            message:= House_does_not_have_a_paper_delivery
        END
    END;
    
    deliverMagazine(houseNumber) =
    PRE
        houseNumber : NAT1  &  houseNumber /: magazineSet & houseNumber: houseNumbers
    THEN
        magazineSet:= magazineSet \/ {houseNumber}
    END;
    
    stopMagazine(houseNumber) =
    PRE
        houseNumber : NAT1  &  houseNumber: magazineSet
    THEN
        magazineSet:= magazineSet - {houseNumber}
    END;
    
    message <-- deliveries(houseNumber) =
    PRE
        houseNumber : NAT1
    THEN
        IF
            houseNumber: houseNumbers /\ magazineSet
        THEN
            message:= House_gets_delivered_paper_and_magazine
        ELSIF
            houseNumber: houseNumbers
        THEN
            message:= House_gets_delivered_paper
        ELSIF
            houseNumber: magazineSet
        THEN
            message:= House_gets_delivered_magazine
        ELSE
            message:= House_gets_nothing_delivered
        END
    END;
    
    message <-- stopAllDeliveries(houseNumber) =
    PRE
        houseNumber: NAT1
    THEN
        IF
            houseNumber: houseNumbers /\ magazineSet
        THEN
            houseNumbers:= houseNumbers - {houseNumber} ||
            magazineSet:= magazineSet - {houseNumber} ||
            message:= Stopped_magazine_and_paper_delivery
        ELSE
            message:= House_does_not_have_magazine_or_paper_delivery
        END
    END;
    
    ans <-- howManyMore =
    BEGIN
        ans:= 10 - card(houseNumbers)
    END
    
      
END /* PaperRound */
