/*
Log space trend versus what it was a few seconds ago
*/

$SELECTIONSTART$-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-sqlperf-transact-sql
drop table if exists #sqlperf_logspace;
create table #sqlperf_logspace (
    id         int not null identity primary key,
    db sysname unique,
    size_mb    decimal(10,2),
    pct_full   decimal(10,2),
    _status    tinyint check (_status=0)
);

insert #sqlperf_logspace (db,size_mb,pct_full,_status)
exec (N'dbcc sqlperf(logspace);');

if object_id('tempdb..#log_snap') is null
begin;
    select *, getutcdate() as snap_dt 
    into #log_snap
    from #sqlperf_logspace sl
end;

;with log_delta as (
    select sl.*
        , sl.pct_full - ls.pct_full as pct_growth
        , datediff(second,ls.snap_dt,getutcdate()) as delta_sec
    from #sqlperf_logspace sl
    join #log_snap ls on ls.db = sl.db
)
select *
    , convert(decimal(10,2),((100.-pct_full)/nullif(pct_growth,0)) * ld.delta_sec/60.) as min_to_full
from log_delta ld
where ((100.-pct_full)/nullif(pct_growth,0)) * ld.delta_sec/60. > 0
   and ld.pct_full > 10
order by ld.pct_full desc;
$SELECTIONEND$
