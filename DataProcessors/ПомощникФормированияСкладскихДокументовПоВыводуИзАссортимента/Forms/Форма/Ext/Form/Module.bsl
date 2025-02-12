﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидДокументов="";
	
	Если Параметры.Свойство("ВидСоздаваемыхДокументов", ВидДокументов) Тогда
		Если ВидДокументов = "ЗаказНаПеремещение" Тогда
			ПредставлениеВидаСоздаваемыхДокументов = Нстр("ru='Заказ на перемещение товаров'");
			Элементы.ОсновныеСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаказыНаПеремещениеТоваров;
			Элементы.СтраницаЗаказыНаВнутреннееПотребление.Видимость = Ложь;
		ИначеЕсли ВидДокументов = "ЗаказНаВнутреннееПотребление" Тогда
			ПредставлениеВидаСоздаваемыхДокументов = Нстр("ru='Заказ на внутреннее потребление'");
			Элементы.ОсновныеСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаказыНаВнутреннееПотребление;
			Элементы.СтраницаЗаказыНаПеремещениеТоваров.Видимость = Ложь;
		Иначе
			ТекстИсключения = Нстр("ru='Некорректные параметры открытия формы'");
			Отказ = Истина;
			ВызватьИсключение ТекстИсключения;
		КонецЕсли;
	Иначе
		ТекстИсключения = Нстр("ru='Некорректные параметры открытия формы'");
		Отказ = Истина;
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если Параметры.Свойство("ДокументОснование") Тогда
		Объект.ДокументОснование = Параметры.ДокументОснование;
	КонецЕсли;
	
	//
	Если НЕ Объект.ДокументОснование.Проведен Тогда
		ТекстИсключения = Нстр("ru='Документ-основание %1 не проведен. Формирование документов не возможно.'");
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстИсключения, Объект.ДокументОснование);
		Отказ = Истина;
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	//
	
	Объект.ВидСоздаваемыхДокументов = ВидДокументов;
	ЗаполнитьСписокСкладов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказынаперемещениетоваров

&НаКлиенте
Процедура ЗаказыНаПеремещениеТоваровПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыНаПеремещениеТоваровПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыНаПеремещениеТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ПеремещенияПеремещениеТоваров" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.ЗаказНаПеремещение)
			И ТипЗнч(Элемент.ТекущиеДанные.ЗаказНаПеремещение) = Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
			ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.ЗаказНаПеремещение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаказынавнутреннеепотребление

&НаКлиенте
Процедура ЗаказыНаВнутреннееПотреблениеПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыНаВнутреннееПотреблениеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыНаВнутреннееПотреблениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ЗаказыЗаказНаВнутреннееПотребление" Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.ЗаказНаВнутреннееПотребление)
			И ТипЗнч(Элемент.ТекущиеДанные.ЗаказНаВнутреннееПотребление) = Тип("ДокументСсылка.ЗаказНаВнутреннееПотребление") Тогда
			ПоказатьЗначение(Неопределено, Элемент.ТекущиеДанные.ЗаказНаВнутреннееПотребление);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокументы(Команда)
	СоздатьДокументыСервер();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьДокументыСервер()
	Если Объект.ОбработкаВыполнена Тогда
		ТекстСообщения = Нстр("ru='Все возможные документы уже созданы'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидСоздаваемыхДокументов = "ЗаказНаПеремещение" Тогда
		ИмяТЧ = "ЗаказыНаПеремещениеТоваров";
		ИмяСклада = "СкладОтправитель";
		ИмяСкладаПолучателя = "СкладПолучатель";
		ИмяДатыОтгрузки = "НачалоОтгрузки";
		ИмяДатыПриемки = "ОкончаниеПоступления";
		ДопКолонка = ", Склады.СкладПолучатель КАК СкладПолучатель";
		ДопКолонкаИтогов = "МАКСИМУМ(СкладПолучатель) КАК СкладПолучатель";
	ИначеЕсли Объект.ВидСоздаваемыхДокументов = "ЗаказНаВнутреннееПотребление" Тогда
		ИмяТЧ = "ЗаказыНаВнутреннееПотребление";
		ИмяСклада = "Склад";
		ИмяСкладаПолучателя = "";
		ИмяДатыОтгрузки = "ДатаОтгрузки";
		ИмяДатыПриемки = "";
		ДопКолонка = "";
		ДопКолонкаИтогов = "";
	Иначе
		ТекстИсключения = Нстр("ru='Некорректные параметры заполнения'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	МассивСкладов = Объект[ИмяТЧ].Выгрузить().ВыгрузитьКолонку("Склад");
	РезультатЗапроса = РезультатЗапросаОстатковПоВыводуИзАссортимента(ИмяТЧ, ДопКолонка, ДопКолонкаИтогов);
	
	ВыборкаСклады = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаСклады.Следующий() Цикл
		ТекущаяДата = ТекущаяДатаСеанса();
		НовыйЗаказ = Документы[Объект.ВидСоздаваемыхДокументов].СоздатьДокумент();
		НовыйЗаказ.Дата = ТекущаяДата;
		НовыйЗаказ.Заполнить(Неопределено);
		НовыйЗаказ[ИмяСклада] = ВыборкаСклады.Склад;
		Если НЕ ПустаяСтрока(ИмяСкладаПолучателя) Тогда
			НовыйЗаказ[ИмяСкладаПолучателя] = ВыборкаСклады.СкладПолучатель;
		КонецЕсли;
		НовыйЗаказ.ДокументОснование = Объект.ДокументОснование;
		НовыйЗаказ.Подразделение = ВыборкаСклады.Подразделение;
		ВыборкаТовары = ВыборкаСклады.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаТовары.Следующий() Цикл
			НоваяСтрокаДокумента = НовыйЗаказ.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаДокумента, ВыборкаТовары);
			НоваяСтрокаДокумента[ИмяДатыОтгрузки] = ТекущаяДата;
			Если НЕ ПустаяСтрока(ИмяДатыПриемки) Тогда
				НоваяСтрокаДокумента[ИмяДатыПриемки] = ТекущаяДата;
			КонецЕсли;
		КонецЦикла;
		НовыйЗаказ.Записать(РежимЗаписиДокумента.Запись);
		СтрокиТЧ = Объект[ИмяТЧ].НайтиСтроки(Новый Структура("Склад", ВыборкаСклады.Склад));
		Если СтрокиТЧ.Количество() = 0 Тогда
			СтрокаТЧ = Объект[ИмяТЧ].Добавить();
		Иначе
			СтрокаТЧ = СтрокиТЧ[0];
		КонецЕсли;
		СтрокаТЧ.Склад = ВыборкаСклады.Склад;
		СтрокаТЧ[Объект.ВидСоздаваемыхДокументов] = НовыйЗаказ.Ссылка;
		Если НЕ ПустаяСтрока(ИмяСкладаПолучателя) Тогда
			СтрокаТЧ[ИмяСкладаПолучателя] = ВыборкаСклады.СкладПолучатель;
		КонецЕсли;
	КонецЦикла;
	Объект.ОбработкаВыполнена = Истина;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокСкладов()
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	История.Склад
	|ПОМЕСТИТЬ Склады
	|ИЗ
	|	РегистрСведений.ИсторияИзмененияФорматовМагазинов.СрезПоследних(&Дата, ) КАК История
	|ГДЕ
	|	История.ФорматМагазина = &ФорматМагазина
	|	И История.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.РозничныйМагазин)
	|	И НЕ История.Склад.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИзменениеАссортиментаТовары.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ втТовары
	|ИЗ
	|	Документ.ИзменениеАссортимента.Товары КАК ИзменениеАссортиментаТовары
	|ГДЕ
	|	ИзменениеАссортиментаТовары.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Склады.Склад КАК Склад
	|ИЗ
	|	Склады КАК Склады
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Остатки.Склад КАК Склад,
	|	Остатки.Склад.Наименование КАК НаименованиеСклада
	|ИЗ
	|	РегистрНакопления.СвободныеОстатки.Остатки(
	|			&Дата,
	|			Номенклатура В
	|					(ВЫБРАТЬ
	|						втТовары.Номенклатура
	|					ИЗ
	|						втТовары)
	|				И Склад В
	|					(ВЫБРАТЬ
	|						С.Склад
	|					ИЗ
	|						Склады КАК С)) КАК Остатки
	|УПОРЯДОЧИТЬ ПО
	|	НаименованиеСклада";
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	ФорматМагазина = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "ОбъектПланирования");
	Запрос.УстановитьПараметр("ФорматМагазина", ФорматМагазина);
	Запрос.УстановитьПараметр("ДокументОснование",Объект.ДокументОснование);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	
	Если Объект.ВидСоздаваемыхДокументов = "ЗаказНаПеремещение" Тогда
		ИмяТабличнойЧасти = "ЗаказыНаПеремещениеТоваров";
	Иначе
		ИмяТабличнойЧасти = "ЗаказыНаВнутреннееПотребление";
	КонецЕсли;
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатСклады = МассивРезультатов[2];
	РезультатОстатки = МассивРезультатов[3];
	СозданиеДоступно = Ложь;
	Если РезультатСклады.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'Не существует ни одного розничного магазина, принадлежащего формату ""%1"". Создание документов не требуется.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ФорматМагазина);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	ИначеЕсли РезультатОстатки.Пустой() Тогда
		ТекстСообщения = НСтр("ru = 'В свободных остатках не числится ни одного товара, выводимого из ассортимента. Создание документов не требуется.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТабличнаяЧасть = Объект[ИмяТабличнойЧасти];
		Выборка = РезультатОстатки.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			СозданиеДоступно = Истина;
		КонецЦикла;
	КонецЕсли;
	Элементы.ФормаСоздатьДокументы.Доступность = СозданиеДоступно;
КонецПроцедуры

&НаСервере
Функция РезультатЗапросаОстатковПоВыводуИзАссортимента(ИмяТЧ, ДополнительноеПоле, ДополнительноеПолеИтогов)
	
	Запрос=Новый Запрос("
						|ВЫБРАТЬ
						|	Склады.Склад КАК Склад
						|	" + ДополнительноеПоле + "
						|ПОМЕСТИТЬ Склады
						|ИЗ
						|	&Склады КАК Склады
						|ГДЕ
						|	Склады." + Объект.ВидСоздаваемыхДокументов + " = &ПустаяСсылка
						|	ИЛИ НЕ Склады." + Объект.ВидСоздаваемыхДокументов + " ССЫЛКА Документ." + Объект.ВидСоздаваемыхДокументов + "
						|;
						|
						|
						|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                    |	ИзменениеАссортиментаТовары.Номенклатура КАК Номенклатура
	                    |ПОМЕСТИТЬ втТовары
	                    |ИЗ
	                    |	Документ.ИзменениеАссортимента.Товары КАК ИзменениеАссортиментаТовары
	                    |ГДЕ
	                    |	ИзменениеАссортиментаТовары.Ссылка = &ДокументОснование
	                    |;
	                    |
	                    |////////////////////////////////////////////////////////////////////////////////
	                    |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                    |	Остатки.Склад КАК Склад,
	                    |	Остатки.Склад.Подразделение КАК Подразделение
						|	" + ДополнительноеПоле + ",
	                    |	Остатки.Номенклатура КАК Номенклатура,
	                    |	Остатки.Характеристика КАК Характеристика,
	                    |	Остатки.ВНаличииОстаток КАК Количество,
	                    |	Остатки.ВНаличииОстаток КАК КоличествоУпаковок
	                    |ИЗ
	                    |	РегистрНакопления.СвободныеОстатки.Остатки(
	                    |			&Дата,
	                    |			Номенклатура В
	                    |					(ВЫБРАТЬ
	                    |						втТовары.Номенклатура
	                    |					ИЗ
	                    |						втТовары)
	                    |				И Склад В (ВЫБРАТЬ С.Склад ИЗ Склады КАК С)) КАК Остатки
						|				" + ?(ПустаяСтрока(ДополнительноеПоле),"","ВНУТРЕННЕЕ СОЕДИНЕНИЕ Склады КАК Склады ПО Склады.Склад = Остатки.Склад") + "
	                    |УПОРЯДОЧИТЬ ПО Остатки.Склад.Наименование, Остатки.Номенклатура.Наименование
	                    |ИТОГИ
						|" + ДополнительноеПолеИтогов + "
						|ПО Склад
						|");
	Запрос.УстановитьПараметр("ДокументОснование",Объект.ДокументОснование);
	Запрос.УстановитьПараметр("Склады", Объект[ИмяТЧ].Выгрузить());
	Запрос.УстановитьПараметр("ПустаяСсылка",Документы[Объект.ВидСоздаваемыхДокументов].ПустаяСсылка());
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса;
КонецФункции

#КонецОбласти
