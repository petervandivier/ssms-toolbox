/*
For each DB
*/

exec sys.sp_MSforeachdb N'use [?]
$CURSOR$
';
