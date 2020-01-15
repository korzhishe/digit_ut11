﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.АктОРасхожденияхПослеПеремещения);
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	ПараметрыОкругления = ОбщегоНазначенияУТ.ПараметрыОкругленияКоличестваШтучныхТоваров();
	ПараметрыОкругления.СуффиксДопРеквизита = "ПоДокументу";
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Статус = Перечисления.СтатусыАктаОРасхождениях.НеСогласовано Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДокументОснование");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ОрганизацияПолучатель");
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Действие");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковокПоДокументу");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоДокументу");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ТекстовоеОписание");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Серия");
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Склад");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.СуффиксДопРеквизита = "ПоДокументу";
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	Если ЗначениеЗаполнено(СкладОтправитель) И СкладОтправитель = СкладПолучатель Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Один склад не может быть как отправителем, так и получателем. Измените один из складов.'"),
				ЭтотОбъект,
				"СкладОтправитель",
				,
				Отказ);

	КонецЕсли;

	// Организация-получатель должна быть взаимосвязана с организацией-отправителем по организационной структуре.
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеремещениеТоваровМеждуФилиалами
		И ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(ОрганизацияПолучатель)
		И Не Справочники.Организации.ОрганизацииВзаимосвязаныПоОрганизациционнойСтруктуре(Организация, ОрганизацияПолучатель) Тогда
		
		ТекстОшибки = НСтр("ru='Организация-получатель должна быть взаимосвязана с организацией-отправителем по организационной структуре.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ОрганизацияПолучатель",
			,
			Отказ);
		
		КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
	                                            НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.АктОРасхожденияхПослеПеремещения),
	                                            Отказ,
	                                            МассивНепроверяемыхРеквизитов);
	
	// Проверка того, что основания по заказу
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Заказ");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КодСтроки");

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДокументыОснования.ДокументОснование
	|ПОМЕСТИТЬ ДокументыОснования
	|ИЗ
	|	&ДокументыОснования КАК ДокументыОснования
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументыОснования.ДокументОснование
	|ИЗ
	|	ДокументыОснования КАК ДокументыОснования
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
	|		ПО ДокументыОснования.ДокументОснование = ПеремещениеТоваров.Ссылка
	|ГДЕ
	|	ПеремещениеТоваров.ПеремещениеПоЗаказам";
	
	Запрос.УстановитьПараметр("ДокументыОснования", Товары.Выгрузить(,"ДокументОснование"));
	
	РезультатЗапроса = Запрос.Выполнить();
	ПроверкиПоЗаказуТребуются = Истина;
	Если РезультатЗапроса.Пустой() Тогда
		ПроверкиПоЗаказуТребуются = Ложь;
	Иначе
		МассивРеализацийПоЗаказу = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	КонецЕсли;
	
	Для ТекИндекс = 0 По Товары.Количество()-1 Цикл
		
		ТекущаяСтрока = Товары[ТекИндекс];
		
		Если ПроверкиПоЗаказуТребуются Тогда 
			Если Не ЗначениеЗаполнено(ТекущаяСтрока.Заказ) И ЗначениеЗаполнено(ТекущаяСтрока.ДокументОснование)
				И МассивРеализацийПоЗаказу.Найти(ТекущаяСтрока.ДокументОснование) <> Неопределено Тогда
				
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Заказ"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "Заказ"),
				,
				Отказ);
				
				ТекстОшибки = НСтр("ru='Не заполнено поле ""Код строки"" в строке %НомерСтроки% списка ""Товары""'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "Заказ"),
				,
				Отказ);
				
			КонецЕсли;
		КонецЕсли;
		
		Если Статус <> Перечисления.СтатусыАктаОРасхождениях.НеСогласовано 
			И (ТекущаяСтрока.КоличествоУпаковок - ТекущаяСтрока.КоличествоУпаковокПоДокументу) <> 0 
			И Не ЗначениеЗаполнено(ТекущаяСтрока.Действие) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнено поле ""Как отражать расхождение"" в строке %НомерСтроки% списка ""Товары""'");
			ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "Действие"),
				,
				Отказ);
			
		КонецЕсли;
			
		Если НЕ ТекущаяСтрока.ЗаполненоПоОснованию И НЕ ЗначениеЗаполнено(ТекущаяСтрока.КоличествоУпаковок) Тогда
		
			ТекстОшибки = НСтр("ru='Не заполнено поле ""Количество факт"" в строке %НомерСтроки% списка ""Товары""'");
			ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", ТекущаяСтрока.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ТекущаяСтрока.НомерСтроки, "КоличествоУпаковок"),
			,
			Отказ);
		
		КонецЕсли;

	КонецЦикла;
	
	ОписаниеМетаданных = РасхожденияСервер.ОписаниеМетаданныхПроверкиВозможностиВнесенияИзлишкаВНакладную();
	ОписаниеМетаданных.ИмяПоляНакладнойЗаказ = "ЗаказНаПеремещение";
	ОписаниеМетаданных.ИмяПоляАктаЗаказ = "Заказ";
	ОписаниеМетаданных.ИмяПоляАктаНакладная = "ДокументОснование";
	
	РасхожденияСервер.ПроверкаВозможностиВнесенияИзлишкаВНакладную(ЭтотОбъект, "ЗаказыНаПеремещение", ОписаниеМетаданных, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.АктОРасхожденияхПослеПеремещения.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета
	ЗаказыСервер.ОтразитьГрафикОтгрузкиТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКОтгрузке(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКПоступлению(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьДвижениеТоваров(ДополнительныеСвойства, Движения, Отказ);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для удаления проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполненНаОснованииДокумента = Ложь;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			
			Если ДанныеЗаполнения.Свойство("ДокументОснование") 
				И ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
				ЗаполненНаОснованииДокумента = Истина;
				ЗаполнитьНаОсновании(ДанныеЗаполнения.ДокументОснование);
			Иначе
				ЗаполнитьПоОтбору(ДанныеЗаполнения);
			КонецЕсли;
			
			ДанныеЗаполнения.Свойство("Склад", СкладОтправитель);
		
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
			
			ЗаполненНаОснованииДокумента = Истина;
			ЗаполнитьНаОсновании(ДанныеЗаполнения);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьПоОтбору(СтруктураОтбора)
	
	Если СтруктураОтбора.Свойство("Организация") Тогда
		Организация = СтруктураОтбора.Организация;
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("ОрганизацияПолучатель") Тогда
		ОрганизацияПолучатель = СтруктураОтбора.ОрганизацияПолучатель;
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("СкладОтправитель") Тогда
		СкладОтправитель = СтруктураОтбора.СкладОтправитель;
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("СкладПолучатель") Тогда
		СкладПолучатель = СтруктураОтбора.СкладПолучатель;
	КонецЕсли;
	
	Если СтруктураОтбора.Свойство("ХозяйственнаяОперация") Тогда
		ХозяйственнаяОперация = СтруктураОтбора.ХозяйственнаяОперация;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаОсновании(Основание)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = Документы.АктОРасхожденияхПослеПеремещения.ТекстЗапросаПоОснованиюПеремещения();
	
	Запрос.УстановитьПараметр("Основания", Основание);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	РеквизитыОснования = РезультатЗапроса[0].Выбрать();
	РеквизитыОснования.Следующий();

	МассивДопустимыхСтатусов = Новый Массив;
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыПеремещенийТоваров.Отгружено);
	МассивДопустимыхСтатусов.Добавить(Перечисления.СтатусыПеремещенийТоваров.Принято);
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		РеквизитыОснования.ДокументОснование,
		РеквизитыОснования.СтатусДокумента,
		РеквизитыОснования.ЕстьОшибкиПроведен,
		РеквизитыОснования.ЕстьОшибкиСтатус,
		МассивДопустимыхСтатусов);
		
	// Заполнение шапки
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыОснования);
	
	Товары.Загрузить(РезультатЗапроса[1].Выгрузить());
	Серии.Загрузить(РезультатЗапроса[2].Выгрузить());
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Менеджер         = Пользователи.ТекущийПользователь();
	Подразделение    = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Менеджер);
	
	Организация      = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	СкладОтправитель = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(СкладОтправитель);
	
	Распоряжение = ДокументОснованиеПриЗаполнении(ДанныеЗаполнения);
	ВариантПриемкиТоваров = ЗакупкиСервер.ПолучитьВариантПриемкиТоваров(Распоряжение);
	
КонецПроцедуры

Функция ДокументОснованиеПриЗаполнении(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ДокументОснование") 
		И ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		
		Возврат ДанныеЗаполнения.ДокументОснование;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		
		Возврат ДанныеЗаполнения;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

// Устанавливает статус для объекта документа.
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов.
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыАктаОРасхождениях[НовыйСтатус];
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.АктОРасхожденияхПослеПеремещения);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	Массив.Добавить(Движения.ОбеспечениеЗаказов);
	// Контроль выполняется при проведении\отмене проведения не нового документа.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.СвободныеОстатки);
		Массив.Добавить(Движения.ТоварыНаСкладах);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
