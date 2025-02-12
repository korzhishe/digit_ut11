﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновитьТаблицуНастроекФорм();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ВРег(ИмяСобытия) = ВРег("Запись_НастройкиОткрытияФормПриНачалеРаботыСистемы") Тогда
		Если ТипЗнч(Источник) = Тип("Структура") Тогда
			ОбновитьЗаписьТаблицыНастроекФорм(Источник);			
		Иначе
			ОбновитьТаблицуНастроекФорм();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиФорм

&НаКлиенте
Процедура НастройкиФормВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьФормуЗаписиРегистра();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьНастройку(Команда)
	ОткрытьФормуЗаписиРегистра();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиФормНастройкиФормы.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиФорм.НеобходимыНастройки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для формы не задаются настройки>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиФормНастройкиФормы.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиФорм.НеобходимыНастройки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиФорм.НастройкиУстановлены");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<настройки не заданы>'"));

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуЗаписиРегистра()
	ТекущиеДанные = Элементы.НастройкиФорм.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрываемойФормы = Новый Структура;
	
	Если ТекущиеДанные.ОткрыватьПоУмолчанию
		Или ТекущиеДанные.НастройкиУстановлены Тогда
		КлючЗаписиПараметровФорм = КлючЗаписиПараметровФорм(ТекущиеДанные.Пользователь, ТекущиеДанные.ОткрываемаяФорма);
		
		Если Не КлючЗаписиПараметровФорм.Пустой() Тогда
			ПараметрыОткрываемойФормы.Вставить("Ключ", КлючЗаписиПараметровФорм);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОткрываемойФормы.Вставить("Пользователь", ТекущиеДанные.Пользователь);
	ПараметрыОткрываемойФормы.Вставить("ОткрываемаяФорма", ТекущиеДанные.ОткрываемаяФорма);
	
	Если ТекущиеДанные.НеобходимыНастройки Тогда
		ИмяОткрываемойФормы = ТекущиеДанные.ИмяФормыНастроек;
	Иначе
		ИмяОткрываемойФормы = "РегистрСведений.НастройкиОткрытияФормПриНачалеРаботыСистемы.ФормаЗаписи";
	КонецЕсли;
	
	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыОткрываемойФормы, ЭтаФорма);
		
КонецПроцедуры

&НаСервере
Функция КлючЗаписиПараметровФорм(Пользователь, ОткрываемаяФорма)
	
	СтруктураИзмерений = Новый Структура;
	СтруктураИзмерений.Вставить("Пользователь", Пользователь);
	СтруктураИзмерений.Вставить("ОткрываемаяФорма", ОткрываемаяФорма);
	
	Возврат РегистрыСведений.НастройкиОткрытияФормПриНачалеРаботыСистемы.СоздатьКлючЗаписи(СтруктураИзмерений);
	
КонецФункции

