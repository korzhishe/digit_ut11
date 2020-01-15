﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметры.БанковскийСчет) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "БанковскийСчет", Параметры.БанковскийСчет, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Параметры.БанковскийСчет));
	КонецЕсли;
	Если Параметры.Свойство("МассивДокументов") Тогда
		МинимальнаяДата = МинимальнаяДатаДокумента(Параметры.МассивДокументов);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Дата", МинимальнаяДата, ВидСравненияКомпоновкиДанных.БольшеИлиРавно,, ЗначениеЗаполнено(МинимальнаяДата));
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция МинимальнаяДатаДокумента(МассивДокументов)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	МИНИМУМ(ДанныеДокумента.Дата) КАК Дата
	|ИЗ (
	|	ВЫБРАТЬ
	|		ДанныеДокумента.ДатаВходящегоДокумента КАК Дата
	|	ИЗ
	|		Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Ссылка В (&МассивДокументов)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|  	
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Дата КАК Дата
	|	ИЗ
	|		Документ.СписаниеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Ссылка В (&МассивДокументов)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|  	
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Дата КАК Дата
	|	ИЗ
	|		Документ.ПриходныйКассовыйОрдер КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Ссылка В (&МассивДокументов)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|  	
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Дата КАК Дата
	|	ИЗ
	|		Документ.РасходныйКассовыйОрдер КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Ссылка В (&МассивДокументов)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|  	
	|	ВЫБРАТЬ
	|		ДанныеДокумента.Дата КАК Дата
	|	ИЗ
	|		Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	ГДЕ
	|		ДанныеДокумента.Ссылка В (&МассивДокументов)
	|
	|	) КАК ДанныеДокумента
	|");
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Дата = НачалоДня(Выборка.Дата);
	Иначе
		Дата = Неопределено;
	КонецЕсли;
	
	Возврат Дата;
	
КонецФункции

#КонецОбласти

#КонецОбласти
