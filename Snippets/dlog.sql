/*
dbcc sqlperf(logspace)
*/

-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-sqlperf-transact-sql
drop table if exists #sqlperf_logspace;
create table #sqlperf_logspace (
    id         int not null identity primary key,
    db sysname unique,
    size_mb    decimal(10,4),
    pct_full   decimal(10,4),
    _status    tinyint check (_status=0)
);

insert #sqlperf_logspace (db,size_mb,pct_full,_status)
exec (N'dbcc sqlperf(logspace) with no_infomsgs;');

select sl.*, d.log_reuse_wait_desc, d.recovery_model_desc 
from #sqlperf_logspace sl
left join sys.databases d on d.[name] = sl.db
order by pct_full desc;

