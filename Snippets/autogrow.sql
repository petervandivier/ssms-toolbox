/*
Get autogrowth actions from the default trace
*/


declare @path nvarchar(260);
select @path = reverse(substring(reverse([path])
                                ,charindex('\',reverse([path]))
                                ,260)
                      )+N'log.trc'
from sys.traces
where is_default = 1;

select
     DatabaseID
    ,NTDomainName
    ,HostName
    ,ClientProcessID
    ,ApplicationName
    ,LoginName
    ,[SPID]
    ,Duration
    ,StartTime
    ,EndTime
    ,IntegerData
    ,ServerName
    ,EventClass
    ,DatabaseName
    ,[FileName]
    ,LoginSid
    ,EventSequence
    ,SessionLoginName
from sys.fn_trace_gettable(@path, default)
where EventClass in (92, 93)
    and StartTime > dateadd(hour,-24,getdate());

