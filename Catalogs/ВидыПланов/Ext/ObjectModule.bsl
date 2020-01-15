﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ЭтоНовый() И ТипПлана.Пустая()  Тогда
		
		ДоступныеТипы = Новый Массив;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеЗакупок") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланЗакупок);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродажПоКатегориям") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланПродажПоКатегориям);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланПродаж);
		КонецЕсли;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки") Тогда
			ДоступныеТипы.Добавить(Перечисления.ТипыПланов.ПланСборкиРазборки);
		КонецЕсли;
		
		Если ДанныеЗаполнения <> Неопределено 
			И ДанныеЗаполнения.Свойство("ТипПлана") 
			И ДоступныеТипы.Найти(ДанныеЗаполнения.ТипПлана) <> Неопределено Тогда
			ТипПлана = ДанныеЗаполнения.ТипПлана;
		ИначеЕсли ДоступныеТипы.Количество() > 0 Тогда
			ТипПлана = ДоступныеТипы[0];
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьВидПланаПоОтбору(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЗаполнятьПоФормуле Тогда
		ЗаполнятьПартнераВТЧ = Ложь;
		ЗаполнятьСоглашениеВТЧ = Ложь;
		ЗаполнятьСкладВТЧ = Ложь;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		ЗаполнятьСклад = Истина;
	КонецЕсли;
	
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	Если ТипПлана = Перечисления.ТипыПланов.ПланПроизводства Тогда
		ЗаполнятьПартнера = Ложь;
		ЗаполнятьПартнераВТЧ = Ложь;
		ЗаполнятьСоглашение = Ложь;
		ЗаполнятьСоглашениеВТЧ = Ложь;
		ЗаполнятьСклад = Ложь;
		ЗаполнятьСкладВТЧ = Ложь;
		ЗаполнятьПланОплат = Ложь;
	ИначеЕсли ТипПлана = Перечисления.ТипыПланов.ПланПродаж И НЕ ИспользоватьСоглашенияСКлиентами Тогда
		ЗаполнятьСоглашение = Ложь;
		ЗаполнятьСоглашениеВТЧ = Ложь;
	КонецЕсли; 
	Если ЗаполнятьПланОплат И (ЗаполнятьПартнераВТЧ ИЛИ ЗаполнятьСоглашениеВТЧ) Тогда
		ЗаполнятьПланОплат = Ложь;
	КонецЕсли;
	Если ЗаполнятьФорматМагазина
		И (ЗаполнятьСклад 
		ИЛИ ЗаполнятьСкладВТЧ)
		И (ТипПлана = Перечисления.ТипыПланов.ПланПродаж 
		ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланПродажПоКатегориям) Тогда
		ЗаполнятьФорматМагазина = Ложь;
	КонецЕсли; 
	Если ЗаполнятьФорматМагазина И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьФорматыМагазинов") Тогда
		ЗаполнятьФорматМагазина = Ложь;
	КонецЕсли; 
	Если НЕ ЗаполнятьПартнера И НЕ ЗаполнятьПартнераВТЧ Тогда
		ЗаполнятьСоглашение = Ложь;
		ЗаполнятьСоглашениеВТЧ = Ложь;
	ИначеЕсли НЕ ЗаполнятьПартнера И ЗаполнятьПартнераВТЧ Тогда
		ЗаполнятьСоглашение = Ложь;
	КонецЕсли;
	
	Если ЗаполнятьПланОплат 
		И (ТипПлана = Перечисления.ТипыПланов.ПланЗакупок 
		ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланПродаж) Тогда
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, "ПланЗакупокПланироватьПоСумме, ПланПродажПланироватьПоСумме");
		
		Если ТипПлана = Перечисления.ТипыПланов.ПланЗакупок 
			И НЕ Реквизиты.ПланЗакупокПланироватьПоСумме
			ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланПродаж 
			И НЕ Реквизиты.ПланПродажПланироватьПоСумме Тогда
		
			ЗаполнятьПланОплат = Ложь;
		
		КонецЕсли; 
		
	КонецЕсли; 
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	
	Если НЕ Замещающий Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КоличествоПериодов");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьВидПланаПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Владелец") И ДанныеЗаполнения.Свойство("ТипПлана") Тогда
		
		Сценарий = ДанныеЗаполнения.Владелец;
		ТипПлана = ДанныеЗаполнения.ТипПлана;
		
		Если НЕ ЗначениеЗаполнено(Сценарий) ИЛИ НЕ ЗначениеЗаполнено(ТипПлана) Тогда
			Возврат;
		КонецЕсли;
		
		ВидПлана = Планирование.ПолучитьВидПланаПоУмолчанию(ТипПлана, Сценарий);
		
		Если ЗначениеЗаполнено(ВидПлана) Тогда
			ИменаРеквизитов = "ЗаполнятьПартнера, ЗаполнятьСоглашение, ЗаполнятьСклад, ЗаполнятьПодразделение, 
				|ЗаполнятьПартнераВТЧ, ЗаполнятьСоглашениеВТЧ, ЗаполнятьСкладВТЧ, ЗаполнятьМенеджера, ЗаполнятьФорматМагазина,
				|ЗапретитьРедактированиеПравила, ЗаполнятьПланОплат, ЗаполнятьПоФормуле";
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана, ИменаРеквизитов);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
