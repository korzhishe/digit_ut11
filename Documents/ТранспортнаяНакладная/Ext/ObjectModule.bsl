﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);		
		Если ДанныеЗаполнения.Свойство("ДокументыОснования") Тогда
			Для Каждого ДокументОснование Из ДанныеЗаполнения.ДокументыОснования Цикл
				НоваяСтрока = ДокументыОснования.Добавить();
				НоваяСтрока.ДокументОснование = ДокументОснование;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ДокументыОснованияИмеютВерныйСпособДоставки(Отказ);
	Если Не Отказ Тогда 
		ДокументыОснованияИмеютНоменклатуруТипаТовар(Отказ)
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
		
	Если Не ЗначениеЗаполнено(БанковскийСчетЗаказчикаПеревозки) Тогда	
		Если ЗначениеЗаполнено(ЗаказчикПеревозки) Тогда
			Если  ТипЗнч(ЗаказчикПеревозки) = Тип("СправочникСсылка.Контрагенты") Тогда
				БанковскийСчетЗаказчикаПеревозки = Справочники.БанковскиеСчетаКонтрагентов.ПолучитьБанковскийСчетПоУмолчанию(ЗаказчикПеревозки);
			Иначе
				СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
				СтруктураПараметров.Организация = ЗаказчикПеревозки;
				БанковскийСчетЗаказчикаПеревозки = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(БанковскийСчетПлательщика) Тогда	
		Если ЗначениеЗаполнено(Плательщик) Тогда
			Если  ТипЗнч(Плательщик) = Тип("СправочникСсылка.Контрагенты") Тогда
				БанковскийСчетПлательщика = Справочники.БанковскиеСчетаКонтрагентов.ПолучитьБанковскийСчетПоУмолчанию(Плательщик);
			Иначе
				СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
				СтруктураПараметров.Организация = Плательщик;
				БанковскийСчетПлательщика = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
			КонецЕсли;
		КонецЕсли;		
	КонецЕсли;

	Если Не ЗначениеЗаполнено(БанковскийСчетПеревозчика) Тогда	
		Если ЗначениеЗаполнено(Перевозчик) Тогда		
			БанковскийСчетПеревозчика = Справочники.БанковскиеСчетаКонтрагентов.ПолучитьБанковскийСчетПоУмолчанию(Перевозчик);
		КонецЕсли;		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ДокументыОснованияИмеютВерныйСпособДоставки(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Шапка.Ссылка КАК Ссылка,
	|	СУММА(ВЫБОР
	|			КОГДА НЕ Шапка.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоСпособовДоставкиБезИспользованияЗаданияНаПеревозку,
	|	СУММА(ВЫБОР
	|			КОГДА Шапка.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоСпособовДоставкиСИспользованиемЗаданияНаПеревозку,
	|	ИСТИНА КАК МожетИспользоватьсяДоставка
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка В(&МассивСсылок)
	|
	|СГРУППИРОВАТЬ ПО
	|	Шапка.Ссылка
	|
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|ВЫБРАТЬ
	|	Шапка.Ссылка,
	|	СУММА(ВЫБОР
	|			КОГДА НЕ Шапка.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ),
	|	СУММА(ВЫБОР
	|			КОГДА Шапка.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ),
	|	ИСТИНА
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка В(&МассивСсылок)
	|	И НЕ Шапка.РеализацияПоЗаказам
	|
	|СГРУППИРОВАТЬ ПО
	|	Шапка.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДокументТовары.Ссылка,
	|	СУММА(ВЫБОР
	|			КОГДА НЕ ДокументТовары.ЗаказКлиента.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ),
	|	СУММА(ВЫБОР
	|			КОГДА ДокументТовары.ЗаказКлиента.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ),
	|	ИСТИНА
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивСсылок)
	|	И ДокументТовары.Ссылка.РеализацияПоЗаказам
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументТовары.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Шапка.Ссылка,
	|	1,
	|	0,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.КорректировкаРеализации КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Шапка.Ссылка,
	|	СУММА(ВЫБОР
	|			КОГДА НЕ Шапка.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ),
	|	СУММА(ВЫБОР
	|			КОГДА Шапка.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ),
	|	ИСТИНА
	|ИЗ
	|	Документ.ПеремещениеТоваров КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка В(&МассивСсылок)
	|	И НЕ Шапка.ПеремещениеПоЗаказам
	|
	|СГРУППИРОВАТЬ ПО
	|	Шапка.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДокументТовары.Ссылка,
	|	СУММА(ВЫБОР
	|			КОГДА НЕ ДокументТовары.ЗаказНаПеремещение.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ),
	|	СУММА(ВЫБОР
	|			КОГДА ДокументТовары.ЗаказНаПеремещение.СпособДоставки В (&СпособыДоставкиСНашимУчастием)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ),
	|	ИСТИНА
	|ИЗ
	|	Документ.ПеремещениеТоваров.Товары КАК ДокументТовары
	|ГДЕ
	|	ДокументТовары.Ссылка В(&МассивСсылок)
	|	И ДокументТовары.Ссылка.ПеремещениеПоЗаказам
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументТовары.Ссылка";

	Запрос.УстановитьПараметр("МассивСсылок", ДокументыОснования.ВыгрузитьКолонку("ДокументОснование"));
	СпособыДоставкиСНашимУчастием = ДоставкаТоваровКлиентСервер.СпособыДоставкиДоКлиентаСНашимУчастием(Истина);
	Запрос.УстановитьПараметр("СпособыДоставкиСНашимУчастием", СпособыДоставкиСНашимУчастием);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	ЗаданиеНаПеревозкуЗаполнено = ЗначениеЗаполнено(ЗаданиеНаПеревозку);
	
	ШаблонСообщенияСДоставкой = НСтр("ru = 'По документу ""%Документ%"" не предусмотрена доставка, поэтому данный документ не может являться основанием транспортной накладной, связанной с заданием на перевозку.'");
	ШаблонСообщенияБезДоставки = НСтр("ru = 'По документу ""%Документ%"" предусмотрена доставка, поэтому данный документ не может являться основанием транспортной накладной, не связанной с заданием на перевозку.'");	
			
	Пока РезультатЗапроса.Следующий() Цикл 
		
		ТекстСообщения = "";
		
		Если (РезультатЗапроса.КоличествоСпособовДоставкиСИспользованиемЗаданияНаПеревозку = 0)
			И ЗаданиеНаПеревозкуЗаполнено Тогда
			ТекстСообщения = ШаблонСообщенияСДоставкой;
		ИначеЕсли (РезультатЗапроса.КоличествоСпособовДоставкиБезИспользованияЗаданияНаПеревозку = 0)
			И НЕ ЗаданиеНаПеревозкуЗаполнено Тогда
			ТекстСообщения = ШаблонСообщенияБезДоставки;
		КонецЕсли;
		
		Если Не ПустаяСтрока(ТекстСообщения) Тогда  
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", РезультатЗапроса.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, РезультатЗапроса.Ссылка,,,Отказ);	
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДокументыОснованияИмеютНоменклатуруТипаТовар(Отказ)
	
	МассивВсехРаспоряжений = ДокументыОснования.ВыгрузитьКолонку("ДокументОснование");
	МассивРаспоряженийСТоварами = Документы.ТранспортнаяНакладная.ПолучитьТолькоДокументыОснованияСТоварами(МассивВсехРаспоряжений, Отказ);
		
КонецПроцедуры

#КонецОбласти


#КонецОбласти


#КонецЕсли
