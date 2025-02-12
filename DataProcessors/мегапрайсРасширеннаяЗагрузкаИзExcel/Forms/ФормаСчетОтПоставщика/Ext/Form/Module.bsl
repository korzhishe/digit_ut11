﻿

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	СтатусДокумента = Перечисления.СтатусыЗаказовПоставщикам.Согласован;
	
	СтруктураПараметров = ПолучитьИзВременногоХранилища(Параметры.Адрес);
	
	Объект.Партнер                      = СтруктураПараметров.Партнер;
	Объект.ВидЦеныПоставщика            = СтруктураПараметров.ВидЦеныПоставщика;
	Объект.СоглашениеСПоставщиком       = СтруктураПараметров.СоглашениеСПоставщиком;
	
	Объект.ДокументОрганизация          = СтруктураПараметров.ДокументОрганизация;
	Объект.ДокументСклад                = СтруктураПараметров.ДокументСклад;	
	
	//БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Объект.ДокументОрганизация, , БанковскийСчет);
	Менеджер       = Пользователи.ТекущийПользователь();
	Подразделение  = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Менеджер, Подразделение);

	Объект.ОбработкаСчетОтПоставщика.Очистить();
	
	Для Каждого Строка из СтруктураПараметров.ТабличнаяЧасть Цикл
		Если Строка.Поле_Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Объект.ОбработкаСчетОтПоставщика.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
		НоваяСтрока.Поле_Количество = Строка.Поле_Количество;
		
		Если НоваяСтрока.Поле_Количество > 0 И НоваяСтрока.Поле_ЦенаЗакупки = 0 Тогда
			НоваяСтрока.Поле_ЦенаЗакупки = НоваяСтрока.Поле_Сумма/НоваяСтрока.Поле_Количество;
		КонецЕсли;
	КонецЦикла;
	
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ИспользоватьУпаковкиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");

КонецПроцедуры






&НаСервере
Функция ПолучитьКоэффициентУпаковки(ТекУпаковка)
	
	Если ЗначениеЗаполнено(ТекУпаковка) Тогда
		ТекКоэффициент = ?(ТекУпаковка.КоличествоУпаковок>0,ТекУпаковка.КоличествоУпаковок,1);
	Иначе
		ТекКоэффициент = 1;
	КонецЕсли;
	
	Возврат ТекКоэффициент;
	
КонецФункции

&НаКлиенте
Процедура СоздатьЗаказПоставщику(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Партнер) Тогда
		Сообщить("Не указан Партнер!");
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СтатусДокумента", СтатусДокумента);
	СтруктураПараметров.Вставить("Валюта", Валюта);
	СтруктураПараметров.Вставить("Подразделение", Подразделение);

	ДокументОбъект = мСоздатьЗаказПоставщикуСервер(СтруктураПараметров);
	ФормаДока = ПолучитьФорму("Документ.ЗаказПоставщику.Форма.ФормаДокумента", Новый Структура("Ключ", ДокументОбъект));    
	ФормаДока.Открыть();
	
КонецПроцедуры

&НаСервере
Функция мСоздатьЗаказПоставщикуСервер(СтруктураПараметров)
	
	УстановитьПривилегированныйРежим(Истина);

	НовыйДокумент = Документы.ЗаказПоставщику.СоздатьДокумент();
	НовыйДокумент.Дата        = ТекущаяДата();
	НовыйДокумент.Менеджер    = ПараметрыСеанса.ТекущийПользователь;
	
	НовыйДокумент.Организация = Объект.ДокументОрганизация;
	НовыйДокумент.Партнер     = Объект.Партнер;
	НовыйДокумент.Соглашение  = Объект.СоглашениеСПоставщиком;
	
	НовыйДокумент.Согласован = Истина;
	НовыйДокумент.Статус     = СтруктураПараметров.СтатусДокумента;
	НовыйДокумент.Приоритет  = Перечисления.Приоритеты.Средний;
	НовыйДокумент.Менеджер    = Менеджер;
	
	НовыйДокумент.Склад         = Объект.ДокументСклад;
	НовыйДокумент.Подразделение = СтруктураПараметров.Подразделение;
	
	НовыйДокумент.Валюта = СтруктураПараметров.Валюта;
	
	Если ЗначениеЗаполнено(Объект.СоглашениеСПоставщиком) Тогда
		НовыйДокумент.ЗаполнитьУсловияЗакупокПоСоглашению(); 
	Иначе
		НовыйДокумент.ЗаполнитьУсловияЗакупокПоУмолчанию();
	КонецЕсли;
	
	НовыйДокумент.ЗакупкаПодДеятельность = Справочники.Организации.ЗакупкаПодДеятельность(НовыйДокумент.Организация, НовыйДокумент.Склад, НовыйДокумент.Дата);
	Попытка
		НовыйДокумент.ВариантПриемкиТоваров = ЗакупкиСервер.ПолучитьВариантПриемкиТоваров(Неопределено, Неопределено);
	Исключение
	КонецПопытки;

	НовыйДокумент.Комментарий = "Импорт из Excel - создан как новый";
	
	НеПересчитыватьСуммуЕслиНетЦены = Ложь;

	Для Каждого Стр из Объект.ОбработкаСчетОтПоставщика Цикл	
		Если НЕ ЗначениеЗаполнено(Стр.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Стр.Поле_Количество = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		КоэффициентУпаковки = ПолучитьКоэффициентУпаковки(Стр.Упаковка);
		
		СтрокаТЧ = НовыйДокумент.Товары.Добавить();
		СтрокаТЧ.ВидЦеныПоставщика = Объект.ВидЦеныПоставщика;
		СтрокаТЧ.НоменклатураПоставщика = Стр.НоменклатураПоставщика;
		СтрокаТЧ.Номенклатура     = Стр.Номенклатура;
		СтрокаТЧ.Характеристика   = Стр.ХарактеристикаНоменклатуры;
		СтрокаТЧ.Упаковка         = Стр.Упаковка;
		
		СтрокаТЧ.Склад            = Объект.ДокументСклад;

		СтрокаТЧ.Количество       = Стр.Поле_Количество;
		СтрокаТЧ.КоличествоУпаковок = Стр.Поле_Количество / КоэффициентУпаковки;
		
		Если ЗначениеЗаполнено(Стр.Поле_Сумма) Тогда
			НеПересчитыватьСуммуЕслиНетЦены = Истина;

			СтрокаТЧ.Цена   = Стр.Поле_Сумма / СтрокаТЧ.КоличествоУпаковок;
			СтрокаТЧ.Сумма  = Стр.Поле_Сумма;
		ИначеЕсли ЗначениеЗаполнено(Стр.Поле_ЦенаЗакупки) Тогда
			СтрокаТЧ.Цена   = Стр.Поле_ЦенаЗакупки;
			СтрокаТЧ.Сумма  = СтрокаТЧ.КоличествоУпаковок * СтрокаТЧ.Цена;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(НовыйДокумент);
	Исключение //СТАРЫЕ ВЕРСИИ УТ
		СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(НовыйДокумент);
	КонецПопытки;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьНоменклатуруПоставщикаПоНоменклатуре", Объект.Партнер);
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",Новый Структура("НалогообложениеНДС, Дата", НовыйДокумент.НалогообложениеНДС, НовыйДокумент.Дата));
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	
	Если НЕ НеПересчитыватьСуммуЕслиНетЦены Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;

	СтруктураТЧ = Новый Структура;
	СтруктураТЧ.Вставить("СтрокиТЧ" , НовыйДокумент.Товары);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(НовыйДокумент.Товары, СтруктураДействий, Неопределено);
	
	НовыйДокумент.Записать();
	
	Возврат НовыйДокумент.Ссылка;
	
КонецФункции





&НаСервере
Процедура ЗаказПоставщикуПриИзмененииНаСервере(СтруктураПараметров)
		
	Если ЗначениеЗаполнено(ЗаказПоставщику) Тогда 
		
		ВремТовары = Новый ТаблицаЗначений;
		ВремТовары = СтруктураПараметров.ЗаказПоставщику.Товары.Выгрузить(,"Номенклатура,Характеристика,Количество,Цена");
		ВремТовары.Свернуть("Номенклатура,Характеристика,Цена","Количество");
		
		Для Каждого Строка из ВремТовары Цикл
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Номенклатура", Строка.Номенклатура);
			ПараметрыОтбора.Вставить("ХарактеристикаНоменклатуры", Строка.Характеристика);
			
			НайденныеСтроки = Объект.ОбработкаСчетОтПоставщика.НайтиСтроки(ПараметрыОтбора);
			Если НайденныеСтроки.Количество() > 0 Тогда
				Для Каждого НайденаСтрока Из НайденныеСтроки Цикл
					НайденаСтрока.КоличествоПоЗаказу = Строка.Количество;
					НайденаСтрока.ЦенаПоЗаказу       = Строка.Цена;            
					НайденаСтрока.ОтклонениеКоличество = НайденаСтрока.Поле_Количество - НайденаСтрока.КоличествоПоЗаказу;
					НайденаСтрока.ОтклонениеЦена       = НайденаСтрока.Поле_ЦенаЗакупки - НайденаСтрока.ЦенаПоЗаказу;
				КонецЦикла;
			Иначе
				НоваяСтрока = Объект.ОбработкаСчетОтПоставщика.Добавить();
				НоваяСтрока.Номенклатура = Строка.Номенклатура;
				НоваяСтрока.ХарактеристикаНоменклатуры = Строка.Характеристика;
				НоваяСтрока.КоличествоПоЗаказу = Строка.Количество;
				НоваяСтрока.ЦенаПоЗаказу       = Строка.Цена;
				
				НоваяСтрока.ОтклонениеКоличество  = НоваяСтрока.Поле_Количество - НоваяСтрока.КоличествоПоЗаказу; 
				НоваяСтрока.ОтклонениеЦена = НоваяСтрока.Поле_ЦенаЗакупки - НоваяСтрока.ЦенаПоЗаказу;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаказПоставщикуПриИзменении(Элемент)
		
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗаказПоставщику",ЗаказПоставщику);
	
	ЗаказПоставщикуПриИзмененииНаСервере(СтруктураПараметров);
	
КонецПроцедуры


&НаКлиенте
Процедура ИзменитьЗаказ(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗаказПоставщику",ЗаказПоставщику);

	ИзменитьЗаказНаСервере(СтруктураПараметров);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьЗаказНаСервере(СтруктураПараметров)
	
	ДокументОбъект = СтруктураПараметров.ЗаказПоставщику.ПолучитьОбъект();
	ДокументОбъект.Комментарий = ДокументОбъект.Комментарий+" Импорт из Excel - был ИЗМЕНЕН загрузкой";
	
	ДокументОбъект.Товары.Очистить();
	
	Для Каждого ВыборкаСтрока ИЗ Объект.ТабличнаяЧасть Цикл		
		НоваяСтрока = ДокументОбъект.Товары.Добавить();
		НоваяСтрока.Номенклатура = ВыборкаСтрока.Номенклатура;
		НоваяСтрока.Характеристика = ВыборкаСтрока.ХарактеристикаНоменклатуры;
		
		НоваяСтрока.Склад            = Объект.ДокументСклад;

		КоэффициентУпаковки = ПолучитьКоэффициентУпаковки(ВыборкаСтрока.Упаковка);

		НоваяСтрока.Количество       = ВыборкаСтрока.Поле_Количество;
		НоваяСтрока.КоличествоУпаковок = ВыборкаСтрока.Поле_Количество / КоэффициентУпаковки;
		
		Если ЗначениеЗаполнено(ВыборкаСтрока.Поле_Сумма) Тогда
			НеПересчитыватьСуммуЕслиНетЦены = Истина;

			НоваяСтрока.Цена   = ВыборкаСтрока.Поле_Сумма / НоваяСтрока.КоличествоУпаковок;
			НоваяСтрока.Сумма  = ВыборкаСтрока.Поле_Сумма;
		ИначеЕсли ЗначениеЗаполнено(ВыборкаСтрока.Поле_ЦенаЗакупки) Тогда
			НоваяСтрока.Цена   = ВыборкаСтрока.Поле_ЦенаЗакупки;
			НоваяСтрока.Сумма  = НоваяСтрока.КоличествоУпаковок * НоваяСтрока.Цена;
		КонецЕсли;
		
	КонецЦикла;
	
	ДокументОбъект.СуммаДокумента = ДокументОбъект.Товары.Итог("Сумма");
	//ДокументОбъект.СуммаВзаиморасчетов = ДокументОбъект.СуммаДокумента;

	//СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(ДокументОбъект);
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВСтрокеТЧ(ДокументОбъект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьНоменклатуруПоставщикаПоНоменклатуре", ДокументОбъект.Партнер);
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",Новый Структура("НалогообложениеНДС, Дата", ДокументОбъект.НалогообложениеНДС, ДокументОбъект.Дата));
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);

	Если НЕ НеПересчитыватьСуммуЕслиНетЦены Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;

	СтруктураТЧ = Новый Структура;
	СтруктураТЧ.Вставить("СтрокиТЧ" , ДокументОбъект.Товары);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(ДокументОбъект.Товары, СтруктураДействий, Неопределено);

	ДокументОбъект.Записать();

КонецПроцедуры

