﻿
//============================================================================
// АВТОР

&НаКлиенте
Процедура SubSysSkype(Команда)
	
	ЗапуститьПриложение("skype:shekineugeniy?chat");
	
КонецПроцедуры

&НаКлиенте
Процедура SubSysОставитьОтзыв(Команда)
	
	ЗапуститьПриложение("http://subsystems.ru/forum/?PAGE_NAME=read&FID=5&TID=54");
	
КонецПроцедуры

&НаКлиенте
Процедура SubSysПерейтиНаСайтРазработчика(Команда)
	
	ЗапуститьПриложение("http://subsystems.ru/");
	
КонецПроцедуры

&НаКлиенте
Процедура SubSysПроверитьОбновления(Команда)
	
	ЗапуститьПриложение("http://subsystems.ru/forum/?PAGE_NAME=read&FID=7&TID=28");
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьМарафетНажатие(Элемент)
	
	ЗапуститьПриложение("http://subsystems.ru/catalog/41/586/");
	
КонецПроцедуры



&НаКлиенте
Процедура ВидеоОбзор(Команда)
	
	ЗапуститьПриложение("https://www.youtube.com/watch?v=QO39ZelcqQ8&t=1788s");
	
КонецПроцедуры





&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Объект").ПолучитьМакет("СхемаЗапроса");
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	Объект.КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	Объект.КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТиповуюОбработку(Команда)
	
	ОткрытьФорму("Обработка.ГрупповоеИзменениеРеквизитов.Форма");

КонецПроцедуры




//============================================================================
// СЛУЖЕБНЫЕ

&НаСервереБезКонтекста
Функция глРазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = " ") Экспорт

	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр,Разделитель);
			
			Если Поз = 0 Тогда
				СтрокаВМассив = СокрЛП(Стр);

				МассивСтрок.Добавить(СтрокаВМассив);
				Возврат МассивСтрок;
			КонецЕсли;
			
			СтрокаВМассив = СокрЛП(Лев(Стр,Поз-1));
			
			МассивСтрок.Добавить(СтрокаВМассив);
			Стр = СокрЛ(Сред(Стр,Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1 = 1 Цикл
			Поз = Найти(Стр,Разделитель);
			
			Если Поз = 0 Тогда
				СтрокаВМассив = СокрЛП(Стр);

				МассивСтрок.Добавить(СтрокаВМассив);
				Возврат МассивСтрок;
			КонецЕсли;
			
			СтрокаВМассив = СокрЛП(Лев(Стр,Поз-1));

			МассивСтрок.Добавить(СтрокаВМассив);
			Стр = Сред(Стр,Поз+ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции 

&НаСервереБезКонтекста
Функция ПеревестиВРег(МассивСлов) Экспорт
	
	НовыйМассив = Новый Массив; 
	
	Для Каждого Стр Из МассивСлов Цикл
		НовыйМассив.Добавить(ВРег(СокрЛП(Стр)));
	КонецЦикла;
	
	Возврат НовыйМассив; 
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьМассивСтрокой(МассивРезультат)
	
	Результат = "";
	
	Для Каждого Строка Из МассивРезультат Цикл		
		Результат = Результат+" "+Строка; 
	КонецЦикла;	
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция глМассивПеревестиСловаВРег(МассивСлов) Экспорт
	
	НовыйМассив = Новый Массив; 
	
	Для Каждого Стр Из МассивСлов Цикл
		НовыйМассив.Добавить(ВРег(СокрЛП(Стр)));
	КонецЦикла;
	
	Возврат НовыйМассив; 
	
КонецФункции


//============================================================================
// 


&НаКлиенте
Процедура ВыборПериода(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Объект.НачалоПериода, Объект.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Объект, РезультатВыбора, "НачалоПериода,КонецПериода");

КонецПроцедуры



//============================================================================
// 

&НаСервере
Процедура ОбработкаНоменклатурыЗаполнитьСервер()

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");

	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("АдресСхемыВХранилище", Объект.КомпоновщикНастроек);
	
	ОбработкаОбъект.ОбработкаНоменклатурыЗаполнитьТаблицу(ПараметрыЗапроса);

	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНоменклатурыЗаполнить(Команда)
	
	ОбработкаНоменклатурыЗаполнитьСервер();
	
	Элементы.Закладки.ТекущаяСтраница = Элементы.Закладки.ПодчиненныеЭлементы.ТаблицаНоменклатуры;

КонецПроцедуры


//============================================================================
// 

&НаСервере
Процедура ПеренестиНоменклатуруВГруппуВыполнитьНаСервере()

	//ОбъектНом = Справочники.Номенклатура.ПолучитьСсылку();

	
	Для Каждого Строка Из Объект.ТабличнаяЧасть Цикл		
		ОбъектСпр = Строка.Номенклатура.ПолучитьОбъект();
		
		ПолныйПуть = ОбъектСпр.ПолныйКод();
		ОбъектСпр.Описание = ОбъектСпр.Описание+Символы.ПС+"ПЕРЕНОС:"+ПолныйПуть;

		ОбъектСпр.Родитель = Объект.ГруппаНоменклатуры;			
						
		ОбъектСпр.ОбменДанными.Загрузка = Истина;
		ОбъектСпр.Записать();	
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПеренестиНоменклатуруВГруппуВыполнить(Команда)
	
	Ответ = Вопрос("Вы уверены ?", РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет, "Дополнительный вопрос");		
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	Сообщить("Обработка Начало - "+ТекущаяДата());

	ПеренестиНоменклатуруВГруппуВыполнитьНаСервере();
	
	Сообщить("Обработка завершена - "+ТекущаяДата());

КонецПроцедуры


//============================================================================
// 

&НаСервере
Функция ЗначениеСсылочногоТипа(Значение) Экспорт
	
	Возврат ЭтоСсылка(ТипЗнч(Значение));
	
КонецФункции


&НаСервере
Функция ЭтоСсылка(Тип) Экспорт
	
	Возврат Тип <> Тип("Неопределено") 
		И (Справочники.ТипВсеСсылки().СодержитТип(Тип)
		//ИЛИ Документы.ТипВсеСсылки().СодержитТип(Тип)
		//ИЛИ Перечисления.ТипВсеСсылки().СодержитТип(Тип)
		//ИЛИ ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(Тип)
		ИЛИ ПланыСчетов.ТипВсеСсылки().СодержитТип(Тип)
		ИЛИ ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(Тип)
		ИЛИ БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип)
		ИЛИ БизнесПроцессы.ТипВсеСсылкиТочекМаршрутаБизнесПроцессов().СодержитТип(Тип)
		ИЛИ Задачи.ТипВсеСсылки().СодержитТип(Тип)
		ИЛИ ПланыОбмена.ТипВсеСсылки().СодержитТип(Тип));
	
КонецФункции




&НаСервере
Процедура УдалитьНоменклатуруНаСервере()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|ГДЕ
	|	СпрНоменклатура.ЭтоГруппа = ЛОЖЬ
	|	И СпрНоменклатура.мегапрайсДатаРегистрации = &ДатаРегистрации";	
	
	Запрос = Новый Запрос();
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ДатаРегистрации",Объект.ДатаРегистрации);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	СписокСсылок = Новый Массив();
	Для Каждого СтрВыборка Из Объект.ТабличнаяЧасть Цикл
		ПолучитьОбъект = СтрВыборка.Номенклатура.ПолучитьОбъект();
		ПолучитьОбъект.УстановитьПометкуУдаления(Истина,Истина);
		Сообщить ("Помечен на удаление " + СтрВыборка.Номенклатура);
		
		СписокСсылок.Добавить(СтрВыборка.Номенклатура);
	КонецЦикла;
	
	ТаблицаСсылок = НайтиПоСсылкам(СписокСсылок);
	ТаблицаСсылок.Колонки[0].Имя = "ИсходнаяСсылка";
	ТаблицаСсылок.Колонки[1].Имя = "ОбнаруженныйСсылка";
	ТаблицаСсылок.Колонки[2].Имя = "ОбнаруженныйМетаданные";

	НачатьТранзакцию();
	Попытка		
		Для Каждого Ссылка из ТаблицаСсылок Цикл
			Если ЗначениеСсылочногоТипа(Ссылка[1]) Тогда				
				Ссылка[1].ПолучитьОбъект().УстановитьПометкуУдаления(Истина);
				Сообщить ("Помечен на удаление связанный элемент " + СокрЛП(Ссылка[0]) + "  " + СокрЛП(Ссылка[1]));
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНоменклатуруКоманда(Команда)
	
	Ответ = Вопрос("Вы уверены ?", РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет, "Дополнительный вопрос");		
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	УдалитьНоменклатуруНаСервере();
	
КонецПроцедуры






&НаСервере
Процедура УдалитьКартинкиНоменклатурыНаСервере()
	
	
	Для Каждого СтрокаВыборка Из Объект.ТабличнаяЧасть Цикл	
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ПрисоединенныеФайлы.Ссылка КАК Ссылка,
		|	ПрисоединенныеФайлы.Наименование КАК Наименование
		|ИЗ
		|	Справочник.НоменклатураПрисоединенныеФайлы КАК ПрисоединенныеФайлы
		|ГДЕ
		|	ПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайлов";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("ВладелецФайлов", СтрокаВыборка.Номенклатура);
		
		ВыборкаТаблица = Запрос.Выполнить().Выгрузить();	
		Для Каждого Выборка Из ВыборкаТаблица Цикл
			Выборка.Ссылка.ПолучитьОбъект().Удалить();
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьКартинкиНоменклатуры(Команда)
	
	Ответ = Вопрос("Вы уверены ?", РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет, "Дополнительный вопрос");		
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	УдалитьКартинкиНоменклатурыНаСервере();
	
КонецПроцедуры


&НаСервере
Процедура УдалитьСвойстваНоменклатурыНаСервере()
	
	Для Каждого Строка Из Объект.ТабличнаяЧасть Цикл		
		ОбъектСпр = Строка.Номенклатура.ПолучитьОбъект();
		ОбъектСпр.ДополнительныеРеквизиты.Очистить();
		ОбъектСпр.Записать();	
	КонецЦикла;

КонецПроцедуры


&НаКлиенте
Процедура УдалитьСвойстваНоменклатуры(Команда)
	
	Ответ = Вопрос("Вы уверены ?", РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет, "Дополнительный вопрос");		
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	УдалитьСвойстваНоменклатурыНаСервере();
	
КонецПроцедуры




&НаСервере
Процедура УдалитьХарактеристикиНоменклатурыНаСервере()
	
	Для Каждого СтрокаВыборка Из Объект.ТабличнаяЧасть Цикл	
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ХарактеристикиНоменклатуры.Ссылка КАК Ссылка,
		|	ХарактеристикиНоменклатуры.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
		|ГДЕ
		|	ХарактеристикиНоменклатуры.Владелец = &ВыбВладелец
		|	И ХарактеристикиНоменклатуры.мегапрайсДатаРегистрации = &ДатаРегистрации";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("ВыбВладелец", СтрокаВыборка.Номенклатура);
		Запрос.УстановитьПараметр("ДатаРегистрации", Объект.ДатаРегистрации);
		
		ВыборкаТаблица = Запрос.Выполнить().Выгрузить();	
		Для Каждого Выборка Из ВыборкаТаблица Цикл
			Если Объект.УдалятьНепосредственно Тогда
				Выборка.Ссылка.ПолучитьОбъект().Удалить();
			Иначе
				Выборка.Ссылка.ПолучитьОбъект().УстановитьПометкуУдаления(Истина,Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьХарактеристикиНоменклатуры(Команда)
	
	Ответ = Вопрос("Вы уверены ?", РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Нет, "Дополнительный вопрос");		
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	УдалитьХарактеристикиНоменклатурыНаСервере();
	
КонецПроцедуры









