﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Управляет регламентным заданием узла обмена.  Расписание задания задается в форме узла обмена.
// Предусматривает работу через подсистему "СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий".
//
// Параметры:
//  РасписаниеРегламентногоЗадания - РасписаниеРегламентногоЗадания - расписание регламентного задания.
//
Процедура ВключитьОтключитьРегламентноеЗадание(РасписаниеРегламентногоЗадания) Экспорт
	
	
	Задание = СуществующееЗадание();
	Если ИспользоватьРегламентноеЗадание Тогда
		
		ПараметрыЗадания = СвойстваЗадания(РасписаниеРегламентногоЗадания);
		
		Если Задание = Неопределено Тогда
			
			ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ОбменССайтом);
			ПараметрыЗадания.Вставить("Ключ", Строка(Новый УникальныйИдентификатор));
			ПараметрыЗадания.Вставить("Использование", Истина);
			
			ИдентификаторЗадания = НовоеЗадание(ПараметрыЗадания);
			ИдентификаторРегламентногоЗадания = ИдентификаторЗадания;
		Иначе
			УстановитьПараметрыЗадания(Задание, ПараметрыЗадания);
		КонецЕсли;
		
	Иначе
		
		Если Задание <> Неопределено Тогда
			УдалитьЗадание(Задание);
		КонецЕсли;
		ИдентификаторРегламентногоЗадания = Неопределено;
		
	КонецЕсли;

КонецПроцедуры

// Получение свойств регламентного задания.
//
// Параметры:
//  РасписаниеЗадания - РасписаниеРегламентногоЗадания - расписание регламентного задания.
// 
// Возвращаемое значение:
//  Структура - свойства существующего регламентного задания.
//
Функция СвойстваЗадания(РасписаниеЗадания = Неопределено) Экспорт
	
	Параметры = Новый Массив;
	Параметры.Добавить(Код);
	
	ПараметрыЗадания = Новый Структура;
	Если Не РасписаниеЗадания = Неопределено Тогда
		ПараметрыЗадания.Вставить("Расписание", РасписаниеЗадания);
	КонецЕсли;
	ПараметрыЗадания.Вставить("Параметры", Параметры);
	ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.ОбменССайтом.ИмяМетода);
	ПараметрыЗадания.Вставить("Наименование", НаименованиеРегламентногоЗадания());

	Возврат ПараметрыЗадания;
	
КонецФункции

// Функция - Существующее задание
// 
// Возвращаемое значение:
//   РегламентноеЗадание - регламентное задание - регламентное задание, соответствующее узлу плана обмена.
//							Если задания нет - возвращается "Неопределено".
//
Функция СуществующееЗадание() Экспорт
	
	Отбор = Новый Структура;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Отбор.Вставить("Ключ", ИдентификаторРегламентногоЗадания);
	Иначе
		Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
			Отбор.Вставить("Идентификатор", Новый УникальныйИдентификатор(ИдентификаторРегламентногоЗадания));
		КонецЕсли;
		Отбор.Вставить("Наименование", НаименованиеРегламентногоЗадания());
		
	КонецЕсли;

	Отбор.Вставить("Метаданные", Метаданные.РегламентныеЗадания.ОбменССайтом);
	
	Найденные = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	Задание = ?(Найденные.Количество() = 0, Неопределено, Найденные[0]);
	
	Возврат Задание;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	Код = "";
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПустаяСтрока(Код) Тогда
		УстановитьНовыйКод();
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) Тогда
		СформироватьНаименование()
	КонецЕсли;
	
	Если НЕ ОбменТоварами
		И НЕ ОбменЗаказами Тогда
		
		Отказ = Истина;
		Сообщение = НСтр("ru = 'Режим обмена не выбран.'");
		Поле = "ОбменТоварами";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, ЭтотОбъект, Поле);
		
	КонецЕсли;

	СкорректироватьПроверяемыеРеквизиты(ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Функция НаименованиеРегламентногоЗадания()
	
	НаименованиеШаблон = НСтр("ru = 'Обмен с сайтом № %1'");
	НаименованиеЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НаименованиеШаблон, Код);
	
	Возврат НаименованиеЗадания;
	
КонецФункции


// Формирует уникальное наименование объекта
//
// Параметры:
// нет
// 
// Возвращаемое значение:
// нет
//
Процедура СформироватьНаименование()
	
	Если ОбменТоварами И ОбменЗаказами Тогда
		
		Префикс = НСтр("ru = 'Обмен товарами и заказами'");
		
	ИначеЕсли ОбменЗаказами Тогда
		
		Префикс = НСтр("ru = 'Обмен заказами'");
		
	Иначе
		
		Префикс = НСтр("ru = 'Выгрузка товаров'");
		
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	МАКСИМУМ(ОбменССайтом.Наименование) КАК Наименование
	               |ИЗ
	               |	ПланОбмена.ОбменССайтом КАК ОбменССайтом
	               |ГДЕ
	               |	ОбменССайтом.Наименование ПОДОБНО &Шаблон
	               |
	               |ИМЕЮЩИЕ
	               |	НЕ МАКСИМУМ(ОбменССайтом.Наименование) ЕСТЬ NULL ";

	
	Запрос.УстановитьПараметр("Шаблон", Префикс + "%");
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Наименование = Префикс;
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Суффикс = Прав(СокрЛП(Выборка.Наименование), 4);
	
	Попытка
		СуффиксЧислом = Число(Суффикс);
	Исключение
		Наименование = Префикс + " 0001";
		Возврат;
	КонецПопытки;
		
	Наименование = Префикс + " " + Формат(СуффиксЧислом + 1, "ЧЦ=4; ЧВН=; ЧГ=");
	
КонецПроцедуры

Процедура СкорректироватьПроверяемыеРеквизиты(ПроверяемыеРеквизиты)
	
	// В зависимости от настроек формы из проверяемых реквизитов удаляем непроверяемые реквизиты.
	
	НеПроверяемыеРеквизиты = Новый Массив;
	
	Если ВыгружатьНаСайт Тогда
		
		НеПроверяемыеРеквизиты.Добавить("КаталогВыгрузки");
		НеПроверяемыеРеквизиты.Добавить("ФайлЗагрузки");
		
	Иначе
		
		НеПроверяемыеРеквизиты.Добавить("АдресСайта");
		НеПроверяемыеРеквизиты.Добавить("ИмяПользователя");
		
		Если Не ОбменТоварами Тогда
			НеПроверяемыеРеквизиты.Добавить("КаталогВыгрузки");
		КонецЕсли;
		
		
	КонецЕсли;
	
	Если Не ОбменЗаказами Тогда
		НеПроверяемыеРеквизиты.Добавить("ФайлЗагрузки");
	КонецЕсли;
	
	Если Не ОбменТоварами Тогда
		
		НеПроверяемыеРеквизиты.Добавить("ВладелецКаталога");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НеПроверяемыеРеквизиты);
	
КонецПроцедуры

// Удаляет регламентное задание, соответствующее объекту.
//
// Параметры:
// нет
// 
// Возвращаемое значение:
// нет
//
Процедура УдалитьЗадание(Задание)
	
	РегламентныеЗаданияСервер.УдалитьЗадание(Задание);
	
КонецПроцедуры

Функция НовоеЗадание(ПараметрыЗадания)
	
	РегламентноеЗадание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	
	Если ТипЗнч(РегламентноеЗадание) = Тип("СтрокаТаблицыЗначений") Тогда
		Идентификатор = РегламентноеЗадание.Ключ;
	Иначе
		Идентификатор = Строка(РегламентноеЗадание.УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Идентификатор;
	
КонецФункции

Процедура УстановитьПараметрыЗадания(Задание, СвойстваЗадания)
	
	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, СвойстваЗадания);
	
	УстановитьПривилегированныйРежим(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
