-- Clean and Standardize the Data


-- REMOVE ALL FASTING SENNA GAMES
CREATE VIEW worlds_clean AS
SELECT w.*
FROM worlds_all w
WHERE NOT EXISTS (
    SELECT 1
    FROM worlds_all b
    JOIN worlds_all s
      ON s.gameid = b.gameid
     AND s.teamname = b.teamname
    WHERE b.gameid   = w.gameid
      AND b.position = 'bot'
      AND s.position = 'sup'
      AND s.cspm > b.cspm
);


-- STANDARDIZING THE CLEAN DATA
CREATE VIEW lane_dominance_z AS
WITH player_means AS (
    SELECT playername,
           STRING_AGG(DISTINCT teamname, ', ') as teamname,
           STRING_AGG(DISTINCT position, ', ') as position,
           COUNT(*) AS n_games,
           AVG(golddiffat10) as gd10, AVG(golddiffat15) AS gd15, AVG(golddiffat20) AS gd20,
           AVG(csdiffat10) as csd10, AVG(csdiffat15) as csd15, AVG(csdiffat20) as csd20,
           AVG(xpdiffat10)   AS xpd10, AVG(xpdiffat15)  AS xpd15, AVG(xpdiffat20)  AS xpd20
    FROM worlds_clean
    GROUP BY playername, position
),
z_score AS (
    SELECT playername, position, teamname, n_games,
           ((gd10 - AVG(gd10) OVER w) / NULLIF(STDDEV_SAMP(gd10) OVER w, 0))::numeric AS z__gd10,
           ((gd15 - AVG(gd15) OVER w) / NULLIF(STDDEV_SAMP(gd15) OVER w, 0))::numeric AS z__gd15,
           ((gd20 - AVG(gd20) OVER w) / NULLIF(STDDEV_SAMP(gd20) OVER w, 0))::numeric AS z__gd20,
           ((csd10 - AVG(csd10) OVER w) / NULLIF(STDDEV_SAMP(csd10) OVER w, 0))::numeric AS z__csd10,
           ((csd15 - AVG(csd15) OVER w) / NULLIF(STDDEV_SAMP(csd15) OVER w, 0))::numeric AS z__csd15,
           ((csd20 - AVG(csd20) OVER w) / NULLIF(STDDEV_SAMP(csd20) OVER w, 0))::numeric AS z__csd20,
           ((xpd10 - AVG(xpd10) OVER w) / NULLIF(STDDEV_SAMP(xpd10) OVER w, 0))::numeric AS z__xpd10,
           ((xpd15 - AVG(xpd15) OVER w) / NULLIF(STDDEV_SAMP(xpd15) OVER w, 0))::numeric AS z__xpd15,
           ((xpd20 - AVG(xpd20) OVER w) / NULLIF(STDDEV_SAMP(xpd20) OVER w, 0))::numeric AS z__xpd20
    FROM player_means
    WINDOW w AS (PARTITION BY position)
)
SELECT playername, position, teamname, n_games,
       ROUND(z__gd10, 3) AS z_gd10,
       ROUND(z__gd15, 3) AS z_gd15,
       ROUND(z__gd20, 3) AS z_gd20,
       ROUND(z__csd10, 3) AS z_csd10,
       ROUND(z__csd15, 3) AS z_csd15,
       ROUND(z__csd20, 3) AS z_csd20,
       ROUND(z__xpd10, 3) AS z_xpd10,
       ROUND(z__xpd15, 3) AS z_xpd15,
       ROUND(z__xpd20, 3) AS z_xpd20
FROM z_score;


-- The remaining analysis is done in python.

