﻿// Процедура - обработчик события "ОбработкаКоманды".
//
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
	    УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Обработка.ПечатьОбщихФорм",
			"ТОРГ12",
			ПараметрКоманды,
			Неопределено,
			Новый Структура("ВыводитьУслуги, Штрихкод", Истина, Истина));
	
	КонецЕсли;

КонецПроцедуры // ОбработкаКоманды()
