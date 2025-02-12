﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		Список = Элементы.ТипЗначения.СписокВыбора;
		Список.Удалить(Список.НайтиПоЗначению("СправочникСсылка.ОбъектыЭксплуатации"));
		Список.Удалить(Список.НайтиПоЗначению("СправочникСсылка.НематериальныеАктивы"));
	КонецЕсли;
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	УстановитьВидимостьПолей();
	УстановитьВидимостьТиповЗначенийАналитики();
	
	Пояснение1 = НСтр("ru='Основная система налогообложения указывается в учетной политике.
		|Прибыли, накопленные в течение месяца, списываются на счет 99.01.1
		|""Прибыли и убытки по деятельности с основной системой налогообложения""'");
	Пояснение2 = НСтр("ru='Доходы по деятельности, порядок налогообложения которой не совпадает с основным.
		|В частности, по деятельности, переведенной на уплату ЕНВД или патентную систему налогообложения.
		|Прибыли, накопленные в течение месяца, списываются на счет 99.01.2 
		|""Прибыли и убытки по отдельным видам деятельности с особым порядком налогообложения""'");
	
	Если Метаданные.ПланыСчетов.Найти("Хозрасчетный") <> Неопределено Тогда
		Элементы.КорреспондирующийСчет.Видимость = Ложь;
	Иначе
		ЗаполнитьСписокВыбораКорСчета();
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		Элементы.СтраницаРегламентированныйУчет.Видимость = Ложь;
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПустаяСтрока(ТипЗначения) Тогда
		ТекстСообщения = НСтр("ru = 'В поле ""Аналитика доходов"" не выбрано ни одного вида аналитики'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			, // ОбъектИлиСсылка
			"ТипЗначения",
			, // ПутьКДанным
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	Если Не ПустаяСтрока(ТипЗначения) Тогда
		ТекущийОбъект.ТипЗначения = Новый ОписаниеТипов(ТипЗначения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	
	Возврат; // Обработчик используется только в УТ
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятиеКналоговомуУчетуПриИзменении(Элемент)
	
	Возврат; // Обработчик используется только в УТ
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСчетаРеглУчетаПоОрганизациямИПодразделениям(Команда)
	
	
	Возврат; // Чтобы в УТ был не пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьВидимостьТиповЗначенийАналитики()
	
	МассивИсключаемыхТипов = Новый Массив;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		МассивИсключаемыхТипов.Добавить("ДокументСсылка.ЗаказПоставщику");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.НаправленияДеятельности");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		МассивИсключаемыхТипов.Добавить("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.СтруктураПредприятия");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.Организации");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыКредитовИДепозитов") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.ДоговорыКредитовИДепозитов");
	КонецЕсли;
	
	Для Каждого ИсключаемыйТип Из МассивИсключаемыхТипов Цикл
		ЭлементСписка = Элементы.ТипЗначения.СписокВыбора.НайтиПоЗначению(ИсключаемыйТип);
		Если ЭлементСписка <> Неопределено И ТипЗначения <> ИсключаемыйТип Тогда
			Элементы.ТипЗначения.СписокВыбора.Удалить(ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПолей()

	Если Объект.Ссылка = ПланыВидовХарактеристик.СтатьиДоходов.ВыручкаОтПродаж Тогда
		Элементы.СпособРаспределения.Видимость = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьТипЗначения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипЗначения()

	СписокТиповЗначений = Новый СписокЗначений;
	СписокТиповЗначений.Добавить("СправочникСсылка.Организации");
	СписокТиповЗначений.Добавить("СправочникСсылка.СтруктураПредприятия");
	СписокТиповЗначений.Добавить("СправочникСсылка.НаправленияДеятельности");
	СписокТиповЗначений.Добавить("СправочникСсылка.Партнеры");
	СписокТиповЗначений.Добавить("ДокументСсылка.ЗаказПоставщику");
	СписокТиповЗначений.Добавить("СправочникСсылка.ДоговорыКредитовИДепозитов");
	СписокТиповЗначений.Добавить("ПеречислениеСсылка.АналитикаКурсовыхРазниц");

	Для Каждого ЭлементСписка Из СписокТиповЗначений Цикл
		Если Объект.ТипЗначения.СодержитТип(Тип(ЭлементСписка.Значение)) Тогда
			ТипЗначения = ЭлементСписка.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКорСчета()

	СписокВыбора = Элементы.КорреспондирующийСчет.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить("91.01", НСтр("ru='Прочие доходы (91.01)'"));

КонецПроцедуры


#КонецОбласти

#КонецОбласти
