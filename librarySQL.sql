CREATE TABLE books(
  book_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  publisher_id INTEGER UNSIGNED NOT NULL DEFAULT 0,
  author VARCHAR(60) DEFAULT 'Anonimo',
  title VARCHAR(60) NOT NULL,
  description TEXT,
  price DECIMAL(5,2) ,
  copies INT NOT NULL DEFAULT 0
);

CREATE TABLE publishers(
  publisher_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  country VARCHAR(20)
);
CREATE TABLE users (
  user_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE actions(
  action_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  book_id INTEGER UNSIGNED NOT NULL,
  user_id INTEGER UNSIGNED NOT NULL,
  action_type ENUM('venta','prestamo','devolucion')
    NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);



INSERT INTO users(name, email) VALUES
    ('Ricardo', 'ricardo@hola.com'),
    ('Laura', 'laura@hola.com'),
    ('Jose', 'jose@hola.com'),
    ('Sofia', 'sofia@hola.com'),
    ('Fernanda', 'fernanda@hola.com'),
    ('Jose Guillermo', 'memo@hola.com'),
    ('Maria', 'maria@hola.com'),
    ('Susana', 'susana@hola.com'),
    ('Jorge', 'jorge@hola.com');

INSERT INTO publishers(publisher_id, name, country) VALUES
    (1, 'OReilly', 'USA'),
    (2, 'Santillana', 'Mexico'),
    (3, 'MIT Edu', 'USA'),
    (4, 'UTPC', 'Colombia'),
    (5, 'Platzi', 'USA');


select * from books \G


INSERT INTO books(publisher_id, title, author, description, price, copies) VALUES
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


INSERT INTO actions (book_id, user_id, action_type)values
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

___________________________________
select publishers.name , books.title
from publishers join books on publishers.publisher_id = books.publisher_id;

o tambien
select publishers.name , books.title
from publishers,books
where publishers.publisher_id = books.publisher_id;

o tambien

select p.name ,p.country, b.title
from publishers p right join books b
on p.publisher_id = b.publisher_id ;

select p.name ,p.country, b.title
from publishers p left join books b
on p.publisher_id = b.publisher_id ;

select p.name ,p.country, b.title
from publishers p inner join books b
on p.publisher_id = b.publisher_id ;

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
  on a.user_id = u.user_id
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
  on a.user_id = u.user_id
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
  on a.user_id = u.user_id
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
  on a.user_id = u.user_id
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
  ON a.user_id = u.user_id;

siempre poner AS
___________________________________


NUMERO DE LIBROS X  EDITORIALES

select p.publisher_id,p.name , count(b.title) as  '    libros',sum(b.price * b.copies) as 'Precio Total'
from books AS b
JOIN publishers AS p
  ON b.publisher_id = p.publisher_id
GROUP BY p.publisher_id
order by p.publisher_id desc;

___________________________________

libro y EDITORIALES

select p.name ,
b.title,
b.price,
b.copies
from books AS b
JOIN publishers AS p
ON b.publisher_id = p.publisher_id;


___________________________________
libro menos de 15$ ya estan pagados, ya no se deben contar en el stock

SELECT p.publisher_id,
p.name ,
SUM(IF(b.price < 15,0, b.price*b.copies) ) as 'Precio Total',
SUM(IF( b.price<15,0,1)) AS libros_por_vender

FROM books AS b
JOIN publishers AS p
  ON b.publisher_id = p.publisher_id
GROUP BY p.publisher_id;
___________________________________

SELECT p.publisher_id,p.name,b.title,b.price
FROM books AS b
JOIN publishers AS p
  ON b.publisher_id = p.publisher_id
order by publisher_id;
___________________________________

libro que puedo vender

select p.publisher_id as pid,p.name,
count(b.book_id) as libros,
sum(IF(b.price >=15 ,1,0)) as libros_mios
FROM books AS b
LEFT JOIN  publishers AS p
on p.publisher_id = b.publisher_id
GROUP by pid;


___________________________________

ELIMINR datos
delete from users where user_id = 10;

___________________________________
tinyint equivale a un boolean, ventaja
compatibilidad en multiple BD

ALTER TABLE users
ADD COLUMN active tinyint(1)
NOT NULL DEFAULT 1;

___________________________________
cambier estado

UPDATE users SET active = 0
WHERE user_id = 11;
___________________________________
email duplicado modificar name

INSERT INTO users(name,email)
  VALUES('Rocio','jotge@hola.com')
ON DUPLICATE KEY UPDATE
  active = 1,
  name = CONCAT(name,' -nuevo'),
  email = CONCAT(email,' -nuevo');
___________________________________

UPDATE users SET name = 'Roberto' WHERE user_id = 1
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
