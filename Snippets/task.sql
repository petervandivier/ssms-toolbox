/*
scheduler task and execution by identifier
*/

select * 
from scheduler.Task for system_time all
where Identifier = '$PASTE$'
order by SysEndTime desc;

select 
    est = StartDateTime at time zone 'UTC' at time zone 'Eastern Standard Time',
    duration_minutes = datediff(minute,StartDateTime,EndDateTime),
    * 
from scheduler.TaskExecution
where TaskUid = (
    select TaskUid 
    from scheduler.Task 
    where Identifier = '$PASTE$'
)
order by StartDateTime desc;
