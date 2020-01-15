﻿
&НаКлиенте
Процедура Выбрать(Команда)
	СписокРаспоряжений = Новый СписокЗначений;
	Для Каждого Строка из Таблица Цикл
		Если Строка.Обрабатывать Тогда
		
			СписокРаспоряжений.Добавить(Строка.Распоряжение);
		
		КонецЕсли;
	КонецЦикла;
	Закрыть(СписокРаспоряжений);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТаблицаРаспоряжений = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицаРаспоряжений);
	
	Таблица.Загрузить(ТаблицаРаспоряжений);
	
	//Для Каждого Распоряжение из Параметры.СписокРаспоряжений Цикл
	//	НоваяСтрока = Таблица.Добавить();	
	//	НоваяСтрока.Распоряжение = Распоряжение.Значение;
	//КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитВсе(Команда)
	//Для Каждого Строка из Таблица Цикл
	//	Строка.Обрабатывать = Истина;
	//КонецЦикла;
	
	ТекСтрокаПеред = Элементы.Таблица.ТекущаяСтрока;
	Для Ид = 0 по Таблица.Количество() - 1 Цикл
		
		Элементы.Таблица.ТекущаяСтрока = Ид;
		
		Если элементы.Таблица.ТекущаяСтрока <> неопределено  Тогда
			
			ТекущиеДанные  = Элементы.Таблица.ТекущиеДанные;
			
			Если ТекущиеДанные <> Неопределено Тогда
				ТекущиеДанные.Обрабатывать = Истина;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	Элементы.Таблица.ТекущаяСтрока = ТекСтрокаПеред;
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсе(Команда)
	//Для Каждого Строка из Таблица Цикл
	//	Строка.Обрабатывать = Ложь;
	//КонецЦикла;
	
	ТекСтрокаПеред = Элементы.Таблица.ТекущаяСтрока;
	Для Ид = 0 по Таблица.Количество() - 1 Цикл
		
		Элементы.Таблица.ТекущаяСтрока = Ид;
		
		Если элементы.Таблица.ТекущаяСтрока <> неопределено  Тогда
			
			ТекущиеДанные  = Элементы.Таблица.ТекущиеДанные;
			
			Если ТекущиеДанные <> Неопределено Тогда
				ТекущиеДанные.Обрабатывать = Ложь;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	Элементы.Таблица.ТекущаяСтрока = ТекСтрокаПеред;
КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьВсе(Команда)
	//Для Каждого Строка из Таблица Цикл
	//	Строка.Обрабатывать = Не Строка.Обрабатывать;
	//КонецЦикла;
	
	ТекСтрокаПеред = Элементы.Таблица.ТекущаяСтрока;
	Для Ид = 0 по Таблица.Количество() - 1 Цикл
		
		Элементы.Таблица.ТекущаяСтрока = Ид;
		
		Если элементы.Таблица.ТекущаяСтрока <> неопределено  Тогда
			
			ТекущиеДанные  = Элементы.Таблица.ТекущиеДанные;
			
			Если ТекущиеДанные <> Неопределено Тогда
				ТекущиеДанные.Обрабатывать = Не ТекущиеДанные.Обрабатывать;
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
	Элементы.Таблица.ТекущаяСтрока = ТекСтрокаПеред;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Таблица.ТекущаяСтрока = Параметры.НомерТекущейСтроки-1;
КонецПроцедуры
