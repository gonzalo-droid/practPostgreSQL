create or replace function inicializar_bd()
	returns void
as
$body$
begin
	if exists(select * from information_schema.tables t where t.table_schema = 'public' and t.table_name = 'tb_action') then
		drop table tb_action;
	end if;

	if exists(select * from information_schema.tables t where t.table_schema = 'public' and t.table_name = 'tb_book') then
		drop table tb_book;
	end if;

	if exists(select * from information_schema.tables t where t.table_schema = 'public' and t.table_name = 'tb_publisher') then
		drop table tb_publisher;
	end if;

	if exists(select * from information_schema.tables t where t.table_schema = 'public' and t.table_name = 'tb_user') then
		drop table tb_user;
	end if;

  CREATE TABLE tb_publisher(
    tb_publisher_id serial not null,
    tb_publisher_cod character(2) not null,
    tb_publisher_nam character varying(50) NOT NULL,
    tb_publisher_country character varying(20) not NULL,
    constraint pk_publisher primary key(tb_publisher_id),
    constraint chk_publisher_id check(tb_publisher_id > 0),
    constraint chk_publisher_cod check(tb_publisher_cod similar to '[0-9]{2}')
  );

  INSERT INTO tb_publisher(tb_publisher_cod, tb_publisher_nam, tb_publisher_country) VALUES
      ('01', 'Santillana', 'Mexico'),
      ('02', 'OReilly', 'USA'),
      ('03', 'MIT Edu', 'USA'),
      ('04', 'UTPC', 'Colombia'),
      ('05', 'Platzi', 'USA');


CREATE TABLE tb_book(
  tb_book_id serial not NULL,
  tb_book_author character varying(60) DEFAULT 'Anonimo',
  tb_book_title character varying(60) NOT NULL,
  tb_book_descrip character varying(200) not null,
  tb_book_price DECIMAL(5,2) not null,
  tb_book_cop INT NOT NULL DEFAULT 0,
  tb_publisher_id integer not null,
  constraint pk_book primary key(tb_book_id),
  constraint fk_publisher_books foreign key (tb_publisher_id) references tb_publisher(tb_publisher_id),
  constraint chk_book_id check(tb_book_id > 0),
  constraint chk_book_precio check(tb_book_price > 0.00),
  constraint chk_book_cop check(tb_book_cop > 0)

);
INSERT INTO tb_book(tb_publisher_id, tb_book_title, tb_book_author, tb_book_descrip, tb_book_price, tb_book_cop) VALUES
    (1, 'Mastering MySQL', 'John Goodman', 'Clases de bases de datos usando MySQL', 10.50, 4),
    (2, 'Trigonometria avanzada', 'Pi Tagoras', 'Trigonometria desde sus origenes', 7.30, 2),
    (3, 'Advanced Statistics', 'Carl Gauss', 'De curvas y otras graficas', 23.60, 1),
    (4, 'Redes Avanzadas', 'Tim Bernes-Lee', 'Lo que viene siendo el Internet', 13.50, 4),
    (2, 'Curvas Parabolicas', 'Napoleon TNT', 'Historia de la parabola', 6.99, 10),
    (1, 'Ruby On (the) Road', 'A Miner', 'Un nuevo acercamiento a la programacion', 18.75, 4),
    (1, 'Estudios basicos de estudios', 'John Goodman', 'Clases de datos usando MySQL', 10.50 , 4),
    (4, 'Donde esta Y?', 'John Goodman', 'Clases de datos usando MySQL', 10.50, 4),
    (3, 'Quimica Avanzada', 'John White', 'Profitable studies on chemistry', 45.35, 1),
    (4, 'Graficas Matematicas', 'Rene Descartes', 'De donde viene el plano', 13.99, 7),
    (4, 'Numeros Importantes', 'Leonard Euler', 'De numeros que a veces nos sirven', 10, 3),
    (3, 'Modelado de conocimiento', 'Jack Friedman', 'Una vez adquirido, como se guarda el conocimiento', 29.99, 2),
    (3, 'Teoria de juegos', 'John Nash', 'A o B?', 12.55, 3),
    (1, 'Calculo de variables', 'Brian Kernhigan', 'Programacion mega basica', 9.50, 3),
    (5, 'Produccion de streaming', 'Juan Pablo Rojas', 'De la oficina ala pan', 23.49, 9),
    (5, 'ELearning', 'JFD & DvdH', 'Diseno y ejecucion de educacion online', 23.55, 4),
    (5, 'Pet Caring for Geeks', 'KC', 'Que tu perro aprenda a programar', 18.79, 3 ),
    (1, 'Algebra basica', 'Al Juarismi', 'Esto de encontrar X o Y, dependiendo', 13.50, 8);



