﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачала = Неопределено;
	Параметры.Свойство("ДатаНачала", ДатаНачала);
	
	ДатаОкончания = Неопределено;
	Параметры.Свойство("ДатаОкончания", ДатаОкончания);
	
	Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) Тогда
		ПериодИнвентаризации.ДатаНачала = ДатаНачала;
		ПериодИнвентаризации.ДатаОкончания = ДатаОкончания;
	Иначе
		ДатаОкончания = Неопределено;
		Параметры.Свойство("ДатаОкончания", ДатаОкончания);
		
	КонецЕсли;
	
	ОтметитьОрганизации = Неопределено;
	Параметры.Свойство("ОтметитьОрганизации", ОтметитьОрганизации);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОтметитьОрганизации", 
		?(ТипЗнч(ОтметитьОрганизации)=Тип("Массив"), ОтметитьОрганизации, Новый Массив));
	Запрос.УстановитьПараметр("ИспользоватьУправленческуюОрганизацию", Константы.ИспользоватьУправленческуюОрганизацию.Получить());
		
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация,
	|	ВЫБОР
	|		КОГДА Организации.Ссылка В (&ОтметитьОрганизации)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНеЦ КАК Отметка,
	|	ВЫБОР
	|		КОГДА Организации.Ссылка В (&ОтметитьОрганизации)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНеЦ КАК Требуется
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	(Не &ИспользоватьУправленческуюОрганизацию
	|				И Не Организации.Предопределенный
	|			Или &ИспользоватьУправленческуюОрганизацию)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Отметка УБЫВ,
	|	Организация";
	
	ТаблицаОрганизаций.Загрузить(Запрос.Выполнить().Выгрузить());
	
	Параметры.Свойство("Склад", Склад);
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если ИспользоватьНесколькоОрганизаций Тогда
		Элементы.СтраницыОрганизации.ТекущаяСтраница = Элементы.СтраницаНесколькоОрганизаций;
	Иначе
		Элементы.СтраницыОрганизации.ТекущаяСтраница = Элементы.СтраницаОднаОрганизация;
		
		Если ТаблицаОрганизаций.Количество() = 0 Тогда
			ТекстОшибки = НСтр("ru = 'Невозможно сформировать инвентаризационную опись, т.к. в настройках программы не введены сведения об организации.'");
			Отказ = Истина;
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
				
		Если ТаблицаОрганизаций[0].Требуется Тогда
			Элементы.СтраницыПотребностьФормированияОписей.ТекущаяСтраница = Элементы.СтраницаОписиФормироватьНужно;
		Иначе
			Элементы.СтраницыПотребностьФормированияОписей.ТекущаяСтраница = Элементы.СтраницаОписиФормироватьНеНужно;
		КонецЕсли;	
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодИнвентаризацииПриИзменении(Элемент)
	ПериодИнвентаризацииПриИзмененииСервер();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОписи

&НаКлиенте
Процедура ОписиПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	
	Оповещение = Новый ОписаниеОповещения("НазадЗавершение", ЭтаФорма);
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить("Удалить", НСтр("ru='Удалить'"));
	СписокКнопок.Добавить("Отмена", НСтр("ru='Отмена'"));
	ТекстВопроса = НСтр("ru='При возврате на предыдущий шаг сформированные инвентаризационные описи будут удалены. Продолжить?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, СписокКнопок,,"Отмена");
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ОчиститьСообщения();
	
	ЕстьОшибки = Ложь;
	Если Не ЗначениеЗаполнено(ПериодИнвентаризации.ДатаНачала) Или Не ЗначениеЗаполнено(ПериодИнвентаризации.ДатаОкончания) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Заполните период инвентаризации.'"), , "ПериодИнвентаризации");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Если ПериодИнвентаризации.ДатаНачала > ПериодИнвентаризации.ДатаОкончания Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Заполните корректно период инвентаризации.'"), , "ПериодИнвентаризации");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Склад) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Заполните Склад.'"), , "Склад");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Если ИспользоватьНесколькоОрганизаций Тогда
		Если ТаблицаОрганизаций.НайтиСтроки(Новый Структура("Отметка", Истина)).Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Выберите одну или несколько организаций, по которым необходимо создать инвентаризационные описи.'"),
				,
				"ТаблицаОрганизаций",
				"Объект");
			ЕстьОшибки = Истина;
		КонецЕсли;
	Иначе
		ТаблицаОрганизаций[0].Отметка = Истина;
	КонецЕсли;
	
	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьОшибки = ЕстьОшибки 
				Или Не ДалееСервер();
	
	Если ЕстьОшибки Тогда
		Возврат;
	Иначе
		ОчиститьСообщения();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	Закрыть(СписокСозданныхОписей.ВыгрузитьЗначения());
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуСоВсех(Команда)
	
	Для Каждого Строка Из ТаблицаОрганизаций Цикл
		Строка.Отметка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	Для Каждого Строка Из ТаблицаОрганизаций Цикл
		Строка.Отметка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОрганизацииПоУмолчанию(Команда)
	
	Для каждого СтрТабл из ТаблицаОрганизаций Цикл
		СтрТабл.Отметка = СтрТабл.Требуется;
	КонецЦикла;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Описи);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Описи, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Описи);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Описи);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДалееСервер()
	
	СозданныеДокументы = СоздатьДокументыСервер();
	СписокСозданныхОписей.ЗагрузитьЗначения(СозданныеДокументы);
	
	Описи.Отбор.Элементы.Очистить();
	ЭлементОтбора = Описи.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.ПравоеЗначение = СозданныеДокументы;
	ЭлементОтбора.Использование = Истина;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраница2;
	Элементы.КнопкаГотово.КнопкаПоУмолчанию = Истина;
		
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция СоздатьДокументыСервер()
	СозданныеДокументы = Новый Массив;
	Для Каждого СтрТабл Из ТаблицаОрганизаций Цикл
		
		Если Не СтрТабл.Отметка Тогда
			Продолжить;
		КонецЕсли;

		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("ДатаНачала", ПериодИнвентаризации.ДатаНачала);
		ДанныеЗаполнения.Вставить("ДатаОкончания", ПериодИнвентаризации.ДатаОкончания);
		ДанныеЗаполнения.Вставить("Склад", Склад);
		ДанныеЗаполнения.Вставить("Организация", СтрТабл.Организация);
		
		ДокументОбъект = Документы.ИнвентаризационнаяОпись.СоздатьДокумент();
		ДокументОбъект.Заполнить(ДанныеЗаполнения);
		ДокументОбъект.Дата = ПериодИнвентаризации.ДатаОкончания;
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		СозданныеДокументы.Добавить(ДокументОбъект.Ссылка);
	КонецЦикла;
	
	Возврат СозданныеДокументы;
	
