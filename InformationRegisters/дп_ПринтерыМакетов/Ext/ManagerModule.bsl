﻿Функция ПолучитьПринтерМакета(ИмяМакета, Пользователь) Экспорт
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Результат = Новый Структура("ИмяПринтера,ПолеСверху,ПолеСнизу,ПолеСправа,ПолеСлева,ВысотаСтраницы,ШиринаСтраницы");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дп_ПринтерыМакетов.Принтер КАК ИмяПринтера,
		|	дп_ПринтерыМакетов.ПолеСверху КАК ПолеСверху,
		|	дп_ПринтерыМакетов.ПолеСнизу КАК ПолеСнизу,
		|	дп_ПринтерыМакетов.ПолеСправа КАК ПолеСправа,
		|	дп_ПринтерыМакетов.ПолеСлева КАК ПолеСлева,
		|	дп_ПринтерыМакетов.ВысотаСтраницы КАК ВысотаСтраницы,
		|	дп_ПринтерыМакетов.ШиринаСтраницы КАК ШиринаСтраницы
		|ИЗ
		|	РегистрСведений.дп_ПринтерыМакетов КАК дп_ПринтерыМакетов
		|ГДЕ
		|	дп_ПринтерыМакетов.Пользователь = &Пользователь
		|	И дп_ПринтерыМакетов.Макет = &Макет";
	
	Запрос.УстановитьПараметр("Макет", ИмяМакета);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, ВыборкаДетальныеЗаписи);
		Возврат Результат;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

КонецФункции	

//Кожемякин А.Г. agkozhemyakin@gmail.com {
//31.08.2016 13:24:54
Функция ДополнитьКоллекцияПечатныхФормПринтеры(АдресКоллекцияПечатныхФорм, Пользователь) Экспорт
	КоллекцияПечатныхФорм  = ПолучитьИзВременногоХранилища(АдресКоллекцияПечатныхФорм);
	МассивМакетов = КоллекцияПечатныхФорм.ВыгрузитьКолонку("Представление");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	дп_ПринтерыМакетов.Принтер как Принтер,
		|	дп_ПринтерыМакетов.Макет как Макет
		|ИЗ
		|	РегистрСведений.дп_ПринтерыМакетов КАК дп_ПринтерыМакетов
		|ГДЕ
		|	дп_ПринтерыМакетов.Пользователь = &Пользователь
		|	И дп_ПринтерыМакетов.Макет В (&Макет)";
	
	Запрос.УстановитьПараметр("Макет", МассивМакетов);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий()  Цикл
		НайденнаяСтрока = КоллекцияПечатныхФорм.Найти(ВыборкаДетальныеЗаписи.Макет, "Представление");
		Если Не НайденнаяСтрока = Неопределено Тогда
			НайденнаяСтрока.Принтер = ВыборкаДетальныеЗаписи.Принтер;
   		КонецЕсли;
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(КоллекцияПечатныхФорм, АдресКоллекцияПечатныхФорм);
	Возврат АдресКоллекцияПечатныхФорм;
КонецФункции

Процедура УстановитьПринтерМакета(Макет, Принтер, Пользователь) Экспорт

	МенеджерЗаписи = РегистрыСведений.дп_ПринтерыМакетов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Макет = Макет;
	МенеджерЗаписи.Пользователь = Пользователь;
	МенеджерЗаписи.Принтер = Принтер;
	МенеджерЗаписи.Записать();

КонецПроцедуры

//}Кожемякин А.Г.