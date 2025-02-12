﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.УникальныйИдентификатор = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Предусмотрено открытие обработки только из форм объектов.'");
	КонецЕсли;
	
	ИдентификаторВызывающейФормы = Параметры.УникальныйИдентификатор;
	
	Если Параметры.Свойство("ВестиУчетСертификатовНоменклатуры") Тогда
		ВестиУчетСертификатовНоменклатуры = Истина;
	КонецЕсли;
	Если Параметры.Свойство("ОтключитьХарактеристики") Тогда
		ОтключитьХарактеристики = Параметры.ОтключитьХарактеристики;
	КонецЕсли;
	
	Если Параметры.Свойство("ОтборПоТипуНоменклатуры") И ЗначениеЗаполнено(Параметры.ОтборПоТипуНоменклатуры) Тогда
		Если ТипЗнч(Параметры.ОтборПоТипуНоменклатуры) = Тип("ФиксированныйМассив") Тогда
			ОтборПоТипуНоменклатуры.ЗагрузитьЗначения(Новый Массив(Параметры.ОтборПоТипуНоменклатуры));
		ИначеЕсли ТипЗнч(Параметры.ОтборПоТипуНоменклатуры) = Тип("ПеречислениеСсылка.ТипыНоменклатуры") Тогда
			ОтборПоТипуНоменклатуры.Добавить(Параметры.ОтборПоТипуНоменклатуры);
		Иначе
			ОтборПоТипуНоменклатуры.ЗагрузитьЗначения(Параметры.ОтборПоТипуНоменклатуры);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ВариантыРасчетаЦеныНабора) Тогда
		ВариантыРасчетаЦеныНабора.ЗагрузитьЗначения(Параметры.ВариантыРасчетаЦеныНабора);
	КонецЕсли;
	
	Если Параметры.ПодбиратьНоменклатуруПоставщика
		И ЗначениеЗаполнено(Параметры.Партнер) Тогда
		
		ПодбиратьНоменклатуруПоставщика = Истина;
		ИмяМакета = "МакетНоменклатураПоставщика";
		Партнер = Параметры.Партнер;
		
	Иначе
		ИмяМакета = "Макет";
	КонецЕсли;
	
	Элементы.ТоварыНоменклатураПоставщика.Видимость = Параметры.ПодбиратьНоменклатуруПоставщика;
	
	ЗагрузитьНастройкиОтбораПоУмолчанию();

	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	Если ЗначениеЗаполнено(Параметры.ЗаголовокКнопкиПеренести) Тогда
		Команды["ПеренестиВДокумент"].Заголовок = Параметры.ЗаголовокКнопкиПеренести;
		Команды["ПеренестиВДокумент"].Подсказка = Параметры.ЗаголовокКнопкиПеренести;
	КонецЕсли;
	
	Если ОтключитьХарактеристики Тогда
		Элементы.ТоварыХарактеристика.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие и Не ПеренестиВДокумент И Объект.Товары.Количество() > 0 Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru = 'Подобранные товары не перенесены в документ. Перенести?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();

	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		ВыполняетсяЗакрытие = Истина;
		АдресТоваровВХранилище = ПоместитьВоВременноеХранилищеНаСервере();
		Если Параметры.РежимВыбора Тогда
			ОповеститьОВыборе(Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище));
			Закрыть();
		Иначе
			Закрыть(АдресТоваровВХранилище);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВдокумент(Команда)
	
	ПеренестиВДокумент = Истина;
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилищеНаСервере();
	Если Параметры.РежимВыбора Тогда
		ОповеститьОВыборе(Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище));
	Иначе
		Закрыть(АдресТоваровВХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуТоваров(Команда)
	
	ТекстВопроса = НСтр("ru = 'При перезаполнении все введенные вручную данные будут потеряны, продолжить?'");
	
	Если Объект.Товары.Количество() > 0 Тогда
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ЗаполнитьТаблицуТоваровЗавершение", ЭтотОбъект),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
	Иначе
		ЗаполнитьТаблицуТоваровНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуТоваровЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТаблицуТоваровНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Функция СтруктураНастроек()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОбязательныеПоля"   , Новый Массив); //
	СтруктураНастроек.Вставить("ПараметрыДанных"    , Новый Структура);
	СтруктураНастроек.Вставить("КомпоновщикНастроек", Неопределено); // Отбор
	СтруктураНастроек.Вставить("ИмяМакетаСхемыКомпоновкиДанных" , Неопределено);
	СтруктураНастроек.Вставить("ВестиУчетСертификатовНоменклатуры" , ВестиУчетСертификатовНоменклатуры);
	СтруктураНастроек.Вставить("ЦеныНаДату", '00010101');
	СтруктураНастроек.Вставить("Поставщик", Справочники.Партнеры.ПустаяСсылка());
	СтруктураНастроек.Вставить("ВестиУчетСертификатовНоменклатуры" , ВестиУчетСертификатовНоменклатуры);
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), ИдентификаторВызывающейФормы);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваровНаСервере(ПроверятьЗаполнение = Истина)
	
	// Поля необходимые для вывода в таблицу товаров на форме.
	СтруктураНастроек = СтруктураНастроек();
	
	Если ПодбиратьНоменклатуруПоставщика Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("НоменклатураПоставщика");
		СтруктураНастроек.Поставщик = Партнер;
	КонецЕсли;
	СтруктураНастроек.ОбязательныеПоля.Добавить("Номенклатура");
	Если НЕ ОтключитьХарактеристики И ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("Характеристика");
	КонецЕсли;
	
	КомпоновщикНастроекСДополнительнымОтбором = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекСДополнительнымОтбором.ЗагрузитьНастройки(КомпоновщикНастроек.ПолучитьНастройки());
	
	Если ОтборПоТипуНоменклатуры.Количество() > 0 Тогда
		Отбор = КомпоновщикНастроекСДополнительнымОтбором.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Номенклатура.ТипНоменклатуры");
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		Отбор.ПравоеЗначение = ОтборПоТипуНоменклатуры;
		Отбор.Использование = Истина;
	КонецЕсли;
	
	Если ВариантыРасчетаЦеныНабора.Количество() > 0 Тогда
		Отбор = КомпоновщикНастроекСДополнительнымОтбором.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантРасчетаЦеныНабора");
		Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		Отбор.ПравоеЗначение = ВариантыРасчетаЦеныНабора;
		Отбор.Использование = Истина;
	КонецЕсли;
	
	СтруктураНастроек.КомпоновщикНастроек = КомпоновщикНастроекСДополнительнымОтбором;
	СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = ИмяМакета;
	
	Объект.Товары.Очистить();
	
	// Загрузка сформированного списка товаров.
	СтруктураРезультата = Обработки.ПодборТоваровПоОтбору.ПодготовитьСтруктуруДанных(СтруктураНастроек);
	Для Каждого СтрокаТЧ Из СтруктураРезультата.ТаблицаТоваров Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
	КонецЦикла;
	
	Элементы.Товары.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
	
	СхемаКомпоновкиДанных = Обработки.ПодборТоваровПоОтбору.ПолучитьМакет(ИмяМакета);
	
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор)));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	ИспользоватьАссортимент = ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент");
	Если ИспользоватьАссортимент Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "АссортиментНаДату", ТекущаяДатаСеанса());
	КонецЕсли;
	Если ВестиУчетСертификатовНоменклатуры Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек.Настройки, "ВестиУчетСертификатовНоменклатуры", Истина);
	КонецЕсли;                  
КонецПроцедуры

#КонецОбласти

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;