/*
sysdepends
*/

select distinct
    object_schema_name(id)+'.'+object_name(id) as name,
    object_definition(id) as def
from sys.sysdepends s
where s.depid = object_id('$CURSOR$')
    --and object_definition(id) like '%%'
order by 1;
