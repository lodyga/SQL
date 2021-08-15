# load the sample database 
mysql> source <filename>
source mysqlsampledatabase.sql

# Connect to the MySQL server 
mysql -u root -p
mysql -uroot -p!@#$!@#$ -h 127.0.0.1 -P 3306
localhost = 127.0.0.1

# show databases
mysql> show databases;


SELECT DATABASE() FROM DUAL;

USE classicmodels;




## Querying data
SELECT lastName
FROM classicmodels.employees;




## Sorting data
SELECT c1, c2 * c3 AS total
ORDER BY 
   column1 [ASC|DESC], 
   total [ASC|DESC],

ORDER BY 
    FIELD (status,
    'In Process',
    'Shipped');




## Filtering data;
# WHERE
    search_condition;

SELECT 
    lastname
FROM
    employees
WHERE
    jobtitle = 'Sales Rep' AND officeCode BETWEEN 1 AND 2
# The % wildcard matches any string of zero or more characters while the _ wildcard matches any single character.
# lastName LIKE '%son'
# officeCode IN (1, 2, 3)
# reportsTo IS NOT NULL;



# SELECT DISTINCT eliminate duplicate rows in a result set;

SELECT DISTINCT 
    state
FROM 
    customers
WHERE 
    state IS NOT NULL
ORDER BY 
    state;

SELECT 
    state
FROM 
    customers
WHERE 
    state IS NOT NULL
GROUP BY 
    state
ORDER BY 
    state;

SELECT DISTINCT
    state, city
FROM
    customers
WHERE
    state IS NOT NULL
ORDER BY 
    state, city;

SELECT 
    DISTINCT state
FROM 
    customers
WHERE 
    country = 'USA'
LIMIT
    5;



# AND Operator

# OR Operator
MySQL always evaluates the OR operators after the AND operators.
true OR false AND false
-----------------------
1;

# IN Operator;
SELECT 
    officeCode, 
    city, 
    phone, 
    country
FROM
    offices
WHERE
    country NOT IN ( "USA", "France" );

SELECT *
FROM
    orderdetails
WHERE
    orderNumber = 10165;

SELECT *
FROM
    orders
WHERE
    orderNumber = 10165;

SELECT
    orderNumber, SUM(quantityOrdered * priceEach) AS subtotal
FROM
    orderdetails
GROUP BY
    orderNumber
HAVING
    subtotal > 60000
;

SELECT
	orderNumber, 
	customerNumber, 
	status, 
	shippedDate
FROM
    orders
WHERE
    orderNumber IN
    (# 10165, 10287, 10310
        SELECT
            orderNumber
        FROM
            orderdetails
        GROUP BY
            orderNumber
        HAVING
            SUM(quantityOrdered * priceEach) > 60000
    );



# BETWEEN Operator;

SELECT 
   orderNumber,
   requiredDate,
   status
FROM 
   orders
WHERE 
   requireddate BETWEEN 
     CAST('2003-01-01' AS DATE) AND 
     CAST('2003-01-31' AS DATE);



# LIKE Operator;

SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    lastName NOT LIKE '%on';

SELECT 
    productCode, 
    productName
FROM
    products
WHERE
    # productCode LIKE '%\_20%'
    productCode LIKE '%$_20%' ESCAPE '$';



# LIMIT Operator;

SELECT 
    customerNumber, 
    customerName, 
    creditLimit
FROM
    customers
ORDER BY creditLimit DESC
LIMIT 2, 5;



# IS NULL Operator;

CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT,
    title VARCHAR(255),
    begin_date DATE NOT NULL,
    complete_date DATE NOT NULL,
    PRIMARY KEY(id)
);
INSERT INTO projects(title, begin_date, complete_date)
VALUES('New CRM','2020-01-01','0000-00-00'),
      ('ERP Future','2020-01-01','0000-00-00'),
      ('VR','2020-01-01','2030-01-01');
SELECT * 
FROM projects
WHERE complete_date IS NULL;

SELECT DISTINCT
    state, city
FROM
    customers
WHERE
    state IS NULL
ORDER BY 
    state, city;




## Joining tables;
# Table & Column Aliases ;

SELECT 
   [column_1 | expression] AS descriptive_name
   [column_1 | expression] AS `descriptive name`
FROM table_name;

SELECT
   CONCAT_WS(', ', lastName, firstname) AS 'Full name'
FROM
   employees;

SELECT
    orderNumber AS Order_no, 
    sum(priceEach * quantityOrdered) AS total
FROM
    orderdetails
GROUP BY
    Order_no
HAVING
    total > 60000;

SELECT
    c.customerName, COUNT(o.orderNumber) AS subtotal
FROM
    customers AS c
INNER JOIN orders AS o ON c.customerNumber = o.customerNumber
GROUP BY
    c.customerName
ORDER BY
    subtotal DESC;



# JOIN;

CREATE TABLE members (
    member_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (member_id)
);
CREATE TABLE committees (
    committee_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (committee_id)
);
INSERT INTO members(name)
VALUES('John'),('Jane'),('Mary'),('David'),('Amelia');
INSERT INTO committees(name)
VALUES('John'),('Mary'),('Amelia'),('Joe');
SELECT
    *
FROM
    members AS m
LEFT JOIN
    committees AS c USING(name)
WHERE
    committee_id IS NULL;
SELECT
    *
FROM
    members AS m
CROSS JOIN
    committees AS c;


# INNER JOIN;

SELECT
    p.productCode, p.productname, l.textDescription
FROM
    products AS p
INNER JOIN productlines AS l USING(productLine);

SELECT
    o.orderNumber, o.status, SUM(quantityOrdered * priceEach ) AS subtotal
FROM
    orders AS o
JOIN orderdetails AS od USING(orderNumber)
GROUP BY
    orderNumber
ORDER BY
    subtotal DESC;

SELECT
    o.orderNumber, o.status, SUM(quantityOrdered * priceEach ) AS subtotal
FROM
    orderdetails AS od
JOIN orders AS o USING(orderNumber)
GROUP BY
    orderNumber
ORDER BY
    subtotal DESC;

SELECT 
    orderNumber,
    orderDate,
    orderLineNumber,
    productName,
    quantityOrdered,
    priceEach
FROM
    orders
INNER JOIN
    orderdetails USING (orderNumber)
INNER JOIN
    products USING (productCode)
ORDER BY 
    orderNumber, 
    orderLineNumber;

SELECT
    orderNumber,
    orderDate,
    customerName,
    orderLineNumber,
    productName,
    quantityOrdered,
    priceEach
FROM
    orders
INNER JOIN orderdetails 
    USING (orderNumber)
INNER JOIN products 
    USING (productCode)
INNER JOIN customers 
    USING (customerNumber)
ORDER BY 
    orderNumber, 
    orderLineNumber;

SELECT
    orderNumber, productName, MSRP, priceEach
FROM
    products AS p
JOIN orderdetails AS o ON p.productcode = o.productcode AND priceEach < MSRP
WHERE
    p.productCode ='S10_1678';

SELECT 
    orderNumber, 
    productName, 
    msrp, 
    priceEach
FROM
    products p
INNER JOIN orderdetails o 
   ON p.productcode = o.productcode
      AND p.msrp > o.priceEach
WHERE
    p.productcode = 'S10_1678';


# LEFT JOIN;

SELECT 
    lastName, 
    firstName, 
    customerName, 
    checkNumber, 
    amount
FROM
    employees
LEFT JOIN customers ON 
    employeeNumber = salesRepEmployeeNumber
LEFT JOIN payments ON 
    payments.customerNumber = customers.customerNumber
ORDER BY 
    customerName, 
    checkNumber;

SELECT
    o.orderNumber, customerNumber, productCode
