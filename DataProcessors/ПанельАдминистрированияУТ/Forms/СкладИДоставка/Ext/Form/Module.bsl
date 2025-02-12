﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ОбщегоНазначенияУТПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы = Новый Структура;
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПередачиТоваровМеждуОрганизациями");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаказыНаВнутреннееПотребление");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЗаказыНаСборку");
	ВнешниеРодительскиеКонстанты.Вставить("ФормироватьФинансовыйРезультат");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	
	// Обновление состояния элементов
	УстановитьДоступность();
	УстановитьЗаголовкиИПодсказкиДляУТКА();
	Элементы.РежимФормированияРасходныхОрдеров.Подсказка =
		Перечисления.РежимыФормированияРасходныхОрдеров.ПодсказкаПоРежимуФормирования(НаборКонстант.РежимФормированияРасходныхОрдеров);
	ЗакупкиСервер.ЗаполнитьНастройкиВариантовПриемки(Константы.ВариантПриемкиТоваров.Получить(),ОформлениеОрдера);
	ЗакупкиСервер.ЗаполнитьСписокВыбораВариантовПриемки(Элементы.ОформлениеОрдера);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПрочееОприходованиеТоваровПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОрдерныеСкладыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУправлениеДоставкойПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьАдресаДоставкиТолькоВДиалогеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЭтикеткиДляДоставкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЭтикеткиДляДоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура(
		"Назначение",
		ПредопределенноеЗначение("Перечисление.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляДоставки"));
	
	ШаблонЭтикетки = Неопределено;

	
	ОткрытьФорму("Справочник.ШаблоныЭтикетокИЦенников.ФормаВыбора", Новый Структура("Отбор", Отбор),,,,, Новый ОписаниеОповещения("ШаблонЭтикеткиДляДоставкиНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЭтикеткиДляДоставкиНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Элемент = ДополнительныеПараметры.Элемент;
    
    
    ШаблонЭтикетки =
    Результат;
    Если ШаблонЭтикетки = Неопределено Тогда
        Возврат;
    КонецЕсли;
    
    НаборКонстант.ШаблонЭтикеткиДляДоставки = ШаблонЭтикетки;
    
    Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ШаблонЭтикеткиУпаковочногоЛистаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура(
		"Назначение",
		ПредопределенноеЗначение("Перечисление.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаУпаковочныхЛистов"));
	
	ШаблонЭтикетки = Неопределено;

	
	ОткрытьФорму("Справочник.ШаблоныЭтикетокИЦенников.ФормаВыбора", Новый Структура("Отбор", Отбор),,,,, Новый ОписаниеОповещения("ШаблонЭтикеткиУпаковочногоЛистаНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонЭтикеткиУпаковочногоЛистаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Элемент = ДополнительныеПараметры.Элемент;
    
    
    ШаблонЭтикетки =
    Результат;
    Если ШаблонЭтикетки = Неопределено Тогда
        Возврат;
    КонецЕсли;
    
    НаборКонстант.ШаблонЭтикеткиУпаковочногоЛиста = ШаблонЭтикетки;
    
    Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоСкладовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПеремещениеТоваровПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаказыНаПеремещениеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПеремещениеПоНесколькимЗаказамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыПеремещенийТоваровПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыЗаказовНаПеремещениеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыЗаказовНаВнутреннееПотреблениеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыЗаказовНаСборкуПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСтатусыСборокТоваровПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПеремещатьТоварыДругихОрганизацийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВнутреннееПотреблениеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаказыНаВнутреннееПотреблениеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НеЗакрыватьЗаказыНаВнутреннееПотреблениеБезПолнойОтгрузкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбособленияТоваровВоВнутреннемПотребленииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НеЗакрыватьЗаказыНаПеремещениеБезПолнойОтгрузкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбособленияТоваровВПеремещенииПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВнутреннееПотреблениеПоНесколькимЗаказамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СборкаРазборкаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаказыНаСборкуПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НеЗакрыватьЗаказыНаСборкуБезПолнойОтгрузкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбособленияТоваровВСборкеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУпаковочныеЛистыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РежимОформленияНакладныхПриИзменении(Элемент)	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура РежимФормированияПриходныхОрдеровПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	ПриИзмененииРежимаФормированияПриходныхОрдеровНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРежимаФормированияПриходныхОрдеровНаСервере()
	
Элементы.РежимФормированияРасходныхОрдеров.Подсказка =
		Перечисления.РежимыФормированияРасходныхОрдеров.ПодсказкаПоРежимуФормирования(НаборКонстант.РежимФормированияРасходныхОрдеров);
КонецПроцедуры

&НаКлиенте
Процедура РежимОформленияНакладныхОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РежимФормированияРасходныхОрдеровОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбособленноеОбеспечениеЗаказовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура НеКонтролироватьОбеспечениеСверхПотребности(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормированиеЗаказовПоПотребностямУпрощенноеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормированиеЗаказовПоПотребностямРасширенноеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОформлениеОрдераПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОформлениеОрдераОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбособленияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ФормированиеЗаказовПоПотребностям" Тогда

			НаборКонстант.ИспользоватьРасширенноеОбеспечениеПотребностей = ФормированиеЗаказовПоПотребностям = 1;
			КонстантаИмя = "ИспользоватьРасширенноеОбеспечениеПотребностей";
			
		КонецЕсли;
		
	КонецЕсли;
		
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.РежимФормированияРасходныхОрдеров" Тогда
		
		РасходныеОрдераФормируютсяМенеджером  = Ложь;
		
		Если НаборКонстант.РежимФормированияРасходныхОрдеров = Перечисления.РежимыФормированияРасходныхОрдеров.Автоматически Тогда	
			Справочники.Склады.ВключитьИспользованиеСтатусовРасходныхОрдеров();
			СкладыСервер.ЗапускФормированияОчередиИПереоформленияРасходныхОрдеров();	
		ИначеЕсли НаборКонстант.РежимФормированияРасходныхОрдеров = Перечисления.РежимыФормированияРасходныхОрдеров.Менеджером Тогда
			РасходныеОрдераФормируютсяМенеджером = Истина;	
		КонецЕсли;
		
		Если Константы.РасходныеОрдераФормируютсяМенеджером.Получить() <> РасходныеОрдераФормируютсяМенеджером Тогда
			Константы.РасходныеОрдераФормируютсяМенеджером.Установить(РасходныеОрдераФормируютсяМенеджером);
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ПорядокОформленияНакладныхРасходныхОрдеров" Тогда
		Если НаборКонстант.РежимФормированияРасходныхОрдеров = Перечисления.РежимыФормированияРасходныхОрдеров.Автоматически Тогда	
			СкладыСервер.ЗапускФормированияОчередиИПереоформленияРасходныхОрдеров();	
		КонецЕсли;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "ОформлениеОрдера" Тогда
		
		Константы.ВариантПриемкиТоваров.Установить(ЗакупкиСервер.ПолучитьВариантовПриемкиПоНастройкам(ОформлениеОрдера, "Разделена"));
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "" Тогда
		МожноИспользоватьОбеспечение =
			Константы.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента.Получить()
			Или Константы.ИспользоватьЗаказыНаВнутреннееПотребление.Получить()
			Или Константы.ИспользоватьЗаказыНаПеремещение.Получить()
			Или Константы.ИспользоватьЗаказыНаСборку.Получить();
			

		ЗапрещеноОтключатьОбособление = Ложь;
		
		Элементы.ИспользоватьОбособленноеОбеспечениеЗаказов.Доступность							 = МожноИспользоватьОбеспечение И Не ЗапрещеноОтключатьОбособление;
		Элементы.ГруппаКомментарийИспользоватьОбособленноеОбеспечениеЗаказов.Видимость			 = Не МожноИспользоватьОбеспечение;
		Элементы.ГруппаКомментарийИспользоватьОбособленноеОбеспечениеЗаказовОтключение.Видимость = ЗапрещеноОтключатьОбособление;
		
		// Обновление вариантов обособления
		НаправленияДеятельностиИспользуются = Константы.ФормироватьФинансовыйРезультат.Получить();
		
		// Перемещение
		ЭлементСпискаВыбора = Элементы.ВариантОбособленияТоваровВПеремещении.СписокВыбора.НайтиПоЗначению(
			ПредопределенноеЗначение("Перечисление.ВариантыОбособленияТоваровВПеремещении.НаправлениеДеятельности"));
		
		Если НаправленияДеятельностиИспользуются И ЭлементСпискаВыбора = Неопределено Тогда
			Элементы.ВариантОбособленияТоваровВПеремещении.СписокВыбора.Вставить(0,
				ПредопределенноеЗначение("Перечисление.ВариантыОбособленияТоваровВПеремещении.НаправлениеДеятельности"));
		ИначеЕсли Не НаправленияДеятельностиИспользуются И ЭлементСпискаВыбора <> Неопределено Тогда
			Элементы.ВариантОбособленияТоваровВПеремещении.СписокВыбора.Удалить(ЭлементСпискаВыбора);
		КонецЕсли;
		
		// Сборка(разборка)
		ЭлементСпискаВыбора = Элементы.ВариантОбособленияТоваровВСборке.СписокВыбора.НайтиПоЗначению(
			ПредопределенноеЗначение("Перечисление.ВариантыОбособленияТоваровВСборке.НаправлениеДеятельности"));
		
		Если НаправленияДеятельностиИспользуются И ЭлементСпискаВыбора = Неопределено Тогда
			Элементы.ВариантОбособленияТоваровВСборке.СписокВыбора.Вставить(0,
				ПредопределенноеЗначение("Перечисление.ВариантыОбособленияТоваровВСборке.НаправлениеДеятельности"));
		ИначеЕсли Не НаправленияДеятельностиИспользуются И ЭлементСпискаВыбора <> Неопределено Тогда
			Элементы.ВариантОбособленияТоваровВСборке.СписокВыбора.Удалить(ЭлементСпискаВыбора);
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбособленноеОбеспечениеЗаказов" Или РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьОбособленноеОбеспечениеЗаказов;
		
		Элементы.РазрешитьОбособлениеТоваровСверхПотребности.Доступность = ЗначениеКонстанты;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьОбособленноеОбеспечениеЗаказов, ЗначениеКонстанты);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.РазрешитьОбособлениеТоваровСверхПотребности" Или РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.РазрешитьОбособлениеТоваровСверхПотребности;

		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.РазрешитьОбособлениеТоваровСверхПотребности, ЗначениеКонстанты);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоСкладов" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьНесколькоСкладов;
		
		Если ЗначениеКонстанты Тогда
			Элементы.ГруппаСтраницыСклады.ТекущаяСтраница = Элементы.ГруппаПояснениеНесколькоСкладов;
		Иначе
			Элементы.ГруппаСтраницыСклады.ТекущаяСтраница = Элементы.ГруппаПояснениеОдинСклад;
		КонецЕсли;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьНесколькоСкладов, ЗначениеКонстанты);
		
		Элементы.ИспользоватьПеремещениеТоваров.Доступность 					= ЗначениеКонстанты;
		Элементы.ПеремещатьТоварыДругихОрганизаций.Доступность 					= НаборКонстант.ИспользоватьПеремещениеТоваров;
		Элементы.ИспользоватьЗаказыНаПеремещение.Доступность 					= НаборКонстант.ИспользоватьПеремещениеТоваров;
		Элементы.ИспользоватьАктыРасхожденийПослеПеремещения.Доступность 		= НаборКонстант.ИспользоватьПеремещениеТоваров;
		Элементы.ИспользоватьСтатусыПеремещенийТоваров.Доступность 				= НаборКонстант.ИспользоватьПеремещениеТоваров;
		Элементы.ИспользоватьПеремещениеПоНесколькимЗаказам.Доступность 		= НаборКонстант.ИспользоватьЗаказыНаПеремещение;
		Элементы.ВариантОбособленияТоваровВПеремещении.Доступность 				= НаборКонстант.ИспользоватьЗаказыНаПеремещение;
		Элементы.ИспользоватьСтатусыЗаказовНаПеремещение.Доступность			= НаборКонстант.ИспользоватьЗаказыНаПеремещение;
		Элементы.НеЗакрыватьЗаказыНаПеремещениеБезПолнойОтгрузки.Доступность 	= НаборКонстант.ИспользоватьЗаказыНаПеремещение;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОрдерныеСклады" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьОрдерныеСклады;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьОрдерныеСклады, ЗначениеКонстанты);
		Элементы.ИспользоватьУпаковочныеЛисты.Доступность = ЗначениеКонстанты;
		
		ИспользоватьСерииНоменклатуры = Константы.ИспользоватьСерииНоменклатуры.Получить();
		Элементы.ГруппаКомментарийСерииНаОрдерныхСкладах.Видимость = Не ЗначениеКонстанты И ИспользоватьСерииНоменклатуры;
		
		Элементы.ПорядокОформленияНакладныхРасходныхОрдеров.Доступность = ЗначениеКонстанты;
		Элементы.РежимФормированияРасходныхОрдеров.Доступность = ЗначениеКонстанты;
		
		ИспользуютсяТоварыВПути               = Константы.ИспользоватьТоварыВПутиОтПоставщиков.Получить();
		ИспользуютсяНеотфактурованныеПоставки = Константы.ИспользоватьНеотфактурованныеПоставки.Получить();
		
		Элементы.ОформлениеОрдера.Доступность = ЗначениеКонстанты
			Или ИспользуютсяТоварыВПути
			Или ИспользуютсяНеотфактурованныеПоставки;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУправлениеДоставкой" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьУправлениеДоставкой;
		
		Элементы.РедактироватьАдресаДоставкиТолькоВДиалоге.Доступность		             = ЗначениеКонстанты;
		Элементы.ШаблонЭтикеткиДляДоставки.Доступность 						             = ЗначениеКонстанты;
		Элементы.ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками.Доступность = ЗначениеКонстанты;
		
		ПараметрыНабораСвойств = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
		ПараметрыНабораСвойств.Используется = ЗначениеКонстанты;
		УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Документ_ПоручениеЭкспедитору", ПараметрыНабораСвойств);
	
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками, ЗначениеКонстанты);
	КонецЕсли;
	
	#Область ВнутреннееПотребление
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнутреннееПотребление" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьВнутреннееПотребление;
		СтатусыЗаказов    = НаборКонстант.ИспользоватьСтатусыЗаказовНаВнутреннееПотребление;
		Заказы            = НаборКонстант.ИспользоватьЗаказыНаВнутреннееПотребление;
		
		Элементы.ИспользоватьЗаказыНаВнутреннееПотребление.Доступность                 = ЗначениеКонстанты;
		Элементы.ИспользоватьВнутреннееПотреблениеПоНесколькимЗаказам.Доступность      = Заказы;
		Элементы.ВариантОбособленияТоваровВоВнутреннемПотреблении.Доступность          = Заказы И Константы.ФормироватьФинансовыйРезультат.Получить();
		Элементы.ИспользоватьСтатусыЗаказовНаВнутреннееПотребление.Доступность         = Заказы;
		Элементы.НеЗакрыватьЗаказыНаВнутреннееПотреблениеБезПолнойОтгрузки.Доступность = ЗначениеКонстанты И СтатусыЗаказов И Заказы;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаказыНаВнутреннееПотребление" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьЗаказыНаВнутреннееПотребление;
		СтатусыЗаказов = НаборКонстант.ИспользоватьСтатусыЗаказовНаВнутреннееПотребление;
		
		Элементы.ИспользоватьВнутреннееПотреблениеПоНесколькимЗаказам.Доступность      = ЗначениеКонстанты;
		Элементы.ВариантОбособленияТоваровВоВнутреннемПотреблении.Доступность          = ЗначениеКонстанты И Константы.ФормироватьФинансовыйРезультат.Получить();
		Элементы.ИспользоватьСтатусыЗаказовНаВнутреннееПотребление.Доступность         = ЗначениеКонстанты;
		Элементы.НеЗакрыватьЗаказыНаВнутреннееПотреблениеБезПолнойОтгрузки.Доступность = ЗначениеКонстанты И СтатусыЗаказов;
		
		Элементы.ГруппаКомментарийНеЗакрыватьЧастичноОтгруженныеЗаказыНаВнутреннееПотребление.Видимость = ЗначениеКонстанты И НЕ СтатусыЗаказов;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСтатусыЗаказовНаВнутреннееПотребление" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = Константы.ИспользоватьСтатусыЗаказовНаВнутреннееПотребление.Получить();
		ЗначениеРодительскойКонстанты = Константы.ИспользоватьЗаказыНаВнутреннееПотребление.Получить();
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
		Элементы.ИспользоватьСтатусыЗаказовНаВнутреннееПотребление, ЗначениеКонстанты);
		Элементы.НеЗакрыватьЗаказыНаВнутреннееПотреблениеБезПолнойОтгрузки.Доступность = ЗначениеКонстанты И ЗначениеРодительскойКонстанты;
		
		Элементы.ГруппаКомментарийНеЗакрыватьЧастичноОтгруженныеЗаказыНаВнутреннееПотребление.Видимость = НЕ ЗначениеКонстанты И ЗначениеРодительскойКонстанты;
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область Перемещение
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПеремещениеТоваров" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты          = НаборКонстант.ИспользоватьПеремещениеТоваров;
		ПередачиМеждуОрганизациями = Константы.ИспользоватьПередачиТоваровМеждуОрганизациями.Получить();
		СтатусыЗаказов             = НаборКонстант.ИспользоватьСтатусыЗаказовНаПеремещение;
		Заказы                     = НаборКонстант.ИспользоватьЗаказыНаПеремещение;
		
		Элементы.ИспользоватьЗаказыНаПеремещение.Доступность             = ЗначениеКонстанты;
		Элементы.ИспользоватьСтатусыПеремещенийТоваров.Доступность       = ЗначениеКонстанты;
		Элементы.ИспользоватьАктыРасхожденийПослеПеремещения.Доступность = ЗначениеКонстанты;
		Элементы.ИспользоватьПеремещениеПоНесколькимЗаказам.Доступность  = Заказы;
		Элементы.ВариантОбособленияТоваровВПеремещении.Доступность       = Заказы;
		Элементы.ИспользоватьСтатусыЗаказовНаПеремещение.Доступность     = Заказы;
		
		Элементы.ПеремещатьТоварыДругихОрганизаций.Доступность 				  = ЗначениеКонстанты И ПередачиМеждуОрганизациями;
		Элементы.ГруппаКомментарийПеремещатьТоварыДругихОрганизаций.Видимость =	НЕ ПередачиМеждуОрганизациями;
		Элементы.НеЗакрыватьЗаказыНаПеремещениеБезПолнойОтгрузки.Доступность = ЗначениеКонстанты И СтатусыЗаказов И Заказы;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаказыНаПеремещение" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьЗаказыНаПеремещение;
		СтатусыЗаказов = НаборКонстант.ИспользоватьСтатусыЗаказовНаПеремещение;
		
		Элементы.ИспользоватьПеремещениеПоНесколькимЗаказам.Доступность      = ЗначениеКонстанты;
		Элементы.ВариантОбособленияТоваровВПеремещении.Доступность           = ЗначениеКонстанты;
		Элементы.ИспользоватьСтатусыЗаказовНаПеремещение.Доступность         = ЗначениеКонстанты;
		Элементы.НеЗакрыватьЗаказыНаПеремещениеБезПолнойОтгрузки.Доступность = ЗначениеКонстанты И СтатусыЗаказов;
		
		Элементы.ГруппаКомментарийНеЗакрыватьЧастичноОтгруженныеЗаказыНаПеремещение.Видимость = ЗначениеКонстанты И НЕ СтатусыЗаказов;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСтатусыЗаказовНаПеремещение" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = Константы.ИспользоватьСтатусыЗаказовНаПеремещение.Получить();
		ЗначениеРодительскойКонстанты = Константы.ИспользоватьЗаказыНаПеремещение.Получить();
		Элементы.НеЗакрыватьЗаказыНаПеремещениеБезПолнойОтгрузки.Доступность = ЗначениеКонстанты И ЗначениеРодительскойКонстанты;
		
		Элементы.ГруппаКомментарийНеЗакрыватьЧастичноОтгруженныеЗаказыНаПеремещение.Видимость = НЕ ЗначениеКонстанты И ЗначениеРодительскойКонстанты;
	КонецЕсли;
	
	#КонецОбласти
	
	#Область СборкаРазборка
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСборкуРазборку" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьСборкуРазборку;
		СтатусыЗаказов    = НаборКонстант.ИспользоватьСтатусыЗаказовНаСборку;
		Заказы            = НаборКонстант.ИспользоватьЗаказыНаСборку;
		
		Элементы.ИспользоватьЗаказыНаСборку.Доступность                 = ЗначениеКонстанты;
		Элементы.ИспользоватьСтатусыСборокТоваров.Доступность           = ЗначениеКонстанты;
		Элементы.ВариантОбособленияТоваровВСборке.Доступность           = Заказы;
		Элементы.ИспользоватьСтатусыЗаказовНаСборку.Доступность         = Заказы;
		Элементы.НеЗакрыватьЗаказыНаСборкуБезПолнойОтгрузки.Доступность = ЗначениеКонстанты И СтатусыЗаказов И Заказы;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаказыНаСборку" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьЗаказыНаСборку;
		СтатусыЗаказов    = НаборКонстант.ИспользоватьСтатусыЗаказовНаСборку;
		
		Элементы.ВариантОбособленияТоваровВСборке.Доступность           = ЗначениеКонстанты;
		Элементы.ИспользоватьСтатусыЗаказовНаСборку.Доступность         = ЗначениеКонстанты;
		Элементы.НеЗакрыватьЗаказыНаСборкуБезПолнойОтгрузки.Доступность = ЗначениеКонстанты И СтатусыЗаказов;
		
		Элементы.ГруппаКомментарийНеЗакрыватьЧастичноОтгруженныеЗаказыНаСборкуРазборку.Видимость = ЗначениеКонстанты И НЕ СтатусыЗаказов;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСтатусыЗаказовНаСборку" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = Константы.ИспользоватьСтатусыЗаказовНаСборку.Получить();
		ЗначениеРодительскойКонстанты = Константы.ИспользоватьЗаказыНаСборку.Получить();
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьСтатусыЗаказовНаСборку, ЗначениеКонстанты);
		Элементы.НеЗакрыватьЗаказыНаСборкуБезПолнойОтгрузки.Доступность = ЗначениеКонстанты И ЗначениеРодительскойКонстанты;
		
		Элементы.ГруппаКомментарийНеЗакрыватьЧастичноОтгруженныеЗаказыНаСборкуРазборку.Видимость = НЕ ЗначениеКонстанты И ЗначениеРодительскойКонстанты;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСтатусыСборокТоваров" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = Константы.ИспользоватьСтатусыСборокТоваров.Получить();
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьСтатусыСборокТоваров, ЗначениеКонстанты);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВариантОбособленияТоваровВСборке" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ГруппаКомментарийОбособлениеКомплектующихПоНазначениюСобираемогоКомплекта.Видимость =
			НаборКонстант.ВариантОбособленияТоваровВСборке = ПредопределенноеЗначение("Перечисление.ВариантыОбособленияТоваровВСборке.НазначениеСобираемогоКомплекта");
		
	КонецЕсли;
	
	#КонецОбласти
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУпаковочныеЛисты" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ИспользоватьУпаковочныеЛисты;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьУпаковочныеЛисты, ЗначениеКонстанты);
		Элементы.ШаблонЭтикеткиУпаковочногоЛиста.Доступность = ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаказыПоставщикам"
		Или РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЗаказыНаСборку"
		Или РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПроизводство"
		Или РеквизитПутьКДанным = "" Тогда

		УстановитьДоступностьФормированиеЗаказовПоПотребностям();

	КонецЕсли;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	ОтображениеПредупрежденияПриРедактировании(РеквизитПутьКДанным);
	
КонецПроцедуры

&НаСервере
Процедура ОтображениеПредупрежденияПриРедактировании(РеквизитПутьКДанным)
	
	СтруктураКонстант = Новый Структура(
		"ИспользоватьСтатусыПеремещенийТоваров,
		|ИспользоватьСтатусыСборокТоваров");
	
	Для Каждого КлючИЗначение Из СтруктураКонстант Цикл
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы[КлючИЗначение.Ключ],
			НаборКонстант[КлючИЗначение.Ключ]);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимФормированияРасходныхОрдеровНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Перечисление.РежимыФормированияРасходныхОрдеров.Форма.ВыборРежимаФормирования",
				Новый Структура("РежимФормированияРасходныхОрдеров", НаборКонстант.РежимФормированияРасходныхОрдеров),
				Элемент,
				,
				,
				,
				,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАктыРасхожденийПослеПеремещенияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьФормированиеЗаказовПоПотребностям()

	Элементы.ГруппаФормированиеЗаказовПоПотребностям.Видимость                        = Истина;
	
	ИспользоватьФормированиеЗаказов =
	НаборКонстант.ИспользоватьЗаказыПоставщикам
		Или ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыНаСборку");
	
	Если Не ИспользоватьФормированиеЗаказов Тогда
		
		Элементы.ГруппаФормированиеЗаказовПоПотребностям.Доступность = Ложь;
		
		Элементы.ГруппаКомментарийИспользоватьФормированиеЗаказовПоПотребностям.Видимость = Истина;
		Элементы.КомментарийРасширенноеФормированиеЗаказовПоПотребностям.Видимость = Истина;
		Элементы.КомментарийУпрощенноеФормированиеЗаказовПоПотребностям.Видимость  = Ложь;
		
		ФормированиеЗаказовПоПотребностям = 2;
		
	ИначеЕсли Не НаборКонстант.ИспользоватьЗаказыПоставщикам Тогда
		
		Элементы.ГруппаФормированиеЗаказовПоПотребностям.Доступность = Ложь;
		
		Элементы.ГруппаКомментарийИспользоватьФормированиеЗаказовПоПотребностям.Видимость = Истина;
		Элементы.КомментарийРасширенноеФормированиеЗаказовПоПотребностям.Видимость = Ложь;
		Элементы.КомментарийУпрощенноеФормированиеЗаказовПоПотребностям.Видимость  = Истина;
		
		ФормированиеЗаказовПоПотребностям = 1;
		
	Иначе
		
		Элементы.ГруппаФормированиеЗаказовПоПотребностям.Доступность = Истина;
		
		Элементы.ГруппаКомментарийИспользоватьФормированиеЗаказовПоПотребностям.Видимость = Ложь;
		
		ФормированиеЗаказовПоПотребностям = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенноеОбеспечениеПотребностей");
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиИПодсказкиДляУТКА()
	
	ПодстановкаСпособы = НСтр("ru = 'покупка, перемещение, сборка'");
	ЗаголовокЭлемента = НСтр("ru = 'Формирование заказов в соответствии со способом обеспечения (%1) для поддержания остатка (min-max) и обеспечения заказов на отгрузку. Расчет потребностей с учетом плановых сроков поставки и интервала между поставками.'");
	ЗаголовокЭлемента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокЭлемента, ПодстановкаСпособы);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчикамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
