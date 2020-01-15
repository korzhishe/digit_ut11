﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");	
	
	ОбновитьСписокДоступныхТиповДокументов();
	
	СформироватьГруппуКнопокСоздать();
	
	УстановитьВидимостьЭлементов();
	
	УстановитьДоступностьКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ФормаОтметкиЭлементов" Тогда
		ВыполнитьПослеЗакрытияСпискаВыбора(ВыбранноеЗначение);
		УстановитьДоступностьКоманд(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборПоТипуДокумента(Команда)
	
	ОтборТипДокументаНачалоВыбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтборПоТипу(Команда)
	
	ОтборТипДокументаОчистка();
	УстановитьДоступностьКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РеестрДокументов(Команда)
	
	ОткрытьФорму("Отчет.РеестрТорговыхДокументов.Форма");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипДокументаОчистка()
	
	ТипыДокументов.ЗаполнитьПометки(Ложь);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Тип",
		ТипыДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ДокументыПоПартнеру(Команда)
	
	ОткрытьФорму("Обработка.ДокументыПоПартнеруИСделке.Форма.ДокументыПоПартнеру");

КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтборТипДокументаНачалоВыбора()
	
	ОткрытьФорму("ОбщаяФорма.ФормаОтметкиЭлементов",Новый Структура("СписокЗначений, Адрес", ТипыДокументов, Адрес),ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьПослеЗакрытияСпискаВыбора(СписокВыбора) 

	СписокТипов = Новый СписокЗначений();
	
	Если СписокВыбора <> Неопределено Тогда
		Для каждого ЭлементСписка Из СписокВыбора Цикл
			НайденноеЗначение = ТипыДокументов.НайтиПоЗначению(ЭлементСписка.Значение);
			ЗаполнитьЗначенияСвойств(НайденноеЗначение,ЭлементСписка);
		КонецЦикла; 
	КонецЕсли;
	
	Для каждого Элемент Из ТипыДокументов Цикл
		Если Элемент.Пометка Тогда
			СписокТипов.Добавить(Элемент.Значение);
		КонецЕсли;
	КонецЦикла;  
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Тип",
		СписокТипов,
		ВидСравненияКомпоновкиДанных.ВСписке,,
		СписокТипов.Количество() > 0);

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДоступныхТиповДокументов()
	
	СписокДоступныхМетаданных = Новый СписокЗначений();
	Для Каждого ОписаниеМетаданныхДокумента Из Метаданные.ЖурналыДокументов.РеестрТорговыхДокументов.РегистрируемыеДокументы Цикл
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОписаниеМетаданныхДокумента) Тогда
			СписокДоступныхМетаданных.Добавить(Тип("ДокументСсылка." + ОписаниеМетаданныхДокумента.Имя), ОписаниеМетаданныхДокумента.Синоним);
		КонецЕсли;
	КонецЦикла;
	
	МассивЭлементовКУдалению = Новый Массив();
	Для каждого Элемент Из ТипыДокументов Цикл
		Если СписокДоступныхМетаданных.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
			МассивЭлементовКУдалению.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла; 
	
	Для каждого Элемент Из МассивЭлементовКУдалению Цикл
		ТипыДокументов.Удалить(Элемент);
	КонецЦикла; 
	
	Для каждого Элемент Из СписокДоступныхМетаданных Цикл
		Если ТипыДокументов.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
			ТипыДокументов.Добавить(Элемент.Значение, Элемент.Представление, Элемент.Пометка);
		КонецЕсли;
	КонецЦикла; 
	
	ТипыДокументов.СортироватьПоЗначению();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()

	Элементы.Организация.Видимость 			= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Элементы.Подразделение.Видимость 		= ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения");
	Элементы.Склад.Видимость 				= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	Элементы.Касса.Видимость 				= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	Элементы.Валюта.Видимость 				= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	Элементы.Партнер.Видимость 				= Не ЭтоБазовая;
	Элементы.Менеджер.Видимость 			= Не ЭтоБазовая;
	Элементы.Дополнительно.Видимость 		= Не ЭтоБазовая;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		Команды.Найти("ДокументыПоПартнеру").Заголовок = НСтр("ru = 'Документы по контрагенту'");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СформироватьГруппуКнопокСоздать()
	
	ИспользуемыеПодсистемы = Новый Структура();
	ИерархияПодсистем = ИерархияПодсистем();
	
	Для каждого ТекСтрокаПодсистема Из ИерархияПодсистем Цикл
		ПодсистемаВерхнегоУровня = ТекСтрокаПодсистема.Значение[0];
		
		ГруппаФормы = Элементы.Вставить("Подменю" + ПодсистемаВерхнегоУровня.Имя, Тип("ГруппаФормы"), Элементы.СписокГруппаСоздать);
		ГруппаФормы.Вид = ВидГруппыФормы.Подменю;
		ГруппаФормы.Заголовок = ПодсистемаВерхнегоУровня.Синоним;
		Для каждого ТекСтрокаТип Из ТипыДокументов Цикл
			МетаДокумент = Метаданные.НайтиПоТипу(ТекСтрокаТип.Значение);
			Для каждого Элемент Из ТекСтрокаПодсистема.Значение Цикл
				Если Элемент.Состав.Содержит(МетаДокумент) Тогда
					Если Команды.Найти(МетаДокумент.Имя) = Неопределено Тогда
						НоваяКомандаФормы = Команды.Добавить(МетаДокумент.Имя);
						НоваяКомандаФормы.Заголовок = МетаДокумент.Синоним;
						НоваяКомандаФормы.Действие = "Подключаемый_Создать";
						
						КомандаНаФорме = Элементы.Вставить("Список" + МетаДокумент.Имя, Тип("КнопкаФормы"), ГруппаФормы,);
						КомандаНаФорме.ИмяКоманды = МетаДокумент.Имя;
						
						ИспользуемыеПодсистемы.Вставить(ТекСтрокаПодсистема.Ключ, ТекСтрокаПодсистема.Значение);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла; 
		КонецЦикла;
		
	КонецЦикла; 
	
	Адрес = ПоместитьВоВременноеХранилище(ИспользуемыеПодсистемы, УникальныйИдентификатор);
	
КонецПроцедуры 

&НаСервере
Функция ИерархияПодсистем()
	
	Соответствие = Новый Структура();
	Разделы = ПолучитьРазделыКомандногоИнтерфейса();
	Для каждого ПодсистемаВерхнегоУровня Из Разделы Цикл
		Если ПодсистемаВерхнегоУровня.ВключатьВКомандныйИнтерфейс и ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ПодсистемаВерхнегоУровня) Тогда
			Ключ = ПодсистемаВерхнегоУровня.Имя;
			МассивЗначений = Новый Массив();
			МассивЗначений.Добавить(ПодсистемаВерхнегоУровня);
			Соответствие.Вставить(Ключ, МассивЗначений);
			ДобавитьПодчиненнуюПодсистему(ПодсистемаВерхнегоУровня, Соответствие, Ключ);
		КонецЕсли;
	КонецЦикла; 
	
	Возврат Соответствие;
	
КонецФункции

&НаСервере
Функция ПолучитьРазделыКомандногоИнтерфейса()

	Массив = Новый Массив;
	
	Если ЭтоБазовая Тогда
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "ПродажиБазовая");
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "ЗакупкиБазовая");
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "СкладБазовая");
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "БанкИКассаБазовая");
	Иначе
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "CRMИМаркетинг");
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "Продажи");
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "Закупки");
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "Склад");
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "Казначейство");
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "РегламентированныйУчет");
		ОбщегоНазначенияУТ.ДобавитьПодсистемуВКоллекцию(Массив, "Администрирование");
	КонецЕсли;
	
	Возврат Массив;
	
КонецФункции

&НаСервере
Функция ДобавитьПодчиненнуюПодсистему(ПодсистемаВерхнегоУровня, Соответствие, Ключ)
	
	МассивЗначений = Соответствие[Ключ];
	Для каждого ПодчиненнаяПодсистема Из ПодсистемаВерхнегоУровня.Подсистемы Цикл
		МассивЗначений.Добавить(ПодчиненнаяПодсистема);
		Если ПодчиненнаяПодсистема.Подсистемы.Количество() > 0 Тогда
			ДобавитьПодчиненнуюПодсистему(ПодчиненнаяПодсистема, Соответствие, Ключ);
		КонецЕсли;
	КонецЦикла; 
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_Создать(Команда) 
	
	ОткрытьФорму("Документ." + Команда.Имя + ".ФормаОбъекта");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКоманд(Форма)

	Массив = Новый Массив();
	Для каждого ТекСтрока Из Форма.ТипыДокументов Цикл
		Если ТекСтрока.Пометка Тогда
			Массив.Добавить(ТекСтрока);
			Прервать;
		КонецЕсли;
	КонецЦикла; 
	
	Форма.Элементы.СписокОчиститьОтборПоТипу.Доступность = Массив.Количество() > 0;

КонецПроцедуры

#КонецОбласти
