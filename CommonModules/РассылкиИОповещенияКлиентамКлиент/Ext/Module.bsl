﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Рассылки и оповещения клиентам".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//  Содержит общие клиентские процедуры и функции при работе с функционалом
//  рассылок и оповещений клиентов.
//

#Область СлужебныйПрограммныйИнтерфейс

// Интерактивное добавление вложения электронного письма.
//
// Параметры:
//  Форма  - УправляемаяФорма - форма, в которой выполняется добавление вложения.
//
Процедура ДобавитьВложениеВыполнить(Форма) Экспорт
	
	#Если Не ВебКлиент Тогда
		
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.МножественныйВыбор = Истина;
		Если Не Диалог.Выбрать() Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого ВыбранныйФайл Из Диалог.ВыбранныеФайлы Цикл
			НоваяСтрока = Форма.Вложения.Добавить();
			НоваяСтрока.Расположение = 2;
			НоваяСтрока.ИмяФайлаНаКомпьютере = ВыбранныйФайл;

			ИмяФайла   = "";
			Расширение = "";
			ВзаимодействияКлиентСервер.ПолучитьКаталогИИмяФайла(ВыбранныйФайл, "", ИмяФайла);
			НоваяСтрока.ИмяФайла = ИмяФайла;

			Расширение                      = ВзаимодействияКлиентСервер.РасширениеФайла(ИмяФайла);
			НоваяСтрока.ИндексКартинки      = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
			Файл                            = Новый Файл(ВыбранныйФайл);
			НоваяСтрока.Размер              = Файл.Размер();
			НоваяСтрока.РазмерПредставление = ВзаимодействияКлиентСервер.ПолучитьСтроковоеПредставлениеРазмераФайла(НоваяСтрока.Размер);
			
			Форма.Модифицированность = Истина;
			
		КонецЦикла;
		
	#Иначе

		ОписаниеОповещенияОкончаниеПомещения = Новый ОписаниеОповещения("ДобавитьВложениеВыполнитьЗавершение",
		                                                                ЭтотОбъект, Новый Структура("Форма", Форма));
		НачатьПомещениеФайла(ОписаниеОповещенияОкончаниеПомещения, "", "", Истина, Форма.УникальныйИдентификатор);
		Возврат;
		
	#КонецЕсли
	
КонецПроцедуры

Процедура ДобавитьВложениеВыполнитьЗавершение(Результат, Адрес, ВыбранныйФайл, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = Форма.Вложения.Добавить();
	НоваяСтрока.Расположение = 4;
	НоваяСтрока.ИмяФайлаНаКомпьютере = Адрес;
	НоваяСтрока.ИмяФайла = ВыбранныйФайл;
	
	Расширение = ВзаимодействияКлиентСервер.РасширениеФайла(ВыбранныйФайл);
	НоваяСтрока.ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
	
	Форма.Модифицированность = Истина;
	Форма.ОбновитьОтображениеДанных();
	
КонецПроцедуры

// Открытие файла, размещенного в таблице Вложений.
//
// Параметры:
//  Форма  - УправляемаяФорма - форма, в которой выполняется действие.
//
Процедура ОткрытьВложениеВыполнить(Форма) Экспорт
	
	ТекДанные = Форма.Элементы.Вложения.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (ТекДанные.Расположение = 0) Тогда
		
		РаботаСФайламиКлиент.ОткрытьФайл(
			РаботаСФайламиКлиент.ДанныеФайла(ТекДанные.Ссылка, Форма.УникальныйИдентификатор), Ложь);
		
	ИначеЕсли текДанные.Расположение = 2 Тогда
		
		ПутьКФайлу = ТекДанные.ИмяФайлаНаКомпьютере;
		#Если Не ВебКлиент Тогда
			ЗапуститьПриложение("""" + ПутьКФайлу + """");
		#Иначе
			ПолучитьФайл(ПутьКФайлу, ТекДанные.ИмяФайла, Истина);
		#КонецЕсли
		
	ИначеЕсли текДанные.Расположение = 4 Тогда
		
		ПутьКФайлу = ТекДанные.ИмяФайлаНаКомпьютере;
		#Если Не ВебКлиент Тогда
			ПолучитьФайл(ПутьКФайлу, ТекДанные.ИмяФайла, Ложь);
		#Иначе
			ПолучитьФайл(ПутьКФайлу, ТекДанные.ИмяФайла, Истина);
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

// Помещает файлы, расположенные в таблице Вложения во временное хранилище.
//
// Параметры:
//  Вложения  - ТаблицаЗначений - таблица, содержащая вложения.
//
Процедура ПоместитьВложенияВоВременноеХранилище(Вложения) Экспорт
	
	#Если Не ВебКлиент Тогда
	Для Каждого СтрокаТаблицыВложений Из Вложения Цикл
		Если СтрокаТаблицыВложений.Расположение = 2 Тогда
			Данные = Новый ДвоичныеДанные(СтрокаТаблицыВложений.ИмяФайлаНаКомпьютере);
			СтрокаТаблицыВложений.ИмяФайлаНаКомпьютере = ПоместитьВоВременноеХранилище(Данные, "");
			СтрокаТаблицыВложений.Расположение = 4;
		КонецЕсли;
	КонецЦикла;
	#КонецЕсли
	
КонецПроцедуры

// Обрабатывает перетаскивание одного или нескольких файлов в таблицу вложений.
//
// Параметры:
//  Вложения  - ТаблицаЗначений - таблица, содержащая вложения.
//  ПараметрыПеретаскивания  - ПараметрыПеретаскивания - параметры операции перетаскивания.
//
Процедура ОбработатьПеретаскиваниеВложения(Вложения, ПараметрыПеретаскивания) Экспорт
	
#Если Не ВебКлиент Тогда
    
    // Инструкция препроцессора нужна для того, чтобы платформенная проверка конфигурации
    // не находила синхронные методы работоы с файлами. В веб клиенте данная процедура все равно
    // не вызывается из-за особенностей перетаскивания файлов в браузере.
    
	МассивИменФайлов = Новый Массив;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл")
		И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Истина Тогда
		
		МассивИменФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1
			И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
			
			Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
				Если ТипЗнч(ФайлПринятый) = Тип("Файл") И ФайлПринятый.ЭтоФайл() Тогда
					МассивИменФайлов.Добавить(ФайлПринятый.ПолноеИмя);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ВыбранныйФайл Из МассивИменФайлов Цикл
			
			НоваяСтрока = Вложения.Добавить();
			НоваяСтрока.Расположение = 2;
			НоваяСтрока.ИмяФайлаНаКомпьютере = ВыбранныйФайл;
			
			ИмяФайла   = "";
			Расширение = "";
			ВзаимодействияКлиентСервер.ПолучитьКаталогИИмяФайла(ВыбранныйФайл, "", ИмяФайла);
			НоваяСтрока.ИмяФайла = ИмяФайла;
			
			Расширение                      = ВзаимодействияКлиентСервер.РасширениеФайла(ИмяФайла);
			НоваяСтрока.ИндексКартинки      = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
			Файл                            = Новый Файл(ВыбранныйФайл);
			НоваяСтрока.Размер              = Файл.Размер();
			НоваяСтрока.РазмерПредставление = ВзаимодействияКлиентСервер.ПолучитьСтроковоеПредставлениеРазмераФайла(НоваяСтрока.Размер);
	
	КонецЦикла;
    
#КонецЕсли

КонецПроцедуры

// Удаляет файл из таблицы Вложения и перемещает в массив вложений к удалению.
//
// Параметры:
//  Форма  - УправляемаяФорма - форма, в которой выполняется действие.
//
Процедура ПереместитьВложениеВУдаленные(Форма) Экспорт

	ТекущиеДанные = Форма.Элементы.Вложения.ТекущиеДанные;
	Если (ТекущиеДанные <> Неопределено)  Тогда
		Если ТекущиеДанные.Расположение = 0 Тогда
			Форма.УдаленныеВложения.Добавить(ТекущиеДанные.Ссылка);
		КонецЕсли;
		Индекс = Форма.Вложения.Индекс(ТекущиеДанные);
		Форма.Вложения.Удалить(Индекс);
		Форма.ОбновитьОтображениеДанных();
		Форма.Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

// Открывает форму подписки для подписчика и группы рассылок и оповещений.
//
// Параметры:
//  Подписчик                  - СправочникСсылка.Партнеры - подписчик, для которого необходимо открыть подписку.
//  ГруппаРассылокИОповещений  - СправочникСсылка.ГруппыРассылокИОповещений - группа, для которой необходимо открыть подписку.
//  Форма                      - УправляемаяФорма - форма, в которой выполняется действие.
//
Процедура ОткрытьФормуПодписки(Подписчик, ГруппаРассылокИОповещений, Форма) Экспорт
	
	Подписка = РассылкиИОповещенияКлиентамВызовСервера.ПодпискаДляПодписчика(Подписчик, ГруппаРассылокИОповещений);
	РедактироватьПодписку(Подписка, Подписчик, ГруппаРассылокИОповещений, Форма);
	
КонецПроцедуры

// Открывает форму подписки.
//
// Параметры:
//  Подписка                   - СправочникСсылка.ПодпискиНаРассылкиИОповещенияКлиентам - отркываемая подписка.
//  Подписчик                  - СправочникСсылка.Партнеры - подписчик.
//  ГруппаРассылокИОповещений  - СправочникСсылка.ГруппыРассылокИОповещений - группа.
//  Форма                      - УправляемаяФорма - форма, в которой выполняется действие.
//  Действует                  - Булево - признак того, что подписка действует.
//
Процедура РедактироватьПодписку(Подписка, Подписчик, ГруппаРассылокИОповещений, Форма, Действует = Истина) Экспорт

	Если Подписка.Пустая() Тогда
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Владелец", Подписчик);
		ЗначенияЗаполнения.Вставить("ГруппаРассылокИОповещений", ГруппаРассылокИОповещений);
		ЗначенияЗаполнения.Вставить("ПодпискаДействует", Действует);
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
	Иначе
		
		ПараметрыФормы = Новый Структура("Ключ", Подписка);
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.ФормаОбъекта",
	             ПараметрыФормы,
	             Форма);

КонецПроцедуры

// Формирует параметры формы подбора партнеров по отбору.
//
// Параметры:
//  Форма  - УправляемаяФорма - форма, из которой вызывается подбор.
//
// Возвращаемое значение:
//   Структура   - сформированные параметры формы подбора.
//
Функция ПараметрыФормыПодбораПоОтбору(Форма) Экспорт

	ЗаголовокФормыПодбора = НСтр("ru='Подбор подписчиков для группы рассылок и оповещений'");
	ЗаголовокКнопкиПеренестиФормыПодбора = НСтр("ru='Перенести в подписку'");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",                               ЗаголовокФормыПодбора);
	ПараметрыФормы.Вставить("ЗаголовокКнопкиПеренести",                ЗаголовокКнопкиПеренестиФормыПодбора);
	ПараметрыФормы.Вставить("УникальныйИдентификатор",                 Форма.УникальныйИдентификатор);
	ПараметрыФормы.Вставить("ПредназначенаДляSMS",                     Форма.ПредназначенаДляSMS);
	ПараметрыФормы.Вставить("ПредназначенаДляЭлектронныхПисем",        Форма.ПредназначенаДляЭлектронныхПисем);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформацииПартнераДляПисем", Форма.ВидКонтактнойИнформацииПартнераДляПисем);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформацииПартнераДляSMS",   Форма.ВидКонтактнойИнформацииПартнераДляSMS);
	
	Возврат ПараметрыФормы;

КонецФункции

// Обработчик команды настройки подписки на оповещения из объекта.
//
// Параметры:
//  Партнер     - СправочникСсылка.Партнеры - партнер, для которого будет настраиваться подписка.
//  ТипСобытия  - Массив, ПеречисленияСсылка.ТипыСобытийОповещений - типы событий, для которых оформляется подписка.
//
Процедура НастроитьПодпискуНаОповещенияИзОбъекта(Партнер, ТипСобытия) Экспорт

	МассивДоступныхГруппОповещений = РассылкиИОповещенияКлиентамВызовСервера.ДоступныеГруппыОповещенийПоТипуСобытия(ТипСобытия);
	СписокДоступныхГруппОповещений = Новый СписокЗначений();
	СписокДоступныхГруппОповещений.ЗагрузитьЗначения(МассивДоступныхГруппОповещений);
	КоличествоДоступныхГруппОповещений = МассивДоступныхГруппОповещений.Количество();
	
	Если КоличествоДоступныхГруппОповещений = 1 Тогда
		
		ЗначенияЗаполнения = Новый Структура();
		ЗначенияЗаполнения.Вставить("Владелец", Партнер);
		ЗначенияЗаполнения.Вставить("ГруппаРассылокИОповещений", МассивДоступныхГруппОповещений[0]);
		ЗначенияЗаполнения.Вставить("ПодпискаДействует", Истина);
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.ФормаОбъекта", ПараметрыФормы);
		
	ИначеЕсли КоличествоДоступныхГруппОповещений > 1 Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Подписчик", Партнер);
		ПараметрыФормы.Вставить("ГруппыРассылокИОповещений", СписокДоступныхГруппОповещений);
		
		ОткрытьФорму("Справочник.ПодпискиНаРассылкиИОповещенияКлиентам.Форма.ФормаСпискаОтПодписчика", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
