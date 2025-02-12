﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗаполнитьСоглашениеОбОбменеЭД(ПараметрКоманды, ПараметрыВыполненияКоманды);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьСоглашениеОбОбменеЭД(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИмяМакета = "СоглашениеОбОбменеЭлектроннымиДокументами_doc";
	
	МакетИДанныеОбъекта = ПодготовитьДанныеПечатиСоглашенияПолучитьМакет(ПараметрКоманды, ИмяМакета);
	НапечататьСогласиеНаОбработкуПерсональныхДанныхСубъекта(ПараметрКоманды, МакетИДанныеОбъекта, ИмяМакета,
		МакетИДанныеОбъекта.ЛокальныйКаталогФайловПечати, ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьДанныеПечатиСоглашенияПолучитьМакет(НастройкаЭДО, ИмяМакета)
	
	РеквизитыНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаЭДО, "Организация, Контрагент");
	
	Субъект = Новый Структура;
	Субъект.Вставить("НастройкаЭДО", НастройкаЭДО);
	Субъект.Вставить("Город",        НСтр("ru = 'г. Москва'"));
	Субъект.Вставить("Дата",         Формат(ТекущаяДатаСеанса(), "ДЛФ=DD"));
	Субъект.Вставить("Сторона1",     РеквизитыНастройки.Организация);
	Субъект.Вставить("Сторона2",     РеквизитыНастройки.Контрагент);
	
	Субъекты = Новый Массив;
	Субъекты.Добавить(Субъект);
	
	ИмяМенеджераПечати = "Справочник.СоглашенияОбИспользованииЭД";
	МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.МакетыИДанныеОбъектовДляПечати(ИмяМенеджераПечати, ИмяМакета, Субъекты);
	
	Возврат МакетИДанныеОбъекта;
	
КонецФункции

&НаКлиенте
Процедура НапечататьСогласиеНаОбработкуПерсональныхДанныхСубъекта(СубъектКлюч, МакетИДанныеОбъекта, ИмяМакета, ЛокальныйКаталогФайловПечати, УникальныйИдентификатор)
	
	ТипМакета				= МакетИДанныеОбъекта.Макеты.ТипыМакетов[ИмяМакета];
	Области					= МакетИДанныеОбъекта.Макеты.ОписаниеОбластей;
	ДвоичныеДанныеМакетов	= МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	ДанныеОбъекта = МакетИДанныеОбъекта.Данные[СубъектКлюч][ИмяМакета];
	
	Макет = УправлениеПечатьюКлиент.ИнициализироватьМакетОфисногоДокумента(ДвоичныеДанныеМакетов[ИмяМакета], ТипМакета, ИмяМакета);
	Если Макет = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗакрытьОкноПечатнойФормы = Ложь;
	Попытка
		ПечатнаяФорма = УправлениеПечатьюКлиент.ИнициализироватьПечатнуюФорму(ТипМакета, Макет.НастройкиСтраницыМакета);
		Если ПечатнаяФорма = Неопределено Тогда
			УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
			Возврат;
		КонецЕсли;
		
		// Вывод обычных областей с параметрами.
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["Шапка"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
	#Если НЕ ВебКлиент Тогда
		ВременныйФайл = ПолучитьИмяВременногоФайла(ТипМакета);
		ПечатнаяФорма.COMСоединение.ActiveDocument.SaveAs(ВременныйФайл);
		УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма, Истина);
		ПоместитьДанныеСоглашенияВоВременноеХранилище(СубъектКлюч, Новый ДвоичныеДанные(ВременныйФайл), УникальныйИдентификатор);
		ОткрытьФорму("Документ.ЭлектронныйДокументИсходящий.Форма.ФормаПросмотраЭД", Новый Структура("ДокументОснование", СубъектКлюч));
		УдалитьФайлы(ВременныйФайл);
	#КонецЕсли
	
	#Если ВебКлиент Тогда
		УправлениеПечатьюКлиент.ПоказатьДокумент(ПечатнаяФорма);
	#КонецЕсли
	
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗакрытьОкноПечатнойФормы = Истина;
	КонецПопытки;
	
	УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма, ЗакрытьОкноПечатнойФормы);
	УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьДанныеСоглашенияВоВременноеХранилище(НастройкаЭДО, ДвоичныеДанныеФайла, Знач УникальныйИдентификатор)
	
	СтруктураФайла  = Новый Структура;
	СтруктураФайла.Вставить("ИмяФайла",                           "Соглашение об обмене электронными документами.doc");
	СтруктураФайла.Вставить("Наименование",                       "Соглашение об обмене электронными документами");
	СтруктураФайла.Вставить("Расширение",                         "doc");
	СтруктураФайла.Вставить("Размер",                             ДвоичныеДанныеФайла.Размер());
	СтруктураФайла.Вставить("Редактирует",                        Неопределено);
	СтруктураФайла.Вставить("ПодписанЭП",                         Ложь);
	СтруктураФайла.Вставить("Зашифрован",                         Ложь);
	СтруктураФайла.Вставить("ФайлРедактируется",                  Ложь);
	СтруктураФайла.Вставить("СсылкаНаДвоичныеДанныеФайла",        ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла, Новый УникальныйИдентификатор));
	СтруктураФайла.Вставить("ДатаМодификацииУниверсальная",       ТекущаяУниверсальнаяДата());
	СтруктураФайла.Вставить("ФайлРедактируетТекущийПользователь", Ложь);
	СтруктураФайла.Вставить("ОтносительныйПуть",                  ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Строка(УникальныйИдентификатор)));
	АдресХранилища = ПоместитьВоВременноеХранилище(СтруктураФайла, Новый УникальныйИдентификатор);
	ОбменСКонтрагентамиСлужебный.ПоместитьПараметрВПараметрыКлиентаНаСервере(НастройкаЭДО, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти
