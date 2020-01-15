﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"БонуснаяПрограммаЛояльности",
		Параметры.БонуснаяПрограммаЛояльности,
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	ТекущаяДата = ТекущаяДатаСеанса();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПараметрыОткрытия = Новый Структура("Ключ", Элементы.Список.ТекущиеДанные.СкидкаНаценка);
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.СкидкиНаценки.Форма.ФормаЭлемента", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

