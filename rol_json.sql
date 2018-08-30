Comandos para consola:
/////////////////////


>sudo -i -u postgres
>psql

Leer comandos desde un archivo:
>\i input.sql

Listar DB
>\l

Listar tablas
>\d

Describe tablas
\d table_name

Usar DB
>\c name_db

//////////////////     R O L E S           ////////////////////////////////
crear un rol
>CREATE ROLE video LOGIN PASSWORD '123321';

creaer nuevo schema
>CREATE SCHEMA name_schema

ver roles/pg_roles ==> tablas por x defecto
>SELECT * FROM pg_roles;

Borrar rol
>DROP ROL pueba_rol

password segura encriptar con MD5
>CREATE ROLE video LOGIN ENCRYPTED PASSWORD '123321';
valido para siempre
>CREATE ROLE video LOGIN ENCRYPTED PASSWORD '123321' VALID UNTIL 'infinity';

acceso temporal
>CREATE ROLE video LOGIN ENCRYPTED PASSWORD '123321' VALID UNTIL '2015-8-1 00:00';

Permisos a los roles:
-CREATEDB
-SUPERUSER
-CREATEROLE
-create DB
>CREATE ROLE video LOGIN ENCRYPTED PASSWORD '123321' CREATEDB VALID UNTIL 'infinity';

-sus roles heredan sus permisos, hasta q sea removido del rol grupal , pierde sus permisos
>CREATE ROLE platzi_group INHERIT;

-Agregar rol a rol_grupo
>GRANT rol_uno TO rol_dos;

**NO SE HEREDAN PERMISOS DE SUPERUSER

**PLANTILLAS BASE CREAR
_crear base datos con plantilla
>CREATE DATABASE nombre_db TEMPLATE template1
(plantilla x default);

-Cambiar rol
>SET ROLE rol_grupo;
////////////////////////////////////////////////////////////////////


/////////Para hacer una base de datos una plantilla//////////////////
ejecutamos lo siguiente:

>UPDATE pg_database SET datistemplate = true
	WHERE datname = ‘curso_pg’;

**Eliminar sesiones
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='library'
AND procpid<>pg_backend_pid();

					or

El query SELECT * FROM pg_stat_activity WHERE datname = 'curso_pg'; te permite visualizar que usuarios se encuentran actualmente conectados.
Conociendo el pid (process id) puedes matar ese proceso para que el usuario termine esa conexión y ahí sí eliminar la base de datos. SELECT pg_terminate_backend(8449);
////////////////////////////////////////////////////////////////////


////////////////////// S C H E M A S//////////////////////////


para sistemas muy grandes.
agrupar por funcionalidad
diferentes schemas , pueden tener tabla de igual
nombre

*crear schema
>CREAR SCHEMA name_sh;
*lista schema
>\dn


----Privilegios------------
>GRANT privilege TO role WITH GRANT OPCTION
*asiganar privilegios sobre todas las tablas
en el schema video en el rol platzi

>GRANT ALL ON ALL TABLES IN SCHEMA video TO platzi;
*solo privilegios de SELECT
>GRANT SELECT ON ALL TABLES IN SCHEMA video TO platzi;

////////////////////////////////////////////////////////////////////

////////////////D A T O S   S E R I A L////////////////////////////

*uso primary key ID
*limite de valor entero


>CREATE SEQUENCE ejemplo;
>SELECT nextval('ejemplo');

-reiniciar un sequence
>SELECT setval('ejemplo',5)

-Mostrar el valor actual de la
sequence
>SELECT currval('ejemplo')

////////////////////////////////////////////////////////////////////

////////////////C A D E N A   de  TXT ////////////////////////////

char => longitud fija, DNI
varchar => variable, toma unicamente
	el texto ingresado
text=> no se especifica longitud
 	hasta un 1GB de text


>SELECT split_part('11-22-33','-',2)
	as posicion2;

posicion2
--------
 22
**el sd complete the 10
>select lpad('sd',10,'?')
"????????sd"

>select repeat('-',4) || 'zy' as dash;
"----zy"
>select trim(' r  ') as TRIM;
"r"

////////////////////////////////////////////////////////////////////

////////////////A R R A Y////////////////////////////


>SELECT string_to_array('aa.bb.bb','.') AS d ;

*El indexador comienza en '1'

>SELECT ARRAY[2013,2014,2015,2016] as array
>SELECT ARRAY(SELECT DISTINCT tb_producto_nom from sh_taller.tb_producto)
>SELECT '{mysql,postgresQL}'::text[] AS x;
**::=> cast de string => text

>SELECT x[1] FROM(
	SELECT '{mysql,postgresQL,a,b,c,d,e}'::text[] AS x
		) AS y;
>SELECT UNNEST x[1:3] FROM(
	SELECT '{mysql,postgresQL,a,b,c,d,e}'::text[] AS x
		) AS y;
*Rango de 1 al 3
>SELECT DISTINCT tb_producto_nom from sh_taller.tb_producto
**Muestro los datos distintos de una columna


////////////////////////////////////////////////////////////////////

//////////////// R A N G O S ////////////////////////////

SELECT '[1,6)'::int8range;

<code> en función int8range el
[ significa que incluye desde el primer valor
 hasta el segundo valor : ejemplo. [0,6) imprime [0,6)
SELECT'[0,6)'::int8range;

el ( significa que imprimira cualquier numero mayor al primer parametro hasta el valor del segundo valor. ejemplo : (0,6) imprime [1,6)
SELECT'(0,6)'::int8range;

>Se pueden definir rangos de datos de un
campo de la tabla y obtener los que cumplan
con ese rango a través de la clausula "@>". Ejemplo:

SELECT * FROM data_name WHERE '[1,5)'::numrange @> caracteristica;

-- Crear tabla
CREATE TABLE data(
    gender varchar(10),
    height numeric,
    weight numeric
);
--Poblarla (mediante un bloque anonimo de PL/pgSQL) 150 registros
DO $$DECLARE r record;
BEGIN
  FOR i IN 1..150 LOOP
    INSERT INTO data
    SELECT
      (SELECT CASE WHEN CEIL(RANDOM()*2) = 1 THEN 'Male' ELSE 'Female' END) as gender,
      (SELECT 72 - ROUND((RANDOM()*3)::numeric, 2)) as height,  -- esto genera valores entre 69 y 72
      (SELECT 100 - ROUND((RANDOM()*45)::numeric,2)) as weight
    ;
   END LOOP;
END$$


SELECT * FROM public.data WHERE '[70.0,71.0)'::numrange @> data.height;





////////////////////////////////////////////////////////////////////

//////////////// JJ SS OO NN ////////////////////////////

CREATE TABLE json.profiles(id serial PRIMARY KEY, profile JSON);
INSERT INTO json.profiles(profile) VALUES ('{"name":"Mario","tech":["postgres","pyhton","mysql"]}')
INSERT INTO json.profiles(profile) VALUES ('{"name":"Luis","tech":["Rstudio","Fortnite","Web"]}')
INSERT INTO json.profiles(profile) VALUES ('{"name":"Carlos","tech":["Power","Java","Server"]}')
INSERT INTO profiles(profile) VALUES ( '{"name": "Jeduan", "tech": ["javascript", "nodejs"] }');
 select json_extract_path_text(profile,'name') from json.profiles;
SELECT json_extract_path_text(profile, 'tech') FROM profiles;
SELECT json_extract_path_text(json_array_elements(profile, 'tech')) FROM profiles;
b







---------------JSON


CREATE TABLE json.profiles(id serial PRIMARY KEY, profile JSON);
INSERT INTO json.profiles(profile) VALUES ('{"name":"Mario","tech":["postgres","pyhton","mysql"]}')
INSERT INTO json.profiles(profile) VALUES ('{"name":"Luis","tech":["Rstudio","Fortnite","Web"]}')
INSERT INTO json.profiles(profile) VALUES ('{"name":"Carlos","tech":["Power","Java","Server"]}')
INSERT INTO profiles(profile) VALUES ( '{"name": "Jeduan", "tech": ["javascript", "nodejs"] }');
 select json_extract_path_text(profile,'name') from json.profiles;
SELECT json_extract_path_text(profile, 'tech') FROM profiles;
SELECT json_extract_path_text(json_array_elements(profile, 'tech')) FROM profiles;
