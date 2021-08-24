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
SHOW INDEX FROM classicmodels.employees;
DESCRIBE classicmodels.employees;



## Section 1. Querying data;
SELECT lastName
FROM classicmodels.employees;




## Section 2. Sorting data;
SELECT c1, c2 * c3 AS total
ORDER BY 
   column1 [ASC|DESC], 
   total [ASC|DESC],

ORDER BY 
    FIELD (status,
    'In Process',
    'Shipped');




## Section 3. Filtering data;
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




## Section 4. Joining tables;
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




## Section 5. Grouping data;
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




## Section 6. Subqueries;
# Subquery;

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

CREATE TABLE 
    customers_archive
LIKE 
    customers
;

INSERT INTO 
    customers_archive
SELECT 
    *
FROM
    customers AS c
WHERE NOT EXISTS
    (SELECT
        1
    FROM
        orders AS o
    WHERE
        o.customerNumber = c.customerNumber)
;

DELETE FROM 
    customers_archive AS ca
WHERE EXISTS
    (SELECT
        *
    FROM
        customers AS c
    WHERE
        c.customerNumber = ca.customerNumber)
;

SELECT
    c.customerName
FROM
    customers AS c
WHERE c.customerNumber IN
    (SELECT
        customerNumber
    FROM
        orders AS o)
;

SELECT 
    c.customerName
FROM
    customers AS c
WHERE EXISTS
    (SELECT
        1
    FROM
        orders AS o
    WHERE
        o.customerNumber = c.customerNumber)
;

The query that uses the EXISTS operator is much faster than the one that uses the IN operator.

The reason is that the EXISTS operator works based on the “at least found” principle. The EXISTS stops scanning the table when a matching row found.

On the other hands, when the IN operator is combined with a subquery, MySQL must process the subquery first and then uses the result of the subquery to process the whole query.

The general rule of thumb is that if the subquery contains a large volume of data, the EXISTS operator provides better performance.

However, the query that uses the IN operator will perform faster if the result set returned from the subquery is very small.

For example, the following statement uses the IN operator selects all employees who work at the office in San Francisco.




## Section 7. Common Table Expressions;
# Common Table Expression or CTE;

WITH customers_in_USA AS (
    SELECT
        customerName, state, customerNumber
    FROM
        customers
    WHERE
        country = 'USA'
) SELECT
    customerName, state
FROM
    customers_in_USA
WHERE
    state = 'CA'
;

# to wybiera najlpszego klienta i jego opiekuna, czyil źle
WITH top_sales AS(
SELECT
    o.customerNumber,
    SUM(od.quantityOrdered * od.priceEach) AS sales
FROM
    orders AS o
INNER JOIN
    orderdetails AS od USING( orderNumber )
WHERE
    YEAR(shippedDate) = '2003' AND
    status = 'Shipped'
GROUP BY
    o.customerNumber
ORDER BY
    sales DESC
LIMIT 5
)SELECT
    e.employeeNumber, e.firstName, e.lastName, sales, c.customerNumber
FROM
    top_sales
INNER JOIN
    customers AS c ON c.customerNumber = top_sales.customerNumber
INNER JOIN
    employees AS e ON e.employeeNumber = c.salesRepEmployeeNumber
;

WITH top_sales AS (
SELECT
    c.salesRepEmployeeNumber,
    SUM(od.quantityOrdered * od.priceEach) AS sales
FROM
    orders AS o
INNER JOIN
    orderdetails AS od USING( orderNumber )
INNER JOIN
    customers AS c USING(customerNumber)
WHERE
    YEAR(shippedDate) = '2003' AND
    status = 'Shipped'
GROUP BY
    c.salesRepEmployeeNumber
ORDER BY
    sales DESC
LIMIT 5
)SELECT
    e.employeeNumber, e.lastName, e.firstName, top_sales.sales
FROM
    top_sales
INNER JOIN
    employees AS e ON e.employeeNumber = top_sales.salesRepEmployeeNumber
;

WITH sales_rep AS (
SELECT
    employeeNumber AS salesRepEmployeeNumber, 
    CONCAT(firstName, ' ', lastName) AS rep_name
FROM
    employees
WHERE
    jobTitle = 'Sales Rep'
),
cust_rep AS (
SELECT
    customerName, rep_name
FROM
    customers
INNER JOIN
    sales_rep USING(salesRepEmployeeNumber)
)
SELECT
    *
FROM
    cust_rep
ORDER BY
    customerName
;

WITH sales_rep AS (
SELECT
    employeeNumber AS salesRepEmployeeNumber, 
    CONCAT(firstName, ' ', lastName) AS rep_name
FROM
    employees
WHERE
    jobTitle = 'Sales Rep'
)
SELECT
    customerName, rep_name
FROM
    customers AS c
INNER JOIN
    sales_rep USING(salesRepEmployeeNumber)
ORDER BY
    customerName
;

First, a WITH clause can be used at the beginning of SELECT, UPDATE, and DELETE statements:

WITH ... SELECT ...
WITH ... UPDATE ...
WITH ... DELETE ...


# Recursive CTE;

WITH RECURSIVE cte_count(n) AS
    (SELECT 3
    UNION ALL
    SELECT n + 1 
    FROM cte_count 
    WHERE n < 5)
SELECT n 
FROM cte_count
;

WITH RECURSIVE employee_paths AS
    (SELECT employeeNumber,
           reportsTo managerNumber,
           officeCode, 
           1 lvl
   FROM employees
   WHERE reportsTo IS NULL
     UNION ALL
     SELECT e.employeeNumber,
            e.reportsTo,
            e.officeCode,
            lvl+1
     FROM employees e
     INNER JOIN employee_paths ep ON ep.employeeNumber = e.reportsTo )
