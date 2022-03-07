/*
Query Store Execution Counts by Obj Name
*/

select top (100) 
    obj=object_schema_name([object_id])+'.'+object_name([object_id])
   ,s.runtime_stats_id
   ,s.plan_id
   ,s.first_execution_time
   ,s.last_execution_time
   ,s.count_executions
   ,p.query_id
   ,p.plan_group_id
from sys.query_store_runtime_stats s
join sys.query_store_plan p on p.plan_id = s.plan_id
join sys.query_store_query q on q.query_id = p.query_id
where q.[object_id] in ( 
     object_id('$CURSOR$')--,object_id('')
);
