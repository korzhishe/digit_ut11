﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура УстановитьАктивность() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТоварыОрганизаций.Регистратор КАК Регистратор,
	|	ТоварыОрганизаций.Регистратор.Дата КАК Дата
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрганизаций
	|ГДЕ
	|	Не ТоварыОрганизаций.Активность
	|	
	|УПОРЯДОЧИТЬ ПО
	|	ТоварыОрганизаций.Регистратор.Дата Возр,
	|	ТоварыОрганизаций.Регистратор 
	|");
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыНакопления.ТоварыОрганизаций.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
		НаборЗаписей.Прочитать();
		НаборЗаписей.УстановитьАктивность(Истина);
		НаборЗаписей.Записывать = Истина;
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли