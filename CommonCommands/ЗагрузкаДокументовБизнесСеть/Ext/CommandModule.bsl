﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("РежимЗагрузкиДокументов", Истина);
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ДокументыОбмена", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
