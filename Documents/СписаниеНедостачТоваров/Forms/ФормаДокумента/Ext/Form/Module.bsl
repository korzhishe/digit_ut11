﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);


	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик механизма "Назначения"
	Справочники.Назначения.ФормаДокументаПриСозданииНаСервере(ЭтаФорма);
	
	ЗаполнитьПоДаннымВХранилище();

	Элементы.ТоварыНоменклатура.ТолькоПросмотр   = Параметры.ЗапретитьИзменятьТовары;
	Элементы.ТоварыХарактеристика.ТолькоПросмотр = Параметры.ЗапретитьИзменятьТовары;
	Элементы.ТоварыКоличество.ТолькоПросмотр     = Параметры.ЗапретитьИзменятьТовары;
	Элементы.Склад.ТолькоПросмотр                = Параметры.ЗапретитьИзменятьТовары;
	Элементы.Организация.ТолькоПросмотр          = Параметры.ЗапретитьИзменятьТовары;
	Элементы.Товары.ИзменятьСоставСтрок          = Не Параметры.ЗапретитьИзменятьТовары;
	Элементы.Заполнить.Доступность               = Не Параметры.ЗапретитьИзменятьТовары; 
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		Если Объект.СтатьяРасходов = Неопределено Тогда
			Объект.СтатьяРасходов = ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	Если ЭтоАдресВременногоХранилища(Параметры.АдресДанныхВХранилище)
		Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	Элементы.ТоварыПоискПоШтрихкоду.Видимость = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ШтрихкодыНоменклатуры);
	
	УстановитьВидимостьВидЦены(Объект.ИсточникИнформацииОЦенахДляПечати);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	//Кожемякин А.Г. agkozhemyakin@gmail.com {
	//10/19/2017 3:18:13 PM
	//
	дп_ДополнительныеПроцедурыКлиент.ЗаполнитьКодЦС(Объект);
	//}Кожемякин А.Г.
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Справочник.ВидыЗапасов.Форма.ФормаВводаВидовЗапасов" Тогда	
		
		ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение);
		Объект.ВидыЗапасовУказаныВручную = ИсточникВыбора.ВидыЗапасовУказаныВручную;
		Модифицированность = Истина;
		
	ИначеЕсли НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.Назначения.Форма.ФормаВыбора" Тогда	

		Элементы.Товары.ТекущиеДанные.Назначение = ВыбранноеЗначение;

	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// Неизвестные штрихкоды
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		КэшированныеЗначения.Штрихкоды.Очистить();
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ОбработатьШтрихкоды(ДанныеШтрихкодов);
		
	КонецЕсли;
	
	// ИнтеграцияЕГАИС
	Если ИмяСобытия = "Запись_АктСписанияЕГАИС"
		И Параметр.Основание = Объект.Ссылка Тогда
		
		СформироватьТекстДокументаЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Основание = Объект.Ссылка Тогда
		
		СформироватьТекстДокументаЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		СформироватьТекстДокументаЕГАИС();
		
	КонецЕсли;
	// Конец ИнтеграцияЕГАИС
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	// ИнтеграцияЕГАИС
	СформироватьТекстДокументаЕГАИС();
	// Конец ИнтеграцияЕГАИС
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_СписаниеНедостачТоваров", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	//Кожемякин А.Г. agkozhemyakin@gmail.com {
	//10/19/2017 3:18:13 PM
	//
	дп_ДополнительныеПроцедурыКлиент.ЗаполнитьКодЦС(Объект);
	//}Кожемякин А.Г.
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ГруппаДополнительно"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	СкладПриИзмененииСервер();	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникИнформацииОЦенахДляПечатиПриИзменении(Элемент)
	
	ИсточникИнформацииОЦенахДляПечатиПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
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
Процедура СтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатьяРасходовВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Объект.СтатьяРасходов);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Элемент.ПараметрыВыбора);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

// ИнтеграцияЕГАИС
&НаКлиенте
Процедура ТекстДокументаЕГАИСОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСКлиент.ТекстДокументаЕГАИСОбработкаНавигационнойСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры
// Конец ИнтеграцияЕГАИС

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	ФинансыКлиент.СтатьяРасходовПриИзменении(Объект, Элементы);
	СтатьяРасходовПриИзмененииСервер();
		
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
 	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = Элементы.Товары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)

	Если Объект.Товары.Количество() > 0 Тогда
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект), НСтр("ru = 'Табличная часть будет очищена и заполнена всеми товарами, по которым нужно оформить списание. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;

	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЗапасов(Команда)
	
	Перем АдресТоваровВХранилище;
	Перем АдресВидовЗапасовВХранилище;
	
	ПоместитьТоварыИВидыЗапасовВХранилище(
		АдресТоваровВХранилище,
		АдресВидовЗапасовВХранилище);
	ФинансыКлиент.ОткрытьВидыЗапасов(
		Объект,
		АдресТоваровВХранилище,
		АдресВидовЗапасовВХранилище,
		ЭтаФорма,
		(Не ЭтаФорма.ТолькоПросмотр)); // РедактироватьВидыЗапасов
	
КонецПроцедуры // ОткрытьВидыЗапасов()

&НаКлиенте
Процедура ПолучитьВес(Команда)
	
	ТекущаяСтрока = МенеджерОборудованияУТКлиент.ТекущаяСтрока(ЭтаФорма);
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьПолученияВесаСЭлектронныхВесов(
		Новый ОписаниеОповещения("ПолучитьВесЗавершение", ЭтотОбъект, ТекущаяСтрока),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВесЗавершение(РезультатВыполнения, ТекущаяСтрока) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ТекущаяСтрока.Количество = РезультатВыполнения.Вес;
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	Иначе
		МенеджерОборудованияКлиентПереопределяемый.СообщитьОбОшибке(РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	Оповещение = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныхШтрихкода, ДополнительныеПараметры) Экспорт
	
	ОбработатьШтрихкоды(ДанныхШтрихкода);
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ОбработатьШтрихкоды(РезультатВыполнения.ТаблицаТоваров);
	Иначе
		МенеджерОборудованияКлиентПереопределяемый.СообщитьОбОшибке(РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТаблицаФормы      = Элементы.Товары;
	ДанныеТаблицы     = Объект.Товары;
	ТекущаяСтрока     = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыРазбиенияСтроки = ОбщегоНазначенияУТКлиент.ПараметрыРазбиенияСтроки();
	ПараметрыРазбиенияСтроки.ИмяПоляКоличество = "Количество";
	ОбщегоНазначенияУТКлиент.РазбитьСтрокуТЧ(ДанныеТаблицы, ТаблицаФормы,, ПараметрыРазбиенияСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКоличествоВДокументе(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("АдресВоВременномХранилище",            ПоместитьТабличнуюЧастьТоварыВоВременноеХранилищеДляПроверкиКоличества());
	ПараметрыОткрытия.Вставить("ПревышениеКоличестваТоваровРазрешено", Истина);
	ПараметрыОткрытия.Вставить("НеИспользоватьУпаковки",               Истина);
	ПараметрыОткрытия.Вставить("ПараметрыУказанияСерий",               ПараметрыУказанияСерий);
	ПараметрыОткрытия.Вставить("Склад",                                Объект.Склад);
	ПараметрыОткрытия.Вставить("ИмяТабличнойЧасти",                    "Товары");
	ПараметрыОткрытия.Вставить("Ссылка",                               Объект.Ссылка);
	
	ВозвращаемыеПараметры = Неопределено;

	
	ОткрытьФорму("ОбщаяФорма.ПроверкаЗаполненияДокументов", ПараметрыОткрытия,,,,, Новый ОписаниеОповещения("ПроверитьКоличествоВДокументеЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКоличествоВДокументеЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ВозвращаемыеПараметры = Результат;
    Если ВозвращаемыеПараметры <> Неопределено Тогда
        ИзменитьТабличнуюЧастьПоРезультатамПроверки(ВозвращаемыеПараметры, ?(КэшированныеЗначения = Неопределено, ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения(), КэшированныеЗначения));
        
        Модифицированность = Истина;
        
    КонецЕсли;

КонецПроцедуры

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

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтражениеВРеглУчете(Команда)
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыХарактеристика.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ХарактеристикиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары");

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеНазначенияНоменклатуры(ЭтаФорма);

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СкладПриИзмененииСервер()
	Объект.ИсточникИнформацииОЦенахДляПечати = Справочники.Склады.ИсточникИнформацииОЦенахДляПечати(Объект.Склад);
	ИсточникИнформацииОЦенахДляПечатиПриИзмененииСервер();
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Склад));
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(
		Объект,
		Документы.СписаниеНедостачТоваров));																						

	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);

КонецПроцедуры

&НаСервере
Процедура ИсточникИнформацииОЦенахДляПечатиПриИзмененииСервер()
	
	ИсточникИнформацииОЦенахДляПечати = Объект.ИсточникИнформацииОЦенахДляПечати;
	УстановитьЗначениеВидЦены(ИсточникИнформацииОЦенахДляПечати);
	УстановитьВидимостьВидЦены(ИсточникИнформацииОЦенахДляПечати);
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер()
	
	Если ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
		
		ДоходыИРасходыСервер.СтатьяАктивовПассивовПриИзменении(
			Объект,
			Объект.СтатьяРасходов,
			Объект.АналитикаАктивовПассивов);
			
		Объект.АналитикаРасходов = Неопределено;
		АналитикаРасходовОбязательна = Ложь;
		АналитикаРасходовЗаказРеализация = Ложь;
		
	Иначе
		
		ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
			Объект,
			Объект.СтатьяРасходов,
			Объект.АналитикаРасходов);
		
		АналитикаРасходовОбязательна = 
			ЗначениеЗаполнено(Объект.СтатьяРасходов)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
			
		АналитикаРасходовЗаказРеализация = 
			ЗначениеЗаполнено(Объект.СтатьяРасходов)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "АналитикаРасходовЗаказРеализация");
			
		Объект.АналитикаАктивовПассивов = Неопределено;
		
	КонецЕсли;
	
	НаСтатьиАктивовПассивов = (ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов"));
	Элементы.АналитикаРасходов.Видимость         = НЕ НаСтатьиАктивовПассивов;
	Элементы.АналитикаАктивовПассивов.Видимость  = НаСтатьиАктивовПассивов;
	Элементы.ГруппаОтражениеВРеглУчете.Видимость = НаСтатьиАктивовПассивов И ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	Элементы.АналитикаРасходов.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходов);
	Элементы.АналитикаАктивовПассивов.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходов) И Не ТипЗнч(Объект.АналитикаАктивовПассивов) = Тип("ПеречислениеСсылка.СтатьиБезАналитики");
	Элементы.АналитикаРасходов.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаРасходов)));
	Элементы.АналитикаАктивовПассивов.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаАктивовПассивов)));
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	АктуализироватьВидДеятельностиНДС(Истина);
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
		
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);

КонецПроцедуры

#КонецОбласти

#Область ПодборыИОбработкаПроверкиКоличества

&НаСервере
Функция ПоместитьТабличнуюЧастьТоварыВоВременноеХранилищеДляПроверкиКоличества()
	
	ТабличнаяЧастьТовары = Объект.Товары.Выгрузить(,"Номенклатура, Характеристика, ХарактеристикиИспользуются, Количество, Серия, СтатусУказанияСерий, ТипНоменклатуры");
	ТабличнаяЧастьТовары.Свернуть("Номенклатура, Характеристика, ХарактеристикиИспользуются, Серия, СтатусУказанияСерий, ТипНоменклатуры", "Количество");
	ТабличнаяЧастьТовары.Колонки.Добавить("КоличествоУпаковок");
	Для Каждого СтрокаТЧ Из ТабличнаяЧастьТовары Цикл
		СтрокаТЧ.КоличествоУпаковок = СтрокаТЧ.Количество;
	КонецЦикла;
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ТабличнаяЧастьТовары, УникальныйИдентификатор);
	Возврат АдресВоВременномХранилище;
	
КонецФункции

&НаСервере
Процедура ИзменитьТабличнуюЧастьПоРезультатамПроверки(ВозвращаемыеПараметры, КэшированныеЗначения)
	
	ТаблицаТовары = ПолучитьИзВременногоХранилища(ВозвращаемыеПараметры.Товары);
	
	УдаляемыеСтроки = Новый Массив;
	Для Каждого СтрокаИсточник Из ТаблицаТовары Цикл
		
		Отбор = Новый Структура("Номенклатура, Характеристика, Серия, ХарактеристикиИспользуются");
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаИсточник);
		НайденныеСтроки = Объект.Товары.НайтиСтроки(Отбор);
		Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
			
			Если СтрокаИсточник.КоличествоУпаковок = 0 Тогда
				Прервать;
			КонецЕсли;
			
			Если СтрокаИсточник.КоличествоУпаковок >= 0 Тогда
				
				СтрокаТЧ.Количество = СтрокаТЧ.Количество + СтрокаИсточник.КоличествоУпаковок;
				СтрокаИсточник.КоличествоУпаковок = 0;
				
			Иначе
				
				КоличествоКСписанию = -СтрокаИсточник.КоличествоУпаковок;
				КоличествоВСтроке   = СтрокаТЧ.Количество;
				
				Если КоличествоКСписанию > КоличествоВСтроке Тогда
					СтрокаИсточник.КоличествоУпаковок = КоличествоВСтроке - КоличествоКСписанию;
					СтрокаТЧ.Количество               = 0;
				Иначе
					СтрокаИсточник.КоличествоУпаковок = 0;
					СтрокаТЧ.Количество               = КоличествоВСтроке - КоличествоКСписанию;
				КонецЕсли;
				
			КонецЕсли;
			
			Если СтрокаТЧ.Количество = 0 Тогда
				УдаляемыеСтроки.Добавить(СтрокаТЧ);
			Иначе
				
				СтруктураДействий = Новый Структура;
				СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
				СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
				
				ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТЧ, СтруктураДействий, КэшированныеЗначения);
				
			КонецЕсли;
			
		КонецЦикла;
		Если НайденныеСтроки.Количество() = 0 Тогда
			
			СтрокаТЧ = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаИсточник);
			СтрокаТЧ.Количество = СтрокаИсточник.КоличествоУпаковок;
			
			СтруктураДействий = Новый Структура;
			СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
			СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТЧ, СтруктураДействий, КэшированныеЗначения);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из УдаляемыеСтроки Цикл
		Объект.Товары.Удалить(СтрокаТЧ);
	КонецЦикла;
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	ИмяПоляКоличество  = "Количество"; 
	
	СтруктураДействийСДобавленнымиСтроками = Новый Структура;
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
 	СтруктураДействийСДобавленнымиСтроками.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));

	СтруктураДействийСИзмененнымиСтроками = Новый Структура;

	СтруктураДействий = ШтрихкодированиеНоменклатурыКлиент.ПараметрыОбработкиШтрихкодов();

	СтруктураДействий.Штрихкоды                              = ДанныеШтрихкодов;
	СтруктураДействий.СтруктураДействийСДобавленнымиСтроками = СтруктураДействийСДобавленнымиСтроками;
	СтруктураДействий.СтруктураДействийСИзмененнымиСтроками  = СтруктураДействийСИзмененнымиСтроками;
	СтруктураДействий.ПараметрыУказанияСерий                 = ПараметрыУказанияСерий;
	СтруктураДействий.ИмяКолонкиКоличество                   = ИмяПоляКоличество;
	СтруктураДействий.НеИспользоватьУпаковки                 = Истина;
	СтруктураДействий.ИзменятьКоличество                     = Истина;
	СтруктураДействий.ТолькоТовары                           = Истина;
	
	ОбработатьШтрихкодыСервер(СтруктураДействий,КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыКлиент.ОбработатьНеизвестныеШтрихкоды(СтруктураДействий,КэшированныеЗначения,ЭтаФорма);
	
	Если ШтрихкодированиеНоменклатурыКлиент.НужноОткрытьФормуУказанияСерийПослеОбработкиШтрихкодов(СтруктураДействий) Тогда
		
		ТекущиеДанныеИдентификатор = СтруктураДействий.МассивСтрокССериями[0];
		
		ПодключитьОбработчикОжидания("ОткрытьПодборСерийПриСканированииШтрихкодаНоменклатуры",0.1,Истина);
			
	КонецЕсли;
	
	Если СтруктураДействий.ТекущаяСтрока <> Неопределено Тогда
		
		Элементы.Товары.ТекущаяСтрока = СтруктураДействий.ТекущаяСтрока;	
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыСервер(СтруктураПараметровДействия,КэшированныеЗначения)
	ШтрихкодированиеНоменклатурыСервер.ОбработатьШтрихкоды(ЭтаФорма,Объект,СтруктураПараметровДействия,КэшированныеЗначения);
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", ТекущиеДанные = Неопределено)
	
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий,Текст, ТекущиеДанные)Тогда
		ТекстИсключения = НСтр("ru = 'Ошибка при попытке указать серии - в этом документе для указания серий не нужен серверный вызов.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийПриСканированииШтрихкодаНоменклатуры()
	
	Если ТекущиеДанныеИдентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(ТекущиеДанныеИдентификатор);
	ОткрытьПодборСерий(,ТекущиеДанные);

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(
		НоменклатураСервер.ПараметрыУказанияСерий(Объект,
			Документы.СписаниеНедостачТоваров));
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Склад));
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	Элементы.ПересчетТоваров.Видимость = ЗначениеЗаполнено(Объект.ПересчетТоваров);
	
	АналитикаРасходовОбязательна = Ложь;
	АналитикаРасходовЗаказРеализация = Ложь;
	АналитикаДоходовОбязательна = Ложь;
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) 
		 И ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		 
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики, АналитикаРасходовЗаказРеализация"); 
		АналитикаРасходовОбязательна = Реквизиты.КонтролироватьЗаполнениеАналитики;
		АналитикаРасходовЗаказРеализация = Реквизиты.АналитикаРасходовЗаказРеализация;
		
	КонецЕсли;
	
	НаСтатьиАктивовПассивов = (ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов"));
	Элементы.АналитикаРасходов.Видимость         = НЕ НаСтатьиАктивовПассивов;
	Элементы.АналитикаАктивовПассивов.Видимость  = НаСтатьиАктивовПассивов;
	Элементы.ГруппаОтражениеВРеглУчете.Видимость = НаСтатьиАктивовПассивов И ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	Элементы.АналитикаРасходов.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходов);
	Элементы.АналитикаАктивовПассивов.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходов);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		Элементы.СтатьяРасходов.Заголовок = НСтр("ru = 'Статья расходов'");
	КонецЕсли;
	
	АктуализироватьВидДеятельностиНДС();
	
	
	// ИнтеграцияЕГАИС
	СформироватьТекстДокументаЕГАИС();
	// Конец ИнтеграцияЕГАИС
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьТоварыИВидыЗапасовВХранилище(АдресТоваровВХранилище, АдресВидовЗапасовВХранилище)
	
	ЗапасыСервер.ПоместитьТоварыИВидыЗапасовВХранилище(
		Объект.Товары,
		Объект.ВидыЗапасов,
		УникальныйИдентификатор,
		АдресТоваровВХранилище,
		АдресВидовЗапасовВХранилище);
		
