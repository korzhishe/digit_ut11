﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имя константы, хранящей номер задания для данного регистра.
// 
//Возвращаемое значение:
//	Строка - Строковое предствление имени константы НомерЗаданияКФормированиюЗаписейКнигиПокупокПродаж
Функция ИмяКонстантыНомераЗадания() Экспорт
	
	Возврат Метаданные.Константы.НомерЗаданияКФормированиюЗаписейКнигиПокупокПродаж.Имя;
	
КонецФункции

// Увеличивает значение номера задания в константе.
//
// Возвращаемое значение:
//	Число - Новый номер задания из константы НомерЗаданияКФормированиюЗаписейКнигиПокупокПродаж
//
Функция УвеличитьНомерЗадания() Экспорт
	
	Возврат ЗакрытиеМесяцаСервер.УвеличитьНомерЗадания(ИмяКонстантыНомераЗадания());
	
КонецФункции

// Возвращает значение номера задани из константы.
//
// Возвращаемое значение:
//	Число - Номер текущего задания из константы НомерЗаданияКФормированиюЗаписейКнигиПокупокПродаж
//
Функция ПолучитьНомерЗадания() Экспорт
	
	Возврат ЗакрытиеМесяцаСервер.ТекущийНомерЗадания(ИмяКонстантыНомераЗадания());
	
КонецФункции

// Метод создает запись регистра с заданными параметрами.
//
// Параметры:
//	ПериодЗадания   - Дата - Начало периода, для которого необходимо зарегистрировать задание к расчету
//	СчетФактура - ДокументСсылка - документ регистратор создавший движение в зависимых регистрах
//	Организация - СправочникСсылка.Организации - организация, по которой необходим перерасчет
//  НомерЗадания - Число - номер задания; если не задано, то будет установлено значение из соответствующей константы
//
Процедура СоздатьЗаписьРегистра(ПериодЗадания, СчетФактура, Организация, НомерЗадания = Неопределено) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// В РИБ данный регистр обрабатывается только в главном узле.
		Возврат;
	КонецЕсли;
	
	Если НомерЗадания = Неопределено Тогда
		НомерЗадания = ПолучитьНомерЗадания();
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ЗаданияКФормированиюЗаписейКнигиПокупокПродаж.СоздатьМенеджерЗаписи();
	НаборЗаписей.Месяц        = НачалоМесяца(ПериодЗадания);
	НаборЗаписей.СчетФактура  = СчетФактура;
	НаборЗаписей.Организация  = Организация;
	НаборЗаписей.НомерЗадания = НомерЗадания;
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

// Метод создает записи регистра с параметрами, полученными запросом.
//
// Параметры:
//	Выборка - ВыборкаИзРезультатаЗапроса - выборка, содержащая данные для формирования записей.
//  НомерЗадания - Число - номер задания; если не задано, то будет установлено значение из соответствующей константы.
//
Процедура СоздатьЗаписиРегистраПоДаннымВыборки(Выборка, НомерЗадания = Неопределено) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// В РИБ данный регистр обрабатывается только в главном узле.
		Возврат;
	КонецЕсли;
	
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		СтруктураПолей = Новый Структура("Месяц, Организация, СчетФактура");
		
		Если НомерЗадания = Неопределено Тогда
			НомерЗадания = ПолучитьНомерЗадания();
		КонецЕсли;
		
		Пока Выборка.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(СтруктураПолей, Выборка);
			
			СоздатьЗаписьРегистра(СтруктураПолей.Месяц, СтруктураПолей.СчетФактура, СтруктураПолей.Организация, НомерЗадания);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстОшибки    = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось сформировать задание к формированию записей книги покупок/продаж за %1 в организации %2 по причине: %3'"),
			Выборка.Месяц,
			Выборка.Организация,
			ТекстОшибки);
			
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Учет НДС'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения);
		
	КонецПопытки;
	
КонецПроцедуры

// Создает записи регистра по данным документов, влияющих на учет НДС
//
// Параметры:
//   МассивДокументов - Массив - ссылки на документы.
//
Процедура СформироватьЗаданияПоДокументам(МассивДокументов) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// В РИБ данный регистр обрабатывается только в главном узле.
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Тип");
	Таблица.Колонки.Добавить("Ссылка");
	
	Для Каждого Документ Из МассивДокументов Цикл
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.Ссылка = Документ.Ссылка;
		НоваяСтрока.Тип    = ТипЗнч(Документ.Ссылка);
	КонецЦикла;
	Таблица.Сортировать("Тип");
	
	ТаблицаТипов = Таблица.Скопировать(, "Тип");
	ТаблицаТипов.Свернуть("Тип");
	
	Для Каждого СтрокаТипа Из ТаблицаТипов Цикл
		
		Отбор = Новый Структура("Тип", СтрокаТипа.Тип);
		МассивСсылок = Таблица.Скопировать(Отбор, "Ссылка").ВыгрузитьКолонку("Ссылка");
		
		Если СтрокаТипа.Тип = Тип("ДокументСсылка.ЗаявлениеОВвозеТоваров") Тогда
			СформироватьЗаданияПоДокументамЗаявлениеОВвозеТоваров(МассивСсылок);
		ИначеЕсли СтрокаТипа.Тип = Тип("ДокументСсылка.РаспределениеНДС") Тогда
			СформироватьЗаданияПоДокументамРаспределениеНДС(МассивСсылок);
		ИначеЕсли СтрокаТипа.Тип = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
			СформироватьЗаданияПоДокументамСчетФактураВыданный(МассивСсылок);
		ИначеЕсли СтрокаТипа.Тип = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
			СформироватьЗаданияПоДокументамСчетФактураПолученный(МассивСсылок);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает перечень объектов метаданных, на основании данных которых формируются записи в регистре.
//
// Возвращаемое значение:
//   Массив - элементы - ОбъектМетаданных, при получении которых в процессе обмена надо формировать зписи в регистре.
//
Функция ВходящиеДанныеМеханизма() Экспорт
	
	ВходящиеДанные = Новый Массив;
	
	// Документы
	
	ВходящиеДанные.Добавить(Метаданные.Документы.ЗаявлениеОВвозеТоваров);
	ВходящиеДанные.Добавить(Метаданные.Документы.РаспределениеНДС);
	ВходящиеДанные.Добавить(Метаданные.Документы.СчетФактураВыданный);
	ВходящиеДанные.Добавить(Метаданные.Документы.СчетФактураПолученный);
	ВходящиеДанные.Добавить(Метаданные.Документы.СчетФактураНалоговыйАгент);
	ВходящиеДанные.Добавить(Метаданные.Документы.ТаможеннаяДекларацияИмпорт);
	
	// Регистры накопления
	
	ВходящиеДанные.Добавить(Метаданные.РегистрыНакопления.НДСПредъявленный);
	
	// Регистры сведений
	
	ВходящиеДанные.Добавить(Метаданные.РегистрыСведений.НДССостояниеРеализации0);
	
	Возврат ВходящиеДанные;
	
КонецФункции

// Добавляет описания регистров для их подключения к механизму дат запрета изменения.
//
Процедура ОписаниеРегистровДляКонтроляДатЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.НДСПредъявленный", "Период", "РегламентныеОперации");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.СостоянияБлокировкиВычетаНДСПоСчетамФактурам", "Период", "РегламентныеОперации");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьЗаданияПоДокументамЗаявлениеОВвозеТоваров(МассивСсылок)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ПодтверждениеОплатыНДСВБюджет.ДатаПодтвержденияОплаты, МЕСЯЦ) КАК Месяц,
	|	Операция.Организация КАК Организация,
	|	Операция.Ссылка КАК СчетФактура
	|ИЗ
	|	РегистрСведений.ПодтверждениеОплатыНДСВБюджет КАК ПодтверждениеОплатыНДСВБюджет
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявлениеОВвозеТоваров КАК Операция
	|		ПО ПодтверждениеОплатыНДСВБюджет.СчетФактура = Операция.Ссылка
	|ГДЕ
	|	Операция.Ссылка В(&Ссылка)
	|	И ПодтверждениеОплатыНДСВБюджет.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОплатыНДСВБюджет.ПолученоПодтверждение)";
	
	Запрос.УстановитьПараметр("Ссылка", МассивСсылок);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	
	СоздатьЗаписиРегистраПоДаннымВыборки(Выборка);
	
КонецПроцедуры

