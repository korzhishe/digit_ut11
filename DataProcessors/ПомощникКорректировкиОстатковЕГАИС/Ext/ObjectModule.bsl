﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Создает новый документ ОстаткиЕГАИС.
//
Процедура СоздатьДокументЗапросаОстатков(ВидДокумента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗапросОстатков = Документы.ОстаткиЕГАИС.СоздатьДокумент();
	ЗапросОстатков.Дата = ТекущаяДатаСеанса();
	ЗапросОстатков.ОрганизацияЕГАИС = ОрганизацияЕГАИС;
	ЗапросОстатков.Заполнить(ОрганизацияЕГАИС);
	
	ЗапросОстатков.ВидДокумента = ВидДокумента;
	
	ЗапросОстатков.Записать(РежимЗаписиДокумента.Проведение);
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре1 Тогда
		ОстаткиВРегистре1 = ЗапросОстатков.Ссылка;
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре2 Тогда
		ОстаткиВРегистре2 = ЗапросОстатков.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет таблицы по данным учетных остатков и остатков ЕГАИС.
//
Процедура ЗаполнитьТаблицыОстатков() Экспорт
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОрганизацияЕГАИС, "Контрагент, ТорговыйОбъект");
	
	УчетныеОстатки.Загрузить(КорректировкаОстатковЕГАИСПереопределяемый.УчетныеОстатки(
		ДатаУчетныхОстатков,
		ЗначенияРеквизитов.Контрагент,
		ЗначенияРеквизитов.ТорговыйОбъект,
		КорректироватьОстаткиНемаркируемойПродукции));
	
	ОстаткиЕГАИС.Загрузить(ОстаткиЕГАИС());
	
КонецПроцедуры

// Рассчитывает корректировочное количество, необходимое для создания документов.
//
Процедура РассчитатьКоличествоКорректировки() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаОстатков", ТаблицаОстатков.Выгрузить());
	Запрос.УстановитьПараметр("ЭтоТорговыйЗал", ЭтоТорговыйЗал);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаОстатков.Номенклатура КАК Номенклатура,
	|	ТаблицаОстатков.Характеристика КАК Характеристика,
	|	ВЫРАЗИТЬ(ТаблицаОстатков.АлкогольнаяПродукция КАК Справочник.КлассификаторАлкогольнойПродукцииЕГАИС) КАК АлкогольнаяПродукция,
	|	ТаблицаОстатков.ОстатокСклад КАК ОстатокСклад,
	|	ТаблицаОстатков.ОстатокТорговыйЗал КАК ОстатокТорговыйЗал,
	|	ТаблицаОстатков.ОстатокРегистр1 КАК ОстатокРегистр1,
	|	ТаблицаОстатков.ОстатокРегистр2 КАК ОстатокРегистр2
	|ПОМЕСТИТЬ ИсходныеДанные
	|ИЗ
	|	&ТаблицаОстатков КАК ТаблицаОстатков
	|ГДЕ
	|	ТаблицаОстатков.АлкогольнаяПродукция <> ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура КАК Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.Характеристика КАК Характеристика,
	|	ИсходныеДанные.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ИсходныеДанные.ОстатокСклад КАК ОстатокСклад,
	|	ИсходныеДанные.ОстатокТорговыйЗал КАК ОстатокТорговыйЗал,
	|	ИсходныеДанные.ОстатокРегистр1 КАК ОстатокРегистр1,
	|	ИсходныеДанные.ОстатокРегистр2 КАК ОстатокРегистр2
	|ПОМЕСТИТЬ ТаблицаОстатков
	|ИЗ
	|	ИсходныеДанные КАК ИсходныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО ИсходныеДанные.АлкогольнаяПродукция = СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция
	|			И (СоответствиеНоменклатурыЕГАИС.Порядок = 1)
	|ГДЕ
	|	НЕ СоответствиеНоменклатурыЕГАИС.Номенклатура ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОстатков.Номенклатура КАК Номенклатура,
	|	ТаблицаОстатков.Характеристика КАК Характеристика,
	|	ТаблицаОстатков.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаОстатков.ОстатокСклад КАК ОстатокСклад,
	|	ТаблицаОстатков.ОстатокТорговыйЗал КАК ОстатокТорговыйЗал,
	|	ТаблицаОстатков.ОстатокРегистр1 КАК ОстатокРегистр1,
	|	ТаблицаОстатков.ОстатокРегистр2 КАК ОстатокРегистр2,
	|	ВЫБОР
	|		КОГДА &ЭтоТорговыйЗал
	|			ТОГДА ТаблицаОстатков.ОстатокРегистр1 - ТаблицаОстатков.ОстатокСклад
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ТаблицаОстатков.ОстатокРегистр1 - ТаблицаОстатков.ОстатокСклад < ТаблицаОстатков.ОстатокТорговыйЗал - ТаблицаОстатков.ОстатокРегистр2
	|					ТОГДА ТаблицаОстатков.ОстатокРегистр1 - ТаблицаОстатков.ОстатокСклад
	|				ИНАЧЕ ТаблицаОстатков.ОстатокТорговыйЗал - ТаблицаОстатков.ОстатокРегистр2
	|			КОНЕЦ
	|	КОНЕЦ КАК ПередатьВРегистр2,
	|	ВЫБОР
	|		КОГДА ТаблицаОстатков.ОстатокРегистр2 - ТаблицаОстатков.ОстатокТорговыйЗал < ТаблицаОстатков.ОстатокСклад - ТаблицаОстатков.ОстатокРегистр1
	|			ТОГДА ТаблицаОстатков.ОстатокРегистр2 - ТаблицаОстатков.ОстатокТорговыйЗал
	|		ИНАЧЕ ТаблицаОстатков.ОстатокСклад - ТаблицаОстатков.ОстатокРегистр1
	|	КОНЕЦ КАК ВернутьИзРегистра2
	|ПОМЕСТИТЬ ПередачаВРегистр2
	|ИЗ
	|	ТаблицаОстатков КАК ТаблицаОстатков
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПередачаВРегистр2.Номенклатура КАК Номенклатура,
	|	ПередачаВРегистр2.Характеристика КАК Характеристика,
	|	ПередачаВРегистр2.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ПередачаВРегистр2.ОстатокСклад КАК ОстатокСклад,
	|	ПередачаВРегистр2.ОстатокТорговыйЗал КАК ОстатокТорговыйЗал,
	|	ПередачаВРегистр2.ОстатокРегистр1 КАК ОстатокРегистр1,
	|	ПередачаВРегистр2.ОстатокРегистр2 КАК ОстатокРегистр2,
	|	ПередачаВРегистр2.ПередатьВРегистр2 КАК ПередатьВРегистр2,
	|	ПередачаВРегистр2.ВернутьИзРегистра2 КАК ВернутьИзРегистра2,
	|	ПередачаВРегистр2.ОстатокТорговыйЗал - ПередачаВРегистр2.ОстатокРегистр2 - ВЫБОР
	|		КОГДА ПередачаВРегистр2.ПередатьВРегистр2 > 0
	|			ТОГДА ПередачаВРегистр2.ПередатьВРегистр2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПоставитьНаБалансВРегистр2,
	|	ВЫБОР
	|		КОГДА ПередачаВРегистр2.ПередатьВРегистр2 > 0
	|			ТОГДА ПередачаВРегистр2.ПередатьВРегистр2
	|		ИНАЧЕ 0
	|	КОНЕЦ + ПередачаВРегистр2.ОстатокРегистр2 - ПередачаВРегистр2.ОстатокТорговыйЗал - ВЫБОР
	|		КОГДА ПередачаВРегистр2.ВернутьИзРегистра2 > 0
	|			ТОГДА ПередачаВРегистр2.ВернутьИзРегистра2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СписатьИзРегистра2,
	|	ПередачаВРегистр2.ОстатокСклад - ПередачаВРегистр2.ОстатокРегистр1 - ВЫБОР
	|		КОГДА ПередачаВРегистр2.ВернутьИзРегистра2 > 0
	|			ТОГДА ПередачаВРегистр2.ВернутьИзРегистра2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПоставитьНаБалансВРегистр1,
	|	ПередачаВРегистр2.ОстатокРегистр1 - ПередачаВРегистр2.ОстатокСклад - ВЫБОР
	|		КОГДА ПередачаВРегистр2.ПередатьВРегистр2 > 0
	|			ТОГДА ПередачаВРегистр2.ПередатьВРегистр2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СписатьИзРегистра1
	|ПОМЕСТИТЬ ТаблицаКорректировки
	|ИЗ
	|	ПередачаВРегистр2 КАК ПередачаВРегистр2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКорректировки.Номенклатура КАК Номенклатура,
	|	ТаблицаКорректировки.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.АлкогольнаяПродукция.ТипПродукции = ЗНАЧЕНИЕ(Перечисление.ТипыПродукцииЕГАИС.Неупакованная)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПродаетсяВРозлив,
	|	ТаблицаКорректировки.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаКорректировки.ОстатокСклад КАК ОстатокСклад,
	|	ТаблицаКорректировки.ОстатокТорговыйЗал КАК ОстатокТорговыйЗал,
	|	ТаблицаКорректировки.ОстатокРегистр1 КАК ОстатокРегистр1,
	|	ТаблицаКорректировки.ОстатокРегистр2 КАК ОстатокРегистр2,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПередатьВРегистр2 > 0
	|			ТОГДА ТаблицаКорректировки.ПередатьВРегистр2
	|		КОГДА ТаблицаКорректировки.ВернутьИзРегистра2 > 0
	|			ТОГДА -ТаблицаКорректировки.ВернутьИзРегистра2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПередатьВРегистр2,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр2 > 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр2
	|		КОГДА ТаблицаКорректировки.СписатьИзРегистра2 > 0
	|			ТОГДА -ТаблицаКорректировки.СписатьИзРегистра2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПоставитьНаБалансВРегистр2,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр1 > 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр1
	|		КОГДА ТаблицаКорректировки.СписатьИзРегистра1 > 0
	|			ТОГДА -ТаблицаКорректировки.СписатьИзРегистра1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПоставитьНаБалансВРегистр1,
	|	0 КАК ОбъемДАЛ
	|ИЗ
	|	ТаблицаКорректировки КАК ТаблицаКорректировки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	ТаблицаКорректировки.Загрузить(Запрос.Выполнить().Выгрузить());
	
	КорректировкаОстатковЕГАИСПереопределяемый.ЗаполнитьКоэффициентПересчетаВДАЛ(ТаблицаКорректировки);
	
КонецПроцедуры

// Создает документы корректировки остатков на основании расчетной таблицы.
//
Процедура СоздатьДокументыКорректировкиОстатков() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаКорректировки", ТаблицаКорректировки.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаКорректировки.Номенклатура КАК Номенклатура,
	|	ТаблицаКорректировки.Характеристика КАК Характеристика,
	|	ТаблицаКорректировки.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаКорректировки.ПередатьВРегистр2 КАК ПередатьВРегистр2,
	|	ТаблицаКорректировки.ПоставитьНаБалансВРегистр2 КАК ПоставитьНаБалансВРегистр2,
	|	ТаблицаКорректировки.ПоставитьНаБалансВРегистр1 КАК ПоставитьНаБалансВРегистр1,
	|	ТаблицаКорректировки.ПродаетсяВРозлив КАК ПродаетсяВРозлив,
	|	ТаблицаКорректировки.ОбъемДАЛ КАК ОбъемДАЛ
	|ПОМЕСТИТЬ ТаблицаКорректировки
	|ИЗ
	|	&ТаблицаКорректировки КАК ТаблицаКорректировки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКорректировки.Номенклатура КАК Номенклатура,
	|	ТаблицаКорректировки.Характеристика,
	|	ТаблицаКорректировки.АлкогольнаяПродукция,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПередатьВРегистр2 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПередатьВРегистр2
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПередатьВРегистр2 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПередатьВРегистр2
	|	КОНЕЦ КАК КоличествоУпаковок,
	|	ТаблицаКорректировки.ПродаетсяВРозлив КАК ПродаетсяВРозлив,
	|	ТаблицаКорректировки.ОбъемДАЛ КАК ОбъемДАЛ
	|ИЗ
	|	ТаблицаКорректировки КАК ТаблицаКорректировки
	|ГДЕ
	|	ТаблицаКорректировки.ПередатьВРегистр2 > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКорректировки.Номенклатура КАК Номенклатура,
	|	ТаблицаКорректировки.Характеристика,
	|	ТаблицаКорректировки.АлкогольнаяПродукция,
	|	-ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПередатьВРегистр2 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПередатьВРегистр2
	|	КОНЕЦ КАК Количество,
	|	-ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПередатьВРегистр2 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПередатьВРегистр2
	|	КОНЕЦ КАК КоличествоУпаковок
	|ИЗ
	|	ТаблицаКорректировки КАК ТаблицаКорректировки
	|ГДЕ
	|	ТаблицаКорректировки.ПередатьВРегистр2 < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКорректировки.Номенклатура КАК Номенклатура,
	|	ТаблицаКорректировки.Характеристика,
	|	ТаблицаКорректировки.АлкогольнаяПродукция,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр2 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПоставитьНаБалансВРегистр2
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр2 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПоставитьНаБалансВРегистр2
	|	КОНЕЦ КАК КоличествоУпаковок
	|ИЗ
	|	ТаблицаКорректировки КАК ТаблицаКорректировки
	|ГДЕ
	|	ТаблицаКорректировки.ПоставитьНаБалансВРегистр2 > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКорректировки.Номенклатура КАК Номенклатура,
	|	ТаблицаКорректировки.Характеристика,
	|	ТаблицаКорректировки.АлкогольнаяПродукция,
	|	-ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр2 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПоставитьНаБалансВРегистр2
	|	КОНЕЦ КАК Количество,
	|	-ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр2 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПоставитьНаБалансВРегистр2
	|	КОНЕЦ КАК КоличествоУпаковок
	|ИЗ
	|	ТаблицаКорректировки КАК ТаблицаКорректировки
	|ГДЕ
	|	ТаблицаКорректировки.ПоставитьНаБалансВРегистр2 < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКорректировки.Номенклатура КАК Номенклатура,
	|	ТаблицаКорректировки.Характеристика,
	|	ТаблицаКорректировки.АлкогольнаяПродукция,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр1 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПоставитьНаБалансВРегистр1
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр1 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПоставитьНаБалансВРегистр1
	|	КОНЕЦ КАК КоличествоУпаковок
	|ИЗ
	|	ТаблицаКорректировки КАК ТаблицаКорректировки
	|ГДЕ
	|	ТаблицаКорректировки.ПоставитьНаБалансВРегистр1 > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКорректировки.Номенклатура КАК Номенклатура,
	|	ТаблицаКорректировки.Характеристика,
	|	ТаблицаКорректировки.АлкогольнаяПродукция,
	|	-ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр1 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПоставитьНаБалансВРегистр1
	|	КОНЕЦ КАК Количество,
	|	-ВЫБОР
	|		КОГДА ТаблицаКорректировки.ПродаетсяВРозлив
	|				И ТаблицаКорректировки.ОбъемДАЛ <> 0
	|			ТОГДА ТаблицаКорректировки.ПоставитьНаБалансВРегистр1 / ТаблицаКорректировки.ОбъемДАЛ
	|		ИНАЧЕ ТаблицаКорректировки.ПоставитьНаБалансВРегистр1
	|	КОНЕЦ КАК КоличествоУпаковок,
	|	ТаблицаКорректировки.ПродаетсяВРозлив КАК ПродаетсяВРозлив,
	|	ТаблицаКорректировки.ОбъемДАЛ КАК ОбъемДАЛ
	|ИЗ
	|	ТаблицаКорректировки КАК ТаблицаКорректировки
	|ГДЕ
	|	ТаблицаКорректировки.ПоставитьНаБалансВРегистр1 < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ОстаткиВРегистре1);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Количество КАК Количество,
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Справка2 КАК Справка2,
	|	ЕСТЬNULL(ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Справка2.ДокументОснование.ДатаТТН, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаТТН
	|ИЗ
	|	Документ.ОстаткиЕГАИС.ОстаткиПоДаннымЕГАИС КАК ОстаткиЕГАИСОстаткиПоДаннымЕГАИС
	|ГДЕ
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	АлкогольнаяПродукция,
	|	ДатаТТН";
	
	ОстаткиСправок2 = Запрос.Выполнить().Выгрузить();
	
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		СоздатьПередачуВРегистр2(МассивРезультатов[1], ОстаткиСправок2);
	КонецЕсли;
	
	Если НЕ МассивРезультатов[2].Пустой() Тогда
		СоздатьВозвратИзРегистра2(МассивРезультатов[2]);
	КонецЕсли;
	
	Если НЕ МассивРезультатов[3].Пустой() Тогда
		СоздатьАктПостановкиНаБалансВРегистр2(МассивРезультатов[3]);
	КонецЕсли;
	
	Если НЕ МассивРезультатов[4].Пустой() Тогда
		СоздатьАктСписанияИзРегистра2(МассивРезультатов[4]);
	КонецЕсли;
	
	Если НЕ МассивРезультатов[5].Пустой() Тогда
		СоздатьАктПостановкиНаБалансВРегистр1(МассивРезультатов[5]);
	КонецЕсли;
	
	Если НЕ МассивРезультатов[6].Пустой() Тогда
		СоздатьАктСписанияИзРегистра1(МассивРезультатов[6], ОстаткиСправок2);
	КонецЕсли;
	
КонецПроцедуры

// Создает документ передачи в регистр №2 ЕГАИС.
//
Процедура СоздатьПередачуВРегистр2(РезультатЗапроса, ОстаткиСправок2)
	
	Док = Документы.ПередачаВРегистр2ЕГАИС.СоздатьДокумент();
	Док.Дата = ТекущаяДатаСеанса();
	Док.ОрганизацияЕГАИС = ОрганизацияЕГАИС;
	Док.Заполнить(ОрганизацияЕГАИС);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПередатьВРегистр2 = ?(Выборка.ПродаетсяВРозлив, Выборка.Количество * Выборка.ОбъемДАЛ, Выборка.Количество);
		
		МассивСправок = ОстаткиСправок2.НайтиСтроки(Новый Структура("АлкогольнаяПродукция", Выборка.АлкогольнаяПродукция));
		Для Каждого СтрокаСправки Из МассивСправок Цикл
			ТекКоличество = Мин(СтрокаСправки.Количество, ПередатьВРегистр2);
			Если ТекКоличество > 0 Тогда
				СтрокаТЧ = Док.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТЧ, Выборка);
				СтрокаТЧ.Количество = ?(Выборка.ПродаетсяВРозлив, ТекКоличество / Выборка.ОбъемДАЛ, ТекКоличество);
				СтрокаТЧ.КоличествоУпаковок = СтрокаТЧ.Количество;
				СтрокаТЧ.Справка2 = СтрокаСправки.Справка2;
				
				ПередатьВРегистр2 = ПередатьВРегистр2 - ТекКоличество;
				СтрокаСправки.Количество = СтрокаСправки.Количество - ТекКоличество;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	ЗаписатьДокументКорректировкиОстатков(Док);
	
КонецПроцедуры

// Создает документ возврата из регистра №2 ЕГАИС.
//
Процедура СоздатьВозвратИзРегистра2(РезультатЗапроса)
	
	Док = Документы.ВозвратИзРегистра2ЕГАИС.СоздатьДокумент();
	Док.Дата = ТекущаяДатаСеанса();
	Док.ОрганизацияЕГАИС = ОрганизацияЕГАИС;
	Док.Заполнить(ОрганизацияЕГАИС);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТЧ = Док.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, Выборка);
	КонецЦикла;
	
	ЗаписатьДокументКорректировкиОстатков(Док);
	
КонецПроцедуры

// Создает акт постановки на баланс в регистр №2 ЕГАИС.
//
Процедура СоздатьАктПостановкиНаБалансВРегистр2(РезультатЗапроса)
	
	Док = Документы.АктПостановкиНаБалансЕГАИС.СоздатьДокумент();
	Док.Дата = ТекущаяДатаСеанса();
	Док.ОрганизацияЕГАИС = ОрганизацияЕГАИС;
	Док.Заполнить(ОрганизацияЕГАИС);
	
	Док.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2;
	Док.ПричинаПостановкиНаБаланс = Перечисления.ПричиныПостановкиНаБалансЕГАИС.ЗакупкаДо2016;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТЧ = Док.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, Выборка);
	КонецЦикла;
	
	ЗаписатьДокументКорректировкиОстатков(Док);
	
КонецПроцедуры

// Создает акт списания из регистра №2 ЕГАИС.
//
Процедура СоздатьАктСписанияИзРегистра2(РезультатЗапроса)
	
	Док = Документы.АктСписанияЕГАИС.СоздатьДокумент();
	Док.Дата = ТекущаяДатаСеанса();
	Док.ОрганизацияЕГАИС = ОрганизацияЕГАИС;
	Док.Заполнить(ОрганизацияЕГАИС);
	
	Док.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра2;
	Док.ПричинаСписания = Перечисления.ПричиныСписанийЕГАИС.Реализация;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТЧ = Док.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, Выборка);
	КонецЦикла;
	
	ЗаписатьДокументКорректировкиОстатков(Док);
	
КонецПроцедуры

// Создает акт постановки на баланс в регистр №1 ЕГАИС.
//
Процедура СоздатьАктПостановкиНаБалансВРегистр1(РезультатЗапроса)
	
	Док = Документы.АктПостановкиНаБалансЕГАИС.СоздатьДокумент();
	Док.Дата = ТекущаяДатаСеанса();
	Док.ОрганизацияЕГАИС = ОрганизацияЕГАИС;
	Док.Заполнить(ОрганизацияЕГАИС);
	
	Док.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1;
	Док.ПричинаПостановкиНаБаланс = Перечисления.ПричиныПостановкиНаБалансЕГАИС.ЗакупкаДо2016;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТЧ = Док.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, Выборка);
	КонецЦикла;
	
	ЗаписатьДокументКорректировкиОстатков(Док);
	
КонецПроцедуры

// Создает акт списания из регистра №1 ЕГАИС.
//
Процедура СоздатьАктСписанияИзРегистра1(РезультатЗапроса, ОстаткиСправок2)
	
	Док = Документы.АктСписанияЕГАИС.СоздатьДокумент();
	Док.Дата = ТекущаяДатаСеанса();
	Док.ОрганизацияЕГАИС = ОрганизацияЕГАИС;
	Док.Заполнить(ОрганизацияЕГАИС);
	
	Док.ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктСписанияИзРегистра1;
	Док.ПричинаСписания = Перечисления.ПричиныСписанийЕГАИС.Недостача;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СписатьИзРегистра1 = ?(Выборка.ПродаетсяВРозлив, Выборка.Количество * Выборка.ОбъемДАЛ, Выборка.Количество);
		
		МассивСправок = ОстаткиСправок2.НайтиСтроки(Новый Структура("АлкогольнаяПродукция", Выборка.АлкогольнаяПродукция));
		Для Каждого СтрокаСправки Из МассивСправок Цикл
			ТекКоличество = Мин(СтрокаСправки.Количество, СписатьИзРегистра1);
			Если ТекКоличество > 0 Тогда
				СтрокаТЧ = Док.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТЧ, Выборка);
				СтрокаТЧ.Количество = ?(Выборка.ПродаетсяВРозлив, ТекКоличество / Выборка.ОбъемДАЛ, ТекКоличество);
				СтрокаТЧ.КоличествоУпаковок = СтрокаТЧ.Количество;
				СтрокаТЧ.Справка2 = СтрокаСправки.Справка2;
				
				СписатьИзРегистра1 = СписатьИзРегистра1 - ТекКоличество;
				СтрокаСправки.Количество = СтрокаСправки.Количество - ТекКоличество;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	ЗаписатьДокументКорректировкиОстатков(Док);
	
КонецПроцедуры

// Записывает документ корректировки остатков.
//
Процедура ЗаписатьДокументКорректировкиОстатков(Док)
	
	Док.Записать();
	
	Если Док.ПроверитьЗаполнение() Тогда
		Док.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ТекстСообщения = НСтр("ru='При проверке документа %1 возникли ошибки. Для выгрузки в ЕГАИС требуется провести документ вручную.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Док.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Док.Ссылка);
	КонецЕсли;
	
	СтрокаТЧ = СозданныеДокументы.Добавить();
	СтрокаТЧ.ДокументСсылка = Док.Ссылка;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет таблицу остатков по данным ЕГАИС.
//
Функция ОстаткиЕГАИС()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОстаткиВРегистре1", ОстаткиВРегистре1);
	Запрос.УстановитьПараметр("ОстаткиВРегистре2", ОстаткиВРегистре2);
	Запрос.УстановитьПараметр("КорректироватьОстаткиНемаркируемойПродукции", КорректироватьОстаткиНемаркируемойПродукции);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	СУММА(ВложенныйЗапрос.ОстатокСклад) КАК ОстатокРегистр1,
	|	СУММА(ВложенныйЗапрос.ОстатокТорговыйЗал) КАК ОстатокРегистр2
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|		СУММА(ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Количество) КАК ОстатокСклад,
	|		0 КАК ОстатокТорговыйЗал
	|	ИЗ
	|		Документ.ОстаткиЕГАИС.ОстаткиПоДаннымЕГАИС КАК ОстаткиЕГАИСОстаткиПоДаннымЕГАИС
	|	ГДЕ
	|		ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Ссылка = &ОстаткиВРегистре1
	|		И ВЫБОР
	|				КОГДА НЕ ЕСТЬNULL(ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция.ВидПродукции.Маркируемый, ЛОЖЬ)
	|					ТОГДА &КорректироватьОстаткиНемаркируемойПродукции
	|				ИНАЧЕ ИСТИНА
	|			КОНЕЦ
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция,
	|		0,
	|		СУММА(ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Количество)
	|	ИЗ
	|		Документ.ОстаткиЕГАИС.ОстаткиПоДаннымЕГАИС КАК ОстаткиЕГАИСОстаткиПоДаннымЕГАИС
	|	ГДЕ
	|		ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Ссылка = &ОстаткиВРегистре2
	|		И ВЫБОР
	|				КОГДА НЕ ЕСТЬNULL(ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция.ВидПродукции.Маркируемый, ЛОЖЬ)
	|					ТОГДА &КорректироватьОстаткиНемаркируемойПродукции
	|				ИНАЧЕ ИСТИНА
	|			КОНЕЦ
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.АлкогольнаяПродукция";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли