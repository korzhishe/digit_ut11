﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	
	// Получение текущего состояния настроек.
	АдресУведомлений = Параметры.ЭлектроннаяПочта;
		
	УведомлятьОСобытиях = Параметры.ВключитьПодписку;
	УведомлятьОНовыхПриглашениях = Параметры.Приглашения;
	УведомлятьОбОтветахКонтрагентов= Параметры.Ответы;
	УведомлятьОНовыхДокументах = Параметры.НовыеЭД;
	УведомлятьОНеОбработанныхДокументах = Параметры.СтарыеЭД;
	УведомлятьОбОкончанииСрокаДействияСертификата = Параметры.Сертификаты;
	
	ПрофильНастроек = Параметры.ПрофильНастроек;
	ИдентификаторОрганизации = Параметры.ИдентификаторОрганизации;
	
	УстановитьДоступностьСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура УведомлятьОСобытияхПриИзменении(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	
	ИзменитьПараметрыПодписки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ИзменитьПараметрыПодписки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьПараметрыПодписки(Закрыть = Ложь)
	
	Если УведомлятьОСобытиях Тогда
		
		ОшибкаЗаполнения = Ложь;
		
		Если Не ЕстьВключенныеСобытия() Тогда
			ОшибкаЗаполнения = Истина;
		КонецЕсли;

		Если Не ПроверитьЗаполнение() Тогда
			ОшибкаЗаполнения = Истина;
		КонецЕсли;
		
		Если ОшибкаЗаполнения Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Профиль", ПрофильНастроек);
	ДополнительныеПараметры.Вставить("Идентификатор", ИдентификаторОрганизации);
	ДополнительныеПараметры.Вставить("Закрыть", Закрыть);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьПараметрыПродолжить", ЭтотОбъект, ДополнительныеПараметры);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ПолучитьМаркерПрофиляЭДО(ОписаниеОповещения, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьВключенныеСобытия()
	
	Результат = Ложь;
	Если УведомлятьОбОкончанииСрокаДействияСертификата
		Или УведомлятьОбОтветахКонтрагентов
		Или УведомлятьОНеОбработанныхДокументах
		Или УведомлятьОНовыхДокументах
		Или УведомлятьОНовыхПриглашениях Тогда
		Результат = Истина;
	КонецЕсли;
	
	Если Не Результат Тогда
		
		ТекстСообщения = НСтр("ru = 'Нет событий для уведомления'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"УведомлятьОНовыхДокументах");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ИзменитьПараметрыПродолжить(РасшифрованныйМаркер, ДополнительныеПараметры) Экспорт
	
	Если РасшифрованныйМаркер = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	РезультатСохранения = СохранитьПараметрыПодписок(РасшифрованныйМаркер, ПараметрыПодписок());
	
	Если РезультатСохранения.НастройкиСохранены Тогда
		
		ЭтаФорма.Модифицированность = Ложь;
		
		Если ДополнительныеПараметры.Закрыть Тогда
			ПараметрыЗакрытия = Новый Структура;
			ПараметрыЗакрытия.Вставить("АдресУведомлений", АдресУведомлений);
			ПараметрыЗакрытия.Вставить("УведомлятьОСобытиях", УведомлятьОСобытиях);
			Закрыть(ПараметрыЗакрытия);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ТекстКодаОшибки(КодСостояния)
	
	ТекстОшибки = "";
	Если КодСостояния = 405 Тогда
		ТекстОшибки = НСтр("ru = 'Указанный клиентом метод нельзя применить к текущему ресурсу'");
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции

&НаКлиенте
Функция ПараметрыПодписок()
	
	ПараметрыУведомления = Новый Структура();
	ПараметрыУведомления.Вставить("Total", ЗначениеXML(УведомлятьОСобытиях));
	ПараметрыУведомления.Вставить("NewInvitations", ЗначениеXML(УведомлятьОНовыхПриглашениях));
	ПараметрыУведомления.Вставить("NewInvitationResults", ЗначениеXML(УведомлятьОбОтветахКонтрагентов));
	ПараметрыУведомления.Вставить("NewMessages", ЗначениеXML(УведомлятьОНовыхДокументах));
	ПараметрыУведомления.Вставить("UnfinishedMessages", ЗначениеXML(УведомлятьОНеОбработанныхДокументах));
	ПараметрыУведомления.Вставить("CertExpiration", ЗначениеXML(УведомлятьОбОкончанииСрокаДействияСертификата));
	ПараметрыУведомления.Вставить("Mail", АдресУведомлений);
	
	Возврат ПараметрыУведомления;
	
КонецФункции

&НаКлиенте
Функция ЗначениеXML(ЗначениеНаФорме)
	
	Если ЗначениеНаФорме = Истина Тогда
		Результат = "true";
	Иначе
		Результат = "false";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция СформироватьАдресСтроки(ПараметрыУведомления)
	
	Адрес = "";
	
	Для Каждого КлючЗначение Из ПараметрыУведомления Цикл
		
		Если ВРег(КлючЗначение.Ключ) = ВРег("Mail") Тогда
			Продолжить;
		КонецЕсли;
		
		Адрес = Адрес + ""+КлючЗначение.Ключ + "="+КлючЗначение.Значение + "&";
		
	КонецЦикла;
	
	Адрес = Адрес + "mail=" + ПараметрыУведомления.Mail;
	
	Возврат Адрес;
	
КонецФункции

&НаСервере
Функция СохранитьПараметрыПодписок(РасшифрованныйМаркер, ПараметрыУведомления)
	
	Если ЭтоАдресВременногоХранилища(РасшифрованныйМаркер) Тогда
		МаркерРасшифрованный = ПолучитьИзВременногоХранилища(РасшифрованныйМаркер);
	Иначе
		МаркерРасшифрованный = РасшифрованныйМаркер;
	КонецЕсли;
	
	Маркер = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.СтрокаИзДвоичныхДанных(МаркерРасшифрованный);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Assistant-Key", Маркер);
	
	СпособОбмена = Перечисления.СпособыОбменаЭД.ЧерезСервис1СЭДО;
	АдресРесурса = "SetSubscriptions?"+СформироватьАдресСтроки(ПараметрыУведомления);
	
	
	Запрос = Новый HTTPЗапрос(АдресРесурса, Заголовки);
	Соединение = ОбменСКонтрагентамиВнутренний.ПолучитьСоединение(СпособОбмена);
	
	Результат = Новый Структура;
	
	НастройкиСохранены = Ложь;
	Попытка
		Ответ = Соединение.Получить(Запрос);
		
	Исключение
		
		ТекстСообщения = НСтр("ru = 'Ошибка выполнения команды сервиса.'");
		ВидОперации = НСтр("ru = 'Изменение свойств подписки ЭДО'");
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				ВидОперации, ПодробноеПредставлениеОшибки, ТекстСообщения);
		
		НастройкиСохранены = Ложь;
		
		Результат.Вставить("НастройкиСохранены", НастройкиСохранены);
		Результат.Вставить("КодСостояния", Неопределено);
		
		Возврат Результат;
		
	КонецПопытки;
	
	Если Ответ.КодСостояния = 200 Тогда
		НастройкиСохранены = Истина;
	Иначе
		
		ШаблонСообщения = НСтр("ru = 'Ошибка при сохранении настройки: %1'");
		ТекстОшибки = ТекстКодаОшибки(Ответ.КодСостояния);
		
		ШаблонСообщения = НСтр("ru = 'Ошибка выполнения команды сервиса. Код ошибки: %1. %2'");
		ПодробноеСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Ответ.КодСостояния, ТекстОшибки);

		ВидОперации = НСтр("ru = 'Изменение свойств подписки ЭДО'");
	
		ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				ВидОперации, "", ПодробноеСообщение);
	КонецЕсли;
	
	Результат.Вставить("НастройкиСохранены", НастройкиСохранены);
	Результат.Вставить("КодСостояния", Ответ.КодСостояния);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ГруппаСобытия.Доступность = УведомлятьОСобытиях;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьСервер()
	
	Элементы.ГруппаСобытия.Доступность = УведомлятьОСобытиях;
	
КонецПроцедуры

#КонецОбласти
