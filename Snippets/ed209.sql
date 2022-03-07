/*
ED209 Hallpass Log
*/

$SELECTIONSTART$select * 
from DBAdmin.ED209.SpidHallPass
order by Expires desc$SELECTIONEND$

/*
update DBAdmin.ED209.SpidHallPass set
    Expires = dateadd(hour,52,getutcdate())
where Spid = 76
*/
