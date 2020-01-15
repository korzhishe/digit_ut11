﻿
#Область ПрограммныйИнтерфейс

#Область ЭкспортныеФункцииДляИнтерактивнойРаботыСоСкидками

// Процедура сбрасывает флаг СкидкиРассчитаны и делает недоступными колонки табличной части.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма объекта.
//
Процедура СброситьФлагСкидкиРассчитаны(Форма) Экспорт
	
	Форма.Объект.СкидкиРассчитаны = Ложь;
	
КонецПроцедуры

// Предложить пользователю рассчитать скидки.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - Описание оповещения, вызываемое после завершения вопроса.
//
Процедура ПредложитьПользователюРассчитатьСкидки(ОписаниеОповещения) Экспорт
	
	ТекстВопроса = НСтр("ru='Автоматические скидки (наценки) не рассчитаны. Рассчитать автоматические скидки (наценки)?'");
	ПоказатьВопрос(
		ОписаниеОповещения,
		ТекстВопроса,
		РежимДиалогаВопрос.ОКОтмена);
	
КонецПроцедуры

// Проверяет заполненность реквизитов, необходимых для назначения скидок.
//
// Параметры:
//   Документ                    - ДокументОбъект, для которого выполняются проверки.
//   ИмяТабличнойЧасти           - Строка - имя табличной части, в которой необходимо осуществить проверку.
//   ПредставлениеТабличнойЧасти - Строка - представление табличной части для информирования пользователя.
//
// Возвращаемое значение:
//   Булево - Возможность назначения ручных скидок (наценок).
//
Функция ВозможноНазначениеРучнойСкидкиНаценки(Документ, ИмяТабличнойЧасти, ПредставлениеТабличнойЧасти) Экспорт

	Если Документ[ИмяТабличнойЧасти].Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='В документе не заполнена таблица %ПредставлениеТабличнойЧасти%. Ручная скидка (наценка) не может быть назначена'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%ПредставлениеТабличнойЧасти%", ПредставлениеТабличнойЧасти);
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат Ложь;
		
	КонецЕсли;

	Возврат Истина;

КонецФункции

// Проверяет заполненность реквизитов, необходимых для отмены скидок.
//
// Параметры:
//   Документ                    - ДокументОбъект, для которого выполняются проверки.
//   ИмяТабличнойЧасти           - Строка - имя табличной части, в которой необходимо осуществить проверку.
//   ПредставлениеТабличнойЧасти - Строка - представление табличной части для информирования пользователя.
//
// Возвращаемое значение:
//  Булево - Возможность отмены ручных скидок (наценок).
//
Функция ВозможнаОтменаРучныхСкидокНаценок(Документ, ИмяТабличнойЧасти, ПредставлениеТабличнойЧасти) Экспорт

	Если Документ[ИмяТабличнойЧасти].Количество() = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='В документе не заполнена таблица %ПредставлениеТабличнойЧасти%. Ручные скидки (наценки) не могут быть отменены'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%ПредставлениеТабличнойЧасти%", ПредставлениеТабличнойЧасти);
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат Ложь;
		
	ИначеЕсли Документ[ИмяТабличнойЧасти].Итог("СуммаРучнойСкидки") = 0 Тогда
		
		ТекстПредупреждения = НСтр("ru='В документе не заполнена сумма ручной скидки в таблице %ПредставлениеТабличнойЧасти%. Ручные скидки (наценки) не могут быть отменены'");
		ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%ПредставлениеТабличнойЧасти%", ПредставлениеТабличнойЧасти);
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат Ложь;
		
	КонецЕсли;

	Возврат Истина;

КонецФункции

// Показывает оповещение пользователя об окончании назначения ручных скидок (наценок).
//
// Параметры:
//   СуммаСкидкиНаценки - Число - Сумма ручной скидки.
//   Валюта             - СправочникСсылка.Валюты, Неопределено - Валюта скидки.
//
Процедура ОповеститьОбОкончанииНазначенияРучныхСкидокНаценок(СуммаСкидкиНаценки = 0, Валюта = Неопределено) Экспорт

	Если СуммаСкидкиНаценки > 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Назначена ручная скидка %СуммаСкидкиНаценки% %Валюта%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СуммаСкидкиНаценки%", СуммаСкидкиНаценки);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Валюта%", Валюта);
		
	ИначеЕсли СуммаСкидкиНаценки < 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Назначена ручная наценка %СуммаСкидкиНаценки% %Валюта%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СуммаСкидкиНаценки%", СуммаСкидкиНаценки);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Валюта%", Валюта);
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Ручные скидки (наценки) отменены'");
		
	КонецЕсли;
		
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Скидки (наценки)'"),
		,
		ТекстСообщения,
		БиблиотекаКартинок.Информация32);

КонецПроцедуры // ОповеститьОбОкончанииНазначенияРучныхСкидокНаценок()

// Открывает форму редактирования условия предоставления скидки
//
// Параметры:
//  ТипУсловия                                        - Перечисление.УсловияПредоставленияСкидокНаценок - тип создаваемого условия
//  ДанныеДляЗаполненияРодителя                       - Справочник.УсловияПредоставленияСкидокНаценок - в качестве родителя нового условия будет установлен
//                                                                                                      родитель переданного в данном параметре условия.
//  ИспользоватьФормуСправочникаУсловияПредоставления - Булево - если Истина, то будет открыта форма элемента справочника УсловияПредоставленияСкидокНаценок,
//                                                               если Ложь, то форма УсловияПредоставленияСкидокНаценок справочника СкидкиНаценки
//
Процедура СоздатьУсловиеПредоставлениеСкидкиНаценки(ТипУсловия,
	                                                ДанныеДляЗаполненияРодителя = Неопределено,
	                                                ИспользоватьФормуСправочникаУсловияПредоставления = Истина) Экспорт
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("УсловиеПредоставления", ТипУсловия));
	СтруктураПараметры.Вставить("ДанныеДляЗаполненияРодителя",
	                            ?(ДанныеДляЗаполненияРодителя = Неопределено,
	                              ПредопределенноеЗначение("Справочник.УсловияПредоставленияСкидокНаценок.ПустаяСсылка"),
	                              ДанныеДляЗаполненияРодителя));
	
	ИмяФормы = ?(ИспользоватьФормуСправочникаУсловияПредоставления,
	            "Справочник.УсловияПредоставленияСкидокНаценок.Форма.ФормаЭлемента",
	            "Справочник.УсловияПредоставленияСкидокНаценок.Форма.ФормаВводаНового");
	
	ОткрытьФорму(ИмяФормы, СтруктураПараметры);

КонецПроцедуры

// Открывает форму редактирования условия предоставления скидки
//
// Параметры:
//  ТипУсловия                                        - Перечисление.УсловияПредоставленияСкидокНаценок - тип создаваемого условия.
//  ДанныеДляЗаполненияРодителя                       - Справочник.УсловияПредоставленияСкидокНаценок - в качестве родителя нового условия будет установлен
//                                                                                                      родитель переданного в данном параметре условия.
//  ИспользоватьФормуСправочникаУсловияПредоставления - Булево - если Истина, то будет открыта форма элемента справочника УсловияПредоставленияСкидокНаценок,
//                                                               если Ложь, то форма УсловияПредоставленияСкидокНаценок справочника СкидкиНаценки.
//
Процедура СоздатьСкидкуНаценку(СпособПредоставления, СпособПримененияСкидки,
	                           ДанныеДляЗаполненияРодителя = Неопределено) Экспорт
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура(
		"СпособПредоставления, СпособПримененияСкидки, ДанныеДляЗаполненияРодителя",
		СпособПредоставления, СпособПримененияСкидки, ДанныеДляЗаполненияРодителя));
	
	ОткрытьФорму("Справочник.СкидкиНаценки.Форма.ФормаЭлемента", СтруктураПараметры);

КонецПроцедуры

// Открывает форму нового условия предоставления скидки (наценки).
//
// Параметры:
//  Форма         - УправляемаяФорма - Форма объекта.
//  Команда       - КомандаФормы - Команда формы.
//  ТекущаяСтрока - ДанныеФормыСтруктура - Текущая строка.
//
Процедура ОбработатьКомандуДобавленияУсловияПредоставленияСкидокНаценок(Форма, Команда, ТекущаяСтрока) Экспорт
	
	Для Каждого СтрокаТЧ Из Форма.КомандыУсловияПредоставления Цикл
		
		Если СтрокаТЧ.ИмяКоманды = Команда.Имя Тогда
			
			СкидкиНаценкиКлиент.СоздатьУсловиеПредоставлениеСкидкиНаценки(
			                 СтрокаТЧ.Значение,
			                 ТекущаяСтрока, Ложь);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Открывает форму новой скидки (наценки)
//
// Параметры:
//  Форма         - УправляемаяФорма - Форма объекта.
//  Команда       - КомандаФормы - Команда формы.
//  ТекущаяСтрока - ДанныеФормыСтруктура - Текущая строка.
//
Процедура ОбработатьКомандуДобавленияСкидкиНаценки(Форма, Команда, ТекущаяСтрока) Экспорт
	
	Для Каждого СтрокаТЧ Из Форма.КомандыУсловияПредоставления Цикл
		
		Если СтрокаТЧ.ИмяКоманды = Команда.Имя Тогда
			
			СпособПримененияСкидки = ПредопределенноеЗначение("Перечисление.СпособыПримененияСкидокНаценок.ПрименитьВМоментРасчетаСкидокНаценок");
			Если СтрНайти(Команда.Имя, "БонусныеБаллы") > 0 Тогда
				СпособПримененияСкидки = ПредопределенноеЗначение("Перечисление.СпособыПримененияСкидокНаценок.НачислитьБонусныеБаллы");
			КонецЕсли;
			
			СкидкиНаценкиКлиент.СоздатьСкидкуНаценку(
				СтрокаТЧ.Значение,
				СпособПримененияСкидки,
				ТекущаяСтрока);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Открывает форму настройки отбора.
//
// Параметры:
//  Форма     - УправляемаяФорма - Форма объекта.
//  Имя       - Строка - Имя.
//  Адреса    - Структура - Структура со свойствами:
//   * СхемаКомпоновкиДанных - СхемаКомпоновкиДанных - Схема компоновки.
//   * НастройкиКомпоновкиДанных - НастройкиКомпоновкиДанных - Настройки.
//
Процедура НастроитьОтбор(Форма, Имя, Адреса) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.УпрощеннаяНастройкаСхемыКомпоновкиДанных",
		Новый Структура(
			"НеПомещатьНастройкиВСхемуКомпоновкиДанных,
			|НеРедактироватьСхемуКомпоновкиДанных,
			|НеЗагружатьСхемуКомпоновкиДанныхИзФайла,
			|НеНастраиватьУсловноеОформление,
			|НеНастраиватьВыбор,
			|НеНастраиватьПорядок,
			|НеНастраиватьПараметры,
			|УникальныйИдентификатор,
			|АдресСхемыКомпоновкиДанных,
			|АдресНастроекКомпоновкиДанных,
			|Заголовок,
			|ТолькоПросмотр",
			Истина,
			Истина,
			Истина,
			Истина,
			Истина,
			Истина,
			Истина,
			Форма.УникальныйИдентификатор,
			Адреса.СхемаКомпоновкиДанных,
			Адреса.НастройкиКомпоновкиДанных,
			НСтр("ru = 'Редактирование отбора'"),
			Форма.Элементы.ВариантОтбораНоменклатуры.ТолькоПросмотр),,,,,
			Новый ОписаниеОповещения(
				"РедактироватьСхемуКомпоновкиДанныхЗавершение",
				Форма,
				Новый Структура("Имя", Имя)),
				РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область ПримененныеСкидки

