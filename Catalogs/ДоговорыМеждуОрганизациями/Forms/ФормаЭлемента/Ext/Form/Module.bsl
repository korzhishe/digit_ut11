﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ФиксированнаяСуммаДоговора И Объект.Сумма = 0 Тогда
		
		ТекстОшибки = НСтр("ru='Не заполнена сумма договора.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			Объект.Ссылка,
			"Объект.Сумма",
			,
			Отказ);
	КонецЕсли;
	
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	
	ОбновитьЗаголовокФормы();
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененРеквизитЗависящийОтСтатуса"
		И Параметр.УникальныйИдентификатор = УникальныйИдентификатор Тогда
		Если Объект.Согласован Тогда
			Объект.Согласован = Ложь;
		КонецЕсли;
		ПодключитьОбработчикОжидания("Подключаемый_ПриИзмененииРеквизитаЗависящегоОтСтатуса", 0.1, Истина);
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл"
			И Параметр.Свойство("ВладелецФайла")
			И Параметр.ВладелецФайла = Объект.Ссылка
			И Параметр.ЭтоНовый
			И ДобавляетсяФайлПодтверждающегоДокумента Тогда
			
		Элементы.ПодтверждающиеДокументы.ТекущиеДанные.Файл = Источник[0];
		ДобавляетсяФайлПодтверждающегоДокумента = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	Если Объект.Согласован И 
		Объект.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Действует")
		И Объект.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Закрыт")
	Тогда
		Объект.Согласован = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДоговораПриИзменении(Элемент)
	
	ТипДоговораПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(Объект.Организация, Объект.ПорядокОплаты, Объект.БанковскийСчет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПолучательПриИзменении(Элемент)
	
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(Объект.ОрганизацияПолучатель, Объект.ПорядокОплаты, Объект.БанковскийСчетПолучателя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокОплатыПриИзменении(Элемент)
	
	ПорядокОплатыПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)
	
	ВалютаВзаиморасчетовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Элементы.НаименованиеДляПечати.СписокВыбора.Очистить();
	Элементы.НаименованиеДляПечати.СписокВыбора.Добавить(Объект.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура КлассификацияЗадолженностиПриИзменении(Элемент)
	
	Если КлассификацияЗадолженности = 1 Тогда
		Объект.УстановленСрокОплаты = Истина;
		Объект.СрокОплаты = 366; // Значение больше 365 календарных дней
	Иначе
		Объект.УстановленСрокОплаты = Ложь;
		Объект.СрокОплаты = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	Возврат;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодтверждающиеДокументы

&НаКлиенте
Процедура ПодтверждающиеДокументыВидДокументаПриИзменении(Элемент)
	
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждающиеДокументыФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКалькуляцияЗатрат

&НаКлиенте
Процедура КалькуляцияЗатратСуммаПриИзменении(Элемент)
	
	ДанныеКалькуляции = Элементы.КалькуляцияЗатрат.ТекущиеДанные;
	
	Если ДанныеКалькуляции.СуммаКВозмещению > ДанныеКалькуляции.Сумма Тогда
		ДанныеКалькуляции.СуммаКВозмещению = ДанныеКалькуляции.Сумма;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КалькуляцияЗатратСуммаКВозмещениюПриИзменении(Элемент)
	
	ДанныеКалькуляции = Элементы.КалькуляцияЗатрат.ТекущиеДанные;
	
	Если ДанныеКалькуляции.СуммаКВозмещению > ДанныеКалькуляции.Сумма Тогда
		ДанныеКалькуляции.СуммаКВозмещению = ДанныеКалькуляции.Сумма;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(Объект, 
		Новый Структура("ДатаНачала, ДатаОкончания", "ДатаНачалаДействия", "ДатаОкончанияДействия"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
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
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодтверждающиеДокументы(Команда)
	
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьПодтверждающийДокумент(Команда)
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", Ложь);
	
	ПоддержкаПлатежей275ФЗ = ПолучитьФункциональнуюОпцию("ПоддержкаПлатежейВСоответствииС275ФЗ");
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаВзаиморасчетов) Тогда
		Объект.ВалютаВзаиморасчетов = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета();
	КонецЕсли;
	
	ФиксированнаяСуммаДоговора = (Объект.Сумма <> 0);
	
	
	ПараметрыВыбораБанковскогоСчета = ПараметрыВыбораБанковскихСчетов(Объект.ПорядокОплаты);
	Элементы.БанковскийСчет.ПараметрыВыбора            = ПараметрыВыбораБанковскогоСчета;
	Элементы.БанковскийСчетПолучателя.ПараметрыВыбора  = ПараметрыВыбораБанковскогоСчета;
	ДенежныеСредстваСервер.УстановитьПараметрыВыбораСтавкиНДС(Элементы.СтавкаНДС);
	
	НастроитьПараметрыВыбораСтатьиДвиженияДенежныхСредств();
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	
	УправлениеЭлементамиГрафикИсполнения(Элементы, ФиксированнаяСуммаДоговора);
	
	
	ОбновитьЗаголовокФормы();
	
	Перечисления.ПорядокОплатыПоСоглашениям.ЗаполнитьВозможныеПорядкиОплаты(Объект.ВалютаВзаиморасчетов,Элементы.ПорядокОплаты, Объект.ПорядокОплаты);
	
	Элементы.НаименованиеДляПечати.СписокВыбора.Очистить();
	Элементы.НаименованиеДляПечати.СписокВыбора.Добавить(Объект.Наименование);
	
	Перечисления.ПорядокОплатыПоСоглашениям.ЗаполнитьВозможныеПорядкиОплаты(Объект.ВалютаВзаиморасчетов, Элементы.ПорядокОплаты, Объект.ПорядокОплаты);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ФиксированнаяСуммаДоговораПриИзменении(Элемент)
	
	Если Не ФиксированнаяСуммаДоговора Тогда
		Объект.Сумма = 0;
	КонецЕсли;
	
	УправлениеЭлементамиГрафикИсполнения(Элементы, ФиксированнаяСуммаДоговора);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПлатежаГОЗПриИзменении(Элемент)
	
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ГосударственныйКонтрактПриИзменении(Элемент)
	
	
	Возврат;
	
КонецПроцедуры

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


&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиГрафикИсполнения(Элементы, ФиксированнаяСуммаДоговора)
	
	Элементы.Сумма.Доступность = ФиксированнаяСуммаДоговора;
	Элементы.Сумма.АвтоОтметкаНезаполненного = ФиксированнаяСуммаДоговора;
	
КонецПроцедуры


&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ТипДоговораПриИзмененииСервер()
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПорядокОплатыПриИзмененииСервер()
	
	Если Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях 
		ИЛИ Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВВалюте Тогда
		Объект.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить();
	ИначеЕсли Объект.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		Объект.ВалютаВзаиморасчетов = Справочники.Валюты.ПустаяСсылка();
	КонецЕсли;
	
	ПараметрыВыбораБанковскихСчетов = ПараметрыВыбораБанковскихСчетов(Объект.ПорядокОплаты);
	Элементы.БанковскийСчет.ПараметрыВыбора            = ПараметрыВыбораБанковскихСчетов;
	Элементы.БанковскийСчетПолучателя.ПараметрыВыбора = ПараметрыВыбораБанковскихСчетов;
	
	Если НЕ БанковскийСчетСоответствуетПорядкуОплаты(Объект.БанковскийСчет, Объект.ПорядокОплаты) Тогда
		Объект.БанковскийСчет = Неопределено;
	КонецЕсли;
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(Объект.Организация, Объект.ПорядокОплаты, Объект.БанковскийСчет);
	
	Если НЕ БанковскийСчетСоответствуетПорядкуОплаты(Объект.БанковскийСчетПолучателя, Объект.ПорядокОплаты) Тогда
		Объект.БанковскийСчетПолучателя = Неопределено;
	КонецЕсли;
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(Объект.ОрганизацияПолучатель, Объект.ПорядокОплаты, Объект.БанковскийСчетПолучателя);
	
КонецПроцедуры

&НаСервере
Процедура ВалютаВзаиморасчетовПриИзмененииСервер()
	
	ВалютаОплатыРегл = ?(Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте ИЛИ 
					Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВВалюте, Ложь ,Неопределено);
					
	Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(Объект.ВалютаВзаиморасчетов,,ВалютаОплатыРегл);
	
	ПорядокОплатыПриИзмененииСервер();
	
	Перечисления.ПорядокОплатыПоСоглашениям.ЗаполнитьВозможныеПорядкиОплаты(Объект.ВалютаВзаиморасчетов, Элементы.ПорядокОплаты, Объект.ПорядокОплаты);

	
	ПорядокОплатыПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область КонтрольНесогласованныхИзменений

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеПриИзменении(Элемент)
	Если Элемент.Имя = "ОрганизацияПолучатель" Тогда
		ОрганизацияПолучательПриИзменении(Элемент);
	ИначеЕсли Элемент.Имя = "Организация" Тогда
		ОрганизацияПриИзменении(Элемент);
	ИначеЕсли Элемент.Имя = "ВалютаВзаиморасчетов" Тогда
		ВалютаВзаиморасчетовПриИзменении(Элемент);
	ИначеЕсли Элемент.Имя = "ПорядокОплаты" Тогда
		ПорядокОплатыПриИзменении(Элемент);
	ИначеЕсли Элемент.Имя = "ТипДоговора" Тогда
		ТипДоговораПриИзменении(Элемент);
	Иначе
		ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеКоманды(Команда)
	Если Команда.Имя = "УстановитьИнтервал" Тогда
		УстановитьИнтервал(Команда);
	Иначе
		ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Команда);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередНачаломИзменения(Элемент, Отказ)
	
	ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередУдалением(Элемент, Отказ)
	
	ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзменении_УстановитьДоступностьЭлементовПоСтатусуСервер(Элемент)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.ПриИзменении.Свойство(Элемент.Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеПриИзменении(Элемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Команда_УстановитьДоступностьЭлементовПоСтатусуСервер(Команда)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.Команды.Свойство(Команда.Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеКоманды(Команда);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПередНачаломИзменения_УстановитьДоступностьЭлементовПоСтатусуСервер(Элемент, Отказ)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.ПередНачаломИзменения.Свойство(Элемент.Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередНачаломИзменения(Элемент, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПередУдалением_УстановитьДоступностьЭлементовПоСтатусуСервер(Элемент, Отказ)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Имя = Элемент.Имя;
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.ПередУдалением.Свойство(Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередУдалением(Элемент, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПередНачаломДобавления_УстановитьДоступностьЭлементовПоСтатусуСервер(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Имя = Элемент.Имя;
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.ПередНачаломДобавления.Свойство(Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизитаЗависящегоОтСтатуса()
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	ОбщегоНазначенияУТКлиент.ПослеИзмененияРеквизитаЗависящегоОтСтатуса(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьДоступностьЭлементовПоСтатусуСервер()
	
	УстановитьПодписку = Ложь;
	
	Если Объект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.НеСогласован Тогда
		УстановитьПодписку = Ложь;
	ИначеЕсли Объект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.Закрыт Или
		Объект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.Действует Тогда
		УстановитьПодписку = Объект.Согласован;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	
	// Элементы управления шапки
	МассивЭлементов.Добавить("Дата");
	МассивЭлементов.Добавить("Номер");
	МассивЭлементов.Добавить("ДатаНачалаДействия");
	МассивЭлементов.Добавить("ДатаОкончанияДействия");
	МассивЭлементов.Добавить("ОрганизацияПолучатель");
	МассивЭлементов.Добавить("Организация");
	МассивЭлементов.Добавить("ВалютаВзаиморасчетов");
	МассивЭлементов.Добавить("ПорядокОплаты");
	МассивЭлементов.Добавить("ТипДоговора");
	МассивЭлементов.Добавить("ПорядокРасчетов");
	МассивЭлементов.Добавить("УстановитьИнтервал");
	
	ОбщегоНазначенияУТ.УстановитьПодпискуНаСобытияИзмененияЭлементовФормы(ЭтаФорма, МассивЭлементов, УстановитьПодписку);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыВыбораБанковскихСчетов(ПорядокОплаты)

	МассивПараметров = Новый Массив;
	
	Если ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях
	 ИЛИ ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВРублях Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", Константы.ВалютаРегламентированногоУчета.Получить()));
	Иначе
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", Новый ФиксированныйМассив(ИностранныеВалюты())));
	КонецЕсли;
	
	МассивПараметров.Добавить(Новый ПараметрВыбора("ВыборСчетовГоловнойОрганизации", Неопределено));
	
	Возврат Новый ФиксированныйМассив(МассивПараметров);
	
КонецФункции

&НаСервереБезКонтекста
Функция ИностранныеВалюты()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Ссылка <> &ВалютаРегламентированногоУчета
	|");
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервереБезКонтекста
Функция БанковскийСчетСоответствуетПорядкуОплаты(БанковскийСчет, ПорядокОплаты)

	Соответствует = Истина;
	
	Если ЗначениеЗаполнено(БанковскийСчет) Тогда
		
		ВалютаСчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчет, "ВалютаДенежныхСредств");
		
		Если ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте Тогда
			Соответствует = ВалютаСчета <> Константы.ВалютаРегламентированногоУчета.Получить();
		Иначе
			Соответствует = ВалютаСчета = Константы.ВалютаРегламентированногоУчета.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Соответствует;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ВладелецСчета, ПорядокОплаты, СчетКЗаполнению)
	
	Если ЗначениеЗаполнено(СчетКЗаполнению)
	 ИЛИ НЕ ЗначениеЗаполнено(ВладелецСчета) Тогда
		Возврат;
	КонецЕсли;
	
	ОплатаВВалюте = ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте
		ИЛИ ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВВалюте;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчетаОрганизаций.Ссылка КАК БанковскийСчет
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	БанковскиеСчетаОрганизаций.Владелец = &Организация
	|	И ((БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте)
	|	ИЛИ (БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте))
	|	И Не БанковскиеСчетаОрганизаций.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("Организация", ВладелецСчета);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		СчетКЗаполнению = Выборка.БанковскийСчет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Если Объект.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа Тогда
		ПредставлениеТипа = НСтр("ru='Договор купли-продажи'");
	ИначеЕсли Объект.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.Комиссионный Тогда
		ПредставлениеТипа = НСтр("ru='Договор комиссии'");
	Иначе
		ПредставлениеТипа = ЭтаФорма.Заголовок;
	КонецЕсли;
	
	Если Объект.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа Тогда
		Элементы.ГруппаОрганизация.Заголовок = НСтр("ru='Поставщик'");
		Элементы.ГруппаОрганизацияПолучатель.Заголовок = НСтр("ru='Покупатель'");
		Элементы.ГруппаФинансовогоУчета.Заголовок = НСтр("ru='Группа учета расчетов с покупателем'");
		Элементы.ГруппаФинансовогоУчетаПолучателя.Заголовок = НСтр("ru='Группа учета расчетов с поставщиком'");
	Иначе
		Элементы.ГруппаОрганизация.Заголовок = НСтр("ru='Комитент'");
		Элементы.ГруппаОрганизацияПолучатель.Заголовок = НСтр("ru='Комиссионер'");
		Элементы.ГруппаФинансовогоУчета.Заголовок = НСтр("ru='Группа учета расчетов с комиссионером'");
		Элементы.ГруппаФинансовогоУчетаПолучателя.Заголовок = НСтр("ru='Группа учета расчетов с комитентом'");
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЭтаФорма.Заголовок = ПредставлениеТипа + " (" + НСтр("ru='создание'") + ")";
	Иначе
		ЭтаФорма.Заголовок = Объект.Наименование + " (" + ПредставлениеТипа + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыВыбораСтатьиДвиженияДенежныхСредств()
	
	МассивПараметровВыбора = Новый Массив;
	
	ПараметрВыбора = Новый ПараметрВыбора("Отбор.ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	МассивПараметровВыбора.Добавить(ПараметрВыбора);
	Элементы.СтатьяДвиженияДенежныхСредств.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
	МассивПараметровВыбора.Очистить();
	
	ПараметрВыбора = Новый ПараметрВыбора("Отбор.ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ОплатаПоставщику);
	МассивПараметровВыбора.Добавить(ПараметрВыбора);
	Элементы.СтатьяДвиженияДенежныхСредствПолучателя.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

