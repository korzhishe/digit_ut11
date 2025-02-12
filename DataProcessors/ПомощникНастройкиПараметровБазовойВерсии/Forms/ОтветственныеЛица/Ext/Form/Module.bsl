﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Заполним значения реквизитов
	РеквизитыФормы = ПолучитьРеквизиты();
	Для Каждого РеквизитФормы Из РеквизитыФормы Цикл 
		Если Параметры.Свойство(РеквизитФормы.Имя) Тогда
			ЭтаФорма[РеквизитФормы.Имя] = Параметры[РеквизитФормы.Имя];
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	ПараметрыЗакрытия = Новый Структура("
		|РуководительФИО, 
		|ТекущаяДолжностьРуководителя, 
		|БухгалтерФИО");
	ЗаполнитьЗначенияСвойств(ПараметрыЗакрытия, ЭтаФорма);
	
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры

#КонецОбласти
