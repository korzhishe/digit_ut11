﻿
//============================================================================
// ФОРМА

&НаСервере
Процедура ЗаполнитьАлгоритмы()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");

	Макет = ОбработкаОбъект.ПолучитьМакет("АлгоритмыКлючевыхСлов");
		
	Область = Макет.ПолучитьОбласть("ТекстыАлгоритмов");
	
	ВсегоСтрок = Область.ВысотаТаблицы + 1;
	ТекущаяСтрока = 1;
	
	Объект.АлгоритмыКлючевыхСлов.Очистить();
	
	Пока ТекущаяСтрока < ВсегоСтрок Цикл
		
		мСтрока = "R" + Формат(ТекущаяСтрока,"ЧДЦ=0; ЧГ=");
		
		Представление  = Область.ПолучитьОбласть(мСтрока + "C1").ТекущаяОбласть.Текст;
		ТекстАлгоритма = Область.ПолучитьОбласть(мСтрока + "C2").ТекущаяОбласть.Текст;
		
		Если ПустаяСтрока(Представление) Тогда
			ТекущаяСтрока = ТекущаяСтрока + 1;		
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Объект.АлгоритмыКлючевыхСлов.Добавить();
		НоваяСтрока.Представление  = Представление;
		НоваяСтрока.ТекстАлгоритма = ТекстАлгоритма;
		
		ТекущаяСтрока = ТекущаяСтрока + 1;			
	КонецЦикла;
		
Конецпроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиПрайсаСервер()
	
	ОбъектПрайсПартнера = Объект.ПрайсПартнера;
	
	Объект.АлгоритмыКлючевыхСлов.Загрузить(ОбъектПрайсПартнера.АлгоритмыКлючевыхСлов.Выгрузить());
	Объект.ЗаменаКлючевыхСлов.Загрузить(ОбъектПрайсПартнера.ЗаменаКлючевыхСлов.Выгрузить());
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтандартныеАлгоритмы(Команда)
	
	ЗаполнитьАлгоритмы();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если НЕ Параметры.Свойство("Адрес") Тогда
		Возврат;
	КонецЕсли;
	
	ФормаОткрытаМодально = Истина;
	
	СтруктураПараметров = ПолучитьИзВременногоХранилища(Параметры.Адрес);
	АдресВХранилище = Параметры.Адрес;
	
	Объект.ПоискСоответствий.Очистить();
	
	Для Каждого Строка из СтруктураПараметров.ТабличнаяЧасть Цикл
		
		Если ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(Строка.Поле_Наименование) Тогда
			Продолжить;
		КонецЕсли;

		Если Строка.ЭтоГруппа Тогда
			Продолжить;
		КонецЕсли;
				
		НоваяСтрока = Объект.ПоискСоответствий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
				
		Если ЗначениеЗаполнено(Строка.ПроизводительСсылка) Тогда
			НоваяСтрока.Производитель = Строка.ПроизводительСсылка;
		КонецЕсли;
			
	КонецЦикла;
		
	ЗаполнитьНастройкиПрайсаСервер();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПервыеКлючевыеСлова = 1;
	
	РучнойРежимПриИзменении("");
	
КонецПроцедуры

&НаКлиенте
Процедура РучнойРежимПриИзменении(Элемент)
	
	Элементы.ПодборРучнойРежим.Видимость = РучнойРежим;
	
	ПоискСоответствийПриАктивизацииСтроки("");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоРегистраторуСервер();
		
	Объект.ПоискСоответствий.Очистить();
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	мегапрайсРегистрацияПрайса.Ссылка,
	|	мегапрайсРегистрацияПрайса.Поле_Артикул КАК Поле_Артикул,
	|	мегапрайсРегистрацияПрайса.Поле_Наименование КАК Поле_Наименование,
	|	мегапрайсРегистрацияПрайса.Производитель,
	|	мегапрайсРегистрацияПрайса.НомерСтроки КАК КлючСтроки
	|ИЗ
	|	Документ.мегапрайсРегистрацияПрайса.Товары КАК мегапрайсРегистрацияПрайса
	|ГДЕ
	|	мегапрайсРегистрацияПрайса.Ссылка = &ПрайсПартнераРегистрация
	|	И мегапрайсРегистрацияПрайса.Номенклатура = &ПустаяСсылка";
	
	Запрос.УстановитьПараметр("ПрайсПартнераРегистрация", Объект.РегистрацияПрайсаСсылка);
	Запрос.УстановитьПараметр("ПустаяСсылка", Справочники.Номенклатура.ПустаяСсылка());

	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.ПоискСоответствий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);			
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПрайсПартнераПриИзменении(Элемент)
	
	ЗаполнитьНастройкиПрайсаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияПрайсаСсылкаПриИзменении(Элемент)
	
	ЗаполнитьДанныеПоРегистраторуСервер();

КонецПроцедуры

//============================================================================
// СЛУЖЕБНЫЕ

&НаСервере
Функция глСтрокаПолучитьЧисло(Строка1, БезТочек = Ложь) 
	
	НовСтрока = "";
	
	Если БезТочек Тогда
		ПравильныеСимволы = "0123456789,.";
	Иначе
		ПравильныеСимволы = "0123456789";
	КонецЕсли;
	
	Для Сч = 1 по СтрДлина(Строка1) Цикл
		
		ТекСимв = Сред(Строка1, Сч, 1);
		
		Если Найти(ПравильныеСимволы, ТекСимв) = 0 Тогда
			НовСтрока = НовСтрока + ТекСимв;
		КонецЕсли;
		
		Если Сч = СтрДлина(Строка1) Тогда
			Если ТекСимв = "." Тогда
				НовСтрока = НовСтрока + ТекСимв;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НовСтрока;	
	
КонецФункции   

&НаСервере
Функция НайтиВСтрокеСловоИзБуквИЦифр(Строка1) 
	
	Результат = Ложь;
	
	ПравильныеСимволы = "0123456789";
	//ПравильныеСимволыБуквы = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮйцукенгшщзхъфывапролджэячсмитьбю";
	ПравильныеСимволыБуквы = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm";
	
	ЕстьБуква = 0;
	ЕстьЦифра = 0;

	Для Сч = 1 по СтрДлина(Строка1) Цикл
				
		ТекСимв = Сред(Строка1, Сч, 1);
		
		Если ЕстьЦифра = 0 Тогда
			Если Найти(ПравильныеСимволы, ТекСимв) > 0 Тогда
				ЕстьЦифра = 1;
			КонецЕсли;
		КонецЕсли;
		
		Если ЕстьБуква = 0 Тогда
			Если Найти(ПравильныеСимволыБуквы, ТекСимв) > 0 Тогда
				ЕстьБуква = 1;
			КонецЕсли;
		КонецЕсли;
				
	КонецЦикла;
	
	Если ЕстьБуква = 1 И ЕстьЦифра = 1 Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;	
	
КонецФункции   




&НаСервере
Функция ПеревестиВРег(МассивСлов)
	
	НовыйМассив = Новый Массив; 
	
	Для Каждого Стр Из МассивСлов Цикл
		НовыйМассив.Добавить(ВРег(СокрЛП(Стр)));
	КонецЦикла;
	
	Возврат НовыйМассив; 
	
КонецФункции

&НаСервере
Функция ПолучитьМассивСтрокой(МассивРезультат)
	
	Результат = "";
	
	Для Каждого Строка Из МассивРезультат Цикл		
		Результат = Результат+" "+Строка; 
	КонецЦикла;	
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция глРазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = " ")

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

&НаСервере
Функция глМассивПеревестиСловаВРег(МассивСлов) Экспорт
	
	НовыйМассив = Новый Массив; 
	
	Для Каждого Стр Из МассивСлов Цикл
		НовыйМассив.Добавить(ВРег(СокрЛП(Стр)));
	КонецЦикла;
	
	Возврат НовыйМассив; 
	
КонецФункции

//============================================================================
// ДЕЙСТВИЯ

&НаСервере
Процедура АвтосохранениеНастройкиПрайса()
	
	Если ЗначениеЗаполнено(Объект.ПрайсПартнера) Тогда
		ПрайсПартнераОбъект = Объект.ПрайсПартнера.ПолучитьОбъект();
		ПрайсПартнераОбъект.АлгоритмыКлючевыхСлов.Загрузить(Объект.АлгоритмыКлючевыхСлов.Выгрузить());
		ПрайсПартнераОбъект.ЗаменаКлючевыхСлов.Загрузить(Объект.ЗаменаКлючевыхСлов.Выгрузить());
		ПрайсПартнераОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьКлючевыеСлова(Команда)
	
	АвтосохранениеНастройкиПрайса();

	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ПроизводительОтбор", ПроизводительОтбор); 
	ПараметрыЗапроса.Вставить("ГруппаОтбор", ГруппаОтбор);

	ЗаполнитьКлючевыеСловаСервер(ПараметрыЗапроса);
	
	Элементы.Закладки.ТекущаяСтраница = Элементы.ЗакладкаПоискСоответствий;

КонецПроцедуры

&НаКлиенте
Процедура ПоискСоответствийВыполнитьАнализСоответствий(Команда)
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ПроизводительОтбор", ПроизводительОтбор); 
	ПараметрыЗапроса.Вставить("ГруппаОтбор", ГруппаОтбор);
	ПараметрыЗапроса.Вставить("ПоискСОтборомПоИерархии", ПоискСОтборомПоИерархии);

	ТаблицаОпределениеСоответствий(ПараметрыЗапроса);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАвтомаксимумСервер()
	
	Для Каждого Стр Из Объект.ПоискСоответствий Цикл
		Стр.АртикулНоменклатуры = Стр.МаксимальноеСовпадение.Артикул;
		Стр.Номенклатура = Стр.МаксимальноеСовпадение;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьАвтомаксимум(Команда)
	
	ЗаполнитьАвтомаксимумСервер();

КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ПоискСоответствий.Выгрузить(), Новый УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСоответствияНаСервере()
		
	ДокументОбъект = Объект.РегистрацияПрайсаСсылка.ПолучитьОбъект();
	
	Для Каждого ТекСтрока Из Объект.ПоискСоответствий Цикл
		
		Если НЕ ЗначениеЗаполнено(ТекСтрока.Номенклатура) Тогда
			Продолжить;
		КонецЕсли;
		
		ДокументОбъект.Товары[ТекСтрока.КлючСтроки - 1].Номенклатура = ТекСтрока.Номенклатура; 
		
	КонецЦикла;
	
	ДокументОбъект.Записать();
	
КонецПроцедуры 

&НаКлиенте
Процедура КомандаРезультат(Команда)
	
	Если ФормаОткрытаМодально Тогда
		
		Закрыть(ПоместитьВоВременноеХранилищеНаСервере());
	Иначе
		
		ЗаполнитьСоответствияНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

//============================================================================
// ОБРАБОТКА

&НаСервере
Функция ОбработкаЗаменаКлючевыхСлов(Строка)
	
	СтрокаЗамены = Строка;
	
	Отбор = Новый Структура();
	Отбор.Вставить("КлючевоеСлово",Строка);
	
	НайтиСтроки = ТаблицаКлючевыхСлов.НайтиСтроки(Отбор);
	Если НайтиСтроки.Количество() > 0 Тогда
		Для Каждого СтрТаблицы Из НайтиСтроки Цикл
			СтрокаЗамены = СтрТаблицы.Замена; 
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтрокаЗамены;
		
КонецФункции

&НаСервере
Функция РазложитьСтрокуНаКлючевыеСлова(Строка)
	
	МассивРезультат = Новый Массив;
		
	МассивКлючевыхСлов = глРазложитьСтрокуВМассивПодстрок(Строка);
	МассивКлючевыхСлов = ПеревестиВРег(МассивКлючевыхСлов);
	КоличествоСлов     = МассивКлючевыхСлов.Количество();
	
	КоличествоКлючевыхСлов = 0;
	Для инд = 0 По КоличествоСлов - 1 Цикл
		КоличествоКлючевыхСлов = КоличествоКлючевыхСлов + 1;
		
		СтрКлючевоеСлово = СокрЛП(МассивКлючевыхСлов[инд]);	
		Если СтрДлина(СтрКлючевоеСлово) = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		МассивРезультат.Добавить(СтрКлючевоеСлово);
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКлючевыеСловаСервер(ПараметрыЗапроса)
	
	Для Каждого Стр Из Объект.ПоискСоответствий Цикл
		
		НаименованиеДляПоиска = СокрЛП(Стр.Поле_Наименование);

		Если Объект.ЗаменаКлючевыхСлов.Количество() > 0 Тогда
			Для Каждого СтрНастроек Из Объект.ЗаменаКлючевыхСлов Цикл
				Если Найти(НаименованиеДляПоиска,СтрНастроек.ЧтоЗаменить) > 0 Тогда
					НаименованиеДляПоиска = СтрЗаменить(НаименованиеДляПоиска,СтрНастроек.ЧтоЗаменить,СтрНастроек.Замена);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;	

		Стр.Номенклатура           = Справочники.Номенклатура.ПустаяСсылка();
		Стр.МаксимальноеСовпадение = Справочники.Номенклатура.ПустаяСсылка();
		Стр.КлючевыеСлова          = "";
						
		Если ГлобальныйПоискПоАртикулам Тогда		
			СтрАртикул      = СокрЛП(Стр.Поле_Артикул);
			Если НЕ ЗначениеЗаполнено(СтрАртикул) Тогда
				Продолжить;
			КонецЕсли;
			
			СтрАртикул = ВыполнитьОбработкуАлгоритмыКлючевыхСлов(СтрАртикул); 
				
			МассивКлючевыхСлов         = РазложитьСтрокуНаКлючевыеСлова(СтрАртикул);
			Стр.КлючевыеСлова          = ПолучитьМассивСтрокой(МассивКлючевыхСлов);
			Стр.КоличествоКлючевыхСлов = МассивКлючевыхСлов.Количество();
		
		Иначе
			
			Если НЕ ЗначениеЗаполнено(НаименованиеДляПоиска) Тогда
				Продолжить;
			КонецЕсли;
			
			НаименованиеДляПоиска = ВыполнитьОбработкуАлгоритмыКлючевыхСлов(НаименованиеДляПоиска);

			МассивКлючевыхСлов         = РазложитьСтрокуНаКлючевыеСлова(НаименованиеДляПоиска);
			Стр.КлючевыеСлова          = ПолучитьМассивСтрокой(МассивКлючевыхСлов);
			Стр.КоличествоКлючевыхСлов = МассивКлючевыхСлов.Количество();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Функция ВыполнитьПоискСоответствийПоСтроке(ПараметрыЗапроса)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаСовпадений = Новый ТаблицаЗначений;
	ТаблицаСовпадений.Колонки.Добавить("Номенклатура");
	ТаблицаСовпадений.Колонки.Добавить("Артикул");
	ТаблицаСовпадений.Колонки.Добавить("Совпадения", Новый ОписаниеТипов("Число"));
	ТаблицаСовпадений.Колонки.Добавить("Производитель");
	ТаблицаСовпадений.Колонки.Добавить("ГруппаСправочника");
	ТаблицаСовпадений.Колонки.Добавить("МаксимальноеСовпадение");

	ПоискСОтборомПоИерархии = ПараметрыЗапроса.ПоискСОтборомПоИерархии;
	ОтборСоответствийПоПроизводителю = ПараметрыЗапроса.ПроизводительОтбор; 
	ОтборСоответствийПоИерархии = ПараметрыЗапроса.ГруппаОтбор;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ВыбГруппаСправочника",ОтборСоответствийПоИерархии);
	Запрос.УстановитьПараметр("ВыбПроизводитель",ОтборСоответствийПоПроизводителю);
	
	КоличествоСлов  = 1;
	КлючевыеСловаСтроки = СокрЛП(ПараметрыЗапроса.КлючевыеСлова);
	
	УсловиеПоискаПоАртикулу = "";
	Если ГлобальныйПоискПоАртикулам Тогда
		СтрУсловиеПоля = "Артикул";
	Иначе
		СтрУсловиеПоля = "Наименование";
	КонецЕсли;
	
	МассивКлючевыхСлов = глРазложитьСтрокуВМассивПодстрок(КлючевыеСловаСтроки," ");
	МассивКлючевыхСлов = глМассивПеревестиСловаВРег(МассивКлючевыхСлов);
	КоличествоКлючевыхСлов = МассивКлючевыхСлов.Количество();
	
	УсловиеПолейВводаПоСтроке = "";	
	Для инд = 0 По КоличествоКлючевыхСлов - 1 Цикл
		СтрКлючевоеСлово = СокрЛП(МассивКлючевыхСлов[инд]);
				
		Если ГлобальныйПоискПоАртикулам Тогда
			УсловиеПолейВводаПоСтроке = УсловиеПолейВводаПоСтроке + " И СпрНоменклатура."+СтрУсловиеПоля+" ПОДОБНО &ПодстрокаПоиска"+Строка(инд);
			
			Запрос.УстановитьПараметр("ПодстрокаПоиска"+Строка(инд),"%"+СтрКлючевоеСлово+"%");
		Иначе	
			УсловиеПолейВводаПоСтроке = УсловиеПолейВводаПоСтроке + " И СпрНоменклатура."+СтрУсловиеПоля+" ПОДОБНО &ПодстрокаПоиска"+Строка(инд);	
			
			Запрос.УстановитьПараметр("ПодстрокаПоиска"+Строка(инд),"%"+СтрКлючевоеСлово+"%");
		КонецЕсли;	
	КонецЦикла;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Номенклатура,
	|	СпрНоменклатура.Наименование,
	|	СпрНоменклатура.Артикул,
	|	СпрНоменклатура.Родитель КАК ГруппаСправочника,
	|	СпрНоменклатура.Производитель КАК Производитель
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|ГДЕ
	|	СпрНоменклатура.ЭтоГруппа = ЛОЖЬ";
	Если ЗначениеЗаполнено(ОтборСоответствийПоПроизводителю) Тогда
		ТекстЗапроса = ТекстЗапроса + " И СпрНоменклатура.Производитель = &ВыбПроизводитель";
	КонецЕсли;
	Если ПоискСОтборомПоИерархии И ЗначениеЗаполнено(ОтборСоответствийПоИерархии) Тогда
		ТекстЗапроса = ТекстЗапроса + " И СпрНоменклатура.Ссылка В ИЕРАРХИИ (&ВыбГруппаСправочника)";
	КонецЕсли;
	Если ГлобальныйПоискПоАртикулам Тогда
		Если НЕ Объект.ИскатьАртикулВНаименованииНоменклатуры Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|	И (НЕ СпрНоменклатура.Артикул = """")";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + "
		|  " + УсловиеПолейВводаПоСтроке;		
	Иначе
		ТекстЗапроса = ТекстЗапроса + " 
		|	"+УсловиеПолейВводаПоСтроке; 
	КонецЕсли;
	ТекстЗапроса = ТекстЗапроса + "
	|
	|СГРУППИРОВАТЬ ПО
	|	СпрНоменклатура.Производитель,
	|	СпрНоменклатура.Родитель,
	|	СпрНоменклатура.Ссылка,
	|	СпрНоменклатура.Наименование,
	|	СпрНоменклатура.Артикул";					
	
	Запрос.Текст = ТекстЗапроса;
	
	ТаблицаПолученногоЗапроса = Новый ТаблицаЗначений;
	ТаблицаПолученногоЗапроса = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаПолученногоЗапроса.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МаксимальноеСовпадение = СПравочники.Номенклатура.ПустаяСсылка();
	МаксимальноСовпадений = 0;
	
	Для Каждого СтрВыборка Из ТаблицаПолученногоЗапроса Цикл
		
		КоличествоСовпаденийСлов = 0;
		
		ВыборкаАртикул      = СтрВыборка.Артикул;
		ВыборкаНаименование = СтрВыборка.Наименование;
		
		Если ГлобальныйПоискПоАртикулам Тогда
			ВыборкаОбработка = ВРег(СокрЛП(ВыборкаАртикул));
		Иначе
			ВыборкаОбработка = ВРег(СокрЛП(ВыборкаНаименование));
		КонецЕсли;
		
		//ВыборкаМассивСлов = глРазложитьСтрокуВМассивПодстрок(ВыборкаОбработка," ");
		//ВыборкаМассивСлов = глМассивПеревестиСловаВРег(ВыборкаМассивСлов);
		//
		//Для Каждого ПодстрокаПоиска Из МассивКлючевыхСлов Цикл					
		//	НомерСовпадения = ВыборкаМассивСлов.Найти(ПодстрокаПоиска);
		//	Если НЕ НомерСовпадения = Неопределено Тогда
		//		КоличествоСовпаденийСлов = КоличествоСовпаденийСлов + 1;
		//	КонецЕсли;
		//КонецЦикла;
				
		Для Каждого ПодстрокаПоиска Из МассивКлючевыхСлов Цикл					
			НомерСовпадения = Найти(ВыборкаОбработка,ПодстрокаПоиска);
			Если НомерСовпадения > 0 Тогда
				КоличествоСовпаденийСлов = КоличествоСовпаденийСлов + 1;
			КонецЕсли;
		КонецЦикла;

		
		МаксимальноСовпадений = МАКС(КоличествоСовпаденийСлов,МаксимальноСовпадений);
						
		СтрСоответствия = ТаблицаСовпадений.Добавить();
		СтрСоответствия.Номенклатура      = СтрВыборка.Номенклатура;
		СтрСоответствия.Артикул           = СтрВыборка.Артикул;
		СтрСоответствия.Совпадения        = КоличествоСовпаденийСлов;
		СтрСоответствия.Производитель     = СтрВыборка.Производитель;
		СтрСоответствия.ГруппаСправочника = СтрВыборка.ГруппаСправочника;
		
	    Если КоличествоСовпаденийСлов >= КоличествоКлючевыхСлов Тогда
			СтрСоответствия.МаксимальноеСовпадение = СтрВыборка.Номенклатура;
		КонецЕсли;
	КонецЦикла;	
		
	ТаблицаСовпадений.Сортировать("Совпадения Убыв");

	Возврат ТаблицаСовпадений;
	
КонецФункции

&НаСервере
Функция ВыполнитьПоискВАртикуле1С(ПараметрыЗапроса)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаСовпадений = Новый ТаблицаЗначений;
	ТаблицаСовпадений.Колонки.Добавить("Номенклатура");
	ТаблицаСовпадений.Колонки.Добавить("Артикул");
	ТаблицаСовпадений.Колонки.Добавить("Совпадения", Новый ОписаниеТипов("Число"));
	ТаблицаСовпадений.Колонки.Добавить("Производитель");
	ТаблицаСовпадений.Колонки.Добавить("ГруппаСправочника");
	ТаблицаСовпадений.Колонки.Добавить("МаксимальноеСовпадение");

	ОтборСоответствийПоПроизводителю = ПараметрыЗапроса.ПроизводительОтбор; 
	ОтборСоответствийПоИерархии = ПараметрыЗапроса.ГруппаОтбор;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ВыбГруппаСправочника",ОтборСоответствийПоИерархии);
	Запрос.УстановитьПараметр("ВыбПроизводитель",ОтборСоответствийПоПроизводителю);
	
	КоличествоСлов  = 1;
	КлючевыеСловаСтроки = СокрЛП(ПараметрыЗапроса.КлючевыеСлова);
		
	МассивКлючевыхСлов = глРазложитьСтрокуВМассивПодстрок(КлючевыеСловаСтроки," ");
	//МассивКлючевыхСлов = глМассивПеревестиСловаВРег(МассивКлючевыхСлов);
	КоличествоКлючевыхСлов = МассивКлючевыхСлов.Количество();
	
	ЕстьРезультат = Ложь;

	Для Инд = 0 По КоличествоКлючевыхСлов - 1 Цикл				
		Если ЕстьРезультат Тогда
			Продолжить;
		КонецЕсли;
		
		СтрКлючевоеСлово = СокрЛП(МассивКлючевыхСлов[инд]);	
		Если СтрДлина(СтрКлючевоеСлово) < 3 Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос = Новый Запрос();
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СпрНоменклатура.Ссылка КАК Номенклатура,
		|	СпрНоменклатура.Наименование,
		|	СпрНоменклатура.Артикул,
		|	СпрНоменклатура.Родитель КАК ГруппаСправочника,
		|	СпрНоменклатура.Производитель КАК Производитель
		|ИЗ
		|	Справочник.Номенклатура КАК СпрНоменклатура
		|ГДЕ
		|	СпрНоменклатура.ЭтоГруппа = ЛОЖЬ
		|	И СпрНоменклатура.Артикул = &ПодстрокаПоиска"+Строка(Инд)+"
		|	И СпрНоменклатура.ПометкаУдаления = ЛОЖЬ";
		
		Запрос.УстановитьПараметр("ПодстрокаПоиска"+Строка(Инд),СтрКлючевоеСлово);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			СтрВыборка = РезультатЗапроса.Выбрать();
			Пока СтрВыборка.Следующий() Цикл
				ЕстьРезультат = Истина;

				СтрСоответствия = ТаблицаСовпадений.Добавить();
				СтрСоответствия.Номенклатура      = СтрВыборка.Номенклатура;
				СтрСоответствия.Артикул           = СтрВыборка.Артикул;
				СтрСоответствия.Совпадения        = 1;
				СтрСоответствия.Производитель     = СтрВыборка.Производитель;
				СтрСоответствия.ГруппаСправочника = СтрВыборка.ГруппаСправочника;
				СтрСоответствия.МаксимальноеСовпадение = СтрВыборка.Номенклатура;
			КонецЦикла;
		КонецЕсли;	
	КонецЦикла;			

	Возврат ТаблицаСовпадений;
	
	
	
	//УсловиеПолейВводаПоСтроке = "";	
	//Для инд = 0 По КоличествоКлючевыхСлов - 1 Цикл
	//	СтрКлючевоеСлово = СокрЛП(МассивКлючевыхСлов[инд]);
	//			
	//	УсловиеПолейВводаПоСтроке = УсловиеПолейВводаПоСтроке + " И СпрНоменклатура.Артикул ПОДОБНО &ПодстрокаПоиска"+Строка(инд);		
	//	Запрос.УстановитьПараметр("ПодстрокаПоиска"+Строка(инд),"%"+СтрКлючевоеСлово+"%");
	//КонецЦикла;	
	//
	//ТекстЗапроса = 
	//"ВЫБРАТЬ ПЕРВЫЕ 1
	//|	СпрНоменклатура.Ссылка КАК Номенклатура,
	//|	СпрНоменклатура.Наименование,
	//|	СпрНоменклатура.Артикул,
	//|	СпрНоменклатура.Родитель КАК ГруппаСправочника,
	//|	СпрНоменклатура.Производитель КАК Производитель
	//|ИЗ
	//|	Справочник.Номенклатура КАК СпрНоменклатура
	//|ГДЕ
	//|	СпрНоменклатура.ЭтоГруппа = ЛОЖЬ";
	//Если ЗначениеЗаполнено(ОтборСоответствийПоПроизводителю) Тогда
	//	ТекстЗапроса = ТекстЗапроса + " И СпрНоменклатура.Производитель = &ВыбПроизводитель";
	//КонецЕсли;
	//Если ЗначениеЗаполнено(ОтборСоответствийПоИерархии) Тогда
	//	ТекстЗапроса = ТекстЗапроса + " И СпрНоменклатура.Ссылка В ИЕРАРХИИ (&ВыбГруппаСправочника)";
	//КонецЕсли;
	//ТекстЗапроса = ТекстЗапроса + "
	//|	И (НЕ СпрНоменклатура.Артикул = """")";
	//ТекстЗапроса = ТекстЗапроса + "
	//|  " + УсловиеПолейВводаПоСтроке;		
	//ТекстЗапроса = ТекстЗапроса + "
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	СпрНоменклатура.Производитель,
	//|	СпрНоменклатура.Родитель,
	//|	СпрНоменклатура.Ссылка,
	//|	СпрНоменклатура.Наименование,
	//|	СпрНоменклатура.Артикул";		
	//
	//Запрос.Текст = ТекстЗапроса;
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//Если НЕ РезультатЗапроса.Пустой() Тогда
	//	СтрВыборка = РезультатЗапроса.Выбрать();
	//	Пока СтрВыборка.Следующий() Цикл		
	//		СтрСоответствия = ТаблицаСовпадений.Добавить();
	//		СтрСоответствия.Номенклатура      = СтрВыборка.Номенклатура;
	//		СтрСоответствия.Артикул           = СтрВыборка.Артикул;
	//		СтрСоответствия.Совпадения        = 1;
	//		СтрСоответствия.Производитель     = СтрВыборка.Производитель;
	//		СтрСоответствия.ГруппаСправочника = СтрВыборка.ГруппаСправочника;
	//		СтрСоответствия.МаксимальноеСовпадение = СтрВыборка.Номенклатура;
	//	КонецЦикла;
	//КонецЕсли;	
	//
	//Возврат ТаблицаСовпадений;
		
КонецФункции
	


&НаСервере
Процедура ТаблицаОпределениеСоответствий(Параметры)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого Стр Из Объект.ПоискСоответствий Цикл
		
		Стр.Номенклатура           = Справочники.Номенклатура.ПустаяСсылка();
		Стр.МаксимальноеСовпадение = Справочники.Номенклатура.ПустаяСсылка();
		Стр.МаксимальноСовпадений  = 0;

		КлючевыеСлова = СокрЛП(Стр.КлючевыеСлова);
		Если НЕ ЗначениеЗаполнено(КлючевыеСлова) Тогда
			Продолжить;
		КонецЕсли;	
		
		ПараметрыЗапроса = Новый Структура;
		ПараметрыЗапроса.Вставить("ПоискСОтборомПоИерархии", ПоискСОтборомПоИерархии);
		ПараметрыЗапроса.Вставить("Поле_Наименование", Стр.Поле_Наименование);
		ПараметрыЗапроса.Вставить("Поле_Артикул", Стр.Поле_Артикул);
		ПараметрыЗапроса.Вставить("КлючевыеСлова", Стр.КлючевыеСлова);
		ПараметрыЗапроса.Вставить("ПроизводительОтбор", ?(ЗначениеЗаполнено(Стр.Производитель),Стр.Производитель,ПроизводительОтбор)); 
		ПараметрыЗапроса.Вставить("ГруппаОтбор", ГруппаОтбор);
		
		Если НЕ Объект.АртикулРасположенВНаименованииИмпорт Тогда
			ТаблицаРезультата = ВыполнитьПоискСоответствийПоСтроке(ПараметрыЗапроса);
		Иначе
			ТаблицаРезультата = ВыполнитьПоискВАртикуле1С(ПараметрыЗапроса);
		КонецЕсли;
		
		Если ТаблицаРезультата = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого СтрРез Из ТаблицаРезультата Цикл
			Если ЗначениеЗаполнено(СтрРез.МаксимальноеСовпадение) Тогда
				Стр.МаксимальноеСовпадение = СтрРез.МаксимальноеСовпадение;
			КонецЕсли;
		КонецЦикла;	
		Стр.КоличествоСоответствий = ТаблицаРезультата.Количество(); 
	КонецЦикла;
	
КонецПроцедуры

//============================================================================
// СПИСКИ

&НаКлиенте
Процедура СоответствияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Номенклатура = Элементы.Соответствия.ТекущиеДанные.Номенклатура;

	Элементы.ТаблицаСоответствий.ТекущиеДанные.Номенклатура = Номенклатура;

	//Для Каждого Строка Из Элементы.ТаблицаСоответствий.ВыделенныеСтроки Цикл
	//	СтрокаСоотв = Объект.ПоискСоответствий.Получить(Строка);
	//	СтрокаСоотв.Номенклатура = Номенклатура;
	//КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПоискСоответствийПриАктивизацииСтроки(Элемент)
	
	Если РучнойРежим Тогда
		
		ТекущиеДанные = Элементы.ТаблицаСоответствий.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда	
			Соответствия.Очистить();
			
			Если НЕ ЗначениеЗаполнено(ТекущиеДанные.КлючевыеСлова) Тогда
				Возврат;
			КонецЕсли;
			
			ПараметрыЗапроса = Новый Структура;
			ПараметрыЗапроса.Вставить("ПоискСОтборомПоИерархии", ПоискСОтборомПоИерархии);
			ПараметрыЗапроса.Вставить("Поле_Наименование", ТекущиеДанные.Поле_Наименование);
			ПараметрыЗапроса.Вставить("Поле_Артикул", ТекущиеДанные.Поле_Артикул);
			ПараметрыЗапроса.Вставить("КлючевыеСлова", ТекущиеДанные.КлючевыеСлова);
			ПараметрыЗапроса.Вставить("ПроизводительОтбор", ?(ЗначениеЗаполнено(ТекущиеДанные.Производитель),ТекущиеДанные.Производитель,ПроизводительОтбор)); 
			ПараметрыЗапроса.Вставить("ГруппаОтбор", ГруппаОтбор);	
			
			ИнформацияПолучитьСоответствияСтроки(ПараметрыЗапроса);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ИнформацияПолучитьСоответствияСтроки(ПараметрыЗапроса)
	
	УстановитьПривилегированныйРежим(Истина);
		
	Если НЕ Объект.АртикулРасположенВНаименованииИмпорт Тогда
		ТаблицаРезультата = ВыполнитьПоискСоответствийПоСтроке(ПараметрыЗапроса);
	Иначе
		ТаблицаРезультата = ВыполнитьПоискВАртикуле1С(ПараметрыЗапроса);
	КонецЕсли;
	
	Если ТаблицаРезультата = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаСовпадений = РеквизитФормыВЗначение("Соответствия");

	МассивКлючевыхСлов = глРазложитьСтрокуВМассивПодстрок(ПараметрыЗапроса.КлючевыеСлова," ");
	МассивКлючевыхСлов = глМассивПеревестиСловаВРег(МассивКлючевыхСлов);
	КоличествоКлючевыхСлов = МассивКлючевыхСлов.Количество();
	
	Для Каждого СтрРез Из ТаблицаРезультата Цикл
		НовСтр = ТаблицаСовпадений.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр,СтрРез);
	КонецЦикла;
	
	ТаблицаСовпадений.Сортировать("Совпадения УБЫВ");
	ЗначениеВРеквизитФормы(ТаблицаСовпадений, "Соответствия");

КонецПроцедуры

//============================================================================
// ОБРАБОТКА

&НаКлиенте
Процедура КомандаОбновитьКлючевыеСлова(Элемент)
	
	КомандаЗаполнитьКлючевыеСлова("");
	
КонецПроцедуры


//============================================================================
// ЗАПИСАТЬ СООТВЕТСТВИЯ

&НаСервере
Процедура ЗаписатьСоответствияСервер()
	
	РеквизитФормыВЗначение("Объект").мЗаписатьСоответствияНоменклатуры(Объект.ПоискСоответствий);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьСоответствия(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ПрайсПартнера) Тогда
		Сообщить("Не указан Партнер!");
		Возврат;
	КонецЕсли;

	ЗаписатьСоответствияСервер();
	
	Состояние("Обработка завершена");

КонецПроцедуры

//============================================================================
// АЛГОРИТМЫ ОБРАБОТКИ  

&НаКлиенте
Процедура АлгоритмПроверить(Команда)
	Значение = АлгоритмЗначение;
	Выполнить(Алгоритм);
	АлгоритмРезультат = Значение;
КонецПроцедуры

&НаСервере
Функция ВыполнитьОбработкуАлгоритмыКлючевыхСлов(Знач Значение)
	
	Если Объект.АлгоритмыКлючевыхСлов.Количество() = 0 Тогда
		Возврат Значение;
	КОнецЕсли;
	
	// найти значение представления для поля
	ЗначениеИсходное = Значение;
	
	Для Каждого ТекАлгоритм Из Объект.АлгоритмыКлючевыхСлов Цикл
		Если ТекАлгоритм.Пометка = Ложь Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			//Значение = Вычислить(ТекАлгоритм.ТекстАлгоритма);
			Выполнить(ТекАлгоритм.ТекстАлгоритма);
		Исключение
			Сообщить("Ошибка Алгоритм["+ТекАлгоритм.НомерСтроки+"] Значение=["+ЗначениеИсходное+"]: "+ОписаниеОшибки());
		КонецПопытки;
	КонецЦИкла;
	
	Возврат Значение;
	
КонецФункции

&НаКлиенте
Процедура АлгоритмыОбработкиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.АлгоритмыОбработки.ТекущиеДанные <> Неопределено Тогда
		Алгоритм = Элементы.АлгоритмыОбработки.ТекущиеДанные.ТекстАлгоритма;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АлгоритмыКлючевыхСловПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	АлгоритмыОбработкиПриАктивизацииСтроки(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АлгоритмПриИзменении(Элемент)
	
	Если Элементы.АлгоритмыОбработки.ТекущиеДанные <> Неопределено Тогда
		Элементы.АлгоритмыОбработки.ТекущиеДанные.ТекстАлгоритма = Алгоритм;
	КонецЕсли;

КонецПроцедуры











