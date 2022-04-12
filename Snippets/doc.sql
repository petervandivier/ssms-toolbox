/*
DatabaseObjectChange - secret
*/

$SELECTIONSTART$
select top(100) * 
from DatabaseObjectChange.dbo.DatabaseObjectChange doc
where doc.ObjectName = '$CURSOR$'
-- and doc.LoginName = '$USER$'
order by doc.LogDate desc;
$SELECTIONEND$
