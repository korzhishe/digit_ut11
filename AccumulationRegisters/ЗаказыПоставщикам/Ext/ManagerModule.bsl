﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
		|//////////////////////////////////
		|ВЫБРАТЬ
		|	Отбор.КодСтроки КАК КодСтроки,
		|	Отбор.Ссылка    КАК Ссылка,
		|	МАКСИМУМ(РегистрЗаказы.Номенклатура)   КАК Номенклатура,
		|	МАКСИМУМ(РегистрЗаказы.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(РегистрЗаказы.Склад)          КАК Склад,
		|
		|	СУММА(ВЫБОР КОГДА РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
		|				РегистрЗаказы.КОформлению
		|			ИНАЧЕ
		|				0
		|		КОНЕЦ)           КАК Количество,
		|	СУММА(ВЫБОР КОГДА РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ТОГДА
		|				РегистрЗаказы.КОформлению
		|			ИНАЧЕ
		|				0
		|		КОНЕЦ)           КАК КоличествоПриход,
		|	СУММА(ВЫБОР КОГДА РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|			И РегистрЗаказы.КОформлению < 0 И НЕ Расхождения.Ссылка ЕСТЬ NULL ТОГДА
		|				- РегистрЗаказы.КОформлению
		|			ИНАЧЕ
		|				0
		|		КОНЕЦ)           КАК КоличествоКорректировка
		|ИЗ
		|	ВтОтбор КАК Отбор
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам КАК РегистрЗаказы
		|		ПО РегистрЗаказы.ЗаказПоставщику = Отбор.Ссылка
		|		 И РегистрЗаказы.КодСтроки = Отбор.КодСтроки
		|		 И РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		 И РегистрЗаказы.КОформлению <> 0
		|		 И РегистрЗаказы.Активность
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаПриобретения.Расхождения КАК Расхождения
		|		ПО Расхождения.Ссылка = РегистрЗаказы.Регистратор
		|		 И Расхождения.ЗаказПоставщику = РегистрЗаказы.ЗаказПоставщику
		|		 И Расхождения.КодСтроки = РегистрЗаказы.КодСтроки
		|		 И Расхождения.ВариантОтражения
		|			= ЗНАЧЕНИЕ(Перечисление.ВариантыОтраженияКорректировокПоступлений.УменьшитьЗакупкуУчестьПриИнвентаризации)
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

// Возвращает остаток к оформлению по переданному списку заказов
//
// Параметры:
//  МассивЗаказов		 - Массив - Массив заказов
//  ИсключаемаяНакладная - ДокументСсылка.ПеремещениеТоваров - Накладная, движения которой необходимо исключить из результата
// 
// Возвращаемое значение:
//  ТаблицаЗначений - таблиц с кодами строк.
//
Функция КОформлениюОстаток(МассивЗаказов, ИсключаемаяНакладная = Неопределено) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Заказы", МассивЗаказов);
	Запрос.УстановитьПараметр("ИсключаемаяНакладная", ИсключаемаяНакладная);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Распоряжение          КАК Распоряжение,
	|	Таблица.Номенклатура          КАК Номенклатура,
	|	Таблица.Характеристика        КАК Характеристика,
	|	Таблица.Склад                 КАК Склад,
	|	Таблица.КодСтроки             КАК КодСтроки,
	|	СУММА(Таблица.Количество)     КАК Количество,
	|	Таблица.ЗаказПоставщику       КАК ЗаказПоставщику,
	|	Таблица.Назначение            КАК Назначение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.ЗаказПоставщику КАК Распоряжение,
	|		Таблица.Номенклатура       КАК Номенклатура,
	|		Таблица.Характеристика     КАК Характеристика,
	|		Таблица.КодСтроки          КАК КодСтроки,
	|		Таблица.Склад              КАК Склад,
	|		Таблица.КОформлениюОстаток КАК Количество,
	|		Таблица.ЗаказПоставщику    КАК ЗаказПоставщику,
	|		ТаблицаЗаказа.Назначение   КАК Назначение
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам.Остатки(, ЗаказПоставщику В (&Заказы)) КАК Таблица
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПоставщику.Товары КАК ТаблицаЗаказа
	|			ПО Таблица.ЗаказПоставщику = ТаблицаЗаказа.Ссылка
	|				И Таблица.КодСтроки = ТаблицаЗаказа.КодСтроки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.ЗаказПоставщику,
	|		Таблица.Номенклатура,
	|		Таблица.Характеристика,
	|		Таблица.КодСтроки,
	|		Таблица.Склад,
	|		Таблица.КОформлениюРасход,
	|		Таблица.ЗаказПоставщику,
	|		ТаблицаЗаказа.Назначение
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам.Обороты(, , Регистратор, ЗаказПоставщику В (&Заказы)) КАК Таблица
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПоставщику.Товары КАК ТаблицаЗаказа
	|			ПО Таблица.ЗаказПоставщику = ТаблицаЗаказа.Ссылка
	|				И Таблица.КодСтроки = ТаблицаЗаказа.КодСтроки
	|	ГДЕ
	|		Таблица.Регистратор = &ИсключаемаяНакладная) КАК Таблица
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Распоряжение,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.КодСтроки,
	|	Таблица.Склад,
	|	Таблица.ЗаказПоставщику,
	|	Таблица.Назначение";
	
	КодыСтрокЗаказов = Запрос.Выполнить().Выгрузить();
	
	Возврат КодыСтрокЗаказов;
	
КонецФункции

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
	|	Набор.ЗаказПоставщику    КАК ЗаказПоставщику,
	|	Набор.Номенклатура       КАК Номенклатура,
	|	Набор.Характеристика     КАК Характеристика,
	|	Набор.КодСтроки          КАК КодСтроки,
	|	СУММА(Набор.Заказано)    КАК Заказано,
	|	СУММА(Набор.КОформлению) КАК КОформлению
	|//&ПОМЕСТИТЬ
	|ИЗ(
	|	ВЫБРАТЬ
	|		Таблица.ЗаказПоставщику    КАК ЗаказПоставщику,
	|		Таблица.Номенклатура       КАК Номенклатура,
	|		Таблица.Характеристика     КАК Характеристика,
	|		Таблица.КодСтроки          КАК КодСтроки,
	|		Таблица.ЗаказаноОстаток    КАК Заказано,
	|		Таблица.КОформлениюОстаток КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам.Остатки(, 
	|//&ОтборПоИзмерениямРегистр
	|			) КАК Таблица
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Таблица.ЗаказПоставщику    КАК ЗаказПоставщику,
	|		Таблица.Номенклатура       КАК Номенклатура,
	|		Таблица.Характеристика     КАК Характеристика,
	|		Таблица.КодСтроки          КАК КодСтроки,
	|		Таблица.Заказано           КАК Заказано,
	|		Таблица.КОформлению        КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам КАК Таблица
	|	ГДЕ
	|		Активность
	|		И Регистратор В(&Регистратор)
	|		И ВидДвижения = ЗНАЧЕНИЕ(ВидДВиженияНакопления.Расход)
	|//&ОтборПоИзмерениямСторно
	|	) КАК Набор
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПоставщику,
	|	Номенклатура,
	|	Характеристика,
	|	КодСтроки
	|
	|//&ИМЕЮЩИЕ";
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//&ПОМЕСТИТЬ", "ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
		ТекстЗапроса = ТекстЗапроса + 
		"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ЗаказПоставщику,
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

#КонецОбласти

#Область ОбработчикиОбновления

#КонецОбласти

#КонецЕсли