﻿

//При создании на сервере
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 
	
	 УсловноеОформлениеСтатуса();

 КонецПроцедуры
 
  //Устанавливает условное оформление списка по статусу
 &НаСервере
Процедура УсловноеОформлениеСтатуса()
	 
	
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	                |	ГАЛ_СтатусыЗаявокНаДоставку.Ссылка,
	                |	ГАЛ_СтатусыЗаявокНаДоставку.R,
	                |	ГАЛ_СтатусыЗаявокНаДоставку.G,
	                |	ГАЛ_СтатусыЗаявокНаДоставку.B
	                |ИЗ
	                |	Справочник.ГАЛ_СтатусыЗаявокНаДоставку КАК ГАЛ_СтатусыЗаявокНаДоставку
	                |ГДЕ
	                |	ГАЛ_СтатусыЗаявокНаДоставку.ПометкаУдаления = ЛОЖЬ";
	 
	 Результат = Запрос.Выполнить();
	 Выборка = Результат.Выбрать();
	 
	 Пока Выборка.Следующий() Цикл
	 
		 ЭлементУО = УсловноеОформление.Элементы.Добавить();
		 ЭлементУО.Использование = Истина;
		 
			 Попытка
			 ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет(Выборка.R,Выборка.G,Выборка.B));
		 Исключение
			 
		 КонецПопытки;
	 
		 ЭлементУсловия                = ЭлементУО.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		 ЭлементУсловия.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Список.СтатусДоставки");
		 ЭлементУсловия.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		 ЭлементУсловия.ПравоеЗначение = Выборка.Ссылка;
		 ЭлементУсловия.Использование  = Истина;
		 
		 ОформляемоеПоле      = ЭлементУО.Поля.Элементы.Добавить();
		 ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Список");
	 КонецЦикла;

КонецПроцедуры

//Установить статус

&НаКлиенте
Процедура УстановитьСтатус(Команда)
	
	ТекСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекСтрока <> Неопределено Тогда
		
		
		Оп = Новый ОписаниеОповещения("ВыполнитьПослеВыбораСтатуса", ЭтаФорма, );
	
		ОткрытьФорму( "Справочник.ГАЛ_СтатусыЗаявокНаДоставку.ФормаВыбора",,ЭтаФорма,,,,Оп);

	КонецЕсли;
	
КонецПроцедуры

//Обработкав выбора статуса
&НаКлиенте
Процедура ВыполнитьПослеВыбораСтатуса(ВыбранноеЗначение, ДополнительныеПараметры)  Экспорт 
	
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ТекСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекСтрока <> Неопределено Тогда		
		УстановитьСтатусНаСервере(ТекСтрока,ВыбранноеЗначение);
		Элементы.Список.Обновить();	
	КонецЕсли;
	
КонецПроцедуры

//Установить статус документа
&НаСервере
Процедура УстановитьСтатусНаСервере(Заказ,ЗначениеСтатуса)
	
	ТекОбъект = Заказ.ПолучитьОбъект();
	ТекОбъект.СтатусДоставки = ЗначениеСтатуса;
	
	Если ТекОбъект.Проведен Тогда
		ТекОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ТекОбъект.Записать(РежимЗаписиДокумента.записать);
	КонецЕсли;

КонецПроцедуры

//Доставлен
&НаКлиенте
Процедура Доставлен(Команда)
	ТекСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекСтрока <> Неопределено Тогда		
		УстановитьСтатусНаСервере(ТекСтрока,ПредопределенноеЗначение("Справочник.ГАЛ_СтатусыЗаявокНаДоставку.Доставлен"));
		Элементы.Список.Обновить();	
	КонецЕсли;

КонецПроцедуры

//Отменен
&НаКлиенте
Процедура Отменен(Команда)
	ТекСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекСтрока <> Неопределено Тогда		
		УстановитьСтатусНаСервере(ТекСтрока,ПредопределенноеЗначение("Справочник.ГАЛ_СтатусыЗаявокНаДоставку.Отменен"));
		Элементы.Список.Обновить();	
	КонецЕсли;

КонецПроцедуры

//Отправка сообщения курьеру на телефон
&НаКлиенте
Процедура ОтправитьСообщениеПУШ(Команда)
	
	ТекСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекСтрока <> Неопределено Тогда
		
		П = Новый Структура;
		П.Вставить("Документ",);
		П.Вставить("Водитель",ТекСтрока);
		ОткрытьФорму("ОбщаяФорма.ГАЛ_ФормаОтправкиPush", П);
	КонецЕсли;

КонецПроцедуры
