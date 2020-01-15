﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подготавливает необходимые данные для формирования пакета ЭД.
// Используется для быстрого обмена файлами (через файл, 1С:Бизнес-сеть).
//
// Параметры:
//  Параметры - Структура - параметры для заполнения документа;
//  АдресХранилища - Строка - адрес хранилища в котором находятся подготовленные данные.
//
Процедура ПодготовитьДанныеДляЗаполненияДокументов(Параметры, АдресХранилища) Экспорт
	
	ТаблицаЭД = Новый ТаблицаЗначений;
	ТаблицаЭД.Колонки.Добавить("ПолноеИмяФайла");
	ТаблицаЭД.Колонки.Добавить("НаименованиеФайла");
	ТаблицаЭД.Колонки.Добавить("НаправлениеЭД");
	ТаблицаЭД.Колонки.Добавить("Контрагент");
	ТаблицаЭД.Колонки.Добавить("УникальныйИдентификатор");
	ТаблицаЭД.Колонки.Добавить("ВладелецЭД");
	ТаблицаЭД.Колонки.Добавить("АдресХранилища");
	ТаблицаЭД.Колонки.Добавить("ДвоичныеДанныеПакета");
	ТаблицаЭД.Колонки.Добавить("ПолноеИмяДопФайла");
	ТаблицаЭД.Колонки.Добавить("ИдентификаторДопФайла");
	
	// Дополнительные свойства для 1С:Бизнес-сеть.
	ТаблицаЭД.Колонки.Добавить("ВидЭД");
	ТаблицаЭД.Колонки.Добавить("Сумма");
	ТаблицаЭД.Колонки.Добавить("АдресХранилищаПредставления");
	ТаблицаЭД.Колонки.Добавить("ДвоичныеДанныеПредставления");
	
	МассивСсылокНаОбъект = Параметры.МассивСсылокНаОбъект;
	
	НастройкиОбъектов = Новый Соответствие;
	Для Каждого СсылкаНаОбъект Из МассивСсылокНаОбъект Цикл
		НастройкиОбмена = ОбменСКонтрагентамиСлужебный.ЗаполнитьПараметрыЭДПоИсточнику(СсылкаНаОбъект,,, Истина);
		
		НастройкиОбмена.Вставить("ИдентификаторОрганизации", ОбменСКонтрагентамиПереопределяемый.ПолучитьИДКонтрагента(
			НастройкиОбмена.Организация, "Организация"));
		НастройкиОбмена.Вставить("ИдентификаторКонтрагента", ОбменСКонтрагентамиПереопределяемый.ПолучитьИДКонтрагента(
			НастройкиОбмена.Контрагент, "Контрагент"));
		
		НастройкиОбмена.Вставить("ПрофильНастроекЭДО", Новый Структура("СпособОбменаЭД", Перечисления.СпособыОбменаЭД.БыстрыйОбмен));
		НастройкиОбмена.Вставить("СоглашениеЭД", "");
		
		ВерсияФормата = ОбменСКонтрагентамиСлужебный.АктуальнаяВерсияФорматаЭД(НастройкиОбмена.ВидЭД);
		НастройкиОбмена.Вставить("ВерсияФормата", ВерсияФормата);
		
		НастройкиОбъектов.Вставить(СсылкаНаОбъект, НастройкиОбмена);
		Если НастройкиОбмена.ВидЭД = Перечисления.ВидыЭД.АктИсполнитель
			ИЛИ НастройкиОбмена.ВидЭД = Перечисления.ВидыЭД.АктЗаказчик Тогда
			НастройкиОбмена.Вставить("ВерсияРегламентаЭДО", Перечисления.ВерсииРегламентаОбмена1С.Версия20);
		КонецЕсли;
	КонецЦикла;
	
	МассивСтруктурОбмена = ОбменСКонтрагентамиСлужебный.СформироватьХМЛФайлыДокументов(МассивСсылокНаОбъект,
		НастройкиОбъектов, Новый Структура("ВидЭД", НастройкиОбмена.ВидЭД));
		
	Для Каждого СтруктураОбмена Из МассивСтруктурОбмена Цикл
		ПолноеИмяФайла = СтруктураОбмена.ПолноеИмяФайла;
		Если НЕ ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаЭД.Добавить();
		НоваяСтрока.ПолноеИмяФайла = ПолноеИмяФайла;
		СтруктураОбмена.Свойство("ПолноеИмяДопФайла", НоваяСтрока.ПолноеИмяДопФайла);
		СтруктураОбмена.Свойство("ИдентификаторДопФайла", НоваяСтрока.ИдентификаторДопФайла);
		
		Если СтруктураОбмена.СтруктураЭД.ДокументыОснования.Количество() <> 1 Тогда
			ВызватьИсключение НСтр("ru = 'Ошибка формирования XML-файла'");
		КонецЕсли;
		
		СтруктураОбмена.СтруктураЭД.Вставить("ДокументОснование", СтруктураОбмена.СтруктураЭД.ДокументыОснования[0]);
		
		НаименованиеФайла = БыстрыйОбменИмяСохраняемогоФайла(СтруктураОбмена.СтруктураЭД.ДокументОснование);
		НаименованиеФайла = СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(НаименованиеФайла);
		
		НоваяСтрока.НаименованиеФайла = НаименованиеФайла;
		НоваяСтрока.НаправлениеЭД = СтруктураОбмена.СтруктураЭД.НаправлениеЭД;
		НоваяСтрока.Контрагент = СтруктураОбмена.СтруктураЭД.Контрагент;
	
		
		Если ТипЗнч(СтруктураОбмена.СтруктураЭД.ДокументОснование) = Тип("Структура") Тогда
			// Бизнес-сеть.
			НоваяСтрока.УникальныйИдентификатор = СтруктураОбмена.СтруктураЭД.ДокументОснование.Идентификатор;
			НоваяСтрока.ВладелецЭД = СтруктураОбмена.СтруктураЭД.ДокументОснование;
		Иначе
			НоваяСтрока.УникальныйИдентификатор = СтруктураОбмена.СтруктураЭД.ДокументОснование.УникальныйИдентификатор();
			НоваяСтрока.ВладелецЭД = СтруктураОбмена.СтруктураЭД.ДокументОснование;
		КонецЕсли; 
		СтруктураОбмена.Вставить("ДвоичныеДанныеПредставления");

		НоваяСтрока.ДвоичныеДанныеПакета = СформироватьДвоичныеДанныеПакета(СтруктураОбмена);
		
		// Дополнительные свойства для 1С:Бизнес-сеть.
		Если ЗначениеЗаполнено(СтруктураОбмена.ДвоичныеДанныеПредставления) Тогда
			НоваяСтрока.ДвоичныеДанныеПредставления = СтруктураОбмена.ДвоичныеДанныеПредставления;
		КонецЕсли;
		НоваяСтрока.ВидЭД = СтруктураОбмена.ВидЭД;
		СтруктураОбмена.СтруктураЭД.Свойство("СуммаДокумента", НоваяСтрока.Сумма);
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТаблицаЭД) Тогда
		ПоместитьВоВременноеХранилище(ТаблицаЭД, АдресХранилища);
	Иначе
		АдресХранилища = "";
	КонецЕсли;
	
