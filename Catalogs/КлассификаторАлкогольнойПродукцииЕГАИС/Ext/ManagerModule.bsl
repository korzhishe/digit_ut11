﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыСправочника(
		"КлассификаторАлкогольнойПродукцииЕГАИС",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти