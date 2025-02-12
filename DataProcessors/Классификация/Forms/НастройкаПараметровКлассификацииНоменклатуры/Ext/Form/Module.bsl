﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
	
		Возврат;
	
	КонецЕсли;
	
	Периоды.Добавить(Перечисления.Периодичность.День);
	Периоды.Добавить(Перечисления.Периодичность.Неделя);
	Периоды.Добавить(Перечисления.Периодичность.Декада);
	Периоды.Добавить(Перечисления.Периодичность.Месяц);
	Периоды.Добавить(Перечисления.Периодичность.Квартал);
	Периоды.Добавить(Перечисления.Периодичность.Полугодие);
	Периоды.Добавить(Перечисления.Периодичность.Год);
	
	ИспользоватьКлассификациюПоВыручке = Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоВыручке.Получить();
	ИспользоватьКлассификациюПоВаловойПрибыли = Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоВаловойПрибыли.Получить();
	ИспользоватьКлассификациюПоКоличествуПродаж = Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоКоличествуПродаж.Получить();
	ПериодABCКлассификации = Константы.ПериодABCКлассификацииНоменклатуры.Получить();
	КоличествоПериодовABCКлассификации = Константы.КоличествоПериодовABCКлассификацииНоменклатуры.Получить();
	ПериодXYZКлассификации = Константы.ПериодXYZКлассификацииНоменклатуры.Получить();
	КоличествоПериодовXYZКлассификации = Константы.КоличествоПериодовXYZКлассификацииНоменклатуры.Получить();
	ПодпериодXYZКлассификации = Константы.ПодпериодXYZКлассификацииНоменклатуры.Получить();
	УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры = Константы.УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры.Получить();
	УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры = Константы.УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры.Получить();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступныеЗначенияПодпериод(Элементы.ПодпериодXYZКлассификации, ПериодXYZКлассификации);
	
	Элементы.ДекорацияABCКлассификацияОписание.Заголовок = НСтр("ru = 'По данным за период:'")
		+ " " + ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации);
	Элементы.ДекорацияXYZКлассификацияОписание.Заголовок = НСтр("ru = 'По данным за период:'")
		+ " " + ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации);
	Элементы.ДекорацияУчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры.Доступность = УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры;
	Элементы.ДекорацияУчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры.Доступность = УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодABCКлассификацииПриИзменении(Элемент)
	
	Элементы.ДекорацияABCКлассификацияОписание.Заголовок = НСтр("ru = 'По данным за период:'")
		+ " " + ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовABCКлассификацииПриИзменении(Элемент)
	
	Элементы.ДекорацияABCКлассификацияОписание.Заголовок = НСтр("ru = 'По данным за период:'")
		+ " " + ОписаниеНастройки(ПериодABCКлассификации, КоличествоПериодовABCКлассификации);
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатурыПриИзменении(Элемент)
	
	Элементы.ДекорацияУчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры.Доступность = УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодXYZКлассификацииПриИзменении(Элемент)
	
	УстановитьДоступныеЗначенияПодпериод(Элементы.ПодпериодXYZКлассификации, ПериодXYZКлассификации);
	
	Элементы.ДекорацияXYZКлассификацияОписание.Заголовок = НСтр("ru = 'По данным за период:'")
		+ " " + ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации);

КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовXYZКлассификацииПриИзменении(Элемент)
	
	Элементы.ДекорацияXYZКлассификацияОписание.Заголовок = НСтр("ru = 'По данным за период:'")
		+ " " + ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодпериодXYZКлассификацииПриИзменении(Элемент)
	
	Элементы.ДекорацияXYZКлассификацияОписание.Заголовок = НСтр("ru = 'По данным за период:'")
		+ " " + ОписаниеНастройки(ПериодXYZКлассификации, КоличествоПериодовXYZКлассификации, ПодпериодXYZКлассификации);
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатурыПриИзменении(Элемент)
	
	Элементы.ДекорацияУчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры.Доступность = УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OK(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		СохранитьПараметры();
		
		КодВозврата = Новый Структура;
		
		КодВозврата.Вставить("ИспользоватьКлассификациюПоВыручке", ИспользоватьКлассификациюПоВыручке);
		КодВозврата.Вставить("ИспользоватьКлассификациюПоВаловойПрибыли", ИспользоватьКлассификациюПоВаловойПрибыли);
		КодВозврата.Вставить("ИспользоватьКлассификациюПоКоличествуПродаж", ИспользоватьКлассификациюПоКоличествуПродаж);
		КодВозврата.Вставить("ПериодABCКлассификации", ПериодABCКлассификации);
		КодВозврата.Вставить("КоличествоПериодовABCКлассификации", КоличествоПериодовABCКлассификации);
		КодВозврата.Вставить("ПериодXYZКлассификации", ПериодXYZКлассификации);
		КодВозврата.Вставить("КоличествоПериодовXYZКлассификации", КоличествоПериодовXYZКлассификации);
		КодВозврата.Вставить("ПодпериодXYZКлассификации", ПодпериодXYZКлассификации);
		КодВозврата.Вставить("УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры", УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры);
		КодВозврата.Вставить("УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры", УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры);
		
		Закрыть(КодВозврата);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура УстановитьДоступныеЗначенияПодпериод(Элемент, ВыбранныйПериод)
	
	Элемент.СписокВыбора.Очистить();
		
	Если ЗначениеЗаполнено(ВыбранныйПериод) Тогда
		
		Для каждого Период Из Периоды Цикл
		
			Элемент.СписокВыбора.Добавить(Период.Значение);
			
			Если ВыбранныйПериод = Период.Значение Тогда
				
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеНастройки(Период, КоличествоПериодов, Подпериод = Неопределено)
	
	ПредставлениеНастройки = "";
	
	Если НЕ ЗначениеЗаполнено(КоличествоПериодов) ИЛИ НЕ ЗначениеЗаполнено(Период) Тогда
		
		Возврат ПредставлениеНастройки;
		
	КонецЕсли;
	
	ПараметрыПредметаИсчисления = "";
	
	Если Период = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru = 'предыдущий день, предыдущих дня, предыдущих дней, м,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru = 'предыдущая неделя, предыдущие недели, предыдущих недель, ж,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru = 'предыдущая декада, предыдущие декады, предыдущих декад, ж,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru = 'предыдущий месяц, предыдущих месяца, предыдущих месяцев, м,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru = 'предыдущий квартал, предыдущих квартала, предыдущих кварталов, м,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru = 'предыдущее полугодие, предыдущих полугодия, предыдущих полугодий, с,,,,, 0'");
		
	ИначеЕсли Период = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		ПараметрыПредметаИсчисления = НСтр("ru = 'предыдущий год, предыдущих года, предыдущих лет, м,,,,, 0'");
		
	Иначе
		
		ПараметрыПредметаИсчисления = "";
		
	КонецЕсли;
	
	ПредставлениеНастройки = НРег(ЧислоПрописью(КоличествоПериодов,, ПараметрыПредметаИсчисления));
	
	Если ЗначениеЗаполнено(Подпериод) Тогда
		
		Если Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + " " + НСтр("ru = '(по дням).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + " " + НСтр("ru = '(по неделям).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + " " + НСтр("ru = '(по декадам).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + " " + НСтр("ru = '(по месяцам).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + " " + НСтр("ru = '(по кварталам).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + " " + НСтр("ru = '(по полугодиям).'");
			
		ИначеЕсли Подпериод = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			
			ПредставлениеНастройки = ПредставлениеНастройки + " " + НСтр("ru = '(по годам).'");
			
		КонецЕсли;
		
	Иначе
		
		ПредставлениеНастройки = ПредставлениеНастройки + ".";
		
	КонецЕсли;
	
	Возврат ПредставлениеНастройки;
	
КонецФункции

&НаСервере
Процедура СохранитьПараметры()
	
	// Запись констант осуществляется в привелигированном режиме.
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоВыручке.Установить(ИспользоватьКлассификациюПоВыручке);
	Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоВаловойПрибыли.Установить(ИспользоватьКлассификациюПоВаловойПрибыли);
	Константы.ИспользоватьABCXYZКлассификациюНоменклатурыПоКоличествуПродаж.Установить(ИспользоватьКлассификациюПоКоличествуПродаж);
	Константы.ПериодABCКлассификацииНоменклатуры.Установить(ПериодABCКлассификации);
	Константы.КоличествоПериодовABCКлассификацииНоменклатуры.Установить(КоличествоПериодовABCКлассификации);
	Константы.ПериодXYZКлассификацииНоменклатуры.Установить(ПериодXYZКлассификации);
	Константы.КоличествоПериодовXYZКлассификацииНоменклатуры.Установить(КоличествоПериодовXYZКлассификации);
	Константы.ПодпериодXYZКлассификацииНоменклатуры.Установить(ПодпериодXYZКлассификации);
	Константы.УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры.Установить(УчитыватьПравилаВнутреннегоТовародвиженияПриABCКлассификацииНоменклатуры);
	Константы.УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры.Установить(УчитыватьПравилаВнутреннегоТовародвиженияПриXYZКлассификацииНоменклатуры);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Выключение привелигированного режима.
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
