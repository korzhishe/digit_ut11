﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ИспользоватьНесколькоВидовЦен = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен");
	НастроитьФормуПоПараметрам(Параметры);
	НастроитьПараметрыВыбораДокументаПродажи(Параметры);
	УстановитьВидимость(ЭтотОбъект);
	
	// Группа регл. сумм выводится на форму только когда включен регл. учет:
	Элементы.ГруппаРегл.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзДокументаПродажи
		И НЕ ЗначениеЗаполнено(ДокументПродажи) Тогда
		ПроверяемыеРеквизиты.Добавить("ДокументПродажи");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СпособОпределенияСебестоимостиВручнуюПриИзменении(Элемент)
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОпределенияСебестоимостиТекущийДокументПриИзменении(Элемент)
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОпределенияСебестоимостиДокументПродажиПриИзменении(Элемент)
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	ЗаполнитьСуммыПоВидуЦен();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗаполненияПриИзменении(Элемент)
	
	ЗаполнитьСуммыПоВидуЦен();

КонецПроцедуры

&НаКлиенте
Процедура СуммаУпрПриИзменении(Элемент)
	
	Если ТипНалогообложения <> ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС") Тогда
		СебестоимостьУпрБезНДС = СебестоимостьУпр;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОКЗакрыть(Команда)

	ОчиститьСообщения();
	Если ПроверитьЗаполнение() Тогда
		ПеренестиДанныеВДокумент();
	КонецЕсли;
		
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьПараметрыВыбораДокументаПродажи(Параметры)
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Организация", Параметры.Организация));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Партнер", Параметры.Партнер));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Контрагент", Параметры.Контрагент));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Договор", Параметры.Договор));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Соглашение", Параметры.Соглашение));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Статус", Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено));
	Элементы.ДокументПродажи.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимость(Форма)
	
	Если Форма.СпособОпределенияСебестоимости = ПредопределенноеЗначение("Перечисление.СпособыОпределенияСебестоимости.Вручную") Тогда
		Форма.Элементы.ГруппаСуммы.ТекущаяСтраница = Форма.Элементы.ГруппаВручнуюДанные;
	Иначе
		Форма.Элементы.ГруппаСуммы.ТекущаяСтраница = Форма.Элементы.ГруппаВручнуюПустая;
	КонецЕсли;
	Если Форма.СпособОпределенияСебестоимости = ПредопределенноеЗначение("Перечисление.СпособыОпределенияСебестоимости.ИзДокументаПродажи") Тогда
		Форма.Элементы.ГруппаСтраницыДокументПродажи.ТекущаяСтраница = Форма.Элементы.СтраницаДокументПродажи;
	Иначе
		Форма.Элементы.ГруппаСтраницыДокументПродажи.ТекущаяСтраница = Форма.Элементы.СтраницаДокументПродажиПустая;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСуммыПоВидуЦен()
	
	Если НЕ ЗначениеЗаполнено(ВидЦены) ИЛИ НЕ ЗначениеЗаполнено(ДатаЗаполнения) Тогда
		Элементы.НадписьНетЦеныНаДату.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	СтруктураОтбораПоВидуЦен = Новый Структура;
	СтруктураОтбораПоВидуЦен.Вставить("Ссылка", ВидЦены);
	ЦенаВключаетНДС = Справочники.ВидыЦен.ВидЦеныИПризнакЦенаВключаетНДСПоУмолчанию(СтруктураОтбораПоВидуЦен).ЦенаВключаетНДС;

	СтруктураПараметровОтбора = Новый Структура;
	СтруктураПараметровОтбора.Вставить("Валюта", ВалютаДокумента);
	СтруктураПараметровОтбора.Вставить("Дата", ДатаЗаполнения);
	СтруктураПараметровОтбора.Вставить("ВидЦены", ВидЦены);
	СтруктураПараметровОтбора.Вставить("Номенклатура", Номенклатура);
	СтруктураПараметровОтбора.Вставить("Характеристика", Характеристика);
	СтруктураПараметровОтбора.Вставить("Упаковка", Упаковка);
	Цена = ПродажиСервер.ПолучитьЦенуПоОтбору(СтруктураПараметровОтбора);
	Себестоимость = Цена * КоличествоУпаковок
			* ?(ВалютаДокумента = ВалютаУправленческогоУчета,
				1,
				РаботаСКурсамивалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаДокумента,
					ВалютаУправленческогоУчета,
					ДатаЗаполнения)
				);
	ТекПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(СтавкаНДС);
	СуммаНДС = ЦенообразованиеКлиентСервер.РассчитатьСуммуНДС(Себестоимость, ТекПроцентНДС, ЦенаВключаетНДС);
	Если ЦенаВключаетНДС Тогда
		СебестоимостьУпр = Себестоимость;
		СебестоимостьУпрБезНДС = СебестоимостьУпр - СуммаНДС;
	Иначе
		СебестоимостьУпрБезНДС = Себестоимость;
		СебестоимостьУпр = СебестоимостьУпрБезНДС + СуммаНДС;
	КонецЕсли;
	
	
	Элементы.НадписьНетЦеныНаДату.Видимость = (Цена = 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборДокументаРеализацииЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		ДокументПродажи = РезультатВыбора;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоПараметрам(Параметры)
	
	Организация = Параметры.Организация;
	Партнер = Параметры.Партнер;
	Конрагент = Параметры.Контрагент;
	Договор = Параметры.Договор;
	Соглашение = Параметры.Соглашение;
	ПоказыватьРеализации = Параметры.ПоказыватьРеализации;
	ВидЦены = Параметры.ВидЦеныСебестоимости;
	ДатаЗаполнения = Параметры.ДатаЗаполненияСебестоимостиПоВидуЦены;
	СпособОпределенияСебестоимости = Параметры.СпособОпределенияСебестоимости;
	КоличествоУпаковок = Параметры.КоличествоУпаковок;
	Упаковка = Параметры.Упаковка;
	ТипНалогообложения = Параметры.ТипНалогообложения;
	ДокументПродажи = Параметры.ДокументПродажи;
	Номенклатура = Параметры.Номенклатура;
	Характеристика = Параметры.Характеристика;
	СтавкаНДС = Параметры.СтавкаНДС;
	ВалютаДокумента = Параметры.ВалютаДокумента;
	СебестоимостьУпр = Параметры.Себестоимость;
	СебестоимостьУпрБезНДС = Параметры.СебестоимостьБезНДС;
	
	
	МассивТипов = Новый Массив;
	Если ПоказыватьРеализации Тогда
		МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	Иначе
		МассивТипов.Добавить(Тип("ДокументСсылка.ОтчетОРозничныхПродажах"));
	КонецЕсли;
	Элементы.ДокументПродажи.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"ГруппаВидЦен",
		"Видимость",
		ИспользоватьНесколькоВидовЦен);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"УпрБезНДС",
		"Видимость",
		ТипНалогообложения = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС);
	Если ТипНалогообложения = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС Тогда
		ТекстЗаголовкаУпр = НСтр("ru = 'Упр. учет с НДС (%1):'");
		ТекстЗаголовкаУпрБезНДС = НСтр("ru = 'Упр. учет без НДС (%1):'");
		Элементы.НадписьУпрБезНДС.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаУпрБезНДС, ВалютаУправленческогоУчета);
	Иначе
		ТекстЗаголовкаУпр = НСтр("ru = 'Упр. учет (%1):'");
	КонецЕсли;
	Элементы.НадписьУпр.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаУпр, ВалютаУправленческогоУчета);
	
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие и Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Перенести изменения в документ?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Если ПроверитьЗаполнение() Тогда
			ВыполняетсяЗакрытие = Истина;
			ПеренестиДанныеВДокумент();
		КонецЕсли;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиДанныеВДокумент()

	Модифицированность = Ложь;
	
		ПараметрыЗакрытия = Новый Структура;
		ПараметрыЗакрытия.Вставить("СпособОпределенияСебестоимости", СпособОпределенияСебестоимости);
		Если СпособОпределенияСебестоимости = ПредопределенноеЗначение("Перечисление.СпособыОпределенияСебестоимости.ИзДокументаПродажи") Тогда
			ПараметрыЗакрытия.Вставить("ДокументРеализации", ДокументПродажи);
		Иначе
			ПараметрыЗакрытия.Вставить("ДокументРеализации", Неопределено);
		КонецЕсли;
		Если СпособОпределенияСебестоимости = ПредопределенноеЗначение("Перечисление.СпособыОпределенияСебестоимости.Вручную") Тогда
			ПараметрыЗакрытия.Вставить("ВидЦеныСебестоимости", ВидЦены);
			ПараметрыЗакрытия.Вставить("ДатаЗаполненияСебестоимостиПоВидуЦены", ДатаЗаполнения);
			ПараметрыЗакрытия.Вставить("Себестоимость", СебестоимостьУпр);
			ПараметрыЗакрытия.Вставить("СебестоимостьБезНДС", СебестоимостьУпрБезНДС);
		Иначе
			ПараметрыЗакрытия.Вставить("ВидЦеныСебестоимости", Неопределено);
			ПараметрыЗакрытия.Вставить("ДатаЗаполненияСебестоимостиПоВидуЦены", Дата(1, 1, 1));
			ПараметрыЗакрытия.Вставить("Себестоимость", 0);
			ПараметрыЗакрытия.Вставить("СебестоимостьБезНДС", 0);
		КонецЕсли;
		Закрыть(ПараметрыЗакрытия);
						
КонецПроцедуры

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;



