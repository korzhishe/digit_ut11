﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос(
	// 0 ТаблицаУдалитьДействиеСкидокНаценок
	"ВЫБРАТЬ
	|	СкидкиНаценки.Склад КАК Склад,
	|	СкидкиНаценки.СкидкаНаценка КАК СкидкаНаценка,
	|	СкидкиНаценки.ДатаНачала КАК Период,
	|	ВЫБОР
	|		КОГДА СкидкиНаценки.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ КОНЕЦПЕРИОДА(СкидкиНаценки.ДатаОкончания, ДЕНЬ)
	|	КОНЕЦ КАК ДатаОкончания,
	|	СкидкиНаценки.Ссылка.СегментПартнеров КАК СегментПартнеров
	|ИЗ
	|	Документ.УдалитьУстановкаСкидокНаценок.СкидкиНаценки КАК СкидкиНаценки
	|ГДЕ
	|	СкидкиНаценки.Ссылка = &Ссылка");

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результат = Запрос.ВыполнитьПакет();

	ДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаУдалитьДействиеСкидокНаценок", Результат[0].Выгрузить());

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли