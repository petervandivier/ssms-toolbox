/*
Master Files
*/

$SELECTIONSTART$
drop table if exists #fullness;
create table #fullness (
     database_id int not null
    ,fname sysname 
    ,space_used_mb float
)
insert #fullness (database_id, fname, space_used_mb)
exec sys.sp_MSforeachdb N'use [?]
select 
    mf.database_id
    ,mf.[name]
    ,(try_cast(fileproperty(mf.[name],''SpaceUsed'') as int) * 8192.) / power(1024.,2)
from sys.master_files mf
where db_name(mf.database_id) in (''?'')
'; -- select * from #fullness f

select [dbid]=mf.database_id
      ,mf.[type_desc]
      ,mf.[name]
      ,mf.physical_name
      ,mf.state_desc
      ,size_mb=try_convert(float,(mf.size*8192.)/power(1024,2))
      ,f.space_used_mb
      ,max_size_mb=try_convert(float,(nullif(mf.max_size,-1)*8192.)/power(1024,2))
      ,pct_full = try_convert(decimal(10,4),f.space_used_mb / ((mf.size*8192.)/power(1024,2)))*100.
      ,growth_mb=case mf.is_percent_growth when 1 then (mf.growth/100.)*try_convert(float,(mf.size*8192.)/power(1024,2)) else try_convert(float,(mf.growth*8192.)/power(1024,2)) end
      ,pct=mf.is_percent_growth
      ,diff_age_time=convert(time(0),dateadd(second,datediff(second,mf.differential_base_time,getutcdate()),0))
      ,diff_age_days=datediff(day,mf.differential_base_time,getutcdate())
from sys.master_files mf
join #fullness f 
    on f.database_id = mf.database_id 
    and f.fname = mf.[name]
where db_name(mf.database_id) in ('$DBNAME$')
$SELECTIONEND$
