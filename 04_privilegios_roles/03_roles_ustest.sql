-- [1.1]

SHOW DATABASES;
-- Sólo muestra las B.D. 'schema'

SELECT USER(), CURRENT_ROLE();
-- ustest@localhost, NONE

-- Los privilegios de los roles asignados no se cargan automáticamente a la sesión

USE colegio2857;
-- No tenemos privilegios sobre la B.D.



SET ROLE readapp;
-- Para cargar un rol necesitamos la cláusula SET

SELECT USER(), CURRENT_ROLE();
-- ustest@localhost, `readapp`@`%`

SHOW DATABASES;

USE colegio2857;

SHOW TABLES;

SELECT 
    *
FROM
    niveles;

INSERT INTO niveles 
VALUES(8, 'DR');
-- Solo tenemos el privilegio SELECT contenido en el rol 'readapp'



SET ROLE writeapp;
-- Cargar otro rol remplaza el anterior

SELECT USER(), CURRENT_ROLE();
-- ustest@localhost, `writeapp`@`%`

INSERT INTO niveles 
VALUES(8, 'DR');

SELECT 
    *
FROM
    niveles;
-- Solo tenemos los privilegios INSERT, UPDATE y DELETE
-- contenidos en el rol 'writeapp'



SET ROLE ALL;
-- Pero podemos cargar todos los roles asignados

SELECT USER(), CURRENT_ROLE();
-- ustest@localhost, `readapp`@`%`,`writeapp`@`%`

SELECT 
    *
FROM
    niveles;

UPDATE niveles 
SET 
    nombre = 'DOC'
WHERE
    id_nivel = 8;

DELETE FROM niveles 
WHERE
    id_nivel = 8;



SET ROLE NONE;
-- También podemos quitar todos los roles

SELECT USER(), CURRENT_ROLE();
-- ustest@localhost, NONE



-- [2.1]
SET ROLE writeapp;

SET ROLE ALL;
-- Ya no existe ningún rol asignado al usuario que podamos cargar

SELECT USER(), CURRENT_ROLE();