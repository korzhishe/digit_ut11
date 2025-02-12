﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);

	НоваяЗапись =  Параметры.Ключ.Пустой();
	
	Если НоваяЗапись Тогда
		Запись.Пользователь     = Параметры.Пользователь;
		Запись.ОткрываемаяФорма = Параметры.ОткрываемаяФорма;
		
		ПриЧтенииСозданииНаСервере();		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриЧтенииСозданииНаСервере();		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	СтруктураИзмерений = Новый Структура;
	СтруктураИзмерений.Вставить("Пользователь", Запись.Пользователь);
	СтруктураИзмерений.Вставить("ОткрываемаяФорма", Запись.ОткрываемаяФорма);
	
	Оповестить("Запись_НастройкиОткрытияФормПриНачалеРаботыСистемы", ПараметрыЗаписи, СтруктураИзмерений);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	СтруктураПараметровФормы = ОткрытиеФормПриНачалеРаботыСистемыКлиентСерверПереопределяемый.НастройкиФормы(Запись.ОткрываемаяФорма);
	ПараметрЗапуска = СтруктураПараметровФормы.ПараметрЗапуска;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
