/*
Get-DbaDiskSpace
*/

select distinct
    vs.volume_mount_point,
    vs.file_system_type,
    format( vs.total_bytes / power(1024.,3), 'N') as total_size_gb,
    format( (vs.total_bytes - vs.available_bytes)/ power(1024.,3), 'N') as used_space_gb,
    format( vs.available_bytes / power(1024.,3), 'N') as available_gb,
    format( 100. * vs.available_bytes / vs.total_bytes , 'N' ) as space_free_pct
from sys.master_files as f 
cross apply sys.dm_os_volume_stats(f.database_id, f.[file_id]) as vs;
