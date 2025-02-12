﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗапретИзмененияДрайвера = (Объект.Ссылка <> Справочники.ПодключаемоеОборудование.ПустаяСсылка());
	// Защита от изменения типа устройства если тип явно задан или экземпляр уже создан.
	Элементы.ТипОборудования.ТолькоПросмотр = ЗапретИзмененияДрайвера;
	// Защита от изменения обработчика драйвера уже созданного экземпляра устройства.
	Элементы.ДрайверОборудования.ТолькоПросмотр = ЗапретИзмененияДрайвера;
	Элементы.ФормаНастроить.Доступность = ЗначениеЗаполнено(Объект.Ссылка); 
	Элементы.СервисФискальногоНакопителя.Видимость = ЗначениеЗаполнено(Объект.Ссылка); 
	
	// Возвращает флаг возможности использовать драйверов снятых с поддержки.
	ИспользоватьСнятыеСПоддержкиДрайвера = МенеджерОборудованияВызовСервераПереопределяемый.ВозможностьИспользоватьСнятыхСПоддержкиДрайверов();
	
	// Загрузка и установка списка доступных обработок.
	СписокДрайверов = ДрайвераПоТипуОборудования(Объект.ТипОборудования, НЕ ЗапретИзмененияДрайвера);
	Элементы.ДрайверОборудования.СписокВыбора.Очистить();
	
	ТипWebСервисОборудование = Перечисления.ТипыПодключаемогоОборудования.WebСервисОборудование;
	ТипККТОборудование       = Перечисления.ТипыПодключаемогоОборудования.ККТ;
	ТипФРОборудование        = Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор;
	ТипПЧОборудование        = Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков;
	
	Для каждого СтрокаСписка Из СписокДрайверов Цикл
		
		Если СтрокаСписка.Значение = ТипWebСервисОборудование Тогда
			Продолжить;
		КонецЕсли;
		
		Элементы.ДрайверОборудования.СписокВыбора.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
	КонецЦикла;

	// Перечисление стандартных типов.
	Для каждого ИмяПеречисления Из Метаданные.Перечисления.ТипыПодключаемогоОборудования.ЗначенияПеречисления Цикл
		СоответствиеТиповОборудования.Добавить(ИмяПеречисления.Синоним, ИмяПеречисления.Комментарий);
	КонецЦикла;
	
	ОрганизацияВидимость = Объект.ТипОборудования = ТипККТОборудование
						ИЛИ Объект.ТипОборудования = ТипФРОборудование
						ИЛИ Объект.ТипОборудования = ТипПЧОборудование;
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриСозданииНаСервере(Объект, ЭтотОбъект, Отказ, Параметры, СтандартнаяОбработка);
	
	УстановитьВидимостьОрганизацииНаСервере();
	
	Если Объект.ТипОборудования = ТипWebСервисОборудование Тогда
		Элементы.ТипОборудования.ТолькоПросмотр = Истина;
		Элементы.ДрайверОборудования.Видимость = Ложь;
		Элементы.РабочееМесто.Видимость = Ложь;
	Иначе
		Элементы.ИдентификаторWebСервисОборудования.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаПараметрыРегистрацииККТ.Видимость = Объект.ТипОборудования = ТипККТОборудование;
	Элементы.СервисФискальногоНакопителя.Видимость = Объект.ТипОборудования = ТипККТОборудование;
	
	Если Объект.ТипОборудования = ТипККТОборудование Тогда
		ОбновитьПараметрыРегистрацииККТ();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПриОткрытии(Объект, ЭтотОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПередЗакрытием(Объект, ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Элементы.ФормаНастроить.Доступность = ЗначениеЗаполнено(Объект.Ссылка); 
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриЧтенииНаСервере(ТекущийОбъект,ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Отказ И Модифицированность Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПередЗаписью(Объект, ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПослеЗаписи(Объект, ЭтотОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияОбработкаПроверкиЗаполненияНаСервере(Объект, ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОборудованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Объект.ТипОборудования <> ВыбранноеЗначение Тогда
		Объект.ТипОборудования = ВыбранноеЗначение;
		Модифицированность = Истина;

		// Загрузка и установка списка доступных обработок.
		СписокДрайверов = ДрайвераПоТипуОборудования(Объект.ТипОборудования, НЕ ЗапретИзмененияДрайвера);
		Элементы.ДрайверОборудования.СписокВыбора.Очистить();
		Для каждого СтрокаСписка Из СписокДрайверов Цикл
			Элементы.ДрайверОборудования.СписокВыбора.Добавить(СтрокаСписка.Значение, СтрокаСписка.Представление);
		КонецЦикла;
		
		Объект.ДрайверОборудования = ПредопределенноеЗначение("Справочник.ДрайверыОборудования.ПустаяСсылка");
		Объект.Наименование = "";
		
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	
	ОрганизацияВидимость = Объект.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККТ")
						ИЛИ Объект.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ФискальныйРегистратор")
						ИЛИ Объект.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ПринтерЧеков");
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияТипОборудованияВыбор(Объект, ЭтотОбъект, ЭтотОбъект, Элемент, ВыбранноеЗначение);
	
	УстановитьВидимостьОрганизацииНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДрайверОборудованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение <> Объект.ДрайверОборудования Тогда
		ОбработатьВыборОбработчика(ВыбранноеЗначение, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработатьВыборОбработчика(ВыбранныйОбработчик, СтандартнаяОбработка = Истина)

	Объект.Наименование = "'" + Строка(ВыбранныйОбработчик) + "'"
						+ ?(ПустаяСтрока(Строка(Объект.РабочееМесто)),
							"",
							" " + НСтр("ru='на'") + " " + Строка(Объект.РабочееМесто));

КонецПроцедуры

&НаКлиенте
Процедура Настроить(Команда)
	
	ОчиститьСообщения();
	
	НастроитьПодключаемоеОборудование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьПараметрыРегистрацииККТ();
	
	Для Каждого ПараметрРегистрации Из Объект.ПараметрыРегистрации Цикл
		
		Параметр = ПараметрыРегистрацииККТ.Добавить();
		НаименованиеПараметра = ПараметрРегистрации.НаименованиеПараметра;
		ЗначениеПараметра     = ПараметрРегистрации.ЗначениеПараметра;
		
		Если НаименованиеПараметра = "РегистрационныйНомерККТ" Тогда
			НаименованиеПараметра = НСтр("ru='Регистрационный номер ККТ'")
		ИначеЕсли НаименованиеПараметра = "ОрганизацияНазвание" Тогда
			НаименованиеПараметра = НСтр("ru='Название организации'")
		ИначеЕсли НаименованиеПараметра = "ОрганизацияИНН" Тогда
			НаименованиеПараметра = НСтр("ru='ИНН организации'")
		ИначеЕсли НаименованиеПараметра = "АдресУстановкиККТ" Тогда
			НаименованиеПараметра = НСтр("ru='Адрес установки ККТ'")
		ИначеЕсли НаименованиеПараметра = "КодыСистемыНалогообложения" Тогда
			НаименованиеПараметра = НСтр("ru='Системы налогообложения'");
			СистемыНалогообложения = СтрРазделить(ЗначениеПараметра, ",");
			ЗначениеПараметра = "";
			Для Каждого СистемаНалогообложения Из СистемыНалогообложения Цикл
				ЗначениеПараметра = ?(Не ПустаяСтрока(ЗначениеПараметра), ЗначениеПараметра + ",", "");
				Если Не ПустаяСтрока(СистемаНалогообложения) Тогда
					ЗначениеПараметра = ЗначениеПараметра + """"+ МенеджерОборудованияКлиентСервер.ПолучитьНаименованиеСистемыНалогообложения(Число(СистемаНалогообложения)) + """";
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли НаименованиеПараметра = "ПризнакАвтономногоРежима" Тогда
			НаименованиеПараметра = НСтр("ru='Автономный режим'")
		ИначеЕсли НаименованиеПараметра = "ПризнакАвтоматическогоРежима" Тогда
			НаименованиеПараметра = НСтр("ru='Автоматический режим'")
		ИначеЕсли НаименованиеПараметра = "НомерАвтоматаДляАвтоматическогоРежима" Тогда
			НаименованиеПараметра = НСтр("ru='Номер автомата для автоматического режима'")
		ИначеЕсли НаименованиеПараметра = "ПризнакШифрованиеДанных" Тогда
			НаименованиеПараметра = НСтр("ru='Шифрование данных'")
		ИначеЕсли НаименованиеПараметра = "ПризнакРасчетовЗаУслуги" Тогда
			НаименованиеПараметра = НСтр("ru='Расчет за услуги'")
		ИначеЕсли НаименованиеПараметра = "ПризнакФормированияТолькоБСО" Тогда
			НаименованиеПараметра = НСтр("ru='Формирования только БСО'")
		ИначеЕсли НаименованиеПараметра = "ПризнакРасчетовТолькоВИнтернет" Тогда
			НаименованиеПараметра = НСтр("ru='Расчет только в интернет'")
		ИначеЕсли НаименованиеПараметра = "ОрганизацияОФДИНН" Тогда
			НаименованиеПараметра = НСтр("ru='ОФД ИНН'")
		ИначеЕсли НаименованиеПараметра = "ОрганизацияОФДНазвание" Тогда
			НаименованиеПараметра = НСтр("ru='Наименование ОФД'")
		ИначеЕсли НаименованиеПараметра = "ЗаводскойНомерККТ" Тогда
			НаименованиеПараметра = НСтр("ru='Заводской номер ККТ'")
		ИначеЕсли НаименованиеПараметра = "ПризнакФискализации" Тогда
			НаименованиеПараметра = НСтр("ru='Признак фискализации'")
		ИначеЕсли НаименованиеПараметра = "ЗаводскойНомерФН" Тогда
			НаименованиеПараметра = НСтр("ru='Заводской номер ФН'")
		ИначеЕсли НаименованиеПараметра = "НомерДокументаФискализации" Тогда
			НаименованиеПараметра = НСтр("ru='Номер документа фискализации'")
		ИначеЕсли НаименованиеПараметра = "ДатаВремяФискализации" Тогда
			НаименованиеПараметра = НСтр("ru='Дата и время фискализации'")
		ИначеЕсли НаименованиеПараметра = "ВерсияФФДККТ" Тогда
			НаименованиеПараметра = НСтр("ru='Версия ФФД ККТ'")
		ИначеЕсли НаименованиеПараметра = "ВерсияФФДФН" Тогда
			НаименованиеПараметра = НСтр("ru='Версия ФФД ФН'")
		// ФФД 1.0.5 и ФФД  1.1
		ИначеЕсли НаименованиеПараметра = "МестоПроведенияРасчетов" Тогда
			НаименованиеПараметра = НСтр("ru='Место проведения расчетов'")
		ИначеЕсли НаименованиеПараметра = "ПродажаПодакцизногоТовара" Тогда
			НаименованиеПараметра = НСтр("ru='Продажа подакцизного товара'")
		ИначеЕсли НаименованиеПараметра = "ПроведенияАзартныхИгр" Тогда
			НаименованиеПараметра = НСтр("ru='Проведения азартных игр'")
		ИначеЕсли НаименованиеПараметра = "ПроведенияЛотерей" Тогда
			НаименованиеПараметра = НСтр("ru='Проведения лотерей'")
		ИначеЕсли НаименованиеПараметра = "ПризнакиАгента" Тогда
			НаименованиеПараметра = НСтр("ru='Признаки агента'")
		ИначеЕсли НаименованиеПараметра = "УстановкаПринтераВАвтомате" Тогда
			НаименованиеПараметра = НСтр("ru='Установка принтера в автомате'")
		КонецЕсли;
			
		Параметр.НаименованиеПараметра = НаименованиеПараметра;
		Параметр.ЗначениеПараметра     = ЗначениеПараметра;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодключаемоеОборудование()
	
	СообщениеОбОшибке = "";
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	Закрыть();
	
	МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Функция ДрайвераПоТипуОборудования(ТипОборудования, ТолькоДоступные)
	
	СписокДрайверов = Новый СписокЗначений();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДрайверыОборудования.Ссылка,
		|	ДрайверыОборудования.Наименование,
		|	ДрайверыОборудования.ТипОборудования
		|ИЗ
		|	Справочник.ДрайверыОборудования КАК ДрайверыОборудования
		|ГДЕ
		|	(ДрайверыОборудования.ТипОборудования = &ТипОборудования)
		|	%УСЛОВИЕ1%
		|	%УСЛОВИЕ2%
		|УПОРЯДОЧИТЬ ПО ДрайверыОборудования.Наименование";
		
	Если ТолькоДоступные Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УСЛОВИЕ1%", "И НЕ ДрайверыОборудования.ПометкаУдаления");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УСЛОВИЕ1%", "");
	КонецЕсли;
	
	Если НЕ ИспользоватьСнятыеСПоддержкиДрайвера Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УСЛОВИЕ2%", "И НЕ ДрайверыОборудования.СнятСПоддержки");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%УСЛОВИЕ2%", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТипОборудования", ТипОборудования);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СписокДрайверов.Добавить(ВыборкаДетальныеЗаписи.Ссылка, ВыборкаДетальныеЗаписи.Наименование);
	КонецЦикла;
	
	Возврат СписокДрайверов;

КонецФункции

&НаКлиенте
Процедура ОперацияФискальногоНакопителя_Завершение(РезультатВыполнения, Параметры) Экспорт
	
	ОчиститьСообщения();
	
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru='Операция завершена.'");
	Иначе
		ТекстСообщения = РезультатВыполнения.ОписаниеОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияФискальногоНакопителя_Продолжить(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения <> Неопределено И Тип(РезультатВыполнения) = Тип("Структура") Тогда
		ФискальноеУстройство = Объект.Ссылка;
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияФискальногоНакопителя_Завершение", ЭтотОбъект);
		МенеджерОборудованияКлиент.НачатьОперациюФНДляФискальногоУстройства(ОповещениеПриЗавершении, УникальныйИдентификатор, РезультатВыполнения, ФискальноеУстройство); 
	КонецЕсли;
	
	ЭтотОбъект.Прочитать();
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияФискальногоНакопителя(Команда)
	
	ФискальноеУстройство = Объект.Ссылка;
	Если Не ЗначениеЗаполнено(ФискальноеУстройство) Тогда
		Возврат;
	КонецЕсли;               
	
	ПараметрыОперации = Новый Структура("ФискальноеУстройство, Организация, ТипОперации", ФискальноеУстройство, Объект.Организация, 1);
	Обработчик = Новый ОписаниеОповещения("ОперацияФискальногоНакопителя_Продолжить", ЭтотОбъект);
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.Форма.ПараметрыФискализации", ПараметрыОперации,,,,,Обработчик, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеПараметровРегистрацииФискальногоНакопителя(Команда)
	
	ФискальноеУстройство = Объект.Ссылка;
	Если Не ЗначениеЗаполнено(ФискальноеУстройство) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОперации = Новый Структура("ФискальноеУстройство, ТипОперации", ФискальноеУстройство, 2);
	Обработчик = Новый ОписаниеОповещения("ОперацияФискальногоНакопителя_Продолжить", ЭтотОбъект);
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.Форма.ПараметрыФискализации", ПараметрыОперации,,,,,Обработчик, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеФискальногоНакопителя(Команда)
	
	ФискальноеУстройство = Объект.Ссылка;
	Если Не ЗначениеЗаполнено(ФискальноеУстройство) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОперации = Новый Структура("ФискальноеУстройство, ТипОперации", ФискальноеУстройство, 3);
	Обработчик = Новый ОписаниеОповещения("ОперацияФискальногоНакопителя_Продолжить", ЭтотОбъект);
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.Форма.ПараметрыФискализации", ПараметрыОперации,,,,,Обработчик, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьОрганизацииНаКлиенте()
	
	Элементы.Организация.Видимость = ОрганизацияВидимость;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОрганизацииНаСервере()
	
	Элементы.Организация.Видимость = ОрганизацияВидимость;
	
КонецПроцедуры

#КонецОбласти
