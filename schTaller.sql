--Script: Tables
create table sh_taller.tb_producto
(
	tb_producto_id serial not null,
	tb_producto_cod character(4) not null,
	tb_producto_nom character varying(50) not null,
	tb_producto_preuni decimal(5,2) not null,
	tb_producto_sto integer not null,
	constraint pk_producto primary key(tb_producto_id),
	constraint unq_producto_cod unique(tb_producto_cod),
	constraint unq_producto_nom unique(tb_producto_nom),
	constraint chk_producto_id check(tb_producto_id > 0),
	constraint chk_producto_cod check(tb_producto_cod similar to '[0-9][0-9][0-9][0-9]'),
	constraint chk_producto_preuni check(tb_producto_preuni > 0.00),
	constraint chk_producto_sto check(tb_producto_sto >= 0)
);

create table sh_taller.tb_cliente
(
	tb_cliente_id serial not null,
	tb_cliente_cod character(4) not null,
	tb_cliente_nom character varying(50) not null,
	constraint pk_cliente primary key(tb_cliente_id),
	constraint unq_cliente_cod unique(tb_cliente_cod),
	constraint unq_cliente_nom unique(tb_cliente_nom),
	constraint chk_cliente_id check(tb_cliente_id > 0),
	constraint chk_cliente_cod check(tb_cliente_cod similar to '[0-9][0-9][0-9][0-9]')
);

create table sh_taller.tb_pedido
(
	tb_pedido_id serial not null,
	tb_pedido_num integer not null,
	tb_pedido_fec date not null,
	tb_pedido_tot decimal(11,2) not null,
	tb_cliente_id integer not null,
	constraint pk_pedido primary key(tb_pedido_id),
	constraint fk_cliente_pedido foreign key(tb_cliente_id) references sh_taller.tb_cliente(tb_cliente_id),
	constraint unq_pedido_num unique(tb_pedido_num),
	constraint chk_pedido_id check(tb_pedido_id > 0),
	constraint chk_pedido_num check(tb_pedido_num > 0),
	constraint chk_pedido_fec check(tb_pedido_fec <= cast(now() as date)),
	constraint chk_pedido_tot check(tb_pedido_tot > 0.00)
);

create table sh_taller.tb_detallepedido
(
	tb_detallepedido_id serial not null,
	tb_detallepedido_can integer not null,
	tb_detallepedido_preuni decimal(5,2) not null,
	tb_detallepedido_subtot decimal(11,2) not null,
	tb_pedido_id integer not null,
	tb_producto_id integer not null,
	constraint pk_detallepedido primary key(tb_detallepedido_id),
	constraint fk_pedido_detallepedido foreign key(tb_pedido_id) references sh_taller.tb_pedido(tb_pedido_id),
	constraint fk_producto_detallepedido foreign key(tb_producto_id) references sh_taller.tb_producto(tb_producto_id),
	constraint chk_detallepedido_id check(tb_detallepedido_id > 0),
	constraint chk_detallepedido_can check(tb_detallepedido_can > 0),
	constraint chk_detallepedido_preuni check(tb_detallepedido_preuni > 0.00),
	constraint chk_detallepedido_subtot check(tb_detallepedido_subtot > 0.00)
);
-------------------------------------------------------------------

--Script: Functions
create or replace function sh_taller.sumar
(
	in numero1 integer,
	in numero2 integer
)
returns integer
as
$body$
declare
	resultado integer;
begin
	resultado = numero1 + numero2;

	return resultado;
end;
$body$
language plpgsql;
---------------------------------------------
create or replace function sh_taller.potencia
(
	in base integer,
	in exponente integer
)
returns integer
as
$body$
declare
	resultado integer;
	i integer;
begin
	i = 0;

	resultado = 1;
	while(i < exponente) loop
		resultado = resultado * base;
		i = i + 1;
	end loop;

	return resultado;
end;
$body$
language plpgsql;
----------------------------------------------
create or replace function sh_taller.potencia2
(
	in base integer,
	in exponente integer
)
returns integer
as
$body$
declare
	resultado integer;
	i integer;
begin
	resultado = 1;
	for i in 1 .. exponente loop
		resultado = resultado * base;
	end loop;

	return resultado;
