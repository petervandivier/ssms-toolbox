/*
text format sp_spaceused
*/

drop table if exists #spaceused;
create table #spaceused (
    table_name       sysname,
    [rows]           bigint,
    reserved         nvarchar(128) not null,
    [data]           nvarchar(128) not null,
    index_size       nvarchar(128) not null,
    unused           nvarchar(128) not null,
    rows_int64       as try_convert(bigint,left([rows]    ,len([rows]    )-3)),
    reserved_int64   as try_convert(bigint,left(reserved  ,len(reserved  )-3)),
    data_int64       as try_convert(bigint,left([data]    ,len([data]    )-3)),
    index_size_int64 as try_convert(bigint,left(index_size,len(index_size)-3)),
    unused_int64     as try_convert(bigint,left(unused    ,len(unused    )-3)),
    rows_text        nvarchar(128),
    reserved_text    nvarchar(128),
    data_text        nvarchar(128),
    index_size_text  nvarchar(128),
    unused_text      nvarchar(128),
);

insert into #spaceused (
    table_name,
    [rows],
    reserved,
    [data],
    index_size,
    unused     
)
exec sp_spaceused '$CURSOR$'

--select 
--    format([rows],'N0'),
--    (len(reserved)-3)/3,
--    * 
--from #spaceused;

update #spaceused set
    rows_text     = format([rows],'N0'),
    reserved_text = 
        case ceiling((len(reserved)-3.0)/3)
            when 1 then lower(replace(reserved,' ',''))
            when 2 then concat(format(round(reserved_int64/1000.0,2)      ,'N1'),'mb')
            when 3 then concat(format(round(reserved_int64/1000000.0,2)   ,'N1'),'gb')
            when 4 then concat(format(round(reserved_int64/1000000000.0,2),'N1'),'tb')
        end,
    data_text = 
        case ceiling((len([data])-3.0)/3)
            when 1 then lower(replace([data],' ',''))
            when 2 then concat(format(round(data_int64/1000.0,2)      ,'N1'),'mb')
            when 3 then concat(format(round(data_int64/1000000.0,2)   ,'N1'),'gb')
            when 4 then concat(format(round(data_int64/1000000000.0,2),'N1'),'tb')
        end,
    index_size_text = 
        case ceiling((len(index_size)-3.0)/3)
            when 1 then lower(replace(index_size,' ',''))
            when 2 then concat(format(round(index_size_int64/1000.0,2)      ,'N1'),'mb')
            when 3 then concat(format(round(index_size_int64/1000000.0,2)   ,'N1'),'gb')
            when 4 then concat(format(round(index_size_int64/1000000000.0,2),'N1'),'tb')
        end,
    unused_text = 
        case ceiling((len(unused)-3.0)/3)
            when 1 then lower(replace(unused,' ',''))
            when 2 then concat(format(round(unused_int64/1000.0,2)      ,'N1'),'mb')
            when 3 then concat(format(round(unused_int64/1000000.0,2)   ,'N1'),'gb')
            when 4 then concat(format(round(unused_int64/1000000000.0,2),'N1'),'tb')
        end
;

--select 
--    (len([data])-3)/3,
--    round(data_int64/1000.0,2),
--    * 
--from #spaceused

select
    table_name,
    rows_text,
    reserved_text,
    data_text,
    index_size_text,
    unused_text
from #spaceused;
go
select
    replace([property], '_text', '') as [property],
    [value]
from #spaceused as s
unpivot (
    [value] for [property] in (
        table_name,
        rows_text,
        reserved_text,
        data_text,
        index_size_text,
        unused_text
    )
) as pvt
go

