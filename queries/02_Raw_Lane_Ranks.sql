-- Chapter 1: Lane Dominance


-- a. LANE DOMINANCE AT 10
WITH player_avgs AS(
    SELECT playername,
           STRING_AGG(DISTINCT position, ', ') AS roles,
           STRING_AGG(DISTINCT teamname, ', ') AS teams,
           COUNT(*) AS games,
           ROUND(AVG(golddiffat10):: numeric, 3) as avg_gd_10,
           ROUND(AVG(csdiffat10):: numeric, 3) AS avg_csd_10,
           ROUND(AVG(xpdiffat10):: numeric, 3) AS avg_xpd_10
    FROM worlds_all
    WHERE playername is not null
      AND golddiffat10 IS NOT NULL
      AND csdiffat10   IS NOT NULL
      AND xpdiffat10   IS NOT NULL

    GROUP BY playername
),
ranked as (
    SELECT *,
           RANK() OVER (ORDER BY avg_gd_10 DESC) AS gd_rank,
           RANK() OVER (ORDER BY avg_csd_10 DESC) AS csd_rank,
           RANK() OVER (ORDER BY avg_xpd_10 DESC) AS xpd_rank
    FROM player_avgs
)
SELECT * FROM ranked
ORDER BY gd_rank + csd_rank + xpd_rank, gd_rank;




-- LANE DOMINANCE AT 15
WITH player_avgs AS(
    SELECT playername,
           STRING_AGG(DISTINCT position, ', ') AS roles,
           STRING_AGG(DISTINCT teamname, ', ') AS teams,
           COUNT(*) AS games,
           ROUND(AVG(golddiffat15):: numeric, 3) as avg_gd_15,
           ROUND(AVG(csdiffat15):: numeric, 3) AS avg_csd_15,
           ROUND(AVG(xpdiffat15):: numeric, 3) AS avg_xpd_15
    FROM worlds_all
    WHERE playername is not null
    GROUP BY playername
),
ranked as (
    SELECT *,
           RANK() OVER (ORDER BY avg_gd_15 DESC) AS gd_rank,
           RANK() OVER (ORDER BY avg_csd_15 DESC) AS csd_rank,
           RANK() OVER (ORDER BY avg_xpd_15 DESC) AS xpd_rank
    FROM player_avgs
)
SELECT * FROM ranked
ORDER BY gd_rank + csd_rank + xpd_rank, gd_rank;





-- LANE DOMINANCE AT 20
WITH player_avgs AS(
    SELECT playername,
           STRING_AGG(DISTINCT position, ', ') AS roles,
           STRING_AGG(DISTINCT teamname, ', ') AS teams,
           COUNT(*) AS games,
           ROUND(AVG(golddiffat20):: numeric, 3) as avg_gd_20,
           ROUND(AVG(csdiffat20):: numeric, 3) AS avg_csd_20,
           ROUND(AVG(xpdiffat20):: numeric, 3) AS avg_xpd_20
    FROM worlds_all
    WHERE playername is not null
    GROUP BY playername
),
ranked as (
    SELECT *,
           RANK() OVER (ORDER BY avg_gd_20 DESC) AS gd_rank,
           RANK() OVER (ORDER BY avg_csd_20 DESC) AS csd_rank,
           RANK() OVER (ORDER BY avg_xpd_20 DESC) AS xpd_rank
    FROM player_avgs
)
SELECT * FROM ranked
WHERE gd_rank <= 25 AND csd_rank <= 25 AND xpd_rank <= 25
ORDER BY gd_rank + csd_rank + xpd_rank, gd_rank;



-- PLAYERS WHO ARE TOP 25 AT ALL TIME STAMPS
WITH player_avgs AS(
    SELECT playername,
           STRING_AGG(DISTINCT position, ', ') AS roles,
           STRING_AGG(DISTINCT teamname, ', ') AS team,
           COUNT(*) as games,
           ROUND(AVG(golddiffat10)::numeric, 3) as avg_gd_10,
           ROUND(AVG(csdiffat10)::numeric, 3) as avg_csd_10,
           ROUND(AVG(xpdiffat10)::numeric, 3) as avg_xpd_10,
           ROUND(AVG(golddiffat15)::numeric, 3) as avg_gd_15,
           ROUND(AVG(csdiffat15)::numeric, 3) as avg_csd_15,
           ROUND(AVG(xpdiffat15)::numeric, 3) as avg_xpd_15,
           ROUND(AVG(golddiffat20)::numeric, 3) as avg_gd_20,
           ROUND(AVG(csdiffat20)::numeric, 3) as avg_csd_20,
           ROUND(AVG(xpdiffat20)::numeric, 3) as avg_xpd_20
    FROM worlds_all
    WHERE playername IS NOT NULL
    GROUP BY playername
),
ranked AS(
    SELECT *,
           RANK() OVER (ORDER BY avg_gd_10 DESC NULLS LAST) as gd_10_rank,
           RANK() OVER (ORDER BY avg_csd_10 DESC NULLS LAST) as csd_10_rank,
           RANK() OVER (ORDER BY avg_xpd_10 DESC NULLS LAST) AS xpd_10_rank,
           RANK() OVER (ORDER BY avg_gd_15 DESC NULLS LAST) as gd_15_rank,
           RANK() OVER (ORDER BY avg_csd_15 DESC NULLS LAST) as csd_15_rank,
           RANK() OVER (ORDER BY avg_xpd_15 DESC NULLS LAST) AS xpd_15_rank,
           RANK() OVER (ORDER BY avg_gd_20 DESC NULLS LAST) as gd_20_rank,
           RANK() OVER (ORDER BY avg_csd_20 DESC NULLS LAST) as csd_20_rank,
           RANK() OVER (ORDER BY avg_xpd_20 DESC NULLS LAST)  AS xpd_20_rank
    FROM player_avgs
),
flagged AS(
    SELECT *,
           (gd_10_rank <= 25 AND csd_10_rank <= 25 AND xpd_10_rank <= 25)::int as top25_10min,
           (gd_15_rank <= 25 AND csd_15_rank <= 25 AND xpd_15_rank <= 25)::int as top25_15min,
           (gd_20_rank <= 25 AND csd_20_rank <= 25 AND xpd_20_rank <= 25)::int as top25_20min
    FROM ranked
)
SELECT playername, roles, team, top25_10min, top25_15min, top25_20min,
       (top25_10min + top25_15min + top25_20min) as top25_all
FROM flagged
WHERE (top25_10min + top25_15min + top25_20min) =3
ORDER BY top25_all DESC;


