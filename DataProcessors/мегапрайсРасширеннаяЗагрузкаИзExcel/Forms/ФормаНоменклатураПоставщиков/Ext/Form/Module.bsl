﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьНоменклатуруПоставщиков = Константы.ИспользоватьНоменклатуруПоставщиков.Получить(); 
	
КонецПроцедуры


 &НаСервере
 Процедура ИспользоватьНоменклатуруПоставщиковПриИзмененииНаСервере()
	 Константы.ИспользоватьНоменклатуруПоставщиков.Установить(ИспользоватьНоменклатуруПоставщиков);
 КонецПроцедуры
 
 &НаКлиенте
 Процедура ИспользоватьНоменклатуруПоставщиковПриИзменении(Элемент)
	 
	 ИспользоватьНоменклатуруПоставщиковПриИзмененииНаСервере();
	 
	 ОбновитьИнтерфейс();
	 
 КонецПроцедуры
