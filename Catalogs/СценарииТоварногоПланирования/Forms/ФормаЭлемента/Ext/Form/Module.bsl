﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
	
		Возврат;
	
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("УправлениеПредприятием") Тогда
		
		Элементы.ИспользоватьДляПланированияМатериалов.Заголовок = НСтр("ru = 'Расчет потребностей в материалах и трудовых ресурсах'");
		Элементы.ГруппаИспользоватьДляЗаказовНаПроизводство.Видимость = Ложь;
		Элементы.ГруппаИспользоватьЗаказыНаПроизводство.Подсказка = "";
		
		Элементы.Календарь.Подсказка = НСтр("ru = 'Календарь работы, используемый для расчета дат запуска продукции, а так же сроков потребностей в материалах и трудовых ресурсах'");
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры
 
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	
	ПланЗакупокПланировать = ?(Объект.ПланЗакупокПланироватьПоСумме, 1, 0);
	ПланПродажПланировать = ?(Объект.ПланПродажПланироватьПоСумме, 1, 0);
	
	ОтображениеПериода = ?(Объект.ОтображатьНомерПериода, 1, 0);
	
	УстановитьВидимостьЭлементов();
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
	ОбновитьНадписиВидовПланов();

КонецПроцедуры 

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Справочник.ВидыПланов.Изменение" И Параметр = Объект.Ссылка Тогда
	
		ОбновитьНадписиВидовПланов();
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПланироватьПриИзменении(Элемент)
	
	Объект.ПланЗакупокПланироватьПоСумме = ПланЗакупокПланировать = 1;
	Объект.ПланПродажПланироватьПоСумме = ПланПродажПланировать = 1;
	Если НЕ (Объект.ПланЗакупокПланироватьПоСумме ИЛИ Объект.ПланПродажПланироватьПоСумме)Тогда
		Объект.Валюта = Неопределено;
	КонецЕсли; 
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)
	
	Если Объект.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год")
		ИЛИ Объект.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
	
		Объект.ОтображатьНомерПериода = Ложь;
		ОтображениеПериода = 0;
	
	КонецЕсли; 
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображениеПериодаПриИзменении(Элемент)
	
	Объект.ОтображатьНомерПериода = ОтображениеПериода = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВПланированииЗакупокПриИзменении(Элемент)
	
	Если Объект.ИспользоватьВПланированииЗакупок Тогда
		Объект.ИспользоватьДляЗаказовПоставщику = Объект.ИспользоватьВПланированииЗакупок;
	Иначе
		Объект.ИспользоватьДляЗаказовПоставщику = Ложь;
	КонецЕсли; 
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВПланированииПродажПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВПланированииСборкиРазборкиПриИзменении(Элемент)
	
	Объект.ИспользоватьДляЗаказовНаСборкуРазборку = Объект.ИспользоватьВПланированииСборкиРазборки;
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВПланированииПроизводстваПриИзменении(Элемент)
	
	
	Объект.ИспользоватьДляПланированияМатериалов         = Объект.ИспользоватьВПланированииПроизводства;
	Объект.ИспользоватьДляЗаказовНаВнутреннееПотребление = Объект.ИспользоватьВПланированииПроизводства;
	
	Объект.Календарь = ?(Объект.ИспользоватьДляПланированияМатериалов, Объект.Календарь, Неопределено);
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДляПланированияМатериаловПриИзменении(Элемент)
	
	Объект.ИспользоватьДляЗаказовНаВнутреннееПотребление = Объект.ИспользоватьДляПланированияМатериалов;
	
	Объект.Календарь = ?(Объект.ИспользоватьДляПланированияМатериалов, Объект.Календарь, Неопределено);
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВПланированииПродажПоКатегориямПриИзменении(Элемент)
	
	Если НЕ Объект.ИспользоватьВПланированииПродажПоКатегориям Тогда
		Объект.ИспользоватьРасчетПоСкоростиПродаж = Ложь;
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражаетсяВБюджетированииПриИзменении(Элемент)
	
	
	Возврат // В УТ 11.1 код данного обработчика пустой
	
КонецПроцедуры

&НаКлиенте
Процедура СценарийБюджетированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	
	Возврат // В УТ 11.1 код данного обработчика пустой
	
КонецПроцедуры 

&НаКлиенте
Процедура НадписьВидыПлановЗакупокНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВидовПлана("ПланЗакупок");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВидыПлановПродажПоКатегориямНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВидовПлана("ПланПродажПоКатегориям");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВидыПлановПродажНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВидовПлана("ПланПродаж");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВидыПлановСборкиРазборкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВидовПлана("ПланСборкиРазборки");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВидыПлановПроизводстваНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВидовПлана("ПланПроизводства");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Оповещение = Новый ОписаниеОповещения("РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма,,Оповещение);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	ИспользоватьПланированиеЗакупок = ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеЗакупок");
	ИспользоватьПланированиеПродаж = ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж");
	ИспользоватьПланированиеСборкиРазборки = ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки");
	ИспользоватьЗаказыПоставщикам = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам");
	ИспользоватьЗаказыНаСборку = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаСборку");
	ИспользоватьОбособленноеОбеспечениеЗаказов = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов");
	
	ИспользоватьПланированиеПроизводства = Ложь;
	
	Элементы.ИспользоватьДляЗаказовПоставщику.Видимость = ИспользоватьПланированиеЗакупок;
	Элементы.ГруппаИспользоватьДляЗаказовПоставщику.Видимость = ИспользоватьПланированиеЗакупок И ИспользоватьЗаказыПоставщикам;
	
	Элементы.ГруппаИспользоватьРасчетПоСкоростиПродаж.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРейтингиПродажНоменклатуры");
	
	Элементы.ГруппаПланировать.Видимость = (ИспользоватьПланированиеЗакупок ИЛИ ИспользоватьПланированиеПродаж);
	
	Элементы.ИспользоватьДляЗаказовНаСборкуРазборку.Видимость = ИспользоватьПланированиеСборкиРазборки;
	Элементы.ГруппаИспользоватьДляЗаказовНаСборкуРазборку.Видимость = ИспользоватьЗаказыНаСборку И ИспользоватьПланированиеСборкиРазборки;
	
	Элементы.ГруппаПланПроизводства.Видимость = ИспользоватьПланированиеПроизводства;
	Элементы.ГруппаИспользоватьЗаказыНаПроизводство.Видимость = ИспользоватьПланированиеПроизводства;
	Элементы.ГруппаИспользоватьДляЗаказовНаВнутреннееПотребление.Видимость = ИспользоватьПланированиеПроизводства;
		

	Элементы.ПланированиеПоНазначениям.Видимость = ИспользоватьОбособленноеОбеспечениеЗаказов;

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьЭлементов(Форма)

	Форма.Элементы.ИспользоватьДляЗаказовПоставщику.Доступность = Форма.Объект.ИспользоватьВПланированииЗакупок;
	
	Форма.Элементы.Валюта.Доступность = (Форма.Объект.ПланЗакупокПланироватьПоСумме ИЛИ Форма.Объект.ПланПродажПланироватьПоСумме);
	Форма.Элементы.ИспользоватьДляЗаказовНаСборкуРазборку.Доступность = Форма.Объект.ИспользоватьВПланированииСборкиРазборки;
	Форма.Элементы.ИспользоватьРасчетПоСкоростиПродаж.Доступность = Форма.Объект.ИспользоватьВПланированииПродажПоКатегориям;
	
	
	Если Форма.Объект.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год")
		ИЛИ Форма.Объект.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
	
		Форма.Элементы.ОтображениеПериода.Доступность = Ложь;
		
	Иначе
		
		Форма.Элементы.ОтображениеПериода.Доступность = Истина;
		
	КонецЕсли;
	
	Форма.Элементы.НадписьВидыПлановЗакупок.Доступность = Форма.Объект.ИспользоватьВПланированииЗакупок;
	Форма.Элементы.НадписьВидыПлановПродаж.Доступность = Форма.Объект.ИспользоватьВПланированииПродаж;
	Форма.Элементы.НадписьВидыПлановПродажПоКатегориям.Доступность = Форма.Объект.ИспользоватьВПланированииПродажПоКатегориям;
	Форма.Элементы.НадписьВидыПлановСборкиРазборки.Доступность = Форма.Объект.ИспользоватьВПланированииСборкиРазборки;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписиВидовПланов()
	
	ВидыПланов = Новый Структура;
	ВидыПланов.Вставить("ПланЗакупок", 
		Новый Структура("Количество, Ссылка, ТипПлана", 0, Неопределено, Перечисления.ТипыПланов.ПланЗакупок));
	ВидыПланов.Вставить("ПланПродаж", 
		Новый Структура("Количество, Ссылка, ТипПлана", 0, Неопределено, Перечисления.ТипыПланов.ПланПродаж));
	ВидыПланов.Вставить("ПланПродажПоКатегориям", 
		Новый Структура("Количество, Ссылка, ТипПлана", 0, Неопределено, Перечисления.ТипыПланов.ПланПродажПоКатегориям));
	ВидыПланов.Вставить("ПланСборкиРазборки", 
		Новый Структура("Количество, Ссылка, ТипПлана", 0, Неопределено, Перечисления.ТипыПланов.ПланСборкиРазборки));
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыПланов.ТипПлана КАК ТипПлана,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВидыПланов.Ссылка) КАК Количество
		|ПОМЕСТИТЬ КоличествоВидов
		|ИЗ
		|	Справочник.ВидыПланов КАК ВидыПланов
		|ГДЕ
		|	ВидыПланов.Владелец = &Владелец
		|	И ВидыПланов.ТипПлана <> ЗНАЧЕНИЕ(Перечисление.ТипыПланов.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВидыПланов.ТипПлана
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ТипПлана
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КоличествоВидов.ТипПлана,
		|	КоличествоВидов.Количество,
		|	ЕСТЬNULL(ВидыПланов.Ссылка, ЗНАЧЕНИЕ(Справочник.ВидыПланов.ПустаяСсылка)) КАК Ссылка
		|ИЗ
		|	КоличествоВидов КАК КоличествоВидов
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПланов КАК ВидыПланов
		|		ПО КоличествоВидов.ТипПлана = ВидыПланов.ТипПлана
		|			И (ВидыПланов.Владелец = &Владелец)
		|			И (КоличествоВидов.Количество = 1)";
		
		Запрос.УстановитьПараметр("Владелец", Объект.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		ТипыПланов = Новый Соответствие;
		ТипыПланов.Вставить(Перечисления.ТипыПланов.ПланЗакупок, "ПланЗакупок");
		ТипыПланов.Вставить(Перечисления.ТипыПланов.ПланПродаж, "ПланПродаж");
		ТипыПланов.Вставить(Перечисления.ТипыПланов.ПланПродажПоКатегориям, "ПланПродажПоКатегориям");
		ТипыПланов.Вставить(Перечисления.ТипыПланов.ПланСборкиРазборки, "ПланСборкиРазборки");
		
		
		КоличествоВидоПланов = 0;
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Если ТипыПланов.Получить(ВыборкаДетальныеЗаписи.ТипПлана) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ВидыПланов.Вставить(
				ТипыПланов.Получить(ВыборкаДетальныеЗаписи.ТипПлана), 
				Новый Структура("Количество, Ссылка, ТипПлана", 
					ВыборкаДетальныеЗаписи.Количество, 
					ВыборкаДетальныеЗаписи.Ссылка, 
					ВыборкаДетальныеЗаписи.ТипПлана));
			
			КоличествоВидоПланов = КоличествоВидоПланов + ВыборкаДетальныеЗаписи.Количество;
		КонецЦикла;
		
	КонецЕсли; 
	
	ОбновитьНадписьВидовПланов(ВидыПланов, "ПланЗакупок", НадписьВидыПлановЗакупок);
	
	ОбновитьНадписьВидовПланов(ВидыПланов, "ПланПродаж", НадписьВидыПлановПродаж);
	
	ОбновитьНадписьВидовПланов(ВидыПланов, "ПланПродажПоКатегориям", НадписьВидыПлановПродажПоКатегориям);
	
	ОбновитьНадписьВидовПланов(ВидыПланов, "ПланСборкиРазборки", НадписьВидыПлановСборкиРазборки);
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьНадписьВидовПланов(ВидыПланов, ТипПлана, Надпись)
	
	ВидПлана = Неопределено;
	ВидыПланов.Свойство(ТипПлана, ВидПлана);
	
	Если ВидПлана = Неопределено ИЛИ ВидПлана.Количество = 0 Тогда
		Надпись = НСтр("ru = '<настроить вид плана>'");
	ИначеЕсли ВидПлана.Количество = 1 Тогда
		Надпись = НСтр("ru = 'Настроить вид плана:'") + " " + Строка(ВидПлана.Ссылка);
	Иначе
		Надпись = НСтр("ru = 'Видов планов:'") + " " + Строка(ВидПлана.Количество);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВидовПлана(ТипПлана)

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Оповещение = Новый ОписаниеОповещения("ОткрытьФормуВидовПланаОтветНаВопрос", ЭтотОбъект, Новый Структура("ТипПлана", ТипПлана));
		ТекстВопроса = НСтр("ru = 'Для настройки вида плана необходимо записать сценарий. Записать и продолжить?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Записать и продолжить'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, Кнопки);
		Возврат;
	
	КонецЕсли; 
	
	ОткрытьФормуВидовПланаЗавершение(ТипПлана);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВидовПланаОтветНаВопрос(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Записать() Тогда
	
		ОткрытьФормуВидовПланаЗавершение(ДополнительныеПараметры.ТипПлана);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВидовПланаЗавершение(ТипПлана)
	
	Перем ВидПлана, ПараметрыФормы;
	
	ВидПлана = Неопределено;
	ВидыПланов.Свойство(ТипПлана, ВидПлана);
	
	Если ВидПлана = Неопределено ИЛИ ВидПлана.Количество = 0 ИЛИ ВидПлана.Количество = 1 Тогда
		
		ПараметрыФормы = Новый Структура;
		
		Если ВидПлана = Неопределено Тогда
			
		ИначеЕсли ВидПлана.Количество = 0 Тогда
			ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Владелец, ТипПлана", Объект.Ссылка, ВидПлана.ТипПлана));
		Иначе
			ПараметрыФормы.Вставить("Ключ", ВидПлана.Ссылка);
		КонецЕсли; 
		
		ОткрытьФорму("Справочник.ВидыПланов.ФормаОбъекта", 
			ПараметрыФормы,
			ЭтотОбъект,
			УникальныйИдентификатор);
		
	Иначе
		
		ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Владелец, ТипПлана", Объект.Ссылка, ВидПлана.ТипПлана));
		
		ОткрытьФорму("Справочник.ВидыПланов.ФормаСписка",
			ПараметрыФормы,
			ЭтотОбъект,
			УникальныйИдентификатор);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