КонецПроцедуры

// Формирует присоединенный файл XML электронного документа.
// Используется для быстрого обмена (через файл, 1C:Бизнес-сеть.
//
// Параметры:
//  СтруктураОбмена - Структура - данные для формирования файла пакета.
//
// Возвращаемое значение:
//  ДвоичныеДанные - данные сформированного файла пакета.
//
Функция СформироватьДвоичныеДанныеПакета(СтруктураОбмена) Экспорт
	
	СтруктураОбмена.СтруктураЭД.Вставить("ПрофильНастроекЭДО", Новый Структура("СпособОбменаЭД",
		Перечисления.СпособыОбменаЭД.БыстрыйОбмен));
	
	ТекстОшибки = "";
	АдресХранилища = Неопределено;
	
	АдресКаталога = ЭлектронноеВзаимодействиеСлужебный.РабочийКаталог("send", Новый УникальныйИдентификатор);
	Если СтруктураОбмена.ВидЭД = Перечисления.ВидыЭД.КаталогТоваров
		Или СтруктураОбмена.ВидЭД = Перечисления.ВидыЭД.ПрайсЛист Тогда
		НаименованиеФайла = СтруктураОбмена.Наименование;
	Иначе
		НаименованиеФайла = БыстрыйОбменИмяСохраняемогоФайла(СтруктураОбмена.СтруктураЭД.ДокументОснование);
	КонецЕсли;
	НаименованиеФайла = СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(НаименованиеФайла);
	
	КопироватьФайл(СтруктураОбмена.ПолноеИмяФайла, АдресКаталога + НаименованиеФайла + ".xml");
	
	СтруктураФайловЭД = Новый Структура;
	СтруктураФайловЭД.Вставить("ГлавныйФайл", НаименованиеФайла + ".xml");
	СтруктураФайловЭД.Вставить("ФайлДляПросмотра", НаименованиеФайла + ".pdf");
	
	ПутьКДопФайлу = "";
	Если СтруктураОбмена.Свойство("ПолноеИмяДопФайла", ПутьКДопФайлу) И ЗначениеЗаполнено(ПутьКДопФайлу) Тогда
		ИмяДопФайла = Строка(СтруктураОбмена.ИдентификаторДопФайла);
		КопироватьФайл(ПутьКДопФайлу, АдресКаталога + ИмяДопФайла + ".xml");
		СтруктураФайловЭД.Вставить("ДополнительныйФайл", ИмяДопФайла + ".xml");
	КонецЕсли;
	
	Если СтруктураОбмена.Свойство("Картинки") И ЗначениеЗаполнено(СтруктураОбмена.Картинки) Тогда
		ПутьКДопФайлу = ПолучитьИмяВременногоФайла();
		ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(СтруктураОбмена.Картинки);
		ДвоичныеДанныеФайла.Записать(ПутьКДопФайлу);
		КопироватьФайл(ПутьКДопФайлу, АдресКаталога + "Additional files" + ".zip");
		СтруктураФайловЭД.Вставить("ДополнительныйФайл", "Additional files" + ".zip");
		ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ПутьКДопФайлу);
	КонецЕсли;
	
	// Формируем meta.xml.
	ОбменСКонтрагентамиВнутренний.СформироватьТранспортнуюИнформацию(СтруктураОбмена.СтруктураЭД,
	СтруктураФайловЭД, АдресКаталога, ТекстОшибки);
	
	// Формируем card.xml.
	ОбменСКонтрагентамиВнутренний.СформироватьКарточку(СтруктураОбмена.СтруктураЭД, АдресКаталога, ТекстОшибки);
	
	Если Не ЗначениеЗаполнено(ТекстОшибки) Тогда
		
		Контейнер = Новый ЗаписьZipФайла();
		ИмяФайлаАрхива = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("zip");

		Контейнер.Открыть(ИмяФайлаАрхива);
		
		ОбъектыДобавляемыеВАрхив = АдресКаталога + "*";
		Контейнер.Добавить(ОбъектыДобавляемыеВАрхив, РежимСохраненияПутейZIP.СохранятьОтносительныеПути,
		РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
		
		Попытка
			Контейнер.Записать();
			ДвоичныеДанныеПакета = Новый ДвоичныеДанные(ИмяФайлаАрхива);
		Исключение
			ТекстСообщения = ?(ЗначениеЗаполнено(ТекстОшибки), ТекстОшибки, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				НСтр("ru = 'Формирование пакета ЭД - однократная сделка'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				ТекстСообщения);
		КонецПопытки;
		ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайлаАрхива);
		
		// Подготовка двоичных данных представления для 1С:Бизнес-сеть
		Если СтруктураОбмена.Свойство("ДвоичныеДанныеПредставления") Тогда
			ИмяФайлаПДФ = СформироватьФайлПредставления(СтруктураОбмена, ТипФайлаТабличногоДокумента.PDF, Истина);
			Если ЗначениеЗаполнено(ИмяФайлаПДФ) Тогда
				КопироватьФайл(ИмяФайлаПДФ, АдресКаталога + НаименованиеФайла + ".pdf");
				СтруктураОбмена.ДвоичныеДанныеПредставления = Новый ДвоичныеДанные(ИмяФайлаПДФ);
			КонецЕсли; 
		КонецЕсли;
	
	Иначе
		ШаблонСообщения = НСтр("ru = 'При формировании %1 возникли следующие ошибки:
		|%2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СтруктураОбмена.ВидЭД,
			ТекстОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(АдресКаталога);
	Возврат ДвоичныеДанныеПакета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция БыстрыйОбменИмяСохраняемогоФайла(Основание)
	
	Если ТипЗнч(Основание) = Тип("Массив") Тогда
		Ссылка = Основание[0];
	Иначе
		Ссылка = Основание;
	КонецЕсли;
	
	НаименованиеФайла = "";
	ОбменСКонтрагентамиПереопределяемый.ЗадатьИмяСохраняемогоФайлаПриБыстромОбмене(Ссылка, НаименованиеФайла);
	Если ЗначениеЗаполнено(Ссылка) И НЕ ЗначениеЗаполнено(НаименованиеФайла) Тогда
		
		СправочникОрганизации = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Организации");
		
		Если ТипЗнч(Ссылка) = Тип("СправочникСсылка." + СправочникОрганизации) Тогда
			СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Наименование");
			ШаблонФайла = НСтр("ru = '%1'");
			НаименованиеФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонФайла, СтруктураРеквизитов.Наименование);
		ИначеЕсли ТипЗнч(Основание) = Тип("Структура") Тогда
			// Бизнес-сеть.
			ШаблонФайла = НСтр("ru = '%1 %2 от %3'");
			НаименованиеФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонФайла, Основание.ВидЭД,
				Основание.Номер, Формат(Основание.Дата, "ДЛФ=Д"));
		Иначе
			СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Номер, Дата");
			ШаблонФайла = НСтр("ru = '%1 %2 от %3'");
			НаименованиеФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонФайла, Строка(ТипЗнч(Ссылка)),
				СтруктураРеквизитов.Номер, Формат(СтруктураРеквизитов.Дата, "ДЛФ=Д"));
		КонецЕсли;
		
		НаименованиеФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(НаименованиеФайла);
		
	КонецЕсли;
	
	Возврат НаименованиеФайла;
	
КонецФункции

Функция СформироватьФайлПредставления(СтруктураОбмена, ТипФайла = Неопределено, СкрыватьСлужебныеОбласти = Ложь)
	
	Если ТипФайла = Неопределено Тогда
		ТипФайла = ТипФайлаТабличногоДокумента.PDF;
	КонецЕсли;
	
	ФайлИсходногоДокумента = Новый Файл(СтруктураОбмена.ПолноеИмяФайла);
	ИмяИсходногоДокумента = ФайлИсходногоДокумента.ИмяБезРасширения;
	
	ПолноеИмяДопФайла = Неопределено;
	СтруктураОбмена.Свойство("ПолноеИмяДопФайла", ПолноеИмяДопФайла);
	
	ПараметрыПечати = Новый Структура("ПолноеИмяДопФайла",     ПолноеИмяДопФайла);
	ПараметрыПечати.Вставить("СкрыватьИдентификаторДокумента", СкрыватьСлужебныеОбласти);
	ПараметрыПечати.Вставить("СкрыватьКопияВерна",             СкрыватьСлужебныеОбласти);
	
	ТабличныйДокумент = ОбменСКонтрагентамиВнутренний.СформироватьПечатнуюФормуЭД(СтруктураОбмена.ПолноеИмяФайла,
		СтруктураОбмена.СтруктураЭД.НаправлениеЭД, ПараметрыПечати);
	
	Если ТабличныйДокумент <> Неопределено Тогда
		ФайлСохранения = ФайлИсходногоДокумента.Путь + ИмяИсходногоДокумента +"." + НРег(ТипФайла);
		ТабличныйДокумент.Записать(ФайлСохранения, ТипФайла);
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось сформировать табличный документ.
			|Подробности см. в журнале регистрации.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		ФайлСохранения = Неопределено;
	КонецЕсли;
	
	Возврат ФайлСохранения;
	
КонецФункции

#КонецОбласти

#КонецЕсли