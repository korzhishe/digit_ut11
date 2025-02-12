﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	ИспользоватьНесколькоРасчетныхСчетов	= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	УправлениеЭлементамиФормы();
	
	ТекстЗапросаЗаказыКОплате = ДенежныеСредстваСервер.ТекстЗапросаЗаказыКОплате();
	ЗаказыКОплате.ТекстЗапроса = ТекстЗапросаЗаказыКОплате;
	
	УстановитьПараметрыДинамическихСписков();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписанияБезналичныхДенежныхСредствКоманднаяПанель);
	// Конец СтандартныеПодсистемы.Печать

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписанияБезналичныхДенежныхСредствКоманднаяПанель);
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
	
	Если ИмяСобытия = "Запись_СписаниеБезналичныхДенежныхСредств" Тогда
		ОбновитьДиначескиеСписки();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация    = Настройки.Получить("Организация");
	БанковскийСчет = Настройки.Получить("БанковскийСчет");
	УстановитьОтборДинамическихСписков();
	
	Вариант = Настройки.Получить("ДатаПлатежа.Вариант");
	Если ЗначениеЗаполнено(Вариант) Тогда
		ДатаПлатежа.Вариант = Вариант;
		УстановитьПараметрыДинамическихСписков();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БанковскийСчетОтборПриИзменении(Элемент)
	
	БанковскийСчетОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьДиначескиеСписки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПлатежаОтборПриИзменении(Элемент)
	
	УстановитьПараметрыДинамическихСписков();
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкиКОплатеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.ЗаявкиКОплате.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыКОплатеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьЗначение(Элементы.ЗаказыКОплате.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьВыдачаПодотчетнику()

	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеречислениеНаДругойСчет()

	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратОплатыКлиенту()

	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОплатаВДругуюОрганизацию(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВозвратВДругуюОрганизацию(Команда)
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию"));
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочиеРасходы(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочиеРасходы"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеречислениеВБюджет(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеречислениеВБюджет"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПрочаяВыдачаДенежныхСредств()
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПрочаяВыдачаДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВнутреннююПередачуДенежныхСредств(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеречислениеТаможне(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеречислениеТаможне"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКонвертацияВалюты(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.КонвертацияВалюты"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыплатаЗаработнойПлаты(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыПоЗарплатномуПроекту"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписаниеПоКредитам(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаПоКредитам"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписаниеПоДепозитам(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаПоДепозитам"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСписаниеПоЗаймам(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаПоЗаймамВыданным"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеречислениеЗаработнойПлатыНаЛицевыеСчета(Команда)
	
	СоздатьСписаниеБезналичныхДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьДокумент(Команда)
	
	Если Элементы.ЗаказыКОплате.ВыделенныеСтроки.Количество() = 1 Тогда
	
		СтрокаТаблицы = Элементы.ЗаказыКОплате.ТекущиеДанные;
		Если СтрокаТаблицы <> Неопределено Тогда
			
			СтруктураОснование = Новый Структура("Организация, ЗаказПоставщику, СуммаКОплате",
				СтрокаТаблицы.Организация,
				СтрокаТаблицы.Ссылка,
				СтрокаТаблицы.СуммаКОплате);
				СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
			
			ОткрытьФорму("Документ.СписаниеБезналичныхДенежныхСредств.ФормаОбъекта", 
				СтруктураПараметры, 
				Элементы.СписанияБезналичныхДенежныхСредств);
		КонецЕсли;
	
	Иначе
	
		МассивСсылок = Новый Массив();
		
		Для Каждого ЗаказКОплате Из Элементы.ЗаказыКОплате.ВыделенныеСтроки Цикл
		
			Если ТипЗнч(ЗаказКОплате) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			
			СсылкаНаДокумент = Элементы.ЗаказыКОплате.ДанныеСтроки(ЗаказКОплате).Ссылка;
			МассивСсылок.Добавить(СсылкаНаДокумент);
			ОрганизацияЗаполнения = Элементы.ЗаказыКОплате.ДанныеСтроки(ЗаказКОплате).Организация;
			
		КонецЦикла;
		
		Если МассивСсылок.Количество() = 0 Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
			Предупреждение(ТекстПредупреждения);
			Возврат;
			
		КонецЕсли;
		
		ОчиститьСообщения();

		Если СформироватьДанныеЗаполненияСписанияДСПоНесколькимДокументамНаСервере(МассивСсылок) Тогда
		
			СтруктураОснование = Новый Структура("Организация, ДокументОснование, СуммаКОплате",
			ОрганизацияЗаполнения,
			МассивСсылок,
			0,);
			СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
			
			ОткрытьФорму("Документ.СписаниеБезналичныхДенежныхСредств.ФормаОбъекта", 
					СтруктураПараметры,
					Элементы.СписанияБезналичныхДенежныхСредств);

			КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.СписанияБезналичныхДенежныхСредств);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.СписанияБезналичныхДенежныхСредств);
	
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
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.СписаниеБезналичныхДенежныхСредств.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств") Тогда
			Элементы.СписанияБезналичныхДенежныхСредств.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.СтраницаСписанияБезналичныхДенежныхСредств;
		КонецЕсли;
		
		ОткрытьЗначение(Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура СохранитьРабочиеЗначенияПолейФормы(СохранитьНеопределено = Ложь)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущаяОрганизация", 
	,
	?(СохранитьНеопределено, Неопределено, Организация));
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущийБанковскийСчет",
	,
	?(СохранитьНеопределено, Неопределено, БанковскийСчет));
	
КонецПроцедуры

&НаСервере
Функция МассивДинамическихСписков()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(СписанияБезналичныхДенежныхСредств);
	МассивСписков.Добавить(ЗаявкиКОплате);
	МассивСписков.Добавить(ЗаказыКОплате);
	
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
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок,
			"Организация",
			СписокОрганизаций,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ЗначениеЗаполнено(Организация));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ДинамическийСписок,
			"БанковскийСчет",
			СписокСчетов,
			ВидСравненияКомпоновкиДанных.ВСписке,
			,
			ЗначениеЗаполнено(БанковскийСчет));
	КонецЦикла;
	
	СохранитьРабочиеЗначенияПолейФормы();
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	ДатаОстатков = ?(ЗначениеЗаполнено(ДатаПлатежа.Дата), ДатаПлатежа.Дата, Дата(2299,1,1));
	Граница = Новый Граница(КонецДня(ДатаОстатков), ВидГраницы.Включая);
	ЗаявкиКОплате.Параметры.УстановитьЗначениеПараметра("ДатаПлатежа", Граница);
	ЗаказыКОплате.Параметры.УстановитьЗначениеПараметра("ДатаПлатежа", Граница);
	
	Элементы.ЗаявкиКОплате.Обновить();
	Элементы.ЗаказыКОплате.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДиначескиеСписки()
	
	Элементы.ЗаявкиКОплате.Обновить();
	Элементы.ЗаказыКОплате.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьВидимость()
	
	БанковскийСчетВидимость = Не ЗначениеЗаполнено(БанковскийСчет);
	Элементы.БанковскийСчет.Видимость = БанковскийСчетВидимость;
	
	МассивЭлементов = Новый Массив;
	МассивЭлементов.Добавить("ЗаявкиКОплатеБанковскийСчет");
	
	ДенежныеСредстваСервер.УстановитьВидимостьЭлементовПоМассиву(
		Элементы,
		МассивЭлементов,
		?(БанковскийСчетВидимость, МассивЭлементов, Новый Массив)); // МассивВидимыхРеквизитов
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.БанковскийСчетОтбор.Видимость = ИспользоватьНесколькоРасчетныхСчетов;
	Элементы.ГруппаСоздать.ПодчиненныеЭлементы.СоздатьПеречислениеНаДругойСчет.Видимость = ИспользоватьНесколькоРасчетныхСчетов;
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеДокументов

&НаКлиенте
Процедура СоздатьСписаниеБезналичныхДенежныхСредств(ХозяйственнаяОперация)

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	ОткрытьФорму("Документ.СписаниеБезналичныхДенежныхСредств.ФормаОбъекта", СтруктураПараметры, Элементы.СписанияБезналичныхДенежныхСредств);
	
КонецПроцедуры

&НаСервере
Функция СформироватьДанныеЗаполненияСписанияДСПоНесколькимДокументамНаСервере(МассивСсылок)

	Возврат ДенежныеСредстваСервер.СформироватьДанныеЗаполненияСписанияДСПоНесколькимДокументам(МассивСсылок)

КонецФункции

#КонецОбласти

#КонецОбласти
