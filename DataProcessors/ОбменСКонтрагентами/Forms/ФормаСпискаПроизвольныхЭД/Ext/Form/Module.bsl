﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьОбменЭД") Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы("РаботаСЭД");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.СписокИсходящих.Обновить();
		Элементы.СписокВходящих.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПодчиненныеДокументы(СтрокаОснование, МассивСтрок, ТЗПодчиненных)
	
	ТЗ = ТЗПодчиненных.Скопировать(МассивСтрок);
	ТЗ.Сортировать("Дата, Номер");
	Для Каждого СтрокаТЗ Из ТЗ Цикл
		НоваяСтрока = СтрокаОснование.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗ);
		Отбор = Новый Структура("ДокументОснование", СтрокаТЗ.Ссылка);
		НайденныеСтроки = ТЗПодчиненных.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЗаполнитьПодчиненныеДокументы(НоваяСтрока, НайденныеСтроки, ТЗПодчиненных);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
