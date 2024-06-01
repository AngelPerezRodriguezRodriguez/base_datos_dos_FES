-- PARCIAL 1 NAJERA CORTES ERIK SAUL, ANGEL PEREZ RODRIGUEZ RODRIGUEZ

-- 1. usando la terminal restaurar archivo: colegio.sql en la base de datos Parcial_[grupo]_[iniciales]
create database if not exists Parcial_2857_AE;
use Parcial_2857_AE;

-- mysql -h localhost -u root -p Parcial_2857_AE < "C:\Users\eriks\OneDrive\Escritorio\colegio.sql"

-- 2. En la terminal, ver el contenido del slow log(slow query)
-- cd C:\ProgramData\MySQL\MySQL Server 8.0\Data
-- type slow_localhost_2857.log

-- 3. En una transacción actualizar el campo colonia a "SIN COLONIA" de todos los alumnos con sexo F de la bd
show variables like '%safe%';
set sql_safe_updates = 0;

start transaction;

update alumnos set colonia = 'SIN COLONIA'
where sexo = 'F'; 

commit;
-- select * from alumnos where sexo = 'F';

-- 4. En una transacción eliminar a todos los alumnos que no tengan un valor en el campo peso, después
-- a todos los alumnos que no tengan un email y usando savepoint regresar al primer punto de la transacción

start transaction;
delete from alumnos where peso is null and peso = 0; 
savepoint alumnos_peso;

delete from alumnos where email is null and email = '';
rollback to alumnos_peso;

commit;

-- 5. Crear dos vistas v_cursos y v_niveles que sean alias de cursos y niveles respectivamente
create or replace view v_cursos as 
select * from cursos;

create or replace view v_niveles as
select * from niveles;

-- 6 roles

-- crear un rol para solo visualizar las vistas v_curso y v_niveles
create role lectura_vista1;

grant select on Parcial_2857_AE.v_cursos  to 'lectura_vista1';
grant select on Parcial_2857_AE.v_niveles  to 'lectura_vista1';


-- crear un rol para escritura en la tablas materias grados y salones
create role escritura1;

grant insert,update, delete on Parcial_2857_AE.materias to 'escritura1';
grant insert,update, delete on Parcial_2857_AE.grados to 'escritura1';
grant insert,update, delete on Parcial_2857_AE.salones to 'escritura1';

-- crear un rol para escritura en los campos colonia peso y email de alumnos, pago y fecha_op, fecha de pagos y calificacion y fmod de evaluaciones
create role escritura2;
grant insert(colonia,peso,email),update (colonia,peso,email), delete on Parcial_2857_AE.alumnos to 'escritura2';

grant insert(pago,fecha_op,fecha_pago),update (pago,fecha_op,fecha_pago), delete on Parcial_2857_AE.pagos to 'escritura2';

grant insert(calificacion, fmod),update (calificacion, fmod), delete on Parcial_2857_AE.evaluaciones to 'escritura2';

/*
show tables from colegio2857;
select * from evaluaciones;
select * from pagos;
select * from alumnos;
*/

-- 7 crear un usuario lector_[nombre]_[grupo] y asignarle el rol de LECTURA
-- a) el usuario debe tener acceso desde localhost y desde cualquier punto con contraseñas diferentes

create user 'lector_ErikAngel_2857'@'localhost' identified by '123456%';
create user 'lector_ErikAngel_2857'@'%' identified by '654321%';

grant lectura_vista1 to 'lector_ErikAngel_2857'@'localhost';

-- b) el usuario remoto solo puede ver vistas y no puede tener mas de una sesion activa
grant lectura_vista1 to 'lector_ErikAngel_2857'@'%';
alter user 'lector_ErikAngel_2857'@'%' with max_user_connections 1;

-- 8 crear un usuario escritor nombre, grupo y asignaarle los roles lectura y escritura
create user 'escritor_ErikAngel_2857'@'localhost' identified by '678910%';
grant lectura_vista1,escritura1,escritura2 to 'escritor_ErikAngel_2857'@'localhost';

-- a) solo tiene acceso desde localhost y puede realizar 25 consultas, 10 actualizaciones y tener solo 2 sesiones concurrentes
alter user 'escritor_ErikAngel_2857'@'localhost' with max_connections_per_hour 25;
alter user 'escritor_ErikAngel_2857'@'localhost' with max_updates_per_hour 10;
alter user 'escritor_ErikAngel_2857'@'localhost' with max_user_connections 2;

-- 9 mostrar los privilegios del usuario escritor usando roles
show grants for 'escritor_ErikAngel_2857'@'localhost' using lectura_vista1,escritura1,escritura2;

--  10 usando la terminal generar respaldo del solo de la tabla alumnos de la BD
-- Parcial grupo iniciales el nombre del archivo desde ser Alumnos_AAAAMMDD.sql
-- mysqldump -h localhost -u root -p Parcial_2857_AE.alumnos > "C:\Users\eriks\OneDrive\Escritorio\Alumnos_20230322.sql"