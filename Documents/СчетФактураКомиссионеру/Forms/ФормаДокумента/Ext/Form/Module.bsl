﻿// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

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
	
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаВыставления = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
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
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	ПроверкаКонтрагентовВызовСервераПереопределяемыйУТ.ФормаДокументаПриСозданииНаСервере(ЭтотОбъект);
	Элементы.ПокупателиЭтоНекорректныйКонтрагент.Видимость = ЭтотОбъект.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

	УчетНДСУТ.НастроитьСовместныйВыборКонтрагентовОрганизаций(Элементы.Комиссионер);
	УчетНДСУТ.НастроитьСовместныйВыборКонтрагентовОрганизаций(Элементы.ПокупателиПокупатель);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыОповещения = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаДокумента();
	ПараметрыОповещения.Форма = ЭтотОбъект;
	ПараметрыОповещения.ДокументСсылка = Объект.Ссылка;
	ПараметрыОповещения.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыОповещения.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;
	
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаДокумента(ИмяСобытия, Параметр, Источник, ПараметрыОповещения);
	// Конец подсистема "ОбменСКонтрагентами".
	
	Если ИмяСобытия = "Запись_Контрагенты" Тогда
		ЗаполнитьСлужебныеРеквизитыПокупателей(Источник);
		УправлениеЭлементамиФормы(ЭтотОбъект);
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Поле ""Дата выставления"" не заполнено'");
	
	Если Выставлен И НЕ ЗначениеЗаполнено(Объект.ДатаВыставления) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ДатаВыставления","Объект",Отказ);
	ИначеЕсли НЕ Выставлен Тогда
		Объект.ДатаВыставления = '00010101';
		Объект.ВыставленВЭлектронномВиде = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыПослеЗаписи = ОбменСКонтрагентами.ПараметрыПослеЗаписиНаСервере();
	ПараметрыПослеЗаписи.Форма = ЭтотОбъект;
	ПараметрыПослеЗаписи.ДокументСсылка = Объект.Ссылка;
	ПараметрыПослеЗаписи.ДекорацияСостояниеЭДО = Элементы.ДекорацияСостояниеЭДО;
	ПараметрыПослеЗаписи.ГруппаСостояниеЭДО = Элементы.ГруппаСостояниеЭДО;

	ОбменСКонтрагентами.ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи, ПараметрыПослеЗаписи);
	// Конец подсистема "ОбменСКонтрагентами".
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ЗаполнитьСлужебныеРеквизитыПокупателей();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		
		Отказ = Истина;
		СамообслуживаниеКлиент.ПечатьДокументСчетФактура(Объект.ДокументОснование);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// Подсистема "ОбменСКонтрагентами".
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец подсистема "ОбменСКонтрагентами".
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ТипЗнч(Пользователи.АвторизованныйПользователь()) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		ТребуетсяОткрытиеПечатнойФормы = Истина;
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_СчетФактураКомиссионера", , Объект.Ссылка);
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИсправленииПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ЗаполнитьСписокКодовВидовОпераций();

КонецПроцедуры

&НаКлиенте
Процедура ВыставленПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыставленВЭлектронномВидеПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежноРасчетныеДокументыСтрокойНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", 		 Объект.Организация);
	ПараметрыФормы.Вставить("ДокументОснование", Объект.ДокументОснование);
	ПараметрыФормы.Вставить("АдресВХранилище",	 ПоместитьПлатежноРасчетныеДокументыВХранилище());
	
	НовыйАдресВХранилище = Неопределено;

	ОписаниеОповещения = Новый ОписаниеОповещения("ПлатежноРасчетныеДокументыСтрокойНажатиеЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.СчетФактураКомиссионеру.Форма.ФормаПлатежноРасчетныеДокументы",
		ПараметрыФормы, , , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежноРасчетныеДокументыСтрокойНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПолучитьПлатежноРасчетныеДокументыИзХранилища(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранныйЭлемент = Неопределено;
	СписокКодовВидовОпераций.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("КодВидаОперацииНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Объект.КодВидаОперации = ВыбранныйЭлемент.Значение;
		ОбновитьПредставлениеВидаОперации(ЭтаФорма);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииПриИзменении(Элемент)
	
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЭДОНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСКонтрагентамиКлиент.ОткрытьДеревоЭД(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПокупателей(Команда)
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Дата");
	СтруктураРеквизитов.Вставить("ДокументОснование");
	
	Оповещение = Новый ОписаниеОповещения("ПроверитьВозможностьПодбораПокупателейЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение, 
		ЭтаФорма, 
		Неопределено, 
		СтруктураРеквизитов,
		Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ИсправлениеПриИзменении(Элемент)
	
	Если Не Объект.Исправление Тогда
		Объект.ДокументОснование = Неопределено;
		Объект.НомерИсправления = "";
	Иначе
		Объект.Организация = Неопределено;
		Объект.Комиссионер = Неопределено;
		Объект.ДокументОснование = Неопределено;
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетФактураОснованиеПриИзменении(Элемент)
	
	СчетФактураОснованиеПриИзмененииСервер()
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиПокупательПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Покупатели.ТекущиеДанные;
	ЗаполнитьСлужебныеРеквизитыПокупателей(ТекущаяСтрока.Покупатель, Истина);
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.Покупатели);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура СчетФактураОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ЗаполнениеОснованияВозможно() Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ЗаполнениеОснованияВозможно() Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	ЗапролнитьЗависимыеОтДокументаОснованияРеквизитыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиКПППокупателяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.Покупатели.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущаяСтрока.Покупатель) Тогда
		ЗаполнитьСписокВыбораКПП(СписокВыбораКПП, ТекущаяСтрока.Покупатель, Объект.Дата);
	КонецЕсли;
	
	ДанныеВыбора = СписокВыбораКПП;
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиИННПокупателяПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.Покупатели);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПокупателиКПППокупателяПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элементы.Покупатели);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
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

#Область РаботаСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт	
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомерИсправленияПриИсправлении.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
#Область ТолькоПросмотрИННПокупателя

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПокупателиИННПокупателя.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Покупатели.ТолькоПросмотрИННПокупателя");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
#КонецОбласти
	
#Область ТолькоПросмотрКПППокупателя

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПокупателиКПППокупателя.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Покупатели.ТолькоПросмотрКПППокупателя");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
#КонецОбласти
	
#Область КонтрагентНеЮрлицоКППНеТребуется

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПокупателиКПППокупателя.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.Покупатели.КППНеТребуется");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",     ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",          НСтр("ru = '<не требуется>'"));
	
#КонецОбласти

#Область ПокупательНомерСчетФактурыТолькоПросмотр

	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПокупателиПокупатель.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПокупателиНомерСчетаФактуры.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Выставлен");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	Выставлен = ЗначениеЗаполнено(Объект.ДатаВыставления);
	
	ЗапролнитьЗависимыеОтДокументаОснованияРеквизитыФормы();
	
	ЗаполнитьСлужебныеРеквизитыПокупателей();
	УправлениеЭлементамиФормы(ЭтаФорма);
	ЗаполнитьСписокКодовВидовОпераций();
	
	Если ЗначениеЗаполнено(Объект.СтрокаПлатежноРасчетныеДокументы) Тогда
		СтрокаПлатежноРасчетныеДокументы = Объект.СтрокаПлатежноРасчетныеДокументы;
	Иначе
		СтрокаПлатежноРасчетныеДокументы = НСтр("ru='<отсутствуют>'"); 
	КонецЕсли;
	
	Элементы.СтрокаПлатежноРасчетныеДокументы.Гиперссылка = ПравоДоступа("Изменение", Метаданные.Документы.СчетФактураКомиссионеру);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ЭтоНовый = НЕ ЗначениеЗаполнено(Форма.Объект.Ссылка);
	
	ИменаЭлементов = Новый Массив;
	ИменаЭлементов.Добавить("Номер");
	ИменаЭлементов.Добавить("Дата");
	ИменаЭлементов.Добавить("НомерИсправленияПриИсправлении");
	ИменаЭлементов.Добавить("ДатаПриИсправлении");
	ИменаЭлементов.Добавить("СчетФактураОснование");
	ИменаЭлементов.Добавить("Исправление");
	ИменаЭлементов.Добавить("Валюта");
	ИменаЭлементов.Добавить("КодВидаОперации");
	ИменаЭлементов.Добавить("СтрокаПлатежноРасчетныеДокументы");

	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, ИменаЭлементов, "ТолькоПросмотр", Форма.Выставлен И НЕ ЭтоНовый);
	
	Элементы.ГруппаНомерДата.Видимость = Не Форма.Объект.Исправление;
	Элементы.ГруппаНомерДатаПриИсправлении.Видимость = Форма.Объект.Исправление;
	
	ИменаЭлементов = Новый Массив;
	ИменаЭлементов.Добавить("ВыставленВЭлектронномВиде");
	ИменаЭлементов.Добавить("ДатаВыставления");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, ИменаЭлементов, "Доступность", Форма.Выставлен);
	
	ИменаЭлементов = Новый Массив;
	ИменаЭлементов.Добавить("СчетФактураОснование");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, ИменаЭлементов, "Доступность", Объект.Исправление);
	
	ИменаЭлементов = Новый Массив;
	ИменаЭлементов.Добавить("Организация");
	ИменаЭлементов.Добавить("Комиссионер");
	ИменаЭлементов.Добавить("ДокументОснование");
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, 
	                                                                ИменаЭлементов, 
	                                                                "ТолькоПросмотр", 
	                                                                Объект.Исправление Или (Форма.Выставлен И НЕ ЭтоНовый));
	
	Для Каждого Строка Из Форма.Объект.Покупатели Цикл
	
		Строка.ТолькоПросмотрИННПокупателя = Форма.Выставлен
		                                     Или Не ЗначениеЗаполнено(Строка.Покупатель)
		                                     Или ТипЗнч(Строка.Покупатель) <> Тип("СправочникСсылка.Контрагенты");
		
		Строка.ТолькоПросмотрКПППокупателя = Форма.Выставлен
		                                     Или Не ЗначениеЗаполнено(Строка.Покупатель)
		                                     Или ТипЗнч(Строка.Покупатель) <> Тип("СправочникСсылка.Контрагенты")
		                                     Или НЕ Строка.ЮрЛицо;
		
		Строка.КППНеТребуется              = ЗначениеЗаполнено(Строка.Покупатель)
		                                     И ТипЗнч(Строка.Покупатель) = Тип("СправочникСсылка.Контрагенты")
		                                     И НЕ Строка.ЮрЛицо;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьПлатежноРасчетныеДокументыВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ПлатежноРасчетныеДокументы.Выгрузить());
	
КонецФункции

&НаСервере
Процедура ПолучитьПлатежноРасчетныеДокументыИзХранилища(НовыйАдресВХранилище)
	
	Если ЗначениеЗаполнено(НовыйАдресВХранилище) Тогда
		Объект.ПлатежноРасчетныеДокументы.Загрузить(ПолучитьИзВременногоХранилища(НовыйАдресВХранилище));
		СформироватьСтрокуРасчетноПлатежныхДокументов();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСтрокуРасчетноПлатежныхДокументов()
	
	СтрокаНомеровИДата = "";
	Для Каждого СтрокаТаблицы Из Объект.ПлатежноРасчетныеДокументы Цикл
		СтрокаНомеровИДата = СтрокаНомеровИДата + ?(ПустаяСтрока(СтрокаНомеровИДата), "", ", ")
							 + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = '%1 от %2'"),
									СтрокаТаблицы.НомерПлатежноРасчетногоДокумента,
									Формат(СтрокаТаблицы.ДатаПлатежноРасчетногоДокумента, "ДЛФ=D"));
	КонецЦикла; 
		
	Если Объект.СтрокаПлатежноРасчетныеДокументы <> СтрокаНомеровИДата Тогда
		Объект.СтрокаПлатежноРасчетныеДокументы = СтрокаНомеровИДата;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.СтрокаПлатежноРасчетныеДокументы) Тогда
		СтрокаПлатежноРасчетныеДокументы = Объект.СтрокаПлатежноРасчетныеДокументы;
	Иначе
		СтрокаПлатежноРасчетныеДокументы = НСтр("ru='<отсутствуют>'"); 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыПодбораПокупателей()
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Объект.Покупатели.Выгрузить(), УникальныйИдентификатор);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОтчетКомиссионера",          Объект.ДокументОснование);
	ПараметрыФормы.Вставить("Дата",                       Объект.Дата);
	ПараметрыФормы.Вставить("АдресВоВременномХранилище",  АдресВоВременномХранилище);
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Процедура ПодборПокупателейЗавершение(АдресВоВременномХранилище, ДополнительныеПараметры) Экспорт
	
	Если АдресВоВременномХранилище = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РезультатПодбора = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Отбор = Новый Структура;
	Отбор.Вставить("Покупатель");
	Отбор.Вставить("НомерСчетаФактуры");
	
	Для каждого СтрокаРезультатаПодбора Из РезультатПодбора Цикл
		
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаРезультатаПодбора);
		РезультатПоиска = Объект.Покупатели.НайтиСтроки(Отбор);
		
		Если НЕ СтрокаРезультатаПодбора.Пометка И РезультатПоиска.Количество() <> 0 Тогда
			Для Каждого СтрокаКУдалению Из РезультатПоиска Цикл
				Объект.Покупатели.Удалить(СтрокаКУдалению);
			КонецЦикла;
		КонецЕсли;
		
		Если СтрокаРезультатаПодбора.Пометка И РезультатПоиска.Количество() = 0 Тогда
			Строка = Объект.Покупатели.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, СтрокаРезультатаПодбора)
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПокупателей(Контрагенты = Неопределено, ЗаполнятьИННКПП = Ложь)
	
	Если Контрагенты = Неопределено Тогда
		Контрагенты = Новый Массив;
		Для каждого Строка Из Объект.Покупатели Цикл
			Контрагенты.Добавить(Строка.Покупатель);
		КонецЦикла
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ИсторияКППКонтрагентов.Период) КАК Период,
	|	ИсторияКППКонтрагентов.Ссылка           КАК Ссылка
	|ПОМЕСТИТЬ ЗначенияКПП
	|ИЗ
	|	Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
	|ГДЕ
	|	ИсторияКППКонтрагентов.Ссылка  В (&Контрагенты)
	|	И ИсторияКППКонтрагентов.Период <= &ДатаСведений
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияКППКонтрагентов.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	ИсторияКППКонтрагентов.КПП    КАК КПП,
	|	ИсторияКППКонтрагентов.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ИсторическоеЗначениеКПП
	|ИЗ
	|	ЗначенияКПП КАК ЗначенияКПП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
	|		ПО ЗначенияКПП.Ссылка = ИсторияКППКонтрагентов.Ссылка
	|			И ЗначенияКПП.Период = ИсторияКППКонтрагентов.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|ВЫБРАТЬ
	|	Контрагенты.Ссылка                                     КАК Ссылка,
	|	ЕСТЬNULL(ИсторическоеЗначениеКПП.КПП, Контрагенты.КПП) КАК КПППокупателя,
	|	Контрагенты.ИНН                                        КАК ИННПокупателя,
	|	ВЫБОР
	|		КОГДА Контрагенты.ОбособленноеПодразделение 
	|				И Контрагенты.ГоловнойКонтрагент = &ПустойКонтрагент 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                                 КАК НеЗаполненГоловнойКонтрагент,
	|	ВЫБОР
	|		КОГДА Контрагенты.ЮрФизЛицо = &ЮрЛицо
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ                                                 КАК ЮрЛицо
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|	ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеКПП КАК ИсторическоеЗначениеКПП
	|		ПО ИсторическоеЗначениеКПП.Ссылка = Контрагенты.Ссылка
	|ГДЕ
	|	Контрагенты.Ссылка В (&Контрагенты)
	|";
	
	Запрос.УстановитьПараметр("Контрагенты",      Контрагенты);
	Запрос.УстановитьПараметр("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	Запрос.УстановитьПараметр("ЮрЛицо",           Перечисления.ЮрФизЛицо.ЮрЛицо);
	Запрос.УстановитьПараметр("ДатаСведений",     Объект.Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Отбор = Новый Структура("Покупатель");
	
	СтрокаИсключений = ?(ЗаполнятьИННКПП, "", "КПППокупателя, ИННПокупателя");
	
	Пока Выборка.Следующий() Цикл
		
		Отбор.Покупатель = Выборка.Ссылка;
		Строки = Объект.Покупатели.НайтиСтроки(Отбор);
		Для каждого Строка Из Строки Цикл
			ЗаполнитьЗначенияСвойств(Строка, Выборка, , СтрокаИсключений);
		КонецЦикла;
		
	КонецЦикла;
	
	Видимость = Ложь;
	Для каждого Строка Из Объект.Покупатели Цикл
		
		Если Строка.НеЗаполненГоловнойКонтрагент Тогда
			Видимость = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.Покупатель)
			Или ТипЗнч(Строка.Покупатель) = Тип("СправочникСсылка.Организации") Тогда
			
			Строка.ИННПокупателя = "";
			Строка.КПППокупателя = "";
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ГруппаНеЗаполненГоловнойКонтрагент.Видимость = Видимость;
	
КонецПроцедуры

&НаСервере
Процедура СчетФактураОснованиеПриИзмененииСервер()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьПоСчетуФактуреОснованию(ДокументОбъект.СчетФактураОснование);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораКПП(СписокВыбора, Контрагент, ДатаСведений)
	
	УчетНДСУТ.ЗаполнитьСписокВыбораКППСчетФактурыВыданные(СписокВыбора, Контрагент, ДатаСведений);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеВидаОперации(Форма)
	
	ТекущийКод = Форма.СписокКодовВидовОпераций.НайтиПоЗначению(Форма.Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		Форма.ПредставлениеВидаОперации = Сред(ТекущийКод.Представление, 4);
	Иначе
		Форма.ПредставлениеВидаОперации = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаполнениеОснованияВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Организация"".'"), , "Организация", "Объект", Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Комиссионер) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не заполнено поле ""Комиссионер"".'"), , "Комиссионер", "Объект", Отказ);
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

&НаСервере
Процедура ЗапролнитьЗависимыеОтДокументаОснованияРеквизитыФормы()
	
	ВалютаОснованияСчетаФактуры = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ВалютаОснованияСчетаФактуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "Валюта");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВозможностьПодбораПокупателейЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыФормы = ПараметрыПодбораПокупателей();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодборПокупателейЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.СчетФактураКомиссионеру.Форма.ФормаПодбораПокупателей", 
		ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовВидовОпераций()
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры,
		СписокКодовВидовОпераций,
		?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
		
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти
