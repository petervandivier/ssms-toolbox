/*
DatabaseObjectChange - secret
*/

$SELECTIONSTART$
select top(100) * 
from DatabaseObjectChange.dbo.DatabaseObjectChange doc
where doc.LoginName not in ( 
    'VIAGOGORS\SQLPRODAGTSVC$',
    'NT SERVICE\SQLTELEMETRY',
    'sa'
)
-- and doc.LoginName = '$USER$'
order by doc.LogDate desc;
$SELECTIONEND$
