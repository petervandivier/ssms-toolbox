/*
xp_readerrorlog with default args
*/

$SELECTIONSTART$
exec xp_readerrorlog
     0 -- log file #, 0-indexed
    ,1 -- log file type, 1 or NULL = error log, 2 = SQL Agent log
    ,null --"kill" -- Search string 1
    ,null -- Search string 2
    ,null -- search from time 
    ,null --"$DATE$ $TIME$" -- search end time 
    ,"desc" -- order by
;
$SELECTIONEND$
