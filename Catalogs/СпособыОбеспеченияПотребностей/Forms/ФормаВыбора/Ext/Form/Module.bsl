﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("Склад", Склад) И ЗначениеЗаполнено(Склад) Тогда

		Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
			ОтбиратьПоСкладу = Истина;
		КонецЕсли;

	КонецЕсли;

	ОбновитьОтборСписка(Список, ОтбиратьПоСкладу, Склад, Параметры.Отбор);

	Элементы.ГруппаОтбор.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") И Параметры.Свойство("Склад");

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОтбиратьПоСкладуПриИзменении(Элемент)

	Если Параметры.Свойство("Отбор") Тогда
		ПараметрыОтбор = Параметры.Отбор;
	Иначе
		ПараметрыОтбор = Неопределено;
	КонецЕсли;
	ОбновитьОтборСписка(Список, ОтбиратьПоСкладу, Склад, ПараметрыОтбор);

КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)

	ОбновитьОтборСписка(Список, ОтбиратьПоСкладу, Склад, Параметры.Отбор);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтборСписка(Список, ОтбиратьПоСкладу, Склад, Отбор)

	Если Отбор <> Неопределено И Отбор.Свойство("ТипОбеспечения") Тогда

		СписокТиповОбеспечения = Новый СписокЗначений();
		Для Каждого Элемент Из Отбор.ТипОбеспечения цикл
			СписокТиповОбеспечения.Добавить(Элемент);
		КонецЦикла;

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Ссылка.ТипОбеспечения", СписокТиповОбеспечения, ВидСравненияКомпоновкиДанных.ВСписке);

	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ОтбиратьПоСкладу", ОтбиратьПоСкладу);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Склад", Склад);

КонецПроцедуры

#КонецОбласти
