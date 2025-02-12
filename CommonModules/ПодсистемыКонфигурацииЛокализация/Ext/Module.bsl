﻿
#Область ПрограммныйИнтерфейс

// Определяет список модулей библиотек и конфигурации, которые предоставляют
// основные сведения о себе: имя, версия, список обработчиков обновления
// а также зависимости от других библиотек.
//
// Состав обязательных процедур такого модуля см. в общем модуле ОбновлениеИнформационнойБазыБСП
// (область ПрограммныйИнтерфейс).
// При этом сам модуль Библиотеки стандартных подсистем ОбновлениеИнформационнойБазыБСП
// не требуется явно добавлять в массив МодулиПодсистем.
//
// Параметры:
//  МодулиПодсистем - Массив - имена серверных общих модулей библиотек и конфигурации.
//                             Например: "ОбновлениеИнформационнойБазыБРО" - библиотека,
//                                       "ОбновлениеИнформационнойБазыБП"  - конфигурация.
//                    
Процедура ПриДобавленииПодсистем(МодулиПодсистем) Экспорт
	
	//++ Локализация
	
	//++ НЕ ГОСИС
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБЭД");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБИП");
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыБИД");
	//-- НЕ ГОСИС
	
	//++ НЕ ГИСМ
	//++ НЕ ВЕТИС
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыЕГАИС");
	//-- НЕ ВЕТИС
	//-- НЕ ГИСМ
	
	//++ НЕ ЕГАИС
	//++ НЕ ВЕТИС
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыГИСМ");
	//-- НЕ ВЕТИС
	//-- НЕ ЕГАИС
	
	//++ НЕ ГИСМ
	//++ НЕ ЕГАИС
	МодулиПодсистем.Добавить("ОбновлениеИнформационнойБазыВЕТИС");
	//-- НЕ ЕГАИС
	//-- НЕ ГИСМ
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