SELECT employeeNumber,
       managerNumber,
       lvl,
       city
FROM employee_paths ep
INNER JOIN offices o USING (officeCode)
ORDER BY lvl, city;

SELECT 
    employeeNumber, 
    reportsTo managerNumber, 
    officeCode, 
    1 lvl
FROM
    employees
WHERE
    reportsTo IS NULL;

WITH RECURSIVE employee_paths AS
    (SELECT employeeNumber,
           reportsTo managerNumber,
           officeCode, 
           1 lvl
   FROM employees
   WHERE reportsTo IS NULL
     UNION ALL
     SELECT e.employeeNumber AS foo,
            e.reportsTo,
            e.officeCode,
            lvl+1 AS bar
     FROM employees e
     INNER JOIN employee_paths ep ON ep.employeeNumber = e.reportsTo )
SELECT
    *
FROM
    employee_paths;




## Section 8. Set operators
# UNION and UNION ALL;

DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
CREATE TABLE t1 (
    id INT PRIMARY KEY
);
CREATE TABLE t2 (
    id INT PRIMARY KEY
);
INSERT INTO t1
    VALUES (1), (2), (3);
INSERT INTO t2
    VALUES (2), (3), (4);
SELECT
    id
FROM t1
UNION DISTINCT
SELECT
    id
FROM
    t2
;
SELECT
    id
FROM t1
UNION ALL
SELECT
    id
FROM
    t2
;

SELECT
    firstName, lastName
FROM
    employees
UNION
SELECT
    contactFirstName, contactLastName
FROM
    customers
;

SELECT 
    CONCAT(firstName, ' ', lastName) fullname, 
    'Employee' AS contactType
FROM
    employees 
UNION
SELECT 
    CONCAT(contactFirstName, ' ', contactLastName),
    'Customer'
FROM
    customers
ORDER BY 
    fullname
;

SELECT
    firstName AS first, lastName AS last,
    'Employee' AS contactType
FROM
    employees
UNION
SELECT
    contactFirstName, contactLastName, 'Customer'
FROM
    customers
ORDER BY
    last, first
;


# INTERSECT;

SELECT DISTINCT
    id
FROM
    t1
INNER JOIN
    t2 USING(id)
;

SELECT
    id
FROM
    t1
WHERE
    id IN (SELECT id FROM t2)
;


# MINUS;

# Jakoś to działa
SELECT
    id
FROM
    t1
LEFT JOIN
    t2 USING(id)
WHERE
    t2.id IS NULL
;

SELECT
    id
FROM
    t1
LEFT JOIN
    t2 USING(id)
;

SELECT
    t2.id
FROM
    t1
LEFT JOIN
    t2 USING(id)
WHERE
    t2.id IS NULL
;




## Section 9. Modifying data in MySQL
# INSERT;

DROP TABLE IF EXISTS tasks;
CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT,
    title varchar(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    prioroty TINYINT NOT NULL DEFAULT 3,
    description TEXT,
    PRIMARY KEY (task_id)
)
;
INSERT INTO tasks (title, prioroty)
    VALUES ('Learn ReactJS', 1)
;
INSERT INTO tasks (title, prioroty)
    VALUES ('Also JavaScript', DEFAULT)
;
INSERT INTO tasks (title, start_date, due_date)
    VALUES ('Meaby Django', '2021-08-19', '2021-08-20')
;
INSERT INTO tasks (title, start_date, due_date)
    VALUES ('Today', CURRENT_DATE(), current_date)
;
INSERT INTO tasks (title, prioroty)
    VALUES ('First task', 1),
            ('Second task', 2),
            ('Third task', 3)
;


# Insert Multiple Rows;

SHOW VARIABLES LIKE 'max_allowed_packet';
# nie słucha się
SET GLOBAL max_allowed_packet = 4194304;
SET GLOBAL max_allowed_packet = 1024;

DROP TABLE IF EXISTS projects;
CREATE TABLE projects(
    project_id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY(project_id)
);
INSERT INTO 
	projects(name, start_date, end_date)
VALUES
	('AI for Marketing','2019-08-01','2019-12-31'),
	('ML for Sales','2019-05-15','2019-11-20');
SELECT LAST_INSERT_ID();


# INSERT INTO SELECT;

DROP TABLE IF EXISTS suppliers;
CREATE TABLE IF NOT EXISTS suppliers (
    supplierNumber INT AUTO_INCREMENT,
    supplierName VARCHAR(100) NOT NULL,
    phone VARCHAR(50),
    addressLine1 VARCHAR(50),
    addressLine2 VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postalCode VARCHAR(50),
    country VARCHAR(50),
    customerNumber INT,
    PRIMARY KEY (supplierNumber)
);

INSERT INTO suppliers (
    supplierName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    customerNumber
)
SELECT 
    customerName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    customerNumber
FROM
    customers
WHERE
    country = 'USA' AND 
    state = 'CA'
;

CREATE TABLE stats (
    totalProduct INT,
    totalCustomer INT,
    totalOrder INT
);
INSERT INTO stats (totalProduct, totalCustomer, totalOrder)
    VALUES (
        (SELECT COUNT(*) FROM products),
        (SELECT COUNT(*) FROM customers),
        (SELECT COUNT(*) FROM orders)
    )
;


# INSERT IGNORE;

DROP TABLE IF EXISTS subscribers;
CREATE TABLE subscribers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(50) NOT NULL UNIQUE
)
;
INSERT INTO subscribers(email)
VALUES('john.doe@gmail.com')
;
INSERT INTO subscribers(email)
VALUES('john.doe@gmail.com'),
      ('jane.smith@ibm.com')
