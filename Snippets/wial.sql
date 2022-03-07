/*
whoIsActiveLogging by session id
*/

select top (100) 
    est = collection_time at time zone 'UTC' at time zone 'Eastern Standard Time'
   ,*
from DBAdmin.logs.WhoIsActiveLogging 
-- where convert(nvarchar(max),sql_text) like '%$CURSOR$%'
	-- and collection_time < '$DATE$ '
	-- and session_id in ()
order by collection_time desc; 
