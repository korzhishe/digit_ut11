﻿#Область СлужебныйПрограммныйИнтерфейс

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПОЛУЧЕНИЯ СВЕДЕНИЙ ОБ ОРГАНИЗАЦИИ


Функция ЭтоЮрЛицо(Организация) Экспорт
	
	ЮридическоеФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо");
	
	Возврат (ЮридическоеФизическоеЛицо <> Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);

КонецФункции 


// Возвращает список организаций, которые являются обособленными подразделениями
// того же юр.лица, к которому относится переданная организация.
//
Функция ПолучитьСписокОбособленныхПодразделений(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ПОМЕСТИТЬ ТаблицаГоловнойОрганизации
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка,
	|	Организации.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаГоловнойОрганизации КАК ТаблицаГоловнойОрганизации
	|		ПО Организации.ГоловнаяОрганизация = ТаблицаГоловнойОрганизации.ГоловнаяОрганизация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	СписокОП = Новый СписокЗначений;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокОП.Добавить(Выборка.Ссылка, Выборка.Наименование);
	КонецЦикла;
	
	Возврат СписокОП;
	
КонецФункции


// Возвращает перечень (фиксированный массив) всех структурных частей переданной головной организации, имеющих отдельный баланс.
// В перечень входит головная организация и все ее обособленные подразделения на выделенном балансе.
//
Функция ВсяОрганизация(Организация) Экспорт
	
	Возврат Новый ФиксированныйМассив(БухгалтерскийУчетПереопределяемый.ВсяОрганизация(Организация));
	
КонецФункции

// Функция возвращает фиксированный массив организаций, к данным которых
// у текущего пользователя разрешено требуемое право доступа по RLS.
//
// Порядок использования функции можно использовать, если требуется выполнять запросы 
// в привилегированном режиме, но чтобы при этом учитывались настройки доступа по RLS:
// 	1. с помощью текущей функции определяется список доступных организаций.
//	2. в текстах запросов к самим данных (регистрам, документам) 
//		устанавливаются отборы по этим организациям
//	3. перед выполнением запроса к данным включается привилегированный режим.
//
// Параметры:
//	ПравоНаИзменение - Булево
//		- Истина - если после выполнения запроса данные бухгалтерии предполагается менять
//					и нужно проверить, что у пользователя есть право на изменение;
//		- Ложь - если данные бухгалтерии только отображаются пользователю на чтение,
//					и нужно проверить что у него есть соответствующее право.
// 
Функция ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ПравоНаИзменение) Экспорт
	
	Запрос = Новый Запрос;
	
	Если Пользователи.ЭтоПолноправныйПользователь()
		ИЛИ НЕ УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() Тогда
		
		// Ограничений по RLS нет, возвращаем все организации из справочника
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации";
		
	Иначе
	
		// Запрос взят из шаблона #ПоЗначениям роли ДобавлениеИзменениеДанныхБухгалтерии
		// с теми параметрами, с которыми он применяется для регистра бухгалтерии Хозрасчетный.
		Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
		Запрос.УстановитьПараметр("Изменение", ПравоНаИзменение);
		
		Запрос.УстановитьПараметр("ИмяРегистра", "РегистрНакопления.НДСЗаписиКнигиПродаж");
		
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	ИСТИНА В
		|			(ВЫБРАТЬ ПЕРВЫЕ 1
		|				ИСТИНА
		|			ИЗ
		|				Справочник.ИдентификаторыОбъектовМетаданных КАК СвойстваТекущейТаблицы
		|					ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
		|					ПО
		|						СвойстваТекущейТаблицы.ПолноеИмя = &ИмяРегистра
		|							И ИСТИНА В
		|								(ВЫБРАТЬ ПЕРВЫЕ 1
		|									ИСТИНА
		|								ИЗ
		|									РегистрСведений.ТаблицыГруппДоступа КАК ТаблицыГруппДоступа
		|								ГДЕ
		|									ТаблицыГруппДоступа.Таблица = СвойстваТекущейТаблицы.Ссылка
		|									И ТаблицыГруппДоступа.ГруппаДоступа = ГруппыДоступа.Ссылка
		|									И ТаблицыГруппДоступа.Изменение = &Изменение)
		|							И ГруппыДоступа.Ссылка В
		|								(ВЫБРАТЬ
		|									ГруппыДоступаПользователи.Ссылка КАК ГруппаДоступа
		|								ИЗ
		|									Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|										ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|										ПО
		|											СоставыГруппПользователей.Пользователь = &Пользователь
		|												И СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь)
		|			ГДЕ
		|				ВЫБОР
		|					КОГДА ИСТИНА В
		|							(ВЫБРАТЬ ПЕРВЫЕ 1
		|								ИСТИНА
		|							ИЗ
		|								РегистрСведений.ЗначенияГруппДоступа КАК Значения
		|									ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГруппыЗначенийДоступа КАК ГруппыЗначений
		|									ПО
		|										Значения.ГруппаДоступа = ГруппыДоступа.Ссылка
		|											И Значения.ЗначениеДоступа = Организации.Ссылка
		|											И ГруппыЗначений.ЗначениеДоступа = ГруппыЗначений.ГруппаЗначенийДоступа)
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ ЛОЖЬ
		|				КОНЕЦ = ВЫБОР
		|					КОГДА ИСТИНА В
		|							(ВЫБРАТЬ ПЕРВЫЕ 1
		|								ИСТИНА
		|							ИЗ
		|								РегистрСведений.ЗначенияГруппДоступаПоУмолчанию КАК ЗначенияПоУмолчанию
		|							ГДЕ
		|								ЗначенияПоУмолчанию.ГруппаДоступа = ГруппыДоступа.Ссылка
		|								И ТИПЗНАЧЕНИЯ(ЗначенияПоУмолчанию.ТипЗначенийДоступа) = ТИПЗНАЧЕНИЯ(Организации.Ссылка)
		|								И ЗначенияПоУмолчанию.ВсеРазрешены = ЛОЖЬ)
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ ЛОЖЬ
		|				КОНЕЦ)";
		
		Запрос.Текст = ?(ПравоНаИзменение,
			ТекстЗапроса,
			СтрЗаменить(ТекстЗапроса, "И ТаблицыГруппДоступа.Изменение = &Изменение", ""));
		
	КонецЕсли;
	
	// Доступ к настройкам RLS выполняется в привилегированном режиме.
	УстановитьПривилегированныйРежим(Истина);
	
	МассивОрганизаций = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Новый ФиксированныйМассив(МассивОрганизаций);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ПОЛУЧЕНИЯ НАСТРОЕК

// Возвращает валюту регламентированного учета
// Если переданная в качестве параметра валюта уже заполнена - возвращает ее.
// Если валюта не передана в качестве параметра или передан пустой,
// валюту рег. учета. Если валюта рег. учета не заполнена - возвращает пустую ссылку на валюту.
//
// Параметры:
// Валюта - СправочникСсылка.Валюты - Валюта, которую нужно заполнить.
//
// Возвращаемое значение:
// СправочникСсылка.Валюты.
//
Функция ПолучитьВалютуРегламентированногоУчета(Знач Валюта = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Возврат Константы.ВалютаРегламентированногоУчета.Получить();
	Иначе
		Возврат Валюта;
	КонецЕсли;
	
КонецФункции 


#КонецОбласти
