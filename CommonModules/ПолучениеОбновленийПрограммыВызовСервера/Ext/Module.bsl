﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение обновлений программы".
// ОбщийМодуль.ПолучениеОбновленийПрограммыВызовСервера.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ИнформацияОДоступномОбновлении(
	Знач ИмяТекущейПрограммы,
	Знач ВерсияТекущейПрограммы,
	Знач ИмяНовойПрограммы,
	Знач НомерРедакцииНовойПрограммы,
	Знач СценарийОбновления,
	Знач НастройкиСоединения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("НастройкиСоединения", НастройкиСоединения);
	ДополнительныеПараметры.Вставить("ПараметрыКлиента"   , ИнтернетПоддержкаПользователей.ПараметрыКлиента());
	Возврат ПолучениеОбновленийПрограммыКлиентСервер.ИнформацияОДоступномОбновлении(
		ИмяТекущейПрограммы,
		ВерсияТекущейПрограммы,
		ИмяНовойПрограммы,
		НомерРедакцииНовойПрограммы,
		СценарийОбновления,
		ДополнительныеПараметры);
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач СообщениеОбОшибке) Экспорт
	
	ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
		СообщениеОбОшибке);
	
КонецПроцедуры

Процедура ЗаписатьИнформациюВЖурналРегистрации(Знач Сообщение) Экспорт
	
	ПолучениеОбновленийПрограммы.ЗаписатьИнформациюВЖурналРегистрации(Сообщение);
	
КонецПроцедуры

Функция ДополнительныеПараметрыЗапросаКСервисуОбновлений(Знач ПараметрыКлиента) Экспорт
	
	Возврат ПолучениеОбновленийПрограммы.ДополнительныеПараметрыЗапросаКСервисуОбновлений(ПараметрыКлиента);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Настройки автоматического обновления.

Функция НастройкиОбновления() Экспорт
	
	Возврат ПолучениеОбновленийПрограммы.НастройкиАвтоматическогоОбновления();
	
КонецФункции

Процедура ЗаписатьНастройкиОбновления(Знач Настройки) Экспорт
	
	ПолучениеОбновленийПрограммы.ЗаписатьНастройкиАвтоматическогоОбновления(Настройки);
	
КонецПроцедуры

Процедура СохранитьИнформациюОДоступномОбновленииВНастройках(Знач ИнформацияОДоступномОбновлении) Экспорт
	
	Если ТипЗнч(ИнформацияОДоступномОбновлении) = Тип("Структура") Тогда
		
		ОписаниеИнформацииОДоступномОбновлении = Новый Структура;
		ОписаниеИнформацииОДоступномОбновлении.Вставить("ИмяПрограммы",
			ИнтернетПоддержкаПользователейКлиентСервер.ИмяПрограммы());
		ОписаниеИнформацииОДоступномОбновлении.Вставить("МетаданныеИмя",
			ИнтернетПоддержкаПользователейКлиентСервер.ИмяКонфигурации());
		ОписаниеИнформацииОДоступномОбновлении.Вставить("МетаданныеВерсия",
			ИнтернетПоддержкаПользователейКлиентСервер.ВерсияКонфигурации());
		ОписаниеИнформацииОДоступномОбновлении.Вставить("ВерсияПлатформы",
			ПолучениеОбновленийПрограммыКлиентСервер.ТекущаяВерсияПлатформы1СПредприятие());
		ОписаниеИнформацииОДоступномОбновлении.Вставить("ИнформацияОДоступномОбновлении",
			ИнформацияОДоступномОбновлении);
		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ИнтеррнетПоддержка",
			"ПолучениеОбновленийПрограммы/ИнформацияОДоступномОбновлении"
			+ ?(ПолучениеОбновленийПрограммыКлиентСервер.Это64РазрядноеПриложение(),
				"64",
				""),
			ОписаниеИнформацииОДоступномОбновлении);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверка версии платформы 1С:Предприятие при начале работы программы.

Функция ПараметрыПроверкиВерсииПлатформыПриЗапуске() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Продолжить"             , Ложь);
	Результат.Вставить("ЭтоАдминистраторСистемы", Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь));
	
	ПараметрыБазовойФункциональности = ОбщегоНазначения.ОбщиеПараметрыБазовойФункциональности();
	
	ТекущаяВерсияПлатформы       = ПолучениеОбновленийПрограммыКлиентСервер.ТекущаяВерсияПлатформы1СПредприятие();
	МинимальнаяВерсияПлатформы   = ПараметрыБазовойФункциональности.МинимальнаяВерсияПлатформы;
	РекомендуемаяВерсияПлатформы = ПараметрыБазовойФункциональности.РекомендуемаяВерсияПлатформы;
	
	РаботаВПрограммеЗапрещена = (ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ТекущаяВерсияПлатформы, МинимальнаяВерсияПлатформы) < 0);
	
	// Определение необходимости отображения сообщения.
	Если Не РаботаВПрограммеЗапрещена Тогда
		
		Если Не Результат.ЭтоАдминистраторСистемы Тогда
			
			// Если работа в программе разрешена, тогда не показывать
			// сообщение обычному пользователю.
			Результат.Продолжить = Истина;
			Возврат Результат;
			
		Иначе
			
			// Проверить необходимость показа оповещения администратору.
			НастройкиОповещения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"ИнтеррнетПоддержка_ПолучениеОбновленийПрограммы",
				"СообщениеОНерекомендуемойВерсииПлатформы");
			
			Если ТипЗнч(НастройкиОповещения) = Тип("Структура")
				И НастройкиОповещения.Свойство("МетаданныеИмя")
				И НастройкиОповещения.Свойство("МетаданныеВерсия")
				И ИнтернетПоддержкаПользователейКлиентСервер.ИмяКонфигурации() =
					НастройкиОповещения.МетаданныеИмя
				И ИнтернетПоддержкаПользователейКлиентСервер.ВерсияКонфигурации() =
					НастройкиОповещения.МетаданныеВерсия  Тогда
				
				// Если сообщение уже отображалось для текущего набора
				// свойств метаданных, тогда пропустить отображение сообщения.
				Результат.Продолжить = Истина;
				Возврат Результат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Определение параметров отображения оповещения.
	Результат.Вставить("РаботаВПрограммеЗапрещена",
		ПараметрыБазовойФункциональности.РаботаВПрограммеЗапрещена);
	
	ТекстСообщения = "<body>" + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для работы с программой %1 использовать версию платформы &quot;1С:Предприятие 8&quot; не ниже: <b>%2</b>
			|<br />Используемая сейчас версия: %3'"),
		?(ПараметрыБазовойФункциональности.РаботаВПрограммеЗапрещена,
			НСтр("ru = 'необходимо'"),
			НСтр("ru = 'рекомендуется'")),
		?(РаботаВПрограммеЗапрещена, МинимальнаяВерсияПлатформы, РекомендуемаяВерсияПлатформы),
		ТекущаяВерсияПлатформы);
	
	Если Не Результат.ЭтоАдминистраторСистемы Тогда
		
		// В этой ветви работа в программе запрещена.
		ТекстСообщения = ТекстСообщения + "<br /><br />"
			+ НСтр("ru = 'Вход в программу невозможен.<br />
				|Необходимо обратиться к администратору для обновления версии платформы 1С:Предприятие.'");
		
	ИначеЕсли ПараметрыБазовойФункциональности.РаботаВПрограммеЗапрещена Тогда
		
		ТекстСообщения = ТекстСообщения + "<br /><br />"
			+ НСтр("ru = 'Вход в программу невозможен.<br />
				|Необходимо предварительно обновить версию платформы 1С:Предприятие.'");
		
	Иначе
		
		ТекстСообщения = ТекстСообщения + "<br /><br />"
			+ НСтр("ru='Рекомендуется обновить версию платформы 1С:Предприятия.<br />
				|В противном случае некоторые возможности программы будут недоступны или будут работать некорректно.'");
		
	КонецЕсли;
	
	ТекстСообщения = ТекстСообщения + "</body>";
	Результат.Вставить("ТекстСообщения",
		ИнтернетПоддержкаПользователейКлиентСервер.ФорматированныйЗаголовок(ТекстСообщения));
	
	Возврат Результат;
	
КонецФункции

Процедура СохранитьНастройкиОповещенияОНерекомендуемойВерсииПлатформы() Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтеррнетПоддержка_ПолучениеОбновленийПрограммы",
		"СообщениеОНерекомендуемойВерсииПлатформы",
		Новый Структура(
			"МетаданныеИмя, МетаданныеВерсия",
			ИнтернетПоддержкаПользователейКлиентСервер.ИмяКонфигурации(),
			ИнтернетПоддержкаПользователейКлиентСервер.ВерсияКонфигурации()));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверка наличия обновлений в фоновом режиме.

Функция НачатьПроверкуНаличияОбновления() Экспорт
	
	Если Не ПолучениеОбновленийПрограммы.ДоступноИспользованиеОбновленияПрограммы() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		ПараметрыФЗ = Новый Массив;
		ПараметрыФЗ.Добавить(ИнтернетПоддержкаПользователей.ПараметрыКлиента());
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(
			"ПолучениеОбновленийПрограммы.ПроверитьНаличиеОбновленияВФоновомРежиме",
			ПараметрыФЗ,
			,
			НСтр("ru = 'Проверка наличия обновлений'"));
	Исключение
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка фоновой проверки наличия обновлений. Не удалось выполнить фоновое задание. %1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ФоновоеЗадание.УникальныйИдентификатор;
	
КонецФункции

Функция РезультатЗаданияПроверкиНаличияОбновлений(Знач ИДЗадания) Экспорт
	
	Попытка
		Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИДЗадания);
	Исключение
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Фоновая проверка наличия обновлений. Ошибка при обращении к заданию. %1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		Возврат -1;
	КонецПопытки;
	
	Если Задание = Неопределено Тогда
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
			НСтр("ru = 'Фоновая проверка наличия обновлений. Задание с указанным идентификатором не найдено.'"));
		Возврат -1;
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Неопределено;
		
	ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Завершено Тогда
		
		ОписательСостояния = ДлительныеОперации.ПрочитатьПрогресс(ИДЗадания);
		Попытка
			Результат = ОписательСостояния.ДополнительныеПараметры.ДопПараметры;
			СохранитьИнформациюОДоступномОбновленииВНастройках(Результат);
			Возврат Результат;
		Исключение
			ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Фоновая проверка наличия обновлений. Ошибка при получении результата выполнения задания. %1'"),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
			Возврат -1;
		КонецПопытки;
		
	ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Фоновая проверка наличия обновлений. Задание завершено аварийно. %1'"),
				ПодробноеПредставлениеОшибки(Задание.ИнформацияОбОшибке)));
		Возврат -1;
		
	ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
		
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
			НСтр("ru = 'Фоновая проверка наличия обновлений. Задание отменено администратором.'"));
		Возврат -1;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти
