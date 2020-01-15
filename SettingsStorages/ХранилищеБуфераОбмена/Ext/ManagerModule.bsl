﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицу буфера обмена
Функция ИнициализироватьТаблицуБуфераОбмена()
	
	ТаблицаСтрок = Новый ТаблицаЗначений();
	ТаблицаСтрок.Колонки.Добавить("ТоварнаяКатегория",      Новый ОписаниеТипов("СправочникСсылка.ТоварныеКатегории"));
	ТаблицаСтрок.Колонки.Добавить("РейтингПродаж",          Новый ОписаниеТипов("СправочникСсылка.РейтингиПродажНоменклатуры"));
	ТаблицаСтрок.Колонки.Добавить("НоменклатураНабора",     Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаСтрок.Колонки.Добавить("Номенклатура",           Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаСтрок.Колонки.Добавить("УпаковочныйЛист",        Новый ОписаниеТипов("ДокументСсылка.УпаковочныйЛист"));
	ТаблицаСтрок.Колонки.Добавить("ТипНоменклатуры",        Новый ОписаниеТипов("ПеречислениеСсылка.ТипыНоменклатуры"));
	ТаблицаСтрок.Колонки.Добавить("Характеристика",         Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаСтрок.Колонки.Добавить("ХарактеристикаНабора",   Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаСтрок.Колонки.Добавить("Содержание",             Новый ОписаниеТипов("Строка"));
	ТаблицаСтрок.Колонки.Добавить("Упаковка",               Новый ОписаниеТипов("СправочникСсылка.УпаковкиНоменклатуры"));
	ТаблицаСтрок.Колонки.Добавить("КоличествоУпаковок",     ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,3));
	ТаблицаСтрок.Колонки.Добавить("Количество",             ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,3));
	ТаблицаСтрок.Колонки.Добавить("Цена",                   ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,2));
	ТаблицаСтрок.Колонки.Добавить("ВидЦены",                Новый ОписаниеТипов("СправочникСсылка.ВидыЦен"));
	ТаблицаСтрок.Колонки.Добавить("ПроцентРучнойСкидки",    ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(5,2));
	ТаблицаСтрок.Колонки.Добавить("СуммаРучнойСкидки",      ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15,2));
	
	Возврат ТаблицаСтрок;
	
КонецФункции 

// Помещает данные в буфер обмена
//
// Параметры:
//   ВыделенныеСтроки       (Массив) Массив идентификаторов выделенных строк
//   ТабЧасть               (ТабличнаяЧасть) Табличная часть объекта с копируемыми строками
Процедура ПоместитьВыделенныеСтрокиВБуферОбмена(ВыделенныеСтроки, ТабЧасть) Экспорт
	ТаблицаБуфераОбмена = ИнициализироватьТаблицуБуфераОбмена();
	
	ВыделенныеСтрокиТЧ = Новый Массив;
	Если ВыделенныеСтроки <> Неопределено Тогда
		
		Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
			СтрокаТаблицы = ТабЧасть.НайтиПоИдентификатору(ТекСтрока);
			ВыделенныеСтрокиТЧ.Добавить(СтрокаТаблицы);
		КонецЦикла;
		
		НаборыВызовСервера.ДополнитьДоПолногоНабора(ТабЧасть, ВыделенныеСтрокиТЧ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыделенныеСтрокиТЧ) Тогда
		Для каждого СтрокаТаблицы Из ВыделенныеСтрокиТЧ Цикл
			
			НоваяСтрока = ТаблицаБуфераОбмена.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			
		КонецЦикла;
	Иначе
		Для каждого СтрокаТаблицы Из ТабЧасть Цикл
			
			НоваяСтрока = ТаблицаБуфераОбмена.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			
		КонецЦикла;
	КонецЕсли;
	
	ХранилищаНастроек.ХранилищеБуфераОбмена.Сохранить("БуфераОбмена", "Строки", ТаблицаБуфераОбмена, , );
КонецПроцедуры 

// Получает данные из буфера обмена
//
// Параметры:
//   ПараметрыОтбора       (Структура) Параметры отбора строк
//
// Возвращаемое значение:
//   ТаблицаЗначений   - Строки, полученные из буфера обмена
//
Функция ПолучитьСтрокиИзБуфераОбмена(ПараметрыОтбора = Неопределено) Экспорт
	СтрокиДляВставки = ХранилищаНастроек.ХранилищеБуфераОбмена.Загрузить("БуфераОбмена","Строки", , );
	
	Если ЗначениеЗаполнено(ПараметрыОтбора) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТЗ.ТоварнаяКатегория,
		|	ТЗ.РейтингПродаж,
		|	ТЗ.НоменклатураНабора,
		|	ТЗ.Номенклатура,
		|	ТЗ.ТипНоменклатуры,
		|	ТЗ.ХарактеристикаНабора,
		|	ТЗ.Характеристика,
		|	ТЗ.Содержание,
		|	ТЗ.Упаковка,
		|	ТЗ.КоличествоУпаковок,
		|	ТЗ.Количество,
		|	ТЗ.Цена,
		|	ТЗ.ВидЦены,
		|	ТЗ.ПроцентРучнойСкидки,
		|	ТЗ.СуммаРучнойСкидки
		|ПОМЕСТИТЬ Т
		|ИЗ
		|	&ТЗ КАК ТЗ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР 
		|		КОГДА Т.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) 
		|		ТОГДА Т.Номенклатура.ТоварнаяКатегория 
		|		ИНАЧЕ Т.ТоварнаяКатегория 
		|	КОНЕЦ КАК ТоварнаяКатегория,
		|	ВЫБОР 
		|		КОГДА Т.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) 
		|		ТОГДА Т.Номенклатура.РейтингПродаж 
		|		ИНАЧЕ Т.РейтингПродаж 
		|	КОНЕЦ КАК РейтингПродаж,
		|	Т.НоменклатураНабора,
		|	Т.Номенклатура,
		|	Т.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
		|	Т.ХарактеристикаНабора,
		|	Т.Характеристика,
		|	Т.Содержание,
		|	Т.Упаковка,
		|	Т.КоличествоУпаковок,
		|	Т.Количество,
		|	Т.Цена,
		|	Т.ВидЦены,
		|	Т.ПроцентРучнойСкидки,
		|	Т.СуммаРучнойСкидки
		|ИЗ
		|	Т КАК Т
		|ГДЕ
		|	ИСТИНА
		|	%ТекстУсловияОтбор%");
		
		Запрос.УстановитьПараметр("ТЗ", СтрокиДляВставки);
		ТекстУсловияОтбор = "";
		
		Если ПараметрыОтбора.Свойство("ОтборПоТипуНоменклатуры") Тогда
			ТекстУсловияОтбор = "И Т.Номенклатура.ТипНоменклатуры В (&ОтборПоТипуНоменклатуры)";
			Запрос.УстановитьПараметр("ОтборПоТипуНоменклатуры", ПараметрыОтбора.ОтборПоТипуНоменклатуры);
		КонецЕсли;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ТекстУсловияОтбор%", ТекстУсловияОтбор);
		
		СтрокиДляВставки = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	
	Возврат СтрокиДляВставки
КонецФункции 

// Проверяет буфер обмена на заполненность
Функция БуферОбменаПустой() Экспорт
	
	Возврат (ХранилищаНастроек.ХранилищеБуфераОбмена.Загрузить("БуфераОбмена", "Строки", , ) = Неопределено)

КонецФункции 

// Очищает буфер обмена
Процедура ОчиститьБуферОбмена() Экспорт
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормУдалить("БуфераОбмена", "Строки", ИмяПользователя());
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытий

// Обработчик чтения данных из буфера обмена
//
// Параметры:
//   КлючОбъекта       (Строка) Полное имя объекта
//   КлючНастроек     (Строка) Ключ сохраняемых данных
//   Настройки        (*) Настройки варианта отчета
//   ОписаниеНастроек (ОписаниеНастроек)
//   Пользователь     (Строка) Имя пользователя ИБ
Процедура ОбработкаЗагрузки(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, Пользователь)
	Настройки = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(КлючОбъекта, КлючНастроек);
КонецПроцедуры

// Обработчик записи данных в буфера обмена
//
// Параметры:
//   КлючОбъекта       (Строка) Полное имя отчета с точкой
//   КлючНастроек     (Строка) Ключ варианта отчета
//   Настройки        (*) Настройки варианта отчета
//   ОписаниеНастроек (ОписаниеНастроек, Неопределено)
//   Пользователь     (Строка, Неопределено) Имя пользователя ИБ
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
Процедура ОбработкаСохранения(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, Пользователь)
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(КлючОбъекта, КлючНастроек, Настройки);
КонецПроцедуры

// Помещает данные в буфер обмена
//
// Параметры:
//   Ячейки - Массив - массив с копируемыми ячейками
Процедура ПоместитьВыделенныеЯчейкиБюджетаВБуферОбмена(ЯчейкиБюджета) Экспорт
	
	ХранилищаНастроек.ХранилищеБуфераОбмена.Сохранить("БуфераОбмена", "ЯчейкиБюджета", ЯчейкиБюджета, , );
	
КонецПроцедуры 

// Получает данные из буфера обмена
//
// Параметры:
//   Нет
//
// Возвращаемое значение:
//   Массив - массив с вставляемыми ячейками
//
Функция ПолучитьЯчейкиБюджетаИзБуфераОбмена() Экспорт
	
	ЯчейкиДляВставки = ХранилищаНастроек.ХранилищеБуфераОбмена.Загрузить("БуфераОбмена", "ЯчейкиБюджета", , );
	Если ТипЗнч(ЯчейкиДляВставки) <> Тип("Массив") Тогда
		ЯчейкиДляВставки = Новый Массив;
	КонецЕсли;
	
	Возврат ЯчейкиДляВставки;
	
КонецФункции 

#КонецОбласти

#КонецЕсли
