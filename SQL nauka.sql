mysql -uroot -pq@#$!@#$ -h 127.0.0.1 -P 3306

https://www.w3schools.com/sql/default.asp

SELECT [DISTINCT|ALL ] { * | [fieldExpression [AS newName]} FROM tableName [alias] [WHERE condition][GROUP BY fieldName(s)]  [HAVING condition] ORDER BY fieldName(s)

CLALSSES
USE
SELECT COUNT, MIN, AVG(* | <col_name> || <col_name2>  AS (alias) | DISTINCT)
FROM
JOIN tab_name
WHERE (ON) col_name <=> val col_name in () | BETWEEN x AND y | LIKE '%a%' IS NOT NULL
ORDER BY <col_name> DESC
GROUP BY
HAVING
LIMIT <int> OFFSET <int>  `skip`, `show`

Sub-Query
SELECT category_name
FROM myflixdb.categories
WHERE category_id = (SELECT MIN(category_id) FROM movies)

SELECT full_names
FROM members
WHERE membership_number = (
	SELECT 
	membership_number
	FROM payments
	WHERE amount_paid = (
		SELECT MAX(amount_paid)
		FROM payments
    )
);

SELECT movie_id, title FROM myflixdb.movies
UNION
SELECT membership_number, full_names FROM members

UNION DISTINCT
UNION ALL


UPDATE Customers
SET ContactName = 'Alfred Schmidt', City= 'Frankfurt'
WHERE CustomerID = 1; col_id IN (int1, int2)

SHOW COLUMNS FROM members

INSERT INTO movies (title, director, year_released, category_id)
VALUES ('The Great Dictator', 'Chalie Chaplie', 1920, 7),
	('sample movie', 'Anonymous', DEFAULT, 8),
	('movie 3', 'John Brown', 1920, 8);
	
DELETE FROM movies
WHERE movie_id IN (17, 19)

UPDATE movies
SET title = 'movie 4', year_released = 1921
WHERE movie_id = 22

INSERT INTO customers2
SELECT * 
FROM customers;

INSERT INTO Customers (CustomerName, City, Country)
SELECT SupplierName, City, Country 
FROM Suppliers;

CREATE TABLE customers2 AS
SELECT * FROM customers
where 0=1;

INSERT INTO table2 (column1, column2, column3, ...)
SELECT column1, column2, column3, ...
FROM table1
WHERE condition;

IFNULL(UnitsOnOrder, 0)

delimiter //
CREATE procedure GetOfficeByCountry(
	in CountryName varchar(50),
    out total int
    )
begin
	select COUNT(country)
    into total
    from customers
    where country = countryName;
end //
delimiter ;
CALL GetOfficeByCountry('USA', @total);
SELECT @total

/* comment */

CREATE DATABASE databasename;
DROP DATABASE databasename;


CREATE TABLE categories_archive (
    category_id INT(11) AUTO_INCREMENT,
    category_name VARCHAR(150) DEFAULT NULL,
    remarks VARCHAR(500) DEFAULT NULL,
    PRIMARY KEY (category_id),
	unique()
);

CREATE TABLE new_name AS
SELECT * 
FROM old_name

CREATE TABLE IF NOT EXISTS MyFlixDB (
    membership_number INT AUTO_INCREMENT,
    full_names VARCHAR(150) NOT NULL,
    gender VARCHAR(6),
    date_of_birth DATE,
    PRIMARY KEY (membership_number)
);

SHOW TABLES
DROP TABLE IF EXISTS MyFlixDB
TRUNCATE TABLE table_name

ALTER TABLE animal
ADD length INT
ADD COLUMN `credit_card_number` VARCHAR(25);

DROP col_name

ALTER TABLE animal
CHANGE COLUMN fullnames full_names VARCHAR(250) NOT NULL

ALTER TABLE animal
MODIFY full_names VARCHAR(50) NOT NULL, DEFAULT 'male';

ADD date_of_registration DATE NULL AFTER date_of_birth;
RENAME TABLE movierentals to movie_rentials


INSERT INTO tab_name (col_nameA, col_nameB) - dodawanie elementów do tablicy
VALUES(NULL, DEFAULT),
		(next item)

ALTER TABLE Persons
MODIFY Age int NOT NULL;

ALTER TABLE orders
ADD CONSTRAINT for_kej FOREIGN KEY (customer_id) REFERENCES customers (customer_id);

ALTER TABLE orders
DROP FOREIGN KEY orders_ibfk_2

CREATE TABLE products
( product_id INT PRIMARY KEY,
  product_name VARCHAR(50) NOT NULL,
  category VARCHAR(25)
);

CREATE TABLE inventory
( inventory_id INT PRIMARY KEY,
  product_id INT NOT NULL,
  quantity INT,
  min_level INT,
  max_level INT,
  CONSTRAINT fk_inv_product_id
    FOREIGN KEY (product_id)
    REFERENCES products (product_id)
);

ALTER TABLE inventory
DROP CONSTRAINT fk_inv_product_id;

ALTER TABLE animal2
MODIFY id int;

ALTER TABLE animal2
ADD PRIMARY KEY (id);

ALTER TABLE animal2
DROP PRIMARY KEY;

ALTER TABLE inventory
ADD FOREIGN KEY (product_id) REFERENCES products (product_id);

ALTER table animal2
MODIFY gender DROP DEFAULT;






SELECT OrderID, Quantity,
CASE
    WHEN Quantity > 30 THEN 'The quantity is greater than 30'
    WHEN Quantity = 30 THEN 'The quantity is 30'
    ELSE 'The quantity is under 30'
END AS QuantityText
FROM OrderDetails;

SELECT  CustomerName, City, Country
FROM Customers
ORDER BY (CASE
    WHEN City IS NULL THEN Country
    ELSE City
END);


CONCAT()
LEFT(str, int) ile znakow z lewej wyswietlic


SELECT category_id, year_released
FROM movies
GROUP BY category_id, year_released

SELECT gender,
COUNT(gender) (COUNT, MAX, MIN, SUM, AVG)
FROM members
GROUP BY gend

SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) > 5
ORDER BY COUNT(CustomerID) DESC;

 = ANY () to to samo co IN () 

SELECT COUNT(movie_id)
FROM movierentals
WHERE movie_id = 2;


CREATE INDEX `title_index` ON `movies`(`title`);
SHOW INDEXES FROM movies;
DROP INDEX ` full_names` ON `members_indexed`;


'a%' - starts with a
'%a' - ends with a
_ - single character
REGEXP '^a$' '^x1|x2$' '[eo]n$' '[a-d]'
compound join condition
(inner, left, full) join tab1_name1
	on tab1_name.col_nameA = tab2_name.col_nameA
	and tab1_name.col_nameB = tab2_name.col_nameB
	using(col_nameA, col_name1B)
cross join - każdy z każdym np. rozmiary z kolorami lub from tab_nameA, tab_nameB 
FROM tab1_name t(short)

SELECT m.full_names, mo.title
FROM movierentals mr
JOIN members m
USING (membership_number)
JOIN movies mo
USING (movie_id);

SELECT A.CustomerName AS CustomerName1, B.CustomerName AS CustomerName2, A.City
FROM Customers A, Customers B
WHERE A.CustomerID != B.CustomerID
AND A.City = B.City 
ORDER BY A.City;

SELECT * FROM orders NATURAL JOIN customers

SELECT m.full_names, mo.title
FROM movierentals mr, members m, movies mo
WHERE mr.membership_number = m.membership_number
AND mr.movie_id = mo.movie_id;


DELIMITER |
CREATE FUNCTION sf_past_movie_return_date (return_date DATE)
  RETURNS VARCHAR(3)
   DETERMINISTIC
    BEGIN
     DECLARE sf_value VARCHAR(3);
        IF curdate() > return_date
            THEN SET sf_value = 'Yes';
        ELSEIF  curdate() <= return_date
            THEN SET sf_value = 'No';
        END IF;
     RETURN sf_value;
    END|
SELECT movie_id, membership_number, return_date, CURDATE(), sf_past_movie_return_date(return_date)  
FROM movierentals;

CREATE VIEW accounts2 AS 
`tu idzie normalny kod` 
SELECT membership_number, full_names, gender FROM members

1) COUNT
2) SUM
3) AVG
4) MIN
5) MAX 

WHERE contactLastName like '%b_r%' 
WHERE postalCode not like '%5'
WHERE title LIKE '67$%%' ESCAPE '$'
SELECT * FROM `movies` WHERE `title` REGEXP '^[^abcd]';
WHERE contactLastName regexp '^a' && contactLastName regexp 'n$|h$'
WHERE contactLastName regexp '[a- e]n$'
WHERE contactFirstName regexp 'e$|na$' and state = 'CA'
WHERE state is not null and postalCode is not null
WHERE shippedDate is not null 
ORDER by orderNumber DESC
CREATE TABLE orders_arch AS
SELECT * FROM orders
UPDATE orders_arch
SET comments = 'dobra klient'
WHERE customerNumber IN 
    (SELECT customerNumber
    FROM customers
    WHERE creditlimit > 100000)

DDL commands are: 
1) CREATE, 2) ALTER, 3) DROP, 4) TRUNCATE, etc. 
DML commands are: 
1) INSERT, 2) UPDATE, 3) DELETE, 4) MERGE, etc.
