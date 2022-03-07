/*
partition function utility 1
*/

select
    [filegroup_name] = fg.[name],
    [schema_name] = object_schema_name(t.[object_id]),
    table_name = t.[name],
    i.index_id,
    index_name = i.[name],
    scheme_name = ps.[name],
    function_name = pf.[name],
    p.partition_number,
    prv.[value],
    [rows] = format(p.[rows], '#,###')
from sys.tables t
inner join sys.indexes i on t.[object_id] = i.[object_id]
inner join sys.partitions p 
    on i.[object_id] = p.[object_id]
    and i.index_id = p.index_id
left join sys.partition_schemes ps on i.data_space_id = ps.data_space_id
left join sys.partition_functions pf on pf.function_id = ps.function_id
left join sys.partition_range_values prv 
    on prv.function_id = ps.function_id
    and prv.boundary_id = p.partition_number
left join sys.destination_data_spaces dds 
    on ps.data_space_id = dds.partition_scheme_id
    and p.partition_number = dds.destination_id
inner join sys.filegroups fg on coalesce(dds.data_space_id, i.data_space_id) = fg.data_space_id
