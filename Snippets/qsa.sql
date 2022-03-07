/*
Query Store ad-hoc
*/

-- execute on secondary to avoid polluting the stats
select top 100 
    qt.query_text_id,
    qt.query_sql_text,
    qt.statement_sql_handle,
    qt.is_part_of_encrypted_module,
    qt.has_restricted_text 
from sys.query_store_query_text as qt
where qt.query_sql_text like '%cdc%'
  and qt.query_sql_text like '%delete%'
  and qt.query_sql_text like '%Listing%';

select * 
from sys.query_store_query q
where q.query_text_id = 15009901;

select * 
from sys.query_store_plan as p
where p.query_id = 764901342;
