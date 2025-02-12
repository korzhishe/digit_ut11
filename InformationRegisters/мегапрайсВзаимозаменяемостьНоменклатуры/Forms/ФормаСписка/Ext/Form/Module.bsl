﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
		
	Если Параметры.Свойство("Номенклатура") Тогда
		ЗаголовокПоНоменклатуре = НСтр("ru = '%Заголовок% (%НаименованиеНоменклатуры%)'");
		НаименованиеНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Номенклатура, "Наименование");
		
		ЗаголовокПоНоменклатуре = СтрЗаменить(ЗаголовокПоНоменклатуре, "%Заголовок%", Заголовок);
		ЗаголовокПоНоменклатуре = СтрЗаменить(ЗаголовокПоНоменклатуре, "%НаименованиеНоменклатуры%",
			НаименованиеНоменклатуры);
		
		Заголовок = ЗаголовокПоНоменклатуре;
		
		ОтборНоменклатура = Параметры.Номенклатура;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Номенклатура", 
			Параметры.Номенклатура, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УдалитьАналоги(ТекущиеДанные)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	мегапрайсВзаимозаменяемостьНоменклатуры.АналогНоменклатура КАК АналогНоменклатура,
	|	мегапрайсВзаимозаменяемостьНоменклатуры.Номенклатура КАК Номенклатура,
	|	мегапрайсВзаимозаменяемостьНоменклатуры.АртикулАналога КАК АналогАртикул,
	|	мегапрайсВзаимозаменяемостьНоменклатуры.Главный
	|ИЗ
	|	РегистрСведений.мегапрайсВзаимозаменяемостьНоменклатуры КАК мегапрайсВзаимозаменяемостьНоменклатуры
	|ГДЕ
	|	мегапрайсВзаимозаменяемостьНоменклатуры.Номенклатура = &ВыбНоменклатура";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ВыбНоменклатура", ТекущиеДанные.Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаРезультат = РезультатЗапроса.Выгрузить();
	
	НаборЗаписей = РегистрыСведений.мегапрайсВзаимозаменяемостьНоменклатуры.СоздатьНаборЗаписей(); 
	НаборЗаписей.Отбор.Номенклатура.Установить(ТекущиеДанные.АналогНоменклатура);
	НаборЗаписей.Записать(Истина);	
		
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл		
		
		НаборЗаписей = РегистрыСведений.мегапрайсВзаимозаменяемостьНоменклатуры.СоздатьНаборЗаписей(); 
		НаборЗаписей.Отбор.Номенклатура.Установить(Выборка.АналогНоменклатура);
		НаборЗаписей.Отбор.АналогНоменклатура.Установить(ТекущиеДанные.АналогНоменклатура);
		НаборЗаписей.Записать(Истина);	
		
		//Для Каждого ВыборкаЗапись Из ТаблицаРезультат Цикл
		//	
		//	НаборЗаписей = РегистрыСведений.мегапрайсВзаимозаменяемостьНоменклатуры.СоздатьНаборЗаписей(); 
		//	НаборЗаписей.Отбор.Номенклатура.Установить(Выборка.АналогНоменклатура);
		//	НаборЗаписей.Отбор.АналогНоменклатура.Установить(ВыборкаЗапись.АналогНоменклатура);
		//	НаборЗаписей.Записать(Истина);			
		//КонецЦикла;		
	КонецЦикла;	

КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;

	УдалитьАналоги(ТекущиеДанные);
	
КонецПроцедуры
