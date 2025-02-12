﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыДокумента(
		"ЗапросАкцизныхМарокЕГАИС",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДействияПриОбменеЕГАИС

// Статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросАкцизныхМарокЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречисленияСсылка.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//
Функция СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросАкцизныхМарок Тогда
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусыКПередаче(
			ДокументСсылка,
			Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.КПередаче);
		
	Иначе
		ВызватьИсключение ИнтеграцияЕГАИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросАкцизныхМарокЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречисленияСсылка.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//
Функция СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросАкцизныхМарок Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
		
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.ПереданВУТМ;
		СтатусыБазовыйПроцесс.ПринятДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеАкцизныхМарок);
		
		СтатусыБазовыйПроцесс.Ошибка = Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеАкцизныеМарки);
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусы(ДокументСсылка, СтатусОбработки, СтатусыБазовыйПроцесс);
		
	Иначе
		ВызватьИсключение ИнтеграцияЕГАИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции

// Статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросАкцизныхМарокЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено, Структура со свойствами:
//   * СтатусОбработки - Перечисление.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречисленияСсылка.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//
Функция СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Операция = Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросАкцизныхМарок Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
		СтатусыБазовыйПроцесс.Принят = Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.ПолученыАкцизныеМарки;
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусы(
			ДокументСсылка,
			Перечисления.СтатусыОбработкиСообщенийЕГАИС.ПринятИзЕГАИС,
			СтатусыБазовыйПроцесс);
		
	ИначеЕсли Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС Тогда
		
		СтатусыБазовыйПроцесс = РегистрыСведений.СтатусыДокументовЕГАИС.СтруктураСтатусы();
		СтатусыБазовыйПроцесс.Обрабатывается = Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.ОбрабатываетсяЕГАИС;
		СтатусыБазовыйПроцесс.Ошибка         = Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.ОшибкаПередачи;
		СтатусыБазовыйПроцесс.ОшибкаДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеАкцизныеМарки);
		СтатусыБазовыйПроцесс.КвитанцияПроведенЕГАИС          = Ложь;
		СтатусыБазовыйПроцесс.УведомлениеОРегистрацииДвижения = Ложь;
		
		ПараметрыОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.РассчитатьСтатусыПриПолученииКвитанции(
			ДокументСсылка,
			"КвитанцияПолученЕГАИС", ДополнительныеПараметры.СтатусОбработки,
			СтатусыБазовыйПроцесс, Истина);
		
	Иначе
		ВызватьИсключение ИнтеграцияЕГАИС.ТекстИсключенияОбработкиСтатуса(ДокументСсылка, Операция);
	КонецЕсли;
	
	Возврат ПараметрыОбновления;
	
КонецФункции


// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросАкцизныхМарокЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	ПараметрыОбновления = СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросАкцизныхМарокЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
// 
// Возвращаемое значение:
//  Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	ПараметрыОбновления = СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции

// Обновить статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросАкцизныхМарокЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено, Структура со свойствами:
//   * СтатусОбработки - Перечисление.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбновления = СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
	Если ПараметрыОбновления = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбновлятьДвижения = Истина;
	Если ДополнительныеПараметры <> Неопределено Тогда
		ОбновлятьДвижения = ДополнительныеПараметры.ОбновлятьДвижения;
	КонецЕсли;
	
	НовыйСтатусПослеОбновления = РегистрыСведений.СтатусыДокументовЕГАИС.ОбновитьСтатус(
		ДокументСсылка,
		ПараметрыОбновления, ОбновлятьДвижения);
	
	Возврат НовыйСтатусПослеОбновления;
	
КонецФункции


// Получить последовательность операций в течении жизненного цикла документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросАкцизныхМарокЕГАИС - Документ, для которого требуется обновить статус.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ИнтеграцияЕГАИС.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Таблица = ИнтеграцияЕГАИС.ПустаяТаблицаПоследовательностьОпераций();
	
	Исходящий = Перечисления.ТипыЗапросовЕГАИС.Исходящий;
	Входящий  = Перечисления.ТипыЗапросовЕГАИС.Входящий;
	
	ИнтеграцияЕГАИС.ДобавитьОперациюВПоследовательность(Таблица, 0, Исходящий, Перечисления.ВидыДокументовЕГАИС.ЗапросАкцизныхМарок, ДокументСсылка, Ложь, Ложь);
	ИнтеграцияЕГАИС.ДобавитьОперациюВПоследовательность(Таблица, 0, Входящий,  Перечисления.ВидыДокументовЕГАИС.ОтветНаЗапросАкцизныхМарок);
	
	Возврат Таблица;
	
КонецФункции

// Опеределить необходимость перезаписи движений.
//
// Параметры:
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Предыдущий статус.
// 
// Возвращаемое значение:
//  Булево - Необходимость перезаписи движений.
//
Функция ОбновлятьДвижения(ПредыдущийСтатус, НовыйСтатус) Экспорт
	Возврат Ложь;
КонецФункции

// Опеределить необходимость перерасчета статуса оформления документов.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЗапросАкцизныхМарокЕГАИС - Документ, по которому требуется рассчитать статус оформления.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС - Предыдущий статус.
// 
// Возвращаемое значение:
//  Булево - Необходимость перерасчета статуса оформления.
//
Функция РассчитатьСтатусОформления(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус) Экспорт
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#Область Статусы

// Возвращает статус по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС - Статус по-умолчанию.
//
Функция СтатусПоУмолчанию() Экспорт
	
	Возврат Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.Черновик;
	
КонецФункции

// Возвращает статусы ошибок.
//
// Возвращаемое значение:
//  Массив - Статусы ошибок.
//
Функция СтатусыОшибок() Экспорт
	
	Статусы = Новый Массив;
	
	Статусы.Добавить(Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.ОшибкаПередачи);
	
	Возврат Статусы;
	
КонецФункции

// Возвращает конечные статусы.
//
// Возвращаемое значение:
//  Массив - Конечные статусы.
//
Функция КонечныеСтатусы() Экспорт
	
	Статусы = Новый Массив;
	
	Возврат Статусы;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию() Экспорт
	
	Возврат Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеАкцизныеМарки;
	
КонецФункции

#КонецОбласти

#Область ПанельОбменСЕГАИС

Функция ВсеТребующиеДействия(Все = Ложь) Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеАкцизныеМарки);
	Если Все Или Не ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхЕГАИС") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ВыполнитеОбмен);
	КонецЕсли;
	
	Возврат МассивДействий;
	
КонецФункции

Функция ВсеТребующиеОжидания(Все = Ложь) Экспорт
	
	МассивДействий = Новый Массив;
	Если Все Или ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхЕГАИС") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	КонецЕсли;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПолучениеАкцизныхМарок);
	
	Возврат МассивДействий;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыДокументовЕГАИС.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ЗапросАкцизныхМарокЕГАИС КАК ЗапросАкцизныхМарокЕГАИС
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ЗапросАкцизныхМарокЕГАИС.Ссылка
	|ГДЕ
	|	ЗапросАкцизныхМарокЕГАИС.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ЗапросАкцизныхМарокЕГАИС.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеДействия)
	|	И (ЗапросАкцизныхМарокЕГАИС.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ЗапросАкцизныхМарокЕГАИС.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыДокументовЕГАИС.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ЗапросАкцизныхМарокЕГАИС КАК ЗапросАкцизныхМарокЕГАИС
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ЗапросАкцизныхМарокЕГАИС.Ссылка
	|ГДЕ
	|	ЗапросАкцизныхМарокЕГАИС.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ЗапросАкцизныхМарокЕГАИС.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеОжидания)
	|	И (ЗапросАкцизныхМарокЕГАИС.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ЗапросАкцизныхМарокЕГАИС.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СообщенияЕГАИС

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеАкцизныеМарки Тогда
		
		Возврат ЗапросАкцизныхМарокЕГАИСXML(ДокументСсылка);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СообщенияЕГАИС

Функция ЗапросАкцизныхМарокЕГАИСXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Операция = Перечисления.ВидыДокументовЕГАИС.ЗапросАкцизныхМарок;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕГАИСПрисоединенныеФайлы.Документ           КАК Ссылка,
	|	КОЛИЧЕСТВО(ЕГАИСПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомер
	|ПОМЕСТИТЬ Версии
	|ИЗ
	|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
	|ГДЕ
	|	ЕГАИСПрисоединенныеФайлы.Документ = &Ссылка
	|	И ЕГАИСПрисоединенныеФайлы.Операция = &Операция
	|	И ЕГАИСПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовЕГАИС.Исходящий)
	|СГРУППИРОВАТЬ ПО
	|	ЕГАИСПрисоединенныеФайлы.Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Шапка.Номер                         КАК Номер,
	|	Шапка.Дата                          КАК Дата,
	|	ЕСТЬNULL(Версии.ПоследнийНомер, 0)  КАК ПоследнийНомерВерсии,
	|	
	|	&Операция                           КАК Операция,
	|	Шапка.ОрганизацияЕГАИС              КАК ОрганизацияЕГАИС,
	|	Шапка.ОрганизацияЕГАИС.Код          КАК ИдентификаторФСРАР,
	|	Шапка.ОрганизацияЕГАИС.ФорматОбмена КАК ФорматОбмена,
	|	Шапка.Ответственный                 КАК Ответственный
	|ИЗ
	|	Документ.ЗапросАкцизныхМарокЕГАИС КАК Шапка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Версии КАК Версии
	|		ПО Шапка.Ссылка = Версии.Ссылка
	|ГДЕ
	|	Шапка.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.ТипМарки    КАК ТипМарки,
	|	Товары.СерияМарки  КАК СерияМарки,
	|	Товары.НомерМарки  КАК НомерМарки
	|ИЗ
	|	Документ.ЗапросАкцизныхМарокЕГАИС.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|");
	
	Запрос.УстановитьПараметр("Ссылка",   ДокументСсылка);
	Запрос.УстановитьПараметр("Операция", Операция);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Шапка  = РезультатЗапроса[1].Выбрать();
	Товары = РезультатЗапроса[РезультатЗапроса.Количество() - 1].Выгрузить();
	
	Если Не Шапка.Следующий() Тогда
		
		СообщениеXML = ИнтеграцияЕГАИС.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияЕГАИС.ОписаниеОперацииПередачиДанных(
			Шапка.Операция, ДокументСсылка);
		
		ИнтеграцияЕГАИСКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, НСтр("ru = 'Нет данных для выгрузки.'"));
		
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	ФорматОбмена = ИнтеграцияЕГАИСКлиентСервер.ФорматОбмена(Шапка.ФорматОбмена);
	
	СообщениеXML = ИнтеграцияЕГАИС.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияЕГАИС.ОписаниеОперацииПередачиДанных(
		Шапка.Операция, ДокументСсылка, НомерВерсии);
	
	ПространствоИмен = Перечисления.ВидыДокументовЕГАИС.ПространствоИмен(Шапка.Операция, ФорматОбмена);
	ИмяТипа          = Перечисления.ВидыДокументовЕГАИС.ТипЕГАИС(Шапка.Операция, ФорматОбмена);
	
	Если ПространствоИмен = Неопределено
		Или ИмяТипа = Неопределено Тогда
		ИнтеграцияЕГАИСКлиентСервер.ДобавитьТекстОшибки(
			СообщениеXML,
			СтрШаблон(НСтр("ru = 'Операция не поддерживается в версии формата обмена: %1.'"), ФорматОбмена));
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
	КонецЕсли;
	
	#Область ЗапросАкцизныхМарокЕГАИС
	
	ДокументXDTO = ИнтеграцияЕГАИС.ОбъектXDTO(ПространствоИмен, "QueryBarcode");
	
	ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(ДокументXDTO, "QueryNumber",  Шапка.Номер, СообщениеXML);
	ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(ДокументXDTO, "Date",         Шапка.Дата,  СообщениеXML);
	
	ДокументXDTO.Marks = ИнтеграцияЕГАИС.ОбъектXDTOПоИмениТипа(ДокументXDTO, "Marks");
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		
		Mark = ИнтеграцияЕГАИС.ОбъектXDTOПоИмениТипа(ДокументXDTO.Marks, "Mark");
		
		ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(Mark, "Identity", СтрокаТЧ.НомерСтроки, СообщениеXML);
		ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(Mark, "Type",     СтрокаТЧ.ТипМарки,    СообщениеXML);
		ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(Mark, "Rank",     СтрокаТЧ.СерияМарки,  СообщениеXML);
		ИнтеграцияЕГАИС.ЗаполнитьСвойствоXDTO(Mark, "Number",   СтрокаТЧ.НомерМарки,  СообщениеXML);
		
		ДокументXDTO.Marks.Mark.Добавить(Mark);
		
	КонецЦикла;
	
	#КонецОбласти
	
	ТекстСообщенияXML = ИнтеграцияЕГАИС.ОбъектXDTOВXML(ДокументXDTO, Шапка.ИдентификаторФСРАР, ПространствоИмен, ИмяТипа);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.ТипСообщения      = Перечисления.ТипыЗапросовЕГАИС.Исходящий;
	СообщениеXML.ОрганизацияЕГАИС  = Шапка.ОрганизацияЕГАИС;
	СообщениеXML.Операция          = Шапка.Операция;
	СообщениеXML.ФорматОбмена      = ФорматОбмена;
	СообщениеXML.Документ          = ДокументСсылка;
	СообщениеXML.ДокументОснование = Неопределено;
	СообщениеXML.Версия            = НомерВерсии;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Акцизные марки
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АкцизныеМарки";
	КомандаПечати.Представление = НСтр("ru = 'Печать акцизных марок'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АкцизныеМарки") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "АкцизныеМарки", НСтр("ru='Акцизные марки'"), СформироватьПечатнуюФормуАкцизныеМарки(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

// Формирует табличный документ "Акцизные марки".
//
Функция СформироватьПечатнуюФормуАкцизныеМарки(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗапросАкцизныхМарокЕГАИС_АкцизныеМарки";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗапросАкцизныхМарокЕГАИСТовары.НомерСтроки КАК НомерСтроки,
	|	ЗапросАкцизныхМарокЕГАИСТовары.Номенклатура КАК Номенклатура,
	|	ЗапросАкцизныхМарокЕГАИСТовары.Характеристика КАК Характеристика,
	|	ЗапросАкцизныхМарокЕГАИСТовары.Упаковка КАК Упаковка,
	|	ЗапросАкцизныхМарокЕГАИСТовары.СерияМарки КАК СерияМарки,
	|	ЗапросАкцизныхМарокЕГАИСТовары.НомерМарки КАК НомерМарки,
	|	ЗапросАкцизныхМарокЕГАИСТовары.КодАкцизнойМарки КАК КодАкцизнойМарки
	|ИЗ
	|	Документ.ЗапросАкцизныхМарокЕГАИС.Товары КАК ЗапросАкцизныхМарокЕГАИСТовары
	|ГДЕ
	|	ЗапросАкцизныхМарокЕГАИСТовары.Ссылка В(&МассивОбъектов)
	|	И ЗапросАкцизныхМарокЕГАИСТовары.КодАкцизнойМарки <> """"
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗапросАкцизныхМарокЕГАИС.ПФ_MXL_АкцизныеМарки");
	
	Эталон = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗапросАкцизныхМарокЕГАИС.Эталон");
	КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;
	
	Область = Макет.ПолучитьОбласть(Макет.ОбластьПечати.Имя);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Область.Параметры.ПредставлениеНоменклатуры = ИнтеграцияЕГАИСПереопределяемый.ПредставлениеНоменклатуры(
			Выборка.Номенклатура,
			Выборка.Характеристика,
			Выборка.Упаковка);
			
		Область.Параметры.СерияНомерМарки = Выборка.СерияМарки + " " + Выборка.НомерМарки;
		
		Рисунок = Область.Рисунки.КодАкцизнойМарки;
		
		ПараметрыШтрихкода = Новый Структура;
		ПараметрыШтрихкода.Вставить("Ширина",          Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселе));
		ПараметрыШтрихкода.Вставить("Высота",          Окр(Рисунок.Высота / КоличествоМиллиметровВПикселе));
		ПараметрыШтрихкода.Вставить("Штрихкод",        СокрЛП(Выборка.КодАкцизнойМарки));
		ПараметрыШтрихкода.Вставить("ТипКода",         6);
		ПараметрыШтрихкода.Вставить("ОтображатьТекст", Ложь);
		
		Рисунок.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
		
		ТабличныйДокумент.Вывести(Область);
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#Область Прочее

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли