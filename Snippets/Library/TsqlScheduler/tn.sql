/*
Scheduler.Task by name
*/

-- https://github.com/taddison/tsqlScheduler
-- select * from scheduler.GetTaskID('$PASTE$', 1);
select * 
from scheduler.Task
where Identifier like '%$PASTE$%';
