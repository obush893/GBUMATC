﻿CREATE TABLE [dbo].[ГУ] (
  [№ п/п] [nvarchar](50) NULL,
  [Дата монтажа указанная Исполнителем] [datetime] NULL,
  [Статус работ] [nvarchar](50) NULL,
  [Ответственный сотрудник] [nvarchar](50) NULL,
  [Дата осмотра] [datetime] NULL,
  [Факт установки ГУ] [nvarchar](50) NULL,
  [Уникальный номер информационного указателя] [nvarchar](50) NULL,
  [Тип городского указателя] [nvarchar](50) NULL,
  [Округ] [nvarchar](50) NULL,
  [Населённый пункт] [nvarchar](150) NULL,
  [Район] [nvarchar](50) NULL,
  [Улица, просп, пер и проч] [nvarchar](50) NULL,
  [Дом, корп, стр и проч] [nvarchar](50) NULL,
  [Улица с односторонним движением] [nvarchar](50) NULL,
  [В случае установки на тротуаре, его измеренная ширина (м)] [nvarchar](50) NULL,
  [Оценочная ширина тротуара] [nvarchar](50) NULL,
  [Расстояние от опоры (либо от центра бетонного основания) до края] [nvarchar](50) NULL,
  [Тип поверхности установки] [nvarchar](50) NULL,
  [Проходимость] [nvarchar](50) NULL,
  [Реконструкция] [nvarchar](50) NULL,
  [Просматриваемость] [nvarchar](50) NULL,
  [Состояние ГУ] [nvarchar](50) NULL,
  [Ориентация ГУ] [nvarchar](50) NULL,
  [Соответствие факт. места установки тех. Паспорту] [nvarchar](50) NULL,
  [Расстояние до места установки по отметке тех паспорта (м.)] [nvarchar](50) NULL,
  [По просматриваемости] [nvarchar](50) NULL,
  [По отсутствию нависания над проезжей частью] [nvarchar](50) NULL,
  [По ширине тротуара в месте установки] [nvarchar](50) NULL,
  [По расположению относительно зеленых насаждений] [nvarchar](50) NULL,
  [По расстоянию от входа в транспортные узлы и дома] [nvarchar](50) NULL,
  [По расстоянию до края велосипедной дорожки] [nvarchar](50) NULL,
  [По содержанию] [nvarchar](50) NULL,
  [По количеству и правильному расположению] [nvarchar](50) NULL,
  [Количество информационных полей] [nvarchar](50) NULL,
  [Текущее количество плашек] [int] NULL,
  [Наличие модуля с картой местности] [nvarchar](50) NULL,
  [Оформление основания] [nvarchar](50) NULL,
  [Территория] [nvarchar](50) NULL,
  [Размер бетонного блока длина] [nvarchar](50) NULL,
  [Размер бетонного блока ширина] [nvarchar](50) NULL,
  [Площадь восстановительных работ после заглубления] [nvarchar](50) NULL,
  [Вывоз техники, инвентаря, оборудования] [nvarchar](50) NULL,
  [Иные нарушения требований технических правил к городским указате] [nvarchar](50) NULL,
  [Заключение] [nvarchar](4000) NULL,
  [Тип нарушения внешнего вида и технического состояния] [nvarchar](4000) NULL,
  [Дата направления замечания в ИЛИОН] [date] NULL,
  [Замечания камеральной проверки] [nvarchar](4000) NULL,
  [Дата направления замечания камеральной проверки в ИЛИОН] [date] NULL,
  [Устранение замечаний камеральной проверки] [nvarchar](50) NULL,
  [Примечание] [nvarchar](4000) NULL,
  [Программа] [nvarchar](500) NULL,
  [Координата X (ЕГКО)] [nvarchar](50) NULL,
  [Координата Y (ЕГКО)] [nvarchar](50) NULL,
  [Адрес установки ГУсуществует в Москве] [nvarchar](50) NULL,
  [Наименования и нарпавления указанные на инф. полях верны] [nvarchar](50) NULL,
  [Место фактической установки соответствует отметке на карте в нов] [nvarchar](50) NULL,
  [ФИО сотрудника, присвоевшего координаты] [nvarchar](50) NULL,
  [ФИО сотрудника проверившего информационные поля] [nvarchar](50) NULL,
  [Отметка о занесении в АСУ (Инвентарный номер)] [nvarchar](50) NULL,
  [Дата занесения информации в АСУ] [datetime] NULL,
  [Сотрудник занесший данные в АСУ] [nvarchar](50) NULL,
  [Дата установки ДУ по графику ДЖКХиБ] [datetime] NULL,
  [Год реализации по госконтрату] [int] NULL,
  [Этап работ] [nvarchar](50) NULL,
  [Мероприятие в рамках которого установлен ДУ] [nvarchar](500) NULL,
  [Планируемая Исполнителем дата монтажа] [nvarchar](50) NULL,
  [Дата поступления информация в отдел мониторинга] [datetime] NULL,
  [Площадь бетонного блока (кв.м)] [nvarchar](50) NULL,
  [Должность сотрудника обследовавшего ДУ] [nvarchar](50) NULL,
  [Должность сотрудника занесшего нформацию в АСУ] [nvarchar](50) NULL,
  [Счетчик дополнительного номера] [nvarchar](50) NULL,
  [Формирование первой части УН] [nvarchar](50) NULL,
  [Вычисление количества знаков во второй части УН] [nvarchar](50) NULL,
  [Количество нулей подстановки во второй части УН] [nvarchar](50) NULL,
  [Формирование необходимого количества нулей для сцепки] [nvarchar](50) NULL,
  [Сцепка (готовая вторая часть УН)] [nvarchar](50) NULL,
  [Сцепка (полный УН)] [nvarchar](50) NULL,
  [Дата отправки информации Исполнителю] [datetime] NULL,
  [Содержание информационных полей. Блок 1, сторона А] [nvarchar](4000) NULL,
  [Содержание информационных полей. Блок 1, сторона Б] [nvarchar](4000) NULL,
  [Содержание информационных полей. Блок 2, сторона А] [nvarchar](4000) NULL,
  [Содержание информационных полей. Блок 2, сторона Б] [nvarchar](4000) NULL,
  [Содержание информационных полей. Блок 3, сторона А] [nvarchar](4000) NULL,
  [Содержание информационных полей. Блок 3, сторона Б] [nvarchar](4000) NULL,
  [Содержание информационных полей. Блок 4, сторона А] [nvarchar](4000) NULL,
  [Содержание информационных полей. Блок 4, сторона Б] [nvarchar](4000) NULL,
  [Фото стороны А] [nvarchar](50) NULL,
  [Фото стороны Б] [nvarchar](50) NULL,
  [Фото текста 1] [nvarchar](50) NULL,
  [Фото текста 2] [nvarchar](50) NULL,
  [Фото текста 3] [nvarchar](50) NULL,
  [Фото текста 4] [nvarchar](50) NULL,
  [Фото замечания] [nvarchar](50) NULL,
  [Карта] [nvarchar](50) NULL,
  [Принято] [date] NULL,
  [Оплачено] [date] NULL,
  [паспорт_первый] [int] NULL,
  [паспорт] [int] NULL,
  [паспорт_согл] [int] NULL,
  [макет] [int] NULL,
  [макет_согл] [int] NULL,
  [Инвентарный номер] [nvarchar](50) NULL,
  [ОКОФ] [nvarchar](50) NULL,
  [Амортизационная группа] [nvarchar](50) NULL,
  [Способ начисления амортизации] [nvarchar](50) NULL,
  [Дата принятия к учету] [date] NULL,
  [Состояние] [nvarchar](50) NULL,
  [Мес. норма %] [float] NULL,
  [Срок полезного использо вания (мес.)] [int] NULL,
  [Процент износа] [float] NULL,
  [Балансовая стоимость] [money] NULL,
  [Кол-во] [int] NULL,
  [Сумма амортизации] [money] NULL,
  [Остаточная стоимость] [money] NULL,
  [ID] [int] IDENTITY NOT FOR REPLICATION,
  [ts] [timestamp],
  [update_d] [datetimeoffset] NOT NULL CONSTRAINT [DF_ГУ_update_d] DEFAULT (sysdatetimeoffset()),
  [AOGUID] [uniqueidentifier] NULL,
  [HOUSEGUID] [uniqueidentifier] NULL,
  [WGS84] [geography] NULL,
  [GU_ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ГУ_GU_ID] DEFAULT (newid()) ROWGUIDCOL,
  CONSTRAINT [PK_ГУ] PRIMARY KEY NONCLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [777]
  ON [dbo].[ГУ] ([№ п/п])
  INCLUDE ([Уникальный номер информационного указателя], [Содержание информационных полей. Блок 1, сторона А], [Содержание информационных полей. Блок 1, сторона Б], [Содержание информационных полей. Блок 2, сторона А], [Содержание информационных полей. Блок 2, сторона Б], [Содержание информационных полей. Блок 3, сторона А], [Содержание информационных полей. Блок 3, сторона Б], [Содержание информационных полей. Блок 4, сторона А], [Содержание информационных полей. Блок 4, сторона Б], [ID])
  ON [PRIMARY]
GO

CREATE UNIQUE CLUSTERED INDEX [gfgg]
  ON [dbo].[ГУ] ([Уникальный номер информационного указателя], [ID])
  ON [PRIMARY]
GO

CREATE INDEX [NonClusteredIndex-20170207-130824]
  ON [dbo].[ГУ] ([Уникальный номер информационного указателя], [Населённый пункт], [Район], [Улица, просп, пер и проч], [Дом, корп, стр и проч], [ID], [ts], [AOGUID], [HOUSEGUID])
  ON [PRIMARY]
GO

CREATE INDEX [NonClusteredIndex-20170210-151711]
  ON [dbo].[ГУ] ([№ п/п], [Уникальный номер информационного указателя], [ID], [AOGUID], [HOUSEGUID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [tyttt]
  ON [dbo].[ГУ] ([Уникальный номер информационного указателя], [ID])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [update_log] 
   ON  [dbo].[ГУ]
   AFTER DELETE,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[ГУ_log]
           ([№ п/п]
           ,[Дата монтажа указанная Исполнителем]
           ,[Статус работ]
           ,[Ответственный сотрудник]
           ,[Дата осмотра]
           ,[Факт установки ГУ]
           ,[Уникальный номер информационного указателя]
           ,[Тип городского указателя]
           ,[Округ]
           ,[Населённый пункт]
           ,[Район]
           ,[Улица, просп, пер и проч]
           ,[Дом, корп, стр и проч]
           ,[Улица с односторонним движением]
           ,[В случае установки на тротуаре, его измеренная ширина (м)]
           ,[Оценочная ширина тротуара]
           ,[Расстояние от опоры (либо от центра бетонного основания) до края]
           ,[Тип поверхности установки]
           ,[Проходимость]
           ,[Реконструкция]
           ,[Просматриваемость]
           ,[Состояние ГУ]
           ,[Ориентация ГУ]
           ,[Соответствие факт. места установки тех. Паспорту]
           ,[Расстояние до места установки по отметке тех паспорта (м.)]
           ,[По просматриваемости]
           ,[По отсутствию нависания над проезжей частью]
           ,[По ширине тротуара в месте установки]
           ,[По расположению относительно зеленых насаждений]
           ,[По расстоянию от входа в транспортные узлы и дома]
           ,[По расстоянию до края велосипедной дорожки]
           ,[По содержанию]
           ,[По количеству и правильному расположению]
           ,[Количество информационных полей]
           ,[Текущее количество плашек]
           ,[Наличие модуля с картой местности]
           ,[Оформление основания]
           ,[Территория]
           ,[Размер бетонного блока длина]
           ,[Размер бетонного блока ширина]
           ,[Площадь восстановительных работ после заглубления]
           ,[Вывоз техники, инвентаря, оборудования]
           ,[Иные нарушения требований технических правил к городским указате]
           ,[Заключение]
           ,[Тип нарушения внешнего вида и технического состояния]
           ,[Дата направления замечания в ИЛИОН]
           ,[Замечания камеральной проверки]
           ,[Дата направления замечания камеральной проверки в ИЛИОН]
           ,[Устранение замечаний камеральной проверки]
           ,[Примечание]
           ,[Программа]
           ,[Координата X (ЕГКО)]
           ,[Координата Y (ЕГКО)]
           ,[Адрес установки ГУсуществует в Москве]
           ,[Наименования и нарпавления указанные на инф. полях верны]
           ,[Место фактической установки соответствует отметке на карте в нов]
           ,[ФИО сотрудника, присвоевшего координаты]
           ,[ФИО сотрудника проверившего информационные поля]
           ,[Отметка о занесении в АСУ (Инвентарный номер)]
           ,[Дата занесения информации в АСУ]
           ,[Сотрудник занесший данные в АСУ]
           ,[Дата установки ДУ по графику ДЖКХиБ]
           ,[Год реализации по госконтрату]
           ,[Этап работ]
           ,[Мероприятие в рамках которого установлен ДУ]
           ,[Планируемая Исполнителем дата монтажа]
           ,[Дата поступления информация в отдел мониторинга]
           ,[Площадь бетонного блока (кв.м)]
           ,[Должность сотрудника обследовавшего ДУ]
           ,[Должность сотрудника занесшего нформацию в АСУ]
           ,[Счетчик дополнительного номера]
           ,[Формирование первой части УН]
           ,[Вычисление количества знаков во второй части УН]
           ,[Количество нулей подстановки во второй части УН]
           ,[Формирование необходимого количества нулей для сцепки]
           ,[Сцепка (готовая вторая часть УН)]
           ,[Сцепка (полный УН)]
           ,[Дата отправки информации Исполнителю]
           ,[Содержание информационных полей. Блок 1, сторона А]
           ,[Содержание информационных полей. Блок 1, сторона Б]
           ,[Содержание информационных полей. Блок 2, сторона А]
           ,[Содержание информационных полей. Блок 2, сторона Б]
           ,[Содержание информационных полей. Блок 3, сторона А]
           ,[Содержание информационных полей. Блок 3, сторона Б]
           ,[Содержание информационных полей. Блок 4, сторона А]
           ,[Содержание информационных полей. Блок 4, сторона Б]
           ,[Фото стороны А]
           ,[Фото стороны Б]
           ,[Фото текста 1]
           ,[Фото текста 2]
           ,[Фото текста 3]
           ,[Фото текста 4]
           ,[Фото замечания]
           ,[Карта]
           ,[Принято]
           ,[Оплачено]
           ,[паспорт_первый]
           ,[паспорт]
           ,[паспорт_согл]
           ,[макет]
           ,[макет_согл]
           ,[Инвентарный номер]
           ,[ОКОФ]
           ,[Амортизационная группа]
           ,[Способ начисления амортизации]
           ,[Дата принятия к учету]
           ,[Состояние]
           ,[Мес. норма %]
           ,[Срок полезного использо вания (мес.)]
           ,[Процент износа]
           ,[Балансовая стоимость]
           ,[Кол-во]
           ,[Сумма амортизации]
           ,[Остаточная стоимость]
           ,[ID]
           ,[update_d]
           ,[AOGUID]
           ,[HOUSEGUID]
           ,[WGS84]
		   ,GU_ID)
SELECT [№ п/п]
      ,[Дата монтажа указанная Исполнителем]
      ,[Статус работ]
      ,[Ответственный сотрудник]
      ,[Дата осмотра]
      ,[Факт установки ГУ]
      ,[Уникальный номер информационного указателя]
      ,[Тип городского указателя]
      ,[Округ]
      ,[Населённый пункт]
      ,[Район]
      ,[Улица, просп, пер и проч]
      ,[Дом, корп, стр и проч]
      ,[Улица с односторонним движением]
      ,[В случае установки на тротуаре, его измеренная ширина (м)]
      ,[Оценочная ширина тротуара]
      ,[Расстояние от опоры (либо от центра бетонного основания) до края]
      ,[Тип поверхности установки]
      ,[Проходимость]
      ,[Реконструкция]
      ,[Просматриваемость]
      ,[Состояние ГУ]
      ,[Ориентация ГУ]
      ,[Соответствие факт. места установки тех. Паспорту]
      ,[Расстояние до места установки по отметке тех паспорта (м.)]
      ,[По просматриваемости]
      ,[По отсутствию нависания над проезжей частью]
      ,[По ширине тротуара в месте установки]
      ,[По расположению относительно зеленых насаждений]
      ,[По расстоянию от входа в транспортные узлы и дома]
      ,[По расстоянию до края велосипедной дорожки]
      ,[По содержанию]
      ,[По количеству и правильному расположению]
      ,[Количество информационных полей]
      ,[Текущее количество плашек]
      ,[Наличие модуля с картой местности]
      ,[Оформление основания]
      ,[Территория]
      ,[Размер бетонного блока длина]
      ,[Размер бетонного блока ширина]
      ,[Площадь восстановительных работ после заглубления]
      ,[Вывоз техники, инвентаря, оборудования]
      ,[Иные нарушения требований технических правил к городским указате]
      ,[Заключение]
      ,[Тип нарушения внешнего вида и технического состояния]
      ,[Дата направления замечания в ИЛИОН]
      ,[Замечания камеральной проверки]
      ,[Дата направления замечания камеральной проверки в ИЛИОН]
      ,[Устранение замечаний камеральной проверки]
      ,[Примечание]
      ,[Программа]
      ,[Координата X (ЕГКО)]
      ,[Координата Y (ЕГКО)]
      ,[Адрес установки ГУсуществует в Москве]
      ,[Наименования и нарпавления указанные на инф. полях верны]
      ,[Место фактической установки соответствует отметке на карте в нов]
      ,[ФИО сотрудника, присвоевшего координаты]
      ,[ФИО сотрудника проверившего информационные поля]
      ,[Отметка о занесении в АСУ (Инвентарный номер)]
      ,[Дата занесения информации в АСУ]
      ,[Сотрудник занесший данные в АСУ]
      ,[Дата установки ДУ по графику ДЖКХиБ]
      ,[Год реализации по госконтрату]
      ,[Этап работ]
      ,[Мероприятие в рамках которого установлен ДУ]
      ,[Планируемая Исполнителем дата монтажа]
      ,[Дата поступления информация в отдел мониторинга]
      ,[Площадь бетонного блока (кв.м)]
      ,[Должность сотрудника обследовавшего ДУ]
      ,[Должность сотрудника занесшего нформацию в АСУ]
      ,[Счетчик дополнительного номера]
      ,[Формирование первой части УН]
      ,[Вычисление количества знаков во второй части УН]
      ,[Количество нулей подстановки во второй части УН]
      ,[Формирование необходимого количества нулей для сцепки]
      ,[Сцепка (готовая вторая часть УН)]
      ,[Сцепка (полный УН)]
      ,[Дата отправки информации Исполнителю]
      ,[Содержание информационных полей. Блок 1, сторона А]
      ,[Содержание информационных полей. Блок 1, сторона Б]
      ,[Содержание информационных полей. Блок 2, сторона А]
      ,[Содержание информационных полей. Блок 2, сторона Б]
      ,[Содержание информационных полей. Блок 3, сторона А]
      ,[Содержание информационных полей. Блок 3, сторона Б]
      ,[Содержание информационных полей. Блок 4, сторона А]
      ,[Содержание информационных полей. Блок 4, сторона Б]
      ,[Фото стороны А]
      ,[Фото стороны Б]
      ,[Фото текста 1]
      ,[Фото текста 2]
      ,[Фото текста 3]
      ,[Фото текста 4]
      ,[Фото замечания]
      ,[Карта]
      ,[Принято]
      ,[Оплачено]
      ,[паспорт_первый]
      ,[паспорт]
      ,[паспорт_согл]
      ,[макет]
      ,[макет_согл]
      ,[Инвентарный номер]
      ,[ОКОФ]
      ,[Амортизационная группа]
      ,[Способ начисления амортизации]
      ,[Дата принятия к учету]
      ,[Состояние]
      ,[Мес. норма %]
      ,[Срок полезного использо вания (мес.)]
      ,[Процент износа]
      ,[Балансовая стоимость]
      ,[Кол-во]
      ,[Сумма амортизации]
      ,[Остаточная стоимость]
      ,[ID]
      ,[update_d]
      ,[AOGUID]
      ,[HOUSEGUID]
      ,[WGS84]
	  ,GU_ID
  FROM deleted

END
GO