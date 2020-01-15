﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазыУТ.ПроверитьВозможностьОткрытияФормы(Метаданные.РегистрыСведений.РеестрДокументов.ПолноеИмя());

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора = Неопределено Тогда
		ВосстановитьНастройки();
	КонецЕсли;
	
	УстановитьОтборыПоХозяйственнымОперациямИДокументам();
	НастроитьКнопкиУправленияДокументами();
		
	СкладПриИзмененииСервер();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = СписокАктов.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокАктовКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ПроверкаДокументовВРеглУчете
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, СписокАктов);
	СвойстваСписка.ТекстЗапроса = СтрЗаменить(СвойстваСписка.ТекстЗапроса, "&СтатусПроверки КАК СтатусПроверки", "НЕОПРЕДЕЛЕНО КАК УдаленСтатусПроверки");
	СвойстваСписка.ТекстЗапроса = СтрЗаменить(СвойстваСписка.ТекстЗапроса, "&ИндикаторПроверки КАК ИндикаторПроверки", "НЕОПРЕДЕЛЕНО КАК УдаленИндикаторПроверки");
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокАктов, СвойстваСписка);
	// Конец ПроверкаДокументовВРеглУчете
	
	ДополнительныеПараметры = Новый Структура("МестоРазмещенияДанныхПроверкиРегл", Элементы.ГруппаРеглПроверка);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокАктов.Дата", "СписокАктовДата");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ) 	
	
	ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди();
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
	Если Не ЗавершениеРаботы
		И СтруктураБыстрогоОтбора = Неопределено Тогда
		
		СохранитьНастройки();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Создание_СкладскиеАкты"
		Или ИмяСобытия = "Запись_СписаниеНедостачТоваров"
		Или ИмяСобытия = "Запись_ПорчаТоваров"
		Или ИмяСобытия = "Запись_ПересортицаТоваров"
		Или ИмяСобытия = "Запись_ОприходованиеИзлишковТоваров"
		Или ИмяСобытия = "Запись_ИнвентаризационнаяОпись"
		Или ИмяСобытия = "Запись_ОрдерНаОтражениеИзлишковТоваровТогда"
		Или ИмяСобытия = "ОрдерНаОтражениеНедостачТоваров"
		Или ИмяСобытия = "ОрдерНаОтражениеПорчиТоваров" Тогда
		
		ОбновитьВсеНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
    СкладПриИзмененииСервер();

	ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроблемаЕстьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылка = "ЗапуститьФормирование" Тогда
		
		ОчиститьСообщения();
		ЗапуститьФормированиеКорректировок();		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВниманиеНажатие(Элемент)
	ОчиститьСообщения();
	ЗапуститьФормированиеКорректировок();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокАктов

&НаКлиенте
Процедура СписокАктовПриИзменении(Элемент)
	ОбновитьГиперссылкуКОформлению();
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("УстановитьПометкуУдаленияЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элемент, Заголовок, ОповещениеОЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Элементы.ГруппаСоздатьГенерируемая.ПодчиненныеЭлементы.Количество() <> 0 Тогда 
		Если Копирование Тогда
			ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элемент);
		ИначеЕсли ОтборТипыДокументов.Количество() = 1 И ОтборХозяйственныеОперации.Количество() = 1 Тогда 
			СтруктураКоманды = Новый Структура("Имя", Элементы.ГруппаСоздатьГенерируемая.ПодчиненныеЭлементы[0].Имя);
			Подключаемый_СоздатьДокумент(СтруктураКоманды);
		Иначе
			Подключаемый_СоздатьДокументЧерезФормуВыбора(Неопределено);
		КонецЕсли;
	КонецЕсли;
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьВсе(Команда)
	ОбновитьВсеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовСкопировать(Команда)
	
	ОбщегоНазначенияУТКлиент.СкопироватьЭлемент(Элементы.СписокАктов);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовПровести(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиДокументы(Элементы.СписокАктов, Заголовок);
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовОтменаПроведения(Команда)
	
	ОбщегоНазначенияУТКлиент.ОтменаПроведения(Элементы.СписокАктов, Заголовок);
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовУстановитьПометкуУдаления(Команда)
	
	Оповещение = Новый ОписаниеОповещения("СписокАктовУстановитьПометкуУдаленияЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУТКлиент.УстановитьПометкуУдаления(Элементы.СписокАктов, Заголовок, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАктовУстановитьПометкуУдаленияЗавершение(Команда, ДополнительныеПараметры) Экспорт
	
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУтКлиент.РедактироватьПериод(Интервал, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокАктов.Параметры.УстановитьЗначениеПараметра("НачалоПериода", Интервал.ДатаНачала);
	СписокАктов.Параметры.УстановитьЗначениеПараметра("КонецПериода", 
		?(ЗначениеЗаполнено(Интервал.ДатаОкончания),
			КонецДня(Интервал.ДатаОкончания),
			Интервал.ДатаОкончания));

	
	
КонецПроцедуры

#Область КнопкаСоздать

&НаКлиенте
Процедура СИспользованиемПомощника(Команда)
	
	ПараметрыФормы = Новый Структура("Склад", Склад);
	ОткрытьФорму("Обработка.ПомощникОформленияСкладскихАктов.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокумент(Команда)
	
	СтруктураОтбора = Новый Структура("Склад",Склад);
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезКоманду(Команда.Имя, СтруктураОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СоздатьДокументЧерезФормуВыбора(Команда)
	
	СтруктураОтбора = Новый Структура("Склад",Склад);
	АдресХозяйственныеОперацииИДокументы = ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы();
	ОбщегоНазначенияУТКлиент.СоздатьДокументЧерезФормуВыбора(АдресХозяйственныеОперацииИДокументы, "СкладскиеАкты", КлючНазначенияИспользования, СтруктураОтбора);
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокАктов);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокАктов, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокАктов);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура СкладПриИзмененииСервер()
				
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад", Склад));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокАктов,
			"Склад",
			Склад,
			ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(Склад));
			
	ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач =
		СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад);
		
	ИспользуетсяАдресноеХранениеНаСкладеИлиЕгоПомещениях = ПолучитьФункциональнуюОпцию("ИспользоватьАдресноеХранение", Новый Структура("Склад", Склад));

	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаСервере
Функция ДанныеПоШтрихКодуПечатнойФормы(Штрихкод)
	
	ДанныеПоШтрихКоду = ОбщегоНазначенияУТ.ДанныеПоШтрихКодуПечатнойФормы(Штрихкод, ХозяйственныеОперацииИДокументы.Выгрузить());	
	
	Возврат ДанныеПоШтрихКоду;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	Состояние(НСтр("ru = 'Выполняется поиск документа по штрихкоду...'"));
	ДанныеПоШтрихКоду = ДанныеПоШтрихКодуПечатнойФормы(Данные.Штрихкод);
	ОбщегоНазначенияУТКлиент.ОбработатьШтрихкоды(Данные.Штрихкод, ДанныеПоШтрихКоду, ЭтаФорма, "СписокАктов");
	
КонецПроцедуры

#КонецОбласти

#Область ФоновоеЗаданиеФормированияКорректировок

&НаСервере
Процедура ЗапуститьФормированиеКорректировок()
	
	Помещения = СкладыСервер.ПомещенияПоКоторымНетФоновогоЗаданияФормированияКорректировокИзлишковНедостачПоТоварнымМестам(Склад);
	ЕстьОшибка = Ложь;
	Для Каждого Помещение Из Помещения Цикл
		ЕстьОшибка = СкладыСервер.СформироватьКорректировкиИзлишковНедостачПоТоварнымМестам(Склад, Помещение)
			Или ЕстьОшибка;
	КонецЦикла;
	
	Элементы.СостояниеАвтоматическогоФормированияКорректировок.Видимость = ЕстьОшибка; 	
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольРаботыФоновыхЗаданийФормированияОчереди()
		
	КонтрольРаботыФоновыхЗаданийФормированияОчередиНаСервере()
			
КонецПроцедуры

&НаСервере
Процедура КонтрольРаботыФоновыхЗаданийФормированияОчередиНаСервере()
		
	Помещения = СкладыСервер.ПомещенияПоКоторымНетФоновогоЗаданияФормированияКорректировокИзлишковНедостачПоТоварнымМестам(Склад);
	
	Элементы.СостояниеАвтоматическогоФормированияКорректировок.Видимость = (Помещения.Количество() > 0);
				
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияКонтроляРаботыФоновыхЗаданийФормированияОчереди()
	
	Если Не ИспользуетсяАдресноеХранениеНаСкладеИлиЕгоПомещениях Тогда
		Элементы.СостояниеАвтоматическогоФормированияКорректировок.Видимость = Ложь;
		ОтключитьОбработчикОжидания("КонтрольРаботыФоновыхЗаданийФормированияОчереди");
		Возврат;
	КонецЕсли; 
	
	КонтрольРаботыФоновыхЗаданийФормированияОчереди();
	ПодключитьОбработчикОжидания("КонтрольРаботыФоновыхЗаданийФормированияОчереди", 600);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ВосстановитьНастройки()
	Перем ЗначениеНастроек;

	ЗначениеНастроек = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.ЖурналСкладскихАктов", "НастройкиОбработки");
	Если ТипЗнч(ЗначениеНастроек) = Тип("Структура") Тогда
		ЗначениеНастроек.Свойство("Склад", Склад);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	Перем Настройки;

	Настройки = Новый Структура;
	Настройки.Вставить("Склад", Склад);

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.ЖурналСкладскихАктов", "НастройкиОбработки", Настройки);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПересчетыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Склад", Склад);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	Если НавигационнаяСсылка = "СписокПересчетовТолькоНевыполненные" Тогда
		ПараметрыФормы.Вставить("Статус",  "ТолькоНевыполненные");
	КонецЕсли;
	ОткрытьФорму("Документ.ПересчетТоваров.Форма.ФормаСписка", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьНеоформленныеПересчетыПоСкладу(Склад)
	
	Возврат ?(ЗначениеЗаполнено(Склад),Документы.ПересчетТоваров.НеоформленныеПересчетыПоСкладу(Склад).Количество() > 0,Ложь);
	
КонецФункции

&НаСервере
Процедура ОбновитьВсеНаСервере()
	Элементы.СписокАктов.Обновить();
	ОбновитьГиперссылкуКОформлению();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаленияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОбновитьГиперссылкуКОформлению();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьХозяйственныеОперацииИДокументы()
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ОприходованиеТоваров;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ОприходованиеИзлишковТоваров.ПолноеИмя();
	Строка.МенеджерРасчетаГиперссылкиКОформлению	= "Обработка.ЖурналСкладскихАктов";
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПересортицаТоваров;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПересортицаТоваров.ПолноеИмя();
	Строка.МенеджерРасчетаГиперссылкиКОформлению	= "Обработка.ЖурналСкладскихАктов";
	
	СтрокаПорчаТоваров = ХозяйственныеОперацииИДокументы.Добавить();
	Строка = СтрокаПорчаТоваров;
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПорчаТоваров;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПорчаТоваров.ПолноеИмя();
	Строка.МенеджерРасчетаГиперссылкиКОформлению	= "Обработка.ЖурналСкладскихАктов";
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	ЗаполнитьЗначенияСвойств(Строка, СтрокаПорчаТоваров);
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ПорчаТоваровСПереоценкой;
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.СписаниеТоваров;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.СписаниеНедостачТоваров.ПолноеИмя();
	Строка.МенеджерРасчетаГиперссылкиКОформлению	= "Обработка.ЖурналСкладскихАктов";
	
	
	Строка = ХозяйственныеОперацииИДокументы.Добавить();
	Строка.ХозяйственнаяОперация 		= Перечисления.ХозяйственныеОперации.ИнвентаризационнаяОпись;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ИнвентаризационнаяОпись.ПолноеИмя();
	Строка.МенеджерРасчетаГиперссылкиКОформлению	= "Обработка.ЖурналСкладскихАктов";
	
	ТаблицаЗначенийДоступно = ОбщегоНазначенияУТ.ДоступныеХозяйственныеОперацииИДокументы(ХозяйственныеОперацииИДокументы.Выгрузить(), ОтборХозяйственныеОперации, ОтборТипыДокументов, "");
	
	ХозяйственныеОперацииИДокументы.Загрузить(ТаблицаЗначенийДоступно);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыПоХозяйственнымОперациямИДокументам()
	
	ИнициализироватьХозяйственныеОперацииИДокументы();
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокАктов,
		"ХозяйственнаяОперация",
		ОтборХозяйственныеОперации,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокАктов,
		"ТипСсылки",
		ОтборТипыДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеХозяйственныеОперацииИДокументы()
	Возврат ПоместитьВоВременноеХранилище(ХозяйственныеОперацииИДокументы.Выгрузить(), УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура НастроитьКнопкиУправленияДокументами()
	
	СтруктураПараметров = ОбщегоНазначенияУТ.СтруктураПараметровНастройкиКнопокУправленияДокументами();
	СтруктураПараметров.Форма 												= ЭтаФорма;
	СтруктураПараметров.ИмяКнопкиСкопировать 								= "СписокАктовСкопировать";
	СтруктураПараметров.ИмяКнопкиСкопироватьКонтекстноеМеню 				= "СписокАктовКонтекстноеМенюСкопировать";
	СтруктураПараметров.ИмяКнопкиИзменить 									= "СписокАктовИзменить";
	СтруктураПараметров.ИмяКнопкиИзменитьКонтекстноеМеню 					= "СписокАктовКонтекстноеМенюИзменить";
	СтруктураПараметров.ИмяКнопкиПровести 									= "СписокАктовПровести";
	СтруктураПараметров.ИмяКнопкиПровестиКонтекстноеМеню 					= "СписокАктовКонтекстноеМенюПровести";
	СтруктураПараметров.ИмяКнопкиОтменаПроведения 							= "СписокАктовОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиОтменаПроведенияКонтекстноеМеню 			= "СписокАктовКонтекстноеМенюОтменаПроведения";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаления 					= "СписокАктовУстановитьПометкуУдаления";
	СтруктураПараметров.ИмяКнопкиУстановитьПометкуУдаленияКонтекстноеМеню 	= "СписокАктовКонтекстноеМенюУстановитьПометкуУдаления";
	
	ОбщегоНазначенияУТ.НастроитьКнопкиУправленияДокументами(СтруктураПараметров);

КонецПроцедуры

#Область ГиперссылкаКОформлению

&НаСервере
Функция ОбновитьГиперссылкуКОформлению()
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("Склад",Склад);
		
	КОформлению = ОбщегоНазначенияУТ.СформироватьГиперссылкуКОформлению(ХозяйственныеОперацииИДокументы.Выгрузить(), ПараметрыФормирования);
	
	Элементы.КОформлению.Видимость = ЗначениеЗаполнено(КОформлению);
	
	Элементы.СтраницыПересчеты.Видимость = ЗначениеЗаполнено(КОформлению);

	Если ЕстьНеоформленныеПересчетыПоСкладу(Склад) Тогда
		Элементы.СтраницыПересчеты.ТекущаяСтраница = Элементы.СтраницаЕстьПересчеты;
	Иначе
		Элементы.СтраницыПересчеты.ТекущаяСтраница = Элементы.СтраницаНетПересчетов;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура КОформлениюОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
		
	ПараметрыФормы.Вставить("ФиксированныеНастройки", Неопределено);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", Новый ПользовательскиеНастройкиКомпоновкиДанных);
	Если ЗначениеЗаполнено(Склад) Тогда
		КлючВарианта = "ОформлениеИзлишковНедостачКонтекст";
		ПараметрыФормы.Вставить("Склад", Склад);
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Склад", Склад)); 
	Иначе
		КлючВарианта = "ОформлениеИзлишковНедостач";
	КонецЕсли;
	ПараметрыФормы.Вставить("КлючВарианта", КлючВарианта);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", КлючВарианта);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыФормы.Вставить("ВидимостьКомандВариантовОтчетов", Ложь);
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки,ПараметрыФормы,,УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
