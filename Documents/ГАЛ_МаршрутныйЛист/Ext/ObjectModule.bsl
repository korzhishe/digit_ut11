﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
			//Ответственный	 
	Если Не ЗначениеЗаполнено(Автор) Тогда
		Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ГАЛ_Маршруты
	Движения.ГАЛ_Маршруты.Записывать = Истина;
	Для Каждого ТекСтрокаЗаказыНаДоставку Из ЗаказыНаДоставку Цикл
		Движение = Движения.ГАЛ_Маршруты.Добавить();
		Движение.Период = Дата;
		Движение.ЗаказНаДоставку  = ТекСтрокаЗаказыНаДоставку.ЗаказНаДоставку;
		Движение.ДатаДоставки     = ДатаДоставки;
		Движение.КурьерЭкспедитор = КурьерЭкспедитор;
		Движение.ПорядковыйНомер  = ТекСтрокаЗаказыНаДоставку.НомерСтроки;
		Движение.СтатусМаршрута   = СтатусМаршрута;
		Движение.Широта           = ТекСтрокаЗаказыНаДоставку.Широта;
		Движение.Долгота          = ТекСтрокаЗаказыНаДоставку.Долгота;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
