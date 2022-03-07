/*
Begin transaction
*/

begin tran
select @@trancount as trancount

	$SELECTEDTEXT$
	$CURSOR$
rollback
-- commit
