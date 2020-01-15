﻿
#Область ПрограммныйИнтерфейс

// Возвращает строковое представление номенклатуры с характеристикой и другими полями для отображения в сообщениях.
//
// Параметры:
//  Номенклатура	 - Строка, СправочникСсылка.Номенклатура			 - номенклатура;
//  Характеристика	 - Строка, СправочникСсылка.ХарактеристикиНоменклатуры	 - характеристика номенклатуры;
//  Упаковка		 - Строка, СправочникСсылка.УпаковкиНоменклатуры		 - упаковка / единица измерения номенклатуры;
//  Серия			 - Строка, СправочникСсылка.СерииНоменклатуры			 - серия номенклатуры;
//  Назначение		 - Строка, СправочникСсылка.Назначения					 - назначение номенклатуры.
// 
// Возвращаемое значение:
//  Строка - представление номенклатуры.
//
Функция ПредставлениеНоменклатуры(Номенклатура, Характеристика, Упаковка = "", Серия = "", Назначение = "") Экспорт

	СтрПредставление = СокрЛП(Номенклатура);

	Если ЗначениеЗаполнено(Характеристика)Тогда
		СтрПредставление = СтрПредставление + " / " + СокрЛП(Характеристика);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Назначение) Тогда
		СтрПредставление = СтрПредставление + " / " + СокрЛП(Назначение);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Серия) Тогда
		СтрПредставление = СтрПредставление + " / " + СокрЛП(Серия);
	КонецЕсли;

	Возврат СтрПредставление;

КонецФункции

// Дополнительные параметры функции НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати
// 
// Возвращаемое значение:
//  Структура - со свойствами:
//  * Содержание - Строка - если передано не пустое содержание, то представлением будет оно, остальные параметры игнорируются
//  * ВозвратнаяТара - Булево - если ИСТИНА, то к передставлению будет добавлена фраза "возвратная тара" в скобках
//
Функция ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати() Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Содержание", "");
	ДополнительныеПараметры.Вставить("ВозвратнаяТара", Ложь);
	ДополнительныеПараметры.Вставить("КодТНВЭД", "");
	
	Возврат ДополнительныеПараметры; 
	
КонецФункции

// Возвращает представление номенклатуры для печати.
//
// Параметры:
//  НаименованиеНоменклатурыДляПечати	 - Строка		 - нужно строго передать строку с наименованием для печати. Ссылка не подойдет, т.к. при
//  		получении по ней строкового представления платформа возьмет наименование, а не наименование для печати;
//  НаименованиеХарактеристикиДляПечати	 - Строка		 - нужно строго передать строку с наименованием для печати. Ссылка не подойдет, т.к. при
//  		получении по ней строкового представления платформа возьмет наименование, а не наименование для печати;
//  Упаковка							 - 				 - Строка, СправочникСсылка.УпаковкиНоменклатуры упаковка / единица измерения номенклатуры;
//  Серия								 - Строка, СправочникСсылка.СерииНоменклатуры	 - серия номенклатуры;
//  ДополнительныеПараметры				 - Структура									 - см. НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати.
// 
// Возвращаемое значение:
//  Строка - пердставление номенклатуры для печати.
//
Функция ПредставлениеНоменклатурыДляПечати(НаименованиеНоменклатурыДляПечати,
	                                       НаименованиеХарактеристикиДляПечати,
	                                       Упаковка = Неопределено,
	                                       Серия = Неопределено,
	                                       ДополнительныеПараметры = Неопределено) Экспорт
										   
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
	КонецЕсли;
	
	Если ТипЗнч(НаименованиеНоменклатурыДляПечати) <> Тип("Строка") Тогда
		ТекстИключения = НСтр("ru = 'В функцию НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати не передано наименование номенклатуры для печати.'");	
		ВызватьИсключение ТекстИключения;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаименованиеХарактеристикиДляПечати) 
		И ТипЗнч(НаименованиеХарактеристикиДляПечати) <> Тип("Строка") Тогда
		ТекстИключения = НСтр("ru = 'В функцию НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати не передано наименование характеристики для печати.'");	
		ВызватьИсключение ТекстИключения;	
	КонецЕсли;
	
	//Если ЗначениеЗаполнено(ДополнительныеПараметры.Содержание) Тогда
	//	
	//	ПредставлениеНоменклатуры = СокрЛП(ДополнительныеПараметры.Содержание);
	//	
	//Иначе
		
		ТекстВСкобках = Новый Массив;
		
		Если ЗначениеЗаполнено(НаименованиеХарактеристикиДляПечати) Тогда
			ТекстВСкобках.Добавить(СокрЛП(НаименованиеХарактеристикиДляПечати));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Упаковка) Тогда
			ТекстВСкобках.Добавить(СокрЛП(Упаковка));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Серия) Тогда
			ТекстВСкобках.Добавить(СокрЛП(Серия));
		КонецЕсли;
		
		//Если ДополнительныеПараметры.ВозвратнаяТара Тогда
		//	ТекстВСкобках.Добавить(НСтр("ru='возвратная тара'"));
		//КонецЕсли;
		
		//Если ЗначениеЗаполнено(ДополнительныеПараметры.КодТНВЭД) Тогда
		//	ТекстВСкобках.Добавить(НСтр("ru = 'Код ТН ВЭД:'")+ Символы.НПП + ДополнительныеПараметры.КодТНВЭД);
		//КонецЕсли;
		//
		ТекстВСкобкахСтрока = СтрСоединить(ТекстВСкобках, ", ");
		
		Если ЗначениеЗаполнено(ТекстВСкобкахСтрока) Тогда
			ПредставлениеНоменклатуры = НСтр("ru = '%НаименованиеНоменклатурыДляПечати% (%ТекстВСкобках%)'");
			ПредставлениеНоменклатуры = СтрЗаменить(ПредставлениеНоменклатуры, "%ТекстВСкобках%", СокрЛП(ТекстВСкобкахСтрока));
		Иначе
			ПредставлениеНоменклатуры = НСтр("ru = '%НаименованиеНоменклатурыДляПечати%'");
		КонецЕсли;
		
		ПредставлениеНоменклатуры = СтрЗаменить(ПредставлениеНоменклатуры, "%НаименованиеНоменклатурыДляПечати%", СокрЛП(НаименованиеНоменклатурыДляПечати));
		
	//КонецЕсли;
	
	Возврат ПредставлениеНоменклатуры;
	
КонецФункции

// Формирует массив отбора по типам номенклатуры Товар и МногооборотнаяТара
//
// Параметры:
//  ВключатьНабор	 - Булево	 - признак включения в отбор набора.
// 
// Возвращаемое значение:
//  Массив - состоит из элементов типа ПеречислениеСсылка.ТипыНоменклатуры.
//
Функция ОтборПоТоваруМногооборотнойТаре(ВключатьНабор = Истина) Экспорт
	
	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"));
	Если ВключатьНабор Тогда
		МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Набор"));
	КонецЕсли;
	
	Возврат МассивТиповНоменклатуры;
	
КонецФункции

// Формирует массив отбора по типам номенклатуры Товар и МногооборотнаяТара, Услуга, Работа
//
// Параметры:
//  ВключатьНабор	 - Булево	 - признак включения в отбор набора.
// 
// Возвращаемое значение:
//  Массив - состоит из элементов типа ПеречислениеСсылка.ТипыНоменклатуры.
//
Функция ОтборПоТоваруМногооборотнойТареУслугеРаботе(ВключатьНабор = Истина) Экспорт
	
	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа"));
	Если ВключатьНабор Тогда
		МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Набор"));
	КонецЕсли;
	
	Возврат МассивТиповНоменклатуры;
	
КонецФункции

#Область ПроцедурыРаботыССериями

