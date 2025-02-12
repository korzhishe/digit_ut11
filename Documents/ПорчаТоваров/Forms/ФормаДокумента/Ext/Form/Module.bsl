﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик механизма "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// Обработчик механизма "Назначения"
	Справочники.Назначения.ФормаДокументаПриСозданииНаСервере(ЭтаФорма);
	
	ЗаполнитьПоДаннымВХранилище();

	ЗаполнитьСписокПричинПорчи();
	
	Элементы.ТоварыНоменклатура.ТолькоПросмотр                = Параметры.ЗапретитьИзменятьТовары;
	Элементы.ТоварыХарактеристика.ТолькоПросмотр              = Параметры.ЗапретитьИзменятьТовары;
	Элементы.ТоварыНоменклатураОприходование.ТолькоПросмотр   = Параметры.ЗапретитьИзменятьТовары;
	Элементы.ТоварыКоличество.ТолькоПросмотр                  = Параметры.ЗапретитьИзменятьТовары;
	Элементы.Склад.ТолькоПросмотр                             = Параметры.ЗапретитьИзменятьТовары;
	Элементы.Организация.ТолькоПросмотр                       = Параметры.ЗапретитьИзменятьТовары;
	Элементы.Заполнить.Доступность                            = Не Параметры.ЗапретитьИзменятьТовары;
	Элементы.Товары.ИзменятьСоставСтрок                       = Не Параметры.ЗапретитьИзменятьТовары;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	Если ЭтоАдресВременногоХранилища(Параметры.АдресДанныхВХранилище)
		Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	УстановитьВидимостьДляВидЦены();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ОбновитьКонтрольЗаполненияАналитикиРасходов(ЭтаФорма, Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	Если ИсточникВыбора.ИмяФормы = "Справочник.ВидыЗапасов.Форма.ФормаВводаВидовЗапасов" Тогда
		
		ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение);
		Объект.ВидыЗапасовУказаныВручную = ИсточникВыбора.ВидыЗапасовУказаныВручную;
		Модифицированность = Истина;
		
	ИначеЕсли НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);

	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.Назначения.Форма.ФормаВыбора" Тогда	

		Элементы.Товары.ТекущиеДанные.Назначение = ВыбранноеЗначение;	
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПорчаТоваров", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПриИзмененииСервер();
	ВалютаПриИзмененииКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	ФинансыКлиент.СтатьяРасходовПриИзменении(Объект, Элементы);
	СтатьяРасходовПриИзмененииСервер(КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриходоватьТоварыПоСебестоимостиСписанияПриИзменении(Элемент)
	
	ПриходоватьТоварыПоСебестоимостиСписанияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	Если Не Объект.ПриходоватьТоварыПоСебестоимостиСписания
		И ЗначениеЗаполнено(Объект.ВидЦены)
		И Объект.Товары.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Заполнить цены по виду цен ""%ВидЦены%""?'");	
		
		ТекстВопроса = СтрЗаменить(ТекстВопроса,"%ВидЦены%", Объект.ВидЦены);
		
		Ответ = Неопределено;

		
		ПоказатьВопрос(Новый ОписаниеОповещения("ВидЦеныПриИзмененииЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЦеныРассчитаны = ЗаполнитьЦеныПоВидуЦенСервер();
		ПродажиКлиент.ОповеститьОбОкончанииЗаполненияЦенПоВидуЦен(ЦеныРассчитаны, Объект.ВидЦены);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ПорчаТоваров.Форма.ФормаДокумента.Элемент.Валюта.ПриИзменении");
	
	ВалютаПриИзмененииКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникИнформацииОЦенахДляПечатиПриИзменении(Элемент)
	
	 	ИсточникИнформацииОЦенахДляПечатиПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если АналитикаРасходовЗаказРеализация Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходов = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.НоменклатураОприходование) Тогда
		ЕстьГрадация = ЕстьГрадацияКачества(ТекущаяСтрока.Номенклатура, ТекущаяСтрока.НоменклатураОприходование);
		Если Не ЕстьГрадация Тогда
			ТекущаяСтрока.НоменклатураОприходование = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
			ТекущаяСтрока.ХарактеристикаОприходование = ПредопределенноеЗначение("Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка");
			ТекущаяСтрока.ХарактеристикиИспользуютсяОприходование = Ложь;
		КонецЕсли;
	КонецЕсли;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура, НоменклатураОприходование", "Артикул", "АртикулОприходование"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));
	СтруктураДействий.Вставить("ПроверитьЗаполнитьНазначение");
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;

	СтруктураДействий.Вставить("ХарактеристикаПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));
	СтруктураДействий.Вставить("ПроверитьЗаполнитьНазначение");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураОприходованиеПриИзменении(Элемент)
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", ТекущиеДанные.НоменклатураОприходование);
	ТекущаяСтрока.Вставить("Характеристика", ТекущиеДанные.ХарактеристикаОприходование);
	ТекущаяСтрока.Вставить("ХарактеристикиИспользуются", ТекущиеДанные.ХарактеристикиИспользуютсяОприходование);
	ТекущаяСтрока.Вставить("Цена", ТекущиеДанные.Цена);
	ТекущаяСтрока.Вставить("ВидЦены", Объект.ВидЦены);
	ТекущаяСтрока.Вставить("Упаковка", ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка"));
	ТекущаяСтрока.Вставить("Артикул", ТекущиеДанные.Артикул);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущиеДанные.ХарактеристикаОприходование);
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	
	Если Не Объект.ПриходоватьТоварыПоСебестоимостиСписания Тогда
		СтруктураДействий.Вставить("ЗаполнитьЦенуПродажи", Новый Структура("Дата, Валюта", Объект.Дата, Объект.Валюта));
	КонецЕсли;

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

	ТекущиеДанные.ХарактеристикаОприходование = ТекущаяСтрока.Характеристика;
	ТекущиеДанные.ХарактеристикиИспользуютсяОприходование = ТекущаяСтрока.ХарактеристикиИспользуются;
	ТекущиеДанные.АртикулОприходование = ТекущаяСтрока.Артикул;
	ТекущиеДанные.Цена = ТекущаяСтрока.Цена;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаОприходованиеПриИзменении(Элемент)
	Если Объект.ПриходоватьТоварыПоСебестоимостиСписания
		Или Не ЗначениеЗаполнено(Объект.ВидЦены) Тогда
		Возврат;	
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", ТекущиеДанные.НоменклатураОприходование);
	ТекущаяСтрока.Вставить("Характеристика", ТекущиеДанные.ХарактеристикаОприходование);
	ТекущаяСтрока.Вставить("ХарактеристикиИспользуются", ТекущиеДанные.ХарактеристикиИспользуютсяОприходование);
	ТекущаяСтрока.Вставить("Цена", ТекущиеДанные.Цена);
	ТекущаяСтрока.Вставить("ВидЦены", Объект.ВидЦены);
	ТекущаяСтрока.Вставить("Упаковка", ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка"));

	СтруктураДействий = Новый Структура;
	Если Не Объект.ПриходоватьТоварыПоСебестоимостиСписания Тогда
		СтруктураДействий.Вставить("ЗаполнитьЦенуПродажи", Новый Структура("Дата, Валюта", Объект.Дата, Объект.Валюта));
	КонецЕсли;

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

	ТекущиеДанные.Цена = ТекущаяСтрока.Цена;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураОприходованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Выберите строку, для которой Вы хотите изменить качество'"));
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ТекущаяСтрока = Новый Структура;
	ТекущаяСтрока.Вставить("Номенклатура", ТекущиеДанные.Номенклатура);
	ТекущаяСтрока.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	ТекущаяСтрока.Вставить("ХарактеристикиИспользуются", ТекущиеДанные.ХарактеристикиИспользуются);
	ТекущаяСтрока.Вставить("НоменклатураОприходование");
	ТекущаяСтрока.Вставить("ХарактеристикаОприходование");
	ТекущаяСтрока.Вставить("ХарактеристикиИспользуютсяОприходование");
	ТекущаяСтрока.Вставить("Цена", ТекущиеДанные.Цена);
	ТекущаяСтрока.Вставить("ВидЦены", Объект.ВидЦены);
	ТекущаяСтрока.Вставить("Упаковка", ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка"));
	ТекущаяСтрока.Вставить("Артикул", ТекущиеДанные.Артикул);
	ТекущаяСтрока.Вставить("АртикулОприходование", ТекущиеДанные.АртикулОприходование);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура, НоменклатураИсходногоКачества", "Артикул", "АртикулОприходование"));
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущиеДанные.Характеристика);
	Если ЗначениеЗаполнено(ТекущиеДанные.Характеристика) Тогда
		СтруктураДействий.Вставить("ЗаполнитьХарактеристикуНекачественногоТовара", ТекущиеДанные.Характеристика);
	КонецЕсли;
	Если Не Объект.ПриходоватьТоварыПоСебестоимостиСписания Тогда
		СтруктураДействий.Вставить("ЗаполнитьЦенуПродажи", Новый Структура("Дата, Валюта", Объект.Дата, Объект.Валюта));
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ТоварыНоменклатураОприходованиеНачалоВыбораЗавершение", 
		ЭтотОбъект, Новый Структура("ТекущиеДанные", ТекущиеДанные));
	СкладыКлиент.ИзменитьКачество(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураОприходованиеНачалоВыбораЗавершение(ТекущаяСтрока, ДополнительныеПараметры) Экспорт 
	
	ЗаполнитьЗначенияСвойств(ДополнительныеПараметры.ТекущиеДанные, ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = Элементы.Товары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНазначениеПриИзменении(Элемент)
	Если Элементы.Товары.ТекущиеДанные <> Неопределено 
		И Не ЗначениеЗаполнено(Элементы.Товары.ТекущиеДанные.Назначение)Тогда
		Элементы.Товары.ТекущиеДанные.ПодНазначение = Ложь;	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)

	Если Объект.Товары.Количество() > 0 Тогда
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект), НСтр("ru = 'Табличная часть будет очищена и заполнена всеми товарами, по которым нужно оформить порчу. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;

	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЦеныПоВидуЦен(Команда)
	
	ОчиститьСообщения();
	
	Если Объект.Товары.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='В документе не заполнена таблица ""Товары"". Цены не могут быть заполнены'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Товары", "Объект");
		Возврат;
	КонецЕсли;
	
	ВидЦены = ЦенообразованиеВызовСервера.ВидЦеныПрайсЛист();
	
	Если ЗначениеЗаполнено(Объект.ВидЦены)
		Или ВидЦены <> Неопределено Тогда
		
		ВидЦены = ?(ЗначениеЗаполнено(Объект.ВидЦены), Объект.ВидЦены, ВидЦены);
		ЦеныРассчитаны = ЗаполнитьЦеныПоВидуЦенСервер(ВидЦены);
		
		ПродажиКлиент.ОповеститьОбОкончанииЗаполненияЦенПоВидуЦен(ЦеныРассчитаны, ВидЦены);
		
	Иначе
		ТекстСообщения = НСтр("ru = 'Не указан вид цены'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ВидЦены", "Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЦеныПоСебестоимости(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ПорчаТоваров.Форма.ФормаДокумента.Команда.ЗаполнитьЦеныПоСебестоимости");
	
	ОчиститьСообщения();
	
	Если Объект.Товары.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru='В документе не заполнена таблица ""Товары"". Цены не могут быть заполнены'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Товары", "Объект");		
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЦеныПоСебестоимостиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВидыЗапасов(Команда)
	
	Перем АдресТоваровВХранилище;
	Перем АдресВидовЗапасовВХранилище;
	
	ПоместитьТоварыИВидыЗапасовВХранилище(
		АдресТоваровВХранилище,
		АдресВидовЗапасовВХранилище);
	ФинансыКлиент.ОткрытьВидыЗапасов(
		Объект,
		АдресТоваровВХранилище,
		АдресВидовЗапасовВХранилище,
		ЭтаФорма,
		(Не ЭтаФорма.ТолькоПросмотр)); // РедактироватьВидыЗапасов
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры // РедактироватьСоставСвойств()

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ТаблицаФормы  = Элементы.Товары;
	ДанныеТаблицы = Объект.Товары;
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыРазбиенияСтроки = ОбщегоНазначенияУТКлиент.ПараметрыРазбиенияСтроки();
	ПараметрыРазбиенияСтроки.ИмяПоляКоличество = "Количество";
	ОбщегоНазначенияУТКлиент.РазбитьСтрокуТЧ(ДанныеТаблицы, ТаблицаФормы,, ПараметрыРазбиенияСтроки);
	
КонецПроцедуры // РазбитьСтроку()

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

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьКонтрольЗаполненияАналитикиРасходов(Форма, КэшированныеЗначения)
	
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовОбязательна, ЗаполнитьПризнакАналитикаРасходовЗаказРеализация");
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("СтатьяРасходов", Форма.Объект.СтатьяРасходов);
	ДанныеОбъекта.Вставить("АналитикаРасходовОбязательна", Форма.АналитикаРасходовОбязательна);
	ДанныеОбъекта.Вставить("АналитикаРасходовЗаказРеализация", Форма.АналитикаРасходовЗаказРеализация);
	
#Если Клиент Тогда
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ДанныеОбъекта, СтруктураДействий, КэшированныеЗначения);
#Иначе
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ДанныеОбъекта, СтруктураДействий, КэшированныеЗначения);
#КонецЕсли
	
	Форма.АналитикаРасходовОбязательна = ДанныеОбъекта.АналитикаРасходовОбязательна;
	Форма.АналитикаРасходовЗаказРеализация = ДанныеОбъекта.АналитикаРасходовЗаказРеализация;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);

	//

	ЗапасыСервер.УстановитьУсловноеОформлениеПодразделенияДляВидовЗапасов(ЭтаФорма);
	
	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "ТоварыХарактеристикаОприходование",
																		     "Объект.Товары.ХарактеристикиИспользуютсяОприходование");

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыЦена.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПриходоватьТоварыПоСебестоимостиСписания");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<приходуется по себестоимости>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары");

	// Видимость колонки "Под назначение"

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыПодНазначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Назначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	//
		
	НоменклатураСервер.УстановитьУсловноеОформлениеНазначенияНоменклатуры(ЭтаФорма);

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СкладПриИзмененииСервер()
	
	Объект.ИсточникИнформацииОЦенахДляПечати = Справочники.Склады.ИсточникИнформацииОЦенахДляПечати(Объект.Склад);
	Объект.Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(
		Справочники.ВидыЦен.ПолучитьРеквизитыВидаЦены(
			Справочники.Склады.УчетныйВидЦены(Объект.Склад)).ВалютаЦены);
	ИсточникИнформацииОЦенахДляПечатиПриИзмененииСервер();
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(
		Объект,
		Документы.ПорчаТоваров));
																											
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Склад));
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзмененииКлиент()
	
	Если ЦенообразованиеКлиент.НеобходимПересчетВВалюту(Объект, ВалютаДокумента) Тогда
		ВалютаПриИзмененииСервер();
		ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ВалютаДокумента, Объект.Валюта);
	КонецЕсли;
	
	ВалютаДокумента = Объект.Валюта;
	
КонецПроцедуры

&НаСервере
Процедура ВалютаПриИзмененииСервер()
	
	СтараяВалюта                = ВалютаДокумента;
	НоваяВалюта                 = Объект.Валюта;
	ДатаДокумента               = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
	СтруктураКурсовСтаройВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(СтараяВалюта, ДатаДокумента);
	СтруктураКурсовНовойВалюты  = РаботаСКурсамиВалют.ПолучитьКурсВалюты(НоваяВалюта,  ДатаДокумента);
	
	// Пересчитаем цену
	Ценообразование.ПересчитатьСуммыВВалютуТовары(
		Объект,
		СтараяВалюта,
		НоваяВалюта,
		СтруктураКурсовСтаройВалюты,
		СтруктураКурсовНовойВалюты,
		Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ИсточникИнформацииОЦенахДляПечатиПриИзмененииСервер()
	
	УстановитьЗначениеДляВидЦены(Объект.ИсточникИнформацииОЦенахДляПечати);
	УстановитьВидимостьДляВидЦены();
	
КонецПроцедуры

&НаСервере
Процедура ПриходоватьТоварыПоСебестоимостиСписанияПриИзмененииСервер()
	
	ПриходоватьТоварыПоСебестоимостиСписания = Объект.ПриходоватьТоварыПоСебестоимостиСписания;
	
	Элементы.АналитикаРасходов.Доступность = Не ПриходоватьТоварыПоСебестоимостиСписания;
	Элементы.СтатьяРасходов.Доступность    = Не ПриходоватьТоварыПоСебестоимостиСписания;
	Элементы.ЗаполнитьЦены.Доступность = Не ПриходоватьТоварыПоСебестоимостиСписания;
	
	Если ПриходоватьТоварыПоСебестоимостиСписания Тогда
		Объект.АналитикаРасходов = Неопределено;
		Объект.СтатьяРасходов    = Неопределено;
		ОчиститьЦены();
	КонецЕсли;
	
	УстановитьВидимостьДляВидЦены();
		
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер(КэшированныеЗначения)
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
		Объект,
		Объект.СтатьяРасходов,
		Объект.АналитикаРасходов);
	
	ОбновитьКонтрольЗаполненияАналитикиРасходов(ЭтаФорма, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	АктуализироватьВидДеятельностиНДС(Истина);
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ОтветственныеЛицаСервер.ПриИзмененииСвязанныхРеквизитовДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ЦенообразованиеИСкидки

&НаСервере
Функция ЗаполнитьЦеныПоВидуЦенСервер(ВидЦены = Неопределено)
	
	Если ВидЦены = Неопределено Тогда
		ВидЦены = Объект.ВидЦены;
	КонецЕсли;
	
	КолонкиПоЗначению = Новый Структура("Упаковка", Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
	ДругиеИменаКолонок = Новый Структура("НоменклатураОприходование, ХарактеристикаОприходование", "Номенклатура", "Характеристика");
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Дата", Объект.Дата);
	ПараметрыЗаполнения.Вставить("Валюта", Объект.Валюта);
	ПараметрыЗаполнения.Вставить("ВидЦены", ВидЦены);
	ПараметрыЗаполнения.Вставить("КолонкиПоЗначению", КолонкиПоЗначению);
	ПараметрыЗаполнения.Вставить("ДругиеИменаКолонок", ДругиеИменаКолонок);
	
	Возврат ПродажиСервер.ЗаполнитьЦены(
		Объект.Товары, // Табличная часть
		 , // Выделенные строки (заполнять во всех строках)
		ПараметрыЗаполнения);
	
КонецФункции

&НаСервере
Функция ЗаполнитьЦеныПоСебестоимостиСервер()
	
	ЗапросПредварительныхДанных = Новый Запрос;
	ЗапросПредварительныхДанных.Текст =  
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РасчетСебестоимостиТоваровОрганизации.Ссылка) КАК Количество
	|ИЗ
	|	Документ.РасчетСебестоимостиТоваров.Организации КАК РасчетСебестоимостиТоваровОрганизации
	|ГДЕ
	|	РасчетСебестоимостиТоваровОрганизации.Ссылка.Проведен
	|	И РасчетСебестоимостиТоваровОрганизации.Организация = &Организация";
	
	ЗапросПредварительныхДанных.УстановитьПараметр("Организация", Объект.Организация);
	ПредварительныеДанные = ЗапросПредварительныхДанных.Выполнить().Выбрать();
	
	Пока ПредварительныеДанные.Следующий() Цикл
		Если ПредварительныеДанные.Количество = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не было произведено ни одного расчета себестоимости товаров по организации ""%Организация%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Организация%", Объект.Организация);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	ДругиеИменаКолонок = Новый Структура("Номенклатура, Характеристика", "Номенклатура", "Характеристика"); 
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Дата", Объект.Дата);
	ПараметрыЗаполнения.Вставить("Организация", Объект.Организация);
	ПараметрыЗаполнения.Вставить("Валюта", Объект.Валюта);
	ПараметрыЗаполнения.Вставить("Склад", Объект.Склад);
	ПараметрыЗаполнения.Вставить("ДругиеИменаКолонок", ДругиеИменаКолонок);
	
	Возврат ПродажиСервер.ЗаполнитьЦеныПоСебестоимости(
		Объект.Товары, // Табличная часть
		Неопределено, // Выделенные строки (заполнять во всех строках)
		ПараметрыЗаполнения);
	
КонецФункции

 &НаСервере
Процедура ОчиститьЦены()
	Для Каждого Строка Из Объект.Товары Цикл
		Строка.Цена = 0;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "")
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий,Текст)Тогда
		ТекстИсключения = НСтр("ru = 'Ошибка при попытке указать серии - в этом документе для указания серий не нужен серверный вызов.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(
		НоменклатураСервер.ПараметрыУказанияСерий(Объект,
			Документы.ПорчаТоваров));
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Объект.Склад));
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	Элементы.АналитикаРасходов.Доступность = Не Объект.ПриходоватьТоварыПоСебестоимостиСписания;
	Элементы.СтатьяРасходов.Доступность    = Не Объект.ПриходоватьТоварыПоСебестоимостиСписания;
	Элементы.ЗаполнитьЦены.Доступность = Не Объект.ПриходоватьТоварыПоСебестоимостиСписания;
	
	Элементы.ПересчетТоваров.Видимость = ЗначениеЗаполнено(Объект.ПересчетТоваров);
	
	АналитикаРасходовЗаказРеализация = 
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "АналитикаРасходовЗаказРеализация");
	
	ВалютаДокумента = Объект.Валюта;
	
	АктуализироватьВидДеятельностиНДС();
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьТоварыИВидыЗапасовВХранилище(АдресТоваровВХранилище, АдресВидовЗапасовВХранилище)
	
	ЗапасыСервер.ПоместитьТоварыИВидыЗапасовВХранилище(
		Объект.Товары,
		Объект.ВидыЗапасов,
		УникальныйИдентификатор,
		АдресТоваровВХранилище,
		АдресВидовЗапасовВХранилище);
		
