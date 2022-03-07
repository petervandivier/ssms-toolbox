/*
Create inline table-valued function
*/

CREATE FUNCTION $function_name$
    (@parameter_name AS INT)
RETURNS TABLE
--WITH ENCRYPTION|SCHEMABINDING, ...
AS
RETURN ( $SELECTEDTEXT$$CURSOR$ )
GO

