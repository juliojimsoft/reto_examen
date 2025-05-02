/*CREACION DE BASE DE DATOS*/
/*Nota  Nota: Cambia la ruta al subdirectorio DATA de tu instalación de SQL Server. 
Puedes verlo en las propiedades de tu instancia o usar SELECT SERVERPROPERTY('InstanceDefaultDataPath');.*/
/*1. CREAR UNA BASE DE DATOS LLAMADA PERSONAL*/
if not exists (select * from master.sys.databases where name = 'db_personal')
begin 
	CREATE DATABASE db_personal
	/*CONFIGURACION DEL ARCHIVO DE DATOS*/
	ON PRIMARY (
		NAME = 'personal_data',
		FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\personal.mdf',
		SIZE = 10MB,
		MAXSIZE=UNLIMITED,
		FILEGROWTH = 5MB
	)
	/*CONFIGURACION DEL ARCHIVO DE TRANSACCIONES*/
	LOG ON (
		NAME='personal_log',
		FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\personal_log.ldf',
		SIZE=5MB,
		MAXSIZE=UNLIMITED,
		FILEGROWTH=2MB
	)
	COLLATE SQL_Latin1_General_CP1_CI_AI
end
go

if db_id('db_personal') is null
begin 
	return;
end
GO

/*usar db creada*/
use db_personal;
go

/*preparar bd y eliminar tablas*/
if object_id('dbo.personas','U') is not null
begin drop table dbo.personas end
if object_id('dbo.area','U') is not null
begin drop table dbo.area end;
if object_id('dbo.zona','U') is not null
begin drop table dbo.zona end
if object_id('dbo.puesto','U') is not null
begin drop table dbo.puesto end
GO

/*2.2 CREAR TABLA AREA*/
create table area(
	id_area int identity(1,1) primary key,
	descripcion nvarchar(50) not null
); 
GO

/*2.3 CREAR TABLA ZONA*/
create table zona(
	id_zona int identity(1,1) primary key,
	descripcion nvarchar(50) not null
); 
GO

/*2.4 CREAR TABLA PUESTO*/
create table puesto(
	id_puesto int identity(1,1) primary key,
	descripcion nvarchar(50) not null
); 
GO

/*2.1 CREAR TABLA PERSONAS*/
CREATE TABLE personas(
	login int identity(5630,2) primary key,
	nombre nvarchar(100), 
	area int not null,
	zona int not null,
	puesto int not null,
	constraint fk_area foreign key(area) references area(id_area) on delete no action,
	constraint fk_zona foreign key(zona) references zona(id_zona) on delete no action,
	constraint fk_puesto foreign key(puesto) references puesto(id_puesto) on delete no action
); 
GO

begin transaction
begin try
	/*SEMILLAS O DATOS INICIALES*/
	INSERT INTO AREA ( DESCRIPCION)
	VALUES ('TELEFONIA');
	INSERT INTO AREA (DESCRIPCION)
	VALUES ('IMPLEMENTACION');
	INSERT INTO AREA (DESCRIPCION)
	VALUES ('CAPACITACION');
	INSERT INTO AREA (DESCRIPCION)
	VALUES ('CALIDAD');
	INSERT INTO AREA (DESCRIPCION)
	VALUES ('DESARROLLO');

	INSERT INTO ZONA (DESCRIPCION)
	VALUES ('DEL VALLE');
	INSERT INTO ZONA (DESCRIPCION)
	VALUES ('NARVARTE');
	INSERT INTO ZONA (DESCRIPCION)
	VALUES ('RELOX');
	INSERT INTO ZONA (DESCRIPCION)
	VALUES ('TORRES');

	INSERT INTO PUESTO (DESCRIPCION)
	VALUES ('COORDINADOR');
	INSERT INTO PUESTO (DESCRIPCION)
	VALUES ('EMPLEADO');

	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('JOSE', 5, 3, 2);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('LUIS', 5, 2, 1);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('RICARDO', 5, 2, 2);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('MIRIAM', 4, 4, 2);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('MAURO', 4, 1, 1);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('ALI', 2, 3, 2);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('GUILLERMO', 2, 2, 1);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('FELIPE', 3, 4, 2);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('JOSUE', 3, 1, 1);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('ISRAEL', 1, 3, 2);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('URIEL', 1, 2, 2);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('CESAR', 1, 1, 2);
	INSERT INTO PERSONAS (NOMBRE, AREA, ZONA, PUESTO)
	VALUES ('EDGAR', 1, 1, 1);
	commit transaction;
