﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УТ 11.4.1
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрНакопления.ПартииТоваровОрганизаций";
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеРегистра.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.ПартииТоваровОрганизаций КАК ДанныеРегистра
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Ключи
	|	ПО Ключи.Ссылка = ДанныеРегистра.АналитикаУчетаНоменклатуры
	|ГДЕ
	|	(ТИПЗНАЧЕНИЯ(Ключи.Склад) = ТИП(Справочник.Партнеры)
	|		ИЛИ ТИПЗНАЧЕНИЯ(Ключи.Склад) = ТИП(Справочник.Организации))
	|	И ДанныеРегистра.ВидЗапасов <> ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|");
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
КонецПроцедуры

// Обработчик обновления УТ 11.4.1 для движений регистра.
// Очищатся виды запасов для движений, где в ключе аналитике склад это СправочникСсылка.Партнеры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ПартииТоваровОрганизаций";
	МетаданныеРегистра = Метаданные.РегистрыНакопления.ПартииТоваровОрганизаций;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра = ПолноеИмяРегистра;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(Параметры.Очередь, Неопределено, ПолноеИмяРегистра);
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Движения.Регистратор                   КАК Регистратор,
	|	Движения.Период                        КАК Период,
	|	Движения.ВидДвижения                   КАК ВидДвижения,
	|	Движения.АналитикаУчетаНоменклатуры    КАК АналитикаУчетаНоменклатуры,
	|	Движения.Организация                   КАК Организация,
	|	Движения.ДокументПоступления           КАК ДокументПоступления,
	|	ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(Ключи.Склад) = ТИП(Справочник.Партнеры)
	|			ИЛИ ТИПЗНАЧЕНИЯ(Ключи.Склад) = ТИП(Справочник.Организации)
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ Движения.ВидЗапасов
	|	КОНЕЦ                                  КАК ВидЗапасов,
	|	Движения.АналитикаУчетаПартий          КАК АналитикаУчетаПартий,
	|	Движения.Количество                    КАК Количество,
	|	Движения.Стоимость                     КАК Стоимость,
	|	Движения.СтоимостьБезНДС               КАК СтоимостьБезНДС,
	|	Движения.СтоимостьРегл                 КАК СтоимостьРегл,
	|	Движения.НДСРегл                       КАК НДСРегл,
	|	Движения.ПостояннаяРазница             КАК ПостояннаяРазница,
	|	Движения.ВременнаяРазница              КАК ВременнаяРазница,
	|	Движения.Номенклатура                  КАК Номенклатура,
	|	Движения.Характеристика                КАК Характеристика,
	|	Движения.НалогообложениеНДС            КАК НалогообложениеНДС,
	|	Движения.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	Движения.КорВидЗапасов                 КАК КорВидЗапасов,
	|	Движения.ДокументИсточник              КАК ДокументИсточник,
	|	Движения.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	Движения.Первичное                     КАК Первичное,
	|	Движения.СтатьяРасходовСписания        КАК СтатьяРасходовСписания,
	|	Движения.АналитикаРасходов             КАК АналитикаРасходов	
	|ИЗ
	|	РегистрНакопления.ПартииТоваровОрганизаций КАК Движения
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Ключи
	|	ПО Ключи.Ссылка = Движения.АналитикаУчетаНоменклатуры
	|ГДЕ
	|	Движения.Регистратор = &Регистратор
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	Пока Выборка.Следующий() Цикл
		
		Регистратор = Выборка.Регистратор;
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра + ".НаборЗаписей");
			ЭлементБлокировки.УстановитьЗначение("Регистратор", Регистратор);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;

			Блокировка.Заблокировать();
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("Регистратор", Регистратор);
			
			Набор = РегистрыНакопления.ПартииТоваровОрганизаций.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Регистратор);
			
			Результат = Запрос.Выполнить().Выгрузить();
			Если Результат.Количество() = 0 Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Регистратор, ДополнительныеПараметры);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Набор.Загрузить(Результат);
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Регистратор% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регистратор%", Регистратор);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
				Регистратор.Метаданные(), ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли