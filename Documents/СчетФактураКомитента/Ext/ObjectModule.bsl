﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.СчетФактураКомитента.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДоходыИРасходыСервер.ОтразитьЖурналУчетаСчетовФактур(ДополнительныеСвойства, Движения, Отказ);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ Исправление Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаИсправления");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СчетаФактурыВыданные = ЭтотОбъект.Покупатели.ВыгрузитьКолонку("СчетФактураВыданный");
	РегистрыСведений.СчетаФактурыКомитентовКРегистрации.ОбновитьСостояние(СчетаФактурыВыданные);
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаСНДС = Покупатели.Итог("СуммаСНДС");
	СуммаНДС  = Покупатели.Итог("СуммаНДС");
	
	Сводный = (Покупатели.Количество() > 1);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Ответственный") Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Покупатели") Тогда
			Для каждого Строка Из ДанныеЗаполнения.Покупатели Цикл
				НоваяСтрока = Покупатели.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			КонецЦикла;
		КонецЕсли;
		ДанныеЗаполнения.Вставить("КодВидаОперации", КодВидаОперации());
		
	КонецЕсли;
	
	ЗаполнитьИННКППКонтрагентов(ДанныеЗаполнения);
	
КонецПроцедуры

Функция КодВидаОперации()
	
	ВерсияКодовВидовОпераций = УчетНДСКлиентСервер.ВерсияКодовВидовОпераций(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	КодВидаОперации = ?(ВерсияКодовВидовОпераций = 3, "01", "04");
	
	Если Покупатели.Количество() > 1 Тогда
		КодВидаОперации = "27";
	КонецЕсли;
	
	Возврат КодВидаОперации;
	
КонецФункции

Процедура ЗаполнитьИННКППКонтрагентов(ДанныеЗаполнения)
	
	КомитентДанныхЗаполнения = Неопределено;
	ДатаСоставленияДанныхЗаполнения = ТекущаяДатаСеанса();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("Комитент")
		И ЗначениеЗаполнено(ДанныеЗаполнения.Комитент)
		И ТипЗнч(ДанныеЗаполнения.Комитент) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		КомитентДанныхЗаполнения = ДанныеЗаполнения.Комитент;
		
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("ДатаСоставления") Тогда
		
		ДатаСоставленияДанныхЗаполнения = ДанныеЗаполнения.ДатаСоставления;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КомитентДанныхЗаполнения) Тогда
		РеквизитыКомитента = Справочники.Контрагенты.РеквизитыКонтрагента(КомитентДанныхЗаполнения, ДатаСоставленияДанныхЗаполнения);
		ИННКомитента = РеквизитыКомитента.ИНН;
		КППКомитента = РеквизитыКомитента.КПП;
	КонецЕсли;
	
	МассивСубкомиссионеров = Новый Массив;
	Для Каждого СтрокаПокупатели Из Покупатели Цикл
		
		Если ЗначениеЗаполнено(СтрокаПокупатели.Субкомиссионер)
			И ТипЗнч(СтрокаПокупатели.Субкомиссионер) = Тип("СправочникСсылка.Контрагенты") Тогда
			
			МассивСубкомиссионеров.Добавить(СтрокаПокупатели.Субкомиссионер);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивСубкомиссионеров.Количество() > 0 Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	МАКСИМУМ(ИсторияКППКонтрагентов.Период) КАК Период,
		|	ИсторияКППКонтрагентов.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ЗначенияКПП
		|ИЗ
		|	Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
		|ГДЕ
		|	ИсторияКППКонтрагентов.Ссылка  В (&МассивКонтрагентов)
		|	И ИсторияКППКонтрагентов.Период <= &ДатаСведений
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсторияКППКонтрагентов.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	ИсторияКППКонтрагентов.КПП КАК КПП,
		|	ИсторияКППКонтрагентов.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ИсторическоеЗначениеКПП
		|ИЗ
		|	ЗначенияКПП КАК ЗначенияКПП
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
		|		ПО ЗначенияКПП.Ссылка = ИсторияКППКонтрагентов.Ссылка
		|			И ЗначенияКПП.Период = ИсторияКППКонтрагентов.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ИсторическоеЗначениеКПП.КПП, Контрагенты.КПП) КАК КПП,
		|	Контрагенты.ИНН                                        КАК ИНН,
		|	Контрагенты.Ссылка                                     КАК Контрагент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеКПП КАК ИсторическоеЗначениеКПП
		|			ПО ИсторическоеЗначениеКПП.Ссылка = Контрагенты.Ссылка
		|ГДЕ
		|	Контрагенты.Ссылка  В (&МассивКонтрагентов)
		|";
		
		Запрос.УстановитьПараметр("МассивКонтрагентов", МассивСубкомиссионеров);
		Запрос.УстановитьПараметр("ДатаСведений", ДатаСоставленияДанныхЗаполнения);
		
		СоотвествиеКонтрагентов = Новый Соответствие;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ДанныеКонтрагента = Новый Структура("ИННСубкомиссионера, КППСубкомиссионера");
			ДанныеКонтрагента.ИННСубкомиссионера = Выборка.ИНН;
			ДанныеКонтрагента.КППСубкомиссионера = Выборка.КПП;
			
			СоотвествиеКонтрагентов.Вставить(Выборка.Контрагент, ДанныеКонтрагента);
			
		КонецЦикла;
		
		Для Каждого СтрокаПокупатели Из Покупатели Цикл
			
			Если ЗначениеЗаполнено(СтрокаПокупатели.Субкомиссионер)
				И ТипЗнч(СтрокаПокупатели.Субкомиссионер) = Тип("СправочникСсылка.Контрагенты") Тогда
				
				ДанныеКонтрагента = СоотвествиеКонтрагентов.Получить(СтрокаПокупатели.Субкомиссионер);
				Если ДанныеКонтрагента <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(СтрокаПокупатели, ДанныеКонтрагента);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
