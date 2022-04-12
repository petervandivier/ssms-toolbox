/*
SqlChecks:Get-OversizeIndexes
*/

select
    db_name() as DatabaseName,
    schema_name(o.schema_id) as 'SchemaName',
    o.name as TableName,
    i.name as IndexName,
    i.type_desc as IndexType,
    sum(max_length) as RowLength,
    count(ic.index_id) as 'ColumnCount'
from sys.indexes i (nolock)
inner join sys.objects o (nolock) on i.object_id = o.object_id
inner join sys.index_columns ic (nolock) on ic.object_id = i.object_id
                                        and ic.index_id = i.index_id
inner join sys.columns c (nolock) on c.object_id = ic.object_id
                                 and c.column_id = ic.column_id
where o.type = 'U'
  and i.index_id > 0
  and ic.is_included_column = 0
group by o.schema_id,
         o.object_id,
         o.name,
         i.object_id,
         i.name,
         i.index_id,
         i.type_desc
having (sum(max_length) > case when i.type_desc = 'NONCLUSTERED' then 1700 else
                                                                               900 end
)
order by 1,
         2,
         3;
