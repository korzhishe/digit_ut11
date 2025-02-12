﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДоступнаМультипредметность = ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("2.0.3.1");
	Элементы.СтраницыМультипредметность.ТекущаяСтраница = ?(ДоступнаМультипредметность, 
		Элементы.СтраницаДоступнаМультипредметность,
		Элементы.СтраницаНедоступнаМультипредметность);
	
	ТипПроцессаXDTO = "DMBusinessProcessInvitation";
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(ТипПроцессаXDTO, Параметры);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
	Если Параметры.Свойство("Шаблон") Тогда
		ШаблонID = Параметры.Шаблон.id;
		ШаблонТип = Параметры.Шаблон.type;
	КонецЕсли;
	
	Если Параметры.Свойство("taskID") Тогда
		ЭтаФорма.Заголовок = НСтр("ru = 'Повтор приглашения'");
		ЭтаФорма.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Нет;
		ЭтаФорма.ТолькоПросмотр = Ложь;
		Элементы.ГруппаПовторСогласования.Видимость = Истина;
		Элементы.ОК.КнопкаПоУмолчанию = Истина;
		Элементы.ГруппаИнфо.Видимость = Ложь;
		Элементы.ГлавнаяЗадачаПредставление.Видимость = Ложь;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотПереопределяемый.ДополнительнаяОбработкаФормыБизнесПроцесса(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтаФорма);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,,ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменен" И Параметр = Элементы.ПредметПредставление Тогда 
		Предмет = Источник.Представление;
	ИначеЕсли ИмяСобытия = "Запись_ДокументооборотБизнесПроцесс" Тогда
		Если Параметр.ID = ID Тогда
			ПеречитатьПроцесс();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГлавнаяЗадачаПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ГлавнаяЗадача) Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ГлавнаяЗадачаТип, ГлавнаяЗадачаID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ПредметТип, ПредметID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	
	Если Срок = НачалоДня(Срок) Тогда 
		Срок = КонецДня(Срок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
		
	Если ЗначениеЗаполнено(Текст) Тогда
		
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMUser;DMBusinessProcessExecutorRole", ДанныеВыбора, Текст, СтандартнаяОбработка);
		Если ДанныеВыбора.Количество() = 1 Тогда
			ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВСписке(
				Элемент.Родитель.Родитель, ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВСписке(Элемент.Родитель.Родитель, ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеИзВыпадающегоСписка("DMBusinessProcessImportance", "Важность", ЭтаФорма); 
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
			"DMBusinessProcessImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
				"Важность", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Важность", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Автор", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Автор", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Автор", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсполнители

&НаКлиенте
Процедура ИсполнителиИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ИсполнителиИсполнительНачалоВыбораЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИсполнителяБизнесПроцесса",, 
		ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиИсполнительНачалоВыбораЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Исполнители.ТекущиеДанные;
	
	Результат.Свойство("Исполнитель", ТекущиеДанные.Исполнитель);
	Результат.Свойство("ИсполнительID", ТекущиеДанные.ИсполнительID);
	Результат.Свойство("ИсполнительТип", ТекущиеДанные.ИсполнительТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", ТекущиеДанные.ОсновнойОбъектАдресации);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ТекущиеДанные.ОсновнойОбъектАдресацииID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ТекущиеДанные.ОсновнойОбъектАдресацииТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ТекущиеДанные.ДополнительныйОбъектАдресации);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ТекущиеДанные.ДополнительныйОбъектАдресацииID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип", ТекущиеДанные.ДополнительныйОбъектАдресацииТип);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	РезультатЗаписи = ЗаписатьОбъект();
	
	Если РезультатЗаписи Тогда
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтаФорма, Ложь);
		ЭтаФорма.Заголовок = Представление;
		Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Бизнес-процесс ""%1"" сохранен.'"), Представление));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтартоватьИЗакрыть(Команда)
	
	РезультатЗапуска = ПодготовитьКПередачеИСтартоватьБизнесПроцесс();
	
	Если РезультатЗапуска Тогда 
		ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтаФорма, Истина);
		ТекстСостояния = НСтр("ru = 'Бизнес-процесс ""%Наименование%"" успешно запущен.'");
		ТекстСостояния = СтрЗаменить(ТекстСостояния,"%Наименование%", Представление);
		Состояние(ТекстСостояния);
		Модифицированность = Ложь;
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуЗавершение", ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.НачатьВыборШаблонаБизнесПроцесса(Оповещение, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если ПодготовитьКПередачеИЗаписатьБизнесПроцесс() Тогда
		Модифицированность = Ложь;
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ОстановитьПроцесс(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ПрерватьПроцесс(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьПроцесс(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ПродолжитьПроцесс(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьПоШаблонуЗавершение(РезультатВыбораШаблона, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(РезультатВыбораШаблона) = Тип("Структура") Тогда
		ЗаполнитьКарточкуПоШаблону(РезультатВыбораШаблона);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКарточкуПоШаблону(ДанныеШаблона)
	
	РезультатЗаполнения = ИнтеграцияС1СДокументооборотВызовСервера.ЗаполнитьБизнесПроцессПоШаблону(ЭтаФорма, ДанныеШаблона);
	ЗаполнитьФормуИзОбъектаXDTO(РезультатЗаполнения.object);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO)
	
	Если ОбъектXDTO.Установлено("objectID") Тогда
		ID = ОбъектXDTO.objectId.id;
		Тип = ОбъектXDTO.objectId.type;
	КонецЕсли;
	
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьНавигационнуюСсылку(ЭтаФорма, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьСтандартнуюШапкуБизнесПроцесса(ЭтаФорма, ОбъектXDTO);
	Обработки.ИнтеграцияС1СДокументооборот.УстановитьВидимостьКомандИзмененияСостоянияПроцесса(ЭтаФорма, ОбъектXDTO);
	
	ДатаНачалаМероприятия = ОбъектXDTO.activityBegin;
	ДатаОкончанияМероприятия = ОбъектXDTO.activityEnd;
	МестоПроведения = ОбъектXDTO.activityVenue;
	Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(ЭтаФорма, ОбъектXDTO.invitationResult, "РезультатПриглашения");
	Срок = ОбъектXDTO.dueDate;
	
	Исполнители.Очистить();
	Для Каждого Исполнитель Из ОбъектXDTO.Performers Цикл
		НоваяСтрока = Исполнители.Добавить();
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьИсполнителяВФорме(НоваяСтрока, Исполнитель);
		НоваяСтрока.ЯвкаОбязательна = Исполнитель.attendanceCompulsory;
	КонецЦикла;
	
	//Декорации
	Если РезультатПриглашенияID = "ПринятоВсемиУчастниками"
		Или РезультатПриглашенияID = "ПринятоОбязательнымиУчастниками" Тогда 
		Элементы.РезультатПриглашения.Заголовок = РезультатПриглашения;
		Элементы.РезультатПриглашения.ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
	Иначе
		Элементы.РезультатПриглашения.Заголовок = РезультатПриглашения;
		Элементы.РезультатПриглашения.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
	КонецЕсли;
	
	// Возможно, изменение процесса запрещено его шаблоном.
	ЗапрещеноИзменение = Ложь;
	Если ОбъектXDTO.Свойства().Получить("blockedByTemplate") <> Неопределено Тогда
		ЗапрещеноИзменение = ОбъектXDTO.blockedByTemplate;
	КонецЕсли;
	Элементы.СрокИсполнения.ТолькоПросмотр = Элементы.СрокИсполнения.ТолькоПросмотр
		ИЛИ (ЗначениеЗаполнено(Срок) И ЗапрещеноИзменение);
	Элементы.СрокИсполненияВремя.ТолькоПросмотр = Элементы.СрокИсполненияВремя.ТолькоПросмотр
		ИЛИ (ЗначениеЗаполнено(Срок) И ЗапрещеноИзменение);
	Если Исполнители.Количество() > 0 И ЗапрещеноИзменение Тогда
		Элементы.Исполнители.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьОбъект(Прокси, Тип)
	
	Возврат ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, Тип);
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИЗаписатьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	Если ЗначениеЗаполнено(ID) Тогда
		РезультатЗаписи = ИнтеграцияС1СДокументооборот.ЗаписатьОбъект(Прокси, ОбъектXDTO);
	Иначе
		РезультатСоздания = ИнтеграцияС1СДокументооборот.СоздатьНовыйОбъект(Прокси, ОбъектXDTO);
	КонецЕсли;
	
	Результат = ?(РезультатСоздания = Неопределено, РезультатЗаписи, РезультатСоздания);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Результат);

	Если РезультатЗаписи <> Неопределено Тогда // запрос на запись возвращает список
		ОбъектXDTO = Результат.objects[0];
		УстановитьСсылкуБизнесПроцесса(ОбъектXDTO);
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьПредметыВФорме(ЭтаФорма, ОбъектXDTO);
	Иначе // запрос на создание возвращает сам объект
		ОбъектXDTO = Результат.object;
		УстановитьСсылкуБизнесПроцесса(ОбъектXDTO);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИСтартоватьБизнесПроцесс()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	ОбъектXDTO = ПодготовитьБизнесПроцесс(Прокси);
	
	РезультатЗапуска = ИнтеграцияС1СДокументооборот.ЗапуститьБизнесПроцесс(Прокси, ОбъектXDTO);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, РезультатЗапуска);
	
	УстановитьСсылкуБизнесПроцесса(РезультатЗапуска.businessProcess);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьБизнесПроцесс(Прокси)
	
	ОбъектXDTO = Обработки.ИнтеграцияС1СДокументооборот.ПодготовитьШапкуБизнесПроцесса(
		Прокси, "DMBusinessProcessInvitation", ЭтаФорма);
	
	//особенная шапка Приглашения
	ОбъектXDTO.activityBegin = ДатаНачалаМероприятия;
	ОбъектXDTO.activityEnd = ДатаОкончанияМероприятия;
	ОбъектXDTO.activityVenue = МестоПроведения;
	
	//исполнители
	Для Каждого Строка Из Исполнители Цикл 
		Исполнитель = СоздатьОбъект(Прокси, "DMBusinessProcessInvitationParticipant");
		Если Строка.ИсполнительТип = "DMUser" Тогда
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси, Строка, 
				"Исполнитель", Исполнитель.user, "DMUser");
		Иначе
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси, Строка, 
				"Исполнитель", Исполнитель.role, "DMBusinessProcessExecutorRole");
			
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси, Строка, 
				"ОсновнойОбъектАдресации", Исполнитель.mainAddressingObject, "DMMainAddressingObject");
			
			Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси, Строка, 
				"ДополнительныйОбъектАдресации", Исполнитель.secondaryAddressingObject, "DMSecondaryAddressingObject"); 
		КонецЕсли;
		Исполнитель.attendanceCompulsory = Строка.ЯвкаОбязательна;
		ОбъектXDTO.performers.Добавить(Исполнитель);
	КонецЦикла;
	
	Возврат ОбъектXDTO;
	
