﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет табличную часть документа по правилу заполнения из различных источников
//
Процедура ЗаполнитьПоПравилуЗаполнения() Экспорт 
	
	Параметры = Новый Структура("Ссылка, Сценарий, КроссТаблица, ИзменитьРезультатНа, ЗаполненоАвтоматически, ТочностьОкругления, 
		|Подразделение, Склад, Партнер, Соглашение, Статус, Периодичность, НачалоПериода, ОкончаниеПериода, РаспределитьПоРабочимДням");
	
	ЗаполнитьЗначенияСвойств(Параметры, ЭтотОбъект);
	
	Параметры.Вставить("ЗаполнятьПоПравилу", Истина);
	Параметры.Вставить("ПравилоЗаполнения", ПравилоЗаполнения.Выгрузить());
	Параметры.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки.Получить());
	
	ЗаполняемаяТЧ = Товары.Выгрузить();
	Если ОбновитьДополнить = 0 Тогда
		ЗаполняемаяТЧ.Очистить();
	КонецЕсли;
	
	Параметры.Вставить("ЗаполняемаяТЧ", ЗаполняемаяТЧ);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	Документы.ПланПродаж.ЗаполнитьПоПравилуЗаполнения(Параметры, АдресХранилища);
	
	ЗаполняемаяТЧ = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Товары.Загрузить(ЗаполняемаяТЧ);
	
	ЗаполненоАвтоматически = Истина;
	
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
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыПланов[НовыйСтатус];
	
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;

	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	Иначе
		ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
		ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	    ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	КонецЕсли;
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ИмяТЧ",                    "Товары");
	ПараметрыПроверки.Вставить("ПредставлениеТЧ",          НСтр("ru='Товары'"));
	ПараметрыПроверки.Вставить("Периодичность",            Периодичность);
	ПараметрыПроверки.Вставить("ДатаНачала",               НачалоПериода);
	ПараметрыПроверки.Вставить("ДатаОкончания",            ОкончаниеПериода);
	ПараметрыПроверки.Вставить("ИмяПоляДатыПериода",       "ДатаОтгрузки");
	ПараметрыПроверки.Вставить("ПредставлениеДатыПериода", НСтр("ru='Дата отгрузки'"));
	
	ПланированиеКлиентСервер.ПроверитьДатуПериодаТЧ(ЭтотОбъект, Отказ, ПараметрыПроверки);
	
	Если КроссТаблица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Характеристика");
	Иначе
		НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	КонецЕсли;
	
	Планирование.ОбработкаПроверкиЗаполненияПоСценариюВидуПлана(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	Если НЕ ПланироватьПоСумме 
		ИЛИ НЕ ЗаполнятьПланОплат 
		ИЛИ НЕ ЗначениеЗаполнено(Соглашение) 
		ИЛИ НЕ ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	Если ЗаполнятьПланОплат Тогда
		
		СуммаЭтаповОплаты = 0;
		Для Каждого ЭтапОплаты Из ПланОплаты Цикл
			СуммаЭтаповОплаты = СуммаЭтаповОплаты + ЭтапОплаты.СуммаПлатежа;
		КонецЦикла;
	
		Если СуммаДокумента > 0 И ПланОплаты.Количество() = 0 Тогда
		
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Необходимо заполнить план оплаты.'"),
				ЭтотОбъект,
				"ПланОплаты",
				, 
				Отказ);
			
		ИначеЕсли СуммаДокумента <> СуммаЭтаповОплаты Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Сумма отгрузок по документу не совпадает с суммой оплат. Необходимо обновить план оплаты.'"),
				ЭтотОбъект,
				"ПланОплаты",
				, 
				Отказ);
				
		КонецЕсли; 
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ПланОплаты.ДатаОтгрузки");
	КонецЕсли;
	
	
	Если Не КроссТаблица Тогда
		
		РеквизитыВидПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана,"ЗаполнятьНазначениеВТЧ, ЗаполнятьСоглашение, ЗаполнятьСклад, ЗаполнятьПартнера");
		
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаТовары.Номенклатура,
		|	ТаблицаТовары.Характеристика,
		|	ТаблицаТовары.Склад,
		|	ТаблицаТовары.Партнер,
		|	ТаблицаТовары.Соглашение,
		|	ТаблицаТовары.Назначение,
		|	ТаблицаТовары.Количество
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&ТаблицаТовары КАК ТаблицаТовары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Склад,
		|	Товары.Партнер,
		|	Товары.Соглашение,
		|	Товары.Назначение,
		|	СУММА(Товары.Количество) КАК Количество
		|ИЗ
		|	Товары КАК Товары
		|ГДЕ
		|	Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|	И (Не &ЗаполнятьСклад ИЛИ Товары.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
		|	И (Не &ЗаполнятьПартнера ИЛИ Товары.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка))
		|	И (Не &ЗаполнятьСоглашение ИЛИ Товары.Соглашение <> ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка))
		|
		|СГРУППИРОВАТЬ ПО
		|	Товары.Номенклатура,
		|	Товары.Склад,
		|	Товары.Партнер,
		|	Товары.Соглашение,
		|	Товары.Назначение,
		|	Товары.Характеристика
		|
		|ИМЕЮЩИЕ
		|	СУММА(Товары.Количество) = 0";
		Запрос.УстановитьПараметр("ТаблицаТовары", Товары.Выгрузить());
		Запрос.УстановитьПараметр("ЗаполнятьСоглашение", РеквизитыВидПлана.ЗаполнятьСоглашение);
		Запрос.УстановитьПараметр("ЗаполнятьСклад", РеквизитыВидПлана.ЗаполнятьСклад);
		Запрос.УстановитьПараметр("ЗаполнятьПартнера", РеквизитыВидПлана.ЗаполнятьПартнера);
		РеквизитыВидПлана = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидПлана,"ЗаполнятьНазначениеВТЧ, ЗаполнятьСоглашение, ЗаполнятьСклад, ЗаполнятьПартнера, ЗаполнятьСкладВТЧ, ЗаполнятьСоглашениеВТЧ, ЗаполнятьПартнераВТЧ");
		
		ТаблицаОшибок = Запрос.Выполнить().Выгрузить();
		
		КлючДанных = ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(ЭтотОбъект);
		СтруктураПоиска = Новый Структура("Номенклатура,Характеристика,Назначение,Склад,Партнер,Соглашение");
		
		Для Каждого СтрокаОшибки Из ТаблицаОшибок Цикл
			
			ТекстСообщения = НСтр("ru='Для строк плана с номенклатурой %Номенклатура%%Характеристика%%Назначение%%Склад%%Партнер%%Соглашение% не запланировано количество ни в одном периоде планирования.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%", СтрокаОшибки.Номенклатура);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Характеристика%", ?(ЗначениеЗаполнено(СтрокаОшибки.Характеристика), НСтр("ru=', характеристикой'") + " " + СтрокаОшибки.Характеристика, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Назначение%", ?(ЗначениеЗаполнено(СтрокаОшибки.Назначение)
				И РеквизитыВидПлана.ЗаполнятьНазначениеВТЧ,
				НСтр("ru=', назначением'") + " " + СтрокаОшибки.Назначение, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Склад%", ?(ЗначениеЗаполнено(СтрокаОшибки.Склад)
				И РеквизитыВидПлана.ЗаполнятьСкладВТЧ , НСтр("ru=', складом'") + " " + СтрокаОшибки.Склад, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Партнер%", ?(ЗначениеЗаполнено(СтрокаОшибки.Партнер)
				И РеквизитыВидПлана.ЗаполнятьПартнераВТЧ, НСтр("ru=', партнером'") + " " + СтрокаОшибки.Партнер, ""));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Соглашение%", ?(ЗначениеЗаполнено(СтрокаОшибки.Соглашение)
				И РеквизитыВидПлана.ЗаполнятьСоглашениеВТЧ, НСтр("ru=', соглашением'") + " " + СтрокаОшибки.Соглашение, ""));
			
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаОшибки);
			СтрокаПоиска = Товары.НайтиСтроки(СтруктураПоиска)[0];
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаПоиска.НомерСтроки, "КоличествоУпаковок");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,КлючДанных, Поле,"Объект",Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Замещающий Тогда
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗамещениеПланов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ВидПлана", ВидПлана);
		Блокировка.Заблокировать();
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Планирование.ПроверитьСтатусУтвержден(ЭтотОбъект, Отказ, РежимЗаписи, Перечисления.ТипыПланов.ПланПродаж);
	
	СуммаДокумента = 0;
	
	Для каждого СтрокаТЧ Из Товары Цикл
		Если ПланироватьПоСумме Тогда
			
			Если Не СтрокаТЧ.Отменено Тогда
			
				СуммаДокумента = СуммаДокумента + СтрокаТЧ.Сумма;
			
			КонецЕсли; 
			
		Иначе
			
			СтрокаТЧ.Цена = 0;
			СтрокаТЧ.Сумма = 0;
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Партнер) Тогда
			СтрокаТЧ.Партнер = Партнер;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Соглашение) Тогда
			СтрокаТЧ.Соглашение = Соглашение;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(Склад) Тогда
			СтрокаТЧ.Склад = Склад;
		КонецЕсли; 
		
	КонецЦикла;
	
	Если НЕ ПланироватьПоСумме Тогда
		ЗаполнятьПланОплат = Ложь;
	КонецЕсли;
	Если НЕ ЗаполнятьПланОплат Тогда
		
		ПланОплаты.Очистить();
		
	КонецЕсли; 
	
	
	Если Замещающий 
		И Не ЭтоНовый()
		И Не Отказ Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбновитьЗамещениеПлана(РежимЗаписи);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбновитьЗамещениеПлана(РежимЗаписи, ОбновлениеИБ = Ложь) Экспорт
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения
		Или (РежимЗаписи = РежимЗаписиДокумента.Запись И Не Проведен) Тогда
		
		Для Каждого Строка Из Товары Цикл
			Строка.Замещен = Ложь;
		КонецЦикла;
		
		НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
		НаборЗаписей.Записать();
		Возврат;
	КонецЕсли;
		
	Периоды = Новый ТаблицаЗначений();
	Периоды.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДобавлениеДатаНачала = НачалоПериода;
	Пока ДобавлениеДатаНачала < КонецДня(ОкончаниеПериода) Цикл
		НоваяСтрока = Периоды.Добавить();
		НоваяСтрока.Период = ДобавлениеДатаНачала;
		
		ДатуОкончанияПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДобавлениеДатаНачала, Периодичность);
		ДобавлениеДатаНачала = ДатуОкончанияПериода+1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Периоды.Период
	|ПОМЕСТИТЬ Периоды
	|ИЗ
	|	&Периоды КАК Периоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланПродажЗамещающий.Ссылка,
	|	ПланПродажЗамещающий.ВидПлана,
	|	ВЫБОР
	|		КОГДА &НачалоПериода > ПланПродажЗамещающий.НачалоПериода
	|			ТОГДА &НачалоПериода
	|		ИНАЧЕ ПланПродажЗамещающий.НачалоПериода
	|	КОНЕЦ КАК НачалоПериода,
	|	ВЫБОР
	|		КОГДА &ОкончаниеПериода < ПланПродажЗамещающий.ОкончаниеПериода
	|			ТОГДА &ОкончаниеПериода
	|		ИНАЧЕ ПланПродажЗамещающий.ОкончаниеПериода
	|	КОНЕЦ КАК ОкончаниеПериода
	|ПОМЕСТИТЬ ЗамещаемыеПланы
	|ИЗ
	|	Документ.ПланПродаж КАК ПланПродажЗамещающий
	|ГДЕ
	|	ПланПродажЗамещающий.ОкончаниеПериода >= &НачалоПериода
	|	И ПланПродажЗамещающий.НачалоПериода <= &ОкончаниеПериода
	|	И ПланПродажЗамещающий.Ссылка <> &Ссылка
	|	И ПланПродажЗамещающий.Проведен
	|	И ПланПродажЗамещающий.ВидПлана = &ВидПлана
	|	И ПланПродажЗамещающий.Статус.Порядок >= &СтатусИндекс
	|	И ПланПродажЗамещающий.Дата > &Дата
	|	И ПланПродажЗамещающий.Подразделение = &Подразделение
	|	И ПланПродажЗамещающий.Партнер = &Партнер
	|	И ПланПродажЗамещающий.Соглашение = &Соглашение
	|	И ПланПродажЗамещающий.Склад = &Склад
	|	И ПланПродажЗамещающий.Менеджер = &Менеджер
	|	И ПланПродажЗамещающий.ФорматМагазина = &ФорматМагазина
	|	И ПланПродажЗамещающий.Назначение = &Назначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещаемыеПланы.ВидПлана,
	|	Периоды.Период КАК ЗамещенныйПериод,
	|	ЛОЖЬ КАК КЗамещению,
	|	ЛОЖЬ КАК КОтменеЗамещения,
	|	ЗамещаемыеПланы.Ссылка КАК ЗамещающийПлан,
	|	&Ссылка КАК ЗамещенныйПлан
	|ПОМЕСТИТЬ ЗамещениеПланов
	|ИЗ
	|	ЗамещаемыеПланы КАК ЗамещаемыеПланы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Периоды КАК Периоды
	|		ПО ЗамещаемыеПланы.НачалоПериода <= Периоды.Период
	|			И ЗамещаемыеПланы.ОкончаниеПериода >= Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланПродажТовары.ДатаОтгрузки,
	|	ВЫБОР &Периодичность
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажТовары.ДатаОтгрузки, НЕДЕЛЯ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажТовары.ДатаОтгрузки, ДЕКАДА)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажТовары.ДатаОтгрузки, МЕСЯЦ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажТовары.ДатаОтгрузки, КВАРТАЛ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажТовары.ДатаОтгрузки, ПОЛУГОДИЕ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажТовары.ДатаОтгрузки, ГОД)
	|		ИНАЧЕ ПланПродажТовары.ДатаОтгрузки
	|	КОНЕЦ КАК Период
	|ПОМЕСТИТЬ ПланПродажТовары
	|ИЗ
	|	&ПланПродажТовары КАК ПланПродажТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланПродажПланОплаты.ДатаОтгрузки,
	|	ВЫБОР &Периодичность
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажПланОплаты.ДатаОтгрузки, НЕДЕЛЯ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажПланОплаты.ДатаОтгрузки, ДЕКАДА)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажПланОплаты.ДатаОтгрузки, МЕСЯЦ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажПланОплаты.ДатаОтгрузки, КВАРТАЛ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажПланОплаты.ДатаОтгрузки, ПОЛУГОДИЕ)
	|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|			ТОГДА НАЧАЛОПЕРИОДА(ПланПродажПланОплаты.ДатаОтгрузки, ГОД)
	|		ИНАЧЕ ПланПродажПланОплаты.ДатаОтгрузки
	|	КОНЕЦ КАК Период
	|ПОМЕСТИТЬ ПланПродажПланОплаты
	|ИЗ
	|	&ПланПродажПланОплаты КАК ПланПродажПланОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланПродажТовары.ДатаОтгрузки
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланПродажТовары КАК ПланПродажТовары
	|		ПО ЗамещениеПланов.ЗамещенныйПериод = ПланПродажТовары.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПланПродажПланОплаты.ДатаОтгрузки
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланПродажПланОплаты КАК ПланПродажПланОплаты
	|		ПО ЗамещениеПланов.ЗамещенныйПериод = ПланПродажПланОплаты.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ВидПлана,
	|	ЗамещениеПланов.ЗамещенныйПериод,
	|	ЗамещениеПланов.КЗамещению,
	|	ЗамещениеПланов.КОтменеЗамещения,
	|	ЗамещениеПланов.ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
	Запрос.УстановитьПараметр("СтатусИндекс", Перечисления.СтатусыПланов.Индекс(Статус));
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Менеджер", Менеджер);
	Запрос.УстановитьПараметр("ФорматМагазина", ФорматМагазина);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ОкончаниеПериода);
	Запрос.УстановитьПараметр("Периоды", Периоды);
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	Запрос.УстановитьПараметр("ПланПродажТовары", Товары.Выгрузить());
	Запрос.УстановитьПараметр("ПланПродажПланОплаты", ПланОплаты.Выгрузить());
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	Выборка = ЗапросПакет[5].Выбрать();
	ВыборкаПланОплаты = ЗапросПакет[6].Выбрать();
	ТаблицаЗамещениеПлана = ЗапросПакет[7].Выгрузить();
	
	Для Каждого Строка Из Товары Цикл
		Строка.Замещен = Ложь;
	КонецЦикла;
	
	Пока Выборка.Следующий() Цикл
		
		Отбор = Новый Структура("ДатаОтгрузки", Выборка.ДатаОтгрузки);
		ЗамещаемыеСтроки = Товары.НайтиСтроки(Отбор);
		Для Каждого Строка Из ЗамещаемыеСтроки Цикл
			Строка.Замещен = Истина;
		КонецЦикла;
		
	КонецЦикла;
	
	Для Каждого Строка Из ПланОплаты Цикл
		Строка.Замещен = Ложь;
	КонецЦикла;
	
	Пока ВыборкаПланОплаты.Следующий() Цикл
		
		Отбор = Новый Структура("ДатаОтгрузки", ВыборкаПланОплаты.ДатаОтгрузки);
		ЗамещаемыеСтроки = ПланОплаты.НайтиСтроки(Отбор);
		Для Каждого Строка Из ЗамещаемыеСтроки Цикл
			Строка.Замещен = Истина;
		КонецЦикла;
		
	КонецЦикла;
	
	НаборЗаписей = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗамещенныйПлан.Установить(Ссылка);
		
	НаборЗаписей.Загрузить(ТаблицаЗамещениеПлана);
	
	Если ОбновлениеИБ Тогда
		НаборЗаписей.ДополнительныеСвойства.Вставить("РегистрироватьНаУзлахПлановОбменаПриОбновленииИБ", Неопределено);
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		НаборЗаписей.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Замещающий 
		И Не Отказ Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбновитьЗамещенныеПланы();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗамещенныеПланы()
	
	Периоды = Новый ТаблицаЗначений();
	Периоды.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	ДобавлениеДатаНачала = НачалоПериода;
	Пока ДобавлениеДатаНачала < КонецДня(ОкончаниеПериода) Цикл
		НоваяСтрока = Периоды.Добавить();
		НоваяСтрока.Период = ДобавлениеДатаНачала;
		
		ДатуОкончанияПериода = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(ДобавлениеДатаНачала, Периодичность);
		ДобавлениеДатаНачала = ДатуОкончанияПериода+1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Периоды.Период
	|ПОМЕСТИТЬ Периоды
	|ИЗ
	|	&Периоды КАК Периоды
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПланПродажЗамещенный.Ссылка,
	|	ПланПродажЗамещенный.ВидПлана,
	|	ВЫБОР
	|		КОГДА ПланПродаж.НачалоПериода > ПланПродажЗамещенный.НачалоПериода
	|			ТОГДА ПланПродаж.НачалоПериода
	|		ИНАЧЕ ПланПродажЗамещенный.НачалоПериода
	|	КОНЕЦ КАК НачалоПериода,
	|	ВЫБОР
	|		КОГДА ПланПродаж.ОкончаниеПериода < ПланПродажЗамещенный.ОкончаниеПериода
	|			ТОГДА ПланПродаж.ОкончаниеПериода
	|		ИНАЧЕ ПланПродажЗамещенный.ОкончаниеПериода
	|	КОНЕЦ КАК ОкончаниеПериода
	|ПОМЕСТИТЬ ЗамещенныеПланы
	|ИЗ
	|	Документ.ПланПродаж КАК ПланПродаж
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПланПродаж КАК ПланПродажЗамещенный
	|		ПО ПланПродаж.ВидПлана = ПланПродажЗамещенный.ВидПлана
	|			И ПланПродаж.Статус.Порядок >= ПланПродажЗамещенный.Статус.Порядок
	|			И ПланПродаж.Дата > ПланПродажЗамещенный.Дата
	|			И ПланПродаж.Подразделение = ПланПродажЗамещенный.Подразделение
	|			И ПланПродаж.Партнер = ПланПродажЗамещенный.Партнер
	|			И ПланПродаж.Соглашение = ПланПродажЗамещенный.Соглашение
	|			И ПланПродаж.Склад = ПланПродажЗамещенный.Склад
	|			И ПланПродаж.Менеджер = ПланПродажЗамещенный.Менеджер
	|			И ПланПродаж.ФорматМагазина = ПланПродажЗамещенный.ФорматМагазина
	|			И ПланПродаж.Назначение = ПланПродажЗамещенный.Назначение
	|			И ПланПродаж.Проведен = ПланПродажЗамещенный.Проведен
	|ГДЕ
	|	ПланПродажЗамещенный.ОкончаниеПериода >= ПланПродаж.НачалоПериода
	|	И ПланПродажЗамещенный.НачалоПериода <= ПланПродаж.ОкончаниеПериода
	|	И ПланПродаж.Ссылка = &Ссылка
	|	И ПланПродаж.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещаемыеПланы.ВидПлана,
	|	Периоды.Период КАК ЗамещенныйПериод,
	|	ЗамещаемыеПланы.Ссылка КАК ЗамещенныйПлан,
	|	&Ссылка КАК ЗамещающийПлан
	|ПОМЕСТИТЬ ЗамещенныеПланыПоПериодам
	|ИЗ
	|	ЗамещенныеПланы КАК ЗамещаемыеПланы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Периоды КАК Периоды
	|		ПО ЗамещаемыеПланы.НачалоПериода <= Периоды.Период
	|			И ЗамещаемыеПланы.ОкончаниеПериода >= Периоды.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ЗамещающийПлан КАК ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.ЗамещенныйПериод КАК ЗамещенныйПериод,
	|	ЗамещениеПланов.ВидПлана КАК ВидПлана,
	|	ЗамещениеПланов.КЗамещению КАК КЗамещению,
	|	ВЫБОР
	|		КОГДА ЗамещенныеПланыПоПериодам.ЗамещенныйПериод ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК КОтменеЗамещения
	|ПОМЕСТИТЬ ЗамещениеПлановСуммаДвижений
	|ИЗ
	|	РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ЗамещенныеПланыПоПериодам КАК ЗамещенныеПланыПоПериодам
	|		ПО ЗамещениеПланов.ВидПлана = ЗамещенныеПланыПоПериодам.ВидПлана
	|			И ЗамещениеПланов.ЗамещенныйПериод = ЗамещенныеПланыПоПериодам.ЗамещенныйПериод
	|			И ЗамещениеПланов.ЗамещающийПлан = ЗамещенныеПланыПоПериодам.ЗамещающийПлан
	|			И ЗамещениеПланов.ЗамещенныйПлан = ЗамещенныеПланыПоПериодам.ЗамещенныйПлан
	|ГДЕ
	|	&Ссылка = ЗамещениеПланов.ЗамещающийПлан
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗамещенныеПланыПоПериодам.ЗамещающийПлан,
	|	ЗамещенныеПланыПоПериодам.ЗамещенныйПлан,
	|	ЗамещенныеПланыПоПериодам.ЗамещенныйПериод,
	|	ЗамещенныеПланыПоПериодам.ВидПлана,
	|	ИСТИНА,
	|	ЛОЖЬ
	|ИЗ
	|	ЗамещенныеПланыПоПериодам КАК ЗамещенныеПланыПоПериодам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ПО ЗамещенныеПланыПоПериодам.ВидПлана = ЗамещениеПланов.ВидПлана
	|			И ЗамещенныеПланыПоПериодам.ЗамещенныйПериод = ЗамещениеПланов.ЗамещенныйПериод
	|			И ЗамещенныеПланыПоПериодам.ЗамещенныйПлан = ЗамещениеПланов.ЗамещенныйПлан
	|			И ЗамещенныеПланыПоПериодам.ЗамещающийПлан = ЗамещениеПланов.ЗамещающийПлан
	|ГДЕ
	|	ЗамещениеПланов.ЗамещенныйПериод ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗамещениеПлановСуммаДвижений.ЗамещающийПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод,
	|	ЗамещениеПлановСуммаДвижений.ВидПлана,
	|	МИНИМУМ(ЕСТЬNULL(ЗамещениеПланов1.КЗамещению, ЗамещениеПлановСуммаДвижений.КЗамещению)) КАК КЗамещению,
	|	МИНИМУМ(ЗамещениеПлановСуммаДвижений.КОтменеЗамещения) КАК КОтменеЗамещения,
	|	МИНИМУМ(ЕСТЬNULL(ЗамещениеПланов.КОтменеЗамещения, ИСТИНА)) КАК ВыполнитьОтменуЗамещению
	|ПОМЕСТИТЬ ЗамещениеПланов
	|ИЗ
	|	ЗамещениеПлановСуммаДвижений КАК ЗамещениеПлановСуммаДвижений
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов
	|		ПО ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан = ЗамещениеПланов.ЗамещенныйПлан
	|			И ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод = ЗамещениеПланов.ЗамещенныйПериод
	|			И (НЕ ЗамещениеПланов.КОтменеЗамещения)
	|			И (&Ссылка <> ЗамещениеПланов.ЗамещающийПлан)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗамещениеПланов КАК ЗамещениеПланов1
	|		ПО ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан = ЗамещениеПланов1.ЗамещенныйПлан
	|			И ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод = ЗамещениеПланов1.ЗамещенныйПериод
	|			И (НЕ ЗамещениеПланов1.КЗамещению)
	|			И (&Ссылка <> ЗамещениеПланов1.ЗамещающийПлан)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗамещениеПлановСуммаДвижений.ВидПлана,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПериод,
	|	ЗамещениеПлановСуммаДвижений.ЗамещенныйПлан,
	|	ЗамещениеПлановСуммаДвижений.ЗамещающийПлан
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗамещениеПланов.ЗамещающийПлан,
	|	ЗамещениеПланов.ЗамещенныйПлан КАК ЗамещенныйПлан,
	|	ЗамещениеПланов.ЗамещенныйПериод,
	|	ЗамещениеПланов.ВидПлана,
	|	ЗамещениеПланов.КЗамещению,
	|	ЗамещениеПланов.КОтменеЗамещения,
	|	ЗамещениеПланов.ВыполнитьОтменуЗамещению
	|ИЗ
	|	ЗамещениеПланов КАК ЗамещениеПланов
	|ИТОГИ ПО
	|	ЗамещенныйПлан";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Периоды", Периоды);
	Запрос.УстановитьПараметр("Периодичность", Периодичность);
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	ВыборкаЗамещенныйПлан = ЗапросПакет[5].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ОбновитьЗамещениеПлана = Ложь;
	
	Пока ВыборкаЗамещенныйПлан.Следующий() Цикл
		
		НаборЗаписейОчереди = РегистрыСведений.ЗамещениеПланов.СоздатьНаборЗаписей();
		НаборЗаписейОчереди.Отбор.ЗамещающийПлан.Установить(Ссылка);
		НаборЗаписейОчереди.Отбор.ЗамещенныйПлан.Установить(ВыборкаЗамещенныйПлан.ЗамещенныйПлан); 
		
		Выборка = ВыборкаЗамещенныйПлан.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока Выборка.Следующий() Цикл
			
			Если (Выборка.КЗамещению И Выборка.КОтменеЗамещения)Тогда
				ОбновитьЗамещениеПлана = Истина;
			ИначеЕсли Выборка.КОтменеЗамещения И НЕ Выборка.ВыполнитьОтменуЗамещению Тогда
				Продолжить;
			ИначеЕсли Выборка.КЗамещению Или Выборка.КОтменеЗамещения Тогда
				ОбновитьЗамещениеПлана = Истина;
				ЗаписьОчереди = НаборЗаписейОчереди.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьОчереди, Выборка);
			ИначеЕсли Проведен Тогда
				ЗаписьОчереди = НаборЗаписейОчереди.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьОчереди, Выборка);
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписейОчереди.Записать();
		
	КонецЦикла;
	
	Если ОбновитьЗамещениеПлана Тогда
		Планирование.ЗапускВыполненияФоновогоПроведенияПлана();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	ЗаполнитьРеквизитыПланаПоСценариюВидуПлана();
	Для каждого СтрокаТовары из Товары Цикл

		СтрокаТовары.Отменено = Ложь;

	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ПланПродаж.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Планирование.ОтразитьПланыПродаж(ДополнительныеСвойства, Движения, Отказ);
	
	Планирование.ОтразитьПланыОплатКлиентов(ДополнительныеСвойства, Движения, Отказ);
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Ответственный = Пользователи.ТекущийПользователь();
	ЗаполнитьДанныеПоУмолчанию();
	
	ЗаполнитьРеквизитыПланаПоСценариюВидуПлана();
	
