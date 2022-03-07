/*
Count number of records returned by query
*/


-- select count_big(*) as cs from $table$; 
select obj=object_schema_name([object_id])+'.'+object_name([object_id])
      ,sum(row_count) as cs
from sys.dm_db_partition_stats
where (index_id = 0 or index_id = 1)
    and try_cast(objectproperty([object_id],'IsUserTable') as bit)=1
    and [object_id] = object_id('$table$')
group by [object_id];

