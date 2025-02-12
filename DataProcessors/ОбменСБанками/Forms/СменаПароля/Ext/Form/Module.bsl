﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ПаролиНеСовпадают.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПовторНовогоПароляОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПроверитьСовпадениеПаролей();
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйПарольОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПроверитьСовпадениеПаролей();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Проверить(Команда)
	
	Если НовыйПароль <> ПовторНовогоПароля Тогда
		Элементы.ПаролиНеСовпадают.Видимость = НовыйПароль <> ПовторНовогоПароля;
		Возврат;
	КонецЕсли;
	
	Закрыть(НовыйПароль);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьСовпадениеПаролей()
	
	Если ЗначениеЗаполнено(НовыйПароль) И ЗначениеЗаполнено(ПовторНовогоПароля) Тогда
		Элементы.ПаролиНеСовпадают.Видимость = НовыйПароль <> ПовторНовогоПароля;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти