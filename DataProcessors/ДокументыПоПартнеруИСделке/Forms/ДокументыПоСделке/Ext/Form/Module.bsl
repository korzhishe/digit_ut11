﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");

	ИмяФормыНастройкаСоставаВидовДокументов = ОбработкаОбъект.Метаданные().ПолноеИмя()
			+ ".Форма.НастройкаСоставаВидовДокументов";

	УстановитьКлючНастроек();

	ЗаполнитьТаблицуЗапросов(ОбработкаОбъект);

	ОбновитьСписокВидовДокументов();

	ВосстановитьНастройки();

	ОбновитьТекстЗапроса();

	УстановитьЗначенияПоУмолчанию();

	ПрименитьПараметрыКоманды();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()

	СохранитьНастройки();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТолькоАктуальныеПриИзменении(Элемент)
	
	ОбработатьИзменениеФлагаТолькоАктуальныеНаСервере()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДокументов

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.Документ);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСоставДокументов(Команда)

	РедактироватьСоставДокументов();

КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)

	ОбновитьТаблицуДокументовНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)

	ВыборПериода(ПериодВыборкиДокументов);

КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)

	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда

		ПоказатьЗначение(Неопределено, ТекущиеДанные.Документ);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Настройки

&НаСервере
Процедура ВосстановитьНастройки()

	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.ДокументыПоПартнеру", КлючНастроек);
	Если ТипЗнч(ЗначениеНастроек) = Тип("Соответствие") Тогда

		ЗначениеИзНастройки = ЗначениеНастроек.Получить("СписокВидовДокументов");
		Если ТипЗнч(ЗначениеИзНастройки) = Тип("СписокЗначений") Тогда
			ПрименитьНастройкиКСпискуВидовДокументов(ЗначениеИзНастройки);
		КонецЕсли;

		ПериодВыборкиДокументов.ДатаНачала    = ЗначениеНастроек.Получить("ДатаНачала");
		ПериодВыборкиДокументов.ДатаОкончания = ЗначениеНастроек.Получить("ДатаОкончания");

		Партнер = ЗначениеНастроек.Получить("Параметр");

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	Настройки = Новый Соответствие;
	Настройки.Вставить("Партнер",               Параметр);
	Настройки.Вставить("СписокВидовДокументов", СписокВидовДокументов);
	Настройки.Вставить("ДатаНачала",            ПериодВыборкиДокументов.ДатаНачала);
	Настройки.Вставить("ДатаОкончания",         ПериодВыборкиДокументов.ДатаОкончания);

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.ДокументыПоПартнеру", КлючНастроек, Настройки);

КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()
	
	Если Не ЗначениеЗаполнено(ПериодВыборкиДокументов.ДатаНачала)
		Или Не ЗначениеЗаполнено(ПериодВыборкиДокументов.ДатаОкончания) Тогда
		
		ПериодВыборкиДокументов.ДатаНачала    = ДобавитьМесяц(ТекущаяДатаСеанса(), - 12);
		ПериодВыборкиДокументов.ДатаОкончания = ТекущаяДатаСеанса();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКлючНастроек()

	Если Параметры.Свойство("КлючНастроек") И Не ПустаяСтрока(Параметры.КлючНастроек) Тогда

		КлючНастроек = Параметры.КлючНастроек;

	Иначе

		КлючНастроек = "БезСделки";

	КонецЕсли;

	КлючНастроек = КлючНастроек + "_" + Пользователи.ТекущийПользователь().УникальныйИдентификатор();

	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Сделка") Тогда

		КлючНастроек = КлючНастроек + "_" + Параметры.Отбор.Сделка.УникальныйИдентификатор();

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ОбновитьТекстЗапроса()

	ВремТекстЗапросаВт     = "";
	ВремТекстЗапросаДанные = "";
	Для Каждого СтрокаТаб Из ТаблицаЗапросов.НайтиСтроки(Новый Структура("Использовать", Истина)) Цикл

		ВремТекстЗапросаВт = ВремТекстЗапросаВт + ?(ПустаяСтрока(ВремТекстЗапросаВт), "", " ОБЪЕДИНИТЬ ВСЕ " + Символы.ПС)
				+ СтрокаТаб.ТекстЗапроса;

		ВремТекстЗапросаДанные = ВремТекстЗапросаДанные + ?(ПустаяСтрока(ВремТекстЗапросаДанные), "", " ОБЪЕДИНИТЬ ВСЕ " + Символы.ПС)
				+ СтрокаТаб.ТекстЗапросаВыборка;

	КонецЦикла;

	Позиция = СтрНайти(ВРЕГ(ВремТекстЗапросаВт), ВРег("//%ПОМЕСТИТЬ%"));
	Если Позиция > 0 Тогда

		ВремТекстЗапросаВт = ЛЕВ(ВремТекстЗапросаВт, Позиция-1) + Сред(ВремТекстЗапросаВт, Позиция + СтрДлина("//%ПОМЕСТИТЬ%"));

	КонецЕсли;

	Позиция = СтрНайти(ВРЕГ(ВремТекстЗапросаДанные), ВРег("Выбрать"));
	Если Позиция > 0 Тогда

		ВремТекстЗапросаДанные = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + Сред(ВремТекстЗапросаДанные, Позиция + СтрДлина("Выбрать")) + 
		"УПОРЯДОЧИТЬ ПО
		|	Дата,
		|	Документ
		|";

	КонецЕсли;

	ТекстЗапросаФильтр       = ВремТекстЗапросаВт;
	ТекстЗапросаПоДокументам = ВремТекстЗапросаДанные;

КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакИспользованияВидаДокумента()

	Для Каждого СтрокаТаб Из ТаблицаЗапросов Цикл

		ЭлементСписка = СписокВидовДокументов.НайтиПоЗначению(СтрокаТаб.ИмяДокумента);
		Если ЭлементСписка <> Неопределено Тогда
			СтрокаТаб.Использовать = ЭлементСписка.Пометка;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВидовДокументов()

	СписокВидовДокументов.Очистить();
	Для Каждого Строка Из ТаблицаЗапросов Цикл
		СписокВидовДокументов.Добавить(Строка.ИмяДокумента, Строка.СинонимДокумента, Строка.Использовать);
	КонецЦикла;

	СписокВидовДокументов.СортироватьПоЗначению(НаправлениеСортировки.Возр);

КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкиКСпискуВидовДокументов(ЗначениеНастройки)

	ПереформироватьЗапрос = Ложь;
	Для Каждого Элемент Из ЗначениеНастройки Цикл

		ЭлементСписка = СписокВидовДокументов.НайтиПоЗначению(Элемент.Значение);
		Если ЭлементСписка <> Неопределено И ЭлементСписка.Пометка <> Элемент.Пометка Тогда

			ЭлементСписка.Пометка = Элемент.Пометка;
			ПереформироватьЗапрос = Истина;

		КонецЕсли;

	КонецЦикла;

	Если ПереформироватьЗапрос Тогда

		УстановитьПризнакИспользованияВидаДокумента();

		ОбновитьТекстЗапроса();

		СохранитьНастройки();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСоставДокументов()

	Результат = Неопределено;


	ОткрытьФорму(ИмяФормыНастройкаСоставаВидовДокументов,
			Новый Структура("СписокВидовДокументов", СписокВидовДокументов),,,,, Новый ОписаниеОповещения("РедактироватьСоставДокументовЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСоставДокументовЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
        
        ПрименитьНастройкиКСпискуВидовДокументов(Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыборПериода(Период)

	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Период;
	Диалог.Показать(
		Новый ОписаниеОповещения("ВыборПериодаЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериодаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Период = Результат;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуДокументовНаСервере()

	Если ПустаяСтрока(ТекстЗапросаПоДокументам) Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Необходимо настроить состав документов'"),,"ЭтаФорма");
		Возврат;

	КонецЕсли;

	Запрос = Новый Запрос(ТекстЗапросаФильтр);
	Запрос.УстановитьПараметр("Параметр",         Параметр);
	Запрос.УстановитьПараметр("НачалоПериода",    ПериодВыборкиДокументов.ДатаНачала);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ПериодВыборкиДокументов.ДатаОкончания);
	Запрос.МенеджерВременныхТаблиц  = Новый МенеджерВременныхТаблиц;

	УстановитьПривилегированныйРежим(Истина);
	Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);

	Запрос.Текст = ТекстЗапросаПоДокументам;

	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(), "ТаблицаДокументов");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЗапросов(ОбработкаОбъект)

	ТаблицаЗапросов.Очистить();
	
	ДополнительныеДокументы = Новый Массив;
	ДополнительныеДокументы.Добавить(Метаданные.Документы.РасходныйОрдерНаТовары);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ПриходныйОрдерНаТовары);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ПриходныйКассовыйОрдер);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.РасходныйКассовыйОрдер);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.СписаниеБезналичныхДенежныхСредств);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.СписаниеЗадолженности);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ПоступлениеБезналичныхДенежныхСредств);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ОперацияПоПлатежнойКарте);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ВзаимозачетЗадолженности);
	ДополнительныеДокументы.Добавить(Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств);

	ПоляШапки = Новый Массив;
	ПоляШапки.Добавить("СуммаДокумента");
	ПоляШапки.Добавить("Валюта");
	ПоляШапки.Добавить("Склад");
	ПоляШапки.Добавить("Организация");

	ОбработкаОбъект.ЗаполнитьТаблицуЗапросов(ТаблицаЗапросов, "ДокументыПоСделке",
			ДополнительныеДокументы,
			ПоляШапки,
			Истина,
			ТолькоАктуальные);

КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеФлагаТолькоАктуальныеНаСервере()

	ЗаполнитьТаблицуЗапросов(РеквизитФормыВЗначение("Объект"));
	ОбновитьТекстЗапроса();
	ОбновитьТаблицуДокументовНаСервере();

КонецПроцедуры 

 &НаСервере
Процедура ПрименитьПараметрыКоманды()

	// Чтение и установка параметров открытия.
	Если Параметры.Свойство("Отбор") Тогда

		Параметры.Отбор.Свойство("Сделка", Параметр);

	КонецЕсли;

	Если Параметры.Свойство("СформироватьПриОткрытии") И Параметры.СформироватьПриОткрытии Тогда

		ОбновитьТаблицуДокументовНаСервере();

	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		Элементы.Параметр.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
