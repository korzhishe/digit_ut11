﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбработчикОповещения = Новый ОписаниеОповещения("СформироватьПодписатьОтправитьЭД", ОбменСКонтрагентамиКлиент);
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ПараметрКоманды", ПараметрКоманды);
	ДополнительныеПараметры.Вставить("Обработчик", ОбработчикОповещения);
	ДополнительныеПараметры.Вставить("Источник", ПараметрыВыполненияКоманды.Источник);
	
	Если ПараметрКоманды.Количество() > 1 Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеВопросаПользователю", ЭтотОбъект, ДополнительныеПараметры);
		
		ТекстВопроса = НСтр("ru = 'Отправить электронные документы выделенных элементов?
			|Если электронных документов нет, они будут созданы автоматически.'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		
		ВыполнитьПроверкуПроведенияДокументов(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВопросаПользователю(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ВыполнитьПроверкуПроведенияДокументов(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверкуПроведенияДокументов(ДополнительныеПараметры)
	
	ЭлектронноеВзаимодействиеКлиентПереопределяемый.ВыполнитьПроверкуПроведенияДокументов(ДополнительныеПараметры.ПараметрКоманды,
		ДополнительныеПараметры.Обработчик, ДополнительныеПараметры.Источник);
		
КонецПроцедуры

#КонецОбласти

