/* *************************************************************
 * 6SENG005W Formal Methods
 * Machine:  Tube
 ************************************************************ */
 
MACHINE Tube

  SETS
      
    LINE = { Bakerloo, Victoria, Northern, Circle } ;

    STATION = { 
                // Bakerloo
                Baker_Street, Regents_Park, Oxford_Circus, Piccadilly_Circus, Charing_Cross,
                // Circle
                Great_Portland_Street, Euston_Square,
                // Victoria
                Warren_Street,  
                // Northern
                Goodge_Street, Tottenham_Court_Road, Leicester_Square
              } ;             
    
    JOURNEY_STATUS = { Journey_is_Empty,
                       Journey_Only_Has_Start_station, 
                       Journey_Has_Multiple_Stations
                     } ;
    
    REPORT = { Station_Added,
               Start_Station_Removed, 
               ERROR_Journey_Empty  
             }
    
    
  VARIABLES
      tube_journey

  INVARIANT
      tube_journey : iseq(STATION)
    
  INITIALISATION
      tube_journey := []
       
       
   /************************************************************/
   
   OPERATIONS
       
      
    AddToJourney( station ) =
        PRE 
            station : STATION  &  station /: ran( tube_journey ) 
        THEN 
            tube_journey  := tube_journey <- station 
        END ;



    report <-- RemoveStartStation = 
        PRE 
            report : REPORT
        THEN 
            skip 
        END ;


    status <-- JourneyStatus =
        PRE 
            status : JOURNEY_STATUS    
        THEN 
            IF  ( tube_journey = [] )
            THEN
                 status := Journey_is_Empty 
            ELSIF
                 ( size(tube_journey) = 1 ) 
            THEN
                 status := Journey_Only_Has_Start_station                  
             ELSE
                 status := Journey_Has_Multiple_Stations
            END 
        END 

       
END /* Tube */


