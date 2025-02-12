﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса
//								Конструктор структуры: ЗаказыСервер.СтруктураКорректировкиСтрокЗаказа().
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыВнутреннихЗаказов[НовыйСтатус];
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		СтруктураКорректировкиСтрокЗаказа = ЗаказыСервер.СтруктураКорректировкиСтрокЗаказа();
		ЗаполнитьЗначенияСвойств(СтруктураКорректировкиСтрокЗаказа, ДополнительныеПараметры);
		
		Если СтруктураКорректировкиСтрокЗаказа.ОтменитьНеотработанныеСтроки 
			ИЛИ СтруктураКорректировкиСтрокЗаказа.СкорректироватьМерныеТовары Тогда
			СтруктураКорректировкиСтрокЗаказа.ПроверятьОстатки = Статус <> Перечисления.СтатусыВнутреннихЗаказов.КОбеспечению;
			СкорректироватьСтрокиЗаказа(СтруктураКорректировкиСтрокЗаказа);
		КонецЕсли;
		
	КонецЕсли;
	
	Статус = ЗначениеНовогоСтатуса;
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

// Корректирует строки, по которым не была оформлено перемещение или складские оредера или имеются расхождения по мерным товарам.
//
// Параметры:
// 		СтруктураПараметров - Структура - Структура параметров корректировки, конструктор: ЗаказыСервер.СтруктураКорректировкиСтрокЗаказа()
//
// Возвращаемое значение:
// 		Структура
// 		*	КоличествоСтрок - Количество отмененных/скорректированных строк
//
Функция СкорректироватьСтрокиЗаказа(СтруктураПараметров) Экспорт
	
	КоличествоСкорректированныхСтрок = 0;
	СвойстваОтмененнойСтроки = Новый Структура("Отменено, СтатусУказанияСерий", Истина, 0);
	
	Если Не СтруктураПараметров.ПроверятьОстатки Тогда
		
		Для Каждого СтрокаТовары из Товары Цикл
			
			Если Не СтрокаТовары.Отменено Тогда
				
				ЗаполнитьЗначенияСвойств(СтрокаТовары, СвойстваОтмененнойСтроки);
				КоличествоСкорректированныхСтрок = КоличествоСкорректированныхСтрок + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Возврат Новый Структура("КоличествоСтрок", КоличествоСкорректированныхСтрок);
		
	КонецЕсли;
	
	ОтменятьТолькоМТВПределахДопустимыхОтклонений = НЕ СтруктураПараметров.ОтменитьНеотработанныеСтроки 
													И СтруктураПараметров.СкорректироватьМерныеТовары;
	
	Возврат Документы.ЗаказНаПеремещение.ОтменитьНеотработанныеСтроки(ЭтотОбъект, 
				ОтменятьТолькоМТВПределахДопустимыхОтклонений, 
				СтруктураПараметров.СкорректироватьМерныеТовары);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеремещениеТоваров;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Основание") Тогда
		
		Если ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
			ЗаполнитьПоЗаказуКлиента(ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг")
			Тогда
			
			ЗаполнитьПоПриобретениюТоваров(ДанныеЗаполнения);
			
		Иначе
			ВызватьИсключение НСтр("ru = 'Неверные параметры создания документа на основании'");
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента") Тогда
		ЗаполнитьПоЗаявкеНаВозвратТоваровОтКлиента(ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаВнутреннееПотребление") Тогда
		ЗаполнитьПоЗаказуНаВнутреннееПотребление(ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаСборку") Тогда
		ЗаполнитьПоЗаказуНаСборку(ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
		ЗаполнитьПоПоступлениюТоваров(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения, ТипЗнч(ДанныеЗаполнения) <> Тип("ДокументСсылка.ПриобретениеТоваровУслуг"));
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	
	Документы.ЗаказНаПеремещение.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация, 
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НачалоОтгрузки");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ОкончаниеПоступления");
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	// Склад получатель и склад отправитель должны различаться
	Если ЗначениеЗаполнено(СкладОтправитель) И СкладОтправитель = СкладПолучатель Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Один склад не может быть как отправителем, так и получателем. Измените один из складов.'"),
			ЭтотОбъект,
			"СкладОтправитель",
			,
			Отказ);
		
	КонецЕсли;
	
	// Желаемая дата поступления в шапке должна быть не меньше даты документа
	Если ЗначениеЗаполнено(ЖелаемаяДатаПоступления) И ЖелаемаяДатаПоступления < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru='Желаемая дата поступления должна быть не меньше даты документа %Дата%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Дата%", Формат(Дата,"ДЛФ=DD"));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ЖелаемаяДатаПоступления",
			,
			Отказ);
		
	КонецЕсли;
	
	// Организация-получатель должна быть взаимосвязана с организацией-отправителем по организационной структуре
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

	ВариантНеТребуется = Перечисления.ВариантыОбеспечения.НеТребуется;
	СкладОтправительОбязателен = Ложь;
	
	ТекстОшибкиПоляНачалаОтгрузки = НСтр("ru='Не заполнена колонка ""Дата отгрузки""'");
	Если ИспользоватьДлительностьПеремещения Тогда
		ТекстОшибкиПоляНачалаОтгрузки = НСтр("ru='Не заполнена колонка ""Начало отгрузки""'");
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из Товары Цикл
		
		АдресОшибки = " " + НСтр("ru='в строке %НомерСтроки% списка ""Товары""'");
		АдресОшибки = СтрЗаменить(АдресОшибки,"%НомерСтроки%", СтрокаТЧ.НомерСтроки);
		
		Если СтрокаТЧ.ВариантОбеспечения <> ВариантНеТребуется
			И Не СтрокаТЧ.Отменено Тогда
			
			СкладОтправительОбязателен = Истина;
			Если Не ЗначениеЗаполнено(СтрокаТЧ.НачалоОтгрузки) Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибкиПоляНачалаОтгрузки + АдресОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "НачалоОтгрузки"),
					,
					Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИспользоватьДлительностьПеремещения И НЕ СтрокаТЧ.Отменено И НЕ ЗначениеЗаполнено(СтрокаТЧ.ОкончаниеПоступления) Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Окончание поступления""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "ОкончаниеПоступления"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если ИспользоватьДлительностьПеремещения И ЗначениеЗаполнено(СтрокаТЧ.НачалоОтгрузки) И ЗначениеЗаполнено(СтрокаТЧ.ОкончаниеПоступления) И СтрокаТЧ.НачалоОтгрузки > СтрокаТЧ.ОкончаниеПоступления Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания поступления меньше даты начала отгрузки'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "ОкончаниеПоступления"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.НачалоОтгрузки) И СтрокаТЧ.НачалоОтгрузки < НачалоДня(Дата) Тогда
			
			ТекстОшибки = НСтр("ru='Дата начала отгрузки должна быть не меньше даты документа ""%Дата%""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки,"%Дата%", Формат(Дата, "ДЛФ=DD"));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "НачалоОтгрузки"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если ИспользоватьДлительностьПеремещения И ЗначениеЗаполнено(СтрокаТЧ.ОкончаниеПоступления) И СтрокаТЧ.ОкончаниеПоступления < НачалоДня(Дата) Тогда
			
			ТекстОшибки = НСтр("ru='Дата окончания поступления должна быть не меньше даты документа ""%Дата%""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки,"%Дата%", Формат(Дата, "ДЛФ=DD"));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки + АдресОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", СтрокаТЧ.НомерСтроки, "ОкончаниеПоступления"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("СкладОтправитель");
	Если СкладОтправительОбязателен И Не ЗначениеЗаполнено(СкладОтправитель) Тогда
		
		ТекстОшибки = НСтр("ru='Поле ""Склад-отправитель"" не заполнено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "СкладОтправитель", , Отказ);
		
	КонецЕсли;
	
	ДоставкаТоваров.ПроверитьЗаполнениеРеквизитовДоставки(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ЗаказыСервер.УстановитьКлючВСтрокахТабличнойЧасти(ЭтотОбъект, "Товары");
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не ИспользоватьДлительностьПеремещения Тогда
		Товары.ЗагрузитьКолонку(Товары.ВыгрузитьКолонку("НачалоОтгрузки"), "ОкончаниеПоступления");
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(
			ЭтотОбъект,
			Документы.ЗаказНаПеремещение));
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.ЗаказНаПеремещение.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	ШаблонНазначения = Документы.ЗаказНаПеремещение.ШаблонНазначения(ЭтотОбъект);
	ПерегенерацияНазначения = Справочники.Назначения.ПроверитьЗаполнитьПередЗаписью(Назначение, ШаблонНазначения,
		ЭтотОбъект, "НаправлениеДеятельности", Отказ);
	
	Если ПерегенерацияНазначения Тогда
		ОбосабливатьПоНазначениюЗаказа = Константы.ВариантОбособленияТоваровВПеремещении.Получить()
			<> Перечисления.ВариантыОбособленияТоваровВПеремещении.НазначениеПолучателя;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
	// Добавление заказа для расчета состояний необходимо для тех случаев когда, например, для всех товаров указан способ обеспечения "Не обеспечивать".
	// При таком способе обеспечения документ не делает движений по тем регистрам, которые добавили бы заказ для расчета самостоятельно.
	ПроведениеСерверУТ.ДобавитьЗаказДляРасчетаСостояний(ДополнительныеСвойства, Ссылка);
	
	ШаблонНазначения = Документы.ЗаказНаПеремещение.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПриЗаписиДокумента(Назначение, ШаблонНазначения, ЭтотОбъект, СкладПолучатель);
	
	// При отмене проведения или установке пометки на удаление проведенного документа необходим вызов пересчета состояний, для удаления записи по текущему документу
	// из регистра сведений СостоянияВнутреннихЗаказов. Корректный пересчет состояния возможен в том случае, когда у документа уже установлен (записан) признак Проведен = Ложь
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование       = Неопределено;
	ЖелаемаяДатаПоступления = Дата(1, 1, 1);
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыЗаказовНаПеремещение") Тогда
		Статус = Метаданные().Реквизиты.Статус.ЗначениеЗаполнения;
	Иначе
		Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт;
	КонецЕсли;
	МаксимальныйКодСтроки   = 0;
	Назначение              = Справочники.Назначения.ПустаяСсылка();
	СостояниеЗаполненияМногооборотнойТары = Перечисления.СостоянияЗаполненияМногооборотнойТары.ПустаяСсылка();
	
	Для каждого СтрокаТовары Из Товары Цикл
	
		СтрокаТовары.НачалоОтгрузки = Дата(1, 1, 1);
		СтрокаТовары.ОкончаниеПоступления = Дата(1, 1, 1);
		СтрокаТовары.Отменено             = Ложь;
		СтрокаТовары.КодСтроки            = 0;
		СтрокаТовары.Назначение = Справочники.Назначения.ПустаяСсылка();
		
	КонецЦикла;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);

	Документы.ЗаказНаПеремещение.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ЗаказыСервер.ОтразитьЗаказыНаПеремещение(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьДвижениеТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьГрафикОтгрузкиТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКОтгрузке(ДополнительныеСвойства, Движения, Отказ);
	ЗаказыСервер.ОтразитьТоварыКПоступлению(ДополнительныеСвойства, Движения, Отказ);

	СформироватьСписокРегистровДляКонтроля();
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ);
	
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

	ВыполнитьКонтрольЗаказаПослеПроведения(Отказ);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ДоставкаТоваров.ОтразитьСостояниеДоставки(Ссылка, Отказ, Истина);

	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено, ЗаполнятьВариантОбеспечения = Истина)

	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыЗаказовНаПеремещение") Тогда
		Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт;
	КонецЕсли;

	Если ЗаполнятьВариантОбеспечения Тогда
		ОбеспечениеСервер.ЗаполнитьВариантОбеспеченияПоУмолчанию(Товары);
	КонецЕсли;
	
	ОбосабливатьПоНазначениюЗаказа = Константы.ВариантОбособленияТоваровВПеремещении.Получить()
		<> Перечисления.ВариантыОбособленияТоваровВПеремещении.НазначениеПолучателя;
	
	ВариантПриемкиТоваров = ЗакупкиСервер.ПолучитьВариантПриемкиТоваров();
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Знач ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ДанныеЗаполнения.Свойство("Товары") Тогда
		ЗаполнитьТоварыПоТаблице(ДанныеЗаполнения.Товары);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаявкеНаВозвратТоваровОтКлиента(ЗаявкаНаВозврат)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаказКлиента.Статус                  КАК СтатусДокумента,
	|	ЗаказКлиента.Проведен                КАК Проведен,
	|	ЗаказКлиента.Организация             КАК Организация,
	|	ЗаказКлиента.Сделка                  КАК Сделка,
	|	ЗаказКлиента.Подразделение           КАК Подразделение,
	|	ЗаказКлиента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ЗаказКлиента.СпособКомпенсации       КАК СпособКомпенсации
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка = &ЗаявкаНаВозврат");
	
	Запрос.УстановитьПараметр("ЗаявкаНаВозврат", ЗаявкаНаВозврат);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Если Реквизиты.СпособКомпенсации <> Перечисления.СпособыКомпенсацииВозвратовТоваров.ЗаменитьТовары Тогда
		ТекстОшибки = НСтр("ru='Ввод на основании возможен для заявок на возврат со способом компенсации ""Заменить товары"".'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Документы.ЗаявкаНаВозвратТоваровОтКлиента.ПроверитьВозможностьВводаНаОсновании(
		ЗаявкаНаВозврат,
		Реквизиты.СтатусДокумента,
		НЕ Реквизиты.Проведен);
	
	//Заполнение шапки
	Организация             = Реквизиты.Организация;
	Сделка                  = Реквизиты.Сделка;
	ДокументОснование       = ЗаявкаНаВозврат;
	Подразделение           = Реквизиты.Подразделение;
	НаправлениеДеятельности = Реквизиты.НаправлениеДеятельности;
	
	//Заполнение табличной части.
	
	ПараметрыТаблицыТовары = ОбеспечениеСервер.ПараметрыТаблицыОстатковПоЗаказу();
	ПараметрыТаблицыТовары.ПолучатьУслуги = Ложь;
	ПараметрыТаблицыТовары.ПолучатьРаботы = Ложь;
	
	ТаблицаТовары = ОбеспечениеСервер.ТаблицаОстатковКЗаказу(ЗаявкаНаВозврат, ПараметрыТаблицыТовары);
	
	Если ТаблицаТовары.Количество() > 0 Тогда
		Товары.Загрузить(ТаблицаТовары);
		СкладПолучатель = ТаблицаТовары[0].Склад;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказуКлиента(ДанныеЗаполнения)

	ЗаказКлиента = ДанныеЗаполнения.Основание;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаказКлиента.Статус                  КАК СтатусДокумента,
	|	ЗаказКлиента.Проведен                КАК Проведен,
	|	ЗаказКлиента.Организация             КАК Организация,
	|	ЗаказКлиента.Сделка                  КАК Сделка,
	|	ЗаказКлиента.Подразделение           КАК Подразделение,
	|	ЗаказКлиента.НаправлениеДеятельности КАК НаправлениеДеятельности
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Ссылка = &ЗаказКлиента");
	
	Запрос.УстановитьПараметр("ЗаказКлиента", ЗаказКлиента);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Документы.ЗаказКлиента.ПроверитьВозможностьВводаНаОсновании(
		ЗаказКлиента,
		Реквизиты.СтатусДокумента,
		НЕ Реквизиты.Проведен);
	
	//Заполнение шапки
	Организация             = Реквизиты.Организация;
	Сделка                  = Реквизиты.Сделка;
	ДокументОснование       = ЗаказКлиента;
	Подразделение           = Реквизиты.Подразделение;
	НаправлениеДеятельности = Реквизиты.НаправлениеДеятельности;
	СкладПолучатель         = ДанныеЗаполнения.Склад;
	
	//Заполнение табличной части.
	
	ПараметрыТаблицыТовары = ОбеспечениеСервер.ПараметрыТаблицыОстатковПоЗаказу();
	ПараметрыТаблицыТовары.ПолучатьУслуги = Ложь;
	ПараметрыТаблицыТовары.ПолучатьРаботы = Ложь;
	ПараметрыТаблицыТовары.Отбор          = СкладПолучатель;
	
	ТаблицаТовары = ОбеспечениеСервер.ТаблицаОстатковКЗаказу(ЗаказКлиента, ПараметрыТаблицыТовары);
	Товары.Загрузить(ТаблицаТовары);
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказуНаВнутреннееПотребление(ЗаказНаПотребление)

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Заказ.Статус                  КАК СтатусДокумента,
	|	Заказ.Проведен                КАК Проведен,
	|	Заказ.Организация             КАК Организация,
	|	Заказ.Сделка                  КАК Сделка,
	|	Заказ.Подразделение           КАК Подразделение,
	|	Заказ.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Заказ.Склад                   КАК СкладДокумента
	|ИЗ
	|	Документ.ЗаказНаВнутреннееПотребление КАК Заказ
	|ГДЕ
	|	Заказ.Ссылка = &ЗаказНаПотребление");
	
	Запрос.УстановитьПараметр("ЗаказНаПотребление", ЗаказНаПотребление);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		ЗаказНаПотребление,
		Реквизиты.СтатусДокумента,
		НЕ Реквизиты.Проведен);
	
	//Заполнение шапки
	Организация             = Реквизиты.Организация;
	Сделка                  = Реквизиты.Сделка;
	ДокументОснование       = ЗаказНаПотребление;
	Подразделение           = Реквизиты.Подразделение;
	НаправлениеДеятельности = Реквизиты.НаправлениеДеятельности;
	СкладПолучатель         = Реквизиты.СкладДокумента;
	
	//Заполнение табличной части.
	ПараметрыТаблицыТовары = ОбеспечениеСервер.ПараметрыТаблицыОстатковПоЗаказу();
	ПараметрыТаблицыТовары.ПолучатьУслуги = Ложь;
	ПараметрыТаблицыТовары.ПолучатьРаботы = Ложь;

	ТаблицаТовары = ОбеспечениеСервер.ТаблицаОстатковКЗаказу(ЗаказНаПотребление, ПараметрыТаблицыТовары);
	
	Если ТаблицаТовары.Количество() > 0 Тогда
		Товары.Загрузить(ТаблицаТовары);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаказуНаСборку(ЗаказНаСборку)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Заказ.Статус                  КАК СтатусДокумента,
	|	Заказ.Проведен                КАК Проведен,
	|	Заказ.Организация             КАК Организация,
	|	Заказ.Сделка                  КАК Сделка,
	|	Заказ.Подразделение           КАК Подразделение,
	|	Заказ.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	Заказ.Склад                   КАК СкладДокумента,
	|	Заказ.ХозяйственнаяОперация   КАК ХозяйственнаяОперация
	|ИЗ
	|	Документ.ЗаказНаСборку КАК Заказ
	|ГДЕ
	|	Заказ.Ссылка = &ЗаказНаСборку");
	
	Запрос.УстановитьПараметр("ЗаказНаСборку", ЗаказНаСборку);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Если Реквизиты.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.СборкаТоваров Тогда
		ТекстОшибки = НСтр("ru='Ввод на основании возможен для заказов на сборку с операцией ""Сборка из комплектующих"".'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		ЗаказНаСборку,
		Реквизиты.СтатусДокумента,
		НЕ Реквизиты.Проведен);
	
	//Заполнение шапки
	Организация             = Реквизиты.Организация;
	Сделка                  = Реквизиты.Сделка;
	ДокументОснование       = ЗаказНаСборку;
	Подразделение           = Реквизиты.Подразделение;
	НаправлениеДеятельности = Реквизиты.НаправлениеДеятельности;
	СкладПолучатель         = Реквизиты.СкладДокумента;
	
	//Заполнение табличной части.
	ПараметрыТаблицыТовары = ОбеспечениеСервер.ПараметрыТаблицыОстатковПоЗаказу();
	ПараметрыТаблицыТовары.ПолучатьУслуги = Ложь;
	ПараметрыТаблицыТовары.ПолучатьРаботы = Ложь;
	
	ТаблицаТовары = ОбеспечениеСервер.ТаблицаОстатковКЗаказу(ЗаказНаСборку, ПараметрыТаблицыТовары);
	
	Если ТаблицаТовары.Количество() > 0 Тогда
		Товары.Загрузить(ТаблицаТовары);
	КонецЕсли;
	
КонецПроцедуры


Процедура ЗаполнитьПоПриобретениюТоваров(ДанныеЗаполнения)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Шапка.Ссылка                  КАК Ссылка,
	|	Шапка.Организация             КАК Организация,
	|	Шапка.Сделка                  КАК Сделка,
	|	Шапка.Склад                   КАК СкладОтправитель,
	|	Шапка.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НЕ Шапка.Проведен             КАК ЕстьОшибкиПроведен
	|ИЗ
	|	&ОснованиеЗаказа КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура        КАК Номенклатура,
	|	Товары.Характеристика      КАК Характеристика,
	|	Товары.Назначение          КАК Назначение,
	|	Товары.Склад               КАК Склад,
	|	Товары.Серия               КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Количество          КАК Количество,
	|	Товары.КоличествоУпаковок  КАК КоличествоУпаковок,
	|	Товары.Упаковка            КАК Упаковка,
	|	
	|	ВЫБОР КОГДА Товары.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) ТОГДА
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить)
	|			ИНАЧЕ
	|				ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно)
	|		КОНЕЦ                  КАК ВариантОбеспечения
	|
	|ИЗ
	|	&ОснованиеЗаказа.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|	И Товары.Номенклатура.ТипНоменклатуры В(
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|		ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И Товары.Склад = &Склад
	|;
	|
	|////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура   КАК Номенклатура,
	|	Серии.Характеристика КАК Характеристика,
	|	Серии.Назначение     КАК Назначение,
	|	Серии.Склад          КАК Склад,
	|	Серии.Серия          КАК Серия,
	|	Серии.Количество     КАК Количество
	|ИЗ
	|	&ОснованиеЗаказа.Серии КАК Серии
	|ГДЕ
	|	Серии.Ссылка = &ДокументОснование
	|	И Серии.Склад = &Склад";
	
	Если ТипЗнч(ДанныеЗаполнения.Основание) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОснованиеЗаказа", "Документ.ПриобретениеТоваровУслуг");
	КонецЕсли;
	
	Запрос       = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ДокументОснование", ДанныеЗаполнения.Основание);
	Запрос.УстановитьПараметр("Склад",             ДанныеЗаполнения.Склад);
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	Шапка            = ПакетРезультатов[0].Выбрать();
	
	Если Не Шапка.Следующий() Тогда
		ТекстОшибки = НСтр("ru='Документ %Документ% не содержит товаров. Ввод на основании документа запрещен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ДанныеЗаполнения.Основание);
		
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(Шапка.Ссылка, Неопределено, Шапка.ЕстьОшибкиПроведен);
	
	// Заполнение шапки.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	ДокументОснование = ДанныеЗаполнения.Основание;
	СкладОтправитель  = ДанныеЗаполнения.Склад;
	
	// Разбиение строк, заполнение серий со статусом 10.
	ТоварыОснования = ПакетРезультатов[1].Выгрузить();
	ИндексыСтрок    = Новый Массив();
	
	Для Каждого СтрокаТовары Из ТоварыОснования Цикл
		Если СтрокаТовары.СтатусУказанияСерий = 10 Тогда
			ИндексыСтрок.Вставить(0, ТоварыОснования.Индекс(СтрокаТовары));
		КонецЕсли;
	КонецЦикла;
	
	Если ИндексыСтрок.Количество() > 0 Тогда
		СерииОснования = ПакетРезультатов[2].Выгрузить();
		КлючСерии      = "Номенклатура, Характеристика, Склад, Назначение";
		
		ОбеспечениеСервер.ПеренестиСерииИзТаблицыВСтроки(ТоварыОснования, ИндексыСтрок, СерииОснования, КлючСерии);
	КонецЕсли;
	
	Товары.Загрузить(ТоварыОснования);
	
	// Заполнение статусов указания серий
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

Процедура ЗаполнитьПоПоступлениюТоваров(ДокументПоступления)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Шапка.Ссылка                  КАК Ссылка,
	|	Шапка.Организация             КАК Организация,
	|	Шапка.Сделка                  КАК Сделка,
	|	Шапка.Склад                   КАК СкладОтправитель,
	|	Шапка.Подразделение           КАК Подразделение,
	|	Шапка.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НЕ Шапка.Проведен             КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ПоступлениеТоваров КАК Шапка
	|ГДЕ
	|	Шапка.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Назначение КАК Назначение,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Количество КАК Количество,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Упаковка КАК Упаковка,
	|	ВЫБОР
	|		КОГДА Товары.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно)
	|	КОНЕЦ КАК ВариантОбеспечения
	|ИЗ
	|	Документ.ПоступлениеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура КАК Номенклатура,
	|	Серии.Характеристика КАК Характеристика,
	|	Серии.Назначение КАК Назначение,
	|	Серии.Серия КАК Серия,
	|	Серии.Количество КАК Количество
	|ИЗ
	|	Документ.ПоступлениеТоваров.Серии КАК Серии
	|ГДЕ
	|	Серии.Ссылка = &ДокументОснование";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументПоступления);
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	
	ТоварыОснования = ПакетРезультатов[1].Выгрузить();
	Если ТоварыОснования.Количество() = 0 Тогда

		ТекстОшибки = НСтр("ru='Документ %Документ% не содержит товаров. Ввод на основании документа запрещен.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ДокументПоступления);
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	Шапка = ПакетРезультатов[0].Выбрать();
	Шапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		Шапка.Ссылка,
		,
		Шапка.ЕстьОшибкиПроведен,);
	
	// Заполнение шапки.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка);
	ДокументОснование = ДокументПоступления;
	
	// Разбиение строк, заполнение серий со статусом 10.
	ИндексыСтрок = Новый Массив();
	Для Каждого СтрокаТовары Из ТоварыОснования Цикл
		
		Если СтрокаТовары.СтатусУказанияСерий = 10 Тогда
			ИндексыСтрок.Вставить(0, ТоварыОснования.Индекс(СтрокаТовары));
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИндексыСтрок.Количество() > 0 Тогда
		
		СерииОснования = ПакетРезультатов[2].Выгрузить();
		КлючСерии = "Номенклатура, Характеристика, Склад, Назначение";
		ОбеспечениеСервер.ПеренестиСерииИзТаблицыВСтроки(ТоварыОснования, ИндексыСтрок, СерииОснования, КлючСерии);
		
	КонецЕсли;
	
	// Заполнение табличной части товары.
	Товары.Загрузить(ТоварыОснования);
	
	СкладОтправитель = ДокументПоступления.Склад;

	// Заполнение статусов указания серий
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;

	Массив.Добавить(Движения.ОбеспечениеЗаказов);

	// Контроль выполняется при перепроведении и отмене проведения.
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
		Массив.Добавить(Движения.ЗаказыНаПеремещение);
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.ЭтоНовый
		Или НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПеремещение).ИспользоватьСерииНоменклатуры Тогда
		Массив.Добавить(Движения.ТоварыКОтгрузке);
	КонецЕсли;
	
	// Контроль выполняется только при проведении.
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда

		Массив.Добавить(Движения.СвободныеОстатки);
		Массив.Добавить(Движения.ГрафикОтгрузкиТоваров);

	КонецЕсли;

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура ЗаполнитьТоварыПоТаблице(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НачалоОтгрузки = НачалоДня(ДанныеЗаполнения[0].НачалоОтгрузки);
	ОкончаниеПоступления = НачалоДня(ДанныеЗаполнения[0].ОкончаниеПоступления);
	Длительность = Цел((ОкончаниеПоступления - НачалоОтгрузки) / 86400);
	ОбщаяДлительность = Истина;
	ОтгрузкаИПоступлениеОднойДатой = (НачалоОтгрузки = ОкончаниеПоступления);
	
	Для Каждого СтрокаДанныхЗаполнения Из ДанныеЗаполнения Цикл
		
		Строка = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, СтрокаДанныхЗаполнения);
		
		Если ОтгрузкаИПоступлениеОднойДатой
			И (НачалоДня(Строка.НачалоОтгрузки) <> НачалоДня(Строка.ОкончаниеПоступления)) Тогда
			
			ОтгрузкаИПоступлениеОднойДатой = Ложь;
			
		КонецЕсли;
		
		Если ОбщаяДлительность
			И Длительность <> Цел((НачалоДня(Строка.ОкончаниеПоступления) - НачалоДня(Строка.НачалоОтгрузки)) / 86400) Тогда
			
			ОбщаяДлительность = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ИспользоватьДлительностьПеремещения = Не ОтгрузкаИПоступлениеОднойДатой;
	Если ИспользоватьДлительностьПеремещения И ОбщаяДлительность Тогда
		ДлительностьПеремещения = Длительность;
	Иначе
		ДлительностьПеремещения = 0;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет возможность проведения документа в статусе "Закрыт".
//
// Параметры:
//  Отказ	 - Булево - параметр "Отказ" обработки проведения
//
Процедура ВыполнитьКонтрольЗаказаПослеПроведения(Отказ)

	КонтролироватьОтгрузку = ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыНаПеремещениеБезПолнойОтгрузки");
	
	Если Статус = Перечисления.СтатусыВнутреннихЗаказов.Закрыт
		И КонтролироватьОтгрузку Тогда
		Массив = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка);
		ДополнительныеПараметры = Новый Структура("КонтрольВыполненияЗаказа", Истина);
		
		Запрос = Документы.ЗаказНаПеремещение.СформироватьЗапросПроверкиПриСменеСтатуса(Массив, "Закрыт", ДополнительныеПараметры);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаОтгрузка = Результат.Выбрать();
		
		Пока ВыборкаОтгрузка.Следующий() Цикл
			
			ПроверкаПройдена = Документы.ЗаказНаПеремещение.ПроверкаПередСменойСтатуса(ВыборкаОтгрузка, Статус, ДополнительныеПараметры);
			Если Не ПроверкаПройдена Тогда
				Отказ = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
