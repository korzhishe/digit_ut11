﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ВидыЗапасов.Количество() > 0 Тогда
		ВидыЗапасов.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		
		ЗаполнитьДокументНаОснованииПриобретенияТоваровУслуг(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаОбособленногоУчетаЗапасов),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	Если НалогообложениеНДС = НовоеНалогообложениеНДС Тогда
		
		ТекстОшибки = НСтр("ru='Новая деятельность соотвествует исходной'");
		Поле = "НалогообложениеНДС";
	 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			Поле,
			, // ПутьКДанным
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
														НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.КорректировкаОбособленногоУчетаЗапасов));
	
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение 
		И Не ВидыЗапасовУказаныВручную Тогда
		
		ЗаполнитьАналитикиУчетаНоменклатуры();
		ЗаполнитьВидыЗапасов(Отказ);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.КорректировкаВидаДеятельностиНДС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДатыПоступленияТоваровОрганизаций(ДополнительныеСвойства, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.Проведение);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыЗаполненения = ПараметрыЗаполненияВидовЗапасов(ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц);
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполненения);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.ОтменаПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПараметрыЗаполненения = ПараметрыЗаполненияВидовЗапасов(ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц);
	ПараметрыЗаполненения.ДокументДелаетИПриходИРасход = Ложь;
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполненения);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументНаОснованииПриобретенияТоваровУслуг(ПриобретениеТоваровУслуг)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ПриобретениеТоваровУслуг);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПриобретениеТоваровУслуг.Ссылка КАК Ссылка,
	|	ПриобретениеТоваровУслуг.Организация КАК Организация,
	|	ПриобретениеТоваровУслуг.Склад КАК Склад,
	|	ПриобретениеТоваровУслуг.Ссылка КАК ДокументПоступления,
	|	ПриобретениеТоваровУслуг.ЗакупкаПодДеятельность КАК НалогообложениеНДС,
	|	
	|	НЕ ПриобретениеТоваровУслуг.Проведен КАК ЕстьОшибкиПроведен
	|
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
	|ГДЕ
	|	ПриобретениеТоваровУслуг.Ссылка = &ДокументОснование
	|
	|////////////////////////////////////////////////
	|;
	|ВЫБРАТЬ
	|	Товары.Номенклатура        КАК Номенклатура,
	|	Товары.Характеристика      КАК Характеристика,
	|	Товары.Серия               КАК Серия,
	|	Товары.Склад               КАК Склад,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Количество          КАК Количество
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|	И Товары.Номенклатура.ТипНоменклатуры В(
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|";
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	Шапка = ПакетРезультатов[0].Выбрать();
	Шапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Ссылка,
		,
		Шапка.ЕстьОшибкиПроведен,);
	
	// Заполнение шапки.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	
	ТоварыОснования = ПакетРезультатов[1].Выгрузить();
	
	// Заполнение табличной части товары.
	Если Не ТоварыОснования.Количество() Тогда
		ТекстОшибки = НСтр("ru='Документ %Документ% не содержит товаров. Ввод на основании документа запрещен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ПриобретениеТоваровУслуг);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Товары.Загрузить(ТоварыОснования);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки") Тогда
		МассивСкладов = ОбщегоНазначенияУТ.УдалитьПовторяющиесяЭлементыМассива(ТоварыОснования.ВыгрузитьКолонку("Склад"));
		
		Если МассивСкладов.Количество() = 1 Тогда
			Склад = МассивСкладов[0];
		Иначе
			Склад = Справочники.Склады.ПустаяСсылка();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	Если Не Проведен
	 ИЛИ ПерезаполнитьВидыЗапасов
	 ИЛИ ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	 ИЛИ ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличеству(МенеджерВременныхТаблиц) Тогда
			
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов(МенеджерВременныхТаблиц);
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект,
											МенеджерВременныхТаблиц,
											Отказ,
											ПараметрыЗаполнения);
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД", "Количество");
		
		ЗаполнитьВидЗапасовОприходование();
	КонецЕсли;
	
КонецПроцедуры

// Создает менеджер временных таблиц с таблицами, которые используются для заполнения видов запасов.
// Экспорт требуется для отчета ОстаткиТоваровОрганизаций.
// 
// Возвращаемое значение:
//  МенеджерВременныхТаблиц - менеджер временных таблиц
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Склад КАК Склад,
	|	&Назначение КАК Назначение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыПредназначенияВидовЗапасов.ПустаяСсылка) КАК Предназначение,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПеремещениеТоваров) КАК ХозяйственнаяОперация,
	|	Ложь КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	&Склад КАК Склад,
	|	&Назначение КАК Назначение,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

