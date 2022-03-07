/*
whoIsActiveLogging - long running queries
*/


declare 
	 @start datetime2 = ''
	,@end   datetime2 = '$DATE$ $TIME$'
	,@topN  tinyint   = 10;
;with top_N as(
    select 
        collection_time,
        [dd hh:mm:ss.mss],
        id = row_number() over (
                partition by collection_time
                order by 
                	try_convert(tinyint,left([dd hh:mm:ss.mss],2)) desc,
                	try_convert(time,stuff([dd hh:mm:ss.mss],1,3,'')) desc )
    from DBAdmin.logs.WhoIsActiveLogging 
    where collection_time between @start and @end
        -- and session_id not in (341,872)
)
select * 
from top_N 
join DBAdmin.logs.WhoIsActiveLogging wial 
    on wial.collection_time = top_N.collection_time
    and wial.[dd hh:mm:ss.mss] = top_N.[dd hh:mm:ss.mss]
where top_N.id < @topN 
order by wial.collection_time desc, wial.[dd hh:mm:ss.mss] desc
