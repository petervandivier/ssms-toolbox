use [$db_name$]
go

select 
    concat(
        object_schema_name(i.[object_id]),
        N'.',
        object_name(i.[object_id])
    ) as schema_table_name,
    i.[name] as index_name,
    ius.*
from sys.dm_db_index_usage_stats as ius
join sys.indexes as i 
    on i.index_id = ius.index_id
    and i.[object_id] = ius.[object_id]
where ius.[object_id] = object_id(N'$schema_table_name$')
    and i.[name] = N'$index_name$';
