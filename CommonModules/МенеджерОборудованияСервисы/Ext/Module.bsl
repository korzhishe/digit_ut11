﻿
#Область ПрограммныйИнтерфейс

// Метод Connect Web-сервиса EquipmentService.
//
Функция Соединиться(ИДУстройства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.УстройствоИспользуется
	|	И ПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.WebСервисОборудование)
	|	И ПодключаемоеОборудование.ИдентификаторWebСервисОборудования = &ИдентификаторСервисОборудования";
	
	Запрос.УстановитьПараметр("ИдентификаторСервисОборудования", ИДУстройства);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Метод GetSettings Web-сервиса EquipmentService.
//
Функция ПолучитьНастройки(ИДУстройства) Экспорт
	
	СтруктураНастроек = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруНастроек();
	
	МенеджерОборудованияСервисыПереопределяемый.ЗаполнитьНастройкиУстройства(ИДУстройства, СтруктураНастроек);
	
	ПодключаемоеОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ПодключаемоеОборудование);
	
	ТекстСообщения = МенеджерОборудованияСервисыВызовСервера.ПолучитьТекстXMLНастроек(СтруктураНастроек, ДанныеУстройства.ВерсияФорматаОбмена);
	
	Возврат ТекстСообщения;
	
КонецФункции

// Метод GetPriceList Web-сервиса EquipmentService.
//
Функция ПолучитьПрайсЛист(ИДУстройства) Экспорт
	
	СтруктураПрайсЛиста = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруПрайсЛиста();
	
	ПодключаемоеОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ПодключаемоеОборудование);
	
	МенеджерОборудованияСервисыПереопределяемый.ЗаполнитьПрайсЛист(ИДУстройства, СтруктураПрайсЛиста);
	
	ТекстСообщения = МенеджерОборудованияСервисыВызовСервера.ПолучитьТекстXMLПрайсЛиста(СтруктураПрайсЛиста, ДанныеУстройства.ВерсияФорматаОбмена);
	
	Возврат ТекстСообщения;
	
КонецФункции

//Метод GetGood Web-сервиса EquipmentService
Функция ПолучитьТовар(ИДУстройства, Штрихкод) Экспорт
	
	СтруктураТовара = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруПрайсЛиста();
	
	ПодключаемоеОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ПодключаемоеОборудование);
	
	МенеджерОборудованияСервисыПереопределяемый.ЗагрузитьТовар(ИДУстройства, СтруктураТовара, Штрихкод);
	ТекстСообщения = МенеджерОборудованияСервисыВызовСервера.ПолучитьТекстXMLПрайсЛиста(СтруктураТовара, ДанныеУстройства.ВерсияФорматаОбмена);
	
	Возврат ТекстСообщения;
	
КонецФункции

// Метод PreparePriceList Web-сервиса EquipmentService.
//
Функция ПолучитьИдентификаторПередачиПрайсЛиста(ИДУстройства) Экспорт
	
	СтруктураПрайсЛиста = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруПрайсЛиста();
	
	ПодключаемоеОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	
	ИдентификаторПередачи = ПолучитьНеотправленныйИдентификаторИзОчередиСообщений(ПодключаемоеОборудование);
	
	Если ИдентификаторПередачи = Неопределено Тогда
		ИдентификаторПередачи = Строка(Новый УникальныйИдентификатор);
		ЗапуститьФормированиеОчередиСообщенийОбмена(ПодключаемоеОборудование, ИдентификаторПередачи);
	КонецЕсли;
	
	Возврат ИдентификаторПередачи;
	
КонецФункции