// Структура параметров указания серий, возвращаемая соотвествующей процедурой модуля менеджера документа (обработки).
// Содержит свойства:
//
// ОБЯЗАТЕЛЬНЫЕ:
//	ИспользоватьСерииНоменклатуры - признак, нужно ли в документе заполнять статусы указания серий 
//	ПоляСвязиСерий - массив с именами реквизитов ТЧ Товары и ТЧ Серии, по которым устанавливается
//					 связь между табличными частями (поля связи "Номенклатура" и "Характеристика" 
//					 присутсвуют всегда, их отдельно указывать не нужно)
//	СкладскиеОперации - массив значений ПеречислениеСсылка.СкладскиеОперации - складские операции, оформляемые документом
//	ПолноеИмяОбъекта - Строка - полное имя объекта. Например, Документ.РеализацияТоваровУслуг
//	
//
// НЕОБЯЗАТЕЛЬНЫЕ:
//	ТолькоПросмотр - признак того, что серии в документе можно только просматривать (значение по умолчанию ЛОЖЬ)
//	ТоварВШапке - признак, что параметры указания серий определены для товара в шапке (иначе - для товара в ТЧ) (значение по умолчанию ЛОЖЬ)
//	БлокироватьДанныеФормы - признак того, что перед открытием форму указания серий, нужно заблокировать форму документа (значение по умолчанию ИСТИНА)
//								если ТолькоПросмотр = Истина, то данные формы не блокируются
//
//	ИмяТЧТовары - имя табличной части со списком товаров (значение по умолчанию - "Товары")
//	ИмяТЧСерии - имя табличной части со списком серий (значение по умолчанию - "Серии")
//	ИмяПоляКоличество - имя поля в ТЧ "Товары", в котором пользователь редактирует количество (значение по умолчанию - "КоличествоУпаковок")
//	ИмяПоляСклад     - имя реквизита склада (значение по умолчанию - "Склад")
//	ИмяПоляПомещение - имя реквизита помещения, если не задано, значит в документе нет помещений
//	ИмяПоляДокументаРаспоряжения - Строка - если серии указываются в расходном ордере, то в этом параметре записывается имя поля распоряжения на отгрузку.
//											если серии указываются в накладной на поступление, то в этом параметрые записывается имя поле распоряжения на 
//												поступление.
//											Значение поля используются для отображения остатков в формах.
//
//	ЭтоОрдер - признак того, что документ является ордером (значение по умолчанию ЛОЖЬ)
//	ЭтоЗаказ - признак того, что документ является заказом (значение по умолчанию ЛОЖЬ)
//	ЭтоНакладная - признак того, что документ является накладной (значение по умолчанию ЛОЖЬ)
//
//	ТолькоСерииДляСебестоимости - нужно указывать только серии, по которым ведется учет себестоимости (значение по умолчанию ЛОЖЬ)
//	ПланированиеОтгрузки - использование параметра политики указания серий "УказыватьПриПланированииОтгрузки" (значение по умолчанию ЛОЖЬ)
//	ПланированиеОтора    - использование параметра политики указания серий "УказыватьПриПланированииОтбора" (значение по умолчанию ЛОЖЬ)
//	ПроверкаОтбора       - на адресном скакладе перед проверкой должны быть заполнены все серии, по которым ведется учет остатков
//	ФактОтбора - использование параметра политики указания серий "УказыватьПоФактуОтбора" (значение по умолчанию ЛОЖЬ)
//	ПодготовкаОрдера - параметр указывает, что ордер находится в статусе, когда происходит подготовка ордера и указание серий не обязательна (значение по умолчанию ЛОЖЬ)
//	ИменаПолейСтатусУказанияСерий - Массив - если в объекте несколько полей со статусом указания серий, то нужно добавить их имена в этот массив (значение по умолчанию пустой массив)
//	ИменаПолейДляОпределенияРаспоряжения - Массив - имена полей для определение распоржения, по которому отображаются остатки в форме подбора серий
//													имена полей табличной части указываются в формате Товары_ДокументРезерваСерий (значение по умолчанию пустой массив)
//	ИспользоватьАдресноеХранение - Булево -  на складе, по которому оформлен документ, используется адресное хранение (значение по умолчанию ЛОЖЬ)
//	ИмяИсточникаЗначенийВФормеОбъекта - Строка - значение по умолчанию "Объект", если данные хранятся в реквизитах формы, то нужно указать "ЭтоФорма"
//	ОтборПроверяемыхСтрок
//	ТолькоСерииСУчетомОстатков - Булево - необходимо указывать серии только тогда, когда по ним ведется учет остатков. (значение по умолчанию - ЛОЖЬ)
//	ОсобеннаяПроверкаСтатусовУказанияСерий - Булево - признак, что в модуле менеджера объявлена процедура ТекстЗапросаПроверкиЗаполненияСерий(ПараметрыУказанияСерий)(значение по умолчанию - ЛОЖЬ)
//	ПараметрыЗапроса - Структура - содержит параметры запроса, используемые в функции ТекстЗапросаЗаполненияСтатусовУказанияСерий.
//	СерииПриПланированииОтгрузкиУказываютсяВТЧСерии - Булево - значение по умолчанию - ЛОЖЬ
//
// Возвращаемое значение:
//	Структура.
//
Функция ПараметрыУказанияСерий() Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ИспользоватьСерииНоменклатуры",Неопределено);
	СтруктураПараметров.Вставить("УчитыватьСебестоимостьПоСериям",Неопределено);
	СтруктураПараметров.Вставить("СкладскиеОперации",Новый Массив); 
	СтруктураПараметров.Вставить("ПоляСвязи", Новый Массив);
	СтруктураПараметров.Вставить("ПолноеИмяОбъекта", "");
	
	СтруктураПараметров.Вставить("ТолькоПросмотр",Ложь);
	СтруктураПараметров.Вставить("ТоварВШапке",Ложь);
	СтруктураПараметров.Вставить("БлокироватьДанныеФормы",Истина);
	СтруктураПараметров.Вставить("ИмяТЧТовары","Товары");
	СтруктураПараметров.Вставить("ИмяТЧСерии","Серии");
	СтруктураПараметров.Вставить("ИмяПоляКоличество","Количество");
	СтруктураПараметров.Вставить("ИмяПоляСклад","Склад");
	СтруктураПараметров.Вставить("ИмяПоляСкладОтправитель",Неопределено);
	СтруктураПараметров.Вставить("ИмяПоляСкладПолучатель",Неопределено);
	СтруктураПараметров.Вставить("ИмяПоляПомещение",Неопределено);
	СтруктураПараметров.Вставить("ЭтоОрдер",Ложь);
	СтруктураПараметров.Вставить("ЭтоЗаказ",Ложь);      
	СтруктураПараметров.Вставить("ЭтоНакладная",Ложь);
	СтруктураПараметров.Вставить("ТолькоСерииДляСебестоимости",Ложь);
	СтруктураПараметров.Вставить("ПланированиеОтгрузки",Ложь);
	СтруктураПараметров.Вставить("ПланированиеОтбора",Ложь);
	СтруктураПараметров.Вставить("ПроверкаОтбора",Ложь);
	СтруктураПараметров.Вставить("ФактОтбора",Ложь);                                    
	СтруктураПараметров.Вставить("ПодготовкаОрдера",Ложь);
	СтруктураПараметров.Вставить("РегистрироватьСерии", Истина);
	СтруктураПараметров.Вставить("Дата",Дата(1,1,1));
	СтруктураПараметров.Вставить("ИменаПолейСтатусУказанияСерий",Новый Массив);
	СтруктураПараметров.Вставить("ИменаПолейДляОпределенияРаспоряжения",Новый Массив);
	СтруктураПараметров.Вставить("ИменаПолейДополнительные",Новый Массив);
	СтруктураПараметров.Вставить("ИспользоватьАдресноеХранение",Ложь);
	СтруктураПараметров.Вставить("ИмяИсточникаЗначенийВФормеОбъекта","Объект");
	СтруктураПараметров.Вставить("ОтборПроверяемыхСтрок", Неопределено);
	СтруктураПараметров.Вставить("ТолькоСерииСУчетомОстатков", Ложь);             
	СтруктураПараметров.Вставить("ОсобеннаяПроверкаСтатусовУказанияСерий", Ложь);
	СтруктураПараметров.Вставить("НужноОкруглятьКоличество", Истина);
	СтруктураПараметров.Вставить("ПараметрыЗапроса", Новый Структура);
	СтруктураПараметров.Вставить("СерииПриПланированииОтгрузкиУказываютсяВТЧСерии", Ложь);
	СтруктураПараметров.Вставить("ИспользуютсяТоварныеМеста", Ложь);
	
	СтруктураПараметров.Вставить("ОперацияДокумента", Неопределено);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Структура, которую возвращает форма подбора серии
// 
// Возвращаемое значение:
//  Структура - структура со следующими ключами:
//  *Значение - СправочникСсылка.СерииНоменклатуры
//  *ИдентификаторСтроки - Число - идентификатор строки таблицы формы, в которую, нужно подставить значение
//
Функция ВыбраннаяСерия() Экспорт
	
	Возврат Новый Структура("Значение,ЗначениеСписываемойСерии,ИдентификаторТекущейСтроки,ИмяТЧ");
	
КонецФункции

// Процедура обновляет кеш ключевых реквизитов текущей строки товаров. По ключевым реквизитам осуществляется связь
//  между ТЧ серий и ТЧ товаров
//
// Параметры:
//  ТекущаяСтрока			 - ДанныеФормыЭлементКоллекции - строка, по которой обновляется кеш.
//  КэшированныеЗначения	 - Структура - переменная модуля формы, в которой храняться кешируемые значения
//  ПараметрыУказанияСерий	 - Структура - структура параметров указания серий, возвращаемая соотвествующей процедурой модуля менеджера документа
//  Копирование				 - Булево - признак, что кешированная строка скопирована (параметр события ПриНачалеРедактирования)
//
Процедура ОбновитьКешированныеЗначенияДляУчетаСерий(ТекущаяСтрока,КэшированныеЗначения,ПараметрыУказанияСерий,Копирование = Ложь) Экспорт
	
	Если Не ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры Тогда
		Возврат;
	КонецЕсли;
	
	Если КэшированныеЗначения = Неопределено Тогда
		КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	КонецЕсли;
	
	Если ТекущаяСтрока <> Неопределено
		И (Не Копирование
		Или ПараметрыУказанияСерий.ИмяТЧТовары = ПараметрыУказанияСерий.ИмяТЧСерии) Тогда
		
		КэшированныеЗначения.Вставить("Номенклатура",ТекущаяСтрока.Номенклатура);
		КэшированныеЗначения.Вставить("Характеристика",ТекущаяСтрока.Характеристика);
		
		Если ТекущаяСтрока.Свойство(ПараметрыУказанияСерий.ИмяПоляКоличество) Тогда
			КэшированныеЗначения.Вставить(ПараметрыУказанияСерий.ИмяПоляКоличество, ТекущаяСтрока[ПараметрыУказанияСерий.ИмяПоляКоличество]);
		КонецЕсли;
		
		Если ТекущаяСтрока.Свойство("Отменено") Тогда
			КэшированныеЗначения.Вставить("Отменено",ТекущаяСтрока.Отменено);
		КонецЕсли;
		
		Для Каждого СтрМас из ПараметрыУказанияСерий.ПоляСвязи Цикл
			КэшированныеЗначения.Вставить(СтрМас,ТекущаяСтрока[СтрМас]);
		КонецЦикла;
		
		Для Каждого СтрМас из ПараметрыУказанияСерий.ИменаПолейДополнительные Цикл
			КэшированныеЗначения.Вставить(СтрМас,ТекущаяСтрока[СтрМас]);
		КонецЦикла;
		
	Иначе
		КэшированныеЗначения.Вставить("Номенклатура",Неопределено);
		КэшированныеЗначения.Вставить("Характеристика",Неопределено);
		КэшированныеЗначения.Вставить(ПараметрыУказанияСерий.ИмяПоляКоличество ,0);
		
		Если ПараметрыУказанияСерий.ЭтоЗаказ Тогда
			КэшированныеЗначения.Вставить("Отменено", Неопределено);
		КонецЕсли;
		
		Для Каждого СтрМас из ПараметрыУказанияСерий.ПоляСвязи Цикл
			КэшированныеЗначения.Вставить(СтрМас,Неопределено);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Функция определяет возможность регистрации новых серий, при указании серий в документе
//
// Параметры:
//  ПараметрыУказанияСерий	 - Структура - структура параметров указания серий, возвращаемая соответствующей процедурой модуля менеджера документа
//  	  
// Возвращаемое значение:
//   - Булево - ИСТИНА - можно регистрировать новые серии, ЛОЖЬ - серии можно подбирать только по остаткам
//
Функция НеобходимоРегистрироватьСерии(ПараметрыУказанияСерий) Экспорт
	
	Если (ПараметрыУказанияСерий.ПланированиеОтгрузки
		   		Или ПараметрыУказанияСерий.ПланированиеОтбора  
		   		Или ПараметрыУказанияСерий.ПодготовкаОрдера)
				И Не ПараметрыУказанияСерий.ФактОтбора Тогда
		
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Извлекает из штрихкода информацию о номере и сроке годности. 
// Работает только для штрихкодов, сгенерированных обработкой печати штрихкодов и номеров 
// серий, сгенерированных формой регистрации серий
//
// Параметры:
//	Штрихкод - Строка - штрихкод, из которого нужно извлечь информацию;
//	ЕстьПолеНомер - Булево - признак, что для серии, чей штрихкод передан, используется номер;
//	ЕстьПолеГоденДо - Булево - признак, что для серии, чей штрихкод передан, используется номер.
//
// Возвращаемое значение:
//	Структура:
//		* Номер - Строка - номер, извлеченный из штрихкода, если номера у серии нет - пустая строка;
//		* ГоденДо - Дата - дата срока годности, если срока годности у серии нет - пустая дата.
//
Функция ИнформацияОСерииИзШтрихкода(Знач Штрихкод, ЕстьПолеНомер, ЕстьПолеГоденДо) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Номер", "");
	Результат.Вставить("ГоденДо", '00010101');
	Результат.Вставить("ЕстьОшибка", Ложь);
	
	Штрихкод = СокрЛП(Штрихкод);
	
	Если ЕстьПолеНомер Тогда
		
		Результат.Номер = Штрихкод;
		
		Если ЕстьПолеГоденДо Тогда
			
			Если СтрДлина(Результат.Номер) >= 6 Тогда
				
				Если СтрДлина(Результат.Номер) >= 8 Тогда
					СрокГодностиИзШтрихкода = Прав(Результат.Номер, 8);
					Результат.ГоденДо		= ДатаИзСтрокиШтрихкода(СрокГодностиИзШтрихкода);
					
					Если ЗначениеЗаполнено(Результат.ГоденДо) Тогда
						Результат.Номер = Лев(Результат.Номер,СтрДлина(Результат.Номер) - 8);
					КонецЕсли;	
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(Результат.ГоденДо) Тогда
					
					СрокГодностиИзШтрихкода = Прав(Результат.Номер, 6);
					Результат.ГоденДо		= ДатаИзСтрокиШтрихкода(СрокГодностиИзШтрихкода);
					
					Если ЗначениеЗаполнено(Результат.ГоденДо) Тогда
						Результат.Номер = Лев(Результат.Номер,СтрДлина(Результат.Номер) - 6);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	Иначе
		
		Результат.ГоденДо = ДатаИзСтрокиШтрихкода(Штрихкод);
		
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Результат.Номер)
		И Не ЗначениеЗаполнено(Результат.ГоденДо) Тогда
		
		Если ЕстьПолеНомер
			И ЕстьПолеГоденДо Тогда
			ТекстСообщения = НСтр("ru = 'Ошибка преобразования штрихкода %Штрихкод% в номер серии и срок годности. Попробуйте повторить сканирование.'");
		ИначеЕсли ЕстьПолеНомер Тогда
			ТекстСообщения = НСтр("ru = 'Ошибка преобразования штрихкода %Штрихкод% в номер серии. Попробуйте повторить сканирование.'");
		Иначе 
			ТекстСообщения = НСтр("ru = 'Ошибка преобразования штрихкода %Штрихкод% в срок годности. Попробуйте повторить сканирование.'");
		КонецЕсли;
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Штрихкод%", Штрихкод);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Результат.ЕстьОшибка);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтатусыСерийСерияНеУказана() Экспорт
	
	//Порядок статусов следования используется в ПересчитатьСтатусУказанияСерийПриОбработке
	//и должен соотвествовать порядку в других фунциях СтатусыСерийСерия
	Статусы = Новый Массив;
	Статусы.Добавить(1);
	Статусы.Добавить(3);
	Статусы.Добавить(5);
	Статусы.Добавить(7);
	Статусы.Добавить(9);
	Статусы.Добавить(13);
	Статусы.Добавить(17);
	
	Возврат Статусы;
	
КонецФункции

Функция СтатусыСерийСерияУказана() Экспорт
	
	//Порядок статусов следования используется в ПересчитатьСтатусУказанияСерийПриОбработке
	//и должен соотвествовать порядку в других фунциях СтатусыСерийСерия
	Статусы = Новый Массив;
	Статусы.Добавить(2);
	Статусы.Добавить(4);
	Статусы.Добавить(6);
	Статусы.Добавить(8);
	Статусы.Добавить(10);
	Статусы.Добавить(14);
	Статусы.Добавить(18);
	
	Возврат Статусы;
	
КонецФункции

Функция СтатусыСерийСериюМожноУказать() Экспорт
	
	//Порядок статусов следования используется в ПересчитатьСтатусУказанияСерийПриОбработке
	//и должен соотвествовать порядку в других фунциях СтатусыСерийСерия
	Статусы = Новый Массив;
	Статусы.Добавить(21);
	Статусы.Добавить(23);
	Статусы.Добавить(25);
	Статусы.Добавить(27);
	Статусы.Добавить(28);
	Статусы.Добавить(11);
	Статусы.Добавить(15);
	
	Возврат Статусы;
	
КонецФункции

Процедура ПересчитатьСтатусУказанияСерийПриОбработке(ПараметрыУказанияСерий, ТекущийСтатус, СерииУказаныПолностью, КоличествоСерий, ВариантОбеспечения = Неопределено, ТекущиеДанные = Неопределено) Экспорт
	
	//Если серия указывается в ТЧ Товары, то значение параметра КоличествоСерий должно быть - Неопределено, т.к. в этом случае
	//статус указания серий не зависит от количества - в этом случае статус указания серий зависит только от того, указана серия 
	//или нет.
	
	//Если серия указывается в ТЧ Товары, то в параметре СерииУказаныПолностью передается признак - заполнена серия или нет,
	//иначе - равно ли количество товаров количеству серий (если количество товаров 0, то параметр должен быть ЛОЖЬ)
	
	Если ТекущийСтатус = 0 Тогда
		Возврат;
	КонецЕсли;
	
	
	
	ПрименятьСтатусМожноУказать = (ПараметрыУказанияСерий.ПодготовкаОрдера
									Или ПараметрыУказанияСерий.ЭтоЗаказ
										И ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада"))
									И Не СерииУказаныПолностью
									И (КоличествоСерий = 0
										Или КоличествоСерий = Неопределено);
		
	ИндексСтатуса = СтатусыСерийСерияНеУказана().Найти(ТекущийСтатус);

	Если ИндексСтатуса = Неопределено Тогда
		ИндексСтатуса = СтатусыСерийСерияУказана().Найти(ТекущийСтатус);
	КонецЕсли;
	
	Если ИндексСтатуса = Неопределено Тогда
		ИндексСтатуса = СтатусыСерийСериюМожноУказать().Найти(ТекущийСтатус);
	КонецЕсли;
	
	Если Не СерииУказаныПолностью
		И ПрименятьСтатусМожноУказать Тогда
		МассивРезультатов = СтатусыСерийСериюМожноУказать();
	ИначеЕсли Не СерииУказаныПолностью Тогда
		МассивРезультатов = СтатусыСерийСерияНеУказана();
	ИначеЕсли СерииУказаныПолностью Тогда
		МассивРезультатов = СтатусыСерийСерияУказана();
	КонецЕсли;
	
	ТекущийСтатус = МассивРезультатов[ИндексСтатуса];
	
КонецПроцедуры

Функция ВЭтомСтатусеСерииУказываютсяВТЧТовары(СтатусУказанияСерий, ПараметрыУказанияСерий) Экспорт
	
	Если ПараметрыУказанияСерий.ИмяТЧТовары = ПараметрыУказанияСерий.ИмяТЧСерии Тогда
		Возврат Истина;
	КонецЕсли;
	
	Статусы = Новый Массив; //Статусы серий указываемых в ТЧ Товары
	Статусы.Добавить(0);
	Статусы.Добавить(13);
	Статусы.Добавить(14);
	Статусы.Добавить(15);
	Статусы.Добавить(17);
	Статусы.Добавить(18);
	Если Не ПараметрыУказанияСерий.СерииПриПланированииОтгрузкиУказываютсяВТЧСерии Тогда
		Статусы.Добавить(9);
		Статусы.Добавить(10);
		Статусы.Добавить(11);
	КонецЕсли;
	
	Если Статусы.Найти(СтатусУказанияСерий) = Неопределено Тогда
		
		Возврат Ложь;
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

Функция ВЭтомСтатусеСерииНеУказываются(СтатусУказанияСерий, ПараметрыУказанияСерий) Экспорт
	
	Если СтатусУказанияСерий = 0 
		Или (СтатусыСерийСериюМожноУказать().Найти(СтатусУказанияСерий) <> Неопределено
			И Не ПараметрыУказанияСерий.ПодготовкаОрдера) Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ВЭтомСтатусеСерииУказываютсяВТЧСерии(СтатусУказанияСерий, ПараметрыУказанияСерий) Экспорт
	
	Возврат Не ВЭтомСтатусеСерииНеУказываются(СтатусУказанияСерий, ПараметрыУказанияСерий)
		И Не ВЭтомСтатусеСерииУказываютсяВТЧТовары(СтатусУказанияСерий, ПараметрыУказанияСерий);
	
КонецФункции

Функция ЗначенияПолейДляОпределенияРаспоряжения(Объект, ТекущаяСтрока, ПараметрыУказанияСерий) Экспорт
	
	ЗначенияПолейДляОпределенияРаспоряжения = Новый Структура;
	
	Для Каждого СтрМас из ПараметрыУказанияСерий.ИменаПолейДляОпределенияРаспоряжения Цикл
		
		ПоложениеРазделителя = СтрНайти(СтрМас, "_");		
		
		Если ПоложениеРазделителя = 0 Тогда
			ЗначенияПолейДляОпределенияРаспоряжения.Вставить(СтрМас, Объект[СтрМас]);
		Иначе
			ИмяПоля = Прав(СтрМас, СтрДлина(СтрМас)- ПоложениеРазделителя);
			ЗначенияПолейДляОпределенияРаспоряжения.Вставить(СтрМас, ТекущаяСтрока[ИмяПоля]);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЗначенияПолейДляОпределенияРаспоряжения;
КонецФункции

Функция СуффиксВИмениПоляСтатусУказанияСерий(ИмяПоляСтатус) Экспорт
	
	Возврат 
		Прав(ИмяПоляСтатус, СтрДлина(ИмяПоляСтатус) - СтрНайти(ИмяПоляСтатус, "СтатусУказанияСерий") - 18);//СтрДлина("СтатусУказанияСерий") + 1 = 18 
	
КонецФункции

Функция ДатаИзСтрокиШтрихкода(Знач Штрихкод)
	ШтрихкодДата = '00010101';	
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Штрихкод) Тогда
		Если СтрДлина(Штрихкод) = 8 Тогда
			
			Штрихкод =  "20" + Сред(Штрихкод,5,2) + Сред(Штрихкод,3,2) + Лев(Штрихкод,2) + Прав(Штрихкод, 2) + "0000";
			
			Попытка
				ШтрихкодДата = Дата(Штрихкод);
			Исключение
				ШтрихкодДата = '00010101';
			КонецПопытки;             
		ИначеЕсли СтрДлина(Штрихкод) = 6 Тогда
			
			Штрихкод =  "20" + Сред(Штрихкод,5,2) + Сред(Штрихкод,3,2) + Лев(Штрихкод,2) + "000000";
			
			Попытка
				ШтрихкодДата = Дата(Штрихкод);
			Исключение
				ШтрихкодДата = '00010101';
			КонецПопытки;             
		КонецЕсли;
	КонецЕсли;
	
	Возврат ШтрихкодДата;
КонецФункции

// Рассчитывает представление серии. Расчет может производится по шаблону рабочего наименования серии - тогда
// фукнция должна быть вызвана с сервера. Если шаблон не задан или фукнция вызвана с клиента, то расчет производится
// по предопределенному шаблону
//
// Параметры:
//  ПараметрыШаблона	 - Структура - см. Справочники.ВидыНоменклатуры.НастройкиИспользованияСерий
//  ЗначенияРеквизитов	 - Структура, УправляемаяФорма, СправочникОбъект.СерииНоменклатуры, ДанныеФормыЭлементКоллекции
// 
// Возвращаемое значение:
//  Строка - 
//
Функция ПредставлениеСерии(ПараметрыШаблона, ЗначенияРеквизитов, ДобавитьСловоНовая = Ложь) Экспорт
	
	Представление = "";
	
	#Если Сервер Тогда
	Если ЗначениеЗаполнено(ПараметрыШаблона.ШаблонРабочегоНаименованияСерии) Тогда
	 
		Представление = НоменклатураСервер.НаименованиеПоШаблону(ПараметрыШаблона.ШаблонРабочегоНаименованияСерии, ЗначенияРеквизитов);
		Возврат Представление;
		
	КонецЕсли;
	#КонецЕсли
	
	ЧастиПредставления = Новый Массив;
	
	Если ДобавитьСловоНовая Тогда
		ЧастиПредставления.Добавить(НСтр("ru = '<Новая>'"));
	КонецЕсли;
	
	Если ПараметрыШаблона.ИспользоватьНомерСерии Тогда
		ЧастиПредставления.Добавить(НСтр("ru = '%Номер%'"));	
	КонецЕсли;
	
	Если ПараметрыШаблона.ИспользоватьСрокГодностиСерии Тогда
		ЧастиПредставления.Добавить(НСтр("ru = 'до %ГоденДо%'"));
	КонецЕсли;
	
	Если ПараметрыШаблона.ИспользоватьНомерКИЗГИСМСерии Тогда
		Если ПараметрыШаблона.ИспользоватьНомерСерии Тогда
			ЧастиПредставления.Добавить(НСтр("ru = 'КиЗ %НомерКиЗГИСМ%'"));
		Иначе
			ЧастиПредставления.Добавить(НСтр("ru = '%НомерКиЗГИСМ%'"));
		КонецЕсли;
	КонецЕсли;
	
	Представление = СтрСоединить(ЧастиПредставления, " ");	
	Представление = СтрЗаменить(Представление, "%Номер%", ЗначенияРеквизитов.Номер);
	Представление = СтрЗаменить(Представление, "%ГоденДо%", Формат(ЗначенияРеквизитов.ГоденДо,ПараметрыШаблона.ФорматнаяСтрокаСрокаГодности));
	Представление = СтрЗаменить(Представление, "%НомерКиЗГИСМ%", ЗначенияРеквизитов.НомерКиЗГИСМ);
	Возврат Представление;
	
КонецФункции

#КонецОбласти
