﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	ОбменДаннымиУТ.АктуализироватьПризнакИспользованияОбменаСБухгалтерией(ЭтотОбъект, ПометкаУдаления);
	
	// Очистка неиспользуемых реквизитов и заполнение служебных
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		ВыгружатьЦеныНоменклатуры       = Ложь;
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		
	ИначеЕсли ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
		
		ВыгружатьЦеныНоменклатуры       = Ложь;
		РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		
	Иначе
		
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
	Иначе
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если Не ВыгружатьЦеныНоменклатуры И ВидыЦенНоменклатуры.Количество() <> 0 Тогда
		ВидыЦенНоменклатуры.Очистить();
	ИначеЕсли ВидыЦенНоменклатуры.Количество() = 0 И ВыгружатьЦеныНоменклатуры Тогда
		ВыгружатьЦеныНоменклатуры = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(УправленческаяОрганизация) Тогда
		УправленческаяОрганизация = Справочники.Организации.УправленческаяОрганизация;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументов = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	ОбменДаннымиСобытияУТУП.ОбновитьКэшМеханизмовРегистрации();
	
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОбобщенныйСклад"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ПравилаСозданияДоговоровКонтрагентов"));
	Иначе
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки") 
			И Не ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи")
			И Не СворачиватьДокументыПоСкладу Тогда
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОбобщенныйСклад"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры //ОбработкаПроверкиЗаполнения()

Процедура ПередУдалением(Отказ)
	ОбменДаннымиУТ.АктуализироватьПризнакИспользованияОбменаСБухгалтерией(ЭтотОбъект, Истина);
КонецПроцедуры

#КонецОбласти

#КонецЕсли



