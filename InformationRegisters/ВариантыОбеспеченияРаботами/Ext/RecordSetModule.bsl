﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
		
	КонецЕсли;
	
	// В общем случае реквизит доп. упорядочивания обновляется
	ОбновлятьРеквизитДопУпорядочивания = Истина;
	
	Если ДополнительныеСвойства.Свойство("ОбновлятьРеквизитДопУпорядочивания") Тогда
		
		ОбновлятьРеквизитДопУпорядочивания = ДополнительныеСвойства.ОбновлятьРеквизитДопУпорядочивания;
		
	КонецЕсли;
	
	// Обновление реквизита доп. упорядочивания
	Если ОбновлятьРеквизитДопУпорядочивания Тогда
	
		// Таблица значений, хранящая максимальные значения реквизита доп. упорядочивания для сочетания номенклатура, характеристика
		ЗначенияРеквизитовДопУпорядочивания = Неопределено;
		
		Если Количество() > 0 Тогда
			
			// Установка блокировки
			УстановитьБлокировку(Отбор);
			
			// Обработка записей набора
			Для каждого РегистрСведенийЗапись из ЭтотОбъект Цикл
			
				// Для записи не установлено значение реквизита доп. упорядочивания
				Если РегистрСведенийЗапись.РеквизитДопУпорядочивания = 0 Тогда
					
					РегистрСведенийЗапись.РеквизитДопУпорядочивания = НовоеЗначениеРеквизитаДопУпорядочивания(РегистрСведенийЗапись, ЗначенияРеквизитовДопУпорядочивания);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// В общем случае реквизит доп. упорядочивания обновляется
	ОбновлятьРеквизитДопУпорядочивания = Истина;
	
	Если ДополнительныеСвойства.Свойство("ОбновлятьРеквизитДопУпорядочивания") Тогда
		
		ОбновлятьРеквизитДопУпорядочивания = ДополнительныеСвойства.ОбновлятьРеквизитДопУпорядочивания;
		
	КонецЕсли;
	
	// Обновление реквизита доп. упорядочивания
	Если ОбновлятьРеквизитДопУпорядочивания Тогда
			
		ОбновитьЗначенияРеквизитаДопУпорядочивания(Отбор);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Записи.СпособОбеспеченияПотребностей КАК Справочник.СпособыОбеспеченияПотребностей) КАК СпособОбеспеченияПотребностей
	|ПОМЕСТИТЬ Записи
	|ИЗ
	|	&Записи КАК Записи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Записи.СпособОбеспеченияПотребностей.ТипОбеспечения КАК ОшибкаЗаполнения
	|ИЗ
	|	Записи КАК Записи
	|ГДЕ
	|	Записи.СпособОбеспеченияПотребностей.ТипОбеспечения     = ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.Перемещение)
	|	ИЛИ Записи.СпособОбеспеченияПотребностей.ТипОбеспечения = ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.СборкаРазборка)");
	
	Запрос.УстановитьПараметр("Записи", Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Если Выборка.ОшибкаЗаполнения = Перечисления.ТипыОбеспечения.Перемещение Тогда
			ТекстСообщения = НСтр("ru = 'Потребности в работах не обеспечиваются перемещением'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Потребности в работах не обеспечиваются сборкой/разборкой'");
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "СпособОбеспеченияПотребностей",, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция НовоеЗначениеРеквизитаДопУпорядочивания(РегистрСведенийЗапись, ЗначенияРеквизитовДопУпорядочивания)
	
	РеквизитДопУпорядочивания = 1;
	
	// Создание таблицы значений, хранящей максимальные значения реквизита доп. упорядочивания для сочетания номенклатура, характеристика
	Если ЗначенияРеквизитовДопУпорядочивания = Неопределено Тогда
		
		ЗначенияРеквизитовДопУпорядочивания = Новый ТаблицаЗначений;
		ЗначенияРеквизитовДопУпорядочивания.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
		ЗначенияРеквизитовДопУпорядочивания.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
		ЗначенияРеквизитовДопУпорядочивания.Колонки.Добавить("РеквизитДопУпорядочивания", Новый ОписаниеТипов("Число"));
		
	КонецЕсли;
	
	// Поиск значения реквизиты доп. упорядочивания
	НайденныеСтроки = ЗначенияРеквизитовДопУпорядочивания.НайтиСтроки(Новый Структура("Номенклатура, Характеристика", РегистрСведенийЗапись.Номенклатура, РегистрСведенийЗапись.Характеристика));
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		РеквизитДопУпорядочивания = НайденныеСтроки[0].РеквизитДопУпорядочивания + 1;
		НайденныеСтроки[0].РеквизитДопУпорядочивания = РеквизитДопУпорядочивания;
		
	Иначе
		
		НоваяСтрока = ЗначенияРеквизитовДопУпорядочивания.Добавить();
		
		НоваяСтрока.Номенклатура = РегистрСведенийЗапись.Номенклатура;
		НоваяСтрока.Характеристика = РегистрСведенийЗапись.Характеристика;
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВариантыОбеспеченияРаботами.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания
		|ИЗ
		|	РегистрСведений.ВариантыОбеспеченияРаботами КАК ВариантыОбеспеченияРаботами
		|ГДЕ
		|	ВариантыОбеспеченияРаботами.Номенклатура = &Номенклатура
		|	И ВариантыОбеспеченияРаботами.Характеристика = &Характеристика
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеквизитДопУпорядочивания УБЫВ");
		
		Запрос.УстановитьПараметр("Номенклатура", РегистрСведенийЗапись.Номенклатура);
		Запрос.УстановитьПараметр("Характеристика", РегистрСведенийЗапись.Характеристика);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		Если ЗначениеЗаполнено(Выборка.РеквизитДопУпорядочивания) Тогда
			
			РеквизитДопУпорядочивания = Выборка.РеквизитДопУпорядочивания + 1;
			
		КонецЕсли;
		
		НоваяСтрока.РеквизитДопУпорядочивания = РеквизитДопУпорядочивания;
		
	КонецЕсли;
		
	Возврат РеквизитДопУпорядочивания;
	
КонецФункции

Процедура ОбновитьЗначенияРеквизитаДопУпорядочивания(ПараметрыОтбора)
	
	// Установка блокировки
	УстановитьБлокировку(ПараметрыОтбора);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВариантыОбеспеченияРаботами.Номенклатура КАК Номенклатура,
	|	ВариантыОбеспеченияРаботами.Характеристика КАК Характеристика,
	|	ВариантыОбеспеченияРаботами.СпособОбеспеченияПотребностей КАК СпособОбеспеченияПотребностей,
	|	ВариантыОбеспеченияРаботами.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
	|	ВЫБОР
	|		КОГДА (ВариантыОбеспеченияРаботами.Номенклатура = &Номенклатура
	|					ИЛИ (НЕ &НоменклатураИспользование))
	|				И (ВариантыОбеспеченияРаботами.Характеристика = &Характеристика
	|					ИЛИ (НЕ &ХарактеристикаИспользование))
	|				И (ВариантыОбеспеченияРаботами.СпособОбеспеченияПотребностей = &СпособОбеспеченияПотребностей
	|					ИЛИ (НЕ &СпособОбеспеченияПотребностейИспользование))
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Приоритет
	|ИЗ
	|	РегистрСведений.ВариантыОбеспеченияРаботами КАК ВариантыОбеспеченияРаботами
	|ГДЕ
	|	(ВариантыОбеспеченияРаботами.Номенклатура = &Номенклатура
	|			ИЛИ (НЕ &НоменклатураИспользование))
	|	И (ВариантыОбеспеченияРаботами.Характеристика = &Характеристика
	|			ИЛИ (НЕ &ХарактеристикаИспользование))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	РеквизитДопУпорядочивания,
	|	Приоритет");
	
	Запрос.УстановитьПараметр("Номенклатура", ПараметрыОтбора.Номенклатура.Значение);
	Запрос.УстановитьПараметр("НоменклатураИспользование", ПараметрыОтбора.Номенклатура.Использование);
	Запрос.УстановитьПараметр("Характеристика", ПараметрыОтбора.Характеристика.Значение);
	Запрос.УстановитьПараметр("ХарактеристикаИспользование", ПараметрыОтбора.Характеристика.Использование);
	Запрос.УстановитьПараметр("СпособОбеспеченияПотребностей", ПараметрыОтбора.СпособОбеспеченияПотребностей.Значение);
	Запрос.УстановитьПараметр("СпособОбеспеченияПотребностейИспользование", ПараметрыОтбора.СпособОбеспеченияПотребностей.Использование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		ЗначениеРеквизитаДопУпорядочивания = 0;
		ПредыдущаяЗапись = Новый Структура("Номенклатура, Характеристика");
		
		// Создание набора записей
		НаборЗаписей = РегистрыСведений.ВариантыОбеспеченияРаботами.СоздатьНаборЗаписей();
		
		// Установка отборов
		НаборЗаписей.Отбор.Номенклатура.Значение = ПараметрыОтбора.Номенклатура.Значение;
		НаборЗаписей.Отбор.Номенклатура.Использование = ПараметрыОтбора.Номенклатура.Использование;
		НаборЗаписей.Отбор.Характеристика.Значение = ПараметрыОтбора.Характеристика.Значение;
		НаборЗаписей.Отбор.Характеристика.Использование = ПараметрыОтбора.Характеристика.Использование;
		
		// Установка дополнительных свойств
		НаборЗаписей.ДополнительныеСвойства.Вставить("ОбновлятьРеквизитДопУпорядочивания", Ложь);
		
		// Обработка выборки
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			// Запись не отличается от предыдущей
			Если Выборка.Номенклатура = ПредыдущаяЗапись.Номенклатура И Выборка.Характеристика = ПредыдущаяЗапись.Характеристика Тогда
				
				// Следующее значение упорядочивания
				ЗначениеРеквизитаДопУпорядочивания = ЗначениеРеквизитаДопУпорядочивания + 1;
				
			Иначе
				
				// Сохранение текущей записи
				ЗаполнитьЗначенияСвойств(ПредыдущаяЗапись, Выборка);
				ЗначениеРеквизитаДопУпорядочивания = 1;
				
			КонецЕсли;
			
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
			НоваяЗапись.РеквизитДопУпорядочивания = ЗначениеРеквизитаДопУпорядочивания;
			
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьБлокировку(ПараметрыОтбора)
	
	БлокировкаДанных = Новый БлокировкаДанных;
			
	ЭлементБлокировки = БлокировкаДанных.Добавить("РегистрСведений.ВариантыОбеспеченияРаботами");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	Если ПараметрыОтбора.Номенклатура.Использование Тогда
		
		ЭлементБлокировки.УстановитьЗначение("Номенклатура", ПараметрыОтбора.Номенклатура.Значение);
		
	КонецЕсли;
	
	Если ПараметрыОтбора.Характеристика.Использование Тогда
		
		ЭлементБлокировки.УстановитьЗначение("Характеристика", ПараметрыОтбора.Характеристика.Значение);
		
	КонецЕсли;
	
	БлокировкаДанных.Заблокировать();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли