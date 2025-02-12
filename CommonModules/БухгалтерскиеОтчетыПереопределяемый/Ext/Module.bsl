﻿////////////////////////////////////////////////////////////////////////////////
// Функции и процедуры обеспечения формирования бухгалтерских отчетов.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при создании формы отчета на сервере для возможности дополнительной настройки.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура ПриСозданииНаСервере(Форма) Экспорт

	УстановитьНастройкиПоУмолчанию(Форма);
	
	ПолеОформления = Форма.Элементы.Найти("КонтрагентДляОтбора");
	Если ПолеОформления <> Неопределено Тогда
		УчетНДСУТ.НастроитьСовместныйВыборКонтрагентовОрганизаций(ПолеОформления, Форма.Отчет.КонтрагентДляОтбора);
	КонецЕсли;
	

КонецПроцедуры

// Вызывается при установке настроек по умолчанию для формы отчета.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма отчета.
//
Процедура УстановитьНастройкиПоУмолчанию(Форма) Экспорт

	ЭлементГруппаБыстрыеОтборы = Форма.Элементы.Найти("ГруппаБыстрыеОтборы");
	Если ЭлементГруппаБыстрыеОтборы <> Неопределено Тогда
		ЭлементГруппаБыстрыеОтборы.ЦветФона = Новый Цвет();
	КонецЕсли;

КонецПроцедуры

// Выполняет установку макета оформления для отчета.
//
// Параметры:
//	ПараметрыОтчета - Структура - передается из формы отчета при запуске фонового задания отчета.
//		Может содержать ключ:
//			* МакетОформления - Строка - Название макета оформления.
//	НастройкаКомпоновкиДанных - НастройкиКомпоновкиДанных - Настройки, которые будут использоваться для отчета. 
//	СтандартнаяОбработка - Булево - Если установить внутри процедуры в Ложь, то стандартная обработка не будет выполняться.
//
Процедура УстановитьМакетОформленияОтчета(ПараметрыОтчета, НастройкаКомпоновкиДанных, СтандартнаяОбработка) Экспорт

	Если ПараметрыОтчета.Свойство("МакетОформления")
		И ЗначениеЗаполнено(ПараметрыОтчета.МакетОформления)
		И ПараметрыОтчета.МакетОформления <> "МакетОформленияОтчетовЗеленый"
		И ПараметрыОтчета.МакетОформления <> "ОформлениеОтчетовЗеленый" Тогда
		// В отчете выбран конкретный макет оформления, его не меняем.
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;

	МакетОформления = "ОформлениеОтчетовБежевый";
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(НастройкаКомпоновкиДанных, "МакетОформления", МакетОформления);	
	
КонецПроцедуры

#КонецОбласти