КонецФункции

&НаКлиенте
Процедура НазадЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = Неопределено Или Ответ = "Отмена" Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьДокументыСервер(СписокСозданныхОписей.ВыгрузитьЗначения());
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраница1;
	Элементы.КнопкаДалее.КнопкаПоУмолчанию = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьДокументыСервер(СписокСозданныхОписей)
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого ДокументСсылка Из СписокСозданныхОписей Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Удалить();
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПериодИнвентаризацииПриИзмененииСервер()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала", ПериодИнвентаризации.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ПериодИнвентаризации.ДатаОкончания);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ТаблицаОрганизаций", ТаблицаОрганизаций.Выгрузить());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаОрганизаций.Отметка,
	|	ТаблицаОрганизаций.Организация,
	|	ТаблицаОрганизаций.Требуется
	|ПОМЕСТИТЬ ТаблицаОрганизаций
	|ИЗ
	|	&ТаблицаОрганизаций КАК ТаблицаОрганизаций
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Дата, ДЕНЬ) КАК Дата,
	|	ВложенныйЗапрос.Организация
	|ПОМЕСТИТЬ ОрганизацииИзАктов
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОприходованиеИзлишковТоваров.Дата КАК Дата,
	|		ОприходованиеИзлишковТоваров.Организация КАК Организация
	|	ИЗ
	|		Документ.ОприходованиеИзлишковТоваров КАК ОприходованиеИзлишковТоваров
	|	ГДЕ
	|		ОприходованиеИзлишковТоваров.Проведен
	|		И ОприходованиеИзлишковТоваров.Склад = &Склад
	|		И ОприходованиеИзлишковТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПересортицаТоваров.Дата,
	|		ПересортицаТоваров.Организация
	|	ИЗ
	|		Документ.ПересортицаТоваров КАК ПересортицаТоваров
	|	ГДЕ
	|		ПересортицаТоваров.Проведен
	|		И ПересортицаТоваров.Склад = &Склад
	|		И ПересортицаТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПорчаТоваров.Дата,
	|		ПорчаТоваров.Организация
	|	ИЗ
	|		Документ.ПорчаТоваров КАК ПорчаТоваров
	|	ГДЕ
	|		ПорчаТоваров.Проведен
	|		И ПорчаТоваров.Склад = &Склад
	|		И ПорчаТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СписаниеНедостачТоваров.Дата,
	|		СписаниеНедостачТоваров.Организация
	|	ИЗ
	|		Документ.СписаниеНедостачТоваров КАК СписаниеНедостачТоваров
	|	ГДЕ
	|		СписаниеНедостачТоваров.Проведен
	|		И СписаниеНедостачТоваров.Склад = &Склад
	|		И СписаниеНедостачТоваров.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания) КАК ВложенныйЗапрос
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОрганизаций.Отметка,
	|	ТаблицаОрганизаций.Организация,
	|	ВЫБОР
	|		КОГДА ОрганизацииИзАктов.Организация ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНеЦ КАК Требуется
	|ИЗ
	|	ТаблицаОрганизаций КАК ТаблицаОрганизаций
	|		ЛЕВОЕ СОЕДИНеНИЕ ОрганизацииИзАктов КАК ОрганизацииИзАктов
	|			ЛЕВОЕ СОЕДИНеНИЕ Документ.ИнвентаризационнаяОпись КАК ИнвентаризационнаяОпись
	|			ПО (ИнвентаризационнаяОпись.Проведен)
	|				И (ИнвентаризационнаяОпись.Организация = ОрганизацииИзАктов.Организация)
	|				И (ИнвентаризационнаяОпись.Склад = &Склад)
	|				И (ОрганизацииИзАктов.Дата МЕЖДУ ИнвентаризационнаяОпись.ДатаНачала И ИнвентаризационнаяОпись.ДатаОкончания)
	|		ПО ТаблицаОрганизаций.Организация = ОрганизацииИзАктов.Организация
	|ГДЕ
	|	ИнвентаризационнаяОпись.Ссылка ЕСТЬ NULL ";
	Таблица = Запрос.Выполнить().Выгрузить();
	ТаблицаОрганизаций.Загрузить(Таблица);
		
КонецПроцедуры

#КонецОбласти
