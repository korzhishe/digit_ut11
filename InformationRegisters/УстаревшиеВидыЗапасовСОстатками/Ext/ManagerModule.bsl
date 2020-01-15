﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ОбновитьЗаписи(ОтборПоВидамЗапасов = Неопределено) Экспорт
	
	Если ОтборПоВидамЗапасов <> Неопределено
		И ОтборПоВидамЗапасов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТУстаревшиеВидыЗапасов
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	(ВидыЗапасов.Устаревший
	|			ИЛИ ВидыЗапасов.ЭтоДубль)
	|	И (&ПоВсемВидамЗапасов
	|			ИЛИ ВидыЗапасов.Ссылка В (&ОтборПоВидамЗапасов))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВложенныйЗапрос.ВидЗапасов КАК ВидЗапасов
	|ПОМЕСТИТЬ ВТУстаревшиеВидыЗапасовСОстатками
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТоварыОрганизацийОстатки.Организация КАК Организация,
	|		ТоварыОрганизацийОстатки.ВидЗапасов КАК ВидЗапасов,
	|		ТоварыОрганизацийОстатки.НомерГТД КАК НомерГТД
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций.Остатки(
	|				,
	|				ВидЗапасов В
	|					(ВЫБРАТЬ
	|						ВТ.Ссылка
	|					ИЗ
	|						ВТУстаревшиеВидыЗапасов КАК ВТ)) КАК ТоварыОрганизацийОстатки) КАК ВложенныйЗапрос
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.ВидЗапасов КАК ВидЗапасов,
	|	СУММА(ВложенныйЗапрос.Контроль) > 0 КАК Добавить
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТУстаревшиеВидыЗапасовСОстатками.ВидЗапасов КАК ВидЗапасов,
	|		1 КАК Контроль
	|	ИЗ
	|		ВТУстаревшиеВидыЗапасовСОстатками КАК ВТУстаревшиеВидыЗапасовСОстатками
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		УстаревшиеВидыЗапасовСОстатками.ВидЗапасов,
	|		-1
	|	ИЗ
	|		РегистрСведений.УстаревшиеВидыЗапасовСОстатками КАК УстаревшиеВидыЗапасовСОстатками
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТУстаревшиеВидыЗапасов КАК ВТУстаревшиеВидыЗапасов
	|			ПО УстаревшиеВидыЗапасовСОстатками.ВидЗапасов = ВТУстаревшиеВидыЗапасов.Ссылка
	|	ГДЕ
	|		(НЕ ВТУстаревшиеВидыЗапасов.Ссылка ЕСТЬ NULL
	|				ИЛИ НЕ(УстаревшиеВидыЗапасовСОстатками.ВидЗапасов.Устаревший
	|						ИЛИ УстаревшиеВидыЗапасовСОстатками.ВидЗапасов.ЭтоДубль))) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ВидЗапасов
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВложенныйЗапрос.Контроль) <> 0";
	
	Если ОтборПоВидамЗапасов = Неопределено Тогда
		Запрос.УстановитьПараметр("ПоВсемВидамЗапасов", Истина);
		Запрос.УстановитьПараметр("ОтборПоВидамЗапасов", Новый Массив);
	Иначе
		Запрос.УстановитьПараметр("ПоВсемВидамЗапасов", Ложь);
		Запрос.УстановитьПараметр("ОтборПоВидамЗапасов", ОтборПоВидамЗапасов);
	КонецЕсли;		
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Набор = РегистрыСведений.УстаревшиеВидыЗапасовСОстатками.СоздатьНаборЗаписей();
		Набор.Отбор.ВидЗапасов.Установить(Выборка.ВидЗапасов);
		
		Если Выборка.Добавить Тогда
			СтрокаНабора = Набор.Добавить();
			СтрокаНабора.ВидЗапасов = Выборка.ВидЗапасов;
		КонецЕсли;
		
		Набор.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
	
#КонецЕсли