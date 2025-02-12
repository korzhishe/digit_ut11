﻿
#Область ПрограммныйИнтерфейс

// Проверить сопоставление классификаторов
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Документ, для которого необходимо проверить соответствие классификаторов.
//  УникальныйИдентификатор - УникальныйИдентификатор - Идентификатор формы открытого документа.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   *ЕстьНеСопоставленныеТовары - Булево - Признак наличия несопоставленных товаров.
//   *НеСопоставленныеТовары - Строка - Адрес по временном хранилище.
//
Функция ПроверитьСопоставлениеКлассификаторов(ДокументСсылка, УникальныйИдентификатор) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ЕстьНеСопоставленныеТовары", Ложь);
	ВозвращаемоеЗначение.Вставить("НеСопоставленныеТовары",     Неопределено);
	
	ИмяТаблицы = "Документ" + "." + ДокументСсылка.Метаданные().Имя + "." + "Товары";
	
	Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПересортицаТоваров") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТабличнаяЧасть.НомерСтроки    КАК НомерСтроки,
		|	ТабличнаяЧасть.Номенклатура   КАК Номенклатура,
		|	ТабличнаяЧасть.Характеристика КАК Характеристика
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	ИмяТаблицы КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.Ссылка = &ДокументСсылка
		|	И ТабличнаяЧасть.Номенклатура.АлкогольнаяПродукция
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ТабличнаяЧасть.НомерСтроки,
		|	ТабличнаяЧасть.НоменклатураОприходование,
		|	ТабличнаяЧасть.ХарактеристикаОприходование
		|ИЗ
		|	ИмяТаблицы КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.Ссылка = &ДокументСсылка
		|	И ТабличнаяЧасть.НоменклатураОприходование.АлкогольнаяПродукция
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки,
		|	Товары.Номенклатура,
		|	Товары.Характеристика
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
		|		ПО (СоответствиеНоменклатурыЕГАИС.Номенклатура = Товары.Номенклатура)
		|			И (СоответствиеНоменклатурыЕГАИС.Характеристика = Товары.Характеристика)
		|ГДЕ
		|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция ЕСТЬ NULL ");
		
	Иначе
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТабличнаяЧасть.НомерСтроки,
		|	ТабличнаяЧасть.Номенклатура,
		|	ТабличнаяЧасть.Характеристика
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	ИмяТаблицы КАК ТабличнаяЧасть
		|ГДЕ
		|	ТабличнаяЧасть.Ссылка = &ДокументСсылка
		|	И ТабличнаяЧасть.Номенклатура.АлкогольнаяПродукция
		|;
		|
		|ВЫБРАТЬ
		|	Товары.НомерСтроки,
		|	Товары.Номенклатура,
		|	Товары.Характеристика
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
		|		ПО СоответствиеНоменклатурыЕГАИС.Номенклатура   = Товары.Номенклатура
		|		 И СоответствиеНоменклатурыЕГАИС.Характеристика = Товары.Характеристика
		|ГДЕ
		|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция ЕСТЬ NULL");
		
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяТаблицы", ИмяТаблицы);
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	НеСопоставленныеТовары = Запрос.Выполнить().Выгрузить();
	ВозвращаемоеЗначение.ЕстьНеСопоставленныеТовары = НеСопоставленныеТовары.Количество() > 0;
	
	Если ВозвращаемоеЗначение.ЕстьНеСопоставленныеТовары Тогда
		ВозвращаемоеЗначение.НеСопоставленныеТовары = ПоместитьВоВременноеХранилище(НеСопоставленныеТовары, УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ТипСклада(Склад) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ТипСклада");
	
КонецФункции

// Получает контрагента по умолчанию.
//
// Параметры:
//  Партнер - Справочник.Партнеры - партнер для которого необходимо получить контрагента.
//
// Возвращаемое значение:
//   Справочник.Контрагенты   - контрагент партнера по умолчанию.
//
Функция ПолучитьКонтрагентаПартнераПоУмолчанию(Партнер) Экспорт
	
	Возврат ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Партнер);
	
КонецФункции

#КонецОбласти