Процедура СформироватьЗаданияПоДокументамРаспределениеНДС(МассивСсылок)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Партии.Период, МЕСЯЦ) КАК Месяц,
	|	Партии.Организация КАК Организация,
	|	Партии.ДокументПоступленияРасходов КАК СчетФактура
	|ИЗ
	|	РегистрНакопления.ПартииПрочихРасходов КАК Партии
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПартий КАК КлючиАналитикиУчетаПартий
	|		ПО Партии.АналитикаУчетаПартий = КлючиАналитикиУчетаПартий.Ссылка
	|ГДЕ
	|	Партии.НалогообложениеНДС <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|	И Партии.НалогообложениеНДС <> КлючиАналитикиУчетаПартий.НалогообложениеНДС
	|	И Партии.Регистратор В(&Ссылка)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(НДСПредъявленный.Период, МЕСЯЦ) КАК Месяц,
	|	НДСПредъявленный.Организация КАК Организация,
	|	НДСПредъявленный.СчетФактура КАК СчетФактура
	|ИЗ
	|	РегистрНакопления.НДСПредъявленный КАК НДСПредъявленный
	|ГДЕ
	|	НДСПредъявленный.Регистратор В (&Ссылка)
	|	И НДСПредъявленный.РегламентнаяОперация";
	
	Запрос.УстановитьПараметр("Ссылка", МассивСсылок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	СоздатьЗаписиРегистраПоДаннымВыборки(Выборка);
	
КонецПроцедуры

Процедура СформироватьЗаданияПоДокументамСчетФактураВыданный(МассивСсылок)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Операция.Дата, МЕСЯЦ) КАК Месяц,
	|	Операция.Контрагент КАК Организация,
	|	ТаблицаДокументыОснования.ДокументОснование КАК СчетФактура
	|ИЗ
	|	Документ.СчетФактураВыданный КАК Операция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный.ДокументыОснования КАК ТаблицаДокументыОснования
	|		ПО Операция.Ссылка = ТаблицаДокументыОснования.Ссылка
	|ГДЕ
	|	Операция.Контрагент ССЫЛКА Справочник.Организации
	|	И Операция.Ссылка В(&Ссылка)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(НДСПредъявленный.Период, МЕСЯЦ) КАК Месяц,
	|	НДСПредъявленный.Организация КАК Организация,
	|	НДСПредъявленный.СчетФактура КАК СчетФактура
	|ИЗ
	|	РегистрНакопления.НДСПредъявленный КАК НДСПредъявленный
	|ГДЕ
	|	НДСПредъявленный.Регистратор В (&Ссылка)
	|	И НДСПредъявленный.РегламентнаяОперация
	|";
	
	Запрос.УстановитьПараметр("Ссылка", МассивСсылок);
	
	Выборка = Запрос.Выполнить().Выбрать();
	СоздатьЗаписиРегистраПоДаннымВыборки(Выборка);
	
КонецПроцедуры

Процедура СформироватьЗаданияПоДокументамСчетФактураПолученный(МассивСсылок)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ДокументыОснования.Ссылка.Дата, МЕСЯЦ) КАК Месяц,
	|	ДокументыОснования.Ссылка.Организация КАК Организация,
	|	ДокументыОснования.ДокументОснование КАК СчетФактура
	|ПОМЕСТИТЬ ВТ_ДокументыОснования
	|ИЗ
	|	Документ.СчетФактураПолученный.ДокументыОснования КАК ДокументыОснования
	|ГДЕ
	|	ДокументыОснования.Ссылка В(&Ссылка)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ДокументыОснования.Ссылка.ДатаЗаписиКнигиПокупок, МЕСЯЦ) КАК Месяц,
	|	ДокументыОснования.Ссылка.Организация КАК Организация,
	|	ДокументыОснования.ДокументОснование КАК СчетФактура
	|ИЗ
	|	Документ.СчетФактураПолученный.ДокументыОснования КАК ДокументыОснования
	|ГДЕ
	|	ДокументыОснования.Ссылка В(&Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ДокументыОснования.Месяц КАК Месяц,
	|	ВТ_ДокументыОснования.Организация КАК Организация,
	|	ВТ_ДокументыОснования.СчетФактура КАК СчетФактура
	|ИЗ
	|	ВТ_ДокументыОснования КАК ВТ_ДокументыОснования
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ДокументыОснования.Месяц,
	|	ВТ_ДокументыОснования.Организация,
	|	КорректировкаПриобретения.ДокументОснование
	|ИЗ
	|	ВТ_ДокументыОснования КАК ВТ_ДокументыОснования
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КорректировкаПриобретения КАК КорректировкаПриобретения
	|		ПО ВТ_ДокументыОснования.СчетФактура = КорректировкаПриобретения.Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ДокументыОснования.Месяц,
	|	ВТ_ДокументыОснования.Организация,
	|	ДругиеКорректировкиОснования.Ссылка
	|ИЗ
	|	ВТ_ДокументыОснования КАК ВТ_ДокументыОснования
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КорректировкаПриобретения КАК КорректировкаПриобретенияОснование
	|		ПО ВТ_ДокументыОснования.СчетФактура = КорректировкаПриобретенияОснование.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.КорректировкаПриобретения КАК ДругиеКорректировкиОснования
	|		ПО (КорректировкаПриобретенияОснование.ДокументОснование = ДругиеКорректировкиОснования.ДокументОснование)
	|			И (ДругиеКорректировкиОснования.ВидКорректировки = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КорректировкаПоСогласованиюСторон))
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(НДСПредъявленный.Период, МЕСЯЦ) КАК Месяц,
	|	НДСПредъявленный.Организация КАК Организация,
	|	НДСПредъявленный.СчетФактура КАК СчетФактура
	|ИЗ
	|	РегистрНакопления.НДСПредъявленный КАК НДСПредъявленный
	|ГДЕ
	|	НДСПредъявленный.Регистратор В (&Ссылка)
	|	И НДСПредъявленный.РегламентнаяОперация
	|";
	
	Запрос.УстановитьПараметр("Ссылка", МассивСсылок);
	Выборка = Запрос.Выполнить().Выбрать();
	СоздатьЗаписиРегистраПоДаннымВыборки(Выборка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
