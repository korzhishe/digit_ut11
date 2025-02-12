﻿#Область ПрограммныйИнтерфейс

// Постановка подготовленных данных электронного чека в очередь отправки.
//
// Параметры:
//  Адресат - Строка, номер телефона или адреса электроннной почты;
//  ТипРассылки - Перечисления.ТипыРассылкиЭлектронного чека;
//  ПараметрыСообщения - Структура сообщения зависит от типа рассылки
//
Процедура НачатьОтправкуЭлектронногоЧека(Адресат, ТипРассылки, ПараметрыСообщения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	ОтправкаЭлектронныхЧековПослеПробитияЧека = Константы.ОтправкаЭлектронныхЧековПослеПробитияЧека.Получить();
	
	Если Параметры.НаличиеБСП И ОтправкаЭлектронныхЧековПослеПробитияЧека Тогда
		
		УникальныйИдентификатор = Новый УникальныйИдентификатор();
		
		ТекущееХранилище = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		
		ПараметрыВыполнения = ОбщийМодуль("ДлительныеОперации").ПараметрыВыполненияВФоне(УникальныйИдентификатор);
		ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
		ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Рассылка электронных чеков'");
		ПараметрыВыполнения.АдресРезультата = ТекущееХранилище;
		ПараметрыВыполнения.ЗапуститьВФоне = Истина; // Всегда в фоне (очередь заданий в файловом варианте).
		
		ПараметрыПроцедуры = Новый Структура;
		ПараметрыПроцедуры.Вставить("ТипРассылки", ТипРассылки);
		ПараметрыПроцедуры.Вставить("ПараметрыСообщения", ПараметрыСообщения);
		ПараметрыПроцедуры.Вставить("Адресат", Адресат);
		
		Результат = ОбщийМодуль("ДлительныеОперации").ВыполнитьВФоне("РассылкаЭлектронныхЧеков.ОтправитьСообщениеОчередиВФоне",
			ПараметрыПроцедуры, ПараметрыВыполнения);
			
		
	Иначе
		ЭлементОбъект = Справочники.ОчередьЭлектронныхЧековКОтправке.СоздатьЭлемент();
		ЭлементОбъект.ТипРассылки  = ТипРассылки;
		ЭлементОбъект.Наименование = Адресат;
		ПараметрыСообщения         = Новый ХранилищеЗначения(ПараметрыСообщения);
		ЭлементОбъект.ПараметрыСообщения     = ПараметрыСообщения;
		ЭлементОбъект.ДатаПостановкиВОчередь = ТекущаяДатаСеанса();
		
		ЭлементОбъект.Записать();
	КонецЕсли;
	
	РассылкаЭлектронныхЧековПереопределяемый.НачатьОтправкуЭлектронногоЧека(Адресат, ТипРассылки, ПараметрыСообщения);
	
КонецПроцедуры

// В фоне отправляет электронный чек через настроенного поставщика услуги, при возникновении ошибки записываются данные ошибки.
// 
// Параметры:
//  ПараметрыСообщения - Структура.Структура. Со свойствами
//       Адресат - Строка, номер телефона или адреса электроннной почты.
//       ТипРассылки -Перечисления.ТипыРассылкиЭлектронного чека
//       ПараметрыСообщения - Структура. Структура сообщения зависит от типа рассылки
//  АдресРезультата - Хранилище сохраняющее результаты выполнения
// 
Процедура ОтправитьСообщениеОчередиВФоне(ПараметрыЗадания, АдресРезультата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипРассылки        = ПараметрыЗадания.ТипРассылки;
	ПараметрыСообщения = ПараметрыЗадания.ПараметрыСообщения;
	Адресат            = ПараметрыЗадания.Адресат;
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	Если ТипРассылки = Перечисления.ТипыРассылкиЭлектронныхЧеков.СообщениеSMS 
		И Параметры.НаличиеПодсистемыОтправкаSMS Тогда
		
		Если ТипЗнч(ПараметрыСообщения) = Тип("ХранилищеЗначения") Тогда
			ПараметрыСообщения = ПараметрыСообщения.Получить();
		КонецЕсли;
		
		НомерПолучателя = ПараметрыСообщения.НомерПолучателя;
		ТекстСообщения = ПараметрыСообщения.ТекстСообщения;
		
		ДлинаНомераТелефона = СтрДлина(НомерПолучателя);
		
		Если ДлинаНомераТелефона = 10 Тогда
			НомерПолучателя = "+7" + НомерПолучателя;
		ИначеЕсли ДлинаНомераТелефона = 11
				И Лев(НомерПолучателя, 1) = "8" Тогда
			НомерПолучателя = "+7" + Сред(НомерПолучателя,2);
		Иначе
			НомерПолучателя = НомерПолучателя;
		КонецЕсли;
		
		НомераПолучателей = Новый Массив;
		НомераПолучателей.Добавить(НомерПолучателя);
		
		РезультатОтправки = ОбщийМодуль("ОтправкаSMS").ОтправитьSMS(НомераПолучателей, ТекстСообщения, Неопределено, Ложь);
		
		Если РезультатОтправки.ОтправленныеСообщения.Количество() = 0 Тогда
			
			ЭлементОбъект = Справочники.ОчередьЭлектронныхЧековКОтправке.СоздатьЭлемент();
			
			ЭлементОбъект.ДатаПостановкиВОчередь = ТекущаяДатаСеанса();
			ЭлементОбъект.Наименование = Адресат;
			ЭлементОбъект.ТипРассылки = ТипРассылки;
			ЭлементОбъект.ПараметрыСообщения = Новый ХранилищеЗначения(ПараметрыСообщения);
			ЭлементОбъект.ПроизошлаОшибкаПередачи = Истина;
			Если РезультатОтправки.Свойство("ОписаниеОшибки") Тогда
				ЭлементОбъект.ОписаниеОшибки = РезультатОтправки.ОписаниеОшибки;
			КонецЕсли;
			ЭлементОбъект.Записать();
			
		КонецЕсли;
	ИначеЕсли Параметры.НаличиеПодсистемыРаботаСПочтовымиСообщениями Тогда
		
		Если ТипЗнч(ПараметрыСообщения) = Тип("ХранилищеЗначения") Тогда
			ПараметрыСообщения = ПараметрыСообщения.Получить();
		КонецЕсли;
		
		ОписаниеОшибки = "";
		ИдентификаторСообщения = "";
		Попытка
			
			ИдентификаторСообщения = ОбщийМодуль("РаботаСПочтовымиСообщениями").ОтправитьПочтовоеСообщение(
												ОбщийМодуль("РаботаСПочтовымиСообщениями").СистемнаяУчетнаяЗапись(),
												ПараметрыСообщения);
			
		Исключение
			Инфо = ИнформацияОбОшибке();
			ОписаниеОшибки = Инфо.Описание;
			
			Если ТипЗнч(Инфо.Причина) = Тип("ИнформацияОбОшибке") Тогда
				ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(Инфо.Причина);
			КонецЕсли; 
			
		КонецПопытки;
		
		Если НЕ ЗначениеЗаполнено(ИдентификаторСообщения) Тогда
			ЭлементОбъект = Справочники.ОчередьЭлектронныхЧековКОтправке.СоздатьЭлемент();
			
			ЭлементОбъект.ДатаПостановкиВОчередь = ТекущаяДатаСеанса();
			ЭлементОбъект.Наименование = Адресат;
			ЭлементОбъект.ТипРассылки = ТипРассылки;
			ЭлементОбъект.ПараметрыСообщения = Новый ХранилищеЗначения(ПараметрыСообщения);
			ЭлементОбъект.ПроизошлаОшибкаПередачи = Истина;
			ЭлементОбъект.ОписаниеОшибки = ОписаниеОшибки;
			ЭлементОбъект.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчередиВФоне(ПараметрыЗадания, АдресРезультата);
	
КонецПроцедуры

// Отправляет электронный чек через настроенного поставщика услуги, обрабатывает очередь
// При успешной отправке запись очереди удаляется, при возникновении ошибки записываются данные ошибки.
// 
// Параметры:
//  ЭлементСсылка - СправочникСсылка.ОчередьЭлектронныхЧековКОтправке
//  ТипРассылки - Перечисление.ТипыРассылкиЭлектронныхЧеков;
//  ПараметрыСообщения - структура
//  Соединение - Интернет-соединение
//
// Возвращаемое значение:
//  Булево - Истина, если SMS отправлено
//  
Функция ОтправитьСообщениеОчереди(Знач ЭлементСсылка, Знач ТипРассылки, Знач ПараметрыСообщения, Знач Соединение = Неопределено) Экспорт
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	Если Параметры.НаличиеБСП Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		ЭлементОбъект = ЭлементСсылка.ПолучитьОбъект();
		Если ТипРассылки = Перечисления.ТипыРассылкиЭлектронныхЧеков.СообщениеSMS 
			И Параметры.НаличиеПодсистемыОтправкаSMS Тогда
			ПараметрыСообщенияСтруктура = ПараметрыСообщения.Получить();
			НомерПолучателя = ПараметрыСообщенияСтруктура.НомерПолучателя;
			ТекстСообщения = ПараметрыСообщенияСтруктура.ТекстСообщения;
			
			ДлинаНомераТелефона = СтрДлина(НомерПолучателя);
			
			Если ДлинаНомераТелефона = 10 Тогда
				НомерПолучателя = "+7" + НомерПолучателя;
			ИначеЕсли ДлинаНомераТелефона = 11
					И Лев(НомерПолучателя, 1) = "8" Тогда
				НомерПолучателя = "+7" + Сред(НомерПолучателя,2);
			Иначе
				НомерПолучателя = НомерПолучателя;
			КонецЕсли;
			
			НомераПолучателей = Новый Массив;
			НомераПолучателей.Добавить(НомерПолучателя);
			
			РезультатОтправки = ОбщийМодуль("ОтправкаSMS").ОтправитьSMS(НомераПолучателей, ТекстСообщения, Неопределено, Ложь);
			
			Если РезультатОтправки.ОтправленныеСообщения.Количество() = 0 Тогда
				
				ЭлементОбъект.ПроизошлаОшибкаПередачи = Истина;
				Если РезультатОтправки.Свойство("ОписаниеОшибки") Тогда
					ЭлементОбъект.ОписаниеОшибки = РезультатОтправки.ОписаниеОшибки;
				КонецЕсли;
				ЭлементОбъект.Записать();
				Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Ложь, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
			Иначе
				ЭлементОбъект.Удалить();
				Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Истина, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
			КонецЕсли;
		ИначеЕсли Параметры.НаличиеПодсистемыРаботаСПочтовымиСообщениями Тогда
			
			Если ТипЗнч(ПараметрыСообщения) = Тип("ХранилищеЗначения") Тогда
				ПараметрыСообщения = ПараметрыСообщения.Получить();
			КонецЕсли;
			
			ОписаниеОшибки = "";
			ИдентификаторСообщения = "";
			Попытка
				
				ИдентификаторСообщения = ОбщийМодуль("РаботаСПочтовымиСообщениями").ОтправитьПочтовоеСообщение(
													ОбщийМодуль("РаботаСПочтовымиСообщениями").СистемнаяУчетнаяЗапись(),
													ПараметрыСообщения,
													Соединение);
				
			Исключение
				Инфо = ИнформацияОбОшибке();
				ОписаниеОшибки = Инфо.Описание;
				
				Если ТипЗнч(Инфо.Причина) = Тип("ИнформацияОбОшибке") Тогда
						ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(Инфо.Причина);
					КонецЕсли; 
					
				КонецПопытки; 
			
			Если ЗначениеЗаполнено(ИдентификаторСообщения) Тогда
				ЭлементОбъект.Удалить();
				Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Истина, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
			Иначе
				ЭлементОбъект.ПроизошлаОшибкаПередачи = Истина;
				ЭлементОбъект.ОписаниеОшибки = ОписаниеОшибки;
				ЭлементОбъект.Записать();
				Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Ложь, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
			КонецЕсли;
			
		КонецЕсли;
	Иначе
		Возврат РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщениеОчереди(Ложь, ЭлементСсылка, ТипРассылки, ПараметрыСообщения, Соединение);
	КонецЕсли;
	
КонецФункции

// Обрабатывается очередь электронных чеков. Обрабатывается регламентным заданием "РассылкаЭлектронныхЧеков".
//
Процедура ОтправитьСообщенияОчереди() Экспорт
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	Если Параметры.НаличиеБСП Тогда
		ОбщийМодуль("ОбщегоНазначения").ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.РассылкаЭлектронныхЧеков);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Проверка записей готовых к передаче.
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОчередьЭлектронныхЧековКОтправке.ДатаПостановкиВОчередь
	|ИЗ
	|	Справочник.ОчередьЭлектронныхЧековКОтправке КАК ОчередьЭлектронныхЧековКОтправке
	|ГДЕ
	|	НЕ ОчередьЭлектронныхЧековКОтправке.ПроизошлаОшибкаПередачи";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	Соединение = Неопределено;
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	Если Параметры.НаличиеПодсистемыРаботаСПочтовымиСообщениями Тогда
		Попытка
			
			Профиль = ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный").ИнтернетПочтовыйПрофиль(ОбщийМодуль("РаботаСПочтовымиСообщениями").СистемнаяУчетнаяЗапись());
			Соединение = Новый ИнтернетПочта;
			ПротоколПодключения = ?(ПустаяСтрока(Профиль.АдресСервераIMAP),ПротоколИнтернетПочты.POP3, ПротоколИнтернетПочты.IMAP);
			Соединение.Подключиться(Профиль, ПротоколПодключения);
			
		Исключение
			
			ТекстСообщенияОбОшибке = ОбщийМодуль("СтроковыеФункцииКлиентСервер").ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Во время подключения к учетной записи %1 произошла ошибка
					|%2'", ОбщийМодуль("ОбщегоНазначенияКлиентСервер").КодОсновногоЯзыка()),
				ОбщийМодуль("РаботаСПочтовымиСообщениями").СистемнаяУчетнаяЗапись(),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Очередь отправки электронных писем'", ОбщийМодуль("ОбщегоНазначенияКлиентСервер").КодОсновногоЯзыка()),
			                         УровеньЖурналаРегистрации.Ошибка, , ,
			                         ТекстСообщенияОбОшибке);
		
		КонецПопытки;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОчередьЭлектронныхЧековКОтправке.ТипРассылки,
	|	ОчередьЭлектронныхЧековКОтправке.ПараметрыСообщения,
	|	ОчередьЭлектронныхЧековКОтправке.Ссылка
	|ИЗ
	|	Справочник.ОчередьЭлектронныхЧековКОтправке КАК ОчередьЭлектронныхЧековКОтправке
	|ГДЕ
	|	НЕ ОчередьЭлектронныхЧековКОтправке.ПроизошлаОшибкаПередачи
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОчередьЭлектронныхЧековКОтправке.ДатаПостановкиВОчередь";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	КоличествоСообщений = 0;
	Пока Выборка.Следующий() Цикл
		
		РассылкаЭлектронныхЧеков.ОтправитьСообщениеОчереди(Выборка.Ссылка,
						Выборка.ТипРассылки,
						Выборка.ПараметрыСообщения,
						Соединение);
		
		КоличествоСообщений = КоличествоСообщений + 1;
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщенияОчереди();
	
КонецПроцедуры

// Проверка наличия подсистем БСП.
//
Функция ПараметрыИспользования() Экспорт
	
	Параметры = Новый Структура;
	
	СтандартныеПодсистемы = Метаданные.Подсистемы.Найти("СтандартныеПодсистемы");
	
	Параметры.Вставить("НаличиеБСП", СтандартныеПодсистемы <> Неопределено);
	Если Параметры.НаличиеБСП Тогда
		Параметры.Вставить("НаличиеПодсистемыОтправкаSMS", СтандартныеПодсистемы.Подсистемы.Найти("ОтправкаSMS") <> Неопределено);
		Параметры.Вставить("НаличиеПодсистемыРаботаСПочтовымиСообщениями", СтандартныеПодсистемы.Подсистемы.Найти("РаботаСПочтовымиСообщениями") <> Неопределено);
	Иначе
		Параметры.Вставить("НаличиеПодсистемыОтправкаSMS", Ложь);
		Параметры.Вставить("НаличиеПодсистемыРаботаСПочтовымиСообщениями", Ложь);
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции // ПараметрыИспользования()

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль.
//
Функция ОбщийМодуль(Имя) Экспорт
	
	Если Метаданные.ОбщиеМодули.Найти(Имя) <> Неопределено Тогда
		Модуль = Вычислить(Имя); // ВычислитьВБезопасномРежиме не требуется, т.к. проверка надежная.
	ИначеЕсли СтрЧислоВхождений(Имя, ".") = 1 Тогда
		Возврат СерверныйМодульМенеджера(Имя);
	Иначе
		Модуль = Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ТекстИсключения = НСтр("ru = 'Общий модуль ""%1"" не найден.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения,"%1", Имя);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Возврат Модуль;
	
КонецФункции

// Удаляет сообщения из очереди, вызывается из формы списка справочника "ОчередьЭлектронныхЧековКОтправке"
// 
// Параметры:
//  МассивСообщений - Массив ссылок  справочник "ОчередьЭлектронныхЧеков"
//  
Процедура УдалитьСообщенияМассива(МассивСообщений) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КоличествоСообщений = 0;
	Для каждого СообщениеСсылка Из МассивСообщений Цикл
		
		Попытка
			СообщениеОбъект = СообщениеСсылка.ПолучитьОбъект();
			СообщениеОбъект.Удалить();
			КоличествоСообщений = КоличествоСообщений + 1;
		Исключение
			КоличествоСообщений = 0;
		КонецПопытки;
	КонецЦикла;
	
	Текст = НСтр("ru = 'Удалено %1 электронных чеков(-а).'");
	Текст =  СтрЗаменить(Текст, "%1", КоличествоСообщений);
	
	ОбщийМодуль("ОбщегоНазначенияКлиентСервер").СообщитьПользователю(Текст);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	РассылкаЭлектронныхЧековПереопределяемый.УдалитьСообщенияМассива(МассивСообщений);
	
КонецПроцедуры

// Отправляет сообщения из очереди, вызывается из формы списка справочника "ОчередьЭлектронныхЧековКОтправке"
// 
// Параметры:
//  МассивСообщений - Массив ссылок.
//  
Процедура ОтправитьСообщенияМассива(МассивСообщений) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	Если Параметры.НаличиеБСП Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		Если Параметры.НаличиеПодсистемыРаботаСПочтовымиСообщениями Тогда
			Попытка
				
				Профиль = ОбщийМодуль("РаботаСПочтовымиСообщениямиСлужебный").ИнтернетПочтовыйПрофиль(ОбщийМодуль("РаботаСПочтовымиСообщениями").СистемнаяУчетнаяЗапись());
				Соединение = Новый ИнтернетПочта;
				ПротоколПодключения = ?(ПустаяСтрока(Профиль.АдресСервераIMAP),ПротоколИнтернетПочты.POP3, ПротоколИнтернетПочты.IMAP);
				Соединение.Подключиться(Профиль, ПротоколПодключения);
				
			Исключение
				
				ТекстСообщенияОбОшибке = ОбщийМодуль("СтроковыеФункцииКлиентСервер").ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Во время подключения к учетной записи %1 произошла ошибка
						|%2'", ОбщийМодуль("ОбщегоНазначенияКлиентСервер").КодОсновногоЯзыка()),
					ОбщийМодуль("РаботаСПочтовымиСообщениями").СистемнаяУчетнаяЗапись(),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Очередь отправки электронных писем'", ОбщийМодуль("ОбщегоНазначенияКлиентСервер").КодОсновногоЯзыка()),
				                         УровеньЖурналаРегистрации.Ошибка, , ,
				                         ТекстСообщенияОбОшибке);
			
			КонецПопытки;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОчередьЭлектронныхЧековКОтправке.ТипРассылки,
		|	ОчередьЭлектронныхЧековКОтправке.ПараметрыСообщения,
		|	ОчередьЭлектронныхЧековКОтправке.Ссылка
		|ИЗ
		|	Справочник.ОчередьЭлектронныхЧековКОтправке КАК ОчередьЭлектронныхЧековКОтправке
		|ГДЕ
		|	ОчередьЭлектронныхЧековКОтправке.Ссылка В(&МассивСообщений)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОчередьЭлектронныхЧековКОтправке.ДатаПостановкиВОчередь";
		
		Запрос.Параметры.Вставить("МассивСообщений", МассивСообщений);
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		КоличествоСообщений = 0;
		Пока Выборка.Следующий() Цикл
			
			Отправлено = РассылкаЭлектронныхЧеков.ОтправитьСообщениеОчереди(Выборка.Ссылка,
							Выборка.ТипРассылки,
							Выборка.ПараметрыСообщения,
							Соединение);
			
			Если Отправлено Тогда
				КоличествоСообщений = КоличествоСообщений + 1;
			КонецЕсли;
		КонецЦикла;
		
		Текст = НСтр("ru = 'Отправлено %1 электронных чеков(-а).'");
		Текст =  СтрЗаменить(Текст, "%1", КоличествоСообщений);
		
		ОбщийМодуль("ОбщегоНазначенияКлиентСервер").СообщитьПользователю(Текст);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	РассылкаЭлектронныхЧековПереопределяемый.ОтправитьСообщенияМассива(МассивСообщений);
	
КонецПроцедуры


// Обработка преряет не доступные элементы  формы списка справочника "ОчередьЭлектронныхЧековКОтправке"
//
Процедура ПриСозданииСпискаОчереди(ЭтотОбъект) Экспорт
	
	Параметры = РассылкаЭлектронныхЧековПовтИсп.ПараметрыИспользования();
	
	ЭтотОбъект.Элементы.ФормаОтправить.Видимость = Параметры.НаличиеБСП;
	ЭтотОбъект.Элементы.ФормаУдалить.Видимость   = Параметры.НаличиеБСП;
	ЭтотОбъект.Элементы.ОтборПоОшибкам.Видимость = Параметры.НаличиеБСП;
	
	РассылкаЭлектронныхЧековПереопределяемый.ПриСозданииСпискаОчереди(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедуры

// Возвращает серверный модуль менеджера по имени объекта.
Функция СерверныйМодульМенеджера(Имя)
	ОбъектНайден = Ложь;
	
	ЧастиИмени = СтрРазделить(Имя, ".");
	Если ЧастиИмени.Количество() = 2 Тогда
		
		ИмяВида = ВРег(ЧастиИмени[0]);
		ИмяОбъекта = ЧастиИмени[1];
		
		Если ИмяВида = ВРег(ИмяТипаКонстанты()) Тогда
			Если Метаданные.Константы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаРегистрыСведений()) Тогда
			Если Метаданные.РегистрыСведений.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаРегистрыНакопления()) Тогда
			Если Метаданные.РегистрыНакопления.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаРегистрыБухгалтерии()) Тогда
			Если Метаданные.РегистрыБухгалтерии.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаРегистрыРасчета()) Тогда
			Если Метаданные.РегистрыРасчета.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаСправочники()) Тогда
			Если Метаданные.Справочники.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаДокументы()) Тогда
			Если Метаданные.Документы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаОтчеты()) Тогда
			Если Метаданные.Отчеты.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаОбработки()) Тогда
			Если Метаданные.Обработки.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаБизнесПроцессы()) Тогда
			Если Метаданные.БизнесПроцессы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаЖурналыДокументов()) Тогда
			Если Метаданные.ЖурналыДокументов.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаЗадачи()) Тогда
			Если Метаданные.Задачи.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаПланыСчетов()) Тогда
			Если Метаданные.ПланыСчетов.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаПланыОбмена()) Тогда
			Если Метаданные.ПланыОбмена.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаПланыВидовХарактеристик()) Тогда
			Если Метаданные.ПланыВидовХарактеристик.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаПланыВидовРасчета()) Тогда
			Если Метаданные.ПланыВидовРасчета.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ОбъектНайден Тогда
		
		ТекстИсключения = НСтр("ru = 'Объект метаданных ""%1"" не найден,
			|либо для него не поддерживается получение модуля менеджера.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения,"%1", Имя);
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
	Модуль = Вычислить(Имя); // ВычислитьВБезопасномРежиме не требуется, т.к. проверка надежная.
	
	Возврат Модуль;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Имена типов.

// Возвращает значение для идентификации общего типа "Регистры сведений".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаРегистрыСведений() Экспорт
	
	Возврат "РегистрыСведений";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Регистры накопления".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаРегистрыНакопления() Экспорт
	
	Возврат "РегистрыНакопления";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Регистры бухгалтерии".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаРегистрыБухгалтерии() Экспорт
	
	Возврат "РегистрыБухгалтерии";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Регистры расчета".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаРегистрыРасчета() Экспорт
	
	Возврат "РегистрыРасчета";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Документы".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаДокументы() Экспорт
	
	Возврат "Документы";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Справочники".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаСправочники() Экспорт
	
	Возврат "Справочники";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Перечисления".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаПеречисления() Экспорт
	
	Возврат "Перечисления";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Отчеты".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаОтчеты() Экспорт
	
	Возврат "Отчеты";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Обработки".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаОбработки() Экспорт
	
	Возврат "Обработки";
	
КонецФункции

// Возвращает значение для идентификации общего типа "ПланыОбмена".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаПланыОбмена() Экспорт
	
	Возврат "ПланыОбмена";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Планы видов характеристик".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаПланыВидовХарактеристик() Экспорт
	
	Возврат "ПланыВидовХарактеристик";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Бизнес-процессы".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаБизнесПроцессы() Экспорт
	
	Возврат "БизнесПроцессы";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Задачи".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаЗадачи() Экспорт
	
	Возврат "Задачи";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Планы счетов".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаПланыСчетов() Экспорт
	
	Возврат "ПланыСчетов";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Планы видов расчета".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаПланыВидовРасчета() Экспорт
	
	Возврат "ПланыВидовРасчета";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Константы".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаКонстанты() Экспорт
	
	Возврат "Константы";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Журналы документов".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаЖурналыДокументов() Экспорт
	
	Возврат "ЖурналыДокументов";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Последовательности".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаПоследовательности() Экспорт
	
	Возврат "Последовательности";
	
КонецФункции

// Возвращает значение для идентификации общего типа "РегламентныеЗадания".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаРегламентныеЗадания() Экспорт
	
	Возврат "РегламентныеЗадания";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Перерасчеты".
//
// Возвращаемое значение:
//  Строка.
//
Функция ИмяТипаПерерасчеты() Экспорт
	
	Возврат "Перерасчеты";
	
КонецФункции

#КонецОбласти
