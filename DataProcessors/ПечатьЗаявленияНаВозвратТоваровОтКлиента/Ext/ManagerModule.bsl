﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
// 		ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
// 		МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
// 		ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
// 		КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
// 		ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЗаявлениеНаВозвратТоваровОтКлиента") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, "ЗаявлениеНаВозвратТоваровОтКлиента", НСтр("ru='Заявление на возврат товаров'"),
			СформироватьПечатнуюФормуЗаявленияНаВозвратТоваровОтКлиента(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, СтруктураТипов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуЗаявленияНаВозвратТоваровОтКлиента(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявлениеНаВозвратТоваровОтКлиента";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыЗаявлениеНаВозвратТоваровОтКлиента(СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументЗаявлениеНаВозвратТоваровОтКлиента(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументЗаявлениеНаВозвратТоваровОтКлиента(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьЗаявленияНаВозвратТоваровОтКлиента.ПФ_MXL_ЗаявлениеНаВозвратТоваров");
	
	ДанныеПечати = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	Товары       = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выгрузить();
	
	ПервыйДокумент = Истина;
	СтруктураПоиска = Новый Структура("Ссылка");
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ВыводитьКоды = Истина;
		Колонка = НСтр("ru='Артикул'");
	ИначеЕсли ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код Тогда
		ВыводитьКоды = Истина;
		Колонка = НСтр("ru='Код'");
	Иначе
		ВыводитьКоды = Ложь;
	КонецЕсли;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ТаблицаТовары = Товары.НайтиСтроки(СтруктураПоиска);
		// Выводим шапку заявления на возврат
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
		ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
		
		СтруктураДанныхШапки = Новый Структура;
		Если ЗначениеЗаполнено(ДанныеПечати.ЧекККМНомер) Тогда
			СтруктураДанныхШапки.Вставить("ЧекККМНомер", 
				ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.ЧекККМНомер, Ложь, Истина));
		КонецЕсли;
		
		Если ТаблицаТовары.Количество() > 1 Тогда
			СтруктураДанныхШапки.Вставить("О1", НСтр("ru='ы'"));
		КонецЕсли;
		ОбластьМакета.Параметры.Заполнить(СтруктураДанныхШапки);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если ВыводитьКоды Тогда
			Постфикс = "";
		Иначе
			Постфикс = "БезКодов";
		КонецЕсли;
		
		// Выводим шапку таблицы возвращенных товаров

		ОбластьНомера   = Макет.ПолучитьОбласть("ШапкаТаблицы" + Постфикс + "|НомерСтроки"+Постфикс);
		ОбластьКодов    = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
		ОбластьДанных   = Макет.ПолучитьОбласть("ШапкаТаблицы" + Постфикс + "|Данные"+Постфикс);
		
		ТабличныйДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			СтруктураОбластьКодов = Новый Структура("ИмяКолонкиКодов", Колонка);
			ОбластьКодов.Параметры.Заполнить(СтруктураОбластьКодов);
			ТабличныйДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьДанных);
		
		// Выводим строки таблицы возвращенных товаров
		
		ОбластьНомераСтандарт = Макет.ПолучитьОбласть("СтрокаТаблицы" + Постфикс + "|НомерСтроки"+Постфикс);
		ОбластьКодовСтандарт  = Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаКодов");
		ОбластьДанныхСтандарт = Макет.ПолучитьОбласть("СтрокаТаблицы" + Постфикс + "|Данные"+Постфикс);
		
		ИспользоватьНаборы = Ложь;
		Если Товары.Колонки.Найти("ЭтоНабор") <> Неопределено Тогда
			ИспользоватьНаборы = Истина;
			
			ОбластьНомераНабор    = Макет.ПолучитьОбласть("СтрокаТаблицы" + "Набор" + Постфикс + "|НомерСтроки" + Постфикс);
			ОбластьКодовНабор     = Макет.ПолучитьОбласть("СтрокаТаблицы" + "Набор" + "|КолонкаКодов");
			ОбластьДанныхНабор    = Макет.ПолучитьОбласть("СтрокаТаблицы" + "Набор" + Постфикс + "|Данные" + Постфикс);
			
			ОбластьНомераКомплектующие    = Макет.ПолучитьОбласть("СтрокаТаблицы" + "Комплектующие" + Постфикс + "|НомерСтроки" + Постфикс);
			ОбластьКодовКомплектующие     = Макет.ПолучитьОбласть("СтрокаТаблицы" + "Комплектующие" + "|КолонкаКодов");
			ОбластьДанныхКомплектующие    = Макет.ПолучитьОбласть("СтрокаТаблицы" + "Комплектующие" + Постфикс + "|Данные" + Постфикс);
		КонецЕсли;
		
		ПустыеДанные   = НаборыСервер.ПустыеДанные();
		
		НомерСтроки = 0;
		
		Для Каждого ВыборкаСтрокТовары Из ТаблицаТовары Цикл
			
			Если НаборыСервер.ИспользоватьОбластьНабор(ВыборкаСтрокТовары, ИспользоватьНаборы) Тогда
				ОбластьНомера    = ОбластьНомераНабор;
				ОбластьКодов     = ОбластьКодовНабор;
				ОбластьДанных    = ОбластьДанныхНабор;
			ИначеЕсли НаборыСервер.ИспользоватьОбластьКомплектующие(ВыборкаСтрокТовары, ИспользоватьНаборы) Тогда
				ОбластьНомера    = ОбластьНомераКомплектующие;
				ОбластьКодов     = ОбластьКодовКомплектующие;
				ОбластьДанных    = ОбластьДанныхКомплектующие;
			Иначе
				ОбластьНомера    = ОбластьНомераСтандарт;
				ОбластьКодов     = ОбластьКодовСтандарт;
				ОбластьДанных    = ОбластьДанныхСтандарт;
			КонецЕсли;
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(ВыборкаСтрокТовары, ИспользоватьНаборы) Тогда
				УстановитьПараметр(ОбластьНомера, "НомерСтроки", Неопределено);
			Иначе
				НомерСтроки = НомерСтроки + 1;
				УстановитьПараметр(ОбластьНомера, "НомерСтроки", НомерСтроки);
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьНомера);
			
			Если ВыводитьКоды Тогда
				Если Колонка = "Артикул" Тогда
					Артикул = ВыборкаСтрокТовары.Артикул;
				Иначе
					Артикул = ВыборкаСтрокТовары.Код;
				КонецЕсли;
				СтруктураДанныхКоды = Новый Структура("Артикул", Артикул);
				ОбластьКодов.Параметры.Заполнить(СтруктураДанныхКоды);
				ТабличныйДокумент.Присоединить(ОбластьКодов);
			КонецЕсли;
			
			ПрефиксИПостфикс = НаборыСервер.ПолучитьПрефиксИПостфикс(ВыборкаСтрокТовары, ИспользоватьНаборы);
			
			Если НаборыСервер.ВыводитьТолькоЗаголовок(ВыборкаСтрокТовары, ИспользоватьНаборы) Тогда
				ОбластьДанных.Параметры.Заполнить(ПустыеДанные);
			Иначе
				ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
			КонецЕсли;
			
			ДополнительныеПараметрыПолученияНаименованияДляПечати = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
			ДополнительныеПараметрыПолученияНаименованияДляПечати.ВозвратнаяТара = ВыборкаСтрокТовары.ЭтоВозвратнаяТара;	
			
			ПредставлениеТовара = ПрефиксИПостфикс.Префикс + НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
					ВыборкаСтрокТовары.ПолноеНаименованиеНоменклатуры,
					ВыборкаСтрокТовары.ПолноеНаименованиеХарактеристики,
					,
					,
					ДополнительныеПараметрыПолученияНаименованияДляПечати) + ПрефиксИПостфикс.Постфикс;
			
			СтруктураДанныхСтрока = Новый Структура("Товар", ПредставлениеТовара);
					
			ОбластьДанных.Параметры.Заполнить(СтруктураДанныхСтрока);
			ТабличныйДокумент.Присоединить(ОбластьДанных);
			
		КонецЦикла;
		
		// Выводим подвал таблицы возвращенных товаров
		
		ОбластьНомера   = Макет.ПолучитьОбласть("ПодвалТаблицы" + Постфикс + "|НомерСтроки" + Постфикс);
		ОбластьКодов    = Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаКодов");
		ОбластьДанных   = Макет.ПолучитьОбласть("ПодвалТаблицы" + Постфикс + "|Данные" + Постфикс);
		
		ТабличныйДокумент.Вывести(ОбластьНомера);
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьДанных);
		
		// Выводим подвал заявления на возврат
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
			ТабличныйДокумент,
			НомерСтрокиНачало,
			ОбъектыПечати,
			ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьПараметр(ОбластьМакета, ИмяПараметра, ЗначениеПараметра)
	ОбластьМакета.Параметры.Заполнить(Новый Структура(ИмяПараметра, ЗначениеПараметра));
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
