/*
Growth over time of largest N tables in DB
*/

-- requires TableSizeTracking
declare 
    @db sysname = '$DBNAME$'
    ,@days_back int = 30
    ,@top_n int = 5

;with top_n_for_t as (
    select distinct top (@top_n)
         tst.DatabaseName
        ,tst.SchemaName
        ,tst.TableName 
        ,MaxMb = max(tst.ReservedMB)
    from DBAdmin.Logs.TableSizeTracking tst
    where tst.DatabaseName = @db
        and tst.LogDateTime > dateadd(day,-7,getdate())
    group by
        tst.DatabaseName
        ,tst.SchemaName
        ,tst.TableName 
    order by MaxMb desc
)
select top(1000) 
    dt = convert(date,LogDateTime)
   ,h = datepart(hour,tst.LogDateTime)
   ,tst.DatabaseName
   ,tst.SchemaName
   ,tst.TableName
   ,MaxMB = max(tst.ReservedMB)
from DBAdmin.Logs.TableSizeTracking tst
join top_n_for_t tn 
    on tn.DatabaseName = tst.DatabaseName
    and tn.SchemaName = tst.SchemaName
    and tn.TableName = tst.TableName
where tst.DatabaseName = @db
    and tst.LogDateTime > dateadd(day,-@days_back,getdate())
group by 
    convert(date,LogDateTime)
   ,datepart(hour,tst.LogDateTime)
   ,tst.DatabaseName
   ,tst.SchemaName
   ,tst.TableName
order by 
    dt desc
   ,h desc
