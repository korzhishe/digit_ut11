﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);

	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	// Строковые литералы
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаПрочие", НСтр("ru='Прочие'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаУдовлетворено", НСтр("ru='Удовлетворено'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СтрокаНеУдовлетворено", НСтр("ru='Не удовлетворено'"));
КонецПроцедуры

#КонецОбласти 

#КонецЕсли