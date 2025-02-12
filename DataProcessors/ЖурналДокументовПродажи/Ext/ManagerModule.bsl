﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	
	МассивКомандОтчетов = Команды.НайтиСтроки(Новый Структура("Вид", "Отчеты"));
	МассивКомандПечати = Команды.НайтиСтроки(Новый Структура("Вид", "Печать"));
	
	МенеджерОтклоненияОтУсловийПродаж = Метаданные.Отчеты.ОтклоненияОтУсловийПродаж.ПолноеИмя();
	МенеджерСостояниеРасчетовСКлиентами = Метаданные.Отчеты.СостояниеРасчетовСКлиентами.ПолноеИмя();
	МенеджерКарточкаРасчетовСКлиентами = Метаданные.Отчеты.КарточкаРасчетовСКлиентами.ПолноеИмя();
	МенеджерКарточкаРасчетовПоПереданнойВозвратнойТаре = Метаданные.Отчеты.КарточкаРасчетовПоПереданнойВозвратнойТаре.ПолноеИмя();
	МенеджерАнализЦенПоставщиков = Метаданные.Отчеты.АнализЦенПоставщиков.ПолноеИмя();
	
	Для каждого ТекКоманда Из МассивКомандОтчетов Цикл
		Если ТекКоманда.Менеджер = МенеджерОтклоненияОтУсловийПродаж Тогда
			ТекКоманда.Важность = "Обычное"
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерСостояниеРасчетовСКлиентами Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 1;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерКарточкаРасчетовСКлиентами Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 2;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерКарточкаРасчетовПоПереданнойВозвратнойТаре Тогда
			ТекКоманда.Порядок = 3;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерАнализЦенПоставщиков Тогда
			ТекКоманда.Важность = "СмТакже";
			ТекКоманда.Порядок = 2;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекКоманда Из МассивКомандПечати Цикл
		ТекКоманда.ВидимостьВФормах = "СписокДокументов";
	КонецЦикла;
	
КонецПроцедуры

Процедура ОформитьНакладные(Параметры, АдресРезультата) Экспорт
	
	ОформитьРядНакладныхПоТаблицам(Параметры);
	Параметры.Удалить("ДокументыПоТипамНакладных");
	ПоместитьВоВременноеХранилище(Параметры, АдресРезультата);
	
КонецПроцедуры

Процедура СоздатьДокументПродажи(ПоляДокумента, ПараметрыОснования, МассивДокументов, ПараметрыФормирования) Экспорт
	
	ПечататьРеализациюТоваровУслуг = ПараметрыФормирования.ПечататьРеализациюТоваровУслуг;
	ПечататьАктВыполненныхРабот    = ПараметрыФормирования.ПечататьАктВыполненныхРабот;
	СоздаватьДокументПродажи       = ПараметрыФормирования.СоздаватьДокументПродажи;
	СоздаватьСчетФактуру           = ПараметрыФормирования.СоздаватьСчетФактуру;
	
	Если ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг Тогда
		НовыйДокумент = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
		НовыйДокумент.Статус = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;
		НовыйДокумент.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг;
	ИначеЕсли ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктНаПередачуПрав Тогда
		НовыйДокумент = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
		НовыйДокумент.Статус = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;
		НовыйДокумент.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктНаПередачуПрав;
	Иначе
		НовыйДокумент = Документы.АктВыполненныхРабот.СоздатьДокумент();
	КонецЕсли;
	
	НовыйДокумент.Дата = ТекущаяДатаСеанса();
	НовыйДокумент.Заполнить(ПараметрыОснования);
	НовыйДокумент.СкидкиРассчитаны = Истина;
	
	Если ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг
		ИЛИ ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктНаПередачуПрав Тогда
		ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(НовыйДокумент,Документы.РеализацияТоваровУслуг);
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(НовыйДокумент, ПараметрыУказанияСерий);
	КонецЕсли;
	
	ДокументПроведен = Ложь;
	
	Если НовыйДокумент.ПроверитьЗаполнение() Тогда
		
		Попытка
			
			Если (ПечататьРеализациюТоваровУслуг 
				И (ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг
				ИЛИ ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктНаПередачуПрав))
				ИЛИ (ПечататьАктВыполненныхРабот И ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктВыполненныхРабот) Тогда
				
				Печатать = Истина;
				
			Иначе
				
				Печатать = Ложь;
				
			КонецЕсли;
			
			Если СоздаватьДокументПродажи Тогда
				НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
				ДокументПроведен = Истина;
			Иначе
				НовыйДокумент.Записать(РежимЗаписиДокумента.Запись);
				Печатать = Ложь;
			КонецЕсли;
			
			МассивДокументов.Добавить(Новый Структура("Документ,Проведен,Печатать", НовыйДокумент.Ссылка, Истина, Печатать));
			
		Исключение
			
			НовыйДокумент.Записать(РежимЗаписиДокумента.Запись);
			МассивДокументов.Добавить(Новый Структура("Документ,Проведен", НовыйДокумент.Ссылка, Ложь, Ложь));
			
		КонецПопытки;
		
		Если ПоляДокумента.НалогообложениеНДС <> Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС
			И (ДокументПроведен И ((ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг
				ИЛИ ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктНаПередачуПрав)
			И НовыйДокумент.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию)
			ИЛИ ПоляДокумента.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктВыполненныхРабот) 
			И СоздаватьСчетФактуру Тогда
			
			СчетФактура = Документы.СчетФактураВыданный.СоздатьДокумент();
			ЗаполнитьЗначенияСвойств(СчетФактура, НовыйДокумент);
			СчетФактура.Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
			СчетФактура.ДокументОснование = НовыйДокумент.Ссылка;
			СчетФактура.Дата = ТекущаяДатаСеанса();
			СчетФактура.УстановитьНовыйНомер();
			
			ДанныеСчетаФактуры = Новый Структура;
			ДанныеСчетаФактуры.Вставить("ДокументОснование", НовыйДокумент.Ссылка);
			ДанныеСчетаФактуры.Вставить("Организация",       НовыйДокумент.Организация);
			ДанныеСчетаФактуры.Вставить("Дата",              НовыйДокумент.Дата);
			ДанныеСчетаФактуры.Вставить("Выставлен",         Истина);
			ДанныеСчетаФактуры.Вставить("ДатаВыставления",   НовыйДокумент.Дата);
			
			СчетФактура.Заполнить(ДанныеСчетаФактуры);
			Попытка
				СчетФактура.Записать(РежимЗаписиДокумента.Проведение);
				МассивДокументов.Добавить(Новый Структура("Документ,Проведен,Печатать", СчетФактура.Ссылка, Истина, Ложь));
			Исключение
				СчетФактура.Записать(РежимЗаписиДокумента.Запись);
				МассивДокументов.Добавить(Новый Структура("Документ,Проведен,Печатать", СчетФактура.Ссылка, Ложь, Ложь));
			КонецПопытки;
		КонецЕсли;
		
	Иначе
		
		НовыйДокумент.Записать(РежимЗаписиДокумента.Запись);
		МассивДокументов.Добавить(Новый Структура("Документ,Проведен", НовыйДокумент.Ссылка, Ложь));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОформитьРядНакладныхПоТаблицам(ПараметрыФормированияДокументов)
	
	ДокументыПоТипамНакладных = ПараметрыФормированияДокументов.ДокументыПоТипамНакладных;
	СписокОшибок = ПараметрыФормированияДокументов.СписокОшибок;
	ПараметрыФормирования = ПараметрыФормированияДокументов.ПараметрыФормирования;
	
	ИспользоватьРеализациюПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьРеализациюПоНесколькимЗаказам");
	ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам");
		
	ПараметрыФормы = Новый Структура();
	ПараметрыФормированияДокументов.Вставить("ИмяФормы", "Обработка.ЖурналДокументовПродажи.Форма.ФормаСозданныеДокументы");
	СозданныеДокументы = Новый СписокЗначений();
	
	СтруктураПоиска = СтруктураЗначащихРеквизитов();
	
	Для Каждого Таблица Из ДокументыПоТипамНакладных Цикл
		
		ПерваяСтрока = Таблица[0];
		Если ПерваяСтрока.СостояниеНакладной > 0 Тогда
			
			МассивСсылок = Таблица.ВыгрузитьКолонку("Ссылка");
			ПараметрыОснования = Новый Структура();
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, ПерваяСтрока);
			Если ПерваяСтрока.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг
				ИЛИ ПерваяСтрока.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктНаПередачуПрав Тогда
				ПараметрыОснования.Вставить("СкладОтгрузки", ПараметрыФормирования.Склад);
				ПараметрыОснования.Вставить("ВариантОформленияПродажи", ПерваяСтрока.ВариантОформленияПродажи);
				ПараметрыОснования.Вставить("ПараметрыОформления", Новый Структура("ПоЗаказам, ПоОрдерам", НЕ ПараметрыФормирования.ПоОрдерам, ПараметрыФормирования.ПоОрдерам));
			КонецЕсли;
			
			Если ((ПерваяСтрока.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.РеализацияТоваровУслуг
					ИЛИ ПерваяСтрока.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктНаПередачуПрав)
					И ИспользоватьРеализациюПоНесколькимЗаказам)
				ИЛИ (ПерваяСтрока.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктВыполненныхРабот
					И ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам) Тогда
				
				РеквизитыРаспоряжения = ПолучитьРеквизитыРаспоряжений(МассивСсылок);
				РеквизитыШапки = Новый Структура();
				ОбщегоНазначенияУТКлиентСервер.ДополнитьСтруктуру(РеквизитыШапки, СтруктураПоиска, Истина);
				ОбщегоНазначенияУТКлиентСервер.ДополнитьСтруктуру(РеквизитыШапки, РеквизитыРаспоряжения, Истина);
				
				ПараметрыОснования.Вставить("РеквизитыШапки",    РеквизитыШапки);
				ПараметрыОснования.Вставить("ДокументОснование", МассивСсылок);
				
				СоздатьДокументПродажи(СтруктураПоиска, ПараметрыОснования, СозданныеДокументы,ПараметрыФормирования);
				
			Иначе
				
				Для Каждого ТекЭлемент Из МассивСсылок Цикл
					ПараметрыОснования.Вставить("ДокументОснование", ТекЭлемент);
					СоздатьДокументПродажи(СтруктураПоиска, ПараметрыОснования, СозданныеДокументы,ПараметрыФормирования);
				КонецЦикла;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыФормированияДокументов.Вставить("Параметры", ПараметрыФормы);
	Если ПараметрыФормирования.НеОткрыватьФормуСозданногоДокумента Тогда
		ПараметрыФормированияДокументов.Вставить("РежимПечатиДокументов", Истина);
	Иначе
		Владелец = Пользователи.АвторизованныйПользователь();
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, СозданныеДокументы.ВыгрузитьЗначения(), "ФормаСозданныеДокументыПродажи");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Функция СтруктураЗначащихРеквизитов() Экспорт
	
	Возврат Новый Структура("
		|Партнер,
		|Контрагент,
		|Договор,
		|Организация,
		|Соглашение,
		|Сделка,
		|Склад,
		|Подразделение,
		|СкладОтгрузки,
		|ХозяйственнаяОперация,
		|ВалютаВзаиморасчетов,
		|НалогообложениеНДС,
		|ЦенаВключаетНДС,
		|ЗапрещеноВыбиратьГруппуСкладов,
		|ВариантОформленияПродажи,
		|СпособДоставки,
		|ПеревозчикПартнер,
		|АдресДоставки,
		|АдресДоставкиПеревозчика,
		|ВернутьМногооборотнуюТару,
		|СрокВозвратаМногооборотнойТары,
		|ТребуетсяЗалогЗаТару,
		|КалендарьВозвратаТары,
		|РассчитыватьДатуВозвратаТарыПоКалендарю,
		|НаправлениеДеятельности
		|");
		
КонецФункции

Функция ПолучитьРеквизитыРаспоряжений(МассивРаспоряжений) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|						КОГДА ЗаказКлиента.БанковскийСчет <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
	|							ТОГДА ЗаказКлиента.БанковскийСчет
	|						ИНАЧЕ NULL
	|					КОНЕЦ) = 1
	|				И КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Организация) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.БанковскийСчет)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчет,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|						КОГДА ЗаказКлиента.БанковскийСчетКонтрагента <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|							ТОГДА ЗаказКлиента.БанковскийСчетКонтрагента
	|						ИНАЧЕ NULL
	|					КОНЕЦ) = 1
	|				И КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Контрагент) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.БанковскийСчетКонтрагента)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчетКонтрагента,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|					КОГДА ЗаказКлиента.Грузоотправитель <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|						ТОГДА ЗаказКлиента.Грузоотправитель
	|					ИНАЧЕ NULL
	|				КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.Грузоотправитель)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	КОНЕЦ КАК Грузоотправитель,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|					КОГДА ЗаказКлиента.Грузополучатель <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|						ТОГДА ЗаказКлиента.Грузополучатель
	|					ИНАЧЕ NULL
	|				КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.Грузополучатель)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	КОНЕЦ КАК Грузополучатель,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|						КОГДА ЗаказКлиента.БанковскийСчетГрузоотправителя <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|							ТОГДА ЗаказКлиента.БанковскийСчетГрузоотправителя
	|						ИНАЧЕ NULL
	|					КОНЕЦ) = 1
	|				И КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|						КОГДА ЗаказКлиента.Грузоотправитель <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|							ТОГДА ЗаказКлиента.Грузоотправитель
	|						ИНАЧЕ NULL
	|					КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.БанковскийСчетГрузоотправителя)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчетГрузоотправителя,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|						КОГДА ЗаказКлиента.БанковскийСчетГрузополучателя <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|							ТОГДА ЗаказКлиента.БанковскийСчетГрузополучателя
	|						ИНАЧЕ NULL
	|					КОНЕЦ) = 1
	|				И КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|						КОГДА ЗаказКлиента.Грузополучатель <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|							ТОГДА ЗаказКлиента.Грузополучатель
	|						ИНАЧЕ NULL
	|					КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.БанковскийСчетГрузополучателя)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|	КОНЕЦ КАК БанковскийСчетГрузополучателя,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|					КОГДА ЗаказКлиента.Касса <> ЗНАЧЕНИЕ(Справочник.Кассы.ПустаяСсылка)
	|						ТОГДА ЗаказКлиента.Касса
	|					ИНАЧЕ NULL
	|				КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.Касса)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Кассы.ПустаяСсылка)
	|	КОНЕЦ КАК Касса,
	|	ЗаказКлиента.ФормаОплаты КАК ФормаОплаты,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫРАЗИТЬ(ЗаказКлиента.АдресДоставкиЗначенияПолей КАК СТРОКА(1000))) = 1
	|			ТОГДА МАКСИМУМ(ВЫРАЗИТЬ(ЗаказКлиента.АдресДоставкиЗначенияПолей КАК СТРОКА(1000)))
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК АдресДоставкиЗначенияПолей,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|					КОГДА ЗаказКлиента.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчика)
	|							ИЛИ ЗаказКлиента.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу)
	|						ТОГДА ВЫРАЗИТЬ(ЗаказКлиента.АдресДоставкиПеревозчикаЗначенияПолей КАК СТРОКА(1000))
	|					ИНАЧЕ NULL
	|				КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ВЫРАЗИТЬ(ЗаказКлиента.АдресДоставкиПеревозчикаЗначенияПолей КАК СТРОКА(1000)))
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК АдресДоставкиПеревозчикаЗначенияПолей,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|					КОГДА (ЗаказКлиента.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.ДоКлиента)
	|							ИЛИ ЗаказКлиента.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу))
	|							И ЗаказКлиента.ЗонаДоставки <> ЗНАЧЕНИЕ(Справочник.ЗоныДоставки.ПустаяСсылка)
	|						ТОГДА ЗаказКлиента.ЗонаДоставки
	|					ИНАЧЕ NULL
	|				КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.ЗонаДоставки)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ЗоныДоставки.ПустаяСсылка)
	|	КОНЕЦ КАК ЗонаДоставки,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|					КОГДА ЗаказКлиента.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.ДоКлиента)
	|							ИЛИ ЗаказКлиента.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу)
	|						ТОГДА ЗаказКлиента.ВремяДоставкиС
	|					ИНАЧЕ NULL
	|				КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.ВремяДоставкиС)
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ КАК ВремяДоставкиС,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|					КОГДА ЗаказКлиента.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.ДоКлиента)
	|							ИЛИ ЗаказКлиента.СпособДоставки = ЗНАЧЕНИЕ(Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу)
	|						ТОГДА ЗаказКлиента.ВремяДоставкиПо
	|					ИНАЧЕ NULL
	|				КОНЕЦ) = 1
	|			ТОГДА МАКСИМУМ(ЗаказКлиента.ВремяДоставкиПо)
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ КАК ВремяДоставкиПо,
	|	ВЫБОР
	|		КОГДА КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫРАЗИТЬ(ЗаказКлиента.ДополнительнаяИнформацияПоДоставке КАК СТРОКА(1000))) = 1
	|			ТОГДА МАКСИМУМ(ВЫРАЗИТЬ(ЗаказКлиента.ДополнительнаяИнформацияПоДоставке КАК СТРОКА(1000)))
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ДополнительнаяИнформацияПоДоставке
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказКлиента.Контрагент КАК Контрагент,
	|		ЗаказКлиента.Организация КАК Организация,
	|		ЗаказКлиента.БанковскийСчет КАК БанковскийСчет,
	|		ЗаказКлиента.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
	|		ЗаказКлиента.Грузоотправитель КАК Грузоотправитель,
	|		ЗаказКлиента.Грузополучатель КАК Грузополучатель,
	|		ЗаказКлиента.БанковскийСчетГрузоотправителя КАК БанковскийСчетГрузоотправителя,
	|		ЗаказКлиента.БанковскийСчетГрузополучателя КАК БанковскийСчетГрузополучателя,
	|		ЗаказКлиента.Касса КАК Касса,
	|		ЗаказКлиента.ФормаОплаты КАК ФормаОплаты,
	|		ЗаказКлиента.СпособДоставки                        КАК СпособДоставки,
	|		ЗаказКлиента.АдресДоставкиЗначенияПолей            КАК АдресДоставкиЗначенияПолей,
	|		ЗаказКлиента.АдресДоставкиПеревозчикаЗначенияПолей КАК АдресДоставкиПеревозчикаЗначенияПолей,
	|		ЗаказКлиента.ЗонаДоставки                          КАК ЗонаДоставки,
	|		ЗаказКлиента.ВремяДоставкиС                        КАК ВремяДоставкиС,
	|		ЗаказКлиента.ВремяДоставкиПо                       КАК ВремяДоставкиПо,
	|		ЗаказКлиента.ДополнительнаяИнформацияПоДоставке    КАК ДополнительнаяИнформацияПоДоставке
	|	ИЗ
	|		Документ.ЗаказКлиента КАК ЗаказКлиента
	|	ГДЕ
	|		ЗаказКлиента.Ссылка В(&МассивРаспоряжений)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗаявкаНаВозвратТоваровОтКлиента.Контрагент,
	|		ЗаявкаНаВозвратТоваровОтКлиента.Организация,
	|		ЗаявкаНаВозвратТоваровОтКлиента.БанковскийСчет,
	|		ЗаявкаНаВозвратТоваровОтКлиента.БанковскийСчетКонтрагента,
	|		ЗаявкаНаВозвратТоваровОтКлиента.Грузоотправитель,
	|		ЗаявкаНаВозвратТоваровОтКлиента.Грузополучатель,
	|		ЗаявкаНаВозвратТоваровОтКлиента.БанковскийСчетГрузоотправителя,
	|		ЗаявкаНаВозвратТоваровОтКлиента.БанковскийСчетГрузополучателя,
	|		ЗаявкаНаВозвратТоваровОтКлиента.Касса,
	|		ЗаявкаНаВозвратТоваровОтКлиента.ФормаОплаты,
	|		ЗаявкаНаВозвратТоваровОтКлиента.СпособДоставки,
	|		ЗаявкаНаВозвратТоваровОтКлиента.АдресДоставкиЗначенияПолей,
	|		ЗаявкаНаВозвратТоваровОтКлиента.АдресДоставкиПеревозчикаЗначенияПолей,
	|		ЗаявкаНаВозвратТоваровОтКлиента.ЗонаДоставки,
	|		ЗаявкаНаВозвратТоваровОтКлиента.ВремяДоставкиС,
	|		ЗаявкаНаВозвратТоваровОтКлиента.ВремяДоставкиПо,
	|		ЗаявкаНаВозвратТоваровОтКлиента.ДополнительнаяИнформацияПоДоставке
	|	ИЗ
	|		Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаявкаНаВозвратТоваровОтКлиента
	|	ГДЕ
	|		ЗаявкаНаВозвратТоваровОтКлиента.Ссылка В(&МассивРаспоряжений)) КАК ЗаказКлиента
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.ФормаОплаты");
		
	Запрос.УстановитьПараметр("МассивРаспоряжений", МассивРаспоряжений);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	СтруктураРеквизитов = Новый Структура();
	СтруктураРеквизитов.Вставить("БанковскийСчет",                 Выборка.БанковскийСчет);
	СтруктураРеквизитов.Вставить("БанковскийСчетКонтрагента",      Выборка.БанковскийСчетКонтрагента);
	СтруктураРеквизитов.Вставить("Грузоотправитель",               Выборка.Грузоотправитель);
	СтруктураРеквизитов.Вставить("Грузополучатель",                Выборка.Грузополучатель);
	СтруктураРеквизитов.Вставить("БанковскийСчетГрузоотправителя", Выборка.БанковскийСчетГрузоотправителя);
	СтруктураРеквизитов.Вставить("БанковскийСчетГрузополучателя",  Выборка.БанковскийСчетГрузополучателя);
	СтруктураРеквизитов.Вставить("Касса",                          Выборка.Касса);
	СтруктураРеквизитов.Вставить("ФормаОплаты",                    Выборка.ФормаОплаты);
	
	СтруктураРеквизитов.Вставить("АдресДоставкиЗначенияПолей",            Выборка.АдресДоставкиЗначенияПолей);
	СтруктураРеквизитов.Вставить("АдресДоставкиПеревозчикаЗначенияПолей", Выборка.АдресДоставкиПеревозчикаЗначенияПолей);
	СтруктураРеквизитов.Вставить("ЗонаДоставки",                          Выборка.ЗонаДоставки);
	СтруктураРеквизитов.Вставить("ВремяДоставкиС",                        Выборка.ВремяДоставкиС);
	СтруктураРеквизитов.Вставить("ВремяДоставкиПо",                       Выборка.ВремяДоставкиПо);
	СтруктураРеквизитов.Вставить("ДополнительнаяИнформацияПоДоставке",    Выборка.ДополнительнаяИнформацияПоДоставке);
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

#КонецОбласти

#КонецЕсли
