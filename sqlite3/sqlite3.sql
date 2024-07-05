> sqlite3 <file_name>.sqlite3  # creates a sqlite3 file

s> .open <file_name>.sqlite3  # open database
s> .tables  # show tables
s> .quit  # exit sqlite3
s> .schema Users
s> .mode column  # chages display
s> PRAGMA table_info(<table_name>)  # colnames

CREATE TABLE Users(
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(128),
    email VARCHAR(128)
);

INSERT INTO Users (name, email) VALUES ("Kristin", "kf@umich.edu");
INSERT INTO Users (name, email) VALUES ('Chuck', 'csev@umich.edu');
INSERT INTO Users (name, email) VALUES ('Colleen', 'cvl@umich.edu');
INSERT INTO Users (name, email) VALUES ('Ted', 'ted@umich.edu');
INSERT INTO Users (name, email) VALUES ('Sally', 'a1@umich.edu');

https://www.dj4e.com/lectures/SQL-01-Basics.txt

DELETE FROM Users WHERE email='ted@umich.edu';
DELETE FROM Users;  # delete every item o table

UPDATE Users SET name="Charles" WHERE email="csev@umich.edu";

SELECT * FROM Users ORDER BY name DESC;

DROP TABLE Users; 



-- removing colums 
DROP INDEX python_problems_problem_space_complexity_id_3bd54baf;
ALTER TABLE python_problems_problem DROP COLUMN space_complexity_id;



