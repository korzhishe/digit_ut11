﻿#Область ПрограммныйИнтерфейс

// Получает документы основания акта приемки со стороны клиента
//
// Параметры:
//  АктПриемки  - ДокументСсылка.АктПриемкиСоСтороныКлиента - документ, для которого получаются основания
//
// Возвращаемое значение:
//   Массив   - массив, который содержит документы "Реализация товаров и услуг", которые являются основаниями.
//
Функция ДокументыОснованияАктаПриемкиСоСтороныКлиента(АктПриемки) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АктОРасхожденияхПослеОтгрузкиТовары.Реализация
	|ИЗ
	|	Документ.АктОРасхожденияхПослеОтгрузки.Товары КАК АктОРасхожденияхПослеОтгрузкиТовары
	|ГДЕ
	|	АктОРасхожденияхПослеОтгрузкиТовары.Ссылка = &АктПриемки";
	
	Запрос.УстановитьПараметр("АктПриемки", АктПриемки);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Реализация");

КонецФункции 

#КонецОбласти
