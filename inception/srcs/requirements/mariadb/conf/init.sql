-- Set a password for root user
ALTER user 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';

-- Create the database `db`
CREATE DATABASE IF NOT EXISTS `${DB_NAME}`;

-- Create new user
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';

-- Give the newly created user privileges over all the tables in the new database
GRANT ALL PRIVILEGES ON `${DB_NAME}`.* TO '${DB_USER}'@'%';

FLUSH PRIVILEGES;