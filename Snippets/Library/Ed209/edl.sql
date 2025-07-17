/*
Search the ED209 log
*/

select 
    est = LogDateTime at time zone 'UTC' at time zone 'Eastern Standard Time',
    LogDateTime,
    Spid,
    recipients,
    [Subject],
    [Message],
    IsKill,
    ExtraInfo
from DBAdmin.ED209.Logs 
where [Message] like '%$PASTE$%'
  and IsKill = 1
order by LogDateTime desc;
