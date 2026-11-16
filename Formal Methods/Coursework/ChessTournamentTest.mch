/* ChessTournamentTest
 * TEST DRIVER ONLY - do NOT submit this file. Submit ChessTournament.mch.
 *
 * It includes ChessTournament and replays one complete tournament, plus the
 * error cases, through operations that need no parameters. Exactly one
 * operation is enabled at a time, so the whole script can be run with
 * Animate > Random Animation Steps... (enter 200).
 *
 * Each operation name ends with the report it should return, so in the
 * History pane every line should read  ..._expect_X-->X .
 * The script ends in a deadlock on purpose (nothing left to run).
 */
MACHINE
    ChessTournamentTest

INCLUDES
    ChessTournament

CONSTANTS
    testMatches     /* the 36 matches of a complete, valid schedule */

PROPERTIES
    testMatches : seq(PLAYER * PLAYER) &
    testMatches = [
        (Alice |-> Frank), (Alice |-> Gabrielle), (Alice |-> Hugo),
        (Bob |-> Eloise), (Bob |-> Gabrielle), (Bob |-> Hugo),
        (Christine |-> Eloise), (Christine |-> Frank), (Christine |-> Hugo),
        (Dennis |-> Eloise), (Dennis |-> Frank), (Dennis |-> Gabrielle),
        (Alice |-> John), (Alice |-> Kate), (Alice |-> Louis),
        (Bob |-> Ida), (Bob |-> Kate), (Bob |-> Louis),
        (Christine |-> Ida), (Christine |-> John), (Christine |-> Louis),
        (Dennis |-> Ida), (Dennis |-> John), (Dennis |-> Kate),
        (Eloise |-> John), (Eloise |-> Kate), (Eloise |-> Louis),
        (Frank |-> Ida), (Frank |-> Kate), (Frank |-> Louis),
        (Gabrielle |-> Ida), (Gabrielle |-> John), (Gabrielle |-> Louis),
        (Hugo |-> Ida), (Hugo |-> John), (Hugo |-> Kate)
    ]

VARIABLES
    step,   /* which part of the script comes next */
    idx     /* next entry of testMatches to schedule */

INVARIANT
    step : 0..28 & idx : 1..37 &
    /* after all 36 games: the stronger player won every game */
    (step : 23..27 =>
        teamScore = { red |-> 24, blue |-> 12, green |-> 0 } &
        playerScore = { Alice |-> 6, Bob |-> 6, Christine |-> 6, Dennis |-> 6, Eloise |-> 3, Frank |-> 3,
                        Gabrielle |-> 3, Hugo |-> 3, Ida |-> 0, John |-> 0, Kate |-> 0, Louis |-> 0 }) &
    /* after restart: back to the initial state */
    (step = 28 =>
        phase = teamSelection & schedule = [] &
        teamMembers = { red |-> {}, blue |-> {}, green |-> {} } &
        playerScore = PLAYER * {0} & teamScore = TEAM * {0})

INITIALISATION
    step := 0 || idx := 1

