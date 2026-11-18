-- Introduction Statistics

-- # of games, teams, and players at Worlds between 2020-2025
SELECT COUNT(DISTINCT gameid) FROM worlds_all;

SELECT COUNT(DISTINCT teamid) FROM worlds_all;

SELECT COUNT(DISTINCT playerid) FROM worlds_all;