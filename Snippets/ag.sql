/*
Availability Group Details
*/


declare @agName sysname = 'AG$CURSOR$';
declare @agid uniqueidentifier;

select 
    @agName = ag.[name],
    @agid = ag.group_id
from sys.availability_groups ag
where right(ag.[name],3) = @agName;

select [name] = @agName

select * 
from sys.availability_databases_cluster adc 
where adc.group_id = @agid

select ar.replica_server_name,
       ar.owner_sid,
       ar.[endpoint_url],
       mode = ar.[availability_mode],
       mode_desc = ar.availability_mode_desc,
       [failover_mode] = ar.failover_mode_desc,
       ar.create_date,
       ar.modify_date,
       [seed_mode] = ar.seeding_mode_desc  
from sys.availability_replicas ar
where ar.group_id = @agid;

