create table PERSONA(
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  first_name varchar(30) NOT NULL,
  last_name varchar(30) NOT NULL ,
  apodo varchar(30),mo
  sexo varchar(15) NOT NULL,
  first_apellido varchar(30) NOT NULL ,
  last_apellido varchar(30) NOT NULL,
  descrip varchar(100) NOT NULL ,
  add COLUMN FK_ciudad INTEGER UNSIGNED NOT NULL,
  add COLUMN FK_crimen INTEGER UNSIGNED NOT NULL,
  add COLUMN FK_departamento INTEGER UNSIGNED NOT NULL
);

create table DEPARTAMENTO(
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name varchar(30) NOT NULL,
);

alter table CIUDAD
add COLUMN FK_depar INT UNSIGNED NOT NULL;


create table CIUDAD(
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name varchar(30) NOT NULL
  FK_depart INT UNSIGNED NOT NULL;
);

create table DELITO(
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name varchar(50) NOT NULL
);

INSERT INTO PERSONA (first_name,last_name,apodo,sexo ,first_apellido,last_apellido,descrip,FK_departamento, FK_ciudad ,FK_crimen )
VALUES ("CARLOS","DANIEL","OLIVOLI","MASCULINO","OLIVERA","LOYAGA","MARCA EN LA CABEZA",1,2,1),
("LENINN",NULL,"TETON","MASCULINO","ROJAS","ESPINOZA","LUNAR EN EL LABIO SUPERIOR",2,3,3);

INSERT INTO DEPARTAMENTO(id,name) values(1,"LAMBAYEQUE"),(2,"TRUJILLO"),(3,"PIURA");

INSERT INTO CIUDAD(id,name,FK_depart) values(1,"PAITA",3),(2,"CHICLAYO",1),(3,"HUANCHACO",2);

INSERT INTO DELITO(id,name)
values (1,"LAVADO DE ACTIVOS"),(2,"NARCOTRAFICO"),(3,"CICARIATO");

select p.last_name , p.first_name , d.name , c.name
from PERSONA as p
JOIN DEPARTAMENTO as d
on p.id = d.id
JOIN CIUDAD as c
on p.FK_ciudad = d.id;
