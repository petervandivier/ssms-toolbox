/*
Task(s) by name - all scheduler DBs
*/

declare @t table ( db sysname, task sysname, cmd nvarchar(4000), e bit, d bit);

insert @t (db, task, cmd, e, d)
exec sys.sp_MSforeachdb N'use [?]
if schema_id(''scheduler'') is not null 
    select db_name(), identifier, tsqlCommand, isEnabled, isDeleted
    from scheduler.Task
    where Identifier like ''%$PASTE$$CURSOR$%'';
';
select * from @t