FROM
    orders AS o
LEFT JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
WHERE 
    o.orderNumber = '10123';

SELECT
    o.orderNumber, customerNumber, productCode
FROM
    orders AS o
LEFT JOIN orderdetails AS od ON o.orderNumber = od.orderNumber AND o.orderNumber = '10123';


# CROSS JOIN;

CREATE DATABASE IF NOT EXISTS salesdb;
USE salesdb;
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(13,2 )
);

CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100)
);

CREATE TABLE sales (
    product_id INT,
    store_id INT,
    quantity DECIMAL(13, 2 ) NOT NULL,
    sales_date DATE NOT NULL,
    PRIMARY KEY (product_id, store_id),
    FOREIGN KEY (product_id)
        REFERENCES products (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (store_id)
        REFERENCES stores (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO products(product_name, price)
VALUES('iPhone', 699),
      ('iPad',599),
      ('Macbook Pro',1299);

INSERT INTO stores(store_name)
VALUES('North'),
      ('South');

INSERT INTO sales ( store_id, product_id, quantity, sales_date )
VALUES(1,1,20,'2017-01-02'),
      (1,2,15,'2017-01-05'),
      (1,3,25,'2017-01-05'),
      (2,1,30,'2017-01-02'),
      (2,2,35,'2017-01-05');

SELECT
    st.store_name, pr.product_name, ( pr.price * sa.quantity ) AS revenue
FROM
    sales AS sa
JOIN products AS pr ON sa.product_id = pr.id
JOIN stores AS st ON sa.store_id = st.id;

SELECT
    st.store_name, pr.product_name, ROUND( SUM( pr.price * sa.quantity )) AS revenue
FROM
    sales AS sa
JOIN products AS pr ON sa.product_id = pr.id
JOIN stores AS st ON sa.store_id = st.id
GROUP BY st.store_name, pr.product_name;

SELECT
    store_name, product_name
FROM
    products AS pr
CROSS JOIN
    stores AS st
;

# to liczy źle
SELECT
    store_name, product_name, ROUND( SUM( pr.price * sa.quantity )) AS revenue
FROM
    products AS pr
CROSS JOIN
    stores AS st
JOIN sales AS sa ON sa.product_id = pr.id
GROUP BY
    store_name, product_name
;

SELECT
    st.id,
    pr.id,
    store_name,
    product_name,
    ROUND(SUM(quantity * price), 0) AS revenue
FROM
    sales AS sa
INNER JOIN products AS pr ON pr.id = sa.product_id
INNER JOIN stores AS st ON st.id = sa.store_id
GROUP BY st.id, pr.id, store_name, product_name;

SELECT 
    st.store_name, pr.product_name, IFNULL(c.revenue, 0) AS revenue
FROM
    products AS pr
        CROSS JOIN
    stores AS st
        LEFT JOIN
    (SELECT
        st.id AS store_id,
        pr.id AS product_id,
        store_name,
        product_name,
        ROUND(SUM(quantity * price), 0) AS revenue
    FROM
        sales AS sa
    INNER JOIN products AS pr ON pr.id = sa.product_id
    INNER JOIN stores AS st ON st.id = sa.store_id
    GROUP BY st.id, pr.id, store_name , product_name) AS c ON c.store_id = st.id
        AND c.product_id= pr.id
ORDER BY st.store_name;


# Self Join;

SELECT 
    CONCAT(sup.lastName, ', ', sup.firstName) AS sup,
    CONCAT(sub.lastName, ', ', sub.firstName) AS sub
FROM
    employees AS sup
INNER JOIN
    employees AS sub ON sup.employeeNumber = sub.reportsTo
ORDER BY
    sup
;

SELECT 
    IFNULL(CONCAT(sup.lastName, ', ', sup.firstName), 'Nobody') AS sup,
    CONCAT(sub.lastName, ', ', sub.firstName) AS sub
FROM
    employees AS sup
RIGHT JOIN
    employees AS sub ON sup.employeeNumber = sub.reportsTo
ORDER BY
    sup DESC
;

SELECT
    c1.city, c1.customerName AS c1, c2.customerName AS c2
FROM
    customers AS c1
INNER JOIN
    customers AS c2 ON 
    c1.city = c2.city AND
    c1.customerName > c2.customerName
ORDER BY
    c1.city
;




## Grouping data
# GROUP BY;

SELECT
    status
FROM
    orders
GROUP BY
    status
;

SELECT
    DISTINCT status
FROM
    orders
;

SELECT
    status, COUNT(status) AS counter
FROM
    orders
GROUP BY
    status
;

SELECT
    ord.status, 
    SUM(od.quantityOrdered * od.priceEach) AS total
FROM
    orders AS ord
INNER JOIN
    orderdetails AS od USING (orderNumber)
GROUP BY
    ord.status
;

SELECT
    YEAR(ord.orderDate) AS YEAR,
    MONTH(ord.orderDate) AS MONTH,
    SUM(od.quantityOrdered * od.priceEach) AS total
FROM
    orders AS ord
INNER JOIN
    orderdetails AS od USING (orderNumber)
WHERE
    status = 'Shipped'
GROUP BY
    YEAR, MONTH
HAVING
    YEAR > 2003
;


# HAVING;

SELECT
    ord.orderNumber,
    SUM(od.quantityOrdered) AS quan,
    SUM(od.quantityOrdered * od.priceEach) AS total
FROM
    orders AS ord
INNER JOIN
    orderdetails AS od USING (orderNumber)
GROUP BY
    ord.orderNumber 
WITH ROLLUP
HAVING
    total > 10000 AND
    quan > 600
;

SELECT
    ord.orderNumber,
    ord.status,
    SUM(od.quantityOrdered * od.priceEach) AS total
FROM
    orders AS ord
INNER JOIN
    orderdetails AS od USING (orderNumber)
GROUP BY
    ord.orderNumber
HAVING
    total > 10000 AND
    ord.status = 'Shipped'
;


# ROLLUP;

CREATE TABLE sales
SELECT
    productLine,
    YEAR(orderDate) orderYear,
    SUM(quantityOrdered * priceEach) orderValue
FROM
    orderdetails
        INNER JOIN
    orders USING (orderNumber)
        INNER JOIN
    products USING (productCode)
GROUP BY
    productLine ,
    YEAR(orderDate);

SELECT
    productLine, SUM(orderValue) AS totalValue
FROM
    sales
GROUP BY
    productLine
;

SELECT
    SUM(orderValue) AS totalValue
FROM
    sales
;

SELECT
    productLine, SUM(orderValue) AS totalValue
FROM
    sales
GROUP BY
    productLine
UNION ALL
SELECT
    NULL,
    SUM(orderValue) AS totalValue
FROM
    sales
;

SELECT
    productLine, SUM(orderValue) AS totalValue
FROM
    sales
GROUP BY
    productLine
WITH ROLLUP
;

SELECT 
    productLine, 
    orderYear,
    SUM(orderValue) AS totalOrderValue
FROM
    sales
GROUP BY 
    productline, 
    orderYear
WITH ROLLUP
;

SELECT 
    orderYear,
    productLine,
    SUM(orderValue) AS totalOrderValue
FROM
    sales
GROUP BY 
    orderYear,
    productline
WITH ROLLUP
;

SELECT 
    orderYear,
    productLine, 
    SUM(orderValue) totalOrderValue,
    GROUPING(orderYear),
    GROUPING(productLine)
FROM
    sales
GROUP BY 
    orderYear,
    productline
WITH ROLLUP;

SELECT
    IF( GROUPING(orderYear), 'AllYears', orderYear ),
    IF( GROUPING(productLine), 'AllLines', productLine ), 
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    orderYear,
    productline
WITH ROLLUP;




## Subqueries
# Subquery

SELECT
    lastName, firstName
FROM
    employees
WHERE
    officeCode IN 
    (SELECT
        officeCode
    FROM
        offices
    WHERE
        country = "USA")
;

SELECT
    customerNumber, checkNumber, amount
FROM
    payments
WHERE
    amount = 
    (SELECT
        MAX(amount)
    FROM
        payments
    )
;

SELECT
    customerNumber, checkNumber, amount
FROM
    payments
WHERE
    amount >= 
    (SELECT
        AVG(amount)
    FROM
        payments
    )
;

SELECT
    customerName
FROM
    customers
WHERE
    customerNumber NOT IN
    (SELECT DISTINCT
        customerNumber
    FROM
        orders)
;

SELECT
    COUNT(*) AS items
FROM
    orderdetails
GROUP BY
    orderNumber
;

SELECT
    MIN(items) AS min,
    MAX(items) AS max,
    FLOOR(AVG(items)) AS avg
FROM
    (SELECT
        COUNT(*) AS items
    FROM
        orderdetails
    GROUP BY
        orderNumber) AS mustAlias
;

SELECT 
    orderNumber, 
    COUNT(*) AS items
FROM
    orderdetails
GROUP BY orderNumber
;

SELECT
    productName, productLine, buyPrice
FROM
    products
WHERE
    buyPrice >
    (SELECT 
        AVG(buyPrice)
    FROM
        products)
;

SELECT
    productName, productLine, buyPrice
FROM
    products AS p1
WHERE
    buyPrice >
    (SELECT 
        AVG(buyPrice)
    FROM
        products
    WHERE
        productLine = p1.productLine)
;

SELECT
    ROUND(AVG(buyPrice))
FROM
    products
;

SELECT
    productLine,
    ROUND(AVG(buyPrice))
FROM
    products
GROUP BY
    productLine
;

SELECT 
    orderNumber, 
    SUM(priceEach * quantityOrdered) total
FROM
    orderdetails
INNER JOIN
    orders USING (orderNumber)
GROUP BY 
    orderNumber
HAVING 
    SUM(priceEach * quantityOrdered) > 60000
;

# To jest podejrzane, EXISTS magicznie działa
SELECT
    customerNumber, customerName
FROM
    customers
WHERE EXISTS
    (SELECT 
        orderNumber, 
        SUM(priceEach * quantityOrdered) total
    FROM
        orderdetails
    INNER JOIN
        orders USING (orderNumber)
    GROUP BY 
        orderNumber
    HAVING 
        SUM(priceEach * quantityOrdered) > 60000)
;

# Derived table;

SELECT
    od.productCode,
    SUM(od.quantityOrdered * od.priceEach) AS sales
FROM
    orders AS o
INNER JOIN
    orderdetails AS od USING( orderNumber )
GROUP BY
    od.productCode
ORDER BY
    sales DESC
LIMIT 5
;

SELECT
    productName, sales
FROM
    (SELECT
        od.productCode,
        SUM(od.quantityOrdered * od.priceEach) AS sales
    FROM
        orders AS o
    INNER JOIN
        orderdetails AS od USING( orderNumber )
    GROUP BY
        od.productCode
    ORDER BY
        sales DESC
    LIMIT 5) AS useless
INNER JOIN
    products USING (productCode)
;

# odwrotnie nie chce
SELECT
    productName, sales
FROM
    products
INNER JOIN
    ((SELECT
        od.productCode,
        SUM(od.quantityOrdered * od.priceEach) AS sales
    FROM
        orders AS o
    INNER JOIN
        orderdetails AS od USING( orderNumber )
    GROUP BY
        od.productCode
    ORDER BY
        sales DESC
    LIMIT 5) AS useless) USING (productCode)
;

SELECT
    o.customerNumber,
    ROUND(SUM(od.quantityOrdered * od.priceEach)) AS sales,
    (CASE
        WHEN ROUND(SUM(od.quantityOrdered * od.priceEach)) < 10000 THEN 'bieda'
        WHEN ROUND(SUM(od.quantityOrdered * od.priceEach)) BETWEEN 10000 AND 100000 THEN 'średniaki'
        WHEN ROUND(SUM(od.quantityOrdered * od.priceEach)) > 100000 THEN 'dobra_klient'
    END) AS c_level
FROM
    orders AS o
INNER JOIN
    orderdetails AS od USING (orderNumber)
WHERE
    YEAR(shippedDate) = '2003'
GROUP BY
    o.customerNumber
;

SELECT
    c_level, COUNT(c_level) AS groupCount
FROM
    (SELECT
        o.customerNumber,
        ROUND(SUM(od.quantityOrdered * od.priceEach)) AS sales,
        (CASE
            WHEN ROUND(SUM(od.quantityOrdered * od.priceEach)) < 10000 THEN 'bieda'
            WHEN ROUND(SUM(od.quantityOrdered * od.priceEach)) BETWEEN 10000 AND 100000 THEN 'średniaki'
            WHEN ROUND(SUM(od.quantityOrdered * od.priceEach)) > 100000 THEN 'dobra_klient'
        END) AS c_level
    FROM
        orders AS o
    INNER JOIN
        orderdetails AS od USING (orderNumber)
    WHERE
        YEAR(shippedDate) = '2003'
    GROUP BY
        o.customerNumber) AS imp_tab
GROUP BY
    imp_tab.c_level
;


# EXISTS;

SELECT
    o.customerNumber, c.customerName, c.city
FROM
    orders AS o
INNER JOIN
    customers AS c USING (customerNumber)
WHERE
    city = 'San Francisco'
GROUP BY
    o.customerNumber
;

SELECT
    o.customerNumber, c.customerName
FROM
    customers AS c
INNER JOIN
    orders AS o USING (customerNumber)
WHERE
    city = 'San Francisco'
GROUP BY
    o.customerNumber
;

SELECT
    c.customerNumber, c.customerName
FROM
    customers AS c
WHERE EXISTS
    (SELECT
        *
    FROM
        orders AS o
    WHERE o.customerNumber = c.customerNumber AND
    city = 'San Francisco')
;

SELECT
    o.customerNumber
FROM
    orders AS o
WHERE EXISTS
    (SELECT
        *
    FROM
        customers AS c
    WHERE o.customerNumber = c.customerNumber AND
    city = 'San Francisco')
;

SELECT
    e.employeeNumber, e.firstName, e.lastName, e.extension
FROM
    employees AS e
WHERE EXISTS
    (SELECT
        10
    FROM
        offices AS o
    WHERE
        e.officeCode = o.officeCode AND
        city = 'San Francisco')
;

UPDATE
    employees AS e
SET
    e.extension = CONCAT( e.extension, '1' )
WHERE EXISTS
    (SELECT
        10
    FROM
        offices AS o
    WHERE
        e.officeCode = o.officeCode AND
        city = 'San Francisco')
;









# SELECT NULL blank coulmn



USE classicmodels
SELECT *
FROM customers;


SHOW DATABASES

DROP DATABASE classicmodels

ALTER TABLE cust2
ADD COLUMN add1 varchar(50) AFTER phone

INSERT INTO cust2 (add1)
SELECT addressLine1
FROM customers

CREATE TABLE classicmodels.cust2 AS
SELECT * FROM classicmodels.customers

ALTER TABLE cust2
DROP COLUMN addressLine1

SELECT * FROM `classicmodels`.`cust2` LIMIT 1000;

SELECT status, COUNT(orderNumber) AS status_count
FROM `classicmodels`.`orders`
GROUP BY status
HAVING COUNT(orderNumber) > 5
ORDER BY COUNT(orderNumber) ASC
LIMIT 1000;