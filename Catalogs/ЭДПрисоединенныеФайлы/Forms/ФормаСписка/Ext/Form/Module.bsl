﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Элементы.СписокПометитьНУдалениеСнятьПометку.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьЭДДляПросмотра(Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометку(Команда)
	
	МассивСсылок = Элементы.Список.ВыделенныеСтроки;
	ЕстьПометкаУдаления = ВернутьЗначениеПометкиУдаления(МассивСсылок);
	
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат;
	ИначеЕсли МассивСсылок.Количество() = 1 Тогда
		Если ЕстьПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru = 'Снять с ""%1"" пометку на удаление?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Пометить ""%1"" на удаление?'");
		КонецЕсли;
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, МассивСсылок[0]);
	Иначе
		Если ЕстьПометкаУдаления Тогда
			ТекстВопроса = НСтр("ru = 'Снять с выделенных элементов пометку на удаление?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Пометить выделенные элементы на удаление?'");
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыВопроса = Новый Структура("МассивСсылок, РежимУстановкиПометки");
	ПараметрыВопроса.МассивСсылок = МассивСсылок;
	ПараметрыВопроса.РежимУстановкиПометки = Не ЕстьПометкаУдаления;
	
	Режим = РежимДиалогаВопрос.ДаНет;
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект, ПараметрыВопроса);
	ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ВернутьЗначениеПометкиУдаления(МассивСсылок)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЭДПрисоединенныеФайлы.ПометкаУдаления
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|ГДЕ
	|	ЭДПрисоединенныеФайлы.ПометкаУдаления
	|	И ЭДПрисоединенныеФайлы.Ссылка В(&МассивСсылок)";
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, ПараметрыВопроса) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьСнятьПометкуУдаленияНаСервере(ПараметрыВопроса.МассивСсылок, ПараметрыВопроса.РежимУстановкиПометки);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСнятьПометкуУдаленияНаСервере(МассивСсылок, ЗначениеПометкиУдаления)
	
	Для каждого ЭлементМассива Из МассивСсылок Цикл
		Объект = ЭлементМассива.ПолучитьОбъект();
		Объект.ДополнительныеСвойства.Вставить("ПомечатьНаУдалениеПодписанныеОбъекты", Истина);
		Объект.УстановитьПометкуУдаления(ЗначениеПометкиУдаления);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