// Процедура открывает форму расшифровки скидок рассчитанных по текущей строке табличной части.
//
// Параметры:
//  ТекущиеДанные  - СтрокаТабличнойЧасти - строка для которой необходимо открыть расшифровку скидок.
//  Объект  - ДанныеФормы - Объект, для которого нужно открыть форму расшифровки скидок.
//  Форма  - УправляемаяФорма - Форма объекта.
//  ДополнительныеПараметры  - Структура - Дополнительные параметры.
//
Процедура ОткрытьФормуПримененныеСкидки(ТекущиеДанные, Объект, Форма, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.АктВыполненныхРабот") Тогда
		ИмяКоличества = "Количество";
	Иначе
		ИмяКоличества = "КоличествоУпаковок";
	КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено Тогда
	
		СтруктураТекущиеДанные = Новый Структура;
		СтруктураТекущиеДанные.Вставить("КлючСвязи",         ТекущиеДанные.КлючСвязи);
		СтруктураТекущиеДанные.Вставить("Номенклатура",      ТекущиеДанные.Номенклатура);
		СтруктураТекущиеДанные.Вставить("Характеристика",    ТекущиеДанные.Характеристика);
		СтруктураТекущиеДанные.Вставить("СуммаРучнойСкидки", ТекущиеДанные.СуммаРучнойСкидки);
		СтруктураТекущиеДанные.Вставить("СуммаБезСкидки",    ТекущиеДанные.Цена * ТекущиеДанные[ИмяКоличества]);
		
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("Объект", Объект);
		СтруктураПараметров.Вставить("Заголовок", НСтр("ru = 'Примененные скидки (наценки) для строки'"));
		СтруктураПараметров.Вставить("ТекущиеДанные", СтруктураТекущиеДанные);
		СтруктураПараметров.Вставить("АдресПримененныхСкидокВоВременномХранилище",          Форма.АдресПримененныхСкидокВоВременномХранилище);
		СтруктураПараметров.Вставить("ОтображатьИнформациюОСкидкахПоСтроке",                Истина);
		СтруктураПараметров.Вставить("ОтображатьИнформациюОРасчетеСкидокПоСтроке",          Истина);
		СтруктураПараметров.Вставить("ОтображатьИнформациюОРасчетеСкидокПоДокументуВЦелом", Ложь);
		
		Если ДополнительныеПараметры <> Неопределено И ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
			Для Каждого Параметр Из ДополнительныеПараметры Цикл
				СтруктураПараметров.Вставить(Параметр.Ключ,Параметр.Значение);
			КонецЦикла;
		КонецЕсли;
		
		ОткрытьФорму("ОбщаяФорма.ПримененныеСкидкиНаценки", СтруктураПараметров, Форма, Форма.УникальныйИдентификатор);
	
	КонецЕсли;
	
КонецПроцедуры // ОткрытьФормуПримененныеСкидки()

// Открыть форму назначения ручных скидок.
//
// Параметры:
//  АдресВоВременномХранилище - Строка - Адрес дополнительных данных во временном хранилище.
//  Валюта - СправочникСсылка.Валюты - Валюта.
//  ОповещениеОЗакрытии - ОписаниеОповещения - Оповещение о закрытии.
//  ИспользоватьОграниченияРучныхСкидок - Булево - Признак использования ограничения ручных скидок.
//  ЭтоЗакупки - Булево - Признак закупок.
//
Процедура ОткрытьФормуНазначенияРучныхСкидок(АдресВоВременномХранилище,
	                                       Валюта,
										   ОповещениеОЗакрытии,
	                                       ИспользоватьОграниченияРучныхСкидок = Истина,
	                                       ЭтоЗакупки = Ложь) Экспорт

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВоВременномХранилище",             АдресВоВременномХранилище);
	ПараметрыФормы.Вставить("Валюта",                                Валюта);
	ПараметрыФормы.Вставить("ИспользоватьОграниченияРучныхСкидок",   ИспользоватьОграниченияРучныхСкидок);
	ПараметрыФормы.Вставить("ЭтоЗакупки", ЭтоЗакупки);

	ОткрытьФорму("ОбщаяФорма.НазначениеРучнойСкидкиНаценки", 
		ПараметрыФормы,
		,
		,
		,
		,
		ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

// Открыть форму назначения управляемых скидок наценок.
//
// Параметры:
//  АдресВоВременномХранилище - Строка - Адрес дополнительных данных во временном хранилище.
//  ОповещениеОЗакрытии - ОписаниеОповещения - Оповещение о закрытии.
//
Процедура ОткрытьФормуНазначенияУправляемыхСкидокНаценок(АдресВоВременномХранилище, ОповещениеОЗакрытии) Экспорт

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище);
	ОткрытьФорму("ОбщаяФорма.НазначениеАвтоматическихУправляемыхСкидокНаценок", 
		ПараметрыФормы,
		,
		,
		,
		,
		ОповещениеОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти

#Область ОбщиеПроцедурыФункцииФормУсловийПрименениСкидок

// Обновить автонаименование условия применения скидок.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма объекта.
//  Обновить - Булево - Признак необходимости обновления автонаименования.
//
Процедура ОбновитьАвтонаименованиеУсловияПримененияСкидок(Форма, Обновить = Истина) Экспорт
	
	Наименование = СкидкиНаценкиКлиентСервер.АвтоНаименованиеУсловияПредоставленияСкидки(Форма);
	Если Не ЗначениеЗаполнено(Форма.Объект.Наименование) ИЛИ (Обновить И Форма.ИспользуетсяАвтоНаименование И Не Форма.НаименованиеИзмененоПользователем) Тогда
		Форма.Объект.Наименование = Наименование;
		Форма.ИспользуетсяАвтоНаименование = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Сообщения

// Открыть форму сообщений
//
// Параметры:
//  СтруктураСообщений - Структура - Структура сообщений.
//  Форма - УправляемаяФорма - Форма объекта.
//
Процедура ОткрытьФормуСообщений(СтруктураСообщений, Форма) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.СообщенияСкидокНаценок", СтруктураСообщений, Форма, Форма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Разворачивает строки дерева либо безусловно, либо только указанные в списке.
//
// Параметры:
//  СтрокаДерева          - СтрокаДерева   - строка, чьи подчиненные элементы будут развернуты
//  ЭлементФормы          - ТаблицаФормы   - элемент формы, в котором располагается дерево.
//  РазвернутыеУзлыДерева - СписокЗначений - список, в котором хранятся значения скидок (наценок), соответствующие узлы которым будут развернуты.
//
Процедура РазвернутьДеревоСкидокРекурсивно(СтрокаДерева, ЭлементФормы, РазвернутыеУзлыДерева = Неопределено) Экспорт
	
	КоллекцияЭлементов = СтрокаДерева.ПолучитьЭлементы();
	Для каждого Элемент Из КоллекцияЭлементов Цикл
		
		Если РазвернутыеУзлыДерева <> Неопределено Тогда
			Если РазвернутыеУзлыДерева.НайтиПоЗначению(Элемент.Ссылка) <> Неопределено Тогда
				ЭлементФормы.Развернуть(Элемент.ПолучитьИдентификатор());
			КонецЕсли;
		Иначе
			ЭлементФормы.Развернуть(Элемент.ПолучитьИдентификатор());
		КонецЕсли;
		
		РазвернутьДеревоСкидокРекурсивно(Элемент, ЭлементФормы, РазвернутыеУзлыДерева);
		
	КонецЦикла;
	
КонецПроцедуры

// Определяет идентификатор строки дерева по значению одной из колонок
//
// Параметры:
//  ГдеИскать          - ДеревоЗначений - реквизит формы, содержащий дерево значений.
//  ДеревоЗначений     - Произвольный - значение, по которому выполняется поиск.
//  Колонка            - Строка - имя колонки дерева, в которой происходит поиск значения.
//  ИскатьВПодчиненных - Булево - признак необходимости поиска в подчиненных узлах.
//
Функция ИдентификаторСтрокиДерева(ГдеИскать, Значение, Колонка, ИскатьВПодчиненных) Экспорт
	
	ЭлементыДерева = ГдеИскать.ПолучитьЭлементы();
	
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева[Колонка] = Значение Тогда
			Возврат ЭлементДерева.ПолучитьИдентификатор();
		ИначеЕсли  ИскатьВПодчиненных Тогда
			НайденныйИдентификаторСтроки = ИдентификаторСтрокиДерева(ЭлементДерева, Значение, Колонка, ИскатьВПодчиненных);
			Если НайденныйИдентификаторСтроки >=0 Тогда
				Возврат НайденныйИдентификаторСтроки;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат -1;
	
КонецФункции

// Выполняет позиционирование на строке дерева по значению в заданной колонке
//
// Параметры:
//  СкидкаНаценка - Справочник.СкидкиНаценки - значение, на котором будет выполнено позиционирование.
//  ДеревоФормы   - ДеревоЗначений - реквизит формы, содержащий дерево значений.
//  ЭлементФормы  - ТаблицаФормы - элемент формы, в котором располагается дерево.
//  ИмяКолонки    - Строка - имя колонки дерева, в которой происходит поиск значения, на котором надо позиционироваться
//
Процедура ПозиционироватьсяНаЗначениеВДереве(СкидкаНаценка, ДеревоФормы, ЭлементФормы, ИмяКолонки) Экспорт
	
	Если Не СкидкаНаценка.Пустая() Тогда
		НайденныйИдентификатор = ИдентификаторСтрокиДерева(ДеревоФормы, СкидкаНаценка, ИмяКолонки, Истина);
		Если НайденныйИдентификатор <> -1 Тогда
			ЭлементФормы.ТекущаяСтрока = НайденныйИдентификатор;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры

// Если узел разворачивается, то скидка (наценка) данного узла сохраняется в списке, если сворачивается, то удаляется.
//
// Параметры:
//  Строка  - ДанныеФормыЭлементДерева - строка, которая разворачивается или сворачивается.
//  ЭлементФормы  - ТаблицаФормы - элемент формы, в котором располагается дерево.
//  СписокРазвернутыхУзлов  - СписокЗначений - список, в котором сохраняются развернутые узлы.
//  Разворачивание  - Булево - Истина, если узел разворачивается. Ложь, если сворачивается.
//
Процедура СохранитьПризнакРазвернутостиУзлаДереваВСписке(Строка, ЭлементФормы, СписокРазвернутыхУзлов, Разворачивание) Экспорт

	ДанныеСтроки = ЭлементФормы.ДанныеСтроки(Строка);
	Если ДанныеСтроки <> Неопределено Тогда
		
		НайденныйЭлементСписка = СписокРазвернутыхУзлов.НайтиПоЗначению(ДанныеСтроки.Ссылка);
		
		Если Разворачивание Тогда
			Если НайденныйЭлементСписка = Неопределено Тогда
				СписокРазвернутыхУзлов.Добавить(ДанныеСтроки.Ссылка);
			КонецЕсли;
		Иначе
			Если НайденныйЭлементСписка <> Неопределено Тогда
				СписокРазвернутыхУзлов.Удалить(НайденныйЭлементСписка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры 

// Открывает форму установки статуса скидки (наценки) по источнику
//
// Параметры:
//  Форма    - УправляемаяФорма - форма, из которой открывается форма установки статуса.
//  Статус    - Перечисления.СтатусыДействияСкидок - статус, который будет установлен.
//  Источник  - СправочникСсылка.Склады, СправочникСсылка.ВидыКартЛояльности, СправочникСсылка.СоглашенияСКлиентом - источник действия скидок,
//
Процедура ОткрытьФормуУстановкиСтатуса(Форма, Статус, Источник) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Источник) Тогда
		ТекстВопроса = НСтр("ru='Для изменения статуса действия скидки (наценки) необходимо записать объект. Записать?'");
		Ответ = Неопределено;
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ОткрытьФормуУстановкиСтатусаЗавершение", ЭтотОбъект, Новый Структура("Источник, Статус, Форма", Источник, Статус, Форма)), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуУстановкиСтатусаФрагмент(Источник, Статус, Форма);
	
КонецПроцедуры

// *Служебная процедура
Процедура ОткрытьФормуУстановкиСтатусаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Источник = ДополнительныеПараметры.Источник;
	Статус = ДополнительныеПараметры.Статус;
	Форма = ДополнительныеПараметры.Форма;
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Форма.Записать();
	Иначе
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуУстановкиСтатусаФрагмент(Источник, Статус, Форма);
	
КонецПроцедуры

// *Служебная процедура
Процедура ОткрытьФормуУстановкиСтатусаФрагмент(Знач Источник, Знач Статус, Знач Форма)
	
	Перем ИдентификаторСтроки, МассивСкидкиНаценки, ПараметрыОткрытия, СтрокаТЧ;
	
	МассивСкидкиНаценки = Новый Массив;
	МассивПозицииНоменклатуры = Новый Массив;
	
	ТипЗнчИсточник = ТипЗнч(Источник);
	
	Если ТипЗнчИсточник = Тип("СправочникСсылка.СоглашенияСКлиентами")
		ИЛИ ТипЗнчИсточник = Тип("СправочникСсылка.ВидыКартЛояльности")
		ИЛИ ТипЗнчИсточник = Тип("СправочникСсылка.Склады") Тогда
		
		Для Каждого ИдентификаторСтроки Из Форма.Элементы.СкидкиНаценки.ВыделенныеСтроки Цикл
			СтрокаТЧ = Форма.СкидкиНаценки.НайтиПоИдентификатору(ИдентификаторСтроки);
			Если СтрокаТЧ.ЭтоГруппа Тогда
				Продолжить;
			КонецЕсли;
			МассивСкидкиНаценки.Добавить(СтрокаТЧ.Ссылка);
		КонецЦикла;
		
		Если МассивСкидкиНаценки.Количество() = 0 Тогда
			ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Не выбраны скидки (наценки) для изменения статуса.'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнчИсточник = Тип("СправочникСсылка.УсловияПредоставленияСкидокНаценок")
		ИЛИ ТипЗнчИсточник = Тип("СправочникСсылка.СкидкиНаценки") Тогда
		
		Для Каждого ИдентификаторСтроки Из Форма.Элементы.Товары.ВыделенныеСтроки Цикл
			СтрокаТЧ = Форма.Элементы.Товары.ДанныеСтроки(ИдентификаторСтроки);
			НоваяСтрока = Новый Структура;
			НоваяСтрока.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
			НоваяСтрока.Вставить("Характеристика", СтрокаТЧ.Характеристика);
			МассивПозицииНоменклатуры.Добавить(НоваяСтрока);
		КонецЦикла;
		
		Если МассивПозицииНоменклатуры.Количество() = 0 Тогда
			ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Не выбраны позиции номенклатуры для изменения статуса.'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ДатаНачала",          Форма.ДатаСреза);
	ПараметрыОткрытия.Вставить("СкидкаНаценка",       МассивСкидкиНаценки);
	ПараметрыОткрытия.Вставить("ПозицияНоменклатуры", МассивПозицииНоменклатуры);
	ПараметрыОткрытия.Вставить("Источник", Источник);
	ПараметрыОткрытия.Вставить("Статус",   Статус);
	
	ОткрытьФорму(
		"Справочник.СкидкиНаценки.Форма.УстановкаСтатусаДействия",
		ПараметрыОткрытия,
		Форма);
	
КонецПроцедуры

// Открывает форму истории изменения статуса скидки (наценки) по источнику
//
// Параметры:
//  Форма    - УправляемаяФорма - форма, из которой открывается история.
//  Источник  - СправочникСсылка.Склады, СправочникСсылка.ВидыКартЛояльности, СправочникСсылка.СоглашенияСКлиентом - источник действия скидок,
//              если Неопределено, то источником считается объект формы, из которой открывается история.
//
Процедура ОткрытьФормуИсторииИзмененияСтатуса(Форма, Источник = Неопределено) Экспорт
	
	Если Источник = Неопределено Тогда
		Источник = Форма.Объект.Ссылка;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Источник) Тогда
		ТекстПредупреждения = НСтр("ru='Для данного объекта еще нет истории изменения статусов
		                            |действия скидок (наценок) так как объект еще не записан.'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	СкидкаНаценка = Неопределено;
	ПозицияНоменклатуры = Неопределено;
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Элементы, "СкидкиНаценки") Тогда
		ТекущиеДанные = Форма.Элементы.СкидкиНаценки.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ЭтоГруппа Тогда
			Возврат;
		КонецЕсли;
		СкидкаНаценка = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	Если (Источник = Неопределено ИЛИ ТипЗнч(Источник) = Тип("СправочникСсылка.СкидкиНаценки"))
		И ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма.Элементы, "Товары") Тогда
		
		ТекущиеДанные = Форма.Элементы.Товары.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ПозицияНоменклатуры = Новый Структура(
			"Номенклатура, Характеристика",
			ТекущиеДанные.Номенклатура,
			ТекущиеДанные.Характеристика);
		
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Источник",            Источник);
	ПараметрыОткрытия.Вставить("СкидкаНаценка",       СкидкаНаценка);
	ПараметрыОткрытия.Вставить("ПозицияНоменклатуры", ПозицияНоменклатуры);
	ОткрытьФорму(
		"Справочник.СкидкиНаценки.Форма.ИсторияДействияСкидкиНаценки",
		ПараметрыОткрытия,
		Форма);
		
КонецПроцедуры

#КонецОбласти
