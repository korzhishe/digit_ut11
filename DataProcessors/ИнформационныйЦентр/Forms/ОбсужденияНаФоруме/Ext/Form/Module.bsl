﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьАдресФорума();
	
	Элементы.ГруппаПодвала.Видимость = Не ПустаяСтрока(АдресФорума);
	
	УстановитьПривилегированныйРежим(Истина);
	ИдентификаторПользователя = Пользователи.ТекущийПользователь().ИдентификаторПользователяСервиса;
	УстановитьПривилегированныйРежим(Ложь);
	
	Результат = ПолучитьСписокТем();
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПоказыватьФорму = Истина;
	
	СформироватьЭлементыСтраницы(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПоказыватьФорму Тогда 
		
		Если Не ПустаяСтрока(АдресФорума) Тогда 
			ПерейтиПоНавигационнойСсылке(АдресФорума);
		КонецЕсли;
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_НажатиеНаТемуСНовымиКомментариями(Элемент)
	
	Фильтр = Новый Структура("ИмяЭлементаФормы", Элемент.Имя);
	НайденныеСтроки = ТаблицаДляНовыхКомментариев.НайтиСтроки(Фильтр);
	Если НайденныеСтроки.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	АдресТемы = НайденныеСтроки.Получить(0).Адрес;
	
	ПерейтиПоНавигационнойСсылке(АдресТемы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаНовуюТему(Элемент)
	
	Фильтр = Новый Структура("ИмяЭлементаФормы", Элемент.Имя);
	НайденныеСтроки = ТаблицаДляНовыхТем.НайтиСтроки(Фильтр);
	Если НайденныеСтроки.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	АдресТемы = НайденныеСтроки.Получить(0).Адрес;
	
	ПерейтиПоНавигационнойСсылке(АдресТемы);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьФорумаНажатие(Элемент)
	
	Если Не ПустаяСтрока(АдресФорума) Тогда 
		ПерейтиПоНавигационнойСсылке(АдресФорума);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСписокТем()
	
	Попытка
		Прокси = ИнформационныйЦентрСервер.ПолучитьПроксиУправленияКонференцией();
		Возврат Прокси.getForumTopics(Строка(ИдентификаторПользователя));
	Исключение
		ИмяСобытия = ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации();
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

&НаСервере
Процедура СформироватьЭлементыСтраницы(Результат)
	
	Если Результат.commentTopics.topicDescriptionCollection.Количество() <> 0 Тогда 
		СформироватьЭлементыНовыхКомментариев(Результат.commentTopics.topicDescriptionCollection);
	КонецЕсли;
	
	Если Результат.mainTopics.topicDescriptionCollection.Количество() <> 0 Тогда
		СформироватьЭлементыНовыхТем(Результат.mainTopics.topicDescriptionCollection);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЭлементыНовыхКомментариев(НовыеКомментарии)
	
	ШаблонТемыСНовымиКомментариями = "%1 (%2)";
	
	Итерация = 0;
	Для Каждого Комментарий Из НовыеКомментарии Цикл 
		
		ИмяНовогоЭлемента                     = "ТемаСНовымиКомментариями" + Строка(Итерация);
		НовыйЭлемент                          = Элементы.Добавить(ИмяНовогоЭлемента, Тип("ДекорацияФормы"), Элементы.НовыеКомментарии);
		НовыйЭлемент.Вид                      = ВидДекорацииФормы.Надпись;
		НовыйЭлемент.Заголовок                = СтрШаблон(ШаблонТемыСНовымиКомментариями, Комментарий.subject, Строка(Комментарий.messageCount));
		НовыйЭлемент.Гиперссылка              = Истина;
		НовыйЭлемент.РастягиватьПоГоризонтали = Истина;
		НовыйЭлемент.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаТемуСНовымиКомментариями");
		
		ЭлементТаблицы                    = ТаблицаДляНовыхКомментариев.Добавить();
		ЭлементТаблицы.ИмяЭлементаФормы   = ИмяНовогоЭлемента;
		ЭлементТаблицы.Адрес              = Комментарий.url;
		
		Итерация = Итерация + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЭлементыНовыхТем(НовыеТемы)
	
	Итерация = 0;
	Для Каждого Тема Из НовыеТемы Цикл 
		
		ИмяЭлементаГруппыНовойТемы          = "ГруппаНовойТемы" + Строка(Итерация);
		ГруппаНовойТемы                     = Элементы.Добавить(ИмяЭлементаГруппыНовойТемы, Тип("ГруппаФормы"), Элементы.НовыеТемы);
		ГруппаНовойТемы.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаНовойТемы.ОтображатьЗаголовок = Ложь;
		ГруппаНовойТемы.Группировка         = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ГруппаНовойТемы.Отображение         = ?(Итерация = 0, ОтображениеОбычнойГруппы.Нет, ОтображениеОбычнойГруппы.СильноеВыделение);
		
		ИмяЭлементаНовойТемы                      = "НоваяТема" + Строка(Итерация);
		ЭлементНовойТемы                          = Элементы.Добавить(ИмяЭлементаНовойТемы, Тип("ДекорацияФормы"), ГруппаНовойТемы);
		ЭлементНовойТемы.Вид                      = ВидДекорацииФормы.Надпись;
		ЭлементНовойТемы.Заголовок                = Тема.subject;
		ЭлементНовойТемы.Гиперссылка              = Истина;
		ЭлементНовойТемы.РастягиватьПоГоризонтали = Истина;
		ЭлементНовойТемы.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаНовуюТему");
		
		ИмяЭлементаПредмета                      = "Предмет" + Строка(Итерация);
		ЭлементПредмета                          = Элементы.Добавить(ИмяЭлементаПредмета, Тип("ДекорацияФормы"), ГруппаНовойТемы);
		ЭлементПредмета.Вид                      = ВидДекорацииФормы.Надпись;
		ЭлементПредмета.Заголовок                = Тема.topicName;
		ЭлементПредмета.РастягиватьПоГоризонтали = Истина;
		ЭлементПредмета.ГоризонтальноеПоложение  = ГоризонтальноеПоложениеЭлемента.Право;
		
		ЭлементТаблицы                    = ТаблицаДляНовыхТем.Добавить();
		ЭлементТаблицы.ИмяЭлементаФормы   = ИмяЭлементаНовойТемы;
		ЭлементТаблицы.Адрес              = Тема.url;
		
		Итерация = Итерация + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьАдресФорума()
	
	АдресФорума = Справочники.ИнформационныеСсылкиДляФорм.Форум.Адрес;
	СтруктураАдресаФорума = ТехнологияСервисаИнтеграцияСБСПКлиентСервер.СтруктураURI(АдресФорума);
	
	АдресПриложения = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
	СтруктураАдресаПриложения = ТехнологияСервисаИнтеграцияСБСПКлиентСервер.СтруктураURI(АдресПриложения);
	
	Если Не ПустаяСтрока(СтруктураАдресаФорума.Хост) Тогда 
		Если Не ПустаяСтрока(СтруктураАдресаПриложения.Хост) Тогда
			АдресФорума = СтрЗаменить(АдресФорума, СтруктураАдресаФорума.Хост, СтруктураАдресаПриложения.Хост);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти



