/*
Cache sp_who2 and transform [LastBatch] to DateTime datatype
*/


drop table if exists #spwho2;

create table #spwho2 (
    SPID        int not null,
    [Status]    nvarchar(128),
    [Login]     nvarchar(128),
    HostName    nvarchar(128),
    BlkBy       nvarchar(128),
    DBName      nvarchar(128),
    Command     nvarchar(128),
    CPUTime     bigint,
    DiskIO      bigint,
    LastBatch   nvarchar(128),
    ProgramName nvarchar(1000),
    _SPID       int,
    RequestID   int
);

insert #spwho2 ( 
    SPID, Status, Login, HostName,
    BlkBy, DBName, Command, CPUTime,
    DiskIO, LastBatch, ProgramName,
    _SPID, RequestID )
exec sys.sp_who2;

update #spwho2 set LastBatch = replace( replace( convert(char(4), year(getutcdate())) + '/' + LastBatch, ' ', 'T'), '/', '-');
alter table #spwho2 alter column LastBatch datetime;

select *, t.[text]
from   #spwho2 s
join dbo.sysprocesses p on p.spid = s.SPID
outer apply sys.dm_exec_sql_text(p.[sql_handle]) t
where s.SPID > 50
--    and s.[Login] = '$USER$'
--    and s.HostName = '$MACHINE$'
--    and s.DBName = '$DBNAME$'

