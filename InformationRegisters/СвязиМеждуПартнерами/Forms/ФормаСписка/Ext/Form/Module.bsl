﻿
#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Если НЕ Копирование Тогда
		//отменить стандартную обработку и параметризовать форму нового
		Отказ = Истина;
		НовыйПратнер = Неопределено;

		ОткрытьФорму("РегистрСведений.СвязиМеждуПартнерами.ФормаЗаписи",
		Новый Структура("Партнер", Партнер),,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
