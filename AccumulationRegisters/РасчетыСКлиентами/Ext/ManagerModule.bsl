﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Регистрирует данные для обработчика обновления
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИмяРегистра       = "РасчетыСКлиентами";
	ПолноеИмяРегистра = "РегистрНакопления." + ИмяРегистра;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасчетыСКлиентами.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
	|ГДЕ
	|	(РасчетыСКлиентами.Сумма <> 0
	|			ИЛИ РасчетыСКлиентами.КОплате <> 0)
	|	И РасчетыСКлиентами.Регистратор ССЫЛКА Документ.ВводОстатков
	|	И РасчетыСКлиентами.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И ТИПЗНАЧЕНИЯ(РасчетыСКлиентами.ЗаказКлиента) НЕ В (&СписокТиповЗаказов)");
	
	СписокТиповЗаказов = Новый СписокЗначений;
	СписокТиповЗаказов.Добавить(Тип("СправочникСсылка.ДоговорыКонтрагентов"));
	СписокТиповЗаказов.Добавить(Тип("СправочникСсылка.ДоговорыМеждуОрганизациями"));
	СписокТиповЗаказов.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
	СписокТиповЗаказов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
	СписокТиповЗаказов.Добавить(Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента"));
	Запрос.УстановитьПараметр("СписокТиповЗаказов", СписокТиповЗаказов);
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, 
																Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор"),
																ПолноеИмяРегистра);
	
КонецПроцедуры

// Обработчик обновления УТ 11.4.2
// Заполняет реквизит РасчетныйДокумент
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.РасчетыСКлиентами";
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ВводОстатков");

	ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Регистраторы, ПолноеИмяРегистра, Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры



#КонецОбласти

#КонецОбласти

#КонецЕсли
