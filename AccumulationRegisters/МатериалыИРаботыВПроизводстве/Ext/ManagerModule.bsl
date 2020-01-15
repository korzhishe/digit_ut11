﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.МатериалыИРаботыВПроизводстве";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВводОстатков.Ссылка КАК Регистратор
	|ИЗ
	|	Документ.ВводОстатков КАК ВводОстатков
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводОстатков.Товары КАК ВводОстатковТовары
	|		ПО ВводОстатков.Ссылка = ВводОстатковТовары.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.МатериалыИРаботыВПроизводстве КАК МатериалыИРаботыВПроизводстве
	|		ПО ВводОстатков.Ссылка = МатериалыИРаботыВПроизводстве.Регистратор
	|			И (ВводОстатковТовары.Номенклатура = МатериалыИРаботыВПроизводстве.Номенклатура)
	|ГДЕ
	|	ВводОстатков.ТипОперации = ЗНАЧЕНИЕ(Перечисление.ТипыОперацийВводаОстатков.ОстаткиМатериаловПереданныхПереработчикам)
	|	И ВводОстатков.ОтражатьВОперативномУчете
	|	И ВводОстатковТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|	И МатериалыИРаботыВПроизводстве.Регистратор ЕСТЬ NULL";
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
		Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор"), ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.МатериалыИРаботыВПроизводстве";
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ВводОстатков");
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы, ПолноеИмяРегистра, Параметры.Очередь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли