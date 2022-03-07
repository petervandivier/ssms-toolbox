/*
Dummy Table
*/

drop table if exists $table_name$;
create table $table_name$ (
	i int not null identity primary key,
	uuid uniqueidentifier,
	vchar varchar(36),
	num int,
	bool bit,
	dt datetime2
);

