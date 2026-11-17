/* ChessTournament

* Author: Shahid.f

*/

MACHINE

ChessTournament

  

SETS

PLAYER = { Alice, Bob, Christine, Dennis, Eloise, Frank,

Gabrielle, Hugo, Ida, John, Kate, Louis } ;

  

TEAM = { red, blue, green } ;

  

PHASE = { teamSelection, matchSetup, gamePlay } ;

  

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

/* 12 is the strongest player, 1 is the weakest */

ability : PLAYER >->> 1..12 &

ability = { Alice |-> 12, Bob |-> 11, Christine |-> 10, Dennis |-> 9,

Eloise |-> 8, Frank |-> 7, Gabrielle |-> 6, Hugo |-> 5,

Ida |-> 4, John |-> 3, Kate |-> 2, Louis |-> 1 } &

MAX_TEAM_SIZE = 4 &

MAX_PLAYER_MATCHES = 6 &

MAX_TEAM_MATCHES = 12

  

DEFINITIONS

/* first and second player of a match */

pA(mm) == prj1(PLAYER, PLAYER)(mm) ;

pB(mm) == prj2(PLAYER, PLAYER)(mm) ;

  

/* the two players of the next game to be played */

nextP1 == pA(first(schedule)) ;

nextP2 == pB(first(schedule)) ;

  

/* players currently in team tt */

membersOf(tt) == dom(teamOf |> {tt}) ;

  

/* scheduled matches involving player pp */

matchesOf(pp) == ({pp} <| ran(schedule)) \/ (ran(schedule) |> {pp}) ;

  

/* scheduled matches between teams t1 and t2, in either order */

matchesBetween(t1, t2) ==

((membersOf(t1) <| ran(schedule)) |> membersOf(t2)) \/

((membersOf(t2) <| ran(schedule)) |> membersOf(t1))

  

VARIABLES

phase,

teamOf,

schedule,

playerScore,

teamScore

  

INVARIANT

phase : PHASE &

teamOf : PLAYER +-> TEAM &

schedule : iseq(PLAYER * PLAYER) &

playerScore : PLAYER --> 0..MAX_PLAYER_MATCHES &

teamScore : TEAM --> 0..(MAX_TEAM_SIZE * MAX_PLAYER_MATCHES) &

  

/* each team has up to 4 players */

!(tt).(tt : TEAM => card(membersOf(tt)) <= MAX_TEAM_SIZE) &

  

/* each match involves two players from different teams */

!(p1, p2).(p1 : PLAYER & p2 : PLAYER & (p1 |-> p2) : ran(schedule) =>

p1 : dom(teamOf) & p2 : dom(teamOf) & teamOf(p1) /= teamOf(p2)) &

  

/* the same two players are never scheduled twice (in either order) */

!(p1, p2).(p1 : PLAYER & p2 : PLAYER & (p1 |-> p2) : ran(schedule) =>

(p2 |-> p1) /: ran(schedule)) &

  

/* up to 6 matches per player */

!(pp).(pp : PLAYER => card(matchesOf(pp)) <= MAX_PLAYER_MATCHES) &

  

/* up to 12 matches between each pair of teams */

!(t1, t2).(t1 : TEAM & t2 : TEAM & t1 /= t2 =>

card(matchesBetween(t1, t2)) <= MAX_TEAM_MATCHES) &

  

/* no matches exist during team selection */

(phase = teamSelection => schedule = []) &

  

/* after team selection every team has exactly 4 players */

(phase /= teamSelection =>

!(tt).(tt : TEAM => card(membersOf(tt)) = MAX_TEAM_SIZE)) &

  

/* scores only change during game play */

(phase /= gamePlay => ran(playerScore) = {0} & ran(teamScore) = {0})

  

INITIALISATION

phase := teamSelection ||

teamOf := {} ||

schedule := [] ||

playerScore := PLAYER * {0} ||

teamScore := TEAM * {0}

  

OPERATIONS

  

report <-- setPlayers(team, members) =

PRE

team : TEAM & members : POW(PLAYER)

THEN

IF phase /= teamSelection THEN

report := wrongPhase

ELSIF team : ran(teamOf) THEN

report := teamAlreadyHasPlayers

ELSIF card(members) /= MAX_TEAM_SIZE THEN

report := notExactlyFourPlayers

ELSIF members /\ dom(teamOf) /= {} THEN

report := playerAlreadyInTeam

ELSIF teamOf = {} THEN

/* first team */

teamOf := members * {team} ||

report := success

ELSE

/* second team: the 4 players left go into the one team

that is still empty, TEAM - (ran(teamOf) \/ {team}) */

teamOf := teamOf \/ (members * {team}) \/

((PLAYER - (dom(teamOf) \/ members)) *

(TEAM - (ran(teamOf) \/ {team}))) ||

phase := matchSetup ||

report := teamsCompleted

END

END ;

  

report <-- setupMatch(players) =

PRE

players : PLAYER * PLAYER

THEN

IF phase /= matchSetup THEN

report := wrongPhase

ELSIF pA(players) = pB(players) THEN

report := samePlayer

ELSIF players : ran(schedule) or

(pB(players) |-> pA(players)) : ran(schedule) THEN

report := matchAlreadyScheduled

ELSIF teamOf(pA(players)) = teamOf(pB(players)) THEN

report := playersInSameTeam

ELSIF card(matchesOf(pA(players))) >= MAX_PLAYER_MATCHES or

card(matchesOf(pB(players))) >= MAX_PLAYER_MATCHES THEN

report := playerHasSixMatches

ELSIF card(matchesBetween(teamOf(pA(players)), teamOf(pB(players))))

>= MAX_TEAM_MATCHES THEN

report := teamsHaveTwelveMatches

ELSE

schedule := schedule <- players ||

report := success

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

report := success

END

END ;

  

report <-- proceed =

BEGIN

IF phase /= matchSetup THEN

report := wrongPhase

ELSIF #(pp).(pp : PLAYER & card(matchesOf(pp)) /= MAX_PLAYER_MATCHES) THEN

report := notAllPlayersHaveSixMatches

ELSIF #(t1, t2).(t1 : TEAM & t2 : TEAM & t1 /= t2 &

card(matchesBetween(t1, t2)) /= MAX_TEAM_MATCHES) THEN

report := notTwelveMatchesPerTeamPair

ELSE

phase := gamePlay ||

report := success

END

END ;

  

report <-- nextGame =

BEGIN

IF phase /= gamePlay THEN

report := wrongPhase

ELSIF schedule = [] THEN

report := noGamesLeft

ELSIF ability(nextP1) > ability(nextP2) THEN

playerScore(nextP1) := playerScore(nextP1) + 1 ||

teamScore(teamOf(nextP1)) := teamScore(teamOf(nextP1)) + 1 ||

schedule := tail(schedule) ||

report := success

ELSE

playerScore(nextP2) := playerScore(nextP2) + 1 ||

teamScore(teamOf(nextP2)) := teamScore(teamOf(nextP2)) + 1 ||

schedule := tail(schedule) ||

report := success

END

END ;

  

restart =

PRE

phase = gamePlay & schedule = []

THEN

phase := teamSelection ||

teamOf := {} ||

playerScore := PLAYER * {0} ||

teamScore := TEAM * {0}

END ;

  

scores <-- playerScores(team) =

PRE

team : TEAM

THEN

scores := membersOf(team) <| playerScore

END

  

END