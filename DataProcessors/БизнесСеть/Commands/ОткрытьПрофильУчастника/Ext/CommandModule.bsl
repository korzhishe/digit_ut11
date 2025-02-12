﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Отказ = Ложь;
	ОчиститьСообщения();
	ПараметрыОткрытия = ПолучитьПараметрыОткрытия(ПараметрКоманды, Отказ);
	
	Если Не Отказ Тогда
		БизнесСетьКлиент.ОткрытьПрофильУчастника(ПараметрыОткрытия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПараметрыОткрытия(ПараметрКоманды, Отказ)
	
	Если ЗначениеЗаполнено(ПараметрКоманды) И ПараметрКоманды.ЭтоГруппа Тогда
		Отказ = Истина;
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяСправочникаОрганизации = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Организации");
	ИмяСправочникаКонтрагенты = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Контрагенты");
	
	ПараметрыОткрытия = Новый Структура;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка." + ИмяСправочникаКонтрагенты) Тогда
		ПараметрыОткрытия.Вставить("Контрагент", ПараметрКоманды);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка." + ИмяСправочникаОрганизации) Тогда
		ПараметрыОткрытия.Вставить("Организация", ПараметрКоманды);
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

#КонецОбласти
