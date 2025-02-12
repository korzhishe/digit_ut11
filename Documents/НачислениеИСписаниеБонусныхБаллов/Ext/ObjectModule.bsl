﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ВидПравилаОбъекта = Неопределено;
	Если ЗначениеЗаполнено(ПравилоНачисления) Тогда
		ВидПравилаОбъекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПравилоНачисления, "ВидПравила");
	Иначе
		ВидПравилаОбъекта = ВидПравила;
	КонецЕсли;
	
	Если ВидПравилаОбъекта = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление Тогда
		Списание.Очистить();
	Иначе
		Начисление.Очистить();
	КонецЕсли;
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВидПравилаОбъекта = Неопределено;
	Если ЗначениеЗаполнено(ПравилоНачисления) Тогда
		ВидПравилаОбъекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПравилоНачисления, "ВидПравила");
		МассивНепроверяемыхРеквизитов.Добавить("ВидПравила");
	Иначе
		ВидПравилаОбъекта = ВидПравила;
	КонецЕсли;
	
	Если ВидПравилаОбъекта = Перечисления.ВидыПравилНачисленияБонусныхБаллов.Начисление Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Списание");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Начисление");
	КонецЕсли;
	
	// Проверка выполняется в форме
	МассивНепроверяемыхРеквизитов.Добавить("ПравилоНачисления");
	МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончанияСрокаДействия");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.НачислениеИСписаниеБонусныхБаллов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СкидкиНаценкиСервер.ОтразитьБонусныеБаллы(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Процедура формирует список регистров для контроля.
//
Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.БонусныеБаллы);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
