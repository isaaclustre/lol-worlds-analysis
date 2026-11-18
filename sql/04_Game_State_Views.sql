-- CREATE A VIEW OF ALL WORLDS GAMES, NOT JUST TOP 8
CREATE VIEW oe_all AS
SELECT * FROM oe_2020 WHERE league = 'WLDs'
UNION ALL
SELECT * FROM oe_2021 WHERE league = 'WLDs'
UNION ALL
SELECT * FROM oe_2022 WHERE league = 'WLDs'
UNION ALL
SELECT * FROM oe_2023 WHERE league = 'WLDs'
UNION ALL
SELECT * FROM oe_2024 WHERE league = 'WLDs'
UNION ALL
SELECT * FROM oe_2025 WHERE league = 'WLDs';



-- REMOVE NULL PLAYERS AND LIMIT TO CORRECT DATES
CREATE VIEW oe_clean_ AS
SELECT *
FROM oe_all
WHERE (EXTRACT(MONTH FROM date) * 100 + EXTRACT(DAY FROM date)) BETWEEN 923 AND 1201
  AND playername IS NOT NULL;

CREATE VIEW oe_clean AS
SELECT w.*
FROM oe_clean_ w
WHERE NOT EXISTS (
    SELECT 1
    FROM oe_clean_ b
    JOIN oe_clean_ s
      ON s.gameid = b.gameid
     AND s.teamname = b.teamname
    WHERE b.gameid   = w.gameid
      AND b.position = 'bot'
      AND s.position = 'sup'
      AND s.cspm > b.cspm
);


-- CALCULATE RAW INDIVIDUAL AND TEAMMATE GOLD DIFF
CREATE VIEW gold_diff AS
WITH t AS (
    SELECT gameid, playername, playerid, teamname, year, position, result,
           golddiffat15 AS indivgolddiff,
           SUM(golddiffat15) OVER w - golddiffat15 AS teammategolddiff,
           COUNT(*) OVER w AS n_players,
           COUNT(golddiffat15) OVER w AS n_gold_diff
    FROM oe_clean
    WINDOW w AS (PARTITION BY gameid, teamname)
)
SELECT gameid, year, playerid, playername, teamname, position, result,
       indivgolddiff, teammategolddiff
FROM t WHERE n_players = 5 AND n_gold_diff = 5 AND result IS NOT NULL;

drop view gold_diff_standardized cascade;



-- CALCULATE STANDARDIZED GOLD DIFFs
CREATE VIEW gold_diff_standardized AS
WITH params AS (
    SELECT 0.40::numeric AS cut
),
role_sd AS (
    SELECT position,
           STDDEV(indivgolddiff)    AS sd_indiv,
           STDDEV(teammategolddiff) AS sd_team
    FROM gold_diff
    GROUP BY position
),
scaled AS (
    SELECT g.playerid, g.gameid, g.year, g.playername, g.teamname, g.position, g.result,
           g.indivgolddiff,
           g.teammategolddiff,
           g.indivgolddiff::numeric    / r.sd_indiv::numeric AS indiv_gd_scaled,
           g.teammategolddiff::numeric / r.sd_team::numeric  AS teammate_gd_scaled
    FROM gold_diff g
    JOIN role_sd r USING (position)
)
SELECT s.*,
       CASE WHEN s.indiv_gd_scaled    >  p.cut THEN 'lead'
            WHEN s.indiv_gd_scaled    < -p.cut THEN 'deficit'
            ELSE 'even' END AS indiv_state,
       CASE WHEN s.teammate_gd_scaled >  p.cut THEN 'lead'
            WHEN s.teammate_gd_scaled < -p.cut THEN 'deficit'
            ELSE 'even' END AS teammate_state
FROM scaled s
CROSS JOIN params p;



-- THE PLAYERS WHO MADE TOP 8 AT LEAST ONCE
CREATE VIEW top8_players AS
SELECT DISTINCT playerid
FROM worlds_all
WHERE playername IS NOT NULL;


