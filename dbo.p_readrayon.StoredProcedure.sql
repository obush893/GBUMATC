/****** Object:  StoredProcedure [dbo].[p_readrayon]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[p_readrayon]
@dostup as varchar(255),
@okrug as varchar(255) = null
as 
set nocount on

select @dostup =isnull(''''+replace(replace(replace(@dostup,', ',','),' ,',','),',',''',''')+'''',''),
@okrug = ISNULL(@okrug,'')

declare @sql varchar(1000)
set @sql=case when @okrug='' then ''   else +' and okrug ='''+@okrug+'''' end

if(@dostup not like '%all%')
 begin
  exec('select distinct rayon from tbo_adres a
  where okrug in ('+@dostup+')'+@sql)
end
else
 begin
  exec('select distinct rayon from tbo_adres a where 1=1 '+@sql)
 end
GO
