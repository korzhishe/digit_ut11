﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ЕдиницаВеса   = Константы.ЕдиницаИзмеренияВеса.Получить();
	ЕдиницаОбъема = Константы.ЕдиницаИзмеренияОбъема.Получить();
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	ВладелецПомещениеПриИзмененииСервер();	
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьПоОбъемуПриИзменении(Элемент)
	Элементы.ОграничениеПоОбъему.Доступность = Объект.ОграничиватьПоОбъему;
	Объект.ОграничениеПоОбъему               = 0;
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьПоВесуПриИзменении(Элемент)
	Элементы.ОграничениеПоВесу.Доступность = Объект.ОграничиватьПоВесу;
	Объект.ОграничениеПоВесу               = 0;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)

	Если Не Объект.Ссылка.Пустая() Тогда
		Результат = Неопределено;

		ОткрытьФорму("Справочник.РабочиеУчастки.Форма.РазблокированиеРеквизитов",,,,,, Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
        
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСкрытьВстроеннуюСправку(Команда)
	
	ОтобразитьСкрытьВстроеннуюСправкуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ВладелецПомещениеПриИзмененииСервер()
	
	ИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Объект.Владелец, Объект.Помещение);

	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад",Объект.Владелец));
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	// Получить значения функциональных опций.
	ИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Объект.Владелец, Объект.Помещение);
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад",Объект.Владелец));
	
	Элементы.ОграничениеПоОбъему.Доступность = Объект.ОграничиватьПоОбъему;
	Элементы.ОграничениеПоВесу.Доступность = Объект.ОграничиватьПоВесу;
	
	// Признак отображения встроенной справки.
	ОтображатьВстроеннуюСправку = Истина;
	
	НастройкиФормы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("РабочиеУчастки_ФормаЭлемента_НастройкиФормы", "");
	
	Если Не (НастройкиФормы = Неопределено) Тогда
		
		Если НастройкиФормы.Свойство("ОтображатьВстроеннуюСправку") Тогда
			ОтображатьВстроеннуюСправку = НастройкиФормы.ОтображатьВстроеннуюСправку;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ФормаОтобразитьСкрытьВстроеннуюСправку.Пометка = ОтображатьВстроеннуюСправку;
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	// Порядок обработки складского задания.
	Элементы.ПорядокОбработкиСкладскихЗаданий.Видимость = ИспользоватьАдресноеХранение;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"ОграничиватьПоВесу,ОграничиватьПоОбъему,ОграничениеПоВесу,ОграничениеПоОбъему,ЕдиницаВеса,ЕдиницаОбъема",
		"Видимость", ИспользоватьАдресноеХранение);
	
	// Видимость элементов встроенной справки.
	ЭлементыВстроеннойСправки = ЭлементыВстроеннойСправки();
	
	Для каждого ЭлементСправки Из ЭлементыВстроеннойСправки Цикл
		Элементы[ЭлементСправки.ИмяЭлемента].Видимость = ЭлементСправки.Видимость;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьСкрытьВстроеннуюСправкуНаСервере()
	
	Элементы.ФормаОтобразитьСкрытьВстроеннуюСправку.Пометка = Не Элементы.ФормаОтобразитьСкрытьВстроеннуюСправку.Пометка;
	ОтображатьВстроеннуюСправку = Элементы.ФормаОтобразитьСкрытьВстроеннуюСправку.Пометка;
	
	УстановитьВидимость();
	СохранитьНастройкиФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ЭлементыВстроеннойСправки()
	
	Результат = Новый Массив;
	
	Результат.Добавить(Новый Структура("ИмяЭлемента, Видимость", 
		"НадписьПодсказкаПоПорядкуОбработкиСкладскогоЗадания", ОтображатьВстроеннуюСправку И ИспользоватьАдресноеХранение));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СохранитьНастройкиФормыНаСервере()
	
	НастройкиФормы = Новый Структура;
	НастройкиФормы.Вставить("ОтображатьВстроеннуюСправку", ОтображатьВстроеннуюСправку);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("РабочиеУчастки_ФормаЭлемента_НастройкиФормы", "",
		НастройкиФормы);
	
КонецПроцедуры


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	ВладелецПомещениеПриИзмененииСервер();
КонецПроцедуры

#КонецОбласти

#КонецОбласти
