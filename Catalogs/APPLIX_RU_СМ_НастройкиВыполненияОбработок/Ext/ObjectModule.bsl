﻿

// Управляет регламентным заданием узла обмена.  Расписание задания задается в форме узла обмена.
// Предусматривает работу через подсистему "СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий".
//
// Параметры:
//  РасписаниеРегламентногоЗадания - РасписаниеРегламентногоЗадания - расписание регламентного задания.
//
Процедура ВключитьОтключитьРегламентноеЗадание(РасписаниеРегламентногоЗадания) Экспорт
	
	
	Задание = СуществующееЗадание();
	Если Использование Тогда
		
		ПараметрыЗадания = СвойстваЗадания(РасписаниеРегламентногоЗадания);
		
		Если Задание = Неопределено Тогда
			
			ПараметрыЗадания.Вставить("Метаданные", Метаданные.РегламентныеЗадания.APPLIX_RU_СМ_ВыполнениеОбработок);
			ПараметрыЗадания.Вставить("Ключ", Строка(Новый УникальныйИдентификатор));
			ПараметрыЗадания.Вставить("Использование", Истина);
			
			ИдентификаторЗадания = НовоеЗадание(ПараметрыЗадания);
			ИдентификаторРегламентногоЗадания = ИдентификаторЗадания;
		Иначе
			УстановитьПараметрыЗадания(Задание, ПараметрыЗадания);
		КонецЕсли;
		
	Иначе
		
		Если Задание <> Неопределено Тогда
			УдалитьЗадание(Задание);
		КонецЕсли;
		ИдентификаторРегламентногоЗадания = Неопределено;
		
	КонецЕсли;

КонецПроцедуры

// Получение свойств регламентного задания.
//
// Параметры:
//  РасписаниеЗадания - РасписаниеРегламентногоЗадания - расписание регламентного задания.
// 
// Возвращаемое значение:
//  Структура - свойства существующего регламентного задания.
//
Функция СвойстваЗадания(РасписаниеЗадания = Неопределено) Экспорт
	
	//Если Не ЗначениеЗаполнено(Код) Тогда
	//	УстановитьНовыйКод();
	//КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ключ) Тогда
		Ключ = Строка(Новый УникальныйИдентификатор)
	КонецЕсли;
	
	Параметры = Новый Массив;
	Параметры.Добавить(Ключ);//Код);
	
	ПараметрыЗадания = Новый Структура;
	Если Не РасписаниеЗадания = Неопределено Тогда
		ПараметрыЗадания.Вставить("Расписание", РасписаниеЗадания);
	Иначе
		// Создадим расписание по умолчанию - каждый день, один раз в день
		Расписание = Новый("РасписаниеРегламентногоЗадания");
		Расписание.ПериодПовтораДней = 1;
		ПараметрыЗадания.Вставить("Расписание", Расписание);
	КонецЕсли;
	ПараметрыЗадания.Вставить("Параметры", Параметры);
	ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.APPLIX_RU_СМ_ВыполнениеОбработок.ИмяМетода);
	ПараметрыЗадания.Вставить("Наименование", НаименованиеРегламентногоЗадания());

	Возврат ПараметрыЗадания;
	
КонецФункции

// Функция - Существующее задание
// 
// Возвращаемое значение:
//   РегламентноеЗадание - регламентное задание - регламентное задание, соответствующее узлу плана обмена.
//							Если задания нет - возвращается "Неопределено".
//
Функция СуществующееЗадание() Экспорт
	
	Отбор = Новый Структура;
	
	//Если ОбщегоНазначения.РазделениеВключено() Тогда
	//	Отбор.Вставить("Ключ", ИдентификаторРегламентногоЗадания);
	//Иначе
		Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
			Отбор.Вставить("Идентификатор", Новый УникальныйИдентификатор(ИдентификаторРегламентногоЗадания));
		КонецЕсли;
		Отбор.Вставить("Наименование", НаименованиеРегламентногоЗадания());
		
	//КонецЕсли;

	Отбор.Вставить("Метаданные", Метаданные.РегламентныеЗадания.APPLIX_RU_СМ_ВыполнениеОбработок);
	
	Найденные = APPLIX_RU_СМ_ОбщийМодульСервер.APPLIX_RU_СМ_РегламентноеЗаданиеНайти(Отбор);
	Задание = ?(Найденные.Количество() = 0, Неопределено, Найденные[0]);
	
	Возврат Задание;
	
КонецФункции


// Удаляет регламентное задание, соответствующее объекту.
//
// Параметры:
// нет
// 
// Возвращаемое значение:
// нет
//
Процедура УдалитьЗадание(Задание)
	
	APPLIX_RU_СМ_ОбщийМодульСервер.APPLIX_RU_СМ_РегламентноеЗаданиеУдалить(Задание);
	
КонецПроцедуры

Функция НовоеЗадание(ПараметрыЗадания)
	
	РегламентноеЗадание = APPLIX_RU_СМ_ОбщийМодульСервер.APPLIX_RU_СМ_РегламентноеЗаданиеДобавить(ПараметрыЗадания);
	
	Если ТипЗнч(РегламентноеЗадание) = Тип("СтрокаТаблицыЗначений") Тогда
		Идентификатор = РегламентноеЗадание.Ключ;
	Иначе
		Идентификатор = Строка(РегламентноеЗадание.УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Идентификатор;
	
КонецФункции

Процедура УстановитьПараметрыЗадания(Задание, СвойстваЗадания)
	
	Если Задание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	APPLIX_RU_СМ_ОбщийМодульСервер.APPLIX_RU_СМ_РегламентноеЗаданиеИзменить(Задание, СвойстваЗадания);
	
	УстановитьПривилегированныйРежим(Истина);
	
КонецПроцедуры

Функция НаименованиеРегламентногоЗадания()
	
	НаименованиеЗадания = "[APPLIX.RU] СМ: " + Наименование;// + Код;
	
	Возврат НаименованиеЗадания;
	
КонецФункции



Процедура ПередЗаписью(Отказ)
	ЭтоФайловаяИБ = APPLIX_RU_СМ_ОбщийМодульСервер.СМ_ЭтаИнформационнаяБазаФайловая();
	
	// Для обычного режима
	Попытка
		Если ЭтоФайловаяИБ Тогда
			
			ПользовательДляВыполненияРеглЗаданий = Константы.ПользовательДляВыполненияРегламентныхЗаданийВФайловомВарианте.Получить();
			
			Если Использование И НЕ ЗначениеЗаполнено(ПользовательДляВыполненияРеглЗаданий) Тогда
				
				Сообщить("Не установлена константа ""Пользователь, для выполнения регламентных заданий в файловом режиме"". Запуск выполняться не будет!", СтатусСообщения.ОченьВажное);
				
			КонецЕсли;
			
		КонецЕсли;
	Исключение
		т = ОписаниеОшибки();
	КонецПопытки;
	
	// для помеченой на удаление настройки обмен автоматически не производится
	Если (ПометкаУдаления И Использование) Тогда
		
		Сообщить("Настройка помечена на удаление. Автоматический запуск по ней производится не будет!", СтатусСообщения.Важное);

	Иначе
		Если (Не ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания)) или (Не Использование) Тогда
			
			УстановитьПривилегированныйРежим(Истина);
			
			Расписание = Неопределено;
			ДополнительныеСвойства.Свойство("Расписание", Расписание);
			
			ВключитьОтключитьРегламентноеЗадание(Расписание);
			
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

