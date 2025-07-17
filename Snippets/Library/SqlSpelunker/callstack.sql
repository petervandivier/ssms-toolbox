/*
SQL Spelunker - use in Powershell
*/

-- https://github.com/taddison/SQLSpelunker
$SELECTIONSTART$cd ~\git\SQLSpelunker\src\SQLSpelunker.Console
dotnet run --c "server=$SERVER$;initial catalog=$DBNAME$;integrated security=sspi" --s "exec $PASTE$;" > ~\Desktop\$PASTE$_callstack.txt$SELECTIONEND$
~\Desktop\$PASTE$_callstack.txt$SELECTIONEND$
