﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	Если ТипЗнч(Запись.СпособРаспределения) = Тип("СправочникСсылка.НаправленияДеятельности") Тогда
		ВариантУказанияНаправленияДеятельности = 0;
	Иначе
		ВариантУказанияНаправленияДеятельности = 1;
	КонецЕсли;
	
	УстановитьВидимостьПолей();
	УстановитьПараметрыВыбораПартнера();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантУказанияНаправленияДеятельностиПриИзменении(Элемент)
	
	ВариантУказанияНаправленияДеятельностиПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьВидимостьПолей()

	Если ВариантУказанияНаправленияДеятельности = 0 Тогда
		Элементы.СпособРаспределения.Видимость = Ложь;
		Элементы.НаправлениеДеятельности.Видимость = Истина;
	Иначе
		Элементы.СпособРаспределения.Видимость = Истина;
		Элементы.НаправлениеДеятельности.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораПартнера()
	
	МассивПараметров = Новый Массив;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Клиент", Истина));
	КонецЕсли;
	
	Элементы.Партнер.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ВариантУказанияНаправленияДеятельностиПриИзмененииСервер()
	
	УстановитьВидимостьПолей();
	
	Если ВариантУказанияНаправленияДеятельности = 0
	   И ТипЗнч(Запись.СпособРаспределения) <> Тип("СправочникСсылка.НаправленияДеятельности")
	Тогда
		Запись.СпособРаспределения = Справочники.НаправленияДеятельности.ПустаяСсылка();
		
	ИначеЕсли ВариантУказанияНаправленияДеятельности = 1
		И ТипЗнч(Запись.СпособРаспределения) <> Тип("СправочникСсылка.СпособыРаспределенияПоНаправлениямДеятельности")
	Тогда
		Запись.СпособРаспределения = Справочники.СпособыРаспределенияПоНаправлениямДеятельности.ПустаяСсылка();
		
	КонецЕсли;
	
	Если ВариантУказанияНаправленияДеятельности = 1
	   И Не ЗначениеЗаполнено(Запись.СпособРаспределения) Тогда
		Запись.СпособРаспределения = Справочники.СпособыРаспределенияПоНаправлениямДеятельности.СпособРаспределенияПоУмолчанию(Перечисления.ПравилаРаспределенияПоНаправлениямДеятельности.ПропорциональноКоэффициентам);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
