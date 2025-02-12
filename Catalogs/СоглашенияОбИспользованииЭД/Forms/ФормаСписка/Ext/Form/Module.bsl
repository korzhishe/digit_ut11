﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьОбменЭД") Тогда
		ТекстСообщения = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ТекстСообщенияОНеобходимостиНастройкиСистемы("РаботаСЭД");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Источник) Тогда
		
		ИмяСправочникаКонтрагенты = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Контрагенты");
		ИмяСправочникаОрганизации = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Организации");
		ИмяСправочникаПартнеры = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Партнеры");
		
		ПараметрыФормы = Новый Структура;
		Если ТипЗнч(Параметры.Источник) = Тип("СправочникСсылка." + ИмяСправочникаКонтрагенты) Тогда
			Контрагент = Параметры.Источник;
			Элементы.Контрагент.Видимость = Ложь;
			Элементы.СписокСоглашенийСКонтрагентамиКонтрагент.Видимость = Ложь;
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокСоглашенийСКонтрагентами.Отбор, "Контрагент",
				Контрагент, ВидСравненияКомпоновкиДанных.Равно);
		ИначеЕсли ТипЗнч(Параметры.Источник) = Тип("СправочникСсылка." + ИмяСправочникаОрганизации) Тогда
			Организация = Параметры.Источник;
			Наименование = Строка(Параметры.Источник);
			Элементы.Организация.Видимость = Ложь;
			Элементы.СписокСоглашенийСКонтрагентамиОрганизация.Видимость = Ложь;
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				СписокСоглашенийСКонтрагентами.Отбор, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
				СписокСоглашенийМеждуОрганизациями.Отбор, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно);
		ИначеЕсли ТипЗнч(Параметры.Источник) = Тип("СправочникСсылка.ПрофилиНастроекЭДО") Тогда
			ПрофильНастроекЭДО = Параметры.Источник;
		ИначеЕсли ТипЗнч(Параметры.Источник) = Тип("СправочникСсылка." + ИмяСправочникаПартнеры) Тогда
			Партнер = Параметры.Источник;
		КонецЕсли;

	КонецЕсли;
	
	// Установим текст запроса динамического списка.
	Если ОбменСКонтрагентамиПовтИсп.ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры() Тогда
		СписокСоглашенийСКонтрагентамиТекстЗапроса = СтрЗаменить(
			СписокСоглашенийСКонтрагентами.ТекстЗапроса, """Партнер""", "СоглашениеПереопределяемый.Контрагент.Партнер");
	Иначе
		СписокСоглашенийСКонтрагентамиТекстЗапроса = СтрЗаменить(
			СписокСоглашенийСКонтрагентами.ТекстЗапроса, """Партнер"" КАК Партнер,", "");
	КонецЕсли;
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = СписокСоглашенийСКонтрагентами.ОсновнаяТаблица;
	СвойстваСписка.ДинамическоеСчитываниеДанных = СписокСоглашенийСКонтрагентами.ДинамическоеСчитываниеДанных;
	СвойстваСписка.ТекстЗапроса = СписокСоглашенийСКонтрагентамиТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокСоглашенийСКонтрагентами, СвойстваСписка);
	
	// Установим параметры динамического списка.
	СписокСоглашенийСКонтрагентами.Параметры.УстановитьЗначениеПараметра("ПрофильНастроекЭДО", ПрофильНастроекЭДО);
	СписокСоглашенийСКонтрагентами.Параметры.УстановитьЗначениеПараметра("ТекстРасширенныйРежим", НСтр("ru = 'Расширенный режим'"));
	
	// Установим отборы динамического списка.
	Если ОбменСКонтрагентамиПовтИсп.ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры() Тогда
		Если ЗначениеЗаполнено(Партнер) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(СписокСоглашенийСКонтрагентами.Отбор, "Партнер",
				Партнер, ВидСравненияКомпоновкиДанных.ВИерархии);
		КонецЕсли;	
	КонецЕсли;
	
	Элементы.ГруппаВсеСоглашения.Видимость = Пользователи.ЭтоПолноправныйПользователь()
		И Не ЗначениеЗаполнено(Параметры.Источник);
	
	НастроитьОтображениеСтраницСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСКонтрагентамиСлужебныйКлиент.ЗаполнитьДанныеСлужбыПоддержки(ТелефонСлужбыПоддержки, АдресЭлектроннойПочтыСлужбыПоддержки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.СписокСоглашенийСКонтрагентами.Обновить();
		
	ИначеЕсли ИмяСобытия = "Запись_НаборКонстант" Тогда
		
		Если Источник = "ИспользоватьОбменЭДМеждуОрганизациями" Тогда
			
			НастроитьОтображениеСтраниц();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьОтборПоКонтрагенту(ЭтотОбъект, Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборПоОрганизации(ЭтотОбъект, Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусуПодключения(ЭтотОбъект, СтатусПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеСоглашенияПриИзменении(Элемент)
	УстановитьОтборПоСостояниюСоглашения(ЭтотОбъект, СостояниеСоглашения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокНастроекСКонтрагентами

&НаКлиенте
Процедура СоздатьЭлементСпискаНастроекСКонтрагентами(Команда)
	
	ПараметрыФормы = Новый Структура;
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("ПрофильНастроекЭДО", ПрофильНастроекЭДО);
	ЗначенияЗаполнения.Вставить("Контрагент", Контрагент);
	
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусыНастроекЭДО(Команда)
	
	ОбработкаОповещения = Новый ОписаниеОповещения("ОбновитьСтатусыНастроекЗавершить", ЭтотОбъект);
	ОбменСКонтрагентамиСлужебныйКлиент.ПолучитьНастройкиЭДОИПараметрыСертификатов(ОбработкаОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусыНастроекЗавершить(Результат, Контекст) Экспорт
	
	СоотвСоглашенийИСтруктурСертификатов = Неопределено;
	Если ТипЗнч(Результат) <> Тип("Структура")
		ИЛИ Не Результат.Свойство("СоответствиеПрофилейИПараметровСертификатов", СоотвСоглашенийИСтруктурСертификатов) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Выполняется получение информации о приглашениях. Подождите...'");
	Состояние(НСтр("ru = 'Получение.'"), , ТекстСообщения);
	ОбменСКонтрагентамиСлужебныйВызовСервера.ОбновитьСтатусыПодключенияНастроекЭДО(СоотвСоглашенийИСтруктурСертификатов);
	
	Оповестить("ОбновитьСостояниеЭД");
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокИнтеркампани

&НаКлиенте
Процедура СписокИнтеркампаниПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	Параметр = ?(Копирование, Новый Структура("ЗначениеКопирования", Элементы.СписокИнтеркампани.ТекущаяСтрока),
		Новый Структура);
	
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаЭлементаИнтеркампани", Параметр,
		Элементы.СписокИнтеркампани);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьСсылкуНаСтатьюПо1СБухфон(Команда)
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьИнструкциюПо1СБухфон();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоКонтрагенту(Форма, ЗначениеОтбора)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
										Форма.СписокСоглашенийСКонтрагентами.Отбор,
										"Контрагент",
										ЗначениеОтбора,
										ВидСравненияКомпоновкиДанных.Равно,
										,
										ИспользоватьОтбор);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоОрганизации(Форма, ЗначениеОтбора)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
										Форма.СписокСоглашенийСКонтрагентами.Отбор,
										"Организация",
										ЗначениеОтбора,
										ВидСравненияКомпоновкиДанных.Равно,
										,
										ИспользоватьОтбор);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСтатусуПодключения(Форма, ЗначениеОтбора)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
										Форма.СписокСоглашенийСКонтрагентами.Отбор,
										"СтатусПодключения",
										ЗначениеОтбора,
										ВидСравненияКомпоновкиДанных.Равно,
										,
										ИспользоватьОтбор);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСостояниюСоглашения(Форма, ЗначениеОтбора)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(ЗначениеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
										Форма.СписокСоглашенийСКонтрагентами.Отбор,
										"СостояниеСоглашения",
										ЗначениеОтбора,
										ВидСравненияКомпоновкиДанных.Равно,
										,
										ИспользоватьОтбор);
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеСтраницСервер()
	
	ИспользуетсяНесколькоОрганизацийЭД = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЭД");
	ИспользоватьОбменЭДМеждуОрганизациями = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭДМеждуОрганизациями");
	
	ОтображатьЗакладки =ИспользоватьОбменЭДМеждуОрганизациями И ИспользуетсяНесколькоОрганизацийЭД;

	Элементы.ГруппаВсеСоглашения.Видимость = ОтображатьЗакладки;
	Если ОтображатьЗакладки Тогда
		Элементы.ГруппаСоглашения.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Иначе
		Элементы.ГруппаСоглашения.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеСтраниц()
	
	НастроитьОтображениеСтраницСервер();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСоглашенийСКонтрагентами.Имя);
	
	// Группа: ИЛИ
	ГруппаЭлементовОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	// Отбор: СостояниеСоглашения = Перечисления.СостоянияСоглашенийЭД.Закрыто
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокСоглашенийСКонтрагентами.СостояниеСоглашения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СостоянияСоглашенийЭД.Закрыто;
	
	// Отбор: Ссылка.ПометкаУдаления = Истина
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокСоглашенийСКонтрагентами.ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	// Оформление: ЦветТекста
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(192, 192, 192));
	
КонецПроцедуры

#КонецОбласти