OPERATIONS

    rr <-- t00_matchBeforeTeams_expect_wrongPhase =
    PRE step = 0 THEN
        rr <-- setupMatch((Alice |-> Eloise)) || step := 1
    END ;

    rr <-- t01_threePlayers_expect_notExactlyFourPlayers =
    PRE step = 1 THEN
        rr <-- setPlayers(red, {Alice, Bob, Christine}) || step := 2
    END ;

    rr <-- t02_setRed_expect_success =
    PRE step = 2 THEN
        rr <-- setPlayers(red, {Alice, Bob, Christine, Dennis}) || step := 3
    END ;

    rr <-- t03_redAgain_expect_teamAlreadyHasPlayers =
    PRE step = 3 THEN
        rr <-- setPlayers(red, {Eloise, Frank, Gabrielle, Hugo}) || step := 4
    END ;

    rr <-- t04_aliceTwice_expect_playerAlreadyInTeam =
    PRE step = 4 THEN
        rr <-- setPlayers(blue, {Alice, Frank, Gabrielle, Hugo}) || step := 5
    END ;

    rr <-- t05_setBlue_expect_teamsCompleted =
    PRE step = 5 THEN
        rr <-- setPlayers(blue, {Eloise, Frank, Gabrielle, Hugo}) || step := 6
    END ;

    rr <-- t06_setGreenTooLate_expect_wrongPhase =
    PRE step = 6 THEN
        rr <-- setPlayers(green, {Ida, John, Kate, Louis}) || step := 7
    END ;

    rr <-- t07_undoNothing_expect_noMatchesScheduled =
    PRE step = 7 THEN
        rr <-- undo || step := 8
    END ;

    rr <-- t08_proceedTooEarly_expect_notAllPlayersHaveSixMatches =
    PRE step = 8 THEN
        rr <-- proceed || step := 9
    END ;

    rr <-- t09_samePlayer_expect_samePlayer =
    PRE step = 9 THEN
        rr <-- setupMatch((Alice |-> Alice)) || step := 10
    END ;

    rr <-- t10_sameTeam_expect_playersInSameTeam =
    PRE step = 10 THEN
        rr <-- setupMatch((Alice |-> Bob)) || step := 11
    END ;

    rr <-- t11_firstMatch_expect_success =
    PRE step = 11 THEN
        rr <-- setupMatch((Alice |-> Eloise)) || step := 12
    END ;

    rr <-- t12_sameMatchReversed_expect_matchAlreadyScheduled =
    PRE step = 12 THEN
        rr <-- setupMatch((Eloise |-> Alice)) || step := 13
    END ;

    rr <-- t13_undoFirstMatch_expect_success =
    PRE step = 13 THEN
        rr <-- undo || step := 14
    END ;

    /* schedule the 12 red v blue matches */
    rr <-- t14_setupRedBlue_expect_success =
    PRE step = 14 & idx <= 12 THEN
        rr <-- setupMatch(testMatches(idx)) ||
        idx := idx + 1 ||
        IF idx = 12 THEN step := 15 END
    END ;

    rr <-- t15_thirteenthRedBlue_expect_teamsHaveTwelveMatches =
    PRE step = 15 THEN
        rr <-- setupMatch((Alice |-> Eloise)) || step := 16
    END ;

    /* schedule the remaining 24 matches (red v green, blue v green) */
    rr <-- t16_setupRest_expect_success =
    PRE step = 16 & idx <= 36 THEN
        rr <-- setupMatch(testMatches(idx)) ||
        idx := idx + 1 ||
        IF idx = 36 THEN step := 17 END
    END ;

    rr <-- t17_seventhMatch_expect_playerHasSixMatches =
    PRE step = 17 THEN
        rr <-- setupMatch((Alice |-> Eloise)) || step := 18
    END ;

    rr <-- t18_nextGameTooEarly_expect_wrongPhase =
    PRE step = 18 THEN
        rr <-- nextGame || step := 19
    END ;

    rr <-- t19_proceed_expect_success =
    PRE step = 19 THEN
        rr <-- proceed || step := 20
    END ;

    rr <-- t20_undoInGamePlay_expect_wrongPhase =
    PRE step = 20 THEN
        rr <-- undo || step := 21
    END ;

    rr <-- t21_matchInGamePlay_expect_wrongPhase =
    PRE step = 21 THEN
        rr <-- setupMatch((Alice |-> Eloise)) || step := 22
    END ;

    /* play all 36 games */
    rr <-- t22_nextGame_expect_success =
    PRE step = 22 & schedule /= [] THEN
        rr <-- nextGame ||
        IF size(schedule) = 1 THEN step := 23 END
    END ;

    rr <-- t23_nextGameNoneLeft_expect_noGamesLeft =
    PRE step = 23 THEN
        rr <-- nextGame || step := 24
    END ;

    sc <-- t24_playerScores_red =
    PRE step = 24 THEN
        sc <-- playerScores(red) || step := 25
    END ;

    sc <-- t25_playerScores_blue =
    PRE step = 25 THEN
        sc <-- playerScores(blue) || step := 26
    END ;

    sc <-- t26_playerScores_green =
    PRE step = 26 THEN
        sc <-- playerScores(green) || step := 27
    END ;

    t27_restart =
    PRE step = 27 THEN
        restart || step := 28
    END

END
