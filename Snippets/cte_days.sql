/*
90 days worth of days
*/

;with day_rng as (
    select cast(getdate() as date) as dt
    union all 
    select dateadd(day,-1,dt)
    from day_rng
    where dt>dateadd(day,-90,getdate())
)
select *
from day_rng
