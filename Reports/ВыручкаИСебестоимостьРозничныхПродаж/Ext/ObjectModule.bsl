﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	// Дополнительные команды
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.НастройкиОтчета;
	
	Если Параметры.Свойство("РасширенныйОтбор") Тогда
		РасширенныйОтбор = КомпоновщикНастроекФормы.ФиксированныеНастройки.Отбор.Элементы.Добавить(
			Тип("ЭлементОтбораКомпоновкиДанных"));
		РасширенныйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
		Если ТипЗнч(Параметры.РасширенныйОтбор) = Тип("Массив") Тогда
			ЭтоМассив = Истина;
			Если Параметры.РасширенныйОтбор.Количество() > 0 Тогда
				ПервыйЭлемент = Параметры.РасширенныйОтбор[0];
			Иначе
				ПервыйЭлемент = Неопределено;
			КонецЕсли;
		Иначе
			ЭтоМассив = Ложь;
			ПервыйЭлемент = Параметры.РасширенныйОтбор;
		КонецЕсли;
		Если ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.Партнеры") Тогда
			Если ЭтоМассив Тогда
				ЕстьПодчиненныеПартнеры = Ложь;
				Для Каждого ЭлементПараметраКоманды Из Параметры.РасширенныйОтбор Цикл
					Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
						ЕстьПодчиненныеПартнеры = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			Иначе
				ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(Параметры.РасширенныйОтбор);
			КонецЕсли;
			Если ЕстьПодчиненныеПартнеры И ЭтоМассив Тогда
				РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
			ИначеЕсли ЕстьПодчиненныеПартнеры Тогда
				РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			ИначеЕсли ЭтоМассив Тогда
				РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Иначе
				РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
			РасширенныйОтбор.ПравоеЗначение = Параметры.РасширенныйОтбор;
		ИначеЕсли ТипЗнч(Параметры.РасширенныйОтбор) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
			РасширенныйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			РасширенныйОтбор.ПравоеЗначение = СегментыСервер.МассивЭлементов(
				ПервыйЭлемент);
		КонецЕсли;
		РасширенныйОтбор.Использование = Истина;
	КонецЕсли;
	

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	КомпоновщикНастроекФормы.Настройки.ДополнительныеСвойства.Вставить("КлючТекущегоВарианта", ЭтаФорма.КлючТекущегоВарианта);
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПриЗагрузкеВариантаНаСервере
//
Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	Параметры = ЭтаФорма.НастройкиОтчета;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	Если Параметры.Свойство("Расшифровка") И Параметры.Расшифровка <> Неопределено
		И Параметры.Расшифровка.ПрименяемыеНастройки.ДополнительныеСвойства.Свойство("ФиксированныеНастройки") Тогда
		КомпоновщикНастроекФормы.ЗагрузитьНастройки(Параметры.Расшифровка.ПрименяемыеНастройки);
	КонецЕсли;
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ВыручкаИСебестоимостьПродаж.Запрос;

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесНоменклатуры1", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("Таблица.Номенклатура.ЕдиницаИзмерения", "Таблица.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемНоменклатуры1", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("Таблица.Номенклатура.ЕдиницаИзмерения", "Таблица.Номенклатура"));

	СхемаКомпоновкиДанных.НаборыДанных.ВыручкаИСебестоимостьПродаж.Запрос = ТекстЗапроса;

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураЗаголовковПолей(), МакетКомпоновки);
	
	// Проверим, что хотя бы одна группировка отчета включена
	Если МакетКомпоновки.НаборыДанных.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru= 'Отчет не сформирован. Включите хотя бы одну группировку в ""Элементы оформления и группировки"".'") ;
	КонецЕсли;
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроверяемыеПоля = Новый Массив;
	ПроверяемыеПоля.Добавить("Поставщик");
	УниверсальныеМеханизмыПартийИСебестоимости.ДобавитьПредупреждениеОбОсобенностяхФормированияОтчета(ДокументРезультат, КомпоновщикНастроек, ПроверяемыеПоля);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.ОформитьДиаграммыОтчета(КомпоновщикНастроек, ДокументРезультат);
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	КомпоновкаДанныхСервер.УстановитьПараметрыВалютыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	КомпоновкаДанныхСервер.НастроитьДинамическийПериод(СхемаКомпоновкиДанных, КомпоновщикНастроек, Истина);
	
	ПараметрПоказыватьПродажи = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ПоказыватьПродажи");
	Если ПараметрПоказыватьПродажи <> Неопределено 
		И ПараметрПоказыватьПродажи.Значение = Неопределено Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПоказыватьПродажи", 1);
				
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
	// Строковые литералы
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаПродажиПоЗаказам", НСтр("ru='Продажи по заказам'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаПродажиБезЗаказов", НСтр("ru='Продажи без заказов'"));
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	ВспомогательныеПараметры = Новый Массив;
	
	КлючТекущегоВарианта = "";
	Если КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("КлючТекущегоВарианта", КлючТекущегоВарианта) Тогда
		Если Не КлючТекущегоВарианта = "ДинамикаПродажРозницы"
			И Не КлючТекущегоВарианта = "ДинамикаПродажРозницыБизнесРегионы" Тогда
			ВспомогательныеПараметры.Добавить("Периодичность");
		КонецЕсли;
	КонецЕсли;
	
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	ВспомогательныеПараметры.Добавить("МаксимумСерийКоличество");
	ВспомогательныеПараметры.Добавить("ВыделениеСерийДиаграмм");
	ВспомогательныеПараметры.Добавить("ОтслеживаемыеАналитики");
	ВспомогательныеПараметры.Добавить("ГрадиентСерийДиаграмм");
	ВспомогательныеПараметры.Добавить("ОтображениеМаркеровТочекДиаграмм");
	
	Возврат ВспомогательныеПараметры;

КонецФункции

Функция СтруктураЗаголовковПолей()
	СтруктураЗаголовковПолей = Новый Структура;
	
	СтруктураЗаголовковВалют = КомпоновкаДанныхСервер.СтруктураЗаголовковВалют(КомпоновщикНастроек);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктураЗаголовковВалют, Ложь);
	
	СтруктуруЗаголовковПолейЕдиницИзмерений = КомпоновкаДанныхСервер.СтруктураЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураЗаголовковПолей, СтруктуруЗаголовковПолейЕдиницИзмерений, Ложь);
	
	Возврат СтруктураЗаголовковПолей;
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Организация");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Склад");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли