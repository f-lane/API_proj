-- SCENARIO: I am helping to run a cat adoption service. I need to record the details of cats, prospective adopters, successful adoptions and food stocks.
-- create DB with at least 3 tables with several columns. Use at least 3 data types. Use at least 2 constraints. Normalise the data. 

CREATE DATABASE cat_sanctuary ;
USE cat_sanctuary ;

CREATE TABLE cats
(cat_ID int NOT NULL AUTO_INCREMENT, 
cat_name VARCHAR(30),
sex CHAR(1), 
birthday DATE,
PRIMARY KEY (cat_ID),
CHECK (sex = 'f' OR sex = 'm')
);

CREATE TABLE food
(food_ID int NOT NULL,
brand VARCHAR(20),
flavour VARCHAR(20),
type CHAR(1),
stock INT,
PRIMARY KEY (food_ID)
);

CREATE TABLE adopter
(adopter_ID int NOT NULL AUTO_INCREMENT,
name VARCHAR(50),
surname VARCHAR(50) NOT NULL,
phone int,
PRIMARY KEY(adopter_ID)
);

CREATE TABLE adoptions
(adoption_ID int NOT NULL,
date DATE, 
PRIMARY KEY (adoption_ID)
);

-- populate DB with at least 8 rows of data per table (I have purposefully not added 8 records to the adoptions table). Use at least 3 queries to insert data. 

INSERT INTO cats
(cat_name, birthday, sex)
VALUES
('Christophe', '2014-09-04', 'm'),
('Marmalade', '2022-01-25', 'f'),
('Caesar', '2021-05-13', 'm'),
('Sonya', NULL, 'f'),
('Gouda', '2024-09-06', 'm'),
('Cheddar', '2024-09-06', 'f'),
('Gorgonzola', '2024-09-06', 'f'),
('Brie', '2024-09-06', 'f'),
('Salad', NULL, 'm')
;

INSERT INTO food
(food_ID, brand, flavour, type, stock)
VALUES
(10, 'Whiskas', 'chicken', 'w', 20),
(11, 'Whiskas', 'fish', 'w', 20),
(20, 'Fancycat', 'beef', 'w', 10),
(21, 'Fancycat', 'chicken', 'w', 12),
(22, 'Fancycat', 'duck', 'd', 3),
(30, 'veterinary', 'fish', 'd', 5), 
(31, 'veterinary', 'duck', 'w', 11),
(32, 'veterinary', 'lamb', 'd', 4)
;

INSERT INTO adopter
(name, surname, phone)
VALUES
('John', 'Johnson', 0335776),
('Rosa', 'Luxembourg', 0981232),
('Olivia', 'Rodrigo', NULL),
('Christophe', 'LeFur', 03322432),
('Charlotte', 'Bronte', 4378854),
('Liz', 'Truss', 01199823),
('Thangham', 'Debonaire', NULL),
('Jacob', 'Collier', 0692743) ;

INSERT INTO adoptions
(adoption_ID, date)
VALUES
(1, '2024-03-19') ;

-- Link tables using PKs and FKs. 
-- Link cats to their favourite food. 
ALTER TABLE cats
ADD fav_food INT;

ALTER TABLE cats
ADD CONSTRAINT fk_fav_food
FOREIGN KEY (fav_food)
REFERENCES food (food_ID) ;

UPDATE cats
	SET fav_food = (case when cat_ID = 1 then 10
						when cat_ID = 2 then 21
                        when cat_ID = 3 then 22
                        when cat_ID = 4 then 32
						when cat_ID BETWEEN 5 AND 8 then 31
                        when cat_ID = 9 then 22
                        end) 
					WHERE cat_ID IS NOT NULL ;
                    
-- Link adopters and adoptions
ALTER TABLE adoptions
ADD adopter_ID INT ;

ALTER TABLE adoptions
ADD CONSTRAINT fk_adopter
FOREIGN KEY (adopter_ID)
REFERENCES adopter (adopter_ID) ;

UPDATE adoptions
SET adopter_ID = 1 
WHERE adoption_ID = 1 ;

-- Link adoption to the relevant cat
ALTER TABLE adoptions
ADD adopt_cat_ID INT ;

ALTER TABLE adoptions
ADD CONSTRAINT fk_adopt_cat
FOREIGN KEY (adopt_cat_ID)
REFERENCES cats (cat_ID) ;

UPDATE adoptions
SET adopt_cat_ID = 2 
WHERE adoption_ID = 1 ;

-- Update adoptions tables with multiple adoptions. 
INSERT INTO adoptions
(adoption_ID, date, adopter_ID, adopt_cat_ID)
VALUES
(2, '2024-03-26', 2, 4) ;

INSERT INTO adoptions 
(adoption_ID, date, adopter_ID, adopt_cat_ID)
VALUES
(3, '2024-03-26', 2, 9) ;

INSERT INTO adoptions
(adoption_ID, date, adopter_ID, adopt_cat_ID)
VALUES
(4, '2024-03-29', 3, 1),
(5, '2024-04-01', 4, 3) ;

-- use at least 5 queries to retrieve data. Use at least 2 aggregate functions. 
-- view all contents in tables
SELECT * FROM cats;
SELECT * FROM food;
SELECT * FROM adoptions ;
SELECT * FROM adopter ;
-- How many unique adopters have adopted from us?
SELECT DISTINCT adopter_ID FROM adoptions; 
-- Which adoptions and cat_IDs had adopter #2 been involved with? 
SELECT adoption_ID, adopt_cat_ID FROM adoptions WHERE adopter_ID = 2;
-- How many unique brands of food do we stock?
SELECT COUNT(DISTINCT brand) AS NumberOfBrands FROM food;
-- How much wet food do we have?
SELECT SUM(CASE WHEN type = 'w' then stock Else 0 End) AS Amount_Of_Wet_Food FROM food;
-- How much dry food do we have?
SELECT SUM(CASE WHEN type = 'd' then stock ELSE 0 End) AS Amount_Of_Dry_Food FROM food;
-- What is our total food stock?
SELECT SUM(stock) AS TotalFood FROM food;

-- Use at least 2 joins. Sort by ORDER BY. 
-- retrieve names of cats adopted, ordered reverse alphabetically. 

SELECT
c.cat_name FROM cats c
INNER JOIN
adoptions a
ON 
c.cat_ID =
a.adopt_cat_ID
ORDER BY cat_name DESC;

-- retrieve names of cats adopted on 26th March 2024, ordered alphabetically

SELECT cat_name 
FROM cat_sanctuary.cats c 
WHERE c.cat_ID IN
(SELECT a.adopt_cat_ID 
FROM cat_sanctuary.adoptions a
WHERE a.date = '2024-03-26') 
ORDER BY cat_name;

-- Use at least two more in-built functions. 
-- return cat names of over 5 characters in length, alphabetically 
SELECT c.cat_name
FROM cat_sanctuary.cats c
WHERE CHAR_LENGTH(cat_name) > 5 
ORDER BY c.cat_name;

-- Make 'veterinary' brand all-caps. 
SELECT f.brand, UPPER(f.brand) as BRAND
FROM cat_sanctuary.food f
WHERE brand = 'veterinary';

-- Create a stored procedure that highlights low dry food stock. 
DELIMITER // 
CREATE PROCEDURE low_stock_dry()
BEGIN 
SELECT * FROM cat_sanctuary.food f WHERE f.stock < 2 AND type = 'd';
END//
DELIMITER;

-- Create a stored procedure that highlights low wet food stock
DELIMITER // 
CREATE PROCEDURE low_stock_wet()
BEGIN 
SELECT * FROM cat_sanctuary.food f WHERE f.stock < 10 AND type = 'w';
END//
DELIMITER;

-- Use the following to call either procedure: 
-- CALL low_stock_wet();
-- CALL low_stock_dry();

-- scenario: a new cat has joined the sanctuary. Another person registers as an adopter and one of our adopters updates us with their phone number. 
-- Then, two of the kittens are adopted and take with them 2 of their favourite food.  Use the stored procedure to check if any food needs ordering. 
-- Unfortunately, the oldest remaining cat dies of old age. Their record is deleted. 

INSERT INTO cats
(cat_name, sex, birthday, fav_food)
VALUES
('Betty', 'f', '2017-08-08', 11) ;

INSERT INTO adopter
(adopter_ID, name, surname, phone)
VALUES
(9, 'Noah', 'Ark', 6290003) ;

UPDATE adopter
SET phone = 8758440
WHERE adopter_ID = 3;

INSERT INTO adoptions
(adoption_ID, date, adopter_ID, adopt_cat_ID)
VALUES
(6, '2024-09-06', 9, 5),
(7, '2024-09-06', 9, 6) ;

UPDATE food
SET stock = stock - 2
WHERE food_ID = 31;

CALL low_stock_wet();

-- show all cats not yet adopted. 
SELECT cat_name FROM cats WHERE cat_ID NOT IN (SELECT adopt_cat_ID FROM adoptions);

-- DELETE oldest cat that is not yet adopted
DELETE FROM cats WHERE cat_ID NOT IN (SELECT adopt_cat_ID FROM adoptions) 
ORDER BY birthday 
LIMIT 1;

/* DELETE random cat that is not yet adopted
DELETE FROM cats WHERE cat_ID NOT IN (SELECT adopt_cat_ID FROM adoptions) 
ORDER BY RAND() 
LIMIT 1; */

