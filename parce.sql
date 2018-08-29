create or replace function sh_taller.Updateproducto2(
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

	if(resultado = true and exists(select * from sh_taller.tb_producto where tb_producto_id <> producto_id and tb_producto_cod=producto_cod)) the
		resultado = false;
		mensaje = 'Codigo ya se encuentra registrado';
	end if;



	if( resultado = true and producto_cod not similar to '[0-9][0-9][0-9][0-9]')then
		resultado = false;
		mensaje = 'Codigo con patron incorrecto';

	end if;

	if(resultado = true and exists(select * from sh_taller.tb_producto where tb_producto_id <> producto_id and tb_producto_nom=producto_nom)) then
	resultado = false;
		mensaje = 'Codigo ya se encuentra registrado';

	end if;

	if(resultado = true and productos_preuni not between 0.01 and 99.99) then
		resultado = false;
		mensaje = 'el Precio Unitario fuera de rango valido';

	end if;

	if(resultado = true and producto_sto < 0)then
		resutlado = false;
		mensaje='Stock no puede ser negativo';

	end if;

	if(resultado = true) then
	update sh_taller.tb_producto set
	tb_producto_cod = producto_cod,
	tb_producto_nom = producto_nom,
	tb_producto_preuni = producto_preuni,
	tb_producto_sto = producto_sto;
	where tb_producto_Id producto_id;
	mensaje ='Producto modificado correctamente';
	end if;



end;
$body$
language plpgsql;

select * from sh_taller.tb_producto order by  producto_id ;

select sh_taller.Updateproducto(4,'0004','mandarina');

select sh_taller.insertarproducto2('Yuca',22.4,40);
select sh_taller.insertarproducto2('camote',32.4,30);
select sh_taller.insertarproducto2('arroz',52.4,50);
select sh_taller.insertarproducto2('azucar',2.4,60);
