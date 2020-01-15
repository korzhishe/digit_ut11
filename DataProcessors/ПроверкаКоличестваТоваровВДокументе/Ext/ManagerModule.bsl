﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	ИменаРеквизитов = "Склад,Помещение,Ордер,СкладскаяОперация,ДатаОтгрузки";
	
	Возврат ИменаРеквизитов;
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект	 - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  Структура - состав полей задается в функции ОбработкаТабличнойЧастиКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыУказанияСерий = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Обработка.ПроверкаКоличестваТоваровВДокументе";
	ПараметрыУказанияСерий.ИмяТЧСерии = "Товары";
	
	ПараметрыСерийСклада = СкладыСервер.ИспользованиеСерийНаСкладе(Объект.Склад, Ложь);
	
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Объект.СкладскаяОперация);
	
	ПараметрыУказанияСерий.ИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Объект.Склад, Объект.Помещение, Объект.ДатаОтгрузки);
	
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("Упаковка");
	ПараметрыУказанияСерий.ИмяПоляКоличество = "КоличествоУпаковок";
	
	ПараметрыУказанияСерий.ИмяПоляПомещение = "Помещение";
	
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("НеОтгружать");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("УпаковочныйЛист");
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("Назначение");
	
	ПараметрыУказанияСерий.ПланированиеОтгрузки = Ложь;
	ПараметрыУказанияСерий.ПланированиеОтбора = Ложь;
	ПараметрыУказанияСерий.ПроверкаОтбора = Ложь;
	ПараметрыУказанияСерий.ФактОтбора = Истина;
	
	ПараметрыУказанияСерий.ЭтоОрдер = Истина;
	ПараметрыУказанияСерий.БлокироватьДанныеФормы = Ложь;
	ПараметрыУказанияСерий.Дата = Объект.ДатаОтгрузки;
	
	Возврат ПараметрыУказанияСерий;
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.НеОтгружать КАК НеОтгружать,
	|	Товары.Серия КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.НеОтгружать КАК НеОтгружать,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры КАК ВидНоменклатуры,
	|	Товары.Серия КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ ТоварыДляЗапроса
	|ИЗ
	|	Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|			ТОГДА 0
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
	|			ТОГДА ВЫБОР
	|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|						ТОГДА ВЫБОР
	|								КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|									ТОГДА 14
	|								ИНАЧЕ 10
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|								ТОГДА 13
	|							ИНАЧЕ 9
	|						КОНЕЦ
	|				КОНЕЦ
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
	|			ТОГДА ВЫБОР
	|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчетСерийПоFEFO
	|						ТОГДА ВЫБОР
	|								КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|									ТОГДА 6
	|								ИНАЧЕ 5
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|								ТОГДА 8
	|							ИНАЧЕ 7
	|						КОНЕЦ
	|				КОНЕЦ
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПоФактуОтбора
	|					И (ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеКлиенту
	|							И &ОтгрузкаКлиенту
	|						ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеВРозницу
	|							И &ОтгрузкаВРозницу
	|						ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеКомплектующихДляСборки
	|							И &ОтгрузкаКомплектующихДляСборки
	|						ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеКомплектовДляРазборки
	|							И &ОтгрузкаКомплектовДляРазборки
	|						ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеНаВнутренниеНужды
	|							И &ОтгрузкаНаВнутренниеНужды
	|						ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеПоВозвратуПоставщику
	|							И &ОтгрузкаПоВозвратуПоставщику
	|						ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеПоПеремещению
	|							И &ОтгрузкаПоПеремещению)
	|				ИЛИ (ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПоФактуОтбора
	|					ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемке)
	|					И ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПеремещенииМеждуПомещениями
	|					И &ПеремещениеМеждуПомещениями
	|			ТОГДА ВЫБОР
	|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
	|						ТОГДА ВЫБОР
	|								КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|									ТОГДА 4
	|								ИНАЧЕ 3
	|							КОНЕЦ
	|					ИНАЧЕ ВЫБОР
	|							КОГДА Товары.НеОтгружать = 1
	|								ТОГДА 0
	|							КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|								ТОГДА 2
	|							ИНАЧЕ 1
	|						КОНЕЦ
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ Статусы
	|ИЗ
	|	ТоварыДляЗапроса КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|			ПО (&Склад = Склады.Ссылка)
	|		ПО (ПолитикиУчетаСерий.Склад = &Склад)
	|			И Товары.ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Статусы.НомерСтроки КАК НомерСтроки,
	|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ИЗ
	|	Статусы КАК Статусы
	|ГДЕ
	|	Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статусы.НомерСтроки";
	
	Если ПараметрыУказанияСерий.ПоляСвязи.Найти("Упаковка") = Неопределено Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Товары.Упаковка КАК Упаковка",
			"ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка");
			
	КонецЕсли;
	
	Возврат ТекстЗапроса;

	
КонецФункции

// Возвращает текст запроса для получениях доступных назначений
//	Параметры:
//		ПараметрыФормированияЗапроса - Структура - параметры для формирования текстов запросов
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаДоступныхНазначений(ПараметрыФормированияЗапроса) Экспорт
	
	Возврат Справочники.Назначения.ТекстЗапросаВсехНазначений(ПараметрыФормированияЗапроса);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УсловиеОтбораСтрок(Объект) Экспорт
	
	Если ТипЗнч(Объект.Ордер) = Тип("ДокументСсылка.ОрдерНаПеремещениеТоваров") Тогда
		
		Если Объект.РежимИсправления Тогда
			УсловиеОтбораСтрок = "ИСТИНА";
		Иначе
			УсловиеОтбораСтрок = "ТаблицаТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать)";
		КонецЕсли;
		
	Иначе
		
		Если Объект.РежимИсправления Тогда
			УсловиеОтбораСтрок = 
			"НЕ ТаблицаТовары.ЭтоУпаковочныйЛист
			|И ТаблицаТовары.УпаковочныйЛистРодитель = ЗНАЧЕНИЕ(Документ.УпаковочныйЛист.ПустаяСсылка)";
		Иначе
			УсловиеОтбораСтрок = "ТаблицаТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать)";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат УсловиеОтбораСтрок;
	
КонецФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаданиеНаДоборТоваровСправочно") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
		"ЗаданиеНаДоборТоваровСправочно",
		НСтр("ru = 'Задание на добор товаров'"),
		Обработки.ПечатьЗаданияНаОтборРазмещениеТоваров.СформироватьЗаданиеНаОтборРазмещениеТовара(Неопределено, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьДанныеДляПечатнойФормыЗаданиеНаДоборТоваров(ПараметрыПечати, Документ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(&ДокументОрдер КАК Документ.ОрдерНаПеремещениеТоваров) КАК Ссылка,
	|	ВЫРАЗИТЬ(&Склад КАК Справочник.Склады) КАК Склад,
	|	ТаблицаДобора.НомерСтроки КАК НомерСтроки,
	|	ВЫРАЗИТЬ(ТаблицаДобора.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ВЫРАЗИТЬ(ТаблицаДобора.Характеристика КАК Справочник.ХарактеристикиНоменклатуры) КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(ТаблицаДобора.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры.НастройкаИспользованияСерий = ЗНАЧЕНИЕ(Перечисление.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара)
	|			ТОГДА NULL
	|		ИНАЧЕ ВЫРАЗИТЬ(ТаблицаДобора.Серия КАК Справочник.СерииНоменклатуры)
	|	КОНЕЦ КАК Серия,
	|	ВЫРАЗИТЬ(ТаблицаДобора.Номенклатура КАК Справочник.Номенклатура).НаборУпаковок КАК НаборУпаковок,
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(ТаблицаДобора.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры.НастройкаИспользованияСерий = ЗНАЧЕНИЕ(Перечисление.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара)
	|			ТОГДА ВЫРАЗИТЬ(ТаблицаДобора.Номенклатура КАК Справочник.Номенклатура).ЕдиницаИзмерения
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Упаковка,
	|	ТаблицаДобора.КоличествоНедобор КАК Количество
	|ПОМЕСТИТЬ ТаблицаДобора
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаДобора
	|ГДЕ
	|	ТаблицаДобора.КоличествоНедобор > 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документ.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Ссылка) КАК СсылкаПредставление,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Склад) КАК СкладПредставление,
	|	ПРЕДСТАВЛЕНИЕ(Документ.ПомещениеОтправитель) КАК ПомещениеПредставление,
	|	Документ.Склад КАК Склад,
	|	Документ.Дата КАК Дата,
	|	Документ.Номер КАК Номер,
	|	ЛОЖЬ КАК НарушенаОрдернаяСхема,
	|	NULL КАК ВидОперации,
	|	ВЫБОР
	|		КОГДА Документ.Склад.ИспользоватьСкладскиеПомещения
	|				И Документ.Дата >= Документ.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|			ТОГДА ВЫБОР
	|					КОГДА Документ.ПомещениеОтправитель.ИспользоватьАдресноеХранениеСправочно
	|							И (НЕ Документ.ПомещениеОтправитель.ИспользоватьАдресноеХранение
	|								ИЛИ &ДатаОтгрузки < Документ.ПомещениеОтправитель.ДатаНачалаАдресногоХраненияОстатков)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЛОЖЬ
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Документ.Склад.ИспользоватьАдресноеХранениеСправочно
	|						И (НЕ Документ.Склад.ИспользоватьАдресноеХранение
	|							ИЛИ &ДатаОтгрузки < Документ.Склад.ДатаНачалаАдресногоХраненияОстатков)
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ
	|	КОНЕЦ КАК ИспользуетсяСправочноеХранение,
	|	ВЫБОР
	|		КОГДА Документ.Склад.ИспользоватьСкладскиеПомещения
	|				И Документ.Дата >= Документ.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|			ТОГДА ВЫБОР
	|					КОГДА Документ.ПомещениеОтправитель.ИспользоватьАдресноеХранение
	|							И &ДатаОтгрузки >= Документ.ПомещениеОтправитель.ДатаНачалаАдресногоХраненияОстатков
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЛОЖЬ
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Документ.Склад.ИспользоватьАдресноеХранение
	|						И &ДатаОтгрузки >= Документ.Склад.ДатаНачалаАдресногоХраненияОстатков
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ
	|	КОНЕЦ КАК ИспользуетсяАдресноеХранение,
	|	ВЫБОР
	|		КОГДА Документ.Склад.ИспользоватьСкладскиеПомещения
	|			И &ДатаОтгрузки >= Документ.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|			ТОГДА Документ.ПомещениеОтправитель.ИспользованиеРабочихУчастков
	|		ИНАЧЕ Документ.Склад.ИспользованиеРабочихУчастков
	|	КОНЕЦ КАК ИспользованиеРабочихУчастков,
	|	&ДопПоля
	|ИЗ
	|	Документ.ОрдерНаПеремещениеТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &ДокументОрдер
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.Ссылка КАК Ссылка,
	|	ТаблицаТовары.Склад КАК Склад,
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Серия КАК Серия,
	|	ТаблицаТовары.Номенклатура.Код КАК Код,
	|	ТаблицаТовары.Номенклатура.Артикул КАК Артикул,
	|	ТаблицаТовары.Номенклатура.НаименованиеПолное КАК ПредставлениеНоменклатуры,
	|	ТаблицаТовары.Характеристика.НаименованиеПолное КАК ПредставлениеХарактеристики,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Серия) КАК ПредставлениеСерии,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Упаковка) КАК ПредставлениеЕдининицыИзмеренияУпаковки,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Номенклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
	|	ТаблицаТовары.Количество КАК КоличествоУпаковок,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ЕСТЬNULL(РазмещениеОсновнаяЯчейка.Ячейка.РабочийУчасток, ЗНАЧЕНИЕ(Справочник.РабочиеУчастки.ПустаяСсылка)) КАК РабочийУчасток,
	|	ЕСТЬNULL(РазмещениеОсновнаяЯчейка.Ячейка.ПорядокОбхода, 0) КАК ПорядокОбхода,
	|	ЕСТЬNULL(РазмещениеОсновнаяЯчейка.Ячейка.ПорядокОбхода, ЗНАЧЕНИЕ(Справочник.СкладскиеЯчейки.ПустаяСсылка)) КАК ОсновнаяЯчейка,
	|	ЕСТЬNULL(РазмещениеОстальныеЯчейки.Ячейка.ПорядокОбхода, 0) КАК ПорядокОбходаДополнительнаяЯчейка,
	|	ЕСТЬNULL(ПРЕДСТАВЛЕНИЕ(РазмещениеОсновнаяЯчейка.Ячейка.РабочийУчасток), """") КАК ПредставлениеРабочегоУчастка,
	|	ЕСТЬNULL(РазмещениеОсновнаяЯчейка.Ячейка.Код, """") КАК ОсновнаяЯчейкаПредставление,
	|	ЕСТЬNULL(РазмещениеОстальныеЯчейки.Ячейка.Код, """") КАК ЯчейкаПредставление,
	|	ТаблицаТовары.Номенклатура.ВидНоменклатуры.НастройкаИспользованияСерий КАК НастройкаИспользованияСерий
	|ИЗ
	|	ТаблицаДобора КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеОсновнаяЯчейка
	|		ПО ТаблицаТовары.Номенклатура = РазмещениеОсновнаяЯчейка.Номенклатура
	|			И (РазмещениеОсновнаяЯчейка.ОсновнаяЯчейка = ИСТИНА)
	|			И (РазмещениеОсновнаяЯчейка.Склад = ТаблицаТовары.Склад)
	|			И (ВЫБОР
	|				КОГДА ТаблицаТовары.Склад.ИспользоватьСкладскиеПомещения
	|					И &ДатаОтгрузки >= ТаблицаТовары.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|					ТОГДА РазмещениеОсновнаяЯчейка.Помещение = ТаблицаТовары.Ссылка.ПомещениеОтправитель
	|				ИНАЧЕ РазмещениеОсновнаяЯчейка.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеОстальныеЯчейки
	|		ПО ТаблицаТовары.Номенклатура = РазмещениеОстальныеЯчейки.Номенклатура
	|			И (РазмещениеОстальныеЯчейки.ОсновнаяЯчейка = ЛОЖЬ)
	|			И (РазмещениеОсновнаяЯчейка.Склад = ТаблицаТовары.Склад)
	|			И (ВЫБОР
	|				КОГДА ТаблицаТовары.Склад.ИспользоватьСкладскиеПомещения
	|					И &ДатаОтгрузки >= ТаблицаТовары.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|					ТОГДА РазмещениеОсновнаяЯчейка.Помещение = ТаблицаТовары.Ссылка.ПомещениеОтправитель
	|				ИНАЧЕ РазмещениеОстальныеЯчейки.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|			КОНЕЦ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Склад,
	|	РабочийУчасток,
	|	ПорядокОбхода,
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	ПорядокОбходаДополнительнаяЯчейка,
	|	ЯчейкаПредставление,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка,
	|	Склад,
	|	РабочийУчасток,
	|	НомерСтроки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаДобора.Ссылка КАК Ссылка,
	|	ТаблицаДобора.Склад КАК Склад,
	|	ЕСТЬNULL(РазмещениеОсновнаяЯчейка.Ячейка.РабочийУчасток, ЗНАЧЕНИЕ(Справочник.РабочиеУчастки.ПустаяСсылка)) КАК РабочийУчасток,
	|	ЕСТЬNULL(РазмещениеОсновнаяЯчейка.Ячейка.ПорядокОбхода, 0) КАК ПорядокОбхода,
	|	ЕСТЬNULL(РазмещениеОстальныеЯчейки.Ячейка.ПорядокОбхода, 0) КАК ПорядокОбходаДополнительнаяЯчейка,
	|	ТаблицаДобора.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДобора.Номенклатура КАК Номенклатура,
	|	ТаблицаДобора.Характеристика КАК Характеристика,
	|	ТаблицаДобора.Серия КАК Серия,
	|	ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) КАК КоличествоВУпаковке,
	|	ЕСТЬNULL(УпаковкиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) КАК Упаковка,
	|	ЕСТЬNULL(УпаковкиНоменклатуры.ЕдиницаИзмерения.Представление, ПРЕДСТАВЛЕНИЕ(ТаблицаДобора.Номенклатура.ЕдиницаИзмерения)) КАК ПредставлениеЕдининицыИзмеренияУпаковки
	|ИЗ
	|	ТаблицаДобора КАК ТаблицаДобора
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиНоменклатуры
	|		ПО (ТаблицаДобора.Номенклатура = УпаковкиНоменклатуры.Владелец
	|				ИЛИ ТаблицаДобора.НаборУпаковок = УпаковкиНоменклатуры.Владелец)
	|			И (НЕ УпаковкиНоменклатуры.ПометкаУдаления)
	|			И ТаблицаДобора.Количество >= &ТекстЗапросаКоэффициентУпаковки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеОсновнаяЯчейка
	|		ПО ТаблицаДобора.Номенклатура = РазмещениеОсновнаяЯчейка.Номенклатура
	|			И (РазмещениеОсновнаяЯчейка.ОсновнаяЯчейка = ИСТИНА)
	|			И (РазмещениеОсновнаяЯчейка.Склад = ТаблицаДобора.Склад)
	|			И (ВЫБОР
	|				КОГДА ТаблицаДобора.Склад.ИспользоватьСкладскиеПомещения
	|					И &ДатаОтгрузки >= ТаблицаДобора.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|					ТОГДА РазмещениеОсновнаяЯчейка.Помещение = ТаблицаДобора.Ссылка.ПомещениеОтправитель
	|				ИНАЧЕ РазмещениеОсновнаяЯчейка.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеОстальныеЯчейки
	|		ПО ТаблицаДобора.Номенклатура = РазмещениеОстальныеЯчейки.Номенклатура
	|			И (РазмещениеОстальныеЯчейки.ОсновнаяЯчейка = ЛОЖЬ)
	|			И (РазмещениеОстальныеЯчейки.Склад = ТаблицаДобора.Склад)
	|			И (ВЫБОР
	|				КОГДА ТаблицаДобора.Склад.ИспользоватьСкладскиеПомещения
	|					И &ДатаОтгрузки >= ТаблицаДобора.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|					ТОГДА РазмещениеОстальныеЯчейки.Помещение = ТаблицаДобора.Ссылка.ПомещениеОтправитель
	|				ИНАЧЕ РазмещениеОстальныеЯчейки.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|			КОНЕЦ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Склад,
	|	РабочийУчасток,
	|	НомерСтроки,
	|	ПорядокОбхода,
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	КоличествоВУпаковке УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.Ссылка КАК Ссылка,
	|	ТаблицаТовары.Склад КАК Склад,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Серия.Наименование КАК ПредставлениеСерии,
	|	ЕСТЬNULL(РазмещениеОсновнаяЯчейка.Ячейка.РабочийУчасток, ЗНАЧЕНИЕ(Справочник.РабочиеУчастки.ПустаяСсылка)) КАК РабочийУчасток,
	|	ЕСТЬNULL(РазмещениеОсновнаяЯчейка.Ячейка.ПорядокОбхода, 0) КАК ПорядокОбхода
	|ИЗ
	|	ТаблицаДобора КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеОсновнаяЯчейка
	|		ПО ТаблицаТовары.Номенклатура = РазмещениеОсновнаяЯчейка.Номенклатура
	|			И (РазмещениеОсновнаяЯчейка.ОсновнаяЯчейка = ИСТИНА)
	|			И (РазмещениеОсновнаяЯчейка.Склад = ТаблицаТовары.Склад)
	|			И (ВЫБОР
	|				КОГДА ТаблицаТовары.Склад.ИспользоватьСкладскиеПомещения
	|					И &ДатаОтгрузки >= ТаблицаТовары.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|					ТОГДА РазмещениеОсновнаяЯчейка.Помещение = ТаблицаТовары.Ссылка.ПомещениеОтправитель
	|				ИНАЧЕ РазмещениеОсновнаяЯчейка.Помещение = ЗНАЧЕНИЕ(Справочник.СкладскиеПомещения.ПустаяСсылка)
	|			КОНЕЦ)
	|ГДЕ
	|	ТаблицаТовары.Номенклатура.ВидНоменклатуры.НастройкаИспользованияСерий = ЗНАЧЕНИЕ(Перечисление.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара)
	|	И НЕ ТаблицаТовары.Серия ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Склад,
	|	РабочийУчасток,
	|	ПорядокОбхода,
	|	Номенклатура,
	|	Характеристика,
	|	ПредставлениеСерии
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение) КАК ОснованиеПредставление,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение.Дата КАК ОснованиеДата,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение.Номер КАК ОснованиеНомер,
	|	МИНИМУМ(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерНаТоварыТоварыПоРаспоряжениям
	|ГДЕ
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка =&ДокументОрдер
	|
	|СГРУППИРОВАТЬ ПО
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение.Дата,
	|	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение.Номер,
	|	ПРЕДСТАВЛЕНИЕ(РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки";
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.РасходныйОрдерНаТовары") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ДопПоля","
			|	ПРЕДСТАВЛЕНИЕ(Документ.ЗаданиеНаПеревозку.Ссылка) КАК ЗаданиеНаПеревозкуПредставление,
			|	Документ.ЗаданиеНаПеревозку.Дата КАК ЗаданиеНаПеревозкуДата,
			|	Документ.ЗаданиеНаПеревозку.Номер КАК ЗаданиеНаПеревозкуНомер,
			|	Документ.ПорядокДоставки КАК ПорядокДоставки,
			|	Документ.ОтгрузкаПоЗаданиюНаПеревозку КАК ОтгрузкаПоЗаданиюНаПеревозку
			|");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ОрдерНаПеремещениеТоваров", "РасходныйОрдерНаТовары");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПомещениеОтправитель", "Помещение");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ДопПоля","ИСТИНА");
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки("УпаковкиНоменклатуры", Неопределено));
	Запрос.УстановитьПараметр("ДокументОрдер", Документ);
	Запрос.УстановитьПараметр("ТаблицаТоваров", ПараметрыПечати.ТаблицаТоваров.Выгрузить());
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Склад, ДатаОтгрузки");
	Запрос.УстановитьПараметр("Склад", СтруктураРеквизитов.Склад);
	Запрос.УстановитьПараметр("ДатаОтгрузки", СтруктураРеквизитов.ДатаОтгрузки);
	
	МассивРезультатов 			= Запрос.ВыполнитьПакет();
	РезультатПоШапке			= МассивРезультатов[1];
	РезультатПоТабличнойЧасти 	= МассивРезультатов[2];
	РезультатПоУпаковкам 		= МассивРезультатов[3];
	РезультатПоСериям	 		= МассивРезультатов[4];
	РезультатПоРаспоряжениям    = МассивРезультатов[5];
	
	СтруктураДанныхДляПечати = Новый Структура;
	
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке", РезультатПоШапке);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти", РезультатПоТабличнойЧасти);
	СтруктураДанныхДляПечати.Вставить("РезультатПоУпаковкам", РезультатПоУпаковкам);
	СтруктураДанныхДляПечати.Вставить("РезультатПоСериям", РезультатПоСериям);
	СтруктураДанныхДляПечати.Вставить("РезультатПоРаспоряжениям", РезультатПоРаспоряжениям);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли