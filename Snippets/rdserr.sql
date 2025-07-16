/*
rds_read_error_log
*/

exec rdsadmin.dbo.rds_read_error_log -- $CURSOR$
    @index       = 0,              -- int
    @type        = 0,              -- int
    @search_str1 = N'',            -- nvarchar(255)
    @search_str2 = N'',            -- nvarchar(255)
    @start_time  = '$DATE$$TIME$', -- datetime
    @end_time    = '$DATE$$TIME$', -- datetime
    @sort_order  = N''             -- nvarchar(4)
;

