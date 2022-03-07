/*
Shrink a log file by batch
*/

use $DBNAME$
go

declare 
    @cur_size int ,
    @good_size int --= $target_size_mb$
    ,@log_file_name sysname;

select 
	@cur_size = (size*8192.)/power(1024.,2)
	,@log_file_name = [name]
from sys.master_files 
where database_id = db_id(db_name())
    and [type] = 1;

with steps as (
    select cur_size = @cur_size
    union all 
    select cur_size - 1024
    from steps
    where cur_size > isnull(@good_size,@cur_size * 0.5)
)
select order_by='/*0*/	',batch_cmd='use ['+db_name()+']
go'
select 
     order_by = '/*'+ltrim(str(row_number() over (order by cur_size desc)))+'*/'
    ,batch_cmd = 'dbcc shrinkfile('+@log_file_name+',size='+ltrim(str(cur_size))+');
go'
from steps
order by cur_size desc;

