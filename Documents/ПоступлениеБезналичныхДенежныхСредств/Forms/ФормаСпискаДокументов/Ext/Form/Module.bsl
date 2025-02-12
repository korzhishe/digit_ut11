﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РаспоряженияНаПоступлениеКонтрагент", "Видимость", Ложь);
	КонецЕсли;
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	УправлениеЭлементамиФормы();
	
	СписокОпераций = СписокОпераций();
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.ПодключитьОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
	СохранитьРабочиеЗначенияПолейФормы(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_ПоступлениеБезналичныхДенежныхСредств" Тогда
		ОбновитьДиначескиеСписки();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация    = Настройки.Получить("Организация");
	БанковскийСчет = Настройки.Получить("БанковскийСчет");
	ТолькоСчета    = Настройки.Получить("ТолькоСчетаНаОплату");
	УстановитьОтборДинамическихСписков();
	
	ПлательщикПредставление = Настройки.Получить("ПлательщикПредставление");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		РаспоряженияНаПоступление,
		"ПлательщикПредставление",
		ПлательщикПредставление,
		ВидСравненияКомпоновкиДанных.Содержит,
		,
		ЗначениеЗаполнено(ПлательщикПредставление));
	
	СписокОпераций = Настройки.Получить("СписокОпераций");
	ПредопределенныйСписокОпераций = СписокОпераций();
	Для Каждого ЭлементСписка Из ПредопределенныйСписокОпераций Цикл
		Если СписокОпераций.НайтиПоЗначению(ЭлементСписка.Значение) = Неопределено Тогда
			СписокОпераций = ПредопределенныйСписокОпераций;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	МассивВыбранныхОпераций = Новый Массив;
	ХозяйственнаяОперацияПредставление = "";
	Для Каждого ЭлементСписка Из СписокОпераций Цикл
		Если ЭлементСписка.Пометка Тогда
			МассивВыбранныхОпераций.Добавить(ЭлементСписка.Значение);
			ХозяйственнаяОперацияПредставление = ХозяйственнаяОперацияПредставление +
				?(ЗначениеЗаполнено(ХозяйственнаяОперацияПредставление), ", ", "") + ЭлементСписка.Значение;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		РаспоряженияНаПоступление,
		"ХозяйственнаяОперация",
		МассивВыбранныхОпераций,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		МассивВыбранныхОпераций.Количество() > 0);
		
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам") Тогда
		ТолькоСчетаНаОплату = Ложь;
		ТолькоСчета = Ложь;
	КонецЕсли;
	УстановитьОтборТолькоСчетаСервер(ТолькоСчета);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоступленияБезналичныхДенежныхСредствБанковскийСчетОтборПриИзменении(Элемент)
	
	БанковскийСчетОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияНаПоступлениеБанковскийСчетОтборПриИзменении(Элемент)
	
	БанковскийСчетОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьДиначескиеСписки();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспоряженияНаПоступлениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.РаспоряженияНаПоступление.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПредставлениеОтборОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		СписокОпераций = ВыбранноеЗначение;
		МассивВыбранныхОпераций = Новый Массив;
		ХозяйственнаяОперацияПредставление = "";
		Для Каждого ЭлементСписка Из СписокОпераций Цикл
			Если ЭлементСписка.Пометка Тогда
				МассивВыбранныхОпераций.Добавить(ЭлементСписка.Значение);
				ХозяйственнаяОперацияПредставление = ХозяйственнаяОперацияПредставление +
					?(ЗначениеЗаполнено(ХозяйственнаяОперацияПредставление), ", ", "") + ЭлементСписка.Значение;
			КонецЕсли;
		КонецЦикла;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			РаспоряженияНаПоступление,
			"ХозяйственнаяОперация",
			МассивВыбранныхОпераций,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			МассивВыбранныхОпераций.Количество() > 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ХозяйственнаяОперацияПредставлениеОтборНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Перечисление.ХозяйственныеОперации.Форма.ФормаВыбораОперации",
		Новый Структура("СписокОпераций", СписокОпераций), Элемент);
	
КонецПроцедуры
	
	&НаКлиенте
Процедура ХозяйственнаяОперацияПредставлениеОтборОчистка(Элемент, СтандартнаяОбработка)
	
	СписокОпераций = СписокОпераций();
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		РаспоряженияНаПоступление,
		"ХозяйственнаяОперация",
		Неопределено,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлательщикПредставлениеОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		РаспоряженияНаПоступление,
		"ПлательщикПредставление",
		ПлательщикПредставление,
		ВидСравненияКомпоновкиДанных.Содержит,
		,
		ЗначениеЗаполнено(ПлательщикПредставление));
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоСчетаНаОплатуПриИзменении(Элемент)
	УстановитьОтборТолькоСчетаСервер(ТолькоСчетаНаОплату);
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствОтПоставщикаВыполнить()

	СоздатьПоступлениеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочиеДоходы(Команда)
	
	СоздатьПоступлениеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочиеДоходы"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочееПоступлениеДенежныхСредствВыполнить()

	СоздатьПоступлениеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочееПоступлениеДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонвертацияВалюты(Команда)
	
	СоздатьПоступлениеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.КонвертацияВалюты"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеПоКредитам(Команда)
	
	СоздатьПоступлениеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоКредитам"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеПоДепозитам(Команда)
	
	СоздатьПоступлениеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоДепозитам"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеПоЗаймам(Команда)
	
	СоздатьПоступлениеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратДенежныхСредствОтПодотчетника(Команда)
	СоздатьПоступлениеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтПодотчетника"));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратНеперечисленнойЗарплаты(Команда)
	СоздатьПоступлениеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратНеперечисленныхДС"));
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
		Команда, ЭтаФорма, Элементы.ПоступленияБезналичныхДенежныхСредств);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура БанковскийСчетОтборПриИзмененииСервер()
	
	Организация = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(БанковскийСчет).Организация;
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПоступлениеБезналичныхДенежныхСредств.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СчетНаОплатуКлиенту.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПоступлениеБезналичныхДенежныхСредств") Тогда
			Элементы.ПоступленияБезналичныхДенежныхСредств.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаПоступленияБезналичныхДенежныхСредств;
		КонецЕсли;
		
		ОткрытьЗначение(Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеДокументов

&НаКлиенте
Процедура СоздатьПоступлениеБезналичныхДенежныхСредств(ХозяйственнаяОперация)

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	ОткрытьФорму("Документ.ПоступлениеБезналичныхДенежныхСредств.ФормаОбъекта", СтруктураПараметры, Элементы.ПоступленияБезналичныхДенежныхСредств);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов")
	 И Не ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам") Тогда
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Элементы.ПоступленияБезналичныхДенежныхСредствБанковскийСчетОтбор.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	Элементы.РаспоряженияНаПоступлениеБанковскийСчетОтбор.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	БанковскийСчетВидимость = Не ЗначениеЗаполнено(БанковскийСчет);
	Элементы.БанковскийСчет.Видимость = БанковскийСчетВидимость;
	Элементы.РаспоряженияНаПоступлениеБанковскийСчет.Видимость = БанковскийСчетВидимость;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура СохранитьРабочиеЗначенияПолейФормы(СохранитьНеопределено = Ложь)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущаяОрганизация", , ?(СохранитьНеопределено, Неопределено, Организация));
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущийБанковскийСчет", , ?(СохранитьНеопределено, Неопределено, БанковскийСчет));
	
КонецПроцедуры

&НаСервере
Функция МассивДинамическихСписков()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(ПоступленияБезналичныхДенежныхСредств);
	МассивСписков.Добавить(РаспоряженияНаПоступление);
	
	Возврат МассивСписков;

КонецФункции

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И (Организации.ДопускаютсяВзаиморасчетыСКлиентамиЧерезГоловнуюОрганизацию
		|			ИЛИ Организации.ДопускаютсяВзаиморасчетыСПоставщикамиЧерезГоловнуюОрганизацию)");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СписокОрганизаций.Добавить(Выборка.Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;
	
	СписокСчетов = Новый СписокЗначений;
	СписокСчетов.Добавить(БанковскийСчет);
	СписокСчетов.Добавить(Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка());
	
	Для Каждого ДинамическийСписок Из МассивДинамическихСписков() Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, "Организация", СписокОрганизаций, ВидСравненияКомпоновкиДанных.ВСписке,, ЗначениеЗаполнено(Организация));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок, "БанковскийСчет", СписокСчетов, ВидСравненияКомпоновкиДанных.ВСписке,, ЗначениеЗаполнено(БанковскийСчет));
	КонецЦикла;
	
	СохранитьРабочиеЗначенияПолейФормы();
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДиначескиеСписки()
	
	Элементы.РаспоряженияНаПоступление.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СписокОпераций()
	
	Операции = Перечисления.ХозяйственныеОперации;
	
	СписокОпераций = Новый СписокЗначений;
	СписокОпераций.Добавить(Операции.ПоступлениеОплатыОтКлиента);
	СписокОпераций.Добавить(Операции.ВозвратДенежныхСредствОтПоставщика, НСтр("ru = 'Возврат от поставщика'"));
	СписокОпераций.Добавить(Операции.ВозвратДенежныхСредствОтПодотчетника, НСтр("ru = 'Возврат от подотченика'"));
	СписокОпераций.Добавить(Операции.КонвертацияВалюты);
	СписокОпераций.Добавить(Операции.ПрочиеДоходы);
	СписокОпераций.Добавить(Операции.ПрочееПоступлениеДенежныхСредств, НСтр("ru = 'Прочее поступление'"));
	СписокОпераций.Добавить(Операции.ПоступлениеДенежныхСредствПоКредитам, НСтр("ru = 'Поступление по кредитам'"));
	СписокОпераций.Добавить(Операции.ПоступлениеДенежныхСредствПоДепозитам, НСтр("ru = 'Поступление по депозитам'"));
	СписокОпераций.Добавить(Операции.ПоступлениеДенежныхСредствПоЗаймамВыданным, НСтр("ru = 'Поступление по выданным займам'"));
	
	Возврат СписокОпераций;
	
КонецФункции

&НаСервере 
Процедура УстановитьОтборТолькоСчетаСервер(ТолькоСчета)
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			РаспоряженияНаПоступление,
			"Тип",
			ТипЗнч(Документы.СчетНаОплатуКлиенту.ПустаяСсылка()),
			ВидСравненияКомпоновкиДанных.Равно,
			,
			ТолькоСчета);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
