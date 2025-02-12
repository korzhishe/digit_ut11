﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПрефиксИдентификатора = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РежимОтладкиЕГАИС", "ПрефиксИдентификатора", "");
	СообщатьОбОшибкахПриЗагрузкеДанных = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РежимОтладкиЕГАИС", "СообщатьОбОшибкахПриЗагрузкеДанных", Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаСервере();
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьНаСервере()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"РежимОтладкиЕГАИС", "ПрефиксИдентификатора", ПрефиксИдентификатора);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"РежимОтладкиЕГАИС", "СообщатьОбОшибкахПриЗагрузкеДанных", СообщатьОбОшибкахПриЗагрузкеДанных);
	
КонецПроцедуры

#КонецОбласти
