﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Помещает во временное хранилище схему компоновки данных,
// настройки компоновки данных и возвращает их адреса
//
// Параметры:
//	ЦельСсылка - Ссылка, СправочникСсылка.СтруктураЦелей - цель, для которой требуется получить адреса
//
// Возвращаемое значение:
//	Структура - структура, содержащая адреса
//				СхемаКомпоновкиДанных - Строка - адрес схемы компоновки данных
//				НастройкиКомпоновкиДанных - Строка - адрес настроек компоновки данных
//
Функция АдресаСхемыКомпоновкиДанныхИНастроекВоВременномХранилище(ЭлементСтруктурыЦелей) Экспорт
	
	Адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных");
	
	Если ТипЗнч(ЭлементСтруктурыЦелей) = Тип("ДанныеФормыСтруктура") Тогда
		ЭлементСтруктурыЦелейСсылка = ЭлементСтруктурыЦелей.Ссылка;
	Иначе
		ЭлементСтруктурыЦелейСсылка = ЭлементСтруктурыЦелей;
	КонецЕсли;
	
	// Получим схему компоновки данных
	Если ЗначениеЗаполнено(ЭлементСтруктурыЦелей.СхемаКомпоновкиДанных) ИЛИ ЭлементСтруктурыЦелейСсылка.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СхемаИНастройки = ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(ЭлементСтруктурыЦелейСсылка, ЭлементСтруктурыЦелей.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = ЭлементСтруктурыЦелейСсылка.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	Если СхемаКомпоновкиДанных = Неопределено И ПустаяСтрока(ЭлементСтруктурыЦелей.СхемаКомпоновкиДанных) Тогда
		СхемаКомпоновкиДанных = Справочники.СтруктураЦелей.ПолучитьМакет("ШаблоннаяСхемаКомпоновкиДанных");
	ИначеЕсли СхемаКомпоновкиДанных = Неопределено И Не ПустаяСтрока(ЭлементСтруктурыЦелей.СхемаКомпоновкиДанных) Тогда
		СхемаКомпоновкиДанных = Справочники.СтруктураЦелей.ПолучитьМакет(ЭлементСтруктурыЦелей.СхемаКомпоновкиДанных);
	КонецЕсли;
	
	ОтключитьОтборыПоФункциональнымОпциям(СхемаКомпоновкиДанных.ВариантыНастроек.Основной.Настройки);
	Адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	
	Настройки = ЭлементСтруктурыЦелейСсылка.ХранилищеНастроекКомпоновкиДанных.Получить();
	
	Если ЗначениеЗаполнено(Настройки) Тогда
		ОтключитьОтборыПоФункциональнымОпциям(Настройки);
		Адреса.НастройкиКомпоновкиДанных = ПоместитьВоВременноеХранилище(Настройки, Новый УникальныйИдентификатор());
	КонецЕсли;
	
	Возврат Адреса;
	
КонецФункции

// Возвращает поля-ресурсы, доступные для выбора пользователем
//
// Параметры:
//	ЦельСсылка - Ссылка, СправочникСсылка.СтруктураЦелей - цель, для которой требуется получить поля-ресурсы
//
// Возвращаемое значение:
//	СписокЗначений - список, доступных пользователю полей-ресурсов (имя и синоним)
//
Функция ДоступныеЗначенияАнализа(ЦельСсылка) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокДоступныхЗначений = Новый СписокЗначений;
	
	Если ЗначениеЗаполнено(ЦельСсылка.СхемаКомпоновкиДанных) ИЛИ ЦельСсылка.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СхемаИНастройки = ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(ЦельСсылка, ЦельСсылка.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = ЦельСсылка.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	Настройки = ЦельСсылка.ХранилищеНастроекКомпоновкиДанных.Получить();
	
	АдресСКД = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	Если НЕ Настройки = Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	ДоступныеПоля = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы;
	
	СлужебныеПоля = СлужебныеПоляЗначенияАнализа();
	
	Для Каждого ДоступноеПоле Из ДоступныеПоля Цикл 
		Если НЕ ДоступноеПоле.Ресурс 
			ИЛИ НЕ СлужебныеПоля.Найти(Строка(ДоступноеПоле.Поле)) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СписокДоступныхЗначений.Добавить(ДоступноеПоле.Поле, ДоступноеПоле.Заголовок);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СписокДоступныхЗначений;
	
КонецФункции

// Возвращает поля-измерения, доступные для выбора пользователем
//
// Параметры:
//	ЦельСсылка - Ссылка, СправочникСсылка.СтруктураЦелей - цель, для которой требуется получить поля-измерения
//
// Возвращаемое значение:
//	СписокЗначений - список, доступных пользователю полей-измерений (имя и синоним)
//
Функция ДоступныеОбъектыАнализа(ЦельСсылка) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокДоступныхОбъектов = Новый СписокЗначений;
	
	Если ЗначениеЗаполнено(ЦельСсылка.СхемаКомпоновкиДанных) ИЛИ ЦельСсылка.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СхемаИНастройки = ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(ЦельСсылка, ЦельСсылка.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = ЦельСсылка.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	Настройки = ЦельСсылка.ХранилищеНастроекКомпоновкиДанных.Получить();
	
	АдресСКД = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	Если НЕ Настройки = Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	ДоступныеПоля = КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.Элементы;
	
	СлужебныеПоля = СлужебныеПоляОбъектаАнализа();
	
	Для Каждого ДоступноеПоле Из ДоступныеПоля Цикл 
		Если НЕ СлужебныеПоля.Найти(Строка(ДоступноеПоле.Поле)) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СписокДоступныхОбъектов.Добавить(ДоступноеПоле.Поле, ДоступноеПоле.Заголовок);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СписокДоступныхОбъектов;
	
КонецФункции

// Функция возвращает структуру с синонимом и схемой компоновки данных по имени макета
//
// Параметры:
//	ЦельСсылка - Ссылка, СправочникСсылка.СтруктураЦелей - цель, для которой требуется получить схему
//	ИмяМакета - Строка, Неопределено - имя получаемого макета схемы компоновки данных
//
// Возвращаемое значение:
//	Структура - Описание - Строка - синоним получаемого макета
//				СхемаКомпоновкиДанных - СхемаКомпоновкиДанных, Неопределено - найденная схема компоновки данных
//				НастройкиКомпоновкиДанных - НастройкиКомпоновкиДанных, Неопределено - найденные настройки компоновки данных
//
Функция ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(ЦельСсылка, ИмяМакета = Неопределено) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Описание",                  "");
	ВозвращаемоеЗначение.Вставить("СхемаКомпоновкиДанных",     Неопределено);
	ВозвращаемоеЗначение.Вставить("НастройкиКомпоновкиДанных", Неопределено);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СтруктураЦелей.ХранилищеСхемыКомпоновкиДанных КАК ХранилищеСхемыКомпоновкиДанных,
	|	СтруктураЦелей.ХранилищеНастроекКомпоновкиДанных КАК ХранилищеНастроекКомпоновкиДанных 
	|ИЗ
	|	Справочник.СтруктураЦелей КАК СтруктураЦелей
	|ГДЕ
	|	СтруктураЦелей.Ссылка = &ЦельСсылка");
	
	Запрос.УстановитьПараметр("ЦельСсылка", ЦельСсылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Не ЗначениеЗаполнено(ИмяМакета) Тогда
		
		ВозвращаемоеЗначение.Описание = ИмяМакета;
		Если Выборка.Следующий() Тогда
			ВозвращаемоеЗначение.СхемаКомпоновкиДанных = Выборка.ХранилищеСхемыКомпоновкиДанных.Получить();
			ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
		КонецЕсли;
		
	Иначе
		
		Макет = Метаданные.НайтиПоТипу(ТипЗнч(ЦельСсылка)).Макеты.Найти(ИмяМакета);
		Если НЕ Макет = Неопределено Тогда
			ВозвращаемоеЗначение.Описание = Макет.Синоним;
			ВозвращаемоеЗначение.СхемаКомпоновкиДанных = Справочники.СтруктураЦелей.ПолучитьМакет(ИмяМакета);
			Если Выборка.Следующий() Тогда
				ВозвращаемоеЗначение.НастройкиКомпоновкиДанных = Выборка.ХранилищеНастроекКомпоновкиДанных.Получить();
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Возвращает пользовательские настройки по умолчанию для целевых показателей 
//
// Параметры:
//	ЦельСсылка - Ссылка, СправочникСсылка.СтруктураЦелей - цель, для которой требуется получить настройки
//
// Возвращаемое значение:
//	ПользовательскиеНастройкиКомпоновкиДанных - пользовательские настройки по умолчанию
//
Функция ПользовательскиеНастройкиПоУмолчанию(ЦельСсылка) Экспорт
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	// Получим схему компоновки данных
	Если ЗначениеЗаполнено(ЦельСсылка.СхемаКомпоновкиДанных) ИЛИ ЦельСсылка.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СхемаИНастройки = Справочники.СтруктураЦелей.ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(ЦельСсылка, ЦельСсылка.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = ЦельСсылка.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	Настройки = ЦельСсылка.ХранилищеНастроекКомпоновкиДанных.Получить();
	
	АдресСКД = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
		
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	Если НЕ Настройки = Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	// Заполним обязательный параметр ВалютаРасчета для СКД где он есть и не заполнен
	ПараметрВалютаРасчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек.ПользовательскиеНастройки, НСтр("ru='ВалютаРасчета'"));
	Если НЕ ПараметрВалютаРасчета = Неопределено И ПараметрВалютаРасчета.Значение = Справочники.Валюты.ПустаяСсылка() Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.ПользовательскиеНастройки, НСтр("ru='ВалютаРасчета'"), МониторингЦелевыхПоказателей.ПолучитьВалютуПоУмолчанию(), Истина);
	КонецЕсли;
	
	Возврат КомпоновщикНастроек.ПользовательскиеНастройки;
	
КонецФункции

// Возвращает служебные поля-ресурсы, недоступные для выбора пользователем
//
// Возвращаемое значение:
//	Массив - массив служебных полей-ресурсов
//
Функция СлужебныеПоляЗначенияАнализа() Экспорт
	
	СлужебныяПоля = Новый Массив;
	
	СлужебныяПоля.Добавить("ЦелевоеЗначение");
	СлужебныяПоля.Добавить("ЦелевойДиапазонМаксимум");
	СлужебныяПоля.Добавить("ЦелевойДиапазонМинимум");
	СлужебныяПоля.Добавить("ГраничноеНегативноеОтклонение");
	СлужебныяПоля.Добавить("ГраничноеПозитивноеОтклонение");
	СлужебныяПоля.Добавить("ПриведенноеГраничноеНегативноеОтклонение");
	СлужебныяПоля.Добавить("ПриведенноеГраничноеПозитивноеОтклонение");
	
	Возврат СлужебныяПоля;
	
КонецФункции

// Возвращает служебные поля-измерения, недоступные для выбора пользователем
//
// Возвращаемое значение:
//	Массив - массив служебных полей-измерений
//
Функция СлужебныеПоляОбъектаАнализа() Экспорт
	
	СлужебныяПоля = Новый Массив;
	
	СлужебныяПоля.Добавить("ВидОтклоненияОтЦелевогоЗначения");
	СлужебныяПоля.Добавить("ВидЦелевогоЗначения");
	СлужебныяПоля.Добавить("ДатаЦелевыхЗначений");
	СлужебныяПоля.Добавить("Период");
	СлужебныяПоля.Добавить("СистемныеПоля");
	СлужебныяПоля.Добавить("ПараметрыДанных");
	
	// Поля-периоды не являются объектами анализа
	СлужебныяПоля.Добавить("ПериодДень");
	СлужебныяПоля.Добавить("ПериодНеделя");
	СлужебныяПоля.Добавить("ПериодДекада");
	СлужебныяПоля.Добавить("ПериодМесяц");
	СлужебныяПоля.Добавить("ПериодКвартал");
	СлужебныяПоля.Добавить("ПериодПолугодие");
	СлужебныяПоля.Добавить("ПериодГод");
	
	Возврат СлужебныяПоля;
	
КонецФункции

// Возвращает массив имен доступных для выбора макетов
//
// Возвращаемое значение:
//	Массив - массив имен доступных для выбора макетов
//
Функция ШаблоныСхемыКомпоновкиДанных() Экспорт
	Шаблоны = Новый Массив;
	
	НеУправлениеПредприятием = Не ПолучитьФункциональнуюОпцию("УправлениеПредприятием");
	
	Для каждого Макет из Метаданные.Справочники.СтруктураЦелей.Макеты Цикл
		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			Продолжить;
		КонецЕсли;
		
		Если НеУправлениеПредприятием 
			И (Макет.Имя = "ИсполнениеПлановПроизводстваПредопределенный" 
				Или Макет.Имя = "ПросроченныеПроизводственныеЗаказыПредопределенный") Тогда
			Продолжить;
		КонецЕсли;
		
		Шаблоны.Добавить(Новый Структура("Имя, Синоним", Макет.Имя, Макет.Синоним));
	КонецЦикла;
	
	Возврат Шаблоны;
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ПослеЗагрузкиДанныхИзДругойМодели() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтруктураЦелей.Ссылка,
	|	СтруктураЦелей.СхемаКомпоновкиДанных
	|ИЗ
	|	Справочник.СтруктураЦелей КАК СтруктураЦелей";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.СхемаКомпоновкиДанных) Тогда
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СправочникОбъект.ХранилищеСхемыКомпоновкиДанных = Новый ХранилищеЗначения("");
			СправочникОбъект.ХранилищеНастроекКомпоновкиДанных = Новый ХранилищеЗначения("");
			
			СправочникОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления УТ 11.1.11
// Заполняет данные, необходимые для заполнения нового реквизита доп. упорядочивания справочника "СтруктураЦелей"
//
Процедура ЗаполнитьРеквизитДопУпорядочиванияИерархическогоОтложенноЗаполнитьДанныеДляОбновления(Параметры) Экспорт
	Запрос = Новый запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтруктураЦелей.Ссылка
	|ИЗ
	|	Справочник.СтруктураЦелей КАК СтруктураЦелей
	|ГДЕ
	|	СтруктураЦелей.Родитель = ЗНАЧЕНИЕ(Справочник.СтруктураЦелей.ПустаяСсылка)
	|	И СтруктураЦелей.РеквизитДопУпорядочиванияИерархического = """"";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура ОтключитьОтборыПоФункциональнымОпциям(Настройки)
	ИспользоватьПартнеровКакКонтрагентов		= ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	ИспользоватьНесколькоОрганизаций			= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	ИспользоватьНесколькоКасс					= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	ИспользоватьНесколькоРасчетныхСчетов		= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	ИспользоватьХарактеристикиНоменклатуры		= ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	УчитыватьСебестоимостьТоваровПоВидамЗапасов	= ПолучитьФункциональнуюОпцию("УчитыватьСебестоимостьТоваровПоВидамЗапасов");
	ИспользоватьКлассификациюКлиентов			= ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВаловойПрибыли")
		ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВыручке")
		ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродаж");
	
	Отборы = Настройки.Отбор.Элементы;
	ИзменяемыеОтборы = Новый Соответствие;
	Для Каждого Отбор Из Отборы Цикл
		Если ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ИзменяемыеОтборы.Вставить(Отбор.ЛевоеЗначение, Отбор);
		КонецЕсли;
	КонецЦикла;
	
	Если ИспользоватьПартнеровКакКонтрагентов Тогда
		ОтключитьОтбор(Настройки, ИзменяемыеОтборы, "Контрагент");
	КонецЕсли;
	
	Если Не ИспользоватьНесколькоОрганизаций Тогда
		ОтключитьОтбор(Настройки, ИзменяемыеОтборы, "Организация");
	КонецЕсли;
	
	Если Не ИспользоватьНесколькоКасс Тогда
		ОтключитьОтбор(Настройки, ИзменяемыеОтборы, "Касса");
	КонецЕсли;
	
	Если Не ИспользоватьНесколькоРасчетныхСчетов Тогда
		ОтключитьОтбор(Настройки, ИзменяемыеОтборы, "БанковскийСчет");
	КонецЕсли;
	
	Если Не ИспользоватьХарактеристикиНоменклатуры Тогда
		ОтключитьОтбор(Настройки, ИзменяемыеОтборы, "Характеристика");
	КонецЕсли;
	
	Если Не УчитыватьСебестоимостьТоваровПоВидамЗапасов Тогда
		ОтключитьОтбор(Настройки, ИзменяемыеОтборы, "ВидЗапасов");
	КонецЕсли;
	
	Если Не ИспользоватьКлассификациюКлиентов Тогда
		ОтключитьОтбор(Настройки, ИзменяемыеОтборы, "Класс");
	КонецЕсли;
КонецПроцедуры

Процедура ОтключитьОтбор(Настройки, ИзменяемыеОтборы, ИмяПоля)
	ПроверяемоеПоле = Новый ПолеКомпоновкиДанных(ИмяПоля);
	УдаляемыйОтбор = ИзменяемыеОтборы.Получить(ПроверяемоеПоле);
	Если Не УдаляемыйОтбор = Неопределено Тогда
		Настройки.Отбор.Элементы.Удалить(УдаляемыйОтбор);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли