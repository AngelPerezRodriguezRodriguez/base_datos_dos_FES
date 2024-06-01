-- 1. Crear un usuario admin con privilegios totales en las bases de datos escuela
create user 'admin'@'localhost' identified by '12345';

select * from mysql.user;
drop user 'admin'@'localhost';
grant all on escuela.* to 'admin'@'localhost';

-- 2. Privilegios de DML solo en los campos nombres de las tablas nivel, grado y alumno
grant insert(nombres), update(nombres), delete on escuela.nivel to 'admin'@'localhost';
grant insert(nombres), update(nombres), delete on escuela.grado to 'admin'@'localhost';
grant insert(nombres), update(nombres), delete on escuela.alumno to 'admin'@'localhost';

-- 3. Solo privilegios DDL en la BD concurrencia
grant create, alter, drop on bdconcurrencia.* to 'admin'@'localhost';

-- 4. Solo una conexion permitida
alter user 'admin'@'localhost' with max_user_connections 1;

-- 5. Solo permite 30 updates x hora
alter user 'admin'@'localhost' with max_updates_per_hour 30;

-- 6. Solo permite 150 querys x hora
alter user 'admin'@'localhost' with max_queries_per_hour 150;

-- 7. Bloquear usuario
alter user 'admin'@'localhost' identified by '12345' account lock;

-- 8. Cambiar password
alter user 'admin'@'localhost' identified by 'abcde';

-- 9. Los privilegios DML son asignados con rol
create role rol_01;
grant insert, update, delete on escuela.* to rol_01;
grant role_01 to 'admin'@'localhost';