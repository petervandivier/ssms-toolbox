/*
Task Execution Log
*/

-- https://github.com/taddison/tsqlScheduler
declare @dt datetime2(3) = '$DATE$ $TIME$';

;with last_run as (
    select id=max(ExecutionID), taskId
    from scheduler.TaskExecution 
    where TaskId in ($CURSOR$)
    group by TaskId
)
select top (100) 
	DurationMin = datediff(minute
                          ,te.StartDateTime
                          ,iif(te.EndDateTime is null and te.ExecutionID = lr.ID
                              ,getutcdate()
                              ,te.EndDateTime))
	,* 
from scheduler.TaskExecution te
join last_run lr on lr.taskID = te.TaskID
--where (te.IsError = 1 or te.EndDateTime is null)  
	-- and te.StartDateTime between dateadd(hour,-2,@dt) and dateadd(hour,2,@dt)
order by te.StartDateTime desc;	
