﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ДанныеЗаполнения.Свойство("Организация",		Организация);
		ДанныеЗаполнения.Свойство("Поставщик",			Поставщик);
		ДанныеЗаполнения.Свойство("ДокументОснование",	СчетФактура);
		
		Документы.СписаниеНДСНаРасходы.ЗаполнитьСписаниеНДСНаРасходы(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект, , МассивНепроверяемыхРеквизитов, Отказ);
	
	Если Не Отказ Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.СписаниеНДСНаРасходы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДоходыИРасходыСервер.ОтразитьНДСПредъявленный(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
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
	
	Для каждого Строка Из Ценности Цикл
		Если НЕ ЗначениеЗаполнено(Строка.РеализацияЭкспорт) И Строка.РеализацияЭкспорт <> Неопределено Тогда
			Строка.РеализацияЭкспорт = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	СуммаНДС = Ценности.Итог("НДС");
	СуммаНДСУпр = Ценности.Итог("НДСУпр");
	СуммаБезНДС = Ценности.Итог("СуммаБезНДС");
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Ценности.Очистить();
	СуммаБезНДС = 0;
	СуммаНДС    = 0;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
