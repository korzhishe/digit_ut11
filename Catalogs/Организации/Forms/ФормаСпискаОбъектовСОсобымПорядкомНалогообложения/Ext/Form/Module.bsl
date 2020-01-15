﻿
#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") Тогда
		Параметры.Отбор.Свойство("Организация", Организация);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Организация", 
			Организация, 
			ВидСравненияКомпоновкиДанных.Равно,,
			ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

#КонецОбласти
