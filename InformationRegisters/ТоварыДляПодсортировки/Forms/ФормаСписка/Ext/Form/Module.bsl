﻿
&НаКлиенте
Процедура СформироватьПодсортировку(Команда)
	
	Если  ЗначениеЗаполнено(ОрганизацияВДокументПеремещение) Тогда
		СформироватьПодсортировкуНаСервере();
	Иначе
		Сообщить("Не выбрана организация для перемещения. Документ подсортировки не создан!!!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьПодсортировкуНаСервере()
	ТоварыКперемещению = Новый ТаблицаЗначений;
	ТоварыКперемещению.Колонки.Добавить("Номенклатура");
	ТоварыКперемещению.Колонки.Добавить("Характеристика");
	ТоварыКперемещению.Колонки.Добавить("СкладОтправитель");
	ТоварыКперемещению.Колонки.Добавить("СкладПолучатель");
	ТоварыКперемещению.Колонки.Добавить("Количество");
	
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ТоварыДляПодсортировки.Номенклатура КАК Номенклатура,
	|	ТоварыДляПодсортировки.Характеристика КАК Характеристика,
	|	ТоварыДляПодсортировки.СкладОтправитель КАК СкладОтправитель,
	|	ТоварыДляПодсортировки.СкладПолучатель КАК СкладПолучатель,
	|	ТоварыДляПодсортировки.МинимальноеКоличество КАК МинимальноеКоличество
	|ИЗ
	|	РегистрСведений.ТоварыДляПодсортировки КАК ТоварыДляПодсортировки");
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПолучательОстаток = 0;
		ОтправительОстаток = 0;
		ЗапросОстаткаПолучателя = Новый Запрос("ВЫБРАТЬ
		|	ТоварыНаСкладахОстатки.ВНаличииОстаток КАК ВНаличииОстаток
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах.Остатки(
		|			&ДатаСреза,
		|			Номенклатура = &Номенклатура
		|				И Характеристика = &Характеристика
		|				И Склад = &Склад) КАК ТоварыНаСкладахОстатки");	
	
		ЗапросОстаткаПолучателя.УстановитьПараметр("ДатаСреза",ТекущаяДата());
		ЗапросОстаткаПолучателя.УстановитьПараметр("Номенклатура",Выборка.Номенклатура);
		ЗапросОстаткаПолучателя.УстановитьПараметр("Характеристика",Выборка.Характеристика);
		ЗапросОстаткаПолучателя.УстановитьПараметр("Склад",Выборка.СкладПолучатель);
		ВыборкаСклад = ЗапросОстаткаПолучателя.Выполнить().Выбрать();

		Если ВыборкаСклад.Следующий() Тогда
			ПолучательОстаток = ВыборкаСклад.ВНаличииОстаток;
		КонецЕсли;
		
		ЗапросОстаткаОтправителя = Новый Запрос("ВЫБРАТЬ
		|	ТоварыНаСкладахОстатки.ВНаличииОстаток КАК ВНаличииОстаток
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах.Остатки(
		|			&ДатаСреза,
		|			Номенклатура = &Номенклатура
		|				И Характеристика = &Характеристика
		|				И Склад = &Склад) КАК ТоварыНаСкладахОстатки");	
		ЗапросОстаткаОтправителя.УстановитьПараметр("ДатаСреза",ТекущаяДата());
		ЗапросОстаткаОтправителя.УстановитьПараметр("Номенклатура",Выборка.Номенклатура);
		ЗапросОстаткаОтправителя.УстановитьПараметр("Характеристика",Выборка.Характеристика);
		ЗапросОстаткаОтправителя.УстановитьПараметр("Склад",Выборка.СкладОтправитель);
		ВыборкаСклад = ЗапросОстаткаОтправителя.Выполнить().Выбрать();
		Если ВыборкаСклад.Следующий() Тогда
			ОтправительОстаток = ВыборкаСклад.ВНаличииОстаток;
		КонецЕсли;
		
		Если Выборка.МинимальноеКоличество > ПолучательОстаток И ОтправительОстаток >= (Выборка.МинимальноеКоличество- ПолучательОстаток)  Тогда
			НоваяСтрока = ТоварыКперемещению.Добавить();
			НоваяСтрока.Номенклатура = Выборка.Номенклатура;
			НоваяСтрока.Характеристика = Выборка.Характеристика;
			НоваяСтрока.СкладОтправитель = Выборка.СкладОтправитель;
			НоваяСтрока.СкладПолучатель = Выборка.СкладПолучатель;
			НоваяСтрока.Количество = Выборка.МинимальноеКоличество- ПолучательОстаток;
		КонецЕсли;
		

		

	КонецЦикла;
	
	
	
	Если ТоварыКперемещению.Количество() = 0 Тогда
		Сообщить("Нет товаров к перемещению");
		Возврат
	Иначе
		Докк = Документы.ПеремещениеТоваров.СоздатьДокумент();
		Докк.Статус = Перечисления.СтатусыПеремещенийТоваров.Отгружено;
		Докк.Организация = ОрганизацияВДокументПеремещение;
		Докк.ОрганизацияПолучатель = ОрганизацияВДокументПеремещение;
		Докк.СкладОтправитель = ТоварыКперемещению[0].СкладОтправитель;
		Докк.СкладПолучатель = ТоварыКперемещению[0].СкладПолучатель;
		Докк.Дата = ТекущаяДата();
		Докк.Комментарий = "Создано автоматической подсортировкой";
		Докк.Ответственный = ПараметрыСеанса.ТекущийПользователь;
		
		Для Каждого ТекСтрока ИЗ ТоварыКперемещению Цикл
			Стрр = Докк.Товары.Добавить();
			Стрр.Номенклатура = ТекСтрока.Номенклатура;
			Стрр.Характеристика = ТекСтрока.Характеристика;
			Стрр.Количество = ТекСтрока.Количество;
			Стрр.КоличествоУпаковок = ТекСтрока.Количество;
			Стрр.Упаковка = Стрр.Номенклатура.ЕдиницаИзмерения;
		КонецЦикла;
		
		Докк.Записать();
		СОобщить("Создан документ подсортировки: "+ Докк.Ссылка);
		//Докк.
	КонецЕсли;
	
	
КонецПроцедуры
