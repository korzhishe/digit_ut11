﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыХарактеристика");
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "ТоварыУпаковка");
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	Элементы.ТоварыКодАкцизнойМарки.ТолькоПросмотр = Не ОбщегоНазначенияКлиентСервер.РежимОтладки();
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	
	ОповещениеПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		ОповещениеПриПодключении,
		ЭтотОбъект,
		ПоддерживаемыеТипыПодключаемогоОборудования);
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ОповещениеПриОтключении = Новый ОписаниеОповещения("ОтключитьОборудованиеЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораПодборНоменклатуры(
		Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
		ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияПодборНоменклатуры(
		Новый ОписаниеОповещения("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтотОбъект),
		ИмяСобытия, Параметр, Источник);
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(
		Новый ОписаниеОповещения("Подключаемый_ОбработаныНеизвестныеШтрихкоды", ЭтотОбъект),
		ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Прочитать();
		ОбновитьСтатусЕГАИС();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьСтатусЕГАИС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ЗапросАкцизныхМарокЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ПараметрыСканированияАкцизныхМарок = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок();
	ПараметрыСканированияАкцизныхМарок.ПоказатьОшибкуОтсутствияСправок2 = Ложь;
	
	Если Элементы.Товары.ТекущиеДанные <> Неопределено Тогда
		ПараметрыСканированияАкцизныхМарок.ИдентификаторСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	КонецЕсли;
	
	ОповещенияПриЗавершении = СобытияФормЕГАИСКлиент.СтруктураОповещенийВнешнегоСобытия(ЭтотОбъект, Ложь,, ПараметрыСканированияАкцизныхМарок);
	
	СобытияФормЕГАИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(ОповещенияПриЗавершении, ЭтотОбъект, Источник, Событие, Данные, ПараметрыСканированияАкцизныхМарок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатусЕГАИСПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ был изменен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ не проведен. Провести?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииХарактеристики(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЕГАИСКлиентПереопределяемый.НачалоВыбораХарактеристики(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииУпаковки(
		ЭтотОбъект, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЕГАИСКлиентПереопределяемый.НачалоВыбораУпаковки(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыТипМаркиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ТипМарки", ТекущиеДанные.ТипМарки);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораТипаАкцизнойМаркиЕГАИС", ПараметрыФормы, Элемент,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыТипМаркиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = АкцизныеМаркиВызовСервера.ДанныеВыбораТипаМарки(Текст);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, 
		"Документ.ЗапросАкцизныхМарокЕГАИС.ФормаДокумента.Команда.ОткрытьПодбор");
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуПодбораНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ОчиститьСообщения();
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыгрузитьДанныеВТСД(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

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

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтотОбъект);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	ОбновитьСтатусЕГАИС();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
КонецПроцедуры

#Область Штрихкоды

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ПараметрыСканированияАкцизныхМарок = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок();
	ПараметрыСканированияАкцизныхМарок.ПоказатьОшибкуОтсутствияСправок2 = Ложь;
	
	ОповещенияПриЗавершении = СобытияФормЕГАИСКлиент.СтруктураОповещенийВнешнегоСобытия(ЭтотОбъект, Ложь);
	
	АкцизныеМаркиЕГАИСКлиент.ОбработатьДанныеШтрихкода(ОповещенияПриЗавершении, ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканированияАкцизныхМарок);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриПолученииДанныхИзТСД(
		Новый ОписаниеОповещения("Подключаемый_ПолученыДанныеИзТСД", ЭтотОбъект),
		ЭтотОбъект, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
		ЭтотОбъект, ДанныеШтрихкодов, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиШтрихкодов(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработаныНеизвестныеШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения);
	
	Подключаемый_ПолученыШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыДанныеИзТСД(ТаблицаТоваров, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьДанныеИзТСД(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтотОбъект,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкоды(ДанныеДляОбработки, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьШтрихкоды(
		ЭтотОбъект, ДанныеДляОбработки, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДанныеИзТСД(ТаблицаТоваров, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьДанныеИзТСД(
		ЭтотОбъект, ТаблицаТоваров, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученDataMatrix(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипМарки"  , Результат.ТипМарки);
	ПараметрыОтбора.Вставить("СерияМарки", Результат.СерияМарки);
	ПараметрыОтбора.Вставить("НомерМарки", Результат.НомерМарки);
	
	МассивСтрок = Объект.Товары.НайтиСтроки(ПараметрыОтбора);
	Если МассивСтрок.Количество() <> 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТЧ = Неопределено;
	Если ДополнительныеПараметры.ИдентификаторСтроки <> Неопределено Тогда
		
		ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
		
		Если ТекущиеДанные <> Неопределено
			И НЕ ЗначениеЗаполнено(ТекущиеДанные.ТипМарки)
			И НЕ ЗначениеЗаполнено(ТекущиеДанные.СерияМарки)
			И НЕ ЗначениеЗаполнено(ТекущиеДанные.НомерМарки) Тогда
			СтрокаТЧ = ТекущиеДанные;
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтрокаТЧ = Неопределено Тогда
		СтрокаТЧ = Объект.Товары.Добавить();
	КонецЕсли;
	
	СтрокаТЧ.ТипМарки   = Результат.ТипМарки;
	СтрокаТЧ.СерияМарки = Результат.СерияМарки;
	СтрокаТЧ.НомерМарки = Результат.НомерМарки;
	
	Если Результат.Справки2.Количество() <> 0 Тогда
		ДанныеСправки2 = Результат.Справки2[0];
		
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.АлкогольнаяПродукция)
			И НЕ ЗначениеЗаполнено(СтрокаТЧ.Номенклатура)
			И НЕ ЗначениеЗаполнено(СтрокаТЧ.Характеристика)
			И НЕ ЗначениеЗаполнено(СтрокаТЧ.Упаковка) Тогда
			СтрокаТЧ.АлкогольнаяПродукция = ДанныеСправки2.АлкогольнаяПродукция;
			СтрокаТЧ.Номенклатура         = ДанныеСправки2.Номенклатура;
			СтрокаТЧ.Характеристика       = ДанныеСправки2.Характеристика;
			СтрокаТЧ.Упаковка             = ДанныеСправки2.Упаковка;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Подбор

&НаСервере
Процедура ОбработкаРезультатаПодбораНоменклатуры(ВыбранноеЗначение, ПараметрыЗаполнения)
	
	СобытияФормЕГАИСПереопределяемый.ОбработкаРезультатаПодбораНоменклатуры(ЭтотОбъект, ВыбранноеЗначение, ПараметрыЗаполнения);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, Объект.Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаПодбораНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ОбработкаРезультатаПодбораНоменклатуры(Результат, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область Статус

&НаСервере
Процедура ОбновитьСтатусЕГАИС()
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);
	
	СтатусЕГАИС        = МенеджерОбъекта.СтатусПоУмолчанию();
	ДальнейшееДействие = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие1 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие3
		|	КОНЕЦ КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовЕГАИС КАК Статусы
		|ГДЕ
		|	Статусы.Документ = &Документ");
		
		Запрос.УстановитьПараметр("Документ", Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияЕГАИС.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусЕГАИС = Выборка.Статус;
			
			ДальнейшееДействие = Новый Массив;
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие1);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие2);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие3);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеАкцизныеМарки);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеПередачуДанных);
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(
		СтатусЕГАИС,
		ДальнейшееДействие,
		ДопустимыеДействия);
	
	РедактированиеФормыНеДоступно = СтатусЕГАИС <> Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.Черновик
	                              И СтатусЕГАИС <> Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.ОшибкаПередачи;
	
	Элементы.ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное.ТолькоПросмотр = РедактированиеФормыНеДоступно;
	Элементы.СтраницаТовары.ТолькоПросмотр                                      = РедактированиеФормыНеДоступно;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ЗапроситьАкцизныеМарки" Тогда
		
		ИнтеграцияЕГАИСКлиент.ПодготовитьКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеАкцизныеМарки"));
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачу" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПередачу(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Оборудование

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти