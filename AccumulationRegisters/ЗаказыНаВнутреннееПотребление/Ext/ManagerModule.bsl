﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Обеспечение

// Получает оформленное накладными по заказам количество.
//
// Параметры:
//  ТаблицаОтбора - ТаблицаЗначений - Таблица с полями "Ссылка" и "КодСтроки", строки должны быть уникальными.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица с полями "Ссылка", "КодСтроки", "Количество". Для каждой пары Заказ-КодСтроки содержит
//                    оформленное накладными количество.
//
Функция ТаблицаОформлено(ТаблицаОтбора) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка    КАК Ссылка,
		|	Таблица.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВтОтбор
		|ИЗ
		|	&ТаблицаОтбора КАК Таблица
		|ГДЕ
		|	Таблица.КодСтроки > 0
		|;
		|
		|////////////////////////////////////////
		|ВЫБРАТЬ
		|	Отбор.КодСтроки КАК КодСтроки,
		|	Отбор.Ссылка    КАК Ссылка,
		|	МАКСИМУМ(РегистрЗаказы.Номенклатура)   КАК Номенклатура,
		|	МАКСИМУМ(РегистрЗаказы.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(РегистрЗаказы.Склад)          КАК Склад,
		|	МАКСИМУМ(РегистрЗаказы.Серия)          КАК Серия,
		|	СУММА(РегистрЗаказы.КОформлению) КАК Количество
		|ИЗ
		|	ВтОтбор КАК Отбор
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыНаВнутреннееПотребление КАК РегистрЗаказы
		|		ПО РегистрЗаказы.ЗаказНаВнутреннееПотребление = Отбор.Ссылка
		|		 И РегистрЗаказы.КодСтроки = Отбор.КодСтроки
		|		 И РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		 И РегистрЗаказы.КОформлению <> 0
		|		 И РегистрЗаказы.Активность
		|СГРУППИРОВАТЬ ПО
		|	Отбор.Ссылка, Отбор.КодСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Ссылка, КодСтроки");
	
	Возврат Таблица;
	
КонецФункции

//Возвращает текст запроса заказов, согласно отборам компоновки.
//Строки заказов с вариантами обеспечения Отгрузить и Отгрузить обособленно не учитываются.
//Текст запроса используется в обработке "Состояние обеспечения" для получения заказов,
//содержащих указанную номенклатуру на указанном складе.
//
//Возвращаемое значение:
// Строка - текст запроса.
//
Функция ТекстЗапросаЗаказовНоменклатуры() Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Т.ЗаказНаВнутреннееПотребление КАК Заказ
		|ИЗ
		|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(,
		|		{Склад.* КАК Склад, Номенклатура.* КАК Номенклатура}) КАК Т
		|ГДЕ
		|	Т.ЗаказаноОстаток > Т.КОформлениюОстаток";

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#Область Состояния

// Возвращает текст запроса для расчета количества товара которое осталось отгрузить
// 
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ВременнаяТаблицаОстаткиЗаказов() Экспорт
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.ЗаказНаВнутреннееПотребление КАК Распоряжение,
		|	Таблица.ЗаказаноОстаток              КАК КоличествоЗаказано
		|ПОМЕСТИТЬ ВтОстаткиЗаказов
		|ИЗ
		|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(, ЗаказНаВнутреннееПотребление В(&МассивЗаказов)) КАК Таблица";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

// Текст запроса получает остаток по ресурсам КОформлению и Заказано
// Остаток дополняется движениями, сделанными накладной заданной в параметре Регистратор
//
// Параметры:
//  ИмяВременнойТаблицы	 - Строка - Поместить результат во временную таблицу с заданным именем. 
//  ОтборПоИзмерениям	 - Структура - Ключ - имя измерения, Значение - имя параметра в запросе, например:
//  									Новый Структура("Номенклатура", "Товар") будет преобразовано в тексте запроса в:
//  									Номенклатура В(&Товар)
//  Выражение			 - Строка - Условие для секции ИМЕЮЩИЕ по ресурсам.
//  								Например, строка вида "КОформлению <> 0" будет преобразована в тексте запроса в:
//  								СУММА(Набор.КОформлению) <> 0
// 
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ТекстЗапросаОстатки(ИмяВременнойТаблицы = "", ОтборПоИзмерениям = Неопределено, Выражение = "") Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Набор.ЗаказНаВнутреннееПотребление КАК ЗаказНаВнутреннееПотребление,
	|	Набор.Номенклатура                 КАК Номенклатура,
	|	Набор.Характеристика               КАК Характеристика,
	|	Набор.КодСтроки                    КАК КодСтроки,
	|	Набор.Серия                        КАК Серия,
	|	Набор.Склад                        КАК Склад,
	|	СУММА(Набор.Заказано)              КАК Заказано,
	|	СУММА(Набор.КОформлению)           КАК КОформлению
	|//&ПОМЕСТИТЬ
	|ИЗ(
	|	ВЫБРАТЬ
	|		Таблица.ЗаказНаВнутреннееПотребление КАК ЗаказНаВнутреннееПотребление,
	|		Таблица.Номенклатура                 КАК Номенклатура,
	|		Таблица.Характеристика               КАК Характеристика,
	|		Таблица.КодСтроки                    КАК КодСтроки,
	|		Таблица.Серия                        КАК Серия,
	|		Таблица.Склад                        КАК Склад,
	|		Таблица.ЗаказаноОстаток              КАК Заказано,
	|		Таблица.КОформлениюОстаток           КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(, 
	|//&ОтборПоИзмерениямРегистр
	|			) КАК Таблица
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Таблица.ЗаказНаВнутреннееПотребление КАК ЗаказНаВнутреннееПотребление,
	|		Таблица.Номенклатура                 КАК Номенклатура,
	|		Таблица.Характеристика               КАК Характеристика,
	|		Таблица.КодСтроки                    КАК КодСтроки,
	|		Таблица.Серия                        КАК Серия,
	|		Таблица.Склад                        КАК Склад,
	|		Таблица.Заказано                     КАК Заказано,
	|		Таблица.КОформлению                  КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаказыНаВнутреннееПотребление КАК Таблица
	|	ГДЕ
	|		Активность
	|		И Регистратор = &Регистратор
	|		И ВидДвижения = ЗНАЧЕНИЕ(ВидДВиженияНакопления.Расход)
	|//&ОтборПоИзмерениямСторно
	|	) КАК Набор
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказНаВнутреннееПотребление,
	|	Номенклатура,
	|	Характеристика,
	|	КодСтроки,
	|	Серия,
	|	Склад
	|
	|//&ИМЕЮЩИЕ";
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ПОМЕСТИТЬ", "ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
		ТекстЗапроса = ТекстЗапроса + 
		"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ЗаказНаВнутреннееПотребление,
		|	КодСтроки";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборПоИзмерениям) Тогда
		
		ТекстОтбораПоИзмерениям = "";
		
		Для Каждого КлючЗначение Из ОтборПоИзмерениям Цикл
			
			ТекстОтбораПоИзмерениям = 
				ТекстОтбораПоИзмерениям
				+ ?(ПустаяСтрока(ТекстОтбораПоИзмерениям), "", " И ")
				+ КлючЗначение.Ключ
				+ " В(&"
				+ КлючЗначение.Значение
				+ ")";
				
		КонецЦикла;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ОтборПоИзмерениямРегистр", ТекстОтбораПоИзмерениям);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ОтборПоИзмерениямСторно", Символы.ПС + "И " + ТекстОтбораПоИзмерениям);
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Выражение) Тогда
		
		Если СтрНайти(Выражение, "КОформлению") <> 0 Тогда
			Выражение = СтрЗаменить(Выражение, "КОформлению", "СУММА(Набор.КОформлению)");
		КонецЕсли;
		Если СтрНайти(Выражение, "Заказано") <> 0 Тогда
			Выражение = СтрЗаменить(Выражение, "Заказано", "СУММА(Набор.Заказано)");
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ИМЕЮЩИЕ", "ИМЕЮЩИЕ " + Выражение);
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли