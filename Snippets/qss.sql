/*
Search query store by query text. Return plans & aggregated runtime stats.
*/

-- fuzzy match sql_text in query store
-- if an RO replica exists, execute there avoid polluting query_store_query_text

drop table if exists #qs_stats;

-- find query in query store
select
    q.query_id,
    qt.query_text_id,
    q.last_execution_time,
    qt.query_sql_text,
    q.query_hash,
    q.query_parameterization_type_desc,
    q.initial_compile_start_time,
    q.last_compile_start_time,
    q.last_compile_batch_sql_handle,
    q.count_compiles,
    round(q.avg_compile_duration, 2) as avg_compile_duration, -- https://stackoverflow.com/a/1262571/4709762
    q.last_compile_memory_kb,
    q.max_compile_memory_kb
into #qs_stats
from sys.query_store_query as q
inner join sys.query_store_query_text as qt on q.query_text_id = qt.query_text_id
where qt.query_sql_text like '%%'
    --and qt.query_sql_text like '%%'
;

select *
from #qs_stats;

/*
query_id(s):
- 
- 
*/
go
drop table if exists #qs_agg;

-- run counts for all plans
-- strips tz from start_time (always utc) 
--   to something you can use in Excel
select
    s.query_id,
    convert(datetime2(0), rsi.start_time) as start_datetime_utc,
    sum(rs.count_executions) as count_executions,
    round(avg(rs.avg_cpu_time) / 1e6, 2) as avg_cpu_time_sec,
    round(avg(rs.avg_duration) / 1e6, 2) as avg_duration_sec,
    round(sum(rs.avg_cpu_time * rs.count_executions) / 1e6, 2) as total_cpu_time_sec
into #qs_agg
from sys.query_store_runtime_stats as rs
join sys.query_store_runtime_stats_interval as rsi on rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
join sys.query_store_plan as p on p.plan_id = rs.plan_id
join #qs_stats as s on s.query_id = p.query_id
group by 
    s.query_id,
    rsi.start_time
;

select
    a.*,
    s.*
from #qs_stats as s
join #qs_agg as a on a.query_id = s.query_id
order by a.start_datetime_utc desc;
go

