/*
session and connection information for a client IP address
*/

$SELECTIONSTART$
select 
    session_id,
    connect_time,
    protocol_type,
    most_recent_sql_handle
from sys.dm_exec_connections
where client_net_address = '$PASTE$';

select 
    session_id,
    login_time,
    [host_name],
    [program_name],
    login_name,
    [context_info],
    last_request_start_time,
    db_name(database_id) as db
from sys.dm_exec_sessions
where session_id in (
    select session_id 
    from sys.dm_exec_connections
    where client_net_address = '$PASTE$'
);
$SELECTIONEND$

