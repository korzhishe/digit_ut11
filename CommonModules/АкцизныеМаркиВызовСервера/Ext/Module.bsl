﻿
#Область СлужебныеПроцедурыИФункции

// Функция - Код классификатора номенклатуры ЕГАИС
//
// Параметры:
//  ШтрихкодАкцизнойМарки - Строка - Штрихкод акцизной марки
// 
// Возвращаемое значение:
//  Строка - строка с кодом номенклатуры по классификатору егаис
//
Функция КодКлассификатораНоменклатурыЕГАИС(ШтрихкодАкцизнойМарки) Экспорт
	
	Если Сред(ШтрихкодАкцизнойМарки, 4, 5) = "00000" Тогда
		
		Значение = Сред(ШтрихкодАкцизнойМарки, 9, 11);
		КоличествоИтераций = 11;
		
	Иначе
		
		Значение = Сред(ШтрихкодАкцизнойМарки, 8, 12);
		КоличествоИтераций = 12;
		
	КонецЕсли;
	
	Результат = 0;
	
	Для Итерация = 1 По КоличествоИтераций Цикл
		
		Сумматор = 1;
		Для Индекс = 1 По КоличествоИтераций - Итерация Цикл
			Сумматор = Сумматор * 36;
		КонецЦикла;
		
		Результат = Результат + Сумматор * (Найти("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", Сред(Значение, Итерация, 1)) - 1);
		
	КонецЦикла;
	
	Возврат Формат(Результат, "ЧЦ=19; ЧВН=; ЧГ=0");
	
КонецФункции

// Проверяет штрихкод акцизной марки
//
// Параметры:
//  Штрихкод - Строка - проверяемый штрихкод.
// 
// Возвращаемое значение:
//   Булево - признак штрихкод является акцизной маркой.
//
Функция ЭтоШтрихкодАкцизнойМарки(Штрихкод) Экспорт
	
	ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЧекККМ;
	ТипШтрихкодМарки = ФабрикаXDTO.Тип(
		Перечисления.ВидыДокументовЕГАИС.ПространствоИмен(
			ВидДокумента, Перечисления.ФорматыОбменаЕГАИС.ПустаяСсылка()), "BK");
	
	Попытка
		ТипШтрихкодМарки.Проверить(Штрихкод);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Проверяет, что считанный ШК является акцизной маркой в формате PDF417 и находит сопоставленную номенклатуру.
//
Функция ОбработатьШтрихкодАкцизнойМарки(Штрихкод, ПараметрыКонтроляАкцизныхМарок) Экспорт
	
	Результат = АкцизныеМаркиКлиентСервер.РезультатОбработкиШтрихкодаАкцизнойМарки(Штрихкод);
	
	Если НЕ ЭтоШтрихкодАкцизнойМарки(Штрихкод) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.Обработан = Истина;
	
	ЗаполнитьСопоставленнуюНоменклатуруПоАкцизнойМарке(Штрихкод, Результат);
	
	Если ПараметрыКонтроляАкцизныхМарок.КонтрольАкцизныхМарок Тогда
		Если НЕ ПроверитьУникальностьАкцизнойМарки(ПараметрыКонтроляАкцизныхМарок.Операция, Штрихкод, Результат.ТекстОшибкиКонтроляАкцизныхМарок) Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет, что считанный ШК является акцизной маркой в формате Data Matrix и находит по диапазону справки 2.
//
Функция ОбработатьШтрихкодDataMatrix(Штрихкод) Экспорт
	
	Результат = АкцизныеМаркиКлиентСервер.РезультатОбработкиШтрихкодаDataMatrix(Штрихкод);
	Результат.Обработан = Истина;
	
	СтруктураШтрихкода = АкцизныеМаркиКлиентСервер.РазложитьШтрихкодDataMatrix(Штрихкод, Результат.ТекстОшибки);
	
	Если НЕ ПустаяСтрока(Результат.ТекстОшибки) Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Результат, СтруктураШтрихкода);
	
	Результат.Справки2 = Справки2ПоШтрихкодуDataMatrix(СтруктураШтрихкода);
	
	Возврат Результат;
	
КонецФункции

// Возвращает Истина, если акцизная марка никогда раньше не продавалась. Ложь - в противном случае.
//
Функция ПроверитьУникальностьАкцизнойМарки(Операция, КодАкцизнойМарки, ТекстОшибки) Экспорт
	
	Возврат АкцизныеМаркиЕГАИСПереопределяемый.ПроверитьУникальностьАкцизнойМарки(Операция, КодАкцизнойМарки, ТекстОшибки);
	
КонецФункции

// Получает тип акцизной марки из классификатора.
//
Функция ТипАкцизнойМарки(Код) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Код"         , "");
	Результат.Вставить("Наименование", "");
	Результат.Вставить("ВидМарки"    , "");
	
	ТаблицаКлассификатора = АкцизныеМаркиЕГАИС.КлассификаторТиповАкцизныхМарок();
	
	СтрокаТаблицы = ТаблицаКлассификатора.Найти(Код, "Код");
	Если СтрокаТаблицы <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, СтрокаТаблицы);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает список найденных типов марок по введенному коду.
//
Функция ДанныеВыбораТипаМарки(Код) Экспорт
	
	Результат = Новый СписокЗначений;
	
	ТаблицаКлассификатора = АкцизныеМаркиЕГАИС.КлассификаторТиповАкцизныхМарок();
	
	Для Каждого СтрокаТаблицы Из ТаблицаКлассификатора Цикл
		
		Если СтрНайти(СтрокаТаблицы.Код, СокрЛП(Код)) <> 0 Тогда
			Результат.Добавить(СтрокаТаблицы.Код, СтрокаТаблицы.ВидМарки + " " + СтрокаТаблицы.Наименование + " (" + СтрокаТаблицы.Код + ")");
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает справки 2, найденные по считанному штрихкоду формата Data Matrix.
//
Функция Справки2ПоШтрихкодуDataMatrix(СтруктураШтрихкода)
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТипМарки", СтруктураШтрихкода.ТипМарки);
	Запрос.УстановитьПараметр("СерияМарки", СтруктураШтрихкода.СерияМарки);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.Ссылка КАК Ссылка,
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.НачальныйНомер КАК НачальныйНомер,
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.КонечныйНомер КАК КонечныйНомер,
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.Ссылка.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.Ссылка.Справка1.НомерТТН КАК НомерТТН,
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.Ссылка.Справка1.ДатаТТН КАК ДатаТТН,
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.Ссылка.Справка1.ДатаРозлива КАК ДатаРозлива,
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.Ссылка.Справка1.Количество КАК КоличествоПоСправке1,
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.Ссылка.Справка1.НомерПодтвержденияЕГАИС КАК НомерПодтвержденияЕГАИС,
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.Ссылка.Справка1.ДатаПодтвержденияЕГАИС КАК ДатаПодтвержденияЕГАИС
	|ИЗ
	|	Справочник.Справки2ЕГАИС.ДиапазоныНомеровАкцизныхМарок КАК Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок
	|ГДЕ
	|	Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.ТипМарки = &ТипМарки
	|	И Справки2ЕГАИСДиапазоныНомеровАкцизныхМарок.СерияМарки = &СерияМарки";
	
	НомерМарки = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтруктураШтрихкода.НомерМарки);
	
	ТаблицаСопоставления = Новый ТаблицаЗначений;
	ТаблицаСопоставления.Колонки.Добавить("АлкогольнаяПродукция", Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачальныйНомер = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Выборка.НачальныйНомер);
		КонечныйНомер = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Выборка.КонечныйНомер);
		
		Если НомерМарки >= НачальныйНомер И НомерМарки <= КонечныйНомер Тогда
			Если Результат.Найти(Выборка.Ссылка) = Неопределено Тогда
				ДанныеСправки2 = Новый Структура;
				ДанныеСправки2.Вставить("Справка2"               , Выборка.Ссылка);
				ДанныеСправки2.Вставить("АлкогольнаяПродукция"   , Выборка.АлкогольнаяПродукция);
				ДанныеСправки2.Вставить("НомерТТН"               , Выборка.НомерТТН);
				ДанныеСправки2.Вставить("ДатаТТН"                , Выборка.ДатаТТН);
				ДанныеСправки2.Вставить("ДатаРозлива"            , Выборка.ДатаРозлива);
				ДанныеСправки2.Вставить("КоличествоПоСправке1"   , Выборка.КоличествоПоСправке1);
				ДанныеСправки2.Вставить("НомерПодтвержденияЕГАИС", Выборка.НомерПодтвержденияЕГАИС);
				ДанныеСправки2.Вставить("ДатаПодтвержденияЕГАИС" , Выборка.ДатаПодтвержденияЕГАИС);
				ДанныеСправки2.Вставить("Номенклатура");
				ДанныеСправки2.Вставить("Характеристика");
				ДанныеСправки2.Вставить("Упаковка");
				
				СтрокаТаблицы = ТаблицаСопоставления.Найти(Выборка.АлкогольнаяПродукция, "АлкогольнаяПродукция");
				Если СтрокаТаблицы = Неопределено Тогда
					СтрокаТаблицы = ТаблицаСопоставления.Добавить();
					СтрокаТаблицы.АлкогольнаяПродукция = Выборка.АлкогольнаяПродукция;
				КонецЕсли;
				
				Результат.Добавить(ДанныеСправки2);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ИнтеграцияЕГАИС.ЗаполнитьСопоставленнуюПродукцию(ТаблицаСопоставления);
	
	Для Каждого ДанныеСправки2 Из Результат Цикл
		СтрокаТаблицы = ТаблицаСопоставления.Найти(ДанныеСправки2.АлкогольнаяПродукция, "АлкогольнаяПродукция");
		Если СтрокаТаблицы <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ДанныеСправки2, СтрокаТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Заполняет сопоставленную номенклатуру и данные классификатора по считанной акцизной марке.
//
Процедура ЗаполнитьСопоставленнуюНоменклатуруПоАкцизнойМарке(Штрихкод, ДанныеЗаполнения)
	
	КодФСРАР = КодКлассификатораНоменклатурыЕГАИС(Штрихкод);
	
	ДанныеЗаполнения.КодАлкогольнойПродукции = КодФСРАР;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|ГДЕ
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Код = &КодФСРАР");
	
	Запрос.УстановитьПараметр("КодФСРАР", КодФСРАР);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ТаблицаСопоставления = Новый ТаблицаЗначений;
		ТаблицаСопоставления.Колонки.Добавить("АлкогольнаяПродукция", Новый ОписаниеТипов("СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС"));
		
		СтрокаТаблицы = ТаблицаСопоставления.Добавить();
		СтрокаТаблицы.АлкогольнаяПродукция = Выборка.Ссылка;
		
		ИнтеграцияЕГАИС.ЗаполнитьСопоставленнуюПродукцию(ТаблицаСопоставления);
		
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, СтрокаТаблицы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти