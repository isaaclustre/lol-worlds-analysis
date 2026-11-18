-- WINS ABOVE EXPECTED VIEW
CREATE MATERIALIZED VIEW wins_above_expected_view AS
WITH player_stats AS (
    SELECT playerid, MAX(playername) AS playername, position, indiv_state, teammate_state,
           COUNT(*) AS n_games,
           SUM(result) AS n_wins
    FROM gold_diff_standardized
    GROUP BY playerid, position, indiv_state, teammate_state
),
situation_stats AS (
    SELECT position, indiv_state, teammate_state,
           COUNT(*) AS situation_games,
           SUM(result) AS situation_wins
    FROM gold_diff_standardized
    GROUP BY position, indiv_state, teammate_state
),
joined AS (
    SELECT p.*, s.situation_games, s.situation_wins,
           (s.situation_wins  - p.n_wins)::numeric
             / NULLIF(s.situation_games - p.n_games, 0) AS others_wr
    FROM player_stats p
    JOIN situation_stats s USING (position, indiv_state, teammate_state)
)
SELECT playerid, playername, position, indiv_state, teammate_state,
       n_games,
       n_wins,
       ROUND(n_wins::numeric / n_games, 3) AS ind_wr,
       ROUND(others_wr, 3) AS others_wr,
       ROUND(n_wins::numeric / n_games - others_wr, 3) AS wae_wr,
       ROUND(n_games * others_wr, 3) AS expected_wins,
       ROUND(n_wins - n_games * others_wr, 3) AS wins_above_expected
FROM joined;




-- FIND THE OFF DIAGONAL GAMES
CREATE VIEW off_diagonals AS
SELECT *,
       CASE WHEN (indiv_state = 'lead' AND teammate_state IN ('even', 'deficit')) OR
                 (indiv_state = 'even' AND teammate_state = 'deficit') THEN 'carry'
            WHEN (indiv_state = 'deficit' AND teammate_state IN ('even', 'lead')) OR
                 (indiv_state = 'even' AND teammate_state = 'lead') THEN 'carried'
            WHEN indiv_state = teammate_state THEN 'aligned'
       END AS subset
FROM wins_above_expected_view
WHERE others_wr IS NOT NULL;



CREATE MATERIALIZED VIEW player_wae_off_diagonals AS
WITH params AS (
    SELECT 'carry'   AS subset, 0.00573::numeric AS tau2
    UNION ALL
    SELECT 'carried' AS subset, 0.00090::numeric AS tau2
    UNION ALL
    SELECT 'aligned' AS subset, 0.0025::numeric AS tau2     -- replace with the fitted aligned value
),
per_player AS (
    SELECT subset, playerid, MAX(playername) AS playername, position,
           SUM(n_games) AS games,
           SUM(n_wins) AS wins,
           SUM(expected_wins) AS expected_wins,
           SUM(wins_above_expected) AS wae,
           SUM(n_games * others_wr * (1 - others_wr)) / SUM(n_games) AS v
    FROM off_diagonals
    WHERE subset IN ('carry', 'carried', 'aligned')
    GROUP BY subset, playerid, position
),
shrunk AS (
    SELECT p.*,
           p.games / (p.games + p.v / q.tau2) AS shrinkage_weight,
           p.wae   / (p.games + p.v / q.tau2) AS shrunk_wae_wr
    FROM per_player p
    JOIN params q USING (subset)
)
SELECT playerid, playername, position, subset,
       ROUND(shrinkage_weight, 3) AS shrinkage_weight,
       games,
       wins,
       ROUND(wins::numeric / games, 3) AS ind_wr,
       ROUND(expected_wins / games, 3) AS expected_wr,
       ROUND(expected_wins / games + shrunk_wae_wr, 3) AS shrunk_wr,
       ROUND(shrunk_wae_wr, 3) AS shrunk_wrae,
       ROUND(expected_wins, 3) AS raw_expected_wins,
       ROUND(wae, 3) AS raw_wae,
       ROUND(wae / games, 3) AS raw_wae_per_game,
       ROUND(games * shrunk_wae_wr, 3) AS shrunk_wae
FROM shrunk;







