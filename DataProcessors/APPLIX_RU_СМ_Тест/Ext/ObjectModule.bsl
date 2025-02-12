﻿
// Интерфейс для регистрации обработки.
// Вызывается при добавлении обработки в справочник "ВнешниеОбработки"
//
// Возвращаемое значение:
// Структура:
// Вид - строка - возможные значения:	"ДополнительнаяОбработка"
//										"ДополнительныйОтчет"
//										"ЗаполнениеОбъекта"
//										"Отчет"
//										"ПечатнаяФорма"
//										"СозданиеСвязанныхОбъектов"
//
// Назначение - массив строк имен объектов метаданных в формате:
//			<ИмяКлассаОбъектаМетаданного>.[ * | <ИмяОбъектаМетаданных>]
//			Например, "Документ.СчетЗаказ" или "Справочник.*"
//			Прим. параметр имеет смысл только для назначаемых обработок
//
// Наименование - строка - наименование обработки, которым будет заполнено
//						наименование справочника по умолчанию - краткая строка для
//						идентификации обработки администратором
//
// Версия - строка - версия обработки в формате <старший номер>.<младший номер>
//					используется при загрузке обработок в информационную базу
// БезопасныйРежим – Булево – Если истина, обработка будет запущена в безопасном режиме.
//							Более подбробная информация в справке.
//
// Информация - Строка- краткая информация по обработке, описание обработки
//
// ВерсияБСП - Строка - Минимальная версия БСП, на которую рассчитывает код
// дополнительной обработки. Номер версии БСП задается в формате «РР.ПП.ВВ.СС»
// (РР – старший номер редакции; ПП – младший номер ре-дакции; ВВ – номер версии; СС – номер сборки).
//
// Команды - ТаблицаЗначений - команды, поставляемые обработкой, одная строка таблицы соотвествует
//							одной команде
//				колонки: 
//				 - Представление - строка - представление команды конечному пользователю
//				 - Идентификатор - строка - идентефикатор команды. В случае печатных форм
//											перечисление через запятую списка макетов
//				 - Использование - строка - варианты запуска обработки:
//						"ОткрытиеФормы" - открыть форму обработки
//						"ВызовКлиентскогоМетода" - вызов клиентского экспортного метода из формы обработки
//						"ВызовСерверногоМетода" - вызов серверного экспортного метода из модуля объекта обработки
//				 - ПоказыватьОповещение – Булево – если Истина, требуется оказывать оповещение при начале
//								и при окончании запуска обработки. Прим. Имеет смысл только
//								при запуске обработки без открытия формы.
//				 - Модификатор – строка - для печатных форм MXL, которые требуется
//										отображать в форме ПечатьДокументов подсистемы Печать
//										требуется установить как "ПечатьMXL"
//
// Предусмотрено 2 команды:
// 1. "Открыть форму обработки" для загрузки прайс-листа в диалоговом режиме
// 2. "Загрузить прайс-лист и сохранить протокол в файл" для загрузки прайс-листа по регламентному заданию и
// сохранения протокола в файл.
//
Функция СведенияОВнешнейОбработке() Экспорт
	
	Попытка
		Объект_ЗаполнитьИнформациюОПрограмме();
	Исключение
	КонецПопытки;
	
	РегистрационныеДанные = Новый Структура;
	РегистрационныеДанные.Вставить("Наименование", Р_НазваниеПрограммы+" [APPLIX.RU]");
	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
	РегистрационныеДанные.Вставить("Версия", Р_Версия);
	//РегистрационныеДанные.Вставить("ВерсияБСП", "1.2.1.4");

	РегистрационныеДанные.Вставить("Вид", "ДополнительнаяОбработка");
	
	РегистрационныеДанные.Вставить("Информация", Р_ОписаниеПрограммы+" [APPLIX.RU]");
	
	Назначение = Новый Массив();
	
	РегистрационныеДанные.Вставить("Назначение", Назначение);
	
	ТЗКоманд = Новый ТаблицаЗначений;
	ТЗКоманд.Колонки.Добавить("Идентификатор");
	ТЗКоманд.Колонки.Добавить("Представление");
	ТЗКоманд.Колонки.Добавить("Модификатор");
	ТЗКоманд.Колонки.Добавить("ПоказыватьОповещение");
	ТЗКоманд.Колонки.Добавить("Использование");
	
	СтрокаКоманды = тзКоманд.Добавить();
	СтрокаКоманды.Идентификатор = "APPLIX_RU_"+Р_Обработка_Имя+"_ОткрытиеФормы";
	СтрокаКоманды.Представление = Р_НазваниеПрограммы+" [APPLIX.RU]";
	СтрокаКоманды.ПоказыватьОповещение = Истина;
	СтрокаКоманды.Использование = "ОткрытиеФормы";  //ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	
	РегистрационныеДанные.Вставить("Команды", ТЗКоманд);
	
	Возврат РегистрационныеДанные;
	
КонецФункции


// ОБЪЕКТ ////////////////////////////////////////////////////////////////////////////////////////

Процедура Объект_ЗаполнитьИнформациюОПрограмме()Экспорт
	Р_НазваниеПрограммы = "Служебный модуль APPLIX - тестовая обработка";
	Р_НазваниеПрограммыПолное = "Служебный модуль APPLIX - тестовая обработка";
	Р_ОписаниеПрограммы = "Служебный модуль APPLIX - тестовая обработка";
	Р_Версия = "1.0.0";
	Р_ИдентификаторПрограммы = "";
	Р_ДемоРежим = Истина;
	
	
	Р_Обработка_Имя = ПолучитьИмяЭтойОбработки();
	
КонецПроцедуры

Функция ПолучитьИмяЭтойОбработки() Экспорт
	Возврат Метаданные().Имя;
КонецФункции


//---------------------------------------------------------------------------------------------------------------------------------------
Функция APPLIX_RU_СМ_ВыполнитьОбработку(ПараметрыВыполнения=Неопределено) Экспорт 
	Рез = "";
	
	// Здесь ваш код выполнения
	
	Возврат Рез;
КонецФункции

