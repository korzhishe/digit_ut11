﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ЕстьОшибки = Ложь;

	МассивДопустимыхТиповОС= РегистрыСведений.ДоступныеВерсииАгентаКопированияОблачногоАрхива.ПолучитьЗначенияДопустимыхТиповОС();

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		Если МассивДопустимыхТиповОС.Найти(ТекущаяЗапись.ТипОС) = Неопределено Тогда
			ЕстьОшибки = Истина;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Недопустимое значение типа ОС: [%1]'"),
				ТекущаяЗапись.ТипОС);
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.Поле  = "ТипОС";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЦикла;

	Отказ = ЕстьОшибки;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		ТекущаяЗапись.ВерсияАгентаКопирования = ИнтернетПоддержкаПользователейКлиентСервер.ВнутреннееПредставлениеНомераВерсии(ТекущаяЗапись.ВерсияАгентаКопирования);
		ТекущаяЗапись.ВерсияПодсистемы        = ИнтернетПоддержкаПользователейКлиентСервер.ВнутреннееПредставлениеНомераВерсии(ТекущаяЗапись.ВерсияПодсистемы);
	КонецЦикла;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли