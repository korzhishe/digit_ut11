﻿
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ОбщегоНазначенияУТПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы 				 = Новый Структура;
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПодразделения");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьСделкиСКлиентами");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьНесколькоОрганизаций");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия", 				 ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	РежимРаботы.Вставить("ВозможнаНастройкаРасписания",  НЕ ОбщегоНазначения.РазделениеВключено() И Пользователи.ЭтоПолноправныйПользователь(, Истина));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ФормироватьУправленческийБаланс = НаборКонстант.ФормироватьУправленческийБаланс;
	
	РегламентноеЗадание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.РасчетСебестоимости);
	РассчитыватьПредварительнуюСебестоимостьИдентификатор = РегламентныеЗаданияСервер.УникальныйИдентификатор(РегламентноеЗадание);
	РассчитыватьПредварительнуюСебестоимостьИспользование = РегламентноеЗадание.Использование;
	РассчитыватьПредварительнуюСебестоимостьРасписание    = РегламентноеЗадание.Расписание;
	
	// Настройки видимости при запуске
	Элементы.ГруппаИспользоватьМониторингЦелевыхПоказателейПраво.Видимость = НЕ РежимРаботы.БазоваяВерсия;
	Элементы.НастройкаРасписанияРегламентногоЗаданияПредварительногоРасчетаСебестоимости.Видимость =
		РежимРаботы.ВозможнаНастройкаРасписания;
		
	НачалоВеденияУправленческогоУчетаОрганизаций =
		?(ЗначениеЗаполнено(НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций), 0, 1);
	
	// Настройки партионного учета
	ПериодДвиженийПУ22 			= ПартионныйУчетСервер.ПериодПервыхДвиженийПартионныйУчетВерсии22();
	ПериодДвиженийСебестоимости = ПартионныйУчетСервер.ПериодПервыхДвиженийРегистраСебестоимость();
	
	НастройкиПартионногоУчета();
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
		ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
		Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	ИначеЕсли (ТипЗнч(Источник) = Тип("Строка")
		И Найти(Источник, "ИспользоватьУправлениеПроизводством2_2") > 0) Тогда
		
		ЭтаФорма.Прочитать();
		НастройкиПартионногоУчета();
		УстановитьДоступность();
		
	ИначеЕсли Источник = "ФормироватьУправленческийБаланс" И Параметр = "ОбновитьИнтерфейс" Тогда
		ЭтаФорма.Прочитать();
		ОбновитьПовторноИспользуемыеЗначения();
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьРаздельныйУчетПоНалогообложениюПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьГруппыФинансовогоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьСебестоимостьТоваровПоВидамЗапасовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	ПровестиДокументыПоРегиструСебестоимостьТоваров();
КонецПроцедуры

&НаКлиенте
Процедура РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданиемПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);

	РассчитыватьПредварительнуюСебестоимостьИспользование = НаборКонстант.РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданием;
	
	Если РассчитыватьПредварительнуюСебестоимостьИспользование И РежимРаботы.ВозможнаНастройкаРасписания Тогда
		
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("Идентификатор", РассчитыватьПредварительнуюСебестоимостьИдентификатор);
		ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", "РассчитыватьПредварительнуюСебестоимостьРасписание");
		ПараметрыВыполнения.Вставить("ИмяРеквизитаИспользование", "РассчитыватьПредварительнуюСебестоимостьИспользование");
		
		РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
		
	Иначе
		
		Изменения = Новый Структура("Использование", РассчитыватьПредварительнуюСебестоимостьИспользование);
		РегламентныеЗаданияСохранить(
			РассчитыватьПредварительнуюСебестоимостьИдентификатор,
			Изменения,
			"РассчитыватьПредварительнуюСебестоимостьИспользование");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьВидыЗапасовПоПодразделениямМенеджерамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьВидыЗапасовПоСделкамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетПрочихДоходовРасходовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетПрочихДоходовРасходовРеглПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУчетПрочихАктивовПассивовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьФинансовыйРезультатПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьУправленческийБалансПриИзменении(Элемент)
	
	Если ФормироватьУправленческийБаланс Тогда
		ЗаполнитьАктивыПассивы();
	Иначе
		НаборКонстант.ФормироватьУправленческийБаланс = Ложь;
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьОтчетностьПоНДСПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьГруппыАналитическогоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьМониторингЦелевыхПоказателейПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДатаПереходаНаПартионныйУчетВерсии22ПриИзменении(Элемент)
	
	НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = НачалоМесяца(НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22);
	ТекстСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(ПериодДвиженийПУ22)
	 ИЛИ НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 <= ПериодДвиженийПУ22 Тогда
	 
		// Сдвиг даты "назад" допустим - переформируются остатки на новый период и дальше можно вести учет на ПУ 2.2
		Если ЗначениеЗаполнено(ПериодДвиженийСебестоимости)
		 И НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 < ПериодДвиженийСебестоимости Тогда
			
			НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = ПериодДвиженийСебестоимости;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Указанный период не может быть раньше даты первых движений по регистрам: %1'"),
				Формат(ПериодДвиженийСебестоимости, "ДЛФ=Д"));
			
		КонецЕсли;
		
	Иначе
		
		// Сдвиг даты "вперед" недопустим - обратный переход с ПУ 2.2 на ПУ 2.1 не поддерживается.
		НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = ПериодДвиженийПУ22;
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Указанный период не может быть позже даты первых движений партионного учета версии 2.2: %1'"),
			Формат(ПериодДвиженийПУ22, "ДЛФ=Д"));
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстСообщения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22");
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПартионногоУчетаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РежимПартионногоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПередачиТоваровМеждуОрганизациямиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДоговорыМеждуОрганизациямиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьОстаткиТоваровОрганизацийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура РаспределениеДопРасходовПоВыбывшимТоварамПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВестиУправленческийУчетОрганизацийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	УстановитьДоступность("НаборКонстант.ВестиУправленческийУчетОрганизаций");
КонецПроцедуры

