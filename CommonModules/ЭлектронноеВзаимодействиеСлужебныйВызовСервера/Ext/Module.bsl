﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеСлужебныйВызовСервера: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Получает значение функциональной опции.
//
// Параметры:
//  НаименованиеФО - Строка, имя функциональной опции.
//
// Возвращаемое значение:
//  ЗначениеВозврата - булево, признак включенной ФО.
//
Функция ЗначениеФункциональнойОпции(НаименованиеФО) Экспорт
	
	СоответствиеФО = Новый Соответствие;
	
	// Библиотека стандартных подсистем
	
	ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьСоответствиеФункциональныхОпций(СоответствиеФО);
	
	// Электронные документы
	СоответствиеФО.Вставить("ИспользоватьОбменЭД",                    "ИспользоватьОбменЭД");
	СоответствиеФО.Вставить("ИспользоватьОбменЭДМеждуОрганизациями",  "ИспользоватьОбменЭДМеждуОрганизациями");
	СоответствиеФО.Вставить("ИспользоватьОбменСБанками",              "ИспользоватьОбменСБанками");
	СоответствиеФО.Вставить("ИспользоватьЭлектронныеПодписиЭД",       "ИспользоватьЭлектронныеПодписиЭД");
	СоответствиеФО.Вставить("ИспользоватьИнтеграциюСЯндексКассой",    "ИспользоватьИнтеграциюСЯндексКассой");
	
	ИмяФОПрикладногоРешения = СоответствиеФО.Получить(НаименованиеФО);
	Если ИмяФОПрикладногоРешения = Неопределено Тогда // не задано соответствие
		Результат = Ложь;
	Иначе
		Результат = ПолучитьФункциональнуюОпцию(ИмяФОПрикладногоРешения)
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Преобразует двоичные данные в строку на сервере.
//
// Параметры:
//  ДвоичныеДанные - ДвоичныеДанные.
//
// Возвращаемое значение:
//  <Строка> - Строка в кодировке UTF8.
//
Функция СтрокаИзДвоичныхДанных(ДвоичныеДанные) Экспорт
	
	Если ТипЗнч(ДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		ВремФайл = ПолучитьИмяВременногоФайла();
		ДвоичныеДанные.Записать(ВремФайл);
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ВремФайл, КодировкаТекста.UTF8);
		
		ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ВремФайл);
		
		Результат = ТекстовыйДокумент.ПолучитьТекст();
		Возврат Результат;
	Иначе
		Возврат ДвоичныеДанные;
	КонецЕсли;
	
КонецФункции

// Возвращает имя прикладного справочника по имени библиотечного справочника.
//
// Параметры:
//  ИмяСправочника - Строка - название справочника из библиотеки.
//
// Возвращаемое значение:
//  Строка - строковое имя прикладного справочника.
//
Функция ИмяПрикладногоСправочника(ИмяСправочника) Экспорт
	
	Возврат ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(ИмяСправочника);
	
КонецФункции

// Изменяет поведение элементов управляемой или обычной формы.
//
// Параметры:
//  Форма - <Управляемая или обычная форма> - управляемая или обычная форма для изменения.
//  СтруктураПараметров - <Структура> - параметры процедуры.
//
Процедура ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров) Экспорт
	
	ЭлектронноеВзаимодействиеПереопределяемый.ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров)
	
КонецПроцедуры

// Возвращает массив документов, которые могут быть проведены.
//
// Параметры:
//  МассивДокументов - Массив - массив ссылок на документы.
//
// Возвращаемое значение:
//  Массив - массив документов, которые можно проводить.
//
Функция МассивПроводимыхДокументов(МассивДокументов) Экспорт
	
	МассивПроводныхДокументов = Новый Массив;
	МассивТиповНеПроводныхДокументов = Новый Массив;
	Для каждого Элемент Из МассивДокументов Цикл
		ИмяДокумента = Элемент.Метаданные().ПолноеИмя();
		Если Метаданные.Документы.Содержит(Метаданные.НайтиПоПолномуИмени(ИмяДокумента)) Тогда
			
			Если Элемент.Метаданные().Проведение = Метаданные.СвойстваОбъектов.Проведение.Запретить Тогда
				Если МассивТиповНеПроводныхДокументов.Найти(ТипЗнч(Элемент)) = Неопределено Тогда
					МассивТиповНеПроводныхДокументов.Добавить(ТипЗнч(Элемент));
				КонецЕсли;
			КонецЕсли;
			
			МассивПроводныхДокументов.Добавить(Элемент)
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТипНеПроводногоДокумента Из МассивТиповНеПроводныхДокументов Цикл
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияТипаИзМассива(МассивПроводныхДокументов, ТипНеПроводногоДокумента);
	КонецЦикла;
	
	Возврат МассивПроводныхДокументов;
	
