/* ChessTournament
 * Author: Shahid.f
 */
MACHINE
    ChessTournament

SETS
    PLAYER = { Alice, Bob, Christine, Dennis, Eloise, Frank,
               Gabrielle, Hugo, Ida, John, Kate, Louis } ;

    
    TEAM   = { red, blue, green } ;

    
    PHASE  = { teamSelection, matchSetup, gamePlay } ;

    
    REPORT = { success, teamsCompleted,
               wrongPhase,
               teamAlreadyHasPlayers, notExactlyFourPlayers, playerAlreadyInTeam,
               samePlayer, matchAlreadyScheduled, playersInSameTeam,
               playerHasSixMatches, teamsHaveTwelveMatches,
               noMatchesScheduled,
               notAllPlayersHaveSixMatches, notTwelveMatchesPerTeamPair,
               noGamesLeft }

CONSTANTS
    ability,           
    MAX_TEAM_SIZE,      
    MAX_PLAYER_MATCHES, 
    MAX_TEAM_MATCHES 
    
PROPERTIES
    /* Where 12 is the highest and 1 is the lowest in ability */
    ability : PLAYER >->> 1..12 &
    ability = { Alice |-> 12, Bob |-> 11, Christine |-> 10, Dennis |-> 9,
                Eloise |-> 8, Frank |-> 7, Gabrielle |-> 6, Hugo |-> 5,
                Ida |-> 4, John |-> 3, Kate |-> 2, Louis |-> 1 } &
    MAX_TEAM_SIZE      = 4  &
    MAX_PLAYER_MATCHES = 6  &
    MAX_TEAM_MATCHES   = 12

DEFINITIONS
    assignedPlayers == union(ran(teamMembers)) ;

    matchesOf(pp) == ( ran(schedule) /\ (({pp} * PLAYER) \/ (PLAYER * {pp})) ) ;
    
    matchesBetween(t1, t2) ==
        ( ran(schedule) /\ ((teamMembers(t1) * teamMembers(t2)) \/
                            (teamMembers(t2) * teamMembers(t1))) )

VARIABLES
    phase,        
    teamMembers,  
    schedule,     
    playerScore,  
    teamScore

INVARIANT
    phase       : PHASE &
    teamMembers : TEAM --> POW(PLAYER) &
    schedule    : iseq(PLAYER * PLAYER) &
    playerScore : PLAYER --> NATURAL &
    teamScore   : TEAM --> NATURAL &

    
    /* each team has up to 4 players */
    !tt.(tt : TEAM => card(teamMembers(tt)) <= MAX_TEAM_SIZE) &
    /* a player can be in at most one team (teams are disjoint) */
    !(t1, t2).(t1 : TEAM & t2 : TEAM & t1 /= t2 =>
               teamMembers(t1) /\ teamMembers(t2) = {}) &

    /* each match involves two players from different teams */
    !(p1, p2).(p1 : PLAYER & p2 : PLAYER & (p1 |-> p2) : ran(schedule) =>
               #(t1, t2).(t1 : TEAM & t2 : TEAM & t1 /= t2 &
                          p1 : teamMembers(t1) & p2 : teamMembers(t2))) &
    /* the same two players are never scheduled twice (in either order) */
    !(p1, p2).(p1 : PLAYER & p2 : PLAYER & (p1 |-> p2) : ran(schedule) =>
               (p2 |-> p1) /: ran(schedule)) &
    /* up to 6 matches per player */
    !pp.(pp : PLAYER => card(matchesOf(pp)) <= MAX_PLAYER_MATCHES) &
    /* up to 12 matches between each pair of teams */
    !(t1, t2).(t1 : TEAM & t2 : TEAM & t1 /= t2 =>
               card(matchesBetween(t1, t2)) <= MAX_TEAM_MATCHES) &

    /* a team's score is the sum of its players' scores */
    !tt.(tt : TEAM =>
         teamScore(tt) = SIGMA(pp).(pp : teamMembers(tt) | playerScore(pp))) &

    /* after team selection: every team has exactly 4 players */
    (phase /= teamSelection =>
        !tt.(tt : TEAM => card(teamMembers(tt)) = MAX_TEAM_SIZE))

INITIALISATION
    phase       := teamSelection ||
    teamMembers := { red |-> {}, blue |-> {}, green |-> {} } ||
    schedule    := [] ||
    playerScore := PLAYER * {0} ||
    teamScore   := TEAM * {0}

