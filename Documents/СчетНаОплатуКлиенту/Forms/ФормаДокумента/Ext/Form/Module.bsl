﻿&НаКлиенте
Перем ОтветПередЗаписью;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	
	ДенежныеСредстваСервер.УстановитьВидимостьОплатыПлатежнойКартой(Элементы.ФормаОплаты);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		Если Параметры.Свойство("Основание") Тогда
			Основание = Параметры.Основание;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДокументОснование", "Видимость", ЗначениеЗаполнено(Объект.ДокументОснование));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	// Подсистема "ОбменСКонтрагентами".
	ПараметрыЭДОПриСоздании= ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаДокумента();
	ПараметрыЭДОПриСоздании.Форма = ЭтотОбъект;
	ПараметрыЭДОПриСоздании.ДокументССылка = Объект.Ссылка;
	ПараметрыЭДОПриСоздании.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыЭДОПриСоздании.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаДокумента(ПараметрыЭДОПриСоздании);
	// Конец подсистема "ОбменСКонтрагентами".
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;
	
	// ИнтеграцияСЯндексКассой
	ИнтеграцияСЯндексКассой.ПриСозданииНаСервере(Параметры.Ключ, ЭтотОбъект,
		ЭтаФорма.КоманднаяПанель);
	// Конец ИнтеграцияСЯндексКассой
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(Объект.Ссылка);
		
		Отказ = Истина;
		СамообслуживаниеКлиент.ПечатьСчетНаОплату(МассивСсылок);
		Возврат;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ФинансыКлиент.ПроверитьЗаполнениеДокументаНаОсновании(
			Объект,
			Основание);
	КонецЕсли;
	
	// Подсистема "ОбменСКонтрагентами".
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец подсистема "ОбменСКонтрагентами".
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		ТребуетсяОткрытиеПечатнойФормы = Истина;
		Возврат;
	КонецЕсли;
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		СуммаЭтаповОплаты = Объект.ЭтапыГрафикаОплаты.Итог("СуммаПлатежа");
		
		Если Объект.СуммаДокумента = 0 Тогда
			
			Объект.СуммаДокумента = СуммаЭтаповОплаты;
			
		ИначеЕсли НЕ ОтветПередЗаписью и Объект.СуммаДокумента <> СуммаЭтаповОплаты Тогда
			Отказ = Истина;
			ТекстВопроса = НСтр("ru='Сумма этапов графика оплаты не совпадает с суммой документа. Скорректировать сумму этапов оплаты?'");
			ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветНаВопрос = РезультатВопроса;
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ОтветПередЗаписью = Истина;
		ЭтапыОплатыКлиентСервер.РаспределитьСуммуПоЭтапамГрафикаОплаты(Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
		Записать();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыПослеЗаписи = ОбменСКонтрагентами.ПараметрыПослеЗаписиНаСервере();
	ПараметрыПослеЗаписи.Форма = ЭтотОбъект;
	ПараметрыПослеЗаписи.ДокументСсылка = Объект.Ссылка;
	ПараметрыПослеЗаписи.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПослеЗаписи.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;

	ОбменСКонтрагентами.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ПараметрыПослеЗаписи);
	// Конец подсистема "ОбменСКонтрагентами".

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыОповещения = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаДокумента();
	ПараметрыОповещения.Форма = ЭтотОбъект;
	ПараметрыОповещения.ДокументСсылка = Объект.Ссылка;
	ПараметрыОповещения.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыОповещения.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	// Конец подсистема "ОбменСКонтрагентами".
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьНазначениеПлатежа(Команда)
	ЗаполнитьНазначениеПлатежа();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФормаОплатыПриИзменении(Элемент)

	ПриИзмененииФормыОплатыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастичнаяОплатаПриИзменении(Элемент)
	
	Если Не Объект.ЧастичнаяОплата И ЗначениеЗаполнено(ОБъект.ДокументОснование) Тогда
		Если Объект.ЭтапыГрафикаОплаты.Количество() > 0 Тогда
			ОтветНаВопрос = Неопределено;

			ПоказатьВопрос(Новый ОписаниеОповещения("ЧастичнаяОплатаПриИзмененииЗавершение", ЭтотОбъект), НСтр("ru='Таблица этапов оплаты будет заполнена по основанию. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
            Возврат;
		КонецЕсли;
		ЗаполнитьЭтапыОплатыПоОснованиюСервер();

	Иначе
		УстановитьДоступностьЭлементовПоЧастичнойОплате();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЧастичнаяОплатаПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ОтветНаВопрос = РезультатВопроса;
    Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
        Объект.ЧастичнаяОплата = Истина;
        Возврат;
    КонецЕсли;
    
    ЗаполнитьЭтапыОплатыПоОснованиюСервер();

КонецПроцедуры

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)
	
	ЭтапыОплатыКлиентСервер.РаспределитьСуммуПоЭтапамГрафикаОплаты(Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЭДОНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСКонтрагентамиКлиент.ОткрытьДеревоЭД(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЭтапыГрафикаОплаты

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПослеУдаления(Элемент)
	
	РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыПроцентПлатежаПриИзменении(Элемент)
	
	ЭтапыОплатыКлиент.ЭтапыГрафикаОплатыПроцентПлатежаПриИзменении(Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные, Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыГрафикаОплатыСуммаПлатежаПриИзменении(Элемент)

	ЭтапыОплатыКлиент.ЭтапыГрафикаОплатыСуммаПлатежаПриИзменении(Элементы.ЭтапыГрафикаОплаты.ТекущиеДанные, Объект.ЭтапыГрафикаОплаты, Объект.СуммаДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодпискуНаОповещения(Команда)
	
	ТипыСобытий = Новый Массив();
	ТипыСобытий.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСобытийОповещений.ВыпискаСчета"));
	ТипыСобытий.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСобытийОповещений.АннулированиеСчета"));
	ТипыСобытий.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСобытийОповещений.ИзменениеСчета"));
	
	РассылкиИОповещенияКлиентамКлиент.НастроитьПодпискуНаОповещенияИзОбъекта(
		Объект.Партнер,
		ТипыСобытий);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплаты.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыНомерСтроки.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыДатаПлатежа.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыСуммаПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЧастичнаяОплата");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыДатаПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ДатаЗаполненаНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ПроцентЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ПроцентЗаполненНеВерно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.НомерСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("НомерСтрокиПолнойОплаты");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НомерСтрокиПолнойОплаты");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Seagreen);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЭтапыГрафикаОплатыПроцентПлатежа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЭтапыГрафикаОплаты.ЭтоЗалогЗаТару");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<залог за тару>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УправлениеЭлементамиФормы();
	УстановитьДоступностьЭлементовПоЧастичнойОплате();
	РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(ЭтаФорма);
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	Элементы.ЧастичнаяОплата.Видимость = ТипЗнч(Объект.ДокументОснование) <> Тип("СправочникСсылка.ДоговорыКонтрагентов");
	
	ТипыСобытий = Новый Массив();
	ТипыСобытий.Добавить(Перечисления.ТипыСобытийОповещений.ВыпискаСчета);
	ТипыСобытий.Добавить(Перечисления.ТипыСобытийОповещений.АннулированиеСчета);
	ТипыСобытий.Добавить(Перечисления.ТипыСобытийОповещений.ИзменениеСчета);
	
	РассылкиИОповещенияКлиентам.УстановитьВидимостьПодпискиНаОповещенияВОбъекте(
		Элементы.ГруппаПодпискаНаОповещения,
		Объект.Партнер,
		ТипыСобытий);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказателиСчетаНаОплатуКлиенту(Форма)
	
	ПроцентПлатежейОбщий = 0;
	ПредыдущееЗначениеДаты = Дата(1, 1, 1);
	Форма.НомерСтрокиПолнойОплаты = 0;
	Для Каждого ТекСтрока Из Форма.Объект.ЭтапыГрафикаОплаты Цикл
		ПроцентПлатежейОбщий = ПроцентПлатежейОбщий + ТекСтрока.ПроцентПлатежа;
		ТекСтрока.ПроцентЗаполненНеВерно = (ПроцентПлатежейОбщий > 100);
		ТекСтрока.ДатаЗаполненаНеВерно = (ПредыдущееЗначениеДаты > ТекСтрока.ДатаПлатежа);
		ПредыдущееЗначениеДаты = ТекСтрока.ДатаПлатежа;
		Если ПроцентПлатежейОбщий = 100 Тогда
			Форма.НомерСтрокиПолнойОплаты = ТекСтрока.НомерСтроки;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	ЛюбаяОплата      = Не ЗначениеЗаполнено(Объект.ФормаОплаты);
	ДоступностьКассы = ЛюбаяОплата Или (Объект.ФормаОплаты = Перечисления.ФормыОплаты.Наличная);
	ДоступностьСчета = ЛюбаяОплата Или (Объект.ФормаОплаты = Перечисления.ФормыОплаты.Безналичная);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Касса", "Доступность", ДоступностьКассы);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "БанковскийСчет", "Доступность", ДоступностьСчета);
	
	УстановитьПривилегированныйРежим(Истина);
	Если ТипЗнч(Объект.ДокументОснование) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
	 Тогда
		Соглашение = Неопределено;
	Иначе
		Соглашение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "Соглашение");
	КонецЕсли;
	
	Если ТипЗнч(Соглашение) = Тип("СправочникСсылка.СоглашенияСКлиентами")
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		ИспользуютсяДоговорыКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами");
	Иначе
		ИспользуютсяДоговорыКонтрагентов =
			ЗначениеЗаполнено(Соглашение)
			И ОбщегоНазначенияУТ.ЗначениеРеквизитаОбъектаТипаБулево(Соглашение, "ИспользуютсяДоговорыКонтрагентов");
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Договор", "Видимость", ИспользуютсяДоговорыКонтрагентов);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииФормыОплатыСервер()
	
	УправлениеЭлементамиФормы();
	
	СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
	СтруктураПараметров.Организация    		= Объект.Организация;
	СтруктураПараметров.БанковскийСчет		= Объект.БанковскийСчет;
	Объект.БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовПоЧастичнойОплате()
	
	МассивЭлементов = Новый Массив();
	
	МассивЭлементов.Добавить("ЭтапыГрафикаОплаты");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "ТолькоПросмотр", Не Объект.ЧастичнаяОплата);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СуммаДокумента", "ТолькоПросмотр", Не Объект.ЧастичнаяОплата);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭтапыОплатыПоОснованиюСервер()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
		
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	1 КАК Порядок,
			|	ЭтапыОплаты.ДатаПлатежа КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентПлатежа КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаПлатежа КАК СуммаПлатежа,
			|	ЛОЖЬ КАК ЭтоЗалогЗаТару
			|ИЗ
			|	Документ.ЗаказКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|	И ЭтапыОплаты.СуммаПлатежа <> 0
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	2 КАК Порядок,
			|	ЭтапыОплаты.ДатаПлатежа КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентЗалогаЗаТару КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаЗалогаЗаТару КАК СуммаПлатежа,
			|	ИСТИНА КАК ЭтоЗалогЗаТару
			|ИЗ
			|	Документ.ЗаказКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|	И ЭтапыОплаты.Ссылка.ТребуетсяЗалогЗаТару
			|	И ЭтапыОплаты.СуммаЗалогаЗаТару <> 0
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаПлатежа,
			|	Порядок
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
		
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	1 КАК Порядок,
			|	ЭтапыОплаты.ДатаПлатежа КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентПлатежа КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаПлатежа КАК СуммаПлатежа,
			|	ЛОЖЬ КАК ЭтоЗалогЗаТару
			|ИЗ
			|	Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	2 КАК Порядок,
			|	ЭтапыОплаты.ДатаПлатежа КАК ДатаПлатежа,
			|	ЭтапыОплаты.ПроцентЗалогаЗаТару КАК ПроцентПлатежа,
			|	ЭтапыОплаты.СуммаЗалогаЗаТару КАК СуммаПлатежа,
			|	ИСТИНА КАК ЭтоЗалогЗаТару
			|ИЗ
			|	Документ.ЗаявкаНаВозвратТоваровОтКлиента.ЭтапыГрафикаОплаты КАК ЭтапыОплаты
			|ГДЕ
			|	ЭтапыОплаты.Ссылка = &Ссылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаПлатежа,
			|	Порядок
			|";
		
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДанныеДокумента.Ссылка КАК Ссылка,
			|	1 КАК НомерСтроки,
			|	ДанныеДокумента.Дата КАК ДатаПлатежа,
			|	0 КАК ПроцентПлатежа,
			|	ДанныеДокумента.СуммаПредоплатыЗаТару КАК СуммаПлатежа,
			|	ИСТИНА КАК ЭтоЗалогЗаТару
			|
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК ДанныеДокумента
			|
			|ГДЕ
			|	ДанныеДокумента.Ссылка = &Ссылка
			|	И ДанныеДокумента.ТребуетсяЗалогЗаТару
			|	И ДанныеДокумента.СуммаПредоплатыЗаТару > 0
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДанныеДокумента.Ссылка КАК Ссылка,
			|	2 КАК НомерСтроки,
			|	ДанныеДокумента.Дата КАК ДатаПлатежа,
			|	
			|	(ДанныеДокумента.СуммаПредоплаты - ДанныеДокумента.СуммаПредоплатыЗаТару)
			|		/ (ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(СУММА(Тара.СуммаСНДС), 0)) * 100 КАК ПроцентПлатежа,
			|	
			|	ДанныеДокумента.СуммаПредоплаты - ДанныеДокумента.СуммаПредоплатыЗаТару КАК СуммаПлатежа,
			|	ЛОЖЬ КАК ЭтоЗалогЗаТару
			|
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК ДанныеДокумента
			|
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		Документ.РеализацияТоваровУслуг.Товары КАК Тара
			|	ПО
			|		Тара.Ссылка = ДанныеДокумента.Ссылка
			|		И ДанныеДокумента.ТребуетсяЗалогЗаТару
			|		И Тара.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|
			|ГДЕ
			|	ДанныеДокумента.Ссылка = &Ссылка
			|	И ДанныеДокумента.СуммаПредоплаты > ДанныеДокумента.СуммаПредоплатыЗаТару
			|
			|СГРУППИРОВАТЬ ПО
			|	ДанныеДокумента.Ссылка
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДанныеДокумента.Ссылка КАК Ссылка,
			|	3 КАК НомерСтроки,
			|	ДанныеДокумента.ДатаПлатежа КАК ДатаПлатежа,
			|	0 КАК ПроцентПлатежа,
			|	
			|	СУММА(Тара.СуммаСНДС) - ДанныеДокумента.СуммаПредоплатыЗаТару КАК СуммаПлатежа,
			|	
			|	ИСТИНА КАК ЭтоЗалогЗаТару
			|
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК ДанныеДокумента
			|
			|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
			|		Документ.РеализацияТоваровУслуг.Товары КАК Тара
			|	ПО
			|		Тара.Ссылка = ДанныеДокумента.Ссылка
			|		И ДанныеДокумента.ТребуетсяЗалогЗаТару
			|		И Тара.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|
			|ГДЕ
			|	ДанныеДокумента.Ссылка = &Ссылка
			|
			|СГРУППИРОВАТЬ ПО
			|	ДанныеДокумента.Ссылка
			|
			|ИМЕЮЩИЕ
			|	СУММА(Тара.СуммаСНДС) > ДанныеДокумента.СуммаПредоплатыЗаТару
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ДанныеДокумента.Ссылка КАК Ссылка,
			|	4 КАК НомерСтроки,
			|	ДанныеДокумента.ДатаПлатежа КАК ДатаПлатежа,
			|	
			|	(ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(СУММА(Тара.Сумма), 0)
			|		- ДанныеДокумента.СуммаПредоплаты + ДанныеДокумента.СуммаПредоплатыЗаТару)
			|		/ (ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(СУММА(Тара.Сумма), 0)) * 100 КАК ПроцентПлатежа,
			|	
			|	ДанныеДокумента.СуммаДокумента - ЕСТЬNULL(СУММА(Тара.Сумма), 0) 
			|		- ДанныеДокумента.СуммаПредоплаты + ДанныеДокумента.СуммаПредоплатыЗаТару КАК СуммаПлатежа,
			|	
			|	ЛОЖЬ КАК ЭтоЗалогЗаТару
			|
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК ДанныеДокумента
			|
			|	ЛЕВОЕ СОЕДИНЕНИЕ
			|		Документ.РеализацияТоваровУслуг.Товары КАК Тара
			|	ПО
			|		Тара.Ссылка = ДанныеДокумента.Ссылка
			|		И ДанныеДокумента.ТребуетсяЗалогЗаТару
			|		И Тара.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|
			|ГДЕ
			|	ДанныеДокумента.Ссылка = &Ссылка
			|
			|СГРУППИРОВАТЬ ПО
			|	ДанныеДокумента.Ссылка
			|
			|ИМЕЮЩИЕ
			|	ДанныеДокумента.СуммаДокумента - ДанныеДокумента.СуммаПредоплаты
			|		> ЕСТЬNULL(СУММА(Тара.Сумма), 0) - ДанныеДокумента.СуммаПредоплатыЗаТару
			|
			|УПОРЯДОЧИТЬ ПО
			|	Ссылка,
			|	НомерСтроки
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомитенту") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа         КАК ДатаПлатежа,
			|	100                                 КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаВознаграждения КАК СуммаПлатежа
			|ИЗ
			|	Документ.ОтчетКомитенту КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионера") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа    КАК ДатаПлатежа,
			|	100                            КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаДокумента КАК СуммаПлатежа
			|ИЗ
			|	Документ.ОтчетКомиссионера КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионераОСписании") Тогда
			
		ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ДокументПродажи.ДатаПлатежа    КАК ДатаПлатежа,
			|	100                            КАК ПроцентПлатежа,
			|	ДокументПродажи.СуммаДокумента КАК СуммаПлатежа
			|ИЗ
			|	Документ.ОтчетКомиссионераОСписании КАК ДокументПродажи
			|ГДЕ
			|	ДокументПродажи.Ссылка = &Ссылка
			|";
			
	Иначе
		ТекстЗапроса = "";
	КонецЕсли;
	
		Если Не ПустаяСтрока(ТекстЗапроса) Тогда
			
			Если Объект.ЭтапыГрафикаОплаты.Количество() > 0 Тогда
				Объект.ЭтапыГрафикаОплаты.Очистить();
			КонецЕсли;
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("Ссылка", Объект.ДокументОснование);
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				НовыйЭтап = Объект.ЭтапыГрафикаОплаты.Добавить();
				ЗаполнитьЗначенияСвойств(НовыйЭтап, Выборка);
			КонецЦикла;
			
			Объект.СуммаДокумента = Объект.ЭтапыГрафикаОплаты.Итог("СуммаПлатежа");
			
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
	
	УстановитьДоступностьЭлементовПоЧастичнойОплате();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНазначениеПлатежа()
	
	ДокументОснование = Объект.ДокументОснование;
	
	Если НЕ ПустаяСтрока(ДокументОснование) Тогда
		Объект.НазначениеПлатежа = Документы.СчетНаОплатуКлиенту.СформироватьНазначениеПлатежа(
			ДокументОснование.Номер,
			ДокументОснование);
	Иначе
		НазначениеПлатежа = НСтр("ru='По счету № %НомерСчета% от %ДатаСчета%'");
		НазначениеПлатежа = СтрЗаменить(НазначениеПлатежа, 
			"%НомерСчета%", 
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Объект.Номер));
		НазначениеПлатежа = СтрЗаменить(НазначениеПлатежа, "%ДатаСчета%", Формат(Объект.Дата, "ДЛФ=D"));
		Объект.НазначениеПлатежа = НазначениеПлатежа;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

ОтветПередЗаписью = Ложь;
