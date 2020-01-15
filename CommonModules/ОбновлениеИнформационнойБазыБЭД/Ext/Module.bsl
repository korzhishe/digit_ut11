﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки электронных документов.
//
/////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает номер версии библиотеки электронных документов.
//
// Возвращаемое значение:
//  Строка - номер сборки.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат "1.3.9.78";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Получение сведений о библиотеке (или конфигурации).

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииПодсистемы.
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаЭлектронныхДокументов";
	Описание.Версия = ВерсияБиблиотеки();
	Описание.РежимВыполненияОтложенныхОбработчиков = "Параллельно";
	Описание.ПараллельноеОтложенноеОбновлениеСВерсии = "1.3.7.1";
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");
	ЕстьОбменСБанками = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками");
	ЕстьОбменССайтами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменССайтами");
	ЕстьБизнесСеть = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.БизнесСеть");
	
	// Обработчики для корневой подсистемы
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.3.9.54";
	Обработчик.Процедура = "Справочники.МаршрутыПодписания.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("f776e15c-cdf3-4712-a8e7-128edbcf4b1c");
	Обработчик.Комментарий = НСтр("ru = '1С:БЭД: Заполняет служебные свойства у предопределенных маршрутов. 
		|Работа с маршрутами подписания временно невозможна.'");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.МаршрутыПодписания.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.БлокируемыеОбъекты = "Справочник.МаршрутыПодписания";
	Обработчик.ЧитаемыеОбъекты = "Справочник.МаршрутыПодписания";
	Обработчик.ИзменяемыеОбъекты = "Справочник.МаршрутыПодписания";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	
	// Обработчики для дочерних подсистем

	Если ЕстьОбменСКонтрагентами Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.0.4.0";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВидыДокументов";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.0.5.0";
		Обработчик.Процедура = "РегистрыСведений.УдалитьУчастникиОбменовЭДЧерезОператоровЭДО.ОбновитьВерсиюРегламентаЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.3.7";
		Обработчик.Процедура = "РегистрыСведений.ЖурналСобытийЭД.ОбновитьСтатусыЭД";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.5.1";
		Обработчик.Процедура = "ОбменСКонтрагентами.ОбработатьКорректировочныеСчетаФактуры";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.6.3";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ЗаполнитьВерсииФорматов";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.7.1";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ПеренестиСертификатАвторизацииВТЧ";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.7.4";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ЗаполнитьВерсииФорматовИсходящихЭДИПакета";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.9.1";
		Обработчик.Процедура = "Справочники.УдалитьСертификатыЭП.ЗаполнитьСрокДействия";
		Обработчик.НачальноеЗаполнение = Ложь;
			
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.13.2";
		Обработчик.Процедура = "РегистрыСведений.УдалитьУчастникиОбменовЭДЧерезОператоровЭДО.ЗаменитьС1На2ВерсиюРегламентаЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.13.4";
		Обработчик.Процедура = "Справочники.ЭДПрисоединенныеФайлы.ЗаполнитьНаименованиеФайла";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.13.6";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВерсииФорматовИсходящихЭДИПакета";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.14.2";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ЗаполнитьИспользованиеКриптографии";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.1.14.2";
		Обработчик.Процедура = "Документы.УдалитьПроизвольныйЭД.ЗаполнитьТипДокумента";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.2.1";
		Обработчик.Процедура = "ОбменСКонтрагентами.ЗаполнитьДанныеОПрофиляхНастроекЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.2.2";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВерсиюФорматаИсходящихЭД207_208";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.4.4";
		Обработчик.Процедура = "Справочники.УдалитьСертификатыЭП.ПеренестиНастройкиСертификатов";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.4.4";
		Обработчик.Процедура = "Справочники.ЭДПрисоединенныеФайлы.ИзменитьСтатусыПроизвольныхЭДСНеОтправленНаСформирован";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.2";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбновитьВерсиюФорматаИсходящихЭД501_502";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.8";
		Обработчик.Процедура = "РегистрыСведений.СостоянияЭД.УдалитьСостояниеУдалитьОжидаетсяИзвещение";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("a351a845-1550-45d5-af0f-b3a5739a90ee");
		Обработчик.Комментарий = НСтр("ru = 'Изменяет состояние документов с ""Ожидается извещение"" на ""Ожидается извещение о получении""'");
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.1.9";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПроверитьКонтрагентовБЭД";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("28ce9ce8-fd89-44ed-9016-a904d4ff0990");
		Обработчик.Комментарий = НСтр("ru = 'Проверяет контрагентов на подключение к сервису 1С-ЭДО.'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.4";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.УдалитьОтветныеТитулы";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.20";
		Обработчик.Процедура = "ОбменСКонтрагентами.НастроитьАвтоПереходНаНовыеВерсииФорматовЭД";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.20";
		Обработчик.Процедура = "ОбменСКонтрагентами.УдалитьУстаревшиеОбработчики";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.4.8";
		Обработчик.Процедура = "ОбменСКонтрагентами.ДобавитьНовыеВидыЭДУПД_УКД";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.4";
		Обработчик.Процедура = "ОбменСКонтрагентами.ЗаполнитьВходящиеДокументыНастроек";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.4";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеревестиНаНовуюАрхитектуруЭДО";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f1");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Создает входящие и исходящие ЭД'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.4";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеревестиНаНовуюАрхитектуруПроизвольныхЭД";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f2");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Создает входящие и исходящие ЭД для произвольных ЭД'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.4";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеревестиНаНовуюАрхитектуруПакетыЭД";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f3");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Удаляет полученные и отправленные пакеты ЭД'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.7";
		Обработчик.Процедура = "ОбменСКонтрагентами.УдалитьНовыеВидыЭДУПД_УКД";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.7";
		Обработчик.Процедура = "Справочники.ПрофилиНастроекЭДО.ЗаполнитьРегламентЭДО";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.25";
		Обработчик.Процедура = "ОбменСКонтрагентами.УстановитьАктуальныеСостоянияЭД";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.25";
		Обработчик.Процедура = "Справочники.ПрофилиНастроекЭДО.СнятьФлагОтветнойПодписиУСчетаНаОплату";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.31";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеревестиНаНовуюАрхитектуруСтарыеУПДУКД";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.31";
		Обработчик.Процедура = "ОбменСКонтрагентами.ПеревестиНаНовуюАрхитектуруЭДОСтарыеCML";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f4");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Создает входящие и исходящие ЭД для старых CML документов'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.34";
		Обработчик.Процедура = "ОбменСКонтрагентами.ЗаполнитьДатуПоследнегоИзмененияСостоянияЭДО";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f5");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Заполняет дату последнего изменения состояния ЭДО'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.35";
		Обработчик.Процедура = "РегистрыСведений.ЖурналСобытийЭД.ЗаполнитьРесурсВладелецЭД";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("ea7baa79-5233-402b-93b5-02c740e8f200");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Заполнение регистра сведений Журнал событий ЭДО'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.38";
		Обработчик.Процедура = "ОбменСКонтрагентами.ЗаменитьУстаревшиеВидыЭД";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("100bcc56-1ab2-40a0-974c-b07c1b32e779");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Обновление устаревших видов ЭД'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.38";
		Обработчик.Процедура = "ОбменСКонтрагентами.ЗаполнитьСостоянияСтарыхУПДУКД";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("1516e625-bc4d-4e63-8f57-43c981f4ef52");
		Обработчик.Комментарий = НСтр("ru = 'Обмен с контрагентами: Обновление регистра сведений Состояния электронных документов'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.9.54";
		Обработчик.Процедура = "Справочники.СоглашенияОбИспользованииЭД.ОбработатьДанныеДляПереходаНаНовуюВерсию";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("b46394ef-478c-49bd-a670-c508adb73281");
		Обработчик.Комментарий = НСтр("ru = '1С:Обмен с контрагентами: заполняет маршруты в настройках ЭДО. 
			|Настройка и обмен электронными документами с контрагентами временно невозможен.'");
		Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.СоглашенияОбИспользованииЭД.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
		Обработчик.ПроцедураПроверки = "Справочники.СоглашенияОбИспользованииЭД.ДанныеОбновленыНаНовуюВерсиюПрограммы";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.БлокируемыеОбъекты = "Справочник.СоглашенияОбИспользованииЭД, 
			|Документ.ЭлектронныйДокументИсходящий,Документ.ЭлектронныйДокументВходящий";
		Обработчик.ЧитаемыеОбъекты = "Справочник.МаршрутыПодписания, Справочник.СоглашенияОбИспользованииЭД";
		Обработчик.ИзменяемыеОбъекты = "Справочник.СоглашенияОбИспользованииЭД";
		Обработчик.ОчередьОтложеннойОбработки = 3;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.9.54";
		Обработчик.Процедура = "Справочники.ПрофилиНастроекЭДО.ОбработатьДанныеДляПереходаНаНовуюВерсию";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("5e7bb05a-2a3a-4031-bddf-a71990eeb03b");
		Обработчик.Комментарий = НСтр("ru = '1С:Обмен с контрагентами: изменение параметров справочника профили настроек ЭДО.
			|Настройка и обмен электронными документами с контрагентами временно невозможен.'");
		Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ПрофилиНастроекЭДО.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
		Обработчик.ПроцедураПроверки = "Справочники.ПрофилиНастроекЭДО.ДанныеОбновленыНаНовуюВерсиюПрограммы";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.БлокируемыеОбъекты = "Справочник.ПрофилиНастроекЭДО, 
			|Документ.ЭлектронныйДокументИсходящий,Документ.ЭлектронныйДокументВходящий";
		Обработчик.ЧитаемыеОбъекты = "Справочник.МаршрутыПодписания, Справочник.ПрофилиНастроекЭДО";
		Обработчик.ИзменяемыеОбъекты = "Справочник.ПрофилиНастроекЭДО";
		Обработчик.ОчередьОтложеннойОбработки = 3;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.9.54";
		Обработчик.Процедура = "Справочники.ЭДПрисоединенныеФайлы.ОбработатьДанныеДляПереходаНаНовуюВерсию";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("d34ac738-363e-4eb7-be07-7c6d472bcc34");
		Обработчик.Комментарий = НСтр("ru = '1С:Обмен с контрагентами: изменение параметров справочника Присоединенные файлы (Электронные документы).
			|Настройка и обмен электронными документами с контрагентами временно невозможен.'");
		Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ЭДПрисоединенныеФайлы.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
		Обработчик.ПроцедураПроверки = "Справочники.ЭДПрисоединенныеФайлы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.БлокируемыеОбъекты = "Документ.ЭлектронныйДокументИсходящий,Документ.ЭлектронныйДокументВходящий,
			|Справочник.ЭДПрисоединенныеФайлы";
		Обработчик.ЧитаемыеОбъекты = "Справочник.МаршрутыПодписания, Справочник.ЭДПрисоединенныеФайлы, Документ.ЭлектронныйДокументИсходящий,
			|Документ.ЭлектронныйДокументВходящий, РегистрыСведений.СостояниеПодписанияЭД, РегистрСведений.ЭлектронныеПодписи";
		Обработчик.ИзменяемыеОбъекты = "Справочник.ЭДПрисоединенныеФайлы, РегистрыСведений.СостояниеПодписанияЭД,
			|Документ.ЭлектронныйДокументВходящий, Документ.ЭлектронныйДокументИсходящий, РегистрСведений.СостоянияЭД";
		Обработчик.ОчередьОтложеннойОбработки = 4;
		
		
		
	КонецЕсли;
	
	Если ЕстьБизнесСеть Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.5.3";
		Обработчик.Процедура = "РегистрыСведений.Пользователи1СБизнесСеть.ПереносЗаписейОрганизаций";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения") Тогда
			
			Обработчик = Обработчики.Добавить();
			Обработчик.Версия = "1.3.6.42";
			Обработчик.Процедура = "РегистрыСведений.СостоянияСинхронизацииТорговыеПредложения.ЗаполнениеОрганизаций";
			Обработчик.РежимВыполнения = "Отложенно";
			Обработчик.Идентификатор = Новый УникальныйИдентификатор("d44d4dde-0e11-4643-894a-81f059cd6d24");
			Обработчик.Комментарий = НСтр("ru = 'Торговые предложения: Обновление регистра сведений Состояние синхронизации (Торговые предложения)'");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьОбменССайтами Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.6.2";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.УстановитьЗначениеРеквизитовВыгрузки";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.3";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.ЗаполнитьРеквизитФормыСоответствиеСтатусовЗаказов";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.2.7.3";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.ЗаполнитьРеквизитФормыЕдиницаИзмеренияНовойНоменклатуры";
		Обработчик.НачальноеЗаполнение = Ложь;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.6.34";
		Обработчик.Процедура = "РегистрыСведений.СостоянияОбменовССайтом.ЗаполнитьСостоянияОбменовССайтами";
		Обработчик.РежимВыполнения = "Монопольно";
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.7.5";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.ПеренестиПарольВБезопасноеХранилище";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.Комментарий = НСтр("ru = 'Обмен с сайтом: Перенос пароля в безопасное хранилище.'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.7.5";
		Обработчик.Процедура = "ПланыОбмена.ОбменССайтом.ЗаполнитьРеквизитыНастройкиОбмена";
		Обработчик.РежимВыполнения = "Монопольно";
		Обработчик.Комментарий = НСтр("ru = 'Обмен с сайтом: Заполнение настроек обмена с сайтом.'");
	КонецЕсли;
	
	Если ЕстьОбменСБанками И ЕстьОбменСКонтрагентами Тогда
	
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.1.1";
		Обработчик.Процедура = "ОбменСБанками.ПеренестиДанныеОбменаСБанками";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e2bf49f3-cca8-4a44-9dad-21b0f1d153f7");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Обновляет данные подсистемы Обмен с банками'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.1.1";
		Обработчик.Процедура = "ОбменСБанками.ОбработатьРегистрПодписываемыеВидыЭД";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("72fa8a62-3f99-4606-a4eb-92bcf23b6d8d");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Обновляет данные регистра Подписываемые виды ЭД'");
		
	КонецЕсли;
	
	Если ЕстьОбменСБанками Тогда
	
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.3.4";
		Обработчик.Процедура = "ОбменСБанками.ПеренестиДанныеДополнительныхОбработокВКонстанту";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("c008fa2f-33a5-4c51-b00f-25fbe916fb1a");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Переносит данные дополнительных обработок в константу'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.2.3";
		Обработчик.Процедура = "ОбменСБанками.ПеренестиСтатусыЭлектронныхПодписей";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("704454cb-bfa5-44ba-a9f0-8638aafa7efe");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Переносит статусы проверки подписей в присоединенные файлы'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.4.4";
		Обработчик.Процедура = "Справочники.НастройкиОбменСБанками.ЗаполнитьВерсиюФормата";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("788f991b-8283-4a84-a661-c021310a9cf9");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Заполняет версию формата.'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.4.8";
		Обработчик.Процедура = "ОбменСБанками.ВключитьАвтоматическоеОбновлениеСпискаБанков";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("d788ef99-4874-4b3b-81ac-671856a5b183");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Включает автоматическое обновление списка банков.'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.7.6";
		Обработчик.Процедура = "ОбменСБанками.ПеренестиВнешниеКомпонентыВСправочник";
		Обработчик.ОбщиеДанные = Истина;
		Обработчик.РежимВыполнения = "Оперативно";
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Переносит внешние компоненты в справочник. Обмен через внешний модуль временно невозможен.'");
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.9.14";
		Обработчик.Процедура = "Документы.СообщениеОбменСБанками.ОбработатьДанныеДляПереходаНаНовуюВерсию";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("1363a2fc-89ab-43e0-85b2-79355bdf89af");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: обработка сообщений обмена с банком.
											|Обмен с банками временно невозможен.'");
		Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.СообщениеОбменСБанками.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
		Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.БлокируемыеОбъекты = "Документ.СообщениеОбменСБанками";
		Обработчик.ЧитаемыеОбъекты = "Справочник.НастройкиОбменСБанками, Документ.СообщениеОбменСБанками, РегистрСведений.СостояниеПодписанияЭД, РегистрСведений.ЭлектронныеПодписи";
		Обработчик.ИзменяемыеОбъекты = "Документ.СообщениеОбменСБанками, РегистрСведений.СостояниеПодписанияЭД, РегистрСведений.СостоянияОбменСБанками";
		Обработчик.ОчередьОтложеннойОбработки = 4;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.9.14";
		Обработчик.Процедура = "РегистрыСведений.СостоянияОбменСБанками.ОбработатьДанныеДляПереходаНаНовуюВерсию";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("e5444128-7069-469a-8c54-ed39deebebfe");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: Удаляет состояние На утверждении. Прямой обмен с банками временно невозможен.'");
		Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.СостоянияОбменСБанками.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
		Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
		Обработчик.БлокируемыеОбъекты = "РегистрСведений.СостоянияОбменСБанками";
		Обработчик.ЧитаемыеОбъекты = "РегистрСведений.СостоянияОбменСБанками";
		Обработчик.ИзменяемыеОбъекты = "РегистрСведений.СостоянияОбменСБанками";
		Обработчик.ОчередьОтложеннойОбработки = 5;
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "1.3.9.52";
		Обработчик.Процедура = "Справочники.НастройкиОбменСБанками.ОбработатьДанныеДляПереходаНаНовуюВерсию";
		Обработчик.РежимВыполнения = "Отложенно";
		Обработчик.Идентификатор = Новый УникальныйИдентификатор("a9a378c4-1fcc-4082-93b4-234a4837103f");
		Обработчик.Комментарий = НСтр("ru = '1С:ДиректБанк: обновление настроек обмена с банками.
											|Обмен с банками временно невозможен.'");
		Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.НастройкиОбменСБанками.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
		Обработчик.ПроцедураПроверки = "Справочники.НастройкиОбменСБанками.ДанныеОбновленыНаНовуюВерсиюПрограммы";
		Обработчик.НачальноеЗаполнение = Ложь;
		Обработчик.БлокируемыеОбъекты = "Справочник.НастройкиОбменСБанками";
		Обработчик.ЧитаемыеОбъекты = "Справочник.НастройкиОбменСБанками";
		Обработчик.ИзменяемыеОбъекты = "Справочник.НастройкиОбменСБанками, Справочник.ДополнительныеВнешниеКомпоненты";
		Обработчик.ОчередьОтложеннойОбработки = 3;
		
	КонецЕсли;
	
	
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПередОбновлениемИнформационнойБазы.
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПослеОбновленияИнформационнойБазы.
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ИтерацииОбновления, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриПодготовкеМакетаОписанияОбновлений.
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
		
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 
КонецПроцедуры

#КонецОбласти
