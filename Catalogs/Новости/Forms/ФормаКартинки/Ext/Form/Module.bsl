﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЭтаФорма.ТекущаяКартинка = 0;
	МаксимальныйПорядокСортировки = 0;

	Если Параметры.СписокУИН.Количество() > 0 Тогда
		// Данные типа ХранилищеЗначений не отображается на клиенте, к ним можно обратиться только получив Объект через РеквизитФормыВЗначение.
		ОбъектДляПолученияДанных = РеквизитФормыВЗначение("Объект");

		// Могут передать несколько УИН, для каждого УИН в базе может быть несколько картинок.
		// Вывести их все с возможностью переключения между ними.
		лкСписокУИН = Параметры.СписокУИН;
		Для каждого ТекущиеБинарныеДанные Из ОбъектДляПолученияДанных.БинарныеДанные Цикл
			Если лкСписокУИН.НайтиПоЗначению(ТекущиеБинарныеДанные.УИН) <> Неопределено Тогда
				ДвоичныеДанныеДляКартинки = ТекущиеБинарныеДанные.Данные.Получить();
				Если ТипЗнч(ДвоичныеДанныеДляКартинки) = Тип("ДвоичныеДанные") Тогда
					// Двоичные данные можно отобразить?
					КартинкаДляОтображения = Новый Картинка(ДвоичныеДанныеДляКартинки, Истина);
					Если КартинкаДляОтображения.Вид <> ВидКартинки.Пустая Тогда
						НоваяСтрока = ЭтаФорма.Картинки.Добавить();
						НоваяСтрока.Заголовок         = ТекущиеБинарныеДанные.Заголовок;
						НоваяСтрока.ДанныеКартинки    = КартинкаДляОтображения;
						НоваяСтрока.ПорядокСортировки = ТекущиеБинарныеДанные.ПорядокСортировки;
						Если МаксимальныйПорядокСортировки < НоваяСтрока.ПорядокСортировки Тогда
							МаксимальныйПорядокСортировки = НоваяСтрока.ПорядокСортировки;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	// Также могут передать список картинок, как правило это возможно из переопределяемого модуля,
	//  при формировании списка параметров (ОбработкаНовостейПереопределяемый.ДополнительноПодготовитьПараметрыНавигационнойСсылки).
	МаксимальныйПорядокСортировки = МаксимальныйПорядокСортировки + 1;
	лкСписокКартинок = Параметры.СписокКартинок;
	Для Каждого ТекущийЭлементСписка Из лкСписокКартинок Цикл
		Если ТекущийЭлементСписка.Картинка.Вид <> ВидКартинки.Пустая Тогда
			НоваяСтрока = ЭтаФорма.Картинки.Добавить();
			НоваяСтрока.Заголовок         = ?(ПустаяСтрока(ТекущийЭлементСписка.Представление), ТекущийЭлементСписка.Значение, ТекущийЭлементСписка.Представление);
			НоваяСтрока.ДанныеКартинки    = ТекущийЭлементСписка.Картинка;
			НоваяСтрока.ПорядокСортировки = МаксимальныйПорядокСортировки;
			МаксимальныйПорядокСортировки = МаксимальныйПорядокСортировки + 1;
		КонецЕсли;
	КонецЦикла;

	Если ЭтаФорма.Картинки.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли ЭтаФорма.Картинки.Количество() = 1 Тогда
		Элементы.ГруппаКомандыПерехода.Видимость = Ложь;
	Иначе
		// Несколько картинок.
		ЭтаФорма.Картинки.Сортировать("ПорядокСортировки");
	КонецЕсли;

	ОтобразитьКартинку(0);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаНазад(Команда)

	Если ЭтаФорма.ТекущаяКартинка > 0 Тогда
		ОтобразитьКартинку(ЭтаФорма.ТекущаяКартинка - 1);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаДалее(Команда)

	Если ЭтаФорма.ТекущаяКартинка <= (ЭтаФорма.Картинки.Количество()-1) Тогда
		ОтобразитьКартинку(ЭтаФорма.ТекущаяКартинка + 1);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура отображает текущую картинку.
//
// Параметры:
//  НомерКартинки - Число.
//
Процедура ОтобразитьКартинку(Знач НомерКартинки)

	Если НомерКартинки <= (ЭтаФорма.Картинки.Количество()-1) Тогда
		ЭтаФорма.ТекущаяКартинка = НомерКартинки;
		ЭтаФорма.ДанныеДляТекущейКартинки = ПоместитьВоВременноеХранилище(ЭтаФорма.Картинки[НомерКартинки].ДанныеКартинки.ПолучитьДвоичныеДанные(), ЭтаФорма.УникальныйИдентификатор);
		ЭтаФорма.Заголовок = ЭтаФорма.Картинки[НомерКартинки].Заголовок;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
