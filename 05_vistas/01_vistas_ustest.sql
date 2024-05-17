-- [1.1]

USE colegio2857;

SHOW TABLES;
-- Sólo muestra la tabla 'alumnos' y 'pagos'

DESC alumnos;
-- Sólo muestra 5 campos de 20

DESC pagos;
-- Sólo muestra 4 campos de 10



SELECT 
    *
FROM
    alumnos;
-- No tenemos acceso a todos los campos con el privilegio SELECT,
-- por lo tanto, no debemos usar '*' en la sentencia

SELECT 
    clave_alu, ap_paterno, ap_materno, nombre, curp, sexo
FROM
    alumnos;
-- No tenemos acceso al campo 'sexo' con el privilegio SELECT

SELECT 
    clave_alu, ap_paterno, ap_materno, nombre, curp
FROM
    alumnos;

SELECT 
    ap_paterno, ap_materno, nombre
FROM
    alumnos;



SELECT 
    *
FROM
    pagos;
-- No tenemos acceso a todos los campos con el privilegio SELECT

SELECT 
    clave_alu, pago, fecha_pago, id
FROM
    pagos;

UPDATE pagos 
SET 
    pago = 7100
WHERE
    id = 24574;
-- No tenemos acceso al campo 'pago' con el privilegio UPDATE

UPDATE pagos 
SET 
    fecha_pago = SYSDATE()
WHERE
    id = 24574;



-- [2.1]

USE colegio2857;

SHOW TABLES;

SELECT 
    *
FROM
    alumnas;

SELECT 
    *
FROM
    alumnos_pagos;

SELECT 
    *
FROM
    alumnos_pagos
WHERE
    clave_alu IN (SELECT 
            matricula
        FROM
            alumnas);
/*
Obtenemos todos los pagos de los alumnos que sean mujeres. Podemos usar un JOIN, pero, 
en este caso, podemos usar algo más sencillo. Usamos la intersección, parecido al JOIN 
pero sin hacer el producto cartesiano sirve cuando no hay nada con qué hacer match.
*/

SELECT 
    *
FROM
    alumnos_pagos
WHERE
    clave_alu NOT IN (SELECT 
            matricula
        FROM
            alumnas);
-- Obtenemos todos los pagos de los alumnos que no sean mujeres

SELECT 
    *
FROM
    information_schema.table_privileges
WHERE
    table_schema = 'colegio2857';
-- Podemos saber qué privilegios están asignados a un usuario con SHOW GRANTS
-- Pero también qué tablas están asignadas a un usuario con la sentencia anterior