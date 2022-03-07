/*
Get a list of numbers
*/

;with nums as(
	select 1 i
	union all 
	select i+1
	from nums
	where i<1e$SELECTIONSTART$6$SELECTIONEND$
)
select i
from nums
option (maxrecursion 0);
