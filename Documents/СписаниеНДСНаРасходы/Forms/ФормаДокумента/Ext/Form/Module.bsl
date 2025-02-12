﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
	ОписаниеТиповСчетФактура = Метаданные.ОпределяемыеТипы.СчетФактура.Тип;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	УчетНДСУТ.НастроитьСовместныйВыборКонтрагентовОрганизаций(Элементы.Поставщик);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	ПриЧтенииСозданииНаСервере();

	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_СписаниеНДСНаРасходы", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЦенности(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Организация");
	СтруктураРеквизитов.Вставить("Поставщик");
	СтруктураРеквизитов.Вставить("СчетФактура");
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьЦенностиНажатиеПослеПроверки", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Объект.Ценности, 
		СтруктураРеквизитов,
		Ложь,
		НСтр("ru = 'Ценности'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЦенностиНажатиеПослеПроверки(Результат, ДополнительныеПараметры) Экспорт 
	
	Объект.Ценности.Очистить();
	ЗаполнитьЦенностиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЦенностиПриИзменении(Элемент)
	
	Объект.СуммаНДС = Объект.Ценности.Итог("НДС");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатьяРасходовВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Объект.СтатьяРасходов);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Элемент.ПараметрыВыбора);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	ФинансыКлиент.СтатьяРасходовПриИзменении(Объект, Элементы);
	СтатьяРасходовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если АналитикаРасходовЗаказРеализация Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходов = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст)
		ИЛИ АналитикаРасходовЗаказРеализация
	Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст)
		ИЛИ АналитикаРасходовЗаказРеализация
	Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СчетФактураПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СчетФактура) Тогда
		ПоказатьВопросОчисткаЦенности();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетФактураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.СчетФактура = Неопределено Тогда
	
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ДоступныеТипы", ОписаниеТиповСчетФактура);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыборТипаСчетаФактуры", ЭтотОбъект);
		ОткрытьФорму("ОбщаяФорма.ВыборТипаИзСписка", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетФактураОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Объект.СчетФактура = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	АналитикаРасходовОбязательна = Ложь;
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
		 
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики, АналитикаРасходовЗаказРеализация"); 
		АналитикаРасходовОбязательна = Реквизиты.КонтролироватьЗаполнениеАналитики;
		
	КонецЕсли;
	
	Элементы.АналитикаРасходов.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходов);
	УстановитьСвязиПараметровВыбораСчетаФактуры();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЦенностиСервер() 
	
	Документы.СписаниеНДСНаРасходы.ЗаполнитьСписаниеНДСНаРасходы(Объект);
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер()
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
		Объект,
		Объект.СтатьяРасходов,
		Объект.АналитикаРасходов);
		
	АналитикаРасходовОбязательна = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
		
	Элементы.АналитикаРасходов.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходов);	
	Элементы.АналитикаРасходов.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаРасходов)));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.СтатьяРасходов = Результат;
	СтатьяРасходовПриИзмененииСервер();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросОчисткаЦенности()
	
	Если Объект.Ценности.Количество() > 0 Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОчисткаЦенностиЗавершение", ЭтотОбъект),
				НСтр("ru='Список ""Ценности"" будет очищен. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьЦенностиСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаЦенностиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Ценности.Очистить();
	ЗаполнитьЦенностиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыборТипаСчетаФактуры(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыФормы = ПараметрыОткрытияФормыВыбораСчетаФактуры(Результат);
	
	Если ПараметрыФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораСчетаФактуры", ЭтотОбъект);
	ОткрытьФорму(ПараметрыФормы.ИмяФормыВыбора, ПараметрыФормы.ПараметрыОткрытия, ЭтаФорма, , , , ОписаниеОповещения); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораСчетаФактуры(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		Объект.СчетФактура = Результат;
		УстановитьСвязиПараметровВыбораСчетаФактуры();
		ПоказатьВопросОчисткаЦенности();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыВыбораСчетаФактуры(ТипЗначения)
	
	Если ТипЗначения = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФормыВыбора = Метаданные.НайтиПоТипу(ТипЗначения).ПолноеИмя() + ".ФормаВыбора";
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяФормыВыбора", ИмяФормыВыбора);
	
	Отбор = Новый Структура;
	Для каждого Параметр Из СвязиПараметрыОтбора(ТипЗначения) Цикл
		Отбор.Вставить(Параметр.Ключ, Объект[Параметр.Значение]);
	КонецЦикла;
	
	Результат.Вставить("ПараметрыОткрытия", Новый Структура("Отбор", Отбор));
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СвязиПараметрыОтбора(ТипЗначения)
	
	СвязиПараметрыОтбора = Новый Структура;
	Если ТипЗначения = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями") Тогда
		СвязиПараметрыОтбора.Вставить("Организация", "Поставщик");
		СвязиПараметрыОтбора.Вставить("ОрганизацияПолучатель", "Организация");
	ИначеЕсли ТипЗначения = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями") Тогда
		СвязиПараметрыОтбора.Вставить("ОрганизацияПолучатель", "Организация");
		СвязиПараметрыОтбора.Вставить("Организация", "Поставщик");
	Иначе
		СвязиПараметрыОтбора.Вставить("Организация", "Организация");
		СвязиПараметрыОтбора.Вставить("Контрагент", "Поставщик");
	КонецЕсли;
		
	Возврат СвязиПараметрыОтбора;
	
КонецФункции

&НаСервере
Процедура УстановитьСвязиПараметровВыбораСчетаФактуры()
	
	ПараметрыОтбора = СвязиПараметрыОтбора(ТипЗнч(Объект.СчетФактура));
	
	МассивОтборов = Новый Массив;
	Для каждого Отбор Из ПараметрыОтбора Цикл
		МассивОтборов.Добавить(Новый СвязьПараметраВыбора("Отбор." + Отбор.Ключ, "Объект." + Отбор.Значение));
	КонецЦикла;
	
	СчетФактураПараметрыВыбора = Новый ФиксированныйМассив(МассивОтборов);
	Элементы.СчетФактура.СвязиПараметровВыбора = СчетФактураПараметрыВыбора;
	
КонецПроцедуры

#КонецОбласти