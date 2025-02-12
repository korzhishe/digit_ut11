﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КаталогДляСохраненияДанных = ИнтеграцияС1СДокументооборотВызовСервера.ЛокальныйКаталогФайлов();
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
		
	ЗаполнитьФормуПисьма(Параметры);
	ОтобразитьКоличествоФайловСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ПредметID) Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ПредметТип, ПредметID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПриложений

&НаКлиенте
Процедура ДеревоПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьФайл(ТекущиеДанные.СсылкаID, ТекущиеДанные.Ссылка,
			ТекущиеДанные.Расширение, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ответить(Команда)
	
	ПараметрыФормы = новый Структура("Предмет", новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("name", Тема);
	ПараметрыФормы.Предмет.Вставить("id", ID);
	ПараметрыФормы.Предмет.Вставить("type", Тип);
	ПараметрыФормы.Вставить("answerType", "reply");
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо", ПараметрыФормы);
	ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветитьВсем(Команда)
	
	ПараметрыФормы = новый Структура("Предмет", новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("name", Тема);
	ПараметрыФормы.Предмет.Вставить("id", ID);
	ПараметрыФормы.Предмет.Вставить("type", Тип);
	ПараметрыФормы.Вставить("answerType", "replyToAll");
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо", ПараметрыФормы);
	ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Переслать(Команда)
	
	ПараметрыФормы = новый Структура("Предмет", новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("name", Тема);
	ПараметрыФормы.Предмет.Вставить("id", ID);
	ПараметрыФормы.Предмет.Вставить("type", Тип);
	ПараметрыФормы.Вставить("answerType", "transfer");
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо", ПараметрыФормы);
	ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПроцесс(Команда)
	
	ПараметрыФормы = новый Структура("Предмет", новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("id", ID);
	ПараметрыФормы.Предмет.Вставить("type", Тип);
	ПараметрыФормы.Предмет.Вставить("name", Представление);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.СозданиеБизнесПроцесса", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФормуПисьма(Параметры)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Ответ = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(Прокси, Параметры.type, Параметры.id);
	ПисьмоXDTO = Ответ.objects[0];
	
	ID = ПисьмоXDTO.objectId.id;
	Тип = ПисьмоXDTO.objectId.type;
	Представление = ПисьмоXDTO.objectID.presentation;
	Заголовок = ПисьмоXDTO.subject;
	Тема = ПисьмоXDTO.subject;
	ТекстПисьма = ПисьмоXDTO.body;
	ДатаСоздания = ПисьмоXDTO.creationDate;
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ПисьмоXDTO.importance,"Важность");
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ПисьмоXDTO.target,"Предмет");

	ДобавитьАдресатов(ПисьмоXDTO.senderAddress, НСтр("ru='От'"));
	ДобавитьАдресатов(ПисьмоXDTO.recipients, НСтр("ru='Кому'"));
	ДобавитьАдресатов(ПисьмоXDTO.courtesyCopyRecipients, НСтр("ru='Копия'"));
	
	Если ПисьмоXDTO.Свойства().Получить("files") <> Неопределено Тогда
		Для каждого Файл из ПисьмоXDTO.files Цикл
			Стр = ДеревоПриложений.Добавить();
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(Стр,Файл,"Ссылка");
			Стр.Расширение = Файл.extension;
			Стр.ДатаМодификации = Файл.modificationDateUniversal;
			Стр.Размер = Файл.size;
			Стр.КартинкаТипаОбъекта = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Файл.extension);
			УстановитьКартинкуТипаОбъекта(Стр);
		КонецЦикла;
	КонецЕсли;
	
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьНавигационнуюСсылку(ЭтаФорма, ПисьмоXDTO);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьАдресатов(СтрокаАдресатов, ТипАдресатов)
	Если НЕ ПустаяСтрока(СтрокаАдресатов) Тогда
		МассивАдресатов = ИнтеграцияС1СДокументооборот.РазложитьСтрокуВМассивПодстрок(СтрокаАдресатов,";", Истина);
		Для каждого Адресат из МассивАдресатов Цикл
			Если НЕ ПустаяСтрока(СокрЛП(Адресат)) Тогда 
				СтрокаАдресата = Адресаты.Добавить();
				СтрокаАдресата.ТипАдресата = ТипАдресатов + ":";
				СтрокаАдресата.Адресат = СокрЛП(Адресат);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинкуТипаОбъекта(СтрокаПредмета)
	Если Найти(СтрокаПредмета.СсылкаТип,"Документ.") <> 0 Тогда
		СтрокаПредмета.КартинкаТипаОбъекта = БиблиотекаКартинок.Документ;
	ИначеЕсли Найти(СтрокаПредмета.СсылкаТип,"Справочник.") <> 0 Тогда
		СтрокаПредмета.КартинкаТипаОбъекта = БиблиотекаКартинок.Справочник
	ИначеЕсли Найти(СтрокаПредмета.СсылкаТип,"БизнесПроцесс.") <> 0 Тогда
		СтрокаПредмета.КартинкаТипаОбъекта = БиблиотекаКартинок.БизнесПроцесс;
	ИначеЕсли Найти(СтрокаПредмета.СсылкаТип,"Задача.") <> 0 Тогда
		СтрокаПредмета.КартинкаТипаОбъекта = БиблиотекаКартинок.Задача;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтобразитьКоличествоФайловСервер()
	
	Если ДеревоПриложений.Количество() > 0 Тогда
		Элементы.ДеревоПриложенийСсылка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Файлы (%1)'"),
			ДеревоПриложений.Количество());
	Иначе
		Элементы.ДеревоПриложенийСсылка.Заголовок = НСтр("ru = 'Файлы'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
