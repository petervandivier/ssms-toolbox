/*
Space Used for daily checks
*/


use $CURSOR$;

select
    db_name() as DbName,
    df.name   as [FileName],
    df.physical_name,
    fg.name   as [FileGroup],
    SpaceUsedPct          = convert(decimal(10, 2), (fileproperty(df.name, 'SPACEUSED') / (df.[size] * 1.0)) * 100),
    SpaceUsedPctByMaxSize = convert(decimal(10, 2), 100 * (fileproperty(df.name, 'SPACEUSED') / (nullif(df.max_size,-1) * 1.0))),
    -- df.size as size_pgs,
    SizeGb                = convert(decimal(10, 2),(df.[size] * 8192.) / power(1024.,3))
from sys.database_files df
left join sys.filegroups fg on df.data_space_id = fg.data_space_id
where df.[type] != 1
order by fg.data_space_id;

select file_id,
       type_desc,
       data_space_id,
       name,
       physical_name,
       state_desc,
       convert(decimal(10,2),(size * 8192.)/power(1024.,3)) as size_gb,
       convert(decimal(10,2),(nullif(max_size,-1) * 8192.)/power(1024.,3)) as max_size_gb,
       convert(decimal(10,2),(growth * 8192.)/power(1024.,3)) as growth_gb,
       differential_base_time
from sys.database_files;