CREATE TABLE tb_user (
  tb_user_id serial not null,
  tb_user_cod character(2) not null,
  tb_user_nam character varying(50) NOT NULL,
  tb_user_email character varying(50) NOT null,
  constraint pk_users primary key(tb_user_id),
  constraint unq_user_cod UNIQUE(tb_user_cod),
  constraint unq_user_email UNIQUE(tb_user_email),
  constraint chk_user_id check(tb_user_id > 0),
  constraint chk_user_cod check(tb_user_cod similar to '[0-9]{2}')

);

INSERT INTO tb_user(tb_user_cod,tb_user_nam,tb_user_email) VALUES
    ('01','Laura', 'laura@hola.com'),
    ('02','Ricardo', 'ricardo@hola.com'),
    ('03','Jose', 'jose@hola.com'),
    ('04','Sofia', 'sofia@hola.com'),
    ('05','Fernanda', 'fernanda@hola.com'),
    ('06','Jose Guillermo', 'memo@hola.com'),
    ('07','Maria', 'maria@hola.com'),
    ('08','Susana', 'susana@hola.com'),
    ('09','Jorge', 'jorge@hola.com');

create type actionType as ENUM('venta','prestamo','devolucion');

CREATE TABLE tb_action(
  tb_action_id serial not null,
  tb_action_type actionType NOT NULL,
  tb_action_fech TIMESTAMP NULL,
  tb_book_id integer not NULL,
  tb_user_id integer not null,
  constraint pk_action_id primary key(tb_action_id),
  constraint fk_book_action foreign key (tb_book_id) references tb_book(tb_book_id),
  constraint fk_user_action foreign key (tb_user_id) references tb_user(tb_user_id),
  constraint chk_action_fech check(tb_action_fech <= now())

);


INSERT INTO tb_action (tb_book_id, tb_user_id, tb_action_type)values
      (3, 2, 'venta'),
      (6, 1, 'prestamo'),
      (7, 7, 'prestamo'),
      (7, 7, 'devolucion'),
      (2, 5, 'venta'),
      (10, 9, 'venta'),
      (7, 7, 'prestamo'),
      (2, 5, 'venta'),
      (1, 3, 'venta'),
      (4, 5, 'prestamo'),
      (5, 2, 'venta');


      end;
      $body$
      language plpgsql;

      select inicializar_bd();

------------------------
function



select * from books \G





___________________________________
select publishers.name , books.title
from publishers join books on publishers.tb_publisher_id = books.tb_publisher_id;

o tambien
select publishers.name , books.title
from publishers,books
where publishers.tb_publisher_id = books.tb_publisher_id;

o tambien

select p.name ,p.country, b.title
from publishers p right join books b
on p.tb_publisher_id = b.tb_publisher_id ;

select p.name ,p.country, b.title
from publishers p left join books b
on p.tb_publisher_id = b.tb_publisher_id ;

select p.name ,p.country, b.title
from publishers p inner join books b
on p.tb_publisher_id = b.tb_publisher_id ;

___________________________________
LO Q VENDI

select  a.action_id,
b.title, a.action_type,
u.name,
b.price as 'precio unitario',
b.price*b.copies as 'total'
from   actions AS a
LEFT JOIN books AS b
  on b.book_id = a.book_id
LEFT JOIN users AS u
  on a.tb_user_id = u.tb_user_id
WHERE a.action_type = 'venta';


___________________________________
LO Q NO VENDI

select  a.action_id,
b.title,
a.action_type,
u.name,
0 as 'NO VENDIDO'
from   actions AS a
LEFT JOIN books AS b
  on b.book_id = a.book_id
LEFT JOIN users AS u
  on a.tb_user_id = u.tb_user_id
WHERE a.action_type <> 'venta';/*
IN ('prestamo','devolucion')*/
___________________________________
-UNION-

