/*
cache xp_readerrorlog to table & selectively exclude log spam
*/


drop table if exists #xper;
create table #xper (
    id int identity primary key, 
    LogNo tinyint, 
    LogDate datetime, 
    ProcessInfo nvarchar(12), 
    [Text] nvarchar(850) index x_text -- max NCI key length 1700 bytes
);

declare @i tinyint = 0;
while @i < 3
begin;
    insert #xper (LogDate, ProcessInfo, [Text])
    exec xp_readerrorlog @i;
    update #xper set LogNo = @i where LogNo is null; 
    set @i += 1;
end;
--select count(*) from #xper

select 
    est = LogDate at time zone 'UTC' at time zone 'Eastern Standard Time',
    * ,
    ','''+replace(left([Text],21),'''','''''')+'''' as ExcludeStub
from #xper
where -- LogDate >= '$DATE$' and 
    left([Text],21) not in (
         '[INFO] Database ID: [' -- SB spam
        ,'DBCC TRACEOFF 3604, s' -- SQLPrompt
        ,'DBCC TRACEON 3604, se' -- SQLPrompt
        ,'The activated proc ''[' -- moar SB spam
        ,'SQL Trace stopped. Tr'
    )
-- select top(1) [text] from sys.messages where language_id = 1033 and message_id = 33308
    and [Text] not like 'The queue % in database % has activation enabled and contains unlocked messages but no RECEIVE has been executed for % seconds.' -- SB spam
    and [Text] not like 'SQL Trace ID % was st%'
order by LogDate desc, id desc;


