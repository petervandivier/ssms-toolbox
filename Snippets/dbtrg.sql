/*
Get all Database-scoped TRIGGERS on the server
*/

$SELECTIONSTART$drop table if exists #all_db_triggers;
create table #all_db_triggers (
    db sysname,
    tr sysname,
    cs bigint,
    def varchar(max)
);
insert #all_db_triggers ( db, tr, cs, def )
exec sys.sp_MSforeachdb N'use [?]
select db_name(), t.name, checksum(sm.definition), sm.definition
from sys.triggers t
join sys.sql_modules sm on sm.[object_id] = t.[object_id]
where t.parent_class=0';
select * from #all_db_triggers;$SELECTIONEND$