;
INSERT IGNORE INTO subscribers(email)
VALUES('john.doe@gmail.com'),
      ('jane.smith@ibm.com')
;

CREATE TABLE tokens (
    s VARCHAR(6)
);
INSERT INTO tokens VALUES('abcdefg');
INSERT IGNORE INTO tokens VALUES('abcdefg');


# UPDATE;

SELECT
    firstName, lastName, email
FROM
    employees
WHERE
    employeeNumber = 1056
;
UPDATE
    employees 
SET 
    lastname = 'Hill',
    email = 'mary.hill@classicmodelcars.com'
WHERE
    employeeNumber = 1056
;

UPDATE
    employees
SET
    email = REPLACE(email, '@classicmodelcars.com', '@cola.com')
WHERE
    officeCode = '6' AND
    jobTitle = 'Sales Rep'
;
SELECT
    *
FROM
    employees
WHERE
    officeCode = '6' AND
    jobTitle = 'Sales Rep'
;   

SELECT
    customerNumber,
    salesRepEmployeeNumber
FROM
    customers
WHERE
    salesRepEmployeeNumber IS NULL
;

SELECT
    employeeNumber
FROM
    employees
ORDER BY RAND()
LIMIT 1
;

SELECT
    employeeNumber
FROM
    employees
WHERE
    employeeNumber = 666
;

# nie doda 666, bo nie ma takiego pracownika
UPDATE
    customers
SET
    salesRepEmployeeNumber = 666
WHERE
    salesRepEmployeeNumber IS NULL
;

INSERT INTO
    employees()
VALUES
    (666, 'Satan', 'St', 'x666', 'st.satan@bogu.pl', 1, 1002, 'Soul Harvester')
;


# UPDATE JOIN;


DROP DATABASE IF EXISTS empdb;
CREATE DATABASE IF NOT EXISTS empdb;
USE empdb;
CREATE TABLE merits (
    performance INT(11) PRIMARY KEY,
    percentage FLOAT NOT NULL
);
CREATE TABLE employees (
    emp_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(255) NOT NULL,
    performance INT(11) DEFAULT NULL,
    base_salary FLOAT DEFAULT NULL,
    salary FLOAT DEFAULT NULL,
    CONSTRAINT fk_performance FOREIGN KEY (performance)
        REFERENCES merits (performance)
);
INSERT INTO merits()
VALUES  (1,0),
        (2,0.01),
        (3,0.03),
        (4,0.05),
        (5,0.08)
;
INSERT INTO employees(emp_name, performance, base_salary)
VALUES('Mary Doe', 1, 50000),
      ('Cindy Smith', 3, 65000),
      ('Sue Greenspan', 4, 75000),
      ('Grace Dell', 5, 125000),
      ('Nancy Johnson', 3, 85000),
      ('John Doe', 2, 45000),
      ('Lily Bush', 3, 55000)
;
UPDATE
    employees
INNER JOIN
    merits ON merits.performance = employees.performance
SET
    salary = base_salary * (1 + percentage)
;
UPDATE
    employees
INNER JOIN
    merits USING(performance)
SET
    salary = base_salary * (1 + percentage)
;
UPDATE
    employees, merits
SET
    salary = base_salary * (1 + percentage)
WHERE
    merits.performance = employees.performance
;
INSERT INTO employees(emp_name, performance, base_salary)
VALUES('Jack William', NULL, 43000),
      ('Ricky Bond', NULL, 52000)
;
# INNER JOIN i LEFT JOIN robią tu to samo
UPDATE
    employees
LEFT JOIN
    merits USING(performance)
SET
    salary = base_salary * (1 + 0.015)
WHERE
    performance IS NULL
;


# DELETE;

DELETE FROM
    employees
WHERE
    emp_name = 'Jack William'
;

DELETE FROM customers
WHERE country = 'France'
ORDER BY creditLimit
LIMIT 5;


# ON DELETE CASCADE;

CREATE TABLE buildings (
    building_no INT PRIMARY KEY AUTO_INCREMENT,
    building_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);
CREATE TABLE rooms (
    room_no INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(255) NOT NULL,
    building_no INT NOT NULL,
    FOREIGN KEY (building_no)
        REFERENCES buildings (building_no)
        ON DELETE CASCADE
);
INSERT INTO buildings(building_name,address)
VALUES  ('ACME Headquaters','3950 North 1st Street CA 95134'),
        ('ACME Sales','5000 North 1st Street CA 95134');
INSERT INTO rooms(room_name,building_no)
VALUES('Amazon',1),
      ('War Room',1),
      ('Office of CEO',1),
      ('Marketing',2),
      ('Showroom',2);
DELETE FROM buildings 
WHERE building_no = 2;

# coś nie pokazuje to co powinno
USE information_schema;
SELECT 
    table_name
FROM
    referential_constraints
WHERE
    constraint_schema = 'classicmodels'
        AND referenced_table_name = 'buildings'
        AND delete_rule = 'CASCADE'
;


# DELETE JOIN;

DROP TABLE IF EXISTS t1, t2;
CREATE TABLE t1 (
    id INT PRIMARY KEY AUTO_INCREMENT
);
CREATE TABLE t2 (
    id VARCHAR(20) PRIMARY KEY,
    ref INT NOT NULL
);
INSERT INTO t1
VALUES (1), (2), (3);
INSERT INTO t2(id, ref)
VALUES  ('A', 1),
        ('B', 2),
        ('C', 3);
DELETE t1, t2
FROM
    t1
INNER JOIN
    t2 ON t2.ref = t1.id
WHERE
    t1.id = 1
;

DELETE
    customers 
