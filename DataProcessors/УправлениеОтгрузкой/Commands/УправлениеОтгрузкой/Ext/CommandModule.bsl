﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.УправлениеОтгрузкой.Команда.УправлениеОтгрузкой");
	
	ОткрытьФорму("Обработка.УправлениеОтгрузкой.Форма.Форма",,,,ПараметрыВыполненияКоманды.Окно);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
