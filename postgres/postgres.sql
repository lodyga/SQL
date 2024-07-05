sudo -u postgres psql; login
ALTER USER postgres PASSWORD 'password'; change default passoword for extensions to work

\l ; SHOW DATABASES;
\c <DATABASE_NAME> ; USE <DATABASE_NAME>;
\dt ; SHOW TABLES;
\d <table_name>; SHOW COLUMNS FROM <table>;