﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаУзлаПриСозданииНаСервере(ЭтаФорма, Отказ);
	
	СформироватьСписокВыбораПравилФормированияДоговора();
	
	Если Объект.ИспользоватьОтборПоОрганизациям Тогда
		
		ПравилоОтбораСправочников = "Отбор";
		
	Иначе
		
		Если Объект.ВыгружатьУправленческуюОрганизацию Тогда
			ПравилоОтбораСправочников = "УпрОрганизация";
		Иначе
			ПравилоОтбораСправочников = "БезОтбора";
		КонецЕсли;
		
	КонецЕсли;
	
	//Инициализируем доступность ссылок установки дата запрета редактирования и даты запрета получения
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("УстановитьДатуЗапретаПолученияДанных");
	МассивЭлементов.Добавить("УстановитьДатуЗапретаИзменений");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы,
		МассивЭлементов,
		"Доступность",
		ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДатыЗапретаИзменения));
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	ОбновитьСписокВыбораВерсийФорматаОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ФормироватьДоговора() И Не ЗначениеЗаполнено(Объект.ПравилаСозданияДоговоровКонтрагентов) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо заполнить правила формирования договоров!'"), ,
			"Объект.ПравилаСозданияДоговоровКонтрагентов");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ФлагИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаПриИзменении(Элемент)
	Объект.ПравилаОтправкиДокументов = "НеСинхронизировать";
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковСОтборомПриИзменении(Элемент)
	УстрановитьУсловияОрганиченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковБезОтбораСУпрПриИзменении(Элемент)
	УстрановитьУсловияОрганиченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковБезОтбораБезУпрПриИзменении(Элемент)
	УстрановитьУсловияОрганиченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПутьКМенеджеруОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	НастройкиДиалога = Новый Структура;
	НастройкиДиалога.Вставить("Фильтр", НСтр("ru = 'Менеджер обмена (*.epf)'") + "|*.epf" );
	
	Оповещение = Новый ОписаниеОповещения("ЗавершениеВыбораФайлаМенеджераОбмена", ЭтотОбъект);
	ОбменДаннымиКлиент.ВыбратьИПередатьФайлНаСервер(Оповещение, НастройкиДиалога, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагОтправлятьВидыЦенНоменклатуры(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры
#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизаций(Команда)
	
	Если Не Объект.ВыгружатьУправленческуюОрганизацию
		Или Не ПолучитьФункциональнуюОпциюИнтерфейса("ИспользоватьУправленческуюОрганизацию") Тогда
		
		КоллекцияФильтров = Новый Массив;
		
		Накладываемыефильтры = Новый Структура();
		Накладываемыефильтры.Вставить("РеквизитОтбора",    "Ссылка");
		Накладываемыефильтры.Вставить("Условие",           "<>");
		Накладываемыефильтры.Вставить("ИмяПараметра",      "ИсключаемаяСсылка");
		Накладываемыефильтры.Вставить("ЗначениеПараметра", 
			ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.Организации.УправленческаяОрганизация"));
		
		КоллекцияФильтров.Добавить(Накладываемыефильтры);
		
	Иначе
		
		КоллекцияФильтров = Неопределено;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Организации");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокОтправляемыхВидовЦенНоменклатуры(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "ВидыЦенНоменклатуры");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "ВидЦенНоменклатуры");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.ВидыЦен");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите виды цен для отправки:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      Неопределено);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);

КонецПроцедуры

#КонецОбласти
#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура ЗавершениеВыбораФайлаМенеджераОбмена(Знач РезультатПомещенияФайлов, Знач ДополнительныеПараметры) Экспорт
	
	ОчиститьСообщения();
	
	АдресПомещенногоФайла = РезультатПомещенияФайлов.Хранение;
	ТекстОшибки           = РезультатПомещенияФайлов.ОписаниеОшибки;
	
	Объект.ПутьКМенеджеруОбмена = РезультатПомещенияФайлов.Имя;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	Элементы.ДатаНачалаВыгрузкиДокументов.Доступность =
		?(Объект.ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация", Истина, Ложь);
	Элементы.ПереключательДокументыНеОтправлять.Доступность =
		?(Не Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости", Истина, Ложь);
	Элементы.ОписаниеДокументыНеОтправлять.Доступность =
		?(Не Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости", Истина, Ложь);
	Элементы.ГруппаДокументы.ПодчиненныеЭлементы.ГруппаРежимОтправкиДокументов.Доступность =
		?(Не Объект.ПравилаОтправкиСправочников = "НеСинхронизировать", Истина, Ложь);
	Элементы.ГруппаНастройкаДополнительныхОтборов.Видимость =
		?((Объект.ПравилаОтправкиСправочников <> "НеСинхронизировать"
			Или Объект.ПравилаОтправкиДокументов <> "НеСинхронизировать"), Истина, Ложь);
	Элементы.ПравилаПолученияДанных.Видимость = Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	
	#Область ГруппаНастройкаДополнительныхОтборов
		
	#Область ГруппаСтраницыОтборПоОрганизациям
	Элементы.ГруппаСтраницыОтборПоОрганизациям.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если Элементы.ГруппаСтраницыОтборПоОрганизациям.Видимость Тогда
		
		Если Объект.ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
			Элементы.ГруппаСтраницыОтборПоОрганизациям.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОтборПоОрганизациямПустая;
		Иначе
			
			Элементы.ГруппаСтраницыОтборПоОрганизациям.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОтборПоОрганизациям;
			
			Элементы.ОткрытьСписокВыбранныхОрганизаций.Доступность = Объект.ИспользоватьОтборПоОрганизациям;
			
			//Видимость управленческой организации и варианта отбора
			ИспользоватьУправленческуюОрганизацию =
				ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию")
					И Не Объект.ВариантНастройки = "ОбменУП2ЗУП3";
					
			// Видимость управленческой организации и вариантаотбора.
			Элементы.ГруппаВыборУправленческойОрганизации.Видимость = ИспользоватьУправленческуюОрганизацию;
			
			Если Элементы.ГруппаВыборУправленческойОрганизации.Видимость Тогда
				
				Элементы.ГруппаСтраницыВариантВыбораОтбора.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаПереключательОтбора;
				
			Иначе
				
				Элементы.ГруппаСтраницыВариантВыбораОтбора.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаФлагОтбора;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьВидимостьГруппыНаСервере(Элементы, "ГруппаСоставДополнительныхОтборов");
	УстановитьВидимостьГруппыНаСервере(Элементы, "ГруппаНастройкаДополнительныхОтборов");
	#КонецОбласти
	
	#Область ВидыЦен
	// Видимость выгружаемых видов цен.
	Если Объект.ПравилаОтправкиСправочников = "НеСинхронизировать"
		Или Объект.ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости"
		Или Объект.ВариантНастройки = "ОбменУП2ЗУП3" Тогда
		
		Элементы.ГруппаСтраницыОтправлятьВидыЦенНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьВидыЦенНоменклатурыПустая;
		
	Иначе
		
		Элементы.ГруппаСтраницыОтправлятьВидыЦенНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьВидыЦенНоменклатуры;
		
		Если Объект.ВыгружатьЦеныНоменклатуры 
			И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
			
			Элементы.ГруппаСтраницыКомандаВыбратьВидыЦен.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаКомандаВыбратьВидыЦен;
			
		Иначе
			
			Элементы.ГруппаСтраницыКомандаВыбратьВидыЦен.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаКомандаВыбратьВидыЦенПустая;
			
		КонецЕсли;
	КонецЕсли;
	#КонецОбласти
	
	#КонецОбласти

	#Область ГруппаПрочее	
	#Область ГруппаВыгружатьАналитикуПоСкладам
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаВыгружатьАналитикуПоСкладам",
		"Видимость",
		Не Объект.ПравилаОтправкиДокументов = "НеСинхронизировать"
			И Не Объект.ВариантНастройки = "ОбменУП2ЗУП3");
	#КонецОбласти
		
	#Область ГруппаДатаЗапретаРедактированияДанных
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаДатаЗапретаРедактированияДанных",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьДатыЗапретаИзменения")
			И Не Объект.ПравилаОтправкиДокументов = "НеСинхронизировать");
	#КонецОбласти
	
	#Область ГруппаПравилаСозданияДоговоровКонтрагентов
	Элементы.ГруппаПравилаСозданияДоговоровКонтрагентов.Видимость = ФормироватьДоговора();
	Элементы.ПолеПравилаСозданияДоговоровКонтрагентов.АвтоОтметкаНезаполненного = ФормироватьДоговора();
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПолеПравилаСозданияДоговоровКонтрагентов",
		"Доступность",
		Элементы.ПолеПравилаСозданияДоговоровКонтрагентов.СписокВыбора.Количество() > 1);
	#КонецОбласти
		
	УстановитьВидимостьГруппыНаСервере(Элементы, "ГруппаСоставПрочихНастроек");
	УстановитьВидимостьГруппыНаСервере(Элементы, "ГруппаПрочее");
	#КонецОбласти
	
	#Область ПравилаПолученияДанных
	#Область ГруппаИнформацияНастройкаСоставаПолучаемыхДанных
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаИнформацияНастройкаСоставаПолучаемыхДанных",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьДатыЗапретаЗагрузки")
			Или Не Объект.ВариантНастройки = "ОбменУП2ЗУП3");
	#КонецОбласти
	
	#Область ГруппаДатаЗапретаПолученияДанных
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаДатаЗапретаПолученияДанных",
		"Видимость",
		ПолучитьФункциональнуюОпцию("ИспользоватьДатыЗапретаЗагрузки"));
	#КонецОбласти
	
	#Область ГруппаСкладПоУмолчанию
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаСкладПоУмолчанию",
		"Видимость",
		Не Объект.ВариантНастройки = "ОбменУП2ЗУП3");
	#КонецОбласти
	
	УстановитьВидимостьГруппыНаСервере(Элементы, "ПравилаПолученияДанных");
	#КонецОбласти

КонецПроцедуры

&НаСервере
Функция ФормироватьДоговора()
	
	Возврат (Объект.ПравилаОтправкиДокументов <> "НеСинхронизировать" И Объект.ВариантНастройки <> "ОбменУП2ЗУП3");
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		Объект[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	//Обновим заголовок выбранных организаций
	Если Объект.Организации.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = Объект.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовокОрганизаций = СтрСоединить(ВыбранныеОрганизации, ",");
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовокОрганизаций;
	
	//Обновим заголовок выбранных видов цен
	Если Объект.ВидыЦенНоменклатуры.Количество() > 0 Тогда
		
		ВыбранныеВидыЦен = Объект.ВидыЦенНоменклатуры.Выгрузить().ВыгрузитьКолонку("ВидЦенНоменклатуры");
		НовыйЗаголовокВидовЦен = СтрСоединить(ВыбранныеВидыЦен, ",");
		
	Иначе
		
		НовыйЗаголовокВидовЦен = НСтр("ru = 'Выбрать виды цен'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокОтправляемыхВидовЦенНоменклатуры.Заголовок = НовыйЗаголовокВидовЦен;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораВерсийФорматаОбмена()
	СписокВерсийФормата = Элементы.ВерсияФорматаОбмена.СписокВыбора;
	СписокВерсийФормата.Очистить();
	
	ВерсииФормата = Новый Соответствие;
	ОбменДаннымиУТ.ДоступныеВерсииУниверсальногоФормата(ВерсииФормата);
	
	Для Каждого ВерсияФормата Из ВерсииФормата Цикл
		СписокВерсийФормата.Добавить(ВерсияФормата.Ключ);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	ТабличнаяЧасть           = Объект[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения];
	ТаблицаВыбранныхЗначений = ТабличнаяЧасть.Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	МассивВыбранныхЗначений  = ТаблицаВыбранныхЗначений.ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
	Возврат МассивВыбранныхЗначений;

КонецФункции

&НаКлиенте
Процедура УстрановитьУсловияОрганиченияСинхронизации()
	
	Если ПравилоОтбораСправочников = "Отбор" Тогда
		
		Объект.ИспользоватьОтборПоОрганизациям = Истина;
		Объект.ВыгружатьУправленческуюОрганизацию = Ложь;
		
	ИначеЕсли ПравилоОтбораСправочников = "УпрОрганизация" Тогда
		
		Объект.ИспользоватьОтборПоОрганизациям = Ложь;
		Объект.ВыгружатьУправленческуюОрганизацию = Истина;
		
	ИначеЕсли ПравилоОтбораСправочников = "БезОтбора" Тогда
		
		Объект.ИспользоватьОтборПоОрганизациям = Ложь;
		Объект.ВыгружатьУправленческуюОрганизацию = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьГруппыНаСервере(ЭлементыФормы, ИмяГруппы)
	
	ГруппаФормы = ЭлементыФормы.Найти(ИмяГруппы);
	
	Если ГруппаФормы = Неопределено
		Или Не ТипЗнч(ГруппаФормы) = Тип("ГруппаФормы") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Видимость = Ложь;
	
	Для Каждого ПодчиненныйЭлемент Из ГруппаФормы.ПодчиненныеЭлементы Цикл
		
		Если Не ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы")	Тогда
			Продолжить; // устанавливаем видимость только по видимости дочерних групп первого уровня вложенности
		КонецЕсли;
		
		Видимость = Видимость ИЛИ ПодчиненныйЭлемент.Видимость;
			
	КонецЦикла;
	
	ГруппаФормы.Видимость = Видимость;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокВыбораПравилФормированияДоговора()
	
	// Сформируем список выбора для реквизита "ПравилаСозданияДоговоровКонтрагентов"
	СписокПравилФормированияДоговора = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.СписокПравилФормированияДоговора();
	Элементы.ПолеПравилаСозданияДоговоровКонтрагентов.СписокВыбора.Очистить();
	Для Каждого ЭлементПравил Из СписокПравилФормированияДоговора Цикл
		Элементы.ПолеПравилаСозданияДоговоровКонтрагентов.СписокВыбора.Добавить(ЭлементПравил.Значение, ЭлементПравил.Представление);
	КонецЦикла;
	
	Если СписокПравилФормированияДоговора.Количество() = 1 Тогда
		Объект.ПравилаСозданияДоговоровКонтрагентов = СписокПравилФормированияДоговора[0].Значение;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ПравилаСозданияДоговоровКонтрагентов)
		И СписокПравилФормированияДоговора.НайтиПоЗначению(Объект.ПравилаСозданияДоговоровКонтрагентов) = Неопределено Тогда
		
		Объект.ПравилаСозданияДоговоровКонтрагентов = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

