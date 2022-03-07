/*
Unique range of date+time bounds in a ##Global_Temp_Table
*/


drop table if exists ##batch_bounds_$MACHINE$; -- <-- careful with ##globals
create table ##batch_bounds_$MACHINE$ (
     start_dt datetime2(3) not null primary key
    ,end_dt   datetime2(3) not null unique
    ,check (end_dt > start_dt) 
);

with date_range as (
    select cast('$start_date$' as datetime2) as dt
    union all 
    select dateadd(day,1,dt)
    from date_range
    where dt<'$DATE$'
), plus_some as ( -- manual additions to range
   select dt from date_range
   --union select '1753-01-01'
   --union select '$DATE$'
), _hours as (
	select 0 h
	union all 
	select h+$hours$
	from _hours
	where h<(24-$hours$)
), hour_rng as (
    select _start = dateadd(hour,h.h,ps.dt)
    from plus_some ps
    cross join _hours h
)
insert ##batch_bounds_$MACHINE$ (start_dt, end_dt)
select _start, convert(datetime2(3),dateadd(hour,$hours$,_start))
from hour_rng
option (maxrecursion 0);

select * from ##batch_bounds_$MACHINE$;
