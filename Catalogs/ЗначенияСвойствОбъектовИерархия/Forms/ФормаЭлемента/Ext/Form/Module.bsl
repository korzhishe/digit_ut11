﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
	   И Параметры.ЗначенияЗаполнения.Свойство("Наименование") Тогда
		
		Объект.Наименование = Параметры.ЗначенияЗаполнения.Наименование;
	КонецЕсли;
	
	Если НЕ Параметры.СкрытьВладельца Тогда
		Элементы.Владелец.Видимость = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ПоказатьВес) = Тип("Булево") Тогда
		ПоказатьВес = Параметры.ПоказатьВес;
	Иначе
		ПоказатьВес = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Владелец, "ДополнительныеЗначенияСВесом");
	КонецЕсли;
	
	Если ПоказатьВес = Истина Тогда
		Элементы.Вес.Видимость = Истина;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ЗначенияСВесом");
	Иначе
		Элементы.Вес.Видимость = Ложь;
		Объект.Вес = 0;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ЗначенияБезВеса");
	КонецЕсли;
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменение_ЗначениеХарактеризуетсяВесовымКоэффициентом"
	   И Источник = Объект.Владелец Тогда
		
		Если Параметр = Истина Тогда
			Элементы.Вес.Видимость = Истина;
		Иначе
			Элементы.Вес.Видимость = Ложь;
			Объект.Вес = 0;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ЗначенияСвойствОбъектовИерархия",
		Новый Структура("Ссылка", Объект.Ссылка), Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		Объект.Владелец, "Заголовок, ЗаголовокФормыЗначения");
	
	ИмяСвойства = СокрЛП(ЗначенияРеквизитов.ЗаголовокФормыЗначения);
	
	Если НЕ ПустаяСтрока(ИмяСвойства) Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (%2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Создание)'"), ИмяСвойства);
		КонецЕсли;
	Иначе
		ИмяСвойства = Строка(ЗначенияРеквизитов.Заголовок);
		
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (Значение свойства %2)'"),
				Объект.Наименование,
				ИмяСвойства);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Значение свойства %1 (Создание)'"), ИмяСвойства);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
