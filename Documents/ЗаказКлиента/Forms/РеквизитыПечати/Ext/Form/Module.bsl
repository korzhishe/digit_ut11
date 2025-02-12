﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,,"ЗакрыватьПриВыборе,ЗакрыватьПриЗакрытииВладельца,КлючНазначенияИспользования");
	Элементы.АдресДоставки.Видимость = НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой");
	ПродажиСервер.ЗаполнитьСписокВыбораАдреса(Элементы.АдресДоставки, Партнер);
	
	Если Параметры.ПараметрыВыбораРеквизитов <> Неопределено Тогда
		Для Каждого ЭлНастройки Из Параметры.ПараметрыВыбораРеквизитов Цикл
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ЭлНастройки.Ключ, "ПараметрыВыбора", ЭлНастройки.Значение);
		КонецЦикла;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗакрытьФормуПринудительно
		И (Модифицированность И Не СохранитьПараметры)
		И НЕ ЗавершениеРаботы Тогда
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
		
		Отказ = Истина;
		
		ДополнительныеПараметры = Новый Структура;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПоказатьВопросПередЗакрытиемЗавершение", ЭтотОбъект, ДополнительныеПараметры),
			НСтр("ru = 'Реквизиты печати были изменены. Закрыть форму без сохранения реквизитов?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросПередЗакрытиемЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "Закрыть" Тогда
		ЗакрытьФормуПринудительно = Истина;
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если СохранитьПараметры И НЕ ЗавершениеРаботы Тогда
		
		СтруктураПараметров = ИзменяемыеРеквизиты(ЭтаФорма);
		ОповеститьОВыборе(СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГрузоотправительПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Грузоотправитель) Тогда
		БанковскийСчетГрузоотправителя = ПолучитьБанковскийСчетКонтрагентаПоУмолчаниюСервер(Грузоотправитель);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрузополучательПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Грузополучатель) Тогда
		БанковскийСчетГрузополучателя = ПолучитьБанковскийСчетКонтрагентаПоУмолчаниюСервер(Грузополучатель);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ТолькоПросмотр Тогда
		СохранитьПараметры = Истина;
	КонецЕсли;
	
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьНазначениеПлатежа(Команда)
	ЗаполнитьНазначениеПлатежа();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервереБезКонтекста
Функция ПолучитьБанковскийСчетКонтрагентаПоУмолчаниюСервер(Контрагент)
	
	Возврат ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетКонтрагентаПоУмолчанию(Контрагент);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменяемыеРеквизиты(Источник)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("АдресДоставки",                  Источник.АдресДоставки);
	СтруктураПараметров.Вставить("БанковскийСчет",                 Источник.БанковскийСчет);
	СтруктураПараметров.Вставить("БанковскийСчетГрузоотправителя", Источник.БанковскийСчетГрузоотправителя);
	СтруктураПараметров.Вставить("БанковскийСчетГрузополучателя",  Источник.БанковскийСчетГрузополучателя);
	СтруктураПараметров.Вставить("БанковскийСчетКонтрагента",      Источник.БанковскийСчетКонтрагента);
	СтруктураПараметров.Вставить("Грузоотправитель",               Источник.Грузоотправитель);
	СтруктураПараметров.Вставить("Грузополучатель",                Источник.Грузополучатель);
	СтруктураПараметров.Вставить("Руководитель",                   Источник.Руководитель);
	СтруктураПараметров.Вставить("ГлавныйБухгалтер",               Источник.ГлавныйБухгалтер);
	СтруктураПараметров.Вставить("НазначениеПлатежа",              Источник.НазначениеПлатежа);
	СтруктураПараметров.Вставить("НомерЗаказа",			           Источник.НомерЗаказа);
	СтруктураПараметров.Вставить("ДатаЗаказа",			           Источник.ДатаЗаказа);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНазначениеПлатежа()
	НазначениеПлатежа = НСтр("ru='По счету №%НомерЗаказа% от %ДатаЗаказа%'");
	НазначениеПлатежа = СтрЗаменить(НазначениеПлатежа,"%НомерЗаказа%",НомерЗаказа);
	НазначениеПлатежа = СтрЗаменить(НазначениеПлатежа,"%ДатаЗаказа%",ДатаЗаказа);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
