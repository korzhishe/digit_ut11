﻿
#Область ПрограммныйИнтерфейс

// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды.
//
Функция ПоддержкаАсинхронногоРежима() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Функция осуществляет подключение устройства.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	ВыходныеПараметры = Новый Массив();
	ПараметрыПодключения.Вставить("ИДУстройства", Неопределено);

	// Проверка настроенных параметров.
	Порт       = Неопределено;
	Скорость   = Неопределено;
	Четность   = Неопределено;
	БитыДанных = Неопределено;
	СтопБиты   = Неопределено;
	
	Параметры.Свойство("Порт",         Порт);
	Параметры.Свойство("Скорость",     Скорость);
	Параметры.Свойство("Четность",     Четность);
	Параметры.Свойство("БитыДанных",   БитыДанных);
	Параметры.Свойство("СтопБиты",     СтопБиты);         

	Если Порт              = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;

	МассивЗначений = Новый Массив;
	МассивЗначений.Добавить(Порт);
	МассивЗначений.Добавить(Скорость);
	МассивЗначений.Добавить(Четность);
	МассивЗначений.Добавить(БитыДанных);
	МассивЗначений.Добавить(СтопБиты);
	
	Если Результат Тогда
		Ответ = ОбъектДрайвера.Подключить(МассивЗначений, ПараметрыПодключения.ИДУстройства);
		Если НЕ Ответ Тогда
			Результат = Ложь;
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1])
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	ОбъектДрайвера.Отключить(ПараметрыПодключения.ИДУстройства);

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Вывод строк на дисплей
	Если Команда = "ВывестиСтрокуНаДисплейПокупателя" ИЛИ Команда = "DisplayText" Тогда
		СтрокаТекста = ВходныеПараметры[0];
		Результат = ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры);

	// Очистка дисплея
	ИначеЕсли Команда = "ОчиститьДисплейПокупателя" ИЛИ Команда = "ClearText" Тогда
		Результат = ОчиститьДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Тестирование устройства
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Получить параметры вывода
	ИначеЕсли Команда = "ПолучитьПараметрыВывода" ИЛИ Команда = "GetOutputOptions" Тогда
		Результат = ПолучитьПараметрыВывода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" ИЛИ Команда = "GetOutputOptions" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Указанная команда не поддерживается данным драйвером.
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция осуществляет вывод списка строк на дисплей покупателя.
//
Функция ВывестиСтрокуНаДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры)

	Результат = Истина;

	МассивСтрок = Новый Массив();
	МассивСтрок.Добавить(МенеджерОборудованияКлиентСервер.ПостроитьПоле(СтрПолучитьСтроку(СтрокаТекста, 1), 20));
	МассивСтрок.Добавить(МенеджерОборудованияКлиентСервер.ПостроитьПоле(СтрПолучитьСтроку(СтрокаТекста, 2), 20));

	Ответ = ОбъектДрайвера.ВывестиСтрокуНаДисплейПокупателя(ПараметрыПодключения.ИДУстройства, МассивСтрок);

	Если Не Ответ Тогда
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет очистку дисплея покупателя.
//
Функция ОчиститьДисплейПокупателя(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Ответ = ОбъектДрайвера.ОчиститьДисплейПокупателя(ПараметрыПодключения.ИДУстройства);
	Если Не Ответ Тогда
		Результат = Ложь;
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция возвращает параметры вывода на дисплей покупателя).
Функция ПолучитьПараметрыВывода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	ВыходныеПараметры.Очистить();  
	ВыходныеПараметры.Добавить(20);
	ВыходныеПараметры.Добавить(2);
		
	Возврат Результат;

КонецФункции

// Функция осуществляет тестирование устройства.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	РезультатТеста = "";
	
	МассивЗначений = Новый Массив;
	МассивЗначений.Добавить(Параметры.Порт);
	МассивЗначений.Добавить(Параметры.Скорость);
	МассивЗначений.Добавить(Параметры.Четность);
	МассивЗначений.Добавить(Параметры.БитыДанных);
	МассивЗначений.Добавить(Параметры.СтопБиты);
	                                                   
	Результат = ОбъектДрайвера.ТестУстройства(МассивЗначений, РезультатТеста);
	
	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	ВыходныеПараметры.Добавить(РезультатТеста);
	
	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера.
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;
	
	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));
	
	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
		Результат = Ложь;
	КонецПопытки;

	Возврат Результат;

КонецФункции

#КонецОбласти