﻿
&НаКлиенте
Процедура ПутьИсходникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПутьЗакончитьВыборИсходник",ЭтотОбъект);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьРезультатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПутьЗакончитьВыборРезультат",ЭтотОбъект);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры


&НаКлиенте
Процедура ПутьЗакончитьВыборИсходник(РезультатВыбора,ДополнительныеПараметры) Экспорт 	
	
	Если РезультатВыбора <> Неопределено Тогда
		Объект.ПутьИсходник = РезультатВыбора[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьЗакончитьВыборРезультат(РезультатВыбора,ДополнительныеПараметры) Экспорт 	
	
	Если РезультатВыбора <> Неопределено Тогда
		Объект.ПутьРезультат = РезультатВыбора[0];
	КонецЕсли;
	
КонецПроцедуры





&НаКлиенте
Функция глРазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель="|") Экспорт
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Пока 1 = 1 Цикл
			Стр = СокрЛП(Стр);
			Поз = Найти(Стр,Разделитель);
			
			Если Поз = 0 Тогда
				СтрокаВМассив = СокрЛП(Стр);
				
				МассивСтрок.Добавить(СтрокаВМассив);
				Возврат МассивСтрок;
			КонецЕсли;
			
			СтрокаВМассив = СокрЛП(Лев(Стр,Поз-1));
			
			МассивСтрок.Добавить(СтрокаВМассив);
			Стр = СокрЛ(Сред(Стр,Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1 = 1 Цикл
			Стр = СокрЛП(Стр);
			Поз = Найти(Стр,Разделитель);
			
			Если Поз = 0 Тогда
				СтрокаВМассив = СокрЛП(Стр);
				
				МассивСтрок.Добавить(СтрокаВМассив);
				Возврат МассивСтрок;
			КонецЕсли;
			
			СтрокаВМассив = СокрЛП(Лев(Стр,Поз-1));
			
			МассивСтрок.Добавить(СтрокаВМассив);
			Стр = Сред(Стр,Поз+ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции 

&НаКлиенте
Процедура Разрезать(Команда)
		
	Файл = Новый Файл(Объект.ПутьИсходник);
	ИтераторЦикла = 0;
	ИтераторНомераФайла = 1;
	
	ФайловыйПотокЧтение = Новый ФайловыйПоток(Объект.ПутьИсходник,РежимОткрытияФайла.Открыть);
	ЧтениеТекста = Новый ЧтениеТекста(ФайловыйПотокЧтение,КодировкаТекста.ANSI);
	
	ИмяФайлаЗаписи = Объект.ПутьРезультат + "\" + Файл.ИмяБезРасширения + "_мегапрайсчасть_" +  Формат(ИтераторНомераФайла,"ЧЦ=3; ЧВН=; ЧГ=0") + Файл.Расширение;
	ФайловыйПотокЗапись = Новый ФайловыйПоток(ИмяФайлаЗаписи,РежимОткрытияФайла.ОткрытьИлиСоздать);
	ЗаписьТекста = Новый ЗаписьТекста(ФайловыйПотокЗапись,КодировкаТекста.ANSI);
	
	НачалоЗагрузки = ТекущаяДата();

	ВыборкаСтрока = ЧтениеТекста.ПрочитатьСтроку();	
	Пока ВыборкаСтрока <> Неопределено Цикл// строки читаются до символа перевода строки
		
		Если Объект.ФайлИспользоватьФильтр Тогда     
			СтрокаУсловие = 0;
			
			Для Каждого ВыборкаФильтр Из Объект.ФильтрацияДанныхФайла Цикл
				Если СтрокаУсловие > 0 Тогда
					Продолжить;
				КонецЕсли;
				
				Если ВыборкаФильтр.НомерЗначения > 0 ИЛИ ВыборкаФильтр.ПроцентНаценки > 0 Тогда
					
					ВыборкаМассивКолонок = СтрРазделить(ВыборкаСтрока,";");
					Если ВыборкаФильтр.НомерЗначения > 0 Тогда
						ПолучитьЗначениеПоНомеру = ВыборкаМассивКолонок.Получить(ВыборкаФильтр.НомерЗначения-1);	
						СтрокаУсловие = Найти(ПолучитьЗначениеПоНомеру,ВыборкаФильтр.ЗначениеФильтра);
					Иначе
						СтрокаУсловие = Найти(ВыборкаСтрока,ВыборкаФильтр.ЗначениеФильтра);
					КонецЕсли;
					
					Попытка
						Если СтрокаУсловие > 0 И ВыборкаФильтр.ПроцентНаценки > 0 Тогда 
							ПолучитьЗначениеЦены = ВыборкаМассивКолонок.Получить(Объект.КолонкаСЦеной-1);
							ПолучитьЗначенииеЦены = Число(ПолучитьЗначениеЦены);
							ПолучитьЗначениеЦены = ПолучитьЗначениеЦены*(1 + ВыборкаФильтр.ПроцентНаценки/100);
							ВыборкаМассивКолонок.Установить(Объект.КолонкаСЦеной-1,ПолучитьЗначениеЦены);
							ВыборкаСтрока = СтрСоединить(ВыборкаМассивКолонок,";");
						КонецЕсли;
					Исключение
						
					КонецПопытки;
				Иначе
					СтрокаУсловие = Найти(ВыборкаСтрока,ВыборкаФильтр.ЗначениеФильтра);
				КонецЕсли;
			КонецЦикла;
			
			Если Объект.ФайлИсключитьДанныеФильтра Тогда
				Если НЕ СтрокаУсловие = 0 Тогда
					ВыборкаСтрока = ЧтениеТекста.ПрочитатьСтроку();
					Продолжить;
				КонецЕсли;
			Иначе
				Если СтрокаУсловие = 0 Тогда
					ВыборкаСтрока = ЧтениеТекста.ПрочитатьСтроку();
					Продолжить;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		ЗаписьТекста.ЗаписатьСтроку(ВыборкаСтрока);

		Если Объект.КоличествоСтрок > 0 Тогда
			Если ИтераторЦикла >= Объект.КоличествоСтрок Тогда
				ИтераторНомераФайла = ИтераторНомераФайла + 1;
				
				ЗаписьТекста.Закрыть();
				ФайловыйПотокЗапись.Закрыть();
				
				ИмяФайлаЗаписи = Объект.ПутьРезультат + "\" + Файл.ИмяБезРасширения + "_мегапрайсчасть_" +  Формат(ИтераторНомераФайла,"ЧЦ=3; ЧВН=; ЧГ=0") + Файл.Расширение; 
				ФайловыйПотокЗапись = Новый ФайловыйПоток(ИмяФайлаЗаписи,РежимОткрытияФайла.ОткрытьИлиСоздать);
				ЗаписьТекста = Новый ЗаписьТекста(ФайловыйПотокЗапись,КодировкаТекста.ANSI);
				
				ИтераторЦикла = 0;
			КонецЕсли;
		КонецЕсли;
		
		ВыборкаСтрока = ЧтениеТекста.ПрочитатьСтроку();
		ИтераторЦикла = ИтераторЦикла + 1; 		
		
	КонецЦикла;
	
	КонецЗагрузки = ТекущаяДата();
	ВремяВыполнения = КонецЗагрузки - НачалоЗагрузки;

	Сообщить("Разделение файла выполнено - (скорость "+ВремяВыполнения+")");
	
	ЧтениеТекста.Закрыть();
	ФайловыйПотокЧтение.Закрыть();
	
	ЗаписьТекста.Закрыть();
	ФайловыйПотокЗапись.Закрыть();
	
КонецПроцедуры
