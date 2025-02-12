﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	ПараметрСтатусДоговора = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "СтатусДоговора");
	Если ПараметрСтатусДоговора <> Неопределено Тогда
		Если ПараметрСтатусДоговора.Значение = Неопределено Тогда
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтатусДоговора", Перечисления.СтатусыДоговоровКонтрагентов.ПустаяСсылка());
			
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		ПараметрВалюта = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВалютаВзаиморасчетов");
		ПараметрВалюта.Значение = Константы.ВалютаРегламентированногоУчета.Получить();
		СхемаКомпоновкиДанных.Макеты.Макет6.Параметры.Валюта.Выражение = "Представление(ПараметрыДанных.ВалютаВзаиморасчетов)";
		СхемаКомпоновкиДанных.Макеты.Макет6.Параметры.ПорядокОплаты.Выражение = "Представление(ПараметрыДанных.ВалютаВзаиморасчетов)";
	КонецЕсли;
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
