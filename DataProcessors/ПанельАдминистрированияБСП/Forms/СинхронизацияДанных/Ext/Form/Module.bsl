﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	ПодсистемаСуществуетОбменДанными         = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными");
	ПодсистемаСуществуетДатыЗапретаИзменения = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения");
	
	УстановитьВидимость();
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.СинхронизацияДанныхПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбработчикОповещений(ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхПриИзменении(Элемент)
	
	ОбновитьРазрешенияПрофилейБезопасности(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрефиксУзлаРаспределеннойИнформационнойБазыПриИзменении(Элемент)
	
	ФоновоеЗадание = ЗапуститьИзменениеПрефиксаИБВФоновомЗадании();
	
	Если ФоновоеЗадание <> Неопределено
		И ФоновоеЗадание.Статус = "Выполняется" Тогда
		
		Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Доступность = Ложь;
		Элементы.ДекорацияОжиданиеИзмененияПрефикса.Видимость = Истина;
		
	КонецЕсли;
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;;
	
	Обработчик = Новый ОписаниеОповещения("ПослеИзмененияПрефикса", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьИзменениеПрефиксаИБВФоновомЗадании()
	
	ПараметрыПроцедуры = Новый Структура("НовыйПрефиксИБ, ПродолжитьНумерацию",
		НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы, Истина);
		
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Изменение префикса'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("ПрефиксацияОбъектовСлужебный.ИзменитьПрефиксИБ", ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПослеИзмененияПрефикса(ФоновоеЗадание, ДополнительныеПараметры) Экспорт

	Если Не Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Доступность Тогда
		Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Доступность = Истина;
	КонецЕсли;
	Если Элементы.ДекорацияОжиданиеИзмененияПрефикса.Видимость Тогда
		Элементы.ДекорацияОжиданиеИзмененияПрефикса.Видимость = Ложь;
	КонецЕсли;
	
	Если ФоновоеЗадание <> Неопределено
		И ФоновоеЗадание.Статус = "Выполнено" Тогда
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Префикс изменен.'"));
		
	Иначе
		
		НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы = ПрефиксЗачитанныйИзИнформационнойБазы();
		Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.ОбновитьТекстРедактирования();
		
		Если ФоновоеЗадание <> Неопределено Тогда
			ТекстОшибки = НСтр("ru='Не удалось изменить префикс.
				|См. подробности в журнале регистрации.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПрефиксЗачитанныйИзИнформационнойБазы()
	
	Возврат Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Получить();
	
КонецФункции

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляWindowsПриИзменении(Элемент)
	
	ОбновитьРазрешенияПрофилейБезопасности(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляLinuxПриИзменении(Элемент)
	
	ОбновитьРазрешенияПрофилейБезопасности(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработка оповещений от других открытых форм.
//
// Параметры:
//   ИмяСобытия - Строка - имя события. Может быть использовано для идентификации сообщений принимающими их формами.
//   Параметр - Произвольный - параметр сообщения. Могут быть переданы любые необходимые данные.
//   Источник - Произвольный - источник события. Например, в качестве источника может быть указана другая форма.
//
// Пример:
//   Если ИмяСобытия = "НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы" Тогда
//     НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы = Параметр;
//   КонецЕсли;
//
&НаКлиенте
Процедура ОбработчикОповещений(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРазрешенияПрофилейБезопасности(Элемент)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбновитьРазрешенияПрофилейБезопасностиЗавершение", ЭтотОбъект, Элемент);
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		
		МассивЗапросов = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Элемент.Имя);
		
		Если МассивЗапросов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
		МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
			МассивЗапросов, ЭтотОбъект, ОповещениеОЗакрытии);
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозвратаДиалога.ОК);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов(ИмяКонстанты)
	
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() = КонстантаЗначение Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользоватьСинхронизациюДанных" Тогда
		
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		Если КонстантаЗначение Тогда
			Запрос = МодульОбменДаннымиСервер.ЗапросНаИспользованиеВнешнихРесурсовПриВключенииОбмена();
		Иначе
			Запрос = МодульОбменДаннымиСервер.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов();
		КонецЕсли;
		Возврат Запрос;
		
	Иначе
		
		МенеджерЗначения = КонстантаМенеджер.СоздатьМенеджерЗначения();
		ИдентификаторКонстанты = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МенеджерЗначения.Метаданные());
		
		МодульРаботаВБезопасномРежиме = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежиме");
		Если ПустаяСтрока(КонстантаЗначение) Тогда
			
			Запрос = МодульРаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(ИдентификаторКонстанты);
			
		Иначе
			
			Разрешения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(КонстантаЗначение, Истина, Истина));
			Запрос = МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения, ИдентификаторКонстанты);
			
		КонецЕсли;
		
		Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запрос);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьРазрешенияПрофилейБезопасностиЗавершение(Результат, Элемент) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
	
		Подключаемый_ПриИзмененииРеквизита(Элемент);
		
	Иначе
		
		ЭтотОбъект.Прочитать();
	
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимость()
	
	Если РазделениеВключено Тогда
		Элементы.ОписаниеРаздела.Заголовок = НСтр("ru = 'Синхронизация данных с моими приложениями.'");
	КонецЕсли;
	
	Если ПодсистемаСуществуетОбменДанными Тогда
		МассивДоступныхВерсий = Новый Соответствие;
		МодульОбменДаннымиПереопределяемый = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиПереопределяемый");
		МодульОбменДаннымиПереопределяемый.ПриПолученииДоступныхВерсийФормата(МассивДоступныхВерсий);
		
		Элементы.ГруппаЗагрузкаДанныхEnterpriseData.Видимость = ?(МассивДоступныхВерсий.Количество() = 0, Ложь, Истина);
		
		Элементы.ГруппаПрефиксУзлаРаспределеннойИнформационнойБазы.РасширеннаяПодсказка.Заголовок =
			Метаданные.Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Подсказка;
			
		Если РазделениеВключено Тогда
			Элементы.ГруппаИспользоватьСинхронизациюДанных.Видимость   = Ложь;
			Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = Ложь;
			
			Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Заголовок = НСтр("ru = 'Префикс в этой программе'");
		Иначе
			Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = Не ОбщегоНазначения.ИнформационнаяБазаФайловая()
				И Пользователи.ЭтоПолноправныйПользователь(, Истина);
		КонецЕсли;
	Иначе
		Элементы.ГруппаСинхронизацияДанных.Видимость = Ложь;
		Элементы.ГруппаПрефиксУзлаРаспределеннойИнформационнойБазы.Видимость = Ложь;
		Элементы.ГруппаСинхронизацияДанныхДополнительно.Видимость  = Ложь;
		Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = Ложь;
	КонецЕсли;
	
	Если ПодсистемаСуществуетДатыЗапретаИзменения Тогда
		МодульДатыЗапретаИзмененияСлужебный = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзмененияСлужебный");
		СвойстваРазделов = МодульДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
		
		Элементы.ГруппаДатыЗапретаЗагрузки.Видимость = СвойстваРазделов.ДатыЗапретаЗагрузкиВнедрены;
		
		Если РазделениеВключено
			И СвойстваРазделов.ДатыЗапретаЗагрузкиВнедрены Тогда
			Элементы.ИспользоватьДатыЗапретаЗагрузки.РасширеннаяПодсказка.Заголовок =
				НСтр("ru = 'Запрет загрузки данных прошлых периодов из других приложений.
				           |Не влияет на загрузку данных из автономных рабочих мест.'");
		КонецЕсли;
	Иначе
		Элементы.ГруппаДатыЗапретаЗагрузки.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ДекорацияОжиданиеИзмененияПрефикса.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДатыЗапретаЗагрузки"
			Или РеквизитПутьКДанным = "")
		И ПодсистемаСуществуетДатыЗапретаИзменения Тогда
		
		Элементы.ГруппаДатыЗапретаЗагрузкиНастройка.Доступность = НаборКонстант.ИспользоватьДатыЗапретаЗагрузки;
			
	КонецЕсли;
	
	Если (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСинхронизациюДанных"
			Или РеквизитПутьКДанным = "")
		И ПодсистемаСуществуетОбменДанными Тогда
		
		Элементы.ОткрытьРеестрНормативноСправочнойИнформации.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ОткрытьРеестрУчетныхДанных.Доступность 				 = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.НастройкиСинхронизацииДанных.Доступность            = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаДатыЗапретаЗагрузки.Доступность               = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.РезультатыСинхронизацииДанных.Доступность           = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаВременныеКаталогиКластераСерверов.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРеестрНормативноСправочнойИнформации(Команда)
	ОткрытьФорму("Отчет.РеестрНормативноСправочнойИнформации.Форма", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРеестрУчетныхДанных(Команда)
	ОткрытьФорму("Отчет.РеестрУчетныхДанных.Форма", , ЭтаФорма);
КонецПроцедуры

#КонецОбласти
