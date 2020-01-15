﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ПустаяСтрока(Параметры.Тег) Тогда
		ЭтаФорма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Добавление тега %1'"),
			ВРег(Параметры.Тег));
	Иначе
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ЭтаФорма.ВыделенныйТекст = Параметры.ВыделенныйТекст;
	ЭтаФорма.Тег             = Параметры.Тег;

	// Для текста
	//  <b style="color:red; ">
	// в этот параметр будет передано
	//  style="color:red; ".
	РаспарситьАтрибуты(Параметры.Атрибуты);

	УправлениеФормой(ЭтаФорма);

	Если (ВРег(ЭтаФорма.Тег) = ВРег("p"))
			ИЛИ (ВРег(ЭтаФорма.Тег) = ВРег("div")) Тогда
		Элементы.ГруппаВыравниваниеАбзаца.Видимость = Истина;
	Иначе
		Элементы.ГруппаВыравниваниеАбзаца.Видимость = Ложь;
		ЭтаФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ЭтаФорма.Пример = ПолучитьПредставлениеАтрибутов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомандаВыравниваниеАбзаца(Команда)

	СброситьВсе = Ложь;
	УстановитьПометку = 0;

	// Если пометка уже была, то сбросить все пометки.
	// Если пометки не было, то сбросить все, а эту установить.
	Если Команда.Имя = "КомандаВыравниваниеАбзацаВлево" Тогда // 1
		Если Элементы.КомандаВыравниваниеАбзацаВлево.Пометка = Истина Тогда
			СброситьВсе = Истина;
		Иначе
			УстановитьПометку = 1
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаВыравниваниеАбзацаВправо" Тогда // 2
		Если Элементы.КомандаВыравниваниеАбзацаВлево.Пометка = Истина Тогда
			СброситьВсе = Истина;
		Иначе
			УстановитьПометку = 2
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаВыравниваниеАбзацаПоЦентру" Тогда // 3
		Если Элементы.КомандаВыравниваниеАбзацаВлево.Пометка = Истина Тогда
			СброситьВсе = Истина;
		Иначе
			УстановитьПометку = 3
		КонецЕсли;
	ИначеЕсли Команда.Имя = "КомандаВыравниваниеАбзацаПоШирине" Тогда // 4
		Если Элементы.КомандаВыравниваниеАбзацаВлево.Пометка = Истина Тогда
			СброситьВсе = Истина;
		Иначе
			УстановитьПометку = 4
		КонецЕсли;
	КонецЕсли;

	Элементы.КомандаВыравниваниеАбзацаВлево.Пометка    = Ложь;
	Элементы.КомандаВыравниваниеАбзацаВправо.Пометка   = Ложь;
	Элементы.КомандаВыравниваниеАбзацаПоЦентру.Пометка = Ложь;
	Элементы.КомандаВыравниваниеАбзацаПоШирине.Пометка = Ложь;
	Если СброситьВсе = Ложь Тогда
		ЭтаФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
		ЭтаФорма.ФорматВыравниваниеАбзаца = УстановитьПометку;
		Если УстановитьПометку = 1 Тогда
			Элементы.КомандаВыравниваниеАбзацаВлево.Пометка    = Истина;
		ИначеЕсли УстановитьПометку = 2 Тогда
			Элементы.КомандаВыравниваниеАбзацаВправо.Пометка   = Истина;
		ИначеЕсли УстановитьПометку = 3 Тогда
			Элементы.КомандаВыравниваниеАбзацаПоЦентру.Пометка = Истина;
		ИначеЕсли УстановитьПометку = 4 Тогда
			Элементы.КомандаВыравниваниеАбзацаПоШирине.Пометка = Истина;
		КонецЕсли;
	Иначе
		ЭтаФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Истина;
	КонецЕсли;

	ЭтаФорма.Пример = ПолучитьПредставлениеАтрибутов();

КонецПроцедуры

&НаКлиенте
Процедура ФорматЦветТекстаПриИзменении(Элемент)

	ЭтаФорма.ФорматЦветТекстаПоУмолчанию = Ложь;
	ЭтаФорма.Пример = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ФорматЦветТекстаОчистка(Элемент, СтандартнаяОбработка)

	ЭтаФорма.ФорматЦветТекстаПоУмолчанию = Истина;
	ЭтаФорма.ФорматЦветТекста            = Новый Цвет;
	ЭтаФорма.Пример                      = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтаФорма);
	СтандартнаяОбработка = Ложь; // Чтобы не срабатывало "ПриИзменении".

КонецПроцедуры

&НаКлиенте
Процедура ФорматЦветФонаПриИзменении(Элемент)

	ЭтаФорма.ФорматЦветФонаПоУмолчанию = Ложь;
	ЭтаФорма.Пример = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ФорматЦветФонаОчистка(Элемент, СтандартнаяОбработка)

	ЭтаФорма.ФорматЦветФонаПоУмолчанию = Истина;
	ЭтаФорма.ФорматЦветФона            = Новый Цвет;
	ЭтаФорма.Пример                    = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтаФорма);
	СтандартнаяОбработка = Ложь; // Чтобы не срабатывало "ПриИзменении".

КонецПроцедуры

