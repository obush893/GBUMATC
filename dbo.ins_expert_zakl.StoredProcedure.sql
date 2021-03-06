/****** Object:  StoredProcedure [dbo].[ins_expert_zakl]    Script Date: 08/05/2016 08:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ins_expert_zakl]
	@UNOM nvarchar(50),
	@number nvarchar(50),
    @data_zakl date,
    @picture varbinary(max) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @last_id int
	declare @DU_ID int
	declare @GU_ID int
	
select @GU_ID=kod from dbo.gu where unikalniy = @UNOM
print @GU_ID
select @DU_ID=kod from dbo.reestr where unikalniy = @UNOM
print @DU_ID

if (@GU_ID <= 0) and (@DU_ID <= 0) RETURN -5
	else
	BEGIN
		if @GU_ID > 0 
			BEGIN
				INSERT INTO expert_zakl ([number],[data_zakl],[picture]) VALUES (@number ,@data_zakl, @picture)
				SET  @last_id = SCOPE_IDENTITY()    
				INSERT INTO [GBUMATC].[dbo].[expert_zakl_GU]
					   ([id_GU],[id_expert_zakl])
					VALUES (@GU_ID ,@last_id)
			END
		if @DU_ID > 0 
			BEGIN
				INSERT INTO expert_zakl ([number],[data_zakl],[picture]) VALUES (@number ,@data_zakl, @picture)
				SET  @last_id = SCOPE_IDENTITY()    
				INSERT INTO [GBUMATC].[dbo].[expert_zakl_reestr]
					   ([id_reestr],[id_expert_zakl])
					VALUES (@DU_ID ,@last_id)
			END	
	END
END
GO
