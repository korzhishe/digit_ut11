﻿
&НаКлиенте
Процедура Печать(Команда)
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ТранспортнаяЭтикетка");
	
	АдресКоллекцияПечатныхФорм = ПечатьНаСервере(КоллекцияПечатныхФорм);
	
	//КоллекцияПечатныхФорм = ПолучитьИзВременногоХранилища(АдресКоллекцияПечатныхФорм);
	
	ОбластиОбъектов = Новый СписокЗначений;
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов);
	
	Закрыть();
КонецПроцедуры

&НаСервере
Функция ПечатьНаСервере(КоллекцияПечатныхФорм, Новая = Ложь)
	Об = РеквизитФормыВЗначение("Объект");
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(Параметры.СсылкаНаОбъект);
	
	ОбъектыПечати = Новый СписокЗначений;
	//ОбъектыПечати.Добавить(Параметры.СсылкаНаОбъект, Параметры.СсылкаНаОбъект);
	//КоллекцияПечатныхФорм = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм("ТранспортнаяЭтикетка");
		
	Об.Печать(МассивОбъектов,КоллекцияПечатныхФорм, ОбъектыПечати, Новый Структура("КоличествоКоробок,НоваяФорма",КоличествоКоробок,Новая));
	
	Возврат ПоместитьВоВременноеХранилище(КоллекцияПечатныхФорм, УникальныйИдентификатор);
	
КонецФункции	


&НаСервере
Функция СоздатьКоллекциюКомандПечати()
	
	Результат = Новый ТаблицаЗначений;
	
	// описание
	Результат.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	
	//////////
	// Опции (необязательные параметры).
	
	// менеджер печати
	Результат.Колонки.Добавить("МенеджерПечати", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ТипыОбъектовПечати", Новый ОписаниеТипов("Массив"));
	
	// Альтернативный обработчик команды.
	Результат.Колонки.Добавить("Обработчик", Новый ОписаниеТипов("Строка"));
	
	// представление
	Результат.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Картинка"));
	// Имена форм для размещения команд, разделитель - запятая.
	Результат.Колонки.Добавить("СписокФорм", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("МестоРазмещения", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ЗаголовокФормы", Новый ОписаниеТипов("Строка"));
	// Имена функциональных опций, влияющих на видимость команды, разделитель - запятая.
	Результат.Колонки.Добавить("ФункциональныеОпции", Новый ОписаниеТипов("Строка"));
	
	// проверка проведения
	Результат.Колонки.Добавить("ПроверкаПроведенияПередПечатью", Новый ОписаниеТипов("Булево"));
	
	// вывод
	Результат.Колонки.Добавить("СразуНаПринтер", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("ФорматСохранения"); // ТипФайлаТабличногоДокумента
	
	// настройки комплектов
	Результат.Колонки.Добавить("ПереопределитьПользовательскиеНастройкиКоличества", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("ДополнитьКомплектВнешнимиПечатнымиФормами", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("ФиксированныйКомплект", Новый ОписаниеТипов("Булево")); // запрет изменения комплекта
	
	// дополнительные параметры
	Результат.Колонки.Добавить("ДополнительныеПараметры", Новый ОписаниеТипов("Структура"));
	
	// Специальный режим выполнения команды
	// по умолчанию выполняется запись модифицированного объекта перед выполнением команды.
	Результат.Колонки.Добавить("НеВыполнятьЗаписьВФорме", Новый ОписаниеТипов("Булево"));
	
	// Для использования макетов офисных документов в веб-клиенте.
	Результат.Колонки.Добавить("ТребуетсяРасширениеРаботыСФайлами", Новый ОписаниеТипов("Булево"));
	
	// Для служебного использования.
	Результат.Колонки.Добавить("СкрытаФункциональнымиОпциями", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("УникальныйИдентификатор", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Отключена", Новый ОписаниеТипов("Булево"));
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПечатьНовый(Команда)
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("ТранспортнаяЭтикетка");
	
	АдресКоллекцияПечатныхФорм = ПечатьНаСервере(КоллекцияПечатныхФорм, Истина);
	
	//КоллекцияПечатныхФорм = ПолучитьИзВременногоХранилища(АдресКоллекцияПечатныхФорм);
	
	ОбластиОбъектов = Новый СписокЗначений;
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, ОбластиОбъектов);
	
	Закрыть();
КонецПроцедуры
