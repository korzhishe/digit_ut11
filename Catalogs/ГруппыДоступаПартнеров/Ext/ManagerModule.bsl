﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Функция определяет, используются или нет группы доступа партнеров
//
//	Возвращаемое значение:
//		Булево - если ИСТИНА, значит группы доступа используются
//
Функция ИспользуютсяГруппыДоступа() Экспорт
	
	Возврат
		ПолучитьФункциональнуюОпцию("ОграничиватьДоступНаУровнеЗаписей")
		И ПолучитьФункциональнуюОпцию("ИспользоватьГруппыДоступаПартнеров");
	
КонецФункции

#КонецОбласти

#КонецЕсли