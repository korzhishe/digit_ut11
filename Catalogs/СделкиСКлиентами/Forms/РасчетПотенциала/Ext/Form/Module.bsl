﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаУпрУчета = Строка(Параметры.ВалютаУпрУчета);
	
	//установить заголовок с учетом вылюты управленческого учета
	Элементы.Потенциал.Заголовок = НСтр("ru='Потенциал (%Валюта%)'");
	Элементы.Потенциал.Заголовок = СтрЗаменить(Элементы.Потенциал.Заголовок, "%Валюта%",Константы.ВалютаУправленческогоУчета.Получить());

	//загрузить список документов
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	&ПервичныйСпрос КАК Документ,
		|	1 КАК ДПОРЯДОК,
		|	ВЫБОР
		|		КОГДА СделкиСКлиентами.ВалютаПервичногоСпроса = КурсыВалютыУпр.Валюта
		|			ТОГДА Документ.СуммаДокумента
		|		ИНАЧЕ Документ.СуммаДокумента * ЕСТЬNULL(КурсыВалютыДокумента.Курс, 1) * ЕСТЬNULL(КурсыВалютыУпр.Кратность, 1) / (ЕСТЬNULL(КурсыВалютыУпр.Курс, 1) * ЕСТЬNULL(КурсыВалютыДокумента.Кратность, 1))
		|	КОНЕЦ КАК Потенциал,
		|	"""" КАК Статус
		|ИЗ
		|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			СУММА(СделкиСКлиентамиПервичныйСпрос.Сумма) КАК СуммаДокумента,
		|			СделкиСКлиентамиПервичныйСпрос.Ссылка КАК Ссылка
		|		ИЗ
		|			Справочник.СделкиСКлиентами.ПервичныйСпрос КАК СделкиСКлиентамиПервичныйСпрос
		|		
		|		СГРУППИРОВАТЬ ПО
		|			СделкиСКлиентамиПервичныйСпрос.Ссылка) КАК Документ
		|		ПО СделкиСКлиентами.Ссылка = Документ.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних КАК КурсыВалютыДокумента
		|		ПО СделкиСКлиентами.ВалютаПервичногоСпроса = КурсыВалютыДокумента.Валюта,
		|	РегистрСведений.КурсыВалют.СрезПоследних(
		|			,
		|			Валюта В
		|				(ВЫБРАТЬ
		|					Константы.ВалютаУправленческогоУчета
		|				ИЗ
		|					Константы КАК Константы)) КАК КурсыВалютыУпр
		|ГДЕ
		|	СделкиСКлиентами.Ссылка = &ОтборДокумента
		|	И Документ.СуммаДокумента > 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СоглашенияСКлиентами.Ссылка,
		|	3,
		|	ВЫБОР
		|		КОГДА СоглашенияСКлиентами.Валюта = КурсыВалютыУпр.Валюта
		|			ТОГДА СоглашенияСКлиентами.СуммаДокумента
		|		ИНАЧЕ СоглашенияСКлиентами.СуммаДокумента * ЕСТЬNULL(КурсыВалютыДокумента.Курс, 1) * ЕСТЬNULL(КурсыВалютыУпр.Кратность, 1) / (ЕСТЬNULL(КурсыВалютыУпр.Курс, 1) * ЕСТЬNULL(КурсыВалютыДокумента.Кратность, 1))
		|	КОНЕЦ,
		|	ПРЕДСТАВЛЕНИЕ(СоглашенияСКлиентами.Статус)
		|ИЗ
		|	РегистрСведений.КурсыВалют.СрезПоследних(
		|			,
		|			Валюта В
		|				(ВЫБРАТЬ
		|					Константы.ВалютаУправленческогоУчета
		|				ИЗ
		|					Константы КАК Константы)) КАК КурсыВалютыУпр,
		|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних КАК КурсыВалютыДокумента
		|			ПО СоглашенияСКлиентами.Валюта = КурсыВалютыДокумента.Валюта
		|		ПО СделкиСКлиентами.СоглашениеСКлиентом = СоглашенияСКлиентами.Ссылка
		|ГДЕ
		|	СоглашенияСКлиентами.ПометкаУдаления = ЛОЖЬ
		|	И СделкиСКлиентами.Ссылка = &ОтборДокумента
		|	И СоглашенияСКлиентами.СуммаДокумента > 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КоммерческоеПредложениеКлиенту.Ссылка,
		|	2,
		|	ВЫБОР
		|		КОГДА КоммерческоеПредложениеКлиенту.Валюта = КурсыВалютыУпр.Валюта
		|			ТОГДА КоммерческоеПредложениеКлиенту.СуммаДокумента
		|		ИНАЧЕ КоммерческоеПредложениеКлиенту.СуммаДокумента * ЕСТЬNULL(КурсыВалютыДокумента.Курс, 1) * ЕСТЬNULL(КурсыВалютыУпр.Кратность, 1) / (ЕСТЬNULL(КурсыВалютыУпр.Курс, 1) * ЕСТЬNULL(КурсыВалютыДокумента.Кратность, 1))
		|	КОНЕЦ,
		|	ПРЕДСТАВЛЕНИЕ(КоммерческоеПредложениеКлиенту.Статус)
		|ИЗ
		|	Документ.КоммерческоеПредложениеКлиенту КАК КоммерческоеПредложениеКлиенту
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних КАК КурсыВалютыДокумента
		|		ПО КоммерческоеПредложениеКлиенту.Валюта = КурсыВалютыДокумента.Валюта,
		|	РегистрСведений.КурсыВалют.СрезПоследних(
		|			,
		|			Валюта В
		|				(ВЫБРАТЬ
		|					Константы.ВалютаУправленческогоУчета
		|				ИЗ
		|					Константы КАК Константы)) КАК КурсыВалютыУпр
		|ГДЕ
		|	КоммерческоеПредложениеКлиенту.ПометкаУдаления = ЛОЖЬ
		|	И КоммерческоеПредложениеКлиенту.Сделка = &ОтборДокумента
		|	И КоммерческоеПредложениеКлиенту.СуммаДокумента > 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка,
		|	4,
		|	ВЫБОР
		|		КОГДА ЗаказКлиента.Валюта = КурсыВалютыУпр.Валюта
		|			ТОГДА ЗаказКлиента.СуммаДокумента
		|		ИНАЧЕ ЗаказКлиента.СуммаДокумента * ЕСТЬNULL(КурсыВалютыДокумента.Курс, 1) * ЕСТЬNULL(КурсыВалютыУпр.Кратность, 1) / (ЕСТЬNULL(КурсыВалютыУпр.Курс, 1) * ЕСТЬNULL(КурсыВалютыДокумента.Кратность, 1))
		|	КОНЕЦ,
		|	ПРЕДСТАВЛЕНИЕ(ЗаказКлиента.Статус)
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних КАК КурсыВалютыДокумента
		|		ПО ЗаказКлиента.Валюта = КурсыВалютыДокумента.Валюта,
		|	РегистрСведений.КурсыВалют.СрезПоследних(
		|			,
		|			Валюта В
		|				(ВЫБРАТЬ
		|					Константы.ВалютаУправленческогоУчета
		|				ИЗ
		|					Константы КАК Константы)) КАК КурсыВалютыУпр
		|ГДЕ
		|	ЗаказКлиента.ПометкаУдаления = ЛОЖЬ
		|	И ЗаказКлиента.Сделка = &ОтборДокумента
		|	И ЗаказКлиента.СуммаДокумента > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДПОРЯДОК");
	Запрос.УстановитьПараметр("ОтборДокумента", Параметры.Ключ);
	Запрос.УстановитьПараметр("ПервичныйСпрос", НСтр("ru = 'Первичный спрос'"));
	СписокДокументов = Запрос.Выполнить().Выгрузить();
	СписокДокументов.Колонки.Добавить("Выбран");
	ЗначениеВРеквизитФормы(СписокДокументов, "Список");
	
	СформироватьСтрокуСуммаПотенциала(ЭтотОбъект);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура ВыбранПриИзменении(Элемент)

	СуммаПотенциала = 0;

	Для Каждого Элемент Из Список Цикл
		Если Элемент.Выбран Тогда
			СуммаПотенциала = СуммаПотенциала + Элемент.Потенциал;
		КонецЕсли;
	КонецЦикла;
	
	СформироватьСтрокуСуммаПотенциала(ЭтотОбъект)

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВсе(Команда)

	СуммаПотенциала = 0;

	Для Каждого Элемент Из Список Цикл
		Элемент.Выбран = Истина;
		СуммаПотенциала = СуммаПотенциала + Элемент.Потенциал;
	КонецЦикла;
	
	СформироватьСтрокуСуммаПотенциала(ЭтотОбъект)

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьВыбор(Команда)

	СуммаПотенциала = 0;

	Для Каждого Элемент Из Список Цикл
		Элемент.Выбран = Ложь;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьПотенциал(Команда)

	Закрыть(СуммаПотенциала);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьСтрокуСуммаПотенциала(Форма)

	Форма.СтрокаСуммаПотенциала = Строка(Форма.СуммаПотенциала) + " " + Форма.ВалютаУпрУчета + ".";

КонецПроцедуры


#КонецОбласти