&НаКлиенте
Процедура ФорматВсплывающаяПодсказкаПриИзменении(Элемент)

	ЭтаФорма.Пример = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ФорматВсплывающаяПодсказкаОчистка(Элемент, СтандартнаяОбработка)

	ЭтаФорма.Пример = ПолучитьПредставлениеАтрибутов();
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)

	Если ПроверитьЗаполнение() Тогда
		ТегНачала = "<" + ЭтаФорма.Тег + " " + ЭтаФорма.ТекстАтрибутов + ">";
		ТегНачала = СтрЗаменить(ТегНачала, "  ", " ");
		Результат =
			Новый Структура("ТегНачала, ТегОкончания",
				ТегНачала,
				"</" + ЭтаФорма.Тег + ">");
		ЭтаФорма.Закрыть(Результат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Функция возвращает строковое представление всех установленных атрибутов форматирования:
// <тег
//  title="ВсплывающаяПодсказка"
//  style="
//    text-align: center | justify | left | right; // Только для div и p
//    color: #000000 | rgb(,,) | цвет_текстом;
//    background-color: #000000 | rgb(,,) | цвет_текстом | transparent; "
// ></тег>.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//   Строка - строковое представление открывающего тега со всеми установленными атрибутами.
//
Функция ПолучитьПредставлениеАтрибутов()

	Результат = "";
	РезультатСтиля = "";

	Если НЕ ПустаяСтрока(ЭтаФорма.ФорматВсплывающаяПодсказка) Тогда
		Результат = Результат + " title=""" + ЭтаФорма.ФорматВсплывающаяПодсказка + """ ";
	КонецЕсли;
	Если ЭтаФорма.ФорматВыравниваниеАбзацаПоУмолчанию <> Истина Тогда
		Если ЭтаФорма.ФорматВыравниваниеАбзаца = 1 Тогда // Влево
			РезультатСтиля = РезультатСтиля + "text-align: left; ";
		ИначеЕсли ЭтаФорма.ФорматВыравниваниеАбзаца = 2 Тогда // Вправо
			РезультатСтиля = РезультатСтиля + "text-align: right; ";
		ИначеЕсли ЭтаФорма.ФорматВыравниваниеАбзаца = 3 Тогда // По центру
			РезультатСтиля = РезультатСтиля + "text-align: center; ";
		ИначеЕсли ЭтаФорма.ФорматВыравниваниеАбзаца = 4 Тогда // По ширине
			РезультатСтиля = РезультатСтиля + "text-align: justify; ";
		КонецЕсли;
	КонецЕсли;
	Если ЭтаФорма.ФорматЦветТекстаПоУмолчанию <> Истина Тогда
		РезультатСтиля = РезультатСтиля
			+ "color: rgb("
				+ ЭтаФорма.ФорматЦветТекста.Красный + ","
				+ ЭтаФорма.ФорматЦветТекста.Зеленый + ","
				+ ЭтаФорма.ФорматЦветТекста.Синий
			+ "); ";
	КонецЕсли;
	Если ЭтаФорма.ФорматЦветФонаПоУмолчанию <> Истина Тогда
		РезультатСтиля = РезультатСтиля
			+ "background-color: rgb("
				+ ЭтаФорма.ФорматЦветФона.Красный + ","
				+ ЭтаФорма.ФорматЦветФона.Зеленый + ","
				+ ЭтаФорма.ФорматЦветФона.Синий
			+ "); ";
	КонецЕсли;

	Если НЕ ПустаяСтрока(РезультатСтиля) Тогда
		Результат = Результат + " style=""" + РезультатСтиля + """ ";
	КонецЕсли;

	Результат = СтрЗаменить(Результат, ";", "; ");
	Результат = СтрЗаменить(Результат, ":", ": ");
	Результат = СтрЗаменить(Результат, "  ", " ");
	ЭтаФорма.ТекстАтрибутов = Результат;

	Результат = "<" + НРег(ЭтаФорма.Тег) + Результат + ">" + ЭтаФорма.ВыделенныйТекст + "</" + НРег(ЭтаФорма.Тег) + ">";

	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
// Процедура управляет видимостью и доступностью элементов управления на форме.
//
// Параметры:
//  лкФорма - эта форма.
//
Процедура УправлениеФормой(лкФорма)

	лкЭлементы = лкФорма.Элементы;

	Если лкФорма.ФорматЦветТекстаПоУмолчанию = Истина Тогда
		лкЭлементы.ДекорацияПримерОформленияЦветом.ЦветТекста = Новый Цвет();
	Иначе
		лкЭлементы.ДекорацияПримерОформленияЦветом.ЦветТекста = лкФорма.ФорматЦветТекста;
	КонецЕсли;

	Если лкФорма.ФорматЦветФонаПоУмолчанию = Истина Тогда
		лкЭлементы.ДекорацияПримерОформленияЦветом.ЦветФона = Новый Цвет();
	Иначе
		лкЭлементы.ДекорацияПримерОформленияЦветом.ЦветФона = лкФорма.ФорматЦветФона;
	КонецЕсли;

	лкЭлементы.ДекорацияПримерОформленияЦветом.Подсказка = лкФорма.ФорматВсплывающаяПодсказка;

	лкЭлементы.КомандаВыравниваниеАбзацаВлево.Пометка    = Ложь;
	лкЭлементы.КомандаВыравниваниеАбзацаВправо.Пометка   = Ложь;
	лкЭлементы.КомандаВыравниваниеАбзацаПоЦентру.Пометка = Ложь;
	лкЭлементы.КомандаВыравниваниеАбзацаПоШирине.Пометка = Ложь;
	Если лкФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь Тогда
		Если лкФорма.ФорматВыравниваниеАбзаца = 1 Тогда
			лкЭлементы.КомандаВыравниваниеАбзацаВлево.Пометка    = Истина;
		ИначеЕсли лкФорма.ФорматВыравниваниеАбзаца = 2 Тогда
			лкЭлементы.КомандаВыравниваниеАбзацаВправо.Пометка   = Истина;
		ИначеЕсли лкФорма.ФорматВыравниваниеАбзаца = 3 Тогда
			лкЭлементы.КомандаВыравниваниеАбзацаПоЦентру.Пометка = Истина;
		ИначеЕсли лкФорма.ФорматВыравниваниеАбзаца = 4 Тогда
			лкЭлементы.КомандаВыравниваниеАбзацаПоШирине.Пометка = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
// Парсит текстовую строку вида:
//<тег
//  title="ВсплывающаяПодсказка"
//  style="
//    text-align: center | justify | left | right; // Только для div и p
//    color: #000000 | rgb(,,) | цветтекстом;
//    background-color: #000000 | rgb(,,) | цветтекстом | transparent; "
//></тег>
// и преобразует все параметры из текста в значения реквизитов формы.
//
// Параметры:
//  Атрибуты - текстовое представление атрибутов.
//
Процедура РаспарситьАтрибуты(Знач Атрибуты)

	ЭтаФорма.ФорматВсплывающаяПодсказка          = ""; // title=""
	ЭтаФорма.ФорматВыравниваниеАбзаца            = 0; // style="text-align:...;"
	ЭтаФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Истина;
	ЭтаФорма.ФорматЦветТекста                    = Новый Цвет; // style="color:...;"
	ЭтаФорма.ФорматЦветТекстаПоУмолчанию         = Истина;
	ЭтаФорма.ФорматЦветФона                      = Новый Цвет; // style="background-color:...;"
	ЭтаФорма.ФорматЦветФонаПоУмолчанию           = Истина;

	// Найти title, все что после = и между кавычками - это значение.
	ГдеПодсказка = Найти(ВРег(Атрибуты), ВРег("title"));
	Если ГдеПодсказка > 0 Тогда
		// Последовательно найти =, открывающую ", закрывающую ".
		ГдеРавно = Найти(Прав(Атрибуты, СтрДлина(Атрибуты) - ГдеПодсказка - 5 + 1), "=");
		Если ГдеРавно > 0 Тогда
			ГдеОткрывающаяКавычка = Найти(Сред(Атрибуты, ГдеРавно + 1, СтрДлина(Атрибуты) - ГдеРавно), """");
			Если ГдеОткрывающаяКавычка > 0 Тогда
				ГдеЗакрывающаяКавычка = Найти(Сред(Атрибуты, ГдеОткрывающаяКавычка + 1, СтрДлина(Атрибуты) - ГдеОткрывающаяКавычка), """");
				Если ГдеЗакрывающаяКавычка > 0 Тогда
					ЭтаФорма.ФорматВсплывающаяПодсказка = Сред(Атрибуты, ГдеОткрывающаяКавычка + 1, ГдеЗакрывающаяКавычка - ГдеОткрывающаяКавычка - 1);
					// Преобразовать атрибуты - убрать из них уже вычисленный title.
					НовыеАтрибуты = "";
					Для С=1 По СтрДлина(Атрибуты) Цикл
						Если С<ГдеПодсказка ИЛИ С>ГдеЗакрывающаяКавычка Тогда
							НовыеАтрибуты = НовыеАтрибуты + Сред(Атрибуты, С, 1);
						КонецЕсли;
					КонецЦикла;
					Атрибуты = НовыеАтрибуты;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// Найти style, все что после = и между кавычками, надо разделить символом ";" - это будет пара ключ:значение.
	ГдеСтиль = Найти(ВРег(Атрибуты), ВРег("style"));
	Если ГдеСтиль > 0 Тогда
		// Последовательно найти =, открывающую ", закрывающую ".
		ГдеРавно = Найти(Прав(Атрибуты, СтрДлина(Атрибуты) - ГдеСтиль - 5 + 1), "=");
		Если ГдеРавно > 0 Тогда
			ГдеОткрывающаяКавычка = Найти(Сред(Атрибуты, ГдеРавно + 1, СтрДлина(Атрибуты) - ГдеРавно), """");
			Если ГдеОткрывающаяКавычка > 0 Тогда
				ГдеЗакрывающаяКавычка = Найти(Сред(Атрибуты, ГдеОткрывающаяКавычка + 1, СтрДлина(Атрибуты) - ГдеОткрывающаяКавычка), """");
				Если ГдеЗакрывающаяКавычка > 0 Тогда
					// Нашли стиль. Все элементы стиля представляют собой ключ:значение и разделены между собой символом ";", например
					// <p style="color: red; text-align: right; ">Текст параграфа</p>.
					ВсеЭлементыСтиля = Сред(Атрибуты, ГдеОткрывающаяКавычка + 1, ГдеЗакрывающаяКавычка - ГдеОткрывающаяКавычка - 1);
					ВсеЭлементыСтиля = СтрЗаменить(ВсеЭлементыСтиля, ";", Символы.ПС);
					Для С1=1 По СтрЧислоСтрок(ВсеЭлементыСтиля) Цикл
						ЭлементСтиля = СтрПолучитьСтроку(ВсеЭлементыСтиля, С1);
						ГдеДвоеточие = Найти(ЭлементСтиля, ":");
						Если ГдеДвоеточие > 0 Тогда
							КлючСтиля = СокрЛП(СтрЗаменить(Лев(ЭлементСтиля, ГдеДвоеточие - 1), " ", ""));
							ЗначениеСтиля = СокрЛП(СтрЗаменить(Прав(ЭлементСтиля, СтрДлина(ЭлементСтиля) - ГдеДвоеточие), " ", ""));
							Если ВРег(КлючСтиля) = ВРег("color") Тогда
								// значение типа rgb(,,) - удалить "rgb(" и ")", а остальное разделить по запятым.
								ЗначениеСтиля = СтрЗаменить(ВРег(ЗначениеСтиля), ВРег("rgb("), "");
								ЗначениеСтиля = СтрЗаменить(ЗначениеСтиля, ")", "");
								ЗначениеСтиля = СтрЗаменить(ЗначениеСтиля, ",", Символы.ПС);
								Если СтрЧислоСтрок(ЗначениеСтиля) >= 3 Тогда
									ЭтаФорма.ФорматЦветТекста = Новый Цвет(
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 1)),
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 2)),
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 3)));
									ЭтаФорма.ФорматЦветТекстаПоУмолчанию = Ложь;
								КонецЕсли;
							ИначеЕсли ВРег(КлючСтиля) = ВРег("background-color") Тогда
								// значение типа rgb(,,) - удалить "rgb(" и ")", а остальное разделить по запятым.
								ЗначениеСтиля = СтрЗаменить(ВРег(ЗначениеСтиля), ВРег("rgb("), "");
								ЗначениеСтиля = СтрЗаменить(ЗначениеСтиля, ")", "");
								ЗначениеСтиля = СтрЗаменить(ЗначениеСтиля, ",", Символы.ПС);
								Если СтрЧислоСтрок(ЗначениеСтиля) >= 3 Тогда
									ЭтаФорма.ФорматЦветФона = Новый Цвет(
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 1)),
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 2)),
										Число(СтрПолучитьСтроку(ЗначениеСтиля, 3)));
									ЭтаФорма.ФорматЦветФонаПоУмолчанию = Ложь;
								КонецЕсли;
							ИначеЕсли ВРег(КлючСтиля) = ВРег("text-align") Тогда
								Если ВРег(ЗначениеСтиля) = ВРег("left") Тогда
									ЭтаФорма.ФорматВыравниваниеАбзаца = 1;
									ЭтаФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
								ИначеЕсли ВРег(ЗначениеСтиля) = ВРег("right") Тогда
									ЭтаФорма.ФорматВыравниваниеАбзаца = 2;
									ЭтаФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
								ИначеЕсли ВРег(ЗначениеСтиля) = ВРег("center") Тогда
									ЭтаФорма.ФорматВыравниваниеАбзаца = 3;
									ЭтаФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
								ИначеЕсли ВРег(ЗначениеСтиля) = ВРег("justify") Тогда
									ЭтаФорма.ФорматВыравниваниеАбзаца = 4;
									ЭтаФорма.ФорматВыравниваниеАбзацаПоУмолчанию = Ложь;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