end;
$body$
language plpgsql;
----------------------------------------------
create or replace function sh_taller.potencia3
(
	in base integer,
	in exponente integer
)
returns integer
as
$body$
declare
	resultado integer;
	i integer;
begin
	i = 1;
	resultado = 1;

	loop
		resultado = resultado * base;
		i = i + 1;

		exit when i > exponente;
		continue when i <= exponente;
	end loop;

	return resultado;
end;
$body$
language plpgsql;
----------------------------------------------
create or replace function sh_taller.potencia4
(
	in base integer,
	in exponente integer
)
returns integer
as
$body$
declare
	resultado integer;
	i integer;
begin
	i = 1;

	if(exponente = 0) then
		resultado = 1;
	else
		resultado = 1;
		loop
			resultado = resultado * base;
			i = i + 1;

			exit when i > exponente;
			continue when i <= exponente;
		end loop;
	end if;

	return resultado;
end;
$body$
language plpgsql;
--------------------------------------------------
create or replace function sh_taller.convertir10a2
(
	in numero integer
)
returns text
as
$body$
declare
	resultado text;
begin
		resultado = '';

		while(numero != 1) loop
			resultado = (numero%2) || resultado;
			numero = numero / 2;
		end loop;

		resultado = numero || resultado;

		return resultado;
end;
$body$
language plpgsql;
--------------------------------------------------
create or replace function sh_taller.convertir2a10
(
	in numero text
)
returns integer
as
$body$
declare
	resultado integer;
	digito text;
	i integer;
begin
		resultado = 0;

		i = 1;
		while(i <= length(numero)) loop
			digito = substring(numero,i,1);
			resultado = resultado + cast(digito as integer) *
			                        sh_taller.potencia(2,(length(numero) - i));

			i = i + 1;
		end loop;

		return resultado;
end;
$body$
language plpgsql;
----------------------------------------------------
create or replace function sh_taller.convertir2a10v2
(
	in numero text,
	out resultado integer
)
as
$body$
declare
	digito text;
	i integer;
begin
		resultado = 0;

		i = 1;
		while(i <= length(numero)) loop
			digito = substring(numero,i,1);
			resultado = resultado + cast(digito as integer) *
			                        sh_taller.potencia(2,(length(numero) - i));

			i = i + 1;
		end loop;
end;
$body$
language plpgsql;
-----------------------------------------------------------------------------
--drop function sh_taller.insertarproducto(character varying,decimal,integer)
create or replace function sh_taller.insertarproducto
(
    in producto_nom character varying(50),
    in producto_preuni decimal(5,2),
    in producto_sto integer,
	out mensaje text
)
as
$body$
declare
	numero integer;
	codigo text;
begin
	select max(cast(tb_producto_cod as integer))
	from sh_taller.tb_producto
	into numero;

	if(numero is null) then
		codigo = '0001';
	else
		numero = numero + 1;
		codigo = lpad(cast(numero as character varying),4,'0');
	end if;

	if(exists(select * from sh_taller.tb_producto where tb_producto_nom = producto_nom)) then
		mensaje = 'Nombre ya se encuentra registrado';
	else
		insert into sh_taller.tb_producto
		(tb_producto_cod,tb_producto_nom,tb_producto_preuni,tb_producto_sto)
		values(codigo,producto_nom,producto_preuni,producto_sto);

		mensaje = 'Producto registrado correctamente';
	end if;
end;
$body$
language plpgsql;
-----------------------------------------------------
--select * from sh_taller.tb_producto
--select sh_taller.insertarproducto(('','MI NOMBRE',9.1,330));
create type tc_producto as
(
	producto_cod character(4),
	producto_nom character varying(50),
	producto_preuni decimal(5,2),
	producto_sto integer
);

create or replace function sh_taller.insertarproducto
(
    in producto tc_producto,
	out mensaje text
)
as
$body$
declare
	numero integer;
	codigo text;
begin
	select max(cast(tb_producto_cod as integer))
	from sh_taller.tb_producto
	into numero;

	if(numero is null) then
		codigo = '0001';
	else
		numero = numero + 1;
		codigo = lpad(cast(numero as character varying),4,'0');
	end if;

	if(exists(select * from sh_taller.tb_producto where tb_producto.tb_producto_nom = producto.producto_nom)) then
		mensaje = 'Nombre ya se encuentra registrado';
	else
		insert into sh_taller.tb_producto
		(tb_producto_cod,tb_producto_nom,tb_producto_preuni,tb_producto_sto)
		values(codigo,producto.producto_nom,producto.producto_preuni,producto.producto_sto);

		mensaje = 'Producto registrado correctamente';
	end if;
end;
$body$
language plpgsql;

create or replace function sh_taller.actualizaproducto
(
	in producto_id integer,
	in producto_cod character(4),
    in producto_nom character varying(50),
    in producto_preuni decimal(5,2),
    in producto_sto integer,
	out mensaje text
)
as
$body$
declare
	resultado boolean;
begin
	resultado = true;

	if(not exists(select * from sh_taller.tb_producto where tb_producto_id = producto_id)) then
		resultado = false;
		mensaje = 'Producto no se encuentra registrado';
	end if;

	if(resultado = true and exists(select * from sh_taller.tb_producto where tb_producto_id <> producto_id and tb_producto_cod = producto_cod)) then
		resultado = false;
		mensaje = 'Código se encuentra registrado';
	end if;

	if(resultado = true and producto_cod not similar to '[0-9][0-9][0-9][0-9]') then
		resultado = false;
		mensaje = 'Código no tiene el patrón correcto';
	end if;

	if(resultado = true and exists(select * from sh_taller.tb_producto where tb_producto_id <> producto_id  and tb_producto_nom = producto_nom)) then
		resultado = false;
		mensaje = 'Nombre ya se encuentra registrado';
	end if;

	if(resultado = true and producto_preuni not between 0.01 and 999.99 ) then
		resultado = false;
		mensaje = 'Precio unitario fuera de rango válido';
	end if;

	if(resultado = true and producto_sto < 0) then
		resultado = false;
		mensaje = 'Stock no puede ser negatvo';
	end if;

	if(resultado = true) then
		update sh_taller.tb_producto set
		tb_producto_cod = producto_cod,
		tb_producto_nom = producto_nom,
		tb_producto_preuni = producto_preuni,
		tb_producto_sto = producto_sto
		where tb_producto_id = producto_id;

		mensaje = 'Producto modificado correctamente';
	end if;
end;
$body$
language plpgsql;

----------------------------------------------------
select * from sh_taller.tb_cliente;
select sh_taller.insertarcliente('JUAN PÉREZ');

create or replace function sh_taller.insertarcliente
(
    in cliente_nom character varying(50),
	out mensaje text
)
as
$body$
declare
	numero integer;
	codigo text;
begin
	select max(cast(tb_cliente_cod as integer))
	from sh_taller.tb_cliente
	into numero;

	if(numero is null) then
		codigo = '0001';
	else
		numero = numero + 1;
		codigo = lpad(cast(numero as character varying),4,'0');
	end if;

	if(exists(select * from sh_taller.tb_cliente where tb_cliente_nom = cliente_nom)) then
		mensaje = 'Nombre ya se encuentra registrado';
	else
		insert into sh_taller.tb_cliente
		(tb_cliente_cod,tb_cliente_nom)
		values(codigo,cliente_nom);

		mensaje = 'Cliente registrado correctamente';
	end if;
end;
$body$
language plpgsql;

create or replace function sh_taller.actualizarcliente
(
	in cliente_id integer,
	in cliente_cod character(4),
    in cliente_nom character varying(50),
	out mensaje text
)
as
$body$
begin
	if(cliente_cod not similar to '[0-9][0-9][0-9][0-9]') then
		mensaje = 'Código con patrón incorrecto';
	else
		if(exists(select * from sh_taller.tb_cliente where tb_cliente_id <> cliente_id and tb_cliente_cod = cliente_cod)) then
			mensaje = 'Código ya se encuentra registrado';
		else
			if(exists(select * from sh_taller.tb_cliente where tb_cliente_id <> cliente_id and tb_cliente_nom = cliente_nom)) then
				mensaje = 'Nombre ya se encuentra registrado';
			else
				update sh_taller.tb_cliente set
				tb_cliente_cod = cliente_cod
				,tb_cliente_nom = cliente_nom
				where tb_cliente_id = cliente_id;

				mensaje = 'Cliente modificado correctamente';
			end if;
		end if;
	end if;
end;
$body$
language plpgsql;
----------------------------------------------------------------------------------------------
-----------------------------------------------------
--select * from sh_taller.tb_producto
--select sh_taller.insertarproducto(('','MI NOMBRE',9.1,330));
create type tc_pedido as
(
	tb_pedido_id integer,
	tb_pedido_num integer,
	tb_pedido_fec date,
	tb_pedido_tot decimal(11,2),
	tb_cliente_id integer
);

create type tc_detallepedido as
(
	tb_detallepedido_id integer,
	tb_detallepedido_can integer,
	tb_detallepedido_preuni decimal(5,2),
	tb_detallepedido_subtot decimal(11,2),
	tb_pedido_id integer,
	tb_producto_id integer
);

alter table sh_taller.tb_pedido drop constraint unq_pedido_num;
alter table sh_taller.tb_pedido add constraint unq_pedido_fecnum unique(tb_pedido_fec,tb_pedido_num);
alter table sh_taller.tb_pedido drop constraint chk_pedido_tot;
alter table sh_taller.tb_pedido add constraint chk_pedido_tot check(tb_pedido_tot >= 0.00)

create or replace function sh_taller.insertarpedido
(
    in pedido tc_pedido,
		in detallespedido tc_detallepedido[],
	out mensaje text
)
as
$body$
declare
	error boolean;
	i integer;
	producto_nom character varying(50);
	producto_sto integer;
	detallepedido_preuni decimal(5,2);
	detallepedido_subtot decimal(11,2);
begin
		error = false;

		for i in 1..array_length(detallespedido,1) loop
			select tb_producto_nom, tb_producto_sto into producto_nom, producto_sto
			from sh_taller.tb_producto

			where tb_producto_id = detallespedido[i].tb_producto_id;

			if(detallespedido[i].tb_detallepedido_can > producto_sto) then
				mensaje = 'Producto ' || producto_nom || ' no tiene stock suficiente';
				error = true;
				exit;
			end if;
		end loop;

		if(error = false) then
			select max(tb_pedido_num)
			from sh_taller.tb_pedido
			where tb_pedido_fec = cast(now() as date)
			into pedido.tb_pedido_num;

			if(pedido.tb_pedido_num is null) then
				pedido.tb_pedido_num = 1;
			else
				pedido.tb_pedido_num = pedido.tb_pedido_num + 1;
			end if;

			pedido.tb_pedido_fec = cast(now() as date);

			select nextval('sh_taller.tb_pedido_tb_pedido_id_seq')
			into pedido.tb_pedido_id;

			insert into sh_taller.tb_pedido
			(tb_pedido_id,tb_pedido_num,tb_pedido_fec,tb_pedido_tot,tb_cliente_id)
			values(pedido.tb_pedido_id,pedido.tb_pedido_num,pedido.tb_pedido_fec,0.00,pedido.tb_cliente_id);

			pedido.tb_pedido_tot = 0;
			for i in 1..array_length(detallespedido,1) loop
				select tb_producto_preuni
				from sh_taller.tb_producto
				where tb_producto_id = detallespedido[i].tb_producto_id
				into detallepedido_preuni;

				detallepedido_subtot = detallespedido[i].tb_detallepedido_can * detallepedido_preuni;
				pedido.tb_pedido_tot = pedido.tb_pedido_tot + detallepedido_subtot;

				insert into sh_taller.tb_detallepedido
				(tb_detallepedido_can,tb_detallepedido_preuni,tb_detallepedido_subtot,tb_pedido_id,tb_producto_id)
				values(detallespedido[i].tb_detallepedido_can,detallepedido_preuni,detallepedido_subtot,
				pedido.tb_pedido_id,detallespedido[i].tb_producto_id);

				update sh_taller.tb_producto set
				tb_producto_sto = tb_producto_sto - detallespedido[i].tb_detallepedido_can
				where tb_producto_id = detallespedido[i].tb_producto_id;
			end loop;

			update sh_taller.tb_pedido set
			tb_pedido_tot = pedido.tb_pedido_tot
			where tb_pedido_id = pedido.tb_pedido_id;
		end if;
