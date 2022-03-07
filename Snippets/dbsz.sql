/*
Sizes for all Dbs
*/

;with fs as (
    select 
        database_id, 
        [type], 
        size = size * 8.0 / 1024 
    from sys.master_files
)
select
    db = db_name(pvt.database_id),
    [0]+[1]+isnull([2],0) as total_size_mb,
    [0] as data_file_size_mb,
    [1] as log_file_size_mb,
    [2] as filestream_size_mb
from fs
pivot (sum(size) for [type] in ([2],[1],[0]))pvt
order by ([0]+[1]+isnull([2],0)) desc;
