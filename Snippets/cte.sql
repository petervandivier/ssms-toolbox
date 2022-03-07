/*
Encapsulate selected text as cte fragment
*/

;with $cte_name$ as (
$SELECTEDTEXT$
)
select $CURSOR$
from $cte_name$
