﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Заголовок", Заголовок);
	Параметры.Свойство("Информация", Информация);
	
	Если НЕ Параметры.Свойство("Пояснение", Элементы.ДекорацияПояснение.Заголовок) Тогда
		Элементы.ДекорацияПояснение.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти