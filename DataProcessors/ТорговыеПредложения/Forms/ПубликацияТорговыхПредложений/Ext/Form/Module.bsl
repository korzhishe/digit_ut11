﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Ссылка", Соглашение);
	ОбновитьДанныеФормы();
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбменБизнесСеть") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ТорговыеПредложения_ПослеЗаписи"
		ИЛИ ИмяСобытия = "БизнесСеть_РегистрацияОрганизаций"
		ИЛИ ИмяСобытия = "ТорговыеПредложение_СопоставлениеНоменклатуры"
		ИЛИ ИмяСобытия = "СинхронизацияТорговыхПредложений_ПриИзменении"
		ИЛИ ИмяСобытия = "ТорговыеПредложения_СохранениеРегионовАбонента" Тогда
		
		ОбновитьДанныеФормы();
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПоказатьСкрытьПояснения(ПоказыватьПояснения, Элементы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СопоставитьНоменклатуруНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.СопоставлениеНоменклатуры",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаОтчетаПубликуемыхТоваровНажатие(Элемент)
	
	ПараметрыОткрытия= Новый Структура;
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
	ОткрытьФорму("Отчет.ПубликуемыеТорговыеПредложения.Форма", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьОрганизациюПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиСинхронизироватьПриИзменении(Элемент)
	
	УстановитьПараметрРегламентногоЗадания("Использование", АвтоматическиСинхронизировать);
	Элементы.СинхронизацияРасписание.Доступность = АвтоматическиСинхронизировать;
	Элементы.НастроитьРасписание.Доступность     = АвтоматическиСинхронизировать;
	Оповестить("СинхронизацияТорговыхПредложений_ПриИзменении");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияЗаголовокНажатие(Элемент)
	
	ОткрытьФорму("Обработка.БизнесСеть.Форма.РегистрацияУчастников",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеЗаголовокНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ФормаСписка",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрофильОбменаЗаголовокНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ПрофильАбонента",, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьСинхронизацию(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Синхронизация торговых предложений с сервисом 1С:Бизнес-сеть'");
	ПараметрыОжидания.ВыводитьПрогрессВыполнения      = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания            = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения               = Истина;
	
	Оповещение = Новый ОписаниеОповещения("ВыполнитьСинхронизациюПродолжение", ЭтотОбъект);
	ДлительнаяОперация = ТорговыеПредложенияВызовСервера.СинхронизироватьТорговыеПредложенияВФоне();
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(ТекущееРасписание());
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПояснения(Команда)
	
	ПоказыватьПояснения = Не ПоказыватьПояснения;
	ПоказатьСкрытьПояснения(ПоказыватьПояснения, Элементы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьСинхронизациюПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда // Отменено пользователем.
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("Сообщения") Тогда
		Для Каждого Сообщение Из Результат.Сообщения Цикл 
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
	Отказ = Ложь;
	Если Результат.Статус = "Ошибка" Тогда
		ТекстСообщения = Результат.ПодробноеПредставлениеОшибки;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 %2'"),
				ОбщегоНазначенияКлиент.ДатаСеанса(), ТекстСообщения));
		Отказ = Истина;
	КонецЕсли;
		
	ОбновитьДанныеФормы();
	
	Если Не Отказ Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = '1С:Бизнес-сеть'"),, НСтр("ru = 'Синхронизация выполнена'"),
			БиблиотекаКартинок.БизнесСеть);
	КонецЕсли;
	
	Оповестить("ТорговыеПредложения_ИзменениеСинхронизации",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПараметрРегламентногоЗадания("Расписание", Расписание);
	Элементы.СинхронизацияРасписание.Заголовок = Расписание;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормы()
	
	// Организации.
	ИспользуетсяНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЭД");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации1СБизнесСеть.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.Организации1СБизнесСеть КАК Организации1СБизнесСеть";
	КоличествоОрганизаций = Запрос.Выполнить().Выбрать().Количество();
	
	Элементы.ОрганизацияУспех.Видимость = КоличествоОрганизаций <> 0;
	Элементы.ОрганизацияОшибка.Видимость  = КоличествоОрганизаций = 0;
	
	Если КоличествоОрганизаций <> 0 Тогда
		Если ИспользуетсяНесколькоОрганизаций Тогда
			Элементы.ОрганизацияУспехНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Организации зарегистрированы (%1)'"),
				КоличествоОрганизаций);
		Иначе
			Элементы.ОрганизацияУспехНадпись.Заголовок = НСтр("ru = 'Организация зарегистрирована'");
		КонецЕсли;
	ИначеЕсли ИспользуетсяНесколькоОрганизаций Тогда
		Элементы.ОрганизацияОшибкаНадпись.Заголовок = НСтр("ru = 'Организации не зарегистрированы'");
	Иначе
		Элементы.ОрганизацияОшибкаНадпись.Заголовок = НСтр("ru = 'Организация не зарегистрирована'");
	КонецЕсли;
	
	// Сопоставление.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоответствиеВидовНоменклатуры1СБизнесСеть.ВидНоменклатуры КАК ВидНоменклатуры
	|ИЗ
	|	РегистрСведений.СоответствиеВидовНоменклатуры1СБизнесСеть КАК СоответствиеВидовНоменклатуры1СБизнесСеть
	|ИТОГИ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВидНоменклатуры)
	|ПО
	|	ОБЩИЕ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	КоличествоСопоставлено = 0;
	Если Выборка.Следующий() Тогда
		КоличествоСопоставлено = Выборка.ВидНоменклатуры;
	КонецЕсли;
	Элементы.СопоставлениеУспех.Видимость = КоличествоСопоставлено <> 0;
	Элементы.СопоставлениеОшибка.Видимость = КоличествоСопоставлено = 0;
	
	Элементы.СопоставлениеУспехНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Номенклатура сопоставлена (%1)'"),
		КоличествоСопоставлено);
		
	// Торговые предложения.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СостоянияСинхронизацииТорговыеПредложения.ТорговоеПредложение КАК ТорговоеПредложение
	|ИЗ
	|	РегистрСведений.СостоянияСинхронизацииТорговыеПредложения КАК СостоянияСинхронизацииТорговыеПредложения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Организации1СБизнесСеть КАК Организации1СБизнесСеть
	|		ПО СостоянияСинхронизацииТорговыеПредложения.Организация = Организации1СБизнесСеть.Организация
	|ГДЕ
	|	НЕ СостоянияСинхронизацииТорговыеПредложения.ТорговоеПредложение.ПометкаУдаления";
	
	КоличествоТорговыхСоглашений = Запрос.Выполнить().Выбрать().Количество();
	Элементы.ТорговыеПредложенияУспех.Видимость  = КоличествоТорговыхСоглашений <> 0;
	Элементы.ТорговыеПредложенияОшибка.Видимость = КоличествоТорговыхСоглашений = 0;
	
	Если КоличествоТорговыхСоглашений <> 0 Тогда
		Элементы.ТорговыеПредложенияУспехНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Торговые предложения настроены (%1)'"),
			КоличествоТорговыхСоглашений);
	КонецЕсли;
	
	// Расписание.
	АвтоматическиСинхронизировать = АвтоматическаяСинхронизацияВключена();
	Элементы.СинхронизацияРасписание.Заголовок   = ТекущееРасписание();
	Элементы.СинхронизацияРасписание.Доступность = АвтоматическиСинхронизировать;
	Элементы.НастроитьРасписание.Доступность     = АвтоматическиСинхронизировать;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.НастроитьРасписание.Видимость     = Ложь;
		Элементы.СинхронизацияРасписание.Видимость = Ложь;
	КонецЕсли;
	
	// Проверка публикации.
	Запрос = Новый Запрос;
	Запрос.Текст = ТорговыеПредложенияПереопределяемый.ТекстЗапросаПубликуемыхТоваров(Ложь, Истина, Ложь);
	КоличествоТоваров = Запрос.Выполнить().Выбрать().Количество();
	Элементы.ОтчетУспех.Видимость  = КоличествоТоваров <> 0;
	Элементы.ОтчетОшибка.Видимость = КоличествоТоваров = 0;
	Если КоличествоТоваров Тогда
		Элементы.ОтчетУспехНадпись.Заголовок = СтрШаблон(НСтр("ru = 'Товары готовы для публикации (%1)'"), КоличествоТоваров);
	КонецЕсли;
	
	// Состояние.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	СостоянияСинхронизацииТорговыеПредложения.ТорговоеПредложение КАК ТорговоеПредложение
	|ИЗ
	|	РегистрСведений.СостоянияСинхронизацииТорговыеПредложения КАК СостоянияСинхронизацииТорговыеПредложения
	|
	|УПОРЯДОЧИТЬ ПО
	|	СостоянияСинхронизацииТорговыеПредложения.ДатаСинхронизации УБЫВ";
	
	ВыборкаСинхронизаций = Запрос.Выполнить().Выбрать();
	Если ВыборкаСинхронизаций.Следующий() Тогда
		ЭлементСостояния = Элементы.РезультатНадпись;
		ТорговыеПредложения.ОбновитьДекорациюСостоянияПубликации(ВыборкаСинхронизаций.ТорговоеПредложение, ЭлементСостояния);
		Если ПустаяСтрока(ЭлементСостояния.Заголовок) Тогда
			ЭлементСостояния.Заголовок = НСтр("ru = 'Новая публикация'");
		КонецЕсли;
		Элементы.РезультатНадпись.Гиперссылка = Ложь;
	КонецЕсли;
	
	// Проверка профиля абонента.
	// Запрос к сервису Бизнес-сеть, для получения количества регионов и адресов.
	КоличествоРегионовПродаж = 0;
	КоличествоАдресовПродаж = 0;
	НаименованиеРегиона = "";
	Если БизнесСеть.ОрганизацияЗарегистрирована() Тогда
		Отказ = Ложь;
		ТаблицыАдресовРегионов = ТорговыеПредложения.ПолучитьТаблицыАдресовАбонента(Отказ);
		Если ТаблицыАдресовРегионов <> Неопределено И ТипЗнч(ТаблицыАдресовРегионов) = Тип("Структура")
			И ТаблицыАдресовРегионов.Свойство("РегионыПродажи")
			И ТипЗнч(ТаблицыАдресовРегионов.РегионыПродажи) = Тип("ТаблицаЗначений") Тогда
			КоличествоРегионовПродаж = ТаблицыАдресовРегионов.РегионыПродажи.Количество();
			КоличествоАдресовПродаж = ТаблицыАдресовРегионов.АдресаПродажи.Количество();
			Если КоличествоРегионовПродаж = 1 Тогда
				НаименованиеРегиона = ТорговыеПредложения.ПоследнийУровеньКонтактнойИнформации(ТаблицыАдресовРегионов.РегионыПродажи[0].ЗначенияПолей, Отказ)
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.РегионыПродажУспех.Видимость = КоличествоРегионовПродаж <> 0 ИЛИ КоличествоАдресовПродаж <> 0;
	Элементы.РегионыПродажОшибка.Видимость = КоличествоРегионовПродаж = 0 И КоличествоАдресовПродаж = 0;
	
	ЗаголовокЭлемента = "";
	Если КоличествоРегионовПродаж И КоличествоАдресовПродаж Тогда
		ЗаголовокЭлемента = СтрШаблон(НСтр("ru = 'Настроены регионы доставки (%1) и адреса самовывоза (%2)'"),
			?(ПустаяСтрока(НаименованиеРегиона), КоличествоРегионовПродаж, НаименованиеРегиона), КоличествоАдресовПродаж);
	ИначеЕсли КоличествоРегионовПродаж Тогда
		ЗаголовокЭлемента = СтрШаблон(НСтр("ru = 'Настроены регионы доставки (%1)'"),
			?(ПустаяСтрока(НаименованиеРегиона), КоличествоРегионовПродаж, НаименованиеРегиона));
	ИначеЕсли КоличествоАдресовПродаж Тогда
		ЗаголовокЭлемента = СтрШаблон(НСтр("ru = 'Настроены адреса самовывоза (%1)'"), КоличествоАдресовПродаж);
	КонецЕсли;
	Элементы.РегионыПродажУспехНадпись.Заголовок = ЗаголовокЭлемента;
	
	ЕстьОшибки = КоличествоСопоставлено = 0 ИЛИ КоличествоТоваров = 0
		ИЛИ КоличествоОрганизаций = 0
		ИЛИ КоличествоТорговыхСоглашений = 0
		ИЛИ КоличествоРегионовПродаж = 0 И КоличествоАдресовПродаж = 0;
		
	Элементы.ПубликацияКоманда.Доступность = Не ЕстьОшибки;
	
КонецПроцедуры

&НаСервере
Функция АвтоматическаяСинхронизацияВключена()
	
	Возврат ПолучитьПараметрРегламентногоЗадания("Использование", Ложь);
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПараметра)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.СинхронизацияТорговыхПредложений);
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.СинхронизацияТорговыхПредложений.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Если СписокЗаданий.Количество() = 0 Тогда
		ПараметрыЗадания.Вставить(ИмяПараметра, ЗначениеПараметра);
		РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	Иначе
		ПараметрыЗадания = Новый Структура(ИмяПараметра, ЗначениеПараметра);
		Для Каждого Задание Из СписокЗаданий Цикл
			РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, ПараметрыЗадания);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрРегламентногоЗадания(ИмяПараметра, ЗначениеПоУмолчанию)
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.СинхронизацияТорговыхПредложений);
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.СинхронизацияТорговыхПредложений.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Для Каждого Задание Из СписокЗаданий Цикл
		Возврат Задание[ИмяПараметра];
	КонецЦикла;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

&НаСервере
Функция ТекущееРасписание()
	
	Возврат ПолучитьПараметрРегламентногоЗадания("Расписание", Новый РасписаниеРегламентногоЗадания);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьСкрытьПояснения(ПоказыватьПояснения, Элементы)
	
	Элементы.ПоказатьСкрытьПояснения.Заголовок = ?(ПоказыватьПояснения, НСтр("ru = 'Скрыть пояснения'"),
		НСтр("ru = 'Показать пояснения'"));
	Элементы.ПояснениеОрганизация.Видимость         = ПоказыватьПояснения;
	Элементы.ПояснениеОтчет.Видимость               = ПоказыватьПояснения;
	Элементы.ПояснениеСинхронизация.Видимость       = ПоказыватьПояснения;
	Элементы.ПояснениеСопоставление.Видимость       = ПоказыватьПояснения;
	Элементы.ПояснениеТорговыеПредложения.Видимость = ПоказыватьПояснения;
	Элементы.ПояснениеРегионыПродаж.Видимость       = ПоказыватьПояснения;
	
КонецПроцедуры

#КонецОбласти