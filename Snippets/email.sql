/*
Send a test DB Mail
*/

$SELECTIONSTART$
declare @usr sysname = '$USER$'
       ,@domain sysname = '@gmail.com' ;
declare 
	@subj nvarchar(255) = 
	    N'test email from '+@@servername
	    +' at '+convert(nvarchar(23),getdate(),126),
    @to sysname = 
    	right(@usr,len(@usr)-patindex('%\%',@usr))
    	+@domain;

print @to;
print @subj;

exec msdb..sp_send_dbmail
    --@profile_name = null, 
    @recipients = @to, 
    @subject = @subj,
    @body = N'foo';
$SELECTIONEND$