КонецПроцедуры // ПоместитьТоварыИВидыЗапасовВХранилище()

&НаСервере
Процедура ПолучитьВидыЗапасовИзХранилища(АдресВидовЗапасовВХранилище)

	Объект.ВидыЗапасов.Загрузить(ПолучитьИзВременногоХранилища(АдресВидовЗапасовВХранилище));
	Модифицированность = Истина;
	
КонецПроцедуры // ПолучитьВидыЗапасовИзХранилища()

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ВремОбъект = РеквизитФормыВЗначение("Объект");
	
	ВремОбъект.Товары.Очистить();
	
	ВремОбъект.ЗаполнитьТабличнуюЧастьТовары();
	
	ЗначениеВРеквизитФормы(ВремОбъект, "Объект");
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
КонецПроцедуры
&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
											
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары,ПараметрыЗаполненияРеквизитов);	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымВХранилище()
	
	Если Не ЭтоАдресВременногоХранилища(Параметры.АдресДанныхВХранилище) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(Параметры.АдресДанныхВХранилище);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.Дата = СтруктураДанных.Шапка.Дата;
		
		ВремОбъект = РеквизитФормыВЗначение("Объект");
		ВремОбъект.Заполнить(Неопределено);
		ЗначениеВРеквизитФормы(ВремОбъект, "Объект");
		
		ЗаполнитьЗначенияСвойств(Объект,СтруктураДанных.Шапка);
	КонецЕсли;	
	
	Для Каждого СтрТабл из СтруктураДанных.ТаблицаТовары Цикл
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрТабл);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьВидЦены(ИсточникИнформацииОЦенахДляПечати)
	
	Если ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен Тогда
		Элементы.ВидЦены.Доступность = Истина;
	ИначеЕсли ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости Тогда
		Элементы.ВидЦены.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеВидЦены(ИсточникИнформацииОЦенахДляПечати)
	
	Если ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен Тогда
		Объект.ВидЦены = Справочники.Склады.УчетныйВидЦены(Объект.Склад);
	ИначеЕсли ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости Тогда
		Объект.ВидЦены = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.СтатьяРасходов = Результат;
	СтатьяРасходовПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура АктуализироватьВидДеятельностиНДС(Проверять = Ложь) 
	
	Если Проверять Тогда
		
		УчетНДСУТ.ПроверитьКорректностьДеятельностиНДСПотребления(
			Объект.ВидДеятельностиНДС,
			Объект.Организация,
			Объект.Дата,
			Перечисления.ХозяйственныеОперации.СписаниеТоваров);
		
	КонецЕсли;
	
	УчетНДСУТ.ЗаполнитьСписокВыбораДеятельностиНДСПотребления(
		Элементы.ВидДеятельностиНДС,
		Объект.Организация,
		Объект.Дата,
		Перечисления.ХозяйственныеОперации.СписаниеТоваров);
	
КонецПроцедуры

// ИнтеграцияЕГАИС
&НаСервере
Процедура СформироватьТекстДокументаЕГАИС()
	
	ИнтеграцияЕГАИСУТ.СформироватьТекстДокументаЕГАИС(ЭтаФорма);
	
КонецПроцедуры
// Конец ИнтеграцияЕГАИС

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

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	//Кожемякин А.Г. agkozhemyakin@gmail.com {
	//10/20/2017 12:11:03 PM
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	дп_ДополнительныеПроцедурыКлиент.УстановитьКодЦС(ТекущаяСтрока);	
	//}Кожемякин А.Г.
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
