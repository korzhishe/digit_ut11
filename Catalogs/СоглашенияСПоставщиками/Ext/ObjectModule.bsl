﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет реквизиты документа по умолчанию
//
Процедура ЗаполнитьРеквизитыПоУмолчанию() Экспорт
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.Партнеры") Тогда
		ЗаполнитьДокументНаОснованииПартнера(ДанныеЗаполнения);
	КонецЕсли;

	ИнициализироватьСправочник();
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам") Тогда
		ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Дата начала действия соглашения должна быть не меньше, чем дата документа.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаНачалаДействия) Тогда	
			
		Если НачалоДня(Дата) > ДатаНачалаДействия Тогда
				
			ТекстОшибки = НСтр("ru='Дата начала действия соглашения должна быть не меньше даты соглашения'");

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"ДатаНачалаДействия",
				,
				Отказ);

		Конецесли;

	КонецЕсли;

	// Дата окончания действия соглашения должна быть не меньше, чем дата документа.
	Если ЗначениеЗаполнено(Дата) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда	
			
		Если НачалоДня(Дата) > ДатаОкончанияДействия Тогда
				
			ТекстОшибки = НСтр("ru='Дата окончания действия соглашения должна быть не меньше даты соглашения'");

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"ДатаОкончанияДействия",
				,
				Отказ);

		Конецесли;

	КонецЕсли;

	// Дата окончания действия соглашения должна быть не меньше, чем дата начала действия.
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда
				
		Если ДатаНачалаДействия > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания действия соглашения должна быть не меньше даты начала действия'");

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"ДатаОкончанияДействия",
				,
				Отказ);
		
		Конецесли;

	КонецЕсли;

	Если РассчитыватьДатуВозвратаТарыПоКалендарю И ВозвращатьМногооборотнуюТару И Не ЗначениеЗаполнено(КалендарьВозвратаТары) Тогда
		
		ТекстОшибки = НСтр("ru='Не указан календарь для учета возврата тары по рабочим дням.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"Объект.КалендарьВозвратаТары",
			,
			Отказ);
		
	КонецЕсли;
		
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОказаниеАгентскихУслуг
		И ИспользоватьУказанныеАгентскиеУслуги
		И АгентскиеУслуги.Количество() = 0 
	Тогда
		ТекстОшибки = НСтр("ru='Не выбраны агентские услуги.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"Объект.ИспользоватьУказанныеАгентскиеУслуги",
			,
			Отказ);
	КонецЕсли;

	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Справочники.СоглашенияСПоставщиками.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	Если ИспользуютсяДоговорыКонтрагентов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокРасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("ВалютаВзаиморасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокОплаты");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ЭтапыГрафикаОплаты.ПроцентЗалогаЗаТару");
	Если ТребуетсяЗалогЗаТару Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЭтапыГрафикаОплаты.ПроцентПлатежа");
		Для Каждого ЭтапОплаты Из ЭтапыГрафикаОплаты Цикл
			Если Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентПлатежа) И Не ЗначениеЗаполнено(ЭтапОплаты.ПроцентЗалогаЗаТару) Тогда
				ТекстОшибки = НСтр("ru='Для этапа должен быть указан процент платежа или процент залога за тару в строке %НомерСтроки% списка ""Этапы графика оплаты""'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ЭтапОплаты.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭтапыГрафикаОплаты", ЭтапОплаты.НомерСтроки, "ПроцентПлатежа"),
					,
					Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ИспользуетсяРаздельныйВариантОформленияЗакупок = Ложь;
	Если (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика
			Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту
			Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС)
		И (ПолучитьФункциональнуюОпцию("ИспользоватьНеотфактурованныеПоставки")
			Или ПолучитьФункциональнуюОпцию("ИспользоватьТоварыВПутиОтПоставщиков"))
		И (ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных
			Или ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным
			Или ВариантПриемкиТоваров = Перечисления.ВариантыПриемкиТоваров.НеРазделенаПоНакладным) Тогда
		ИспользуетсяРаздельныйВариантОформленияЗакупок = Истина;

	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи 
		И Не ИспользуетсяРаздельныйВариантОформленияЗакупок Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидЦеныПоставщика");
	КонецЕсли;
	
	МассивВариантов = Новый Массив();
	МассивВариантов.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыПриемкиТоваров.МожетПроисходитьБезЗаказовИНакладных"));
	МассивВариантов.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыПриемкиТоваров.НеРазделенаПоЗаказамИНакладным"));
	МассивВариантов.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыПриемкиТоваров.НеРазделенаПоНакладным"));
	
	Если МассивВариантов.Найти(ВариантПриемкиТоваров) = Неопределено Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособДоставки");
		МассивНепроверяемыхРеквизитов.Добавить("ПеревозчикПартнер");
		МассивНепроверяемыхРеквизитов.Добавить("АдресДоставкиПеревозчика");
	КонецЕсли;
	
	Если Справочники.СоглашенияСПоставщиками.СоглашениеИспользуетсяПриПриемке(ВариантПриемкиТоваров)
		И ДоставкаТоваровКлиентСервер.ДоставкаИспользуется(СпособДоставки, 
		ПолучитьФункциональнуюОпцию("ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками")) Тогда
		ПроверяемыеРеквизиты.Добавить("Склад");
	КонецЕсли;
	
	ДоставкаТоваров.ПроверитьЗаполнениеРеквизитовДоставки(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	ВзаиморасчетыСервер.ПроверитьПорядокОплаты(ЭтотОбъект, Отказ);
	
	ПроверитьАгентскиеУслуги(Отказ);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиСправочника(
		ЭтотОбъект,
		Перечисления.СтатусыСоглашенийСПоставщиками.НеСогласовано);
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Справочники.СоглашенияСПоставщиками.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту 
			ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС Тогда
		НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС;
	КонецЕсли;

	// Отработка смены пометки удаления
	Если Не ЭтоНовый() И ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
		Документы.РегистраторГрафикаДвиженияТоваров.УстановитьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;
	
	Если ИспользуютсяДоговорыКонтрагентов Тогда
		ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПустаяСсылка();
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		Статус = Перечисления.СтатусыСоглашенийСПоставщиками.Закрыто;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СоглашениеИспользуетсяПриПриемке = Справочники.СоглашенияСПоставщиками.СоглашениеИспользуетсяПриПриемке(ВариантПриемкиТоваров);
	
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ, ПометкаУдаления Или Не СоглашениеИспользуетсяПриПриемке);
	
	Если СоглашениеИспользуетсяПриПриемке Тогда
		
		Справочники.СоглашенияСПоставщиками.ПолучитьСоздатьДокументРегистрации(Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Статус                  = Перечисления.СтатусыСоглашенийСПоставщиками.НеСогласовано;
	Согласован              = Ложь;
	ДатаНачалаДействия      = '00010101';
	ДатаОкончанияДействия   = '00010101';

	ИнициализироватьСправочник(Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.ЗначениеДоступа = Партнер;

	Если ЗначениеЗаполнено(Организация) Тогда
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = Организация;
	КонецЕсли;

	Если ЗначениеЗаполнено(Склад) Тогда
		СтрокаТаб = Таблица.Добавить();
		СтрокаТаб.ЗначениеДоступа = Склад;
	КонецЕсли;
	
КонецПроцедуры

#Область ИнициализацияИЗаполнение

// Заполняет соглашение с поставщиком на основании партнера
//
// Параметры:
//	Основание - СправочникСсылка.Партнеры - ссылка на партнера
//
Процедура ЗаполнитьДокументНаОснованииПартнера(Знач Основание)
	
	Партнер = Основание;
	ЗакупкиСервер.ПроверитьВозможностьВводаНаОснованииПартнераПоставщикаКонкурента(Партнер);
	ЗаполнитьРеквизитыПоУмолчанию();
	
КонецПроцедуры

// Заполняет соглашение с поставщиком в соответствии с отбором.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Структура со значениями заполнения
//
Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("ХозяйственнаяОперация") Тогда
		
		ХозяйственнаяОперация = ДанныеЗаполнения.ХозяйственнаяОперация;
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи Тогда
			ИспользуютсяДоговорыКонтрагентов = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Партнер") Тогда
		
		Партнер = ДанныеЗаполнения.Партнер;
		ЗакупкиСервер.ПроверитьВозможностьВводаНаОснованииПартнераПоставщикаКонкурента(Партнер);
		ЗаполнитьРеквизитыПоУмолчанию();
		
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ДанныеЗаполнения.Организация;
	КонецЕсли;
	
КонецПроцедуры

// Инициализирует соглашение с поставщиком
//
Процедура ИнициализироватьСправочник(ЗаполнятьВсеРеквизиты = Истина)

	Менеджер = Пользователи.ТекущийПользователь();
	Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	
	Если Не ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
	КонецЕсли;

	Если ЗаполнятьВсеРеквизиты Тогда
		
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
		ВалютаВзаиморасчетов = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(ВалютаВзаиморасчетов);
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
		Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад, ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки"));
		ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(ВалютаВзаиморасчетов, Неопределено);
		ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаРасчетов.ПолучитьГруппуФинансовогоУчетаПоУмолчанию(ПорядокОплаты, ХозяйственнаяОперация);
		ВариантПриемкиТоваров = Константы.ВариантПриемкиТоваров.Получить();
		Если Не ИспользуютсяДоговорыКонтрагентов Тогда
			Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам")
				ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию Тогда
				ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоЗаказамНакладным;
			Иначе
				ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Проверяет на отсутствие совпадающих по сроку и реализуемым услугам
// агентские соглашения
Процедура ПроверитьАгентскиеУслуги(Отказ)
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ОказаниеАгентскихУслуг
		ИЛИ Статус <> Перечисления.СтатусыСоглашенийСПоставщиками.Действует
			И Статус <> Перечисления.СтатусыСоглашенийСПоставщиками.Закрыто Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для данной хозяйственной операции необходимо указание организации'"),ЭтотОбъект,"Организация",,Отказ);
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Услуги.Номенклатура КАК Номенклатура,
	|	Услуги.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ ВыбранныеУслуги
	|ИЗ
	|	&Услуги КАК Услуги
	|;
	|///////////////////////////////////////////////
	|// По всем услугам принципала
	|ВЫБРАТЬ
	|	ДубльСоглашения.Наименование КАК Наименование,
	|	НЕОПРЕДЕЛЕНО КАК Номенклатура,
	|	НЕОПРЕДЕЛЕНО КАК Характеристика
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК ДубльСоглашения
	|ГДЕ
	|	ДубльСоглашения.Ссылка <> &Ссылка
	|	И ДубльСоглашения.Организация = &Организация
	|	И ДубльСоглашения.Партнер = &Партнер
	|	И ДубльСоглашения.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОказаниеАгентскихУслуг)
	|	И ДубльСоглашения.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует), ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Закрыто))
	|	И (НЕ ДубльСоглашения.ИспользоватьУказанныеАгентскиеУслуги
	|		ИЛИ &ПоВсемУслугам)
	|	И ((&ДатаНачалаДействия >= ДубльСоглашения.ДатаНачалаДействия
	|		И (&ДатаНачалаДействия <= ДубльСоглашения.ДатаОкончанияДействия
	|				ИЛИ ДубльСоглашения.ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|		И &ДатаНачалаДействия <> ДАТАВРЕМЯ(1,1,1))
	|		ИЛИ (&ДатаОкончанияДействия >=ДубльСоглашения.ДатаНачалаДействия
	|			И (&ДатаОкончанияДействия <= ДубльСоглашения.ДатаОкончанияДействия
	|				ИЛИ ДубльСоглашения.ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|		) ИЛИ (&ДатаНачалаДействия = ДАТАВРЕМЯ(1,1,1) И &ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|	)
	|
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|// По указанным агентским услугам принципала
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДубльСоглашения.Наименование КАК Наименование,
	|	ВыбранныеУслуги.Номенклатура КАК Номенклатура,
	|	ВыбранныеУслуги.Характеристика КАК Характеристика
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК ДубльСоглашения
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВыбранныеУслуги КАК ВыбранныеУслуги
	|	ПО ИСТИНА
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СоглашенияСПоставщиками.АгентскиеУслуги КАК ДублиУслуг
	|	ПО ДубльСоглашения.Ссылка = ДублиУслуг.Ссылка
	|		И ВыбранныеУслуги.Номенклатура = ДублиУслуг.Номенклатура
	|		И ВыбранныеУслуги.Характеристика = ДублиУслуг.Характеристика
	|ГДЕ
	|	ДубльСоглашения.Ссылка <> &Ссылка
	|	И ДубльСоглашения.Организация = &Организация
	|	И ДубльСоглашения.Партнер = &Партнер
	|	И ДубльСоглашения.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОказаниеАгентскихУслуг)
	|	И ДубльСоглашения.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Действует), ЗНАЧЕНИЕ(Перечисление.СтатусыСоглашенийСПоставщиками.Закрыто))
	|	И (НЕ (ДублиУслуг.Номенклатура ЕСТЬ NULL)
	|		ИЛИ НЕ ДубльСоглашения.ИспользоватьУказанныеАгентскиеУслуги
	|	)
	|	И ((&ДатаНачалаДействия >= ДубльСоглашения.ДатаНачалаДействия
	|		И (&ДатаНачалаДействия <= ДубльСоглашения.ДатаОкончанияДействия
	|				ИЛИ ДубльСоглашения.ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|		И &ДатаНачалаДействия <> ДАТАВРЕМЯ(1,1,1))
	|		ИЛИ (&ДатаОкончанияДействия >=ДубльСоглашения.ДатаНачалаДействия
	|			И (&ДатаОкончанияДействия <= ДубльСоглашения.ДатаОкончанияДействия
	|				ИЛИ ДубльСоглашения.ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|		) ИЛИ (&ДатаНачалаДействия = ДАТАВРЕМЯ(1,1,1) И &ДатаОкончанияДействия = ДАТАВРЕМЯ(1,1,1))
	|	)
	|");
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("Партнер",Партнер);
	Запрос.УстановитьПараметр("Услуги",АгентскиеУслуги.Выгрузить(,"Номенклатура, Характеристика"));
	Запрос.УстановитьПараметр("ПоВсемУслугам",НЕ ИспользоватьУказанныеАгентскиеУслуги);
	Запрос.УстановитьПараметр("ДатаНачалаДействия",ДатаНачалаДействия);
	Запрос.УстановитьПараметр("ДатаОкончанияДействия",ДатаОкончанияДействия);
	
	ШаблонСообщения = НСтр("ru = 'Обнаружено существующее соглашение %Наименование% %ДляУслуги%'");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = СтрЗаменить(ШаблонСообщения, "%Наименование%", Строка(Выборка.Наименование));
		Если ЗначениеЗаполнено(Выборка.Номенклатура) Тогда
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДляУслуги%", " " + НСтр("ru = 'для услуги'") + " " +Выборка.Номенклатура + ","+Выборка.Характеристика);
		Иначе
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДляУслуги%", "");
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,"Объект",Отказ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
