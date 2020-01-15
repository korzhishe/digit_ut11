﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнтеграцияЕГАИС.ПровестиДокумент(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЗапросОстатковВРегистре2 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОстаткиПоДаннымЕГАИС.Справка2");
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияЕГАИСПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаписатьСтатусДокументаЕГАИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОстаткиПоДаннымЕГАИС.Очистить();
	КорректировкаОстатков.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьПоРасхождениям() Экспорт
	
	КорректировкаОстатков.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС", ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОстаткиАлкогольнойПродукцииЕГАИСОстатки.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ОстаткиАлкогольнойПродукцииЕГАИСОстатки.Справка2 КАК Справка2,
	|	ОстаткиАлкогольнойПродукцииЕГАИСОстатки.КоличествоОстаток КАК Количество
	|ПОМЕСТИТЬ ОстаткиПоУчету
	|ИЗ
	|	РегистрНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.Остатки(&Период, ОрганизацияЕГАИС = &ОрганизацияЕГАИС) КАК ОстаткиАлкогольнойПродукцииЕГАИСОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АлкогольнаяПродукция,
	|	Справка2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Справка2 КАК Справка2,
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Количество КАК Количество
	|ПОМЕСТИТЬ ОстаткиЕГАИС
	|ИЗ
	|	Документ.ОстаткиЕГАИС.ОстаткиПоДаннымЕГАИС КАК ОстаткиЕГАИСОстаткиПоДаннымЕГАИС
	|ГДЕ
	|	ОстаткиЕГАИСОстаткиПоДаннымЕГАИС.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АлкогольнаяПродукция,
	|	Справка2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиПоУчету.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ОстаткиПоУчету.Справка2,
	|	ЕСТЬNULL(ОстаткиЕГАИС.Количество, 0) - ОстаткиПоУчету.Количество КАК Количество
	|ИЗ
	|	ОстаткиПоУчету КАК ОстаткиПоУчету
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиЕГАИС КАК ОстаткиЕГАИС
	|		ПО ОстаткиПоУчету.АлкогольнаяПродукция = ОстаткиЕГАИС.АлкогольнаяПродукция
	|			И ОстаткиПоУчету.Справка2 = ОстаткиЕГАИС.Справка2
	|ГДЕ
	|	ЕСТЬNULL(ОстаткиЕГАИС.Количество, 0) - ОстаткиПоУчету.Количество <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОстаткиЕГАИС.АлкогольнаяПродукция,
	|	ОстаткиЕГАИС.Справка2,
	|	ОстаткиЕГАИС.Количество
	|ИЗ
	|	ОстаткиЕГАИС КАК ОстаткиЕГАИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиПоУчету КАК ОстаткиПоУчету
	|		ПО ОстаткиЕГАИС.АлкогольнаяПродукция = ОстаткиПоУчету.АлкогольнаяПродукция
	|			И ОстаткиЕГАИС.Справка2 = ОстаткиПоУчету.Справка2
	|ГДЕ
	|	ОстаткиПоУчету.Количество ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	АлкогольнаяПродукция
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	КорректировкаОстатков.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли