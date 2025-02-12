﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Добавляет команду создания документа "Выкуп возвратной тары у поставщика".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьМногооборотнуюТару";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаРасчетовПоПринятойВозвратнойТаре(КомандыОтчетов);
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаРасчетовСПоставщикомПоДокументам(КомандыОтчетов);
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСостояниеРасчетовСПоставщикомПоДокументам(КомандыОтчетов);
	
КонецПроцедуры

// Функция определяет реквизиты выбранного документа.
//
// Параметры:
//  ДокументСсылка - Ссылка на документа
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного документа
//
Функция РеквизитыДокумента(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.ПорядокРасчетов КАК ПорядокРасчетов,
	|	ДанныеДокумента.Курс КАК Курс,
	|	ДанныеДокумента.Кратность КАК Кратность
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &ДокументСсылка
	|");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Дата = Выборка.Дата;
		Организация = Выборка.Организация;
		Партнер = Выборка.Партнер;
		Контрагент = Выборка.Контрагент;
		Договор = Выборка.Договор;
		НаправлениеДеятельности = Выборка.НаправлениеДеятельности;
		ПорядокРасчетов = Выборка.ПорядокРасчетов;
		Валюта = Выборка.Валюта;
		ВалютаВзаиморасчетов = Выборка.ВалютаВзаиморасчетов;
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
		СуммаДокумента = Выборка.СуммаДокумента;
		СуммаВзаиморасчетов = ?(Выборка.Проведен, Выборка.СуммаВзаиморасчетов, 0);
		Кратность = Выборка.Кратность;
		Курс = Выборка.Курс;
	Иначе
		Дата = Дата(1,1,1);
		Организация = Справочники.Организации.ПустаяСсылка();
		Партнер = Справочники.Партнеры.ПустаяСсылка();
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		НаправлениеДеятельности = Справочники.НаправленияДеятельности.ПустаяСсылка();
		ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПустаяСсылка();
		Валюта = Справочники.Валюты.ПустаяСсылка();
		ВалютаВзаиморасчетов = Справочники.Валюты.ПустаяСсылка();
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
		СуммаДокумента = 0;
		СуммаВзаиморасчетов = 0;
		Кратность = 1;
		Курс = 1;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("Дата, Организация, Партнер, Контрагент, Договор, ПорядокРасчетов, Валюта, ВалютаВзаиморасчетов, ХозяйственнаяОперация, СуммаДокумента, СуммаВзаиморасчетов, Курс, Кратность, НаправлениеДеятельности",
		Дата,
		Организация,
		Партнер,
		Контрагент,
		Договор,
		ПорядокРасчетов,
		Валюта,
		ВалютаВзаиморасчетов,
		ХозяйственнаяОперация,
		СуммаДокумента,
		СуммаВзаиморасчетов,
		Курс,
		Кратность,
		НаправлениеДеятельности);
	
	Возврат СтруктураРеквизитов;

КонецФункции


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.ПредусмотренЗалогЗаТару КАК ПредусмотренЗалогЗаТару,
	|	ДанныеДокумента.ДатаПлатежа КАК ДатаПлатежа,
	|	ДанныеДокумента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДокумента.ФормаОплаты КАК ФормаОплаты,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ВЫБОР КОГДА ДанныеДокумента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК РасчетыПоДоговорам,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ВЫБОР КОГДА ДанныеДокумента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)
	|		И ЕСТЬNULL(ДанныеДокумента.Договор.ЗаданГрафикИсполнения, ЛОЖЬ) ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ГрафикИсполненияВДоговоре
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(Реквизиты.Валюта, Реквизиты.ВалютаВзаиморасчетов, Реквизиты.Период);
	
	Запрос.УстановитьПараметр("Период",                                        Реквизиты.Период);
	Запрос.УстановитьПараметр("Партнер",                                       Реквизиты.Партнер);
	Запрос.УстановитьПараметр("Организация",                                   Реквизиты.Организация);
	Запрос.УстановитьПараметр("Валюта",                                        Реквизиты.Валюта);
	Запрос.УстановитьПараметр("ПредусмотренЗалогЗаТару",                       Реквизиты.ПредусмотренЗалогЗаТару);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета",                Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета",                    Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ДатаПлатежа",                                   Реквизиты.ДатаПлатежа);
	Запрос.УстановитьПараметр("ФормаОплаты",                                   Реквизиты.ФормаОплаты);
	Запрос.УстановитьПараметр("ВалютаВзаиморасчетов",                          Реквизиты.ВалютаВзаиморасчетов);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУПР",                Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл",               Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	Запрос.УстановитьПараметр("Договор",                                       Реквизиты.Договор);
	Запрос.УстановитьПараметр("РасчетыПоДоговорам",                            Реквизиты.РасчетыПоДоговорам);
	Запрос.УстановитьПараметр("АналитикаУчетаПоПартнерам",                     РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(Реквизиты));
	Запрос.УстановитьПараметр("ГрафикИсполненияВДоговоре",                     Реквизиты.ГрафикИсполненияВДоговоре);
	
КонецПроцедуры

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт

	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаПринятаяВозвратнаяТара(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРасчетыСПоставщиками(Запрос, ТекстыЗапроса, Регистры);

	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
			
КонецПроцедуры

Функция ТекстЗапросаВтРасчетыПоНакладной(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтРасчетыПоНакладной";
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СУММА(РасчетыПоНакладной.Сумма)     КАК СуммаВзаиморасчетов,
	|	СУММА(РасчетыПоНакладной.СуммаРегл) КАК СуммаРегл,
	|	СУММА(РасчетыПоНакладной.СуммаУпр)  КАК СуммаУпр
	|ПОМЕСТИТЬ ВтРасчетыПоНакладной
	|ИЗ (ВЫБРАТЬ
	|		СУММА(ДанныеДокумента.СуммаВзаиморасчетов) КАК Сумма,
	|		ВЫБОР КОГДА &ВалютаВзаиморасчетов = &ВалютаРегламентированногоУчета И &Валюта <> &ВалютаРегламентированногоУчета
	|				ТОГДА СУММА(ДанныеДокумента.СуммаВзаиморасчетов)
	|				ИНАЧЕ ВЫРАЗИТЬ(СУММА(ДанныеДокумента.СуммаДокумента) * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2))
	|		КОНЕЦ КАК СуммаРегл,
	|		ВЫБОР КОГДА &ВалютаВзаиморасчетов = &ВалютаУправленческогоУчета
	|				ТОГДА СУММА(ДанныеДокумента.СуммаВзаиморасчетов)
	|				ИНАЧЕ ВЫРАЗИТЬ(СУММА(ДанныеДокумента.СуммаДокумента) * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2))
	|		КОНЕЦ КАК СуммаУпр
	|	ИЗ
	|		Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|	ГДЕ
	|		НЕ &ПредусмотренЗалогЗаТару И НЕ &РасчетыПоДоговорам
	|		И ДанныеДокумента.Ссылка = &Ссылка
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|		
	|	ВЫБРАТЬ
	|		СУММА(-РасшифровкаПлатежа.СуммаВзаиморасчетов) КАК Сумма,
	|		ВЫБОР КОГДА &ВалютаВзаиморасчетов = &ВалютаРегламентированногоУчета И &Валюта <> &ВалютаРегламентированногоУчета
	|				ТОГДА СУММА(-РасшифровкаПлатежа.СуммаВзаиморасчетов)
	|				ИНАЧЕ ВЫРАЗИТЬ(СУММА(-РасшифровкаПлатежа.Сумма) * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2))
	|		КОНЕЦ КАК СуммаРегл,
	|		ВЫБОР КОГДА &ВалютаВзаиморасчетов = &ВалютаУправленческогоУчета
	|				ТОГДА СУММА(-РасшифровкаПлатежа.СуммаВзаиморасчетов)
	|				ИНАЧЕ ВЫРАЗИТЬ(СУММА(-РасшифровкаПлатежа.Сумма) * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2))
	|		КОНЕЦ КАК СуммаУпр
	|	ИЗ
	|		Документ.ВыкупВозвратнойТарыУПоставщика.РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|	ГДЕ
	|		РасшифровкаПлатежа.Ссылка = &Ссылка
	|		И НЕ РасшифровкаПлатежа.Заказ = НЕОПРЕДЕЛЕНО
	|		И НЕ &ПредусмотренЗалогЗаТару) КАК РасчетыПоНакладной
	|ИМЕЮЩИЕ СУММА(РасчетыПоНакладной.Сумма) <> 0
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПринятаяВозвратнаяТара(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПринятаяВозвратнаяТара";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки              КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	ТаблицаТовары.Количество               КАК Количество,
	|	ТаблицаТовары.СуммаСНДС                КАК Сумма,
	|	&Партнер                               КАК Партнер,
	|	ТаблицаТовары.ДокументПоступления      КАК ДокументПоступления,
	|	ИСТИНА                                 КАК Выкуп,
	|	&ПредусмотренЗалогЗаТару               КАК ПредусмотренЗалог
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	ТаблицаТовары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС КАК СуммаБезНДС,
	|	ТаблицаТовары.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаРегламентированногоУчета ТОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаБезНДС, 0) ТОГДА
	|		ЕСТЬNULL(ДанныеРегистра.СуммаБезНДСРегл, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаБезНДСРегл,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаРегламентированногоУчета ТОГДА ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаНДС, 0) ТОГДА
	|		ЕСТЬNULL(ДанныеРегистра.СуммаНДСРегл, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаНДСРегл,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаРегламентированногоУчета ТОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаБезНДС, 0) ТОГДА
	|		ВЫБОР
	|			КОГДА ЕСТЬNULL(ДанныеРегистра.БазаНДСРегл, 0) = 0
	|				ТОГДА ЕСТЬNULL(ДанныеРегистра.СуммаБезНДСРегл, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДанныеРегистра.БазаНДСРегл, 0)
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК БазаНДСРегл,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаРегламентированногоУчета ТОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаБезНДС, 0) ТОГДА
	|		ВЫБОР
	|			КОГДА ЕСТЬNULL(ДанныеРегистра.БазаНДСУпр, 0) = 0
	|				ТОГДА ЕСТЬNULL(ДанныеРегистра.СуммаБезНДСУпр, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДанныеРегистра.БазаНДСУпр, 0)
	|		КОНЕЦ
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК БазаНДСУпр,
	|
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаУправленческогоУчета ТОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаБезНДС, 0) ТОГДА
	|		ЕСТЬNULL(ДанныеРегистра.СуммаБезНДСУпр, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаБезНДСУпр,
	|	ВЫБОР 
	|	КОГДА &Валюта = &ВалютаУправленческогоУчета ТОГДА ТаблицаТовары.СуммаНДС
	|	КОГДА ТаблицаТовары.СуммаНДС = ЕСТЬNULL(ДанныеРегистра.СуммаНДС, 0) ТОГДА
	|		ЕСТЬNULL(ДанныеРегистра.СуммаНДСУпр, 0)
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаНДСУпр,
	|
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК ТаблицаТовары
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК ДанныеРегистра
	|	ПО
	|		ДанныеРегистра.Регистратор = &Ссылка
	|		И ТаблицаТовары.ИдентификаторСтроки = ДанныеРегистра.ИдентификаторСтроки
	|
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРасчетыСПоставщиками(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыСПоставщиками";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтРасчетыПоНакладной", ТекстыЗапроса) Тогда
		ТекстЗапросаВтРасчетыПоНакладной(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Период КАК ДатаРегистратора,
	|	&ДатаПлатежа КАК ДатаПлатежа,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|
	|	&Договор КАК ЗаказПоставщику,
	|
	|	Неопределено КАК ЗакупкаПоЗаказу,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика) КАК ХозяйственнаяОперация,
	|	&ВалютаВзаиморасчетов КАК Валюта,
	|	Неопределено КАК ФормаОплаты,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК Сумма,
	|	0 КАК КОплате,
	|	0 КАК КОтгрузке,
	|	ВЫБОР 
	|		КОГДА ДанныеДокумента.ВалютаВзаиморасчетов = &ВалютаРегламентированногоУчета 
	|			ТОГДА ДанныеДокумента.СуммаВзаиморасчетов
	|		ИНАЧЕ ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2))
	|	КОНЕЦ КАК СуммаРегл,
	|	ВЫБОР 
	|		КОГДА ДанныеДокумента.ВалютаВзаиморасчетов = &ВалютаУправленческогоУчета 
	|			ТОГДА ДанныеДокумента.СуммаВзаиморасчетов
	|		ИНАЧЕ ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуУПР КАК ЧИСЛО(15, 2))
	|	КОНЕЦ КАК СуммаУпр,
	|	&Организация КАК Организация
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И НЕ &ПредусмотренЗалогЗаТару
	|	И &РасчетыПоДоговорам
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период                                                         КАК Период,
	|	&Период                                                         КАК ДатаРегистратора,
	|	&ДатаПлатежа                                                    КАК ДатаПлатежа,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)                          КАК ВидДвижения,
	|	&АналитикаУчетаПоПартнерам                                      КАК АналитикаУчетаПоПартнерам,
	|
	|	&Ссылка                                                         КАК ЗаказПоставщику,
	|
	|	Неопределено                                                    КАК ЗакупкаПоЗаказу,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика) КАК ХозяйственнаяОперация,
	|	&ВалютаВзаиморасчетов                                           КАК Валюта,
	|	Неопределено                                                    КАК ФормаОплаты,
	|	
	|	РасчетыПоНакладной.СуммаВзаиморасчетов                          КАК Сумма,
	|	0                                                               КАК КОплате,
	|	0                                                               КАК КОтгрузке,
	|	РасчетыПоНакладной.СуммаРегл                                    КАК СуммаРегл,
	|	РасчетыПоНакладной.СуммаУпр                                     КАК СуммаУпр,
	|	&Организация                                                    КАК Организация
	|ИЗ
	|	ВтРасчетыПоНакладной КАК РасчетыПоНакладной
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОНЕЦПЕРИОДА(&ДатаПлатежа, День) КАК Период,
	|	&Период КАК ДатаРегистратора,
	|	&ДатаПлатежа КАК ДатаПлатежа,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|
	|	ВЫБОР КОГДА &РасчетыПоДоговорам ТОГДА
	|		&Договор
	|	ИНАЧЕ
	|		&Ссылка
	|	КОНЕЦ КАК ЗаказПоставщику,
	|
	|	Неопределено КАК ЗакупкаПоЗаказу,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика) КАК ХозяйственнаяОперация,
	|	&ВалютаВзаиморасчетов КАК Валюта,
	|	&ФормаОплаты КАК ФормаОплаты,
	|	0 КАК Сумма,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК КОплате,
	|	0 КАК КОтгрузке,
	|	0 КАК СуммаРегл,
	|	0 КАК СуммаУпр,
	|	&Организация КАК Организация
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И НЕ &ПредусмотренЗалогЗаТару
	|	И НЕ &ГрафикИсполненияВДоговоре
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&Период                                                         КАК Период,
	|	&Период                                                         КАК ДатаРегистратора,
	|	&Период                                                         КАК ДатаПлатежа,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)                          КАК ВидДвижения,
	|	&АналитикаУчетаПоПартнерам                                      КАК АналитикаУчетаПоПартнерам,
	|
	|	РасшифровкаПлатежа.Заказ                                        КАК ЗаказПоставщику,
	|
	|	Неопределено                                                    КАК ЗакупкаПоЗаказу,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика) КАК ХозяйственнаяОперация,
	|	&ВалютаВзаиморасчетов                                           КАК Валюта,
	|	Неопределено                                                    КАК ФормаОплаты,
	|	
	|	РасшифровкаПлатежа.СуммаВзаиморасчетов                          КАК Сумма,
	|	РасшифровкаПлатежа.СуммаВзаиморасчетов                          КАК КОплате,
	|	0                                                               КАК КОтгрузке,
	|
	|	ВЫБОР 
	|		КОГДА &ВалютаВзаиморасчетов = &ВалютаРегламентированногоУчета 
	|			ТОГДА РасшифровкаПлатежа.СуммаВзаиморасчетов
	|		ИНАЧЕ ВЫРАЗИТЬ(РасшифровкаПлатежа.Сумма * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2))
	|	КОНЕЦ КАК СуммаРегл,
	|	ВЫБОР 
	|		КОГДА &ВалютаВзаиморасчетов = &ВалютаУправленческогоУчета 
	|			ТОГДА РасшифровкаПлатежа.СуммаВзаиморасчетов
	|		ИНАЧЕ ВЫРАЗИТЬ(РасшифровкаПлатежа.Сумма * &КоэффициентПересчетаВВалютуУПР КАК ЧИСЛО(15, 2))
	|	КОНЕЦ КАК СуммаУпр,
	|
	|	&Организация                                                    КАК Организация
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|
	|ГДЕ
	|	РасшифровкаПлатежа.Ссылка = &Ссылка
	|	И НЕ &ПредусмотренЗалогЗаТару
	|	И НЕ РасшифровкаПлатежа.Заказ = НЕОПРЕДЕЛЕНО
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
