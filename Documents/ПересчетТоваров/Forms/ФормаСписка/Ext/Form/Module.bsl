﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	
	Склад = Справочники.Склады.СкладПоУмолчанию();
			
	Если Параметры.Свойство("Статус", Статус) Тогда
		СтатусПриИзмененииНаКлиентеНаСервере(ЭтаФорма);
	Иначе
		Статус = "Все";
	КонецЕсли;
	
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Склад", Склад);
		СтруктураБыстрогоОтбора.Свойство("Помещение", Помещение);	
	Иначе
		СтруктураБыстрогоОтбора = Новый Структура("Склад, Помещение", Склад, Помещение);
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокПересчетов, 
			"Склад", 
			Склад, 
			СтруктураБыстрогоОтбора,
			Истина);
			
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокПересчетов, 
			"Помещение", 
			Помещение, 
			СтруктураБыстрогоОтбора,
			Истина);
			
	ИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Склад, Помещение);
	
	УстановитьВидимостьПомещения();
	ОбновитьИнформациюОРасхождениях();
	
	Если Не ПравоДоступа("Добавление", Метаданные.Документы.ПересчетТоваров) Тогда
		
		Элементы.СоздатьЗаданиеНаПересчетНеадресныйСклад.Видимость = Ложь;
		Элементы.СкопироватьНеадресныйСклад.Видимость = Ложь;
		Элементы.УстановитьПометкуУдаленияНеадресныйСклад.Видимость = Ложь;
		Элементы.НазначитьИсполнителя.Видимость = Ложь;
		
		Элементы.СоздатьЗаданиеНаПересчетАдресныйСклад.Видимость = Ложь;
		Элементы.СгенерироватьЗаданияНаПересчетАдресныйСклад.Видимость = Ложь;
		Элементы.СкопироватьАдресныйСклад.Видимость = Ложь;
		Элементы.УстановитьПометкуУдаленияАдресныйСклад.Видимость = Ложь;
		Элементы.НазначитьИсполнителяАдресныйСклад.Видимость = Ложь;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = СписокПересчетов.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.ПрефиксГрупп = "АдресныйСклад";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанельЗаданияНаПересчетАдресныйСклад;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.ПрефиксГрупп = "НеадресныйСклад";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаКоманднаяПанельЗаданияНаПересчетНеадресныйСклад;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаКоманднаяПанельЗаданияНаПересчетНеадресныйСклад);
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаКоманднаяПанельЗаданияНаПересчетАдресныйСклад);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	
	УстановитьВидимостьКоманд();
	УстановитьВидимостьКомандКонтекстныхОтчетов();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокПересчетов.Дата", Элементы.СписокПересчетовДата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди();

	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ПересчетТоваров" Тогда
		Если Элементы.СтраницыИнформацияОРасхождениях.Видимость Тогда
			ОбновитьСписокНаСервере()
		Иначе
			Элементы.СписокПересчетов.Обновить();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Создание_СкладскиеАкты" Тогда
		Если Элементы.СтраницыИнформацияОРасхождениях.Видимость Тогда
			ОбновитьИнформациюОРасхождениях();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора) 
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.Пользователи.Форма.ФормаСписка" 
		И ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		// Назначение исполнителя - выбрали пользователя
		
		МассивИзмененныхДокументов = ОбработкаВыбораИсполнителяНаСервере(ВыбранноеЗначение);
		
		Если МассивИзмененныхДокументов.Количество() > 0 Тогда
			
			ТекстСообщения = НСтр("ru='Для %КоличествоОбработанных% из %КоличествоВсего% выделенных в списке заданий на пересчет назначен исполнитель %Исполнитель%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоОбработанных%", МассивИзмененныхДокументов.Количество());
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВсего%",        СписокВыделенныхДокументов.Количество());
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Исполнитель%",            ВыбранноеЗначение);
			
			ТекстЗаголовка = НСтр("ru='Исполнитель %Исполнитель% назначен'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Исполнитель%", ВыбранноеЗначение);
			ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
			
		Иначе
			
			ТекстСообщения = НСтр("ru='Исполнитель %Исполнитель% не назначен ни для одного задания на пересчет'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Исполнитель%", ВыбранноеЗначение);
			
			ТекстЗаголовка = НСтр("ru='Исполнитель %Исполнитель% не назначен'");
			ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Исполнитель%", ВыбранноеЗначение);
			ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Склад = Настройки.Получить("Склад");
	Помещение = Настройки.Получить("Помещение");
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		Если СтруктураБыстрогоОтбора.Свойство("Склад") И ЗначениеЗаполнено(СтруктураБыстрогоОтбора.Склад) Тогда
			Склад = СтруктураБыстрогоОтбора.Склад;
			Настройки.Удалить("Склад");
		КонецЕсли;
		
		Если СтруктураБыстрогоОтбора.Свойство("Помещение") И ЗначениеЗаполнено(СтруктураБыстрогоОтбора.Помещение) Тогда
			Помещение = СтруктураБыстрогоОтбора.Помещение;
			Настройки.Удалить("Помещение");
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПересчетов, 
			"Склад", 
			Склад, 
			ВидСравненияКомпоновкиДанных.Равно,, 
			Истина);
			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПересчетов, 
			"Помещение", 
			Помещение, 
			ВидСравненияКомпоновкиДанных.Равно,, 
			Истина);
	
	УстановитьВидимостьПомещения();
	УстановитьВидимостьСтраницКоманднойПанелиСписокПересчетов();
	ОбновитьИнформациюОРасхождениях();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПриИзмененииСервер();
	ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди()
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	
	СкладПомещениеПриИзмененииНаСервере();
	ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди();

КонецПроцедуры

&НаКлиенте
Процедура ПроблемаЕстьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ЗапуститьФормирование" Тогда
		
		ОчиститьСообщения();
		ЗапуститьФормированиеКорректировок();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВниманиеНажатие(Элемент)
	ОчиститьСообщения();
	ЗапуститьФормированиеКорректировок();
КонецПроцедуры


&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	СтатусПриИзмененииНаКлиентеНаСервере(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПересчетов

&НаКлиенте
Процедура СписокПересчетовПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СгенерироватьЗаданияНаПересчет(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ОткрытьФорму("Документ.ПересчетТоваров.Форма.ФормаНастроекСозданияЗаданийНаПересчет", 
			ПараметрыФормы, 
			ЭтаФорма,,,,, 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаданиеНаПересчет(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Склад", Склад);
	ЗначенияЗаполнения.Вставить("Помещение", Помещение); 
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);	
		
	ОткрытьФорму("Документ.ПересчетТоваров.ФормаОбъекта", ПараметрыФормы);
		
КонецПроцедуры

&НаКлиенте
Процедура НазначитьИсполнителя(Команда)
	
	ОчиститьСообщения();
	                                  
	МассивВыделенныхДокументов = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.СписокПересчетов);
	
	Если МассивВыделенныхДокументов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СписокВыделенныхДокументов.Очистить();
	
	Для Каждого ВыделеннаяСтрока Из МассивВыделенныхДокументов Цикл
		СписокВыделенныхДокументов.Добавить(ВыделеннаяСтрока);	
	КонецЦикла;
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", Новый Структура("РежимВыбора", Истина), ЭтаФорма,,,,,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокПересчетов);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокПересчетов, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокПересчетов);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

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

&НаКлиенте
Процедура ОткрытьОтчетТоварыВПроцессеОтгрузки(Команда)
	ПараметрыФормы = Новый Структура("КлючПользовательскихНастроек, КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии, Отбор, НеИспользоватьФиксированныеНастройки");
	ПараметрыФормы.КлючПользовательскихНастроек	= "ПересчетТоваровФормаСписка";
	ПараметрыФормы.КлючНазначенияИспользования	= "ПересчетТоваровФормаСписка";
	ПараметрыФормы.КлючВарианта					= "ОтгружаемыеТовары";
	ПараметрыФормы.СформироватьПриОткрытии		= Истина;
	ПараметрыФормы.Отбор						= Новый Структура;
	Если Не Склад.Пустая() Тогда
		ПараметрыФормы.Отбор.Вставить("Склад",		Склад);
	КонецЕсли;
	Если Не Помещение.Пустая() Тогда
		ПараметрыФормы.Отбор.Вставить("Помещение",	Помещение);
	КонецЕсли;

	ОткрытьФорму("Отчет.ВедомостьПоТоварамНаСкладах.Форма", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	Если Элементы.СтраницыИнформацияОРасхождениях.Видимость Тогда
		ОбновитьСписокНаСервере();
	Иначе
		Элементы.СписокПересчетов.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПересчетовСтатус.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьСтатусыПересчетовТоваров");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПересчетТоваров.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.СписокПересчетов.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(,МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ФоновоеЗаданиеФормированияКорректировок

&НаСервере
Процедура ЗапуститьФормированиеКорректировок()
	
	Помещения = СкладыСервер.ПомещенияПоКоторымНетФоновогоЗаданияФормированияКорректировокИзлишковНедостачПоТоварнымМестам(Склад);
	ЕстьОшибка = Ложь;
	Для Каждого ТекПомещение Из Помещения Цикл
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Склад", Склад);
		ПараметрыЗадания.Вставить("Помещение", ТекПомещение);
		СкладыСервер.ЗапускВыполненияФоновогоФормированияКорректировокИзлишковНедостачПоТоварнымМестам(ПараметрыЗадания)
	КонецЦикла;
	
	Элементы.СостояниеАвтоматическогоФормированияКорректировок.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольРаботыФоновыхЗаданийФормированияОчереди()
		
	КонтрольРаботыФоновыхЗаданийФормированияОчередиНаСервере()
			
КонецПроцедуры

&НаСервере
Процедура КонтрольРаботыФоновыхЗаданийФормированияОчередиНаСервере()
		
	Помещения = СкладыСервер.ПомещенияПоКоторымНетФоновогоЗаданияФормированияКорректировокИзлишковНедостачПоТоварнымМестам(Склад);
	
	Элементы.СостояниеАвтоматическогоФормированияКорректировок.Видимость = (Помещения.Количество() > 0);
				
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди()
	
	Если Не ИспользоватьАдресноеХранение Тогда
		Элементы.СостояниеАвтоматическогоФормированияКорректировок.Видимость = Ложь;
		ОтключитьОбработчикОжидания("КонтрольРаботыФоновыхЗаданийФормированияОчереди");
		Возврат;
	КонецЕсли; 
	
	КонтрольРаботыФоновыхЗаданийФормированияОчереди();
	ПодключитьОбработчикОжидания("КонтрольРаботыФоновыхЗаданийФормированияОчереди", 600);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьПомещения()
	
	Если СкладыСервер.ИспользоватьСкладскиеПомещения(Склад) Тогда
		Элементы.ГруппаФильтры.ТекущаяСтраница = Элементы.ГруппаФильтрыСПомещением;
	Иначе
		Элементы.ГруппаФильтры.ТекущаяСтраница = Элементы.ГруппаФильтрыБезПомещения;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСтраницКоманднойПанелиСписокПересчетов()
	
	Если СкладыСервер.ИспользоватьАдресноеХранение(Склад, Помещение) Тогда
		Элементы.ГруппаСтраницыШапкаЗаданияНаПересчет.ТекущаяСтраница = Элементы.ГруппаСтраницаШапкаЗаданияНаПересчетАдресныйСклад;
	Иначе
		Элементы.ГруппаСтраницыШапкаЗаданияНаПересчет.ТекущаяСтраница = Элементы.ГруппаСтраницаШапкаЗаданияНаПересчетНеадресныйСклад;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ОбработкаВыбораИсполнителяНаСервере(ВыбранноеЗначение)
			
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПересчетТоваров.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПересчетТоваров КАК ПересчетТоваров
	|ГДЕ
	|	ПересчетТоваров.Исполнитель <> &Исполнитель
	|	И ПересчетТоваров.Ссылка В(&МассивДокументов)";
	
	Запрос.УстановитьПараметр("Исполнитель", ВыбранноеЗначение);
	Запрос.УстановитьПараметр("МассивДокументов", СписокВыделенныхДокументов);
		
	ВыборкаДокументов = Запрос.Выполнить().Выбрать();
	
	МассивИзмененныхДокументов = Новый Массив;
	
	Пока ВыборкаДокументов.Следующий() Цикл
		
		Попытка
			ДокументОбъект = ВыборкаДокументов.Ссылка.ПолучитьОбъект();
			
			ДокументОбъект.Заблокировать();
			
			ДокументОбъект.Исполнитель = ВыбранноеЗначение;
			
			ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			МассивИзмененныхДокументов.Добавить(ВыборкаДокументов.Ссылка);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
	КонецЦикла;
	
	Элементы.СписокПересчетов.Обновить();
		
	Возврат МассивИзмененныхДокументов;

КонецФункции

&НаСервереБезКонтекста
Функция ЕстьРасхождения(Склад)
	Возврат Обработки.ПомощникОформленияСкладскихАктов.ТоварыКОформлениюСкладскихАктов(Склад).Количество() > 0;
КонецФункции

&НаСервере
Процедура ОбновитьИнформациюОРасхождениях()
	
	Если Не ЗначениеЗаполнено(Склад)
		Или Не ПравоДоступа("Использование", Метаданные.Обработки.ПомощникОформленияСкладскихАктов)
		Или Не СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад) Тогда
		Элементы.СтраницыИнформацияОРасхождениях.Видимость = Ложь;
		Возврат;
	Иначе
		Элементы.СтраницыИнформацияОРасхождениях.Видимость = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Склад) Тогда
		Элементы.СтраницыИнформацияОРасхождениях.ТекущаяСтраница = Элементы.СтраницаНетСклада;
		//Доб Мешкова
		Элементы.ФормаОформитьПересчетыТоваров.Доступность = Ложь;
		//Доб Мешкова
	ИначеЕсли ЕстьРасхождения(Склад) Тогда
		Элементы.СтраницыИнформацияОРасхождениях.ТекущаяСтраница = Элементы.СтраницаЕстьРасхождения;
		//Доб Мешкова
		Элементы.ФормаОформитьПересчетыТоваров.Доступность = Истина;
		//Доб Мешкова
	Иначе
		Элементы.СтраницыИнформацияОРасхождениях.ТекущаяСтраница = Элементы.СтраницаНетРасхождений; 
		//Доб Мешкова
		Элементы.ФормаОформитьПересчетыТоваров.Доступность = Ложь;
		//Доб Мешкова
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЕстьРасхожденияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура("Склад", Склад);
	
	ОткрытьФорму("Обработка.ПомощникОформленияСкладскихАктов.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СтатусПриИзмененииНаКлиентеНаСервере(Форма)
	Если Форма.Статус = "Все" Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Форма.СписокПересчетов, "Статус");
	ИначеЕсли Форма.Статус = "ТолькоНевыполненные" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.СписокПересчетов, 
			"Статус", 
			ПредопределенноеЗначение("Перечисление.СтатусыПересчетовТоваров.Выполнено"), 
			ВидСравненияКомпоновкиДанных.НеРавно,, 
			Истина);	
	ИначеЕсли Форма.Статус = "ВРаботе" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.СписокПересчетов, 
			"Статус", 
			ПредопределенноеЗначение("Перечисление.СтатусыПересчетовТоваров.ВРаботе"), 
			ВидСравненияКомпоновкиДанных.Равно,, 
			Истина);		
	ИначеЕсли Форма.Статус = "ВнесениеРезультатов" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.СписокПересчетов, 
			"Статус", 
			ПредопределенноеЗначение("Перечисление.СтатусыПересчетовТоваров.ВнесениеРезультатов"), 
			ВидСравненияКомпоновкиДанных.Равно,, 
			Истина);
	ИначеЕсли Форма.Статус = "Выполнено" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.СписокПересчетов, 
			"Статус", 
			ПредопределенноеЗначение("Перечисление.СтатусыПересчетовТоваров.Выполнено"), 
			ВидСравненияКомпоновкиДанных.Равно,, 
			Истина);
	ИначеЕсли Форма.Статус = "Подготовлено" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.СписокПересчетов, 
			"Статус", 
			ПредопределенноеЗначение("Перечисление.СтатусыПересчетовТоваров.Подготовлено"), 
			ВидСравненияКомпоновкиДанных.Равно,, 
			Истина);
	Иначе
		Форма.Статус = "Все";
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Форма.СписокПересчетов, "Статус");
	КонецЕсли;	
КонецПроцедуры

&НаСервере 
Процедура УстановитьВидимостьКомандКонтекстныхОтчетов()
	КоличествоДоступныхОтчетов = 0;
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ВедомостьПоТоварамНаСкладах) Тогда
		Элементы.ОткрытьОтчетТоварыВПроцессеОтгрузки.Видимость = Истина;
		КоличествоДоступныхОтчетов = КоличествоДоступныхОтчетов + 1;
	Иначе
		Элементы.ОткрытьОтчетТоварыВПроцессеОтгрузки.Видимость = Ложь;
	КонецЕсли;
	
	Если КоличествоДоступныхОтчетов > 0 Тогда
		Элементы.СтраницыКонтекстныеОтчеты.ТекущаяСтраница = Элементы.СтраницаДоступныеОтчеты;
	Иначе
		Элементы.СтраницыКонтекстныеОтчеты.ТекущаяСтраница = Элементы.СтраницаНетДоступныхОтчетов;
	КонецЕсли;
КонецПроцедуры

&НаСервере 
Процедура УстановитьВидимостьКоманд()
	
	ЕстьПравоНаРедактирование = ПравоДоступа("Редактирование", Метаданные.Документы.ПересчетТоваров);
	
	Элементы.СоздатьЗаданиеНаПересчетНеадресныйСклад.Видимость	= ЕстьПравоНаРедактирование;
	Элементы.СписокПересчетов.ИзменятьСоставСтрок				= ЕстьПравоНаРедактирование;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокНаСервере()
	ОбновитьИнформациюОРасхождениях();
	Элементы.СписокПересчетов.Обновить();
КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииСервер()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПересчетов, 
		"Склад", 
		Склад, 
		ВидСравненияКомпоновкиДанных.Равно,, 
		Истина);
	
	ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач =
		СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад);
			
	УстановитьВидимостьПомещения();
	ОбновитьИнформациюОРасхождениях();
	
	ИспользоватьСтатусыПересчетовТоваров = СкладыСервер.ИспользоватьСтатусыПересчетовТоваров(Склад);
	
	СкладПомещениеПриИзмененииНаСервере();

КонецПроцедуры

&НаСервере
Процедура СкладПомещениеПриИзмененииНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокПересчетов, 
		"Помещение", 
		Помещение, 
		ВидСравненияКомпоновкиДанных.Равно,, 
		Истина);
	
	ИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Склад, Помещение);
	
	УстановитьВидимостьСтраницКоманднойПанелиСписокПересчетов();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОформитьПересчетыТоваров(Команда)
	ОформитьСкладскиеАктыСервер();
КонецПроцедуры

//Доб Мешкова
&НаСервере
Процедура ОформитьСкладскиеАктыСервер()
	
	МассивВидовОпераций = Новый Массив;
	МассивВидовОпераций.Добавить("Оприходование");
	МассивВидовОпераций.Добавить("Списание");
	
	ДатаДокумента = ТекущаяДата();
	ТоварыРаспределенные = Обработки.ПомощникОформленияСкладскихАктов.ТоварыКОформлениюСкладскихАктов(Склад);
	Для Каждого ВидОперации Из МассивВидовОпераций Цикл
		МассивОпераций = ТоварыРаспределенные.НайтиСтроки(Новый Структура("ОперацияТекст", ВидОперации));
		 
		Организация = Справочники.Организации.НайтиПоРеквизиту("ИНН","7720767758");
			Отбор = Новый Структура("ОперацияТекст", ВидОперации);
			Если ВидОперации = "Оприходование" и ТоварыРаспределенные.НайтиСтроки(Отбор).Количество()>0 Тогда
				ДокументСсылка = СоздатьОприходованиеИзлишковТоваровСервер(Организация, ДатаДокумента, ТоварыРаспределенные.НайтиСтроки(Отбор));
			
			ИначеЕсли ВидОперации = "Списание" и ТоварыРаспределенные.НайтиСтроки(Отбор).Количество()>0 Тогда
				ДокументСсылка = СоздатьСписаниеНедостачТоваровСервер(Организация, ДатаДокумента, ТоварыРаспределенные.НайтиСтроки(Отбор));
				
			КонецЕсли;
		
	КонецЦикла;
	
	
	
КонецПроцедуры

&НаСервере
Функция СоздатьСписаниеНедостачТоваровСервер(Знач Организация, Знач ДатаДокумента, Знач СтрокиРаспределения)
	
	ДокументОбъект = Документы.СписаниеНедостачТоваров.СоздатьДокумент();
	ДанныеЗаполнения = СтруктураДанныхЗаполнения(Организация, ДатаДокумента);
	ДокументОбъект.Заполнить(ДанныеЗаполнения);
	ДокументОбъект.ВидЦены = ДанныеЗаполнения.ВидЦены;
	ДокументОбъект.СтатьяРасходов = ПланыВидовХарактеристик.СтатьиРасходов.НайтиПоКоду("00-000075");
	ДокументОбъект.АналитикаРасходов = Справочники.ФизическиеЛица.НайтиПоНаименованию("Sklad_test");
	
	Для Каждого Распределение из СтрокиРаспределения Цикл
		НоваяСтрока = ДокументОбъект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Распределение);
		НоваяСтрока.Номенклатура = Распределение.НоменклатураСписываемая;
		НоваяСтрока.Характеристика = Распределение.ХарактеристикаСписываемая;
		НоваяСтрока.Назначение = Распределение.НазначениеСписываемое;
		НоваяСтрока.Серия = Распределение.СерияСписываемая;
		НоваяСтрока.Количество = Распределение.КоличествоНеРаспределено;
	КонецЦикла;
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(
		НоменклатураСервер.ПараметрыУказанияСерий(ДокументОбъект,
			Документы.СписаниеНедостачТоваров));
			
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ДокументОбъект, ПараметрыУказанияСерий);
	
	Если ЗначениеЗаполнено(ДокументОбъект.ВидЦены) И ДокументОбъект.Товары.Количество() > 0 Тогда
		ПродажиСервер.ЗаполнитьЦены(
			ДокументОбъект.Товары, ,
			Новый Структура("Дата, Валюта, ВидЦены, КолонкиПоЗначению", ДокументОбъект.Дата, 
				Константы.ВалютаУправленческогоУчета.Получить(), ДокументОбъект.ВидЦены, 
				Новый Структура("Упаковка", Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка())),
			Новый Структура()
			);
	КонецЕсли;
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	Если ДокументОбъект.ПроверитьЗаполнение() Тогда
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	
	                 
	Возврат ДокументОбъект.Ссылка;
	
КонецФункции


&НаСервере
Функция СоздатьОприходованиеИзлишковТоваровСервер(Знач Организация, Знач ДатаДокумента, Знач СтрокиРаспределения)
	
	ДокументОбъект = Документы.ОприходованиеИзлишковТоваров.СоздатьДокумент();
	ДанныеЗаполнения = СтруктураДанныхЗаполнения(Организация, ДатаДокумента);
	ДокументОбъект.Заполнить(ДанныеЗаполнения);	
    ДокументОбъект.ВидЦены = ДанныеЗаполнения.ВидЦены;
	ДокументОбъект.СтатьяДоходов = ПланыВидовХарактеристик.СтатьиДоходов.НайтиПоКоду("00-000001");
	ДокументОбъект.АналитикаДоходов = Организация;
	Для Каждого Распределение из СтрокиРаспределения Цикл
		
		НоваяСтрока = ДокументОбъект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Распределение);
		
		НоваяСтрока.Номенклатура = Распределение.НоменклатураПриходуемая;
		НоваяСтрока.Характеристика = Распределение.ХарактеристикаПриходуемая;
		НоваяСтрока.Назначение = Распределение.НазначениеПриходуемое;
		НоваяСтрока.Серия = Распределение.СерияПриходуемая;
		НоваяСтрока.Количество = Распределение.КоличествоНеРаспределено;
		
		НоваяСтрока.Сумма = НоваяСтрока.Количество * НоваяСтрока.Цена;
		
	КонецЦикла;
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(
		НоменклатураСервер.ПараметрыУказанияСерий(ДокументОбъект,
			Документы.ОприходованиеИзлишковТоваров));
			
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ДокументОбъект, ПараметрыУказанияСерий);
	
	Если ЗначениеЗаполнено(ДокументОбъект.ВидЦены) И ДокументОбъект.Товары.Количество() > 0 Тогда
		ПродажиСервер.ЗаполнитьЦены(
			ДокументОбъект.Товары, ,
			Новый Структура("Дата, Валюта, ВидЦены, КолонкиПоЗначению", ДокументОбъект.Дата, 
				Константы.ВалютаУправленческогоУчета.Получить(), ДокументОбъект.ВидЦены, 
				Новый Структура("Упаковка", Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка())),
			Новый Структура("ПересчитатьСумму", "Количество"));
	КонецЕсли;
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	
	
	ТабЧасть = ДокументОбъект.Товары;
	
	Если ТабЧасть.Количество() <> 0 Тогда   		
		
	НомераГИД = ЗаполнитьНомераГТДНаСервере(ДокументОбъект.Ссылка);
	
	Для каждого НомерГТД Из НомераГИД Цикл
		ПараметрыОтбора = Новый Структура("Номенклатура, Характеристика", НомерГТД.Номенклатура, НомерГТД.Характеристика);
		
		НайденныеСтроки = ТабЧасть.НайтиСтроки(ПараметрыОтбора);
		
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ЗаполнитьЗначенияСвойств(НайденнаяСтрока, НомерГТД,, "Номенклатура, Характеристика");
		КонецЦикла; 
	КонецЦикла;
	
КонецЕсли;

    ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);

	Если ДокументОбъект.Товары.Найти(0, "Цена")<>Неопределено или ДокументОбъект.Товары.Найти(Справочники.НомераГТД.ПустаяСсылка(), "НомерГТД")<>Неопределено Тогда
	Сообщить("Документ "+Строка(ДокументОбъект.Ссылка)+" не проведен. Отсутствуют цены\номера ГТД.");	
	
    Иначе
	Если ДокументОбъект.ПроверитьЗаполнение() Тогда
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
		Исключение
		КонецПопытки;
	КонецЕсли;
    КонецЕсли;
		
	
	
	                 
		                 
	Возврат ДокументОбъект.Ссылка;
	
КонецФункции

&НаСервере
Функция СтруктураДанныхЗаполнения(Организация, ДатаДокумента)
	
	ДанныеЗаполнения = Новый Структура;
	
	ДанныеЗаполнения.Вставить("Дата", ДатаДокумента);
	ДанныеЗаполнения.Вставить("Организация", Организация);
	ДанныеЗаполнения.Вставить("Склад", Склад);
	ДанныеЗаполнения.Вставить("ИсточникИнформацииОЦенахДляПечати", Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен);
	ДанныеЗаполнения.Вставить("ВидЦены", Справочники.ВидыЦен.НайтиПоНаименованию("Себестоимость"));
	ДанныеЗаполнения.Вставить("Ответственный", Пользователи.ТекущийПользователь());
	ДанныеЗаполнения.Вставить("НеЗаполнятьТаблинуюЧастьТовары");
							
	Возврат ДанныеЗаполнения;
	
КонецФункции 

&НаСервереБезКонтекста
Функция ЗаполнитьНомераГТДНаСервере(Документ)
	
	Запрос       = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОприходованиеИзлишковТоваровТовары.Номенклатура КАК Номенклатура,
	|	ОприходованиеИзлишковТоваровТовары.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ втИсходныеДанные
	|ИЗ
	|	Документ.ОприходованиеИзлишковТоваров.Товары КАК ОприходованиеИзлишковТоваровТовары
	|ГДЕ
	|	ОприходованиеИзлишковТоваровТовары.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втИсходныеДанные.Номенклатура КАК Номенклатура,
	|	втИсходныеДанные.Характеристика КАК Характеристика,
	|	МАКСИМУМ(ЕСТЬNULL(ДатыПоступленияТоваровОрганизаций.ДатаПоступления, ДАТАВРЕМЯ(1, 1, 1))) КАК ДатаПоступления
	|ПОМЕСТИТЬ втСрезПоследних
	|ИЗ
	|	втИсходныеДанные КАК втИсходныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДатыПоступленияТоваровОрганизаций КАК ДатыПоступленияТоваровОрганизаций
	|		ПО втИсходныеДанные.Номенклатура = ДатыПоступленияТоваровОрганизаций.Номенклатура
	|			И втИсходныеДанные.Характеристика = ДатыПоступленияТоваровОрганизаций.Характеристика
	|ГДЕ
	|	ДатыПоступленияТоваровОрганизаций.НомерГТД <> ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	втИсходныеДанные.Номенклатура,
	|	втИсходныеДанные.Характеристика
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	ДатаПоступления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСрезПоследних.Номенклатура,
	|	втСрезПоследних.Характеристика,
	|	ДатыПоступленияТоваровОрганизаций.НомерГТД
	|ИЗ
	|	втСрезПоследних КАК втСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДатыПоступленияТоваровОрганизаций КАК ДатыПоступленияТоваровОрганизаций
	|		ПО втСрезПоследних.Номенклатура = ДатыПоступленияТоваровОрганизаций.Номенклатура
	|			И втСрезПоследних.Характеристика = ДатыПоступленияТоваровОрганизаций.Характеристика
	|			И втСрезПоследних.ДатаПоступления = ДатыПоступленияТоваровОрганизаций.ДатаПоступления";
	Запрос.УстановитьПараметр("Ссылка", Документ);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	НомераГТД = ОбщегоНазначения.ТаблицаЗначенийВМассив(Результат);
	
	Возврат НомераГТД;
	
КонецФункции

//Доб Мешкова

#КонецОбласти