OPERATIONS

    report <-- setPlayers(team, members) =
    PRE
        team : TEAM & members : POW(PLAYER)
    THEN
        IF phase /= teamSelection THEN
            report := wrongPhase
        ELSIF teamMembers(team) /= {} THEN
            report := teamAlreadyHasPlayers
        ELSIF card(members) /= MAX_TEAM_SIZE THEN
            report := notExactlyFourPlayers
        ELSIF members /\ assignedPlayers /= {} THEN
            report := playerAlreadyInTeam
        ELSIF assignedPlayers = {} THEN
            teamMembers(team) := members ||
            report := success
        ELSE
            ANY lastTeam WHERE
                lastTeam : TEAM & lastTeam /= team & teamMembers(lastTeam) = {}
            THEN
                teamMembers := teamMembers <+
                    { team |-> members,
                      lastTeam |-> PLAYER - (assignedPlayers \/ members) } ||
                phase  := matchSetup ||
                report := teamsCompleted
            END
        END
    END ;

    report <-- setupMatch(players) =
    PRE
        players : PLAYER * PLAYER
    THEN
        LET p1, p2 BE
            p1 = prj1(PLAYER, PLAYER)(players) &
            p2 = prj2(PLAYER, PLAYER)(players)
        IN
            IF phase /= matchSetup THEN
                report := wrongPhase
            ELSIF p1 = p2 THEN
                report := samePlayer
            ELSIF (p1 |-> p2) : ran(schedule) or (p2 |-> p1) : ran(schedule) THEN
                report := matchAlreadyScheduled
            ELSIF #tt.(tt : TEAM & p1 : teamMembers(tt) & p2 : teamMembers(tt)) THEN
                report := playersInSameTeam
            ELSIF card(matchesOf(p1)) >= MAX_PLAYER_MATCHES or
                  card(matchesOf(p2)) >= MAX_PLAYER_MATCHES THEN
                report := playerHasSixMatches
            ELSIF #(t1, t2).(t1 : TEAM & t2 : TEAM &
                             p1 : teamMembers(t1) & p2 : teamMembers(t2) &
                             card(matchesBetween(t1, t2)) >= MAX_TEAM_MATCHES) THEN
                report := teamsHaveTwelveMatches
            ELSE
                schedule := schedule <- players ||
                report   := success
            END
        END
    END ;

    report <-- undo =
    BEGIN
        IF phase /= matchSetup THEN
            report := wrongPhase
        ELSIF schedule = [] THEN
            report := noMatchesScheduled
        ELSE
            schedule := front(schedule) ||
            report   := success
        END
    END ;

    report <-- proceed =
    BEGIN
        IF phase /= matchSetup THEN
            report := wrongPhase
        ELSIF #pp.(pp : PLAYER & card(matchesOf(pp)) /= MAX_PLAYER_MATCHES) THEN
            report := notAllPlayersHaveSixMatches
        ELSIF #(t1, t2).(t1 : TEAM & t2 : TEAM & t1 /= t2 &
                         card(matchesBetween(t1, t2)) /= MAX_TEAM_MATCHES) THEN
            report := notTwelveMatchesPerTeamPair
        ELSE
            phase  := gamePlay ||
            report := success
        END
    END ;

    report <-- nextGame =
    BEGIN
        IF phase /= gamePlay THEN
            report := wrongPhase
        ELSIF schedule = [] THEN
            report := noGamesLeft
        ELSE
            LET p1, p2 BE
                p1 = prj1(PLAYER, PLAYER)(first(schedule)) &
                p2 = prj2(PLAYER, PLAYER)(first(schedule))
            IN
                ANY winner, winnerTeam WHERE
                    winner : {p1, p2} &
                    (ability(p1) > ability(p2) => winner = p1) &
                    (ability(p2) > ability(p1) => winner = p2) &
                    winnerTeam : TEAM & winner : teamMembers(winnerTeam)
                THEN
                    playerScore(winner)   := playerScore(winner) + 1 ||
                    teamScore(winnerTeam) := teamScore(winnerTeam) + 1 ||
                    schedule := tail(schedule) ||
                    report   := success
                END
            END
        END
    END ;

    restart =
    PRE
        phase = gamePlay & schedule = []
    THEN
        phase       := teamSelection ||
        teamMembers := { red |-> {}, blue |-> {}, green |-> {} } ||
        schedule    := [] ||
        playerScore := PLAYER * {0} ||
        teamScore   := TEAM * {0}
    END ;

    scores <-- playerScores(team) =
    PRE
        team : TEAM
    THEN
        scores := teamMembers(team) <| playerScore
    END

END
