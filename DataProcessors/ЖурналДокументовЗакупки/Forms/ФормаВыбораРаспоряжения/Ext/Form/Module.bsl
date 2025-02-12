﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОтборСписка = Параметры.Отбор;
	Регистратор = Параметры.Регистратор;
	Склад       = Параметры.Склад;
	
	Если Параметры.Отбор.Свойство("СкрыватьДопОтборы") Тогда
		Элементы.ПоказатьВсе.Видимость = НЕ Параметры.СкрыватьДопОтборы;
	КонецЕсли; 
	
	ЗаполнитьСписокРаспоряжений();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРаспоряжений

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьВсеПриИзменении(Элемент)
	
	ЗаполнитьСписокРаспоряжений()
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ОбщегоНазначенияУТКлиент.ПроверитьНаличиеВыделенныхВСпискеСтрок(Элементы.СписокРаспоряжений) Тогда
		Закрыть(Элементы.СписокРаспоряжений.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокРаспоряжений()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаЗаказы.ЗаказПоставщику КАК ЗаказПоставщику,
	|	СУММА(ТаблицаЗаказы.КОформлению) КАК КОформлению
	|ПОМЕСТИТЬ
	|	ВтТаблицаЗаказы
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказыОстатки.ЗаказПоставщику КАК ЗаказПоставщику,
	|		ЗаказыОстатки.КОформлениюОстаток КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаказыПоставщикам.Остатки(
	|				,
	|				ВЫБОР
	|					КОГДА &ИспользоватьОтборы
	|						ТОГДА ЗаказПоставщику.Организация = &Организация
	|							И ЗаказПоставщику.Контрагент = &Контрагент
	|							И ЗаказПоставщику.Договор = &Договор
	|							И ЗаказПоставщику.ВариантПриемкиТоваров = &ВариантПриемкиТоваров
	|							И ЗаказПоставщику.Партнер = &Партнер
	|							И ЗаказПоставщику.Соглашение = &Соглашение
	|							И ЗаказПоставщику.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|							И ЗаказПоставщику.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|							И (ЗаказПоставщику.Валюта = &Валюта
	|							И ЗаказПоставщику.НалогообложениеНДС = &НалогообложениеНДС
	|							И ЗаказПоставщику.ПорядокРасчетов = &ПорядокРасчетов
	|							И ЗаказПоставщику.НаправлениеДеятельности = &НаправлениеДеятельности
	|								ИЛИ ЗаказПоставщику.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи))
	|							И (Склад = &Склад
	|								ИЛИ Склад В ИЕРАРХИИ (&Склад)
	|								ИЛИ Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|					ИНАЧЕ ИСТИНА
	|				КОНЕЦ) КАК ЗаказыОстатки
	|			
	|			ОБЪЕДИНИТЬ ВСЕ
	|			
	|		ВЫБРАТЬ
	|			ЗаказыДвижения.ЗаказПоставщику,
	|			ВЫБОР
	|				КОГДА ЗаказыДвижения.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|					ТОГДА -ЗаказыДвижения.КОформлению
	|				ИНАЧЕ ЗаказыДвижения.КОформлению
	|			КОНЕЦ
	|		ИЗ
	|			РегистрНакопления.ЗаказыПоставщикам КАК ЗаказыДвижения
	|		ГДЕ
	|			ЗаказыДвижения.Регистратор = &Регистратор
	|			И ВЫБОР
	|					КОГДА &ИспользоватьОтборы
	|						ТОГДА ЗаказыДвижения.Активность
	|							И ЗаказыДвижения.ЗаказПоставщику.Организация = &Организация
	|							И ЗаказыДвижения.ЗаказПоставщику.Контрагент = &Контрагент
	|							И ЗаказыДвижения.ЗаказПоставщику.Договор = &Договор
	|							И ЗаказыДвижения.ЗаказПоставщику.ВариантПриемкиТоваров = &ВариантПриемкиТоваров
	|							И ЗаказыДвижения.ЗаказПоставщику.Партнер = &Партнер
	|							И ЗаказыДвижения.ЗаказПоставщику.Соглашение = &Соглашение
	|							И ЗаказыДвижения.ЗаказПоставщику.ЦенаВключаетНДС = &ЦенаВключаетНДС
	|							И ЗаказыДвижения.ЗаказПоставщику.ВернутьМногооборотнуюТару = &ВернутьМногооборотнуюТару
	|							И (ЗаказыДвижения.ЗаказПоставщику.Валюта = &Валюта
	|							И ЗаказыДвижения.ЗаказПоставщику.НалогообложениеНДС = &НалогообложениеНДС
	|							И ЗаказыДвижения.ЗаказПоставщику.ПорядокРасчетов = &ПорядокРасчетов
	|							И ЗаказыДвижения.ЗаказПоставщику.НаправлениеДеятельности = &НаправлениеДеятельности
	|								ИЛИ ЗаказПоставщику.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи))
	|							И (ЗаказыДвижения.Склад = &Склад
	|								ИЛИ ЗаказыДвижения.Склад В ИЕРАРХИИ (&Склад)
	|								ИЛИ ЗаказыДвижения.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка))
	|				ИНАЧЕ ИСТИНА
	|			КОНЕЦ) КАК ТаблицаЗаказы
	|ГДЕ
	|	ТаблицаЗаказы.КОформлению > 0
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаЗаказы.ЗаказПоставщику;
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаказыПоставщикам.Ссылка КАК Ссылка,
	|	ТИПЗНАЧЕНИЯ(ЗаказыПоставщикам.Ссылка) КАК ТипРаспоряжения,
	|	ЗаказыПоставщикам.Дата КАК Дата,
	|	ЗаказыПоставщикам.Номер КАК Номер,
	|	ЗаказыПоставщикам.Партнер КАК Партнер,
	|	ЗаказыПоставщикам.Контрагент КАК Контрагент,
	|	ЗаказыПоставщикам.Договор КАК Договор,
	|	ЗаказыПоставщикам.Соглашение КАК Соглашение,
	|	ЗаказыПоставщикам.Организация КАК Организация,
	|	ЗаказыПоставщикам.Склад КАК Склад,
	|	ЗаказыПоставщикам.Валюта КАК Валюта,
	|	ЗаказыПоставщикам.Менеджер КАК Менеджер,
	|	ЗаказыПоставщикам.Статус КАК Статус,
	|	ЗаказыПоставщикам.СуммаДокумента КАК СуммаДокумента,
	|	ЗаказыПоставщикам.Приоритет КАК Приоритет,
	|	ЗаказыПоставщикам.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ЗаказыПоставщикам.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЗаказыПоставщикам.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ЗаказыПоставщикам.ПорядокРасчетов КАК ПорядокРасчетов,
	|	ЗаказыПоставщикам.Комментарий КАК Комментарий,
	|	ВЫБОР
	|		КОГДА ЗаказыПоставщикам.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания)
	|			ТОГДА 0
	|		КОГДА ЗаказыПоставщикам.Приоритет В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.Приоритеты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КартинкаПриоритета
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказыПоставщикам
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВтТаблицаЗаказы КАК ТаблицаЗаказы
	|		ПО ЗаказыПоставщикам.Ссылка = ТаблицаЗаказы.ЗаказПоставщику
	|ГДЕ 
	|	ЕСТЬNULL(ТаблицаЗаказы.КОформлению,0) > 0
	|	И &УсловиеХозяйственнойОперации";
	
	
	ХозяйственнаяОперация = Неопределено;
	
	Если ОтборСписка.Свойство("ХозяйственнаяОперация", ХозяйственнаяОперация) Тогда
		
		Условие = "ЗаказыПоставщикам.ХозяйственнаяОперация В (&СписокХозяйственныхОпераций)";
		
		Если ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
			
			Запрос.УстановитьПараметр("СписокХозяйственныхОпераций", ОтборСписка.ХозяйственнаяОперация);
			
		Иначе
			
			СписокОпераций = Новый СписокЗначений;
			СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
			
			Условие = "НЕ"+ " " + Условие;
			Запрос.УстановитьПараметр("СписокХозяйственныхОпераций", СписокОпераций);
			
		КонецЕсли;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеХозяйственнойОперации", Условие);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеХозяйственнойОперации" , "ИСТИНА");
	КонецЕсли;
	
	ИспользоватьОтборы = НЕ ПоказатьВсе;
	Запрос.УстановитьПараметр("ИспользоватьОтборы", ИспользоватьОтборы);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаХранениеСПравомПродажи Тогда
		Запрос.УстановитьПараметр("Валюта",						Неопределено);
		Запрос.УстановитьПараметр("НалогообложениеНДС",			Неопределено);
		Запрос.УстановитьПараметр("НаправлениеДеятельности",	Неопределено);
		Запрос.УстановитьПараметр("ПорядокРасчетов",			Неопределено);
	Иначе
		Запрос.УстановитьПараметр("Валюта",						ОтборСписка.Валюта);
		Запрос.УстановитьПараметр("НалогообложениеНДС",			ОтборСписка.НалогообложениеНДС);
		Запрос.УстановитьПараметр("НаправлениеДеятельности",	ОтборСписка.НаправлениеДеятельности);
		Запрос.УстановитьПараметр("ПорядокРасчетов",			ОтборСписка.ПорядокРасчетов);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация",				ОтборСписка.Организация);
	Запрос.УстановитьПараметр("Контрагент",					ОтборСписка.Контрагент);
	Запрос.УстановитьПараметр("Партнер",					ОтборСписка.Партнер);
	Запрос.УстановитьПараметр("Соглашение",					ОтборСписка.Соглашение);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС",			ОтборСписка.ЦенаВключаетНДС);
	Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару",	ОтборСписка.ВернутьМногооборотнуюТару);
	Запрос.УстановитьПараметр("Договор",					ОтборСписка.Договор);
	Запрос.УстановитьПараметр("ВариантПриемкиТоваров",		ОтборСписка.ВариантПриемкиТоваров);
	
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Результат = Запрос.Выполнить();
	СписокРаспоряжений.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

#КонецОбласти