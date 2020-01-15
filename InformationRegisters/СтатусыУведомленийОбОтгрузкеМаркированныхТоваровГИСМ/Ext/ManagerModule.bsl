﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает структуру значений по умолчанию для уведомления для движений.
//
// Возвращаемое значение:
//	Структура - значения по умолчанию
//
Функция ЗначенияПоУмолчанию() Экспорт
	
	СтруктрураЗначенияПоУмолчанию = Новый Структура;
	
	СтруктрураЗначенияПоУмолчанию.Вставить("Документ",                     Неопределено);
	СтруктрураЗначенияПоУмолчанию.Вставить("ТекущееУведомлениеОбОтгрузке", Документы.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ.ПустаяСсылка());
	
	СтруктрураЗначенияПоУмолчанию.Вставить("Статус",                       Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Отсутствует);
	СтруктрураЗначенияПоУмолчанию.Вставить("ДальнейшееДействие",           Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка());
	
	СтруктрураЗначенияПоУмолчанию.Вставить("ПроцентПодтвержденныхКиЗ",     0);
	
	Возврат СтруктрураЗначенияПоУмолчанию;
	
КонецФункции

// Осуществляет запись в регистр по переданным данным.
//
// Параметры:
// 	ДанныеЗаписи - данные для записи в регистр
//
Процедура ВыполнитьЗаписьВРегистрПоДаннымСтруктура(ДанныеЗаписи) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Удаляет запись из регистра по переданному документу.
//
// Параметры:
// 	Документ - документ, данные по которому необходимо удалить
//
Процедура УдалитьЗаписьИзРегистра(Документ) Экспорт

	НаборЗаписей = РегистрыСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Записать();

КонецПроцедуры

// Функция определяет, является ли статус уведомления неактуальным.
//
// Параметры:
// 	Статус - статус, который необходимо проверить
//
// Возвращаемое значение:
//	Булево - статус заявки является неактуальным
//
Функция ЭтоСтатусНеАктуальногоУведомления(Статус) Экспорт

	Если Статус = Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Отсутствует
		Или Статус = Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОтклоненоГИСМ
		Или Статус = Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОтклоненоКлиентом
		Или Статус = Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ПустаяСсылка() Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

// Возвращает статус документа.
//
// Параметры:
// 	УведомлениеОбОтгрузке - документ, для которого необходимо обновить статус
// 	Статус - статус документа
// 	ДальнейшееДействие - дальнейшее действие по документу
//
// Возвращаемое значение:
//	ПеречислениеСсылка.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ - новый статус документа
//
Функция ОбновитьСтатус(УведомлениеОбОтгрузке, Статус, ДальнейшееДействие) Экспорт
	
	НовыйСтатус             = Неопределено;
	НовоеДальнейшееДействие = Неопределено;
	
	НаборЗаписей = НаборЗаписей(УведомлениеОбОтгрузке);
	
	Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
		Если ЗаписьНабора.Статус <> Статус Тогда
			ЗаписьНабора.Статус = Статус;
			НовыйСтатус = Статус;
		КонецЕсли;
		Если ЗаписьНабора.ДальнейшееДействие <> ДальнейшееДействие Тогда
			ЗаписьНабора.ДальнейшееДействие = ДальнейшееДействие;
			НовоеДальнейшееДействие = ДальнейшееДействие;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(НовыйСтатус)
		Или ЗначениеЗаполнено(НовоеДальнейшееДействие) Тогда
		НаборЗаписей.Записать();
	КонецЕсли;
	
	Возврат НовыйСтатус;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НаборЗаписей(УведомлениеОбОтгрузке)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Состояния.Документ КАК Документ
	|ИЗ
	|	РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ КАК Состояния
	|ГДЕ
	|	Состояния.Документ = &УведомлениеОбОтгрузке
	|ИЛИ Состояния.ТекущееУведомлениеОбОтгрузке = &УведомлениеОбОтгрузке");
	
	Запрос.УстановитьПараметр("УведомлениеОбОтгрузке", УведомлениеОбОтгрузке);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	НаборЗаписей = Неопределено;
	Если Выборка.Следующий() Тогда
		
		НаборЗаписей = РегистрыСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Выборка.Документ, Истина);
		НаборЗаписей.Прочитать();
		
	Иначе
		
		Основание = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УведомлениеОбОтгрузке, "Основание");
		Если ЗначениеЗаполнено(Основание) Тогда
			Документ = Основание;
		Иначе
			Документ = УведомлениеОбОтгрузке;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Документ.Установить(Документ, Истина);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗначенияПоУмолчанию());
		НоваяЗапись.Документ                     = Документ;
		НоваяЗапись.ТекущееУведомлениеОбОтгрузке = УведомлениеОбОтгрузке;
		
	КонецЕсли;
	
	Возврат НаборЗаписей;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ";
	
	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	СсылкиДляОбработки.Документ КАК Документ,
		|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ТекущееУведомлениеОбОтгрузке КАК ТекущееУведомлениеОбОтгрузке,
		|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Статус                       КАК Статус,
		|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ДальнейшееДействие           КАК ДальнейшееДействие,
		|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ПроцентПодтвержденныхКиЗ     КАК ПроцентПодтвержденныхКиЗ
		|ИЗ
		|	&ВТДляОбработкиСсылка КАК СсылкиДляОбработки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ КАК СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ
		|		ПО СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Документ = СсылкиДляОбработки.Документ
		|";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуИзмеренийНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь,
		ПолноеИмяРегистра,
		МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВТДляОбработкиСсылка", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра);
			ЭлементБлокировки.УстановитьЗначение("Документ", Выборка.Документ);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Набор = РегистрыСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.СоздатьНаборЗаписей();
			Набор.Отбор.Документ.Установить(Выборка.Документ);
			
			НоваяЗапись = Набор.Добавить();
			НоваяЗапись.Документ                     = Выборка.Документ;
			НоваяЗапись.ТекущееУведомлениеОбОтгрузке = Выборка.ТекущееУведомлениеОбОтгрузке;
			НоваяЗапись.Статус                       = Перечисления.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОбрабатываетсяПоступление;
			НоваяЗапись.ДальнейшееДействие           = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеЗакрытияУведомления;
			НоваяЗапись.ПроцентПодтвержденныхКиЗ     = Выборка.ПроцентПодтвержденныхКиЗ;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось обработать сообщение: %1 из очереди получения квитанций по причине: %2'"),
				Выборка.Сообщение,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.ГИСМПрисоединенныеФайлы,
				Выборка.Сообщение,
				ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь,
		"РегистрСведений.ОчередьПолученияКвитанцийОФиксацииГИСМ");
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Документ КАК Документ
	|ИЗ
	|	РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ КАК СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|		ПО ГИСМПрисоединенныеФайлы.ВладелецФайла = СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Документ
	|		 И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПолучениеАннулирования)
	|		 И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Входящее)
	|	
	|ГДЕ
	|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОтклоненоКлиентом)
	|	И ГИСМПрисоединенныеФайлы.Ссылка ЕСТЬ NULL
	|");
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаДанных = РезультатЗапроса.Выгрузить();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ";
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ТаблицаДанных, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли