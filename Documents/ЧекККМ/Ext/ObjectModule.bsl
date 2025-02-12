﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		Если Не ДанныеЗаполнения.Свойство("ЧтениеКомандФормы") Тогда
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЧекККМ") Тогда
		
		ЗаполнитьДокументПоЧекуККМ(ДанныеЗаполнения);
		
	Иначе
		
		КассаККМ = Справочники.КассыККМ.КассаККМФискальныйРегистраторДляРМК();
		Если ЗначениеЗаполнено(КассаККМ) Тогда
			ЗаполнитьДокументПоКассеККМ(КассаККМ);
		Иначе
			ВызватьИсключение НСтр("ru = 'Для текущего рабочего места не настроено подключаемое оборудование: Фискальный регистратор'");
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.СтатусыЧековККМ.Отложен;
	КонецЕсли;
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Статус = Перечисления.СтатусыЧековККМ.Пробит И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru='Чек ККМ пробит. Отмена проведения невозможна'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект);
		Возврат;
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	ПодарочныеСертификатыСервер.ЗаполнитьСуммуВВалютеСертификатаВТабличнойЧасти(ПодарочныеСертификаты, Дата, Валюта);
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЧекККМ));
	
	РозничныеПродажи.СопоставитьАлкогольнуюПродукциюСНоменклатурой(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ЧекККМ.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваВКассахККМ(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыПоЭквайрингу(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваВПути(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	// Подарочные сертификаты
	ПодарочныеСертификатыСервер.ОтразитьПодарочныеСертификаты(ДополнительныеСвойства, Движения, Отказ);
	ПодарочныеСертификатыСервер.ОтразитьИсториюПодарочныхСертификатов(ДополнительныеСвойства, Движения, Отказ);
	СкидкиНаценкиСервер.ОтразитьБонусныеБаллы(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Архивный = Ложь;
	Статус = Неопределено;
	
	ПолученоНаличными = 0;
	ОплатаПлатежнымиКартами.Очистить();
	Серии.Очистить();
	
	СостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены);
	
	СкидкиРассчитаны = Ложь;
	СкидкиНаценкиСервер.ОтменитьСкидки(ЭтотОбъект, "Товары");
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		СтрокаТЧ.СуммаБонусныхБалловКСписанию = 0;
		СтрокаТЧ.СуммаБонусныхБалловКСписаниюВВалюте = 0;
	КонецЦикла;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	Если Не СкладыСервер.ИспользоватьСкладскиеПомещения(Склад,Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Помещение");
	КонецЕсли;
	
	ИспользуетсяРегистрацияРозничныхПродажВЕГАИС = ИнтеграцияЕГАИСВызовСервера.ИспользуетсяРегистрацияРозничныхПродажВЕГАИС(
		Организация, Склад, Дата);
	Если ИспользуетсяРегистрацияРозничныхПродажВЕГАИС Тогда
		РозничныеПродажи.ПроверитьКорректностьЗаполненияАлкогольнойПродукции(
			Документы.ЧекККМ.ДанныеДляЕГАИС(ЭтотОбъект), ЭтотОбъект,
			Отказ);
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЧекККМ),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	ПодарочныеСертификатыСервер.ПроверитьЗаполнениеПодарочныхСертификатов(ЭтотОбъект, Отказ);
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	
	Кассир = Пользователи.ТекущийПользователь();
	
	НалогообложениеНДС = Справочники.Организации.НалогообложениеНДС(Организация, Склад, Дата);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоКассеККМ(КассаККМ)
	
	СостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены,,"Кассир");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
		ЗаполнитьДокументПоКассеККМ(ДанныеЗаполнения.КассаККМ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоЧекуККМ(ЧекККМСсылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЧекККМ.КассаККМ КАК КассаККМ,
	|	ЧекККМ.Товары   КАК Товары
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ЧекККМСсылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьДокументПоКассеККМ(Выборка.КассаККМ);
		Товары.Загрузить(Выборка.Товары.Выгрузить());
	КонецЕсли;
	
	ПриКопировании(ЧекККМСсылка);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Процедура формирует список регистров для контроля.
//
Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.СвободныеОстатки);
		Массив.Добавить(Движения.ТоварыНаСкладах);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
