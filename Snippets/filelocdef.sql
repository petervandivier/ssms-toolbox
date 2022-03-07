/*
Default path(s) for Backup, Data and Log files
*/



DECLARE @DataLoc nvarchar(2000)
       ,@LogLoc nvarchar(2000)
       ,@BackupLoc nvarchar(2000);
 
EXEC master.dbo.xp_instance_regread
       N'HKEY_LOCAL_MACHINE',
       N'Software\Microsoft\MSSQLServer\MSSQLServer',
       N'DefaultData',
       @DataLoc OUTPUT;
 
EXEC master.dbo.xp_instance_regread
       N'HKEY_LOCAL_MACHINE',
       N'Software\Microsoft\MSSQLServer\MSSQLServer',
       N'DefaultLog',
       @LogLoc OUTPUT;
 
EXEC xp_instance_regread
       N'HKEY_LOCAL_MACHINE',
       N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer',
       N'BackupDirectory',
       @BackupLoc OUTPUT;

SELECT 
        @DataLoc   AS [Default Data Location],
        @LogLoc    AS [Default Log Location],
        @BackupLoc AS [Default Backup Location];