end try
begin catch
	rollback transaction
	print error_message();
end catch
/*3. QUERYS*/
--3.1 MOSTRAR A TODOS LOS COORDINADORES
	select 
	pe.*,
	pu.descripcion as descripcion_puesto
	from personas pe
	inner join puesto pu on pe.puesto=pu.id_puesto
	where pe.puesto = 1

--3.2 MOSTRAR A TODAS LAS PERSONAS QUE LABOREN EN LA ZONA DEL VALLE
	select 
	pe.*,
	zo.descripcion as descripcion_zona
	from personas pe
	inner join zona zo on pe.zona=zo.id_zona
	where pe.zona = 1

--3.3 MOSTRA A TODOS LOS EMPLEADOS QUE LABOREN EN LA ZONA NARVARTE
	select 
	pe.*,
	zo.descripcion as descripcion_zona
	from personas pe
	inner join zona zo on pe.zona=zo.id_zona
	where pe.zona = 2

--3.4 MOSTRA A TODAS LAS PERSONAS POR AREA
	select 
	pe.area,
	a.descripcion,
	count(pe.login) total_empleados_por_area
	from personas pe
	inner join area a on pe.area = a.id_area
	group by pe.area,a.descripcion

--3.5 Con un cruce obtener el siguiente resultado
	select 
		pe.nombre,
		pe.login,
		a.descripcion,
		z.descripcion,
		p.descripcion
	from 
	personas pe
	inner join area a on pe.area=a.id_area
	inner join puesto p on pe.puesto=p.id_puesto
	inner join zona z on pe.zona = z.id_zona
	order by login desc

--SP:
--CREAR UN SP CON UN PARAMETRO DE ENTRADA @IDZONA QUE MUESTRE TODOS LAS PERSONAS
--DE LA ZONA INDICADA EN EL PARAMETRO.
create procedure sp_obtenerPersonasPorZona(
	@idZona int = null
)
as
begin
	if exists(select 1 from zona where id_zona = @idZona)
	begin
		select 
		pe.*
		from personas pe
		inner join zona zo on pe.zona=zo.id_zona
		where pe.zona = @idZona
	end
	else
	begin 
		SELECT 'Zona invalida' AS msg;
	end
end
go

-- sp_obtenerPersonasPorZona @idZona=1

/*CREAR UN SP CON UN PARAMETRO DE ENTRADA @PUESTO QUE MUESTRE TODAS LAS PERSONAS
QUE TENGAN EL PUESTO INDICADO EN EL PARAMETRO.*/

create procedure sp_obtenerPersonasPorPuesto(
	@idPuesto int = null
)
as
begin
	if exists(select 1 from puesto where id_puesto = @idPuesto)
	begin
		select 
		pe.*
		from personas pe
		inner join puesto pu on pe.zona=pu.id_puesto
		where pe.puesto = @idPuesto
	end
	else
	begin 
		SELECT 'puesto invalida' AS msg;
	end
end
go

 -- sp_obtenerPersonasPorPuesto @idPuesto=2

 /*columnas dinamicas*/
create procedure sp_analisisPersonasPorArea
as
begin
	declare @query nvarchar(max)
	declare @columns nvarchar(max)  
	select @columns = isnull(@columns+',', ' ')+QUOTENAME(descripcion) 
	from (
		select distinct a.descripcion from area as a
	) as c
	--print(@columns)
	--select @columns

	set @query = 'select 
	''Gente Asignada'' as '' '',
	'+@columns+'
	from (
		select 
		personas.area,
		area.descripcion
		from area
		inner join personas on area.id_area = personas.area 
	) as T 
	pivot(
		count(area)
		for descripcion in ('+@columns+')
	) as p'
	print @query
	exec sp_executesql @query;
end
go

-- sp_analisisPersonasPorArea

select * from area

select 
area.descripcion,
count(personas.login) as cantidad
from 
area
inner join personas on personas.area = area.id_area
group by area.descripcion

select 
'Gente Asignada' as ' ',
[1],[2],[3]
from (
	select 
	area.id_area,
	area.descripcion
	from area
	inner join personas on area.id_area = personas.area 
) as T
pivot(
	count(descripcion)
	for id_area in ([1],[2],[3])
) as p

