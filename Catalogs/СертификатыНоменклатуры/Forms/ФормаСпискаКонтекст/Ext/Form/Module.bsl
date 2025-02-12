﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Номенклатура",Номенклатура);
	ВидНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура,"ВидНоменклатуры");
	
	ТекстЗаголовка = НСтр("ru = 'Сертификаты номенклатуры (%Владелец%)'");
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Номенклатура));
	
	АвтоЗаголовок = Ложь;
	Заголовок     = ТекстЗаголовка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"ВидНоменклатуры",
		ВидНоменклатуры);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"Номенклатура",
		Номенклатура);
		
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура,"ИспользованиеХарактеристик") =
		Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать Тогда
		Элементы.СертификатыНоменклатурыХарактеристика.Видимость = Ложь;
	КонецЕсли;		
	
	Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры,"ИспользоватьСерии") Тогда
		Элементы.СертификатыНоменклатурыСерия.Видимость = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СертификатыНоменклатурыСоздать",
			"Видимость", ПравоДоступа("Добавление", Метаданные.Справочники.СертификатыНоменклатуры));
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СертификатыНоменклатурыСкопировать",
			"Видимость", ПравоДоступа("Добавление", Метаданные.Справочники.СертификатыНоменклатуры));
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПодобратьСертификаты",
			"Видимость", ПравоДоступа("Редактирование", Метаданные.Справочники.СертификатыНоменклатуры));
			
	МассивТипов = Справочники.СертификатыНоменклатуры.СформироватьСписокВыбораТиповСертификатов();
	Элементы.ТипСертификата.СписокВыбора.ЗагрузитьЗначения(МассивТипов);
	
	Если ТолькоДействующиеНаДату Тогда
		Элементы.Дата.Доступность = Истина;
	Иначе	
		Элементы.Дата.Доступность = Ложь;
	КонецЕсли;
	
	Дата = ТекущаяДатаСеанса();

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СертификатНоменклатуры" Тогда
		
		МассивТипов = СформироватьСписокВыбораТиповСертификатов();
		Элементы.ТипСертификата.СписокВыбора.ЗагрузитьЗначения(МассивТипов);
		Элементы.СертификатыНоменклатуры.Обновить();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипСертификатаПриИзменении(Элемент)
			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СертификатыНоменклатуры,
		"ТипСертификата",
		ТипСертификата,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ТипСертификата));
			
КонецПроцедуры

&НаКлиенте
Процедура ТипСертификатаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	МассивТипов = СформироватьСписокТипов(Текст);
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(МассивТипов);

КонецПроцедуры

&НаКлиенте
Процедура ТолькоДействующиеНаДатуПриИзменении(Элемент)
	
	Если ТолькоДействующиеНаДату Тогда
		Элементы.Дата.Доступность = Истина;
	Иначе	
		Элементы.Дата.Доступность = Ложь;
	КонецЕсли;
	
	УстановитьОтборПоТолькоДействубщимНаДату();	
		
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьОтборПоТолькоДействубщимНаДату();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификатыНоменклатуры

&НаКлиенте
Процедура СертификатыНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекщаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	Если ТекщаяСтрока <> Неопределено Тогда	
		ПараметрыФормы = Новый Структура("Ключ", ТекщаяСтрока.СертификатНоменклатуры);
		ОткрытьФорму("Справочник.СертификатыНоменклатуры.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СертификатыНоменклатурыСоздать(Команда)
	
	ПараметрыФормы = Новый Структура();	
	ПараметрыФормы.Вставить("Номенклатура", Номенклатура);
	ПараметрыФормы.Вставить("ТипСертификата", ТипСертификата);	
	
	ОткрытьФорму("Справочник.СертификатыНоменклатуры.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыСкопировать(Команда)

	ТекщаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	Если ТекщаяСтрока <> Неопределено Тогда	
		ПараметрыФормы = Новый Структура("ЗначениеКопирования", ТекщаяСтрока.СертификатНоменклатуры);
		ОткрытьФорму("Справочник.СертификатыНоменклатуры.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыИзменить(Команда)
	
	ТекщаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	Если ТекщаяСтрока <> Неопределено Тогда	
		ПараметрыФормы = Новый Структура("Ключ", ТекщаяСтрока.СертификатНоменклатуры);
		ОткрытьФорму("Справочник.СертификатыНоменклатуры.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПометитьНаУдаление(Команда)
	
	ТекщаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	Если ТекщаяСтрока <> Неопределено Тогда	
		
		ШаблонВопроса = ?(ТекщаяСтрока.ПометкаУдаления,
			НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
			НСтр("ru = 'Пометить ""%1"" на удаление?'"));
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонВопроса,
		ТекщаяСтрока.СертификатНоменклатуры);
		
		Ответ = Неопределено;

		
		ПоказатьВопрос(Новый ОписаниеОповещения("СертификатыНоменклатурыПометитьНаУдалениеЗавершение", ЭтотОбъект, Новый Структура("ТекщаяСтрока", ТекщаяСтрока)), ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПометитьНаУдалениеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ТекщаяСтрока = ДополнительныеПараметры.ТекщаяСтрока;
    
    
    Ответ = РезультатВопроса; 
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    УстановитьПометкуУдаленияСертификата(ТекщаяСтрока.СертификатНоменклатуры,Не ТекщаяСтрока.ПометкаУдаления);
    Элементы.СертификатыНоменклатуры.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСертификаты(Команда)
	
	ОткрытьФорму("Справочник.СертификатыНоменклатуры.Форма.ФормаПодбораСертификатов", Новый Структура ("Номенклатура", Номенклатура));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИзображение(Команда)
	
	ОчиститьСообщения();
	
	ТекущаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтркутураВозврата = ОткрытьИзображениеНаСервере(ТекущаяСтрока.СертификатНоменклатуры);	

	Если СтркутураВозврата.Результат = "НетИзображений" Тогда
		ТекстСообщения = НСтр("ru='Для сертификата номенклатуры ""%Сертификат%"" отсутствует изображение для просмотра'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Сертификат%",ТекущаяСтрока.СертификатНоменклатуры);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);	
	ИначеЕсли СтркутураВозврата.Результат = "ОдноИзображение" Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(
			РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(
			СтркутураВозврата.ПрисоединенныйФайл,
			УникальныйИдентификатор));
	Иначе
		ПараметрыВыбора = Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе, РежимВыбора",
										   ТекущаяСтрока.СертификатНоменклатуры, Истина, Истина);
		ЗначениеВыбора = Неопределено;

		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыВыбора,,,,, Новый ОписаниеОповещения("ОткрытьИзображениеЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	
			
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИзображениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ЗначениеВыбора = Результат;
    
    Если ЗначениеЗаполнено(ЗначениеВыбора) Тогда
        
        РаботаСФайламиКлиент.ОткрытьФайл(
        РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(
        ЗначениеВыбора,
        УникальныйИдентификатор));
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СертификатыНоменклатурыХарактеристика.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СертификатыНоменклатуры.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всех хараткеристик>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СертификатыНоменклатурыСерия.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СертификатыНоменклатуры.Серия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всех серий>'"));

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СертификатыНоменклатурыДатаОкончанияСрокаДействия.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СертификатыНоменклатуры.Бессрочный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<бессрочный>'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоТолькоДействубщимНаДату()
	                              
	ГруппаОтборПоДействующимНаДату = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(СертификатыНоменклатуры).Элементы,
		"ГруппаОтборПоДействующимНаДату",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДействующимНаДату, "Статус", ПредопределенноеЗначение("Перечисление.СтатусыСертификатовНоменклатуры.Действующий"), 
		ВидСравненияКомпоновкиДанных.Равно, "ГруппаОтборПоДействующимНаДату", ТолькоДействующиеНаДату И ЗначениеЗаполнено(Дата));
		
	ГруппаОтборПоДате = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		ГруппаОтборПоДействующимНаДату,
		"ГруппаОтборПоДате",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);	
		
    ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДате, "ДатаОкончанияСрокаДействия", Дата, 
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно, "ОтборПоДате", ТолькоДействующиеНаДату И ЗначениеЗаполнено(Дата));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДате, "Бессрочный", Истина, 
		ВидСравненияКомпоновкиДанных.Равно, "ОтборПоДатеБессрочный", ТолькоДействующиеНаДату И ЗначениеЗаполнено(Дата));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуУдаленияСертификата(СертификатСсылка, Пометка)
	
	СертификатОбъект = СертификатСсылка.ПолучитьОбъект();
	СертификатОбъект.УстановитьПометкуУдаления(Пометка);	
	СертификатОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Функция ОткрытьИзображениеНаСервере(СертификатНоменкалтуры);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(СертификатыНоменклатурыПрисоединенныеФайлы.Ссылка) КАК ПрисоединенныйФайл,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СертификатыНоменклатурыПрисоединенныеФайлы.Ссылка) КАК КоличествоФайлов,
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла
	|ИЗ
	|	Справочник.СертификатыНоменклатурыПрисоединенныеФайлы КАК СертификатыНоменклатурыПрисоединенныеФайлы
	|ГДЕ
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	|	И СертификатыНоменклатурыПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла";
	Запрос.УстановитьПараметр("ВладелецФайла", СертификатНоменкалтуры);
	
	Выборка = Запрос.Выполнить().Выбрать();	

	СтруктураВозврата = Новый Структура;
	
	Если Выборка.Следующий() Тогда
		Если Выборка.КоличествоФайлов > 1 Тогда
			СтруктураВозврата.Вставить("Результат", "МассивИзображений");
		ИначеЕсли Выборка.КоличествоФайлов = 1 Тогда
			СтруктураВозврата.Вставить("Результат", "ОдноИзображение");
			СтруктураВозврата.Вставить("ПрисоединенныйФайл", Выборка.ПрисоединенныйФайл);
		КонецЕсли;				
	Иначе
		СтруктураВозврата.Вставить("Результат", "НетИзображений");
	КонецЕсли;	
			
	Возврат СтруктураВозврата;
	
КонецФункции	

&НаСервереБезКонтекста
Функция СформироватьСписокТипов(Текст)
	
	Возврат Справочники.СертификатыНоменклатуры.АвтоПодборТиповСертификатов(Текст);
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьСписокВыбораТиповСертификатов()
	
	Возврат Справочники.СертификатыНоменклатуры.СформироватьСписокВыбораТиповСертификатов();
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СертификатыНоменклатуры);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СертификатыНоменклатуры, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СертификатыНоменклатуры);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
