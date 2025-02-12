﻿
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	RGB = ПолучитьАбсолютныйЦвет(НашЦвет);
	Запись.R = RGB.Красный;
	Запись.G = RGB.Зеленый;
	Запись.B = RGB.Синий;
	//Объект.ЗначениеЦвета = RGB;
КонецПроцедуры


Функция ПолучитьАбсолютныйЦвет(ИсходныйЦвет) Экспорт
	
	
	
	Если ИсходныйЦвет.Вид = ВидЦвета.Абсолютный Тогда
		Возврат ИсходныйЦвет;
	КонецЕсли;
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.Область("R1C1").ЦветФона = ИсходныйЦвет;
	Каталог = КаталогВременныхФайлов();
	ТабДок.Записать(Каталог + "ПреобразованиеЦвета.mxl", ТипФайлаТабличногоДокумента.MXL7);
	ТабДок.Прочитать(Каталог + "ПреобразованиеЦвета.mxl");
	
	АЦвет = ТабДок.Область("R1C1").ЦветФона;
	
	Возврат АЦвет;

КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекЦвет = Новый Цвет(Запись.R,Запись.G,Запись.B);
	НашЦвет = ТекЦвет;
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеЦветаМеткиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		СписокВыбора = ЗначениеЦветаНачалоВыбораСервер();
	
	 
		Оп = Новый ОписаниеОповещения("ВыполнитьПослеВыбора", ЭтотОбъект, );
		ПоказатьВыборИзСписка(Оп, СписокВыбора, Запись.ЗначениеЦветаМетки);


КонецПроцедуры

&НаСервере
Функция  ЗначениеЦветаНачалоВыбораСервер()
	
	Макет = Справочники.ГАЛ_СтатусыЗаявокНаДоставку.ПолучитьМакет("ЦветаМетки");	
	СписокВыбора = Новый СписокЗначений;
	Строк=7;
	НСтр=1;
	Для НомерСтроки=0 по (Строк-1) цикл
			СписокВыбора.Добавить(Макет.Область(НСтр, 1).Текст,Макет.Область(НСтр, 3).Текст,,Макет.Область(НСтр, 2).Картинка);
			НСтр=НСтр+1;
	КонецЦикла;

	Возврат СписокВыбора;  
КонецФункции


&НаКлиенте
Процедура ВыполнитьПослеВыбора(ЗначениеВыбора, ДопПараметры) Экспорт 
	
	//Запись.ЗначениеЦветаМетки = ЗначениеВыбора.Значение;
		
	//Цвет = WebЦвета[Объект.ЗначениеЦвета];
КонецПроцедуры

&НаКлиенте
Процедура НашЦветОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	RGB = ПолучитьАбсолютныйЦвет(НашЦвет);
	Запись.R = RGB.Красный;
	Запись.G = RGB.Зеленый;
	Запись.B = RGB.Синий;

КонецПроцедуры
