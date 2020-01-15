﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УстановитьНедоступныеОтборыИзПараметров(Параметры.Отбор);
	
	Если Параметры.Свойство("Партнер") Тогда
		
		СписокПартнеров = Новый СписокЗначений;
		ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(Параметры.Партнер, СписокПартнеров);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Партнер", 
			СписокПартнеров, 
			ВидСравненияКомпоновкиДанных.ВСписке,
			, 
			Истина);
		
		Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Параметры.Партнер);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"ПартнерПоУмолчанию", 
			Параметры.Партнер, 
			ВидСравненияКомпоновкиДанных.Равно,
			, 
			Истина);
		
	Иначе
		
		Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Справочники.Партнеры.ПустаяСсылка());
		
	КонецЕсли;
	
	Если Параметры.Свойство("НалогообложениеНДС") Тогда 
		УчетАгентскогоНДС = (Параметры.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НалоговыйАгентПоНДС);  
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка( 
			Список, 
			"УчетАгентскогоНДС", 
			УчетАгентскогоНДС, 
			ВидСравненияКомпоновкиДанных.Равно, 
			, 
			Истина); 
	КонецЕсли;
		
	Если Параметры.Отбор.Свойство("ХозяйственнаяОперация") И
		Параметры.Отбор.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика И
		Параметры.Свойство("ПоказыватьЗакупкуПоИмпорту") Тогда
		
		МассивХозяйственныхОпераций = Новый Массив();
		МассивХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика);
		МассивХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту);

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"ХозяйственнаяОперация", 
			МассивХозяйственныхОпераций,
			ВидСравненияКомпоновкиДанных.ВСписке);
			
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтборМенеджер.СписокВыбора, 
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Справочники.ДоговорыКонтрагентов));
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Параметры.Отбор.Очистить();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Менеджер = Настройки.Получить("Менеджер");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Менеджер", 
		Менеджер, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Менеджер));
	
	Настройки.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборМенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Менеджер", 
		Менеджер, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Процедура устанавливает отборы, переданные в структуре. Отборы недоступны для изменения.
//
// Параметры:
//	СтруктураОтбора - Структура - Ключ: имя поля компоновки данных, Значение: значение отбора.
//
&НаСервере
Процедура УстановитьНедоступныеОтборыИзПараметров(СтруктураОтбора)
	
	Для Каждого ЭлементОтбора Из СтруктураОтбора Цикл
		
		Если ЭлементОтбора.Ключ = "Контрагент" И ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			
			РеквизитОтбора = ?(ЗначениеЗаполнено(ЭлементОтбора.Значение),
			                   ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементОтбора.Значение, "Партнер"),
			                   Справочники.Партнеры.ПустаяСсылка());
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			   Список, 
			   "Партнер", 
			   РеквизитОтбора,
			   ВидСравненияКомпоновкиДанных.Равно);
			
			Продолжить;
			
		КонецЕсли;
		
		Если ЭлементОтбора.Ключ = "ХозяйственнаяОперация" 
			И ЭлементОтбора.Значение = Перечисления.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список, 
				ЭлементОтбора.Ключ, 
				Перечисления.ХозяйственныеОперации.РеализацияКлиенту,
				ВидСравненияКомпоновкиДанных.Равно);
			
			Продолжить;
			
		КонецЕсли;

		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("ФиксированныйМассив") Тогда
			ВидСравненияКомпоновки = ВидСравненияКомпоновкиДанных.Всписке;
		Иначе
			ВидСравненияКомпоновки = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			ЭлементОтбора.Ключ, 
			ЭлементОтбора.Значение, 
			ВидСравненияКомпоновки);
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
