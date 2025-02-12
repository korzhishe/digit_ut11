﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает самый низкий приоритет
//
// Возвращаемое значание:
//	СправочникСсылка.Приоритеты - самый низкий приоритет
//
Функция ПолучитьНизшийПриоритет() Экспорт
	
	Результат = Справочники.Приоритеты.ПустаяСсылка();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Приоритеты.Ссылка                    КАК Приоритет,
	|	Приоритеты.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	|ИЗ
	|	Справочник.ПриоритетыОплаты КАК Приоритеты
	|ГДЕ
	|	НЕ Приоритеты.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания УБЫВ");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Результат = Выборка.Приоритет;
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Возвращает самый высокий приоритет
//
// Возвращаемое значание:
//	СправочникСсылка.Приоритеты -  самый высокий приоритет
//
Функция ПолучитьВысшийПриоритет() Экспорт
	
	Результат = Справочники.Приоритеты.ПустаяСсылка();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Приоритеты.Ссылка                    КАК Приоритет,
	|	Приоритеты.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
	|ИЗ
	|	Справочник.ПриоритетыОплаты КАК Приоритеты
	|ГДЕ
	|	НЕ Приоритеты.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания ВОЗР");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Результат = Выборка.Приоритет;
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Получает приоритет, используемый для заполнения новых документов
//
// Возвращаемое значение:
//	СправочникСсылка.ПриоритетыОплаты - приоритет по умолчанию
//
Функция ПолучитьПриоритетПоУмолчанию(Знач Приоритет) Экспорт
	
	Результат = Справочники.ПриоритетыОплаты.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(Приоритет) Тогда
		
		Результат = Приоритет;
		
	Иначе
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	Приоритеты.Приоритет                 КАК Приоритет,
		|	Приоритеты.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
		|ИЗ
		|	(ВЫБРАТЬ ПЕРВЫЕ 2
		|		Приоритеты.Ссылка                    КАК Приоритет,
		|		Приоритеты.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
		|	ИЗ
		|		Справочник.ПриоритетыОплаты КАК Приоритеты
		|	ГДЕ
		|		НЕ Приоритеты.ПометкаУдаления
		|	
		|	УПОРЯДОЧИТЬ ПО
		|		РеквизитДопУпорядочивания УБЫВ) КАК Приоритеты
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеквизитДопУпорядочивания ВОЗР");
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			Результат = Выборка.Приоритет;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Приоритеты.Ссылка                      КАК Ссылка,
	|	Приоритеты.ПометкаУдаления             КАК ПометкаУдаления,
	|	Приоритеты.РеквизитДопУпорядочивания   КАК РеквизитДопУпорядочивания,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Приоритеты.Ссылка) КАК Представление
	|ИЗ
	|	Справочник.ПриоритетыОплаты КАК Приоритеты
	|ГДЕ
	|	НЕ Приоритеты.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
	
		Пока Выборка.Следующий() Цикл
		
			ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Представление);
		
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Выполняет первоначальное заполнение справочника
//
Процедура СоздатьПриоритетыПоУмолчанию() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле
	|ИЗ
	|	Справочник.ПриоритетыОплаты КАК Приоритеты");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		ПриоритетыЭлемент = СоздатьЭлемент();
		ПриоритетыЭлемент.Наименование = НСтр("ru = 'Высокий'");
		ПриоритетыЭлемент.РеквизитДопУпорядочивания = 1;
		ПриоритетыЭлемент.Записать();
		
		ПриоритетыЭлемент = СоздатьЭлемент();
		ПриоритетыЭлемент.Наименование = НСтр("ru = 'Средний'");
		ПриоритетыЭлемент.РеквизитДопУпорядочивания = 2;
		ПриоритетыЭлемент.Записать();
		
		ПриоритетыЭлемент = СоздатьЭлемент();
		ПриоритетыЭлемент.Наименование = НСтр("ru = 'Низкий'");
		ПриоритетыЭлемент.РеквизитДопУпорядочивания = 3;
		ПриоритетыЭлемент.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли