/*
Podemos agregar privilegios a una tabla de dos formas:

1. Nivel de columna

* No podemos cambiar el nombre de los campos
* La sentencia SELECT * FROM [tabla] no se puede utilizar

2. Nivel de vista

* Filtra datos
* Esconde campos
* Esconde la complejidad de los JOINS
* Cuida la independencia lógica

Una vista es una estructura que se crea a través del resultado de una consulta.
Las vistas se almacenan en la misma tabla que el resto de tablas; por lo tanto,
no pueden ocupar el nombre de una tabla existente. Una vista no contiene datos, 
ya que pertenecen a las tablas de la instrucción SELECT.
*/



SELECT 
    *
FROM
    mysql.USER;

DROP USER 'ustest'@'localhost';

CREATE USER 'ustest'@'localhost' 
IDENTIFIED BY '123456%';



-- Privilegios a nivel de columna

SELECT 
    *
FROM
    alumnos;

GRANT 
	SELECT (clave_alu, ap_paterno, ap_materno, nombre, curp),
	SHOW VIEW 
ON colegio2857.alumnos 
TO 'ustest'@'localhost';
/*
Estamos otorgando los privilegios SELECT y SHOW VIEW.
SHOW VIEW no es absolutamente necesario, pero se puede llegar a ocupar.

Podemos acceder a la tabla 'alumnos' pero no a todas sus columnas.
*/

SELECT 
    *
FROM
    pagos;

GRANT 
	SELECT (clave_alu, pago, fecha_pago, id),
	UPDATE (fecha_pago),
	SHOW VIEW 
ON colegio2857.pagos 
TO 'ustest'@'localhost';
-- Estamos otorgando los privilegios SELECT, UPDATE y SHOW VIEW



/*
Podemos otorgar el privilegio INSERT, pero sólo sobre campos NOT NULL.

Si otorgamos el privilegio DELETE, no será sobre determinados campos,
sino sobre todo el registro, ya que el privilegio no discrimina campos.
*/



SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`
-- GRANT SELECT (`ap_materno`, `ap_paterno`, `clave_alu`, `curp`, `nombre`), SHOW VIEW ON `colegio2857`.`alumnos` TO `ustest`@`localhost`
-- GRANT SELECT (`clave_alu`, `fecha_pago`, `id`, `pago`), UPDATE (`fecha_pago`), SHOW VIEW ON `colegio2857`.`pagos` TO `ustest`@`localhost`



-- [1.2]

REVOKE
	SELECT (clave_alu, ap_paterno, ap_materno, nombre, curp), 
	SHOW VIEW 
ON colegio2857.alumnos 
FROM 'ustest'@'localhost';

REVOKE
	SELECT (clave_alu, pago, fecha_pago, id),
	UPDATE(fecha_pago),
	SHOW VIEW 
ON colegio2857.pagos 
FROM 'ustest'@'localhost';

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`



-- Privilegios a nivel de vista

 USE colegio2857;
 
CREATE OR REPLACE VIEW alumnas AS
    SELECT 
        clave_alu AS matricula,
        CONCAT_WS(' ', nombre, ap_paterno, ap_materno) AS alumno,
        curp,
        ciudad
    FROM
        alumnos
    WHERE
        sexo = 'F';
-- Podemos cambiar el nombre de los campos

SELECT 
    *
FROM
    alumnas;
-- La sentencia SELECT * FROM [tabla] se puede utilizar

SHOW TABLES;
-- Aparece la tabla 'alumnas'



SELECT 
    *
FROM
    information_schema.TABLES;

SELECT 
    *
FROM
    information_schema.TABLES
WHERE
    table_schema = 'colegio2857';

SELECT 
    *
FROM
    information_schema.TABLES
WHERE
    table_schema = 'colegio2857'
        AND table_type = 'VIEW';
/*
MySQL guarda las tablas en la tabla 'tables' en la B.D. 'information_schema'.
La tabla 'alumnas' tiene valor VIEW en el campo 'table_type' y tiene valor 
NULL en el campo 'table_rows'.
*/



SELECT 
    *
FROM
    alumnas;

SELECT 
    *
FROM
    alumnas
WHERE
    curp <> '';
-- Podemos utilizar '!='
-- y también '<>'

DESC alumnas;
-- No hay valor para el campo 'key'



CREATE OR REPLACE VIEW inscritos AS
    SELECT 
        *
    FROM
        alumnos;
-- Funciona como alias, es decir, no estamos filtrando nada

SELECT 
    *
FROM
    alumnos;

SELECT 
    *
