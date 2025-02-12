﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ВидНоменклатуры", ВидНоменклатуры, ВидСравненияКомпоновкиДанных.Равно,,Истина);

	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.СерииНоменклатуры);
	Элементы.ФормаИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	ВидНоменклатурыПриИзмененииСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Не Копирование Тогда
		Отказ = Истина;
		
		Если Не ЗначениеЗаполнено(ВидНоменклатуры) Тогда
			ТекстПредупреждения = НСтр("ru = 'Перед добавлением серии необходимо указать вид номенклатуры.'");
			
			ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ВидНоменклатуры",ВидНоменклатуры);
		
		ОткрытьФорму("Справочник.СерииНоменклатуры.ФормаОбъекта", 
			Новый Структура("ЗначенияЗаполнения",ЗначенияЗаполнения), Элементы.Список);
				
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВидНоменклатурыПриИзмененииСервер()
    
    Перем ВладелецСерий, ПараметрыШаблона;
    
    ВладелецСерий = Справочники.ВидыНоменклатуры.ПустаяСсылка();
    
    Если ЗначениеЗаполнено(ВидНоменклатуры) Тогда
        ПараметрыШаблона = Новый ФиксированнаяСтруктура(
        ЗначениеНастроекПовтИсп.НастройкиИспользованияСерий(ВидНоменклатуры));
        
        ВладелецСерий = ПараметрыШаблона.ВладелецСерий;
        
    КонецЕсли;
    
    ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
    																		"ВидНоменклатуры",
																		    ВладелецСерий,
																		    ВидСравненияКомпоновкиДанных.Равно,
																		    ,
																		    Истина);

КонецПроцедуры

#КонецОбласти