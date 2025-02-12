﻿// Работает только если подсистема ИПП выключена из командного интерфейса:
// e1cib/command/Справочник.Новости.Команда.КомандаСписокВажныхНовостейТребующихПрочтения.

// Важно, что подсистема ИнтернетПоддержкаПользователей должна быть включена в командный интерфейс (хотя может быть и не видна).
// Иначе будет ошибка при вызове этой команды.
// При изменении наименования подсистемы ИнтернетПоддержкаПользователей, необходимо изменить ссылки и здесь.
// НЕ работает, если подсистема ИПП выключена из командного интерфейса.
// e1cib/navigationpoint/ИнтернетПоддержкаПользователей/Справочник.Новости.Команда.КомандаСписокВажныхНовостейТребующихПрочтения.

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	// Вначале найти окно со списком новостей.
	ГлавноеОкно = Неопределено;
	ОкноЧтенияНовостейОткрыто = Ложь;
	СписокОткрытыхОкон = ПолучитьОкна();
	Для каждого ОткрытоеОкно Из СписокОткрытыхОкон Цикл
		Если ОткрытоеОкно.Основное Тогда
			ГлавноеОкно = ОткрытоеОкно;
		КонецЕсли;
		// Если окно открыто на рабочем столе, то нельзя понять, открыто оно или нет
		Если (НЕ ОткрытоеОкно.Основное) И (ОткрытоеОкно.Заголовок = НСтр("ru='Новости 1С'")) Тогда
			ОкноЧтенияНовостейОткрыто = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	// Если окно чтения новостей не открыто, открыть его.
	Если ОкноЧтенияНовостейОткрыто = Ложь Тогда
		Если ПараметрыВыполненияКоманды = Неопределено Тогда

			ПараметрыОткрытияФормы = Новый Структура;

			ИмяФормы = "Справочник.Новости.Форма.ФормаПросмотраНовостей"; // ИмяФормы
			ОбработкаНовостейКлиентПереопределяемый.ПереопределитьПараметрыОткрытияФормыСпискаНовостей(
				ИмяФормы,
				ПараметрыОткрытияФормы,
				ПараметрКоманды,
				ПараметрыВыполненияКоманды);

			Форма = ОткрытьФорму(
				ИмяФормы,
				ПараметрыОткрытияФормы,
				Неопределено,
				""); // Уникальность

		Иначе

			ПараметрыОткрытияФормы = Новый Структура;

			ИмяФормы = "Справочник.Новости.Форма.ФормаПросмотраНовостей"; // ИмяФормы
			ОбработкаНовостейКлиентПереопределяемый.ПереопределитьПараметрыОткрытияФормыСпискаНовостей(
				ИмяФормы,
				ПараметрыОткрытияФормы,
				ПараметрКоманды,
				ПараметрыВыполненияКоманды);

			Форма = ОткрытьФорму(
				ИмяФормы,
				ПараметрыОткрытияФормы,
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Уникальность);

		КонецЕсли;
	КонецЕсли;

	// Оповестить о фильтрации.
	// Сейчас Важные и Очень важные новости отображаются одинаково.
	Оповестить(
		"Новости. Активизировать папку отбора", // Событие
		Новый Структура("ВариантОтбора, ЗначениеОтбора", // Параметры
			5,
			Неопределено), // ЗначениеОтбора не нужно, но для корректной обработки нужно вставить пустое значение.
		Неопределено); // Источник.

КонецПроцедуры

#КонецОбласти
