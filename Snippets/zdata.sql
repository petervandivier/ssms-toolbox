/*
Dummmy Data
*/

;with getNums as ( select 1 as i union all select i + 1 from getNums where i < 100 )
    , getData as (
	select 
		i,
		uuid  = newid(),
		vchar = convert(varchar(36),newid()),
		num   = abs(checksum(newid())%1000),
		bool  = convert(bit,abs(checksum(newid())%2)-1),
		dt    = dateadd(day,checksum(newid())%1000,getutcdate())
	from getNums
)
select *
from getData gd;
