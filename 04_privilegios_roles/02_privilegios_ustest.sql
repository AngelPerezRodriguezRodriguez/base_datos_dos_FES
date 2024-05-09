-- [1.1]

SHOW DATABASES;
-- Sólo muestra las B.D. 'schema'

SELECT USER();
-- ustest@localhost



-- [2.1]
SHOW DATABASES;
-- Muestra las B.D. 'schema'
-- pero también muestra el resto de B.D.



-- [3.1]

SHOW DATABASES;
-- Muestra las B.D. 'schema'
-- pero también muestra 'colegio2857'

USE colegio2857;

SHOW TABLES;

SELECT * FROM niveles;

-- Podemos comprobar los privilegios sobre la B.D. y sobre todos sus objetos:

INSERT INTO niveles VALUES (8, 'DR');

SELECT * FROM niveles;

UPDATE niveles SET nombre = 'DOC' WHERE id_nivel = 8;

SELECT * FROM niveles;

DELETE FROM niveles WHERE id_nivel = 8;

SELECT * FROM niveles;



-- [4.1]

USE colegio2857;

SELECT * FROM niveles;

INSERT INTO niveles VALUES (8, 'DR');

UPDATE niveles SET nombre = 'DOC' WHERE id_nivel = 8;

DELETE FROM niveles WHERE id_nivel = 8;

-- 'insert', 'udpate' y 'delete' son comandos denegados

SELECT * FROM grados;

DELETE FROM grados WHERE id_grado = 16;

-- 'insert', 'udpate' y 'delete' son denegados sobre todos los objetos de 'colegio2857'



-- [5.1]

USE colegio2857;

SELECT * FROM niveles;

INSERT INTO niveles VALUES (8, 'DR');

UPDATE niveles SET nombre = 'DOC' WHERE id_nivel = 8;

DELETE FROM niveles WHERE id_nivel = 8;

SELECT * FROM grados;

DELETE FROM grados WHERE id_grado = 16;

-- 'insert', 'udpate' y 'delete' sólo son permitidos sobre la tabla 'niveles'



-- [6.1]
SHOW DATABASES;
-- Muestra las B.D. 'schema', 'colegio2857'
-- pero también muestra 'bdconcurrencia'

USE bdconcurrencia;

SHOW TABLES;

SELECT * FROM cuentas;
-- Sólo tenemos el privilegio 'select'



-- [7.1]
SHOW DATABASES;
-- Muestra las B.D. 'schema', 'colegio2857', 'bdconcurrencia'
-- pero también muestra 'escuela2857'

USE escuela2857;

SHOW TABLES;
-- Sólo muestra la tabla 'alumnos' y 'pagos'

SELECT * FROM alumnos;

SELECT * FROM pagos;

SELECT * FROM niveles;