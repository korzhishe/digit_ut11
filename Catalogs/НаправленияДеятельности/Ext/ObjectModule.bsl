﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус.Пустая() Тогда
		Статус = Перечисления.СтатусыНаправленияДеятельности.Используется;
	КонецЕсли;
	
	ШаблонНазначения = Справочники.НаправленияДеятельности.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПроверитьЗаполнитьПередЗаписью(Назначение, ШаблонНазначения, ЭтотОбъект, "УчетЗатрат", Отказ, Истина, Не УчетЗатрат);
	
	ДополнительныеСвойства.Вставить("ОбновитьНазначение",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ДопускаетсяОбособлениеСверхПотребности") <> ЭтотОбъект.ДопускаетсяОбособлениеСверхПотребности);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонНазначения = Справочники.НаправленияДеятельности.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПриЗаписиСправочника(Назначение, ШаблонНазначения, ЭтотОбъект, ДополнительныеСвойства.ОбновитьНазначение);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Запись подчиненной константы.
	ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ЭтоГруппа Тогда
		Назначение = Справочники.Назначения.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли