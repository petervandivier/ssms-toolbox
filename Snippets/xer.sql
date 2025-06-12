/*
Create but do not start a new RDS XE on executions fuzzy matching input text
*/

/*
trace executions of SQL Text based on a fuzzy match
creates an XE logging to the default RDS location
does not start the XE
*/
create event session [$XE_NAME$]
    on server
    add event sqlserver.exec_prepared_sql (
        action (
            sqlserver.client_app_name,
            sqlserver.client_hostname,
            sqlserver.database_id,
            sqlserver.[database_name],
            sqlserver.nt_username,
            sqlserver.query_hash_signed,
            sqlserver.server_principal_name,
            sqlserver.[session_id],
            sqlserver.sql_text,
            sqlserver.tsql_stack,
            sqlserver.username
        )
        where (
            sqlserver.[database_name] = N'$DB_NAME$'
            and package0.equal_boolean(sqlserver.is_system, 0)
            and sqlserver.like_i_sql_unicode_string(
                sqlserver.sql_text, 
                N'%$SQL_TEXT$%'
            )
        )
    ),
    add event sqlserver.prepare_sql(
        action (
            sqlserver.client_app_name,
            sqlserver.client_hostname,
            sqlserver.database_id,
            sqlserver.[database_name],
            sqlserver.nt_username,
            sqlserver.query_hash_signed,
            sqlserver.server_principal_name,
            sqlserver.[session_id],
            sqlserver.sql_text,
            sqlserver.tsql_stack,
            sqlserver.username
        )
        where (
            sqlserver.[database_name] = N'$DB_NAME$'
            and package0.equal_boolean(sqlserver.is_system, 0)
            and sqlserver.like_i_sql_unicode_string(
                sqlserver.sql_text, 
                N'%$SQL_TEXT$%'
            )
        )
    ),
    add event sqlserver.rpc_completed (
        set collect_data_stream = 1
        action (
            sqlserver.client_app_name,
            sqlserver.client_hostname,
            sqlserver.database_id,
            sqlserver.[database_name],
            sqlserver.nt_username,
            sqlserver.query_hash_signed,
            sqlserver.server_principal_name,
            sqlserver.[session_id],
            sqlserver.sql_text,
            sqlserver.tsql_stack,
            sqlserver.username
        )
        where (
            sqlserver.[database_name] = N'$DB_NAME$'
            and package0.equal_boolean(sqlserver.is_system, 0)
            and sqlserver.like_i_sql_unicode_string(
                sqlserver.sql_text, 
                N'%$SQL_TEXT$%'
            )
        )
    ),
    add event sqlserver.sp_statement_completed (
        action (
            sqlserver.client_app_name,
            sqlserver.client_hostname,
            sqlserver.database_id,
            sqlserver.[database_name],
            sqlserver.nt_username,
            sqlserver.query_hash_signed,
            sqlserver.server_principal_name,
            sqlserver.[session_id],
            sqlserver.sql_text,
            sqlserver.tsql_stack,
            sqlserver.username
        )
        where (
            sqlserver.[database_name] = N'$DB_NAME$'
            and package0.equal_boolean(sqlserver.is_system, 0)
            and sqlserver.like_i_sql_unicode_string(
                sqlserver.sql_text, 
                N'%$SQL_TEXT$%'
            )
        )
    ),
    add event sqlserver.sql_batch_completed (
        set collect_batch_text = 1
        action (
            sqlserver.client_app_name,
            sqlserver.client_hostname,
            sqlserver.database_id,
            sqlserver.[database_name],
            sqlserver.nt_username,
            sqlserver.query_hash_signed,
            sqlserver.server_principal_name,
            sqlserver.[session_id],
            sqlserver.sql_text,
            sqlserver.tsql_stack,
            sqlserver.username
        )
        where (
            sqlserver.[database_name] = N'$DB_NAME$'
            and package0.equal_boolean(sqlserver.is_system, 0)
            and sqlserver.like_i_sql_unicode_string(
                sqlserver.sql_text, 
                N'%$SQL_TEXT$%'
            )
        )
    )
    add target package0.event_file (
        set 
            filename    = N'D:\rdsdbdata\Log\$XE_NAME$.xel', 
            max_file_size = 100
    )
    with (
        max_memory            = 4096kb,
        event_retention_mode  = allow_single_event_loss,
        max_dispatch_latency  = 30 seconds,
        max_event_size        = 0kb,
        memory_partition_mode = none,
        track_causality       = off,
        startup_state         = off
    )
;
go
