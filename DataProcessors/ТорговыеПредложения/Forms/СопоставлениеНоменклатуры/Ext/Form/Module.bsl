﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТорговыеПредложенияПереопределяемый.ИнициализацияСпискаСопоставленияНоменклатуры(Элементы.Список);
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьВидыНоменклатуры = ТорговыеПредложенияПереопределяемый.ФункциональнаяОпцияИспользуется(ИмяФормы);
	Если Не ИспользоватьВидыНоменклатуры Тогда
		ТорговыеПредложенияПереопределяемый.СообщитьОНеобходимостиИспользованияФункциональнойОпции(
			ИмяФормы, ИспользоватьВидыНоменклатуры, Отказ);
		Возврат;
	КонецЕсли;
	
	ИнформационнаяБазаФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ТипыЗначенийСвойств = ТорговыеПредложенияПереопределяемый.ДоступныеТипыЗначенийСвойствДляСопоставления();
	
	ПустаяСсылкаРеквизитаОбъекта = ТорговыеПредложенияПереопределяемый.ПустаяСсылкаРеквизитаОбъектаДляСопоставления();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбновитьРеквизитыСервиса", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "Категория" И Не Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
		ВыбратьКатегориюСервиса();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРеквизиты

&НаКлиенте
Процедура РеквизитыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаРеквизита = Элементы.Реквизиты.ТекущиеДанные;
	СтрокаВидаНоменклатуры = Элементы.Список.ТекущиеДанные;
	Если Поле.Имя = "РеквизитыСоответствие" Тогда
		СтандартнаяОбработка = Ложь;
		Если СтрокаРеквизита.ВозможноСопоставление Тогда
			ОбработчикЗакрытия = Новый ОписаниеОповещения("ОбновитьСоответствие", ЭтотОбъект, Элементы.Список.ТекущиеДанные.Ссылка);
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("РеквизитОбъекта",                 СтрокаРеквизита.РеквизитОбъекта);
			ПараметрыОткрытия.Вставить("ВидНоменклатуры",                 СтрокаВидаНоменклатуры.Ссылка);
			ПараметрыОткрытия.Вставить("ТипЗначения",                     СтрокаРеквизита.ТипЗначения);
			ПараметрыОткрытия.Вставить("ИдентификаторКатегории",          СтрокаВидаНоменклатуры.ИдентификаторКатегории);
			ПараметрыОткрытия.Вставить("ИдентификаторРеквизитаКатегории", СтрокаРеквизита.ИдентификаторРеквизитаКатегории);
			ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.СопоставлениеЗначений", ПараметрыОткрытия,,,,, ОбработчикЗакрытия);
		КонецЕсли;
	ИначеЕсли Поле.Имя = "РеквизитыТипРеквизитаРубрикатора" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ИдентификаторКатегории",          СтрокаВидаНоменклатуры.ИдентификаторКатегории);
		ПараметрыОткрытия.Вставить("ИдентификаторРеквизитаКатегории", СтрокаРеквизита.ИдентификаторРеквизитаКатегории);
		ПараметрыОткрытия.Вставить("Категория",                       СтрокаВидаНоменклатуры.Категория);
		ПараметрыОткрытия.Вставить("ТипРеквизитаРубрикатора",         СтрокаРеквизита.ТипРеквизитаРубрикатора);
		ПараметрыОткрытия.Вставить("ПредставлениеРеквизитаКатегории", СтрокаРеквизита.ПредставлениеРеквизитаКатегории);
		ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ПросмотрЗначений", ПараметрыОткрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыРеквизитОбъектаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Реквизиты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииРеквизитаОбъекта(ТекущиеДанные);
	
КонецПроцедуры

// Определяет, что тип значения содержит тип дополнительных значений свойств.
//
// Параметры:
//  ТипЗначения	 - ОписаниеТипов - передаваемые типы.
// 
// Возвращаемое значение:
//  Булево - результат проверки.
//
&НаКлиенте
Функция ТипЗначенияСодержитЗначенияСвойств(ТипЗначения)
	
	Результат = Ложь;
	
	Для Каждого ДоступныйТип Из ТипыЗначенийСвойств Цикл
		Если ТипЗначения.СодержитТип(ДоступныйТип.Значение) Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура РеквизитыПриАктивизацииСтроки(Элемент)
	
	ДанныеВыбора = Новый СписокЗначений;
	ТекущиеДанные = Элементы.Реквизиты.ТекущиеДанные;
	
	Элементы.РеквизитыРеквизитОбъекта.СписокВыбора.Очистить();
	
	Для Каждого ЭлементСписка Из СписокВыбораРеквизитов Цикл
		Если Реквизиты.НайтиСтроки(Новый Структура("РеквизитОбъекта", ЭлементСписка.Значение)).Количество()
			И ТекущиеДанные.РеквизитОбъекта <> ЭлементСписка.Значение Тогда
			Продолжить;
		КонецЕсли;
		Элементы.РеквизитыРеквизитОбъекта.СписокВыбора.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыРеквизитОбъектаОткрытие(Элемент, СтандартнаяОбработка)
	
	Если Элементы.Реквизиты.ТекущиеДанные.РеквизитОбъекта = Неопределено
		ИЛИ Не ЗначениеЗаполнено(Элементы.Реквизиты.ТекущиеДанные.РеквизитОбъекта) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьКатегорию(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И Не ТекущиеДанные.ЭтоГруппа Тогда
		ВыбратьКатегориюСервиса();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКатегорию(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() <> 0 Тогда
		РежимУдаления = Истина;
		Отказ = Ложь;
		ОчиститьСопоставлениеКатегорий(Элементы.Список.ВыделенныеСтроки, Отказ);
		
		Если Не Отказ Тогда
			Элементы.Список.Обновить();
			ТекущийВидНоменклатуры = Неопределено;
			ОбновитьРеквизитыСервиса();
			Оповестить("ТорговыеПредложение_СопоставлениеНоменклатуры");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьРеквизит(Команда)
	
	ТекущиеДанные = Элементы.Реквизиты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ Не ЗначениеЗаполнено(ТекущиеДанные.РеквизитОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.РеквизитОбъекта = Неопределено;
	ПриИзмененииРеквизитаОбъекта(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьРеквизитыСервиса()
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.ТорговыеПредложения.Форма.СопоставлениеНоменклатуры.ПолучитьРеквизитыРубрикатора");
	
	Если ТекущийВидНоменклатуры <> Элементы.Список.ТекущиеДанные.Ссылка И Не Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		ТекущийВидНоменклатуры = Элементы.Список.ТекущиеДанные.Ссылка;
	ИначеЕсли Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда 
		Если ИдентификаторЗадания <> Неопределено Тогда
			ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		КонецЕсли;
		Элементы.ГруппаСтраницРеквизитовСервиса.ТекущаяСтраница = Элементы.СтраницаРеквизитов;
		Реквизиты.Очистить();
		Возврат;
	Иначе
		Возврат;
	КонецЕсли;
	
	Ссылка = Элементы.Список.ТекущаяСтрока;
	ИдентификаторКатегории = Элементы.Список.ТекущиеДанные.ИдентификаторКатегории;
	
	// Длительные операции.
	Если Не ЗначениеЗаполнено(ИдентификаторКатегории) Тогда
		Реквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ВидНоменклатуры", Ссылка);
	ПараметрыПроцедуры.Вставить("ИдентификаторКатегории", ИдентификаторКатегории);
	
	СписокВыбораРеквизитов.Очистить();
	
	Если ИнформационнаяБазаФайловая Тогда
		
		ПолучитьРеквизитыРубрикатора(ПараметрыПроцедуры);
		
	Иначе
		
		Если ИдентификаторЗадания <> Неопределено Тогда
			ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		КонецЕсли;
		
		Элементы.ГруппаСтраницРеквизитовСервиса.ТекущаяСтраница = Элементы.СтраницаДлительногоОжидания;
		
		Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
		Задание.Наименование = НСтр("ru = '1С:Бизнес-сеть. Получение реквизитов рубрикатора'");
		Задание.ИмяПроцедуры = "ТорговыеПредложения.ПолучитьРеквизитыРубрикатора";
		Задание.ПараметрыПроцедуры = ПараметрыПроцедуры;
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ТекстСообщения = Задание.Наименование;
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
		ПараметрыОжидания.ВыводитьСообщения = Истина;
		
		ДлительнаяОперация = ВыполнитьЗаданиеВФоне(Задание, УникальныйИдентификатор);
		
		ИдентификаторЗадания = ДлительнаяОперация.ИдентификаторЗадания;
		
		ПараметрыПроцедуры.Вставить("ИдентификаторЗадания", ИдентификаторЗадания);
		ДлительнаяОперацияЗавершение = Новый ОписаниеОповещения(
			"ДлительнаяОперацияЗавершение", ЭтотОбъект, ПараметрыПроцедуры);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация,
			ДлительнаяОперацияЗавершение,
			ПараметрыОжидания);
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПолучитьРеквизитыРубрикатора(ПараметрыПроцедуры)
	
	АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ТорговыеПредложения.ПолучитьРеквизитыРубрикатора(ПараметрыПроцедуры, АдресРезультата);
	Если ЗначениеЗаполнено(АдресРезультата)
		И ЭтоАдресВременногоХранилища(АдресРезультата)
		И ТекущийВидНоменклатуры = ПараметрыПроцедуры.ВидНоменклатуры Тогда
		
		ЗаполнитьСопоставлениеРеквизитов(АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизитаОбъекта(ТекущиеДанные)
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.РеквизитОбъекта) Тогда
		ТекущиеДанные.РеквизитОбъекта = ПустаяСсылкаРеквизитаОбъекта;
	КонецЕсли;
	
	Отказ = Ложь;
	СохранитьСопоставлениеРеквизитов(Элементы.Список.ТекущиеДанные.Ссылка, ТекущиеДанные.РеквизитОбъекта,
		ТекущиеДанные.ИдентификаторРеквизитаКатегории, ТекущиеДанные.ПредставлениеРеквизитаКатегории,
		Элементы.Список.ТекущиеДанные.ИдентификаторКатегории, ТекущиеДанные.ТипЗначения, Отказ);
		
	Если Не ЗначениеЗаполнено(ТекущиеДанные.РеквизитОбъекта) Тогда
		ТекущиеДанные.Сопоставлено = Неопределено;
	КонецЕсли;
	
	ВозможноСопоставление = Ложь; ЗначениеСопоставления = "";
	Если ТипЗначенияСодержитЗначенияСвойств(Элементы.Реквизиты.ТекущиеДанные.ТипЗначения)
		И Элементы.Реквизиты.ТекущиеДанные.ТипРеквизитаРубрикатора = "Список" Тогда
		ВозможноСопоставление = Истина;
		ЗначениеСопоставления = СоответствиеЗначенийВСтроке(Элементы.Список.ТекущаяСтрока, ТекущиеДанные.РеквизитОбъекта);
	КонецЕсли;
	Элементы.Реквизиты.ТекущиеДанные.ВозможноСопоставление = ВозможноСопоставление;
	Элементы.Реквизиты.ТекущиеДанные.Сопоставлено = ЗначениеСопоставления;

КонецПроцедуры

&НаКлиенте
Процедура ДлительнаяОперацияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Отказ = Ложь;
	ТекстСообщения = "";
	
	Элементы.ГруппаСтраницРеквизитовСервиса.ТекущаяСтраница = Элементы.СтраницаРеквизитов;
	
	Если Результат = Неопределено Тогда  // отменено пользователем.
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Фоновое задание отменено пользователем'");
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И Результат.Статус = "Выполнено" Тогда
		
		// Обновление реквизитов.
		Если ЗначениеЗаполнено(Результат.АдресРезультата) 
			И ЭтоАдресВременногоХранилища(Результат.АдресРезультата)
			И ТекущийВидНоменклатуры = ДополнительныеПараметры.ВидНоменклатуры
			И ИдентификаторЗадания = ДополнительныеПараметры.ИдентификаторЗадания Тогда
			
			ЗаполнитьСопоставлениеРеквизитов(Результат.АдресРезультата);
			
		КонецЕсли;
		ИдентификаторЗадания = Неопределено;
		
	КонецЕсли;
	
	Если Отказ Тогда
		Если Не ПустаяСтрока(ТекстСообщения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 %2'"),
				ОбщегоНазначенияКлиент.ДатаСеанса(), ТекстСообщения));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСопоставлениеРеквизитов(АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если Результат = Неопределено Тогда
		СписокВыбораРеквизитов.Очистить();
		Реквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	Если Результат.СопоставленныеРеквизиты.Количество() Тогда
		СписокВыбораРеквизитов.Очистить();
		Элементы.РеквизитыРеквизитОбъекта.СписокВыбора.Очистить();
		Для Каждого СтрокаРеквизита Из Результат.СопоставленныеРеквизиты Цикл
			Если СписокВыбораРеквизитов.НайтиПоЗначению(СтрокаРеквизита.РеквизитОбъекта) = Неопределено Тогда
				СписокВыбораРеквизитов.Добавить(СтрокаРеквизита.РеквизитОбъекта);
			КонецЕсли;
			СписокВыбораРеквизитов.СортироватьПоПредставлению();
		КонецЦикла;
	КонецЕсли;
	
	Реквизиты.Загрузить(Результат.РеквизитыРубрикатора);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыполнитьЗаданиеВФоне(Знач Задание, УникальныйИдентификатор) 
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(Задание.ИмяПроцедуры, 
		Задание.ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКатегориюСервиса()
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.ТорговыеПредложения.Форма.СопоставлениеНоменклатуры.ВыборКатегорииРубрикатора");
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено ИЛИ Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();

	ТребуетсяОбновлениеКэшаКатегории = Ложь;
	Если ПустаяСтрока(АдресКэшаКатегорийРубрик) Тогда
		АдресКэшаКатегорийРубрик = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ТребуетсяОбновлениеКэшаКатегории = Истина;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьКатегориюСервисаПродолжение", ЭтотОбъект);
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("РежимВыбора",              Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе",       Истина);
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна",        РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("Отбор",                    Новый Структура("ЭтоГруппа", Истина));
	ПараметрыФормыВыбора.Вставить("АдресКэшаКатегорийРубрик", АдресКэшаКатегорийРубрик);
	ПараметрыФормыВыбора.Вставить("ТребуетсяОбновлениеКэшаКатегории", ТребуетсяОбновлениеКэшаКатегории);
	ПараметрыФормыВыбора.Вставить("Идентификатор",            Элементы.Список.ТекущиеДанные.ИдентификаторКатегории);
	ОткрытьФорму("Обработка.ТорговыеПредложения.Форма.ДеревоКатегорий", ПараметрыФормыВыбора,,,,, Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКатегориюСервисаПродолжение(Результат, ПараметрыВыбора) Экспорт
	
	Если Результат = Неопределено ИЛИ ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Свойство("АдресКэшаКатегорийРубрик", АдресКэшаКатегорийРубрик);
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() <> 0 И Результат.Свойство("Идентификатор") Тогда
		Отказ = Ложь;
		ЗаписатьЗначениеСопоставления(Элементы.Список.ВыделенныеСтроки, Результат, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		Элементы.Список.Обновить();
		ТекущийВидНоменклатуры = Неопределено;
		ОбновитьРеквизитыСервиса();
	КонецЕсли;
		
	Оповестить("ТорговыеПредложение_СопоставлениеНоменклатуры");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьЗначениеСопоставления(Знач Массив, Результат, Отказ)
	
	ОчиститьСопоставлениеКатегорий(Массив, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.СоответствиеВидовНоменклатуры1СБизнесСеть.СоздатьНаборЗаписей();
	Для Каждого Элемент Из Массив Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.ВидНоменклатуры = Элемент;
		НоваяЗапись.ИдентификаторКатегории = Результат.Идентификатор;
		НоваяЗапись.ПредставлениеКатегории = Результат.Представление;
	КонецЦикла;
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСоответствие(Результат, ПараметрыОбработчика) Экспорт
	
	// Обновление данных по строке.
	ТекущиеДанные = Элементы.Реквизиты.ТекущиеДанные;
	
	ТекущиеДанные.Сопоставлено = СоответствиеЗначенийВСтроке(Элементы.Список.ТекущаяСтрока,	ТекущиеДанные.РеквизитОбъекта);
	
КонецПроцедуры

&НаСервере
Функция СоответствиеЗначенийВСтроке(ВидНоменклатуры, РеквизитОбъекта)

	// Заполнение списка набора реквизитов.
	Запрос = Новый Запрос;
	
	Запрос.Текст = ТорговыеПредложенияПереопределяемый.ТекстЗапросаСоответствияЗначенийРеквизитовВидаНоменклатуры();
	
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	Запрос.УстановитьПараметр("РеквизитОбъекта", РеквизитОбъекта);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = СтрШаблон(НСтр("ru = 'Сопоставлено %1 из %2'"),
		Выборка.КоличествоСопоставленныхРеквизитов,
		Выборка.КоличествоЗначенийРеквизита);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
// Очистка сопоставлений категорий.
//
// Параметры:
//  ВидыНоменклатуры - Массив - ссылки на виды номенклатуры, для которых требуется очистить сопоставления.
//
Процедура ОчиститьСопоставлениеКатегорий(Знач ВидыНоменклатуры, Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоответствиеВидовНоменклатуры1СБизнесСеть.ВидНоменклатуры КАК ВидНоменклатуры,
	|	СоответствиеВидовНоменклатуры1СБизнесСеть.ИдентификаторКатегории КАК ИдентификаторКатегории
	|ИЗ
	|	РегистрСведений.СоответствиеВидовНоменклатуры1СБизнесСеть КАК СоответствиеВидовНоменклатуры1СБизнесСеть
	|ГДЕ
	|	СоответствиеВидовНоменклатуры1СБизнесСеть.ВидНоменклатуры В(&ВидыНоменклатуры)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеРеквизитовНоменклатуры1СБизнесСеть.ВидНоменклатуры,
	|	СоответствиеРеквизитовНоменклатуры1СБизнесСеть.РеквизитОбъекта,
	|	СоответствиеРеквизитовНоменклатуры1СБизнесСеть.ИдентификаторРеквизитаКатегории
	|ИЗ
	|	РегистрСведений.СоответствиеРеквизитовНоменклатуры1СБизнесСеть КАК СоответствиеРеквизитовНоменклатуры1СБизнесСеть
	|ГДЕ
	|	СоответствиеРеквизитовНоменклатуры1СБизнесСеть.ВидНоменклатуры В(&ВидыНоменклатуры)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеЗначенийРеквизитов1СБизнесСеть.ВидНоменклатуры,
	|	СоответствиеЗначенийРеквизитов1СБизнесСеть.РеквизитОбъекта,
	|	СоответствиеЗначенийРеквизитов1СБизнесСеть.Значение
	|ИЗ
	|	РегистрСведений.СоответствиеЗначенийРеквизитов1СБизнесСеть КАК СоответствиеЗначенийРеквизитов1СБизнесСеть
	|ГДЕ
	|	СоответствиеЗначенийРеквизитов1СБизнесСеть.ВидНоменклатуры В(&ВидыНоменклатуры)";
	
	Запрос.УстановитьПараметр("ВидыНоменклатуры", ВидыНоменклатуры);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Выборка = Результат[0].Выбрать();
	Если Выборка.Количество() = 0 Тогда
		// Если ранее не было сопоставления вида номенклатуры очистка сопоставлений не требуется.
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		// Удаление записей р/с СоответствиеВидовНоменклатуры1СБизнесСеть.
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи = РегистрыСведений.СоответствиеВидовНоменклатуры1СБизнесСеть.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ВидНоменклатуры = Выборка.ВидНоменклатуры;
			МенеджерЗаписи.ИдентификаторКатегории = Выборка.ИдентификаторКатегории;
			МенеджерЗаписи.Удалить();
		КонецЦикла;

		// Удаление записей р/с СоответствиеРеквизитовНоменклатуры1СБизнесСеть.
		Выборка = Результат[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи = РегистрыСведений.СоответствиеРеквизитовНоменклатуры1СБизнесСеть.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ВидНоменклатуры = Выборка.ВидНоменклатуры;
			МенеджерЗаписи.РеквизитОбъекта = Выборка.РеквизитОбъекта;
			МенеджерЗаписи.ИдентификаторРеквизитаКатегории = Выборка.ИдентификаторРеквизитаКатегории;
			МенеджерЗаписи.Удалить();
		КонецЦикла;
		
		// Удаление записей р/с СоответствиеЗначенийРеквизитов1СБизнесСеть.
		Выборка = Результат[2].Выбрать();
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи = РегистрыСведений.СоответствиеЗначенийРеквизитов1СБизнесСеть.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ВидНоменклатуры = Выборка.ВидНоменклатуры;
			МенеджерЗаписи.РеквизитОбъекта = Выборка.РеквизитОбъекта;
			МенеджерЗаписи.Значение = Выборка.Значение;
			МенеджерЗаписи.Удалить();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = НСтр("ru = 'Ошибка очистки сопоставления реквизитов:'") + " " + ИнформацияОбОшибке().Описание;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), "БизнесСеть");
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьСопоставлениеРеквизитов(Знач ВидНоменклатуры, Знач РеквизитОбъекта,
	Знач ИдентификаторРеквизитаКатегории, Знач ПредставлениеРеквизитаКатегории, Знач ИдентификаторКатегории,
	ТипЗначения, Отказ)
	
	Если ЗначениеЗаполнено(РеквизитОбъекта) Тогда
		
		НачатьТранзакцию();
		Попытка
			// Удаление всех старых записей для идентификатора реквизита категории.
			Если ЗначениеЗаполнено(ИдентификаторРеквизитаКатегории) Тогда
				НаборЗаписей = РегистрыСведений.СоответствиеРеквизитовНоменклатуры1СБизнесСеть.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ВидНоменклатуры.Установить(ВидНоменклатуры);
				НаборЗаписей.Отбор.ИдентификаторРеквизитаКатегории.Установить(ИдентификаторРеквизитаКатегории);
				НаборЗаписей.Прочитать();
				НаборЗаписей.Очистить();
				НаборЗаписей.Записать(Истина);
			КонецЕсли;
			МенеджерЗаписи = РегистрыСведений.СоответствиеРеквизитовНоменклатуры1СБизнесСеть.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ВидНоменклатуры = ВидНоменклатуры;
			МенеджерЗаписи.РеквизитОбъекта = РеквизитОбъекта;
			МенеджерЗаписи.ИдентификаторРеквизитаКатегории = ИдентификаторРеквизитаКатегории;
			МенеджерЗаписи.ПредставлениеРеквизитаКатегории = ПредставлениеРеквизитаКатегории;
			МенеджерЗаписи.Записать(Истина);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Ошибка записи сопоставления:'") + " " + ИнформацияОбОшибке().Описание;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), "БизнесСеть");
			Возврат;
		КонецПопытки;
		
		// Обновление типа для текущей строки.
		Если ТипЗнч(РеквизитОбъекта) = Тип("Строка") Тогда
			СписокРеквизитов = ТорговыеПредложенияПереопределяемый.РеквизитыНоменклатурыДоступныеДляПубликации();
			СвойстваРеквизита = СписокРеквизитов.Получить(РеквизитОбъекта);
			Если СвойстваРеквизита <> Неопределено Тогда
				ТипЗначения = СвойстваРеквизита.ТипЗначения;
			КонецЕсли;
		Иначе
			ТипЗначения = РеквизитОбъекта.ТипЗначения;
		КонецЕсли;
		
	Иначе
		
		НачатьТранзакцию();
		Попытка
			// Удаление сопоставления реквизитов.
			НаборЗаписей = РегистрыСведений.СоответствиеРеквизитовНоменклатуры1СБизнесСеть.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ВидНоменклатуры.Установить(ВидНоменклатуры);
			НаборЗаписей.Отбор.ИдентификаторРеквизитаКатегории.Установить(ИдентификаторРеквизитаКатегории);
			НаборЗаписей.Прочитать();
			
			// Очистка сопоставления значений реквизитов.
			Для Каждого ЗаписьРеквизита Из НаборЗаписей Цикл
				НаборЗаписейЗначений = РегистрыСведений.СоответствиеЗначенийРеквизитов1СБизнесСеть.СоздатьНаборЗаписей();
				НаборЗаписейЗначений.Отбор.ВидНоменклатуры.Значение = ВидНоменклатуры;
				НаборЗаписейЗначений.Отбор.ВидНоменклатуры.Использование = Истина;
				НаборЗаписейЗначений.Отбор.РеквизитОбъекта.Значение = ЗаписьРеквизита.РеквизитОбъекта;
				НаборЗаписейЗначений.Отбор.РеквизитОбъекта.Использование = Истина;
				НаборЗаписейЗначений.Записать();
			КонецЦикла;
			
			НаборЗаписей.Очистить();
			НаборЗаписей.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Ошибка очистки сопоставления:'") + " " + ИнформацияОбОшибке().Описание;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), "БизнесСеть");
			Возврат;
		КонецПопытки;
		
		ТипЗначения = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Надпись <Укажите реквизит>.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РеквизитыРеквизитОбъекта.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Реквизиты.РеквизитОбъекта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Укажите реквизит>'"));
	
	// Надпись <Автоматически>.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РеквизитыСоответствие.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Реквизиты.РеквизитОбъекта");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Реквизиты.ВозможноСопоставление");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Автоматически>'"));
	
КонецПроцедуры

#КонецОбласти