КонецФункции

&НаКлиенте
Функция ЗаписатьОбъект() Экспорт
	
	ПодготовитьКПередачеИЗаписатьБизнесПроцесс();
	ИнтеграцияС1СДокументооборотКлиент.Оповестить_ЗаписьБизнесПроцесса(ЭтаФорма, Ложь);
	Модифицированность = Ложь;
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура УстановитьСсылкуБизнесПроцесса(ОбъектXDTO)
	
	ID = ОбъектXDTO.objectId.id;
	Если ОбъектXDTO.objectId.Свойства().Получить("presentation") <> Неопределено Тогда
		Представление = ОбъектXDTO.objectId.presentation;
	Иначе
		Представление = ОбъектXDTO.name;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	ЗаписатьОбъект();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПрограммноДобавленнуюКоманду(Команда)
	
	// Вызовем обработчик команды, которая добавлена программно при создании формы на сервере.
	ИнтеграцияС1СДокументооборотКлиентПереопределяемый.ВыполнитьПрограммноДобавленнуюКоманду(Команда, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметОсновной(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(ЭтаФорма, "Основной", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметВспомогательный(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПредметЗавершение", ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.ДобавитьПредмет(ЭтаФорма, "Вспомогательный", ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПредмет(Команда)
	
	ОткрытьПредмет();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Предметы.Удалить(ТекущиеДанные);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПредмет();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПредметЗавершение(ОписаниеПредмета, ПараметрыОбработчика) Экспорт
	
	Если ОписаниеПредмета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаПредмета = Предметы.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаПредмета, ОписаниеПредмета);
	СтрокаПредмета.Картинка = ИнтеграцияС1СДокументооборотКлиентСервер.
		НомерКартинкиПоРолиПредмета(СтрокаПредмета.РольПредмета);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредмет()
	
	ТекущиеДанные = Элементы.Предметы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
		
	Иначе
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("ИдентификаторСтроки", ТекущиеДанные.ПолучитьИдентификатор());
		ПараметрыОповещения.Вставить("Предмет", ТекущиеДанные.Предмет);
		ПараметрыОповещения.Вставить("ПредметID", ТекущиеДанные.ПредметID);
		ПараметрыОповещения.Вставить("ПредметТип", ТекущиеДанные.ПредметТип);
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(ТекущиеДанные.ПредметТип, ТекущиеДанные.ПредметID);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьПроцесс()
	
	ПараметрыПолучения = Новый Структура("id, type", ID, Тип);
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъектXDTOПроцесса(Тип, ПараметрыПолучения);
	ЗаполнитьФормуИзОбъектаXDTO(ОбъектXDTO);
	
КонецПроцедуры

#КонецОбласти