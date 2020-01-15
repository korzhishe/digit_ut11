﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Удаляет из регистра сведений РегистрацииВНалоговомОргане записи, которые стали
//	некорректными после изменения организации в элементе справочника РегистрацииВНалоговомОргане
//
//	Параметры:
//		РегистрацияВНалоговомОргане - СправочникОбъект.РегистрацииВНалоговомОргане - регистрация в налоговом органе,
//			для которой необходимо выполнить актуализацию
//
Процедура АктуализироватьСоставРегистрацииВНалоговомОргане(РегистрацияВНалоговомОргане) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрацииВНалоговомОргане.Подразделение,
	|	РегистрацииВНалоговомОргане.Организация
	|ИЗ
	|	РегистрСведений.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
	|ГДЕ
	|	РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане = &Ссылка
	|	И РегистрацииВНалоговомОргане.Организация.ГоловнаяОрганизация <> &Владелец";
	
	Запрос.УстановитьПараметр("Ссылка",   РегистрацияВНалоговомОргане.Ссылка);
	Запрос.УстановитьПараметр("Владелец", РегистрацияВНалоговомОргане.Владелец);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		Запись = РегистрыСведений.РегистрацииВНалоговомОргане.СоздатьМенеджерЗаписи();
		Запись.Организация = Выборка.Организация;
		Запись.Подразделение = Выборка.Подразделение;
		
		Запись.Удалить();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли