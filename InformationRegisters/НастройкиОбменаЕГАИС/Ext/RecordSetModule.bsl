﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		ДанныеЗаполнения = Новый Структура;
	КонецЕсли;
	
	Если ОбщегоНазначения.РазделениеВключено()
		ИЛИ ОбщегоНазначенияКлиентСервер.КлиентПодключенЧерезВебСервер() Тогда
		ОбменНаСервере = Ложь;
	Иначе
		ОбменНаСервере = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	КонецЕсли;
	
	ДанныеЗаполнения.Вставить("ОбменНаСервере", ОбменНаСервере);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли