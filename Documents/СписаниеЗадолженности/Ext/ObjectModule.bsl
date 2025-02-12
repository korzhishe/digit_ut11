﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	// Очистим табличную часть документа.
	Если Задолженность.Количество() > 0 Тогда
		Задолженность.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("АктОРасхождениях") Тогда
		
		ЗаполнитьНаОснованииАктаОРасхождениях(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеДебиторскойЗадолженности Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходов");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
	КонецЕсли;
	
	Если РасчетыМеждуОрганизациями Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Задолженность.Партнер");
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Контрагент) И (Организация=Контрагент) Тогда
		Текст = НСтр("ru='Организация и %Контрагент% должны различаться.'");
		
		ТипЗадолженности = ?(ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности,
												Перечисления.ТипыЗадолженности.Кредиторская,
												Перечисления.ТипыЗадолженности.Дебиторская);
		
		Текст = СтрЗаменить(Текст,"%Контрагент%",Перечисления.ТипыЗадолженности.СинонимКонтрагента(ТипЗадолженности));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,ЭтотОбъект,"Контрагент",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СформироватьСписокЗависимыхЗаказов();
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ОчиститьПустойЗаказВТабличнойЧасти(Задолженность);
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеДебиторскойЗадолженности Тогда
			СтатьяДоходов = Неопределено;
			АналитикаДоходов = Неопределено;
		Иначе
			СтатьяРасходов = Неопределено;
			АналитикаРасходов = Неопределено;
		КонецЕсли;
		
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Задолженность);
		
		// Заполнение валюты взаиморасчетов если выключена ФО "ИспользоватьНесколькоВалют"
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
			ВалютаВзаиморасчетов = Неопределено;
			Для Каждого СтрокаТЧ Из Задолженность Цикл
				Если Не ЗначениеЗаполнено(СтрокаТЧ.ВалютаВзаиморасчетов) Тогда
					Если ВалютаВзаиморасчетов = Неопределено Тогда
						ВалютаВзаиморасчетов = Константы.ВалютаУправленческогоУчета.Получить();
					КонецЕсли;
					СтрокаТЧ.ВалютаВзаиморасчетов = ВалютаВзаиморасчетов;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.СписаниеЗадолженности.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по расчетам с поставщиками и клиентами.
	ВзаиморасчетыСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по прочим доходам и расходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	
	СформироватьСписокРегистровДляКонтроля();

	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	РегистрыСведений.СостоянияЗаказовПоставщикам.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();

	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	РегистрыСведений.СостоянияЗаказовПоставщикам.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьНаОснованииАктаОРасхождениях(ДанныеЗаполнения)

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	АктОРасхожденияхПослеПриемки.Организация   КАК Организация,
	|	АктОРасхожденияхПослеПриемки.Подразделение КАК Подразделение,
	|	&ОснованиеАкта                             КАК Основание,
	|	АктОРасхожденияхПослеПриемки.Ссылка        КАК АктОРасхожденияхОснование,
	|	АктОРасхожденияхПослеПриемки.Валюта        КАК Валюта
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки КАК АктОРасхожденияхПослеПриемки
	|ГДЕ
	|	АктОРасхожденияхПослеПриемки.Ссылка = &АктОРасхождениях
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(АктОРасхожденияхПослеПриемкиТовары.СуммаПоДокументу - АктОРасхожденияхПослеПриемкиТовары.Сумма) КАК Сумма
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки.Товары КАК АктОРасхожденияхПослеПриемкиТовары
	|ГДЕ
	|	АктОРасхожденияхПослеПриемкиТовары.Ссылка = &АктОРасхождениях
	|	И АктОРасхожденияхПослеПриемкиТовары.ДокументОснование = &ОснованиеАкта
	|	И АктОРасхожденияхПослеПриемкиТовары.СуммаПоДокументу - АктОРасхожденияхПослеПриемкиТовары.Сумма > 0
	|	И АктОРасхожденияхПослеПриемкиТовары.ПоВинеСтороннейКомпании
	|	И АктОРасхожденияхПослеПриемкиТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы)";
	
	Запрос.УстановитьПараметр("АктОРасхождениях", ДанныеЗаполнения.АктОРасхождениях);
	Запрос.УстановитьПараметр("ОснованиеАкта", ДанныеЗаполнения.ОснованиеАкта);
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаШапка = Результат[0].Выбрать();
	
	Если ВыборкаШапка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	Иначе
		Возврат;
	КонецЕсли;
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности;
	
	ВыборкаСумма = Результат[1].Выбрать();
	Если ВыборкаСумма.Следующий() Тогда
		Если ВыборкаСумма.Сумма > 0 Тогда
			НоваяСтрока = Задолженность.Добавить();
			НоваяСтрока.ВалютаВзаиморасчетов = ВыборкаШапка.Валюта;
			НоваяСтрока.Сумма = ВыборкаСумма.Сумма;
			НоваяСтрока.ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Пользователи.ТекущийПользователь(), Подразделение);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.РасчетыСКлиентами);
	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура СформироватьСписокЗависимыхЗаказов()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка В(&МассивЗаказов)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка В(&МассивЗаказов)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка В (ВЫБРАТЬ
	|			Задолженность.Заказ
	|		ИЗ
	|			Документ.СписаниеЗадолженности.Задолженность КАК Задолженность
	|		ГДЕ
	|			Задолженность.Ссылка = &Ссылка
	|		СГРУППИРОВАТЬ ПО
	|			Задолженность.Заказ)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка В (ВЫБРАТЬ
	|			Задолженность.Заказ
	|		ИЗ
	|			Документ.СписаниеЗадолженности.Задолженность КАК Задолженность
	|		ГДЕ
	|			Задолженность.Ссылка = &Ссылка
	|		СГРУППИРОВАТЬ ПО
	|			Задолженность.Заказ)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиента.Ссылка;
	|
	|ВЫБРАТЬ
	|	ЗаказПоставщику.Ссылка КАК ЗаказПоставщику
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|ГДЕ
	|	ЗаказПоставщику.Ссылка В(&МассивЗаказов)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПоставщику.Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ЗаказПоставщику.Ссылка КАК ЗаказПоставщику
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|ГДЕ
	|	ЗаказПоставщику.Ссылка В (ВЫБРАТЬ
	|			Задолженность.Заказ
	|		ИЗ
	|			Документ.СписаниеЗадолженности.Задолженность КАК Задолженность
	|		ГДЕ
	|			Задолженность.Ссылка = &Ссылка
	|		СГРУППИРОВАТЬ ПО
	|			Задолженность.Заказ)
	|	
	|СГРУППИРОВАТЬ ПО
	|	ЗаказПоставщику.Ссылка
	|";
	
	Запрос.УстановитьПараметр("МассивЗаказов", ЭтотОбъект.Задолженность.ВыгрузитьКолонку("Заказ"));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.ВыполнитьПакет();
	
	МассивЗависимыхЗаказов = Результат[0].Выгрузить().ВыгрузитьКолонку("ЗаказКлиента");
	ЭтотОбъект.ДополнительныеСвойства.Вставить("МассивЗависимыхЗаказовКлиентов", Новый ФиксированныйМассив(МассивЗависимыхЗаказов));
	
	МассивЗависимыхЗаказов = Результат[1].Выгрузить().ВыгрузитьКолонку("ЗаказПоставщику");
	ЭтотОбъект.ДополнительныеСвойства.Вставить("МассивЗависимыхЗаказовПоставщикам", Новый ФиксированныйМассив(МассивЗависимыхЗаказов));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
