﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает группу для дел, не входящих в разделы командного интерфейса.
//
Функция ПолноеИмя() Экспорт
	
	Настройки = Новый Структура;
	Настройки.Вставить("ЗаголовокПрочихДел");
	ТекущиеДелаПереопределяемый.ПриОпределенииНастроек(Настройки);
	Если ЗначениеЗаполнено(Настройки.ЗаголовокПрочихДел) Тогда
		ЗаголовокПрочихДел = Настройки.ЗаголовокПрочихДел;
	Иначе
		ЗаголовокПрочихДел = НСтр("ru = 'Прочие дела'");
	КонецЕсли;
	
	Возврат ЗаголовокПрочихДел;
КонецФункции

#КонецОбласти

#КонецЕсли