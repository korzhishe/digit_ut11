﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Распоряжение = Параметры.Распоряжение;
	ТекДок       = Параметры.ТекДок;
	Если НЕ Константы.ИспользоватьСерииНоменклатуры.Получить() Тогда
		Элементы.ДанныеСерия.Видимость = Ложь; 
	КонецЕсли;	
	ЗаполнитьДанные();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанные()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	
	"ВЫБРАТЬ ПЕРВЫЕ 5
	|	ПересчетТоваров.Ссылка
	|ИЗ
	|	Документ.ПересчетТоваров КАК ПересчетТоваров
	|ГДЕ
	|	НЕ ПересчетТоваров.Проведен
	|	И НЕ ПересчетТоваров.ПометкаУдаления
	|	И ПересчетТоваров.Статус = &Статус
	//|	И ПересчетТоваров.ДокументОснование = &Распоряжение
	|	И ПересчетТоваров.Ссылка <> &ТекДок";
	
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыПересчетовТоваров.Выполнено);
	//Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	Запрос.УстановитьПараметр("ТекДок", ТекДок);
	
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	КолСсылок = МассивСсылок.Количество();
	Пересчеты.ЗагрузитьЗначения(МассивСсылок);	
	КолУдалить = 5 - КолСсылок;
	
	НачалоУдаления = 5;
	Пока КолУдалить <> 0 Цикл
		Элементы["ДанныеФактСотрудник" + Строка(НачалоУдаления)].Видимость = Ложь;
		КолУдалить = КолУдалить - 1;
		НачалоУдаления = НачалоУдаления - 1;
	КонецЦикла;
	
	Начало = 0;
	
	Для Каждого Док из МассивСсылок Цикл
		
		Начало = Начало +1;
		Элементы["ДанныеФактСотрудник" + Строка(Начало)].Заголовок = Строка(Док.Исполнитель); 
		
		Факт = "ПересчетТоваровТовары.КоличествоФакт КАК ФактСотрудник" + Строка(Начало);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		
		"ВЫБРАТЬ
		|	ПересчетТоваровТовары.Количество КАК ПоУчету,
		| "+ Факт +",
		|	ПересчетТоваровТовары.Номенклатура,
		|	ПересчетТоваровТовары.Упаковка КАК ЕдИзм,
		|	ПересчетТоваровТовары.Характеристика,
		|	ПересчетТоваровТовары.Серия,
		|	ПересчетТоваровТовары.Ссылка.Исполнитель КАК Исполнитель,
		|	ПересчетТоваровТовары.Ссылка
		|ИЗ
		|	Документ.ПересчетТоваров.Товары КАК ПересчетТоваровТовары
		|ГДЕ
		|	ПересчетТоваровТовары.Ссылка = &Док";
		
		Запрос.УстановитьПараметр("Док", Док);
		Товары = Запрос.Выполнить().Выгрузить();
		
		Для Каждого Товар из Товары Цикл
			ПараметрыОтбора = Новый Структура("Номенклатура, Характеристика, Серия", Товар.Номенклатура, Товар.Характеристика, Товар.Серия);
			НайденныеСтроки = Данные.НайтиСтроки(ПараметрыОтбора);
			Если НайденныеСтроки.Количество() > 0 Тогда
				ФактСотрудник = "ФактСотрудник" + Строка(Начало);
				НайденныеСтроки[0]["ФактСотрудник" + Строка(Начало)] =  Товар["ФактСотрудник" + Строка(Начало)]; 
				Если Начало <> 1 И НЕ НайденныеСтроки[0].Ошибка И НайденныеСтроки[0]["ФактСотрудник" + Строка(Начало)] <> НайденныеСтроки[0]["ФактСотрудник" + Строка(Начало-1)] Тогда 
					НайденныеСтроки[0].Ошибка = Истина;	
					НайденныеСтроки[0].Итог = 0;
				Иначе
					НайденныеСтроки[0].Итог = НайденныеСтроки[0]["ФактСотрудник" + Строка(Начало)];
				КонецЕсли;	
			Иначе
				НоваяСтрока = Данные.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Товар);
				Если Начало <> 1 Тогда
					НоваяСтрока.Ошибка = Истина;
				Иначе
					НоваяСтрока.Итог = Товар["ФактСотрудник" + Строка(Начало)]; 
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПересчет(Команда)
	ЭтаФорма.ВладелецФормы.Объект.Товары.Очистить();
	
	УдалитьДокументы();
	
	Для Каждого Стр из Данные Цикл 
		НоваяСтрока = ЭтаФорма.ВладелецФормы.Объект.Товары.добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр);
		НоваяСтрока.Количество = Стр.ПоУчету;  
		НоваяСтрока.КоличествоУпаковок = Стр.ПоУчету;
		НоваяСтрока.КоличествоФакт = Стр.Итог;  
		НоваяСтрока.КоличествоУпаковокФакт = Стр.Итог; 
		
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", НоваяСтрока.Характеристика);
		СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
		ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, Неопределено);
		
	КонецЦикла;
	
	
	Закрыть();
	Сообщить("Итоговый пересчет завершен, данные внесены. Промежуточные пересчеты закрыты!");
КонецПроцедуры

&НаСервере
Процедура УдалитьДокументы()
	Для Каждого Док из Пересчеты Цикл
		Попытка
			ДокОбъект = Док.Значение.ПолучитьОбъект();
			ДокОбъект.Доп_Закрыт = Истина;
			ДокОбъект.Записать();
		Исключение
			Сообщить("Не удалось перезаписать документ " + Док.Значение)
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	ТаблДок = Новый ТабличныйДокумент;

	ПечатьДанных(ТаблДок);
	
	ТаблДок.АвтоМасштаб = Истина;
	
	ТаблДок.Показать();
КонецПроцедуры

&НаСервере
Процедура ПечатьДанных(ТаблДок)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	"ВЫБРАТЬ
	|	Данные.Номенклатура,
	|	Данные.Характеристика
	|ПОМЕСТИТЬ Данные
	|ИЗ
	|	&Данные КАК Данные
	|ГДЕ
	|	Данные.Ошибка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РазмещениеОсновнаяЯчейка.Ячейка.Код КАК ОснЯч,
	|	РазмещениеОстальныеЯчейки.Ячейка.Код КАК ОстЯч,
	|	Данные.Номенклатура,
	|	Данные.Характеристика
	|ИЗ
	|	Данные КАК Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеОсновнаяЯчейка
	|		ПО Данные.Номенклатура = РазмещениеОсновнаяЯчейка.Номенклатура
	|			И (РазмещениеОсновнаяЯчейка.ОсновнаяЯчейка = ИСТИНА)
	|			И (РазмещениеОсновнаяЯчейка.Склад = &Склад)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмещениеНоменклатурыПоСкладскимЯчейкам КАК РазмещениеОстальныеЯчейки
	|		ПО Данные.Номенклатура = РазмещениеОстальныеЯчейки.Номенклатура
	|			И (РазмещениеОстальныеЯчейки.ОсновнаяЯчейка = ЛОЖЬ)
	|			И (РазмещениеОстальныеЯчейки.Склад = &Склад)
	|ГДЕ
	|	(НЕ РазмещениеОсновнаяЯчейка.Ячейка ЕСТЬ NULL 
	|			ИЛИ НЕ РазмещениеОстальныеЯчейки.Ячейка ЕСТЬ NULL )
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОснЯч,
	|	ОстЯч";
	
	
	Запрос.УстановитьПараметр("Данные", Данные.Выгрузить());
	Запрос.УстановитьПараметр("Склад", ТекДок.Склад);
	
	ДанныеЯчеек = Запрос.Выполнить().Выгрузить();
	
	Макет = Документы.ПересчетТоваров.ПолучитьМакет("Доп_ИтоговыйПересчетСЯчейками");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ТаблДок.Вывести(ОбластьЗаголовок);
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.ПредставлениеСклада = ТекДок.Склад;
	//ОбластьШапка.Параметры.ПредставлениеРаспоряжения = Распоряжение;
	ТаблДок.Вывести(ОбластьШапка);
	
	ОбластьИсполнитель = Макет.ПолучитьОбласть("Исполнитель");
	ОбластьИсполнитель.Параметры.ИсполнительПредставление = ТекДок.Исполнитель;
	ТаблДок.Вывести(ОбластьИсполнитель);
	
	
	ОбластьШапкаТаблицыБезУпаковок = Макет.ПолучитьОбласть("ШапкаТаблицыБезУпаковок");
	ТаблДок.Вывести(ОбластьШапкаТаблицыБезУпаковок);
	
	ОбластьСтрокаТаблицыБезУпаковок = Макет.ПолучитьОбласть("СтрокаТаблицыБезУпаковок");
	НомерСтроки = 1;
	
	Для Каждого Стр из Данные Цикл
		Если Стр.Ошибка Тогда
			ОбластьСтрокаТаблицыБезУпаковок.Параметры.НомерСтроки = НомерСтроки; 
		    //ОбластьСтрокаТаблицыБезУпаковок.Параметры.Артикул = Стр.Номенклатура.Артикул;
			ОбластьСтрокаТаблицыБезУпаковок.Параметры.ПредставлениеБазовойЕдиницыИзмерения = Стр.Номенклатура.ЕдиницаИзмерения;
			Товар = Стр.Номенклатура.Наименование; 
			Товар = ?(ЗначениеЗаполнено(Стр.Характеристика), Товар + " (" + Стр.Характеристика.Наименование + ")", Товар);
			ОбластьСтрокаТаблицыБезУпаковок.Параметры.Товар = Товар;
			
			Отбор = Новый Структура("Номенклатура, Характеристика", Стр.Номенклатура,Стр.Характеристика);
			
			СтрокиЯчеек = ДанныеЯчеек.НайтиСтроки(Отбор);
			
			ОснЯч = "";
			ОстЯч = "";
			Для Каждого СтрЯч из СтрокиЯчеек Цикл
				Если ЗначениеЗаполнено(СтрЯч.ОснЯч) Тогда
					ОснЯч = ОснЯч + СтрЯч.ОснЯч + "|";  
				КонецЕсли;
				Если ЗначениеЗаполнено(СтрЯч.ОстЯч) Тогда
					ОстЯч = ОстЯч + СтрЯч.ОстЯч + "|"; 
				КонецЕсли;
			КонецЦикла;	
			ОбластьСтрокаТаблицыБезУпаковок.Параметры.ОсновнаяЯчейкаПредставление = ОснЯч;
			ОбластьСтрокаТаблицыБезУпаковок.Параметры.ДополнительныеЯчейки = ОстЯч;		
			
			
			НомерСтроки = НомерСтроки + 1;
			ТаблДок.Вывести(ОбластьСтрокаТаблицыБезУпаковок);
			
		КонецЕсли;	
	КонецЦикла;
	
	
	ОбластьПодвалТаблицыБезУпаковок = Макет.ПолучитьОбласть("ПодвалТаблицыБезУпаковок");
	ТаблДок.Вывести(ОбластьПодвалТаблицыБезУпаковок);	
	
КонецПроцедуры