// Формирует временную таблицу товаров с аналитикой обособленного учета. 
// Требуется для отчета ОстаткиТоваровОрганизаций.
//
// Параметры:
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц	 - менеджер временных таблиц, в котором есть таблица ТаблицаТоваров
//
Процедура СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.СтатусУказанияСерий = 14
	|			ТОГДА ТаблицаТоваров.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТоваров.Склад,
	|
	|	ТаблицаДанныхДокумента.Подразделение,
	|	ТаблицаДанныхДокумента.Менеджер,
	|	ТаблицаДанныхДокумента.Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		Истина
	|;
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц)
	
	Если МенеджерВременныхТаблиц.Таблицы.Найти("ДоступныеВидыЗапасов") <> Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"
	// Собственные виды запасов
	|ВЫБРАТЬ
	|	ВидыЗапасов.Организация КАК ДляОрганизации,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов
	|	
	|ПОМЕСТИТЬ ДоступныеВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.Организация = &Организация
	|	И ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	И (ВидыЗапасов.НалогообложениеНДС = &НалогообложениеНДС
	|		ИЛИ (ВидыЗапасов.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|				И &НалогообложениеНДС = &НалогообложениеОрганизации))
	|	И Не ВидыЗапасов.ПометкаУдаления
	|	И Не &ПартионныйУчетВерсии22
	|	И НЕ ВидыЗапасов.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВидыЗапасов.Организация КАК ДляОрганизации,
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	Не ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.Организация = &Организация
	|	И ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар)
	|	И Не ВидыЗапасов.ПометкаУдаления
	|	И &ПартионныйУчетВерсии22
	|	И НЕ ВидыЗапасов.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВидЗапасов";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("НалогообложениеОрганизации", Справочники.Организации.НалогообложениеНДС(Организация, Неопределено, Дата));
	Запрос.УстановитьПараметр("ПартионныйУчетВерсии22",
		УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22(НачалоМесяца(Дата)));
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПараметрыЗаполненияВидовЗапасов(МенеджерВременныхТаблиц)
	
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.ДокументДелаетИПриходИРасход = Истина;
	ПараметрыЗаполнения.ДоступныеВидыЗапасовУжеСформированы = Истина;
	
	СформироватьДоступныеВидыЗапасов(МенеджерВременныхТаблиц);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Заполняет аналитики учета номенклатуры. Используется в отчете ОстаткиТоваровОрганизаций.
Процедура ЗаполнитьАналитикиУчетаНоменклатуры() Экспорт
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
		Перечисления.ХозяйственныеОперации.ПеремещениеТоваров,
		Склад, 
		Неопределено, 
		Неопределено);
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета);

КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	Массив = Новый Массив;
	// Приходы в регистр (сторно расхода из регистра) контролируем при перепроведении и отмене проведения
	Если Не ДополнительныеСвойства.ЭтоНовый и Не СохранятьВидЗапасов Тогда
		Массив.Добавить(Движения.ТоварыОрганизаций);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, Склад, НалогообложениеНДС";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Процедура ЗаполнитьВидЗапасовОприходование()
	
	Если СохранятьВидЗапасов Тогда
		Для Каждого СтрТабл из ВидыЗапасов Цикл
			СтрТабл.ВидЗапасовОприходование = СтрТабл.ВидЗапасов;
		КонецЦикла;
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаВидыЗапасов.НомерСтроки,
		|	ВЫРАЗИТЬ(ТаблицаВидыЗапасов.ВидЗапасов КАК Справочник.ВидыЗапасов) КАК ВидЗапасов,
		|	ТаблицаВидыЗапасов.НомерГТД,
		|	ТаблицаВидыЗапасов.Количество,
		|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры
		|ПОМЕСТИТЬ ТаблицаВидыЗапасов
		|ИЗ
		|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	&Организация КАК Организация,
		|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
		|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
		|	ТаблицаВидыЗапасов.ВидЗапасов.ТипЗапасов КАК ТипЗапасов,
		|	ТаблицаВидыЗапасов.ВидЗапасов.ВладелецТовара КАК ВладелецТовара,
		|	ТаблицаВидыЗапасов.ВидЗапасов.Соглашение КАК Соглашение,
		|	ТаблицаВидыЗапасов.ВидЗапасов.Валюта КАК Валюта,
		|	&НалогообложениеОрганизации КАК НалогообложениеОрганизации,
		|	ТаблицаВидыЗапасов.ВидЗапасов.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
		|	&НовоеНалогообложениеНДС КАК НалогообложениеНДС,
		|	ВЫБОР
		|		КОГДА ТаблицаВидыЗапасов.ВидЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемНаКомиссию)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)
		|	КОНЕЦ КАК ХозяйственнаяОперация
		|ИЗ
		|	ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("НовоеНалогообложениеНДС", НовоеНалогообложениеНДС);
		Запрос.УстановитьПараметр("НалогообложениеОрганизации", Справочники.Организации.НалогообложениеНДС(Организация, Неопределено, Дата));
		Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
		
		СоответствиеВидовЗапасов = Новый Соответствие;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СтрокаТЧ = ВидыЗапасов[Выборка.НомерСтроки - 1];
			
			ВидЗапасовОприходование = СоответствиеВидовЗапасов.Получить(СтрокаТЧ.ВидЗапасов);
			
			Если ВидЗапасовОприходование = Неопределено Тогда
				ВидЗапасовОприходование = Справочники.ВидыЗапасов.ВидЗапасовДокумента(Выборка.Организация, Выборка.ХозяйственнаяОперация, Выборка);
				СоответствиеВидовЗапасов.Вставить(СтрокаТЧ.ВидЗапасов, ВидЗапасовОприходование);
			КонецЕсли;
			СтрокаТЧ.ВидЗапасовОприходование = ВидЗапасовОприходование;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
