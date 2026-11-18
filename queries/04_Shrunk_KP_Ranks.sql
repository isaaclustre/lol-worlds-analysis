-- Top 10 In Standardized Shrunk KP
SELECT playername, position, teamname,
       z_kp10, z_kp15, z_kp20, z_kptotal,
       z_kp10 + z_kp15 + z_kp20 + z_kptotal AS kp_index
FROM worlds_kp_z
ORDER BY kp_index DESC
LIMIT 10;


-- Top 10 in Unstandardized Shrunk KP
SELECT playername, position, teamname,
       kp10_shrunk, kp15_shrunk, kp20_shrunk, kptotal_shrunk,
       kp10_shrunk + kp15_shrunk + kp20_shrunk + kptotal_shrunk AS kp_index
FROM worlds_kp_shrunk
ORDER BY kp_index DESC
LIMIT 10;
