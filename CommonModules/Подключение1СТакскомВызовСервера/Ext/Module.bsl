﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Подключение 1С-Такском".
// ОбщийМодуль.Подключение1СТакскомВызовСервера.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, доступно ли текущему пользователю использование сервиса
// 1С-Такском в соответствии с текущим режимом работы и правами пользователя.
//
// Возвращаемое значение:
//	Булево - Истина - использование доступно, Ложь - в противном случае.
//
Функция ДоступноИспользованиеСервиса1СТакском() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Отказ = Ложь;
	Подключение1СТакскомПереопределяемый.ИспользоватьСервис1СТакском(Отказ);
	Если Отказ = Истина Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Пользователи.РолиДоступны("ИспользованиеСервиса1СТакском", , Ложь);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает отпечаток указанного сертификата.
//
// Параметры:
//	Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
//		ссылка справочника сертификатов.
//
// Возвращаемое значение:
//	Строка - отпечаток указанного сертификата;
//	Неопределено - если сертификат не найден в справочнике сертификатов.
//
Функция ОтпечатокСертификата(Сертификат) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сертификат, "Отпечаток");
	
КонецФункции

#КонецОбласти