// Метод GetPriceListPackage Web-сервиса EquipmentService.
//
Функция ПолучитьПакетПрайсЛиста(ИДУстройства, ИдентификаторПередачи, Рестарт) Экспорт
	
	ПодключаемоеОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	
	СтруктураОтвета = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруОтветаПриВыгрузкеПакетаПрайсЛиста();
	
	СтруктураСообщения = ПолучитьСообщениеИзОчередиОбмена(ПодключаемоеОборудование, ИдентификаторПередачи, Рестарт);
	
	Если СтруктураСообщения = Неопределено Тогда
		
		СтруктураОтвета.Успешно = Ложь; // Пакет еще не готов
		
	Иначе
		
		ПометитьСообщениеОбменаВОчередиКакОтправленное(СтруктураСообщения);
		СтруктураОтвета.Успешно  = Истина;
		СтруктураОтвета.ПакетПрайсЛиста = СтруктураСообщения.ДанныеПакета.Получить();
		
	КонецЕсли;
	
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ПодключаемоеОборудование);
	
	ТекстСообщения = СформироватьТекстСообщенияОтветаПолученияПакетаПрайсЛиста(СтруктураОтвета, ДанныеУстройства.ВерсияФорматаОбмена);
	
	Возврат ТекстСообщения;
	
КонецФункции

// Метод PostDoc Web-сервиса EquipmentService.
//
Функция ЗагрузитьДокумент(ИДУстройства, ТипДокумента, XMLТекст) Экспорт
	
	СтруктураОтвета = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруОтветаПриЗагрузке();
	СтруктураДокумента = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗагружаемогоДокумента();
	
	ПодключаемоеОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ПодключаемоеОборудование);
	
	МенеджерОборудованияСервисыВызовСервера.ЗаполнитьСтруктуруДокумента(СтруктураДокумента, ТипДокумента, XMLТекст, ДанныеУстройства.ВерсияФорматаОбмена);
	
	Если НЕ СтруктураДокумента.Отказ Тогда
		МенеджерОборудованияСервисыПереопределяемый.ЗагрузитьДокумент(ИДУстройства, СтруктураОтвета, СтруктураДокумента);
	Иначе
		СтруктураОтвета.Успешно = Ложь;
		СтруктураОтвета.Описание = СтруктураДокумента.СообщениеОбОшибке;
	КонецЕсли;
	
	ТекстСообщения = СформироватьТекстСообщенияОтветаЗагрузкиДокумента(СтруктураОтвета, ДанныеУстройства.ВерсияФорматаОбмена);
	
	Возврат ТекстСообщения;
	
КонецФункции

// Метод GetDocTypes Web-сервиса EquipmentService.
//
Функция ПолучитьТипыДокументов() Экспорт
	
	МассивТипов = Новый Массив;
	МенеджерОборудованияСервисыПереопределяемый.ЗаполнитьТипыДокументов(МассивТипов);
	ТекстСообщения = ПолучитьТекстXMLТиповДокументов(МассивТипов);
	
	Возврат ТекстСообщения;
КонецФункции

// Метод GetVersion Web-сервиса EquipmentService.
//
Функция ПолучитьВерсиюФорматаОбмена(ИДУстройства) Экспорт
	
	ПодключаемоеОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	
	Если ПодключаемоеОборудование = Неопределено Тогда
		
		Возврат 0;
	Иначе
		
		ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ПодключаемоеОборудование);
		
		Возврат ДанныеУстройства.ВерсияФорматаОбмена;
		
	КонецЕсли;
	
	
КонецФункции

// Функция возвращает XML-текст прайс-листа (DocTypes) в формате XDTO-пакета EquipmentService.
//
Функция ПолучитьТекстXMLТиповДокументов(МассивТипов) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	URIИмен      = МенеджерОборудованияСервисыКлиентСервер.URIПространстваИмен();
	ТипОбъекта   = ФабрикаXDTO.Тип(URIИмен, "DocTypes");
	ОбъектОбмена = ФабрикаXDTO.Создать(ТипОбъекта);
	
	Для Каждого ТипДокумента Из МассивТипов Цикл
		ТипОбъекта   = ФабрикаXDTO.Тип(URIИмен, "ТипыДокументовЗапись");
		ЗаписьТипДокумента = ФабрикаXDTO.Создать(ТипОбъекта);
		
		ЗаполнитьЗначенияСвойств(ЗаписьТипДокумента, ТипДокумента);
		ОбъектОбмена.ТипыДокументов.Добавить(ЗаписьТипДокумента);
	КонецЦикла;
	
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектОбмена);
	
	ТекстСообщения = ЗаписьXML.Закрыть();
	
	Возврат ТекстСообщения;
	
КонецФункции

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Процедура СформироватьОчередьСообщенийОбмена(ПодключаемоеОборудование, ИдентификаторПередачи) Экспорт
	
	ОчиститьОчередьСообщенийОбменаЭкземпляраОборудования(ПодключаемоеОборудование);
	СтруктураПрайсЛиста = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруПрайсЛиста();
	
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ПодключаемоеОборудование);
	
	МенеджерОборудованияСервисыПереопределяемый.ЗаполнитьПрайсЛист(ПодключаемоеОборудование.ИдентификаторWebСервисОборудования, 
		СтруктураПрайсЛиста);
	
	КоличествоЭлементовВПакете = ПолучитьКоличествоЭлементовВПакете(ПодключаемоеОборудование);
	
	МассивПакетов = МенеджерОборудованияКлиентСервер.РазбитьПрайсЛистПоПакетам(СтруктураПрайсЛиста, КоличествоЭлементовВПакете);
	
	Если МассивПакетов.Количество() = 0 Тогда
		
		XMLТекстСообщения = МенеджерОборудованияСервисыВызовСервера.ПолучитьТекстXMLПрайсЛиста(СтруктураПрайсЛиста, ДанныеУстройства.ВерсияФорматаОбмена);
		ДобавитьПакетДанныхВОчередьСообщенийОбмена(ПодключаемоеОборудование, ИдентификаторПередачи, XMLТекстСообщения);
		
	Иначе
		
		ПорядковыйНомер = 1;
		Для Каждого Пакет Из МассивПакетов Цикл
			
			XMLТекстСообщения = МенеджерОборудованияСервисыВызовСервера.ПолучитьТекстXMLПрайсЛиста(Пакет, ДанныеУстройства.ВерсияФорматаОбмена);
			
			ДобавитьПакетДанныхВОчередьСообщенийОбмена(ПодключаемоеОборудование, ИдентификаторПередачи, XMLТекстСообщения, ПорядковыйНомер);
			
			ПорядковыйНомер = ПорядковыйНомер + 1;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьКоличествоЭлементовВПакете(ПодключаемоеОборудование)
	
	ПараметрыУстройства = Справочники.ПодключаемоеОборудование.ПолучитьПараметрыУстройства(ПодключаемоеОборудование);
	
	КоличествоЭлементовВПакете = 0;
	
	Если ПараметрыУстройства.Свойство("КоличествоЭлементовВПакете") Тогда
		
		КоличествоЭлементовВПакете = ПараметрыУстройства.КоличествоЭлементовВПакете;
	КонецЕсли;
	
	Возврат КоличествоЭлементовВПакете;
	
КонецФункции

