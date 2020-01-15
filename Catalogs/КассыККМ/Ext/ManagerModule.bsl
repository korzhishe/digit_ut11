﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает реквизиты объекта, которые необходимо блокировать от изменения
//
// Возвращаемое значение:
//	Массив - блокируемые реквизиты объекта
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ВалютаДенежныхСредств");
	Результат.Добавить("Владелец");
	Результат.Добавить("Склад");
	Результат.Добавить("ТипКассы");
	
	Возврат Результат;
	
КонецФункции

// Функция определяет фискальный регистратор по умолчанию.
//
// Возвращает кассу ККМ, если найдена одна касса.
// Возвращает Неопределено, если касса не найдена или касс больше одной.
//
// Возвращаемое значение:
//	СправочникСсылка.КассыККМ - Найденная касса ККМ
//
Функция КассаККМФискальныйРегистраторПоУмолчанию() Экспорт
	
	КассаККМ = Неопределено;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	КассыККМ.Ссылка КАК КассаККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Если Выборка.Следующий() Тогда
			КассаККМ = Выборка.КассаККМ;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КассаККМ;

КонецФункции

// Функция определяет фискальный регистратор по умолчанию.
//
// Возвращает кассу ККМ, если найдена одна касса.
// Возвращает Неопределено, если касса не найдена или касс больше одной.
//
// Возвращаемое значение:
//	СправочникСсылка.КассыККМ - Найденная касса ККМ
//
Функция КассаККМФискальныйРегистраторДляРМК() Экспорт
	
	КассаККМ = Неопределено;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	КассыККМ.Ссылка КАК КассаККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|	И 1 В (ВЫБРАТЬ 1 Из Справочник.НастройкиРМК.КассыККМ КАК Т Где Т.Ссылка.РабочееМесто = &РабочееМесто И Т.КассаККМ = КассыККМ.Ссылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КассыККМ.Ссылка КАК КассаККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|	И НЕ 1 В (ВЫБРАТЬ 1 Из Справочник.НастройкиРМК КАК Т Где Т.РабочееМесто = &РабочееМесто)
	|");
	
	Запрос.Параметры.Вставить("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		КассаККМ = Выборка.КассаККМ;
	КонецЕсли;
	
	Возврат КассаККМ;

КонецФункции

// Функция определяет автономную кассу по умолчанию.
//
// Возвращает кассу ККМ, если найдена одна касса.
// Возвращает Неопределено, если касса не найдена или касс больше одной.
//
// Возвращаемое значение:
//	СправочникСсылка.КассыККМ - Найденная касса ККМ
//
Функция АвтономнаяКассаККМПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	КассыККМ.Ссылка КАК КассаККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.АвтономнаяККМ)
	|	И НЕ КассыККМ.ПометкаУдаления
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 
	   И Выборка.Следующий()
	Тогда
		КассаККМ = Выборка.КассаККМ;
	Иначе
		КассаККМ = Неопределено;
	КонецЕсли;
	
	Возврат КассаККМ;

КонецФункции

// Функция определяет кассу по умолчанию.
//
// Возвращает кассу ККМ, если найдена одна касса.
// Возвращает Неопределено, если касса не найдена или касс больше одной.
//
// Возвращаемое значение:
//	СправочникСсылка.КассыККМ - Найденная касса ККМ
//
Функция КассаККМПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	КассыККМ.Ссылка КАК КассаККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	НЕ КассыККМ.ПометкаУдаления
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 
	   И Выборка.Следующий()
	Тогда
		КассаККМ = Выборка.КассаККМ;
	Иначе
		КассаККМ = Неопределено;
	КонецЕсли;
	
	Возврат КассаККМ;

КонецФункции

// Функция определяет валюту выбранной кассы ККМ.
//
// Параметры:
//  КассаККМ - СправочникСсылка.КассыККМ - Ссылка на кассу ККМ
//
// Возвращаемое значение:
//	Структура - Организация и Валюта выбранной кассы ККМ
//
Функция РеквизитыКассыККМ(КассаККМ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КассыККМ.Склад КАК Склад,
	|	КассыККМ.Владелец КАК Организация,
	|	КассыККМ.Склад.РозничныйВидЦены КАК ВидЦены,
	|	КассыККМ.Склад.РозничныйВидЦены.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	КассыККМ.ВалютаДенежныхСредств КАК Валюта,
	|	КассыККМ.ТипКассы КАК ТипКассы
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	КассыККМ.Ссылка = &КассаККМ";
	
	Запрос.УстановитьПараметр("КассаККМ", КассаККМ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Склад           = Выборка.Склад;
		Организация     = Выборка.Организация;
		ВидЦены         = Выборка.ВидЦены;
		ЦенаВключаетНДС = Выборка.ЦенаВключаетНДС;
		Валюта          = Выборка.Валюта;
		ТипКассы        = Выборка.ТипКассы;
	Иначе
		Склад           = Неопределено;
		Организация     = Неопределено;
		ВидЦены         = Неопределено;
		ЦенаВключаетНДС = Неопределено;
		Валюта          = Неопределено;
		ТипКассы        = Неопределено;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("Склад, Организация, ВидЦены, ЦенаВключаетНДС, Валюта, ТипКассы",
		Склад,
		Организация,
		ВидЦены,
		ЦенаВключаетНДС,
		Валюта,
		ТипКассы);
	
	Возврат СтруктураРеквизитов;

КонецФункции

// Функция выполняет получение параметров кассы ККМ.
//
// Параметры:
//  КассаККМ - СправочникСсылка.КассыККМ - Касса ККМ.
//
// Возвращаемое значение:
//  Структура со свойствами:
//   * ИдентификаторУстройства - Строка - Идентификатор устройства.
//   * ИспользоватьБезПодключенияОборудования - Булево - Использовать без подключения оборудования.
//   * ЭтоФискальныйРегистратор - Булево - Признак фискального регистратора.
//   * ИспользоватьСкладскиеПомещения - Булево - Признак использования складских помещений.
//   * КассаККМ - СправочникСсылка.КассыККМ - Касса ККМ.
//   * НастройкиРМК - СправочникСсылка.НастройкиРМК - Ссылка на настройки РМК.
//
Функция ПараметрыКассыККМ(КассаККМ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(НастройкиРМККассыККМ.Ссылка, ЗНАЧЕНИЕ(Справочник.НастройкиРМК.ПустаяСсылка)) КАК НастройкиРМК,
	|	ВЫБОР
	|		КОГДА КассыККМ.ТипКассы = ЗНАЧЕНИЕ(Перечисление.ТипыКассККМ.ФискальныйРегистратор)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоФискальныйРегистратор,
	|	ЕСТЬNULL(НастройкиРМККассыККМ.ПодключаемоеОборудование, ЗНАЧЕНИЕ(Справочник.ПодключаемоеОборудование.ПустаяСсылка)) КАК ИдентификаторУстройства,
	|	ВЫБОР КОГДА
	|		НастройкиРМККассыККМ.ПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.ККТ) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК ДоступнаПередачаДанных,
	|	ЕСТЬNULL(НастройкиРМККассыККМ.ИспользоватьБезПодключенияОборудования, Истина) КАК ИспользоватьБезПодключенияОборудования,
	|	КассыККМ.Ссылка                КАК КассаККМ,
	|	КассыККМ.ВалютаДенежныхСредств КАК Валюта,
	|	КассыККМ.Владелец              КАК Организация,
	|	ЕСТЬNULL(КассыККМ.Склад.ИспользоватьСкладскиеПомещения, ЛОЖЬ) КАК ИспользоватьСкладскиеПомещения,
	|	ВЫБОР КОГДА ЕСТЬNULL(НастройкиРМККассыККМ.ИспользоватьБезПодключенияОборудования, ЛОЖЬ) ТОГДА
	|		КассыККМ.СерийныйНомер
	|	ИНАЧЕ
	|		ВЫБОР КОГДА НастройкиРМККассыККМ.ПодключаемоеОборудование.СерийныйНомер <> """" ТОГДА
	|			НастройкиРМККассыККМ.ПодключаемоеОборудование.СерийныйНомер
	|		ИНАЧЕ
	|			КассыККМ.СерийныйНомер
	|		КОНЕЦ
	|	КОНЕЦ КАК СерийныйНомер
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиРМК.КассыККМ КАК НастройкиРМККассыККМ
	|		ПО (НастройкиРМККассыККМ.КассаККМ = КассыККМ.Ссылка)
	|			И (НастройкиРМККассыККМ.Ссылка.РабочееМесто = &РабочееМесто)
	|ГДЕ
	|	КассыККМ.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", КассаККМ);
	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ИдентификаторУстройства",                Справочники.ПодключаемоеОборудование.ПустаяСсылка());
	ВозвращаемоеЗначение.Вставить("ИспользоватьБезПодключенияОборудования", Истина);
	ВозвращаемоеЗначение.Вставить("ЭтоФискальныйРегистратор",               Ложь);
	ВозвращаемоеЗначение.Вставить("ИспользоватьСкладскиеПомещения",         Ложь);
	ВозвращаемоеЗначение.Вставить("Организация",                            Справочники.Организации.ПустаяСсылка());
	ВозвращаемоеЗначение.Вставить("КассаККМ",                               КассаККМ);
	ВозвращаемоеЗначение.Вставить("Валюта",                                 Константы.ВалютаРегламентированногоУчета.Получить());
	ВозвращаемоеЗначение.Вставить("ДоступнаПередачаДанных",                 Ложь);
	ВозвращаемоеЗначение.Вставить("НастройкиРМК",                           Справочники.НастройкиРМК.ПустаяСсылка());
	ВозвращаемоеЗначение.Вставить("СерийныйНомер",                          "");
	
	Если Выборка.Следующий() Тогда
		
		ВозвращаемоеЗначение.ИдентификаторУстройства                = Выборка.ИдентификаторУстройства;
		ВозвращаемоеЗначение.ИспользоватьБезПодключенияОборудования = Выборка.ИспользоватьБезПодключенияОборудования;
		ВозвращаемоеЗначение.ЭтоФискальныйРегистратор               = Выборка.ЭтоФискальныйРегистратор;
		ВозвращаемоеЗначение.ИспользоватьСкладскиеПомещения         = Выборка.ИспользоватьСкладскиеПомещения;
		ВозвращаемоеЗначение.Организация                            = Выборка.Организация;
		ВозвращаемоеЗначение.КассаККМ                               = Выборка.КассаККМ;
		ВозвращаемоеЗначение.Валюта                                 = Выборка.Валюта;
		ВозвращаемоеЗначение.ДоступнаПередачаДанных                 = Выборка.ДоступнаПередачаДанных;
		ВозвращаемоеЗначение.НастройкиРМК                           = Выборка.НастройкиРМК;
		ВозвращаемоеЗначение.СерийныйНомер                          = Выборка.СерийныйНомер;
		
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

//Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов
//
//	Возвращаемое значение:
//		Массив - массив имен реквизитов
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Владелец");
	НеРедактируемыеРеквизиты.Добавить("ВалютаДенежныхСредств");
	НеРедактируемыеРеквизиты.Добавить("Склад");
	НеРедактируемыеРеквизиты.Добавить("ТипКассы");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Получает остаток выданных в кассу ККМ, но еще не полученных денежных средств
//
// Параметры:
//    КассаККМ - СправочникСсылка.КассыККМ - Ссылка на кассу ККМ
//
// Возвращаемое значение:
//    Число - сумма денежных средств к поступлению в кассу ККМ
Функция СуммаКПоступлению(КассаККМ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДенежныеСредства.СуммаОстаток КАК КПоступлению
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВПути.Остатки(, Получатель = &КассаККМ) КАК ДенежныеСредства
	|";
	
	Запрос.УстановитьПараметр("КассаККМ", КассаККМ);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КПоступлению;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
