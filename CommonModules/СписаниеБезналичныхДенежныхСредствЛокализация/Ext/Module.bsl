﻿
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	Движения = Объект.Движения;
	ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект.<Имя документа> - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//++ Локализация
	// Платежное поручение
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПлатежноеПоручение";
	КомандаПечати.Представление = НСтр("ru = 'Платежное поручение'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	// Банковские реквизиты
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РеквизитыПлатежа";
	КомандаПечати.Представление = НСтр("ru = 'Реквизиты международного платежа'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	//++ Локализация
	 Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПлатежноеПоручение") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ПлатежноеПоручение",
			НСтр("ru='Платежное поручение'"),
			СформироватьПлатежноеПоручение(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.СписаниеБезналичныхДенежныхСредств.ПФ_MXL_ПлатежноеПоручение");
			
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеквизитыПлатежа") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"РеквизитыПлатежа",
			НСтр("ru='Банковские реквизиты'"),
			СформироватьРеквизитыПлатежа(МассивОбъектов, ОбъектыПечати),
			,
			"Документ.СписаниеБезналичныхДенежныхСредств.ПФ_MXL_РеквизитыПлатежа");
	КонецЕсли; 	
	//-- Локализация
КонецПроцедуры

//++ Локализация
Функция СформироватьПлатежноеПоручение(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеБезналичныхДенежныхСредств_ПлатежноеПоручение";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеБезналичныхДенежныхСредств.ПФ_MXL_ПлатежноеПоручение");

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента
	|ПОМЕСТИТЬ БанковскиеСчетаКонтрагентовВрем
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&МассивДокументов)
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ДанныеДокумента.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&МассивДокументов)
	|	И ДанныеДокумента.ФормаОплатыБезналичная
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ДанныеДокумента.БанковскийСчетПолучатель КАК БанковскийСчетКонтрагента
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&МассивДокументов)
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ДанныеДокумента.БанковскийСчетПолучатель КАК БанковскийСчетКонтрагента
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&МассивДокументов)
	|	И ДанныеДокумента.ФормаОплатыБезналичная
	|;
	|
	|//////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документ.БанковскийСчет КАК БанковскийСчет
	|ПОМЕСТИТЬ БанковскиеСчетаОрганизацийВрем
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК Документ
	|ГДЕ
	|	Документ.Ссылка В (&МассивДокументов)
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ДанныеДокумента.БанковскийСчет КАК БанковскийСчет
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&МассивДокументов)
	|	И ДанныеДокумента.ФормаОплатыБезналичная
	|	
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ДанныеДокумента.БанковскийСчетКасса КАК БанковскийСчет
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.РаспределениеПоСчетам КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&МассивДокументов)
	|	И ДанныеДокумента.Ссылка.ФормаОплатыБезналичная
	|;
	|
	|//////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка КАК Ссылка,
	|	БанковскиеСчета.Владелец КАК Владелец,
	|	БанковскиеСчета.НомерСчета КАК НомерСчета,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.НаименованиеБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.Наименование
	|	КОНЕЦ КАК НаименованиеБанка,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.БИКБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.Код
	|	КОНЕЦ КАК БИК,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.КоррСчетБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.КоррСчет
	|	КОНЕЦ КАК КоррСчет,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.ГородБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.Город
	|	КОНЕЦ КАК Город,
	|	БанковскиеСчета.ТекстКорреспондента КАК ТекстКорреспондента,
	|	БанковскиеСчета.ИННКорреспондента КАК ИННКорреспондента,
	|	БанковскиеСчета.КППКорреспондента КАК КППКорреспондента
	|
	|ПОМЕСТИТЬ БанковскиеСчетаКонтрагентов
	|ИЗ
	|	Справочник.БанковскиеСчетаКонтрагентов КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов = ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В (
	|		ВЫБРАТЬ
	|			БанковскиеСчета.БанковскийСчетКонтрагента
	|		ИЗ
	|			БанковскиеСчетаКонтрагентовВрем КАК БанковскиеСчета
	|		)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка,
	|	БанковскиеСчета.Владелец,
	|	БанковскиеСчета.Банк.КоррСчет,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.НаименованиеБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.Наименование
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.БИКБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.Код
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.КоррСчетБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.КоррСчет
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.ГородБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.Город
	|	КОНЕЦ,
	|	БанковскиеСчета.ТекстКорреспондента,
	|	БанковскиеСчета.ИННКорреспондента,
	|	БанковскиеСчета.КППКорреспондента
	|ИЗ
	|	Справочник.БанковскиеСчетаКонтрагентов КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов <> ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В (
	|		ВЫБРАТЬ
	|			БанковскиеСчета.БанковскийСчетКонтрагента
	|		ИЗ
	|			БанковскиеСчетаКонтрагентовВрем КАК БанковскиеСчета
	|		)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка,
	|	БанковскиеСчета.Владелец,
	|	БанковскиеСчета.НомерСчета,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.НаименованиеБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.Наименование
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.БИКБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.Код
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.КоррСчетБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.КоррСчет
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.ГородБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.Город
	|	КОНЕЦ,
	|	БанковскиеСчета.ТекстКорреспондента,
	|	"""",
	|	""""
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов = ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В (
	|		ВЫБРАТЬ
	|			БанковскиеСчета.БанковскийСчетКонтрагента
	|		ИЗ
	|			БанковскиеСчетаКонтрагентовВрем КАК БанковскиеСчета
	|		)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка,
	|	БанковскиеСчета.Владелец,
	|	БанковскиеСчета.Банк.КоррСчет,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.НаименованиеБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.Наименование
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.БИКБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.Код
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.КоррСчетБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.КоррСчет
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.ГородБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.Город
	|	КОНЕЦ,
	|	БанковскиеСчета.ТекстКорреспондента,
	|	"""",
	|	""""
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов <> ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В (
	|		ВЫБРАТЬ
	|			БанковскиеСчета.БанковскийСчетКонтрагента
	|		ИЗ
	|			БанковскиеСчетаКонтрагентовВрем КАК БанковскиеСчета
	|		)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка КАК Ссылка,
	|	БанковскиеСчета.Владелец КАК Владелец,
	|	БанковскиеСчета.НомерСчета КАК НомерСчета,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.НаименованиеБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.Наименование
	|	КОНЕЦ КАК НаименованиеБанка,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.БИКБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.Код
	|	КОНЕЦ КАК БИК,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.КоррСчетБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.КоррСчет
	|	КОНЕЦ КАК КоррСчет,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанка ТОГДА
	|		БанковскиеСчета.ГородБанка
	|	ИНАЧЕ
	|		БанковскиеСчета.Банк.Город
	|	КОНЕЦ КАК Город
	|
	|ПОМЕСТИТЬ БанковскиеСчетаОрганизаций
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов = ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В (
	|		ВЫБРАТЬ
	|			БанковскиеСчета.БанковскийСчет КАК БанковскийСчет
	|		ИЗ
	|			БанковскиеСчетаОрганизацийВрем КАК БанковскиеСчета
	|		)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	БанковскиеСчета.Ссылка,
	|	БанковскиеСчета.Владелец,
	|	БанковскиеСчета.Банк.КоррСчет,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.НаименованиеБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.Наименование
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.БИКБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.Код
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.КоррСчетБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.КоррСчет
	|	КОНЕЦ,
	|	ВЫБОР КОГДА БанковскиеСчета.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		БанковскиеСчета.ГородБанкаДляРасчетов
	|	ИНАЧЕ
	|		БанковскиеСчета.БанкДляРасчетов.Город
	|	КОНЕЦ
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.БанкДляРасчетов <> ЗНАЧЕНИЕ(Справочник.КлассификаторБанков.ПустаяСсылка)
	|	И БанковскиеСчета.Ссылка В (
	|		ВЫБРАТЬ
	|			БанковскиеСчета.БанковскийСчет КАК БанковскийСчет
	|		ИЗ
	|			БанковскиеСчетаОрганизацийВрем КАК БанковскиеСчета
	|		)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК ДатаДокумента,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Организация.Префикс КАК Префикс,
	|	ДанныеДокумента.Организация.НаименованиеСокращенное КАК ПлательщикНаименование,
	|	
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ИННПлательщика = """" ТОГДА
	|			ДанныеДокумента.Организация.ИНН
	|		ИНАЧЕ
	|			ДанныеДокумента.ИННПлательщика
	|	КОНЕЦ КАК ИННПлательщика,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.КПППлательщика = """" ТОГДА
	|			ДанныеДокумента.Организация.КПП
	|		ИНАЧЕ
	|			ДанныеДокумента.КПППлательщика
	|	КОНЕЦ КАК КПППлательщика,
	|	ДанныеДокумента.ТекстПлательщика КАК ТекстПлательщика,
	|	ДанныеДокумента.БанковскийСчет.ТекстКорреспондента КАК ТекстКорреспондента,
	|	
	|	БанковскиеСчетаКонтрагентов.Владелец.Наименование КАК ПолучательНаименование,
	|	БанковскиеСчетаКонтрагентов.Владелец.НаименованиеПолное КАК ПолучательНаименованиеПолное,
	|	БанковскиеСчетаКонтрагентов.Владелец.НаименованиеСокращенное КАК ПолучательНаименованиеСокращенное,
	|	БанковскиеСчетаКонтрагентов.Владелец КАК Получатель,
	|	
	|	ВЫБОР
	|		КОГДА БанковскиеСчетаКонтрагентов.ИННКорреспондента = """" ТОГДА
	|			БанковскиеСчетаКонтрагентов.Владелец.ИНН
	|		ИНАЧЕ
	|			БанковскиеСчетаКонтрагентов.ИННКорреспондента
	|	КОНЕЦ КАК ИННПолучателя,
	|	ВЫБОР
	|		КОГДА БанковскиеСчетаКонтрагентов.КППКорреспондента = """" ТОГДА
	|			БанковскиеСчетаКонтрагентов.Владелец.КПП
	|		ИНАЧЕ
	|			БанковскиеСчетаКонтрагентов.КППКорреспондента
	|	КОНЕЦ КАК КПППолучателя,
	|	БанковскиеСчетаКонтрагентов.ТекстКорреспондента КАК ТекстПолучателя,
	|
	|	ДанныеДокумента.НазначениеПлатежа КАК НазначениеПлатежа,
	|	ДанныеДокумента.ВидПлатежа КАК ВидПлатежа,
	|	ДанныеДокумента.ОчередностьПлатежа КАК Очередность,
	|	ДанныеДокумента.ИдентификаторПлатежа КАК ИдентификаторПлатежа,
	|	ДанныеДокумента.КодБК КАК КодБК,
	|	ДанныеДокумента.КодОКАТО КАК КодОКАТО,
	|	ДанныеДокумента.ПоказательДаты КАК ПоказательДаты,
	|	ДанныеДокумента.ПоказательНомера КАК ПоказательНомера,
	|	ДанныеДокумента.ПоказательОснования КАК ПоказательОснования,
	|	ДанныеДокумента.ПоказательПериода КАК ПоказательПериода,
	|	ДанныеДокумента.ПоказательТипа КАК ПоказательТипа,
	|	ДанныеДокумента.СтатусСоставителя КАК СтатусСоставителя,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
	|	ДанныеДокумента.ТипПлатежногоДокумента КАК ТипПлатежногоДокумента,
	|
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.НомерСчета, """") КАК НомерСчетаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.НаименованиеБанка, """") КАК НаименованиеБанкаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.БИК, """") КАК БИКБанкаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.КоррСчет, """") КАК СчетБанкаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.Город, """") КАК ГородБанкаПолучателя,
	|
	|	ДанныеДокумента.БанковскийСчет.ВариантВыводаМесяца КАК ВариантВыводаМесяца,
	|	ДанныеДокумента.БанковскийСчет.ВыводитьСуммуБезКопеек КАК ВыводитьСуммуБезКопеек,
	|	ДанныеДокумента.БанковскийСчет.ВалютаДенежныхСредств КАК ВалютаДенежныхСредств,
	|
	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		ДанныеДокумента.БанковскийСчет.НаименованиеБанкаДляРасчетов
	|	ИНАЧЕ
	|		ДанныеДокумента.БанковскийСчет.БанкДляРасчетов.Наименование
	|	КОНЕЦ КАК БанкДляРасчетов,
	|	ДанныеДокумента.БанковскийСчет.НомерСчета КАК НомерСчета,
	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет.РучноеИзменениеРеквизитовБанка ТОГДА
	|		ДанныеДокумента.БанковскийСчет.НаименованиеБанка
	|	ИНАЧЕ
	|		ДанныеДокумента.БанковскийСчет.Банк.Наименование
	|	КОНЕЦ КАК Банк,
	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет.РучноеИзменениеРеквизитовБанка ТОГДА
	|		ДанныеДокумента.БанковскийСчет.ГородБанка
	|	ИНАЧЕ
	|		ДанныеДокумента.БанковскийСчет.Банк.Город
	|	КОНЕЦ КАК Город,
	|
	|	ЕСТЬNULL(БанковскиеСчетаОрганизаций.НомерСчета, """") КАК НомерСчетаПлательщика,
	|	ЕСТЬNULL(БанковскиеСчетаОрганизаций.НаименованиеБанка, """") КАК НаименованиеБанкаПлательщика,
	|	ЕСТЬNULL(БанковскиеСчетаОрганизаций.БИК, """") КАК БИКБанкаПлательщика,
	|	ЕСТЬNULL(БанковскиеСчетаОрганизаций.КоррСчет, """") КАК СчетБанкаПлательщика,
	|	ЕСТЬNULL(БанковскиеСчетаОрганизаций.Город, """") КАК ГородБанкаПлательщика
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|	ПО
	|		ДанныеДокумента.БанковскийСчетКонтрагента = БанковскиеСчетаКонтрагентов.Ссылка
	|		ИЛИ 
	|		(ДанныеДокумента.БанковскийСчетПолучатель = БанковскиеСчетаКонтрагентов.Ссылка
	|		И ДанныеДокумента.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КонвертацияВалюты))
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|	ПО
	|		ДанныеДокумента.БанковскийСчет = БанковскиеСчетаОрганизаций.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&МассивДокументов)
	|	И ДанныеДокумента.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК ДатаДокумента,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Организация.Префикс КАК Префикс,
	|	ДанныеДокумента.Организация.НаименованиеСокращенное КАК ПлательщикНаименование,
	|	
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ИННПлательщика = """" ТОГДА
	|			ДанныеДокумента.Организация.ИНН
	|		ИНАЧЕ
	|			ДанныеДокумента.ИННПлательщика
	|	КОНЕЦ КАК ИННПлательщика,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.КПППлательщика = """" ТОГДА
	|			ДанныеДокумента.Организация.КПП
	|		ИНАЧЕ
	|			ДанныеДокумента.КПППлательщика
	|	КОНЕЦ КАК КПППлательщика,
	|	ДанныеДокумента.ТекстПлательщика КАК ТекстПлательщика,
	|	ЕстьNULL(Распределение.БанковскийСчетКасса.ТекстКорреспондента, ДанныеДокумента.БанковскийСчет.ТекстКорреспондента) КАК ТекстКорреспондента,
	|	
	|	БанковскиеСчетаКонтрагентов.Владелец.Наименование КАК ПолучательНаименование,
	|	БанковскиеСчетаКонтрагентов.Владелец.НаименованиеПолное КАК ПолучательНаименованиеПолное,
	|	БанковскиеСчетаКонтрагентов.Владелец.НаименованиеСокращенное КАК ПолучательНаименованиеСокращенное,
	|	БанковскиеСчетаКонтрагентов.Владелец КАК Получатель,
	|	
	|	ВЫБОР
	|		КОГДА БанковскиеСчетаКонтрагентов.ИННКорреспондента = """" ТОГДА
	|			БанковскиеСчетаКонтрагентов.Владелец.ИНН
	|		ИНАЧЕ
	|			БанковскиеСчетаКонтрагентов.ИННКорреспондента
	|	КОНЕЦ КАК ИННПолучателя,
	|	ВЫБОР
	|		КОГДА БанковскиеСчетаКонтрагентов.КППКорреспондента = """" ТОГДА
	|			БанковскиеСчетаКонтрагентов.Владелец.КПП
	|		ИНАЧЕ
	|			БанковскиеСчетаКонтрагентов.КППКорреспондента
	|	КОНЕЦ КАК КПППолучателя,
	|	БанковскиеСчетаКонтрагентов.ТекстКорреспондента КАК ТекстПолучателя,
	|
	|	ДанныеДокумента.НазначениеПлатежа КАК НазначениеПлатежа,
	|	"""" КАК ВидПлатежа,
	|	0 КАК Очередность,
	|	ДанныеДокумента.ИдентификаторПлатежа КАК ИдентификаторПлатежа,
	|	ДанныеДокумента.КодБК КАК КодБК,
	|	ДанныеДокумента.КодОКАТО КАК КодОКАТО,
	|	ДанныеДокумента.ПоказательДаты КАК ПоказательДаты,
	|	ДанныеДокумента.ПоказательНомера КАК ПоказательНомера,
	|	ДанныеДокумента.ПоказательОснования КАК ПоказательОснования,
	|	ДанныеДокумента.ПоказательПериода КАК ПоказательПериода,
	|	ДанныеДокумента.ПоказательТипа КАК ПоказательТипа,
	|	ДанныеДокумента.СтатусСоставителя КАК СтатусСоставителя,
	|	ЕстьNULL(Распределение.Сумма, ДанныеДокумента.СуммаДокумента) КАК СуммаДокумента,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыПлатежныхДокументов.ПлатежноеПоручение) КАК ТипПлатежногоДокумента,
	|
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.НомерСчета, """") КАК НомерСчетаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.НаименованиеБанка, """") КАК НаименованиеБанкаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.БИК, """") КАК БИКБанкаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.КоррСчет, """") КАК СчетБанкаПолучателя,
	|	ЕСТЬNULL(БанковскиеСчетаКонтрагентов.Город, """") КАК ГородБанкаПолучателя,
	|
	|	ЕСТЬNULL(ЕстьNULL(Распределение.БанковскийСчетКасса.ВариантВыводаМесяца, ДанныеДокумента.БанковскийСчет.ВариантВыводаМесяца), ЗНАЧЕНИЕ(Перечисление.ВариантыВыводаМесяцаВДатеДокумента.Числом)) КАК ВариантВыводаМесяца,
	|	ЕСТЬNULL(ЕстьNULL(Распределение.БанковскийСчетКасса.ВыводитьСуммуБезКопеек, ДанныеДокумента.БанковскийСчет.ВыводитьСуммуБезКопеек), ЛОЖЬ) КАК ВыводитьСуммуБезКопеек,
	|	ЕСТЬNULL(ЕстьNULL(Распределение.БанковскийСчетКасса.ВалютаДенежныхСредств, ДанныеДокумента.БанковскийСчет.ВалютаДенежныхСредств), ДанныеДокумента.Валюта) КАК ВалютаДенежныхСредств,
	|
	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет.РучноеИзменениеРеквизитовБанкаДляРасчетов ТОГДА
	|		ДанныеДокумента.БанковскийСчет.НаименованиеБанкаДляРасчетов
	|	ИНАЧЕ
	|		ДанныеДокумента.БанковскийСчет.БанкДляРасчетов.Наименование
	|	КОНЕЦ КАК БанкДляРасчетов,
	|	ДанныеДокумента.БанковскийСчет.НомерСчета КАК НомерСчета,
	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет.РучноеИзменениеРеквизитовБанка ТОГДА
	|		ДанныеДокумента.БанковскийСчет.НаименованиеБанка
	|	ИНАЧЕ
	|		ДанныеДокумента.БанковскийСчет.Банк.Наименование
	|	КОНЕЦ КАК Банк,
	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет.РучноеИзменениеРеквизитовБанка ТОГДА
	|		ДанныеДокумента.БанковскийСчет.ГородБанка
	|	ИНАЧЕ
	|		ДанныеДокумента.БанковскийСчет.Банк.Город
	|	КОНЕЦ КАК Город,
	|
	|	ЕСТЬNULL(ЕстьNULL(БанковскиеСчетаОрганизацийРаспределение.НомерСчета, БанковскиеСчетаОрганизаций.НомерСчета), """") КАК НомерСчетаПлательщика,
	|	ЕСТЬNULL(ЕстьNULL(БанковскиеСчетаОрганизацийРаспределение.НаименованиеБанка, БанковскиеСчетаОрганизаций.НаименованиеБанка), """") КАК НаименованиеБанкаПлательщика,
	|	ЕСТЬNULL(ЕстьNULL(БанковскиеСчетаОрганизацийРаспределение.БИК, БанковскиеСчетаОрганизаций.БИК), """") КАК БИКБанкаПлательщика,
	|	ЕСТЬNULL(ЕстьNULL(БанковскиеСчетаОрганизацийРаспределение.КоррСчет, БанковскиеСчетаОрганизаций.КоррСчет), """") КАК СчетБанкаПлательщика,
	|	ЕСТЬNULL(ЕстьNULL(БанковскиеСчетаОрганизацийРаспределение.Город, БанковскиеСчетаОрганизаций.Город), """") КАК ГородБанкаПлательщика
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ДанныеДокумента
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|	ПО
	|		ДанныеДокумента.БанковскийСчетКонтрагента = БанковскиеСчетаКонтрагентов.Ссылка
	|		ИЛИ (ДанныеДокумента.БанковскийСчетПолучатель = БанковскиеСчетаКонтрагентов.Ссылка
	|			И ДанныеДокумента.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КонвертацияВалюты))
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|	ПО
	|		ДанныеДокумента.БанковскийСчет = БанковскиеСчетаОрганизаций.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.ЗаявкаНаРасходованиеДенежныхСредств.РаспределениеПоСчетам КАК Распределение
	|	ПО
	|		Распределение.Ссылка = ДанныеДокумента.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизацийРаспределение
	|	ПО
	|		Распределение.БанковскийСчетКасса = БанковскиеСчетаОрганизацийРаспределение.Ссылка
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка В (&МассивДокументов)
	|	И ДанныеДокумента.Проведен
	|	И ДанныеДокумента.ФормаОплатыБезналичная
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер
	|";
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если Выборка.ТипПлатежногоДокумента <> Перечисления.ТипыПлатежныхДокументов.ПлатежноеПоручение Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Платежное поручение не формируется для типа документа: %1'"),
				Выборка.ТипПлатежногоДокумента);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				Выборка.Ссылка.ПолучитьОбъект(),
				"ТипПлатежногоДокумента",
				, // ПутьКДанным
				// Отказ
			);
		Иначе
		
			ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, Выборка.Ссылка);
			ОбластьМакета.Параметры.Заполнить(Выборка);
			
			// Заполним текст плательщика.
			Если Не ПустаяСтрока(Выборка.ТекстПлательщика) Тогда
				ТекстПлательщика = Выборка.ТекстПлательщика;
			Иначе
				Если Не ПустаяСтрока(Выборка.ТекстКорреспондента) Тогда
					ТекстПлательщика = Выборка.ТекстКорреспондента;
				Иначе
					ТекстПлательщика = Выборка.ПлательщикНаименование;
					Если ЗначениеЗаполнено(Выборка.БанкДляРасчетов) Тогда
						ТекстПлательщика = ТекстПлательщика
						+ " р/с " + СокрЛП(Выборка.НомерСчета)
						+ " в " + Строка(Выборка.Банк)
						+ " " + Выборка.Город;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			ОбластьМакета.Параметры.ТекстПлательщика = ТекстПлательщика;
			
			Если ПустаяСтрока(ТекстПлательщика) Тогда
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'У организации %1 не заполнено поле ""Сокращенное наименование""'"),
					Выборка.Организация);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					Текст,
					Выборка.Организация.ПолучитьОбъект(),
					"НаименованиеСокращенное");
			КонецЕсли;
			
			// Заполним текст получателя.
			Если Не ПустаяСтрока(Выборка.ТекстПолучателя) Тогда
				ТекстПолучателя = Выборка.ТекстПолучателя;
			ИначеЕсли ТипЗнч(Выборка.Получатель) = Тип("СправочникСсылка.Организации") Тогда
				ТекстПолучателя = Выборка.ПолучательНаименованиеСокращенное;
			ИначеЕсли ТипЗнч(Выборка.Получатель) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
				ТекстПолучателя = Выборка.ПолучательНаименование;
			Иначе
				ТекстПолучателя = Выборка.ПолучательНаименованиеПолное;
			КонецЕсли;
			ОбластьМакета.Параметры.ТекстПолучателя = ТекстПолучателя;
			
			Если ПустаяСтрока(ТекстПолучателя) И ЗначениеЗаполнено(Выборка.Получатель) Тогда
				Если ТипЗнч(Выборка.Получатель) = Тип("СправочникСсылка.Организации") Тогда
					ИмяПоля = "НаименованиеСокращенное";
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'У организации-получателя %1 не заполнено поле ""Сокращенное наименование""'"),
						Выборка.Получатель);
				ИначеЕсли ТипЗнч(Выборка.Получатель) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
					ИмяПоля = "ФИО";
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'У физического лица %1 не заполнено поле ""ФИО""'"),
						Выборка.Получатель);
				Иначе
					ИмяПоля = "НаименованиеПолное";
					Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'У контрагента %1 не заполнено поле ""Сокращенное наименование""'"),
						Выборка.Получатель);
				КонецЕсли; 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					Текст,
					Выборка.Получатель.ПолучитьОбъект(),
					ИмяПоля);
			КонецЕсли;
			
			ОбластьМакета.Параметры.НаименованиеБанкаПлательщика = Выборка.НаименованиеБанкаПлательщика + " " + Выборка.ГородБанкаПлательщика;
			ОбластьМакета.Параметры.НаименованиеБанкаПолучателя = Выборка.НаименованиеБанкаПолучателя + " " + Выборка.ГородБанкаПолучателя;
			
			// Заполним ИНН и КПП.
			ОбластьМакета.Параметры.ИННПлательщика = "ИНН " + ?(ПустаяСтрока(Выборка.ИННПлательщика), "0", Выборка.ИННПлательщика);
			ОбластьМакета.Параметры.КПППлательщика = "КПП " + ?(ПустаяСтрока(Выборка.КПППлательщика), "0", Выборка.КПППлательщика);
			ОбластьМакета.Параметры.ИННПолучателя = "ИНН " + ?(ПустаяСтрока(Выборка.ИННПолучателя), "0", Выборка.ИННПолучателя);
			ОбластьМакета.Параметры.КПППолучателя = "КПП " + ?(ПустаяСтрока(Выборка.КПППолучателя), "0", Выборка.КПППолучателя);
			
			Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств") Тогда
				НомерДокументаДляПечати = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
					Выборка.Номер,
					Истина, // УдалитьПрефиксИнформационнойБазы
					Истина); // УдалитьПользовательскийПрефикс
				ОбластьМакета.Параметры.НаименованиеНомер = НСтр("ru='ПЛАТЕЖНОЕ ПОРУЧЕНИЕ №'") + " " + НомерДокументаДляПечати;
			Иначе
				ОбластьМакета.Параметры.НаименованиеНомер = НСтр("ru='ОБРАЗЕЦ ПЛАТЕЖНОГО ПОРУЧЕНИЯ'");
			КонецЕсли;
			ОбластьМакета.Параметры.СуммаЧислом = ФормированиеПечатныхФорм.СуммаПлатежногоДокумента(
				Выборка.СуммаДокумента,
				Выборка.ВыводитьСуммуБезКопеек);
			ОбластьМакета.Параметры.СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(
				Выборка.СуммаДокумента,
				Выборка.ВалютаДенежныхСредств,
				Выборка.ВыводитьСуммуБезКопеек);
			Если Выборка.ВариантВыводаМесяца = Перечисления.ВариантыВыводаМесяцаВДатеДокумента.Прописью Тогда
				ФорматДаты = "ДЛФ=ДД'";
			Иначе
				ФорматДаты = "ДЛФ=D'";
			КонецЕсли;
			ОбластьМакета.Параметры.ДатаДокумента = Формат(Выборка.ДатаДокумента, ФорматДаты);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
				ТабличныйДокумент,
				НомерСтрокиНачало,
				ОбъектыПечати,
				Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьРеквизитыПлатежа(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеБезналичныхДенежныхСредств_РеквизитыПлатежа";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеБезналичныхДенежныхСредств.ПФ_MXL_РеквизитыПлатежа");
	
	ТаблицаСсылок = Новый ТаблицаЗначений;
	ТаблицаСсылок.Колонки.Добавить("Ссылка",
		Новый ОписаниеТипов("ДокументСсылка.СписаниеБезналичныхДенежныхСредств, ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств"));
	Для Инд = 1 По МассивОбъектов.Количество() Цикл
		ТаблицаСсылок.Добавить();
	КонецЦикла;
	ТаблицаСсылок.ЗагрузитьКолонку(МассивОбъектов, "Ссылка");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаСсылок.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ
	|	ПлатежныеПоручения
	|ИЗ
	|	&ТаблицаСсылок КАК ТаблицаСсылок
	|ГДЕ
	|	ТаблицаСсылок.Ссылка ССЫЛКА Документ.СписаниеБезналичныхДенежныхСредств
	|	ИЛИ ТаблицаСсылок.Ссылка ССЫЛКА Документ.ЗаявкаНаРасходованиеДенежныхСредств
	|;"
		+ Обработки.КлиентБанк.ТекстЗапросаПлатежныеПорученияТретьиЛица() + "ОБЪЕДИНИТЬ ВСЕ"
		+ Обработки.КлиентБанк.ТекстЗапросаПлатежныеПорученияВнутренние() + "ОБЪЕДИНИТЬ ВСЕ"
		+ Обработки.КлиентБанк.ТекстЗапросаПлатежныеПорученияПереводы()
	;
	Запрос.УстановитьПараметр("ТаблицаСсылок", ТаблицаСсылок);
	
	ПоляЗапроса = Новый Массив;
	ПоляЗапроса.Добавить("Ссылка");
	ПоляЗапроса.Добавить("Сумма");
	ПоляЗапроса.Добавить("Валюта");
	ПоляЗапроса.Добавить("Номер");
	ПоляЗапроса.Добавить("Дата");
	ПоляЗапроса.Добавить("НазначениеПлатежа");
	ПоляЗапроса.Добавить("КонтрагентНаименованиеМеждународное");
	ПоляЗапроса.Добавить("КонтрагентАдресМеждународный");
	ПоляЗапроса.Добавить("КонтрагентРасчСчет");
	ПоляЗапроса.Добавить("КонтрагентБанкМеждународный");
	ПоляЗапроса.Добавить("КонтрагентАдресБанкаМеждународный");
	ПоляЗапроса.Добавить("КонтрагентСВИФТБанка");
	ПоляЗапроса.Добавить("КонтрагентБИКБанка");
	ПоляЗапроса.Добавить("КонтрагентКоррСчетБанка");
	ПоляЗапроса.Добавить("КонтрагентБанкДляРасчетовМеждународный");
	ПоляЗапроса.Добавить("КонтрагентАдресБанкаДляРасчетовМеждународный");
	ПоляЗапроса.Добавить("КонтрагентСВИФТБанкаДляРасчетов");
	ПоляЗапроса.Добавить("КонтрагентБИКБанкаДляРасчетов");
	ПоляЗапроса.Добавить("ОрганизацияНаименованиеМеждународное");
	ПоляЗапроса.Добавить("ОрганизацияАдресМеждународный");
	ПоляЗапроса.Добавить("ОрганизацияРасчСчет");
	ПоляЗапроса.Добавить("ОрганизацияБанкМеждународный");
	ПоляЗапроса.Добавить("ОрганизацияАдресБанкаМеждународный");
	ПоляЗапроса.Добавить("ОрганизацияСВИФТБанка");
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
	
	ВсегоКолонок = СхемаЗапроса.ПакетЗапросов[1].Колонки.Количество() - 1;
	Для Инд = 0 По ВсегоКолонок Цикл
		Колонка = СхемаЗапроса.ПакетЗапросов[1].Колонки.Получить(ВсегоКолонок - Инд);
		Если ПоляЗапроса.Найти(Колонка.Псевдоним) = Неопределено Тогда
			СхемаЗапроса.ПакетЗапросов[1].Колонки.Удалить(ВсегоКолонок - Инд);
		КонецЕсли;
	КонецЦикла;
	
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Если ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СписаниеБезналичныхДенежныхСредств", "ЗаявкаНаРасходованиеДенежныхСредств");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Реквизиты");
		ОбластьМакета.Параметры.Заполнить(Выборка);
		
		ОбластьМакета.Параметры.СуммаПлатежа = Формат(Выборка.Сумма, "ЧЦ=15; ЧДЦ=2") + " " + Строка(Выборка.Валюта);
		
		Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств") Тогда
			ОбластьМакета.Параметры.Документ = СтрШаблон(НСтр("ru = 'Реквизиты платежа'") + " №%1 " + НСтр("ru = 'от'") + " %2",
				ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.Номер), Формат(Выборка.Дата, "ДЛФ=Д"));
		Иначе
			ОбластьМакета.Параметры.Документ = НСтр("ru = 'Реквизиты платежа'");
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(
			ТабличныйДокумент,
			НомерСтрокиНачало,
			ОбъектыПечати,
			Выборка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции
//-- Локализация
#КонецОбласти


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры
//++ Локализация
//-- Локализация

#КонецОбласти

#КонецОбласти
