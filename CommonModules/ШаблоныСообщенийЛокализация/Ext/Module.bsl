﻿
#Область ПрограммныйИнтерфейс

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// см. ШаблоныСообщенийПереопределяемый.ПриПодготовкеШаблонаСообщения()
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры) Экспорт
	
	//++ Локализация
	МассивНазначенийШаблона = Новый Массив;
	Для Каждого ЗначениеПеречисления ИЗ Перечисления.ТипыСобытийОповещений.ИзменениеСостоянияЗаказа.Метаданные().ЗначенияПеречисления Цикл
		Если НЕ Перечисления.ТипыСобытийОповещений.ДанныеДляОбработкиОчередиОповещений(Перечисления.ТипыСобытийОповещений[ЗначениеПеречисления.Имя]).ДоступноДляИспользования Тогда
			Продолжить;
		КонецЕсли;
		МассивНазначенийШаблона.Добавить(ЗначениеПеречисления.Имя);
	КонецЦикла;
	
	НазначениеШаблонаЭтоОповещение = Ложь;
	Если МассивНазначенийШаблона.Найти(НазначениеШаблона) <> Неопределено Тогда
		НазначениеШаблонаЭтоОповещение = Истина;
		ИмяМакета = СтрЗаменить(НазначениеШаблона, "Перечисление.ТипыСобытийОповещений.", "");
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.ИнтеграцияСЯндексКассой
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ИнтеграцияСЯндексКассой") Тогда 
		ОбщийМодульИнтеграцияСЯндексКассой = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияСЯндексКассой");
		Если Не ОбщийМодульИнтеграцияСЯндексКассой = Неопределено Тогда 
			ОбщийМодульИнтеграцияСЯндексКассой.ПриПодготовкеШаблонаСообщения(
				Реквизиты,
				Вложения,
				?(НазначениеШаблонаЭтоОповещение, "Перечисление.ТипыСобытийОповещений." + ИмяМакета, НазначениеШаблона),
				ДополнительныеПараметры);
		КонецЕсли;
	КонецЕсли;
	
	// Конец ЭлектронноеВзаимодействие.ИнтеграцияСЯндексКассой
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// см. ШаблоныСообщенийПереопределяемый.ПриФормированииСообщения()
//
Процедура ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона) Экспорт
	
	//++ Локализация
	// ЭлектронноеВзаимодействие.ИнтеграцияСЯндексКассой
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ИнтеграцияСЯндексКассой") Тогда 
		ОбщийМодульИнтеграцияСЯндексКассой = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияСЯндексКассой");
		Если Не ОбщийМодульИнтеграцияСЯндексКассой = Неопределено Тогда 
			ОбщийМодульИнтеграцияСЯндексКассой.ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона);
		КонецЕсли;
	КонецЕсли;
	
	// Конец ЭлектронноеВзаимодействие.ИнтеграцияСЯндексКассой
	
	МассивНазначенийШаблона = Новый Массив;
	Для Каждого ЗначениеПеречисления ИЗ Перечисления.ТипыСобытийОповещений.ИзменениеСостоянияЗаказа.Метаданные().ЗначенияПеречисления Цикл
		Если НЕ Перечисления.ТипыСобытийОповещений.ДанныеДляОбработкиОчередиОповещений(Перечисления.ТипыСобытийОповещений[ЗначениеПеречисления.Имя]).ДоступноДляИспользования Тогда
			Продолжить;
		КонецЕсли;
		МассивНазначенийШаблона.Добавить(ЗначениеПеречисления.Имя);
	КонецЦикла;
	
	//-- Локализация
	
КонецПроцедуры

// Заполняет список получателей почты при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получается письма.
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электронной почты.
//  НазначениеШаблона - Строка - идентификатор назначения шаблона
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект являющийся источником данных
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, НазначениеШаблона, ПредметСообщения) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
