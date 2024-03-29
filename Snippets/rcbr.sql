/*
Rowcout-by-range (timeseries) for 2 arbitrary tables
*/


create or alter proc #getRowCountForRange
     @start     datetime2(3)
    ,@end       datetime2(3)
    ,@method    varchar(11) = 'PARTITIONS' -- 'COUNT_STAR'
    ,@rc_a      bigint      output
    ,@rc_b      bigint      output
    ,@size_mb_a float       output
    ,@size_mb_b float       output
as 
begin;
    
    if @method = 'PARTITIONS'
    begin;
		
		select 
		     @rc_a = sum(iif(s.index_id in (0,1),s.row_count,0))
		    ,@size_mb_a = sum(s.used_page_count*8192.)/power(1024.,2)
		from sys.dm_db_partition_stats s
		join sys.partitions p on p.[partition_id] = s.[partition_id]
		join sys.indexes i 
		    on p.[object_id] = i.[object_id]
		    and p.index_id = i.index_id
		left join sys.partition_schemes ps on ps.data_space_id = i.data_space_id
		join sys.partition_functions pf on pf.function_id = ps.function_id
		join sys.partition_range_values prv
		    on prv.boundary_id = s.partition_number
		    and prv.function_id = pf.function_id
		where s.[object_id] = object_id('$table_a$')
		    and sql_variant_property(prv.[value],'BaseType') = '$partition_data_type$'
			and try_cast(prv.[value] as $partition_data_type$$precision_scale$) = @start;

		select 
		     @rc_b = sum(iif(s.index_id in (0,1),s.row_count,0))
		    ,@size_mb_b = sum(s.used_page_count*8192.)/power(1024.,2)
		from sys.dm_db_partition_stats s
		join sys.partitions p on p.[partition_id] = s.[partition_id]
		join sys.indexes i 
		    on p.[object_id] = i.[object_id]
		    and p.index_id = i.index_id
		left join sys.partition_schemes ps on ps.data_space_id = i.data_space_id
		join sys.partition_functions pf on pf.function_id = ps.function_id
		join sys.partition_range_values prv
		    on prv.boundary_id = s.partition_number
		    and prv.function_id = pf.function_id
		where s.[object_id] = object_id('$table_b$')
		    and sql_variant_property(prv.[value],'BaseType') = '$partition_data_type$'
			and try_cast(prv.[value] as $partition_data_type$$precision_scale$) = @start;
    end;
    
    if @method = 'COUNT_STAR'
    begin
        select @rc_a = count_big(*) 
        from $table_a$
        where $column_a$ >= @start 
            and $column_a$  < @end;

        select @rc_b = count_big(*) 
        from $table_b$ 
        where $column_b$ >= @start 
            and $column_b$ < @end;
    end
end;
go

set nocount on;
--set lock_timeout 1000;
--set xact_abort on;

drop table if exists ##range_$MACHINE$;
create table ##range_$MACHINE$ (
     _start          datetime2(3) not null primary key
    ,_end            datetime2(3) not null unique
    ,check (_start < _end)
    ,row_count_a     int
    ,row_count_b     int
    ,size_mb_a       decimal(10,2)
    ,size_mb_b       decimal(10,2)
    ,is_range_closed bit not null default 0 -- allow for stop/restart
    ,dt_upd          datetime2(3)
);

insert ##range_$MACHINE$(_start, _end)
exec ('select start_dt, end_dt from ##batch_bounds_$MACHINE$;');
-- select * from ##range_$MACHINE$

declare 
     @start        datetime2(3)
    ,@end          datetime2(3)
    ,@row_count_a  bigint
    ,@row_count_b  bigint
    ,@size_mb_a    float
    ,@size_mb_b    float
    ,@loop_num_cur int = 0
    ,@loop_num_all int
    ,@msg          nvarchar(4000);

/*
exec dbo.#getRowCountForRange 
     @start = '2013-01-01'
    ,@end   = '2013-02-01'
    ,@method = 'COUNT_STAR'
    ,@rc_a  = @row_count_a out
    ,@rc_b  = @row_count_b out
    ,@size_mb_a = @size_mb_a out
    ,@size_mb_b = @size_mb_b out; 

select
	 row_count_a = @row_count_a
    ,row_count_b = @row_count_b
    ,size_mb_a   = @size_mb_a
    ,size_mb_b   = @size_mb_b
    ,is_range_closed = 1
*/
begin 
	select @loop_num_all = count(*) from ##range_VGD18559;

	declare crs_RC cursor for
	    select _start,_end 
	    from ##range_$MACHINE$ 
	    where is_range_closed=0;
	
	open crs_RC;
	
	fetch next from crs_RC into @start, @end
	
	while @@fetch_status = 0
	begin;
		select @loop_num_cur += 1;
	    set @msg = convert(varchar,getutcdate(),126)+': '+formatmessage('Interating loop [%i] of [%i].',@loop_num_cur,@loop_num_all);
	    raiserror(@msg,0,0) with nowait;
	    
	    declare @rc_a bigint
	       ,@rc_b     bigint;
	    
	    exec dbo.#getRowCountForRange
			$method$@method = 'PARTITIONS',
	        @start = @start
	       ,@end   = @end
	       ,@rc_a  = @row_count_a out
	       ,@rc_b  = @row_count_b out
	       ,@size_mb_a = @size_mb_a out
	       ,@size_mb_b = @size_mb_b out; 
	    
	
	    update ##range_$MACHINE$ set
	         row_count_a = @row_count_a
	        ,row_count_b = @row_count_b
	        ,size_mb_a   = @size_mb_a
	        ,size_mb_b   = @size_mb_b
	        ,is_range_closed = 1
	        ,dt_upd      = getutcdate() 
	    where current of crs_RC;
	
	    fetch next from crs_RC into @start, @end;
	
	end;
	 
	close crs_RC;
	deallocate crs_RC;
end;

select 
    _start
   ,_end
   ,row_count_a as [row_count_PageEvent.PageEvent] 
   ,row_count_b as [row_count_PageEvent.PageEvent_new] 
   ,size_mb_a   as [size_mb_PageEvent.PageEvent]
   ,size_mb_b   as [size_mb_PageEvent.PageEvent_new]   
   ,is_range_closed
   ,dt_upd
from ##range_VGD18559;


