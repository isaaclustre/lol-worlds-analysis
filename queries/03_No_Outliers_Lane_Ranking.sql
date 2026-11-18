-- IGNAR's GAMES
SELECT playername, position, teamname, champion, golddiffat10, xpdiffat10, csdiffat10, cspm
FROM worlds_all
WHERE playername = 'Ignar'
ORDER BY champion;

-- FBI's GAMES (Ignar's teammates)
SELECT playername, position, teamname, champion, golddiffat10, xpdiffat10, csdiffat10, cspm
FROM worlds_all
WHERE playername = 'FBI'
ORDER BY champion;


-- Standardized at 15 minutes
WITH ranked AS (
    SELECT playername, position, teamname, n_games,
           z_gd15, z_csd15, z_xpd15,
           RANK() OVER (ORDER BY z_gd15  DESC) AS gd_rank,
           RANK() OVER (ORDER BY z_csd15 DESC) AS csd_rank,
           RANK() OVER (ORDER BY z_xpd15 DESC) AS xpd_rank,
           RANK() OVER (ORDER BY z_gd15 + z_csd15 + z_xpd15 DESC) AS overall_rank
    FROM lane_dominance_z
)
SELECT playername, position AS role, teamname AS team, n_games,
       ROUND(z_gd15::numeric, 1)  AS gold_z,
       ROUND(z_csd15::numeric, 1) AS cs_z,
       ROUND(z_xpd15::numeric, 1) AS xp_z,
       overall_rank
FROM ranked
ORDER BY overall_rank
LIMIT 7;


