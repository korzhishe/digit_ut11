﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура рассчитывает и записывает итог запланированного поступления по распоряжению а регистр 
// ГрафикПоступленияТоваров (в регистр записи пишутся только из этого модуля).
// Все плановые поступления\отгрузки записываются в регистр движения товаров. Дата поступления\отгрузки
// указывается в "Периоде". При фактическом поступлении\отгрузке по заказу происходит закрытие графика
// поступления\отгрузки по ФИФО. Рассчитанные записи записываются под распоряжение. Если поступило\отгрузили
// больше, чем в заказе - отрицательные остатки в регистр не пишутся.
// 
// Параметры:
//  МассивРаспоряжений - Массив - массив распоряжений (заказов) по которым нужно рассчитать график поступления.
//
Процедура РассчитатьИтогиРегистраОстаткиТоваровПоГрафику(МассивРаспоряжений) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивРаспоряжений", МассивРаспоряжений);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(Движения.ДатаРаспоряжения)    КАК ДатаРаспоряжения,
		|	Движения.Распоряжение                  КАК Распоряжение,
		|	Движения.Номенклатура                  КАК Номенклатура,
		|	Движения.Характеристика                КАК Характеристика,
		|	Движения.Назначение                    КАК Назначение,
		|	Движения.Склад                         КАК Склад,
		|
		|	СУММА(ВЫБОР КОГДА Движения.Корректировка ТОГДА
		|				-Движения.ПланируемоеПоступление
		|			ИНАЧЕ
		|				Движения.ПланируемоеПоступление
		|		КОНЕЦ)                             КАК ПланируемоеПоступлениеОстаток,
		|
		|	СУММА(ВЫБОР КОГДА Движения.Корректировка ТОГДА
		|				- Движения.ПланируемоеПоступлениеПодЗаказ
		|			ИНАЧЕ
		|				Движения.ПланируемоеПоступлениеПодЗаказ
		|		КОНЕЦ)                             КАК ПланируемоеПоступлениеПодЗаказОстаток,
		|
		|	СУММА(ВЫБОР КОГДА Движения.Корректировка ТОГДА
		|				-Движения.ПланируемоеПоступлениеСНеподтвержденными
		|			ИНАЧЕ
		|				Движения.ПланируемоеПоступлениеСНеподтвержденными
		|		КОНЕЦ)                             КАК ПланируемоеПоступлениеСНеподтвержденнымиОстаток,
		|
		|	СУММА(ВЫБОР КОГДА Движения.Корректировка ТОГДА
		|				- Движения.ПланируемоеПоступлениеПодЗаказСНеподтвержденными
		|			ИНАЧЕ
		|				Движения.ПланируемоеПоступлениеПодЗаказСНеподтвержденными
		|		КОНЕЦ)                             КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток
		|
		|ПОМЕСТИТЬ ОстаткиПоРаспоряжению
		|
		|ИЗ
		|	РегистрНакопления.ДвижениеТоваров КАК Движения
		|ГДЕ
		|	Движения.Распоряжение В(&МассивРаспоряжений)
		|	И Движения.Активность
		|СГРУППИРОВАТЬ ПО
		|	Движения.Распоряжение,
		|	Движения.Номенклатура, Движения.Характеристика, Движения.Склад, Движения.Назначение
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	Номенклатура, Характеристика, Склад, Назначение
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(Таблица.Период, ДЕНЬ)   КАК Период,
		|	Таблица.Номенклатура                  КАК Номенклатура,
		|	Таблица.Характеристика                КАК Характеристика,
		|	Таблица.Назначение                    КАК Назначение,
		|	Таблица.Склад                         КАК Склад,
		|	Таблица.Распоряжение                  КАК Распоряжение,
		|
		|	СУММА(Таблица.ПланируемоеПоступление)                           КАК ПланируемоеПоступление,
		|	СУММА(Таблица.ПланируемоеПоступлениеПодЗаказ)                   КАК ПланируемоеПоступлениеПодЗаказ,
		|	СУММА(Таблица.ПланируемоеПоступлениеСНеподтвержденными)         КАК ПланируемоеПоступлениеСНеподтвержденными,
		|	СУММА(Таблица.ПланируемоеПоступлениеПодЗаказСНеподтвержденными) КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденными
		|
		|ПОМЕСТИТЬ ПланДвижения
		|
		|ИЗ
		|	РегистрНакопления.ДвижениеТоваров КАК Таблица
		|ГДЕ
		|	Таблица.Распоряжение В(&МассивРаспоряжений)
		|	И (Таблица.ПланируемоеПоступление > 0
		|		ИЛИ Таблица.ПланируемоеПоступлениеПодЗаказ > 0
		|		ИЛИ Таблица.ПланируемоеПоступлениеСНеподтвержденными > 0
		|		ИЛИ Таблица.ПланируемоеПоступлениеПодЗаказСНеподтвержденными > 0)
		|	И Таблица.Активность
		|
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(Таблица.Период, ДЕНЬ),
		|	Таблица.Распоряжение,
		|	Таблица.Номенклатура, Таблица.Характеристика, Таблица.Склад, Таблица.Назначение
		|
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	План.Период                                                                         КАК Период,
		|	План.Номенклатура                                                                   КАК Номенклатура,
		|	План.Характеристика                                                                 КАК Характеристика,
		|	План.Склад                                                                          КАК Склад,
		|	План.Назначение                                                                     КАК Назначение,
		|	План.Распоряжение                                                                   КАК Распоряжение,
		|
		|	МАКСИМУМ(План.ПланируемоеПоступление)                                               КАК ПланируемоеПоступление,
		|	МАКСИМУМ(План.ПланируемоеПоступлениеПодЗаказ)                                       КАК ПланируемоеПоступлениеПодЗаказ,
		|	СУММА(ЕСТЬNULL(Остатки.ПланируемоеПоступлениеОстаток, 0))                           КАК ПланируемоеПоступлениеОстаток,
		|	СУММА(ЕСТЬNULL(Остатки.ПланируемоеПоступлениеПодЗаказОстаток, 0))                   КАК ПланируемоеПоступлениеПодЗаказОстаток,
		|
		|	МАКСИМУМ(План.ПланируемоеПоступлениеСНеподтвержденными)                             КАК ПланируемоеПоступлениеСНеподтвержденными,
		|	МАКСИМУМ(План.ПланируемоеПоступлениеПодЗаказСНеподтвержденными)                     КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденными,
		|	СУММА(ЕСТЬNULL(Остатки.ПланируемоеПоступлениеСНеподтвержденнымиОстаток, 0))         КАК ПланируемоеПоступлениеСНеподтвержденнымиОстаток,
		|	СУММА(ЕСТЬNULL(Остатки.ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток, 0)) КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток,
		|
		|	МАКСИМУМ(ЕСТЬNULL(Остатки.ДатаРаспоряжения, ДАТАВРЕМЯ(1, 1, 1))) КАК ДатаРаспоряжения
		|
		|ИЗ
		|	ПланДвижения КАК План
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоРаспоряжению КАК Остатки
		|		ПО План.Номенклатура      = Остатки.Номенклатура
		|			И План.Характеристика = Остатки.Характеристика
		|			И План.Склад          = Остатки.Склад
		|			И План.Распоряжение   = Остатки.Распоряжение
		|			И План.Назначение     = Остатки.Назначение
		|
		|СГРУППИРОВАТЬ ПО
		|	План.Период,
		|	План.Номенклатура, План.Характеристика, План.Склад, План.Назначение,
		|	План.Распоряжение
		|
		|УПОРЯДОЧИТЬ ПО
		|	Распоряжение,
		|	Номенклатура, Характеристика, Склад, Назначение,
		|	Период УБЫВ";

	НаборЗаписей = РегистрыНакопления.ГрафикПоступленияТоваров.СоздатьНаборЗаписей();
	Выборка = Запрос.Выполнить().Выбрать();
	ЕстьЗаписиВВыборке = Выборка.Следующий();
	Пока ЕстьЗаписиВВыборке Цикл

		ТекСклад          = Неопределено;
		ТекНоменклатура   = Неопределено;
		ТекХарактеристика = Неопределено;
		ТекНазначение     = Неопределено;
		ТекРаспоряжение   = Выборка.Распоряжение;

		НаборЗаписей.Отбор.Регистратор.Установить(ТекРаспоряжение);
		// Из таблицы удаляем отработанное распоряжение
		МассивРаспоряжений.Удалить(МассивРаспоряжений.Найти(ТекРаспоряжение));

		// Цикл по строкам одного распоряжения на поступление\отгрузку.
		ДатаРаспоряжения = НачалоДня(ТекущаяДатаСеанса());
		Пока ЕстьЗаписиВВыборке И Выборка.Распоряжение = ТекРаспоряжение Цикл

			Если ЗначениеЗаполнено(Выборка.ДатаРаспоряжения) Тогда
				ДатаРаспоряжения = Выборка.ДатаРаспоряжения;
			КонецЕсли;
			
			Если ТекНоменклатура <> Выборка.Номенклатура Или ТекХарактеристика <> Выборка.Характеристика
				Или ТекСклад <> Выборка.Склад Или ТекНазначение <> Выборка.Назначение Тогда

				ТекНоменклатура   = Выборка.Номенклатура;
				ТекХарактеристика = Выборка.Характеристика;
				ТекСклад          = Выборка.Склад;
				ТекНазначение     = Выборка.Назначение;

				ПоступлениеКоличествоОстаток = 0;
				Если Выборка.ПланируемоеПоступлениеОстаток > 0 Тогда
					ПоступлениеКоличествоОстаток = Выборка.ПланируемоеПоступлениеОстаток;
				КонецЕсли;

				ПоступлениеПодЗаказКоличествоОстаток = 0;
				Если Выборка.ПланируемоеПоступлениеПодЗаказОстаток > 0 Тогда
					ПоступлениеПодЗаказКоличествоОстаток = Выборка.ПланируемоеПоступлениеПодЗаказОстаток;
				КонецЕсли;

				ПоступлениеКоличествоСНеподтвержденнымиОстаток = 0;
				Если Выборка.ПланируемоеПоступлениеСНеподтвержденнымиОстаток > 0 Тогда
					ПоступлениеКоличествоСНеподтвержденнымиОстаток = Выборка.ПланируемоеПоступлениеСНеподтвержденнымиОстаток;
				КонецЕсли;

				ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток = 0;
				Если Выборка.ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток > 0 Тогда
					ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток = Выборка.ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток;
				КонецЕсли;

			КонецЕсли;

			КоличествоПоступление = 0;
			КоличествоПоступлениеПодЗаказ = 0;
			
			КоличествоПоступлениеСНеподтвержденными = 0;
			КоличествоПоступлениеПодЗаказСНеподтвержденными = 0;

			Если Выборка.ПланируемоеПоступление > 0
				Или Выборка.ПланируемоеПоступлениеПодЗаказ > 0
				Или Выборка.ПланируемоеПоступлениеСНеподтвержденными > 0
				Или Выборка.ПланируемоеПоступлениеПодЗаказСНеподтвержденными > 0 Тогда

				КоличествоПоступление         = Мин(Выборка.ПланируемоеПоступление,         ПоступлениеКоличествоОстаток);
				КоличествоПоступлениеПодЗаказ = Мин(Выборка.ПланируемоеПоступлениеПодЗаказ, ПоступлениеПодЗаказКоличествоОстаток);
				
				КоличествоПоступлениеСНеподтвержденными         = Мин(Выборка.ПланируемоеПоступлениеСНеподтвержденными,         ПоступлениеКоличествоСНеподтвержденнымиОстаток);
				КоличествоПоступлениеПодЗаказСНеподтвержденными = Мин(Выборка.ПланируемоеПоступлениеПодЗаказСНеподтвержденными, ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток);
				
				Если КоличествоПоступление > 0
					Или КоличествоПоступлениеПодЗаказ > 0
					Или КоличествоПоступлениеСНеподтвержденными > 0
					Или КоличествоПоступлениеПодЗаказСНеподтвержденными > 0 Тогда
					
					ДобавитьПриходВГрафик(НаборЗаписей,
					                      Выборка,
					                      КоличествоПоступление,
					                      КоличествоПоступлениеПодЗаказ,
					                      КоличествоПоступлениеСНеподтвержденными,
					                      КоличествоПоступлениеПодЗаказСНеподтвержденными);
				КонецЕсли;
				
				ПоступлениеКоличествоОстаток         = ПоступлениеКоличествоОстаток         - КоличествоПоступление;
				ПоступлениеПодЗаказКоличествоОстаток = ПоступлениеПодЗаказКоличествоОстаток - КоличествоПоступлениеПодЗаказ;
				
				ПоступлениеКоличествоСНеподтвержденнымиОстаток         = ПоступлениеКоличествоСНеподтвержденнымиОстаток         - КоличествоПоступлениеСНеподтвержденными;
				ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток = ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток - КоличествоПоступлениеПодЗаказСНеподтвержденными;

			КонецЕсли;

			// Переход к следующей записи в выборке.
			ЕстьЗаписиВВыборке = Выборка.Следующий();

		КонецЦикла;

		// Запись и очистка набора.
		НаборЗаписей.Записать(Истина);
		ЗаписатьОбеспечениеЗаказов(НаборЗаписей, ДатаРаспоряжения);
		НаборЗаписей.Очистить();

	КонецЦикла;

	// По неотработанным распоряжениям нужно очистить движения.
	НаборЗаписей.Очистить();
	ДатаРаспоряжения = Неопределено;
	Если МассивРаспоряжений.Количество() > 0 Тогда
		Для Каждого Распоряжение Из МассивРаспоряжений Цикл
			
			НаборЗаписей.Отбор.Регистратор.Установить(Распоряжение);
			НаборЗаписей.Записать(Истина);
			ЗаписатьОбеспечениеЗаказов(НаборЗаписей, ДатаРаспоряжения);
			
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Функция РассчитатьИтогиРегистраОстаткиТоваровПоГрафикуДляОбновленияИБ(Распоряжение) Экспорт

	НаборЗаписей = РегистрыНакопления.ГрафикПоступленияТоваров.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(Распоряжение);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(Движения.ДатаРаспоряжения)    КАК ДатаРаспоряжения,
		|	Движения.Распоряжение                  КАК Распоряжение,
		|	Движения.Номенклатура                  КАК Номенклатура,
		|	Движения.Характеристика                КАК Характеристика,
		|	Движения.Назначение                    КАК Назначение,
		|	Движения.Склад                         КАК Склад,
		|
		|	СУММА(ВЫБОР КОГДА Движения.Корректировка ТОГДА
		|				-Движения.ПланируемоеПоступление
		|			ИНАЧЕ
		|				Движения.ПланируемоеПоступление
		|		КОНЕЦ)                             КАК ПланируемоеПоступлениеОстаток,
		|
		|	СУММА(ВЫБОР КОГДА Движения.Корректировка ТОГДА
		|				- Движения.ПланируемоеПоступлениеПодЗаказ
		|			ИНАЧЕ
		|				Движения.ПланируемоеПоступлениеПодЗаказ
		|		КОНЕЦ)                             КАК ПланируемоеПоступлениеПодЗаказОстаток,
		|
		|	СУММА(ВЫБОР КОГДА Движения.Корректировка ТОГДА
		|				-Движения.ПланируемоеПоступлениеСНеподтвержденными
		|			ИНАЧЕ
		|				Движения.ПланируемоеПоступлениеСНеподтвержденными
		|		КОНЕЦ)                             КАК ПланируемоеПоступлениеСНеподтвержденнымиОстаток,
		|
		|	СУММА(ВЫБОР КОГДА Движения.Корректировка ТОГДА
		|				- Движения.ПланируемоеПоступлениеПодЗаказСНеподтвержденными
		|			ИНАЧЕ
		|				Движения.ПланируемоеПоступлениеПодЗаказСНеподтвержденными
		|		КОНЕЦ)                             КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток
		|
		|ПОМЕСТИТЬ ОстаткиПоРаспоряжению
		|
		|ИЗ
		|	РегистрНакопления.ДвижениеТоваров КАК Движения
		|ГДЕ
		|	Движения.Распоряжение = &Распоряжение
		|	И Движения.Активность
		|СГРУППИРОВАТЬ ПО
		|	Движения.Распоряжение,
		|	Движения.Номенклатура, Движения.Характеристика, Движения.Склад, Движения.Назначение
		|ИНДЕКСИРОВАТЬ ПО
		|	Распоряжение,
		|	Номенклатура, Характеристика, Склад, Назначение
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(Таблица.Период, ДЕНЬ)   КАК Период,
		|	Таблица.Номенклатура                  КАК Номенклатура,
		|	Таблица.Характеристика                КАК Характеристика,
		|	Таблица.Назначение                    КАК Назначение,
		|	Таблица.Склад                         КАК Склад,
		|	Таблица.Распоряжение                  КАК Распоряжение,
		|
		|	СУММА(Таблица.ПланируемоеПоступление)                           КАК ПланируемоеПоступление,
		|	СУММА(Таблица.ПланируемоеПоступлениеПодЗаказ)                   КАК ПланируемоеПоступлениеПодЗаказ,
		|	СУММА(Таблица.ПланируемоеПоступлениеСНеподтвержденными)         КАК ПланируемоеПоступлениеСНеподтвержденными,
		|	СУММА(Таблица.ПланируемоеПоступлениеПодЗаказСНеподтвержденными) КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденными
		|
		|ПОМЕСТИТЬ ПланДвижения
		|
		|ИЗ
		|	РегистрНакопления.ДвижениеТоваров КАК Таблица
		|ГДЕ
		|	Таблица.Распоряжение = &Распоряжение
		|	И (Таблица.ПланируемоеПоступление > 0
		|		ИЛИ Таблица.ПланируемоеПоступлениеПодЗаказ > 0
		|		ИЛИ Таблица.ПланируемоеПоступлениеСНеподтвержденными > 0
		|		ИЛИ Таблица.ПланируемоеПоступлениеПодЗаказСНеподтвержденными > 0)
		|	И Таблица.Активность
		|
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(Таблица.Период, ДЕНЬ),
		|	Таблица.Распоряжение,
		|	Таблица.Номенклатура, Таблица.Характеристика, Таблица.Склад, Таблица.Назначение
		|
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	План.Период                                                                         КАК Период,
		|	План.Номенклатура                                                                   КАК Номенклатура,
		|	План.Характеристика                                                                 КАК Характеристика,
		|	План.Склад                                                                          КАК Склад,
		|	План.Назначение                                                                     КАК Назначение,
		|	План.Распоряжение                                                                   КАК Распоряжение,
		|
		|	МАКСИМУМ(План.ПланируемоеПоступление)                                               КАК ПланируемоеПоступление,
		|	МАКСИМУМ(План.ПланируемоеПоступлениеПодЗаказ)                                       КАК ПланируемоеПоступлениеПодЗаказ,
		|	СУММА(ЕСТЬNULL(Остатки.ПланируемоеПоступлениеОстаток, 0))                           КАК ПланируемоеПоступлениеОстаток,
		|	СУММА(ЕСТЬNULL(Остатки.ПланируемоеПоступлениеПодЗаказОстаток, 0))                   КАК ПланируемоеПоступлениеПодЗаказОстаток,
		|
		|	МАКСИМУМ(План.ПланируемоеПоступлениеСНеподтвержденными)                             КАК ПланируемоеПоступлениеСНеподтвержденными,
		|	МАКСИМУМ(План.ПланируемоеПоступлениеПодЗаказСНеподтвержденными)                     КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденными,
		|	СУММА(ЕСТЬNULL(Остатки.ПланируемоеПоступлениеСНеподтвержденнымиОстаток, 0))         КАК ПланируемоеПоступлениеСНеподтвержденнымиОстаток,
		|	СУММА(ЕСТЬNULL(Остатки.ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток, 0)) КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток,
		|
		|	МАКСИМУМ(ЕСТЬNULL(Остатки.ДатаРаспоряжения, ДАТАВРЕМЯ(1, 1, 1))) КАК ДатаРаспоряжения
		|
		|ИЗ
		|	ПланДвижения КАК План
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоРаспоряжению КАК Остатки
		|		ПО План.Номенклатура      = Остатки.Номенклатура
		|			И План.Характеристика = Остатки.Характеристика
		|			И План.Склад          = Остатки.Склад
		|			И План.Распоряжение   = Остатки.Распоряжение
		|			И План.Назначение     = Остатки.Назначение
		|
		|СГРУППИРОВАТЬ ПО
		|	План.Период,
		|	План.Номенклатура, План.Характеристика, План.Склад, План.Назначение,
		|	План.Распоряжение
		|
		|УПОРЯДОЧИТЬ ПО
		|	Распоряжение,
		|	Номенклатура, Характеристика, Склад, Назначение,
		|	Период УБЫВ";

	Выборка = Запрос.Выполнить().Выбрать();
	ЕстьЗаписиВВыборке = Выборка.Следующий();

	ТекСклад          = Неопределено;
	ТекНоменклатура   = Неопределено;
	ТекХарактеристика = Неопределено;
	ТекНазначение     = Неопределено;

	// Цикл по строкам одного распоряжения на поступление\отгрузку.
	Пока ЕстьЗаписиВВыборке Цикл
		
		Если ТекНоменклатура <> Выборка.Номенклатура Или ТекХарактеристика <> Выборка.Характеристика
			Или ТекСклад <> Выборка.Склад Или ТекНазначение <> Выборка.Назначение Тогда

			ТекНоменклатура   = Выборка.Номенклатура;
			ТекХарактеристика = Выборка.Характеристика;
			ТекСклад          = Выборка.Склад;
			ТекНазначение     = Выборка.Назначение;

			ПоступлениеКоличествоОстаток = 0;
			Если Выборка.ПланируемоеПоступлениеОстаток > 0 Тогда
				ПоступлениеКоличествоОстаток = Выборка.ПланируемоеПоступлениеОстаток;
			КонецЕсли;

			ПоступлениеПодЗаказКоличествоОстаток = 0;
			Если Выборка.ПланируемоеПоступлениеПодЗаказОстаток > 0 Тогда
				ПоступлениеПодЗаказКоличествоОстаток = Выборка.ПланируемоеПоступлениеПодЗаказОстаток;
			КонецЕсли;
			
			ПоступлениеКоличествоСНеподтвержденнымиОстаток = 0;
			Если Выборка.ПланируемоеПоступлениеСНеподтвержденнымиОстаток > 0 Тогда
				ПоступлениеКоличествоСНеподтвержденнымиОстаток = Выборка.ПланируемоеПоступлениеСНеподтвержденнымиОстаток;
			КонецЕсли;
			
			ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток = 0;
			Если Выборка.ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток > 0 Тогда
				ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток = Выборка.ПланируемоеПоступлениеПодЗаказСНеподтвержденнымиОстаток;
			КонецЕсли;

		КонецЕсли;

		КоличествоПоступление = 0;
		КоличествоПоступлениеПодЗаказ = 0;
		
		КоличествоПоступлениеСНеподтвержденными = 0;
		КоличествоПоступлениеПодЗаказСНеподтвержденными = 0;

		Если Выборка.ПланируемоеПоступление > 0
			Или Выборка.ПланируемоеПоступлениеПодЗаказ > 0
			Или Выборка.ПланируемоеПоступлениеСНеподтвержденными > 0
			Или Выборка.ПланируемоеПоступлениеПодЗаказСНеподтвержденными > 0 Тогда

			КоличествоПоступление         = Мин(Выборка.ПланируемоеПоступление,         ПоступлениеКоличествоОстаток);
			КоличествоПоступлениеПодЗаказ = Мин(Выборка.ПланируемоеПоступлениеПодЗаказ, ПоступлениеПодЗаказКоличествоОстаток);
			
			КоличествоПоступлениеСНеподтвержденными         = Мин(Выборка.ПланируемоеПоступлениеСНеподтвержденными,         ПоступлениеКоличествоСНеподтвержденнымиОстаток);
			КоличествоПоступлениеПодЗаказСНеподтвержденными = Мин(Выборка.ПланируемоеПоступлениеПодЗаказСНеподтвержденными, ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток);
			
			Если КоличествоПоступление > 0
				Или КоличествоПоступлениеПодЗаказ > 0
				Или КоличествоПоступлениеСНеподтвержденными > 0
				Или КоличествоПоступлениеПодЗаказСНеподтвержденными > 0 Тогда
				
				ДобавитьПриходВГрафик(НаборЗаписей,
				                      Выборка,
				                      КоличествоПоступление,
				                      КоличествоПоступлениеПодЗаказ,
				                      КоличествоПоступлениеСНеподтвержденными,
				                      КоличествоПоступлениеПодЗаказСНеподтвержденными);
			КонецЕсли;
			
			ПоступлениеКоличествоОстаток         = ПоступлениеКоличествоОстаток         - КоличествоПоступление;
			ПоступлениеПодЗаказКоличествоОстаток = ПоступлениеПодЗаказКоличествоОстаток - КоличествоПоступлениеПодЗаказ;
			
			ПоступлениеКоличествоСНеподтвержденнымиОстаток         = ПоступлениеКоличествоСНеподтвержденнымиОстаток         - КоличествоПоступлениеСНеподтвержденными;
			ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток = ПоступлениеПодЗаказКоличествоСНеподтвержденнымиОстаток - КоличествоПоступлениеПодЗаказСНеподтвержденными;
			
		КонецЕсли;

		// Переход к следующей записи в выборке.
		ЕстьЗаписиВВыборке = Выборка.Следующий();

	КонецЦикла;

	Возврат НаборЗаписей;
	
КонецФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ДвижениеТоваров";
	
	РегистрыСведений.ДоступныеОстаткиПланируемыхПоступлений.ЗарегистрироватьКОбработкеПриОбновленииИБ(ПолноеИмяРегистра, Параметры);
	
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ДвижениеТоваров";
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ЗаказПоставщику");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(
		Регистраторы, ПолноеИмяРегистра, Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ДобавитьПриходВГрафик(НаборЗаписей, Выборка, Количество, КоличествоПодЗаказ, КоличествоСНеподтвержденными, КоличествоПодЗаказСНеподтвержденными)
	
	Запись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(Запись, Выборка);
	Запись.ДатаСобытия = Запись.Период;
	Запись.ВидДвижения = ВидДвиженияНакопления.Приход;
	
	Запись.КоличествоИзЗаказов = Количество;
	Запись.КоличествоПодЗаказ  = КоличествоПодЗаказ;
	Запись.КоличествоИзЗаказовСНеподтвержденными = КоличествоСНеподтвержденными;
	Запись.КоличествоПодЗаказСНеподтвержденными  = КоличествоПодЗаказСНеподтвержденными;
	
КонецПроцедуры

Процедура ЗаписатьОбеспечениеЗаказов(НаборЗаписей, Период)
	
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
