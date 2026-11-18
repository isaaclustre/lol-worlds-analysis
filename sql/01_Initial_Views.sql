-- Creating the views

-- Chapter 0: Creating the Views
CREATE VIEW worlds_2020 AS
SELECT *
FROM oe_2020
WHERE league = 'WLDs'
  AND teamname IN ('Dplus Kia', 'Suning', 'G2 Esports', 'Top Esports', 'Kiwoom DRX', 'JD Gaming', 'Fnatic', 'Gen.G');

CREATE VIEW worlds_2021 AS
SELECT *
FROM oe_2021
WHERE league = 'WLDs'
  AND teamname in ('EDward Gaming', 'Dplus Kia', 'T1', 'Gen.G', 'Hanwha Life Esports', 'Royal Never Give Up', 'MAD Lions KOI', 'Cloud9');

CREATE VIEW worlds_2022 AS
    SELECT *
FROM oe_2022
WHERE league = 'WLDs'
  AND teamname in ('Kiwoom DRX', 'T1', 'Gen.G', 'JD Gaming', 'Dplus Kia','EDward Gaming', 'Royal Never Give Up', 'Rogue');

CREATE VIEW worlds_2023 AS
    SELECT *
FROM oe_2023
WHERE league = 'WLDs'
AND teamname in ('T1', 'Weibo Gaming', 'Bilibili Gaming', 'JD Gaming', 'NRG', 'Gen.G', 'KT Rolster', 'LNG Esports');

CREATE VIEW worlds_2024 AS
    SELECT *
FROM oe_2024
WHERE league = 'WLDs'
AND teamname in ('T1', 'Bilibili Gaming', 'Gen.G', 'Weibo Gaming', 'LNG Esports', 'Hanwha Life Esports', 'Top Esports', 'FlyQuest');

CREATE VIEW worlds_2025 AS
    SELECT *
FROM oe_2025
WHERE league = 'WLDs'
AND teamname in ('T1', 'KT Rolster', 'Gen.G', 'Top Esports', 'Hanwha Life Esports', 'CTBC Flying Oyster', 'G2 Esports', 'Anyone''s Legend');


CREATE VIEW worlds_all AS
SELECT *
FROM (
    SELECT * FROM worlds_2020
    UNION ALL
    SELECT * FROM worlds_2021
    UNION ALL
    SELECT * FROM worlds_2022
    UNION ALL
    SELECT * FROM worlds_2023
    UNION ALL
    SELECT * FROM worlds_2024
    UNION ALL
    SELECT * FROM worlds_2025
) u
WHERE (EXTRACT(MONTH FROM date) * 100 + EXTRACT(DAY FROM date)) BETWEEN 923 AND 1201
  AND playername IS NOT NULL;