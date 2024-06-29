CREATE DATABASE runners;
USE runners;

CREATE TABLE results (
runnerName VARCHAR(50) NOT NULL CHECK (runnerName <> ''),
date DATE,
distance VARCHAR(50) NOT NULL CHECK (distance <> ''),
time TIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM results;

INSERT INTO results (
runnerName,
date,
distance,
time)

VALUES (
'Thomas',
'2024-06-27',
'5K',
'00:30:28');
