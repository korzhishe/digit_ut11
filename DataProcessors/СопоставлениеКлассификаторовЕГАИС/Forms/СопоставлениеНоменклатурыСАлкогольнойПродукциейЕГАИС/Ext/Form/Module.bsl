﻿&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(Параметры.НеСопоставленныеТовары) Тогда
		Объект.Товары.Загрузить(ПолучитьИзВременногоХранилища(Параметры.НеСопоставленныеТовары));
		ЗаполнитьСлужебныеРеквизиты();
	Иначе
		ВызватьИсключение НСтр("ru='Обработка предназначена только для контекстного открытия из форм конфигурации.'");
	КонецЕсли;
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.СоответствиеНоменклатурыЕГАИС) Тогда
		ТолькоПросмотр = Истина;
		Элементы.ЗаписатьИЗакрыть.Доступность                                  = Ложь;
		Элементы.ДекорацияНедостаточноПравНаИзменениеКлассификаторов.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизиты()
	
	ТаблицаНоменклатуры = Объект.Товары.Выгрузить(,"НомерСтроки, Номенклатура");
	
	ТаблицаНоменклатуры.Колонки.Добавить("Крепость"    , Новый ОписаниеТипов("Число"));
	ТаблицаНоменклатуры.Колонки.Добавить("ВидПродукции", Новый ОписаниеТипов("СправочникСсылка.ВидыАлкогольнойПродукции"));
	ТаблицаНоменклатуры.Колонки.Добавить("Объем"       , Новый ОписаниеТипов("Число"));
	
	ИнтеграцияЕГАИСПереопределяемый.ЗаполнитьРеквизитыАлкогольнойПродукции(ТаблицаНоменклатуры);
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		
		СтрокаТаблицы = ТаблицаНоменклатуры.Найти(СтрокаТЧ.НомерСтроки, "НомерСтроки");
		
		Если СтрокаТаблицы <> Неопределено Тогда
			
			СтрокаТЧ.Объем        = СтрокаТаблицы.Объем;
			СтрокаТЧ.Крепость     = СтрокаТаблицы.Крепость;
			СтрокаТЧ.ВидПродукции = СтрокаТаблицы.ВидПродукции;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка) 
	
	Если НЕ ПринудительноЗакрытьФорму И Модифицированность Тогда
		
		Отказ = Истина;
		
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Сохранить'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не сохранять'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Введенные данные не сохранены, сохранить?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			
			Отказ = Ложь;
			Если ПроверитьЗаполнение() Тогда
				ПроверитьЗаписатьДанные(Отказ);
				Если Не Отказ Тогда
					ПринудительноЗакрытьФорму = Истина;
					Закрыть();
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ТоварыПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ТоварыАлкогольнаяПродукция Тогда
		
		ЗаполнитьСпискиВыбораНоменклатурыЕГАИС(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ТоварыНоменклатура Тогда
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Элементы.Товары.ТекущиеДанные.Номенклатура);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Отмена(Команда)
	
	ПринудительноЗакрытьФорму = Истина;
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		Отказ = Ложь;
		ПроверитьЗаписатьДанные(Отказ);
		
		Если Не Отказ Тогда
			ПринудительноЗакрытьФорму = Истина;
			Закрыть(Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ПроверитьЗаписатьДанные();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	//
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискиВыбораНоменклатурыЕГАИС(ТекущаяСтрока)
	
	СписокВыбораНоменклатура = Элементы.ТоварыНоменклатура.СписокВыбора;
	СписокВыбораНоменклатура.Очистить();
	
	ПараметрыОтбора = Новый Структура("АлкогольнаяПродукция", ТекущаяСтрока.АлкогольнаяПродукция);
	
	НайденныеСтроки = НоменклатураДляВыбора.НайтиСтроки(ПараметрыОтбора);
	Для Каждого СтрокаТЧ Из НайденныеСтроки Цикл
		СписокВыбораНоменклатура.Добавить(СтрокаТЧ.Номенклатура);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаписатьДанные(Отказ = Ложь)
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		
		Если ЗначениеЗаполнено(СтрокаТЧ.АлкогольнаяПродукция)Тогда
			
			НаборЗаписей = РегистрыСведений.СоответствиеНоменклатурыЕГАИС.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Номенклатура.Установить(СтрокаТЧ.Номенклатура, Истина);
			НаборЗаписей.Отбор.Характеристика.Установить(СтрокаТЧ.Характеристика, Истина);
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Номенклатура         = СтрокаТЧ.Номенклатура;
			НоваяЗапись.Характеристика       = СтрокаТЧ.Характеристика;
			НоваяЗапись.АлкогольнаяПродукция = СтрокаТЧ.АлкогольнаяПродукция;
			НоваяЗапись.Порядок              = 1;
			
			Попытка
				НаборЗаписей.Записать();
			Исключение
				ТекстОшибки = НСтр("ru = 'Не удалось сопоставить номенклатуру %1'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1", СтрокаТЧ.АлкогольнаяПродукция);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки + Символы.ПС + ОписаниеОшибки());
				Отказ = Истина;
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыАлкогольнаяПродукцияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыОтбора = Новый Структура;
	Если ЗначениеЗаполнено(ТекущиеДанные.Объем) Тогда
		ПараметрыОтбора.Вставить("Объем", ТекущиеДанные.Объем);
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекущиеДанные.Крепость) Тогда
		ПараметрыОтбора.Вставить("Крепость", ТекущиеДанные.Крепость);
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекущиеДанные.Крепость) Тогда
		ПараметрыОтбора.Вставить("ВидПродукции", ТекущиеДанные.ВидПродукции);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ФормаВыбора", ПараметрыФормы, Элементы.ТоварыАлкогольнаяПродукция);
	
КонецПроцедуры

#КонецОбласти