КонецПроцедуры // ПоместитьТоварыИВидыЗапасовВХранилище()

&НаСервере
Процедура ПолучитьВидыЗапасовИзХранилища(АдресВидовЗапасовВХранилище)
	
	Объект.ВидыЗапасов.Загрузить(ПолучитьИзВременногоХранилища(АдресВидовЗапасовВХранилище));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()

	ВремОбъект = РеквизитФормыВЗначение("Объект");

	ВремОбъект.Товары.Очистить();
	
	ВремОбъект.ЗаполнитьТабличнуюЧастьТовары();
	
	ЗначениеВРеквизитФормы(ВремОбъект, "Объект");

	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	ЗаполнитьСписокПричинПорчи();
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура, НоменклатураОприходование", "ХарактеристикиИспользуются", "ХарактеристикиИспользуютсяОприходование"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура, НоменклатураОприходование", "Артикул", "АртикулОприходование"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
											
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары,ПараметрыЗаполненияРеквизитов);	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПричинПорчи()
	Запрос = Новый Запрос;
	Запрос.Текст =
	 "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 100
	 |	ПорчаТоваров.ПричинаПорчи КАК ПричинаПорчи,
	 |	ПорчаТоваров.Дата КАК ДатаДокумента
	 |ПОМЕСТИТЬ ПричиныПорчиТоваров
	 |ИЗ
	 |	Документ.ПорчаТоваров КАК ПорчаТоваров
	 |ГДЕ
	 |	ПорчаТоваров.Проведен
	 |	И ПорчаТоваров.ПричинаПорчи <> """"
	 |
	 |УПОРЯДОЧИТЬ ПО
	 |	ДатаДокумента УБЫВ
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 30
	 |	ПричиныПорчиТоваров.ПричинаПорчи
	 |ИЗ
	 |	ПричиныПорчиТоваров КАК ПричиныПорчиТоваров";
	 
	Результат = Запрос.Выполнить().Выгрузить();
	Элементы.ПричинаПорчи.СписокВыбора.ЗагрузитьЗначения(Результат.ВыгрузитьКолонку("ПричинаПорчи"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымВХранилище()
	
	Если Не ЭтоАдресВременногоХранилища(Параметры.АдресДанныхВХранилище) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(Параметры.АдресДанныхВХранилище);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.Дата = СтруктураДанных.Шапка.Дата;
		
		ВремОбъект = РеквизитФормыВЗначение("Объект");
		ВремОбъект.Заполнить(Неопределено);
		ЗначениеВРеквизитФормы(ВремОбъект, "Объект");
		
		ЗаполнитьЗначенияСвойств(Объект,СтруктураДанных.Шапка);
	КонецЕсли;	
	
	Для Каждого СтрТабл из СтруктураДанных.ТаблицаТовары Цикл
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрТабл);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
				
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьГрадацияКачества(ТоварИсходногоКачества, ТоварДругогоКачества)
	
	 Возврат РегистрыСведений.ТоварыДругогоКачества.ПроверитьНаличиеГрадации(ТоварИсходногоКачества, ТоварДругогоКачества);
	
КонецФункции

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДляВидЦены()
	
	Если Объект.ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости 
		И Объект.ПриходоватьТоварыПоСебестоимостиСписания Тогда
		Элементы.ВидЦены.Доступность = Ложь;
	Иначе 
		Элементы.ВидЦены.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеДляВидЦены(ИсточникИнформацииОЦенахДляПечати)
	
	Если ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен Тогда
		Объект.ВидЦены = Справочники.Склады.УчетныйВидЦены(Объект.Склад);
	ИначеЕсли ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости Тогда
		Объект.ВидЦены = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура АктуализироватьВидДеятельностиНДС(Проверять = Ложь) 
	
	Если Проверять Тогда
		
		УчетНДСУТ.ПроверитьКорректностьДеятельностиНДСПотребления(
			Объект.ВидДеятельностиНДС,
			Объект.Организация,
			Объект.Дата,
			Перечисления.ХозяйственныеОперации.ПорчаТоваров);
		
	КонецЕсли;
	
	УчетНДСУТ.ЗаполнитьСписокВыбораДеятельностиНДСПотребления(
			Элементы.ВидДеятельностиНДС,
			Объект.Организация,
			Объект.Дата,
			Перечисления.ХозяйственныеОперации.ПорчаТоваров);
	
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

#КонецОбласти

#КонецОбласти
