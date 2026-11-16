/* Family
 * Author: Shahid.f
 * Creation date: 11/13/2026
 */
MACHINE  Family
    
  SETS
    PEOPLE = { Grandad, Paul, Jim, Mary, Ian, Jack, Jill, Jane, Bill, Joe } ;
    
    SEX =  { Male, Female } ;
          
    REPORT =  { Success,                   Error_NotAFamilyMember,       
	            Error_MalesCantHaveBabies, Error_AlreadyUsedName, Error_PassportNumberAlreadyTaken, Error_DoesNotHaveAPassport, Error_NumberAlreadyInUse  } ;

    ANSWER =   { Yes, No, Do_Not_Know}
    
  CONSTANTS
    PASSPORT_NUMBERS

  PROPERTIES
    PASSPORT_NUMBERS = NAT1

  
  VARIABLES
    family,
    age,
    sex,
    passport,
    parentOf,
    myMum
  
  INVARIANT
    family  <: PEOPLE     &
    age : PEOPLE +-> NAT   &  dom(age) = family  &
    sex : PEOPLE +-> SEX   &  dom(sex) = family  &
    passport: PEOPLE >+> PASSPORT_NUMBERS & dom(passport) <: family &
    parentOf: PEOPLE <-> PEOPLE & dom(parentOf) <: family & ran(parentOf) <: family &
    myMum: PEOPLE +-> PEOPLE &  dom(myMum) <: family & ran(myMum) <: family & ran(myMum) <: sex~[{Female}]    

  INITIALISATION
       family := { Grandad, Paul, Mary, Jim, Jane, Jill }  
    ||
       age    := { Grandad |-> 100, Paul |-> 41, Jim |-> 15, 
                   Jane |-> 11,     Mary |-> 40, Jill |-> 4 }  
    ||
       sex    := { Paul |-> Male,   Mary |-> Female, Jim |-> Male,
                   Jane |-> Female, Jill |-> Female, Grandad |-> Male }  
    ||
        passport:= {}
    
    ||
        parentOf:= {}
    ||
        myMum:= {}
  
  
  OPERATIONS
    
    report <-- HadBirthday( person ) =
               PRE
                   person : PEOPLE
               THEN
                   IF   ( person : family )
                   THEN
                         age    := age <+ { person |-> (age(person) + 1) }  ||
                         report := Success
                   ELSE 
                         /* ( person /: family ) */
                         report := Error_NotAFamilyMember
                   END
               END ;
              
              
    report <-- PersonDies( person ) =
              PRE
                  person: PEOPLE
              THEN
                  IF    (person: family)
                  THEN
                      family := family - {person} ||
                      age:= {person} <<| age ||
                      sex := {person} <<| sex ||
                      parentOf:= {person} <<| parentOf |>> {person} ||
                      myMum:= {person} <<| myMum |>> {person}
                      report:= Success
                  ELSE
                      report := Error_NotAFamilyMember
                  END
              END;
              
                      
                      
    report <-- HadABaby( mother, baby, babysex ) =
              PRE
                  mother: PEOPLE & baby: PEOPLE & babysex: SEX & mother /= baby
              THEN
                  IF    (mother: family)
                  THEN
                      IF sex(mother) = Female
                      THEN
                          IF baby/:family
                          THEN
                              
                              family:= family \/ {baby} ||
                              age:= age <+ {baby |-> 0} ||
                              sex:= sex <+ {baby |-> babysex} ||
                              parentOf:= parentOf \/ { mother |-> baby} ||
                              myMum:= myMum \/ {baby |-> mother}
                              report:= Success
                          ELSE
                              report:= Error_AlreadyUsedName
                          END
                      ELSE
                          report:= Error_MalesCantHaveBabies
                      END
                  ELSE
                      report:= Error_NotAFamilyMember
                  END
              END;
              
                          
                              
                      
   
    answer <-- DoesAFamilyMemberHaveThisSex( ss ) =
              PRE
                  ss: SEX
              THEN
                  IF sex~[{ss}] /= {}
                  THEN
                      answer:= Yes
                  ELSE
                      answer:= No
                  END
              END;
              
   report <-- firstPassport(person, passportNo) =
             PRE
                 person: PEOPLE & passportNo: PASSPORT_NUMBERS & person/:dom(passport)
             THEN
                 IF person: family
                 THEN
                     IF passportNo/: ran(passport)
                     THEN
                         passport:= passport <+ {person |-> passportNo} ||
                         report:= Success
                     ELSE
                         report:=  Error_PassportNumberAlreadyTaken
                     END
                 ELSE
                     report:= Error_NotAFamilyMember
                 END
             END;
             
    report <-- renewPassport(person, newPassportNo) =
              PRE
                  person: PEOPLE & newPassportNo: PASSPORT_NUMBERS
              THEN
                  IF person: family
                  THEN
                      IF person: dom(passport)
                      THEN
                          IF newPassportNo/: ran(passport)
                          THEN
                              passport:= passport <+ {person |-> newPassportNo} ||
                              report:= Success
                          ELSE
                              report:= Error_NumberAlreadyInUse
                          END
                      ELSE
                          report:= Error_DoesNotHaveAPassport
                      END
                  ELSE
                      report:= Error_NotAFamilyMember
                  END
              END;
              
    report <-- hasChildren(person) =
              PRE
                  person: PEOPLE
              THEN
                  IF person: family
                  THEN
                      IF person: dom(parentOf)
                      THEN
                          report:= Yes
                      ELSE
                          report:= No
                      END
                  ELSE
                      report:= Do_Not_Know
                  END
              END
END 
