﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	УстановитьДоступностьКомандПечати(Элементы);
	УстановитьДоступностьКомандПорядка(Элементы);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = СтруктураЦелейСписок.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.ПрефиксГрупп = "СтруктураЦелейСписок";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СтруктураЦелейСписокКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	СписокТипов = ВариантыАнализаСписок.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.ПрефиксГрупп = "ВариантыАнализаСписок";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ВариантыАнализаСписокКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСтруктураЦелейСписок

&НаКлиенте
Процедура СтруктураЦелейСписокПриАктивизацииСтроки(Элемент)
	
	ОбновитьСодержимоеФормыПриаАктивизацииЦели();
	
	УстановитьДоступностьКомандПечати(Элементы);
	УстановитьДоступностьКомандПорядка(Элементы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВариантыАнализаСписок

&НаКлиенте
Процедура ВариантыАнализаСписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКомандПечати(Элементы);
	УстановитьДоступностьКомандПорядка(Элементы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Найти(Команда.Имя, "ВариантыАнализаСписок") Тогда
		Список = Элементы.ВариантыАнализаСписок;
	Иначе
		Список = Элементы.СтруктураЦелейСписок;
	КонецЕсли;
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	Если Найти(Контекст.ИмяКомандыВФорме, "ВариантыАнализаСписок") Тогда
		Список = Элементы.ВариантыАнализаСписок;
	Иначе
		Список = Элементы.СтруктураЦелейСписок;
	КонецЕсли;
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СтруктураЦелейСписок);
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ВариантыАнализаСписок);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыАнализаСписок.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьВариантыАнализа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.FormBackColor);
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

КонецПроцедуры

&НаКлиенте 
Функция НайтиПолеОтбора(Элементы, ИмяОтбора)
	
	ИскомоеПоле = Неопределено;
	
	ПолеОтбора = Новый ПолеКомпоновкиДанных(ИмяОтбора);
	
	Для каждого ОтборПоле из Элементы Цикл
		
		Если ТипЗнч(ОтборПоле) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") тогда
			ИскомоеПоле = НайтиПолеОтбора(ОтборПоле.Элементы, ИмяОтбора);
		Иначе
			Если ОтборПоле.Использование и ОтборПоле.ЛевоеЗначение = ПолеОтбора тогда
				
				ИскомоеПоле = ОтборПоле;
				
				Прервать;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИскомоеПоле;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСодержимоеФормыПриаАктивизацииЦели()
	
	Если ТипЗнч(Элементы.СтруктураЦелейСписок.ТекущаяСтрока) = Тип("СправочникСсылка.СтруктураЦелей") Тогда
		ТекущаяЦель = Элементы.СтруктураЦелейСписок.ТекущаяСтрока;
		ИспользоватьВариантыАнализа = ЦельИзмеримая(ТекущаяЦель);
		
	Иначе
		ТекущаяЦель = Неопределено;
		ИспользоватьВариантыАнализа = Ложь;
		
	КонецЕсли;
	
	ИскомоеПолеОтбора = НайтиПолеОтбора(ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(ВариантыАнализаСписок).Элементы, "Владелец");
	
	Если ИскомоеПолеОтбора = Неопределено Тогда
		ОтборПоЦели = ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(ВариантыАнализаСписок).Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборПоЦели.Использование = Истина;
		ОтборПоЦели.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
		ОтборПоЦели.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборПоЦели.ПравоеЗначение = ТекущаяЦель;
		ОтборПоЦели.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	Иначе
		ИскомоеПолеОтбора.Использование = Истина;
		ИскомоеПолеОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
		ИскомоеПолеОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ИскомоеПолеОтбора.ПравоеЗначение = ТекущаяЦель;
		ИскомоеПолеОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	КонецЕсли;
	
	Элементы.ВариантыАнализаСписок.ТолькоПросмотр = Не ИспользоватьВариантыАнализа;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура УстановитьДоступностьКомандПечати(Элементы)
	
	Если Элементы.ВариантыАнализаСписок.ТекущаяСтрока = Неопределено Тогда
		Элементы.ВариантыАнализаСписокОтчетМониторЦелевыхПоказателейПечатнаяФорма.Доступность = Ложь;
		Элементы.ВариантыАнализаСписокОтчетМониторЦелевыхПоказателейПечатнаяФормаКонтекст.Доступность = Ложь;
	Иначе
		Элементы.ВариантыАнализаСписокОтчетМониторЦелевыхПоказателейПечатнаяФорма.Доступность = Истина;
		Элементы.ВариантыАнализаСписокОтчетМониторЦелевыхПоказателейПечатнаяФормаКонтекст.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура УстановитьДоступностьКомандПорядка(Элементы)
	
	Если Элементы.ВариантыАнализаСписок.ТекущаяСтрока = Неопределено Тогда
		Элементы.ВариантыАнализаСписокГруппаИзменениеПорядка.Доступность = Ложь;
	Иначе
		Элементы.ВариантыАнализаСписокГруппаИзменениеПорядка.Доступность = Истина;
	КонецЕсли;
	
	Если Элементы.СтруктураЦелейСписок.ТекущаяСтрока = Неопределено Тогда
		Элементы.СтруктураЦелейСписокГруппаИзменениеПорядкаЦелей.Доступность = Ложь;
	Иначе
		Элементы.СтруктураЦелейСписокГруппаИзменениеПорядкаЦелей.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Функция ЦельИзмеримая(Цель)
	
	ЦельИзмеримая = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Цель", Цель);
	Запрос.Текст = "ВЫБРАТЬ
	|	СтруктураЦелей.ЦельИзмеримая
	|ИЗ
	|	Справочник.СтруктураЦелей КАК СтруктураЦелей
	|ГДЕ
	|	СтруктураЦелей.Ссылка = &Цель";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		ЦельИзмеримая = Выборка.ЦельИзмеримая;
		
	КонецЕсли;
	
	Возврат ЦельИзмеримая;
	
КонецФункции

#КонецОбласти