КонецФункции

// Проверяет проведенность документов.
//
// Параметры:
//  МассивДокументов - Массив - документы, проведенность которых необходимо проверить.
//
// Возвращаемое значение:
//  Массив - непроведенные документы из массива Документы.
//
Функция ПроверитьПроведенностьДокументов(МассивДокументов) Экспорт 
	
	ПроводимыеДокументы = МассивПроводимыхДокументов(МассивДокументов);
	Возврат ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ПроводимыеДокументы);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Права

// Только для внутреннего использования
Функция ЕстьПравоЧтенияЭД(ВыводитьСообщение = Истина) Экспорт
	
	ЕстьПраво = ЭлектронноеВзаимодействиеПереопределяемый.ЕстьПравоЧтенияЭД();
	Если ТипЗнч(ЕстьПраво) <> Тип("Булево") Тогда
		ЕстьПраво = Пользователи.РолиДоступны("ВыполнениеОбменаЭД, ЧтениеЭД");
	КонецЕсли;	
	Если НЕ ЕстьПраво И ВыводитьСообщение Тогда
		ЭлектронноеВзаимодействиеСлужебный.СообщитьПользователюОНарушенииПравДоступа();
	КонецЕсли;
		
	Возврат ЕстьПраво;
		
КонецФункции

// Только для внутреннего использования
Функция ЕстьПравоОбработкиЭД(ВыводитьСообщение = Истина) Экспорт
	
	ЕстьПраво = ЭлектронноеВзаимодействиеПереопределяемый.ЕстьПравоОбработкиЭД();
	Если ТипЗнч(ЕстьПраво) <> Тип("Булево") Тогда
		ЕстьПраво = Пользователи.РолиДоступны("ВыполнениеОбменаЭД");
	КонецЕсли;
	
	Если НЕ ЕстьПраво И ВыводитьСообщение Тогда
		ЭлектронноеВзаимодействиеСлужебный.СообщитьПользователюОНарушенииПравДоступа();
	КонецЕсли;
	
	Возврат ЕстьПраво;
	
КонецФункции

// Только для внутреннего использования
Функция ЕстьПравоНастройкиЭДО(ВыводитьСообщение = Истина) Экспорт
	
	ЕстьПраво = Пользователи.РолиДоступны("НастройкаПараметровЭД");
	
	Если НЕ ЕстьПраво И ВыводитьСообщение Тогда
		ЭлектронноеВзаимодействиеСлужебный.СообщитьПользователюОНарушенииПравДоступа();
	КонецЕсли;
	
	Возврат ЕстьПраво;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Ошибки и сообщения

// Возвращает текст сообщения пользователю по коду ошибки.
//
// Параметры:
//  КодОшибки - Строка * код ошибки.
//  СтороннееОписаниеОшибки - Строка - описание ошибки переданное другой системой.
//
// Возвращаемое значение:
//  Строка - переопределенное описание ошибки.
//
Функция ПолучитьСообщениеОбОшибке(КодОшибки, СтороннееОписаниеОшибки = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ШаблонСообщения = НСтр("ru = 'Код ошибки %1. %2'");
	
	СообщенияОшибок = Новый Соответствие;
	ИнициализацияСообщенийОшибок(СообщенияОшибок);
	
	СообщениеОбОшибке = СообщенияОшибок.Получить(КодОшибки);
	Если СообщениеОбОшибке = Неопределено ИЛИ НЕ ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		СообщениеОбОшибке = СтороннееОписаниеОшибки;
	КонецЕсли;
	
	ЭлектронноеВзаимодействиеПереопределяемый.ИзменитьСообщениеОбОшибке(КодОшибки, СообщениеОбОшибке);
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, КодОшибки, СообщениеОбОшибке);
	
	Возврат ТекстСообщения;
	
КонецФункции

// Обрабатывает исключительные ситуации по электронным документам.
//
// Параметры:
//  ВидОперации - строка - вид операции при которой возникло исключение.
//  ПодробныйТекстОшибки - строка - описание ошибки.
//  ТекстСообщения - строка - текст ошибки.
//  КодСобытия - Строка - код события, используется для стандартизации иерархии событий.
//                Может принимать значения: "ЭлектронноеВзаимодействие" - Общая подсистема, 
//                                          "ОбменСБанками" - Обмен с банками, 
//                                          "ОбменСКонтрагентами" - Обмен с контрагентами,
//                                          "ОбменССайтами" - Обмен с сайтами, 
//                                          "РегламентныеЗадания" - Регламентные задания, 
//                                          "БизнесСеть" - Бизнес-сеть,
//                                          "ИнтеграцияСЯндексКассой" - Интеграция с Яндекс.Кассой.
//  СсылкаНаОбъект - ДокументСсылка, СправочникСсылка - объект с которым связано данное событие.
//
Процедура ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, ТекстСообщения = "", КодСобытия = "ОбменСКонтрагентами", СсылкаНаОбъект = Неопределено) Экспорт
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь( , , Ложь);
	
	Если ЭтоПолноправныйПользователь И ЗначениеЗаполнено(ПодробныйТекстОшибки) И НЕ ПустаяСтрока(ТекстСообщения)
		И ПодробныйТекстОшибки <> ТекстСообщения Тогда
		ТекстСообщения = ТекстСообщения + Символы.ПС
			+ НСтр("ru ='Подробности см. в журнале регистрации.'");
	КонецЕсли;

	Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, СсылкаНаОбъект);
	КонецЕсли;
	Если Прав(ВидОперации, 1) <> "." Тогда
		ВидОперации = ВидОперации + ".";
	КонецЕсли;
	ТекстОшибки = СтрШаблон(НСтр("ru = 'Выполнение операции: %1
		|%2'"), ВидОперации, ПодробныйТекстОшибки);
	
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		ОбъектМетаданных = СсылкаНаОбъект.Метаданные();
	КонецЕсли;
	
	ЭлектронноеВзаимодействиеСлужебный.ВыполнитьЗаписьСобытияПоЭДВЖурналРегистрации(
		ТекстОшибки, КодСобытия, , ОбъектМетаданных, СсылкаНаОбъект);
	
КонецПроцедуры

// Возвращает текст сообщения пользователю о необходимости  настройки системы.
//
// Параметры:
//  ВидОперации - Строка - признак выполняемой операции.
//
// Возвращаемое значение:
//  ТекстСообщения - Строка - Строка сообщения.
//
Функция ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации) Экспорт
	
	ТекстСообщения = "";
	ЭлектронноеВзаимодействиеПереопределяемый.ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации, ТекстСообщения);
	Если НЕ ЗначениеЗаполнено(ТекстСообщения) Тогда
		Если ВРег(ВидОперации) = "РАБОТАСЭД" Тогда
			ТекстСообщения = НСтр("ru = 'Для работы с электронными документами необходимо
			|в настройках системы включить использование обмена электронными документами.'");
		ИначеЕсли ВРег(ВидОперации) = "ПОДПИСАНИЕЭД" Тогда
			ТекстСообщения = НСтр("ru = 'Для возможности подписания ЭД необходимо
			|в настройках системы включить опцию использования электронных цифровых подписей.'");
		ИначеЕсли ВРег(ВидОперации) = "НАСТРОЙКАКРИПТОГРАФИИ" Тогда
			ТекстСообщения = НСтр("ru = 'Для возможности настройки криптографии необходимо 
			|в настройках системы включить опцию использования электронных цифровых подписей.'");
		ИначеЕсли ВРег(ВидОперации) = "РАБОТАСБАНКАМИ" Тогда
			ТекстСообщения = НСтр("ru = 'Для возможности обмена ЭД с банками необходимо 
			|в настройках системы включить опцию использования прямого взаимодействия с банками.'");
		Иначе
			ТекстСообщения = НСтр("ru='Операция не может быть выполнена. Не выполнены необходимые настройки системы.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Криптография

// Находит существующий или создает новый элемент справочника СертификатыКлючейЭлектроннойПодписиИШифрования.
//
// Параметры:
//  ДвоичныеДанныеСертификата - ДвоичныеДанные - содержимое сертификата;
//  Организация - СправочникСсылка.Организации - организация;
//  ИнформацияОПрограммеКриптографии - Строка - название криптосредства;
//                                - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования - ссылка на программу криптографии.
//
// Возвращаемое значение:
//  СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - ссылка на новый сертификат.
//
Функция НайтиСоздатьСертификатЭП(ДвоичныеДанныеСертификата, Организация, ИнформацияОПрограммеКриптографии = Неопределено) Экспорт
	
	Если ТипЗнч(ИнформацияОПрограммеКриптографии) = Тип("Строка")  Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	ПрограммыЭлектроннойПодписиИШифрования.Ссылка
		               |ИЗ
		               |	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования
		               |ГДЕ
		               |	ПрограммыЭлектроннойПодписиИШифрования.ИмяПрограммы = &НазваниеПрограммыКриптографии";
		Запрос.УстановитьПараметр("НазваниеПрограммыКриптографии", ИнформацияОПрограммеКриптографии);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Программа = Выборка.Ссылка;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ИнформацияОПрограммеКриптографии) = Тип("СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования") Тогда
		Программа = ИнформацияОПрограммеКриптографии;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Организация", Организация);
	
	// Если в ИБ уже есть такой сертификат, и в нем заполнена программа криптографии, то не меняем программу,
	// т.к. он могла быть указана правильно вручную.
	СсылкаНаСертификат = ЭлектроннаяПодпись.СсылкаНаСертификат(ДвоичныеДанныеСертификата);
	Если НЕ ЗначениеЗаполнено(СсылкаНаСертификат)
		ИЛИ (ЗначениеЗаполнено(СсылкаНаСертификат)
				И НЕ ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаСертификат, "Программа"))) Тогда
		ДополнительныеПараметры.Вставить("Программа", Программа);
	КонецЕсли;
	
	Возврат ЭлектроннаяПодпись.ЗаписатьСертификатВСправочник(ДвоичныеДанныеСертификата, ДополнительныеПараметры);

КонецФункции

// Определяет, где нужно проводить крипто операции.
//
// Возвращаемое значение:
//  Булево - Истина, если криптография настроена на сервере или Ложь - если на клиенте.
//
Функция ВыполнятьКриптооперацииНаСервере() Экспорт
	
	Возврат ЭлектроннаяПодпись.СоздаватьЭлектронныеПодписиНаСервере();
	
КонецФункции

// Позволяет получить значения реквизитов сертификата ЭП.
//
// Параметры:
//  Сертификат ЭП - справочник-ссылка - ссылка на элемент справочника "Сертификаты ЭП".
//
// Возвращаемое значение:
//  Структура значений реквизитов.
//
Функция РеквизитыСертификата(СертификатЭП) Экспорт
	
	ПараметрыСертификата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СертификатЭП,
		"Отозван, Отпечаток, ДействителенДо, ПользовательОповещенОСрокеДействия,
		|Фамилия, Имя, Отчество, Должность, Организация, ДанныеСертификата,
		|Наименование, Пользователь, КомуВыдан, Фирма");
	ПараметрыСертификата.Вставить("ДвоичныеДанныеСертификата", ПараметрыСертификата.ДанныеСертификата.Получить());
	ПараметрыСертификата.Вставить("ВыбранныйСертификат", СертификатЭП);
	ПараметрыСертификата.Вставить("ПарольПолучен", Ложь);
	ПараметрыСертификата.Вставить("ПарольПользователя", Неопределено);
	
	// В БСП методах необходим параметр
	ПараметрыСертификата.Вставить("Комментарий", "");
	
	Возврат ПараметрыСертификата;
	
КонецФункции

// Позволяет получить свойства субъекта сертификата ЭП.
//
// Параметры:
//  Сертификат ЭП - справочник-ссылка - ссылка на элемент справочника "Сертификаты ЭП".
//
// Возвращаемое значение:
//  Структура свойств субъекта сертификата.
//
Функция СвойстваСубъектаСертификата(СертификатЭП) Экспорт

	ПараметрыСертификата = РеквизитыСертификата(СертификатЭП);
	Сертификат = Новый СертификатКриптографии(ПараметрыСертификата.ДвоичныеДанныеСертификата);
	
	Возврат ЭлектроннаяПодписьКлиентСервер.СвойстваСубъектаСертификата(Сертификат);
	
КонецФункции


// Возвращает пароль к сертификату, если доступен текущему пользователю.
// При вызове в привилегированном режиме текущий пользователь не учитывается.
//
// Параметры:
//  Сертификат - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования - вернуть пароль
//                 к указанному сертификату.
//  МассивОтпечатков - Массив - массив отпечатков сертификатов для которых требуется получить сохраненные пароли.
//              
// Возвращаемое значение:
//  Неопределено - пароль для указанного сертификата не указан.
//  Строка       - пароль для указанного сертификата.
//  Соответствие - все заданные пароли по массиву отпечатков,
//                 в виде ключ - сертификат и значение - пароль.
//
Функция ПарольКСертификату(Сертификат = Неопределено, МассивОтпечатков = Неопределено) Экспорт
	
	Если Не Пользователи.РолиДоступны("ДобавлениеИзменениеЭлектронныхПодписейИШифрование") Тогда
		Если Сертификат <> Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		Возврат Новый СписокЗначений;
	КонецЕсли;
		
	Если Сертификат <> Неопределено Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Данные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Сертификат,"ПаролиСертификатов");
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ТипЗнч(Данные) <> Тип("Соответствие") Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Пользователь = Пользователи.ТекущийПользователь();
		Пароль = Данные.Получить(Пользователь);
		
		Если ЗначениеЗаполнено(Пароль) Тогда
			Возврат Пароль;
		КонецЕсли;
		
		Пользователь = Справочники.Пользователи.ПустаяСсылка();
		Пароль = Данные.Получить(Пользователь);
		
		Если ЗначениеЗаполнено(Пароль) Тогда
			Возврат Пароль;
		КонецЕсли;
		
		Возврат Неопределено;
		
	КонецЕсли;
		
	Если МассивОтпечатков <> Неопределено Тогда
		
		ПаролиСертификатов = Новый Соответствие;
		
		УстановитьПривилегированныйРежим(Истина);
		
		Для Каждого Отпечаток Из МассивОтпечатков Цикл
			
			СертификатПоОтпечатку = ЭлектроннаяПодписьСлужебныйВызовСервера.СсылкаНаСертификат(Отпечаток,Неопределено);
			
			Если ЗначениеЗаполнено(СертификатПоОтпечатку) Тогда
				
				Данные = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(СертификатПоОтпечатку,"ПаролиСертификатов");
				
				Если ТипЗнч(Данные) <> Тип("Соответствие") Тогда
					Продолжить;
				КонецЕсли;
				
				Пользователь = Пользователи.ТекущийПользователь();
				Пароль = Данные.Получить(Пользователь);
				
				Если ЗначениеЗаполнено(Пароль) Тогда
					ПаролиСертификатов.Вставить(СертификатПоОтпечатку, Пароль);
				Иначе
					
					Пользователь = Справочники.Пользователи.ПустаяСсылка();
					Пароль = Данные.Получить(Пользователь);
					
					Если ЗначениеЗаполнено(Пароль) Тогда
						ПаролиСертификатов.Вставить(СертификатПоОтпечатку, Пароль);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Ложь);
		
		Возврат ПаролиСертификатов;
		
	КонецЕсли;
	
