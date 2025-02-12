﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка= Ложь;
		Возврат;
	КонецЕсли;

	ТипСтруктура = Тип("Структура");

	ЭтаФорма.РежимПросмотра = "Декорации"; // Возможные значения: Декорации, ТаблицаЗначений, ФоновоеОбновление, Листание, Автолистание.
	ЭтаФорма.ЧастотаАвтолистания = 10; // Секунд
	ЭтаФорма.КоличествоНовостейДляЛистанияМаксимум = 5; // Реальное количество переключателей будет подстраиваться под количество новостей.

	СтруктураНастроекПоказаНовостей = ХранилищаНастроек.НастройкиНовостей.Загрузить(
		"НастройкиПоказаНовостей",
		"");
	ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураНастроекПоказаНовостей);

	ВозвращаемыеЗначения = Неопределено;
	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуПросмотраНовостейДляРабочегоСтолаПриСозданииНаСервере(
		ЭтаФорма,
		ВозвращаемыеЗначения);

	Если (ЭтаФорма.ЧастотаАвтолистания < 5) Тогда
		ЭтаФорма.ЧастотаАвтолистания = 5;
	КонецЕсли;
	Если ЭтаФорма.КоличествоНовостейДляЛистанияМаксимум <= 0 Тогда
		ЭтаФорма.КоличествоНовостейДляЛистанияМаксимум = 5; // Реальное количество переключателей будет подстраиваться под количество новостей.
	КонецЕсли;

	ЭтаФорма.ПропуститьЗаполнениеНовостями = Ложь;
	Если ТипЗнч(ВозвращаемыеЗначения) = ТипСтруктура Тогда
		Если (ВозвращаемыеЗначения.Свойство("ПропуститьЗаполнениеНовостями") = Истина)
				И (ВозвращаемыеЗначения.ПропуститьЗаполнениеНовостями = Истина) Тогда
			ЭтаФорма.ПропуститьЗаполнениеНовостями = Истина;
		КонецЕсли;
	КонецЕсли;

	Если ЭтаФорма.ПропуститьЗаполнениеНовостями <> Истина Тогда
		// Автоматически заполнить новостями и обновить форму.
		ЗагрузитьНовостиИОбновитьФормуСервер();
	Иначе
		// Если текст новости выводится прямо в этом окне, то заранее заполнить тексты новостей.
		ЗаполнитьТекстНовостейХТМЛ();
		// Только обновить форму - новости могут быть заполнены в переопределяемом модуле.
		УправлениеФормой();
		УстановитьУсловноеОформление();
	КонецЕсли;

	Если (ОбработкаНовостейПовтИсп.ЕстьРолиЧтенияНовостей()) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЭтаФорма.ПропуститьЗаполнениеНовостями <> Истина Тогда
		Если ЭтаФорма.СписокНовостей_ИнтервалАвтообновления < 1 Тогда
			ЭтаФорма.СписокНовостей_ИнтервалАвтообновления = 15;
		КонецЕсли;
		ЭтаФорма.ПодключитьОбработчикОжидания("АвтообновлениеСпискаНовостей", ЭтаФорма.СписокНовостей_ИнтервалАвтообновления * 60, Ложь);
	КонецЕсли;

	// При создании на сервере были обнаружены интерактивные действия для клиента?
	Если ЭтаФорма.ИнтерактивныеДействияПриОткрытии.Количество() > 0 Тогда
		ИнтерактивныеДействия = ЭтаФорма.ИнтерактивныеДействияПриОткрытии.ВыгрузитьЗначения();
		ОбработкаНовостейКлиент.ВыполнитьИнтерактивныеДействия(ИнтерактивныеДействия);
	КонецЕсли;

	// Подключить автолистание.
	Если (ВРег(ЭтаФорма.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтаФорма.ОтключитьОбработчикОжидания("ВыполнитьАвтолистание");
		Если ЭтаФорма.КоличествоНовостейДляЛистания > 1 Тогда
			ЭтаФорма.ПодключитьОбработчикОжидания("ВыполнитьАвтолистание", ЭтаФорма.ЧастотаАвтолистания, Ложь);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Новость прочтена" Тогда
		// Не обновлять список новостей.

	ИначеЕсли ИмяСобытия = "Новости. Загружены новости" Тогда
		Если Источник <> ЭтаФорма.УникальныйИдентификатор Тогда
			ЗагрузитьНовостиИОбновитьФормуСервер();
		КонецЕсли;

	ИначеЕсли ИмяСобытия = "Новости. Обновлены настройки чтения новостей" Тогда
		ПриСозданииНаСервере(Ложь, Истина);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереходКНовости(Элемент)

	ИдентификаторЭлемента = Число(Сред(Элемент.Имя, 17, 3));
	Если (ИдентификаторЭлемента > 0) И (ИдентификаторЭлемента <= ЭтаФорма.Новости.Количество()) Тогда
		ТекущаяСтрока = ЭтаФорма.Новости[ИдентификаторЭлемента-1];
		ФормаНовости = ОбработкаНовостейКлиент.ПоказатьНовость(
			ТекущаяСтрока.Ссылка, // НовостьСсылка
			, // ПараметрыОткрытияФормы. БлокироватьОкноВладельца не нужно, т.к. неизвестно что будет за владелец и блокировать первое попавшееся окно неправильно.
			, // ФормаВладелец
			Ложь); // Уникальность по-умолчанию (по ссылке)
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИндексТекущейНовостиПриИзменении(Элемент)

	// Если пользователь явно нажал на кнопку выбора новости, то остановить автолистание.
	// Оно автоматически включится после обновления списка новостей.
	// Отключить автолистание.
	Если (ВРег(ЭтаФорма.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтаФорма.ОтключитьОбработчикОжидания("ВыполнитьАвтолистание");
	КонецЕсли;

	// Вывести текст текущей новости.
	ЭтаФорма.ТекстНовостиХТМЛ = ЭтаФорма.Новости.Получить(ЭтаФорма.ИндексТекущейНовости).ТекстНовостиХТМЛ;

КонецПроцедуры

&НаКлиенте
Процедура ТекстНовостиХТМЛПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	// Отключить автолистание.
	Если (ВРег(ЭтаФорма.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтаФорма.ОтключитьОбработчикОжидания("ВыполнитьАвтолистание");
	КонецЕсли;

	лкОбъект = ЭтаФорма.Новости.Получить(ЭтаФорма.ИндексТекущейНовости).Ссылка; // При открытии из формы элемента справочника / документа

	ОбработкаНовостейКлиент.ОбработкаНажатияВТекстеНовости(лкОбъект, ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма, Элемент);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Новости

&НаКлиенте
Процедура НовостиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ВыбраннаяСтрока <> Неопределено Тогда
		ТекущаяНовость = ЭтаФорма.Новости.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущаяНовость <> Неопределено Тогда
			Если НЕ ТекущаяНовость.Ссылка.Пустая() Тогда
				ФормаНовости = ОбработкаНовостейКлиент.ПоказатьНовость(
					ТекущаяНовость.Ссылка, // НовостьСсылка
					, // ПараметрыОткрытияФормы. БлокироватьОкноВладельца не нужно, т.к. неизвестно что будет за владелец
					       // и блокировать первое попавшееся окно неправильно.
					, // ФормаВладелец
					Ложь); // Уникальность по-умолчанию (по ссылке)
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет все информационные надписи, но не устанавливает видимость групп СтраницаДекорации или СтраницаТаблицаЗначений.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УправлениеФормой()

	Если ВРег(ЭтаФорма.РежимПросмотра) = ВРег("Декорации") Тогда

		// Все новости делать в виде гиперссылок
		ВсегоНовостей = 3;
		Для С=1 По ВсегоНовостей Цикл
			ЭлементТекстНовости   = Элементы["ДекорацияНовость" + Формат(С, "ЧЦ=3; ЧДЦ=0; ЧН=000; ЧВН=; ЧГ=0") + "ТекстНовости"];
			ЭлементДатаПубликации = Элементы["ДекорацияНовость" + Формат(С, "ЧЦ=3; ЧДЦ=0; ЧН=000; ЧВН=; ЧГ=0") + "ДатаПубликации"];
			Если ЭтаФорма.Новости.Количество() < С Тогда
				ЭлементТекстНовости.Видимость   = Ложь;
				ЭлементДатаПубликации.Видимость = Ложь;
			Иначе
				ЭлементТекстНовости.Видимость   = Истина;
				ЭлементДатаПубликации.Видимость = Истина;
				ЭлементТекстНовости.Заголовок   = ЭтаФорма.Новости[С-1].Наименование;
				ЭлементДатаПубликации.Заголовок = Формат(МестноеВремя(ЭтаФорма.Новости[С-1].ДатаПубликации, ЧасовойПояс()), "ДФ='dd.MM.yyyy HH:mm'");
			КонецЕсли;
		КонецЦикла;

		Если ЭтаФорма.Новости.Количество() = 0 Тогда
			Элементы.ДекорацияНетНовостей.Видимость = Истина;
		Иначе
			Элементы.ДекорацияНетНовостей.Видимость = Ложь;
		КонецЕсли;

		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДекорации;

	ИначеЕсли ВРег(ЭтаФорма.РежимПросмотра) = ВРег("ТаблицаЗначений") Тогда

		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаТаблицаЗначений;

	ИначеЕсли ВРег(ЭтаФорма.РежимПросмотра) = ВРег("ФоновоеОбновление") Тогда

		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаДекорации; ////?

	ИначеЕсли (ВРег(ЭтаФорма.РежимПросмотра) = ВРег("Листание"))
			ИЛИ (ВРег(ЭтаФорма.РежимПросмотра) = ВРег("Автолистание")) Тогда
		// Исправить количество новостей для листания.
		ЭтаФорма.КоличествоНовостейДляЛистания = Мин(ЭтаФорма.Новости.Количество(), ЭтаФорма.КоличествоНовостейДляЛистанияМаксимум);
		// Переключить на страницу.
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЛистание;
		// Перерисовать поле переключателей.
		Элементы.ИндексТекущейНовости.СписокВыбора.Очистить();
		Для С=0 По ЭтаФорма.КоличествоНовостейДляЛистания-1 Цикл
			Элементы.ИндексТекущейНовости.СписокВыбора.Добавить(С, " ");
		КонецЦикла;
		// Если количество новостей для листания = 1, то скрыть поле переключателей.
		Если ЭтаФорма.КоличествоНовостейДляЛистания <= 1 Тогда
			Элементы.ГруппаИндексТекущейНовости.Видимость = Ложь;
		Иначе
			Элементы.ГруппаИндексТекущейНовости.Видимость = Истина;
		КонецЕсли;
		// Сбросить счетчик текущей новости.
		ЭтаФорма.ИндексТекущейНовости = 0;
		// Вывести текст текущей новости.
		ЭтаФорма.ТекстНовостиХТМЛ = ЭтаФорма.Новости.Получить(ЭтаФорма.ИндексТекущейНовости).ТекстНовостиХТМЛ;

	КонецЕсли;

КонецПроцедуры

// Функция заполняет табличную часть "Новости" из справочника "Новости".
// Запускается только в том случае, если новости не были получены вручную.
// Возвращается массив интерактивных действий (если нужно): оповещения пользователю и т.п.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Массив структур.
//
&НаСервере
Функция ОбновитьСписокНовостейСервер()

	ИнтерактивныеДействия = Новый Массив;

	Справочники.Новости.ПолучитьСписокНовостей(
		ЭтаФорма.Новости,
		ПользователиКлиентСервер.ТекущийПользователь(),
		Новый Структура("ВариантОтбора", 0),
		ИнтерактивныеДействия);

	ЭтаФорма.Новости.Сортировать("ДатаПубликации УБЫВ");

	// Заполнить текст новостей.
	ЗаполнитьТекстНовостейХТМЛ();

	// После загрузки новостей обновить отображение быстрых фильтров.
	УправлениеФормой();

	Возврат ИнтерактивныеДействия;

КонецФункции

// Процедура заполняет колонку "ТекстНовостиХТМЛ" табличной части "Новости".
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ЗаполнитьТекстНовостейХТМЛ()

	// Заполнить текст новостей.
	Если (ВРег(ЭтаФорма.РежимПросмотра) = ВРег("Листание"))
			ИЛИ (ВРег(ЭтаФорма.РежимПросмотра) = ВРег("Автолистание")) Тогда
		С = 0;
		Для Каждого ТекущаяНовость Из ЭтаФорма.Новости Цикл
			Если С >= ЭтаФорма.КоличествоНовостейДляЛистанияМаксимум Тогда
				Прервать;
			КонецЕсли;
			Если ПустаяСтрока(ТекущаяНовость.ТекстНовостиХТМЛ) И (НЕ ТекущаяНовость.Ссылка.Пустая()) Тогда
				ТекущаяНовость.ТекстНовостиХТМЛ = Справочники.Новости.ПолучитьХТМЛТекстНовостей(
					ТекущаяНовость.Ссылка,
					Новый Структура("ОтображатьЗаголовок",
						Ложь));
			КонецЕсли;
			С = С + 1;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

// Процедура для автоматического запуска обработкой ожидания - обновляет список новостей.
// В интерфейсе не видна.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура АвтообновлениеСпискаНовостей()

	ИнтерактивныеДействия = ОбновитьСписокНовостейСервер();
	ОбработкаНовостейКлиент.ВыполнитьИнтерактивныеДействия(ИнтерактивныеДействия);

	// Исправить количество новостей для листания.
	ЭтаФорма.КоличествоНовостейДляЛистания = Мин(ЭтаФорма.Новости.Количество(), ЭтаФорма.КоличествоНовостейДляЛистанияМаксимум);

	// Подключить автолистание.
	Если (ВРег(ЭтаФорма.РежимПросмотра) = ВРег("Автолистание")) Тогда
		ЭтаФорма.ОтключитьОбработчикОжидания("ВыполнитьАвтолистание");
		Если ЭтаФорма.КоличествоНовостейДляЛистания > 1 Тогда
			ЭтаФорма.ПодключитьОбработчикОжидания("ВыполнитьАвтолистание", ЭтаФорма.ЧастотаАвтолистания, Ложь);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

КонецПроцедуры

// Загружает новые новости и обновляет форму.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ЗагрузитьНовостиИОбновитьФормуСервер()

	// Загрузка новостей в табличную часть из справочника.
	ИнтерактивныеДействия = ОбновитьСписокНовостейСервер(); // Здесь же вызовется УправлениеФормой();
	// ОбработкаНовостейКлиент.ВыполнитьИнтерактивныеДействия(ИнтерактивныеДействия); // На сервере вызвать нельзя, передадим на клиента через реквизиты формы.
	ЭтаФорма.ИнтерактивныеДействияПриОткрытии.ЗагрузитьЗначения(ИнтерактивныеДействия);

	УстановитьУсловноеОформление();

КонецПроцедуры

// Процедура обеспечивает автопереключение новостей.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура ВыполнитьАвтолистание()

	// Увеличить счетчик текущей новости.
	ЭтаФорма.ИндексТекущейНовости = ЭтаФорма.ИндексТекущейНовости + 1;
	Если ЭтаФорма.ИндексТекущейНовости > (ЭтаФорма.КоличествоНовостейДляЛистания - 1) Тогда
		ЭтаФорма.ИндексТекущейНовости = 0;
	КонецЕсли;

	// Вывести текст текущей новости.
	ЭтаФорма.ТекстНовостиХТМЛ = ЭтаФорма.Новости.Получить(ЭтаФорма.ИндексТекущейНовости).ТекстНовостиХТМЛ;

КонецПроцедуры

#КонецОбласти
