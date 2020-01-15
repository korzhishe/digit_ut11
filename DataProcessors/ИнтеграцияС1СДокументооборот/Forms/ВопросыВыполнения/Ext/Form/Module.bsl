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
	
	// вопросы выполнения задач
	Если ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.2.7.3") Тогда
		ВывестиСписокВопросов();
	Иначе
		Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтаФорма);
		Элементы.Вопросы.Видимость = Ложь;
		Элементы.ВопросыОписание.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если (ИмяСобытия = "Запись_ДокументооборотЗадача" 
		ИЛИ ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс") И Источник = ЭтаФорма Тогда
		ВывестиСписокВопросов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВопросы

&НаКлиенте
Процедура ВопросыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Процесс = Элементы.Вопросы.ТекущиеДанные;
	
	Если Процесс <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(Процесс.ВопросТип, Процесс.ВопросID, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Модифицированность = Ложь;
	ВывестиСписокВопросов();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВыполнить(Команда)
	
	Модифицированность = Ложь;
	ПараметрыФормы = Новый Структура("СтрокаПоиска",СтрокаПоиска);
	Оповещение = Новый ОписаниеОповещения("НайтиВыполнитьЗавершение", ЭтаФорма);
	 
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ПоискВСписке", ПараметрыФормы, ЭтаФорма,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВыполнитьЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		СтрокаПоиска = Результат;
		ВывестиСписокВопросов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПоиск(Команда)
	
	// отменяем режим поиска
	Модифицированность = Ложь;
	СтрокаПоиска = "";
	ВывестиСписокВопросов();
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	
	Модифицированность = Ложь;
	ПарметрыФормы = новый Структура;
	ПарметрыФормы.Вставить("id", ПредметID);
	ПарметрыФормы.Вставить("type", ПредметТип);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.БизнесПроцессРешениеВопросовНовыйВопрос", ПарметрыФормы, ЭтаФорма, ПредметID);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВывестиСписокВопросов()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	СписокУсловий = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "target";
	Условие.value = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ПредметID, ПредметТип);
	СписокУсловий.conditions.Добавить(Условие);
	
	Если ЗначениеЗаполнено(СтрокаПоиска) Тогда
		Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
		Условие.property = "name";
		Условие.value = СтрокаПоиска;
		СписокУсловий.conditions.Добавить(Условие);
	КонецЕсли;
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.type = "DMBusinessProcessIssuesSolution";
	Запрос.query = СписокУсловий;
	
	Ответ = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Вопросы.Очистить();
	Для каждого Вопрос Из Ответ.items Цикл
		
		БизнесПроцесс = Вопрос.object;
		СтрокаВопроса = Вопросы.Добавить();
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(СтрокаВопроса, БизнесПроцесс, "Вопрос");
		СтрокаВопроса.Вопрос = БизнесПроцесс.description;
		СтрокаВопроса.Дата = БизнесПроцесс.beginDate;
		СтрокаВопроса.Описание = БизнесПроцесс.perfomanceHistory;
		СтрокаВопроса.ПоказыватьКартинку = Истина;
		
	КонецЦикла
	
КонецПроцедуры

#КонецОбласти
