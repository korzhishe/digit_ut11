﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	УниверсальныеМеханизмыПартийИСебестоимости.СохранитьДвиженияСформированныеРасчетомПартийИСебестоимости(ЭтотОбъект, Замещение);
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	БлокироватьДляИзменения   = Истина;
	
	// Текущее состояние остатков помещается во временную таблицу,
	// чтобы при записи получить изменение актуальных остатков регистра.
	
	ТекстыЗапросовДляПолученияТаблицыИзменений = 
		ЗакрытиеМесяцаСервер.ТекстыЗапросовДляПолученияТаблицыИзмененийРегистра(ЭтотОбъект.Метаданные());
	
	Запрос = Новый Запрос;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиНачальныхДанных;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("ТекстВыборкиТаблицыИзменений", ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиТаблицыИзменений);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
	 ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
	 ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;

	// Рассчитывается изменение остатков регистра с учетом нового набора записей
	// и помещается во временную таблицу.
	
	Запрос = Новый Запрос;
	Запрос.Текст = ДополнительныеСвойства.ТекстВыборкиТаблицыИзменений;
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.Выполнить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Подразделение,
	|	ТаблицаИзменений.СтатьяРасходов,
	|	ТаблицаИзменений.АналитикаРасходов,
	|	ТаблицаИзменений.НаправлениеДеятельности,
	|	СУММА(ТаблицаИзменений.Сумма) КАК СуммаИзменение,
	|	СУММА(ТаблицаИзменений.СуммаБезНДС) КАК СуммаБезНДСИзменение,
	|	СУММА(ТаблицаИзменений.СуммаРегл) КАК СуммаРеглИзменение,
	|	СУММА(ТаблицаИзменений.ПостояннаяРазница) КАК ПостояннаяРазницаИзменение,
	|	СУММА(ТаблицаИзменений.ВременнаяРазница) КАК ВременнаяРазницаИзменение
	|ПОМЕСТИТЬ ДвиженияПрочиеРасходыИзменение
	|ИЗ
	|	ТаблицаИзмененийПрочиеРасходы КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Подразделение,
	|	ТаблицаИзменений.СтатьяРасходов,
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.АналитикаРасходов,
	|	ТаблицаИзменений.НаправлениеДеятельности
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.Сумма) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.СуммаБезНДС) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.СуммаРегл) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.ПостояннаяРазница) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.ВременнаяРазница) <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ) КАК Месяц,
	|	ТаблицаИзменений.Организация                  КАК Организация,
	|	ТаблицаИзменений.Регистратор                  КАК Документ,
	|	ЛОЖЬ                                          КАК ИзмененыДанныеДляПартионногоУчетаВерсии21
	|ПОМЕСТИТЬ ПрочиеРасходыЗаданияКРасчетуСебестоимости
	|ИЗ
	|	ТаблицаИзмененийПрочиеРасходы КАК ТаблицаИзменений
	|ГДЕ
	|	(ТаблицаИзменений.СтатьяРасходов.ВариантРаспределенияРасходовУпр
	|		= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты)
	|	ИЛИ ТаблицаИзменений.СтатьяРасходов.ВариантРаспределенияРасходовРегл
	|		= ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты)
	|	)
	|	И НЕ ТаблицаИзменений.Регистратор ССЫЛКА Документ.РаспределениеДоходовИРасходовПоНаправлениямДеятельности
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, МЕСЯЦ),
	|	ТаблицаИзменений.Регистратор,
	|	ТаблицаИзменений.Период,
	|	ТаблицаИзменений.Организация,
	|	ТаблицаИзменений.Подразделение,
	|	ТаблицаИзменений.СтатьяРасходов,
	|	ТаблицаИзменений.АналитикаРасходов,
	|	ТаблицаИзменений.НаправлениеДеятельности,
	|	ТаблицаИзменений.ХозяйственнаяОперация,
	|	ТаблицаИзменений.АналитикаУчетаНоменклатуры
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаИзменений.Сумма) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.СуммаБезНДС) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.СуммаРегл) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.ПостояннаяРазница) <> 0
	|	ИЛИ СУММА(ТаблицаИзменений.ВременнаяРазница) <> 0
	|";
	Результат = Запрос.ВыполнитьПакет();
	
	// Информация о разнице между остатками была помещена во временную таблицу.
	// Добавляется информация о ее существовании и наличии в ней записей.
	Если Не ОбменДанными.Загрузка И ПроведениеСерверУТ.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Выборка = Результат[0].Выбрать();
		Выборка.Следующий();
		СтруктураВременныеТаблицы.Вставить("ДвиженияПрочиеРасходыИзменение", Выборка.Количество > 0);
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
