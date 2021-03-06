/****** Object:  StoredProcedure [dbo].[my_pivot]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[my_pivot]
  @field_param sysname,
  @field_param_title sysname,
  @field_time sysname,
  @table_name sysname,
  @aggrigate_field sysname,
  @aggrigate_functions  sysname,
  @where varchar(4000)
as

select @field_param =isnull(@field_param,''),
  @field_param_title  =isnull(@field_param_title,''),
  @field_time  =isnull(@field_time,''),
  @table_name  =isnull(@table_name,''),
  @aggrigate_field  =isnull(@aggrigate_field,''),
  @aggrigate_functions   =isnull(@aggrigate_functions,''),
  @where  =isnull(@where,'')

declare @sql nvarchar(4000)

set @sql=N'
declare @d date 

declare cur cursor local static read_only for
  select distinct   cast( '+@field_time+N' as date) data
   from '+@table_name+N'  ' + @where+ '
   order by 1
open cur
 fetch next from cur into @d
 while @@FETCH_STATUS =0 
 begin
    if (isnull(@sOUT,'''')<>'''') set @sOUT=@sOUT+'',''
   set @sOUT= isnull(@sOUT,'''')+''[''+convert( varchar,@d,104)+'']''

  fetch next from cur into @d
 end
 close cur
 deallocate cur '
declare @sValues varchar(8000)
set @sValues=''


--print (@sql)

exec sp_executesql @sql, N'@sOUT varchar(8000) OUTPUT', @sOUT=@sValues OUTPUT



 
exec ( 'SELECT '+@field_param+' AS ['+@field_param_title+'], 
'+ @sValues +'
FROM
(SELECT '+@field_param+',convert( varchar,'+@field_time+',104) ftime, '+@aggrigate_field+'
    FROM '+@table_name+') AS SourceTable
PIVOT ( '+@aggrigate_functions+'
FOR ftime IN ('+@sValues+')
) AS PivotTable;
')
  
 /*
exec  my_pivot 
@field_param ='TaskListTitle',
@field_param_title='Привет',
@field_time ='Created',
@table_name ='WSS_Content_doctrix.dbo.WorkflowAssociation',
@where =' where Created>getdate()-100',
@aggrigate_field= '1 StandardCost ',
@aggrigate_functions ='sum(StandardCost)'

@field_param ='',
@field_time ='Created',
@table_name ='WSS_Content_doctrix.dbo.WorkflowAssociation',
@where =''
 
 
 SELECT     wa.Author, wa.Configuration, wa.Created, wa.InstanceCount,wa.InstantiationParams, wa.Modified, wa.Name, wa.Version, wa.StatusFieldName
  FROM WSS_Content_doctrix..WorkflowAssociation wa
  where Name not like N'%предыдущая%'
  
  */
GO
