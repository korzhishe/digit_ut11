﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет условия продаж в коммерческом предложении
//
// Параметры:
//	УсловияПродаж - Структура - Структура для заполнения
//
Процедура ЗаполнитьУсловияПродаж(Знач УсловияПродаж) Экспорт
	
	Если УсловияПродаж = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = УсловияПродаж.Валюта;
	Если ЗначениеЗаполнено(УсловияПродаж.ХозяйственнаяОперация) Тогда
		ХозяйственнаяОперация = УсловияПродаж.ХозяйственнаяОперация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Организация) Тогда
		Организация = УсловияПродаж.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.ГрафикОплаты) Тогда
		ГрафикОплаты = УсловияПродаж.ГрафикОплаты;
	КонецЕсли;
	
	ФормаОплаты = УсловияПродаж.ФормаОплаты;
	
	Если ЗначениеЗаполнено(УсловияПродаж.Склад) Тогда
		Склад = УсловияПродаж.Склад;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УсловияПродаж.СрокПоставки) Тогда
		СрокПоставки = УсловияПродаж.СрокПоставки;
	КонецЕсли;
	
	ЦенаВключаетНДС      = УсловияПродаж.ЦенаВключаетНДС;
	НалогообложениеНДС   = УсловияПродаж.НалогообложениеНДС;
	ВернутьМногооборотнуюТару = УсловияПродаж.ВозвращатьМногооборотнуюТару;
	СрокВозвратаМногооборотнойТары = УсловияПродаж.СрокВозвратаМногооборотнойТары;
	ТребуетсяЗалогЗаТару = УсловияПродаж.ТребуетсяЗалогЗаТару;
	
	ДатаДокумента = НачалоДня(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	
	Если ЗначениеЗаполнено(УсловияПродаж.ДатаОкончанияДействия) И УсловияПродаж.ДатаОкончанияДействия >= ДатаДокумента Тогда
		СрокДействия = УсловияПродаж.ДатаОкончанияДействия;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по умолчанию в коммерческом предложении
//
Процедура ЗаполнитьУсловияПродажПоУмолчанию() Экспорт
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер,КонтактноеЛицо);
	
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	
	Если ЗначениеЗаполнено (Партнер) ИЛИ НЕ ИспользоватьСоглашенияСКлиентами Тогда
		
		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
			Партнер,
			Новый Структура("УчитыватьГруппыСкладов,ВыбранноеСоглашение,ПустаяСсылкаДокумента", 
			Истина,
			Соглашение,
			Документы.КоммерческоеПредложениеКлиенту.ПустаяСсылка()));
		
		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
		
			Соглашение = УсловияПродажПоУмолчанию.Соглашение;
			ЗаполнитьУсловияПродаж(УсловияПродажПоУмолчанию);
			
			Если ИспользоватьСоглашенияСКлиентами Тогда
				СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
				ПродажиСервер.ЗаполнитьЦены(
					Товары, // Табличная часть
					, // Массив строк или структура отбора
					Новый Структура( // Параметры заполнения
						"Дата, Валюта, Соглашение, РасчитыватьНаборы, ПоляЗаполнения",
						Дата,
						Валюта,
						Соглашение,
						Истина,
						"Цена, СтавкаНДС, ВидЦены"
					),
					Новый Структура( // Структура действий с измененными строками
						"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС, ПересчитатьСуммуРучнойСкидки, ОчиститьАвтоматическуюСкидку, ПересчитатьСуммуСУчетомРучнойСкидки",
						"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы, "КоличествоУпаковок", Неопределено, Новый Структура("Очищать", Ложь)));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС) И ИспользоватьСоглашенияСКлиентами Тогда
		НалогообложениеНДС = ЗначениеНастроекПовтИсп.ПолучитьНалогообложениеНДС(Организация, Склад, Дата);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет условия продаж по соглашению в коммерческом предложении клиенту
//
Процедура ЗаполнитьУсловияПродажПоСоглашению() Экспорт
	
	УсловияПродаж = ПродажиСервер.ПолучитьУсловияПродаж(Соглашение, Истина);
	ЗаполнитьУсловияПродаж(УсловияПродаж);
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ЭтотОбъект);
	ПродажиСервер.ЗаполнитьЦены(
		Товары, // Табличная часть
		, // Массив строк или структура отбора
		Новый Структура( // Параметры заполнения
			"Дата, Валюта, Соглашение, РасчитыватьНаборы, ПоляЗаполнения",
			Дата,
			Валюта,
			Соглашение,
			Истина,
			"Цена, СтавкаНДС, ВидЦены"
		),
		Новый Структура( // Структура действий с измененными строками
			"ПересчитатьСумму, ПересчитатьСуммуСНДС, ПересчитатьСуммуНДС, ПересчитатьСуммуРучнойСкидки, ОчиститьАвтоматическуюСкидку, ПересчитатьСуммуСУчетомРучнойСкидки",
			"КоличествоУпаковок", СтруктураПересчетаСуммы, СтруктураПересчетаСуммы, "КоличествоУпаковок", Неопределено, Новый Структура("Очищать", Ложь)));
			
	Если Не ЗначениеЗаполнено(НалогообложениеНДС) Тогда
		НалогообложениеНДС = ЗначениеНастроекПовтИсп.ПолучитьНалогообложениеНДС(Организация, Склад, Дата);
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыКоммерческихПредложенийКлиентам[НовыйСтатус];
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполненНаОснованииДокумента = Ложь;

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.СделкиСКлиентами") Тогда
		ЗаполнитьДокументНаОснованииСделкиПоПродаже(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
		ЗаполнитьДокументНаОснованииИндивидуальногоСоглашенияСКлиентом(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.КоммерческоеПредложениеКлиенту") Тогда
		ЗаполнитьДокументНаОснованииКоммерческогоПредложенияКлиенту(ДанныеЗаполнения);
		ЗаполненНаОснованииДокумента = Истина;
	КонецЕсли;
	
	Если Не ЗаполненНаОснованииДокумента Тогда
		ИнициализироватьУсловияПродаж();
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(НалогообложениеНДС) Или Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		НалогообложениеНДС = ЗначениеНастроекПовтИсп.ПолучитьНалогообложениеНДС(Организация, Склад, Дата);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);

	// Срок действия коммерческого предложения должен быть не меньше даты документа
	Если ЗначениеЗаполнено(СрокДействия) И СрокДействия < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru='Срок действия должен быть не меньше даты коммерческого предложения'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		ТекстОшибки,
		ЭтотОбъект,
		"СрокДействия",
		,
		Отказ);
		
	КонецЕсли;
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	СуммаАктивногоВарианта = РассчитатьСуммуАктивногоВарианта();
	
	Если СуммаАктивногоВарианта <> СуммаДокумента Тогда
		СуммаДокумента = СуммаАктивногоВарианта;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиДокумента(ЭтотОбъект,
		РежимЗаписи,
		Перечисления.СтатусыКоммерческихПредложенийКлиентам.НеСогласовано);
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Документы.КоммерческоеПредложениеКлиенту.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Согласован         = Ложь;
	Статус             = Перечисления.СтатусыКоммерческихПредложенийКлиентам.НеСогласовано;
	СрокДействия       = '00010101';
	ДокументОснование  = Документы.КоммерческоеПредложениеКлиенту.ПустаяСсылка();
	СостояниеЗаполненияМногооборотнойТары = Перечисления.СостоянияЗаполненияМногооборотнойТары.ПустаяСсылка();
	
	СкидкиРассчитаны = Ложь;
	СкидкиНаценкиСервер.ОтменитьСкидки(ЭтотОбъект, "Товары", Истина,,Истина);
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Организация;

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Партнер;

КонецПроцедуры

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьДокументНаОснованииСделкиПоПродаже(Основание)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СделкиСКлиентами.Ссылка КАК Сделка,
	|	СделкиСКлиентами.Партнер КАК Партнер,
	|	СделкиСКлиентами.СоглашениеСКлиентом КАК Соглашение,
	|	СделкиСКлиентами.ПервичныйСпрос.(
	|		ИСТИНА КАК Активность,
	|		ТекстовоеОписание КАК ТекстовоеОписание
	|	) КАК ПервичныйСпрос,
	|	СделкиСКлиентамиПартнерыИКонтактныеЛица.КонтактноеЛицо КАК КонтактноеЛицо
	|ИЗ
	|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СделкиСКлиентами.ПартнерыИКонтактныеЛица КАК СделкиСКлиентамиПартнерыИКонтактныеЛица
	|		ПО СделкиСКлиентамиПартнерыИКонтактныеЛица.Ссылка = СделкиСКлиентами.Ссылка
	|			И (СделкиСКлиентамиПартнерыИКонтактныеЛица.Партнер = СделкиСКлиентами.Партнер
	|				И СделкиСКлиентамиПартнерыИКонтактныеЛица.КонтактноеЛицо <> ЗНАЧЕНИЕ(Справочник.КонтактныеЛицаПартнеров.ПустаяСсылка))
	|ГДЕ
	|	СделкиСКлиентами.Ссылка = &Основание");
	
	Запрос.УстановитьПараметр("Основание",Основание);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОснованииСделкиПоПродаже(Выборка.Партнер);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	Товары.Загрузить(Выборка.ПервичныйСпрос.Выгрузить());
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		Если ЗначениеЗаполнено(Выборка.Соглашение) Тогда
			ЗаполнитьУсловияПродажПоСоглашению();
		Иначе
			ЗаполнитьУсловияПродажПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииИндивидуальногоСоглашенияСКлиентом(Знач ДокументОснование)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СоглашениеСКлиентом.Ссылка          КАК Соглашение,
	|	СоглашениеСКлиентом.Партнер         КАК Партнер,
	|	СоглашениеСКлиентом.КонтактноеЛицо  КАК КонтактноеЛицо,
	|
	|	СоглашениеСКлиентом.Статус      КАК СтатусДокумента,
	|	ВЫБОР
	|		КОГДА
	|			СоглашениеСКлиентом.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСКлиентами.Действует)
	|		ТОГДА
	|			ЛОЖЬ
	|		ИНАЧЕ
	|			ИСТИНА
	|	КОНЕЦ КАК ЕстьОшибкиСтатус,
	|	СоглашениеСКлиентом.Типовое КАК ЕстьОшибкиТиповое
	|
	|ИЗ
	|	Справочник.СоглашенияСКлиентами  КАК СоглашениеСКлиентом
	|ГДЕ
	|	СоглашениеСКлиентом.Ссылка = &ДокументОснование
	|");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Выборка.Следующий();
	
	МассивДопустимыхСтатусов = Новый Массив();
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыСоглашенийСКлиентами.Действует);
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОснованииСоглашения(Выборка.ЕстьОшибкиТиповое);
		
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(Выборка.Соглашение,
		Выборка.СтатусДокумента,
		,
		Выборка.ЕстьОшибкиСтатус,
		МассивДопустимыхСтатусов);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	ЗаполнитьУсловияПродажПоСоглашению();
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииКоммерческогоПредложенияКлиенту(Знач ДокументОснование)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КоммерческоеПредложениеКлиенту.Ссылка                                КАК ДокументОснование,
	|	КоммерческоеПредложениеКлиенту.Партнер                               КАК Партнер,
	|	КоммерческоеПредложениеКлиенту.Сделка                                КАК Сделка,
	|	КоммерческоеПредложениеКлиенту.Организация                           КАК Организация,
	|	КоммерческоеПредложениеКлиенту.КонтактноеЛицо                        КАК КонтактноеЛицо,
	|	КоммерческоеПредложениеКлиенту.Валюта                                КАК Валюта,
	|	КоммерческоеПредложениеКлиенту.СуммаДокумента                        КАК СуммаДокумента,
	|	КоммерческоеПредложениеКлиенту.ГрафикОплаты                          КАК ГрафикОплаты,
	|	КоммерческоеПредложениеКлиенту.ДополнительнаяИнформация              КАК ДополнительнаяИнформация,
	|	КоммерческоеПредложениеКлиенту.Соглашение                            КАК Соглашение,
	|	КоммерческоеПредложениеКлиенту.СрокПоставки                          КАК СрокПоставки,
	|	КоммерческоеПредложениеКлиенту.Соглашение.ДатаОкончанияДействия      КАК СрокДействия,
	|	КоммерческоеПредложениеКлиенту.ЦенаВключаетНДС                       КАК ЦенаВключаетНДС,
	|	КоммерческоеПредложениеКлиенту.НалогообложениеНДС                    КАК НалогообложениеНДС,
	|	КоммерческоеПредложениеКлиенту.ФормаОплаты                           КАК ФормаОплаты,
	|	КоммерческоеПредложениеКлиенту.Склад                                 КАК Склад,
	|	КоммерческоеПредложениеКлиенту.ВернутьМногооборотнуюТару             КАК ВернутьМногооборотнуюТару,
	|	КоммерческоеПредложениеКлиенту.СрокВозвратаМногооборотнойТары        КАК СрокВозвратаМногооборотнойТары,
	|	КоммерческоеПредложениеКлиенту.СостояниеЗаполненияМногооборотнойТары КАК СостояниеЗаполненияМногооборотнойТары,
	|	КоммерческоеПредложениеКлиенту.ТребуетсяЗалогЗаТару                  КАК ТребуетсяЗалогЗаТару,
	|	КоммерческоеПредложениеКлиенту.КартаЛояльности                       КАК КартаЛояльности,
	|	КоммерческоеПредложениеКлиенту.ХозяйственнаяОперация                 КАК ХозяйственнаяОперация,
	|	КоммерческоеПредложениеКлиенту.Статус                                КАК СтатусДокумента,
	|	НЕ КоммерческоеПредложениеКлиенту.Проведен                           КАК ЕстьОшибкиПроведен,
	|	КоммерческоеПредложениеКлиенту.СпособДоставки                        КАК СпособДоставки,
	|
	|	КоммерческоеПредложениеКлиенту.Товары.(
	|		НоменклатураНабора,
	|		ХарактеристикаНабора,
	|		Номенклатура,
	|		Характеристика,
	|		Упаковка,
	|		КоличествоУпаковок,
	|		Количество,
	|		ВидЦены,
	|		Цена,
	|		ПроцентРучнойСкидки,
	|		СуммаРучнойСкидки,
	|		СтавкаНДС,
	|		СуммаНДС,
	|		СуммаСНДС,
	|		Сумма,
	|		Активность,
	|		ТекстовоеОписание
	|	) КАК Товары,
	|
	|	КоммерческоеПредложениеКлиенту.СкидкиНаценки.(
	|		КлючСвязи КАК КлючСвязи,
	|		СкидкаНаценка КАК СкидкаНаценка,
	|		Сумма КАК Сумма
	|	) КАК СкидкиНаценки
	|
	|ИЗ
	|	Документ.КоммерческоеПредложениеКлиенту КАК КоммерческоеПредложениеКлиенту
	|ГДЕ
	|	КоммерческоеПредложениеКлиенту.Ссылка = &ДокументОснование");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Выборка.ДокументОснование,
		,
		Выборка.ЕстьОшибкиПроведен);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	Товары.Загрузить(Выборка.Товары.Выгрузить());
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("ПрименятьКОбъекту",                Истина);
	СтруктураПараметры.Вставить("ТолькоПредварительныйРасчет",      Ложь);
	СтруктураПараметры.Вставить("ВосстанавливатьУправляемыеСкидки", Истина);
	СтруктураПараметры.Вставить("УправляемыеСкидки", Новый СписокЗначений);
	
	СкидкиНаценки.Загрузить(Выборка.СкидкиНаценки.Выгрузить());
	СкидкиНаценкиСервер.РассчитатьПоКоммерческомуПредложениюКлиенту(ЭтотОбъект, СтруктураПараметры);
	СкидкиРассчитаны = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
			ЗаполнитьУсловияПродажПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Менеджер       = Пользователи.ТекущийПользователь();
	Валюта         = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	Организация    = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад          = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад, ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи"));
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, КонтактноеЛицо);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСогласованиеКоммерческихПредложений")
	 Или ПраваПользователяПовтИсп.ОтклонениеОтУсловийПродаж() Тогда
		Статус = Перечисления.СтатусыКоммерческихПредложенийКлиентам.Действует;
	Иначе
		Статус = Перечисления.СтатусыКоммерческихПредложенийКлиентам.НеСогласовано;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьУсловияПродаж()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ЗаполнитьУсловияПродажПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция РассчитатьСуммуАктивногоВарианта()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.СуммаСНДС КАК СуммаСНДС,
	|	Товары.Активность КАК Активность
	|ПОМЕСТИТЬ
	|	Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(Товары.СуммаСНДС),0) КАК СуммаСНДС
	|ИЗ
	|	Товары КАК Товары
	|ГДЕ
	|	Товары.Активность
	|	И (Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ИЛИ НЕ &ВернутьМногооборотнуюТару
	|		ИЛИ &ТребуетсяЗалогЗаТару)
	|");
	
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить(,"Номенклатура,СуммаСНДС,Активность"));
	Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару", ВернутьМногооборотнуюТару);
	Запрос.УстановитьПараметр("ТребуетсяЗалогЗаТару", ТребуетсяЗалогЗаТару);
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	СуммаАктивногоВарианта = Выгрузка[0].СуммаСНДС;
	Возврат СуммаАктивногоВарианта;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
