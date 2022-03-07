/*
Cursor
*/

declare $var1$ int;

declare $cursor_name$ cursor 
	local
	forward_only
	read_only
for
    select $CURSOR$;

open $cursor_name$ 

fetch next from $cursor_name$ into $var1$;

while @@fetch_status = 0
begin;

    fetch next from $cursor_name$ into $var1$;    
end;

close $cursor_name$;
deallocate $cursor_name$


