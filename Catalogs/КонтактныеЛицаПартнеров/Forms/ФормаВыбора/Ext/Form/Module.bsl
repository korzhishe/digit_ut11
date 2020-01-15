﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УсловиеЗапросаПоВладельцу = "";
	Запрос = Новый Запрос;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Владелец") Тогда
		Если ТипЗнч( Параметры.Отбор.Владелец) = Тип("Массив") Тогда
			Если Параметры.Отбор.Владелец.Количество() > 0 Тогда
				Партнер = Параметры.Отбор.Владелец[0];
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,"Владелец",Параметры.Отбор.Владелец, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
			КонецЕсли;
		Иначе
			Партнер = Параметры.Отбор.Владелец;
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,"ПометкаУдаления",Ложь,ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ГруппаПрекращениеСвязи = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(Список).Элементы,"ПрекращениеСвязи",ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаПрекращениеСвязи,"ДатаПрекращенияСвязи",ВидСравненияКомпоновкиДанных.Равно,Дата(1,1,1),,Истина);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ГруппаПрекращениеСвязи,"ДатаПрекращенияСвязи",ВидСравненияКомпоновкиДанных.Больше,ТекущаяДатаСеанса(),,Истина);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Партнер) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Владелец");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

