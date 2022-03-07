/*
Databases that are the PRIMARY replica or LOCAL on this instance, exclude FORWARDERs
*/

select 
    ars.role_desc
   ,ag_name = ag.[name]
   ,adc.[database_name]
from sys.availability_groups ag 
join sys.dm_hadr_availability_replica_states ars on ars.group_id = ag.group_id
join sys.availability_databases_cluster adc on adc.group_id = ag.group_id
where ars.is_local = 1
    and ars.role_desc = 'PRIMARY'
    and not exists (
        select 1
        from sys.availability_groups dag 
        join sys.availability_replicas fwd on fwd.group_id = dag.group_id
        join sys.availability_groups ag2 on ag2.name = fwd.replica_server_name
        join sys.availability_databases_cluster db on db.group_id = ag2.group_id
        where dag.is_distributed = 1
            and db.[database_name] = adc.[database_name]
)
union all 
select 
    'LOCAL_ONLY'
   ,@@servername
   ,[name]
from sys.databases d 
where not exists (
    select 1 
    from sys.availability_databases_cluster adc
    where adc.[database_name] = d.[name]
);