&НаСервере
Процедура ОбновитьТаблицуНастроекФорм()
	
	НастройкиФорм.Очистить();
	
	ПараметрыФорм = Новый Соответствие;
	Для Каждого ЗначениеПеречисления Из ОткрытиеФормПриНачалеРаботыСистемы.ИспользуемыеФормыПриНачалеРаботыСистемы() Цикл
		ПараметрыФорм.Вставить(
			ЗначениеПеречисления, 
			ОткрытиеФормПриНачалеРаботыСистемыКлиентСерверПереопределяемый.НастройкиФормы(ЗначениеПеречисления));
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Пользователь,
	|	Пользователи.ИдентификаторПользователяИБ
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	(Пользователи.Ссылка = &ПользовательДляОтбора
	|			ИЛИ &ПользовательДляОтбора = НЕОПРЕДЕЛЕНО)
	|	И НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.Служебный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователи.Наименование";
	
	Если Параметры.Свойство("Отбор") Тогда
		Запрос.УстановитьПараметр("ПользовательДляОтбора", Параметры.Отбор.Пользователь);
	ИначеЕсли НЕ Пользователи.ЭтоПолноправныйПользователь(,, Ложь) Тогда
		Запрос.УстановитьПараметр("ПользовательДляОтбора", Пользователи.ТекущийПользователь());
	Иначе
		Запрос.УстановитьПараметр("ПользовательДляОтбора", Неопределено);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Выборка.ИдентификаторПользователяИБ);
		Если ПользовательИБ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЭтоПолноправныйПользователь = ПользовательИБ.Роли.Содержит(Метаданные.Роли.ПолныеПрава);
		
		Для Каждого ПараметрыФормы Из ПараметрыФорм Цикл
			
			Если ЭтоПолноправныйПользователь
			 ИЛИ ПользовательИБ.Роли.Содержит(Метаданные.Роли[ПараметрыФормы.Значение.Роль]) Тогда
				
			 	НоваяСтрока = НастройкиФорм.Добавить();
				
				НоваяСтрока.Пользователь        = Выборка.Пользователь;
				НоваяСтрока.ОткрываемаяФорма    = ПараметрыФормы.Ключ;
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ПараметрыФормы.Значение, "ПараметрЗапуска, НеобходимыНастройки, ИмяФормыНастроек");
			 
			КонецЕсли;
			
		КонецЦикла;
			
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиФорм.Пользователь,
	|	НастройкиФорм.НеобходимыНастройки,
	|	НастройкиФорм.ОткрываемаяФорма,
	|	НастройкиФорм.ПараметрЗапуска,
	|	НастройкиФорм.ИмяФормыНастроек
	|ПОМЕСТИТЬ НастройкиФорм
	|ИЗ
	|	&НастройкиФорм КАК НастройкиФорм
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиФорм.Пользователь,
	|	НастройкиФорм.ОткрываемаяФорма,
	|	НастройкиФорм.НеобходимыНастройки,
	|	НастройкиФорм.ПараметрЗапуска,
	|	НастройкиФорм.ИмяФормыНастроек,
	|	ЕСТЬNULL(НастройкиОткрытияФормПриНачалеРаботыСистемы.ТекстовоеПредставлениеПараметров, """") КАК НастройкиФормы,
	|	ЕСТЬNULL(НастройкиОткрытияФормПриНачалеРаботыСистемы.ОткрыватьПоУмолчанию, ЛОЖЬ) КАК ОткрыватьПоУмолчанию,
	|	ВЫБОР
	|		КОГДА НастройкиОткрытияФормПриНачалеРаботыСистемы.Пользователь ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК НастройкиУстановлены
	|ИЗ
	|	НастройкиФорм КАК НастройкиФорм
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиОткрытияФормПриНачалеРаботыСистемы КАК НастройкиОткрытияФормПриНачалеРаботыСистемы
	|		ПО НастройкиФорм.Пользователь = НастройкиОткрытияФормПриНачалеРаботыСистемы.Пользователь
	|			И НастройкиФорм.ОткрываемаяФорма = НастройкиОткрытияФормПриНачалеРаботыСистемы.ОткрываемаяФорма";
	
	Запрос.УстановитьПараметр("НастройкиФорм", РеквизитФормыВЗначение("НастройкиФорм"));
	
	НастройкиФорм.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Если Не НастройкиФорм.Количество() Тогда
		Элементы.ФормаИзменитьНастройку.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаписьТаблицыНастроекФорм(КлючЗаписиРегистра)
	
	ПараметрыОтбора = Новый Структура("Пользователь, ОткрываемаяФорма");
	ЗаполнитьЗначенияСвойств(ПараметрыОтбора, КлючЗаписиРегистра);
	
	НайденныеСтроки = НастройкиФорм.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат; // оповещение предназначено не для этой формы
	КонецЕсли;
	
	СтрокаТаблицыНастроекФорм = НайденныеСтроки[0];
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиОткрытияФормПриНачалеРаботыСистемы.ТекстовоеПредставлениеПараметров,
	|	НастройкиОткрытияФормПриНачалеРаботыСистемы.ОткрыватьПоУмолчанию
	|ИЗ
	|	РегистрСведений.НастройкиОткрытияФормПриНачалеРаботыСистемы КАК НастройкиОткрытияФормПриНачалеРаботыСистемы
	|ГДЕ
	|	НастройкиОткрытияФормПриНачалеРаботыСистемы.Пользователь = &Пользователь
	|	И НастройкиОткрытияФормПриНачалеРаботыСистемы.ОткрываемаяФорма = &ОткрываемаяФорма";
	
	Запрос.УстановитьПараметр("Пользователь",     ПараметрыОтбора.Пользователь);
	Запрос.УстановитьПараметр("ОткрываемаяФорма", ПараметрыОтбора.ОткрываемаяФорма);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтрокаТаблицыНастроекФорм.НастройкиФормы       = Выборка.ТекстовоеПредставлениеПараметров;
		СтрокаТаблицыНастроекФорм.ОткрыватьПоУмолчанию = Выборка.ОткрыватьПоУмолчанию;
		СтрокаТаблицыНастроекФорм.НастройкиУстановлены = Истина;
	Иначе
		СтрокаТаблицыНастроекФорм.НастройкиФормы       = "";
		СтрокаТаблицыНастроекФорм.ОткрыватьПоУмолчанию = Ложь;
		СтрокаТаблицыНастроекФорм.НастройкиУстановлены = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
