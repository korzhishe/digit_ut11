﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаОплатаПлатежнымиКартами = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
	ОплатаПлатежнымиКартами.Загрузить(ТаблицаОплатаПлатежнымиКартами);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НапечататьСлипЧек(Команда)
	
	ТекущиеДанные = Элементы.ОплатаПлатежнымиКартами.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ВозвращаемоеЗначение = Новый Структура;
		ВозвращаемоеЗначение.Вставить("Действие", "НапечататьСлипЧек");
		ВозвращаемоеЗначение.Вставить("ВыбраннаяСтрока", Элементы.ОплатаПлатежнымиКартами.ТекущиеДанные);
		
		Закрыть(ВозвращаемоеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьОплату(Команда)
	
	ТекущиеДанные = Элементы.ОплатаПлатежнымиКартами.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ВозвращаемоеЗначение = Новый Структура;
		ВозвращаемоеЗначение.Вставить("Действие", "ОтменитьОплату");
		ВозвращаемоеЗначение.Вставить("ВыбраннаяСтрока", Элементы.ОплатаПлатежнымиКартами.ТекущиеДанные);
		
		Закрыть(ВозвращаемоеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
