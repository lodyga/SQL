login to PostgreSQL shell
export PGPASSWORD='password' && psql -U postgres -h 127.0.0.1 -p 5432 -d postgres
PROTOCOL://USER:PASSWORD@HOST:PORT/DBNAME
connection URI
psql "postgresql://postgres:password@localhost:5432/postgres"
psql "postgresql://uciucfvga7q5sokdvyk2:password@bkkkdsogwmivlnenigc9-postgresql.services.clever-cloud.com:50013/bkkkdsogwmivlnenigc9"


sudo -u postgres psql; login
ALTER USER postgres PASSWORD 'password'; change default passoword for extensions to work

\l ; SHOW DATABASES;
\c <DATABASE_NAME> ; USE <DATABASE_NAME>;
\dt ; SHOW TABLES;
\d <table_name>; SHOW COLUMNS FROM <table>;

SELECT * FROM python_problems_language;

dump db
pg_dump -U postgres -h localhost -p 5432 codesite_db > temp.sql
load db
psql -h hostname -d databasename -U username -f file.sql

