/*
Database Files
*/

-- https://dba.stackexchange.com/a/7921/68127
select 
    [TYPE]           = A.[type_desc]
   ,[FILE_Name]      = A.[name]
   ,[FILEGROUP_NAME] = fg.[name]
   ,File_Location    = A.physical_name
   ,FILESIZE_MB      = convert(decimal(10, 2),  A.size/128.)
   ,USEDSPACE_MB     = convert(decimal(10, 2),  A.size/128.-((size/128.)-cast(fileproperty(A.[name],'SPACEUSED') as int)/128.))
   ,FREESPACE_MB     = convert(decimal(10, 2),  A.size/128.-             cast(fileproperty(A.[name],'SPACEUSED') as int)/128.)
   ,[FREESPACE_%]    = convert(decimal(10, 2),((A.size/128.-             cast(fileproperty(A.[name],'SPACEUSED') as int)/128.) / (A.size/128.))*100)
   ,AutoGrow = 'By '+iif(is_percent_growth=0,cast(growth/128 as varchar(10))+' MB -',cast(growth as varchar(10))+'% -')
               +case max_size
                    when 0  then 'DISABLED'
                    when -1 then ' Unrestricted'
                    else ' Restricted to '+cast(max_size / (128 * 1024) as varchar(10))+' GB'
                end
               +iif(is_percent_growth = 1, ' [autogrowth by percent, BAD setting!]', '')
from sys.database_files A
left join sys.filegroups fg on A.data_space_id = fg.data_space_id
order by 
    A.[type_desc]
   ,A.[name];
