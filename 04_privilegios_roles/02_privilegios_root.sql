SELECT 
    *
FROM
    mysql.USER;

DROP USER 'ustest'@'localhost';

CREATE USER 'ustest'@'localhost' 
IDENTIFIED BY '123456%';

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`

-- Tenemos privilegio de uso (USAGE) sobre todas las B.D. (*) y todos los objetos del servidor (*)



/*
Creamos una nueva conexión a través de Workbench:

* Setup new connection
* Connection name: local ustest
* Username: ustest
* Test connection
*/



-- [1.2]

REVOKE USAGE 
ON *.* 
FROM 'ustest'@'localhost';

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`

-- Para reflejar el privilegio revocado, hay que hacer un par de cosas más
-- Pero por el momento se sigue mostrando el privilegio USAGE a pesar de que lo hemos revocado

GRANT ALL 
ON *.* 
TO 'ustest'@'localhost';
-- ALL refiere a todos los privilegios de B.D. y objetos, pero no administrativos
-- USAGE no está dentro de todos los privilegios que acabamos de asignar

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `ustest`@`localhost`
-- GRANT APPLICATION_PASSWORD_ADMIN,AUDIT_ABORT_EXEMPT,AUDIT_ADMIN,AUTHENTICATION_POLICY_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,ENCRYPTION_KEY_ADMIN,FIREWALL_EXEMPT,FLUSH_OPTIMIZER_COSTS,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,GROUP_REPLICATION_STREAM,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,PASSWORDLESS_USER_ADMIN,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SENSITIVE_VARIABLES_OBSERVER,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_USER_ID,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,XA_RECOVER_ADMIN ON *.* TO `ustest`@`localhost`



-- [2.2]

REVOKE ALL 
ON *.* 
FROM 'ustest'@'localhost';

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`

GRANT ALL 
ON colegio2857.* 
TO 'ustest'@'localhost';
-- Ahora ya no concedemos los privilegios para todas las B.D. 
-- sólo para 'colegio2857' y sobre todos sus objetos

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT ALL PRIVILEGES ON `colegio2857`.* TO `ustest`@`localhost`



-- [3.2]

REVOKE INSERT, UPDATE, DELETE 
ON colegio2857.* 
FROM 'ustest'@'localhost';

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT SELECT, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER ON `colegio2857`.* TO `ustest`@`localhost`

-- Ya no posee INSERT, UPDATE y DELETE (los primeros tres privilegios)



-- [4.2]

GRANT INSERT, UPDATE, DELETE 
ON colegio2857.niveles 
TO 'ustest'@'localhost';

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT SELECT, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER ON `colegio2857`.* TO `ustest`@`localhost`
-- GRANT INSERT, UPDATE, DELETE ON `colegio2857`.`niveles` TO `ustest`@`localhost`

-- INSERT, UPDATE y DELETE sólo son permitidos sobre la tabla 'niveles' de 'colegio2857'
-- La tabla 'niveles' tiene los privilegios SELECT, CREATE, DROP, etc. por ser de nivel superior



-- [5.2]

GRANT SELECT 
ON bdconcurrencia.* 
TO 'ustest'@'localhost';

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT SELECT ON `bdconcurrencia`.* TO `ustest`@`localhost`
-- GRANT SELECT, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER ON `colegio2857`.* TO `ustest`@`localhost`
-- GRANT INSERT, UPDATE, DELETE ON `colegio2857`.`niveles` TO `ustest`@`localhost`



-- [6.2]

/*
Creamos un respaldo a través de Workbench:

* Navigator
* Administration
* Data export

* schema: colegio2857
* Dump structure and data
* Export to self-contained file: C:\...\Dump_[año][mes][dia]_colegio2857.sql

Abrimos el respaldo creado y agregamos las sentencias:

CREATE DATABASE IF NOT EXISTS escuela2857;
USE escuela2857;
*/

USE escuela2857;

SHOW TABLES;

GRANT SELECT 
ON escuela2857.alumnos 
TO 'ustest'@'localhost';

GRANT SELECT 
ON escuela2857.pagos 
TO 'ustest'@'localhost';

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT SELECT ON `bdconcurrencia`.* TO `ustest`@`localhost`
-- GRANT SELECT, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER ON `colegio2857`.* TO `ustest`@`localhost`
-- GRANT INSERT, UPDATE, DELETE ON `colegio2857`.`niveles` TO `ustest`@`localhost`
-- GRANT SELECT ON `escuela2857`.`alumnos` TO `ustest`@`localhost`
-- GRANT SELECT ON `escuela2857`.`pagos` TO `ustest`@`localhost`



-- [7.2]

DROP USER 'ustest'@'localhost';

SELECT 
    *
FROM
    mysql.USER;