FROM
    customers
LEFT JOIN
    orders ON customers.customerNumber = orders.customerNumber 
WHERE
    orderNumber IS NULL
;


# REPLACE;

CREATE TABLE cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    population INT NOT NULL
);
INSERT INTO cities(name,population)
VALUES('New York',8008278),
	  ('Los Angeles',3694825),
	  ('San Diego',1223405);

REPLACE INTO
    cities(id, population)
VALUES
    (2, 3696820)
;
REPLACE INTO cities
SET id = 4,
    name = 'Phoenix',
    population = 1768980
;

REPLACE INTO 
    cities(name, population)
SELECT 
    name, population 
FROM 
   cities 
WHERE id = 1;

UPDATE
    cities
SET
    name = 'Not New York'
WHERE
    id = 5
;


# Prepared Statement;

PREPARE stmt1 FROM 
    'SELECT 
        productCode, 
        productName 
    FROM products
        WHERE productCode = ?'
;
SET @foo = 'S10_1678';
EXECUTE stmt1 USING @foo;
DEALLOCATE PREPARE stmt1;




## Section 10. MySQL transaction; Na razie wygląda na mniej ważne
# Tranasction;

SELECT
    MAX(orderNumber) + 1
FROM
    orders
;

-- 1. start a new transaction
START TRANSACTION;

-- 2. Get the latest order number
SELECT 
    @orderNumber := MAX(orderNumber) + 1
FROM
    orders;

-- 3. insert a new order for customer 145
INSERT INTO orders(
    orderNumber,
    orderDate,
    requiredDate,
    shippedDate,
    status,
    customerNumber)
VALUES(
    @orderNumber,
    '2005-05-31',
    '2005-06-10',
    '2005-06-11',
    'In Process',
    145);
        
-- 4. Insert order line items
# Cannot add or update a child row: a foreign key constraint fails
INSERT INTO orderdetails(
    orderNumber,
    productCode,
    quantityOrdered,
    priceEach,
    orderLineNumber)
VALUES  (@orderNumber,'S18_1749', 30, '136', 1),
        (@orderNumber,'S18_2248', 50, '55.09', 2); 
      
-- 5. commit changes    
COMMIT;


# Table Locking;

CREATE TABLE messages ( 
    id INT NOT NULL AUTO_INCREMENT, 
    message VARCHAR(100) NOT NULL, 
    PRIMARY KEY (id) 
);
SELECT CONNECTION_ID();
INSERT INTO messages(message)
VALUES ('Hello')
;
LOCK TABLE messages READ;
INSERT INTO messages(message)
VALUES ('Hi')
;
INSERT INTO messages(message) 
VALUES('Bye');
SHOW PROCESSLIST;
LOCK TABLE messages WRITE;
INSERT INTO messages(message) 
VALUES('Good Moring');
UNLOCK TABLES;




## Section 11. Managing databases; ## ten tutor powinien być na początku
# Selecting a MySQL database;

SELECT database();
# coś to nie działa w VSC MySQL, najpierw trzeba kliknąć bazę;
USE classicmodels;
SHOW DATABASES;

mysql -u root -D classicmodels -p


# CREATE DATABASE;
CREATE DATABASE testdb;
DROP DATABASE [IF EXISTS] database_name;




## Section 12. Working with tables;
# MySQL storage engines;

# CREATE TABLE;
CREATE TABLE [IF NOT EXISTS] table_name(
   column_1_definition,
   column_2_definition,
   ...,
   table_constraints
) ENGINE=storage_engine;
column_name data_type(length) [NOT NULL] [DEFAULT value] [AUTO_INCREMENT] column_constraint;

CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    status TINYINT NOT NULL,
    priority TINYINT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)  ENGINE=INNODB;

# This picture shows the database diagram of the tasks table
DESCRIBE tasks;

CREATE TABLE IF NOT EXISTS checklists (
    todo_id INT AUTO_INCREMENT,
    task_id INT,
    todo VARCHAR(255) NOT NULL,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (todo_id , task_id),
    FOREIGN KEY (task_id)
        REFERENCES tasks (task_id)
        ON UPDATE RESTRICT ON DELETE CASCADE
);


# AUTO_INCREMENT;

# ALTER TABLE;

ALTER TABLE table_name
ADD 
    new_column_name column_definition
    [FIRST | AFTER column_name]
;

ALTER TABLE table_name
CHANGE 
   old_column_name 
   new_column_name column_definition;

ALTER TABLE table_name
MODIFY column_name column_definition;

CREATE TABLE vehicles (
    vehicleId INT,
    year INT NOT NULL,
    make VARCHAR(100) NOT NULL,
    PRIMARY KEY(vehicleId)
);
ALTER TABLE vehicles
ADD model VARCHAR(100) NOT NULL;
DESCRIBE vehicles;
ALTER TABLE vehicles
ADD color VARCHAR(50),
ADD note VARCHAR(255);
ALTER TABLE vehicles 
MODIFY note VARCHAR(100) NOT NULL;
DESCRIBE vehicles;
ALTER TABLE vehicles 
MODIFY year SMALLINT NOT NULL,
MODIFY color VARCHAR(20) NULL AFTER make;
DESCRIBE vehicles;
ALTER TABLE vehicles 
CHANGE COLUMN note vehicleCondition VARCHAR(100) NOT NULL;
DESCRIBE vehicles;
ALTER TABLE vehicles
DROP COLUMN vehicleCondition;
DESCRIBE vehicles;
ALTER TABLE vehicles 
RENAME TO cars; 
DESCRIBE cars;


# Renaming tables;

RENAME TABLE old_table_name TO new_table_name;

CREATE DATABASE IF NOT EXISTS hr;
USE hr;
SHOW DATABASES;
SELECT database();

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE employees (
    id int AUTO_INCREMENT primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    department_id int not null,
    FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
);
INSERT INTO departments(dept_name)
VALUES('Sales'),('Markting'),('Finance'),('Accounting'),('Warehouses'),('Production');
INSERT INTO employees(first_name,last_name,department_id) 
VALUES('John','Doe',1),
		('Bush','Lily',2),
		('David','Dave',3),
		('Mary','Jane',4),
		('Jonatha','Josh',5),
		('Mateo','More',1);

CREATE VIEW v_employee_info as
    SELECT 
        id, first_name, last_name, dept_name
    from
        employees
    inner join
        departments USING (department_id);

SELECT 
    *
FROM
    v_employee_info;

RENAME TABLE employees TO people;

CHECK TABLE v_employee_info;

RENAME TABLE people TO employees;

DELIMITER $$
CREATE PROCEDURE get_employee(IN p_id INT)
BEGIN
	SELECT first_name
		,last_name
		,dept_name
	FROM employees
	INNER JOIN departments using (department_id)
	WHERE id = p_id;
END $$
DELIMITER;

CALL get_employee(1);

RENAME TABLE employees TO people;

CALL get_employee(2);

DESCRIBE people;
# na później


# DROP COLUMN;

ALTER TABLE table_name
DROP COLUMN column_name;

CREATE TABLE posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    excerpt VARCHAR(400),
    content TEXT,
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255)
);

ALTER TABLE posts 
ADD COLUMN category_id INT NOT NULL;
DESCRIBE posts;

ALTER TABLE posts
ADD CONSTRAINT fk_cat
FOREIGN KEY (category_id) 
REFERENCES categories(id);

DESCRIBE posts;

ALTER TABLE posts
DROP COLUMN category_id;

ALTER TABLE posts
DROP CONSTRAINT fk_cat;

ALTER TABLE posts
DROP COLUMN category_id;


# Add Columns to a Table;

ALTER TABLE table
ADD [COLUMN] column_name column_definition [FIRST|AFTER existing_column];

SELECT 
    IF(count(*) = 1, 'Exist','Not Exist') AS result
FROM
    information_schema.columns
WHERE
    table_schema = 'classicmodels'
        AND table_name = 'customers'
        AND column_name = 'customerName';


# DROP TABLE;

DROP [TEMPORARY] TABLE [IF EXISTS] table_name [, table_name] ...
[RESTRICT | CASCADE];

CREATE TABLE IF NOT EXISTS test1(
    id INT PRIMARY KEY AUTO_INCREMENT
);
CREATE TABLE IF NOT EXISTS test2 LIKE test1;
CREATE TABLE IF NOT EXISTS test3 LIKE test1;
SET @schema = 'hr';
SET @pattern = 'test%';
-- construct dynamic sql (DROP TABLE tbl1, tbl2...;)
SELECT CONCAT('DROP TABLE ',GROUP_CONCAT(CONCAT(@schema,'.',table_name)),';')
INTO @droplike
FROM information_schema.tables
WHERE @schema = database()
AND table_name LIKE @pattern;

-- display the dynamic sql statement
SELECT @droplike;

-- execute dynamic sql
PREPARE stmt FROM @droplike;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


# Temporary Table;

CREATE TEMPORARY TABLE temp_dep LIKE departments;

INSERT INTO temp_dep()
SELECT
    *
FROM
    departments
;

SELECT
    *
FROM
    temp_dep
;

DELIMITER //
CREATE PROCEDURE check_table_exists(table_name VARCHAR(100)) 
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @err = 1;
    SET @err = 0;
    SET @table_name = table_name;
    SET @sql_query = CONCAT('SELECT 1 FROM ',@table_name);
    PREPARE stmt1 FROM @sql_query;
    IF (@err = 1) THEN
        SET @table_exists = 0;
    ELSE
        SET @table_exists = 1;
        DEALLOCATE PREPARE stmt1;
    END IF;
END //
DELIMITER ;

CALL check_table_exists('temp_dep');
SELECT @table_exists;


# TRUNCATE TABLE;

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL
)  ENGINE=INNODB;

DELIMITER $$
CREATE PROCEDURE load_book_data(IN num INT(4))
BEGIN
	DECLARE counter INT(4) DEFAULT 0;
	DECLARE book_title VARCHAR(255) DEFAULT '';

	WHILE counter < num DO
	  SET book_title = CONCAT('Book title #',counter);
	  SET counter = counter + 1;

	  INSERT INTO books(title)
	  VALUES(book_title);
	END WHILE;
END$$
DELIMITER ;

CALL load_book_data(10000);
SELECT * FROM books;
TRUNCATE TABLE books;


# Generated Columns;

DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    fullname varchar(101) GENERATED ALWAYS AS (CONCAT(first_name,' ',last_name)),
    email VARCHAR(100) NOT NULL
);
INSERT INTO contacts(first_name,last_name, email)
VALUES('john','doe','john.doe@mysqltutorial.org');
SELECT * FROM contacts;

ALTER TABLE products
ADD COLUMN stockValue DOUBLE 
GENERATED ALWAYS AS (buyprice*quantityinstock) STORED;


## Section 13. MySQL data types;
# Data Types;

The following table shows the summary of numeric types in MySQL:
Numeric Types	Description
 TINYINT	A very small integer
 SMALLINT	A small integer
 MEDIUMINT	A medium-sized integer
 INT	A standard integer
 BIGINT	A large integer
 DECIMAL	A fixed-point number
 FLOAT	A single-precision floating point number
 DOUBLE	A double-precision floating point number
 BIT	A bit field

String Types	Description
 CHAR	A fixed-length nonbinary (character) string
 VARCHAR	A variable-length non-binary string
 BINARY	A fixed-length binary string
 VARBINARY	A variable-length binary string
 TINYBLOB	A very small BLOB (binary large object)
 BLOB	A small BLOB
 MEDIUMBLOB	A medium-sized BLOB
 LONGBLOB	A large BLOB
 TINYTEXT	A very small non-binary string
 TEXT	A small non-binary string
 MEDIUMTEXT	A medium-sized non-binary string
 LONGTEXT	A large non-binary string
 ENUM	An enumeration; each column value may be assigned one enumeration member
 SET	A set; each column value may be assigned zero or more SET members

Date and Time Types	Description
 DATE	A date value in CCYY-MM-DD format
 TIME	A time value in hh:mm:ss format
 DATETIME	A date and time value inCCYY-MM-DD hh:mm:ssformat
 TIMESTAMP	A timestamp value in CCYY-MM-DD hh:mm:ss format
 YEAR	A year value in CCYY or YY format
 
Spatial Data Types	Description
 GEOMETRY	A spatial value of any type
 POINT	A point (a pair of X-Y coordinates)
 LINESTRING	A curve (one or more POINT values)
 POLYGON	A polygon
 GEOMETRYCOLLECTION	A collection of GEOMETRYvalues
 MULTILINESTRING	A collection of LINESTRINGvalues
 MULTIPOINT	A collection of POINTvalues
 MULTIPOLYGON	A collection of POLYGONvalues


# DECIMAL;
amount DECIMAL(6,2);
Code language: SQL (Structured Query Language) (sql)
In this example, the amount column can store 6 digits with 2 decimal places, 
therefore, the range of the amount column is from 9999.99 to -9999.99.;

CREATE TABLE materials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255),
    cost DECIMAL(19 , 2) NOT NULL
);
DESCRIBE materials;
ALTER TABLE materials
MODIFY cost decimal(19, 4)
;


# BOOLEAN;

CREATE TABLE tasks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    completed BOOLEAN
);
DESCRIBE tasks;
INSERT INTO tasks(title,completed)
VALUES  ('Master MySQL Boolean type',true),
        ('Design database table',false); 
INSERT INTO tasks(title,completed)
VALUES('Test Boolean with a number',2);
SELECT 
    id, 
    title, 
    IF(completed, 'true', 'false') completed
FROM
    tasks;
SELECT 
    id, title, completed
FROM
    tasks
WHERE
    completed = TRUE;
SELECT 
    id, title, completed
FROM
    tasks
WHERE
    completed IS TRUE;

# VARCHAR;

In terms of efficiency, if you are storing strings with a wildly variable 
length then use a VARCHAR, if the length is always the same, then use a CHAR 
as it is slightly faster.


# TEXT;

Note that the TEXT data is not stored in the database server’s memory, 
therefore, whenever you query TEXT data, MySQL has to read from it from the disk, which is much slower in comparison with CHAR and VARCHAR.

# DATE;

SELECT NOW();
SELECT DATE(NOW());
SELECT YEAR(NOW());
SELECT CURRENT_DATE;
SELECT CURDATE();

SELECT DATE_FORMAT(CURDATE(), '%m/%d/%Y') AS today;
SELECT DATEDIFF('2015-11-04','2014-11-04') days;
SELECT 
    '2015-01-01' start,
    DATE_ADD('2015-01-01', INTERVAL 1 DAY) 'one day later',
    DATE_ADD('2015-01-01', INTERVAL 1 WEEK) 'one week later',
    DATE_ADD('2015-01-01', INTERVAL 1 MONTH) 'one month later',
    DATE_ADD('2015-01-01', INTERVAL 1 YEAR) 'one year later';
SELECT DAY('2000-12-31') day, 
       MONTH('2000-12-31') month, 
       QUARTER('2000-12-31') quarter, 
       YEAR('2000-12-31') year,
       WEEKDAY('2000-12-31') weekday;


# TIME;

SELECT 
    CURRENT_TIME() AS string_now,
    CURRENT_TIME() + 0 AS numeric_now;
SELECT 
    CURRENT_TIME(),
    ADDTIME(CURRENT_TIME(), 023000),	
    SUBTIME(CURRENT_TIME(), 023000);
SELECT 
   CURRENT_TIME(), 
   UTC_TIME();


# JSON;

CREATE TABLE events( 
  id int auto_increment primary key, 
  event_name varchar(255), 
  visitor varchar(255), 
  properties json, 
  browser json
);
DESCRIBE events;

INSERT INTO events(event_name, visitor,properties, browser) 
VALUES
(
  'pageview', 
  '1',
  '{ "page": "/" }',
  '{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'
),
(
  'pageview', 
  '2',
  '{ "page": "/contact" }',
  '{ "name": "Firefox", "os": "Windows", "resolution": { "x": 2560, "y": 1600 } }'
),
(
  'pageview', 
  '1',
  '{ "page": "/products" }',
  '{ "name": "Safari", "os": "Mac", "resolution": { "x": 1920, "y": 1080 } }'
),
(
  'purchase', 
  '3',
  '{ "amount": 200 }',
  '{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1600, "y": 900 } }'
),
(
  'purchase', 
  '4',
  '{ "amount": 150 }',
  '{ "name": "Firefox", "os": "Windows", "resolution": { "x": 1280, "y": 800 } }'
),
(
  'purchase', 
  '4',
  '{ "amount": 500 }',
  '{ "name": "Chrome", "os": "Windows", "resolution": { "x": 1680, "y": 1050 } }'
);

SELECT * FROM events;


