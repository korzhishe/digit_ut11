﻿////////////////////////////////////////////////////////////////////////////////
// ИнтеграцияГИСМВызовСервераПереопределяемый: переопределяемые процедуры, 
// требующие вызова сервера.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяДокумента - Строка - имя документа, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыДокумента(ИмяДокумента, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГИСМ
	Если ИмяДокумента = "МаркировкаТоваровГИСМ" Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			ВыбраннаяФорма = "ФормаДокументаУТ";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	ИначеЕсли ИмяДокумента = "ПеремаркировкаТоваровГИСМ" Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			ВыбраннаяФорма = "ФормаДокументаУТ";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Получает массив номенклатуры КиЗ по переданному GTIN маркированного товара и списка номеклатуры КиЗ,
// подходящей под выбранные категории КиЗ в документе.
//
// Параметры:
//  СписокНоменклатураКиЗ	 - Массив - список номенклатуры КиЗ, отобранной по категориям КиЗ в документе.
//  GTIN					 - Массив - массив GTIN маркируемой номенклатуры.
// 
// Возвращаемое значение:
//  Массив - массив номенклатуры КиЗ
//
Функция ПолучитьМассивКиз(СписокНоменклатураКиЗ, GTIN) Экспорт
	
	//++ НЕ ГИСМ
	Возврат МаркировкаТоваровГИСМВызовСервераУТ.ПолучитьМассивКиз(СписокНоменклатураКиЗ, GTIN);
	//-- НЕ ГИСМ
	
	Возврат Новый Массив;
	
КонецФункции

// Получает массив GTIN для переданного товара
//
// Параметры:
//  Номенклатура	 - СправочникСсылка.Номенклатура - номенклатура (маркируемый товар).
//  Характеристика	 - СправочникСсылка.Номенклатура - характеристика номенклатуры (маркируемого товара).
// 
// Возвращаемое значение:
//  Массив - массив GTIN
//
Функция МассивGTINМаркированногоТовара(Номенклатура, Характеристика) Экспорт
	
	//++ НЕ ГИСМ
	Возврат МаркировкаТоваровГИСМВызовСервераУТ.МассивGTINМаркированногоТовара(Номенклатура, Характеристика);
	//-- НЕ ГИСМ
	
	Возврат Новый Массив;
	
КонецФункции

#КонецОбласти
