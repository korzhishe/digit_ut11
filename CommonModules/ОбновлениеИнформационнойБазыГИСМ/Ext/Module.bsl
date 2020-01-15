﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки интеграции с ГИСМ.
// 
/////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Получение сведений о библиотеке (или конфигурации).

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииПодсистемы
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаСистемыМаркировки";
	Описание.Версия = "1.0.4.1";
	Описание.РежимВыполненияОтложенныхОбработчиков = "Параллельно";
	
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	Описание.ТребуемыеПодсистемы.Добавить("БиблиотекаПодключаемогоОборудования");
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.5";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыГИСМ.НачальноеЗаполнение";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение версии схем обмена с ГИСМ.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.2.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыГИСМ.НастройкиОбменаГИСМ_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыГИСМ.НастройкиОбменаГИСМ_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ЧитаемыеОбъекты = "Константа.НастройкиОбменаГИСМ";
	Обработчик.ИзменяемыеОбъекты = "Константа.НастройкиОбменаГИСМ";
	Обработчик.Комментарий = НСтр("ru = 'Обновление настроек обмена с ГИСМ.'");
	
	ТипОрганизация = Метаданные.ОпределяемыеТипы.Организация.Тип.Типы()[0];
	ПредставлениеТипа = Метаданные.НайтиПоТипу(ТипОрганизация).ПолноеИмя();
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.2.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "РегистрыСведений.ОрганизацииДляОбменаГИСМ.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ОрганизацииДляОбменаГИСМ.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ЧитаемыеОбъекты = ПредставлениеТипа;
	Обработчик.ИзменяемыеОбъекты = "РегистрСведений.ОрганизацииДляОбменаГИСМ";
	Обработчик.Комментарий = НСтр("ru = 'Перенос GLN из справочника организаций в регистр ""Организации для обмена с ГИСМ"".'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.2.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "РегистрыСведений.ОчередьПолученияКвитанцийОФиксацииГИСМ.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.ОчередьПолученияКвитанцийОФиксацииГИСМ.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ЧитаемыеОбъекты   = "РегистрСведений.ОчередьПолученияКвитанцийОФиксацииГИСМ";
	Обработчик.ИзменяемыеОбъекты = "РегистрСведений.ОчередьПолученияКвитанцийОФиксацииГИСМ";
	Обработчик.Комментарий = НСтр("ru = 'Заполнение ресурса GLN в регистре ""Очередь получения квитанций о фиксации ГИСМ"".'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.2.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "Справочники.ВидыМехаГИСМ.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ВидыМехаГИСМ.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ЧитаемыеОбъекты   = "Справочник.ВидыМехаГИСМ";
	Обработчик.ИзменяемыеОбъекты = "Справочник.ВидыМехаГИСМ";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет справочник ""Виды меха ГИСМ"" согласно новым данным классификатора.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.2.1";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "Документы.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 2;
	Обработчик.ЧитаемыеОбъекты = "Справочник.ВидыМехаГИСМ,"
	                           + "Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ";
	Обработчик.ИзменяемыеОбъекты = "Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ";
	Обработчик.Комментарий = НСтр("ru = 'Очищает в документе ""Уведомление об импорте маркированных товаров"" виды меха не соответствующие новому классификатору.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.2.5";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыГИСМ.ВерсииСхемОбменаГИСМ_ВерсияСхемОбменаПоУмолчанию_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыГИСМ.ВерсииСхемОбменаГИСМ_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ЧитаемыеОбъекты   = "Константа.ВерсииСхемОбменаГИСМ";
	Обработчик.ИзменяемыеОбъекты = "Константа.ВерсииСхемОбменаГИСМ";
	Обработчик.Комментарий = НСтр("ru = 'Обновление версии схем обмена с ГИСМ до 2.41'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.2.6";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "РегистрыСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ОчередьОтложеннойОбработки = 1;
	Обработчик.ЧитаемыеОбъекты   = "РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ";
	Обработчик.ИзменяемыеОбъекты = "РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ";
	Обработчик.Комментарий = НСтр("ru = 'Обработка ошибочно присвоенного статуса документа ""Уведомление об отгрузке маркированной продукции"".'");
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПередОбновлениемИнформационнойБазы
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	ИдентификаторБиблиотекаИнтеграцииГИСМ = "БиблиотекаИнтеграцииГИСМ";
	ВерсияБиблиотекаИнтеграцииГИСМ = ОбновлениеИнформационнойБазы.ВерсияИБ(ИдентификаторБиблиотекаИнтеграцииГИСМ);
	Если ВерсияБиблиотекаИнтеграцииГИСМ <> "0.0.0.0" Тогда
		
		ОбновлениеИнформационнойБазы.УстановитьВерсиюИБ("БиблиотекаСистемыМаркировки", ВерсияБиблиотекаИнтеграцииГИСМ, Ложь);
		
		Если ОбщегоНазначения.РазделениеВключено() Тогда
			ИмяРегистра = "ВерсииПодсистемОбластейДанных";
		Иначе
			ИмяРегистра = "ВерсииПодсистем";
		КонецЕсли;
		
		Набор = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
		Набор.Отбор.ИмяПодсистемы.Установить(ИдентификаторБиблиотекаИнтеграцииГИСМ);
		Набор.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПослеОбновленияИнформационнойБазы
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// См. процедуру ОбновлениеИнформационнойБазыБСП.ПриПодготовкеМакетаОписанияОбновлений
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
// Пример добавления процедуры-обработчика в список:
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

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура НачальноеЗаполнение() Экспорт
	
	ИнтеграцияГИСМ.ПроверитьОбновитьВерсиюСхемОбмена(ИнтеграцияГИСМ.ВерсияСхемОбменаПоУмолчанию(), Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы_ВерсииСхемОбменаГИСМ

Процедура ВерсииСхемОбменаГИСМ_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Ложь;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.ВерсииСхемОбменаГИСМ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиПродукцииВГИСМ") Тогда
			
			НоваяВерсия = ИнтеграцияГИСМВызовСервера.АктуальнаяВерсияСхемОбмена();
			
			Если ЗначениеЗаполнено(НоваяВерсия) Тогда
				ИнтеграцияГИСМ.ПроверитьОбновитьВерсиюСхемОбмена(НоваяВерсия, Истина);
			Иначе
				ИнтеграцияГИСМ.ПроверитьОбновитьВерсиюСхемОбмена(ИнтеграцияГИСМ.ВерсияСхемОбменаПоУмолчанию(), Истина);
			КонецЕсли;
			
		Иначе
			
			ИнтеграцияГИСМ.ПроверитьОбновитьВерсиюСхемОбмена(ИнтеграцияГИСМ.ВерсияСхемОбменаПоУмолчанию(), Истина);
			
		КонецЕсли;
		
		ОбработкаЗавершена = Истина;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ОбработкаЗавершена = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Не удалось обработать константу ВерсииСхемОбменаГИСМ по причине: %Причина%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.Константы.ВерсииСхемОбменаГИСМ,,
			ТекстСообщения);
		
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ВерсииСхемОбменаГИСМ_ВерсияСхемОбменаПоУмолчанию_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Ложь;
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.ВерсииСхемОбменаГИСМ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		ИнтеграцияГИСМ.ПроверитьОбновитьВерсиюСхемОбмена(ИнтеграцияГИСМ.ВерсияСхемОбменаПоУмолчанию(), Истина);
		
		ОбработкаЗавершена = Истина;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ОбработкаЗавершена = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Не удалось обработать константу ВерсииСхемОбменаГИСМ по причине: %Причина%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.Константы.ВерсииСхемОбменаГИСМ,,
			ТекстСообщения);
		
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ВерсииСхемОбменаГИСМ_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы_НастройкиОбменаГИСМ

Процедура НастройкиОбменаГИСМ_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Константа.НастройкиОбменаГИСМ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		НастройкиОбмена = ИнтеграцияГИСМ.НастройкиОбменаГИСМ();
		
		Если НастройкиОбмена <> Неопределено Тогда
			
			Если НастройкиОбмена.Колонки.Найти("Подразделение") = Неопределено Тогда
				
				НастройкиОбмена.Колонки.Добавить("Подразделение", Метаданные.ОпределяемыеТипы.Подразделение.Тип);
				
				ХранилищеЗначения = Новый ХранилищеЗначения(НастройкиОбмена);
				
				МенеджерЗначения = Константы.НастройкиОбменаГИСМ.СоздатьМенеджерЗначения();
				МенеджерЗначения.Значение = ХранилищеЗначения;
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстСообщения = НСтр("ru = 'Не удалось обработать константу НастройкиОбменаГИСМ по причине: %Причина%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Предупреждение,
			Метаданные.Константы.НастройкиОбменаГИСМ,,
			ТекстСообщения);
		
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

Процедура НастройкиОбменаГИСМ_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПроверитьПолучитьОбъект(Ссылка,ВерсияДанных,Очередь) Экспорт
	
	Объект = Ссылка.ПолучитьОбъект();
	Если Объект = Неопределено Тогда
		ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Ссылка);
		Возврат Неопределено;
	КонецЕсли;
	Если Объект.ВерсияДанных <> ВерсияДанных Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат Объект;
	
КонецФункции

#КонецОбласти

#КонецОбласти
