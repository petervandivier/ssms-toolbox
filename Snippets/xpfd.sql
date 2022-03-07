/*
Free space on fixed drives
*/

$SELECTIONSTART$
drop table if exists #xpfd;
create table #xpfd (
    drive char(1) not null primary key,
    mb_free int not null,
    gb_free as (convert(float,round(mb_free/1024.,2)))
)
insert #xpfd ( drive, mb_free )
exec xp_fixeddrives;

select * from #xpfd x;
$SELECTIONEND$
