﻿
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт

	Возврат Константы[ИмяКонстанты].Получить();
	
КонецФункции

Процедура УстановитьЗначениеКонстанты(ИмяКонстанты, Значение) Экспорт

	Константы[ИмяКонстанты].Установить(Значение);
	
КонецПроцедуры


Функция Реквизит(ОбъектДанных, ИмяРеквизита) Экспорт
	
	Возврат ОбъектДанных[ИмяРеквизита];
	
КонецФункции

Функция ДанныеПереводимВСтроку(Данные) Экспорт
	
	ДанныеСтрокаХранилище = Новый ХранилищеЗначения(Данные, Новый СжатиеДанных(9)); 
	
	XMLДанныеСтрока = XMLСтрока(ДанныеСтрокаХранилище);
	Возврат XMLДанныеСтрока;
	
КонецФункции

Функция ИзСтрокиВДанные(СтрокаДанных) Экспорт
	
	ХранилищеСтрока = XMLЗначение(Тип("ХранилищеЗначения"), СтрокаДанных);
	Данные 			= ХранилищеСтрока.Получить();
	Возврат Данные;
	
КонецФункции