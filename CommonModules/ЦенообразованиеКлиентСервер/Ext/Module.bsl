﻿////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции для обработки действий пользователя
// в процессе работы с ценами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииРаботыСНдс

// Рассчитывает сумму НДС от суммы в зависимости от включения НДС в цену
//
// Параметры:
//  ЦенаВключаетНДС - Булево - Признак включения НДС в цену
//  ПроцентНДС      - Число - Ставка НДС числом
//  Сумма           - Число - Сумма, от которой необходимо рассчитать сумму НДС
//
// Возвращаемое значение:
//  Число - Сумма НДС.
//
Функция РассчитатьСуммуНДС(Сумма, ПроцентНДС, ЦенаВключаетНДС = Истина) Экспорт
	
	Если ЦенаВключаетНДС Тогда
		СуммаНДС = Сумма * ПроцентНДС / (ПроцентНДС + 1);
	Иначе
		СуммаНДС = Сумма * ПроцентНДС;
	КонецЕсли;
	
	Возврат СуммаНДС;
	
КонецФункции // РассчитатьСуммуНДС()

// Возвращает числовое значение ставки НДС по значению перечисления
//
// Параметры:
//  СтавкаНДС - ПеречислениеСсылка.СтавкиНДС - значение перечисления СтавкиНДС
//
// Возвращаемое значение:
//  Число - Значение ставки НДС числом
//
Функция ПолучитьСтавкуНДСЧислом(Знач СтавкаНДС, НДСпоСтавкам4и2 = Ложь) Экспорт
	
	Если СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10")
		ИЛИ СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10_110") Тогда
		
		Возврат ?(НДСпоСтавкам4и2, 0.02, 0.1);
		
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18")
		ИЛИ СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18_118") Тогда
		
		Возврат ?(НДСпоСтавкам4и2, 0.04, 0.18);
	ИначеЕсли СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20") Тогда
		
		Возврат ?(НДСпоСтавкам4и2, 0.04, 0.20);
		

		
	Иначе
		
		Возврат 0;
		
	КонецЕсли;
	
КонецФункции // ПолучитьСтавкуНДСЧислом()

#КонецОбласти

#Область ПроцедурыИФункцииРаботыСИтогамиДокументов

// Возвращает сумму документа с учетом НДС
//
// Параметры:
//  Товары          - ТабличнаяЧасть - табличная часть документа для подсчета суммы документа.
//  ЦенаВключаетНДС - Булево - признак включения НДС в цену документа.
//
// Возвращаемое значение:
//  Число - Cумма документа с учетом НДС/
//
Функция ПолучитьСуммуДокумента(Товары, Знач ЦенаВключаетНДС) Экспорт

	СуммаДокумента = Товары.Итог("Сумма");

	Если Не ЦенаВключаетНДС Тогда
		СуммаДокумента = СуммаДокумента + Товары.Итог("СуммаНДС");
	КонецЕсли;

	Возврат СуммаДокумента;

КонецФункции // ПолучитьСуммуДокумента()

#КонецОбласти

#Область ПроцедурыИФункцииДляВыполненияОкругления

// Округляет число по заданному порядку 
//
// Параметры:
//  Число              - Число - исходное число.
//  ТочностьОкругления - Число - Число, определяет точность округления.
//  ВариантОкругления  - Перечисление.ВариантыОкругления - определяет способ округления.
//
// Возвращаемое значение:
//  Число - исходное число, округленное с заданной точностью.
//
Функция ОкруглитьЦену(Число, ТочностьОкругления, ВариантОкругления) Экспорт

	Перем Результат;
		
	// вычислим количество интервалов, входящих в число
	Если ТочностьОкругления <> 0 Тогда
		КоличествоИнтервалов = Число / ТочностьОкругления;
	Иначе
		КоличествоИнтервалов = 0;
	КонецЕсли;
	
	// вычислим целое количество интервалов.
	КоличествоЦелыхИнтервалов = Цел(КоличествоИнтервалов);
		
	Если КоличествоИнтервалов = КоличествоЦелыхИнтервалов Тогда
		// Числа поделились нацело. Округлять не нужно.
		Результат = Число;
	Иначе
		Если ВариантОкругления = ПредопределенноеЗначение("Перечисление.ВариантыОкругления.ВсегдаВПользуПредприятия") Тогда
			// При порядке округления "0.05" 0.371 должно округлится до 0.4
			Результат = ТочностьОкругления * (КоличествоЦелыхИнтервалов + 1);
		ИначеЕсли ВариантОкругления = ПредопределенноеЗначение("Перечисление.ВариантыОкругления.ВсегдаВПользуКлиента") Тогда
			// При порядке округления "0.05" 0.371 должно округлится до 0.35
			Результат = ТочностьОкругления * (КоличествоЦелыхИнтервалов);
		Иначе
			// При порядке округления "0.05" 0.371 должно округлится до 0.35,
			// а 0.376 до 0.4
			Результат = ТочностьОкругления * Окр(КоличествоИнтервалов, 0, РежимОкругления.Окр15как20);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ОкруглитьЦену()

// Применяет "психологическое округление" к числу
//
// Параметры:
//  Число                     - Число - число, к которому применяется округление.
//  ПсихологическоеОкругление - Число - число, значение "психологического округления".
//
// Возвращаемое значение:
//  Число - Результат применения "психологического округления" к числу.
//
Функция ПрименитьПсихологическоеОкругление(Число, ПсихологическоеОкругление) Экспорт
	
	Если Число = 0 ИЛИ ПсихологическоеОкругление = 0 Тогда
		Возврат Число;
	Иначе
		РезультатОкругления = Число - ПсихологическоеОкругление;
		Возврат ?(РезультатОкругления < Число, РезультатОкругления, Число);
	КонецЕсли;
	
КонецФункции // ПрименитьПсихологическоеОкругление()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтруктурыДанных

Функция ПараметрыПолученияЦенНоменклатурыПоставщика() Экспорт
	
	ПараметрыПолученияЦен = Новый Структура();
	ПараметрыПолученияЦен.Вставить("Дата");
	ПараметрыПолученияЦен.Вставить("Валюта");
	ПараметрыПолученияЦен.Вставить("Соглашение");
	ПараметрыПолученияЦен.Вставить("ЭтоВыкупТары");
	Возврат ПараметрыПолученияЦен;
	
КонецФункции

#КонецОбласти

#КонецОбласти
