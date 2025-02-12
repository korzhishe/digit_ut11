﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список выбора статуса, в зависимости от включенных опций
//
// Параметры:
//  ДанныеВыбора			 - СписокЗначений	 - заполняемый список значений
//  ИспользоватьСтатусЗакрыт - Булево			 - признак необходимости использования статуса "Закрыт"
//
Процедура ЗаполнитьСписокВыбора(ДанныеВыбора, ИспользоватьСтатусЗакрыт) Экспорт
	
	ДанныеВыбора.Очистить();
	
	// Безусловные статусы
	ДанныеВыбора.Добавить(Перечисления.СтатусыВнутреннихЗаказов.КОбеспечению);
	ДанныеВыбора.Добавить(Перечисления.СтатусыВнутреннихЗаказов.КВыполнению);
	
	Если ИспользоватьСтатусЗакрыт Тогда
		ДанныеВыбора.Добавить(Перечисления.СтатусыВнутреннихЗаказов.Закрыт);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
