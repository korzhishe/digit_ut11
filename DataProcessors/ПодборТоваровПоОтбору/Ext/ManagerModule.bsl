﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция подготавливает структуру данных, необходимую для печати ценников и этикеток.
//
// Параметры:
//  Структура - данные, структура настроек.
//
// Возвращаемое значение:
//  Структура - данные, необходимые для печати этикеток и ценников.
//
Функция ПодготовитьСтруктуруДанных(СтруктураНастроек) Экспорт
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ТаблицаТоваров",                             Неопределено);
	СтруктураРезультата.Вставить("СоответствиеПолейСКДКолонкамТаблицыТоваров", Новый Соответствие);

#Область ПодготовкаСхемыКомпоновкиДанныхИКомпоновщикаНастроекСкд
	
	// Схема компоновки.
	СхемаКомпоновкиДанных = Обработки.ПодборТоваровПоОтбору.ПолучитьМакет(СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных);
	
	// Подготовка компоновщика макета компоновки данных.
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Компоновщик.Настройки.Отбор.Элементы.Очистить();
	Компоновщик.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.Полное);
	
	// Отбор и сортировка компоновщика настроек.
	Если СтруктураНастроек.КомпоновщикНастроек <> Неопределено Тогда
		
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(
			Компоновщик.Настройки.Отбор,
			СтруктураНастроек.КомпоновщикНастроек.Настройки.Отбор);
			
		КомпоновкаДанныхКлиентСервер.СкопироватьЭлементы(
			Компоновщик.Настройки.Порядок,
			СтруктураНастроек.КомпоновщикНастроек.Настройки.Порядок);
			
	КонецЕсли;
	
	ИспользоватьАссортимент = ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент");
	Если ИспользоватьАссортимент Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "АссортиментНаДату", ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("ЦеныНаДату") Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "ЦеныНаДату", СтруктураНастроек.ЦеныНаДату);
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("Поставщик") Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "Поставщик", СтруктураНастроек.Поставщик);
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("ОтборПоВариантуРасчетаЦенНаборов") Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Компоновщик.Настройки.Отбор,
			"ВариантРасчетаЦеныНабора",
			ВидСравненияКомпоновкиДанных.ВСписке,
			СтруктураНастроек.ОтборПоВариантуРасчетаЦенНаборов,
			Неопределено,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЕсли;
	
	Если СтруктураНастроек.ВестиУчетСертификатовНоменклатуры Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(Компоновщик.Настройки, "ВестиУчетСертификатовНоменклатуры", Истина);
	КонецЕсли;
	
	// Выбранные поля компоновщика настроек.
	Для Каждого ОбязательноеПоле Из СтруктураНастроек.ОбязательныеПоля Цикл
		ПолеСКД = КомпоновкаДанныхСервер.НайтиПолеСКДПоПолномуИмени(Компоновщик.Настройки.Выбор.ДоступныеПоляВыбора.Элементы, ОбязательноеПоле);
		Если ПолеСКД <> Неопределено Тогда
			ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = ПолеСКД.Поле;
		КонецЕсли;
	КонецЦикла;
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(Компоновщик);
	
	// Компоновка макета компоновки данных.
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		Компоновщик.ПолучитьНастройки(),,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

#КонецОбласти

#Область ПодготовкаВспомогательныхДанныхДляСопоставленияПолейШаблонаИСкд
	
	Для каждого Поле Из МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Поля Цикл
		СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицыТоваров.Вставить(
			Справочники.ШаблоныЭтикетокИЦенников.ИмяПоляВШаблоне(Поле.ПутьКДанным), Поле.Имя);
	КонецЦикла;

#КонецОбласти

#Область ВыполнениеЗапроса

	ТекстЗапроса = МакетКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос;
	ЭлементыПорядка = Компоновщик.ПолучитьНастройки().Порядок.Элементы;
	
	ТекстПорядка = "";
	Для Каждого ЭлементПорядка Из ЭлементыПорядка Цикл
		Если ЭлементПорядка.Использование И ЗначениеЗаполнено(ЭлементПорядка.Поле) Тогда
			СтрокаПорядка = Строка(ЭлементПорядка.Поле) +
				?(ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр," ВОЗР", " УБЫВ") + ", ";
			ТекстПорядка = ТекстПорядка + СтрокаПорядка;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстПорядка) Тогда
		ТекстПорядка = Лев(ТекстПорядка, СтрДлина(ТекстПорядка)-2);
	Иначе
		ТекстПорядка = "ИсходныеДанныеПоследнийЗапрос.Номенклатура.Наименование ВОЗР"
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + " УПОРЯДОЧИТЬ ПО " + ТекстПорядка;
	Запрос = Новый Запрос(ТекстЗапроса);
	
	// Заполнение параметров с полей отбора компоновщика настроек формы обработки.
	Для каждого Параметр Из МакетКомпоновкиДанных.ЗначенияПараметров Цикл
		Запрос.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
	КонецЦикла;
	
	СтруктураРезультата.ТаблицаТоваров = Запрос.Выполнить().Выгрузить();
	
	Возврат СтруктураРезультата;

#КонецОбласти
КонецФункции
#КонецОбласти

#КонецЕсли