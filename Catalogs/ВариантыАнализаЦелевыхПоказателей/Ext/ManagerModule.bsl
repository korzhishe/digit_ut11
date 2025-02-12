﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает настройки оформления по умолчанию для вариантов анализа 
//
// Возвращаемое значение:
//	Структура - структура, содержащая настройки оформления
//
Функция НастройкиОформленияПоУмолчанию(ПокомпонентноеСравнение = Ложь) Экспорт
	
	// Сформируем настройки цветов
	ЦветовыеНастройки = Новый Структура;
	
	НаборЦветов = Новый Соответствие;
	НаборЦветов.Вставить("Значение", WebЦвета.СинийСоСтальнымОттенком);
	НаборЦветов.Вставить("Прогноз", WebЦвета.НейтральноФиолетовоКрасный);
	НаборЦветов.Вставить("ЦелевоеЗначение", WebЦвета.ЗеленыйЛес);
	НаборЦветов.Вставить("ПозитивноеОтклонение", WebЦвета.КоролевскиГолубой);
	НаборЦветов.Вставить("НегативноеОтклонение", WebЦвета.Малиновый);
	НаборЦветов.Вставить("ЗонаДопустимыхОтклонений", Новый Цвет(255, 195, 0));
	
	ЦветовыеНастройки.Вставить("Цвета", НаборЦветов);
	
	ХранилищеНастроекОформления = Новый ХранилищеЗначения(ЦветовыеНастройки);
	
	// Сформируем настройки параметров вывода
	СтруктураНастроекОформления  = Новый Структура("ХранилищеНастроекОформления, 
	|ТолькоЦветОсновнойСерии,
	|ГрадиентДляПокомпонентногоСравнения,
	|ВыделятьМаксимальноеЗначениеДляПокомпонентногоСравнения,
	|ВыводитьМаркерТочекПрогноза,
	|ОтображатьЛегенду,
	|ВыводитьПодписиКДиаграммам,
	|ОкантовкаДиаграмм,
	|РежимСглаживанияДиаграмм,
	|РежимШкалыЗначений,
	|ВключатьНоль");
		
	СтруктураНастроекОформления.Вставить("ХранилищеНастроекОформления", ХранилищеНастроекОформления);
	СтруктураНастроекОформления.Вставить("ТолькоЦветОсновнойСерии", Истина);
	СтруктураНастроекОформления.Вставить("ГрадиентДляПокомпонентногоСравнения", Истина);
	СтруктураНастроекОформления.Вставить("ВыделятьМаксимальноеЗначениеДляПокомпонентногоСравнения", Ложь);
	СтруктураНастроекОформления.Вставить("ВыводитьМаркерТочекПрогноза", Ложь);
	СтруктураНастроекОформления.Вставить("ОтображатьЛегенду", Истина);
	СтруктураНастроекОформления.Вставить("ВыводитьПодписиКДиаграммам", Истина);
	СтруктураНастроекОформления.Вставить("ОкантовкаДиаграмм", Ложь);
	СтруктураНастроекОформления.Вставить("РежимСглаживанияДиаграмм", Истина);
	СтруктураНастроекОформления.Вставить("РежимШкалыЗначений", Перечисления.РежимШкалыЗначенийДиаграмм.Авто);
	СтруктураНастроекОформления.Вставить("ВключатьНоль", Истина);
	
	Возврат СтруктураНастроекОформления;
	
КонецФункции

// Помещает во временное хранилище схему компоновки данных,
// настройки компоновки данных и пользовательские настройки и возвращает их адреса
//
// Параметры:
//	ВариантАнализа - Ссылка, СправочникСсылка.ВариантыАнализаЦелевыхПоказателей - вариант анализа, для которого возвращаются адреса
//
// Возвращаемое значение:
//	Структура - структура, содержащая адреса
//
Функция АдресаСхемыКомпоновкиДанныхИПользовательскихНастроек(ВариантАнализа) Экспорт
	
	Адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, ПользовательскиеНастройки");
	
	// Получим схему компоновки данных
	Если ЗначениеЗаполнено(ВариантАнализа.Владелец.СхемаКомпоновкиДанных) ИЛИ ВариантАнализа.Владелец.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СхемаИНастройки = Справочники.СтруктураЦелей.ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(ВариантАнализа.Владелец, ВариантАнализа.Владелец.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = ВариантАнализа.Владелец.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	Адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	
	Настройки = ВариантАнализа.Владелец.ХранилищеНастроекКомпоновкиДанных.Получить();
	
	Если ЗначениеЗаполнено(Настройки) Тогда
		Адреса.НастройкиКомпоновкиДанных = ПоместитьВоВременноеХранилище(Настройки, Новый УникальныйИдентификатор());
	КонецЕсли;
	
	ПользовательскиеНастройки = ВариантАнализа.ХранилищеПользовательскихНастроекКомпоновкиДанных.Получить();
	
	Если ЗначениеЗаполнено(ПользовательскиеНастройки) Тогда
		Адреса.ПользовательскиеНастройки = ПоместитьВоВременноеХранилище(ПользовательскиеНастройки, Новый УникальныйИдентификатор());
	КонецЕсли;
	
	Возврат Адреса;
	
КонецФункции

// Возвращает демонстрационные данные, указанные при варианте анализа
//
// Параметры:
//	ВариантАнализа - Ссылка, СправочникСсылка.ВариантыАнализаЦелевыхПоказателей - вариант анализа, для которого возвращаются адреса
//
// Возвращаемое значение:
//	ТаблицаЗначений - таблица демонстрационных данных варианта анализа
//
Функция ДемонстрационныеДанныеВариантаАнализа(ВариантАнализа) Экспорт 
	ДемонстрационныеДанные = Новый ТаблицаЗначений;
	
	ЗначениеАнализаИмя = Строка(ВариантАнализа.ЗначениеАнализа.Получить());
	ЗначениеАнализаДополнительноеИмя = Строка(ВариантАнализа.ЗначениеАнализаДополнительное.Получить());
	ОбъектАнализаИмя = Строка(ВариантАнализа.ОбъектАнализа.Получить());
	
	ХранилищеДемонстрационныхДанныхЗначение = ВариантАнализа.ХранилищеДемонстрационныхДанных.Получить();
	Если ХранилищеДемонстрационныхДанныхЗначение <> Неопределено Тогда
		ДемонстрационныеДанные = ХранилищеДемонстрационныхДанныхЗначение.Данные.Получить();
		
		ДемонстрационныеДанные.Колонки.ЗначениеПоказателя.Имя = ЗначениеАнализаИмя;
		
		Если ВариантАнализа.ТипАнализа = Перечисления.ТипыАнализаПоказателей.ПокомпонентноеСравнение
			ИЛИ ВариантАнализа.ТипАнализа = Перечисления.ТипыАнализаПоказателей.ПокомпонентноеСравнениеДинамика Тогда
			Если ВариантАнализа.РежимПокомпонентногоСравнения = 0 Тогда
				ДемонстрационныеДанные.Колонки.ОбъектАнализа.Имя = ОбъектАнализаИмя;
			Иначе
				ДемонстрационныеДанные.Колонки.ЗначениеПоказателяДополнительное.Имя = ЗначениеАнализаДополнительноеИмя;
			КонецЕсли;
		КонецЕсли;
		Если ВариантАнализа.ТипАнализа = Перечисления.ТипыАнализаПоказателей.ПокомпонентноеСравнение Тогда
			Если ВариантАнализа.РежимПокомпонентногоСравнения = 0 Тогда
				ПоследняяДата = ДемонстрационныеДанные[0].Период;
				ДемонстрационныеДанные.ЗаполнитьЗначения(Неопределено, "Период");
				
				ИтогПоТаблице = ДемонстрационныеДанные.Итог(ЗначениеАнализаИмя);
				НоваяСтрока = ДемонстрационныеДанные.Добавить();
				НоваяСтрока.Период = ПоследняяДата;
				НоваяСтрока[ЗначениеАнализаИмя] = ИтогПоТаблице;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат ДемонстрационныеДанные;
КонецФункции
#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ОткрытиеСуществующегоОбъекта = Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ);
	СозданиеОбъектаНеИзСписка = Не ОткрытиеСуществующегоОбъекта
			И Не (Параметры.Свойство("ЗначенияЗаполнения") 
				И Параметры.ЗначенияЗаполнения.Свойство("Владелец")
				Или Параметры.Свойство("ЗначениеКопирования"));
	
	Если ВидФормы = "ФормаОбъекта" И СозданиеОбъектаНеИзСписка Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = Метаданные.Справочники.ВариантыАнализаЦелевыхПоказателей.Формы.ФормаПредупреждения;
	КонецЕсли;
КонецПроцедуры
	
#КонецОбласти 

