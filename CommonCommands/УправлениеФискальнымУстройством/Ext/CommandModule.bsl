﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.Форма.УправлениеФискальнымУстройством", , ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти