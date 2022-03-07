/*
Create view
*/

create or alter view $view_name$
--WITH ENCRYPTION, SCHEMABINDING, VIEW_METADATA
as
    $SELECTEDTEXT$$CURSOR$
-- WITH CHECK OPTION
go