SELECT 
    id, browser -> '$.name' AS browser, browser ->> '$.os' AS os
FROM
    events
;

SELECT 
    browser->>'$.name' AS browser, count(browser) AS counter
FROM 
    events
GROUP BY 
    browser->>'$.name'
;
SELECT 
    browser->'$.name' AS browser, count(browser) AS counter
FROM 
    events
GROUP BY 
    browser->'$.name'
;

SELECT 
    visitor, COUNT(*) AS count, SUM(properties ->> '$.amount') AS revenue
FROM
    events
WHERE
    properties ->> '$.amount' > 0
GROUP BY
    visitor
;

 
# ENUM;

CREATE TABLE tickets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    priority ENUM('Low', 'Medium', 'High') NOT NULL
);
INSERT INTO tickets(title, priority)
VALUES  ('Scan virus for computer A', 'High'),
        ('Upgrade Windows OS for all computers', 1),
        ('Install Google Chrome for Mr. John', 'Medium'),
        ('Create a new user for the new employee David', 'High')
INSERT INTO tickets(title)
VALUES('Refresh the computer of Ms. Lily');
;
SELECT 
    *
FROM
    tickets
WHERE
    priority = 'High';
SELECT 
    *
FROM
    tickets
WHERE
    priority = 3;
SELECT 
    title, priority
FROM
    tickets
ORDER BY priority DESC;




## Section 14. MySQL constraints;
# NOT NULL;

Generally, the NULL value makes your queries more complicated because you 
have to use functions such as ISNULL(), IFNULL(), and NULLIF() for handling NULL.;

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

INSERT INTO tasks(title ,start_date, end_date)
VALUES('Learn MySQL NOT NULL constraint', '2017-02-01','2017-02-02'),
      ('Check and update NOT NULL constraint to your database', '2017-02-01',NULL);

UPDATE
    tasks
SET
    end_date = start_date + 7
WHERE
    end_date IS NULL
;

DESCRIBE tasks;
ALTER TABLE
    tasks
CHANGE
    end_date end_date DATE NOT NULL
;
DESCRIBE tasks;

ALTER TABLE tasks 
MODIFY 
    end_date DATE NOT NULL;


# Primary Key;

ALTER TABLE table_name
ADD PRIMARY KEY(column_list);

ALTER TABLE users
ADD UNIQUE INDEX username_unique (username ASC) ;


# Foreign key;

DESCRIBE classicmodels.employees;

DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;

CREATE TABLE categories(
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
)ENGINE=INNODB;
CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
        REFERENCES categories(categoryId)
        ON UPDATE CASCADE
        ON DELETE CASCADE 
)ENGINE=INNODB;
SHOW CREATE TABLE products;
CREATE TABLE `products` (
  `productId` int NOT NULL AUTO_INCREMENT,
  `productName` varchar(100) NOT NULL,
  `categoryId` int DEFAULT NULL,
  PRIMARY KEY (`productId`),
  KEY `fk_category` (`categoryId`),
  CONSTRAINT `fk_category` FOREIGN KEY (`categoryId`) 
    REFERENCES `categories` (`categoryId`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci
;

INSERT INTO categories(categoryName)
VALUES
    ('Smartphone'),
    ('Smartwatch');

INSERT INTO products(productName, categoryId)
VALUES
    ('iPhone', 1), 
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galary Watch',2);

UPDATE categories
SET categoryId = 100
WHERE categoryId = 1
;

DELETE FROM categories
WHERE categoryId = 2
;

ALTER TABLE products
DROP FOREIGN KEY fk_category;

SHOW CREATE TABLE products;
CREATE TABLE `products` (
  `productId` int NOT NULL AUTO_INCREMENT,
  `productName` varchar(100) NOT NULL,
  `categoryId` int DEFAULT NULL,
  PRIMARY KEY (`productId`),
  KEY `fk_category` (`categoryId`)
) ENGINE = InnoDB AUTO_INCREMENT = 5 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci
;

SHOW INDEX FROM hr.products;


# Disable Foreign Key Checks;

To disable foreign key checks, you use the following statement:

SET foreign_key_checks = 0;
Code language: SQL (Structured Query Language) (sql)
And you can enable it by using the following statement:

SET foreign_key_checks = 1;

CREATE TABLE countries(
    country_id INT AUTO_INCREMENT,
    country_name VARCHAR(255) NOT NULL,
    PRIMARY KEY(country_id)
) ENGINE=InnoDB;
CREATE TABLE cities(
    city_id INT AUTO_INCREMENT,
    city_name VARCHAR(255) NOT NULL,
    country_id INT NOT NULL,
    PRIMARY KEY(city_id),
    FOREIGN KEY(country_id) 
		REFERENCES countries(country_id)
)ENGINE=InnoDB;

INSERT INTO cities(city_name, country_id)
VALUES('New York',1);
SET foreign_key_checks = 0;
INSERT INTO cities(city_name, country_id)
VALUES('New York',1);
SET foreign_key_checks = 1;
INSERT INTO countries(country_id, country_name)
VALUES(1,'USA');

DROP TABLE countries;
SET foreign_key_checks = 0;
DROP TABLE countries;
DROP TABLE cities;
SET foreign_key_checks = 1;

SHOW INDEX FROM cities;
SHOW INDEX FROM classicmodels.employees;


# UNIQUE;
DROP INDEX index_name ON table_name;
ALTER TABLE table_name
DROP INDEX index_name;


# CHECK;

CREATE TABLE parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10,2 ) NOT NULL CHECK (cost >= 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);
DROP TABLE IF EXISTS parts;
CREATE TABLE parts (
    part_no VARCHAR(18) PRIMARY KEY,
    description VARCHAR(40),
    cost DECIMAL(10,2 ) NOT NULL CHECK (cost >= 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    CONSTRAINT parts_chk_price_gt_cost 
        CHECK(price >= cost)
);


# DEFAULT;

CREATE TABLE cart_items 
(
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price DEC(5,2) NOT NULL,
    sales_tax DEC(5,2) NOT NULL DEFAULT 0.1,
    CHECK(quantity > 0),
    CHECK(sales_tax >= 0) 
);

ALTER TABLE table_name
ALTER column_name DROP DEFAULT;




## Section 15. MySQL globalization;
# Character Set;

SHOW CHARACTER SET;

SET @str = CONVERT('MySQL Character Set' USING ucs2);
SELECT LENGTH(@str), CHAR_LENGTH(@str);


# Collation;

SHOW collation LIKE 'latin1%';




## Section 16. MySQL import & export CSV;
# Import CSV File Into MySQL Table;

DROP TABLE IF EXISTS data;
CREATE TABLE data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    Programming_language VARCHAR(255),
    Designed_by VARCHAR(255),
    Appeared INT,
    Exetension VARCHAR(255)
);

/*
LOAD DATA INFILE '/var/lib/mysql-files/data2.csv'
INTO TABLE hr.data
fields terminated by ','
# enclosed by '"'
lines terminated by '\n'
IGNORE 1 ROWS
;
*/

SHOW VARIABLES LIKE "secure_file_priv";


# Export Table to CSV;

(SELECT 'id', 'title', 'prioroty')
UNION
(SELECT 
    *
FROM
    tickets)
INTO OUTFILE '/var/lib/mysql-files/data3.csv'
FIELDS ENCLOSED BY '"' 
TERMINATED BY ';' 
ESCAPED BY '"' 
LINES TERMINATED BY '\r\n';

SHOW COLUMNS 
FROM tickets;

SELECT 
    orderNumber, orderDate, IFNULL(shippedDate, 'N/A')
FROM
    orders INTO OUTFILE '/var/lib/mysql-files/orders2.csv' 
    FIELDS ENCLOSED BY '"' 
    TERMINATED BY ';' 
    ESCAPED BY '"' LINES
    TERMINATED BY '\r\n'
;




# Section 17. Advanced techniques
## Natural Sorting;

CREATE TABLE items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_no VARCHAR(255) NOT NULL
);
TRUNCATE TABLE items;