FROM
    inscritos;

SELECT 
    *
FROM
    information_schema.TABLES
WHERE
    table_schema = 'colegio2857'
        AND table_type = 'VIEW';
 
 

SELECT 
    *
FROM
    alumnos;

SELECT 
    *
FROM
    pagos;

CREATE OR REPLACE VIEW alumnos_pagos AS
    SELECT 
        a.clave_alu,
        CONCAT_WS(' ',
                a.nombre,
                a.ap_paterno,
                a.ap_materno) AS alumno,
        IFNULL(SUM(p.pago), 0) AS total_pagos,
        COUNT(p.pago) AS no_pagos
    FROM
        alumnos a
            LEFT JOIN
        pagos p ON (a.clave_alu = p.clave_alu)
    GROUP BY a.clave_alu;
-- Obtenemos todos los alumnos aunque no tengan pagos

SELECT 
    *
FROM
    alumnos_pagos;

/*
Un JOIN muestra menos registros a comparación de un LEFT JOIN:

CREATE OR REPLACE VIEW alumnos_pagos AS
    SELECT 
        a.clave_alu,
        CONCAT_WS(' ',
                a.nombre,
                a.ap_paterno,
                a.ap_materno) AS alumno,
        IFNULL(SUM(p.pago), 0) AS total_pagos,
        COUNT(p.pago) AS no_pagos
    FROM
        alumnos a
            JOIN
        pagos p ON (a.clave_alu = p.clave_alu)
    GROUP BY a.clave_alu;
 
SELECT 
    *
FROM
    alumnos_pagos;
*/

SELECT 
    *
FROM
    information_schema.TABLES
WHERE
    table_schema = 'colegio2857'
        AND table_type = 'VIEW';



GRANT SELECT 
ON colegio2857.alumnas 
TO 'ustest'@'localhost';

GRANT SELECT 
ON colegio2857.alumnos_pagos 
TO 'ustest'@'localhost';
/*
Versiones previas a la ocho de MySQL, si surge el problema de no poder ver la vista 'alumnas' 
porque no tenemos privilegio de la tabla 'alumnos', agregamos SHOW VIEW ON [tabla]
tal como lo hicimos al principio.
*/

SHOW GRANTS FOR 'ustest'@'localhost';
-- GRANT USAGE ON *.* TO `ustest`@`localhost`



SELECT 
    *
FROM
    information_schema.table_privileges
WHERE
    table_schema = 'colegio2857';
/*
Podemos saber qué privilegios están asignados a un usuario con SHOW GRANTS.
Pero también qué tablas están asignadas a un usuario con la sentencia anterior.

Una de las partes de seguridad es validar que la lista de privilegios coincida con
mi matriz de autorización.
*/



-- [2.2]

-- Crear sentencias para privilegios

SELECT 
    CONCAT('SHOW GRANTS FOR \'',
            USER,
            '\'@\'',
            HOST,
            '\';')
FROM
    mysql.USER;
/*
Creamos un SHOW GRANTS para cada usuario en cada host:

SHOW GRANTS FOR 'mysql.infoschema'@'localhost';
SHOW GRANTS FOR 'mysql.session'@'localhost';
SHOW GRANTS FOR 'mysql.sys'@'localhost';
SHOW GRANTS FOR 'root'@'localhost';
SHOW GRANTS FOR 'ustest'@'localhost';
*/



SELECT 
    *
FROM
    information_schema.COLUMNS
WHERE
    table_schema = 'colegio2857'
        AND TABLE_NAME = 'alumnos';



-- Crear SELECT para privilegios de columnas
SELECT 
    CONCAT('GRANT SELECT (',
            COLUMN_NAME,
            '), SHOW VIEW ON colegio2857.',
            TABLE_NAME,
            ' to ustest@localhost;')
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_SCHEMA = 'colegio2857'
        AND TABLE_NAME = 'alumnos';



-- Crear SELECT para privilegios de tablas
SELECT 
    CONCAT('GRANT SELECT, SHOW VIEW ON colegio2857.',
            TABLE_NAME,
            ' to ustest@localhost;')
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    TABLE_SCHEMA = 'colegio2857'
        AND TABLE_TYPE = 'BASE TABLE';
        


DROP USER 'ustest'@'localhost';

SELECT 
    *
FROM
    mysql.USER;



DROP VIEW alumnas;

DROP VIEW inscritos;

DROP VIEW alumnos_pagos;

SELECT 
    *
FROM
    information_schema.TABLES
WHERE
    table_schema = 'colegio2857'
        AND table_type = 'VIEW';