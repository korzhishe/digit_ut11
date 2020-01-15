﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет наличие отрицательных остатков товаров организаций, наличие "развернутого" сальдо по видам запасов,
// возможность оформления передач товаров между организациями.
//
// Параметры:
//	Параметры - Структура - содержит свойства
//		* ДатаНачала - Дата - начальная дата проверки остатков
//		* ДатаОкончания - Дата - конечная дата проверки остатков
//		* МассивОрганизаций - Массив - организации, для которых выполняется проверка остатков
//	АдресХранилища - Строка - адрес во временном хранилище
//
Функция ПолучитьСостояниеОстатковТоваровОрганизаций(Параметры, АдресХранилища = Неопределено) Экспорт
	
	Запрос = Новый Запрос(ЗакрытиеМесяцаСервер.ЗапросОтрицательныеОстаткиТоваровОрганизаций() + "
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|" +
	"ВЫБРАТЬ
	|	Остатки.Период КАК Период,
	|	Остатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Остатки.Организация КАК Организация,
	|	Остатки.ВидЗапасов КАК ВидЗапасов,
	|	Остатки.НомерГТД КАК НомерГТД,
	|	СУММА(Остатки.Количество) КАК Количество,
	|	СУММА(Остатки.Оборот) КАК Оборот
	|ПОМЕСТИТЬ ТаблицаОстатков
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыОрганизацийОстаткиИОбороты.Период КАК Период,
	|		ТоварыОрганизацийОстаткиИОбороты.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизацийОстаткиИОбороты.Организация КАК Организация,
	|		ТоварыОрганизацийОстаткиИОбороты.ВидЗапасов КАК ВидЗапасов,
	|		ТоварыОрганизацийОстаткиИОбороты.НомерГТД КАК НомерГТД,
	|		ТоварыОрганизацийОстаткиИОбороты.КоличествоКонечныйОстаток КАК Количество,
	|		ТоварыОрганизацийОстаткиИОбороты.КоличествоОборот КАК Оборот
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций.ОстаткиИОбороты(
	|				&ГраницаКонецПредыдущегоПериода,
	|				&ГраницаКонецПериода,
	|				Месяц,
	|				,
	|				АналитикаУчетаНоменклатуры В
	|						(ВЫБРАТЬ
	|							ОтрицательныеОстатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|						ИЗ
	|							ОтрицательныеОстатки КАК ОтрицательныеОстатки)
	|					И Организация В (&МассивОрганизаций)
	|				) КАК ТоварыОрганизацийОстаткиИОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Резервы.Период,
	|		Резервы.АналитикаУчетаНоменклатуры,
	|		Резервы.Организация,
	|		Резервы.ВидЗапасов,
	|		Резервы.НомерГТД,
	|		Резервы.КоличествоКонечныйОстаток,
	|		Резервы.КоличествоОборот
	|	ИЗ
	|		РегистрНакопления.РезервыТоваровОрганизаций.ОстаткиИОбороты(
	|				&ГраницаКонецПредыдущегоПериода,
	|				&ГраницаКонецПериода,
	|				Месяц,
	|				,
	|				АналитикаУчетаНоменклатуры В
	|						(ВЫБРАТЬ
	|							ОтрицательныеОстатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|						ИЗ
	|							ОтрицательныеОстатки КАК ОтрицательныеОстатки)
	|					И Организация В (&МассивОрганизаций)
	|				) КАК Резервы) КАК Остатки
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.НомерГТД,
	|	Остатки.ВидЗапасов,
	|	Остатки.Организация,
	|	Остатки.АналитикаУчетаНоменклатуры,
	|	Остатки.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОстатков.Организация КАК Организация,
	|	ТаблицаОстатков.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаОстатков.Период КАК Период
	|ПОМЕСТИТЬ ВтОтрицательныеОстаткиОрганизацияАналитика
	|ИЗ
	|	ТаблицаОстатков КАК ТаблицаОстатков
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаОстатков.Организация,
	|	ТаблицаОстатков.АналитикаУчетаНоменклатуры,
	|	ТаблицаОстатков.Период
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаОстатков.Количество) < 0 И
	|	СУММА(ТаблицаОстатков.Оборот) < 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	АналитикаУчетаНоменклатуры,
	|	Период
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОстатков.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаОстатков.Период КАК Период
	|ПОМЕСТИТЬ ВтОтсутствующиеТовары
	|ИЗ
	|	ТаблицаОстатков КАК ТаблицаОстатков
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаОстатков.АналитикаУчетаНоменклатуры,
	|	ТаблицаОстатков.Период
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаОстатков.Количество) < 0 И
	|	СУММА(ТаблицаОстатков.Оборот) < 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры,
	|	Период
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|// ОТРИЦАТЕЛЬНЫЕ ОСТАТКИ ТОВАРОВ ОРГАНИЗАЦИЙ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтрицательныеОстаткиОрганизацияАналитика.Период КАК Период
	|ИЗ
	|	ВтОтрицательныеОстаткиОрганизацияАналитика КАК ОтрицательныеОстаткиОрганизацияАналитика
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период ВОЗР
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|// РАЗВЕРНУТОЕ САЛЬДО ПО ТОВАРАМ ОРГАНИЗАЦИЙ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыОрганизаций.Период КАК Период
	|ИЗ (
	|	ВЫБРАТЬ
	|		ОтрицательныеОстатки.Организация КАК Организация,
	|		ОтрицательныеОстатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ОтрицательныеОстатки.ВидЗапасов КАК ВидЗапасов,
	|		ОтрицательныеОстатки.НомерГТД КАК НомерГТД,
	|		ОтрицательныеОстатки.Период
	|	ИЗ
	|		ОтрицательныеОстатки КАК ОтрицательныеОстатки
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ВтОтрицательныеОстаткиОрганизацияАналитика КАК ОтрицательныеОстаткиОрганизацияАналитика
	|		ПО
	|			ОтрицательныеОстатки.Организация = ОтрицательныеОстаткиОрганизацияАналитика.Организация
	|			И ОтрицательныеОстатки.АналитикаУчетаНоменклатуры = ОтрицательныеОстаткиОрганизацияАналитика.АналитикаУчетаНоменклатуры
	|			И ОтрицательныеОстатки.Период = ОтрицательныеОстаткиОрганизацияАналитика.Период
	|	ГДЕ
	|		ОтрицательныеОстаткиОрганизацияАналитика.Период ЕСТЬ NULL
	|	) КАК ТоварыОрганизаций
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период ВОЗР
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|// НЕДОСТАТОЧНО ТОВАРОВ ОРГАНИЗАЦИЙ НА СКЛАДАХ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтсутствующиеТовары.Период КАК Период
	|ИЗ
	|	ВтОтсутствующиеТовары КАК ОтсутствующиеТовары
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период ВОЗР
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|// МОЖНО ОФОРМИТЬ ПЕРЕДАЧИ ТОВАРОВ МЕЖДУ ОРГАНИЗАЦИЯМИ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыОрганизаций.Период КАК Период
	|ИЗ (
	|	ВЫБРАТЬ
	|		ОтрицательныеОстаткиОрганизацияАналитика.Организация КАК Организация,
	|		ОтрицательныеОстаткиОрганизацияАналитика.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ОтрицательныеОстаткиОрганизацияАналитика.Период КАК Период
	|	ИЗ
	|		ВтОтрицательныеОстаткиОрганизацияАналитика КАК ОтрицательныеОстаткиОрганизацияАналитика
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			ВтОтсутствующиеТовары КАК ОтсутствующиеТовары
	|		ПО
	|			ОтрицательныеОстаткиОрганизацияАналитика.АналитикаУчетаНоменклатуры = ОтсутствующиеТовары.АналитикаУчетаНоменклатуры
	|			И ОтрицательныеОстаткиОрганизацияАналитика.Период = ОтсутствующиеТовары.Период
	|	ГДЕ
	|		ОтсутствующиеТовары.Период ЕСТЬ NULL
	|
	|	) КАК ТоварыОрганизаций
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период ВОЗР
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|");
	
	Запрос.УстановитьПараметр("ГраницаКонецПредыдущегоПериода", 	Параметры.ДатаНачала);
	Запрос.УстановитьПараметр("ГраницаКонецПериода",				Параметры.ДатаОкончания);
	Запрос.УстановитьПараметр("МассивОрганизаций", 					Параметры.МассивОрганизаций);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Если ЗначениеЗаполнено(АдресХранилища) Тогда
		ПоместитьВоВременноеХранилище(МассивРезультатов, АдресХранилища);
	КонецЕсли;
	
	Возврат МассивРезультатов;
	
КонецФункции

#КонецОбласти

#КонецЕсли
