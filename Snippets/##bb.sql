/*
Unique range of date simple bounds in a ##Global_Temp_Table
*/


drop table if exists ##batch_bounds_$MACHINE$; -- <-- careful with ##globals
create table ##batch_bounds_$MACHINE$ (
     start_dt datetime2(3) not null primary key
    ,end_dt   datetime2(3) not null unique
    ,check (end_dt > start_dt) 
);

with date_range as (
    select cast('$start$' as datetime2) as dt
    union all 
    select dateadd(month,1,dt)
    from date_range
    where dt<'$DATE$'
), plus_some as ( -- manual additions to range
    select _start = dt 
          ,_end = convert(datetime2(3),dateadd(month,1,dt))
    from date_range
    --union all select '1753-01-01','2013-01-01'
    --union all select '2020-12-01','9999-01-01'
)
insert ##batch_bounds_$MACHINE$ (start_dt, end_dt)
select _start, _end
from plus_some
option (maxrecursion 0);

select * from ##batch_bounds_$MACHINE$;
