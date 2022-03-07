/*
create table foo()
*/

--drop table if exists foo;
create table foo ( 
    i int identity not null primary key,
    bar varchar(10)
);
