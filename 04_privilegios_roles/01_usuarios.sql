/*
En MySQL los usuarios se identifican con:

	[nombre_usuario]@[contexto]

El contexto refiere de dónde se puede conectar:

	* Local
	* Remoto
	* Dirección IP

Bases de Datos:

	* information_schema: diccionario de datos
	* performance_schema: estadísticas de uso
	* mysql: todo lo que ocupa el propio servidor para trabajar (incluye los usuarios)
*/
SHOW DATABASES;

SELECT * FROM mysql.USER;
/* 
Accedemos a la tabla usuario y podemos observar todos los privilegios que podemos asignar.
Los campos max_questions, max_updates, max_connections, etc. son limitantes para el usuario; 
si tiene valor cero, no tiene límite.

El plugin de seguridad es la combinación de algoritmos que usa MySQL para generar el password 
y puede cambiar con las versiones de MySQL. Entre otras cosas, contiene un 'sha' del cual se 
obtiene una huella digital que se usa para validaciones.
*/

SHOW PRIVILEGES;

SELECT version() AS version_SGBD, USER() AS usuario;

CREATE USER 'ustest'@'localhost' IDENTIFIED BY '123456%';
-- 'identified by' define el password y el plugin de seguridad
-- Este usuario se conecta de forma local

CREATE USER 'ustest'@'%' IDENTIFIED BY '7890%';
-- Este usuario se conectar de forma remota, pero no de forma local

SELECT * FROM mysql.USER;
-- Para ambos usuarios, aún no hemos asignado ningún privilegio
-- Hasta ahora ambos usuarios se pueden autenticar, pero no autorizar

/*
Ingresamos con las credenciales de 'ustest@localhost' desde una terminal y ejecutamos
las siguientes sentencias:

SELECT USER();

SHOW DATABASES();
USE information_schema;

SHOW TABLES;
SELECT * FROM tables;

Aún no hemos definido ningún privilegio, pero el usuario puede ejecutar las sentencias anteriores.
Tendríamos que modificar el privilegio 'show databases' para los usuarios que no sean 'root'.
El usuario no puede acceder a B.D. como 'sakila', 'sys' y 'world' pero sí a 'information_schema', 
algo que es necesario modificar.

Si ingresamos con las credenciales de 'ustest@%' desde una terminal, no podemos acceder
dado que estamos realizando la conexión de forma local cuando dicho usuario sólo puede 
acceder de forma remota.
*/

DROP USER 'ustest'@'localhost';

DROP USER 'ustest'@'%';
/*
Si ejecutamos la instrucción 'drop user' con la sesión iniciada, entonces el usuario aún puede acceder 
y modificar la B.D. Esto se debe a que el usuario y sus privilegios ya están cargados en la memoria 
del cliente en el server; lo mismo sucede si modificamos sus privilegios.
*/

SHOW PROCESSLIST;
/*
Para solucionar el problema no podemos cerrar la sesión porque literalmente el usuario ya no existe.
Por lo tanto, una de las soluciones es matar el proceso del usuario con la instrucción 'kill'.

Si matamos el proceso antes de eliminar el usuario, entonces volverá a conectarse con éxito.
*/

FLUSH PRIVILEGES;
-- Adicionalmente podemos usar esta instrucción que refresca los privilegios del usuario

CREATE USER 'ustest'@'localhost' IDENTIFIED BY '123456%' WITH MAX_USER_CONNECTIONS 2;
-- Número máximo de conexiones simultaneas
-- En este ejemplo, sólo podemos desde dos terminales simultáneamente

CREATE USER 'ustest'@'localhost' IDENTIFIED BY '123456%' WITH MAX_CONNECTIONS_PER_HOUR 2;
-- Número máximo de conexiones en una hora
-- En este ejemplo, en una hora no podemos una tercera vez

DROP USER 'ustest'@'localhost';