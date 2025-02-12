﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Задача") Тогда
		Задача = Параметры.Задача;
		ЗадачаID = Параметры.ЗадачаID;
		ЗадачаТип = Параметры.ЗадачаТип;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ИсполнительНачалоВыбораЗавершение", ЭтаФорма);
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИсполнителяБизнесПроцесса",, 
		ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Исполнитель", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Исполнитель", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	Модифицированность = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ЗначениеЗаполнено(Исполнитель) Тогда 
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		    НСтр("ru = 'Не указан исполнитель задачи.'"),, 
			"Исполнитель");
		Возврат;
	КонецЕсли;
	Результат = ПеренаправитьЗадачу();
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПеренаправитьЗадачу()

	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMRedirectTasksRequest");
	
	Запрос.Comment = Комментарий;
	
	ЗадачаXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObject");
	ОбъектИД = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
	ОбъектИД.id = ЗадачаID;
	ОбъектИД.type = ЗадачаТип;
	ЗадачаXDTO.objectID = ОбъектИД;
	ЗадачаXDTO.name = Задача;
	Запрос.tasks.Добавить(ЗадачаXDTO);
	
	ИсполнительБП = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMBusinessProcessTaskExecutor");
			
	Если ИсполнительТип = "DMUser" Тогда
		ИсполнительБП.user = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMUser");
		ИсполнительБП.user.name = Исполнитель;
		ИсполнительБП.user.objectId = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
		ИсполнительБП.user.objectId.id = ИсполнительID;
		ИсполнительБП.user.objectId.type = ИсполнительТип;
	Иначе
		ИсполнительБП.role = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMBusinessProcessExecutorRole");
		ИсполнительБП.role.name = Исполнитель;
		ИсполнительБП.role.objectId = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
		ИсполнительБП.role.objectId.id = ИсполнительID;
		ИсполнительБП.role.objectId.type = ИсполнительТип;
		
		Если ЗначениеЗаполнено(ОсновнойОбъектАдресации) Тогда
			ИсполнительБП.mainAddressingObject = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMMainAddressingObject");
			ИсполнительБП.mainAddressingObject.name = ОсновнойОбъектАдресации;
			ИсполнительБП.mainAddressingObject.objectId = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
			ИсполнительБП.mainAddressingObject.objectId.id = ОсновнойОбъектАдресацииID;
			ИсполнительБП.mainAddressingObject.objectId.type = ОсновнойОбъектАдресацииТип;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДополнительныйОбъектАдресации) Тогда
			ИсполнительБП.secondaryAddressingObject = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMSecondaryAddressingObject");
			ИсполнительБП.secondaryAddressingObject.name = ДополнительныйОбъектАдресации;
			ИсполнительБП.secondaryAddressingObject.objectId = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
			ИсполнительБП.secondaryAddressingObject.objectId.id = ДополнительныйОбъектАдресацииID;
			ИсполнительБП.secondaryAddressingObject.objectId.type = ДополнительныйОбъектАдресацииТип;
		КонецЕсли;
	КонецЕсли;
	
	Запрос.performer = ИсполнительБП;
	
	Ответ = Прокси.execute(Запрос);
	
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Если ИнтеграцияС1СДокументооборот.ПроверитьТип(Прокси, Ответ, "DMError") Тогда 
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ИсполнительНачалоВыбораЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Свойство("Исполнитель", Исполнитель);
	Результат.Свойство("ИсполнительID", ИсполнительID);
	Результат.Свойство("ИсполнительТип", ИсполнительТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ОсновнойОбъектАдресацииID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ОсновнойОбъектАдресацииТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ДополнительныйОбъектАдресацииID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип",ДополнительныйОбъектАдресацииТип);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти
