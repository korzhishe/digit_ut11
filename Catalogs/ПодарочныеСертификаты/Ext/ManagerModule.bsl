﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//  Массив - блокируемые реквизиты объекта
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("Владелец");
	
	Возврат Результат;

КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	Если Пользователи.ЭтоПолноправныйПользователь()
		 И ПолучитьФункциональнуюОпцию("ИспользоватьПодарочныеСертификаты") Тогда
		// Подарочный сертификат
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьПодарочныхСертификатов";
		КомандаПечати.Идентификатор = "ПодарочныйСертификат";
		КомандаПечати.Представление = НСтр("ru = 'Подарочный сертификат'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КонецЕсли;

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
КонецПроцедуры

// Функция получает данные для формирования печатной формы Подарочный сертификат.
//
// Параметры:
//  ПараметрыПечати - Структура - Параметры печати.
//  МассивОбъектов - Массив - Массив подарочных сертификатов.
//
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * РезультатЗапроса - РезультатЗапроса - Результат запроса.
//   * ЗаголовокДокумента - Строка - Заголовок документа.
//
Функция ПолучитьДанныеДляПечатнойФормыПодарочныйСертификат(ПараметрыПечати, МассивОбъектов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПодарочныеСертификаты.Ссылка        КАК Ссылка,
	|	ПодарочныеСертификаты.Код           КАК СерийныйНомер,
	|	ПодарочныеСертификаты.Штрихкод      КАК Штрихкод,
	|	ПодарочныеСертификаты.МагнитныйКод  КАК МагнитныйКод,
	|	ПодарочныеСертификаты.Владелец.Номинал  КАК Номинал,
	|	ПодарочныеСертификаты.Владелец.Валюта   КАК Валюта
	|ИЗ
	|	Справочник.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка В (&МассивДокументов)
	|");
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДанныхДляПечати    = Новый Структура("РезультатЗапроса, ЗаголовокДокумента",
	                                               РезультатЗапроса, НСтр("ru = 'Подарочный сертификат'"));
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли