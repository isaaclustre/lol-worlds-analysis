-- CONCLUSION QUERIES


-- Chovy

-- KP RANK
SELECT * FROM (
    SELECT playername,
           kp_index,
           RANK() OVER (ORDER BY kp_index DESC) AS overall_rank
    FROM worlds_kp_z
              )
ranked WHERE playername = 'Chovy';

-- CARRY RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carry' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Chovy';

-- CARRIED RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carried' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Chovy';


-- Zeus

-- KP RANK
SELECT * FROM (
    SELECT playername,
           kp_index,
           RANK() OVER (ORDER BY kp_index DESC) AS overall_rank
    FROM worlds_kp_z
              )
ranked WHERE playername = 'Zeus';

-- CARRY RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carry' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Zeus';

-- CARRIED RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carried' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Zeus';


-- Faker

-- KP RANK
SELECT * FROM (
    SELECT playername,
           kp_index,
           RANK() OVER (ORDER BY kp_index DESC) AS overall_rank
    FROM worlds_kp_z
              )
ranked WHERE playername = 'Faker';

-- CARRY RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carry' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Faker';

-- CARRIED RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carried' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Faker';


-- Gumayusi

-- KP RANK
SELECT * FROM (
    SELECT playername,
           kp_index,
           RANK() OVER (ORDER BY kp_index DESC) AS overall_rank
    FROM worlds_kp_z
              )
ranked WHERE playername = 'Gumayusi';

-- CARRY RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carry' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Gumayusi';

-- CARRIED RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carried' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Gumayusi';


-- Keria

-- KP RANK
SELECT * FROM (
    SELECT playername,
           kp_index,
           RANK() OVER (ORDER BY kp_index DESC) AS overall_rank
    FROM worlds_kp_z
              )
ranked WHERE playername = 'Keria';

-- CARRY RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carry' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Keria';

-- CARRIED RANK
SELECT * FROM (
    SELECT playername,
           subset,
           ind_wr,
           shrunk_wrae,
           RANK() OVER (ORDER BY shrunk_wrae DESC, ind_wr DESC) AS overall_rank
    FROM player_wae_off_diagonals
    WHERE subset = 'carried' AND playerid IN (SELECT playerid FROM top8_players)
              )
ranked WHERE playername = 'Keria';