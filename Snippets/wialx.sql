/*
WhoIsActiveLogging - for export
*/

select top (100) 
    event_bst = convert(datetime,(collection_time at time zone 'UTC') at time zone 'GMT Standard Time')
   ,[dd hh:mm:ss.mss]
   ,session_id
   ,sql_text = left(convert(varchar(max),sql_text),1000)
   ,login_name
   ,wait_info
   ,CPU = convert(bigint,replace(CPU,',',''))
   ,tempdb_allocations =convert(bigint,replace(tempdb_allocations,',',''))
   ,tempdb_current =convert(bigint,replace(tempdb_current,',',''))
   ,blocking_session_id
   ,blocked_session_count=convert(bigint,replace(blocked_session_count,',',''))
   ,reads=convert(bigint,replace(reads,',',''))
   ,writes=convert(bigint,replace(writes,',',''))
   ,physical_reads=convert(bigint,replace(physical_reads,',',''))
   ,used_memory=convert(bigint,replace(used_memory,',',''))
   ,status
   ,open_tran_count=convert(bigint,replace(open_tran_count,',',''))
   ,percent_complete=convert(decimal(10,2),percent_complete)
   ,host_name
   ,database_name
   ,program_name
   ,start_time
   ,login_time
   ,request_id
   ,collection_time
from DBAdmin.logs.WhoIsActiveLogging 
--where convert(time,collection_time) between '08:00' and '08:45'
--and collection_time >= '2018-05-11'
order by collection_time desc; 