end;
$body$
language plpgsql;

select sh_taller.insertarpedido((0,0,'01/01/0001',0,1),'{"(0,2,0,0,0,1)","(0,4,0,0,0,1)"}');

--------------------------------------------------------------------------------------------------
--drop type tc_pedido cascade;
--drop type tc_detallepedido cascade;

create type tc_detallepedido as
(
	tb_detallepedido_id integer,
	tb_detallepedido_can integer,
	tb_detallepedido_preuni decimal(5,2),
	tb_detallepedido_subtot decimal(11,2),
	tb_producto_id integer
);

create type tc_pedido as
(
	tb_pedido_id integer,
	tb_pedido_num integer,
	tb_pedido_fec date,
	tb_pedido_tot decimal(11,2),
	tb_cliente_id integer,
	detallespedido tc_detallepedido[]
);

create or replace function sh_taller.insertarpedido
(
	in pedido tc_pedido,
	out mensaje text
)
as
$body$
declare
	error boolean;
	i integer;
	producto_nom character varying(50);
	producto_preuni decimal(5,2);
	producto_sto integer;
	detallespedido_preuni decimal(5,2)[];
	detallespedido_subtot decimal(11,2)[];
begin
	error = false;

	select max(tb_pedido_num)
	from sh_taller.tb_pedido
	where tb_pedido_fec = cast(now() as date)
	into pedido.tb_pedido_num;

	if(pedido.tb_pedido_num is null) then
		pedido.tb_pedido_num = 1;
	else
		pedido.tb_pedido_num = pedido.tb_pedido_num + 1;
	end if;

	pedido.tb_pedido_fec = cast(now() as date);

	pedido.tb_pedido_tot = 0.00;

	for i in 1..array_length(pedido.detallespedido,1) loop
		select tb_producto_nom,tb_producto_preuni,tb_producto_sto
		into producto_nom,producto_preuni,producto_sto
		from sh_taller.tb_producto
		where tb_producto_id = pedido.detallespedido[i].tb_producto_id;

		if(pedido.detallespedido[i].tb_detallepedido_can > producto_sto) then
			mensaje = 'Producto ' || producto_nom || ' no tiene stock suficiente';
			error = true;
			exit;
		end if;

		detallespedido_preuni[i] = producto_preuni;
		detallespedido_subtot[i] = pedido.detallespedido[i].tb_detallepedido_can * detallespedido_preuni[i];

		pedido.tb_pedido_tot = pedido.tb_pedido_tot + detallespedido_subtot[i];
	end loop;

	if(error = false) then
		select nextval('sh_taller.tb_pedido_tb_pedido_id_seq')
		into pedido.tb_pedido_id;

		insert into sh_taller.tb_pedido
		(tb_pedido_id,tb_pedido_num,tb_pedido_fec,tb_pedido_tot,tb_cliente_id)
		values(pedido.tb_pedido_id,pedido.tb_pedido_num,pedido.tb_pedido_fec,pedido.tb_pedido_tot,pedido.tb_cliente_id);

		for i in 1..array_length(pedido.detallespedido,1) loop
			insert into sh_taller.tb_detallepedido
			(tb_detallepedido_can,tb_detallepedido_preuni,tb_detallepedido_subtot,tb_pedido_id,tb_producto_id)
			values(pedido.detallespedido[i].tb_detallepedido_can,detallespedido_preuni[i],detallespedido_subtot[i],
			pedido.tb_pedido_id,pedido.detallespedido[i].tb_producto_id);

			update sh_taller.tb_producto set
			tb_producto_sto = tb_producto_sto - pedido.detallespedido[i].tb_detallepedido_can
			where tb_producto_id = pedido.detallespedido[i].tb_producto_id;
		end loop;
	end if;
end;
$body$
language plpgsql;

select sh_taller.insertarpedido((0,0,'01/01/0001',0,1,array[(0,2,0,0,1),(0,4,0,0,1)]::tc_detallepedido[]));
