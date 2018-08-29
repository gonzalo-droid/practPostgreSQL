//instal
 sudo apt-get install postgresql postgresql-client postgresql-contrib libpq-dev
//vresion
psql --version
//entrar a postgresql
sudo -i -u postgres
//entrar
psql==> verificar la version
//salir
\q
//crear user
createuser --interactive
---nombre
---yes // ser root
//create base de datos
createdb taller
//pass a usuario
psql
-- \password user
-- 123321
-- 123321
//conectar a bd
psql -U user W
==============
//LISTAR LAS DB
--( \l || psql -l )&& mysql ==> show databases;

//LISTAR TABLES
--  && mysql ==> show tables

//Crear base de datos:
CREATE DATABASE nombre_db WITH OWNER nombre_usuario;

//Eliminar base de datos:
DROP DATABASE nombre_db;

//Acceder database con usuario x:
psql -U nombre_usuario nombre_db





ROLES

de inicio de sesion
	password
de grupo
	No tiene proviligeios de inicio de sesion
	agrupar roles
>sudo -i -u postgres
>psql
crear un rol
>CREATE ROLE video LOGIN PASSWORD '123321';

creaer nuevo schema
>CREATE SCHEMA name_schema

ver roles/pg_roles ==> tablas x defecto
>SELECT * FROM pg_roles;

borrar rol
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
____



**Para hacer una base de datos una plantilla
ejecutamos lo siguiente:

>UPDATE pg_database SET datistemplate = true
	WHERE datname = curso_pg;

**Eliminar sesiones
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='library'
AND procpid<>pg_backend_pid();

______------SCHEMAS-------______

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

--------DATOS SERIALES------------
*uso primary key ID
*limite de valor entero


>CREATE SEQUENCE ejemplo;
>SELECT nextval('ejemplo');

-reiniciar un sequence
>SELECT setval('ejemplo',5)

-Mostrar el valor actual de la
sequence
>SELECT currval('ejemplo')

-----Cadenas de texto----


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

>select lpad('sd',10,'?')
"????????sd"
>select repeat('-',4) || 'zy' as dash;
"----zy"
>select trim(' r  ') as TRIM;
"r"



--------A-R-R-A-Y-----

>SELECT string_to_array('aa.bb.bb','.') AS d ;

*El indexador comienza en '1'

>SELECT ARRAY[2013,2014,2015,2016] as array
>SELECT ARRAY(SELECT DISTINCT tb_producto_nom from sh_taller.tb_producto)
>SELECT '{mysql,postgres}'::text[] AS x;
**::=> cast de string => text

>SELECT x[1] FROM(
	SELECT '{mysql,postgres,a,b,c,d,e}'::text[] AS x
		) AS y;
>SELECT UNNEST x[1:3] FROM(
	SELECT '{mysql,postgres,a,b,c,d,e}'::text[] AS x
		) AS y;
*Rango de 1 al 3
>SELECT DISTINCT tb_producto_nom from sh_taller.tb_producto
**Muestro los datos distintos de una columna


_______RANGOS

SELECT '[1,6)'::int&range;

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






---------------JSON


CREATE TABLE json.profiles(id serial PRIMARY KEY, profile JSON);
INSERT INTO json.profiles(profile) VALUES ('{"name":"Mario","tech":["postgres","pyhton","mysql"]}')
INSERT INTO json.profiles(profile) VALUES ('{"name":"Luis","tech":["Rstudio","Fortnite","Web"]}')
INSERT INTO json.profiles(profile) VALUES ('{"name":"Carlos","tech":["Power","Java","Server"]}')
INSERT INTO profiles(profile) VALUES ( '{"name": "Jeduan", "tech": ["javascript", "nodejs"] }');
 select json_extract_path_text(profile,'name') from json.profiles;
SELECT json_extract_path_text(profile, 'tech') FROM profiles;
SELECT json_extract_path_text(json_array_elements(profile, 'tech')) FROM profiles;




HSTORE

CREATE EXTENSION hstore;
"Activamos la extension hstore"

CREATE TABLE hprofiles(
    id serial PRIMARY key,
    profile hstore
);

\d hprofiles

INSERT INTO hprofiles(profile) VALUES('name=> Mario, ruby=>true , postgres=> true');
INSERT INTO hprofiles(profile) VALUES('name=> Jeduan, javascript=>true , nodejs=> true');
#Insertar valores

SELECT * FROM hprofiles;

SELECT profile ->>'name'as Name FROM profiles;


SELECT * FROM hprofiles WHERE (profile -> 'ruby')::boolean;


select * FROM hprofiles WHERE profile @> 'nodejs=>true';
#Evalua si en profile hay un regisyto de nodejs

select * FROM hprofiles WHERE profile ? 'nodejs'; #exite la llave?

select * FROM hprofiles WHERE profile ?& ARRAY['nodejs','javascript']; #exite la llave?

select * FROM hprofiles WHERE profile ?| ARRAY['nodejs','javascript']; #exite la llave?

#Actualizar los 2 registros a  la vez
UPDATE hprofiles SET profile = profile || 'html5=>true'::hstore;


#Borrar llave
UPDATE hprofiles SET profile =delete( profile,'html5');


#obtener keys

SELECT akeys(profile) FROM hprofiles;
SELECT skeys(profile) FROM hprofiles;
SELECT DISTINCT skeys(profile) FROM hprofiles;


#hsote ==> json
SELECT hstore_to_json(profile) FROM hprofiles ;





--------------------PostGIS
#Guardar informacion de geolocalizacion y geometria

--Activar
CREATE EXTENSION postgis;

CREATE TABLE hospitales(
    id serial primary key,
    location geography,
    position geometry(POINT, 4326),#coordernada cartesiana
    name text
)

\d hospitales

INSERT INTO hospitales (name,location) values("San Muerte",ST_POINT(-6.3788,53.2911))
SELECT * FROM hospitales;


#buscar la distancia del punto de referencia
SELECT name, ST_DISTANCE(location,ST_POINT(-6.237009945,53.3411573)::geography)
FROM hospitales;
#distancia desed el punto del query a las locations de la TABLE


#posiciones dentro de l aposicion en particular
SELECT name FROM hospitales WHERE ST_DWithin(location,ST_POINT(-6.23709,53.34115)::geography,10000)
                                                                                            #RADIO


Si les sale un error de este tipo en debian:
"ERROR: could not open extension control file "/usr/share/postgresql/9.4/extension/postgis.control": No such file or directory"
Deben instalar el postgis con:
"sudo apt-get install postgresql-9.4-postgis-2.1"





#Reportar posicion2
SELECT name, ST_ASTEXT(location) FROM hospitales;

#formato json
SELECT name, ST_ASGEOJSON(location) FROM hospitales;

#Formato KML
SELECT name, ST_ASKML(location) FROM hospitales;

#Librerias para trabajar PostGIS
#Herramienta PGSQLtuchip

----------------------------------------------!!!!!!!!!!!!!!!!!!!!!!""""""""""""""
Ubutnu 16.04.4
PostgreSQL 9.5

Me dio el siguiente error:

curso_pg=# CREATE EXTENSION postgis;
ERROR:  could notopen extension control file "/usr/share/postgresql/9.5/extension/postgis.control": No existe el archivo o el directori
para solucionarlo, tuve que instarlalo:

sudo apt-get install postgis
y ya pude habilitar la extensión es postgreSQL

curso_pg=# CREATEEXTENSION postgis;
CREATEEXTENSION

IN vestigar
-----------------
CTS en postgres
Fuciones de ventanas
Tablas temporales
