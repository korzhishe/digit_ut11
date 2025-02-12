﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьПротокол(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПротокол(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ПолучитьПротокол(ТекущиеДанные);
	
	Результат.Протокол.Показать(Результат.Заголовок);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПротоколыБезОшибок(Команда)
	
	УдалитьПротоколыБезОшибокНаСервере();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьПротокол(ТекущиеДанные)
	
	Заголовок = ПротоколРасчетаПартийИСебестоимости.ЗаголовокПротоколаПриВыводе(
		ТекущиеДанные.ПериодРасчета);
	
	Протокол  = РегистрыСведений.ПротоколыРасчетаПартийИСебестоимости.ПолучитьТекстПротокола(
		ТекущиеДанные.Идентификатор,
		ТекущиеДанные.Период); // период записи протокола
	
	Возврат Новый Структура("Протокол, Заголовок", Протокол, Заголовок);
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьПротоколыБезОшибокНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПротоколыРасчетаПартийИСебестоимости.Период 	   КАК Период,
	|	ПротоколыРасчетаПартийИСебестоимости.Идентификатор КАК Идентификатор
	|ИЗ
	|	РегистрСведений.ПротоколыРасчетаПартийИСебестоимости КАК ПротоколыРасчетаПартийИСебестоимости
	|ГДЕ
	|	НЕ ПротоколыРасчетаПартийИСебестоимости.БылиОшибки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
	
	НаборЗаписей = РегистрыСведений.ПротоколыРасчетаПартийИСебестоимости.СоздатьНаборЗаписей();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей.Отбор.Период.Установить(Выборка.Период);
		НаборЗаписей.Отбор.Идентификатор.Установить(Выборка.Идентификатор);
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
