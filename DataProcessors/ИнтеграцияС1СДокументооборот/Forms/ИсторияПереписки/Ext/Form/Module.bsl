﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("id") Тогда
		ПредметID = Параметры.id;
		ПредметТип = Параметры.type;
	КонецЕсли;
	
	Если ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.2.8.1.CORP") Тогда
		ПолучитьЗаполнитьДеревоПисем();
	Иначе
		Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтаФорма);
		Элементы.ДеревоПисем.Видимость = Ложь;
	КонецЕсли;
	
	Если ПредметТип = "DMCorrespondent" Тогда
		Элементы.ДеревоПисемНомер.Видимость = Истина;
		Элементы.ДеревоПисемАдресаты.Видимость = Ложь;
		Элементы.ДеревоПисемПисьмо.Заголовок = НСтр("ru='Документ'");
	Иначе
		Элементы.ДеревоПисемНомер.Видимость = Ложь;
		Элементы.ДеревоПисемАдресаты.Видимость = Истина;
		Элементы.ДеревоПисемПисьмо.Заголовок = НСтр("ru='Письмо'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазвернутьДеревоПисем();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотИсходящееПисьмо" Тогда
		Если Источник = ЭтаФорма Тогда
			ПолучитьЗаполнитьДеревоПисем();
			РазвернутьДеревоПисем();
		ИначеЕсли ЗначениеЗаполнено(Параметр) Тогда
			Если Параметр.ПредметID = ПредметID Тогда
				ПолучитьЗаполнитьДеревоПисем();
				РазвернутьДеревоПисем();
			ИначеЕсли ПисьмоЕстьВСписке(Параметр.ПисьмоОснованиеID) Тогда
				ПолучитьЗаполнитьДеревоПисем();
				РазвернутьДеревоПисем();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПисем

&НаКлиенте
Процедура ДеревоПисемВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = ДеревоПисем.НайтиПоИдентификатору(ВыбраннаяСтрока);
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ТекущаяСтрока.ПисьмоТип, ТекущаяСтрока.ПисьмоID, ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ПолучитьЗаполнитьДеревоПисем();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОбъект(Команда)
	
	ТекущаяСтрока = Элементы.ДеревоПисем.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ТекущаяСтрока.ПисьмоТип, ТекущаяСтрока.ПисьмоID, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьЗаполнитьДеревоПисем()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	СписокУсловий = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetCorrespondenceTreeQuery");
	ПредметXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObject");
	ПредметXDTO.name = "";
	ПредметXDTO.objectID = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ПредметID, ПредметТип);
	СписокУсловий.target.Добавить(ПредметXDTO);
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetCorrespondenceTreeRequest");
	Запрос.query = СписокУсловий;

	Ответ = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Дерево = РеквизитФормыВЗначение("ДеревоПисем");
	Дерево.Строки.Очистить();
	Для каждого Элемент из Ответ.followers Цикл
		ЗаполнитьСтрокуДерева(Дерево.Строки, Элемент);
	КонецЦикла;
	ЗначениеВРеквизитФормы(Дерево, "ДеревоПисем");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуДерева(СтрокиДерева, СтрокаXDTO)
	
	СтрокаДерева = СтрокиДерева.Добавить();
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(СтрокаДерева, СтрокаXDTO.object, "Письмо");
	СтрокаДерева.Адресаты = СтрокаXDTO.recipients;
	СтрокаДерева.Дата = СтрокаXDTO.date;
	
	Если ПредметТип = "DMCorrespondent" Или ПредметТип = "DMOutgoingEMail" Тогда
		Если СтрокаXDTO.Свойства().Получить("regNumber") <> Неопределено Тогда
			СтрокаДерева.Номер = СтрокаXDTO.regNumber;
		КонецЕсли;
		Если СтрокаXDTO.Свойства().Получить("sent") <> Неопределено Тогда
			СтрокаДерева.Отправлен = СтрокаXDTO.sent;
		КонецЕсли;
	КонецЕсли;
	
	Если СтрокаДерева.ПисьмоТип = "DMIncomingEMail" Тогда
		СтрокаДерева.Картинка = 0;
	ИначеЕсли СтрокаДерева.ПисьмоТип = "DMOutgoingEMail" Тогда
		// заполняется ли свойство sent&
		Если ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP") Тогда
			Если СтрокаДерева.Отправлен = Истина Тогда
				СтрокаДерева.Картинка = 1 
			Иначе
				СтрокаДерева.Картинка = 3;
			КонецЕсли;
		Иначе
			СтрокаДерева.Картинка = 1;
		КонецЕсли;
	ИначеЕсли ПредметТип = "DMCorrespondent" Тогда
		Если СтрокаДерева.ПисьмоТип = "DMInternalDocument" Тогда
			СтрокаДерева.Картинка = 2;
		ИначеЕсли СтрокаДерева.ПисьмоТип = "DMIncomingDocument" Тогда
			СтрокаДерева.Картинка = 0;
		Иначе
			Если СтрокаДерева.Отправлен Тогда
				СтрокаДерева.Картинка = 1;
			Иначе
				СтрокаДерева.Картинка = 3;
			КонецЕсли;
		КонецЕсли;
	Иначе
		СтрокаДерева.Картинка = 2;
	КонецЕсли;
	
	Для каждого Элемент из СтрокаXDTO.followers Цикл
		ЗаполнитьСтрокуДерева(СтрокаДерева.Строки, Элемент);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДеревоПисем()
	
	ЭлементыДерева = ДеревоПисем.ПолучитьЭлементы();
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Элементы.ДеревоПисем.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПисьмоЕстьВСписке(ПисьмоID)
	
	ЭлементыДерева = ДеревоПисем.ПолучитьЭлементы();
	Возврат ПроверитьНаличиеЭлементаДерева(ЭлементыДерева,ПисьмоID);
	
КонецФункции

&НаКлиенте
Функция ПроверитьНаличиеЭлементаДерева(ЭлементыДерева, ПисьмоID)
	
	Для каждого ЭлементДерева из ЭлементыДерева Цикл
		Если ЭлементДерева.ПисьмоID = ПисьмоID Тогда 
			Возврат Истина;
		КонецЕсли;
		Подчиненные = ЭлементДерева.ПолучитьЭлементы();
	    Возврат ПроверитьНаличиеЭлементаДерева(Подчиненные, ПисьмоID)
	КонецЦикла;

	Возврат Ложь;
	
КонецФункции

#КонецОбласти
