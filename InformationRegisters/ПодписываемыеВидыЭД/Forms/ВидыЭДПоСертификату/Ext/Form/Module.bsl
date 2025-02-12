﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	АктуальныеЭД = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.АктуальныеВидыЭД();
	
	Для Каждого ВидЭД Из АктуальныеЭД Цикл
		Строки = ВидыПодписываемыхЭД.НайтиСтроки(Новый Структура("ВидЭД", ВидЭД));
		Если Строки.Количество() = 0 Тогда
			Если Параметры.Отбор.Свойство("СертификатЭП") Тогда
				НоваяЗапись = ВидыПодписываемыхЭД.Добавить();
				НоваяЗапись.СертификатЭП = Параметры.Отбор.СертификатЭП;
				НоваяЗапись.ВидЭД = ВидЭД;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ВидыПодписываемыхЭД.Сортировать("ВидЭД");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ЗавершениеРаботы И ДанныеИзменены Тогда
		ОчиститьСообщения();
		СохранитьИзмененияНаСервере(Отказ, Истина);

		Если Отказ Тогда
			СписокКнопок = Новый СписокЗначений;
			СписокКнопок.Добавить("Записать");
			СписокКнопок.Добавить("ПродолжитьРедактирование", НСтр("ru = 'Продолжить редактирование'"));
			СписокКнопок.Добавить("ЗакрытьБезСохранения", НСтр("ru = 'Закрыть без сохранения'"));
			ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
			
			ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'В заданных настройках обнаружены возможные ошибки.'"),
				СписокКнопок,, "ПродолжитьРедактирование", НСтр("ru = 'Настройка некорректна'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	ИзменитьОтметку(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	ИзменитьОтметку(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОтметку(Пометка)
	
	Для Каждого Строка Из ВидыПодписываемыхЭД Цикл
		Строка.Использовать = Пометка;
	КонецЦикла;
	ДанныеИзменены = Истина;
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИспользоватьПриИзменении(Элемент)
	
	ДанныеИзменены = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		
		УсловноеОформление.Элементы.Очистить();

		Элемент = УсловноеОформление.Элементы.Добавить();

		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидЭД.Имя);

		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидыПодписываемыхЭД.ВидЭД");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления["ВидыЭД"].СоглашениеОбИзмененииСтоимостиОтправитель;

		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Соглашение об изменении стоимости (отправитель)'"));
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьИзмененияНаСервере(Отказ, ВыполнятьПроверку = Ложь)
	
	СертификатЭП = ВидыПодписываемыхЭД.Отбор.СертификатЭП.Значение;
	НаборЗаписейПосле = ВидыПодписываемыхЭД.Выгрузить();
	
	Если ВыполнятьПроверку Тогда
		НаборЗаписейДо = РегистрыСведений.ПодписываемыеВидыЭД.СоздатьНаборЗаписей();
		НаборЗаписейДо.Отбор.СертификатЭП.Установить(СертификатЭП);
		НаборЗаписейДо.Прочитать();
		НаборЗаписейДо = НаборЗаписейДо.Выгрузить();
		
		ПроверитьВалидностьПоВсемЗависимымНастройкам(Отказ, НаборЗаписейДо, НаборЗаписейПосле);
	КонецЕсли;
	
	Если Не Отказ Тогда
		РегистрыСведений.ПодписываемыеВидыЭД.СохранитьПодписываемыеВидыЭД(СертификатЭП, НаборЗаписейПосле);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьВалидностьПоВсемЗависимымНастройкам(Отказ, СтарыйНаборЗаписей, НовыйНаборЗаписей)
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	ЕстьОбменСБанками = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками");
	
	Если ЕстьОбменСКонтрагентами ИЛИ ЕстьОбменСБанками Тогда
		// Вычислим виды документов, по которым сняли флаг использования.
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("СтарыйНабор", СтарыйНаборЗаписей);
		Запрос.УстановитьПараметр("НовыйНабор", НовыйНаборЗаписей);
		Запрос.УстановитьПараметр("ПустойМаршрут", Справочники.МаршрутыПодписания.ПустаяСсылка());
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СтарыйНабор.СертификатЭП,
		|	СтарыйНабор.ВидЭД,
		|	СтарыйНабор.Использовать
		|ПОМЕСТИТЬ СтарыйНабор
		|ИЗ
		|	&СтарыйНабор КАК СтарыйНабор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НовыйНабор.СертификатЭП,
		|	НовыйНабор.ВидЭД,
		|	НовыйНабор.Использовать
		|ПОМЕСТИТЬ НовыйНабор
		|ИЗ
		|	&НовыйНабор КАК НовыйНабор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтарыйНабор.СертификатЭП,
		|	СтарыйНабор.ВидЭД
		|ПОМЕСТИТЬ ОтключенныеВидыДокументов
		|ИЗ
		|	СтарыйНабор КАК СтарыйНабор
		|		ЛЕВОЕ СОЕДИНЕНИЕ НовыйНабор КАК НовыйНабор
		|		ПО СтарыйНабор.СертификатЭП = НовыйНабор.СертификатЭП
		|			И СтарыйНабор.ВидЭД = НовыйНабор.ВидЭД
		|			И (НовыйНабор.Использовать)
		|ГДЕ
		|	СтарыйНабор.Использовать
		|	И НовыйНабор.СертификатЭП ЕСТЬ NULL
		|;";
		
		// Найдем все настройки обмена с банками / с контрагентами, в которых указан маршрут
		ТекстЗапросаНастроек = "";
		ТекстОбъединения = 
		"
		|	
		|ОБЪЕДИНИТЬ ВСЕ
		|	
		|";
		
		Если ЕстьОбменСКонтрагентами Тогда
			ТекстЗапросаНастроек = 
			"ВЫБРАТЬ
			|	ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент КАК ВидДокумента,
			|	ПрофилиНастроекЭДОИсходящиеДокументы.МаршрутПодписания КАК МаршрутПодписания,
			|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка КАК НастройкаОбмена,
			|	ПрофилиНастроекЭДОСертификатыПодписейОрганизации.Сертификат КАК Сертификат
			|ПОМЕСТИТЬ ВидыДокументовПоНастройкам
			|ИЗ
			|	Справочник.ПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПрофилиНастроекЭДО.СертификатыПодписейОрганизации КАК ПрофилиНастроекЭДОСертификатыПодписейОрганизации
			|		ПО ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка = ПрофилиНастроекЭДОСертификатыПодписейОрганизации.Ссылка
			|ГДЕ
			|	ПрофилиНастроекЭДОИсходящиеДокументы.МаршрутПодписания <> &ПустойМаршрут
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент,
			|	СоглашенияОбИспользованииЭДИсходящиеДокументы.МаршрутПодписания,
			|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка,
			|	СоглашенияОбИспользованииЭДСертификатыПодписейОрганизации.Сертификат
			|ИЗ
			|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СоглашенияОбИспользованииЭД.СертификатыПодписейОрганизации КАК СоглашенияОбИспользованииЭДСертификатыПодписейОрганизации
			|		ПО СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка = СоглашенияОбИспользованииЭДСертификатыПодписейОрганизации.Ссылка
			|ГДЕ
			|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.РасширенныйРежимНастройкиСоглашения
			|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.МаршрутПодписания <> &ПустойМаршрут";
		КонецЕсли;
		
		Если ЕстьОбменСБанками Тогда
			ТекстЗапросаПоБанкам = 
			"ВЫБРАТЬ
			|	НастройкиОбменСБанкамиИсходящиеДокументы.ИсходящийДокумент КАК ВидДокумента,
			|	НастройкиОбменСБанкамиИсходящиеДокументы.МаршрутПодписания КАК МаршрутПодписания,
			|	НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка КАК НастройкаОбмена,
			|	НастройкиОбменСБанкамиСертификатыПодписейОрганизации.СертификатЭП КАК Сертификат
			|%ПомещениеВоВременнуюТаблицу%
			|ИЗ
			|	Справочник.НастройкиОбменСБанками.ИсходящиеДокументы КАК НастройкиОбменСБанкамиИсходящиеДокументы
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиОбменСБанками.СертификатыПодписейОрганизации КАК НастройкиОбменСБанкамиСертификатыПодписейОрганизации
			|		ПО НастройкиОбменСБанкамиИсходящиеДокументы.Ссылка = НастройкиОбменСБанкамиСертификатыПодписейОрганизации.Ссылка
			|ГДЕ
			|	НастройкиОбменСБанкамиИсходящиеДокументы.МаршрутПодписания <> &ПустойМаршрут";
			ТекстЗапросаПоБанкам = СтрЗаменить(ТекстЗапросаПоБанкам, 
				"%ПомещениеВоВременнуюТаблицу%", 
				?(ЗначениеЗаполнено(ТекстЗапросаНастроек), "", "ПОМЕСТИТЬ ВидыДокументовПоНастройкам"));
				
			ТекстЗапросаНастроек = ТекстЗапросаНастроек 
				+ ?(ЗначениеЗаполнено(ТекстЗапросаНастроек), ТекстОбъединения, "") + ТекстЗапросаПоБанкам;
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса 
			+ Символы.ПС 
			+ ТекстЗапросаНастроек
			+ Символы.ПС
			+ ";"
			+ Символы.ПС +
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ВидыДокументовПоНастройкам.ВидДокумента КАК ВидДокумента,
			|	ВидыДокументовПоНастройкам.НастройкаОбмена КАК НастройкаОбмена
			|ПОМЕСТИТЬ ДанныеДляПроверки
			|ИЗ 
			|	ВидыДокументовПоНастройкам КАК ВидыДокументовПоНастройкам
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтключенныеВидыДокументов
			|			ПО ВидыДокументовПоНастройкам.ВидДокумента = ОтключенныеВидыДокументов.ВидЭД
			|				И ВидыДокументовПоНастройкам.Сертификат = ОтключенныеВидыДокументов.СертификатЭП
			|;
			|
			|ВЫБРАТЬ
			|	ВидыДокументовПоНастройкам.ВидДокумента КАК ВидДокумента,
			|	ВидыДокументовПоНастройкам.НастройкаОбмена КАК НастройкаОбмена,
			|	ВидыДокументовПоНастройкам.МаршрутПодписания КАК МаршрутПодписания,
			|	ВидыДокументовПоНастройкам.Сертификат
			|ИЗ
			|	ДанныеДляПроверки КАК ДанныеДляПроверки
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВидыДокументовПоНастройкам КАК ВидыДокументовПоНастройкам
			|			ПО ДанныеДляПроверки.ВидДокумента = ВидыДокументовПоНастройкам.ВидДокумента
			|				И ДанныеДляПроверки.НастройкаОбмена = ВидыДокументовПоНастройкам.НастройкаОбмена
			|ИТОГИ ПО
			|	НастройкаОбмена,
			|	МаршрутПодписания,
			|	ВидДокумента";
		Запрос.Текст = ТекстЗапроса;
		
		// Обойдем настройки и проверим каждую на валидность
		ВыборкаНастроек = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаНастроек.Следующий() Цикл
			НаборСертификатов = Новый Массив;
			СертификатыСчитаны = Ложь;
			
			ВыборкаМаршрутов = ВыборкаНастроек.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаМаршрутов.Следующий() Цикл
				НаборВидовЭД = Новый Массив;
				
				ВыборкаВидов = ВыборкаМаршрутов.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаВидов.Следующий() Цикл
					НаборВидовЭД.Добавить(ВыборкаВидов.ВидДокумента);
					
					Если Не СертификатыСчитаны Тогда
						ВыборкаСертификатов = ВыборкаВидов.Выбрать();
						Пока ВыборкаСертификатов.Следующий() Цикл
							Если ЗначениеЗаполнено(ВыборкаСертификатов.Сертификат) Тогда
								НаборСертификатов.Добавить(ВыборкаСертификатов.Сертификат);
							КонецЕсли;
						КонецЦикла;
						СертификатыСчитаны = Истина;
					КонецЕсли;
				КонецЦикла;
				
				РезультатыПроверки = ЭлектронноеВзаимодействиеСлужебный.РезультатыПроверкиМаршрутаПоПараметрамНастройки(
					ВыборкаМаршрутов.МаршрутПодписания, НаборСертификатов, НаборВидовЭД, НовыйНаборЗаписей);
					
				// Ошибки недоступности сертификатов для подписания вида ЭД в целом пропускаем - это не ошибка настройки маршрута.
				ЭлектронноеВзаимодействиеСлужебный.ВывестиРезультатыПроверкиМаршрута(РезультатыПроверки, 
					ВыборкаНастроек.НастройкаОбмена, ВыборкаМаршрутов.МаршрутПодписания, Отказ);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры
	
&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = "Записать" Тогда
		ОчиститьСообщения();
		СохранитьИзмененияНаСервере(Ложь);
	ИначеЕсли Ответ = "ЗакрытьБезСохранения" Тогда
		ДанныеИзменены = Ложь;
		ОчиститьСообщения();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти





