﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполнения = Новый Структура;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	   И Не ДанныеЗаполнения.Свойство("СпособРаспределения")
	Тогда
		ДанныеЗаполнения.Вставить("СпособРаспределения", Справочники.НаправленияДеятельности.ПустаяСсылка());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли