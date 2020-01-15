﻿
#Область ПрограммныйИнтерфейс

// Формирует список шаблонов заданий очереди.
//
// см. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов()
//
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	//++ Локализация
	//ИнтеграцияС1СДокументооборот
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.ИнтеграцияС1СДокументооборотВыполнитьОбменДанными.Имя);
	//Конец ИнтеграцияС1СДокументооборот
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриПолученииСпискаШаблонов(ШаблоныЗаданий);
	// Конец ЭлектронноеВзаимодействие

	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.ПриПолученииСпискаШаблонов(ШаблоныЗаданий);
	// Конец ИнтернетПоддержкаПользователей
	
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.АрхивированиеЧековККМ.Имя);	
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.УдалениеОтложенныхЧековККМ.Имя);
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.УдалениеЧековККМ.Имя);
	
	//++ НЕ ГИСМ
	//++ НЕ ЕГАИС
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.ОтправкаПолучениеДанныхВЕТИС.Имя);
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.СверткаРегистраСоответствиеНоменклатурыВЕТИС.Имя);
	//-- НЕ ЕГАИС
	//-- НЕ ГИСМ
	
	//++ НЕ ГИСМ
	//++ НЕ ВЕТИС
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.СверткаРегистраСоответствиеНоменклатурыЕГАИС.Имя);
	//-- НЕ ВЕТИС
	//-- НЕ ГИСМ
	//-- Локализация
	
КонецПроцедуры

// Заполняет соответствие имен методов их псевдонимам для вызова из очереди заданий.
//
// см. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков()
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	//++ Локализация
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	// Конец ЭлектронноеВзаимодействие
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователей.ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам);
	// Конец ИнтернетПоддержкаПользователей	
	
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ЗакрытиеМесяца.ИмяМетода);
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ОбменССайтом.ИмяМетода);
	
	//++ НЕ ГИСМ
	//++ НЕ ЕГАИС
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.ОтправкаПолучениеДанныхВЕТИС.ИмяМетода);
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.СверткаРегистраСоответствиеНоменклатурыВЕТИС.ИмяМетода);
	//-- НЕ ЕГАИС
	//-- НЕ ГИСМ
	
	//++ НЕ ГИСМ
	//++ НЕ ВЕТИС
	СоответствиеИменПсевдонимам.Вставить(Метаданные.РегламентныеЗадания.СверткаРегистраСоответствиеНоменклатурыЕГАИС.ИмяМетода);
	//-- НЕ ВЕТИС
	//-- НЕ ГИСМ
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
