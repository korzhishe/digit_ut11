﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КассаККМОтбор        = Параметры.КассаККМ;
	КартаЛояльностиОтбор = Параметры.КартаЛояльности;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КассаККМ", КассаККМОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КассаККМОтбор));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КартаЛояльности", КартаЛояльностиОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КартаЛояльностиОтбор));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассаККМОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КассаККМ", КассаККМОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КассаККМОтбор));
	
КонецПроцедуры

&НаКлиенте
Процедура КартаЛояльностиОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "КартаЛояльности", КартаЛояльностиОтбор, ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(КартаЛояльностиОтбор));
	
КонецПроцедуры

#КонецОбласти
