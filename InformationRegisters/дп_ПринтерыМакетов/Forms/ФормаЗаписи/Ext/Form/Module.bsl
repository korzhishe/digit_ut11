﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Запись.Пользователь) Тогда
	
		Запись.Пользователь = Пользователи.ТекущийПользователь();
	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.ШаблонЭтикетки) Тогда
		Если Запись.ШаблонЭтикетки.Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляТоваров Тогда
			Запись.Макет = "Этикетка: "+Запись.ШаблонЭтикетки.ПолноеНаименование();	
		Иначе
			Запись.Макет = Запись.ШаблонЭтикетки.ПолноеНаименование();
		КонецЕсли;
		
		Элементы.ШаблонЭтикетки.Доступность = Ложь;
		Элементы.Макет.Доступность = Ложь;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура МакетНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПолноеСтроковоеИмяТипа = "";
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТипОбъектаСтрокой", ПолноеСтроковоеИмяТипа);
	
	ФильтрПоСсылочнымМетаданным = Новый СписокЗначений;
	ФильтрПоСсылочнымМетаданным.Добавить("Документы");
	СтруктураПараметров.Вставить("КоллекцииВыбираемыхОбъектовМетаданных", ФильтрПоСсылочнымМетаданным);
	
	ФормаВыбораОбъектаМетаДанных = ПолучитьФорму("РегистрСведений.дп_ПринтерыМакетов.Форма.ВыборОбъектаМетаданных",
	СтруктураПараметров,
	ЭтаФорма);
	
	ФормаВыбораОбъектаМетаДанных.ЗакрыватьПриЗакрытииВладельца = Истина;
	ФормаВыбораОбъектаМетаДанных.ЗакрыватьПриВыборе = Истина;
	
	//Если ИспользоватьРежимМодальности() Тогда
		// Стандартно в модальном режиме (8.2/8.3).
		ВыбранныйОбъектМетаДанных = ФормаВыбораОбъектаМетаДанных.ОткрытьМодально();
		//ВызватьВыборОбъектаБД(ВыбранныйОбъектМетаДанных, Элемент);
	//Иначе
	//	// Стандартно в немодальном режиме (8.3).
	//	Выполнить("ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения(""ВызватьВыборОбъектаБД"", ЭтотОбъект, Элемент)");
	//	Выполнить("ФормаВыбораОбъектаМетаДанных.ОписаниеОповещенияОЗакрытии = ОписаниеОповещенияОЗакрытии");
	//	ФормаВыбораОбъектаМетаДанных.Открыть();
	//КонецЕсли;
	
	КоллекцияПечатныхФорм = ПолучитьКомплектПечатныхФорм(ВыбранныйОбъектМетаДанных);
	ДанныеВыбора = Новый СписокЗначений;	
	Для Каждого СтрокаПечатнаяФорма из КоллекцияПечатныхФорм Цикл
		 ДанныеВыбора.Добавить(СтрокаПечатнаяФорма.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКомплектПечатныхФорм(ВыбранныйОбъектМетаДанных)

	Возврат РегистрыСведений.НастройкиПечатиОбъектов.КомплектПечатныхФорм(
		ВыбранныйОбъектМетаДанных,
		Неопределено,
		0)

КонецФункции // ()

