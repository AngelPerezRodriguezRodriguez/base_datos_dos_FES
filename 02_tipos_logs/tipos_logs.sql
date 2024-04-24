SHOW VARIABLES;
-- Variables que contienen la configuración de nuestro servidor



SHOW VARIABLES LIKE '%data%';
/*
C:\ProgramData\MySQL\MySQL Server 8.0\Data

Dicha ruta contiene todos los datos de nuestras B.D. 
(creación de bases de datos, tablas, inserción de datos, etc.).
Es la parte física de nuestro S.G.B.D.
*/



SHOW VARIABLES LIKE '%error%';
/* Tipo de log [01]

'log_error' realiza un tracking de todas las veces que sucede algo inesperado en el servidor.
Es una variable que sólo podemos cambiar cuando el servidor está apagado a través del archivo 
de configuración my.ini

SET cambia una variable en el servidor en tiempo de ejecución. Si queremos que la variable 
cambie a un estado permanente, editamos el archivo de configuración my.ini

 * Intentamos cambiar la ruta de almacenamiento

		SET GLOBAL log_error = 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\[nuevo_archivo].err';
		Error Code: 1238. Variable 'log_error' is a read only variable

 * Visualizamos el archivo [usuario].err

		cd C:\ProgramData\MySQL\MySQL Server 8.0\Data
		type [usuario].err
 */



SHOW VARIABLES LIKE '%general_log%';
/* Tipo de log [02]

'general_log' registra todas las consultas que se ejecutan en la B.D. por un usuario o proceso. 
Está apagado por default ya que no nos encontramos en un estado de producción sino de desarrollo, 
además de que crece exponencialmente; nos sirve más como un historial.

 * Encendemos el registro
 
		SET GLOBAL general_log = 1;
 
 * Cambiamos la ruta de almacenamiento
 
		SET GLOBAL general_log_file = 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\[nuevo_archivo].log';
 
 * Ejecutamos una sentencia
   'information_schemma' es el diccionario de datos.
 
		SELECT 
		table_schema, 
		SUM(table_rows) AS no_registros
		FROM information_schema.TABLES
		GROUP BY table_schema
		ORDER BY 2 DESC;
 
 * Visualizamos el contenido de [nuevo_archivo].log
 
		cd C:\ProgramData\MySQL\MySQL Server 8.0\Data
		type [nuevo_archivo].log
        
 * Apagamos el registro de consultas

		SET GLOBAL general_log = 0;
 */



SHOW VARIABLES LIKE '%log_bin%';
/* Tipo de log [03]

'log_bin' recupera las transacciones que cambian el estado de la B.D. (CREATE, ALTER, DROP, etc.)
Si se crashea el sistema, podemos recuperar el estado transaccional. Está prendido por default porque 
nos puede ayudar, en caso de que se apague o crashee el servidor, a recuperar dicho estado.

 * Visualizamos el contenido de [usuario]-bin.index
 
		cd C:\ProgramData\MySQL\MySQL Server 8.0\Data
		type [usuario]-bin.index
*/



SHOW VARIABLES LIKE '%slow_query%';
/* Tipo de log [04]

'slow_query' registra todas las consultas que llegan a alentar el servidor.
Una consulta que dura más de dos segundos es considerada como lenta.

 * Encendemos el registro de consultas
 
		SET GLOBAL slow_query_log = 1;

 * Cambiamos la ruta de almacenamiento

		SET GLOBAL slow_query_log_file = 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Data\\[nuevo_archivo]-slow.log';

 * Ejecutamos una sentencia
   A pesar de usar la instrucción JOIN no hay igualdad de PK y FK (ON, USING o NATURAL),
   por lo tanto, es un producto cartesiano.
        
		SELECT * 
		FROM colegio2857.alumnos 
		JOIN colegio2857.pagos;

 * Visualizamos el contenido de [nuevo_archivo]-slow.log
 
		cd C:\ProgramData\MySQL\MySQL Server 8.0\Data
		type [nuevo_archivo]-slow.log
 */



SHOW PROCESSLIST;
-- Muestra el número de conexiones a nuestro servidor