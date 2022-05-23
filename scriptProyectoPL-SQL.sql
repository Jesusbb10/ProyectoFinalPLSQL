/*Creacion de las tablas*/
create table estudiante(
    id      number(2),
    nombre  varchar2(10),
    apellido   varchar2(15),
    curso       varchar2(2)
);


create table prestamos(
   id       number(1),
   idEstudiante number(2),
   idLibro      number(2),
   fecha_prestamo  date,
   fecha_devolucion  date
);


create table libros (
    id           number(1),
    titulo      varchar2(40),
    idAutor    number(2),
    idEditorial   number(2)
);

create table editoriales (
    id      number(2),
    nombre  varchar2(15)
);

create table autores (
    id      number(2),
    nombre  varchar2(10),
    apellido varchar2(15)
);


/*Claves primarias*/
alter table estudiante add constraint est_id_pk primary key(id);
alter table prestamos add constraint pre_id_pk primary key(id);
alter table libros add constraint lib_id_pk primary key(id);
alter table editoriales add constraint edi_id_pk primary key(id);
alter table autores add constraint aut_id_pk primary key(id);

/*Claves foraneas*/
alter table prestamos add constraint pre_est_fk foreign key (idEstudiante) references estudiante;
alter table prestamos add constraint pre_lib_fk foreign key (idLibro) references libros;
alter table libros add constraint lib_edi_fk foreign key (idEditorial) references editoriales;
alter table libros add constraint lib_aut_fk foreign key (idAutor) references autores;

/*Restricciones*/
alter table prestamos add constraint pre_fec_ck check(fecha_prestamo < fecha_devolucion);


/*Insersión de datos en las tablas*/

/*Tabla Estudiante*/
insert into estudiante 
values (10, 'Jesus', 'Baglietto', '1A');
insert into estudiante 
values (11, 'Chema', 'Rodriguez', '1A');
insert into estudiante 
values (12, 'Lucia', 'Hidalgo', '1A');
insert into estudiante 
values (13, 'Angel', 'Heredia', '2B');
insert into estudiante 
values (14, 'Marina', 'Marin', '2B');
insert into estudiante 
values (15, 'Luis', 'Perez', '2B');
insert into estudiante 
values (16, 'Maria', 'Gomez', '2B');

/*Tabla Editoriales*/
insert into editoriales 
values(20, 'Planeta');
insert into editoriales 
values(30, 'ANAYA');
insert into editoriales 
values(40, 'Santillana');
insert into editoriales 
values(50, 'Remolino');
insert into editoriales 
values(60, 'Algarabía');


/*Tabla Autores*/
insert into autores 
values(10, 'J.K', 'Rowling');
insert into autores 
values(20, 'Jane', 'Austen');
insert into autores 
values(30, 'Jeff', 'Kinney');
insert into autores 
values(40, 'Dante', 'Alighieri');
insert into autores 
values(50, 'J.R.R', 'Tolkien');
insert into autores 
values(60, 'Ana', 'Frank');

/*Tabla Libros*/
insert into libros 
values(1, 'Harry Potter', 10, 40);
insert into libros 
values(2, 'Orgullo y prejuicio', 20, 20);
insert into libros 
values(3, 'Diario de greg', 30, 50);
insert into libros 
values(4, 'Divina Comedia', 40, 20);
insert into libros 
values(5, 'El señor de los anillos', 50, 60);
insert into libros 
values(6, 'Diario de Ana Frank', 60, 40);


/*Tabla Prestamo*/
insert into prestamos
values (1, 10, 1, '23/05/2022', '02/06/2022');
insert into prestamos
values (2, 11, 2, '10/05/2022', '21/05/2022');
insert into prestamos
values (3, 12, 1, '01/05/2022', '04/05/2022');
insert into prestamos
values (4, 13, 4, '27/05/2022', null);
insert into prestamos
values (5, 14, 5, '29/05/2022', '07/06/2022');
insert into prestamos
values (6, 15, 3, '21/04/2022', '12/05/2022');
insert into prestamos
values (7, 16, 6, '03/02/2022', '02/04/2022');


/*Procedimientos PLQSL*/
/*Procedimiento que muestra el titulo de un libro pasando su id*/
create or replace procedure mostrar_libros(idLibro libros.id%type)
as
cursor titulo_lib is
select titulo from libros
where id = idLibro;

begin
 for registro in titulo_lib loop
 dbms_output.put_line(registro.titulo);
end loop;
 

end mostrar_libros;
/

exec mostrar_libros(2);

/*Procedimiento que actualiza una columna de la tabla estudiantes mediante un id*/
create or replace procedure actualizar_estudiantes(idEst estudiante.id%type, nombreEst estudiante.nombre%type, apellidoEst estudiante.apellido%type, cursoEst estudiante.curso%type)
as

begin

update estudiante 
set nombre = nombreEst, apellido = apellidoEst, curso = cursoEst
where id = idEst;

end actualizar_estudiantes;
/

BEGIN
 actualizar_estudiantes(10, 'Javier', 'Bueno', '1B');
END;
/


/*Funciones PLSQL*/
/*Funcion que muestra el titulo del libro que ha alquilado el estudiante pasado por parametros*/
create or replace function mostrar_alquiler(idEst estudiante.id%type)
return varchar2
as
cursor alquiler is
select titulo, nombre from libros lib, estudiante est, prestamos pr
where est.id = idEst and est.id = pr.idEstudiante and pr.idLibro = lib.id;

begin
 for registro in alquiler loop
 return registro.titulo;
end loop;

end mostrar_alquiler;
/
select mostrar_alquiler(10) from dual;

/*Función que muestra el nombre de la editorial que tiene el libro pasado por parametros*/

create or replace function mostrar_editorial(idLibro libros.id%type)
return varchar2
as
cursor c_editorial is
select nombre, titulo from libros lib, editoriales edi
where lib.id =idLibro and edi.id = lib.idEditorial;

begin

 for registro in c_editorial loop
 return registro.nombre;

end loop;

end mostrar_editorial;
/
select mostrar_editorial(6) from dual;


/*Bloque Anónimo*/

declare
alquiler varchar2(40);
editorial varchar2(15);
begin 
dbms_output.put_line('El titulo del libro es: ');
mostrar_libros('&idLibro');
dbms_output.put_line('');
actualizar_estudiantes('&id', '&nombre', '&apellido', '&curso');
dbms_output.put_line('Estudiante actualizado');
dbms_output.put_line('');
select mostrar_alquiler('&idEstudiante') into alquiler from dual;
dbms_output.put_line('');
select mostrar_editorial('&idLibro') into editorial from dual;
end;
/
