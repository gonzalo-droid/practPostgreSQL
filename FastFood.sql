create or replace function inicializar_bd()
	returns void
as
$body$
begin
	if exists(select * from information_schema.tables t where t.table_schema = 'public' and t.table_name = 'tb_detallepedido') then
		drop table tb_detallepedido;
	end if;

	if exists(select * from information_schema.tables t where t.table_schema = 'public' and t.table_name = 'tb_pedido') then
		drop table tb_pedido;
	end if;

	if exists(select * from information_schema.tables t where t.table_schema = 'public' and t.table_name = 'tb_producto') then
		drop table tb_producto;
	end if;

	if exists(select * from information_schema.tables t where t.table_schema = 'public' and t.table_name = 'tb_usuario') then
		drop table tb_usuario;
	end if;

	if exists(select * from information_schema.tables t where t.table_schema = 'public' and t.table_name = 'tb_sucursal') then
		drop table tb_sucursal;
	end if;

	create table tb_sucursal
	(
		tb_sucursal_id serial not null,
		tb_sucursal_cod character(2) not null,
		tb_sucursal_nom character varying(50) not null,
		constraint pk_sucursal primary key(tb_sucursal_id),
		constraint unq_sucursal_cod unique(tb_sucursal_cod),
		constraint unq_sucursal_nom unique(tb_sucursal_nom),
		constraint chk_sucursal_id check(tb_sucursal_id > 0),
		constraint chk_sucursal_cod check(tb_sucursal_cod similar to '[0-9]{2}')
	);

	INSERT INTO tb_sucursal(tb_sucursal_cod,tb_sucursal_nom)
	values ('01','Trujillo'),('02','Piura'),('03','Lambayeque')

	create table tb_usuario
	(
		tb_usuario_id serial not null,
		tb_usuario_cod character(2) not null,
		tb_usuario_nom character varying(50) not null,
		tb_usuario_usenam character varying(50) not null,
		tb_usuario_pas character varying(50) not null,
		tb_sucursal_id integer not null,
		constraint pk_usuario primary key(tb_usuario_id),
		constraint fk_sucursal_usuario foreign key(tb_sucursal_id) references tb_sucursal(tb_sucursal_id),
		constraint unq_usuario_cod unique(tb_usuario_cod),
		constraint unq_usuario_usenam unique(tb_usuario_usenam),
		constraint chk_usuario_id check(tb_usuario_id > 0),
		constraint chk_usuario_cod check(tb_usuario_cod similar to '[0-9]{2}')
	);
insert into tb_usuario(tb_usuario_cod,tb_usuario_nom,tb_usuario_usenam,tb_usuario_pas,tb_sucursal_id)
	values ('01','Carlos Daniel Olivera Loyaga','CDOL','1234',1),
				('02','Jorge Luis Chapoñan Suclupe','JLCS','1234',2),
				('03','Gonzalo Felipe Lopez Guerrero','GFLG','1234',3)
	create table tb_producto
	(
		tb_producto_id serial not null,
		tb_producto_cod character(2) not null,
		tb_producto_nom character varying(50) not null,
		tb_producto_preuni decimal(11,2) not null,
		constraint pk_producto primary key(tb_producto_id),
		constraint unq_producto_cod unique(tb_producto_cod),
		constraint unq_producto_nom unique(tb_producto_nom),
		constraint chk_producto_id check(tb_producto_id > 0),
		constraint chk_producto_cod check(tb_producto_cod similar to '[0-9]{2}'),
		constraint chk_producto_preuni check(tb_producto_preuni > 0.00)
	);
INSERT INTO tb_producto(tb_producto_cod,tb_producto_nom,tb_producto_preuni)
values ('01','PIZZA ITALIANA',23.4),('02','PIZZA FRANCESA',14.8),('03','PIZZA ALEMANA',35.7),('04','PIZZA ESPAÑOLA',10.5)
	create table tb_pedido
	(
		tb_pedido_id serial not null,
		tb_pedido_cli character varying(50) not null,
		tb_pedido_dir character varying(50) not null,
		tb_pedido_tel character(6) not null,
		tb_pedido_tot decimal(11,2) not null,
		tb_pedido_pag decimal(11,2) not null,
		tb_pedido_vue decimal(11,2) not null,
		tb_pedido_mod character(1) not null,
		tb_pedido_est character(1) not null default 'P',
		tb_pedido_fechorreg timestamp not null default now(),
		tb_pedido_fechormod timestamp null,
		tb_pedido_fechorcon timestamp null,
		tb_pedido_fechordes timestamp null,
		tb_pedido_fechoranu timestamp null,
		tb_usuario_id integer null,
		tb_sucursal_id integer null,
		constraint pk_pedido primary key(tb_pedido_id),
		constraint fk_usuario_pedido foreign key(tb_usuario_id) references tb_usuario(tb_usuario_id),
		constraint fk_sucursal_pedido foreign key(tb_sucursal_id) references tb_sucursal(tb_sucursal_id),
		constraint chk_pedido_id check(tb_pedido_id > 0),
		constraint chk_pedido_tel check(tb_pedido_tel similar to '[0-9]{6}'),
		constraint chk_pedido_tot check(tb_pedido_tot > 0.00),
		constraint chk_pedido_pag check(tb_pedido_pag > 0.00),
		constraint chk_pedido_vue check(tb_pedido_vue >= 0.00),
		-- T: Teléfono, I: Internet
		constraint chk_pedido_mod check(tb_pedido_mod in ('T','I')),
		-- P: Por Confirmar, C: Confirmado, D: Despachado, A: Anulado
		constraint chk_pedido_est check(tb_pedido_est in ('P','C','D','A')),
		constraint chk_pedido_fechorreg check(tb_pedido_fechorreg <= now()),
		constraint chk_pedido_fechormod check(tb_pedido_fechormod <= now()),
		constraint chk_pedido_fechorcon check(tb_pedido_fechorcon <= now()),
		constraint chk_pedido_fechordes check(tb_pedido_fechordes <= now()),
		constraint chk_pedido_fechoranu check(tb_pedido_fechoranu <= now()),
		constraint chk_pedido_fechormodfechorreg check(tb_pedido_fechormod >= tb_pedido_fechorreg),
		constraint chk_pedido_fechorconfechormod check(tb_pedido_fechorcon >= tb_pedido_fechormod),
		constraint chk_pedido_fechordesfechorcon check(tb_pedido_fechordes >= tb_pedido_fechorcon),
		constraint chk_pedido_fechoranufechorreg check(tb_pedido_fechoranu >= tb_pedido_fechorreg)
	);

	create table tb_detallepedido
	(
		tb_detallepedido_id serial not null,
		tb_detallepedido_can integer not null,
		tb_detallepedido_preuni decimal(11,2) not null,
		tb_detallepedido_subtot decimal(11,2) not null,
		tb_pedido_id integer not null,
		tb_producto_id integer not null,
		constraint pk_detallepedido primary key(tb_detallepedido_id),
		constraint fk_pedido_detallepedido foreign key(tb_pedido_id) references tb_pedido(tb_pedido_id),
		constraint fk_producto_detallepedido foreign key(tb_producto_id) references tb_producto(tb_producto_id),
		constraint chk_detallepedido_id check(tb_detallepedido_id > 0),
		constraint chk_detallepedido_can check(tb_detallepedido_can >= 0),
		constraint chk_detallepedido_preuni check(tb_detallepedido_preuni > 0.00),
		constraint chk_detallepedido_subtot check(tb_detallepedido_subtot >= 0.00)
	);
end;
$body$
language plpgsql;

select inicializar_bd();
drop function inicializar_bd();
