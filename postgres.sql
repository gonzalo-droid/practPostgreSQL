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
