﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы Библиотеки подключаемого оборудования (БПО).
// 
/////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаПодключаемогоОборудования";
	Описание.Версия = МенеджерОборудованияВызовСервера.ВерсияБиблиотеки();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре.
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Монопольно";
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБПО.ОбновитьПоставляемыеДрайвера";
	Обработчик.Комментарий = НСтр("ru = 'Обновление поставляемых драйверов подключаемого оборудования.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБПО.ОбновитьПараметрыККТ";
	Обработчик.Комментарий = НСтр("ru = 'Обновление параметров ККТ.'");
	
КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - если установить Истина, то будет выведена форма
//                                с описанием обновлений. По умолчанию, Истина.
//                                Возвращаемое значение.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
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

#Область ПроцедурыОбновления

// Обновить поставляемые драйвера БПО.
//
Процедура ОбновитьПоставляемыеДрайвера(Параметры = Неопределено) Экспорт
	
	МенеджерОборудованияВызовСервераПереопределяемый.ОбновитьПоставляемыеДрайвера();
	МенеджерОборудованияВызовСервераПереопределяемый.ОбновитьУстановленныеДрайвера();
	
КонецПроцедуры

// Обновить параметры ККТ.
//
Процедура ОбновитьПараметрыККТ(Параметры = Неопределено) Экспорт
	
	МенеджерОборудованияВызовСервераПереопределяемый.ОбновитьПараметрыККТ();
	
КонецПроцедуры

#КонецОбласти