﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ФормироватьРабочееНаименование =		Не (ДополнительныеСвойства.Свойство("РабочееНаименованиеСформировано"));
	ФормироватьНаименованиеДляПечати =		Не (ДополнительныеСвойства.Свойство("НаименованиеДляПечатиСформировано"));
	
	Если ФормироватьРабочееНаименование
		Или ФормироватьНаименованиеДляПечати Тогда
		
		СтруктураРеквизитов = Новый Структура;
		
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
			СтруктураРеквизитов.Вставить("ШаблонРабочегоНаименованияХарактеристики");
			СтруктураРеквизитов.Вставить("ЗапретРедактированияРабочегоНаименованияХарактеристики");
			СтруктураРеквизитов.Вставить("ШаблонНаименованияДляПечатиХарактеристики");
			СтруктураРеквизитов.Вставить("ЗапретРедактированияНаименованияДляПечатиХарактеристики");
		Иначе 
			СтруктураРеквизитов.Вставить("ШаблонРабочегоНаименованияХарактеристики","ВидНоменклатуры.ШаблонРабочегоНаименованияХарактеристики");
			СтруктураРеквизитов.Вставить("ЗапретРедактированияРабочегоНаименованияХарактеристики","ВидНоменклатуры.ЗапретРедактированияРабочегоНаименованияХарактеристики");
			СтруктураРеквизитов.Вставить("ШаблонНаименованияДляПечатиХарактеристики","ВидНоменклатуры.ШаблонНаименованияДляПечатиХарактеристики");
			СтруктураРеквизитов.Вставить("ЗапретРедактированияНаименованияДляПечатиХарактеристики","ВидНоменклатуры.ЗапретРедактированияНаименованияДляПечатиХарактеристики");
		КонецЕсли;
	
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, СтруктураРеквизитов);
		
		Если ФормироватьРабочееНаименование 
			И ЗначениеЗаполнено(РеквизитыОбъекта.ШаблонРабочегоНаименованияХарактеристики) 
			И (РеквизитыОбъекта.ЗапретРедактированияРабочегоНаименованияХарактеристики 
			Или Не ЗначениеЗаполнено(Наименование)) Тогда
			ШаблонНаименования = РеквизитыОбъекта.ШаблонРабочегоНаименованияХарактеристики;
			Наименование = НоменклатураСервер.НаименованиеПоШаблону(ШаблонНаименования, ЭтотОбъект);
		КонецЕсли;
		
		Если ФормироватьНаименованиеДляПечати
			И ЗначениеЗаполнено(РеквизитыОбъекта.ШаблонНаименованияДляПечатиХарактеристики) 
			И (РеквизитыОбъекта.ЗапретРедактированияНаименованияДляПечатиХарактеристики 
			Или Не ЗначениеЗаполнено(НаименованиеПолное)) Тогда
			ШаблонНаименованияДляПечати = РеквизитыОбъекта.ШаблонНаименованияДляПечатиХарактеристики;
			НаименованиеПолное = НоменклатураСервер.НаименованиеПоШаблону(ШаблонНаименованияДляПечати, ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		ТекстИсключения = НСтр("ru='Поле ""Рабочее наименование"" не заполнено'");
		ВызватьИсключение ТекстИсключения; 
		Отказ = Истина;
	КонецЕсли;
	
	КонтролироватьРабочееНаименование = Константы.КонтролироватьУникальностьРабочегоНаименованияНоменклатурыИХарактеристик.Получить()
	И Не (ДополнительныеСвойства.Свойство("РабочееНаименованиеПроверено"));
	
	Если КонтролироватьРабочееНаименование
		И Не Отказ Тогда
		Если Не Справочники.ХарактеристикиНоменклатуры.РабочееНаименованиеУникально(ЭтотОбъект) Тогда
			ТекстИсключения = НСтр("ru='Значение поля ""Рабочее наименование"" не уникально'");
			ВызватьИсключение ТекстИсключения; 
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Обработка смены пометки удаления.
	Если Не ЭтоНовый() Тогда

		Если ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления") Тогда
			Справочники.КлючиАналитикиУчетаНоменклатуры.УстановитьПометкуУдаления(Новый Структура("Характеристика", Ссылка), ПометкаУдаления);
		КонецЕсли;

	КонецЕсли;
		
	Если ЗначениеЗаполнено(Принципал)
		И ТипЗнч(Принципал) = Тип("СправочникСсылка.Организации") Тогда
		Контрагент = Принципал;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Характеристика = &Характеристика";
	
	Запрос.УстановитьПараметр("Характеристика", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Штрихкод.Значение = Выборка.Штрихкод;
		НаборЗаписей.Отбор.Штрихкод.Использование = Истина;
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры // ПередУдалением()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Наименование");
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		ЗапрашиваемыеРеквизиты = Новый Структура;
		ЗапрашиваемыеРеквизиты.Вставить("ОсобенностьУчета");
		ЗапрашиваемыеРеквизиты.Вставить("ТипНоменклатуры");
		
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
			ЗапрашиваемыеРеквизиты.Вставить("ВариантОказанияУслуг", "ВидНоменклатуры.ВариантОказанияУслуг");
		Иначе
			ЗапрашиваемыеРеквизиты.Вставить("ВариантОказанияУслуг", "ВариантОказанияУслуг");
		КонецЕсли;
		
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, ЗапрашиваемыеРеквизиты);
		
		Если РеквизитыОбъекта.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.КиЗГИСМ
			И ЗначениеЗаполнено(КиЗГИСМGTIN)
			И Не МенеджерОборудованияКлиентСервер.ПроверитьКорректностьGTIN(КиЗГИСМGTIN) Тогда
			ТекстСообщения = НСтр("ru = 'Указан некорректный GTIN.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "КиЗГИСМGTIN", "Объект", Отказ);
		КонецЕсли;
		
		Если РеквизитыОбъекта <> Перечисления.ТипыНоменклатуры.Услуга
			Или РеквизитыОбъекта.ВариантОказанияУслуг = Перечисления.ВариантыОказанияУслуг.ОрганизациейПродавцом Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Принципал");
		КонецЕсли;
		
		Если РеквизитыОбъекта <> Перечисления.ТипыНоменклатуры.Услуга
			Или РеквизитыОбъекта.ВариантОказанияУслуг <> Перечисления.ВариантыОказанияУслуг.Партнером Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		КонецЕсли;
		
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Принципал");
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

#КонецОбласти

#КонецЕсли