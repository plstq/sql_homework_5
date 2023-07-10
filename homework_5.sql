DROP TABLE IF EXISTS Cars;

CREATE TABLE Cars (
  Id INT,
  Name VARCHAR(50),
  Cost INT
);

INSERT INTO Cars (Id, Name, Cost) VALUES
(1, 'Audi', 52642),
(2, 'Mercedes', 57127),
(3, 'Skoda', 9000),
(4, 'Volvo', 29000),
(5, 'Bentley', 350000),
(6, 'Citroen', 21000),
(7, 'Hummer', 41400),
(8, 'Volkswagen', 21600);

select * from cars;

-- task 1
DROP VIEW IF EXISTS AffordableCars;
CREATE OR REPLACE VIEW AffordableCars AS
SELECT * FROM Cars WHERE Cost <= 25000;

select * from affordablecars;

-- task 2
ALTER VIEW AffordableCars AS
SELECT * FROM Cars WHERE Cost <= 30000;

SELECT * FROM AffordableCars;

-- task 3
CREATE VIEW SkodaAndAudiCars AS
SELECT * FROM Cars WHERE Name IN ('Skoda', 'Audi');

select * from skodaandaudicars;

-- task4
-- Создание таблицы Analysis
CREATE TABLE Analysis (
  an_id INT,
  an_name VARCHAR(50),
  an_cost DECIMAL(10,2),
  an_price DECIMAL(10,2),
  an_group INT
);

-- Заполнение таблицы Analysis случайными значениями
INSERT INTO Analysis (an_id, an_name, an_cost, an_price, an_group)
SELECT 
    FLOOR(RAND() * 1000) + 1 as an_id,
    CONCAT('Analysis', FLOOR(RAND() * 1000) + 1) as an_name,
    ROUND(RAND() * 100, 2) as an_cost,
    ROUND(RAND() * 200, 2) as an_price,
    FLOOR(RAND() * 100) + 1 as an_group
FROM
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS a
    CROSS JOIN
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS b;

select * from analysis;

-- Создание таблицы Groups
CREATE TABLE AnalysisGroups (
  gr_id INT,
  gr_name VARCHAR(50),
  gr_temp VARCHAR(50)
);

-- Заполнение таблицы Groups случайными значениями
INSERT INTO AnalysisGroups (gr_id, gr_name, gr_temp)
SELECT 
    FLOOR(RAND() * 100) + 1 as gr_id,
    CONCAT('Group', FLOOR(RAND() * 100) + 1) as gr_name,
    CONCAT('Temp', FLOOR(RAND() * 100) + 1) as gr_temp
FROM
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS a;

select * from analysisgroups;

-- Создание таблицы Orders
CREATE TABLE Orders (
  ord_id INT,
  ord_datetime DATETIME,
  ord_an INT
);

-- Заполнение таблицы Orders случайными значениями
INSERT INTO Orders (ord_id, ord_datetime, ord_an)
SELECT 
    FLOOR(RAND() * 1000) + 1 as ord_id,
    DATE_ADD('2020-02-05', INTERVAL FLOOR(RAND() * 7) DAY) as ord_datetime,
    FLOOR(RAND() * 1000) + 1 as ord_an
FROM
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS a
    CROSS JOIN
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) AS b;
    
select * from orders;
    
SELECT a.an_name, a.an_price
FROM Analysis a
INNER JOIN Orders o ON a.an_id = o.ord_an
WHERE o.ord_datetime BETWEEN '2020-02-05' AND DATE_ADD('2020-02-05', INTERVAL 7 DAY);

-- task 5
CREATE TABLE TrainSchedule (
  train_id INTEGER,
  station VARCHAR(20),
  station_time TIME
);

INSERT INTO TrainSchedule (train_id, station, station_time) VALUES
(110, 'San Francisco', '10:00:00'),
(110, 'Redwood City', '10:54:00'),
(110, 'Palo Alto', '11:02:00'),
(110, 'San Jose', '12:35:00'),
(120, 'San Francisco', '11:00:00'),
(120, 'Palo Alto', '12:49:00'),
(120, 'San Jose', '13:30:00');

select * from trainschedule;

ALTER TABLE TrainSchedule ADD COLUMN time_to_next_station TIME;

UPDATE TrainSchedule AS t1
JOIN (
    SELECT t2.train_id, t2.station, t2.station_time,
        MIN(t3.station_time) AS next_station_time
    FROM TrainSchedule AS t2
    JOIN TrainSchedule AS t3 ON t2.train_id = t3.train_id
    AND t2.station_time < t3.station_time
    GROUP BY t2.train_id, t2.station, t2.station_time
) AS temp
ON temp.train_id = t1.train_id
AND temp.station = t1.station
SET t1.time_to_next_station = TIMEDIFF(temp.next_station_time, t1.station_time);

SELECT * FROM TrainSchedule;