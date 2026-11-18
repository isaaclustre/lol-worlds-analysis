-- # of games and WR for each game state.
SELECT SUM(n_wins) FILTER (WHERE indiv_state = 'lead' and teammate_state = 'lead') /
       SUM(n_games) FILTER (WHERE indiv_state = 'lead' and teammate_state = 'lead') AS lead_lead_wr,

       SUM(n_wins) FILTER (WHERE indiv_state = 'lead' and teammate_state = 'even') /
       SUM(n_games) FILTER (WHERE indiv_state = 'lead' and teammate_state = 'even') AS lead_even_wr,

       SUM(n_wins) FILTER (WHERE indiv_state = 'lead' and teammate_state = 'deficit') /
       SUM(n_games) FILTER (WHERE indiv_state = 'lead' and teammate_state = 'deficit') AS lead_deficit_wr,

       SUM(n_wins) FILTER (WHERE indiv_state = 'even' and teammate_state = 'lead') /
       SUM(n_games) FILTER (WHERE indiv_state = 'even' and teammate_state = 'lead') AS even_lead_wr,

       SUM(n_wins) FILTER (WHERE indiv_state = 'even' and teammate_state = 'even') /
       SUM(n_games) FILTER (WHERE indiv_state = 'even' and teammate_state = 'even') AS even_even_wr,

       SUM(n_wins) FILTER (WHERE indiv_state = 'even' and teammate_state = 'deficit') /
       SUM(n_games) FILTER (WHERE indiv_state = 'even' and teammate_state = 'deficit') AS even_deficit_wr,

       SUM(n_wins) FILTER (WHERE indiv_state = 'deficit' and teammate_state = 'lead') /
       SUM(n_games) FILTER (WHERE indiv_state = 'deficit' and teammate_state = 'lead') AS deficit_lead_wr,

       SUM(n_wins) FILTER (WHERE indiv_state = 'deficit' and teammate_state = 'even') /
       SUM(n_games) FILTER (WHERE indiv_state = 'deficit' and teammate_state = 'even') AS deficit_lead_wr,

       SUM(n_wins) FILTER (WHERE indiv_state = 'deficit' and teammate_state = 'deficit') /
       SUM(n_games) FILTER (WHERE indiv_state = 'deficit' and teammate_state = 'deficit') AS deficit_lead_wr
FROM wins_above_expected_view;


-- Kanavi, Malrang, and Levi Stats
SELECT playername, position, games,
       ind_wr, shrunk_wr
FROM player_wae_off_diagonals
WHERE playername IN ('Kanavi', 'Malrang', 'Levi')
AND subset = 'carry';



-- Top 10 Carry players
SELECT playername, position, games,
       ind_wr, expected_wr, shrunk_wr, shrunk_wrae
FROM player_wae_off_diagonals
WHERE subset = 'carry' AND playerid IN (SELECT playerid FROM top8_players)
ORDER BY shrunk_wrae DESC, ind_wr DESC
LIMIT 10;


-- Top 10 Carried players
SELECT playername, position, games,
       ind_wr, expected_wr, shrunk_wr, shrunk_wrae
FROM player_wae_off_diagonals
WHERE subset = 'carried' AND playerid IN (SELECT playerid FROM top8_players)
ORDER BY shrunk_wrae DESC, ind_wr DESC
LIMIT 10;



-- Top 10 Aligned Players
SELECT playername, position, games,
       ind_wr, expected_wr, shrunk_wr, shrunk_wrae
FROM player_wae_off_diagonals
WHERE subset = 'aligned' AND playerid IN (SELECT playerid FROM top8_players)
ORDER BY shrunk_wrae DESC, ind_wr DESC
LIMIT 10;


-- Outlier Players ('Blaber', 'Hylissang', 'Zven', 'Juhan', 'Larssen')
SELECT playername, position, games,
       ind_wr, expected_wr, shrunk_wrae
FROM player_wae_off_diagonals
WHERE playername IN ('Blaber', 'Hylissang', 'Zven', 'Juhan', 'Larssen')
AND subset = 'carry'
ORDER BY shrunk_wrae DESC;

