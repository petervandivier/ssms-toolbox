/*
DatabaseObjectChangeMaster - secret
*/

$SELECTIONSTART$
select top(100) * 
from DatabaseObjectChangeMaster.dbo.DatabaseObjectChangeMaster doc
where doc.where doc.ObjectName = '$CURSOR$'
-- and doc.LoginName = '$USER$'
order by doc.LogDate desc;
$SELECTIONEND$