Процедура ЗапуститьФормированиеОчередиСообщенийОбмена(ПодключаемоеОборудование, ИдентификаторПередачи)
	
	ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	Если ЭтоФайловаяБаза Тогда
		
		// В файловом варианте сообщение готовится в момент вызова с клиента
		СформироватьОчередьСообщенийОбмена(ПодключаемоеОборудование, ИдентификаторПередачи);
		
	Иначе
		// В клиент-серверном варианте сообщения готовятся в фоновом задании.
		
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(ПодключаемоеОборудование);
		МассивПараметров.Добавить(ИдентификаторПередачи);
		
		ИмяФункции = "МенеджерОборудованияСервисы.СформироватьОчередьСообщенийОбмена";
		
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(
			ИмяФункции,
			МассивПараметров,
			ИдентификаторПередачи,
			ПодключаемоеОборудование);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.УстройствоИспользуется
	|	И ПодключаемоеОборудование.ТипОборудования = ЗНАЧЕНИЕ(Перечисление.ТипыПодключаемогоОборудования.WebСервисОборудование)
	|	И ПодключаемоеОборудование.ИдентификаторWebСервисОборудования = &ИдентификаторСервисОборудования";
	
	Запрос.УстановитьПараметр("ИдентификаторСервисОборудования", ИДУстройства);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьПакетДанныхВОчередьСообщенийОбмена(ПодключаемоеОборудование, ИдентификаторПередачи, ТекстСообщения, ПорядковыйНомер = 1)
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСПодключаемымОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПодключаемоеОборудование.Установить(ПодключаемоеОборудование);
	НаборЗаписей.Отбор.ИдентификаторПередачи.Установить(ИдентификаторПередачи);
	НаборЗаписей.Отбор.ПорядковыйНомер.Установить(ПорядковыйНомер);
	НаборЗаписей.Прочитать();
	
	// Если сообщение с таким номером уже есть в очереди, генерируем исключение.
	Если НаборЗаписей.Количество() > 0 Тогда
		
		ВызватьИсключение(НСтр("ru='Не удалось выполнить отправку данных. Очередь сообщений обмена уже содержит сообщение с номером" + " " + ПорядковыйНомер + ".'"));
		
	КонецЕсли;
	
	НоваяЗапись                          = НаборЗаписей.Добавить();
	НоваяЗапись.ПодключаемоеОборудование = ПодключаемоеОборудование;
	НоваяЗапись.ИдентификаторПередачи    = ИдентификаторПередачи;
	НоваяЗапись.ПорядковыйНомер          = ПорядковыйНомер;
	НоваяЗапись.ДанныеПакета             = Новый ХранилищеЗначения(ТекстСообщения, Новый СжатиеДанных(9)); 
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Процедура ОчиститьОчередьСообщенийОбменаЭкземпляраОборудования(ПодключаемоеОборудование)
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСПодключаемымОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПодключаемоеОборудование.Установить(ПодключаемоеОборудование);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	НаборЗаписей.Записать(Истина);

КонецПроцедуры

Функция ПолучитьНеотправленныйИдентификаторИзОчередиСообщений(ПодключаемоеОборудование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОчередьСообщенийОбменаСПодключаемымОборудованием.ИдентификаторПередачи КАК ИдентификаторПередачи
		|ИЗ
		|	РегистрСведений.ОчередьСообщенийОбменаСПодключаемымОборудованием КАК ОчередьСообщенийОбменаСПодключаемымОборудованием
		|ГДЕ
		|	ОчередьСообщенийОбменаСПодключаемымОборудованием.ПодключаемоеОборудование = &ПодключаемоеОборудование
		|	И НЕ ОчередьСообщенийОбменаСПодключаемымОборудованием.Отправлен";
	
	Запрос.УстановитьПараметр("ПодключаемоеОборудование", ПодключаемоеОборудование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ИдентификаторПередачи;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьСообщениеИзОчередиОбмена(ПодключаемоеОборудование, ИдентификаторПередачи, Рестарт)
	
	Если Рестарт Тогда
		СброситьФлагОтправкиВОчередиОбмена(ПодключаемоеОборудование, ИдентификаторПередачи);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОчередьСообщенийОбменаСПодключаемымОборудованием.ПодключаемоеОборудование,
	|	ОчередьСообщенийОбменаСПодключаемымОборудованием.ИдентификаторПередачи,
	|	ОчередьСообщенийОбменаСПодключаемымОборудованием.ПорядковыйНомер,
	|	ОчередьСообщенийОбменаСПодключаемымОборудованием.ДанныеПакета
	|ИЗ
	|	РегистрСведений.ОчередьСообщенийОбменаСПодключаемымОборудованием КАК ОчередьСообщенийОбменаСПодключаемымОборудованием
	|ГДЕ
	|	ОчередьСообщенийОбменаСПодключаемымОборудованием.ПодключаемоеОборудование = &ПодключаемоеОборудование
	|	И НЕ ОчередьСообщенийОбменаСПодключаемымОборудованием.Отправлен
	|	И ОчередьСообщенийОбменаСПодключаемымОборудованием.ИдентификаторПередачи = &ИдентификаторПередачи
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОчередьСообщенийОбменаСПодключаемымОборудованием.ПорядковыйНомер";
	
	Запрос.УстановитьПараметр("ПодключаемоеОборудование", ПодключаемоеОборудование);
	Запрос.УстановитьПараметр("ИдентификаторПередачи",    ИдентификаторПередачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СтруктураПакета = Новый Структура;
		СтруктураПакета.Вставить("ПодключаемоеОборудование", Выборка.ПодключаемоеОборудование);
		СтруктураПакета.Вставить("ИдентификаторПередачи",    Выборка.ИдентификаторПередачи);
		СтруктураПакета.Вставить("ПорядковыйНомер",          Выборка.ПорядковыйНомер);
		СтруктураПакета.Вставить("ДанныеПакета",             Выборка.ДанныеПакета);
		
		Возврат СтруктураПакета;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ПометитьСообщениеОбменаВОчередиКакОтправленное(СтруктураСообщения)
	
	МенеджерЗаписи = РегистрыСведений.ОчередьСообщенийОбменаСПодключаемымОборудованием.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ПодключаемоеОборудование = СтруктураСообщения.ПодключаемоеОборудование;
	МенеджерЗаписи.ИдентификаторПередачи = СтруктураСообщения.ИдентификаторПередачи;
	
	МенеджерЗаписи.Прочитать();
	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураСообщения);
	
	МенеджерЗаписи.Отправлен = Истина;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

Процедура СброситьФлагОтправкиВОчередиОбмена(ПодключаемоеОборудование, ИдентификаторПередачи);
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСПодключаемымОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПодключаемоеОборудование.Установить(ПодключаемоеОборудование);
	НаборЗаписей.Отбор.ИдентификаторПередачи.Установить(ИдентификаторПередачи);
	НаборЗаписей.Прочитать();
	
	Для Каждого Запись Из НаборЗаписей Цикл
		Запись.Отправлен = Ложь;
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Функция СформироватьТекстСообщенияОтветаЗагрузкиДокумента(СтруктураОтвета, ВерсияФорматаОбмена)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	URIИмен      = МенеджерОборудованияСервисыКлиентСервер.URIПространстваИмен(ВерсияФорматаОбмена);
	
	Если ВерсияФорматаОбмена >= 1006 Тогда
		ТипОбъекта   = ФабрикаXDTO.Тип(URIИмен, "PostDocsResponse");
	Иначе
		ТипОбъекта   = ФабрикаXDTO.Тип(URIИмен, "Response");
	КонецЕсли;
	
	ОбъектОбмена = ФабрикаXDTO.Создать(ТипОбъекта);
	
	ЗаполнитьЗначенияСвойств(ОбъектОбмена, СтруктураОтвета);
	
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектОбмена);
	ТекстСообщения = ЗаписьXML.Закрыть();
	
	Возврат ТекстСообщения;
	
КонецФункции

Функция СформироватьТекстСообщенияОтветаПолученияПакетаПрайсЛиста(СтруктураОтвета, ВерсияФорматаОбмена)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	URIИмен      = МенеджерОборудованияСервисыКлиентСервер.URIПространстваИмен(ВерсияФорматаОбмена);
	
	ТипОбъекта   = ФабрикаXDTO.Тип(URIИмен, "PriceListPackage");
	
	ОбъектОбмена = ФабрикаXDTO.Создать(ТипОбъекта);
	ОбъектОбмена.Успешно = СтруктураОтвета.Успешно;
	
	Если ЗначениеЗаполнено(СтруктураОтвета.ПакетПрайсЛиста) Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(СтруктураОтвета.ПакетПрайсЛиста);
		ТипОбъектаПрайсЛист   = ФабрикаXDTO.Тип(URIИмен, "PriceList");
		ДанныеПрайсЛист = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипОбъектаПрайсЛист);
		ЧтениеXML.Закрыть();
		ОбъектОбмена.ПрайсЛист = ДанныеПрайсЛист;
	КонецЕсли;
	
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектОбмена);
	ТекстСообщения = ЗаписьXML.Закрыть();
	
	Возврат ТекстСообщения;
	
КонецФункции

#КонецОбласти
