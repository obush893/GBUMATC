/****** Object:  StoredProcedure [dbo].[tbo_asp_search]    Script Date: 08/05/2016 08:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[tbo_asp_search]
@addr nvarchar(255),
@id varchar(255)=null

as
set nocount on
/*
Нельзя объединить не объединяемое!!!
я помню, мы это это делали, чтобы пользователь мог вносить только корректные данные
но сейчас другая команда, :(
сделать чтобы все работало из того, что есть, и не обрращать внимание на кривые данные.
жесть вообщпеомстроить хороший отчёт на кривых данных невозможно!!!
я знаю
может давай оставим до завтра? а то уже я напрягся, да и ты небось мозг себе взорвал

я с утра еще поговорю, может немного упростится задача

exec tbo_asp_search @addr='',@ID='167127'

*/
-- exec tbo_asp_search @addr='зеленогра',@ID='708904'


-- exec tbo_asp_search @addr='Зеленоград',@ID=null


select @addr = ISNULL(ltrim(rtrim(@addr)),''),
       @id =  ISNULL(ltrim(rtrim(@id)),'') 


select @addr = case when @addr ='' then '' else @addr +'%' end 
      


select  
  a.adres_mesta_sbora_tbo v_adres_mesta_sbora_tbo,
	a.adres_mkd,
	a.adres_mesta_sbora_kgm v_adres_mesta_sbora_kgm,
	a.id_dvor_territorii a_id_dvor_territorii,
	o.ma_adres_mesta_sbora_otkhodov o_adres_mesta_sbora_otkhodov,
	o.id_mesta_sbora_otkhodov  o_id_mesta_sbora_otkhodov,
	z.ma_ima_dvor_territorii z_ima_dvor_territorii,
	z.ma_adres_mesta_sbora_tbo z_adres_mesta_sbora_tbo,
	z.ma_adres_mesta_sbora_kgm z_adres_mesta_sbora_kgm,
	z.id_dvor_territorii z_id_dvor_territorii
from (select    
	
	    adres_mkd,
	    max(id_dvor_territorii) id_dvor_territorii,
	    max(adres_mesta_sbora_tbo) adres_mesta_sbora_tbo  ,
	    max(adres_mesta_sbora_kgm) adres_mesta_sbora_kgm from tbo_vse_adresa  
	where (@addr ='' or adres_mesta_sbora_tbo like @addr or adres_mesta_sbora_kgm like @addr )  and(@id='' or id_dvor_territorii=@id)
	group by adres_mkd) a
full join (select adres,MAX(id_mesta_sbora_otkhodov) id_mesta_sbora_otkhodov, MAX(adres_mesta_sbora_otkhodov) ma_adres_mesta_sbora_otkhodov 
            from  tbo_otdelnie o 
             where (@addr ='' or adres_mesta_sbora_otkhodov like @addr)
             and (@id='' or id_mesta_sbora_otkhodov=@id)
           group by adres) o on o.adres=a.adres_mkd-- or o.id_mesta_sbora_otkhodov=a.id_dvor_territorii
full join (select 	adres_mkd, 
	          Max(ima_dvor_territorii) ma_ima_dvor_territorii,
	          max(id_dvor_territorii)id_dvor_territorii,
	          Max(adres_mesta_sbora_tbo) ma_adres_mesta_sbora_tbo,
            Max(adres_mesta_sbora_kgm) ma_adres_mesta_sbora_kgm
	         from tbo_zapolnaem_nejelyo 
	         where( @addr ='' or ima_dvor_territorii like @addr or
               adres_mesta_sbora_tbo like @addr or
               adres_mesta_sbora_kgm like @addr )
                 and (@id='' or id_dvor_territorii=@id)
           group by adres_mkd) z on z.adres_mkd=a.adres_mkd-- or z.id_dvor_territorii=a.id_dvor_territorii or z.id_dvor_territorii=o.id_mesta_sbora_otkhodov



/*
Плохо!!!
select adres, COUNT(1) from  tbo_otdelnie  group by adres having COUNT(1)>1

Плохо!!!
select  adres_mkd, COUNT(1)  from tbo_zapolnaem_nejelyo group by adres_mkd having COUNT(1)>1

Ещё хуже
select  id_dvor_territorii, COUNT(1)  from tbo_zapolnaem_nejelyo group by id_dvor_territorii having COUNT(1)>1

dbo.tbo_zapolnaem_nejelyo

id_dvor_territorii
id_mesta_sbora_tbo
id_mesta_sbora_kgm

Плохо!!!
select  id_dvor_territorii, COUNT(1)  from tbo_vse_adresa group by id_dvor_territorii having COUNT(1)>1


dbo.tbo_vse_adresa
id_dvor_territorii
id_mesta_sbora_tbo
id_mesta_sbora_kgm


Плохо!!!
select  id_mesta_sbora_otkhodov, COUNT(1)  from tbo_otdelnie group by id_mesta_sbora_otkhodov having COUNT(1)>1

dbo.tbo_otdelnie
id_mesta_sbora_otkhodov

--вот как то так



Ключевых полей нет!!! Везде идёт задублированность!!!
да, с этими данными полная жопа. задублирование идет, т.к. на каждой площадке может быть несколько разных контейнеров
или одинаковае контейнеры по 













Объясни мне логику, что мы ищем?
Значения в какой таблице?
логика такая:
в поиске вводятся данные по адресу или ID. 
далее в таблице на web-форме будет выводится информация из 3х таблиц и нескольких полей.
далее ползователь кликает на данные в таблице и ему раскрывается информация по данным из сводной табличке (той которую сейчас делаем)
 












*/





/*


теперь про ID
ща попробую табличку сделать



select '|'+@addr +'|',
       @id 

*/
/*
Поиск по адресу ты будешь производить по какому полю???
а вот фиг его знает, мне сказали, чтобы поиск выводился по всем полям из 3х таблиц. итог собственно виден внизу.

Поиск на соответствие (=) или на нечеткое соответствие (like)??
мне кажется нужно делать через like, т.к. пользователь наверно не знает какой адрес  точно забит в базе



таблица tbo_vse_adresa
	adres_mesta_sbora_tbo
	adres_mkd
	adres_mesta_sbora_kgm
	

таблица tbo_otdelnie
	adres
	adres_mesta_sbora_otkhodov
 
таблица tbo_zapolnaem_nejelyo
	adres_mkd
	ima_dvor_territorii
	adres_mesta_sbora_tbo
	adres_mesta_sbora_kgm





--Теперь нужно зарпросы писать!!!
--по адресу я выборку сделал, из каких таблиц какие поля выводить


а запросы кто писать будет? :-)
понял, ща сделаю
	
*/
GO
