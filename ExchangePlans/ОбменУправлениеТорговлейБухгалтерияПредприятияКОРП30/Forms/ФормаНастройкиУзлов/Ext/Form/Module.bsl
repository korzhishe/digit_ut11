﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрыПодключения") Тогда
		ПараметрыСоединения = Параметры.ПараметрыПодключения;
	КонецЕсли;
	
	ИменаРеквизитов                   = СтруктураСоответсвтияНастройкиОтборовРеквизитамФормы();
	ИменаРеквизитовБазыКорреспондента = СтруктураСоответсвтияНастройкиОтборовКорреспондентаРеквизитамФормы();
	
	ОбменДаннымиСервер.ФормаНастройкиУзловПриСозданииНаСервере(ЭтотОбъект, Отказ);
	
	СтруктураОтбора = Новый Структура("Использовать", Истина);
	ОрганизацииУТ.Загрузить(ОрганизацииУТ.Выгрузить(СтруктураОтбора));
	Для Каждого Строка Из ОрганизацииУТ Цикл
		Строка.Представление = Справочники.Организации.ПолучитьСсылку(Новый УникальныйИдентификатор(Строка.УникальныйИдентификаторСсылки));
	КонецЦикла;
	
	ВидыЦенНоменклатуры.Загрузить(ВидыЦенНоменклатуры.Выгрузить(СтруктураОтбора));
	Для Каждого Строка Из ВидыЦенНоменклатуры Цикл
		Строка.Представление = Справочники.ВидыЦен.ПолучитьСсылку(Новый УникальныйИдентификатор(Строка.УникальныйИдентификаторСсылки));
	КонецЦикла;
	
	СформироватьСписокВыбораПравилФормированияДоговора();
	
	Если ИспользоватьОтборПоОрганизациямУТ Тогда
		ПравилаОтбораОрганизаций = "Отбор";
	Иначе
		
		Если ВыгружатьУправленческуюОрганизацию Тогда
			ПравилаОтбораОрганизаций = "УпрОрганизация";
		Иначе
			ПравилаОтбораОрганизаций = "БезОтбора";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
				|	ВидыЦен.Ссылка
				|ИЗ
				|	Справочник.ВидыЦен КАК ВидыЦен
				|ГДЕ
				|	ВидыЦен.ПометкаУдаления = ЛОЖЬ");
				
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ВидЦеныПоУмолчанию = Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;

	//Инициализируем доступность ссылок установки дата запрета редактирования и даты запрета получения
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(
		Элементы,
		"ГруппаДатаЗапретаРедактированияДанныхУТ",
		"Видимость",
		Не ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УстановитьДатуЗапретаИзмененийУТ",
		"Доступность",
		ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДатыЗапретаИзменения));
	
	Если Не ЗначениеЗаполнено(ПравилаВыгрузкиПодразделенийУТ) Тогда
		ПравилаВыгрузкиПодразделенийУТ = "ТолькоОбособленные";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПравилаВыгрузкиПодразделенийБП) Тогда
		ПравилаВыгрузкиПодразделенийБП = "ТолькоОбособленные";
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	ПолучитьОписаниеКонтекста();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если ПравилаОтправкиДокументовУТ = "НеСинхронизировать" Тогда
		
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОбобщенныйСклад"));
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ПравилаСозданияДоговоровКонтрагентов"));
		
	Иначе
		
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки") 
			И Не ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи")
			И Не СворачиватьДокументыПоСкладу Тогда
			
			ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ОбобщенныйСклад"));
			
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если Не ЗаписатьИЗакрытьНаСервере() Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиКлиент.ФормаНастройкиУзловКомандаЗакрытьФорму(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизаций(Команда)
	
	ПараметрыФормы = Новый Структура();
	Если ТекущийЭлемент.Имя = "ОткрытьСписокВыбранныхОрганизацийУТ" Тогда
		
		ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "ОрганизацииУТ");
		ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Представление");
		ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            Неопределено);
		
		Если Не ВыгружатьУправленческуюОрганизацию
			И Не ПолучитьФункциональнуюОпциюИнтерфейса("ИспользоватьУправленческуюОрганизацию") Тогда
		
			КоллекцияФильтров = Новый Массив;
			
			Накладываемыефильтры = Новый Структура();
			Накладываемыефильтры.Вставить("РеквизитОтбора",    "Ссылка");
			Накладываемыефильтры.Вставить("Условие",           "<>");
			Накладываемыефильтры.Вставить("ИмяПараметра",      "ИсключаемаяСсылка");
			Накладываемыефильтры.Вставить("ЗначениеПараметра", 
				ПредопределенноеЗначение("Справочник.Организации.УправленческаяОрганизация"));
			
			КоллекцияФильтров.Добавить(Накладываемыефильтры);
			
		Иначе
			
			КоллекцияФильтров = Неопределено;
			
		КонецЕсли;
		
		ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);
		
	ИначеЕсли ТекущийЭлемент.Имя = "ОткрытьСписокВыбранныхОрганизацийБП" Тогда
		
		ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "ОрганизацииБП");
		ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "УникальныйИдентификаторСсылки");
		ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            ПараметрыСоединения);
		
		ПараметрыФормы.Вставить("КоллекцияФильтров",                      Неопределено);
		
	Иначе
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберите организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокОтправляемыхВидовЦенНоменклатуры(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "ВидыЦенНоменклатуры");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Представление");
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

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область СтраницаНастройкиПравилОтправкиДляИнформационнойБазыУправлениеТорговлей

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
Процедура ПереключательОтправлятьНСИАвтоматическиУТПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиУТПриИзменении(Элемент)
	
	Если ПравилаОтправкиСправочниковУТ = "СинхронизироватьПоНеобходимости" 
		И ПравилаОтправкиДокументовУТ = "НеСинхронизировать" Тогда
		
		ПравилаОтправкиДокументовУТ = "АвтоматическаяСинхронизация";
		
	КонецЕсли;

	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаУТПриИзменении(Элемент)
	ПравилаОтправкиДокументовУТ = "НеСинхронизировать";
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиУТПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюУТПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьУТПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагИспользоватьОтборПоОрганизациямУТПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагОтправлятьВидыЦенНоменклатурыПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагСворачиватьДокументыПоСкладуСВыключеннымиФОПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СтраницаНастройкиПравилОтправкиДляИнформационнойБазыБухгалтерияПредприятия

&НаКлиенте
Процедура ПереключательОтправлятьНСИАвтоматическиБППриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиБППриИзменении(Элемент)
	Если ПравилаОтправкиСправочниковБП = "СинхронизироватьПоНеобходимости" 
		И ПравилаОтправкиДокументовБП = "НеСинхронизировать" Тогда
		
		ПравилаОтправкиДокументовБП = "АвтоматическаяСинхронизация";
		
	КонецЕсли;

	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаБППриИзменении(Элемент)
	ПравилаОтправкиДокументовБП = "НеСинхронизировать";
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиБППриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюБППриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьБППриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ФлагИспользоватьОтборПоОрганизациямБППриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ПолучитьОписаниеКонтекста()
	
	ОписаниеКонтекста = (""
		+ СформироватьОписаниеПравилОтправкиУТ()
		+ Символы.ПС + Символы.ПС
		+ СформироватьОписаниеПравилОтправкиБП()
	);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	//Обновим заголовок выбранных организаций конфигурации "Управление торговлей"
	Если ОрганизацииУТ.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = ОрганизацииУТ.Выгрузить().ВыгрузитьКолонку("Представление");
		НовыйЗаголовокОрганизаций = СтрСоединить(ВыбранныеОрганизации, ",");
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизацийУТ.Заголовок = НовыйЗаголовокОрганизаций;
	
	//Обновим заголовок выбранных организаций конфигурации "Бухгалтерия предприятия"
	Если ОрганизацииБП.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = ОрганизацииБП.Выгрузить().ВыгрузитьКолонку("Представление");
		НовыйЗаголовокОрганизаций = СтрСоединить(ВыбранныеОрганизации, ",");
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизацийБП.Заголовок = НовыйЗаголовокОрганизаций;

	
	//Обновим заголовок выбранных видов цен
	Если ВидыЦенНоменклатуры.Количество() > 0 Тогда
		
		ВыбранныеВидыЦен = ВидыЦенНоменклатуры.Выгрузить().ВыгрузитьКолонку("Представление");
		НовыйЗаголовокВидовЦен = СтрСоединить(ВыбранныеВидыЦен, ",");
		
	Иначе
		
		НовыйЗаголовокВидовЦен = НСтр("ru = 'Выбрать виды цен'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокОтправляемыхВидовЦенНоменклатуры.Заголовок = НовыйЗаголовокВидовЦен;
	
КонецПроцедуры

&НаСервере
Функция СформироватьОписаниеПравилОтправкиУТ()
	
	ТекстОписанияУТ = НСтр("ru = 'Правила отправки данных из информационной базы ""Управление торговлей"" :'") + Символы.ПС;
	
	Если ПравилаОтправкиСправочниковУТ = "АвтоматическаяСинхронизация" Тогда
		
		ТекстОписанияУТ = ТекстОписанияУТ + 
			НСтр("ru = 'Вся нормативно-справочная информация регистрируется к отправке автоматически;'");
			
	ИначеЕсли ПравилаОтправкиСправочниковУТ = "СинхронизироватьПоНеобходимости" Тогда
		
		ТекстОписанияУТ = ТекстОписанияУТ + 
			НСтр("ru = 'К отправке регистрируется только используемая в документах нормативно-справочная информация;'");
			
	ИначеЕсли ПравилаОтправкиСправочниковУТ = "НеСинхронизировать" Тогда
		
		ТекстОписанияУТ = ТекстОписанияУТ + 
		НСтр("ru = 'Данные из информационной базы ""Управление торговлей"" отправляться не будут.'");
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументовУТ = "АвтоматическаяСинхронизация" Тогда
		
		Если ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументовУТ) Тогда
			
			ТекстОписанияУТ = ТекстОписанияУТ 
				+ Символы.ПС 
				+ НСтр("ru = 'Документы автоматически регистрируются к отправке начиная с %ДатаНачала%;'");
				
			ТекстОписанияУТ = СтрЗаменить( ТекстОписанияУТ,
										   "%ДатаНачала%", Формат(ДатаНачалаВыгрузкиДокументовУТ, "ДЛФ=D"));
		Иначе
			
			ТекстОписанияУТ = ТекстОписанияУТ 
				+ Символы.ПС 
				+ НСтр("ru = 'Все документы автоматически регистрируются к отправке;'");
				
		КонецЕсли;
		
	ИначеЕсли ПравилаОтправкиДокументовУТ = "ИнтерактивнаяСинхронизация" Тогда
		
		ТекстОписанияУТ = ТекстОписанияУТ 
			+ Символы.ПС 
			+ НСтр("ru = 'Пользователь самостоятельно отбирает и регистрирует необходимые ему документы к отправке;'");
		
	ИначеЕсли ПравилаОтправкиДокументовУТ = "НеСинхронизировать"
		И ПравилаОтправкиСправочниковУТ <> "НеСинхронизировать" Тогда
		
		ТекстОписанияУТ = ТекстОписанияУТ 
			+ Символы.ПС 
			+ НСтр("ru = 'Документы из информационной базы ""Управление торговлей"" отправляться не будут;'");
		
	КонецЕсли;
	
	Если ИспользоватьОтборПоОрганизациямУТ
		И ПравилаОтправкиСправочниковУТ <> "НеСинхронизировать" Тогда
		
		КоллекцияЗначений = ОрганизацииУТ.Выгрузить().ВыгрузитьКолонку("Представление");
		ПредставлениеКоллекции = СокращенноеПредставлениеКоллекцииЗначений(КоллекцияЗначений);
		ТекстОписанияУТ = ТекстОписанияУТ 
			+ Символы.ПС 
			+ НСтр("ru = 'Все данные будут
				| отправляться с отбором по организациям: %ПредставлениеКоллекции%;'");
		ТекстОписанияУТ = СтрЗаменить(ТекстОписанияУТ, "%ПредставлениеКоллекции%", ПредставлениеКоллекции);
		
	Иначе
		
		Если ПравилаОтправкиСправочниковУТ <> "НеСинхронизировать" Тогда
			
			Если ПравилаОтбораОрганизаций = "УпрОрганизация" Тогда
				ТекстОписанияУТ = ТекстОписанияУТ 
					+ Символы.ПС 
					+ НСтр("ru = 'Данные будут отправляться по всем организациям, включая управленческую;'");
			Иначе
				ТекстОписанияУТ = ТекстОписанияУТ 
					+ Символы.ПС 
					+ НСтр("ru = 'Данные будут отправляться по всем организациям, кроме ""Управленческой организации"";'");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если СворачиватьДокументыПоСкладу 
		И ПравилаОтправкиСправочниковУТ <> "НеСинхронизировать" Тогда
		
		ТекстОписанияУТ = ТекстОписанияУТ 
			+ Символы.ПС 
			+ НСтр("ru = 'При отправке документов аналитика по складу передаваться не будет.
				| Вместо указанных складов будет подставляться обобщенный склад: %ОбобщенныйСклад%;'");
		ТекстОписанияУТ = СтрЗаменить(ТекстОписанияУТ, "%ОбобщенныйСклад%", ОбобщенныйСклад);
		
	КонецЕсли;
	
	Если ВыгружатьЦеныНоменклатуры 
		И ПравилаОтправкиСправочниковУТ <> "НеСинхронизировать" Тогда
		
		КоллекцияЗначений = ВидыЦенНоменклатуры.Выгрузить().ВыгрузитьКолонку("Представление");
		ПредставлениеКоллекции = СокращенноеПредставлениеКоллекцииЗначений(КоллекцияЗначений);
		ТекстОписанияУТ = ТекстОписанияУТ 
			+ Символы.ПС 
			+ НСтр("ru = 'Дополнительно будет отправляться информация о ценах номенклатуры: %ПредставлениеКоллекции%.'");
		ТекстОписанияУТ = СтрЗаменить(ТекстОписанияУТ, "%ПредставлениеКоллекции%", ПредставлениеКоллекции);
		
	ИначеЕсли Не ВыгружатьЦеныНоменклатуры
		И ПравилаОтправкиСправочниковУТ = "АвтоматическаяСинхронизация" Тогда
		
		ТекстОписанияУТ = ТекстОписанияУТ 
			+ Символы.ПС 
			+ НСтр("ru = 'Цены номенклатуры отправляться не будут.'");
		
	КонецЕсли;
	
	Возврат ТекстОписанияУТ;
	
КонецФункции

&НаСервере
Функция СформироватьОписаниеПравилОтправкиБП()
	
	ТекстОписанияБП = НСтр("ru = 'Правила отправки данных из информационной базы ""Бухгалтерия предприятия"" :'") + Символы.ПС;
	
	Если ПравилаОтправкиСправочниковБП = "АвтоматическаяСинхронизация" Тогда
		
		ТекстОписанияБП = ТекстОписанияБП + 
			НСтр("ru = 'Вся нормативно-справочная информация регистрируется к отправке автоматически;'");
			
	ИначеЕсли ПравилаОтправкиСправочниковБП = "СинхронизироватьПоНеобходимости" Тогда
		
		ТекстОписанияБП = ТекстОписанияБП + 
			НСтр("ru = 'К отправке регистрируется только используемая в документах нормативно-справочная информация;'");
			
	ИначеЕсли ПравилаОтправкиСправочниковБП = "НеСинхронизировать" Тогда
		
		ТекстОписанияБП = ТекстОписанияБП + 
		НСтр("ru = 'Данные из информационной базы ""Бухгалтерия предприятия"" отправляться не будут.'");
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументовБП = "АвтоматическаяСинхронизация" Тогда
		
		Если ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументовБП) Тогда
			
			ТекстОписанияБП = ТекстОписанияБП 
				+ Символы.ПС 
				+ НСтр("ru = 'Документы автоматически регистрируются к отправке начиная с %ДатаНачала%;'");
				
			ТекстОписанияБП = СтрЗаменить( ТекстОписанияБП,
										   "%ДатаНачала%", Формат(ДатаНачалаВыгрузкиДокументовБП, "ДЛФ=D"));
										   
		Иначе
			
			ТекстОписанияБП = ТекстОписанияБП 
				+ Символы.ПС 
				+ НСтр("ru = 'Все документы автоматически регистрируются к отправке;'");
				
		КонецЕсли;
		
	ИначеЕсли ПравилаОтправкиДокументовБП = "ИнтерактивнаяСинхронизация" Тогда
		
		ТекстОписанияБП = ТекстОписанияБП 
			+ Символы.ПС 
			+ НСтр("ru = 'Пользователь самостоятельно отбирает и регистрирует необходимые ему документы к отправке;'");
		
	ИначеЕсли ПравилаОтправкиДокументовБП = "НеСинхронизировать"
		И ПравилаОтправкиСправочниковБП <> "НеСинхронизировать" Тогда
		
		ТекстОписанияБП = ТекстОписанияБП 
			+ Символы.ПС 
			+ НСтр("ru = 'Документы из информационной базы ""Бухгалтерия предприятия"" отправляться не будут;'");
		
	КонецЕсли;
	
	Если ПравилаОтправкиСправочниковБП <> "НеСинхронизировать" Тогда
		
		Если ИспользоватьОтборПоОрганизациямБП Тогда
			
			КоллекцияЗначений = ОрганизацииБП.Выгрузить().ВыгрузитьКолонку("Представление");
			ПредставлениеКоллекции = СокращенноеПредставлениеКоллекцииЗначений(КоллекцияЗначений);
			ТекстОписанияБП = ТекстОписанияБП 
				+ Символы.ПС 
				+ НСтр("ru = 'Все данные будут
					| отправляться с отбором по организациям: %ПредставлениеКоллекции%.'");
			ТекстОписанияБП = СтрЗаменить(ТекстОписанияБП, "%ПредставлениеКоллекции%", ПредставлениеКоллекции);
		
		Иначе
		
			ТекстОписанияБП = ТекстОписанияБП 
				+ Символы.ПС 
				+ НСтр("ru = 'Данные будут отправляться по всем организациям.'");
			
		КонецЕсли;
		
	КонецЕсли;

	
	Возврат ТекстОписанияБП;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	//Правила отправки информационной базы "Управление торговлей"
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаНачалаВыгрузкиДокументовУТ",
		"Доступность",
		ПравилаОтправкиДокументовУТ = "АвтоматическаяСинхронизация");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПереключательДокументыНеОтправлятьУТ",
		"Доступность",
		Не ПравилаОтправкиСправочниковУТ = "СинхронизироватьПоНеобходимости");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОписаниеДокументыНеОтправлятьУТ",
		"Доступность",
		Не ПравилаОтправкиСправочниковУТ = "СинхронизироватьПоНеобходимости");
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы.ГруппаДокументыУТ.ПодчиненныеЭлементы,
		"ГруппаРежимОтправкиДокументовУТ",
		"Доступность",
		Не ПравилаОтправкиСправочниковУТ = "НеСинхронизировать");
		
	//Видимость отбора по организациям
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Элементы,
	"ГруппаСтраницыОтборПоОрганизациямУТ",
	"Видимость",
	ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций"));
		
	Если Элементы.ГруппаСтраницыОтборПоОрганизациямУТ.Видимость Тогда

		Если ПравилаОтправкиСправочниковУТ = "НеСинхронизировать" Тогда
			
			Элементы.ГруппаСтраницыОтборПоОрганизациямУТ.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОтборПоОрганизациямПустаяУТ;
			
		Иначе
			
			Элементы.ГруппаСтраницыОтборПоОрганизациямУТ.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОтборПоОрганизациямУТ;
			
			Если ИспользоватьОтборПоОрганизациямУТ Тогда
				
				Элементы.ГруппаСтраницыКомандаВыбораОрганизаций.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаКомандаВыбратьОрганизации;
				
			Иначе
				
				Элементы.ГруппаСтраницыКомандаВыбораОрганизаций.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаКомандаВыбратьОрганизацииПустая;
				
			КонецЕсли;
			
			//Видимость управленческой организации и вариантаотбора
			ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ГруппаВыборУправленческойОрганизации",
				"Видимость",
				ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию"));
			
			Если Элементы.ГруппаВыборУправленческойОрганизации.Видимость Тогда
				
				Элементы.ГруппаСтраницыВариантВыбораОтбора.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаПереключательОтбора;
				
			Иначе
				
				Элементы.ГруппаСтраницыВариантВыбораОтбора.ТекущаяСтраница = 
					Элементы.ГруппаСтраницаФлагОтбора;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	//Видимость выгружаемых видов цен
	Если ПравилаОтправкиСправочниковУТ = "НеСинхронизировать"
		Или ПравилаОтправкиСправочниковУТ = "СинхронизироватьПоНеобходимости" Тогда
		
		Элементы.ГруппаСтраницыОтправлятьВидыЦенНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьВидыЦенНоменклатурыПустая;
		
	Иначе
		
		Элементы.ГруппаСтраницыОтправлятьВидыЦенНоменклатуры.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьВидыЦенНоменклатуры;
		
		Если ВыгружатьЦеныНоменклатуры И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
			
			Элементы.ГруппаСтраницыКомандаВыбратьВидыЦен.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаКомандаВыбратьВидыЦен;
			
		Иначе
			
			Элементы.ГруппаСтраницыКомандаВыбратьВидыЦен.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаКомандаВыбратьВидыЦенПустая;
			
		КонецЕсли;
		
	КонецЕсли;

	
	//Видимость группы прочее
	Если ПравилаОтправкиДокументовУТ = "НеСинхронизировать" Тогда
		
		Элементы.ГруппаСтраницыПравилаСозданияДоговоровКонтрагентов.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаПравилаСозданияДоговоровКонтрагентовПустая;
			
		Элементы.ГруппаСтраницыОбобщенныйСклад.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОбобщенныйСкладПустая;
		
	Иначе
		
		Элементы.ГруппаСтраницыПравилаСозданияДоговоровКонтрагентов.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаПравилаСозданияДоговоровКонтрагентов;
		
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПолеПравилаСозданияДоговоровКонтрагентов",
			"Доступность",
			Элементы.ПолеПравилаСозданияДоговоровКонтрагентов.СписокВыбора.Количество() > 1);
			
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
			
			Элементы.ГруппаСтраницыОбобщенныйСклад.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОбобщенныйСкладПустая;
			
		Иначе
			
			Элементы.ГруппаСтраницыОбобщенныйСклад.ТекущаяСтраница = 
				Элементы.ГруппаСтраницаОбобщенныйСклад;
			
			Если ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки") 
				Или ПолучитьФункциональнуюОпцию("ИспользоватьСкладыВТабличнойЧастиДокументовПродажи") Тогда
				
				Элементы.СтраницыВариантовОтображенияОбощенногоСклада.ТекущаяСтраница = 
					Элементы.СтраницаВариантСВключеннымиФО;
				
			Иначе
				
				Элементы.СтраницыВариантовОтображенияОбощенногоСклада.ТекущаяСтраница = 
					Элементы.СтраницаВариантСВыключеннымиФО;
				
				ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
					Элементы,
					"ПолеОбобщенныйСкладСВыключеннымиФО",
					"Доступность",
					СворачиватьДокументыПоСкладу);
					
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	
	//Правила отправки информационной базы "Бухгалтерия предприятия"


	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаНачалаВыгрузкиДокументовБП",
		"Доступность",
		ПравилаОтправкиДокументовБП = "АвтоматическаяСинхронизация");
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы.ГруппаДокументыБП.ПодчиненныеЭлементы,
		"ГруппаРежимОтправкиДокументовБП",
		"Доступность",
		Не ПравилаОтправкиСправочниковБП = "НеСинхронизировать");
		
	//Видимость отбора по организациям
	Если ПравилаОтправкиСправочниковБП = "НеСинхронизировать" Тогда
		
		Элементы.ГруппаСтраницыОтборПоОрганизациямБП.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтборПоОрганизациямПустаяБП;
			
		Элементы.ГруппаСтраницыОтправлятьИнформациюОРасходе.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьИнформациюОРасходеПустая;
			
	Иначе
		
		Элементы.ГруппаСтраницыОтборПоОрганизациямБП.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтборПоОрганизациямБП;
			
		Элементы.ГруппаСтраницыОтправлятьИнформациюОРасходе.ТекущаяСтраница = 
			?(ПравилаОтправкиДокументовБП = "НеСинхронизировать",
			Элементы.ГруппаСтраницаОтправлятьИнформациюОРасходеПустая, 
			Элементы.ГруппаСтраницаОтправлятьИнформациюОРасходе);
			
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОткрытьСписокВыбранныхОрганизацийБП",
			"Видимость",
			ИспользоватьОтборПоОрганизациямБП);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПереключательДокументыНеОтправлятьБП",
			"Доступность",
			Не ПравилаОтправкиСправочниковБП = "СинхронизироватьПоНеобходимости");
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ОписаниеДокументыНеОтправлятьБП",
			"Доступность",
			Не ПравилаОтправкиСправочниковБП = "СинхронизироватьПоНеобходимости");
			
	КонецЕсли;
	//Видимость принципа отправки подразделений
	Если ПравилаОтправкиСправочниковУТ = "НеСинхронизировать" Тогда
		
		Элементы.ГруппаСтраницыОтправлятьПодразделенияУТ.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьПодразделенияУТПустая;
			
	Иначе
		
		Элементы.ГруппаСтраницыОтправлятьПодразделенияУТ.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьПодразделенияУТ;
			
	КонецЕсли;
	Если ПравилаОтправкиСправочниковБП = "НеСинхронизировать" Тогда
		
		Элементы.ГруппаСтраницыОтправлятьПодразделенияБП.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьПодразделенияБППустая;
			
	Иначе
		
		Элементы.ГруппаСтраницыОтправлятьПодразделенияБП.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаОтправлятьПодразделенияБП;
			
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	ТабличнаяЧасть           = ЭтаФорма[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения];
	ТаблицаВыбранныхЗначений = ТабличнаяЧасть.Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	МассивВыбранныхЗначений  = ТаблицаВыбранныхЗначений.ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения);
	
	Возврат МассивВыбранныхЗначений;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	ЭтаФорма[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Идентификатор.Имя = "УникальныйИдентификаторСсылки";
		СписокВыбранныхЗначений.Колонки.Добавить("Использовать");
		СписокВыбранныхЗначений.ЗаполнитьЗначения( Истина, "Использовать");
		ЭтаФорма[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура УстрановитьУсловияОрганиченияСинхронизации()
	
	Если ПравилаОтбораОрганизаций = "Отбор" Тогда
		
		ИспользоватьОтборПоОрганизациямУТ = Истина;
		ВыгружатьУправленческуюОрганизацию = Ложь;
		
	ИначеЕсли ПравилаОтбораОрганизаций = "УпрОрганизация" Тогда
		
		ИспользоватьОтборПоОрганизациямУТ = Ложь;
		ВыгружатьУправленческуюОрганизацию = Истина;
		
	ИначеЕсли ПравилаОтбораОрганизаций = "БезОтбора" Тогда
		
		ИспользоватьОтборПоОрганизациямУТ = Ложь;
		ВыгружатьУправленческуюОрганизацию = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает сокращенное строковое представление коллекции значений
// 
// Параметры:
//  Коллекция 						- массив или список значений.
//  МаксимальноеКоличествоЭлементов - число, максимальное количество элементов включаемое в представление.
//
// Возвращаемое значение:
//  Строка.
//
&НаСервере
Функция СокращенноеПредставлениеКоллекцииЗначений(Коллекция, МаксимальноеКоличествоЭлементов = 2)
	
	СтрокаПредставления = "";
	
	КоличествоЗначений			 = Коллекция.Количество();
	КоличествоВыводимыхЭлементов = Мин(КоличествоЗначений, МаксимальноеКоличествоЭлементов);
	
	Если КоличествоВыводимыхЭлементов = 0 Тогда
		
		Возврат "";
		
	Иначе
		
		Для НомерЗначения = 1 По КоличествоВыводимыхЭлементов Цикл
			
			СтрокаПредставления = СтрокаПредставления + Коллекция.Получить(НомерЗначения - 1) + ", ";	
			
		КонецЦикла;
		
		СтрокаПредставления = Лев(СтрокаПредставления, СтрДлина(СтрокаПредставления) - 2);
		Если КоличествоЗначений > КоличествоВыводимыхЭлементов Тогда
			СтрокаПредставления = СтрокаПредставления + ", ... ";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрокаПредставления;
	
КонецФункции

&НаСервере
Функция СтруктураСоответсвтияНастройкиОтборовРеквизитамФормы()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ВыгружатьЦеныНоменклатуры",            "ВыгружатьЦеныНоменклатуры");
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям",      "ИспользоватьОтборПоОрганизациямУТ");
	СтруктураНастроек.Вставить("ВыгружатьУправленческуюОрганизацию",   "ВыгружатьУправленческуюОрганизацию");
	СтруктураНастроек.Вставить("СворачиватьДокументыПоСкладу",         "СворачиватьДокументыПоСкладу");
	СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов",         "ДатаНачалаВыгрузкиДокументовУТ");
	СтруктураНастроек.Вставить("ПравилаОтправкиДокументов",            "ПравилаОтправкиДокументовУТ");
	СтруктураНастроек.Вставить("ПравилаОтправкиСправочников",          "ПравилаОтправкиСправочниковУТ");
	СтруктураНастроек.Вставить("ПравилаСозданияДоговоровКонтрагентов", "ПравилаСозданияДоговоровКонтрагентов");
	СтруктураНастроек.Вставить("ОбобщенныйСклад",                      "ОбобщенныйСклад");
	СтруктураНастроек.Вставить("РежимВыгрузкиСправочников",            "РежимВыгрузкиСправочниковУТ");
	СтруктураНастроек.Вставить("РежимВыгрузкиДокументов",              "РежимВыгрузкиДокументовУТ");
	СтруктураНастроек.Вставить("УправленческаяОрганизация",            "УправленческаяОрганизация");
	СтруктураНастроек.Вставить("Организации",                          "ОрганизацииУТ");
	СтруктураНастроек.Вставить("ВидыЦенНоменклатуры",                  "ВидыЦенНоменклатуры");
	СтруктураНастроек.Вставить("ПравилаВыгрузкиПодразделений",         "ПравилаВыгрузкиПодразделенийУТ");
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаСервере
Функция СтруктураСоответсвтияНастройкиОтборовКорреспондентаРеквизитамФормы()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям", "ИспользоватьОтборПоОрганизациямБП");
	СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов",    "ДатаНачалаВыгрузкиДокументовБП");
	СтруктураНастроек.Вставить("ПравилаОтправкиДокументов",       "ПравилаОтправкиДокументовБП");
	СтруктураНастроек.Вставить("ПравилаОтправкиСправочников",     "ПравилаОтправкиСправочниковБП");
	СтруктураНастроек.Вставить("РежимВыгрузкиСправочников",       "РежимВыгрузкиСправочниковБП");
	СтруктураНастроек.Вставить("РежимВыгрузкиДокументов",         "РежимВыгрузкиДокументовБП");
	СтруктураНастроек.Вставить("РежимВыгрузкиПриНеобходимости",   "РежимВыгрузкиПриНеобходимости");
	СтруктураНастроек.Вставить("Организации",                     "ОрганизацииБП");
	СтруктураНастроек.Вставить("ВыгружатьДанныеОРасходахФОТ",     "ВыгружатьДанныеОРасходахФОТ");
	СтруктураНастроек.Вставить("ПравилаВыгрузкиПодразделений",    "ПравилаВыгрузкиПодразделенийБП");
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаСервере
Функция ЗаписатьИЗакрытьНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациямУТ И ОрганизацииУТ.Количество() <> 0 Тогда
		ОрганизацииУТ.Очистить();
	ИначеЕсли ОрганизацииУТ.Количество() = 0 И ИспользоватьОтборПоОрганизациямУТ Тогда
		ИспользоватьОтборПоОрганизациямУТ = Ложь;
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациямБП И ОрганизацииБП.Количество() <> 0 Тогда
		ОрганизацииБП.Очистить();
	ИначеЕсли ОрганизацииБП.Количество() = 0 И ИспользоватьОтборПоОрганизациямБП Тогда
		ИспользоватьОтборПоОрганизациямБП = Ложь;
	КонецЕсли;
	
	Если Не ВыгружатьЦеныНоменклатуры И ВидыЦенНоменклатуры.Количество() <> 0 Тогда
		ВидыЦенНоменклатуры.Очистить();
	ИначеЕсли ВидыЦенНоменклатуры.Количество() = 0 И ВыгружатьЦеныНоменклатуры Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
			ВыгружатьЦеныНоменклатуры = Ложь;
		Иначе
			Если ЗначениеЗаполнено(ВидЦеныПоУмолчанию)Тогда
				НоваяСтрока = ВидыЦенНоменклатуры.Добавить();
				НоваяСтрока.Представление = ВидЦеныПоУмолчанию;
				НоваяСтрока.УникальныйИдентификаторСсылки = Строка(ВидЦеныПоУмолчанию.УникальныйИдентификатор());
			Иначе
				ВыгружатьЦеныНоменклатуры = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(УправленческаяОрганизация) Тогда
		УправленческаяОрганизация = ПредопределенноеЗначение("Справочник.Организации.УправленческаяОрганизация");
	КонецЕсли;
	
	Если ПравилаОтправкиДокументовУТ <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументовУТ = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	Если ПравилаОтправкиДокументовБП <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументовБП = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	ПолучитьОписаниеКонтекста();

	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура СформироватьСписокВыбораПравилФормированияДоговора()
	
	// Сформируем список выбора для реквизита "ПравилаСозданияДоговоровКонтрагентов"
	СписокПравилФормированияДоговора = Элементы.ПолеПравилаСозданияДоговоровКонтрагентов.СписокВыбора;
	
	Если Не (ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") 
		Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам"))
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПоступлениеПоНесколькимЗаказам")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьРеализациюПоНесколькимЗаказам")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам") Тогда
		
		СписокПравилФормированияДоговора.Удалить(СписокПравилФормированияДоговора.НайтиПоЗначению("ПоЗаказам"));
		
		Если ПравилаСозданияДоговоровКонтрагентов = "ПоЗаказам" Тогда
			ПравилаСозданияДоговоровКонтрагентов = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСделкиСКлиентами") Тогда
		
		СписокПравилФормированияДоговора.Удалить(СписокПравилФормированияДоговора.НайтиПоЗначению("ПоСделкам"));
		
		Если ПравилаСозданияДоговоровКонтрагентов = "ПоСделкам" Тогда
			ПравилаСозданияДоговоровКонтрагентов = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		
		СписокПравилФормированияДоговора.Удалить(СписокПравилФормированияДоговора.НайтиПоЗначению("ПоПартнерам"));
		
		Если ПравилаСозданияДоговоровКонтрагентов = "ПоПартнерам" Тогда
			ПравилаСозданияДоговоровКонтрагентов = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Если Константы.ИспользованиеСоглашенийСКлиентами.Получить() = Перечисления.ИспользованиеСоглашенийСКлиентами.НеИспользовать Тогда
		
		СписокПравилФормированияДоговора.Удалить(СписокПравилФормированияДоговора.НайтиПоЗначению("ПоСоглашениям"));
		
		Если ПравилаСозданияДоговоровКонтрагентов = "ПоСоглашениям" Тогда
			ПравилаСозданияДоговоровКонтрагентов = "";
		КонецЕсли;
		
	КонецЕсли;
	
	Если СписокПравилФормированияДоговора.Количество() = 1 Тогда
		ПравилаСозданияДоговоровКонтрагентов = СписокПравилФормированияДоговора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
