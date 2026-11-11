/* Favourites
 * Author: Shahid.f
 * Creation date: 11/11/2026
 */
MACHINE
    Favourites
SETS
    PEOPLE = { Alice, Bob, Charlie};
    COLOR = { Red, Blue, Green}
VARIABLES
    favColor
INVARIANT
    favColor: PEOPLE<->COLOR
INITIALISATION
    favColor:= {Alice |-> Red, Bob |-> Blue}
OPERATIONS
    
    addfavourite(person, color) =
    PRE
        person: PEOPLE & color:COLOR
    THEN
        favColor:= favColor \/ {person |-> color}
    END;
    
    removeFavourites(person, color) =
    PRE
        person: PEOPLE & color:COLOR & (person |-> color) : favColor
    THEN
        favColor:= favColor - {person |-> color}
    END;
    
    removeAllFavourites(person) =
    PRE
        person: PEOPLE
    THEN
        favColor:= {person} <<| favColor
    END;
    
    colors<--getFavouriteColor(person) =
    PRE
        person: PEOPLE & person: dom(favColor)
    THEN
        colors:= favColor[{person}]
    END;
    
    people<--getPeople(color) =
    PRE
        color: COLOR & color: ran(favColor)
    THEN
        people:= favColor~[{color}]
    END;
    
    updateFavourites(person, color) =
    PRE
        person: PEOPLE & color:COLOR
    THEN
        favColor:= favColor <+ {person |-> color}
    END;
    
    pairs<--getPeopleWithColors(colors) =
    PRE
        colors<: COLOR & colors /\ ran(favColor) /= {}
    THEN
        pairs:= favColor |> colors
    END
    
    
    
END
