﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Отбор = "";
	Если Параметры.Свойство("Отбор", Отбор)
		И ТипЗнч(Отбор) = Тип("Структура") И Отбор.Количество() <> 0 Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ВидыЭДПоСертификату";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Только для внутреннего использования
Процедура СохранитьПодписываемыеВидыЭД(СертификатСсылка, ПодписываемыеЭД = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПодписываемыеЭД = Неопределено Тогда
		ПодписываемыеЭД = Новый ТаблицаЗначений;
		ПодписываемыеЭД.Колонки.Добавить("СертификатЭП");
		ПодписываемыеЭД.Колонки.Добавить("ВидЭД", );
		ПодписываемыеЭД.Колонки.Добавить("Использовать");
		ВидыЭД = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.АктуальныеВидыЭД();
		Для Каждого ВидЭД Из ВидыЭД Цикл
			НовЗапись = ПодписываемыеЭД.Добавить();
			НовЗапись.СертификатЭП = СертификатСсылка;
			НовЗапись.ВидЭД = ВидЭД;
			НовЗапись.Использовать = Истина;
		КонецЦикла
	КонецЕсли;

	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПодписываемыеВидыЭД");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		НаборЗаписей = РегистрыСведений.ПодписываемыеВидыЭД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.СертификатЭП.Установить(СертификатСсылка);
		НаборЗаписей.Прочитать();
		НаборЗаписейДо = НаборЗаписей.Выгрузить();
		НаборЗаписей.Загрузить(ПодписываемыеЭД);
		НаборЗаписей.Записать();
		НаборЗаписейПосле = НаборЗаписей.Выгрузить();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти

