﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ОткрытьВсеСообщения") Тогда
		ОткрытьВсеСообщения();
	ИначеЕсли Параметры.Свойство("ОткрытьНовость") Тогда
		Если Параметры.Свойство("Идентификатор") Тогда 
			ОткрытьНовость(Параметры.Идентификатор);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_НажатиеНаНовость(Элемент)
	
	Фильтр = Новый Структура;
	Фильтр.Вставить("ИмяЭлементаФормы", Элемент.Имя);
	
	МассивСтрок = ТаблицаВсехНовостей.НайтиСтроки(Фильтр);
	Если МассивСтрок.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущееСообщение = МассивСтрок.Получить(0);
	
	Если ТекущееСообщение.ТипИнформации = "Недоступность" Тогда 
		
		ОткрытьНовость(ТекущееСообщение.Идентификатор);
		
	ИначеЕсли ТекущееСообщение.ТипИнформации = "УведомлениеОПожелании" Тогда 
		
		ИдентификаторИдеи = Строка(ТекущееСообщение.Идентификатор);
		
		ИнформационныйЦентрКлиент.ПоказатьИдею(ИдентификаторИдеи);
		
    ИначеЕсли ТекущееСообщение.ТипИнформации = "Новость" Тогда 
        
        ОткрытьНовость(ТекущееСообщение.Идентификатор);
        
    КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеСообщенияНажатие(Элемент)
	
	Закрыть();
	ИнформационныйЦентрКлиент.ПоказатьВсеСообщения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОткрытьВсеСообщения()
	
	Заголовок = НСтр("ru = 'Сообщения'");
	СформироватьСписокВсехНовостей();
	Элементы.ОбщаяГруппа.ТекущаяСтраница = Элементы.ГруппаНовостей;
	
КонецПроцедуры

&НаСервере
Процедура ОткрытьНовость(Идентификатор)
	
	Элементы.ОбщаяГруппа.ТекущаяСтраница = Элементы.ГруппаНовости;
	УстановитьПривилегированныйРежим(Истина);
	СсылкаНаДанные	= Справочники.ОбщиеДанныеИнформационногоЦентра.НайтиПоРеквизиту("Идентификатор", Идентификатор);
	Если СсылкаНаДанные.Пустая() Тогда 
		Возврат;
	КонецЕсли;
		
	Заголовок = СсылкаНаДанные.Наименование;
	
	Вложения  = СсылкаНаДанные.Вложения.Получить();
	ТекстHTML = СсылкаНаДанные.ТекстHTML;
	
	Если ТипЗнч(Вложения) = Тип("Структура") Тогда 
		СтруктураВложений = Вложения;
	Иначе
		СтруктураВложений = Новый Структура;
	КонецЕсли;
	
	Содержание.УстановитьHTML(ТекстHTML, СтруктураВложений);
    ЭтаФорма.ТекущийЭлемент = Элементы.Содержание;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокВсехНовостей()
	
	ТаблицаВсехНовостей.Очистить();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВозвращаемаяТаблица = ИнформационныйЦентрСервер.СформироватьСписокВсехНовостей();
	
	Если ВозвращаемаяТаблица.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ТаблицаВсехНовостей.Загрузить(ВозвращаемаяТаблица);
	
	ГруппаНовостей = Элементы.ГруппаВсехНовостей;
	
	Для Итерация = 0 По ТаблицаВсехНовостей.Количество() - 1 Цикл
		
		Критичность  = ТаблицаВсехНовостей.Получить(Итерация).Критичность;
		Наименование = ТаблицаВсехНовостей.Получить(Итерация).Наименование;
		Картинка     = ?(Критичность > 5, БиблиотекаКартинок.УведомлениеСервиса, БиблиотекаКартинок.СообщениеСервиса);
		
		ГруппаНовости                     = Элементы.Добавить("ГруппаНовости" + Строка(Итерация), Тип("ГруппаФормы"), ГруппаНовостей);
		ГруппаНовости.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаНовости.ОтображатьЗаголовок = Ложь;
		ГруппаНовости.Группировка         = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		ГруппаНовости.Отображение         = ОтображениеОбычнойГруппы.Нет;
		
		КартинкаНовости                = Элементы.Добавить("КартинкаНовости" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаНовости);
		КартинкаНовости.Вид            = ВидДекорацииФормы.Картинка;
		КартинкаНовости.Картинка       = Картинка;
		КартинкаНовости.Ширина         = 2;
		КартинкаНовости.Высота         = 1;
		КартинкаНовости.РазмерКартинки = РазмерКартинки.Растянуть;
		
		ИмяНовости                          = Элементы.Добавить("ИмяНовости" + Строка(Итерация), Тип("ДекорацияФормы"), ГруппаНовости);
		ИмяНовости.Вид                      = ВидДекорацииФормы.Надпись;
		ИмяНовости.Заголовок                = Наименование;
		ИмяНовости.РастягиватьПоГоризонтали = Истина;
		ИмяНовости.ВертикальноеПоложение    = ВертикальноеПоложениеЭлемента.Центр;
		ИмяНовости.ВысотаЗаголовка          = 1;
		ИмяНовости.Гиперссылка	            = Истина;
		ИмяНовости.УстановитьДействие("Нажатие", "Подключаемый_НажатиеНаНовость");
		
		Если Критичность = 10 Тогда 
			ИмяНовости.Шрифт = Новый Шрифт(, , Истина, , , );
		КонецЕсли;
		
		ТаблицаВсехНовостей.Получить(Итерация).ИмяЭлементаФормы = "ИмяНовости" + Строка(Итерация);
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти



