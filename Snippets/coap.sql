/*
Create stored procedure
*/

create or alter proc $procedure_name$
    @parameter_name AS INT
as
begin;
    set nocount on;
    set xact_abort on;
    
    $SELECTEDTEXT$$CURSOR$
    
    return;
end;
go

