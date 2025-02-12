﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Для внутреннего использования
//
Процедура НастроитьОбменШаг1(Параметры, АдресВременногоХранилища) Экспорт
	
	ИмяПланаОбмена = Параметры.ИмяПланаОбмена;
	КодКорреспондента = Параметры.КодКорреспондента;
	НаименованиеКорреспондента = Параметры.НаименованиеКорреспондента;
	ОбластьДанныхКорреспондента = Параметры.ОбластьДанныхКорреспондента;
	КонечнаяТочкаКорреспондента = Параметры.КонечнаяТочкаКорреспондента;
	НастройкаОтборовНаУзле = Параметры.НастройкаОтборовНаУзле;
	Префикс = Параметры.Префикс;
	ПрефиксКорреспондента = Параметры.ПрефиксКорреспондента;
	
	УстановитьПривилегированныйРежим(Истина);
	
	КодЭтогоПриложения = ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
	НаименованиеЭтогоПриложения = ОбменДаннымиВМоделиСервиса.СформироватьНаименованиеПредопределенногоУзла();
	
	НачатьТранзакцию();
	Попытка
		
		Корреспондент = Неопределено;
		
		// Создаем настройку обмена в этой базе
		ОбменДаннымиВМоделиСервиса.СоздатьНастройкуОбмена(
			ИмяПланаОбмена,
			КодКорреспондента,
			НаименованиеКорреспондента,
			КонечнаяТочкаКорреспондента,
			НастройкаОтборовНаУзле.НастройкаОтборовНаУзле,
			Корреспондент,
			,
			,
			Префикс);
		
		// Регистрируем справочники к выгрузке в этой базе
		ОбменДаннымиСервер.ЗарегистрироватьТолькоСправочникиДляНачальнойВыгрузки(Корреспондент);
		
		// {Обработчик: ПриОтправкеДанныхОтправителя} Начало
		ВерсияБСП243 = ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СтандартныеПодсистемыСервер.ВерсияБиблиотеки(), "2.4.3.1") >= 0;
		МодульОбменДаннымиСервер = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		Если Не ВерсияБСП243
			Или МодульОбменДаннымиСервер.ЕстьАлгоритмМенеджераПланаОбмена("ПриОтправкеДанныхОтправителя",ИмяПланаОбмена) Тогда
			ПланыОбмена[ИмяПланаОбмена].ПриОтправкеДанныхОтправителя(НастройкаОтборовНаУзле.НастройкаОтборовНаУзле, Ложь);
		КонецЕсли;
		// {Обработчик: ПриОтправкеДанныхОтправителя} Окончание
		
		// Отправляем сообщение корреспонденту
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиУправлениеИнтерфейс.СообщениеНастроитьОбменШаг1());
		Сообщение.Body.CorrespondentZone = ОбластьДанныхКорреспондента;
		
		Сообщение.Body.ExchangePlan = ИмяПланаОбмена;
		Сообщение.Body.CorrespondentCode = КодЭтогоПриложения;
		Сообщение.Body.CorrespondentName = НаименованиеЭтогоПриложения;
		Сообщение.Body.FilterSettings = СериализаторXDTO.ЗаписатьXDTO(НастройкаОтборовНаУзле.НастройкаОтборовНаУзлеБазыКорреспондента);
		Сообщение.Body.Code = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Корреспондент, "Код");
		Сообщение.Body.EndPoint = ОбменСообщениямиВнутренний.КодЭтогоУзла();
		Сообщение.AdditionalInfo = СериализаторXDTO.ЗаписатьXDTO(Новый Структура("Префикс", ПрефиксКорреспондента));
		
		Сессия = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
	ВыходныеПараметры = Новый Структура("Корреспондент, Сессия", Корреспондент, Сессия);
	ПоместитьВоВременноеХранилище(ВыходныеПараметры, АдресВременногоХранилища);
	
КонецПроцедуры

// Для внутреннего использования
//
Процедура НастроитьОбменШаг2(Параметры, АдресВременногоХранилища) Экспорт
	
	Корреспондент = Параметры.Корреспондент;
	ОбластьДанныхКорреспондента = Параметры.ОбластьДанныхКорреспондента;
	ЗначенияПоУмолчаниюНаУзле = Параметры.ЗначенияПоУмолчаниюНаУзле;
	ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента = Параметры.ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Корреспондент);
	КодЭтогоПриложения = ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
	
	НачатьТранзакцию();
	Попытка
		
		// Сохраняем настройки, заданные пользователем
		ОбменДаннымиВМоделиСервиса.ОбновитьНастройкуОбмена(Корреспондент, ЗначенияПоУмолчаниюНаУзле);
		
		// Регистрируем все данные к выгрузке, кроме справочников
		ОбменДаннымиСервер.ЗарегистрироватьВсеДанныеКромеСправочниковДляНачальнойВыгрузки(Корреспондент);
		
		// Отправляем сообщение корреспонденту
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиУправлениеИнтерфейс.СообщениеНастроитьОбменШаг2());
		Сообщение.Body.CorrespondentZone = ОбластьДанныхКорреспондента;
		
		Сообщение.Body.ExchangePlan = ИмяПланаОбмена;
		Сообщение.Body.CorrespondentCode = КодЭтогоПриложения;
		Сообщение.Body.AdditionalSettings = СериализаторXDTO.ЗаписатьXDTO(ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента);
		
		Сессия = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
	ВыходныеПараметры = Новый Структура("Сессия", Сессия);
	ПоместитьВоВременноеХранилище(ВыходныеПараметры, АдресВременногоХранилища);
	
КонецПроцедуры

// Для внутреннего использования
//
Процедура ВыполнитьАвтоматическоеСопоставлениеДанных(Параметры, АдресВременногоХранилища) Экспорт
	
	// Выполняем автоматическое сопоставление данных, полученных от корреспондента
	// Получаем статистику сопоставления.
	
	Корреспондент = Параметры.Корреспондент;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Получаем сообщение обмена во временный каталог
	Отказ = Ложь;
	ПараметрыСообщения = ОбменДаннымиСервер.ПолучитьСообщениеОбменаВоВременныйКаталог(
		Отказ, Корреспондент, Неопределено);
	Если Отказ Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Возникли ошибки при получении сообщения обмена из внешнего ресурса для корреспондента ""%1"".'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	ПомощникИнтерактивногоОбменаДанными = Обработки.ПомощникИнтерактивногоОбменаДанными.Создать();
	ПомощникИнтерактивногоОбменаДанными.УзелИнформационнойБазы = Корреспондент;
	ПомощникИнтерактивногоОбменаДанными.ИмяФайлаСообщенияОбмена = ПараметрыСообщения.ИмяФайлаСообщенияОбмена;
	ПомощникИнтерактивногоОбменаДанными.ИмяВременногоКаталогаСообщенийОбмена = ПараметрыСообщения.ИмяВременногоКаталогаСообщенийОбмена;
	ПомощникИнтерактивногоОбменаДанными.ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Корреспондент);
	ПомощникИнтерактивногоОбменаДанными.ВидТранспортаСообщенийОбмена = Неопределено;
	
	// Выполняем анализ сообщения обмена
	Отказ = Ложь;
	ПомощникИнтерактивногоОбменаДанными.ВыполнитьАнализСообщенияОбмена(Отказ);
	Если Отказ Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Возникли ошибки при анализе сообщения обмена для корреспондента ""%1"".'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	// Выполняем автоматическое сопоставление и получаем статистику сопоставления
	Отказ = Ложь;
	ПомощникИнтерактивногоОбменаДанными.ВыполнитьАвтоматическоеСопоставлениеПоУмолчаниюИПолучитьСтатистикуСопоставления(Отказ);
	Если Отказ Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Возникли ошибки при выполнении автоматического сопоставления данных, полученных от корреспондента ""%1"".'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	ТаблицаИнформацииСтатистики = ПомощникИнтерактивногоОбменаДанными.ТаблицаИнформацииСтатистики();
	
	// Удаляем из таблицы статистики строки, для которых нет данных в этой базе или в базе-корреспонденте.
	// А также строки, для которых синхронизация данных по идентификаторам ссылок не предусмотрена.
	УдалитьПустыеДанныеИзСтатистики(ТаблицаИнформацииСтатистики);
	
	ВсеДанныеСопоставлены = (ТаблицаИнформацииСтатистики.НайтиСтроки(Новый Структура("ИндексКартинки", 1)).Количество() = 0);
	
	ВыходныеПараметры = Новый Структура("ИнформацияСтатистики, ВсеДанныеСопоставлены, ИмяФайлаСообщенияОбмена, СтатистикаПустая",
		ТаблицаИнформацииСтатистики, ВсеДанныеСопоставлены, ПараметрыСообщения.ИмяФайлаСообщенияОбмена, ТаблицаИнформацииСтатистики.Количество() = 0);
	ПоместитьВоВременноеХранилище(ВыходныеПараметры, АдресВременногоХранилища);
	
КонецПроцедуры

// Для внутреннего использования
//
Процедура ВыполнитьСинхронизациюСправочников(Параметры, АдресВременногоХранилища) Экспорт
	
	Корреспондент = Параметры.Корреспондент;
	ОбластьДанныхКорреспондента = Параметры.ОбластьДанныхКорреспондента;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Корреспондент);
	КодЭтогоПриложения = ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
	
	// Выполняем загрузку сообщения обмена, полученного от корреспондента
	Отказ = Ложь;
	ОбменДаннымиВМоделиСервиса.ВыполнитьЗагрузкуДанных(Отказ, Корреспондент);
	Если Отказ Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Возникли ошибки в процессе загрузки справочников от корреспондента %1.'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	// Выполняем выгрузку сообщения обмена для корреспондента (только справочники)
	Отказ = Ложь;
	ОбменДаннымиВМоделиСервиса.ВыполнитьВыгрузкуДанных(Отказ, Корреспондент);
	Если Отказ Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Возникли ошибки в процессе выгрузки справочников для корреспондента %1.'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	// Отправляем сообщение корреспонденту
	Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
		СообщенияОбменаДаннымиУправлениеИнтерфейс.СообщениеЗагрузитьСообщениеОбмена());
	Сообщение.Body.CorrespondentZone = ОбластьДанныхКорреспондента;
	
	Сообщение.Body.ExchangePlan = ИмяПланаОбмена;
	Сообщение.Body.CorrespondentCode = КодЭтогоПриложения;
	
	НачатьТранзакцию();
	Попытка
		Сессия = ОбменДаннымиВМоделиСервиса.ОтправитьСообщение(Сообщение);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	СообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
	ВыходныеПараметры = Новый Структура("Сессия", Сессия);
	ПоместитьВоВременноеХранилище(ВыходныеПараметры, АдресВременногоХранилища);
	
КонецПроцедуры

// Для внутреннего использования
//
Процедура ПолучитьСтатистикуСопоставления(Параметры, АдресВременногоХранилища) Экспорт
	
	// Параметры.Корреспондент,
	// Параметры.ИмяФайлаСообщенияОбмена,
	// Параметры.ИнформацияСтатистики,
	// Параметры.ИндексыСтрок.
	
	// Получаем статистику сопоставления для заданных типов данных.
	УстановитьПривилегированныйРежим(Истина);
	
	ПомощникИнтерактивногоОбменаДанными = Обработки.ПомощникИнтерактивногоОбменаДанными.Создать();
	ПомощникИнтерактивногоОбменаДанными.УзелИнформационнойБазы = Параметры.Корреспондент;
	ПомощникИнтерактивногоОбменаДанными.ИмяФайлаСообщенияОбмена = Параметры.ИмяФайлаСообщенияОбмена;
	ПомощникИнтерактивногоОбменаДанными.ИмяВременногоКаталогаСообщенийОбмена = "";
	ПомощникИнтерактивногоОбменаДанными.ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Параметры.Корреспондент);
	ПомощникИнтерактивногоОбменаДанными.ВидТранспортаСообщенийОбмена = Неопределено;
	
	ПомощникИнтерактивногоОбменаДанными.ИнформацияСтатистики.Загрузить(Параметры.ИнформацияСтатистики);
	
	Отказ = Ложь;
	ПомощникИнтерактивногоОбменаДанными.ПолучитьСтатистикуСопоставленияОбъектовПоСтроке(Отказ, Параметры.ИндексыСтрок);
	Если Отказ Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Возникли ошибки при получении информации статистики для корреспондента ""%1"".'"),
			Строка(Параметры.Корреспондент));
	КонецЕсли;
	
	ВсеДанныеСопоставлены = (ПомощникИнтерактивногоОбменаДанными.ТаблицаИнформацииСтатистики().НайтиСтроки(Новый Структура("ИндексКартинки", 1)).Количество() = 0);
	
	ВыходныеПараметры = Новый Структура("ИнформацияСтатистики, ВсеДанныеСопоставлены",
		ПомощникИнтерактивногоОбменаДанными.ТаблицаИнформацииСтатистики(), ВсеДанныеСопоставлены);
	ПоместитьВоВременноеХранилище(ВыходныеПараметры, АдресВременногоХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для внутреннего использования
//
Процедура УдалитьПустыеДанныеИзСтатистики(ТаблицаИнформацииСтатистики)
	
	ОбратныйИндекс = ТаблицаИнформацииСтатистики.Количество() - 1;
	
	Пока ОбратныйИндекс >= 0 Цикл
		
		Статистика = ТаблицаИнформацииСтатистики[ОбратныйИндекс];
		
		Если Статистика.КоличествоОбъектовВИсточнике = 0
			ИЛИ Статистика.КоличествоОбъектовВПриемнике = 0
			ИЛИ Не Статистика.СинхронизироватьПоИдентификатору Тогда
			
			ТаблицаИнформацииСтатистики.Удалить(Статистика);
			
		КонецЕсли;
		
		ОбратныйИндекс = ОбратныйИндекс - 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
