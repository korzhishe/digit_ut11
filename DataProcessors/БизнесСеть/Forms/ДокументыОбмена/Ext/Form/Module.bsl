﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СписокВсехТиповЭД = БизнесСеть.ВидыДокументовСервиса();
	
	Для Каждого ЭлементСписка Из СписокВсехТиповЭД Цикл
		Элементы.ОтборВидДокумента.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;
	
	Параметры.Свойство("РежимИсходящихДокументов", РежимИсходящихДокументов);
	
	Если РежимИсходящихДокументов Тогда
		НастройкиОтбора = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("БизнесСеть",
			"ИсходящиеДокументы\НастройкиОтбора");
			
		Элементы.КомандаЗагрузить.Видимость = Ложь;
		Элементы.КомандаОтклонитьДокументы.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Исходящие документы без электронной подписи'");
		Элементы.ПоказыватьЗагруженные.Заголовок = НСтр("ru = 'Показывать доставленные'");
		Элементы.СписокОтправитель.Заголовок = "Получатель";
	Иначе
		Заголовок = НСтр("ru = 'Входящие документы без электронной подписи'");
		НастройкиОтбора = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("БизнесСеть",
			"ВходящиеДокументы\НастройкиОтбора");
	КонецЕсли;
	Если ТипЗнч(НастройкиОтбора) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиОтбора);
	КонецЕсли;
	
	ОбновитьСписок(Отказ);
	
	ИспользуетсяНесколькоОрганизацийЭД = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЭД");
	
	Если Не ИспользуетсяНесколькоОрганизацийЭД Тогда
		Элементы.СписокОрганизация.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиОтбора = Новый Структура;
	НастройкиОтбора.Вставить("ВключитьОтборВидДокумента", ВключитьОтборВидДокумента);
	НастройкиОтбора.Вставить("ВключитьОтборКонтрагент", ВключитьОтборКонтрагент);
	НастройкиОтбора.Вставить("ОтборВидДокумента", ОтборВидДокумента);
	НастройкиОтбора.Вставить("ОтборКонтрагент", ОтборКонтрагент);
	НастройкиОтбора.Вставить("ПоказыватьЗагруженные", ПоказыватьЗагруженные);
	
	Если РежимИсходящихДокументов Тогда
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("БизнесСеть",
			"ИсходящиеДокументы\НастройкиОтбора", НастройкиОтбора);
	Иначе
		ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("БизнесСеть",
			"ВходящиеДокументы\НастройкиОтбора", НастройкиОтбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокВходящихДокументов1СБизнесСеть" Тогда
		ОбновитьСписокДокументов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьВсеПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ВключитьОтборКонтрагент = ЗначениеЗаполнено(ОтборКонтрагент);
	ОбновитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтборКонтрагентПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтборВидДокументаПриИзменении(Элемент)
	
	ОбновитьСписокДокументов();

КонецПроцедуры

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	ВключитьОтборВидДокумента = ЗначениеЗаполнено(ОтборВидДокумента);
	ОбновитьСписокДокументов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВывестиЭДНаПросмотр(Элементы.Список.ТекущиеДанные)
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	Оповещение = Новый ОписаниеОповещения("УдалитьДокументВСервисеПослеВопроса", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Выделенные документы будут удалены в сервисе 1С:Бизнес-сеть.
							  |Документы учета информационной базы не изменятся.
							  |Продолжить выполнение операции?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДанныхТипОбъектаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Элементы.СписокТипОбъекта.Очистить();
	
	Для Каждого ЭлементМассива Из Элементы.Список.ТекущиеДанные.ВозможныеТипыОбъекта Цикл
		Элементы.СписокТипОбъекта.Добавить(ЭлементМассива.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииЯчейки(Элемент)
	
	ДоступностьЗагрузки = Элементы.Список.ВыделенныеСтроки.Количество() = 1;
	Если ДоступностьЗагрузки <> Элементы.КомандаЗагрузить.Доступность Тогда
		Элементы.КомандаЗагрузить.Доступность            = ДоступностьЗагрузки;
		Элементы.КомандаОтклонитьДокументы.Доступность   = ДоступностьЗагрузки;
		Элементы.КомандаОткрытьПредставление.Доступность = ДоступностьЗагрузки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Возможна загрузка только по одному документу.'"));
		Возврат;
	КонецЕсли;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ВывестиЭДНаПросмотр(Список.НайтиПоИдентификатору(ВыделеннаяСтрока), Истина);
	КонецЦикла;
	
	ОбновитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ВывестиЭДНаПросмотр(Элементы.Список.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДокумент(Команда)
	
	Отказ = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПутьККаталогу");
	
	МассивСтруктур = Новый Массив;
	
	Для Каждого СтрокаСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		
		СтрокаДанных = Список.НайтиПоИдентификатору(СтрокаСписка);
		
		СтруктураОбмена = Новый Структура;
		
		Если Не ЗначениеЗаполнено(СтрокаДанных.АдресХранилища) Тогда
			МассивИдентификаторовДокументов = Новый Массив;
			МассивИдентификаторовДокументов.Добавить(СтрокаДанных.Идентификатор);
			МассивДанныхДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(МассивИдентификаторовДокументов, Истина, УникальныйИдентификатор);
			Если МассивДанныхДокументов = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СтрокаДанных.АдресХранилища = МассивДанныхДокументов[0];
		КонецЕсли;

		СтруктураОбмена.Вставить("НаименованиеФайла", СтрокаДанных.Документ);
		СтруктураОбмена.Вставить("АдресХранилища",    СтрокаДанных.АдресХранилища);
		
		МассивСтруктур.Добавить(СтруктураОбмена);
	КонецЦикла;
	
	БыстрыйОбменВыгрузитьЭД(МассивСтруктур, СтруктураПараметров);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВывестиЭДНаПросмотр(СтрокаДанных, АвтоматическаяЗагрузка = Неопределено)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(СтрокаДанных.АдресХранилища) Тогда
		МассивИдентификаторовДокументов = Новый Массив;
		МассивИдентификаторовДокументов.Добавить(СтрокаДанных.Идентификатор);
		МассивДанныхДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(МассивИдентификаторовДокументов, Истина, УникальныйИдентификатор);
		Если МассивДанныхДокументов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		СтрокаДанных.АдресХранилища = МассивДанныхДокументов[0];
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ПолноеИмяФайла");
	ПараметрыОткрытия.Вставить("НаименованиеФайла");
	ПараметрыОткрытия.Вставить("НаправлениеЭД");
	ПараметрыОткрытия.Вставить("Контрагент");
	ПараметрыОткрытия.Вставить("ВладелецЭД");
	ПараметрыОткрытия.Вставить("АдресХранилища");
	ПараметрыОткрытия.Вставить("ФайлАрхива");
	ПараметрыОткрытия.Вставить("Информация");
	ПараметрыОткрытия.Вставить("Статус");
	ПараметрыОткрытия.Вставить("Отправитель");
	ПараметрыОткрытия.Вставить("Получатель");
	ПараметрыОткрытия.Вставить("УчастникИНН");
	ПараметрыОткрытия.Вставить("УчастникКПП");
	ПараметрыОткрытия.Вставить("Дата");
	ПараметрыОткрытия.Вставить("Участник");
	ПараметрыОткрытия.Вставить("Идентификатор");
	ПараметрыОткрытия.Вставить("КонтактноеЛицо");
	ПараметрыОткрытия.Вставить("Телефон");
	ПараметрыОткрытия.Вставить("ЭлектроннаяПочта");
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, СтрокаДанных);
	
	// Заполнение дополнительных параметров.
	ПараметрыОткрытия.Вставить("СсылкаНаДокумент", СтрокаДанных.ВладелецЭД);
	ПараметрыОткрытия.Вставить("РежимЗаполненияДокумента", ЗначениеЗаполнено(СтрокаДанных.ВладелецЭД));
	ПараметрыОткрытия.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОткрытия.Вставить("ИдентификаторВнутренний", СтрокаДанных.ИдентификаторВнутренний);
	ПараметрыОткрытия.Вставить("Источник", СтрокаДанных.Источник);
	
	Если ЗначениеЗаполнено(АвтоматическаяЗагрузка) Тогда
		ПараметрыОткрытия.Вставить("АвтоматическаяЗагрузка", Истина);
		ПараметрыОткрытия.Вставить("СопоставлятьНоменклатуру", Истина);
	КонецЕсли;
	
	КонтекстВызова = Новый Структура("СтруктураЭД", ПараметрыОткрытия);
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ПросмотрДокумента", КонтекстВызова,, ПараметрыОткрытия.ИдентификаторВнутренний);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокДокументов()
	
	Идентификатор = Неопределено;
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		Идентификатор = Элементы.Список.ТекущиеДанные.Идентификатор;
	КонецЕсли;
	
	Отказ = Ложь;
	ОчиститьСообщения();
	ОбновитьСписок(Отказ);
	
	Если Идентификатор <> Неопределено Тогда
		Массив = Список.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор));
		Если Массив.Количество() Тогда
			ИдентификаторСтроки = Массив[0].ПолучитьИдентификатор();
			Элементы.Список.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок(Отказ)
	
	ПараметрыЗапроса = Новый Структура();
	ПараметрыЗапроса.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	МассивОрганизаций = БизнесСетьВызовСервера.МассивЗарегистрированныхОрганизаций();
	Если МассивОрганизаций.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Информационная база не подключена к сервису 1С:Бизнес-сеть.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапроса.Вставить("Организация", МассивОрганизаций[0]);
	ПараметрыЗапроса.Вставить("МассивОрганизаций", МассивОрганизаций);
	Если ЗначениеЗаполнено(ОтборКонтрагент) И ВключитьОтборКонтрагент Тогда
		ПараметрыЗапроса.Вставить("ОтборКонтрагент", ОтборКонтрагент);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтборВидДокумента) И ВключитьОтборВидДокумента Тогда
		ПараметрыЗапроса.Вставить("ОтборВидДокумента", ОтборВидДокумента);
	КонецЕсли;
	
	Если НЕ ПоказыватьЗагруженные Тогда
		ПараметрыЗапроса.Вставить("ОтборТолькоНовые", Истина);
	КонецЕсли;
	
	Если РежимИсходящихДокументов Тогда
		ПараметрыЗапроса.Вставить("РежимИсходящихДокументов", Истина);
	КонецЕсли;
	
	// Получение данных из сервиса.
	Результат = БизнесСетьКлиентСервер.ОписаниеРезультатаКомандыСервиса();
	БизнесСетьВызовСервера.ПолучитьВходящиеДокументы(ПараметрыЗапроса, Результат, Отказ);
	
	Список.Очистить();
	
	Если Не Отказ И Результат.КодСостояния = 404 Тогда
		Возврат;
	ИначеЕсли Отказ ИЛИ Результат.КодСостояния <> 200 ИЛИ Результат.Данные = Неопределено
		ИЛИ ТипЗнч(Результат.Данные) <> Тип("Массив") Тогда
		Отказ = Истина;
		ВидОперации = НСтр("ru = 'Получение документов.'");
		ТекстСообщения = НСтр("ru = 'Ошибка получения документов в сервисе 1С:Бизнес-сеть.'");
		ПодробныйТекстОшибки = "";
		Если ТипЗнч(Результат.Данные) = Тип("Структура") И Результат.Данные.Свойство("message") Тогда
			ПодробныйТекстОшибки = СтрШаблон(НСтр("ru = 'Код состояния %1. %2'"), Результат.КодСостояния, Результат.Данные.message);
		КонецЕсли;
		ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, ТекстСообщения, "БизнесСеть");		
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементМассива Из Результат.Данные Цикл
		НоваяСтрока = Список.Добавить();
		НоваяСтрока.Документ = ЭлементМассива.documentTitle;
		Если РежимИсходящихДокументов Тогда
			НоваяСтрока.Участник       = ЭлементМассива.destinationOrganization.title;
			НоваяСтрока.УчастникИНН    = ЭлементМассива.destinationOrganization.Inn;
			НоваяСтрока.УчастникКПП    = ?(ЭлементМассива.destinationOrganization.Kpp = "0", "", ЭлементМассива.destinationOrganization.Kpp);
			НоваяСтрока.ОрганизацияИНН = ЭлементМассива.sourceOrganization.Inn;
			НоваяСтрока.ОрганизацияКПП = ?(ЭлементМассива.sourceOrganization.Kpp = "0", "", ЭлементМассива.sourceOrganization.Kpp);
		Иначе
			НоваяСтрока.Участник       = ЭлементМассива.sourceOrganization.title;
			НоваяСтрока.УчастникИНН    = ЭлементМассива.sourceOrganization.Inn;
			НоваяСтрока.УчастникКПП    = ?(ЭлементМассива.sourceOrganization.Kpp = "0", "", ЭлементМассива.sourceOrganization.Kpp);
			НоваяСтрока.ОрганизацияИНН = ЭлементМассива.destinationOrganization.Inn;
			НоваяСтрока.ОрганизацияКПП = ?(ЭлементМассива.destinationOrganization.Kpp = "0", "", ЭлементМассива.destinationOrganization.Kpp);
		КонецЕсли;
		
		НоваяСтрока.ФайлАрхива     = Истина;
		НоваяСтрока.Сумма          = ЭлементМассива.moneyAmount / 100; // Сервис хранит данные в копейках.
		НоваяСтрока.Информация     = ЭлементМассива.info;
		НоваяСтрока.Идентификатор  = ЭлементМассива.id;
		НоваяСтрока.НаправлениеЭД  = ?(РежимИсходящихДокументов, ПредопределенноеЗначение("Перечисление.НаправленияЭД.Исходящий"),
			ПредопределенноеЗначение("Перечисление.НаправленияЭД.Входящий"));
		НоваяСтрока.ТипОбъекта     = ?(НоваяСтрока.ВозможныеТипыОбъекта.Количество()>0,
			НоваяСтрока.ВозможныеТипыОбъекта[0].Представление, "");
		Если ЗначениеЗаполнено(ЭлементМассива.sentDate) Тогда
			НоваяСтрока.ДатаДокумента = БизнесСетьКлиентСервер.ДатаИзUnixTime(ЭлементМассива.sentDate);	
		КонецЕсли;
		НоваяСтрока.Загружен       = ?(ЭлементМассива.deliveryStatus= "SENT", Истина, Ложь);
		НоваяСтрока.ИдентификаторВнутренний = ЭлементМассива.documentGuid;
		Если Не ЗначениеЗаполнено(НоваяСтрока.ИдентификаторВнутренний) Тогда
			НоваяСтрока.ИдентификаторВнутренний = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
		НоваяСтрока.Источник       = ЭлементМассива;
		
		Если РежимИсходящихДокументов Тогда
			Если ЭлементМассива.deliveryStatus = "SENT" Тогда 
				НоваяСтрока.Статус = "Отправлен";
			ИначеЕсли ЭлементМассива.deliveryStatus = "DELIVERED" Тогда
				НоваяСтрока.Статус = "Доставлен";
			ИначеЕсли ЭлементМассива.deliveryStatus = "REJECTED" Тогда 
				НоваяСтрока.Статус = "Отклонен";
			КонецЕсли;
		Иначе
			Если ЭлементМассива.deliveryStatus = "SENT" Тогда
				НоваяСтрока.Статус = "Новый";
			ИначеЕсли ЭлементМассива.deliveryStatus = "DELIVERED" Тогда
				НоваяСтрока.Статус = "Загружен";
			ИначеЕсли ЭлементМассива.deliveryStatus = "REJECTED" Тогда
				НоваяСтрока.Статус = "Отклонен";
			КонецЕсли;
		КонецЕсли;
		
		Если ЭлементМассива.documentPresentationDataType = "pdf" Тогда
			НоваяСтрока.ПредставлениеДокумента = Истина;
		КонецЕсли;
		
		// Контактная информация.
		НоваяСтрока.КонтактноеЛицо   = ЭлементМассива.person.name;
		НоваяСтрока.Телефон          = ЭлементМассива.person.phone;
		НоваяСтрока.ЭлектроннаяПочта = ЭлементМассива.person.email;
		
	КонецЦикла;
	
	Список.Сортировать("ДатаДокумента");
	ЗаполнитьСсылкиТаблицы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСсылкиТаблицы()
	
	ОснованияЭлектронныхДокументов = Метаданные.ОпределяемыеТипы.ОснованияЭлектронныхДокументов.Тип.Типы();
	
	СоответствиеКонтрагентов = Новый Соответствие;
	СоответствиеОрганизаций  = Новый Соответствие;
	
	Для Каждого СтрокаТаблицы Из Список Цикл
		
		КлючКонтрагента = СтрокаТаблицы.УчастникИНН + СтрокаТаблицы.УчастникКПП;
		Контрагент = СоответствиеКонтрагентов.Получить(КлючКонтрагента);
		Если Контрагент = Неопределено Тогда
			Контрагент = ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП("Контрагенты",
				СтрокаТаблицы.УчастникИНН, СтрокаТаблицы.УчастникКПП);
			СоответствиеКонтрагентов.Вставить(КлючКонтрагента, Контрагент);
		КонецЕсли;
		СтрокаТаблицы.Контрагент = Контрагент;
		
		КлючОрганизации = СтрокаТаблицы.ОрганизацияИНН + СтрокаТаблицы.ОрганизацияКПП;
		Организация = СоответствиеОрганизаций.Получить(КлючОрганизации);
		Если Организация = Неопределено Тогда
			Организация = ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП("Организации",
				СтрокаТаблицы.ОрганизацияИНН, СтрокаТаблицы.ОрганизацияКПП);
			СоответствиеОрганизаций.Вставить(КлючОрганизации, Организация);
		КонецЕсли;
		СтрокаТаблицы.Организация = Организация;
		
		СписокТипов = Новый СписокЗначений;
		ВидЭДСервиса = СтрокаТаблицы.Источник.DocumentDataType;
		
		Если ПустаяСтрока(СтрокаТаблицы.Участник) И ЗначениеЗаполнено(СтрокаТаблицы.Контрагент) Тогда
			СтрокаТаблицы.Участник = Строка(СтрокаТаблицы.Контрагент);
		КонецЕсли;
		
		Если НРег(Лев(ВидЭДСервиса, 3)) = "v8." Тогда
			ВидЭДСервиса = Сред(ВидЭДСервиса, 4);
		КонецЕсли;
		
		Если Метаданные.Перечисления.ВидыЭД.ЗначенияПеречисления.Найти(ВидЭДСервиса) <> Неопределено Тогда
			
			Если Не РежимИсходящихДокументов Тогда
				
				// Поиск документа основания по предопределенному типу.
				ВидДокументаСтроки = Перечисления.ВидыЭД[ВидЭДСервиса];
				ОбменСКонтрагентамиПереопределяемый.СписокТиповДокументовПоВидуЭД(ВидДокументаСтроки, СписокТипов);
				СтрокаТаблицы.ВидДокумента = ВидДокументаСтроки;
				СтрокаТаблицы.ВозможныеТипыОбъекта = СписокТипов;
				Если ЗначениеЗаполнено(СтрокаТаблицы.ИдентификаторВнутренний) И СписокТипов.Количество()>0 Тогда
					Для Счетчик = 0 По СписокТипов.Количество()-1 Цикл
						НаименованиеТипа = СписокТипов.Получить(Счетчик).Значение.Метаданные().Имя;
						ВладелецЭД = Документы[НаименованиеТипа].ПолучитьСсылку(
							Новый УникальныйИдентификатор(СтрокаТаблицы.ИдентификаторВнутренний));
						Если ОбщегоНазначения.СсылкаСуществует(ВладелецЭД) Тогда
							СтрокаТаблицы.ВладелецЭД = ВладелецЭД;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
			Иначе
				
				// Поиск документа основания ЭД по всем доступным типам.
				Для Каждого ТипОснования Из ОснованияЭлектронныхДокументов Цикл
					Ссылка = Новый(ТипОснования);
					СсылкаМетаданные = Ссылка.Метаданные();
					Если Метаданные.Документы.Содержит(СсылкаМетаданные) Тогда
						ВладелецЭД = Документы[СсылкаМетаданные.Имя].ПолучитьСсылку(
							Новый УникальныйИдентификатор(СтрокаТаблицы.ИдентификаторВнутренний));
						Если ОбщегоНазначения.СсылкаСуществует(ВладелецЭД) Тогда
							СтрокаТаблицы.ВладелецЭД = ВладелецЭД;
							Прервать;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДокументВСервисеПослеВопроса(Результат, МассивСтрок) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Элементы.Список.ВыделенныеСтроки;
	КоличествоСтрок = МассивСтрок.Количество();
	ДокументыПоОрганизациям = Новый Соответствие;
	
	Для Каждого ЭлементМассива Из МассивСтрок Цикл
		СтрокаДокумента = Список.НайтиПоИдентификатору(ЭлементМассива);
		Если ДокументыПоОрганизациям[СтрокаДокумента.Организация] = Неопределено Тогда
			ДокументыПоОрганизациям.Вставить(СтрокаДокумента.Организация, Новый Структура("МассивИдентификаторов, МассивСтрок", 
				Новый Массив, Новый Массив));
		КонецЕсли;
		ДокументыПоОрганизациям[СтрокаДокумента.Организация].МассивИдентификаторов.Добавить(СтрокаДокумента.Идентификатор);
		ДокументыПоОрганизациям[СтрокаДокумента.Организация].МассивСтрок.Добавить(СтрокаДокумента);
	КонецЦикла;
	
	// Вызов метода удаления по идентификаторам документов.
	Для Каждого ВыборкаПоОрганизации Из ДокументыПоОрганизациям Цикл
		МассивИдентификаторов = ВыборкаПоОрганизации.Значение.МассивИдентификаторов;
		
		Результат = БизнесСетьКлиентСервер.ОписаниеРезультатаКомандыСервиса();
		Отказ = Ложь;
		
		ПараметрыКоманды = Новый Структура;
		ПараметрыКоманды.Вставить("Организация", ВыборкаПоОрганизации.Ключ);
		ПараметрыКоманды.Вставить("МассивИдентификаторов", МассивИдентификаторов);
		ПараметрыКоманды.Вставить("РежимИсходящихДокументов", РежимИсходящихДокументов);
		БизнесСетьВызовСервера.УдалитьДокументы(ПараметрыКоманды, Результат, Отказ);
		
		Если Отказ ИЛИ Результат.КодСостояния <> 200 Тогда
			Возврат;
		КонецЕсли;
		
		// Удаление строки в форме списка.
		Для Каждого СтрокаДокумента Из ВыборкаПоОрганизации.Значение.МассивСтрок Цикл
			Список.Удалить(СтрокаДокумента);
		КонецЦикла;
	КонецЦикла;
	
	Если КоличествоСтрок = 1 Тогда
		ТекстОповещения	= НСтр("ru = 'Документ удален.'");
		ТекстПояснения	= НСтр("ru = 'Удален документ в сервисе 1С:Бизнес-сеть.'");
	Иначе
		ТекстОповещения	= НСтр("ru = 'Документы удалены (%1).'");
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОповещения, КоличествоСтрок);
		ТекстПояснения	= НСтр("ru = 'Удалены документы в сервисе 1С:Бизнес-сеть.'");
	КонецЕсли;
	ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.БизнесСеть);
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйОбменВыгрузитьЭД(МассивСтруктурОбмена, СтруктураПараметров)
	
	Перем ПутьККаталогу;
	
	МассивФайлов = Новый Массив;
	Для Каждого СтруктураОбмена Из МассивСтруктурОбмена Цикл
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
			СтруктураОбмена.НаименованиеФайла + ".zip", СтруктураОбмена.АдресХранилища);
		МассивФайлов.Добавить(ОписаниеФайла);
	КонецЦикла;
	Если МассивФайлов.Количество() Тогда
		ПустойОбработчик = Новый ОписаниеОповещения("ПустойОбработчик", ЭлектронноеВзаимодействиеСлужебныйКлиент);
		НачатьПолучениеФайлов(ПустойОбработчик, МассивФайлов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.ДатаДокумента", "ДатаДокумента");
	
	// Серый цвет для новых контрагентов.
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокОтправитель.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Контрагент");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);

	// Выделение жирным незагруженных документов
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ВладелецЭД");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина, Ложь, Ложь, Ложь));

КонецПроцедуры

// Открытие представления документа PDF.
//
&НаКлиенте
Процедура ОткрытьПредставление(Команда) 
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		// Получение представления из сервиса.
		МассивИдентификаторовДокументов = Новый Массив;
		МассивИдентификаторовДокументов.Добавить(ТекущиеДанные.Идентификатор);
		МассивДанныхДокументов = БизнесСетьВызовСервера.ПолучитьДанныеДокументаСервиса(МассивИдентификаторовДокументов,
			Истина, УникальныйИдентификатор, Истина);
		
		// Открытие файла.
		ДанныеФайла = Новый Структура;
		ДанныеФайла.Вставить("СсылкаНаДвоичныеДанныеФайла",  МассивДанныхДокументов[0]);
		ДанныеФайла.Вставить("ДатаМодификацииУниверсальная", ОбщегоНазначенияКлиент.ДатаСеанса());
		ДанныеФайла.Вставить("ОтносительныйПуть", "");
		ДанныеФайла.Вставить("ИмяФайла",          ТекущиеДанные.Документ + ".pdf");
		ДанныеФайла.Вставить("Наименование",      ТекущиеДанные.Документ);
		ДанныеФайла.Вставить("Расширение",        "pdf");
		ДанныеФайла.Вставить("ДляРедактирования", Ложь);
		ДанныеФайла.Вставить("Редактирует",       Неопределено);
		ДанныеФайла.Вставить("Версия",            ПредопределенноеЗначение("Справочник.ВерсииФайлов.ПустаяСсылка"));
		ДанныеФайла.Вставить("ТекущаяВерсия",     ПредопределенноеЗначение("Справочник.ВерсииФайлов.ПустаяСсылка"));
		ДанныеФайла.Вставить("ХранитьВерсии",     Ложь);
		ДанныеФайла.Вставить("РабочийКаталогВладельца",  "");
		ДанныеФайла.Вставить("ПолноеИмяФайлаВРабочемКаталоге", "");
		ДанныеФайла.Вставить("ВРабочемКаталогеНаЧтение", Ложь);
		ДанныеФайла.Вставить("ПолноеНаименованиеВерсии", "");
		ДанныеФайла.Вставить("НаЧтение",   Истина);
		ДанныеФайла.Вставить("Зашифрован", Ложь);
		ДанныеФайла.Вставить("Размер",     РазмерФайла(МассивДанныхДокументов[0]));
		ДанныеФайла.Вставить("Ссылка",     ПредопределенноеЗначение("Справочник.ВерсииФайлов.ПустаяСсылка"));
		
		РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РазмерФайла(АдресХранилища)
	
	ИмяФайла = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла();
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
	ДвоичныеДанные.Записать(ИмяФайла);
	ФайлНаДиске = Новый Файл(ИмяФайла);
	РазмерФайла = ФайлНаДиске.Размер();
	ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайла);
	Возврат РазмерФайла;
	
КонецФункции

&НаКлиенте
Процедура ОтклонитьДокументы(Команда)
	
	Отказ = Истина;
	Оповещение = Новый ОписаниеОповещения("ОтклонитьДокументыПродолжение", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Выделенные документы будут отклонены для загрузки.
							  |Продолжить выполнение операции?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтклонитьДокументыПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтрок = Элементы.Список.ВыделенныеСтроки;
	КоличествоСтрок = МассивСтрок.Количество();
	
	ПараметрыВызова = Новый Массив;
	СтруктураУдаления = Новый Структура;
	Для Каждого ЭлементМассива Из МассивСтрок Цикл
		
		СтрокаДокумента = Список.НайтиПоИдентификатору(ЭлементМассива);
		СтруктураУдаления = Новый Структура;
		СтруктураУдаления.Вставить("Ссылка", СтрокаДокумента.Ссылка);
		СтруктураУдаления.Вставить("Идентификатор", СтрокаДокумента.Идентификатор);
		ПараметрыВызова.Добавить(СтруктураУдаления);
		
	КонецЦикла;
	
	Отказ = Ложь;
	БизнесСетьВызовСервера.ОтклонитьДокументы(ПараметрыВызова, Отказ);
	
КонецПроцедуры

#КонецОбласти
