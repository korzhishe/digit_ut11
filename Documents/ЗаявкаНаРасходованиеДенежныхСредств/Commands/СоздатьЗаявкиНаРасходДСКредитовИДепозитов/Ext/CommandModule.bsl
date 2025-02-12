﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе",Истина);
	ПараметрыФормы.Вставить("ИдентификаторФормы",ПараметрыВыполненияКоманды.Источник.УникальныйИдентификатор);
	ПараметрыФормы.Вставить("Договоры",ПараметрКоманды);
		
	Если ПараметрыВыполненияКоманды.Источник.ВладелецФормы <> Неопределено 
		И ТипЗнч(ПараметрыВыполненияКоманды.Источник.ВладелецФормы) = Тип("УправляемаяФорма") Тогда
		ИмяВладельца = ПараметрыВыполненияКоманды.Источник.ВладелецФормы.ИмяФормы;
		Если ИмяВладельца = "Справочник.Партнеры.Форма.ФормаЭлемента"
			ИЛИ ИмяВладельца = "Справочник.Контрагенты.Форма.ФормаЭлемента" Тогда
			ПараметрыФормы.Вставить("Контрагенты",ПолучитьКонтрагентов(ПараметрКоманды));
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ДоговорыКредитовИДепозитов.Форма.ФормаСозданияЗаявок", 
					ПараметрыФормы, 
					ПараметрыВыполненияКоманды.Источник, 
					ПараметрыВыполненияКоманды.Уникальность, 
					ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

&НаСервере
Функция ПолучитьКонтрагентов(ДоговорыКредитов)
	
	Контрагенты = Новый Массив;	
	Для Каждого Договор Из ДоговорыКредитов Цикл
		Контрагент = Договор.Контрагент;
		Если Контрагенты.Найти(Контрагент) = Неопределено Тогда
			Контрагенты.Добавить(Контрагент);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Контрагенты;
	
КонецФункции