КонецПроцедуры

// Процедура заполняет подразделение, сценарий, вид плана и признак кросс-таблицы в документе, значением по умолчанию.
//
Процедура ЗаполнитьДанныеПоУмолчанию()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА СтруктураПредприятия.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.Подразделение
	|	КОНЕЦ КАК Подразделение,
	|	ВЫБОР
	|		КОГДА СценарииТоварногоПланирования.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СценарииТоварногоПланирования.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.Сценарий
	|	КОНЕЦ КАК Сценарий,
	|	ВЫБОР
	|		КОГДА ВидыПланов.ПометкаУдаления
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыПланов.ПустаяСсылка)
	|		ИНАЧЕ ДанныеДокумента.ВидПлана
	|	КОНЕЦ КАК ВидПлана,
	|	ДанныеДокумента.ЗаполнятьПоФормуле КАК ЗаполнятьПоФормуле,
	|	ДанныеДокумента.КроссТаблица КАК КроссТаблица,
	|	ЕСТЬNULL(ВидыПланов.ЗаполнятьПланОплат, ЛОЖЬ) КАК ЗаполнятьПланОплат
	|ИЗ
	|	Документ.ПланПродаж КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПланов КАК ВидыПланов
	|		ПО ДанныеДокумента.ВидПлана = ВидыПланов.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СценарииТоварногоПланирования КАК СценарииТоварногоПланирования
	|		ПО ДанныеДокумента.Сценарий = СценарииТоварногоПланирования.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|		ПО ДанныеДокумента.Подразделение = СтруктураПредприятия.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ответственный = &Ответственный
	|	И ДанныеДокумента.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокумента.Дата УБЫВ");
	
	Запрос.УстановитьПараметр("Ответственный", Ответственный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		
	КонецЕсли;
	
	Сценарий = ЗначениеНастроекПовтИсп.ПолучитьСценарийПоУмолчанию(Перечисления.ТипыПланов.ПланПродаж, Сценарий);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПланаПоСценариюВидуПлана()
	
	РеквизитыСценария = "Периодичность, Валюта, ПланПродажПланироватьПоСумме";
	ПараметрыСценария = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сценарий, РеквизитыСценария);
	Если НЕ ЗначениеЗаполнено(ВидПлана) Тогда
		ВидПлана = Планирование.ПолучитьВидПланаПоУмолчанию(Перечисления.ТипыПланов.ПланПродаж, Сценарий);
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыСценария);
	ПланироватьПоСумме = ПараметрыСценария.ПланПродажПланироватьПоСумме;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
