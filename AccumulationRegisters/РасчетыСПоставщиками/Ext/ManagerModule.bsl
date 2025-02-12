﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы
// Регистрирует данные для обработчика обновления
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИмяРегистра       = "РасчетыСПоставщиками";
	ПолноеИмяРегистра = "РегистрНакопления." + ИмяРегистра;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РасчетыСПоставщиками.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК РасчетыСПоставщиками
	|ГДЕ
	|	(РасчетыСПоставщиками.Сумма <> 0
	|			ИЛИ РасчетыСПоставщиками.КОплате <> 0)
	|	И РасчетыСПоставщиками.Регистратор ССЫЛКА Документ.ВводОстатков
	|	И РасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И ТИПЗНАЧЕНИЯ(РасчетыСПоставщиками.ЗаказПоставщику) НЕ В (&СписокТиповЗаказов)");
	
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
	
	ПолноеИмяРегистра = "РегистрНакопления.РасчетыСПоставщиками";
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ВводОстатков");

	ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Регистраторы, ПолноеИмяРегистра, Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры
#КонецОбласти

#КонецОбласти

#КонецЕсли
