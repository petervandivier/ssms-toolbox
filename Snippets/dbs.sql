/*
SSF sys.dbs
*/

select d.log_reuse_wait_desc,* 
from sys.databases d
--where d.name = '$DBNAME$'
