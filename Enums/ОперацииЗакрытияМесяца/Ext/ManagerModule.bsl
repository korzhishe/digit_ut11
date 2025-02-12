﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ДляЗаданийКЗакрытиюМесяца") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	// В форме списка регистра заданий к закрытию месяца для выбора доступны только те значения перечисления,
	// которые поддерживаются в механизме закрытия месяца.
	// см. использование функции ЗакрытиеМесяцаСервер.ПроверитьНаличиеЗаданийКЗакрытиюМесяца()
	ДанныеВыбора = Новый СписокЗначений;
	
	ДанныеВыбора.Добавить(Перечисления.ОперацииЗакрытияМесяца.ПереоценкаДенежныхСредствКредитовДепозитовЗаймов);
	ДанныеВыбора.Добавить(Перечисления.ОперацииЗакрытияМесяца.РаспределениеНДС);
	
КонецПроцедуры

#КонецОбласти
