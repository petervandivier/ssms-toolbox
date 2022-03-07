/*
AG Details by DB Name
*/


declare 
    @dbName sysname = '$CURSOR$',
    @agid uniqueidentifier,
    @agName sysname;

select @agid = adc.group_id
from sys.availability_databases_cluster adc
where adc.[database_name] = @dbName;

select * 
from sys.availability_databases_cluster adc 
where adc.group_id = @agid

select [name] 
from sys.availability_groups
where group_id = @agid;

select ar.replica_server_name,
       ar.owner_sid,
       ar.[endpoint_url],
       mode = ar.[availability_mode],
       mode_desc = ar.availability_mode_desc,
       [failover_mode] = ar.failover_mode_desc,
       ar.create_date,
       ar.modify_date,
       [seeding_mode] = ar.seeding_mode_desc 
from sys.availability_replicas ar
where ar.group_id = @agid;

