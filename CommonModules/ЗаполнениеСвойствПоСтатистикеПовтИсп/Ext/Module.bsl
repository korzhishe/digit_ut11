﻿
#Область ПрограммныйИнтерфейс

// Формирует описание структуры реквизитов для заполнения по статистике.
// 
// Параметры:
//	ИмяОбъектаМетаданных - Строка - полное имя объекта метаданных
//	ОтборПоРеквизитуРодителю - Строка - имя реквизита объекта, подчиненные реквизиты которого надо заполнить по статистике.
// 
// Возвращаемое значение:
//	Структура с ключами
//		РеквизитыОбъекта - Структура
//			Ключ - имя реквизита объекта, заполняемого по статистике
//			Значение - Структура - описание "реквизитов-родителей"
//				Ключ - имя "реквизита-родителя"
//				Значение - Число - тип "родителя", его влияние на сбор статистики:
// 					1 - "Родитель", который обязательно должен быть заполнен.
// 	   					Если хоть один из родителей этого типа не заполнен - не имеет смысла собирать статистику "подчиненного" реквизита.
// 					2 - "Родитель", который участвуют в отборе статистики всегда, независимо от его заполненности.
//						Заполнен или нет реквизит этого типа, он все равно участвует в отборе статистики "подчиненного" реквизита.
// 					3 - "Родитель", который участвуют в отборе статистики только если они заполнены.
//						Если реквизит этого типа не заполнен, то по нему не выполняется отбор статистики "подчиненного" реквизита.
//		СинонимыРеквизитов - Структура
//			Ключ - "вид" реквизита (имя "стандартного" реквизита)
//			Значение - Строка - имя реквизита объекта в метаданных
//		ПорядокЗаполненияРеквизитов - Массив - определяет последовательность заполнения реквизитов объекта.
//			Заполнение выполняется начиная с реквизитов, не имеющих "родителей" и заканчивается реквизитами, не имеющими "подчиненных".
//			Элементами массива является структуры, ключи которых содержат имена реквизитов, которые надо заполнить на данном шаге.
//		КэшЗначенияРеквизитов - Структура - кэшируемые значения реквизитов (используется для заполнения их "подчиненных" реквизитов)
//			Ключ - имя реквизита объекта
//			Значение - Произвольный - значение реквизита объекта
//		ТекстОшибки - Строка - содержит текст ошибки, выявленной при формировании описания структуры реквизитов.
//
Функция ОписаниеЗаполняемыхРеквизитовОбъекта(ИмяОбъектаМетаданных, ОтборПоРеквизитуРодителю = "") Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданных);
	
	// Вспомогательные данные, описывающие особенности заполнения реквизитов разных объектов:
	// Соответствие "вида" реквизита (Ключ) и имени реквизита объекта (Значение)
	СтруктураСинонимов = Новый Структура;
	// Перечень "видов" реквизитов (Ключ), которые в данном объекте заполнять не требуется
	СтруктураНезаполняемыхРеквизитов = Новый Структура;
	// Соответствие имени реквизита объекта (Ключ) и его "родителей" (Значение)
	// (аналогично ключу РеквизитыОбъекта из описания реквизитов объекта)
	ДополнительныеРеквизиты = Новый Структура; // Имя реквизита - Реквизиты-родители
	
#Область ОсобенностиЗаполненияРеквизитовПоОбъектамМетаданных

#Область АвансовыйОтчет
	Если ОбъектМетаданных = Метаданные.Документы.АвансовыйОтчет Тогда
		
		СтруктураСинонимов.Вставить("БанковскийСчетОрганизации", "БанковскийСчет");
		
	КонецЕсли;
#КонецОбласти
#Область АктВыполненныхРабот
	Если ОбъектМетаданных = Метаданные.Документы.АктВыполненныхРабот Тогда
		
		СтруктураСинонимов.Вставить("ДокументОснование", "ЗаказКлиента");
		
		СтруктураНезаполняемыхРеквизитов.Вставить("НалогообложениеНДС");
		
	КонецЕсли;
#КонецОбласти
#Область ВыкупВозвратнойТарыКлиентом
	Если ОбъектМетаданных = Метаданные.Документы.ВыкупВозвратнойТарыКлиентом Тогда
		
		СтруктураНезаполняемыхРеквизитов.Вставить("НалогообложениеНДС");
		
	КонецЕсли;
#КонецОбласти
#Область ЗаказКлиента
	Если ОбъектМетаданных = Метаданные.Документы.ЗаказКлиента Тогда
		
		СтруктураСинонимов.Вставить("БанковскийСчетОрганизации", "БанковскийСчет");
		
		СтруктураНезаполняемыхРеквизитов.Вставить("НалогообложениеНДС");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"ХозяйственнаяОперация", "Автор");
		
	КонецЕсли;
#КонецОбласти
#Область ЗаказПоставщику
	Если ОбъектМетаданных = Метаданные.Документы.ЗаказПоставщику Тогда
		
		СтруктураСинонимов.Вставить("БанковскийСчетОрганизации", "БанковскийСчет");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"ХозяйственнаяОперация", "Автор");
		
	КонецЕсли;
#КонецОбласти
#Область ЗаявкаНаРасходованиеДенежныхСредств
	Если ОбъектМетаданных = Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств Тогда
		
		СтруктураСинонимов.Вставить("БанковскийСчетОрганизации", "БанковскийСчет");
		СтруктураСинонимов.Вставить("Менеджер", "КтоЗаявил");
		
	КонецЕсли;
#КонецОбласти
#Область ЗаявкаНаВозвратТоваровОтКлиента
	Если ОбъектМетаданных = Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента Тогда
		
		СтруктураСинонимов.Вставить("БанковскийСчетОрганизации", "БанковскийСчет");
		СтруктураСинонимов.Вставить("ДокументОснование", "ДокументРеализации");
		
		СтруктураНезаполняемыхРеквизитов.Вставить("НалогообложениеНДС");
		
	КонецЕсли;
#КонецОбласти
#Область КоммерческоеПредложениеКлиенту
	Если ОбъектМетаданных = Метаданные.Документы.КоммерческоеПредложениеКлиенту Тогда
		
		СтруктураНезаполняемыхРеквизитов.Вставить("НалогообложениеНДС");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"ХозяйственнаяОперация", "Автор");
		
	КонецЕсли;
#КонецОбласти
#Область ОперацияПоПлатежнойКарте
	Если ОбъектМетаданных = Метаданные.Документы.ОперацияПоПлатежнойКарте Тогда
		
		СтруктураНезаполняемыхРеквизитов.Вставить("Организация");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"ЭквайринговыйТерминал");
		
	КонецЕсли;
#КонецОбласти
#Область ОтчетБанкаПоОперациямЭквайринга
	Если ОбъектМетаданных = Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга Тогда
		
		СтруктураСинонимов.Вставить("БанковскийСчетОрганизации", "БанковскийСчет");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"Эквайер", "БанковскийСчет");
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"СтатьяРасходов, АналитикаРасходов", "БанковскийСчет, Эквайер");
		
	КонецЕсли;
#КонецОбласти
#Область ОтчетКомиссионера
	Если ОбъектМетаданных = Метаданные.Документы.ОтчетКомиссионера Тогда
		
		СтруктураСинонимов.Вставить("БанковскийСчетОрганизации", "БанковскийСчет");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"Услуга, СпособРасчетаВознаграждения, СтавкаНДСВознаграждения, ПроцентВознаграждения");
		
	КонецЕсли;
#КонецОбласти
#Область ОтчетКомиссионераОСписании
	Если ОбъектМетаданных = Метаданные.Документы.ОтчетКомиссионераОСписании Тогда
		
		СтруктураНезаполняемыхРеквизитов.Вставить("НалогообложениеНДС");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"СтатьяДоходов, АналитикаДоходов, СтатьяРасходов, АналитикаРасходов");
		
	КонецЕсли;
#КонецОбласти
#Область ОтчетКомитенту
	Если ОбъектМетаданных = Метаданные.Документы.ОтчетКомитенту Тогда
		
		СтруктураСинонимов.Вставить("БанковскийСчетОрганизации", "БанковскийСчет");
		
		СтруктураНезаполняемыхРеквизитов.Вставить("НалогообложениеНДС");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"Услуга, СпособРасчетаВознаграждения, СтавкаНДСВознаграждения, ПроцентВознаграждения");
		
	КонецЕсли;
#КонецОбласти
#Область ОтчетПоКомиссииМеждуОрганизациями
	Если ОбъектМетаданных = Метаданные.Документы.ОтчетПоКомиссииМеждуОрганизациями Тогда
		
		СтруктураНезаполняемыхРеквизитов.Вставить("НалогообложениеНДС");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"Услуга, СпособРасчетаВознаграждения, СтавкаНДСВознаграждения, ПроцентВознаграждения");
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"Партнер, Контрагент");
		
	КонецЕсли;
#КонецОбласти
#Область ПеремещениеТоваров
	Если ОбъектМетаданных = Метаданные.Документы.ПеремещениеТоваров Тогда
		
		СтруктураСинонимов.Вставить("Склад", "СкладОтправитель");
		СтруктураСинонимов.Вставить("ДокументОснование", "ЗаказНаПеремещение");
		
		СтруктураНезаполняемыхРеквизитов.Вставить("ПеремещениеПодДеятельность");
		
	КонецЕсли;
#КонецОбласти
#Область ПриобретениеТоваровУслуг
	Если ОбъектМетаданных = Метаданные.Документы.ПриобретениеТоваровУслуг Тогда
		
		СтруктураСинонимов.Вставить("ДокументОснование", "ЗаказПоставщику");
		
	КонецЕсли;
#КонецОбласти
#Область РеализацияТоваровУслуг
	Если ОбъектМетаданных = Метаданные.Документы.РеализацияТоваровУслуг Тогда
		
		СтруктураСинонимов.Вставить("ДокументОснование", "ЗаказКлиента");
		
		СтруктураНезаполняемыхРеквизитов.Вставить("НалогообложениеНДС");
		
	КонецЕсли;
#КонецОбласти
#Область СписаниеНедостачТоваров
	Если ОбъектМетаданных = Метаданные.Документы.СписаниеНедостачТоваров Тогда
		
		СтруктураНезаполняемыхРеквизитов.Вставить("Склад");
		
		ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(ДополнительныеРеквизиты,
			"СтатьяРасходов, АналитикаРасходов", "", "Ответственный");
			
	КонецЕсли;
#КонецОбласти

#КонецОбласти

	// Переопределим вспомогательные данные 
	ЗаполнениеСвойствПоСтатистикеПереопределяемый.ПриФормированииОписанияРеквизитовОбъекта(
		ИмяОбъектаМетаданных,
		ОтборПоРеквизитуРодителю,
		СтруктураСинонимов,
		СтруктураНезаполняемыхРеквизитов,
		ДополнительныеРеквизиты);
	
	// Заполним описание структуры реквизитов для заполнения реквизитов по статистике (подробнее см. комментарий к функции)
	ОписаниеРеквизитовОбъекта = ЗаполнениеСвойствПоСтатистикеСервер.ШаблонОписанияРеквизитовОбъекта();
	
	ДобавитьВОписаниеРеквизитыОбъекта(
		ИмяОбъектаМетаданных,
		ОписаниеРеквизитовОбъекта,
		СтруктураСинонимов,
		СтруктураНезаполняемыхРеквизитов,
		ДополнительныеРеквизиты);
		
	ОставитьВОписанииТолькоПодчиненныеРеквизитыОбъекта(
		ОписаниеРеквизитовОбъекта,
		ОтборПоРеквизитуРодителю);
	
	ОпределитьПорядокЗаполненияРеквизитовОбъекта(
		ОписаниеРеквизитовОбъекта);
	
	Возврат ОписаниеРеквизитовОбъекта;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РеквизитыОбъектовМетаданных

// Возвращает имя реквизита "вида" Подразделение для указанного объекта метаданных.
//
// Параметры:
//	ИмяОбъектаМетаданных - Строка - полное имя объекта метаданных
//
//	Возвращаемое значение:
//	 Строка - имя реквизита "вида" Подразделение, пустая строка если такого реквизита в объекте нет
//
Функция ИмяРеквизитаПодразделение(ИмяОбъектаМетаданных) Экспорт
	
	ТипРеквизита 	 = Тип("СправочникСсылка.СтруктураПредприятия"); // искомый тип реквизита объекта
	РеквизитыОбъекта = Новый Структура; // имена реквизитов объекта с типом, соответствующих искомому типу
	
	// Ищем реквизит в коллекции Реквизиты метаданных объекта
	Для Каждого Реквизит Из Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданных).Реквизиты Цикл
		
		Если Реквизит.Тип.Типы().Количество() = 1 И Реквизит.Тип.СодержитТип(ТипРеквизита) Тогда
			РеквизитыОбъекта.Вставить(Реквизит.Имя); // тип реквизита не составной и соответствует искомому
		КонецЕсли;
		
	КонецЦикла;
	
	Если РеквизитыОбъекта.Свойство("Подразделение") Тогда
		
		Возврат "Подразделение"; // есть реквизит с именем Подразделение
		
	ИначеЕсли РеквизитыОбъекта.Свойство("ПодразделениеОрганизации") Тогда
		
		Возврат "ПодразделениеОрганизации"; // есть реквизит с именем ПодразделениеОрганизации
		
	ИначеЕсли РеквизитыОбъекта.Количество() = 1 Тогда
		
		Для Каждого КлючИЗначение Из РеквизитыОбъекта Цикл
			Возврат КлючИЗначение.Ключ; // есть единственный реквизит с искомым типом
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ""; // подходящий реквизит объекта не найден
	
КонецФункции

// Возвращает имя реквизита объекта метаданные по "виду" реквизита.
//
// Параметры:
//	ИмяОбъектаМетаданных - Строка - полное имя объекта метаданных
//	ВидРеквизита - Строка - "вид" реквизита
//	СтруктураСинонимов - Структура - см. пояснение к переменной в ОписаниеЗаполняемыхРеквизитовОбъекта()
//	СтруктураНезаполняемыхРеквизитов - Структура - см. пояснение к переменной в ОписаниеЗаполняемыхРеквизитовОбъекта()
//
// Возвращаемое значение:
//	Строка - имя реквизита объекта
//
Функция ИмяРеквизитаОбъектаМетаданных(ИмяОбъектаМетаданных, ВидРеквизита, 
			СтруктураСинонимов, СтруктураНезаполняемыхРеквизитов)
	
	Если СтруктураНезаполняемыхРеквизитов.Свойство(ВидРеквизита) Тогда
		Возврат ""; // данный реквизит в этом объекте не заполняется
	КонецЕсли;
	
	Если СтруктураСинонимов.Свойство(ВидРеквизита) Тогда
		// Реквизит этого "вида" в объекте имеет другое имя
		ИмяРеквизита = СтруктураСинонимов[ВидРеквизита];
	Иначе
		// Имя этого реквизита в объекте совпадает с его "видом"
		ИмяРеквизита = ВидРеквизита;
	КонецЕсли;
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданных);
	
	Если ОбъектМетаданных.Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
		Возврат ""; // нет такого реквизита у объекта метаданных
	КонецЕсли;
	
	Возврат ИмяРеквизита; // имя реквизита как оно указано в метаданных
	
КонецФункции

// Возвращает реквизиты указанного объекта метаданных, заполняемые из данных заполнения объекта.
//
// Параметры:
//	ИмяОбъектаМетаданных - Строка - полное имя объекта метаданных
//
//	Возвращаемое значение:
//	 Структура - ключами являются имена реквизитов объекта метаданных
//
Функция РеквизитыЗаполняемыеИзДанныхЗаполнения(ИмяОбъектаМетаданных) Экспорт
	
	СтруктураРеквизитов = Новый Структура;
	
	Для Каждого Реквизит Из Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданных).Реквизиты Цикл
		Если Реквизит.ЗаполнятьИзДанныхЗаполнения Тогда
			СтруктураРеквизитов.Вставить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

#КонецОбласти

#Область ФормированиеСтруктурыОписанияРеквизитов

// Возвращает описание "стандартных" (общих для всех объектов) реквизитов, заполняемых по статистике.
//
// Возвращаемое значение:
//	Структура - см. ключ РеквизитыОбъекта в комментарии к ОписаниеЗаполняемыхРеквизитовОбъекта()
//
Функция ОписаниеСтандартныхРеквизитовОбъекта()
	
	СтандартныеРеквизиты = Новый Структура;
	
	ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(СтандартныеРеквизиты,
		"Подразделение", "Автор", "ДокументОснование, Менеджер");
	
	
	ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(СтандартныеРеквизиты,
		"Склад", "Автор", "", "Партнер, Соглашение");
	
	
	ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(СтандартныеРеквизиты,
		"Организация", "Автор", "", "Партнер, Соглашение");
	
	ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(СтандартныеРеквизиты,
		"БанковскийСчетОрганизации", "Организация", "", "Договор, Валюта");
	
	ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(СтандартныеРеквизиты,
		"Касса", "Автор, Организация", "", "Валюта");
	
	
	ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(СтандартныеРеквизиты,
		"БанковскийСчетКонтрагента", "Контрагент", "", "Договор, Валюта");
	
	
	ЗаполнениеСвойствПоСтатистикеСервер.ДобавитьЗаполняемыеРеквизиты(СтандартныеРеквизиты,
		"НалогообложениеНДС", "", "", "Партнер, Контрагент");
	
	Возврат СтандартныеРеквизиты;
	
КонецФункции


// Заполняет описание структуры реквизитов объекта информацией о всех реквизитах объекта и их синонимах.
//
// Параметры:
//	ИмяОбъектаМетаданных - Строка - полное имя объекта метаданных
//	ОписаниеРеквизитовОбъекта - Структура - см. комментарий к ОписаниеЗаполняемыхРеквизитовОбъекта()
//	СтруктураСинонимов - Структура - см. пояснение к переменной в ОписаниеЗаполняемыхРеквизитовОбъекта()
//	СтруктураНезаполняемыхРеквизитов - Структура - см. пояснение к переменной в ОписаниеЗаполняемыхРеквизитовОбъекта()
//	ДополнительныеРеквизиты - Структура - см. пояснение к переменной в ОписаниеЗаполняемыхРеквизитовОбъекта()
//
Процедура ДобавитьВОписаниеРеквизитыОбъекта(ИмяОбъектаМетаданных, ОписаниеРеквизитовОбъекта,
			СтруктураСинонимов, СтруктураНезаполняемыхРеквизитов, ДополнительныеРеквизиты)
			
	// Заполним информацию о "стандартных" (общих для всех объектов) реквизитах, заполняемых по статистике
	СтандартныеРеквизиты = ОписаниеСтандартныхРеквизитовОбъекта();
	
	Для Каждого ЗаполняемыйРеквизит Из СтандартныеРеквизиты Цикл
		
		ИмяРеквизита = ИмяРеквизитаОбъектаМетаданных(
			ИмяОбъектаМетаданных,
			ЗаполняемыйРеквизит.Ключ,
			СтруктураСинонимов,
			СтруктураНезаполняемыхРеквизитов);
		
		Если НЕ ЗначениеЗаполнено(ИмяРеквизита) Тогда
			Продолжить; // нет такого реквизита в метаданных объекта
		КонецЕсли;
		
		// Добавим в описание реквизит объекта, заполняемый по статистике
		ОписаниеРеквизитовОбъекта.РеквизитыОбъекта.Вставить(ИмяРеквизита, Новый Структура);
		
		Для Каждого РеквизитРодитель Из ЗаполняемыйРеквизит.Значение Цикл
			
			ИмяРеквизитаРодителя = ИмяРеквизитаОбъектаМетаданных(
				ИмяОбъектаМетаданных,
				РеквизитРодитель.Ключ,
				СтруктураСинонимов,
				СтруктураНезаполняемыхРеквизитов);
			
			Если НЕ ЗначениеЗаполнено(ИмяРеквизитаРодителя) Тогда
				Продолжить; // нет такого реквизита в метаданных объекта
			КонецЕсли;
			
			// Добавим в описание реквизита объекта, заполняемого по статистике, информацию о "реквизите-родителе"
			ОписаниеРеквизитовОбъекта.РеквизитыОбъекта[ИмяРеквизита].Вставить(
				ИмяРеквизитаРодителя,
				РеквизитРодитель.Значение);
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Сохраним в описании реквизитов информацию о синонимах ("вид" реквизита - имя реквизита)
	ОписаниеРеквизитовОбъекта.Вставить("СинонимыРеквизитов", ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(СтруктураСинонимов));
	
	// Добавим в описание дополнительный, "не стандартный" реквизит объекта, заполняемый по статистике
	Для Каждого ЗаполняемыйРеквизит Из ДополнительныеРеквизиты Цикл
		
		ОписаниеРеквизитовОбъекта.РеквизитыОбъекта.Вставить(ЗаполняемыйРеквизит.Ключ, Новый Структура);
		
		Для Каждого РеквизитРодитель Из ЗаполняемыйРеквизит.Значение Цикл
			ОписаниеРеквизитовОбъекта.РеквизитыОбъекта[ЗаполняемыйРеквизит.Ключ].Вставить(
				РеквизитРодитель.Ключ,
				РеквизитРодитель.Значение);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Удаляет из описания "лишние" реквизиты, заполнение которых в данном контексте не требуется.
// В результате в описании реквизитов остаются только реквизиты,
// "подчиненные" самому реквизиту ОтборПоРеквизитуРодителю или любому из его "реквизитов-потомков".
// 
// Параметры:
//	ОписаниеРеквизитовОбъекта - Структура - см. комментарий к ОписаниеЗаполняемыхРеквизитовОбъекта()
//	ОтборПоРеквизитуРодителю - Строка - см. комментарий к ОписаниеЗаполняемыхРеквизитовОбъекта()
//
Процедура ОставитьВОписанииТолькоПодчиненныеРеквизитыОбъекта(ОписаниеРеквизитовОбъекта, ОтборПоРеквизитуРодителю)
	
	Если НЕ ЗначениеЗаполнено(ОтборПоРеквизитуРодителю) Тогда
		Возврат; // требуется заполнение всех реквизитов объекта
	КонецЕсли;
	
	// Проверим, что указанный реквизит-родитель есть (по "или")
	// - среди реквизитов, заполняемых по статистике
	// - среди реквизитов-родителей, влияющих на заполнение других реквизитов
	// По сути это защита от некорректного вызова, когда ошибочно передан несуществующий реквизит-родитель.
	РеквизитСуществует = Ложь;
	
	Для Каждого РеквизитИРодители Из ОписаниеРеквизитовОбъекта.РеквизитыОбъекта Цикл
		Если НРег(РеквизитИРодители.Ключ) = НРег(ОтборПоРеквизитуРодителю)
		 ИЛИ РеквизитИРодители.Значение.Свойство(ОтборПоРеквизитуРодителю) Тогда
			РеквизитСуществует = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ РеквизитСуществует Тогда
		ОписаниеРеквизитовОбъекта.ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Для реквизита ""%1"" не предусмотрено заполнение по статистике.'"),
			ОтборПоРеквизитуРодителю);
		Возврат; // нет такого реквизита
	КонецЕсли;
	
	ПодчиненныеРеквизиты = Новый Структура(ОтборПоРеквизитуРодителю); // реквизит-родитель и все его "реквизиты-потомки"
	ПродолжатьПоиск      = Истина;
	
	// Ищем до тех пор, пока не будет выполнена холостая итерация,
	// на которой не будет найдено ни одного нового "реквизита-потомка".
	Пока ПродолжатьПоиск Цикл
		
		ПродолжатьПоиск = Ложь;
		
		Для Каждого РеквизитИРодители Из ОписаниеРеквизитовОбъекта.РеквизитыОбъекта Цикл
			
			Для Каждого ПодчиненныйРеквизит Из ПодчиненныеРеквизиты Цикл
				
				Если РеквизитИРодители.Значение.Свойство(ПодчиненныйРеквизит.Ключ)
				 И НЕ ПодчиненныеРеквизиты.Свойство(РеквизитИРодители.Ключ) Тогда
				 
					// Найден еще один "реквизит-потомок"
					ПодчиненныеРеквизиты.Вставить(РеквизитИРодители.Ключ);
					ПродолжатьПоиск = Истина;
					
					Прервать;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ПодчиненныеРеквизиты.Удалить(ОтборПоРеквизитуРодителю); // сам реквизит-родитель заполнять не надо
	
	// Удалим "лишние" реквизиты (не являющиеся "реквизитами-потомками")
	Для Каждого РеквизитИРодители Из ОписаниеРеквизитовОбъекта.РеквизитыОбъекта Цикл
		
		Если НЕ ПодчиненныеРеквизиты.Свойство(РеквизитИРодители.Ключ) Тогда
			
			// ... из структуры реквизитов объекта
			ОписаниеРеквизитовОбъекта.РеквизитыОбъекта.Удалить(РеквизитИРодители.Ключ);
			
			// ... из структуры синонимов реквизитов
			ВидРеквизита = ОбщегоНазначенияУТ.КлючКоллекцииПоЗначению(
				ОписаниеРеквизитовОбъекта.СинонимыРеквизитов,
				РеквизитИРодители.Ключ);
			
			Если ЗначениеЗаполнено(ВидРеквизита) Тогда
				ОписаниеРеквизитовОбъекта.СинонимыРеквизитов.Удалить(ВидРеквизита);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Вычисляет порядок, в которым должны заполняться реквизиты объекта.
// Реквизиты и их связи по сути являются описанием графа - в этой процедуре выполняется топологическая сортировка этого графа:
// - сначала должны заполняться реквизиты, среди "родителей" которых нет других заполняемых реквизитов
// - затем заполняются реквизиты, "подчиненные" реквизитам, найденным на предыдущей итерации
// - и т.д., пока на очередной итерации не будет найдено ни одного "подчиненного" реквизита
// - если в графе будет найден цикл (петля), то будет выдана ошибка - значит описание реквизитов объекта сформировано некорректно
//
// Параметры:
//	ОписаниеРеквизитовОбъекта - Структура - см. комментарий к ОписаниеЗаполняемыхРеквизитовОбъекта()
//
Процедура ОпределитьПорядокЗаполненияРеквизитовОбъекта(ОписаниеРеквизитовОбъекта)
	
	ОписаниеРеквизитовОбъекта.ПорядокЗаполненияРеквизитов.Очистить();
	
	// Представим все дуги графа в виде структуры: Ключ - приемник, Значение - источник
	ВходящиеСвязи = Новый Структура;
	
	Для Каждого РеквизитИРодители Из ОписаниеРеквизитовОбъекта.РеквизитыОбъекта Цикл
		
		ВходящиеСвязи.Вставить(
			РеквизитИРодители.Ключ,
			ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(РеквизитИРодители.Значение));
		
		Для Каждого Родитель Из РеквизитИРодители.Значение Цикл
			Если НЕ ВходящиеСвязи.Свойство(Родитель.Ключ) Тогда
				ВходящиеСвязи.Вставить(Родитель.Ключ, Новый Структура);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	// Продолжаем обход графа пока в нем остаются "несортированные" вершины.
	Пока ВходящиеСвязи.Количество() > 0 Цикл
		
		РеквизитыТекущегоУровня = Новый Структура; // вершины, в которые не входят дуги 
		
		Для Каждого ВходящаяСвязь Из ВходящиеСвязи Цикл
			Если ВходящаяСвязь.Значение.Количество() = 0 Тогда
				// Найдена вершина без входящих дуг (реквизит без родителей)
				РеквизитыТекущегоУровня.Вставить(ВходящаяСвязь.Ключ);
			КонецЕсли;
		КонецЦикла;
		
		Если РеквизитыТекущегоУровня.Количество() = 0 Тогда
			// В графе найдено цикл
			ОписаниеРеквизитовОбъекта.ТекстОшибки = НСтр(
				"ru='При описании структуры реквизитов для заполнения по статистике
				|допущено зацикливание связей реквизитов'");
			Возврат;
		КонецЕсли;
		
		// Удалим найденные на текущей итерации вершины без входящих дуг из графа.
		// В результате некоторые из их подчиненных вершин теперь станут вершинами без входящих дуг.
		Для Каждого ТекущийРеквизит Из РеквизитыТекущегоУровня Цикл
			ВходящиеСвязи.Удалить(ТекущийРеквизит.Ключ); // удалим из заполняемых реквизитов
			Для Каждого ВходящаяСвязь Из ВходящиеСвязи Цикл
				ВходящаяСвязь.Значение.Удалить(ТекущийРеквизит.Ключ); // удалим из "реквизитов-родителей"
			КонецЦикла;
		КонецЦикла;
		
		// Среди найденных на текущей итерации оставим только те реквизиты, которые надо заполнять по статистике.
		Для Каждого ТекущийРеквизит Из РеквизитыТекущегоУровня Цикл
			Если НЕ ОписаниеРеквизитовОбъекта.РеквизитыОбъекта.Свойство(ТекущийРеквизит.Ключ) Тогда
				// Этот реквизит является только "родителем", но сам не заполняется.
				РеквизитыТекущегоУровня.Удалить(ТекущийРеквизит.Ключ);
			КонецЕсли;
		КонецЦикла;
		
		// Если на текущей итерации найден хоть один заполняемый по статистике реквизит,
		// то добавим новый уровень в порядок заполнения реквизитов.
		// В нем будут только заполняемые по статистике реквизиты, "подчиненные" только реквизитам вышестоящих уровней.
		Если РеквизитыТекущегоУровня.Количество() > 0 Тогда
			ОписаниеРеквизитовОбъекта.ПорядокЗаполненияРеквизитов.Добавить(РеквизитыТекущегоУровня);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
