﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Элементы.Подразделение.Видимость = ИнтеграцияГИСМ.ИспользоватьПодразделения();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.МаркировкаТоваровГИСМ));
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.МаркировкаТоваровГИСМ));
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументПродажи.Форма.Форма" Тогда
		
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.ВидыЗапасов.Форма.ФормаВводаВидовЗапасов" Тогда
		
		ПолучитьВидыЗапасовИзХранилища(ВыбранноеЗначение);
		Объект.ВидыЗапасовУказаныВручную = ИсточникВыбора.ВидыЗапасовУказаныВручную;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МаркировкаТоваровГИСМУТ.ЗаполнитьСлужебныеРеквизитыТабличнойЧасти(Объект.Товары);
	
	ОбновитьСтатусГИСМ();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_МаркировкаТоваровГИСМ",Объект.Основание,Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// Неизвестные штрихкоды
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		КэшированныеЗначения.Штрихкоды.Очистить();
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ОбработатьШтрихкоды(ДанныеШтрихкодов);
		
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияГИСМ"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусГИСМФормахВДокументах)) Тогда
		
		ОбновитьСтатусГИСМ();
		
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура ОперацияМаркировкиПриИзменении(Элемент)
	
	ОперацияМаркировкиПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДатаПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеДеятельностиПриИзменении(Элемент)
	
	НаправлениеДеятельностиПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	ФинансыКлиент.СтатьяРасходовПриИзменении(Объект, Элементы);
	СтатьяРасходовПриИзмененииСервер();
	
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
	МаркировкаТоваровГИСМВызовСервераУТ.АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора,
		Текст,
		СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	МаркировкаТоваровГИСМВызовСервераУТ.АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора,
		Текст,
		СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Маркировка товаров ГИСМ была изменена. Записать?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("СтатусГИСМОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтотОбъект,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Маркировка товаров ГИСМ не записана. Записать?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусГИСМОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать();
	КонецЕсли;
	
	Если Не Модифицированность И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПередатьДанные" Тогда
		
		СтандартнаяОбработка = Ложь;
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаДанных"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	СкладПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМВидПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМРазмерПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСпособВыпускаВОборотПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КиЗГИСМСИндивидуализациейПриИзменении(Элемент)
	Если МаркировкаТоваровГИСМКлиент.ПроверитьЗаполнениеКатегорийКиЗ(Объект) Тогда
		КатегорияКиЗПриИзменении();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(
		Элемент,КэшированныеЗначения,ПараметрыУказанияСерий) Тогда
		
		ТекущаяСтрокаИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Копирование);
	
	Если НоваяСтрока И Не Копирование Тогда
		
		ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
		
		ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	НеобходимоОбновитьСтатусыСерий = НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(
		Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Истина);


	Если НеобходимоОбновитьСтатусыСерий Тогда

		ТоварыПослеУдаленияСервер(НеобходимоОбновитьСтатусыСерий, КэшированныеЗначения);
		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ИдентификаторСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураКиЗПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуКиЗПоВладельцу", ТекущаяСтрока.ХарактеристикаКиЗ);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("НоменклатураКиЗ", "ХарактеристикиКиЗИспользуются"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыGTINНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	СписокВыбораGTIN = МаркировкаТоваровГИСМВызовСервераПереопределяемый.МассивGTINМаркированногоТовара(ТекущаяСтрока.Номенклатура, ТекущаяСтрока.Характеристика);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораGTIN);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураКиЗНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	GTIN = ?(Объект.КиЗГИСМСИндивидуализацией, ТекущаяСтрока.GTIN, "");
	СписокВыбораКиЗ = МаркировкаТоваровГИСМВызовСервераПереопределяемый.ПолучитьМассивКиз(СписокНоменклатураКиЗ, GTIN);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СписокВыбораКиЗ);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКодТаможенногоОрганаПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыДатаРегистрацииДекларацииПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыРегистрационныйНомерДекларацииПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УказатьСерии(Команда)
	
	ОткрытьПодборСерий();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьТовары(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Склад",                                     Объект.Склад);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                    Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры",           Истина);
	ПараметрыФормы.Вставить("ОтборПоТипуНоменклатуры",                   Новый ФиксированныйМассив(НоменклатураКлиентСервер.ОтборПоТоваруМногооборотнойТаре(Ложь)));
	ПараметрыФормы.Вставить("Заголовок",                                 НСтр("ru = 'Подбор товаров'"));
	ПараметрыФормы.Вставить("Дата",                                      Объект.Дата);
	ПараметрыФормы.Вставить("Документ",                                  Объект.Ссылка);
	ПараметрыФормы.Вставить("НаправлениеДеятельности",                   Объект.НаправлениеДеятельности);
	ПараметрыФормы.Вставить("ОсобенностьУчета",                          ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПродукцияМаркируемаяДляГИСМ"));
	
	ОткрытьФорму("Обработка.ПодборТоваровВДокументПродажи.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);
	
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
		ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	Оповещение = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныхШтрихкода, ДополнительныеПараметры) Экспорт
	
	ОбработатьШтрихкоды(ДанныхШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		Новый ОписаниеОповещения("ЗагрузитьИзТСДЗавершение", ЭтотОбъект),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(Результат, Параметры) Экспорт
	
	Если Результат.Результат Тогда
		ОбработатьШтрихкоды(Результат.ТаблицаТоваров);
	Иначе
		МенеджерОборудованияКлиентПереопределяемый.СообщитьОбОшибке(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьОперацияИдентификации();
	
	ОбновитьСтатусГИСМ();
	
	УчетНДСПоФактИспользованию = МаркировкаТоваровГИСМУТ.ОбновитьУчетНДСПоФактическомуИспользованию(Объект.Организация,
		Объект.Склад,
		Объект.Дата);
	МаркировкаТоваровГИСМУТ.ЗаполнитьСлужебныеРеквизитыТабличнойЧасти(Объект.Товары);
	МаркировкаТоваровГИСМУТ.ПроверитьЧтоВсеСтатьиРаспределяются(Объект.СтатьяРасходов, ВсеСтатьиРаспределяются, УчетНДСПоФактИспользованию, ОперацияИдентификации);
	МаркировкаТоваровГИСМУТ.УправлениеДоступностью(ЭтаФорма);
	МаркировкаТоваровГИСМУТ.ОбновитьКонтрольЗаполненияАналитикиРасходов(Объект.СтатьяРасходов, Объект.АналитикаРасходов, АналитикаРасходовОбязательна);
	МаркировкаТоваровГИСМУТ.УстановитьПараметрыВыбораСтатьи(Элементы.СтатьяРасходов);
	
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьСпискиВыбораРеквизитовШапки(ЭтаФорма);
	МаркировкаТоваровГИСМПереопределяемый.ПолучитьКиЗДляЗаполнения(Объект,СписокНоменклатураКиЗ);
	
	АктуализироватьМаркировкаПодДеятельность();
	
	УстановитьКорректностьЗаполненияКлючевыхПолейТовары();
	
	ВидимостьДополнительныхРеквизитовТабличнойЧастиТовары();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКорректностьЗаполненияКлючевыхПолейТовары()

	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ);
	КонецЦикла;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьХотяБыОдноИзКлючевыхПолейЗаполнено(СтрокаТЧ)

	СтрокаТЧ.ХотяБыОдноИзКлючевыхПолейЗаполнено = (ЗначениеЗаполнено(СтрокаТЧ.КодТаможенногоОргана)
	                                              Или ЗначениеЗаполнено(СтрокаТЧ.ДатаРегистрацииДекларации)
	                                              Или ЗначениеЗаполнено(СтрокаТЧ.РегистрационныйНомерДекларации))
	                                              Или (Не ЗначениеЗаполнено(СтрокаТЧ.КодТаможенногоОргана)
	                                              И Не ЗначениеЗаполнено(СтрокаТЧ.ДатаРегистрацииДекларации)
	                                              И Не ЗначениеЗаполнено(СтрокаТЧ.РегистрационныйНомерДекларации));
	
КонецПроцедуры

#Область Серии

&НаСервере
Процедура ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий, КэшированныеЗначения)
	
	Действия = Новый Структура;
	Действия.Вставить("ОбновлятьКоличествоТоваровПриРегистрацииСерий", Истина);
	НоменклатураСервер.ОбработатьУказаниеСерий(Объект, ПараметрыУказанияСерий, ПараметрыФормыУказанияСерий, Действия, КэшированныеЗначения);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения)
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Объект,
				ПараметрыУказанияСерий, ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийСервер()
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий, ТекущиеДанныеИдентификатор, ЭтаФорма);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", ТекущиеДанные = Неопределено, ВыдаватьСообщения = Истина)
	
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий,Текст, ТекущиеДанные,,ВыдаватьСообщения)Тогда
		Если ТекущиеДанные = Неопределено Тогда
			ТекущиеДанныеИдентификатор = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
		Иначе
			ТекущиеДанныеИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		КонецЕсли;

		ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
		
		ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы,ПараметрыФормыУказанияСерий,ЭтаФорма,,,, Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение", ЭтотОбъект, Новый Структура("ПараметрыФормыУказанияСерий", ПараметрыФормыУказанияСерий)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийЗавершение(ЗначениеВозврата, ДополнительныеПараметры) Экспорт

	Если ЗначениеВозврата <> Неопределено Тогда
		ОбработатьУказаниеСерийСервер(ДополнительныеПараметры.ПараметрыФормыУказанияСерий, КэшированныеЗначения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийПриСканированииШтрихкодаНоменклатуры()
	
	Если ТекущиеДанныеИдентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Объект.Товары.НайтиПоИдентификатору(ТекущиеДанныеИдентификатор);
	ОткрытьПодборСерий(,ТекущиеДанные, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыПослеУдаленияСервер(НеобходимоОбновитьСтатусыСерий, КэшированныеЗначения)
	Если НеобходимоОбновитьСтатусыСерий Тогда
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Неопределено, КэшированныеЗначения);
	КонецЕсли;
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

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	МаркировкаТоваровГИСМУТ.ЗаполнитьМаркировкаПодДеятельность(Объект);
	УчетНДСПоФактИспользованию = МаркировкаТоваровГИСМУТ.ОбновитьУчетНДСПоФактическомуИспользованию(Объект.Организация,
		Объект.Склад,
		Объект.Дата);
	МаркировкаТоваровГИСМУТ.ПроверитьЧтоВсеСтатьиРаспределяются(Объект.СтатьяРасходов, ВсеСтатьиРаспределяются, УчетНДСПоФактИспользованию, ОперацияИдентификации);
	
КонецПроцедуры

&НаСервере
Процедура ОперацияМаркировкиПриИзмененииСервер() 
	
	ЗаполнитьОперацияИдентификации();
	МаркировкаТоваровГИСМУТ.УправлениеДоступностью(ЭтаФорма);
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.МаркировкаТоваровГИСМ));
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
	ВидимостьДополнительныхРеквизитовТабличнойЧастиТовары();
	
КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииСервер()
	МаркировкаТоваровГИСМУТ.ЗаполнитьМаркировкаПодДеятельность(Объект);
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.МаркировкаТоваровГИСМ));
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
КонецПроцедуры

&НаСервере
Процедура ТоварыНоменклатураПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьGTINВСтроке");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыХарактеристикаПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьGTINВСтроке");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура ТоварыGTINПриИзмененииСервер(ИдентификаторСтроки)
	
	ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ИдентификаторСтроки);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроке(ТекущаяСтрока, СписокНоменклатураКиЗ, Объект.КиЗГИСМСИндивидуализацией);
	
КонецПроцедуры

&НаСервере
Процедура НаправлениеДеятельностиПриИзмененииСервер()
	Объект.НазначениеКиЗ = НаправленияДеятельностиСервер.ТолкающееНазначение(Объект.НаправлениеДеятельности);
КонецПроцедуры

&НаСервере
Процедура КатегорияКиЗПриИзменении()
	МаркировкаТоваровГИСМПереопределяемый.КатегорияКиЗПриИзменении(Объект, СписокНоменклатураКиЗ);
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер()
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
		Объект,
		Объект.СтатьяРасходов,
		Объект.АналитикаРасходов);
	
	МаркировкаТоваровГИСМУТ.ОбновитьКонтрольЗаполненияАналитикиРасходов(Объект.СтатьяРасходов, Объект.АналитикаРасходов, АналитикаРасходовОбязательна);
	МаркировкаТоваровГИСМУТ.ПроверитьЧтоВсеСтатьиРаспределяются(Объект.СтатьяРасходов, ВсеСтатьиРаспределяются, УчетНДСПоФактИспользованию, ОперацияИдентификации);
	
	МаркировкаТоваровГИСМУТ.УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	АктуализироватьМаркировкаПодДеятельность(Истина);
	
КонецПроцедуры

&НаСервере
Процедура АктуализироватьМаркировкаПодДеятельность(Проверить = Ложь)
	
	Если Проверить Тогда 
		УчетНДСУТ.ПроверитьКорректностьДеятельностиНДСПотребления(
			Объект.МаркировкаДляДеятельности,
			Объект.Организация,
			Объект.Дата,
			Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию);
	КонецЕсли;
	
	УчетНДСУТ.ЗаполнитьСписокВыбораДеятельностиНДСПотребления(
		Элементы.МаркировкаДляДеятельности, 
		Объект.Организация,
		Объект.Дата,
		Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПоместитьТоварыИВидыЗапасовВХранилище(АдресТоваровВХранилище, АдресВидовЗапасовВХранилище)
	
	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("АналитикаУчетаНоменклатуры", Новый ОписаниеТипов("СправочникСсылка.КлючиАналитикиУчетаНоменклатуры"));
	ТаблицаТоваров.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТоваров.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаТоваров.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	
	Для каждого Стр Из Объект.Товары Цикл
		НоваяСтрока = ТаблицаТоваров.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр);
		НоваяСтрока.Номенклатура = Стр.НоменклатураКиЗ;
		НоваяСтрока.Характеристика = Стр.ХарактеристикаКиЗ;
	КонецЦикла;
	
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(
		ТаблицаТоваров,
		УникальныйИдентификатор);
	АдресВидовЗапасовВХранилище = ПоместитьВоВременноеХранилище(
		Объект.ВидыЗапасов.Выгрузить(,"АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, Количество"),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьВидыЗапасовИзХранилища(АдресВидовЗапасовВХранилище)
	
	Объект.ВидыЗапасов.Загрузить(ПолучитьИзВременногоХранилища(АдресВидовЗапасовВХранилище));
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение)

	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьGTINВСтроке");
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, "Номенклатура, Характеристика, ХарактеристикиИспользуются, Количество");
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	ЗаполнитьСтатусыУказанияСерийСервер();
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроках(Объект, СписокНоменклатураКиЗ);
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	СтруктураДействийСДобавленнымиСтроками = Новый Структура;
	СтруктураДействийСДобавленнымиСтроками.Вставить("ЗаполнитьGTINВСтроке");
	СтруктураДействийСИзмененнымиСтроками = Новый Структура;
	СтруктураДействий = ШтрихкодированиеНоменклатурыКлиент.ПараметрыОбработкиШтрихкодов();
	
	СтруктураДействий.Штрихкоды                              = ДанныеШтрихкодов;
	СтруктураДействий.СтруктураДействийСДобавленнымиСтроками = СтруктураДействийСДобавленнымиСтроками;
	СтруктураДействий.СтруктураДействийСИзмененнымиСтроками  = СтруктураДействийСИзмененнымиСтроками;
	СтруктураДействий.ПараметрыУказанияСерий                 = ПараметрыУказанияСерий;
	СтруктураДействий.ИзменятьКоличество                     = Истина;
	СтруктураДействий.ТолькоТовары                           = Истина;
	СтруктураДействий.НеИспользоватьУпаковки                 = Истина;
	СтруктураДействий.ИмяКолонкиКоличество                   = "Количество";
	
	ОбработатьШтрихкодыСервер(СтруктураДействий,КэшированныеЗначения);
	ШтрихкодированиеНоменклатурыКлиент.ОбработатьНеизвестныеШтрихкоды(СтруктураДействий,КэшированныеЗначения,ЭтаФорма);
	
	Если ШтрихкодированиеНоменклатурыКлиент.НужноОткрытьФормуУказанияСерийПослеОбработкиШтрихкодов(СтруктураДействий) Тогда
		
		ТекущиеДанныеИдентификатор = СтруктураДействий.МассивСтрокССериями[0];
		
		ПодключитьОбработчикОжидания("ОткрытьПодборСерийПриСканированииШтрихкодаНоменклатуры",0.1,Истина);
			
	КонецЕсли;
	
	Если СтруктураДействий.ТекущаяСтрока <> Неопределено Тогда
		Элементы.Товары.ТекущаяСтрока = СтруктураДействий.ТекущаяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыСервер(СтруктураПараметровДействия,КэшированныеЗначения)
	ШтрихкодированиеНоменклатурыСервер.ОбработатьШтрихкоды(ЭтаФорма, Объект,СтруктураПараметровДействия,КэшированныеЗначения);
	МаркировкаТоваровГИСМПереопределяемый.ЗаполнитьНоменклатуруКиЗВСтроках(Объект, СписокНоменклатураКиЗ);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОперацияИдентификации()
	ОперацияИдентификации = Объект.ОперацияМаркировки = ПредопределенноеЗначение("Перечисление.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированнойНаПроизводствеПродукции")
		ИЛИ Объект.ОперацияМаркировки = ПредопределенноеЗначение("Перечисление.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированныхПриИмпортеТоваров");
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОбновитьСтатусГИСМ()
	
	МаркировкаТоваровГИСМ.ОбновитьСтатусГИСМ(ЭтаФорма, "МаркировкаТоваровГИСМ");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатьяРасходов.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АналитикаРасходов.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НаправлениеДеятельности.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ОперацияМаркировки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	СписокОпераций = Новый СписокЗначений;
	СписокОпераций.Добавить(Перечисления.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированнойНаПроизводствеПродукции);
	СписокОпераций.Добавить(Перечисления.ОперацииМаркировкиГИСМ.ИдентификацияРанееМаркированныхПриИмпортеТоваров);
	ОтборЭлемента.ПравоеЗначение = СписокОпераций;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, "ТоварыХарактеристикаКиЗ", "Объект.Товары.ХарактеристикиКизИспользуются");
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МаркировкаДляДеятельности.Имя);
	
	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МаркировкаДляДеятельности");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УчетНДСПоФактИспользованию");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВсеСтатьиРаспределяются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.МаркировкаДляДеятельности.Имя);
	
	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.МаркировкаДляДеятельности");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УчетНДСПоФактИспользованию");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВсеСтатьиРаспределяются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКодТаможенногоОргана.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыДатаРегистрацииДекларации.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыРегистрационныйНомерДекларации.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ХотяБыОдноИзКлючевыхПолейЗаполнено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.КодТаможенногоОргана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ДатаРегистрацииДекларации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.РегистрационныйНомерДекларации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ВидимостьДополнительныхРеквизитовТабличнойЧастиТовары()
	
	ВидимостьРеквизитов = (Объект.ОперацияМаркировки = Перечисления.ОперацииМаркировкиГИСМ.МаркировкаОстатковНа12082016);
	
	Если ИнтеграцияГИСМ.ИспользоватьВозможностиВерсии("2.41") Тогда
		Элементы.ТоварыКодТаможенногоОргана.Видимость                 = ВидимостьРеквизитов;
		Элементы.ТоварыДатаРегистрацииДекларации.Видимость            = ВидимостьРеквизитов;
	Иначе
		Элементы.ТоварыКодТаможенногоОргана.Видимость                 = Ложь;
		Элементы.ТоварыДатаРегистрацииДекларации.Видимость            = Ложь;
	КонецЕсли;
	
	Элементы.ТоварыНомерТовараВДекларации.Видимость         = ВидимостьРеквизитов;
	Элементы.ТоварыРегистрационныйНомерДекларации.Видимость = ВидимостьРеквизитов;
	
КонецПроцедуры

#КонецОбласти