﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ПодсказкаНастройкиРМКТерминал.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОплатуПлатежнымиКартами");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПодключаемоеОборудование(Команда)
	
	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
	
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиРМК(Команда)
	
	ТекущиеНастройкиРМК = ТекущиеНастройкиРМК();
	Если ЗначениеЗаполнено(ТекущиеНастройкиРМК) Тогда
		ПоказатьЗначение(Неопределено, ТекущиеНастройкиРМК);
	Иначе
		ОткрытьФорму("Справочник.НастройкиРМК.ФормаОбъекта",,ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ТекущиеНастройкиРМК()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиРМК.Ссылка
	|ИЗ
	|	Справочник.НастройкиРМК КАК НастройкиРМК
	|ГДЕ
	|	НастройкиРМК.РабочееМесто = &РабочееМесто";

	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());

	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();

	Если Выборка.Следующий() Тогда
	
		Возврат Выборка.Ссылка;
		
	Иначе
		
		Возврат Справочники.НастройкиРМК.ПустаяСсылка();
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти