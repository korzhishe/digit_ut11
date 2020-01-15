﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;

	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
		
	
	Если ЭтоГруппа Тогда
		
		Возврат;
		
	КонецЕсли;
	
	МассивИмен = СтрРазделить(ИмяШаблонаСКД, ".", Ложь);
	Если МассивИмен.Количество() = 3 Тогда
		
		СхемаКомпоновкиДанных = Новый ХранилищеЗначения(Неопределено);
		
	ИначеЕсли ТипЗнч(СхемаКомпоновкиДанных.Получить()) <> Тип("СхемаКомпоновкиДанных") Тогда
		
		СхемаКомпоновкиДанных = Новый ХранилищеЗначения(Новый СхемаКомпоновкиДанных);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяШаблонаСКД) И ВерсияШаблонаСКД = 0 Тогда
	
		ВерсияШаблонаСКД = Справочники.ИсточникиДанныхПланирования.ТекущаяВерсияШаблоновСКД();
		
	ИначеЕсли НЕ ЗначениеЗаполнено(ИмяШаблонаСКД) Тогда
		
		ВерсияШаблонаСКД = 0;
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли