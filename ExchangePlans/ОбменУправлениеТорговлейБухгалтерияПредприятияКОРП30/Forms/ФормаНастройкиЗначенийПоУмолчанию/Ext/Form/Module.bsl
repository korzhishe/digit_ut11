﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = "ОбменУправлениеТорговлейБухгалтерияПредприятияКОРП30";
	
	ОбменДаннымиСервер.ФормаНастройкиЗначенийПоУмолчаниюПриСозданииНаСервере(ЭтаФорма, ИмяПланаОбмена);
	
	УстановитьВидимостьНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ОбменДаннымиКлиент.ФормаНастройкиЗначенийПоУмолчаниюКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов") Тогда
		
		Элементы.ГруппаСтраницыСоздаватьПартнеровДляНовыхКонтрагентов.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаСоздаватьПартнеровДляНовыхКонтрагентов;
	Иначе
		
		Элементы.ГруппаСтраницыСоздаватьПартнеровДляНовыхКонтрагентов.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаСоздаватьПартнеровДляНовыхКонтрагентовПустая;
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