КонецФункции

// Находит сертификат по строке отпечатка.
//
// Параметры:
//  Отпечаток  - Строка - base64 кодированный отпечаток сертификата;
//  ТолькоВЛичномХранилище  - Булево - вести поиск только в личном хранилище.
//
// Возвращаемое значение:
//   СертификатКриптографии  - сертификат криптографии.
//
Функция ПолучитьСертификатПоОтпечатку(Отпечаток, ТолькоВЛичномХранилище = Ложь) Экспорт
	
	ДвоичныеДанныеОтпечатка = Base64Значение(Отпечаток);
	
	Отказ = Ложь;
	МенеджерКриптографии = ЭлектронноеВзаимодействиеСлужебный.МенеджерКриптографии(Отказ);
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ХранилищеСертификатовКриптографии = Неопределено;
	Если ТолькоВЛичномХранилище Тогда
		ХранилищеСертификатовКриптографии = МенеджерКриптографии.ПолучитьХранилищеСертификатов(
			ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	Иначе	
		ХранилищеСертификатовКриптографии = МенеджерКриптографии.ПолучитьХранилищеСертификатов();
	КонецЕсли;
	
	Сертификат = ХранилищеСертификатовКриптографии.НайтиПоОтпечатку(ДвоичныеДанныеОтпечатка);
	
	Возврат Сертификат;
	
КонецФункции

// Получает массив структур личных сертификатов для показа в диалоге выбора сертификатов для подписи или шифрования.
//
// Параметры:
//   ПоказыватьОшибку  - Булево - если Ложь, то ошибка создания менеджера криптографии не отображается.
//
// Возвращаемое значение:
//   Массив - массив структур с полями сертификата.
Функция МассивОтпечатковСертификатов(ПоказыватьОшибку = Истина) Экспорт
	
	МассивОтпечатков = Новый Массив;
	
	Если НЕ ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ВыполнятьКриптооперацииНаСервере() Тогда
		Возврат МассивОтпечатков;
	КонецЕсли;
	
	Отказ = Ложь;
	МенеджерКриптографии = ЭлектронноеВзаимодействиеСлужебный.МенеджерКриптографии(Отказ, ПоказыватьОшибку);
	Если Отказ Тогда
		Возврат МассивОтпечатков;
	КонецЕсли;
	
	ТекущаяДата = ТекущаяДатаСеанса(); // Используется для выявления истекших сертификатов, которые хранятся на клиентском компьютере.
	
	ХранилищеСертификатовКриптографии = МенеджерКриптографии.ПолучитьХранилищеСертификатов(
		ТипХранилищаСертификатовКриптографии.ПерсональныеСертификаты);
	СертификатыХранилища = ХранилищеСертификатовКриптографии.ПолучитьВсе();
	
	Для Каждого Сертификат Из СертификатыХранилища Цикл
		Если Сертификат.ДатаОкончания < ТекущаяДата Тогда
			Продолжить; // Пропуск истекших сертификатов.
		КонецЕсли;
		
		СтруктураСертификата = ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(Сертификат);
		Если СтруктураСертификата <> Неопределено Тогда
			СтрокаОтпечатка = Base64Строка(Сертификат.Отпечаток);
			Если МассивОтпечатков.Найти(СтрокаОтпечатка) = Неопределено Тогда
				МассивОтпечатков.Добавить(СтрокаОтпечатка);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивОтпечатков;
	
КонецФункции

// Получение структуры команд ЭДО из сохраненной настройки.
//  ИмяКоманды - Строка - имя команды.
//  АдресКомандВоВременномХранилище - Строка - адрес во временном хранилище.
//
Функция ОписаниеКомандыЭДО(ИмяКоманды, АдресКомандВоВременномХранилище) Экспорт
	
	КомандыЭДО = ПолучитьИзВременногоХранилища(АдресКомандВоВременномХранилище);
	Для Каждого КомандаЭДО Из КомандыЭДО.НайтиСтроки(Новый Структура("ИмяКомандыНаФорме", ИмяКоманды)) Цикл
		Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КомандаЭДО);
	КонецЦикла;
	
КонецФункции

// Проверяет будет ли пользователю показываться оповещение о наличии новых эд в сервисе 1С-ЭДО
// Возвращаемое значение:
//   Булево - результат проверки.
//
Функция ОповещатьОСобытияхЭДО() Экспорт
	
	Оповещать = Ложь;
	Если ЕстьПравоОбработкиЭД(Ложь)
		И ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ЕстьПроверкаНовыхЭД() Тогда
		Оповещать = Истина;
	КонецЕсли;
	
	Возврат Оповещать;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализацияСообщенийОшибок(СообщенияОшибок)
	
	// Общие коды ошибок
	СообщенияОшибок.Вставить("001", );
	СообщенияОшибок.Вставить("002", );
	СообщенияОшибок.Вставить("003", );
	СообщенияОшибок.Вставить("004", );
	СообщенияОшибок.Вставить("005", );
	СообщенияОшибок.Вставить("006", НСтр("ru = 'Невозможно извлечь файлы из архива. Путь к файлам архива должен быть короче 256 символов.
										|Возможные способы устранения ошибки:
										| - в настройках операционной системы, в переменных среды, изменить путь к временным файлам;'"));
	// Коды ошибок 1С
	СообщенияОшибок.Вставить("0", НСтр("ru = 'Одна из имеющихся в запросе подписей принадлежит неизвестному лицу.'"));
	СообщенияОшибок.Вставить("2", НСтр("ru = 'Одна из подписей неверна'"));
	СообщенияОшибок.Вставить("3", НСтр("ru = 'Должны быть представлены две разные подписи.'"));
	СообщенияОшибок.Вставить("4", НСтр("ru = 'Неверный тип содержимого: двоичный.'"));
	СообщенияОшибок.Вставить("5", НСтр("ru = 'Должна быть предоставлена хотя бы одна подпись.'"));
	СообщенияОшибок.Вставить("6", НСтр("ru = 'Не все подписи отличаются.'"));
	СообщенияОшибок.Вставить("7", НСтр("ru = 'Все подписи не обеспечивают уровень полномочий, необходимых для операции.'"));
	СообщенияОшибок.Вставить("8", НСтр("ru = 'Один из подписантов неизвестен.'"));
	СообщенияОшибок.Вставить("9", НСтр("ru = 'Содержимое типа транспортного сообщения является неправильным, ожидается: application/xml.'"));
	СообщенияОшибок.Вставить("10", НСтр("ru = 'Содержимое типа делового сообщения неверно, ожидается: application/xml.'"));
	СообщенияОшибок.Вставить("11", НСтр("ru = 'Не все подписи соответствуют одному и тому же клиенту.'"));
	СообщенияОшибок.Вставить("12", НСтр("ru = 'Всех имеющихся в запросе подписей недостаточно для того, чтобы получить право на доступ к запрашиваемому счету.'"));
	СообщенияОшибок.Вставить("13", НСтр("ru = 'HTTP запрос URL неверный. Поддерживаются только запросы ресурсов и состояния.'"));
	СообщенияОшибок.Вставить("14", НСтр("ru = 'Ошибка проверки транспортного контейнера.'"));
	СообщенияОшибок.Вставить("15", НСтр("ru = 'Ошибка проверки контейнера бизнес данных.
	                                          |Необходимо обратиться в тех.поддержку банка'"));
	СообщенияОшибок.Вставить("16", НСтр("ru = 'В выписке счета слишком малая начальная дата.'"));
	СообщенияОшибок.Вставить("17", НСтр("ru = 'В выписке счета слишком большая конечная дата.'"));
	СообщенияОшибок.Вставить("18", НСтр("ru = 'Неверная дата документа.'"));
	СообщенияОшибок.Вставить("19", НСтр("ru = 'Счет банка не соответствует БИК.'"));
	СообщенияОшибок.Вставить("21", НСтр("ru = 'Неразрешенная инструкция.'"));
	
	СообщенияОшибок.Вставить("100", НСтр("ru = 'Не удалось создать менеджер криптографии на компьютере.'"));
	СообщенияОшибок.Вставить("101", НСтр("ru = 'Сертификат не найден в хранилище сертификатов на компьютере.'"));
	СообщенияОшибок.Вставить("102", НСтр("ru = 'Сертификат не действителен.'"));
	СообщенияОшибок.Вставить("103", НСтр("ru = 'Не удалось выполнить операции шифрования/расшифровки на компьютере.'"));
	СообщенияОшибок.Вставить("104", НСтр("ru = 'Не удалось выполнить операции формирования/проверки ЭП на компьютере.'"));
	СообщенияОшибок.Вставить("105", НСтр("ru = 'Нет доступных сертификатов в хранилище сертификатов на компьютере.'"));
	
	СообщенияОшибок.Вставить("110", НСтр("ru = 'Не удалось создать менеджер криптографии на сервере.'"));
	СообщенияОшибок.Вставить("111", НСтр("ru = 'Сертификат не найден в хранилище сертификатов на сервере.'"));
	СообщенияОшибок.Вставить("112", НСтр("ru = 'Сертификат не действителен.'"));
	СообщенияОшибок.Вставить("113", НСтр("ru = 'Не удалось выполнить операции шифрования/расшифровки на сервере.'"));
	СообщенияОшибок.Вставить("114", НСтр("ru = 'Не удалось выполнить операции формирования/проверки ЭП на сервере.'"));
	СообщенияОшибок.Вставить("115", НСтр("ru = 'Нет доступных сертификатов в хранилище сертификатов на сервере.'"));
	
	СообщенияОшибок.Вставить("106", НСтр("ru = 'Версия платформы 1С ниже ""8.2.17"".'"));
	СообщенияОшибок.Вставить("107", НСтр("ru = 'Не удалось создать каталоги обмена.'"));
	
	СообщенияОшибок.Вставить("121", НСтр("ru = 'Не удалось соединиться с FTP сервером.'"));
	СообщенияОшибок.Вставить("122", НСтр("ru = 'Невозможно создать каталог, так как на FTP ресурсе существует файл с таким именем.'"));
	СообщенияОшибок.Вставить("123", НСтр("ru = 'Невозможно создать каталог.'"));
	СообщенияОшибок.Вставить("124", НСтр("ru = 'Невозможно открыть каталог.'"));
	СообщенияОшибок.Вставить("125", НСтр("ru = 'Произошла ошибка при поиске файлов на FTP ресурсе.'"));
	СообщенияОшибок.Вставить("126", НСтр("ru = 'Различаются данные записанного, а затем прочитанного тестового файла в каталоге.'"));
	СообщенияОшибок.Вставить("127", НСтр("ru = 'Не удалось записать файл в каталог.'"));
	СообщенияОшибок.Вставить("128", НСтр("ru = 'Не удалось прочитать файл в каталоге."));
	СообщенияОшибок.Вставить("129", НСтр("ru = 'Не удалось удалить файл.'"));
	
	// Коды ошибок оператора Такском.
	// Метод CertificateLogin: идентификация и авторизация.
	// Синхронный режим без обращения к БД.
	СообщенияОшибок.Вставить("2501", ); // Не указан идентификатор вендора (название параметра?) 400 0501.
	СообщенияОшибок.Вставить("3109", ); // Не указан сертификат 403 3100.
	СообщенияОшибок.Вставить("3107", ); // Некорректное тело сертификата 403 3107.
	СообщенияОшибок.Вставить("3101", ); // Сертификат просрочен 403 3101.
	СообщенияОшибок.Вставить("3102", ); // Для указанного сертификата не удалось построить цепочку доверия 403 3102.
	
	// Синхронный режим с обращением в БД.
	СообщенияОшибок.Вставить("1301", ); // Вендор с указанным идентификатором не прошел авторизацию 401 1300.
	СообщенияОшибок.Вставить("3103", НСтр("ru = 'Сертификат не привязан к ID Такском. Необходимо привязать сертификат в ручную на Админ.Такском.'")); // Сертификат не связан ни с одним абонентом Такском 403 3103
	СообщенияОшибок.Вставить("3104", ); // Сертификат связан с несколькими абонентами, но не указан идентификатор абонента (TaxcomID) 403 3104
	СообщенияОшибок.Вставить("3105", ); // Сертификат связан с несколькими абонентами, но указанный идентификатор абонента (TaxcomID) имеет неправильный формат 403 3105
	СообщенияОшибок.Вставить("3106", ); // Сертификат связан с несколькими абонентами, но указанный идентификатор абонента (TaxcomID) не связан ни с одним абонентом Такском 403 3106
	СообщенияОшибок.Вставить("1102", ); // Абоненту запрещен доступ к API 401 1100.
	СообщенияОшибок.Вставить("1101", ); // Доступ для данного абонента заблокирован 401 1101.
	СообщенияОшибок.Вставить("3108", ); // Сертификат отозван (в будущем) 403 3108.
	
	// Метод SendMessage: загрузка транспортных контейнеров
	// Синхронный режим без обращения к БД.
	СообщенияОшибок.Вставить("1201", ); // Истек 5-ти минутный срок действия токена (требуется повторная авторизация) 401 1200
	СообщенияОшибок.Вставить("2118", ); // Размер отправляемого контейнера не соответствует допустимому диапазону от 0 до (цифра!) 400 0100
	СообщенияОшибок.Вставить("2107", ); // Отправляемый контейнер не является ZIP-архивом 400 0107
	СообщенияОшибок.Вставить("2108", ); // В контейнере отсутствует необходимый файл meta.xml 400 0108
	СообщенияОшибок.Вставить("2109", ); // Файл meta.xml не является XML-файлом (стандарты?) 400 0109
	СообщенияОшибок.Вставить("2111", ); // Структура файла meta.xml не соответствует принятой схеме 400 0111
	СообщенияОшибок.Вставить("2101", ); // В файле meta.xml не указан корректный идентификатор документооборота (DocFlowID) 400 0101
	СообщенияОшибок.Вставить("2102", ); // В отправляемом контейнере обнаружены файлы, связанные более чем с одним документооборотом 400 0102
	СообщенияОшибок.Вставить("2113", ); // В данном документообороте возможна отправка только одного файла 400 0113
	СообщенияОшибок.Вставить("2103", ); // В файле meta.xml отсутствует код регламента (ReglamentCode) 400 0103
	СообщенияОшибок.Вставить("2114", ); // В файле meta.xml указан некорректный код регламента (ReglamentCode) 400 0114
	СообщенияОшибок.Вставить("2104", ); // В файле meta.xml отсутствует код транзакции (TransactionCode) 400 0104
	СообщенияОшибок.Вставить("2303", ); // Транзакция с кодом <TransactionCode> недопустима в документообороте < ReglamentCode > 400 0300
	СообщенияОшибок.Вставить("3108", ); // Файл <имя файла>, указанный в meta.xml, не найден в отправляемом контейнере 400 0105
	СообщенияОшибок.Вставить("0110", ); // Файл card.xml не является XML-файлом 400 0110
	СообщенияОшибок.Вставить("0112", ); // Структура файла card.xml не соответствует принятой схеме 400 0112
	СообщенияОшибок.Вставить("0106", НСтр("ru = 'В соглашении указан идентификатор организации некорректного формата.'")); // Неверный формат идентификатора отправителя (название параметра?) в файле card.xml 400 0106
	СообщенияОшибок.Вставить("0115", ); // Неверный формат идентификатора получателя (название параметра?) в файле card.xml 400 0115
	
	// Синхронный режим с обращением к БД
	СообщенияОшибок.Вставить("0201", ); // Идентификатор отправителя (название параметра?) соответствует учетной записи 400 0201
	СообщенияОшибок.Вставить("0401", ); // Документооборот с указанным идентификатором уже зарегистрирован (DocFlowID) 400 0401
	СообщенияОшибок.Вставить("0402", ); // Документооборот с указанным идентификатором не зарегистрирован (DocFlowID) 400 0402
	СообщенияОшибок.Вставить("0301", ); // Данная транзакция <код транзакции> уже была осуществлена для данного документооборота < DocFlowID > 400 0301
	
	// Асинхронный режим
	СообщенияОшибок.Вставить("0202", НСтр("ru = 'В соглашении указан идентификатор контрагента не зарегистрированный в Такском.'")); // Получатель с указанным идентификатором не зарегистрирован 0202
	СообщенияОшибок.Вставить("0203", ); // Получатель с указанным идентификатором не является контрагентом отправителя 0203
	СообщенияОшибок.Вставить("3200", ); // Документ не может быть отправлен в связи с ограничениями тарификации 3200
	
	// Метод GetMessageList: получение входящих транспортных контейнеров
	// Синхронный режим без обращения к БД.
	СообщенияОшибок.Вставить("0503", ); // Отсутствует обязательный параметр «метка времени (название параметра)» 400 0503
	СообщенияОшибок.Вставить("0504", ); // Некорректный формат метки времени 400 0504
	
	// Метод GetMessage: выгрузка входящих транспортных контейнеров
	// Синхронный режим без обращения к БД.
	СообщенияОшибок.Вставить("0505", ); // Отсутствует обязательный параметр идентификатор контейнера (документооборота) 400 0505
	СообщенияОшибок.Вставить("0502", ); // Неправильный формат идентификатора документооборота 400 0502
	
	// Синхронный режим с обращением к БД
	СообщенияОшибок.Вставить("4100", ); // Сообщение с данным <DocFlowID> идентификатором документооборота не найдено 404 4100
	
	// Общие ошибки сервера Такском
	СообщенияОшибок.Вставить("5101", ); // Внутренняя ошибка сервера 500 0000
	
КонецПроцедуры

#КонецОбласти
