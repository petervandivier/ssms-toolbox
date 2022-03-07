/*
partitioning details with left-right helpers
*/

-- http://sqlity.net/en/2483/partition-boundaries/
declare @obj sysname = '$CURSOR$';

with as_text as (
    select 
        function_id 
        ,boundary_id 
        ,parameter_id 
        ,[value] 
        ,data_type = convert(varchar(50),sql_variant_property([value],'BaseType'))
        ,t_val = isnull(
            case 
                when convert(varchar(50),sql_variant_property([value],'BaseType')) like '%date%'
                    then format(try_cast([value] as date),'yyyy-MM-dd')
                when convert(varchar(50),sql_variant_property([value],'BaseType')) like '%int%' 
                  or convert(varchar(50),sql_variant_property([value],'BaseType')) in ('money','smallmoney','decimal','numeric','float','real')
                    then format(try_cast([value] as int),'#,###') 
                else try_cast([value] as varchar(50))
            end, 'INF' )
    from sys.partition_range_values
), size_by_part as (
    select 
        file_group_name = f.[name],
        p.partition_number,
        size_mb = convert(decimal(10,2),(sum(au.total_pages) * 8192.)/power(1024.,2))
    from sys.partitions p
    join sys.allocation_units au on p.hobt_id = au.container_id 
    join sys.filegroups f on au.data_space_id = f.data_space_id
    where p.[object_id] = object_id(@obj)
    group by f.[name],
        p.partition_number
)
select distinct -- allocation units blows it up ~*3
    sbp.size_mb,
    file_group_name = f.[name],
    table_schema = schema_name(t.[schema_id]),
    table_name = t.[name],
    p.partition_number,
    range_desc = left_prv.t_val
                 +iif(pf.boundary_value_on_right=0,' < ',' <= ')
                 +'X'
                 +iif(pf.boundary_value_on_right=0,' <= ',' < ')
                 +right_prv.t_val,
    range_side=iif(pf.[type]='R','>> RIGHT >>','<< LEFT <<'),
    partition_schem_name = ps.[name],
    partition_function_name = pf.[name],
    left_boundary = convert(date,left_prv.[value]),
    p.[rows],
    right_boundary = convert(date,right_prv.[value])
    --,p.*
    --,au.*
from sys.partitions p
join sys.tables t on p.[object_id] = t.[object_id]
join sys.indexes i 
    on p.[object_id] = i.[object_id]
    and p.index_id = i.index_id
join sys.allocation_units au on p.hobt_id = au.container_id 
    -- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-allocation-units-transact-sql
    --on (p.hobt_id = au.container_id and au.[type] in (1,3))
    --or (p.[partition_id] = au.container_id and au.[type] =2)
join sys.filegroups f on au.data_space_id = f.data_space_id
left join sys.partition_schemes ps on ps.data_space_id = i.data_space_id
left join sys.partition_functions pf on ps.function_id = pf.function_id
left join as_text left_prv 
    on left_prv.function_id = ps.function_id
    and left_prv.boundary_id + 1 = p.partition_number
left join as_text right_prv 
    on right_prv.function_id = ps.function_id
    and right_prv.boundary_id = p.partition_number
full join size_by_part sbp 
    on sbp.partition_number = p.partition_number
    and sbp.file_group_name = f.[name]
where p.[object_id] = object_id(@obj)
    and i.index_id = 1
order by p.partition_number;
