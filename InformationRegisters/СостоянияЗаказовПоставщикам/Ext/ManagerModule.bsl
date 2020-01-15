﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура по переданной ссылке на заказ расчитывает и записывает в регистр сведений состояние заказа
//
//	Параметры:
//		Заказы - ДокументСсылка - документ, в рамках проведения которого перерасчитывается состояние
//		Отказ - Булево - признак прерывания обработки проведения
//		УдалениеПроведения - Булево - признак обработки удаления проведения
//		Очередь - Число - Очередь обработчиков обновления
//
Процедура ОтразитьСостояниеЗаказа(Заказы, Отказ, УдалениеПроведения = Ложь, Очередь = Неопределено) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Заказы) = Тип("Массив") Тогда
		МассивСсылок = Заказы;
	ИначеЕсли ОбщегоНазначения.ЗначениеСсылочногоТипа(Заказы) Тогда
		МассивСсылок = Новый Массив;
		МассивСсылок.Добавить(Заказы);
	Иначе
		МассивСсылок = Заказы.ДополнительныеСвойства.МассивЗависимыхЗаказовПоставщикам;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(МассивСсылок) Тогда
		Возврат;
	КонецЕсли;
	
	Если УдалениеПроведения Тогда
		
		Для Каждого СтрокаСсылка Из МассивСсылок Цикл
			Набор = РегистрыСведений.СостоянияЗаказовПоставщикам.СоздатьНаборЗаписей();
			Набор.Отбор.Заказ.Установить(СтрокаСсылка);
			Набор.Записать(Истина);
		КонецЦикла;
		
		Возврат
		
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура("Заказ, Состояние, ДатаСобытия, 
		|СуммаОплаты, ПроцентОплаты, СуммаПоступления, ПроцентПоступления, СуммаДолга, ПроцентДолга, ЕстьРасхожденияОрдерНакладная");
	
	ТаблицаСостоянийЗаказов = ТаблицаСостоянийЗаказов(МассивСсылок);
	ТаблицаПредыдущихСостоянийЗаказов = ТаблицаПредыдущихСостоянийЗаказов(МассивСсылок);
		
	Для Каждого СтрокаТаблицы Из ТаблицаСостоянийЗаказов Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТаблицы);
		МассивДействующихСостояний = ТаблицаПредыдущихСостоянийЗаказов.НайтиСтроки(СтруктураПоиска);
		
		СостояниеИзменено = НЕ Булево(МассивДействующихСостояний.Количество());
		Если СостояниеИзменено Тогда
			
			Набор = РегистрыСведений.СостоянияЗаказовПоставщикам.СоздатьНаборЗаписей();
			Набор.Отбор.Заказ.Установить(СтрокаТаблицы.Заказ);
			
			СтрокаНабора = Набор.Добавить();
			
			ОкруглитьПроценты(СтрокаТаблицы.ПроцентПоступления);
			ОкруглитьПроценты(СтрокаТаблицы.ПроцентОплаты);
			ОкруглитьПроценты(СтрокаТаблицы.ПроцентДолга);
			
			ЗаполнитьЗначенияСвойств(СтрокаНабора, СтрокаТаблицы);
			
			Попытка
				Если Очередь <> Неопределено Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
				Иначе
					Набор.Записать(Истина);
				КонецЕсли;
			Исключение
				ТекстСообщения = НСтр("ru = 'Не удалось отразить состояние заказа поставщику: %Ссылка% по причине: %Причина%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", СтрокаТаблицы.Заказ);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
					Метаданные.Документы.ЗаказПоставщику, СтрокаТаблицы.Заказ, ТекстСообщения);
			КонецПопытки;
		Иначе
			Если Очередь <> Неопределено Тогда
				Набор = РегистрыСведений.СостоянияЗаказовПоставщикам.СоздатьНаборЗаписей();
				Набор.Отбор.Заказ.Установить(СтрокаТаблицы.Заказ);
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Набор);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Округляет проценты отгрузки, оплаты, долга
//
// Параметры:
//	ОкругляемоеЧисло - Число - округляемое число
//
Процедура ОкруглитьПроценты(ОкругляемоеЧисло)
	
	Если ОкругляемоеЧисло > 99
		И ОкругляемоеЧисло < 100 Тогда
		
		ОкругляемоеЧисло = 99;
		
	КонецЕсли;
	
	Если ОкругляемоеЧисло > 0
		И ОкругляемоеЧисло < 1 Тогда
		
		ОкругляемоеЧисло = 1;
		
	КонецЕсли;
	
КонецПроцедуры

//Функция возвращает таблицу значений с состояниями документов.
//
//	Параметры:
//		СсылкиНаДокументы - Массив - (состоящий из ДокументСсылка) ссылки на документы, по которым
//					нужно рассчитать состояние. В модуле менеджера документов должна быть определена функция
//					ТекстЗапросаДляРасчетаДатыАктуальностиСостоянийЗаказов(), которая возвращает текст запроса по датам актуальности и
//					ТекстЗапросаДляРасчетаСостоянийЗаказов(), которая возвращает текст запроса по состояниям заказов.
//	Возвращаемое значение:
//		ТаблицаЗначений:
//			Заказ - ДокументСсылка
//			Состояние - ПеречислениеСсылка.СостоянияЗаказовПоставщикам
//			ДатаСобытия - Дата
//			СуммаОплаты - Число
//			ПроцентОплаты - Число
//			СуммаПоступления - Число
//			ПроцентПоступления - Число
//			СуммаДолга - Число
//			ПроцентДолга - Число
//
Функция ТаблицаСостоянийЗаказов(МассивСсылок)
	
	СоотвествиеТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивСсылок);
	
	ПервыйЗапрос = Истина;
	ТекстЗапросаВременныхТаблиц = ТекстЗапросаДляРасчетаДатСобытийСостоянийЗаказов();
	
	ТекстЗапроса = "";
	
	Для Каждого ТипДокумента из СоотвествиеТипов Цикл
		
		Если Не ПервыйЗапрос Тогда 
			ТекстЗапроса = ТекстЗапроса + 
			" ОБЪЕДИНИТЬ ВСЕ ";
		КонецЕсли;
		
		МенеджерОбъекта             = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипДокумента.Ключ);
		ТекстЗапроса                = ТекстЗапроса + МенеджерОбъекта.ТекстЗапросаДляРасчетаСостоянийЗаказов();
		
		ПервыйЗапрос = Ложь;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаВременныхТаблиц + ТекстЗапроса;
	Запрос.УстановитьПараметр("МассивЗаказов", МассивСсылок);
	Запрос.УстановитьПараметр("НеИспользоватьСтатусыЗаказовПоставщикам", НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыЗаказовПоставщикам"));
	Запрос.УстановитьПараметр("КонтролироватьЗакрытиеЗаказа", 
			ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыПоставщикамБезПолногоПоступления")
				ИЛИ ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыПоставщикамБезПолнойОплаты"));
	
	Запрос.УстановитьПараметр("ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров",
		Константы.ДопустимоеОтклонениеОтгрузкиПриемкиМерныхТоваров.Получить());
	Запрос.УстановитьПараметр("МерныеТипыВеличин", Справочники.УпаковкиЕдиницыИзмерения.МерныеТипыЕдиницИзмерений());
	
	ТаблицаСостояний = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаСостояний;
	
КонецФункции

// Функция возвращает текст запроса для расчета даты актуальности состояний заказов.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстЗапросаДляРасчетаДатСобытийСостоянийЗаказов()
	
	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	РасчетыСПоставщикамиОбороты.Период КАК Период,
		|	РасчетыСПоставщикамиОбороты.КОплатеРасход КАК КОплатеРасход,
		|	РасчетыСПоставщикамиОбороты.ЗаказПоставщику КАК ЗаказПоставщику
		|ПОМЕСТИТЬ ЭтапыРасчетов
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками.Обороты(, , День, ЗаказПоставщику В (&МассивЗаказов)) КАК РасчетыСПоставщикамиОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РасчетыСПоставщикамиОстатки.ЗаказПоставщику КАК ЗаказПоставщику,
		|	РасчетыСПоставщикамиОстатки.КОплатеПриход КАК КОплатеПриход
		|ПОМЕСТИТЬ ОплаченоПоЗаказам
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками.Обороты(, , , ЗаказПоставщику В (&МассивЗаказов)) КАК РасчетыСПоставщикамиОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЭтапыРасчетов.Период КАК Период,
		|	ЭтапыРасчетов.ЗаказПоставщику КАК ЗаказПоставщику
		|ПОМЕСТИТЬ РезультатРасчетов
		|ИЗ
		|	ЭтапыРасчетов КАК ЭтапыРасчетов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЭтапыРасчетов КАК РасчетыСПоставщиками
		|		ПО (РасчетыСПоставщиками.Период <= ЭтапыРасчетов.Период)
		|			И (РасчетыСПоставщиками.ЗаказПоставщику = ЭтапыРасчетов.ЗаказПоставщику)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ОплаченоПоЗаказам КАК Оплачено
		|		ПО ЭтапыРасчетов.ЗаказПоставщику = Оплачено.ЗаказПоставщику
		|
		|СГРУППИРОВАТЬ ПО
		|	ЭтапыРасчетов.Период,
		|	ЭтапыРасчетов.ЗаказПоставщику,
		|	Оплачено.КОплатеПриход
		|
		|ИМЕЮЩИЕ
		|	СУММА(ЭтапыРасчетов.КОплатеРасход) - ЕСТЬNULL(Оплачено.КОплатеПриход, 0) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(РезультатРасчетов.Период) КАК ДатаАктуальности,
		|	РезультатРасчетов.ЗаказПоставщику КАК ОбъектРасчетов
		|ПОМЕСТИТЬ ДатыАктуальностиЗаказовПоставщикам
		|ИЗ
		|	РезультатРасчетов КАК РезультатРасчетов
		|
		|СГРУППИРОВАТЬ ПО
		|	РезультатРасчетов.ЗаказПоставщику
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(ГрафикПоступленияТоваров.ДатаСобытия) КАК МинимальнаяДатаПоступления,
		|	ГрафикПоступленияТоваров.Регистратор КАК ЗаказПоставщику
		|ПОМЕСТИТЬ ДатыПоступленияЗаказовПоставщикам
		|ИЗ
		|	РегистрНакопления.ГрафикПоступленияТоваров КАК ГрафикПоступленияТоваров
		|ГДЕ
		|	ГрафикПоступленияТоваров.Регистратор В (&МассивЗаказов)
		|СГРУППИРОВАТЬ ПО
		|	ГрафикПоступленияТоваров.Регистратор
		|;
		|///////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ЭтапыРасчетов;
		|УНИЧТОЖИТЬ ОплаченоПоЗаказам;
		|УНИЧТОЖИТЬ РезультатРасчетов;
		|";
	Возврат ТекстЗапроса;
	
КонецФункции

//Функция возвращает таблицу значений с состояниями документов.
//
//	Параметры:
//		МассивСсылок - Массив - (состоящий из ДокументСсылка) ссылки на документы, по которым
//					нужно рассчитать состояние. В модуле менеджера документов должна быть определена функция
//					ТекстЗапросаДляРасчетаДатыАктуальностиСостоянийЗаказов(), которая возвращает текст запроса по датам актуальности и
//					ТекстЗапросаДляРасчетаСостоянийЗаказов(), которая возвращает текст запроса по состояниям заказов.
//	Возвращаемое значение:
//		ТаблицаЗначений:
//			Заказ - ДокументСсылка
//			Состояние - ПеречислениеСсылка.СостоянияЗаказовПоставщикам
//			ДатаСобытия - Дата
//			СуммаОплаты - Число
//			ПроцентОплаты - Число
//			СуммаПоступления - Число
//			ПроцентПоступления - Число
//			СуммаДолга - Число
//			ПроцентДолга - Число
//			ЕстьРасхожденияОрдерНакладная - Булево
//
Функция ТаблицаПредыдущихСостоянийЗаказов(МассивСсылок)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	СостоянияЗаказовПоставщикам.Заказ КАК Заказ,
	|	СостоянияЗаказовПоставщикам.Состояние КАК Состояние,
	|	СостоянияЗаказовПоставщикам.ДатаСобытия КАК ДатаСобытия,
	|	СостоянияЗаказовПоставщикам.СуммаОплаты КАК СуммаОплаты,
	|	СостоянияЗаказовПоставщикам.ПроцентОплаты КАК ПроцентОплаты,
	|	СостоянияЗаказовПоставщикам.СуммаПоступления КАК СуммаПоступления,
	|	СостоянияЗаказовПоставщикам.ПроцентПоступления КАК ПроцентПоступления,
	|	СостоянияЗаказовПоставщикам.СуммаДолга КАК СуммаДолга,
	|	СостоянияЗаказовПоставщикам.ПроцентДолга КАК ПроцентДолга,
	|	СостоянияЗаказовПоставщикам.ЕстьРасхожденияОрдерНакладная КАК ЕстьРасхожденияОрдерНакладная
	|ИЗ
	|	РегистрСведений.СостоянияЗаказовПоставщикам КАК СостоянияЗаказовПоставщикам
	|ГДЕ
	|	СостоянияЗаказовПоставщикам.Заказ В(&МассивСсылок)");
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли