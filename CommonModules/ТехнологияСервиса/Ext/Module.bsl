﻿#Область ПрограммныйИнтерфейс

// Возвращает версию библиотеки "1С:Библиотека технологии сервиса"
//
// Возвращаемое значение: Строка, версия библиотеки в формате РР.{П|ПП}.ЗЗ.СС.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат "1.0.12.27";
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Вызывается при включении разделения данных по областям данных.
//
Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
	
	ПроверитьВозможностьИспользованияКонфигурацииВМоделиСервиса();
	
КонецПроцедуры

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "*";
		Обработчик.Процедура = "ТехнологияСервиса.ПроверитьВозможностьИспользованияКонфигурацииВМоделиСервиса";
		Обработчик.ОбщиеДанные = Истина;
		Обработчик.ВыполнятьВГруппеОбязательных = Истина;
		Обработчик.Приоритет = 99;
		Обработчик.МонопольныйРежим = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при установке параметров сеанса.
//
// Параметры:
//  ИменаПараметровСеанса - Массив, Неопределено.
//
Процедура ВыполнитьДействияПриУстановкеПараметровСеанса(Параметры) Экспорт
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		
		МодульПользователиСлужебныйВМоделиСервисаБТС = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ПользователиСлужебныйВМоделиСервисаБТС");
		МодульПользователиСлужебныйВМоделиСервисаБТС.ПриУстановкеПараметровСеанса(Параметры);
		
	КонецЕсли;
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ЭлектроннаяПодписьВМоделиСервиса") Тогда
			
		МодульЭлектроннаяПодписьВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("ЭлектроннаяПодписьВМоделиСервиса");
		МодульЭлектроннаяПодписьВМоделиСервиса.ПриУстановкеПараметровСеанса(Параметры);
		
	КонецЕсли;
		
КонецПроцедуры

// Проверяет возможность использования конфигурации в модели сервиса.
//  При невозможности использования - генерируется исключение с указанием причины,
//  из-за которой использование конфигурации в модели сервиса невозможно.
//
Процедура ПроверитьВозможностьИспользованияКонфигурацииВМоделиСервиса() Экспорт
	
	ОписанияПодсистем = СтандартныеПодсистемыПовтИсп.ОписанияПодсистем().ПоИменам;
	ОписаниеБСП = ОписанияПодсистем.Получить("СтандартныеПодсистемы");
	
	Если ОписаниеБСП = Неопределено Тогда
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'В конфигурацию не внедрена библиотека ""1С:Библиотека стандартных подсистем"".
                  |Без внедрения этой библиотеки конфигурация не может использоваться в модели сервиса.
                  |
                  |Для использования этой конфигурации в модели сервиса требуется внедрить библиотеку
                  |""1С:Библиотека стандартных подсистем"" версии не младше %1!'", Метаданные.ОсновнойЯзык.КодЯзыка),
			ТребуемаяВерсияБСП());
		
	Иначе
		
		ВерсияБСП = ОписаниеБСП.Версия;
		
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБСП, ТребуемаяВерсияБСП()) < 0 Тогда
			
			ВызватьИсключение СтрШаблон(
				НСтр("ru = 'Для использования конфигурации в модели сервиса с текущей версией библиотеки
                      |""1С:Библиотека технологии сервиса"" требуется обновить используемую версию
                      |библиотеки ""1С:Библиотека стандартных подсистем""!
                      |
                      |Используемая версия: %1, требуется версия не младше %2!'", Метаданные.ОсновнойЯзык.КодЯзыка),
				ВерсияБСП, ТребуемаяВерсияБСП());
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует описание ошибки для передачи через web-сервис
//
// Параметры:
//  ИнформацияОбОшибке - ИнформацияОбОшибке - информация об ошибке,
//   на основе которой требуется сформировать описание.
//
// Возвращаемое значение:
//  ОбъектXDTO - {http://www.1c.ru/SaaS/ServiceCommon}ErrorDescription
//   описание ошибки для передачи через web-сервис.
//
Функция ПолучитьОписаниеОшибкиWebСервиса(ИнформацияОбОшибке) Экспорт
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение операции web-сервиса'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , ,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
	ОписаниеОшибки = ФабрикаXDTO.Создать(
		ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ServiceCommon", "ErrorDescription"));
		
	ОписаниеОшибки.BriefErrorDescription = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	ОписаниеОшибки.DetailErrorDescription = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	
	Возврат ОписаниеОшибки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает минимальную поддерживаемую версию библиотеки "1С:Библиотека стандартных подсистем".
//
// Возвращаемое значение: Строка, версия библиотеки в формате РР.{П|ПП}.ЗЗ.СС.
//
Функция ТребуемаяВерсияБСП()
	
	Возврат "2.4.1.1";
	
КонецФункции

#КонецОбласти
