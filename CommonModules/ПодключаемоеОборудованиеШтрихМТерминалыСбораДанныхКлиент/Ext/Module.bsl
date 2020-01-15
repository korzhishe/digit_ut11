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
// Параметры:
//  ОбъектДрайвера   - <*>
//           - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	ПараметрыПодключения.Вставить("ИДУстройства", "");

	ВыходныеПараметры = Новый Массив();

	// Проверка параметров устройства.
	Порт            = Неопределено;
	Скорость        = Неопределено;
	Таймаут         = Неопределено;
	Четность        = Неопределено;
	БитыДанных      = Неопределено;
	СтопБиты        = Неопределено;
	ТаблицаВыгрузки = Неопределено;
	ТаблицаЗагрузки = Неопределено;
	ФорматВыгрузки  = Неопределено;
	ФорматЗагрузки = Неопределено;
	Модель          = Неопределено;
	Наименование    = Неопределено;

	Параметры.Свойство("Порт"           , Порт);
	Параметры.Свойство("Скорость"       , Скорость);
	Параметры.Свойство("Таймаут"        , Таймаут);
	Параметры.Свойство("Четность"       , Четность);
	Параметры.Свойство("БитыДанных"     , БитыДанных);
	Параметры.Свойство("СтопБиты"       , СтопБиты);
	Параметры.Свойство("ТаблицаВыгрузки", ТаблицаВыгрузки);
	Параметры.Свойство("ТаблицаЗагрузки", ТаблицаЗагрузки);
	Параметры.Свойство("ФорматВыгрузки" , ФорматВыгрузки);
	Параметры.Свойство("ФорматЗагрузки" , ФорматЗагрузки);
	Параметры.Свойство("Модель"         , Модель);

	Если Порт            = Неопределено
	 Или Скорость        = Неопределено
	 Или Таймаут         = Неопределено
	 Или Четность        = Неопределено
	 Или БитыДанных      = Неопределено
	 Или СтопБиты        = Неопределено
	 Или ТаблицаВыгрузки = Неопределено
	 Или ТаблицаЗагрузки = Неопределено
	 Или ФорматВыгрузки  = Неопределено
	 Или ФорматЗагрузки  = Неопределено
	 Или Модель          = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;

	Если Результат Тогда
		ОбъектДрайвера.ДобавитьУстройство();
		Если ОбъектДрайвера.КодОшибки = 0 Тогда
			ПараметрыПодключения.ИДУстройства    = ОбъектДрайвера.НомерТекущегоУстройства;
			ОбъектДрайвера.НомерПорта            = Параметры.Порт;
			ОбъектДрайвера.СкоростьОбмена        = Параметры.Скорость;
			ОбъектДрайвера.Таймаут               = Параметры.Таймаут;
			ОбъектДрайвера.Четность              = Параметры.Четность;
			ОбъектДрайвера.БитыДанных            = Параметры.БитыДанных;
			ОбъектДрайвера.СтопБиты              = Параметры.СтопБиты;
			ОбъектДрайвера.ИмяТекущегоУстройства = Параметры.Модель;

			ОбъектДрайвера.УстройствоВключено = 1;
			Если ОбъектДрайвера.Результат <> 0 Тогда
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);
				ОбъектДрайвера.УдалитьУстройство();

				Результат = Ложь;
			КонецЕсли;
		Иначе
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
// Параметры:
//  ОбъектДрайвера - <*>
//         - ОбъектДрайвера драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <Булево> - Результат работы функции.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;
	ОбъектДрайвера.УстройствоВключено = 0;
	ОбъектДрайвера.УдалитьУстройство();

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;

	ВыходныеПараметры = Новый Массив();

	// Выгрузка таблицы в устройство.
	Если Команда = "UploadDirectory" Тогда
		ТаблицаВыгрузки = ВходныеПараметры[1];

		Результат = ВыгрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения,
									 ТаблицаВыгрузки, ВыходныеПараметры);

	// Загрузка таблицы из устройства.
	ИначеЕсли Команда = "DownloadDocument" Тогда
		Результат = ЗагрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" Тогда
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

// Функция осуществляет выгрузку строки в терминал сбора данных.
//
Функция ВыгрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаВыгрузки, ВыходныеПараметры)

	Результат = Истина;

	Результат = НачатьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	Если Результат Тогда
		ОбъектДрайвера.ПоказатьПрогресс = Истина;
		Для Индекс = 0 По ТаблицаВыгрузки.Количество() - 1 Цикл
			Результат = ВыгрузитьСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
			                            ТаблицаВыгрузки[Индекс][0].Значение, ТаблицаВыгрузки[Индекс][1].Значение,
			                            ТаблицаВыгрузки[Индекс][2].Значение, ТаблицаВыгрузки[Индекс][3].Значение,
			                            ТаблицаВыгрузки[Индекс][4].Значение, ТаблицаВыгрузки[Индекс][5].Значение,
			                            ТаблицаВыгрузки[Индекс][6].Значение, ТаблицаВыгрузки[Индекс][7].Значение,
			                            ВыходныеПараметры);
			Если Не Результат Тогда
				ЗавершитьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		ОбъектДрайвера.ПоказатьПрогресс = Ложь;

		Если Результат Тогда
			Результат = ЗавершитьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет загрузку строки из терминала сбора данных.
//
Функция ЗагрузитьТаблицу(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат  = Истина;
	Штрихкод   = Неопределено;
	Количество = Неопределено;
	
	Результат = НачатьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, Количество, ВыходныеПараметры);
	
	Если Результат Тогда
		ВыходныеПараметры.Добавить(Новый Массив());
		Для Индекс = 1 По Количество Цикл
			Результат = ЗагрузитьСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
			                            Штрихкод, Количество, ВыходныеПараметры);
			Если Результат Тогда
				ПозицияДанных = Новый Структура("Штрихкод, Количество", Штрихкод, Количество);
				ВыходныеПараметры[0].Добавить(ПозицияДанных);
			Иначе
				ЗавершитьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если Результат Тогда
		Результат = ЗавершитьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		Если Не Результат Тогда
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет подготовку процедуры выгрузки данных в терминал.
//
Функция НачатьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;

	ОбъектДрайвера.НомерФормы = Параметры.ТаблицаВыгрузки;
	Если ОбъектДрайвера.ОчиститьБуферТаблицы() = 0 Тогда
		Если ОбъектДрайвера.НачатьЗагрузкуТаблицы() <> 0 Тогда
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

			Результат = Ложь;
		КонецЕсли;
	Иначе
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет выгрузку строки в терминал сбора данных.
//
// Параметры:
//  Объект                         - <*>
//                                 - Объект драйвера торгового оборудования.
//
//  Штрихкод                       - <Строка>
//                                 - Штрихкод товара.
//
//  Номенклатура                   - <СправочникСсылка.Номенклатура>
//                                 - Номенклатура.
//
//  ЕдиницаИзмерения               - <СправочникСсылка.ЕдиницыИзмерения>
//                                 - Единица измерения номенклатуры.
//
//  ХарактеристикаНоменклатуры     - <СправочникСсылка.ХарактеристикиНоменклатуры>
//                                 - Характеристика номенклатуры.
//
//  СерияНоменклатуры              - <СправочникСсылка.СерииНоменклатуры>
//                                 - Серия номенклатуры.
//
//  Качество                       - <СправочникСсылка.Качество>
//                                 - Качество.
//
//  Цена                           - <Число>
//                                 - Цена номенклатуры.
//
//  Количество                     - <Число>
//                                 - Количество номенклатуры.
//
// Возвращаемое значение:
//  <ПеречислениеСсылка.ТООшибки*> - Результат работы функции.
//
Функция ВыгрузитьСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                        Штрихкод, Номенклатура, ЕдиницаИзмерения,
                        ХарактеристикаНоменклатуры, СерияНоменклатуры,
                        Качество, Цена, Количество, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ДанныеДляВыгрузки = Новый Массив();
	Если Параметры.ФорматВыгрузки.Количество() > 0 Тогда
		Для Каждого СтрокаФормата Из Параметры.ФорматВыгрузки Цикл
			Если СтрокаФормата.Наименование = "Штрихкод" Тогда
				ДанныеДляВыгрузки.Добавить(Штрихкод);
			ИначеЕсли СтрокаФормата.Наименование = "Номенклатура" Тогда
				ДанныеДляВыгрузки.Добавить(Номенклатура);
			ИначеЕсли СтрокаФормата.Наименование = "ЕдиницаИзмерения" Тогда
				ДанныеДляВыгрузки.Добавить(ЕдиницаИзмерения);
			ИначеЕсли СтрокаФормата.Наименование = "ХарактеристикаНоменклатуры" Тогда
				ДанныеДляВыгрузки.Добавить(ХарактеристикаНоменклатуры);
			ИначеЕсли СтрокаФормата.Наименование = "СерияНоменклатуры" Тогда
				ДанныеДляВыгрузки.Добавить(СерияНоменклатуры);
			ИначеЕсли СтрокаФормата.Наименование = "Качество" Тогда
				ДанныеДляВыгрузки.Добавить(Качество);
			ИначеЕсли СтрокаФормата.Наименование = "Цена" Тогда
				ДанныеДляВыгрузки.Добавить(Цена);
			ИначеЕсли СтрокаФормата.Наименование = "Количество" Тогда
				ДанныеДляВыгрузки.Добавить(Количество);
			КонецЕсли;
		КонецЦикла;
	Иначе
		ДанныеДляВыгрузки.Добавить(Штрихкод);
		ДанныеДляВыгрузки.Добавить(Номенклатура);
		ДанныеДляВыгрузки.Добавить(ЕдиницаИзмерения);
		ДанныеДляВыгрузки.Добавить(ХарактеристикаНоменклатуры);
		ДанныеДляВыгрузки.Добавить(СерияНоменклатуры);
		ДанныеДляВыгрузки.Добавить(Качество);
		ДанныеДляВыгрузки.Добавить(Цена);
		ДанныеДляВыгрузки.Добавить(Количество);
	КонецЕсли;

	Если ДанныеДляВыгрузки.Количество() > 0 Тогда
		Для Каждого Данные Из ДанныеДляВыгрузки Цикл
			Ответ = ОбъектДрайвера.ДобавитьВТаблицу(Данные);
			Если Ответ <> 0 Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если ОбъектДрайвера.Результат <> 0 Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет завершение процедуры выгрузки данных в терминал сбора данных.
//
Функция ЗавершитьВыгрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Ответ = ОбъектДрайвера.ЗагрузитьТаблицу();
	Если Ответ <> 0 Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет подготовку процедуры загрузки данных из терминала сбора данных.
//
Функция НачатьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, Количество, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.НомерТекущегоУстройства = ПараметрыПодключения.ИДУстройства;

	ОбъектДрайвера.НомерФормы = Параметры.ТаблицаЗагрузки;
	Количество                = ОбъектДрайвера.ПолучитьКоличествоЗаписей();
	Если ОбъектДрайвера.Результат = 0 Тогда
		Если ОбъектДрайвера.ОчиститьБуферТаблицы() = 0 Тогда
			Если ОбъектДрайвера.НачалоОтчета() <> 0 Тогда
				ВыходныеПараметры.Очистить();
				ВыходныеПараметры.Добавить(999);
				ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

				Результат = Ложь;
			КонецЕсли;
		Иначе
			ВыходныеПараметры.Очистить();
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

			Результат = Ложь;
		КонецЕсли;
	Иначе
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет загрузку строки из терминала сбора данных.
//
// Параметры:
//  Объект                         - <*>
//                                 - Объект драйвера торгового оборудования.
//
//  Штрихкод                       - <Строка>
//                                 - Штрихкод, соответствующий данной номенклатуре.
//
//  Количество                     - <Число>
//                                 - Выходной параметр; количество номенклатуры.
//
// Возвращаемое значение:
//  <ПеречислениеСсылка.ТООшибки*> - Результат работы функции.
//
Функция ЗагрузитьСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения, Штрихкод, Количество, ВыходныеПараметры)

	Результат  = Истина;
	Штрихкод   = Неопределено;
	Количество = Неопределено;

	ОбъектДрайвера.ПолучитьЗапись();
	Если ОбъектДрайвера.Результат = 0 Тогда
		Если Параметры.ФорматЗагрузки.Количество() > 0 Тогда
			Для Каждого СтрокаФормата Из Параметры.ФорматЗагрузки Цикл
				Если СтрокаФормата.Наименование = "Штрихкод" Тогда
					Штрихкод = ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля];
				ИначеЕсли СтрокаФормата.Наименование = "Количество" Тогда
					Количество = ОбъектДрайвера["Поле" + СтрокаФормата.НомерПоля];
				КонецЕсли;
			КонецЦикла;
		Иначе
			Штрихкод   = ОбъектДрайвера["Поле1"];
			Количество = ОбъектДрайвера["Поле2"];
		КонецЕсли;
	Иначе
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет завершение процедуры загрузки данных из терминала сбора данных.
//
// Параметры:
//  Объект                         - <*>
//                                 - Объект драйвера торгового оборудования.
//
// Возвращаемое значение:
//  <ПеречислениеСсылка.ТООшибки*> - Результат работы функции.
//
Функция ЗавершитьЗагрузку(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ОбъектДрайвера.КонецОтчета();
	Если ОбъектДрайвера.Результат <> 0 Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ОбъектДрайвера.ОписаниеРезультата);

		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет тестирование устройства.
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Результат = ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	ВыходныеПараметры.Добавить(?(Результат, "", НСтр("ru='Ошибка при подключении устройства'")));

	ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера.
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.Версия;
	Исключение
		Результат = Ложь;
	КонецПопытки;

	Возврат Результат;

КонецФункции

#КонецОбласти