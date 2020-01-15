﻿
#Область ПрограммныйИнтерфейс

// Позволяет добавить описание кросс объектной связи типов для получателей рассылки.

// см. РассылкаОтчетовПереопределяемый.ПереопределитьТаблицуТиповПолучателей()
//
Процедура ПриПереопределенииТаблицыТиповПолучателей(ТаблицаТипов, ДоступныеТипы) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Позволяет исключить отчеты, которые не готовы к интеграции с рассылкой.
//   
// см. РассылкаОтчетовПереопределяемый.ОпределитьИсключаемыеОтчеты()
//
Процедура ОпределитьИсключаемыеОтчеты(ИсключаемыеОтчеты) Экспорт
	
	//++ Локализация
	ИсключаемыеОтчеты.Добавить(Метаданные.Отчеты.ПроблемыПроверкиКонтрагентов);
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
