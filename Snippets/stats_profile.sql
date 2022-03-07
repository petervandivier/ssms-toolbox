/*
Live rowcount & batch stats for long-running session
*/

-- set statistics profile on; <-- in remote session, as needed

select      p.node_id
           ,p.physical_operator_name
           ,sum(p.row_count) row_count
           ,sum(p.estimate_row_count) as estimate_row_count
           ,cast(sum(p.row_count) * 100 as float) / sum(nullif(p.estimate_row_count, 0)) as pct_complete
from        sys.dm_exec_query_profiles p
where       p.session_id = $CURSOR$
group by    p.node_id ,p.physical_operator_name
order by    p.node_id;

