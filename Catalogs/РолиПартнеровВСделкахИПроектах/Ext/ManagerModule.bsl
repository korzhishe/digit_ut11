﻿

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)

	Если Параметры.Свойство("Клиент") Тогда

		СтандартнаяОбработка = Ложь;
		Если Параметры.Клиент = Параметры.Участник Тогда
			ДанныеВыбора = Новый СписокЗначений;
			Роль = Справочники.РолиПартнеровВСделкахИПроектах.Клиент;
			ДанныеВыбора.Добавить(Роль, Роль.Наименование);
		Иначе
			Запрос = Новый Запрос(
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	РолиПартнеровВСделкахИПроектах.Ссылка,
				|	РолиПартнеровВСделкахИПроектах.Наименование
				|ИЗ
				|	Справочник.РолиПартнеровВСделкахИПроектах КАК РолиПартнеровВСделкахИПроектах
				|ГДЕ
				|	РолиПартнеровВСделкахИПроектах.Ссылка <> ЗНАЧЕНИЕ(Справочник.РолиПартнеровВСделкахИПроектах.Клиент)");
			РезультатЗапроса = Запрос.Выполнить();
			Если Не РезультатЗапроса.Пустой() Тогда
				ДанныеВыбора = Новый СписокЗначений;
				Выборка = РезультатЗапроса.Выбрать();
				Пока Выборка.Следующий() Цикл
					ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Наименование);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
