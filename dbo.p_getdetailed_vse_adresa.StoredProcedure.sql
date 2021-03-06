/****** Object:  StoredProcedure [dbo].[p_getdetailed_vse_adresa]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[p_getdetailed_vse_adresa]
@addr nvarchar(255),
@id varchar(255)=null
,@okrug varchar(255)=null

as 


/*


лишнее удаляем?
да и общюю сумму тоже удаляем



[p_getdetailed_vse_adresa] null, '1987960'
 p_getdetailed_vse_adresa4 '','1987960', 'all'
 p_getdetailed_vse_adresa4 'Зеленоград г. к.1431','', 'all'
 

declare @s varchar(255)='1-й Нагатинский проезд, д.11. корп.1'
exec  dbo.p_getdetailed_vse_adresa @s,'','all'
exec  dbo.p_getdetailed_otdelnie @s,'','all'
exec   dbo.p_getdetailed_zapolnaem_nejelyo @s,'','all'
exec  dbo.p_getdetailed_summary @s,'','all'
 
 
  
 
 давай по очереди. а то я немного запутался.
1 таблица: 
"адреса МКД", 4 столбцов: дома, население, объем отходов эксперем-ент, объем отходов не эксперемент. дома и население берем из таблицы, 
а объем расходов расчитываем вот по этому куску: CAST( SUM(p1)*1.45/365 as decimal(10,2))[Эксперимент, м3/сутки] 
, CAST( SUM(p2)*1.45/365 as decimal(10,2)) [Не эксперимент, м3/сутки],
 
 
*/

declare @Text1 varchar(8000)

select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'') 
,@okrug=','+ISNULL(ltrim(rtrim(@okrug)),'')+','


 
select  adres_mesta_sbora_tbo [Адрес места сбора ТБО], 
 chislenost_nasiliniya [Численность населения], 
 t2.[Эксперимент, м3/сутки], 
 t2.[Не эксперимент, м3/сутки]


 From (select  adres_mesta_sbora_tbo, id_mesta_sbora_tbo ,
       id_dvor_territorii,
         CAST( SUM(case when uchasnik_eksperementa like 'да'   then chislenost_nasiliniya else 0 end)*1.45/365 as decimal(10,5))[Эксперимент, м3/сутки] 
       , CAST( SUM(case when uchasnik_eksperementa like 'нет'  then chislenost_nasiliniya else 0 end)*1.45/365 as decimal(10,5)) [Не эксперимент, м3/сутки]
       , SUM(chislenost_nasiliniya) chislenost_nasiliniya -- так надо!
      -- У тебя идёт группировка. а численность, это ко-во человек (в простонеародие) Если у тебя будет несколько записей с одинаковыми  id_mesta_sbora_tbo ,  id_dvor_territorii то нужно 
      -- логику понял
          From dbo.tbo_vse_adresa va
          --left join  dbo.ConvertStringDelimsToTable(@okrug, ',') okr on okr.StrVal=va.okrug

           where del=0 and (@okrug like '%all%' or @okrug like '%,'+va.okrug+',%')
        --  and adres_mesta_sbora_tbo = 'Базовская ул., д. 20, к. 2'
          and  (@id='' or exists( select * from  dbo.fn_find_addr2(@id) a where a.addr1=va.adres_mesta_sbora_tbo )  or  va.id_mesta_sbora_tbo=@id  ) 
         and  (@addr='' or exists( select * from  dbo.fn_find_id2(@addr) i where i.id_ploshadki=va.id_mesta_sbora_tbo)or va.adres_mesta_sbora_tbo=@addr  )
      
          
          group by  adres_mesta_sbora_tbo, id_mesta_sbora_tbo, id_dvor_territorii
) t2




              order by  t2.adres_mesta_sbora_tbo
GO
