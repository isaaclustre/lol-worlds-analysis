-- CALCULATES TEAM KILLS
CREATE VIEW worlds_team_kp AS
SELECT gameid,
    teamname,
    playername,
    "position",
    killsat10,
    assistsat10,
    killsat15,
    assistsat15,
    killsat20,
    assistsat20,
    kills,
    assists,
    sum(killsat10) OVER (PARTITION BY teamname, gameid) AS teamkills10,
    sum(killsat15) OVER (PARTITION BY teamname, gameid) AS teamkills15,
    sum(killsat20) OVER (PARTITION BY teamname, gameid) AS teamkills20,
    sum(kills) OVER (PARTITION BY teamname, gameid) AS totalteamkills
   FROM worlds_clean;





-- SHRUNK KP
CREATE VIEW worlds_kp_shrunk AS
 WITH priors AS (
         SELECT v."position",
            v.mu10,
            v.k10,
            v.mu15,
            v.k15,
            v.mu20,
            v.k20,
            v.mutotal,
            v.ktotal
           FROM ( VALUES ('top'::text,0.3803,75,0.4083,115,0.4789,139,0.5815,191), ('jng'::text,0.7199,75,0.7224,115,0.7238,139,0.7178,191), ('mid'::text,0.4695,75,0.5247,115,0.5827,139,0.6694,191), ('bot'::text,0.4883,75,0.5008,115,0.5615,139,0.6813,191), ('sup'::text,0.6049,75,0.6193,115,0.659,139,0.7153,191)) v("position", mu10, k10, mu15, k15, mu20, k20, mutotal, ktotal)
        )
 SELECT p.playername,
    p."position",
    p.teamname,
    p.n_games,
    p.p10,
    p.t10,
    p.p15,
    p.t15,
    p.p20,
    p.t20,
    p.p_total,
    p.t_total,
    round(((p.p10 + (pri.mu10 * pri.k10::numeric)::double precision) / (p.t10 + pri.k10::double precision))::numeric, 4) AS kp10_shrunk,
    round(((p.p15 + (pri.mu15 * pri.k15::numeric)::double precision) / (p.t15 + pri.k15::double precision))::numeric, 4) AS kp15_shrunk,
    round(((p.p20 + (pri.mu20 * pri.k20::numeric)::double precision) / (p.t20 + pri.k20::double precision))::numeric, 4) AS kp20_shrunk,
    round((p.p_total + pri.mutotal * pri.ktotal::numeric) / (p.t_total + pri.ktotal::numeric), 4) AS kptotal_shrunk
   FROM p_and_t p
     JOIN priors pri ON p."position" = pri."position";





-- STANDARDIZED KP
CREATE VIEW worlds_kp_z AS
WITH z AS (
         SELECT worlds_kp_shrunk.playername,
            worlds_kp_shrunk."position",
            worlds_kp_shrunk.teamname,
            worlds_kp_shrunk.kp10_shrunk,
            worlds_kp_shrunk.kp15_shrunk,
            worlds_kp_shrunk.kp20_shrunk,
            worlds_kp_shrunk.kptotal_shrunk,
            (worlds_kp_shrunk.kp10_shrunk - avg(worlds_kp_shrunk.kp10_shrunk) OVER w) / NULLIF(stddev_samp(worlds_kp_shrunk.kp10_shrunk) OVER w, 0::numeric) AS z_kp10,
            (worlds_kp_shrunk.kp15_shrunk - avg(worlds_kp_shrunk.kp15_shrunk) OVER w) / NULLIF(stddev_samp(worlds_kp_shrunk.kp15_shrunk) OVER w, 0::numeric) AS z_kp15,
            (worlds_kp_shrunk.kp20_shrunk - avg(worlds_kp_shrunk.kp20_shrunk) OVER w) / NULLIF(stddev_samp(worlds_kp_shrunk.kp20_shrunk) OVER w, 0::numeric) AS z_kp20,
            (worlds_kp_shrunk.kptotal_shrunk - avg(worlds_kp_shrunk.kptotal_shrunk) OVER w) / NULLIF(stddev_samp(worlds_kp_shrunk.kptotal_shrunk) OVER w, 0::numeric) AS z_kptotal
           FROM worlds_kp_shrunk
          WINDOW w AS (PARTITION BY worlds_kp_shrunk."position")
        )
 SELECT playername,
    "position",
    teamname,
    kp10_shrunk,
    kp15_shrunk,
    kp20_shrunk,
    kptotal_shrunk,
    round(z_kp10, 4) AS z_kp10,
    round(z_kp15, 4) AS z_kp15,
    round(z_kp20, 4) AS z_kp20,
    round(z_kptotal, 4) AS z_kptotal,
    round(z_kp10 + z_kp15 + z_kp20 + z_kptotal, 4) AS kp_index
   FROM z;