INSERT INTO items(item_no)
VALUES('A-1'),
      ('A-2'),
      ('A-3'),
      ('A-4'),
      ('A-5'),
      ('A-10'),
      ('A-11'),
      ('A-20'),
      ('A-30');

SELECT 
    item_no
FROM
    items
ORDER BY LENGTH(item_no), item_no;




## Stored Procedures
## Section 1. Stored procedure basics;
# Basics;


DELIMITER$$
CREATE PROCEDURE GetCustomers()
    SELECT
        *
    FROM
        classicmodels.customers
END; $$
DELIMITER;

CALL GetCustomers();


# DROP PROCEDURE;
DROP PROCEDURE IF EXISTS GetCustomers;

SHOW warnings;


# Variables;

# DECLARE @total INT;
SET @total = 10;
SELECT @total;

SELECT COUNT(*)
INTO @custCount
FROM customers
;
SELECT @custCount;

DELIMITER $$
CREATE PROCEDURE GetTotalOrder()
BEGIN
    DECLARE totalOrder INT DEFAULT 0;
    
    SELECT COUNT(*)
    INTO totalOrder
    FROM orders;
    
    SELECT totalOrder;
END$$
DELIMITER ;

# działało, ale już nie działa - podejrzane, pod Workbenchem działa
CALL GetTotalOrder();


# Parameters;

DELIMITER $$
CREATE PROCEDURE GetOffice(
    IN countryName VARCHAR(50)
)
BEGIN
    SELECT
        *
    FROM
        offices
    WHERE
        country = countryName;
END $$
DELIMITER ;

# nie działa, a powinno, pod Workbenchem działa
CALL GetOffice('UK');

DELIMITER $$
CREATE PROCEDURE GetOrder(
    IN statusName VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT
        count(*)
    INTO
        total
    FROM
        orders
    WHERE
        status = statusName;
END $$
DELIMITER ;

CALL GetOrder('Shipped', @total);
SELECT @total AS total_shipped;

DELIMITER $$
CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN adder INT
)
BEGIN
    SET counter = counter + adder;
END $$
DELIMITER ;

SET @counter = 1;
CALL SetCounter(@counter, 9);
SELECT @counter;


# Alter Stored Procedures;

DELIMITER $$
CREATE PROCEDURE GetOrderAmount()
BEGIN
    SELECT 
        SUM(quantityOrdered * priceEach) 
    FROM orderdetails;
END$$
DELIMITER ;

CALL GetOrderAmount();

DELIMITER $$
CREATE PROCEDURE GetOrderAmount2(
    OUT total INT
)
BEGIN
    SELECT 
        SUM(quantityOrdered * priceEach)
    INTO
        total
    FROM orderdetails;
END$$
DELIMITER ;

SELECT @total;
CALL GetOrderAmount2(@total);


# Listing Stored Procedures;

SHOW PROCEDURE STATUS WHERE db = 'classicmodels';
SHOW PROCEDURE STATUS LIKE '%order%';

SELECT 
    routine_name
FROM
    information_schema.routines
WHERE
    routine_type = 'PROCEDURE'
        AND routine_schema = 'classicmodels';




## Section 2. Conditional Statements;
# IF;




































# SELECT NULL blank coulmn



USE classicmodels;
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