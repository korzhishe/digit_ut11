﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ДоговорыКредитовИДепозитов") Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКредитовИДепозитов");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		
		ДоговорыКредитовИДепозитов = ТипЗначения.СодержитТип(Тип("СправочникСсылка.ДоговорыКредитовИДепозитов"));
		
		Если Не ПустаяСтрока(КорреспондирующийСчет) Тогда
			Если ПустаяСтрока(СтрЗаменить(КорреспондирующийСчет, ".", "")) Тогда
				КорреспондирующийСчет = "";
			ИначеЕсли Прав(СокрЛП(КорреспондирующийСчет), 1) = "." Тогда
				КорреспондирующийСчет = Лев(СокрЛП(КорреспондирующийСчет), СтрДлина(СокрЛП(КорреспондирующийСчет)) - 1);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#КонецЕсли
