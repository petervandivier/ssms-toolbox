/*
Get all DBs on server with IMO configured filegroups
*/

$SELECTIONSTART$drop table if exists #imo_db;
create table #imo_db(db sysname);
insert #imo_db ( db )
exec sys.sp_MSforeachdb N'use [?]
select db_name()
from sys.filegroups
where type=''FX'';';
select * from #imo_db;$SELECTIONEND$
