SELECT * FROM mysql.USER;

DROP USER 'ustest'@'localhost';

CREATE USER 'ustest'@'localhost' IDENTIFIED BY '123456%';



CREATE ROLE 'roltest'@'host';

SELECT * FROM mysql.USER;
/*
Crear un rol va a tener el mismo formado que un usuario, necesita de un contexto,
pero realmente nunca nos vamos a conectar con un rol, por lo tanto, el contexto
sólo nos sirve para completar el formato con el que se crean los usuarios.

El rol no nos sirve para autenticarnos, solo para autorizaciones, es decir, no cuenta 
con ningún privilegio, por ejemplo, no posee un valor en el campo 'authentication_string'.
*/

CREATE ROLE writeapp, readapp, developerapp;

SELECT * FROM mysql.USER;

SHOW GRANTS FOR writeapp;
-- GRANT USAGE ON *.* TO `writeapp`@`%`

-- Así como podemos ver los privilegios de un usuario
-- también podemos ver los privilegios de un rol



GRANT INSERT, UPDATE, DELETE ON colegio2857.* TO 'writeapp';

SHOW GRANTS FOR writeapp;
-- GRANT USAGE ON *.* TO `writeapp`@`%`
-- GRANT INSERT, UPDATE, DELETE ON `colegio2857`.* TO `writeapp`@`%`

GRANT SELECT ON colegio2857.* TO 'readapp';

SHOW GRANTS FOR readapp;
-- GRANT USAGE ON *.* TO `readapp`@`%`
-- GRANT SELECT ON `colegio2857`.* TO `readapp`@`%`

GRANT ALL ON colegio2857.* TO 'developerapp';

SHOW GRANTS FOR developerapp;
-- GRANT USAGE ON *.* TO `developerapp`@`%`
-- GRANT ALL PRIVILEGES ON `colegio2857`.* TO `developerapp`@`%`



SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`

GRANT writeapp, readapp TO 'ustest'@'localhost';

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT `readapp`@`%`,`writeapp`@`%` TO `ustest`@`localhost`

-- Otorgamos privilegios a través de los roles



SHOW GRANTS FOR 'ustest'@'localhost' USING writeapp;
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT INSERT, UPDATE, DELETE ON `colegio2857`.* TO `ustest`@`localhost`
-- GRANT `readapp`@`%`,`writeapp`@`%` TO `ustest`@`localhost`

SHOW GRANTS FOR 'ustest'@'localhost' USING readapp;
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT SELECT ON `colegio2857`.* TO `ustest`@`localhost`
-- GRANT `readapp`@`%`,`writeapp`@`%` TO `ustest`@`localhost`

SHOW GRANTS FOR 'ustest'@'localhost' USING writeapp, readapp;
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT SELECT, INSERT, UPDATE, DELETE ON `colegio2857`.* TO `ustest`@`localhost`
-- GRANT `readapp`@`%`,`writeapp`@`%` TO `ustest`@`localhost`

-- Utilizamos 'using' para conocer los privilegios de un usuario con determinados roles 



-- [1.2]

REVOKE writeapp, readapp FROM 'ustest'@'localhost';
-- Para hacer efectivo este cambio hay que cerrar la sesión de 'ustest'@'localhost'



-- [2.2]

DROP ROLE writeapp, readapp, developerapp;

SELECT * FROM mysql.USER;

/*
Podemos diferenciar diferentes "estados" de un role:

* Creados   (create)
* Asignados (grant)
* Cargados  (set)
*/

SHOW VARIABLES LIKE '%rol%';
/* 
Cambiar estas variables sólo sería a nivel sesión:

'activate_all_roles_on_login'
Activa los roles asignados al iniciar sesión

'mandatory_roles'
Roles mandatorios, más privilegiados, que siempre van a cargarse

Si queremos ver los cambios reflejados de forma permanente, 
hay que cambiar el archivo 'my.ini' y reiniciamos el servidor.
*/

DROP USER 'ustest'@'localhost';

DROP USER 'roltest'@'host';

SELECT * FROM mysql.USER;