select  a.action_id as id,
b.title,
a.action_type,
u.name,
0 as 'price',
0*b.copies as total
from   actions AS a
LEFT JOIN books AS b
  on b.book_id = a.book_id
LEFT JOIN users AS u
  on a.tb_user_id = u.tb_user_id
WHERE a.action_type <> 'venta'


UNION

select  a.action_id as id,
b.title,
a.action_type,
u.name,
b.price as 'price',
b.price*b.copies as total
from   actions AS a
LEFT JOIN books AS b
  on b.book_id = a.book_id
LEFT JOIN users AS u
  on a.tb_user_id = u.tb_user_id
WHERE a.action_type = 'venta'


ORDER BY id;


___________________________________
SELECT  a.action_id AS ID,
        b.title,
        a.action_type,
        u.name,
--      b.price AS 'PRECIO'
    IF   (a.action_type = 'venta',
          b.price,
          0) AS price,

    b.book_id AS bid,

    IF  (b.book_id IN (1,4,7,8,2),
        b.price * .9 ,
        b.price) AS descuento

FROM  actions AS a

LEFT JOIN books AS b
  ON b.book_id = a.book_id
LEFT JOIN users AS u
  ON a.tb_user_id = u.tb_user_id;

siempre poner AS
___________________________________


NUMERO DE LIBROS X  EDITORIALES

select p.tb_publisher_id,p.name , count(b.title) as  '    libros',sum(b.price * b.copies) as 'Precio Total'
from books AS b
JOIN publishers AS p
  ON b.tb_publisher_id = p.tb_publisher_id
GROUP BY p.tb_publisher_id
order by p.tb_publisher_id desc;

___________________________________

libro y EDITORIALES

select p.name ,
b.title,
b.price,
b.copies
from books AS b
JOIN publishers AS p
ON b.tb_publisher_id = p.tb_publisher_id;


___________________________________
libro menos de 15$ ya estan pagados, ya no se deben contar en el stock

SELECT p.tb_publisher_id,
p.name ,
SUM(IF(b.price < 15,0, b.price*b.copies) ) as 'Precio Total',
SUM(IF( b.price<15,0,1)) AS libros_por_vender

FROM books AS b
JOIN publishers AS p
  ON b.tb_publisher_id = p.tb_publisher_id
GROUP BY p.tb_publisher_id;
___________________________________

SELECT p.tb_publisher_id,p.name,b.title,b.price
FROM books AS b
JOIN publishers AS p
  ON b.tb_publisher_id = p.tb_publisher_id
order by tb_publisher_id;
___________________________________

libro que puedo vender

select p.tb_publisher_id as pid,p.name,
count(b.book_id) as libros,
sum(IF(b.price >=15 ,1,0)) as libros_mios
FROM books AS b
LEFT JOIN  publishers AS p
on p.tb_publisher_id = b.tb_publisher_id
GROUP by pid;


___________________________________

ELIMINR datos
delete from users where tb_user_id = 10;

___________________________________
tinyint equivale a un boolean, ventaja
compatibilidad en multiple BD

ALTER TABLE users
ADD COLUMN active tinyint(1)
NOT NULL DEFAULT 1;

___________________________________
cambier estado

UPDATE users SET active = 0
WHERE tb_user_id = 11;
___________________________________
email duplicado modificar name

INSERT INTO users(name,email)
  VALUES('Rocio','jotge@hola.com')
ON DUPLICATE KEY UPDATE
  active = 1,
  name = CONCAT(name,' -nuevo'),
  email = CONCAT(email,' -nuevo');
___________________________________

UPDATE users SET name = 'Roberto' WHERE tb_user_id = 1
LIMIT 1;
limitar duplas

___________________________________
INSERT INTO [tupla]
UPDATE [tupla]
---insert o update
--1
REPLACE INTO users(name,email,active)
values('lorena','lorena@hola.com',4);
// modifica la KEY
--2
REPLACE INTO
users set
name = 'juan',
email = 'juan@hotmial.com'
LIMIT 1;

___________________________________
select p.first_name,d.name,c.name,dt.name
    from PERSONA as p
    join DEPARTAMENTO as d
    ON p.id = d .id
    join CIUDAD as c
    On c.id = d.id


    UNION
    from PERSONA as p
    join DELITO as dt
    ON p.id = dt .id
;
