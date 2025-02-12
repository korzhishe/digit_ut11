﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияПодарочныхСертификатов") Тогда
		
		ЗаполнитьПоРеализацииПодарочныхСертификатов(
			ДанныеЗаполнения,
			ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ПодарочныеСертификаты") Тогда
		
		ЗаполнитьПоРеализацииПодарочныхСертификатов(
			ДанныеЗаполнения.ЧекККМ,
			ДанныеЗаполнения.ЧекККМ);
		ПодарочныеСертификаты.Очистить();
		
		ВозвращаемыеПодарочныеСертификаты = ПолучитьИзВременногоХранилища(ДанныеЗаполнения.ПодарочныеСертификаты);
		Для Каждого СтрокаТЧ Из ВозвращаемыеПодарочныеСертификаты Цикл
			
			НоваяСтрока = ПодарочныеСертификаты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Статус = Перечисления.СтатусыЧековККМ.Пробит И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru='Чек на возврат подарочных сертификатов пробит. Отмена проведения невозможна.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект);
			
		Возврат;
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаДокумента = ПодарочныеСертификаты.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ВозвратПодарочныхСертификатов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПодарочныеСертификатыСервер.ОтразитьПодарочныеСертификаты(ДополнительныеСвойства, Движения, Отказ);
	ПодарочныеСертификатыСервер.ОтразитьИсториюПодарочныхСертификатов(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваВКассахККМ(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыПоЭквайрингу(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваВПути(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваКонтрагент(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Документ ""Возврат подарочных сертификатов"" вводится только на основании документа ""Реализация подарочных сертификатов"".'");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПодарочныеСертификатыСервер.ПроверитьЗаполнениеПодарочныхСертификатов(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Документы.СчетФактураВыданныйАванс.СформироватьДвиженияПоКнигамПокупокПродаж(Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

// Процедура заполнения документа на основании расходного кассового ордера.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств - Заявка на платеж
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоРеализацииПодарочныхСертификатов(
	Знач ДокументОснование,
	ДанныеЗаполнения)
	
	// Заполним данные шапки документа.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	РеализацияПодарочныхСертификатов.Валюта        КАК Валюта,
	|	РеализацияПодарочныхСертификатов.Ссылка        КАК ЧекККМ,
	|	РеализацияПодарочныхСертификатов.Организация   КАК Организация,
	|	РеализацияПодарочныхСертификатов.КассаККМ      КАК КассаККМ,
	|	РеализацияПодарочныхСертификатов.КассоваяСмена КАК КассоваяСмена,
	|	РеализацияПодарочныхСертификатов.Статус        КАК Статус,
	|	РеализацияПодарочныхСертификатов.Проведен      КАК Проведен
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов КАК РеализацияПодарочныхСертификатов
	|ГДЕ
	|	РеализацияПодарочныхСертификатов.Ссылка = &Ссылка
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	1 КАК Количество,
	|	ПодарочныеСертификаты.Сумма КАК Сумма
	|ПОМЕСТИТЬ врПодарочныеСертификаты
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	-1 КАК Количество,
	|	-ПодарочныеСертификаты.Сумма КАК Сумма
	|ИЗ
	|	Документ.ВозвратПодарочныхСертификатов.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка.РеализацияПодарочныхСертификатов = &Ссылка
	|	И ПодарочныеСертификаты.Ссылка.Проведен
	|	И ПодарочныеСертификаты.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	СУММА(ПодарочныеСертификаты.Количество) КАК Количество,
	|	СУММА(ПодарочныеСертификаты.Сумма)      КАК Сумма
	|ИЗ
	|	врПодарочныеСертификаты КАК ПодарочныеСертификаты
	|СГРУППИРОВАТЬ ПО
	|	ПодарочныеСертификаты.ПодарочныйСертификат
	|ИМЕЮЩИЕ
	|	СУММА(ПодарочныеСертификаты.Количество) > 0
	|;
	|
	|///////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОплатаПлатежнымиКартами.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ОплатаПлатежнымиКартами.НомерПлатежнойКарты   КАК НомерПлатежнойКарты,
	|	ОплатаПлатежнымиКартами.Сумма                 КАК Сумма,
	|	ОплатаПлатежнымиКартами.СсылочныйНомер        КАК СсылочныйНомер,
	|	ОплатаПлатежнымиКартами.НомерЧекаЭТ           КАК НомерЧекаЭТ
	|ИЗ
	|	Документ.РеализацияПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК ОплатаПлатежнымиКартами
	|ГДЕ
	|	ОплатаПлатежнымиКартами.Ссылка = &Ссылка
	|	И Не (ОплатаПлатежнымиКартами.ЭквайринговыйТерминал, ОплатаПлатежнымиКартами.НомерПлатежнойКарты, ОплатаПлатежнымиКартами.Сумма) В (ВЫБРАТЬ Т.ЭквайринговыйТерминал, Т.НомерПлатежнойКарты, Т.Сумма ИЗ Документ.ВозвратПодарочныхСертификатов.ОплатаПлатежнымиКартами КАК Т ГДЕ Т.Ссылка.РеализацияПодарочныхСертификатов = &Ссылка)
	|";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, ,"Статус, Проведен");
	
	Если РезультатЗапроса[2].Пустой() Тогда
		
		ТекстОшибки = НСтр("ru='По данному чеку ККМ все подарочные сертификаты уже возвращены.'");
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	ТекстОшибки = "";
	Если НЕ РозничныеПродажи.СменаОткрыта(Выборка.КассоваяСмена, ТекущаяДатаСеанса(), ТекстОшибки) Тогда
		
		ТекстОшибки = ТекстОшибки + " " + НСтр("ru='Ввод на основании невозможен.'");
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если НЕ Выборка.Проведен Тогда
		
		ТекстОшибки = НСтр("ru='Документ ""Реализация подарочных сертификатов"" не проведен. Ввод на основании невозможен.'");
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Если Выборка.Статус <> Перечисления.СтатусыЧековККМ.Пробит Тогда
		
		ТекстОшибки = НСтр("ru='Чек ""Реализация подарочных сертификатов"" не пробит. Ввод на основании невозможен.'");
		
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	ПодарочныеСертификаты.Загрузить(РезультатЗапроса[2].Выгрузить());
	ОплатаПлатежнымиКартами.Загрузить(РезультатЗапроса[3].Выгрузить());
	
	РеализацияПодарочныхСертификатов = ДокументОснование;
	
	СуммаДокумента = ПодарочныеСертификаты.Итог("Сумма");
	
КонецПроцедуры

// Инициализирует реализация товаров и услуг.
//	ДокументОбъект - Объект, который будет заполнен
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта      = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	Кассир      = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.ПодарочныеСертификаты);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
