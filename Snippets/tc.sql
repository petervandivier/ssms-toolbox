/*
TRY ... CATCH fragment
*/

begin try;
    $SELECTEDTEXT$
end try begin catch;
    $CURSOR$
end catch;
