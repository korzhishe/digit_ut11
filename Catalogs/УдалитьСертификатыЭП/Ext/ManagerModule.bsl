﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Обработчик обновления БЭД 1.1.9.1
// Заполняет дату окончания действия сертификата
//
Процедура ЗаполнитьСрокДействия() Экспорт
	
	Сертификаты = Справочники.УдалитьСертификатыЭП.Выбрать();
	
	Пока Сертификаты.Следующий() Цикл
		
		Попытка
			Сертификат = Сертификаты.ПолучитьОбъект();
			ДанныеСертификата = Сертификат.ФайлСертификата.Получить();
			Если ТипЗнч(ДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
				СертификатКриптографии = Новый СертификатКриптографии(ДанныеСертификата);
				Сертификат.ДатаОкончания = СертификатКриптографии.ДатаОкончания;
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Сертификат);
			КонецЕсли;
		Исключение
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.2.4.4
// Создает новые элементы справочника СертификатыКлючейЭлектроннойПодписиИШифрования
// и заполняет данными существующих из сертификатов.
//
Процедура ПеренестиНастройкиСертификатов() Экспорт
	
	КриптоПрограмма = Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПустаяСсылка();
	ВыборкаКриптоПрограмм = Справочники.ПрограммыЭлектроннойПодписиИШифрования.Выбрать();
	Пока ВыборкаКриптоПрограмм.Следующий() Цикл
		Если ЗначениеЗаполнено(КриптоПрограмма) Тогда
			КриптоПрограмма = Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПустаяСсылка();
		КонецЕсли;
		КриптоПрограмма = ВыборкаКриптоПрограмм.Ссылка;
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СертификатыПодписейОрганизации.Ссылка
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО.СертификатыПодписейОрганизации КАК СертификатыПодписейОрганизации
	|ГДЕ
	|	СертификатыПодписейОрганизации.Сертификат = ЗНАЧЕНИЕ(Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка)
	|	И СертификатыПодписейОрганизации.УдалитьСертификат <> ЗНАЧЕНИЕ(Справочник.УдалитьСертификатыЭП.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПрофильНастроекЭДО = Выборка.Ссылка.ПолучитьОбъект();
		Для Каждого СертификатПодписей Из ПрофильНастроекЭДО.СертификатыПодписейОрганизации Цикл
			Если ЗначениеЗаполнено(СертификатПодписей.УдалитьСертификат)
				И НЕ ЗначениеЗаполнено(СертификатПодписей.Сертификат) Тогда
				
				НовыйСертификат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СертификатПодписей.УдалитьСертификат, "СсылкаНаНовыйСертификат");
				Если ЗначениеЗаполнено(НовыйСертификат) Тогда
					СертификатПодписей.Сертификат = НовыйСертификат;
				Иначе
					СертификатПодписей.Сертификат = ПеренестиЭлементВСертификатыКлючейЭлектроннойПодписиИШифрования(СертификатПодписей.УдалитьСертификат, КриптоПрограмма);
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПрофильНастроекЭДО);
		
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	СоглашенияОбИспользованииЭД.СертификатОрганизацииДляРасшифровки = ЗНАЧЕНИЕ(Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка)
	|	И СоглашенияОбИспользованииЭД.УдалитьСертификатОрганизацииДляРасшифровки <> ЗНАЧЕНИЕ(Справочник.УдалитьСертификатыЭП.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СертификатыПодписейОрганизации.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.СертификатыПодписейОрганизации КАК СертификатыПодписейОрганизации
	|ГДЕ
	|	СертификатыПодписейОрганизации.Сертификат = ЗНАЧЕНИЕ(Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка)
	|	И СертификатыПодписейОрганизации.УдалитьСертификат <> ЗНАЧЕНИЕ(Справочник.УдалитьСертификатыЭП.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Соглашение = Выборка.Ссылка.ПолучитьОбъект();
		
		Если ЗначениеЗаполнено(Соглашение.УдалитьСертификатОрганизацииДляРасшифровки)
			И НЕ ЗначениеЗаполнено(Соглашение.СертификатОрганизацииДляРасшифровки) Тогда
			
			НовыйСертификат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Соглашение.УдалитьСертификатОрганизацииДляРасшифровки, "СсылкаНаНовыйСертификат");
			Если ЗначениеЗаполнено(НовыйСертификат) Тогда
				Соглашение.СертификатОрганизацииДляРасшифровки = НовыйСертификат;
			Иначе
				Соглашение.СертификатОрганизацииДляРасшифровки = ПеренестиЭлементВСертификатыКлючейЭлектроннойПодписиИШифрования(Соглашение.УдалитьСертификатОрганизацииДляРасшифровки, КриптоПрограмма);
			КонецЕсли;
			
		КонецЕсли;
		
		Для Каждого СертификатПодписей Из Соглашение.СертификатыПодписейОрганизации Цикл
			
			Если ЗначениеЗаполнено(СертификатПодписей.УдалитьСертификат)
				И НЕ ЗначениеЗаполнено(СертификатПодписей.Сертификат) Тогда
				
				НовыйСертификат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СертификатПодписей.УдалитьСертификат, "СсылкаНаНовыйСертификат");
				Если ЗначениеЗаполнено(НовыйСертификат) Тогда
					СертификатПодписей.Сертификат = НовыйСертификат;
				Иначе
					СертификатПодписей.Сертификат = ПеренестиЭлементВСертификатыКлючейЭлектроннойПодписиИШифрования(СертификатПодписей.УдалитьСертификат, КриптоПрограмма);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Соглашение);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Функция ПеренестиЭлементВСертификатыКлючейЭлектроннойПодписиИШифрования(СтарыйСертификат, Программа)
	
	СтарыйСертификатОбъект = СтарыйСертификат.ПолучитьОбъект();
	
	ДвоичныеДанныеСертификата = СтарыйСертификатОбъект.ФайлСертификата.Получить();
	
	Если Не ЗначениеЗаполнено(ДвоичныеДанныеСертификата) Тогда
		Возврат Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка();
	КонецЕсли;
	
	СертификатОбъект = Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.СоздатьЭлемент();
	СертификатОбъект.ДанныеСертификата = Новый ХранилищеЗначения(ДвоичныеДанныеСертификата);
	СертификатОбъект.Отпечаток = СтарыйСертификатОбъект.Отпечаток;
	
	СертификатОбъект.Добавил = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если СертификатОбъект.ДанныеСертификата.Получить() <> ДвоичныеДанныеСертификата Тогда
		СертификатОбъект.ДанныеСертификата = Новый ХранилищеЗначения(ДвоичныеДанныеСертификата);
	КонецЕсли;
	
	Если ТипЗнч(ДвоичныеДанныеСертификата) = Тип("Строка") Тогда
		ОбновитьЗначение(СертификатОбъект.Подписание,     Истина);
		ОбновитьЗначение(СертификатОбъект.Шифрование,     Истина);
		ОбновитьЗначение(СертификатОбъект.КомуВыдан,      СтарыйСертификатОбъект.Наименование);
		ОбновитьЗначение(СертификатОбъект.ДействителенДо, СтарыйСертификатОбъект.ДатаОкончания);
		
		Фамилия   = СтарыйСертификатОбъект.Фамилия;
		Имя       = СтарыйСертификатОбъект.Имя;
		Отчество  = СтарыйСертификатОбъект.Отчество;
		Должность = СтарыйСертификатОбъект.ДолжностьПоСертификату;
		Фирма     = СтарыйСертификатОбъект.Организация;
	Иначе
		СертификатКриптографии = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
		ОбновитьЗначение(СертификатОбъект.Подписание, СертификатКриптографии.ИспользоватьДляПодписи);
		ОбновитьЗначение(СертификатОбъект.Шифрование, СертификатКриптографии.ИспользоватьДляШифрования);
		
		СтруктураСертификата = ЭлектроннаяПодписьКлиентСервер.ЗаполнитьСтруктуруСертификата(СертификатКриптографии);
		ОбновитьЗначение(СертификатОбъект.КомуВыдан,      СтруктураСертификата.КомуВыдан);
		ОбновитьЗначение(СертификатОбъект.КемВыдан,       СтруктураСертификата.КемВыдан);
		ОбновитьЗначение(СертификатОбъект.ДействителенДо, СтруктураСертификата.ДействителенДо);
		
		СвойстваСубъекта = ЭлектроннаяПодписьКлиентСервер.СвойстваСубъектаСертификата(СертификатКриптографии);
		Фамилия   = ?(СвойстваСубъекта.Фамилия   = Неопределено, СтарыйСертификатОбъект.Фамилия, СвойстваСубъекта.Фамилия);
		Имя       = ?(СвойстваСубъекта.Имя       = Неопределено, СтарыйСертификатОбъект.Имя, СвойстваСубъекта.Имя);
		Отчество  = ?(СвойстваСубъекта.Отчество  = Неопределено, СтарыйСертификатОбъект.Отчество, СвойстваСубъекта.Отчество);
		Должность = ?(СвойстваСубъекта.Должность = Неопределено, СтарыйСертификатОбъект.ДолжностьПоСертификату, СвойстваСубъекта.Должность);
		Фирма     = СвойстваСубъекта.Организация;
	КонецЕсли;
	
	ОбновитьЗначение(СертификатОбъект.Наименование, СтарыйСертификатОбъект.Наименование);
	ОбновитьЗначение(СертификатОбъект.Организация,  СтарыйСертификатОбъект.Организация);
	ОбновитьЗначение(СертификатОбъект.Пользователь, СтарыйСертификатОбъект.Пользователь);
	ОбновитьЗначение(СертификатОбъект.Фамилия,   Фамилия,     Истина);
	ОбновитьЗначение(СертификатОбъект.Имя,       Имя,         Истина);
	ОбновитьЗначение(СертификатОбъект.Отчество,  Отчество,    Истина);
	ОбновитьЗначение(СертификатОбъект.Должность, Должность,   Истина);
	ОбновитьЗначение(СертификатОбъект.Фирма,     Фирма,       Истина);
	ОбновитьЗначение(СертификатОбъект.Программа, Программа,   Истина);
	
	ОбновитьЗначение(СертификатОбъект.ПометкаУдаления, СтарыйСертификатОбъект.ПометкаУдаления, Истина);
	ОбновитьЗначение(СертификатОбъект.Отозван,         СтарыйСертификатОбъект.Отозван,         Истина);
	
	ПропускаемыеРеквизиты = Новый Соответствие;
	ПропускаемыеРеквизиты.Вставить("Ссылка",       Истина);
	ПропускаемыеРеквизиты.Вставить("Наименование", Истина);
	ПропускаемыеРеквизиты.Вставить("Организация",  Истина);
	ПропускаемыеРеквизиты.Вставить("УсиленнаяЗащитаЗакрытогоКлюча", Истина);
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СертификатОбъект);
	
	ВидыЭД = СтарыйСертификатОбъект.ВидыДокументов.Выгрузить(Новый Структура("ИспользоватьДляПодписи", Истина));
	Если ВидыЭД.Количество() > 0 Тогда
		ВидыЭД.Колонки.Найти("ВидДокумента").Имя = "ВидЭД";
		ВидыЭД.Колонки.Найти("ИспользоватьДляПодписи").Имя = "Использовать";
		ВидыЭД.Колонки.Добавить("СертификатЭП");
		ВидыЭД.ЗаполнитьЗначения(СертификатОбъект.Ссылка, "СертификатЭП");
		НаборЗаписей = РегистрыСведений.ПодписываемыеВидыЭД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.СертификатЭП.Установить(СертификатОбъект.Ссылка);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Загрузить(ВидыЭД);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	КонецЕсли;
	
	СтарыйСертификатОбъект.СсылкаНаНовыйСертификат = СертификатОбъект.Ссылка;
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СтарыйСертификатОбъект);
	
	Возврат СертификатОбъект.Ссылка;
	
КонецФункции

// Для процедуры ОбновитьСписокСертификатов, ЗаписатьСертификатВСправочник.
Процедура ОбновитьЗначение(СтароеЗначение, НовоеЗначение, ПропускатьНеопределенныеЗначения = Ложь)
	
	Если НовоеЗначение = Неопределено И ПропускатьНеопределенныеЗначения Тогда
		Возврат;
	КонецЕсли;
	
	Если СтароеЗначение <> НовоеЗначение Тогда
		СтароеЗначение = НовоеЗначение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