&НаКлиенте
Процедура НачалоВеденияУправленческогоУчетаСОпределеннойДатыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элементы.ВестиУправленческийУчетОрганизаций, Ложь);
	УстановитьДоступность("НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
КонецПроцедуры

&НаКлиенте
Процедура НачалоВеденияУправленческогоУчетаСНачальнойДатыПриИзменении(Элемент)
	НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = Дата(1,1,1);
	Подключаемый_ПриИзмененииРеквизита(Элементы.ДатаНачалаВеденияУправленческогоУчетаОрганизаций, Ложь);
	УстановитьДоступность("НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВеденияУправленческогоУчетаОрганизацийПриИзменении(Элемент)
	
	НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = НачалоМесяца(НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций);
	
	Если НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций < НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 Тогда
		НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22;
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Указанный период должен быть позже даты начала использования партионного учета: %1'"),
			Формат(НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22, "ДЛФ=Д"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, , "НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
	КонецЕсли;
	
	
	Подключаемый_ПриИзмененииРеквизита(Элементы.ДатаНачалаВеденияУправленческогоУчетаОрганизаций, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаРасписанияРегламентногоЗаданияПредварительногоРасчетаСебестоимости(Команда)
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Идентификатор", РассчитыватьПредварительнуюСебестоимостьИдентификатор);
	ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", "РассчитыватьПредварительнуюСебестоимостьРасписание");
	
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РассчитыватьПредварительнуюСебестоимостьРасписание);
	Диалог.Показать(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПоставляемуюМодельПоказателей(Команда)
	ПоказатьВопрос(Новый ОписаниеОповещения("ВосстановитьПоставляемуюМодельПоказателейЗавершение", ЭтаФорма), 
		НСтр("ru= 'Настройки поставляемых категорий целей, целевых показателей, вариантов анализа и целевых значений будут сброшены.
		|Продолжить с потерей настроек поставляемой модели показателей?'"), РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте 
Процедура ВосстановитьПоставляемуюМодельПоказателейЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Иначе
		ЗаполнитьСтруктуруЦелейИВариантыАнализаНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеАктивовПассивов(Команда)
	
	ЗаполнитьАктивыПассивы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения)
	
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание]);
	Диалог.Показать(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	
	Если Расписание = Неопределено Тогда
		Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
			ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Ложь;
			НаборКонстант.РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданием = Ложь;
			Подключаемый_ПриИзмененииРеквизита(Элементы.РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданием);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание] = Расписание;
	
	Изменения = Новый Структура("Расписание", Расписание);
	Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
		ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Истина;
		Изменения.Вставить("Использование", Истина);
	КонецЕсли;
	
	РегламентныеЗаданияСохранить(
		ПараметрыВыполнения.Идентификатор,
		Изменения,
		ПараметрыВыполнения.ИмяРеквизитаРасписание);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАктивыПассивы()
	
	Обработчик = Новый ОписаниеОповещения("ПослеФормированияДвиженийУпрБаланса",ЭтаФорма);
	ОткрытьФорму("Обработка.ДвиженияАктивовПассивов.Форма.ЗаполнениеРегистра",,ЭтаФорма,,,,Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеФормированияДвиженийУпрБаланса(Результат, Параметры) Экспорт
	
	ЭтаФорма.Прочитать();
	
	ФормироватьУправленческийБаланс = НаборКонстант.ФормироватьУправленческийБаланс;
	
	Элементы.ГруппаЗаполнениеАктивовПассивов.Видимость =
		ФормироватьУправленческийБаланс И НЕ НаборКонстант.ЗаполненыДвиженияАктивовПассивов;
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокументыПоРегиструСебестоимостьТоваров()
	
	Результат = ПровестиДокументыПоРегиструСебестоимостьТоваровНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		
		ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1.2; // Уменьшим шаг увеличения времени опроса выполнения задания
		
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

// Унифицированная процедура проверки выполнения фонового задания.
//
&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
 
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() 
		 И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыключитьКонтрольОстатковТоваров(Команда)
	ВыключитьКонтрольОстатковТоваровСервер();
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура РегламентныеЗаданияСохранить(УникальныйИдентификатор, Изменения, РеквизитПутьКДанным)
	
	РегламентныеЗаданияСервер.ИзменитьЗадание(УникальныйИдентификатор, Изменения);
	
	Если РеквизитПутьКДанным <> Неопределено Тогда
		УстановитьДоступность(РеквизитПутьКДанным);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	ИначеЕсли РеквизитПутьКДанным = "ФормироватьУправленческийБаланс" Тогда
		КонстантаИмя = РеквизитПутьКДанным;
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВестиУправленческийУчетОрганизаций"
	 И НаборКонстант.ВестиУправленческийУчетОрганизаций Тогда
		
		НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = НачалоМесяца(ТекущаяДатаСеанса());
		Если НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций <= НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 Тогда
			НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = Дата(1,1,1);
		КонецЕсли;
		
		НачалоВеденияУправленческогоУчетаОрганизаций =
			?(ЗначениеЗаполнено(НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций), 0, 1);
		
		СохранитьЗначениеРеквизита("НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций");
		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ВестиУправленческийУчетОрганизаций"
	 ИЛИ РеквизитПутьКДанным = "НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций" Тогда
		ПартионныйУчетСервер.ЗапланироватьПересчетСебестоимостиПриИзмененииУправленческогоУчетаОрганизаций();
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22" Тогда
		
		ПартионныйУчетСервер.ЗапланироватьПересчетСебестоимостиВерсии22();
		
		Если НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 > НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций Тогда
			НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций = НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22;
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "РежимПартионногоУчета" Тогда
		
		ИзмененныеКонстанты = Новый Структура;
		
		Если РежимПартионногоУчета = "НеИспользуется" Тогда 
			
			// Отключение партионного учета.
			Если ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
				КонстантаИмя = "ИспользоватьПартионныйУчет";
				ИзмененныеКонстанты.Вставить("ИспользоватьПартионныйУчет", Ложь);
				Константы.ИспользоватьПартионныйУчет.Установить(Ложь);
			КонецЕсли;
			Если ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22") Тогда
				ИзмененныеКонстанты.Вставить("ПартионныйУчетВерсии22", Ложь);
				Константы.ПартионныйУчетВерсии22.Установить(Ложь);
			КонецЕсли;
			
			ПартионныйУчетСервер.ЗапланироватьПересчетСебестоимостиПриОтключенииПУВерсии22();
			Обработки.ПервоначальноеЗаполнениеРегистровПартионногоУчета.ОтменаПроведенияДокументовПоРегистрамПартий();
			
		Иначе
			
			// Включение партионного учета.
			Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
				КонстантаИмя = "ИспользоватьПартионныйУчет";
				ИзмененныеКонстанты.Вставить("ИспользоватьПартионныйУчет", Истина);
				Константы.ИспользоватьПартионныйУчет.Установить(Истина);
			КонецЕсли;
			
			Если (РежимПартионногоУчета = "Версия22") <> ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22") Тогда
				
				// Включение партионного учета версии 2.2.
				КонстантаИмя = "ПартионныйУчетВерсии22";
				ИзмененныеКонстанты.Вставить("ПартионныйУчетВерсии22", РежимПартионногоУчета = "Версия22");
				Константы.ПартионныйУчетВерсии22.Установить(РежимПартионногоУчета = "Версия22");
			
				Если РежимПартионногоУчета = "Версия22" И НЕ ЗначениеЗаполнено(НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22) Тогда
					
					// Если в ИБ есть движения, то установим дату перехода на этот месяц; если движений нет, то пусть дата остается пустой
					Если ЗначениеЗаполнено(ПериодДвиженийСебестоимости) Тогда
						
						НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = НачалоМесяца(ТекущаяДатаСеанса());
						СохранитьЗначениеРеквизита("НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22");
						
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							НСтр("ru='Партионный учет версии 2.2. включен с текущего периода.
								|Установите требуемый период перехода на партионный учет версии 2.2.'"),
							,
							"НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22");
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Очистим дату перехода на партионный учет версии 2.2 если он не используется.
		Если НЕ ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22")
		 И ЗначениеЗаполнено(Константы.ДатаПереходаНаПартионныйУчетВерсии22.Получить()) Тогда
			
			НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22 = Дата(1,1,1);
			СохранитьЗначениеРеквизита("НаборКонстант.ДатаПереходаНаПартионныйУчетВерсии22");
			
		КонецЕсли;
		
		Для Каждого ТекКонстанта Из ИзмененныеКонстанты Цикл
			Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(ТекКонстанта.Ключ, ТекКонстанта.Значение) Тогда
				ЭтаФорма.Прочитать();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ИспользоватьРеглУчет = Ложь;
	Элементы.ГруппаКомментарийИспользованиеРеглУчета.Видимость = ИспользоватьРеглУчет И НаборКонстант.ИспользоватьУчетПрочихДоходовРасходовРегл;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьГруппыФинансовогоУчета" ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьГруппыФинансовогоУчета, 
			НаборКонстант.ИспользоватьГруппыФинансовогоУчета);
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУчетПрочихДоходовРасходов" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ФормироватьФинансовыйРезультат.Доступность = НаборКонстант.ИспользоватьУчетПрочихДоходовРасходов;
		Элементы.ИспользоватьУчетПрочихДоходовРасходовРегл.Доступность = НаборКонстант.ИспользоватьУчетПрочихДоходовРасходов
			И (НЕ ИспользоватьРеглУчет ИЛИ НЕ НаборКонстант.ИспользоватьУчетПрочихДоходовРасходовРегл);
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУчетПрочихДоходовРасходовРегл" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ИспользоватьУчетПрочихДоходовРасходов.Доступность = НЕ НаборКонстант.ИспользоватьУчетПрочихДоходовРасходов
			ИЛИ НЕ (ИспользоватьРеглУчет И НаборКонстант.ИспользоватьУчетПрочихДоходовРасходовРегл);
	КонецЕсли;	
	
	Если РеквизитПутьКДанным = "НаборКонстант.ФормироватьФинансовыйРезультат" ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ФормироватьФинансовыйРезультат,
			НаборКонстант.ФормироватьФинансовыйРезультат);
	КонецЕсли;
	
	ИспользоватьМФУ = Ложь;
	Элементы.ГруппаКомментарийИспользованиеМФУ.Видимость = ИспользоватьМФУ;
	Элементы.ГруппаДетализацияФинансовогоРезультата.Доступность = НЕ ИспользоватьМФУ;
	
	Элементы.ГруппаЗаполнениеАктивовПассивов.Видимость = ФормироватьУправленческийБаланс И НЕ НаборКонстант.ЗаполненыДвиженияАктивовПассивов;
	
	Если РеквизитПутьКДанным = "РежимПартионногоУчета"
	 ИЛИ РеквизитПутьКДанным = "НаборКонстант.ВестиУправленческийУчетОрганизаций"
	 ИЛИ РеквизитПутьКДанным = "НаборКонстант.ДатаНачалаВеденияУправленческогоУчетаОрганизаций"
	 ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ГруппаИспользоватьРаздельныйУчетПоНалогообложению.Доступность = (РежимПартионногоУчета <> "НеИспользуется");
		Элементы.ГруппаКомментарийИспользоватьРаздельныйУчетПоНалогообложению.Видимость = (РежимПартионногоУчета = "НеИспользуется");
		Элементы.ДатаПереходаНаПартионныйУчетВерсии22.Видимость = (РежимПартионногоУчета = "Версия22");
		
		Элементы.РаспределениеДопРасходовПоВыбывшимТоварам.Доступность = (РежимПартионногоУчета = "Версия22");
		
		Элементы.НачалоВеденияУправленческогоУчетаСНачальнойДаты.Доступность = НаборКонстант.ВестиУправленческийУчетОрганизаций;
		Элементы.НачалоВеденияУправленческогоУчетаСОпределеннойДаты.Доступность = НаборКонстант.ВестиУправленческийУчетОрганизаций;
		
		ДоступностьВестиУправленческийУчетОрганизаций();
		
		УпрУчетСДаты = НаборКонстант.ВестиУправленческийУчетОрганизаций
			И (НачалоВеденияУправленческогоУчетаОрганизаций = 0);
		
		Элементы.ДатаНачалаВеденияУправленческогоУчетаОрганизаций.Доступность = УпрУчетСДаты;
		Элементы.ДатаНачалаВеденияУправленческогоУчетаОрганизаций.АвтоОтметкаНезаполненного = УпрУчетСДаты;
		
		Элементы.ДекорацияКомментарийФормироватьВидыЗапасовПоСделкам.Видимость = НЕ НаборКонстант.ИспользоватьСделкиСКлиентами;	
		Элементы.ДекорацияФормироватьВидыЗапасовПоСделкам.Видимость = НЕ НаборКонстант.ИспользоватьСделкиСКлиентами;
		Элементы.ФормироватьВидыЗапасовПоСделкам.Доступность = НаборКонстант.ИспользоватьСделкиСКлиентами
			И (РежимПартионногоУчета = "Версия22");
		
		Элементы.ДекорацияКомментарийПоПодразделениямМенеджерам.Видимость = НЕ НаборКонстант.ИспользоватьПодразделения;
		Элементы.ДекорацияПоПодразделениямМенеджерам.Видимость = НЕ НаборКонстант.ИспользоватьПодразделения;
		Элементы.ФормироватьВидыЗапасовПоПодразделениямМенеджерам.Доступность = НаборКонстант.ИспользоватьПодразделения
			И (РежимПартионногоУчета = "Версия22");	
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "РассчитыватьПредварительнуюСебестоимостьРасписание"
		ИЛИ РеквизитПутьКДанным = "РассчитыватьПредварительнуюСебестоимостьИспользование"
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданием"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.НастройкаРасписанияРегламентногоЗаданияПредварительногоРасчетаСебестоимости.Доступность = 
			РассчитыватьПредварительнуюСебестоимостьИспользование;
		Если РассчитыватьПредварительнуюСебестоимостьИспользование Тогда
			Элементы.ГруппаРассчитыватьПредварительнуюСтоимостьРегламентнымЗаданиемСтраницы.ТекущаяСтраница = 
				Элементы.РассчитыватьПредварительнуюСтоимостьИспользуется;
		Иначе
			Элементы.ГруппаРассчитыватьПредварительнуюСтоимостьРегламентнымЗаданиемСтраницы.ТекущаяСтраница = 
				Элементы.РассчитыватьПредварительнуюСтоимостьНеИспользуется;
		КонецЕсли;
		Если РассчитыватьПредварительнуюСебестоимостьИспользование Тогда
			РасписаниеПредставление = Строка(РассчитыватьПредварительнуюСебестоимостьРасписание);
			Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
		Иначе
			Представление = НСтр("ru = '<Отключено>'");
		КонецЕсли;
		Элементы.ПояснениеРассчитыватьПредварительнуюСебестоимость.Заголовок = Представление;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = Ложь;
		Элементы.ГруппаКомментарийИспользоватьГруппыАналитическогоУчета.Видимость = ЗначениеКонстанты;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьМониторингЦелевыхПоказателей" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ВосстановитьПоставляемуюМодельПоказателей.Доступность = НаборКонстант.ИспользоватьМониторингЦелевыхПоказателей;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьНесколькоОрганизаций;
		
		Элементы.ИспользоватьПередачиТоваровМеждуОрганизациями.Доступность = ЗначениеКонстанты;
		
				
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПередачиТоваровМеждуОрганизациями"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		НесколькоОрганизаций = НаборКонстант.ИспользоватьНесколькоОрганизаций;
		ПередачиМеждуОрганизациями = НаборКонстант.ИспользоватьПередачиТоваровМеждуОрганизациями;
		
		Элементы.ИспользоватьДоговорыМеждуОрганизациями.Доступность = НесколькоОрганизаций И ПередачиМеждуОрганизациями;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьРаздельныйУчетПоНалогообложению" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьРаздельныйУчетПоНалогообложению, 
			НаборКонстант.ИспользоватьРаздельныйУчетПоНалогообложению);
		
	КонецЕсли;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста 
Процедура ЗаполнитьСтруктуруЦелейИВариантыАнализаНаСервере()
	МониторингЦелевыхПоказателей.ЗаполнитьСтруктуруЦелейИВариантыАнализа();
КонецПроцедуры

&НаКлиенте
Процедура АктуализироватьДанныеПриФормированииОтчетовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаСервере
Функция ПровестиДокументыПоРегиструСебестоимостьТоваровНаСервере()
	
	ПараметрыЗадания = Новый Структура;
	НаименованиеЗадания = НСтр("ru = 'Проведение документов по регистру ""Себестоимость товаров""'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"ЗапасыСервер.ПроведениеДокументовПоРегиструСебестоимостьТоваров",
		ПараметрыЗадания,
		НаименованиеЗадания);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура НастройкиПартионногоУчета()
	
	// Возможные значения реквизита РежимПартионногоУчета: "НеИспользуется", "Версия21", "Версия22".
	
	// Ограничения на изменение режимов.
	ПричиныЗапретаВыключения 	= ПартионныйУчетСервер.ПартионныйУчетНельзяВыключать();
	ПричиныЗапретаПонижения 	= ПартионныйУчетСервер.ПартионныйУчетВерсии22НельзяПонизитьДоВерсии21();
	
	// Заполнение списка доступных режимов.
	ДоступныеРежимы = Элементы.РежимПартионногоУчета.СписокВыбора;
	ДоступныеРежимы.Очистить();
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
		РежимПартионногоУчета = "НеИспользуется";
	ИначеЕсли НЕ ПолучитьФункциональнуюОпцию("ПартионныйУчетВерсии22") Тогда
		РежимПартионногоУчета = "Версия21";
	Иначе
		РежимПартионногоУчета = "Версия22";
	КонецЕсли;
	
	Если РежимПартионногоУчета = "НеИспользуется" ИЛИ НЕ ЗначениеЗаполнено(ПричиныЗапретаВыключения) Тогда
		ДоступныеРежимы.Добавить("НеИспользуется", НСтр("ru='Не используется'"));
	КонецЕсли;
	
	Если (РежимПартионногоУчета = "Версия22" И НЕ ЗначениеЗаполнено(ПричиныЗапретаПонижения))
	 ИЛИ РежимПартионногоУчета = "Версия21" Тогда
		
		Если ПолучитьФункциональнуюОпцию("УправлениеПредприятием") Тогда
			ИмяКонфигурации = НСтр("ru='ERP 2.1'");
		ИначеЕсли ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
			ИмяКонфигурации = НСтр("ru='КА 2.0'");
		Иначе
			ИмяКонфигурации = НСтр("ru='УТ 11.2'");
		КонецЕсли;
		
		ДоступныеРежимы.Добавить("Версия21",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Версия 2.1 (режим совместимости с %1)'"),
				ИмяКонфигурации));
		
	КонецЕсли;
	
	ДоступныеРежимы.Добавить("Версия22", НСтр("ru='Версия 2.2'"));
	
	// Описание причин ограничений выбора режимов.
	ТекстОграничения = "";
	
	Если РежимПартионногоУчета <> "НеИспользуется" И ЗначениеЗаполнено(ПричиныЗапретаВыключения) Тогда
		ТекстОграничения = ТекстОграничения + "
			|" + ПричиныЗапретаВыключения;
	КонецЕсли;
	
	Если РежимПартионногоУчета = "Версия22" И ЗначениеЗаполнено(ПричиныЗапретаПонижения) Тогда
		ТекстОграничения = ТекстОграничения + "
			|" + ПричиныЗапретаПонижения;
	КонецЕсли;
	
	// Установка свойств элементов формы.
	Элементы.РежимПартионногоУчета.Доступность 				  	   = (ДоступныеРежимы.Количество() > 1);
	Элементы.КомментарийИспользоватьПартионныйУчет.Заголовок 	   = СокрЛП(ТекстОграничения);
	Элементы.ГруппаКомментарийИспользоватьПартионныйУчет.Видимость = НЕ ПустаяСтрока(ТекстОграничения);
	
КонецПроцедуры

&НаСервере
Процедура ВыключитьКонтрольОстатковТоваровСервер()
	ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций = Не ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций;
	
	ОбновитьНадписьКнопкиВыключитьКонтрольОстатковТоваровОрганизаций(ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций);
	
	Если ПараметрыСеанса.ПроводитьБезКонтроляОстатковТоваровОрганизаций Тогда
		ТекстСообщения = НСтр("ru = 'Пользователем %ИмяПользователя% в рамках своего сеанса выключен контроль остатков товаров организаций.'", Метаданные.ОсновнойЯзык.КодЯзыка);
	Иначе
		ТекстСообщения = НСтр("ru = 'Пользователем %ИмяПользователя% возобновлен контроль остатков товаров организаций.'", Метаданные.ОсновнойЯзык.КодЯзыка);
	КонецЕсли;
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяПользователя%", ПользователиКлиентСервер.ТекущийПользователь());
	
	ЗаписьЖурналаРегистрации(ЗапасыСервер.ИмяСобытияВыключенКонтрольОстатков(),
		УровеньЖурналаРегистрации.Предупреждение, , ,ТекстСообщения);
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьКнопкиВыключитьКонтрольОстатковТоваровОрганизаций(КонтрольВыключен)
	Если КонтрольВыключен Тогда
		Элементы.ВыключитьКонтрольОстатковТоваров.Заголовок = НСтр("ru = 'Возобновить контроль остатков'");
		Элементы.ВыключитьКонтрольОстатковТоваров.РасширеннаяПодсказка.Заголовок = НСтр("ru = 'Восстановление контроля остатков товаров организаций для текущего пользователя, ранее выключенных на время сеанса.'");
	Иначе
		Элементы.ВыключитьКонтрольОстатковТоваров.Заголовок = НСтр("ru = 'Отключить контроль остатков (на время сеанса)'");
		Элементы.ВыключитьКонтрольОстатковТоваров.РасширеннаяПодсказка.Заголовок = НСтр("ru = 'Выключение контроля остатков товаров организаций для текущего пользователя на время сеанса работы.
			| Возможность так же доступна в ""НСИ и администрирование"" - ""Персональные настройки"".'");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДоступностьВестиУправленческийУчетОрганизаций()

	КомментарийОпции = "";
	
	Если НаборКонстант.ВестиУправленческийУчетОрганизаций Тогда
	Иначе
		Если РежимПартионногоУчета <> "Версия22" Тогда
			КомментарийОпции = КомментарийОпции + Символы.ПС
				+ НСтр("ru = '- установить опции ""Партионный учет"" значение ""Версия 2.2""'");
		КонецЕсли; 
		Если ЗначениеЗаполнено(КомментарийОпции) Тогда
			КомментарийОпции = НСтр("ru = 'Для включения возможности использования управленческого учета по правилам МФУ необходимо:'") + КомментарийОпции;
		КонецЕсли; 
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(КомментарийОпции) Тогда
		Элементы.КомментарийВестиУУНаПланеСчетовХозрасчетный.Заголовок = КомментарийОпции;
		Элементы.ГруппаКомментарийВестиУправленческийУчетОрганизаций.Видимость = Истина;
		Элементы.ВестиУправленческийУчетОрганизаций.Доступность = Ложь;
	Иначе
		Элементы.ГруппаКомментарийВестиУправленческийУчетОрганизаций.Видимость = Ложь;
		Элементы.ВестиУправленческийУчетОрганизаций.Доступность = Истина;
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
