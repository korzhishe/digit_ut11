﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	УстановитьТекстЗапросаСписка();
	
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()), Истина);
	
	УстановитьВидимость();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);

	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытиеЗаказов" Тогда
		Элементы.Список.Обновить();
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЗаказНаВнутреннююПередачуТоваров(Команда)
	
	ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеремещениеТоваровМеждуФилиалами");
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	ОткрытьФорму("Документ.ЗаказНаПеремещение.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрыт(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураЗакрытия = Новый Структура;
	СписокЗаказов = Новый СписокЗначений;
	СписокЗаказов.ЗагрузитьЗначения(ВыделенныеСсылки);
	СтруктураЗакрытия.Вставить("Заказы",                       СписокЗаказов);
	СтруктураЗакрытия.Вставить("ОтменитьНеотработанныеСтроки", Истина);
	СтруктураЗакрытия.Вставить("ЗакрыватьЗаказы",              Истина);
	
	ОткрытьФорму("Обработка.ПомощникЗакрытияЗаказов.Форма.ФормаЗакрытия", СтруктураЗакрытия,
					ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнению(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К выполнению"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКВыполнениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КВыполнению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(),
    НСтр("ru = 'К выполнению'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечению(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К обеспечению"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОбеспечениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КОбеспечению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(),
    НСтр("ru = 'К обеспечению'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьТекстЗапросаСписка()

	Если ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияВнутреннихЗаказов) Тогда
		
		Список.ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДокументЗаказНаПеремещение.Ссылка,
		|	ДокументЗаказНаПеремещение.ПометкаУдаления,
		|	ДокументЗаказНаПеремещение.Номер,
		|	ДокументЗаказНаПеремещение.Дата,
		|	ДокументЗаказНаПеремещение.Проведен,
		|	ДокументЗаказНаПеремещение.ДлительностьПеремещения,
		|	ДокументЗаказНаПеремещение.ЖелаемаяДатаПоступления,
		|	ДокументЗаказНаПеремещение.Комментарий,
		|	ДокументЗаказНаПеремещение.МаксимальныйКодСтроки,
		|	ДокументЗаказНаПеремещение.Организация,
		|	ДокументЗаказНаПеремещение.ОрганизацияПолучатель,
		|	ДокументЗаказНаПеремещение.Ответственный,
		|	ДокументЗаказНаПеремещение.Подразделение,
		|	ДокументЗаказНаПеремещение.Сделка,
		|	ДокументЗаказНаПеремещение.СкладОтправитель,
		|	ДокументЗаказНаПеремещение.СкладПолучатель,
		|	ДокументЗаказНаПеремещение.Статус,
		|	ДокументЗаказНаПеремещение.ХозяйственнаяОперация,
		|	ДокументЗаказНаПеремещение.Назначение,
		|	ДокументЗаказНаПеремещение.ДокументОснование,
		|	ДокументЗаказНаПеремещение.СостояниеЗаполненияМногооборотнойТары,
		|	ДокументЗаказНаПеремещение.МоментВремени,
		|	ВЫБОР
		|		КОГДА НЕ ДокументЗаказНаПеремещение.Проведен
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(СостоянияВнутреннихЗаказов.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.Закрыт))
		|	КОНЕЦ КАК Состояние,
		|	ЕСТЬNULL(СостоянияВнутреннихЗаказов.ЕстьРасхожденияОрдерНакладная, ЛОЖЬ) КАК ЕстьРасхожденияОрдерНакладная
		|ИЗ
		|	Документ.ЗаказНаПеремещение КАК ДокументЗаказНаПеремещение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВнутреннихЗаказов КАК СостоянияВнутреннихЗаказов
		|		ПО (СостоянияВнутреннихЗаказов.Заказ = ДокументЗаказНаПеремещение.Ссылка)";

	Иначе
		
		Список.ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДокументЗаказНаПеремещение.Ссылка,
		|	ДокументЗаказНаПеремещение.ПометкаУдаления,
		|	ДокументЗаказНаПеремещение.Номер,
		|	ДокументЗаказНаПеремещение.Дата,
		|	ДокументЗаказНаПеремещение.Проведен,
		|	ДокументЗаказНаПеремещение.ДлительностьПеремещения,
		|	ДокументЗаказНаПеремещение.ЖелаемаяДатаПоступления,
		|	ДокументЗаказНаПеремещение.Комментарий,
		|	ДокументЗаказНаПеремещение.МаксимальныйКодСтроки,
		|	ДокументЗаказНаПеремещение.Организация,
		|	ДокументЗаказНаПеремещение.ОрганизацияПолучатель,
		|	ДокументЗаказНаПеремещение.Ответственный,
		|	ДокументЗаказНаПеремещение.Подразделение,
		|	ДокументЗаказНаПеремещение.Сделка,
		|	ДокументЗаказНаПеремещение.СкладОтправитель,
		|	ДокументЗаказНаПеремещение.СкладПолучатель,
		|	ДокументЗаказНаПеремещение.Статус,
		|	ДокументЗаказНаПеремещение.ХозяйственнаяОперация,
		|	ДокументЗаказНаПеремещение.Назначение,
		|	ДокументЗаказНаПеремещение.ДокументОснование,
		|	ДокументЗаказНаПеремещение.СостояниеЗаполненияМногооборотнойТары,
		|	ДокументЗаказНаПеремещение.МоментВремени
		|ИЗ
		|	Документ.ЗаказНаПеремещение КАК ДокументЗаказНаПеремещение";
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()

	ПравоДоступаДобавление = Документы.ЗаказНаПеремещение.ПравоДоступаДобавление();

	ИспользоватьПеремещениеПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьПеремещениеПоНесколькимЗаказам");
	
	ИспользоватьРасширенноеОбеспечениеПотребностей = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенноеОбеспечениеПотребностей");
	ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс");
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()), Истина);
	
	Если ИспользоватьРасширенноеОбеспечениеПотребностей Тогда
		Элементы.ФормаСписокГруппаСоздать.Видимость = ПравоДоступаДобавление;
		Элементы.ФормаСоздать.Видимость = Ложь;
	Иначе
		Элементы.ФормаСписокГруппаСоздать.Видимость = Ложь;
		Элементы.ФормаСоздать.Видимость = ПравоДоступаДобавление;
	КонецЕсли;
	
	Элементы.ГруппаСоздать.Видимость = ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс И ПравоДоступаДобавление;
	Элементы.СписокСоздать.Видимость = Не ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс И ПравоДоступаДобавление;
	
	Элементы.СписокСкопировать.Видимость = ПравоДоступаДобавление;
	
	ИспользоватьСтатусы =  ПравоДоступа("Изменение", Метаданные.Документы.ЗаказНаПеремещение);
	Элементы.ГруппаУстановитьСтатус.Видимость = ИспользоватьСтатусы;
	
	Если ИспользоватьСтатусы Тогда
		ИспользоватьСтатусЗакрыт = ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыНаПеремещениеБезПолнойОтгрузки");
		Элементы.УстановитьСтатусЗакрыт.Видимость = ИспользоватьСтатусЗакрыт;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗаказНаПеремещение.ФормаСписка.Элемент.Список.Выбор");
	
КонецПроцедуры

#КонецОбласти
