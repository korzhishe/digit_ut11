﻿////////////////////////////////////////////////////////////////////////////////
// Обработки.УправлениеНовостями.Команды.КомандаФормаНастроекНовостей: Модуль объекта.
//
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура();
	ОткрытьФорму(
		"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
