/*
ED209 Hallpass Log
*/

select * 
from DBAdmin.ED209.SpidHallPass
order by Expires desc

/*
update DBAdmin.ED209.SpidHallPass set
    Expires = dateadd(hour,52,getutcdate())
where Spid = 76
*/
