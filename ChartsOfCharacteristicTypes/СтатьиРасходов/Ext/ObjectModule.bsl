﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
	 И ДанныеЗаполнения.Свойство("ВариантРаспределенияРасходовРегл") Тогда
	 
		Если ДанныеЗаполнения.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Склады");
		ИначеЕсли ДанныеЗаполнения.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаПрочиеАктивы Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ПрочиеРасходы");
			
		КонецЕсли;
	 
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ДоговорыКредитовИДепозитов") Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКредитовИДепозитов");
			ТипРасходов = Перечисления.ТипыРасходов.ПрочиеРасходы;
	КонецЕсли;
	
	Если ТипЗначения.Типы().Количество() > 1 Тогда
		ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Склады");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Предопределенный Тогда
		
		ПроверяемыеСтатьи = Новый Массив;
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.КурсовыеРазницы);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.НачисленныйНДСПриВыкупеМногооборотнойТары);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.ПрибыльУбытокПрошлыхЛет);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.РазницыСтоимостиВозвратаИФактическойСтоимостиТоваров);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.СебестоимостьПродаж);
		ПроверяемыеСтатьи.Добавить(ПланыВидовХарактеристик.СтатьиРасходов.ФормированиеРезервовПоСомнительнымДолгам);
		Если ПроверяемыеСтатьи.Найти(Ссылка) <> Неопределено Тогда
			Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности Тогда
				ТекстСообщения = НСтр("ru = 'Необходимо выбрать вариант распределения в регл. учете ""На направления деятельности""'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ВариантРаспределенияРасходовРегл",
					,
					Отказ);
			КонецЕсли;
			Если ВариантРаспределенияРасходовУпр <> Перечисления.ВариантыРаспределенияРасходов.ПустаяСсылка()
			 И ВариантРаспределенияРасходовУпр <> Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности Тогда
				ТекстСообщения = НСтр("ru = 'Необходимо выбрать вариант распределения в упр. учете ""На направления деятельности""'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ВариантРаспределенияРасходовУпр",
					,
					Отказ);
			КонецЕсли;	
		КонецЕсли;
			
		Если Ссылка = ПланыВидовХарактеристик.СтатьиРасходов.НДСНалоговогоАгента
			И ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
			
			ТекстСообщения = НСтр("ru = 'Необходимо выбрать вариант распределения ""На себестоимость товаров""'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,
				ЭтотОбъект,
				"ВариантРаспределенияРасходовРегл",
				,
				Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров
	 И ВариантРаспределенияРасходовУпр <> Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияНаСебестоимость");
	КонецЕсли;
	
	Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты
	 И ВариантРаспределенияРасходовУпр <> Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияПоЭтапамПроизводства");
		МассивНепроверяемыхРеквизитов.Добавить("ПравилоРаспределенияПоПодразделениям");
		МассивНепроверяемыхРеквизитов.Добавить("ХарактерПроизводственныхЗатрат");
	КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		ВариантРаспределенияРасходов = ВариантРаспределенияРасходовРегл;
		
		Если ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности 
			И ВариантРаспределенияРасходовРегл <> Перечисления.ВариантыРаспределенияРасходов.НеРаспределять Тогда
			
			ВидДеятельностиРасходов = Перечисления.ВидыДеятельностиРасходов.ОсновнаяДеятельность;
			
		КонецЕсли;
			
		Если ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров Тогда
			ВидЦенностиНДС = Перечисления.ВидыЦенностей.Товары;
		Иначе
			ВидЦенностиНДС = Перечисления.ВидыЦенностей.ПрочиеРаботыИУслуги;
		КонецЕсли;
		
		ПрочиеРасходы = ТипЗначения.СодержитТип(Тип("СправочникСсылка.ПрочиеРасходы"));
		ДоговорыКредитовИДепозитов = ТипЗначения.СодержитТип(Тип("СправочникСсылка.ДоговорыКредитовИДепозитов"));
		
		Если Не ПустаяСтрока(КорреспондирующийСчет) Тогда
			Если ПустаяСтрока(СтрЗаменить(КорреспондирующийСчет, ".", "")) Тогда
				КорреспондирующийСчет = "";
			Иначе
				Пока Прав(СокрЛП(КорреспондирующийСчет), 1) = "." Цикл
					КорреспондирующийСчет = Лев(СокрЛП(КорреспондирующийСчет), СтрДлина(СокрЛП(КорреспондирующийСчет)) - 1);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ОграничитьИспользование
			И ДоступныеХозяйственныеОперации.Количество() > 0 Тогда
			
			ДоступныеХозяйственныеОперации.Очистить();
			ДоступныеОперации = "";
		Иначе
			СписокОпераций = Новый СписокЗначений;
			ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьСписокХозяйственныхОпераций(
				СписокОпераций,
				ВариантРаспределенияРасходовУпр,
				ВариантРаспределенияРасходовРегл);
			СтрокаДоступныеОперации = "";
			Для Каждого СтрокаТаблицы Из ДоступныеХозяйственныеОперации Цикл
				ЭлементСписка = СписокОпераций.НайтиПоЗначению(СтрокаТаблицы.ХозяйственнаяОперация);
				Если ЭлементСписка <> Неопределено Тогда
					СтрокаДоступныеОперации = СтрокаДоступныеОперации
						+ ?(Не ПустаяСтрока(СтрокаДоступныеОперации), ", ", "")
						+ ЭлементСписка.Представление;
				КонецЕсли;
			КонецЦикла;
			Если ДоступныеОперации <> СтрокаДоступныеОперации Тогда
				ДоступныеОперации = СтрокаДоступныеОперации;
			КонецЕсли;
		КонецЕсли;
		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
