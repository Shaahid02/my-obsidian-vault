/* ChessTournament

* Author: Shahid.f

* Module: 6SENG005W Formal Methods - Coursework 2026/27

* Description: B specification of a chess tournament with three phases:

* team selection, match setup and game play.

*/

MACHINE

ChessTournament

  

SETS

/* The 12 players, listed from strongest (Alice) to weakest (Louis) */

PLAYER = { Alice, Bob, Christine, Dennis, Eloise, Frank,

Gabrielle, Hugo, Ida, John, Kate, Louis } ;

  

/* The three teams */

TEAM = { red, blue, green } ;

  

/* The three phases of the tournament */

PHASE = { teamSelection, matchSetup, gamePlay } ;

  

/* Messages returned by the operations */

REPORT = { success, teamsCompleted,

/* general */

wrongPhase,

/* setPlayers errors */

teamAlreadyHasPlayers, notExactlyFourPlayers, playerAlreadyInTeam,

/* setupMatch errors */

samePlayer, matchAlreadyScheduled, playersInSameTeam,

playerHasSixMatches, teamsHaveTwelveMatches,

/* undo errors */

noMatchesScheduled,

/* proceed errors */

notAllPlayersHaveSixMatches, notTwelveMatchesPerTeamPair,

/* nextGame errors */

noGamesLeft }

  

CONSTANTS

ability, /* relative level of ability of each player */

MAX_TEAM_SIZE, /* 4 players per team */

MAX_PLAYER_MATCHES, /* up to 6 matches per player */

MAX_TEAM_MATCHES /* up to 12 matches between each pair of teams */

  

PROPERTIES

/* ability is a bijection: every player has a different ability level.

A higher number means a stronger player (Alice = 12 ... Louis = 1). */

ability : PLAYER >->> 1..12 &

ability = { Alice |-> 12, Bob |-> 11, Christine |-> 10, Dennis |-> 9,

Eloise |-> 8, Frank |-> 7, Gabrielle |-> 6, Hugo |-> 5,

Ida |-> 4, John |-> 3, Kate |-> 2, Louis |-> 1 } &

MAX_TEAM_SIZE = 4 &

MAX_PLAYER_MATCHES = 6 &

MAX_TEAM_MATCHES = 12

  

DEFINITIONS

/* all players that are currently in some team */

assignedPlayers == union(ran(teamMembers)) ;

  

/* the scheduled matches that involve player pp (either side of the pair) */

matchesOf(pp) == ( ran(schedule) /\ (({pp} * PLAYER) \/ (PLAYER * {pp})) ) ;

  

/* the scheduled matches between team t1 and team t2 (either way round) */

matchesBetween(t1, t2) ==

( ran(schedule) /\ ((teamMembers(t1) * teamMembers(t2)) \/

(teamMembers(t2) * teamMembers(t1))) )

  

VARIABLES

phase, /* current phase of the tournament */

teamMembers, /* current members of each team */

schedule, /* scheduled matches, in the order they were scheduled */

playerScore, /* score of each player */

teamScore /* score of each team */

  

INVARIANT

/* ---------- typing ---------- */

phase : PHASE &

teamMembers : TEAM --> POW(PLAYER) &

schedule : iseq(PLAYER * PLAYER) & /* injective: no match twice */

playerScore : PLAYER --> NATURAL &

teamScore : TEAM --> NATURAL &

  

/* ---------- teams ---------- */

/* each team has up to 4 players */

!tt.(tt : TEAM => card(teamMembers(tt)) <= MAX_TEAM_SIZE) &

/* a player can be in at most one team (teams are disjoint) */

!(t1, t2).(t1 : TEAM & t2 : TEAM & t1 /= t2 =>

teamMembers(t1) /\ teamMembers(t2) = {}) &

  

/* ---------- matches ---------- */

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

  

/* ---------- scores ---------- */

/* a team's score is the sum of its players' scores */

!tt.(tt : TEAM =>

teamScore(tt) = SIGMA(pp).(pp : teamMembers(tt) | playerScore(pp))) &

  

/* ---------- phase consistency ---------- */

/* during team selection: at most one team filled, nothing scheduled, scores 0 */

(phase = teamSelection =>

card({tt | tt : TEAM & teamMembers(tt) /= {}}) <= 1 &

schedule = [] &

playerScore = PLAYER * {0}) &

/* after team selection: every team has exactly 4 players */

(phase /= teamSelection =>

!tt.(tt : TEAM => card(teamMembers(tt)) = MAX_TEAM_SIZE)) &

/* during match setup no game has been played yet */

(phase = matchSetup => playerScore = PLAYER * {0}) &

/* during game play: games played (= points awarded) + games left = 36 */

(phase = gamePlay =>

SIGMA(pp).(pp : PLAYER | playerScore(pp)) + size(schedule) = 36)

  

INITIALISATION

phase := teamSelection ||

teamMembers := { red |-> {}, blue |-> {}, green |-> {} } ||

schedule := [] ||

playerScore := PLAYER * {0} ||

teamScore := TEAM * {0}

  

OPERATIONS

  

/* ------------------------------------------------------------------ */

/* Add the 4 players in members to team. When the second team is */

/* completed, the remaining 4 players go to the last empty team and */

/* the phase moves to match setup. */

/* ------------------------------------------------------------------ */

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

/* this is the first team to be completed */

teamMembers(team) := members ||

report := success

ELSE

/* this is the second team: fill the one remaining empty team */

ANY lastTeam WHERE

lastTeam : TEAM & lastTeam /= team & teamMembers(lastTeam) = {}

THEN

teamMembers := teamMembers <+

{ team |-> members,

lastTeam |-> PLAYER - (assignedPlayers \/ members) } ||

phase := matchSetup ||

report := teamsCompleted

END

END

END ;

  

/* ------------------------------------------------------------------ */

/* Schedule a match between the given pair of players. */

/* ------------------------------------------------------------------ */

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

report := success

END

END

END ;

  

/* ------------------------------------------------------------------ */

/* Remove the most recently scheduled match (the last in the sequence)*/

/* ------------------------------------------------------------------ */

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

  

/* ------------------------------------------------------------------ */

/* Move to the game play phase once the schedule is complete. */

/* Note: if every player has exactly 6 matches, each pair of teams */

/* must have exactly 12 (each team has 4 x 6 = 24 match places, so */

/* RB + RG = RB + BG = RG + BG = 24, giving 12 each). The second */

/* check is kept because the requirements list both conditions. */

/* ------------------------------------------------------------------ */

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

phase := gamePlay ||

report := success

END

END ;

  

/* ------------------------------------------------------------------ */

/* Play the first scheduled game. The more able player always wins. */

/* ------------------------------------------------------------------ */

report <-- nextGame =

BEGIN

IF phase /= gamePlay THEN

report := wrongPhase

ELSIF schedule = [] THEN

report := noGamesLeft

ELSE

LET winner BE

/* the player in the first match with the highest ability */

winner = ability~(max(ability[{ prj1(PLAYER, PLAYER)(first(schedule)),

prj2(PLAYER, PLAYER)(first(schedule)) }]))

IN

ANY winnerTeam WHERE

winnerTeam : TEAM & winner : teamMembers(winnerTeam)

THEN

playerScore(winner) := playerScore(winner) + 1 ||

teamScore(winnerTeam) := teamScore(winnerTeam) + 1 ||

schedule := tail(schedule) ||

report := success

END

END

END

END ;

  

/* ------------------------------------------------------------------ */

/* Go back to team selection, resetting teams and scores. */

/* Only allowed in game play once all games have been played. */

/* ------------------------------------------------------------------ */

restart =

PRE

phase = gamePlay & schedule = []

THEN

phase := teamSelection ||

teamMembers := { red |-> {}, blue |-> {}, green |-> {} } ||

playerScore := PLAYER * {0} ||

teamScore := TEAM * {0}

END ;

  

/* ------------------------------------------------------------------ */

/* Report the current score of every player in the given team. */

/* ------------------------------------------------------------------ */

scores <-- playerScores(team) =

PRE

team : TEAM

THEN

scores := teamMembers(team) <| playerScore

END

  

END