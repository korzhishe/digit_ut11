﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	
	СтруктураХозяйственныхОпераций	= Новый Структура;
	СтруктураХозяйственныхОпераций.Вставить("ПоступлениеОплатыОтКлиента", Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	СтруктураХозяйственныхОпераций.Вставить("ВозвратОплатыКлиенту", Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту);
	
	УправлениеЭлементамиФормы();
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	
	Если Не ПроверкаКонтрагентовВызовСервера.ИспользованиеПроверкиВозможно() Тогда
		Элементы.ЕстьОшибкиПроверкиКонтрагентов.Видимость = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ЗаявкиКОплате.Дата", Элементы.ЗаявкиКОплатеДата.Имя);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
	СохранитьРабочиеЗначенияПолейФормы(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_ОперацияПоПлатежнойКарте" Тогда
		ОбновитьДинамическиеСписки();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация           = Настройки.Получить("Организация");
	ЭквайринговыйТерминал = Настройки.Получить("ЭквайринговыйТерминал");
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьДинамическиеСписки();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭквайринговыйТерминалОтборПриИзменении(Элемент)
	
	ЭквайринговыйТерминалОтборПриИзмененииНаСервере()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратОплатыКлиенту()
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", СтруктураХозяйственныхОпераций.ВозвратОплатыКлиенту));
	ОткрытьФорму("Документ.ОперацияПоПлатежнойКарте.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ЭквайринговыйТерминалОтборПриИзмененииНаСервере()
	
	Организация = Справочники.ЭквайринговыеТерминалы.ПолучитьРеквизитыЭквайринговогоТерминала(ЭквайринговыйТерминал).Организация;
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОперацияПоПлатежнойКарте.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СчетНаОплатуКлиенту.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаявкаНаРасходованиеДенежныхСредств.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте") Тогда
			Элементы.Список.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаОперацииПоПлатежнойКарте;
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			Элементы.ЗаказыКОплате.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаЗаказыКОплате;
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
			Элементы.ЗаявкиКОплате.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаРаспоряженияНаОплату;
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.СчетНаОплатуКлиенту") Тогда
			Элементы.СчетаКОплате.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаСчетаКОплате;
		КонецЕсли;
		
		ПоказатьЗначение(Неопределено, Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов")
	   И Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаявкиНаРасходованиеДенежныхСредств") Тогда
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
		Элементы.ЗаказыКОплатеСуммаКОплате.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция МассивДинамическихСписков()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(Список);
	МассивСписков.Добавить(СчетаКОплате);
	МассивСписков.Добавить(ЗаказыКОплате);
	МассивСписков.Добавить(ЗаявкиКОплате);
	
	Возврат МассивСписков;

КонецФункции

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	Для Каждого ДинамическийСписок Из МассивДинамическихСписков() Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
		
		Если ДинамическийСписок.ОсновнаяТаблица = "Документ.ОперацияПоПлатежнойКарте" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, "ЭквайринговыйТерминал", ЭквайринговыйТерминал, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ЭквайринговыйТерминал));
		КонецЕсли;
	КонецЦикла;
	
	СохранитьРабочиеЗначенияПолейФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДинамическиеСписки()
	
	Элементы.СчетаКОплате.Обновить();
	Элементы.ЗаказыКОплате.Обновить();
	Элементы.ЗаявкиКОплате.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРабочиеЗначенияПолейФормы(СохранитьНеопределено = Ложь)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущаяОрганизация", "", ?(СохранитьНеопределено, Неопределено, Организация));
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущийЭквайринговыйТерминал", "", ?(СохранитьНеопределено, Неопределено, ЭквайринговыйТерминал));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
