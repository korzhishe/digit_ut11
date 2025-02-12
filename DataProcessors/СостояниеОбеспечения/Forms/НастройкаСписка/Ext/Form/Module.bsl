﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КомпоновщикНастроек = Параметры.КомпоновщикНастроек;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)

	ОчиститьСообщения();
	Если ОбеспечениеКлиентСервер.ПроверитьПересечениеНастроек(КомпоновщикНастроек) Тогда

		ОповеститьОвыборе(КомпоновщикНастроек.ПользовательскиеНастройки);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти
