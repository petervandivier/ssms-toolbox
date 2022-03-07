/*
Get size of all tables in DB
*/

-- https://stackoverflow.com/a/7892349/4709762
;with hobt as (
    select 
         hobt_idx_id = min(i.index_id)
        ,i.[object_id]
    from sys.indexes i
    group by i.[object_id]
)
select TableName     = object_schema_name(t.[object_id])+'.'+object_name(t.[object_id])
      ,RowCounts     =  sum(p.rows)
      ,TotalSpaceKB  =  sum(a.total_pages)*8
      ,TotalSpaceMB  = (sum(a.total_pages)*8)/1024.
      ,UsedSpaceKB   =  sum(a.used_pages) *8
      ,UsedSpaceMB   = (sum(a.used_pages) *8)/1024.
      ,UnusedSpaceKB = (sum(a.total_pages)-sum(a.used_pages))*8
      ,UnusedSpaceMB = (sum(a.total_pages)-sum(a.used_pages))*8/1024.
from sys.tables t
join sys.indexes i on t.[object_id] = i.[object_id]
join hobt h 
    on i.[object_id] = h.[object_id]
    and i.index_id = h.hobt_idx_id
join sys.partitions p 
    on i.[object_id] = p.[object_id]
    and i.index_id = p.index_id
join sys.allocation_units a on p.[partition_id] = a.container_id
left join sys.schemas s on t.[schema_id] = s.[schema_id]
where t.[name] not like 'dt%'
    and t.is_ms_shipped = 0
    and i.[object_id] > 255
group by t.[object_id]
order by TotalSpaceMB desc;

