﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает строковый идентификатор форм обработки "ЖурналДокументовЗакупки" по умолчанию.
//
// ВозвращаемоеЗначение:
//	Строка - идентификатор форм обработки "ЖурналДокументовЗакупки" по умолчанию.
//
Функция КлючНазначенияФормыПоУмолчанию() Экспорт
	
	Возврат "ДокументыЗакупки";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриОпределенииКомандПодключенныхКОбъекту(Команды) Экспорт
	
	МассивКомандОтчетов = Команды.НайтиСтроки(Новый Структура("Вид", "Отчеты"));
	МассивКомандПечати = Команды.НайтиСтроки(Новый Структура("Вид", "Печать"));
	
	МенеджерСостояниеВыполненияДокументов = Метаданные.Отчеты.СостояниеВыполненияДокументов.ПолноеИмя();
	МенеджерСостояниеРасчетовСПоставщиками = Метаданные.Отчеты.СостояниеРасчетовСПоставщиками.ПолноеИмя();
	МенеджерКарточкаРасчетовСПоставщиками = Метаданные.Отчеты.КарточкаРасчетовСПоставщиками.ПолноеИмя();
	МенеджерКарточкаРасчетовПоПринятойВозвратнойТаре = Метаданные.Отчеты.КарточкаРасчетовПоПринятойВозвратнойТаре.ПолноеИмя();
	МенеджерОтклоненияОтУсловийЗакупок = Метаданные.Отчеты.ОтклоненияОтУсловийЗакупок.ПолноеИмя();
	МенеджерАнализЦенПоставщиков = Метаданные.Отчеты.АнализЦенПоставщиков.ПолноеИмя();
	МенеджерАнализРасхожденийПриПоступленииАлкогольнойПродукции = Метаданные.Отчеты.АнализРасхожденийПриПоступленииАлкогольнойПродукции.ПолноеИмя();
	
	Для каждого ТекКоманда Из МассивКомандОтчетов Цикл
		Если ТекКоманда.Менеджер = МенеджерСостояниеВыполненияДокументов Тогда
			ТекКоманда.Порядок = 1;
			ТекКоманда.ВидимостьВФормах = "СписокДокументов, ФормаСозданныеДокументы";
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерСостояниеРасчетовСПоставщиками Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 1;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерКарточкаРасчетовСПоставщиками Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 2;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерКарточкаРасчетовПоПринятойВозвратнойТаре Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 3;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерОтклоненияОтУсловийЗакупок Тогда
			ТекКоманда.Важность = "СмТакже";
			ТекКоманда.Порядок = 1;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерАнализЦенПоставщиков Тогда
			ТекКоманда.Важность = "СмТакже";
			ТекКоманда.Порядок = 2;
		КонецЕсли;
		Если ТекКоманда.Менеджер = МенеджерАнализРасхожденийПриПоступленииАлкогольнойПродукции Тогда
			ТекКоманда.Важность = "Обычное";
			ТекКоманда.Порядок = 1;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекКоманда Из МассивКомандПечати Цикл
		ТекКоманда.ВидимостьВФормах = "СписокДокументов";
	КонецЦикла;
	
КонецПроцедуры

#Область ФормированиеГиперссылкиВЖурналеЗакупок 

Функция ТекстЗапросаЗаказыКОформлению(Организация = Неопределено, Склад = Неопределено, МассивСсылок = Неопределено)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыПоставщикам.ЗаказПоставщику КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(, ЗаказПоставщику ССЫЛКА Документ.ЗаказПоставщику И &УсловиеОтбора) КАК ЗаказыПоставщикам
	|ГДЕ
	|	ЗаказыПоставщикам.КОформлениюОстаток > 0";
	
	УсловиеОтбора = "ИСТИНА";
	Если ЗначениеЗаполнено(Организация) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ЗаказПоставщику.Организация = &Организация";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ЗаказПоставщику.Склад = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивСсылок) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ЗаказПоставщику.Ссылка В (&МассивСсылок)";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&УсловиеОтбора", УсловиеОтбора);
	Возврат ТекстЗапроса
	
КонецФункции

Функция ТекстЗапросаРаспоряженияНаПриемку(Организация = Неопределено, Склад = Неопределено, МассивСсылок = Неопределено)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаРаспоряжений.ДокументПоступления КАК Ссылка,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Склад) КАК Склад,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Номенклатура) КАК Номенклатура,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Характеристика) КАК Характеристика,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Назначение) КАК Назначение,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Серия) КАК Серия,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Отправитель) КАК Отправитель
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(
	|			,
	|			(ДокументПоступления ССЫЛКА Документ.ЗаказПоставщику
	|				ИЛИ ДокументПоступления ССЫЛКА Документ.ПриобретениеТоваровУслуг
	|				ИЛИ ДокументПоступления ССЫЛКА Справочник.ДоговорыКонтрагентов
	|				ИЛИ ДокументПоступления ССЫЛКА Справочник.СоглашенияСПоставщиками)
	|				И &УсловиеОтбора) КАК ТаблицаРаспоряжений
	|ГДЕ
	|	ТаблицаРаспоряжений.КОформлениюПоступленийПоОрдерамОстаток <> 0
	|	И &УсловиеОтбора
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРаспоряжений.ДокументПоступления";
	
	УсловиеОтбора = "ИСТИНА";
	Если ЗначениеЗаполнено(Организация) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Организация = &Организация";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Склад = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивСсылок) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Ссылка В (&МассивСсылок)";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&УсловиеОтбора", УсловиеОтбора);
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ЕстьЗаказыКОформлению(Организация = Неопределено, Склад = Неопределено) Экспорт
	
	Если НЕ (ПравоДоступа("Чтение", Метаданные.Документы.ЗаказПоставщику)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаказыПоставщикам)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапросаЗаказыКОформлению(Организация, Склад);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ВЫБРАТЬ", "ВЫБРАТЬ ПЕРВЫЕ 1");

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ЕстьРаспоряженияНаПриемку(Организация = Неопределено, Склад = Неопределено) Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапросаРаспоряженияНаПриемку(Организация, Склад);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ВЫБРАТЬ РАЗЛИЧНЫЕ", "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1");

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Возврат Не Запрос.Выполнить().Пустой();
		
КонецФункции

Функция СформироватьГиперссылкуКОформлению(Параметры) Экспорт
	
	Организация = Параметры.Организация;
	Склад = Параметры.Склад;
	
	ПоказыватьЗаказы = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам")
		И ПравоДоступа("Чтение", Метаданные.Документы.ЗаказПоставщику)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ЗаказыПоставщикам)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению);
	
	ПоказыватьРаспоряженияНаПриемку = СкладыСервер.ЕстьОрдерныйНаПоступлениеСклад(Склад,ТекущаяДатаСеанса())
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению);
		
	ПоказыватьРаспоряженияНаПоступления = (ПолучитьФункциональнуюОпцию("ИспользоватьНеотфактурованныеПоставки")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьТоварыВПутиОтПоставщиков"))
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению);
		
	ГиперссылкаПоЗаказам = Неопределено;
	ГиперссылкаПоПриемке = Неопределено;
	ГиперссылкаПоПоступлениям = Неопределено;
	
	ТекстГиперссылкаПоПоступлениям = НСтр("ru = 'К оформлению поступления'");
	ТекстГиперссылкиПоЗаказам = НСтр("ru = 'К оформлению приобретения'");
	ТекстГиперссылкиПоПриемке = НСтр("ru = 'Контроль ордеров'");
	
	ЦветНезаполненный = ЦветаСтиля.НезаполненноеПолеТаблицы;
	ЦветЗаполненный = ЦветаСтиля.ГиперссылкаЦвет;
	
	МассивСтрок = Новый Массив;
	
	Если ПоказыватьЗаказы Тогда
		ЕстьЗаказы = ЕстьЗаказыКОформлению(Организация, Склад);
		ГиперссылкаПоЗаказам = Новый ФорматированнаяСтрока(ТекстГиперссылкиПоЗаказам,,
			?(ЕстьЗаказы,ЦветЗаполненный,ЦветНезаполненный),
			,
			"СтраницаРаспоряженияНаОформление");
		МассивСтрок.Добавить(ГиперссылкаПоЗаказам);
	КонецЕсли;
	
	Если ПоказыватьРаспоряженияНаПоступления Тогда
		ЕстьРаспоряжения = ЕстьРаспоряженияНаПоступление(Организация, Склад);
		ГиперссылкаПоПоступлениям = Новый ФорматированнаяСтрока(ТекстГиперссылкаПоПоступлениям,,
			?(ЕстьРаспоряжения,ЦветЗаполненный,ЦветНезаполненный),
			,
			"СтраницаРаспоряженияНаПоступление");
			
		Если МассивСтрок.Количество() > 0 Тогда
			МассивСтрок.Добавить("; ");
		КонецЕсли;
		МассивСтрок.Добавить(ГиперссылкаПоПоступлениям)
	КонецЕсли;
	
	Если ПоказыватьРаспоряженияНаПриемку Тогда
		ЕстьРаспоряжения = ЕстьРаспоряженияНаПриемку(Организация, Склад);
		ГиперссылкаПоПриемке = Новый ФорматированнаяСтрока(ТекстГиперссылкиПоПриемке,,
			?(ЕстьРаспоряжения,ЦветЗаполненный,ЦветНезаполненный),
			,
			"СтраницаРаспоряженияНаПриемку");
			
		Если МассивСтрок.Количество() > 0 Тогда
			МассивСтрок.Добавить("; ");
		КонецЕсли;
		МассивСтрок.Добавить(ГиперссылкаПоПриемке);
	КонецЕсли;
	
	Если МассивСтрок.Количество() > 0 Тогда
		Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ТекстЗапросаРаспоряженияНаПоступление(Организация = Неопределено, Склад = Неопределено, МассивСсылок = Неопределено)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	ТаблицаРаспоряжений.ДокументПоступления КАК Ссылка,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Склад) КАК Склад,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Номенклатура) КАК Номенклатура,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Характеристика) КАК Характеристика,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Назначение) КАК Назначение,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Серия) КАК Серия,
	|	МАКСИМУМ(ТаблицаРаспоряжений.Отправитель) КАК Отправитель
	|ИЗ
	|	РегистрНакопления.ТоварыКПоступлению.Остатки(
	|			,
	|			(ДокументПоступления ССЫЛКА Документ.ЗаказПоставщику
	|				ИЛИ ДокументПоступления ССЫЛКА Документ.ПриобретениеТоваровУслуг
	|				ИЛИ ДокументПоступления ССЫЛКА Справочник.ДоговорыКонтрагентов
	|				ИЛИ ДокументПоступления ССЫЛКА Справочник.СоглашенияСПоставщиками)
	|				И ХозяйственнаяОперация В (&СписокХозОпераций)
	|				И &УсловиеОтбора) КАК ТаблицаРаспоряжений
	|ГДЕ
	|	(ТаблицаРаспоряжений.КОформлениюПоступленийПоНакладнымОстаток <> 0
	|	ИЛИ ТаблицаРаспоряжений.КОформлениюПоступленийПоРаспоряжениюОстаток <> 0)
	|	И &УсловиеОтбора
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРаспоряжений.ДокументПоступления";
	
	УсловиеОтбора = "ИСТИНА";
	Если ЗначениеЗаполнено(Организация) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Организация = &Организация";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Склад = &Склад";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивСсылок) Тогда
		УсловиеОтбора = УсловиеОтбора + "
		|И ДокументПоступления.Ссылка В (&МассивСсылок)";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&УсловиеОтбора", УсловиеОтбора);
	
	Возврат ТекстЗапроса
	
КонецФункции

Функция ЕстьРаспоряженияНаПоступление(Организация = Неопределено, Склад = Неопределено) Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКПоступлению) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапросаРаспоряженияНаПоступление(Организация, Склад);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ВЫБРАТЬ РАЗЛИЧНЫЕ", "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1");

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("СписокХозОпераций", ЗакупкиСервер.ХозяйственныеОперацииРаздельнойЗакупкиБезОтборов());
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
