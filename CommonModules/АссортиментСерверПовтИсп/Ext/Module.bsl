﻿////////////////////////////////////////////////////////////////////////////////
// Модуль "Ассортимент", содержит процедуры и функции для
// проверки корректности документов изменения ассортимента и установки квот ассортимента,
// обработки регистрации ассортимента в регистрах,
// обработки введенных пользователем данных,
// а также содержит ряд вспомогательных функций и процедур
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает признак контроля ассортимента по истории изменений
//
// Параметры:
//  Склад  - СправочникСсылка.Склады - Склад/магазин для которого проверяется контроль ассортимента
//  НаДату  - Дата - Дата на которую производится проверка контроля ассортимента
//
// Возвращаемое значение:
//   Булево   - Истина, если ассортимент контроллируется на складе и Ложь, если нет.
//
Функция КонтролироватьАссортимент(Знач Склад, Знач НаДату = Неопределено) Экспорт 

	Если ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент") Тогда
	
		Возврат АссортиментСервер.КонтролироватьАссортимент(Склад, НаДату);
	
	Иначе
	
		Возврат Ложь;
	
	КонецЕсли;

КонецФункции 

#КонецОбласти