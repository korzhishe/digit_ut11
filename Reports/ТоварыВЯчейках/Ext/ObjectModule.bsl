﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
		И Параметры.Свойство("ОписаниеКоманды")
		И Параметры.ОписаниеКоманды.ДополнительныеПараметры.Свойство("ИмяКоманды") Тогда
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ПоЯчейке" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Ячейка", Параметры.ПараметрКоманды);
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ПоНоменклатуре" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Номенклатура", Параметры.ПараметрКоманды);
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ПоОбластиХранения" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("ОбластьХранения", Параметры.ПараметрКоманды);
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ПоСкладскойГруппеНоменклатуры" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("СкладскаяГруппаНоменклатуры", Параметры.ПараметрКоманды);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ТоварыВЯчейках.Запрос;
	
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаКоэффициентУпаковки", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ТоварыВЯчейкахОстаткиИОбороты.Упаковка", 
			"ТоварыВЯчейкахОстаткиИОбороты.Номенклатура"));
			
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъем", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки(
			"ТоварыВЯчейкахОстаткиИОбороты.Упаковка", 
			"ТоварыВЯчейкахОстаткиИОбороты.Номенклатура"));
			
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВес", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки(
			"ТоварыВЯчейкахОстаткиИОбороты.Упаковка", 
			"ТоварыВЯчейкахОстаткиИОбороты.Номенклатура"));
	
	СхемаКомпоновкиДанных.НаборыДанных.ТоварыВЯчейках.Запрос = ТекстЗапроса;

	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗаголовкиПолей()
	
	Если НЕ ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ЕдиницаВеса = Строка(Константы.ЕдиницаИзмеренияВеса.Получить());
	ЕдиницаОбъема = Строка(Константы.ЕдиницаИзмеренияОбъема.Получить());

	Для Каждого ПолеНабораДанных Из СхемаКомпоновкиДанных.НаборыДанных.ТоварыВЯчейках.Поля Цикл
		Если ТипЗнч(ПолеНабораДанных) = Тип("ПолеНабораДанныхСхемыКомпоновкиДанных") Тогда
			Если СтрНайти(ПолеНабораДанных.Заголовок, "%ЕдиницаВеса%") > 0 Тогда
				ПолеНабораДанных.Заголовок = СтрЗаменить(ПолеНабораДанных.Заголовок, "%ЕдиницаВеса%", ЕдиницаВеса);
			ИначеЕсли СтрНайти(ПолеНабораДанных.Заголовок, "%ЕдиницаОбъема%") > 0 Тогда
				ПолеНабораДанных.Заголовок = СтрЗаменить(ПолеНабораДанных.Заголовок, "%ЕдиницаОбъема%", ЕдиницаОбъема);	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

УстановитьЗаголовкиПолей();

#КонецОбласти

#КонецЕсли