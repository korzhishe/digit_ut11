﻿
#Область ПрограммныйИнтерфейс

// Переопределение настроек присоединенных файлов.
//
// см. РаботаСФайламиПереопределяемый.ПриОпределенииНастроек()
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	//++ Локализация
	ЭлектронноеВзаимодействие.ПриОпределенииНастроек(Настройки);
	//-- Локализация
		
КонецПроцедуры

// Позволяет переопределить справочники хранения файлов по типам владельцев.
// 
// см. РаботаСФайламиПереопределяемый.ПриОпределенииСправочниковХраненияФайлов()
//
Процедура ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников) Экспорт
	
	//++ Локализация
	ЭлектронноеВзаимодействие.ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников);
	
	
	//-- НЕ ГИСМ
	
	//++ НЕ ВЕТИС
	//++ НЕ ЕГАИС
	Если ИнтеграцияГИСМ.ТипПодсистемыГИСМ(ТипВладелецФайла) Тогда
		ИменаСправочников.Вставить("ГИСМПрисоединенныеФайлы", Ложь);
	КонецЕсли;
	//-- НЕ ЕГАИС
	//-- НЕ ВЕТИС
	
	//++ НЕ ВЕТИС
	//++ НЕ ГИСМ
	ИнтеграцияЕГАИС.ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников);
	//-- НЕ ГИСМ
	//-- НЕ ВЕТИС
	
	//++ НЕ ГИСМ
	//++ НЕ ЕГАИС
	ИнтеграцияВЕТИС.ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников);
	//-- НЕ ЕГАИС
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
