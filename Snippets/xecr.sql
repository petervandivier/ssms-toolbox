/*
Extended Event Consumption (RDS)
*/

print @@servername -- 
print getutcdate() -- 

select                     -- (duration)
    count(*),              -- 
    min(rf.timestamp_utc), -- 
    max(rf.timestamp_utc)  -- 
from sys.fn_xe_file_target_read_file('D:\rdsdbdata\Log\$prefix$*', null, null, null) as rf 

drop table if exists #xe;

select --top 10 
    rf.[object_name],
    rf.timestamp_utc,
    convert(decimal(10,2),null) as duration_ms,
    event_data as text_data,
    try_convert(xml,rf.event_data) as xml_data,
    rf.[file_name],
    left(
        right(
            rf.[file_name],
            22
        ),
        18
    ) as windows_filetime
into #xe
FROM sys.fn_xe_file_target_read_file('D:\rdsdbdata\Log\$prefix$*', null, null, null) as rf;

--alter table #xe add duration_ms decimal(10,2);
update #xe set
    duration_ms = round(xml_data.value('(/event/data[@name="duration"]/value)[1]','bigint') / 1000.0,2)
;

select top 10 * 
from #xe;
