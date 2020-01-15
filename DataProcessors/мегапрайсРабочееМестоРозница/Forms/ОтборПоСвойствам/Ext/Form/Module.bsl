﻿
&НаСервере
Перем НомерУникальногоИдентификатора;

&НаСервере
Перем НомерРеквизита;

&НаСервере
Функция ПолучитьУникальныйИдентификатор()
	
	Если НомерУникальногоИдентификатора = Неопределено Тогда
		НомерУникальногоИдентификатора = 1;
	Иначе
		НомерУникальногоИдентификатора = НомерУникальногоИдентификатора + 1;
	КонецЕсли;
	
	Возврат "U" + НомерУникальногоИдентификатора;
	
КонецФункции

&НаСервере
Функция ПолучитьИмяРеквизитаФормы()
	
	Если НомерРеквизита = Неопределено Тогда
		НомерРеквизита = 1;
	Иначе
		НомерРеквизита = НомерРеквизита + 1;
	КонецЕсли;
	
	Возврат "R" + НомерРеквизита;
	
КонецФункции

&НаСервере
Функция ПолучитьСтруктуруОписанияСвойства(Категория)
	
	ОписаниеСвойства = Новый Структура;
	ОписаниеСвойства.Вставить("Свойство", Категория);
	ОписаниеСвойства.Вставить("СвойствоХарактеристики", Ложь);
	ОписаниеСвойства.Вставить("ИмяСвойства", Строка(Категория));
	ОписаниеСвойства.Вставить("ИмяРеквизитаФормы", ПолучитьИмяРеквизитаФормы());
	ОписаниеСвойства.Вставить("ТипЗначения", Новый ОписаниеТипов("Булево"));
	ОписаниеСвойства.Вставить("ТипСвойства", 5);
	
	Возврат ОписаниеСвойства;
	
КонецФункции // ПолучитьСтруктуруОписанияСвойства()

&НаСервере
Функция ПолучитьСтруктуруОписанияСвойстваБулево()
	
	ДеревоЭлементов = Новый Структура;
	ДеревоЭлементов.Вставить("Свойство", Неопределено);
	ДеревоЭлементов.Вставить("СвойствоХарактеристики", Ложь);
	ДеревоЭлементов.Вставить("ИмяСвойства", "");
	ДеревоЭлементов.Вставить("ИмяРеквизитаФормы", "");
	ДеревоЭлементов.Вставить("ТипЗначения", Неопределено);
	ДеревоЭлементов.Вставить("ТипСвойства", 4);
	
	Возврат ДеревоЭлементов;
	
КонецФункции // ПолучитьСтруктуруОписанияСвойства()

&НаСервере
Функция ПолучитьСтруктуруОписанияСвойстваФлажками()
	
	ДеревоЭлементов = Новый Структура;
	ДеревоЭлементов.Вставить("Свойство", Неопределено);
	ДеревоЭлементов.Вставить("СвойствоХарактеристики", Ложь);
	ДеревоЭлементов.Вставить("ИмяСвойства", "");
	ДеревоЭлементов.Вставить("РеквизитыФормы", Новый Массив);
	ДеревоЭлементов.Вставить("ТипЗначения", Неопределено);
	ДеревоЭлементов.Вставить("ТипСвойства", 1);
	
	Возврат ДеревоЭлементов;
	
КонецФункции // ПолучитьСтруктуруОписанияСвойства()

&НаСервере
Функция ПолучитьСтруктуруОписанияСвойстваСписком()
	
	ДеревоЭлементов = Новый Структура;
	ДеревоЭлементов.Вставить("Свойство", Неопределено);
	ДеревоЭлементов.Вставить("СвойствоХарактеристики", Ложь);
	ДеревоЭлементов.Вставить("ИмяСвойства", "");
	ДеревоЭлементов.Вставить("ИмяРеквизитаФормы", "");
	ДеревоЭлементов.Вставить("ТипЗначения", Неопределено);
	ДеревоЭлементов.Вставить("ТипСвойства", 2);
	
	Возврат ДеревоЭлементов;
	
КонецФункции // ПолучитьСтруктуруОписанияСвойства()

&НаСервере
Функция ПолучитьСтруктуруОписанияСвойстваИнтервалом()
	
	ДеревоЭлементов = Новый Структура;
	ДеревоЭлементов.Вставить("Свойство", Неопределено);
	ДеревоЭлементов.Вставить("СвойствоХарактеристики", Ложь);
	ДеревоЭлементов.Вставить("ИмяСвойства", "");
	ДеревоЭлементов.Вставить("ИмяРеквизитаФормыНачальноеЗначение", "");
	ДеревоЭлементов.Вставить("ИмяРеквизитаФормыКонечноеЗначение", "");
	ДеревоЭлементов.Вставить("ТипЗначения", Неопределено);
	ДеревоЭлементов.Вставить("ТипСвойства", 3); // 1 - Перечислимое, 2 - список значений, 3 -интервалом
	
	Возврат ДеревоЭлементов;
	
КонецФункции // ПолучитьСтруктуруОписанияСвойства()

&НаСервере
Функция ПолучитьСтруктуруОписанияПеречислимогоЗначения()
	
	ДеревоЭлементов = Новый Структура;
	ДеревоЭлементов.Вставить("ИмяРеквизитаФормы", "");
	ДеревоЭлементов.Вставить("Значение", Неопределено);
	
	Возврат ДеревоЭлементов;
	
КонецФункции // ПолучитьСтруктуруОписанияСвойства()


&НаСервере
Функция СоздатьЭлементыДляСвойства(Родитель, Заголовок)

	ЭлементДекорация = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ДекорацияФормы"), Родитель);
	ЭлементДекорация.Вид         = ВидДекорацииФормы.Надпись;
	ЭлементДекорация.Заголовок   = Заголовок;
	ЭлементДекорация.Шрифт       = Новый Шрифт(,,Истина);
	ЭлементДекорация.Ширина      = 30;
	ЭлементДекорация.РастягиватьПоГоризонтали = Истина;
	
	ЭлементГруппа01     = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ГруппаФормы"), Родитель);
	ЭлементГруппа01.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	// Горизонтальная группировка.
	ЭлементГруппа01.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	// Без отображения в форме.
	ЭлементГруппа01.ОтображатьЗаголовок = Ложь;
	ЭлементГруппа01.Отображение         =ОтображениеОбычнойГруппы.Нет;
	
	ЭлементДекорация = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ДекорацияФормы"), ЭлементГруппа01);
	ЭлементДекорация.Вид         = ВидДекорацииФормы.Надпись;
	ЭлементДекорация.Заголовок   = " ";
	ЭлементДекорация.Ширина      = 1;
	ЭлементДекорация.РастягиватьПоГоризонтали = Ложь;
	
	ЭлементГруппа02     = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ГруппаФормы"), ЭлементГруппа01);
	ЭлементГруппа02.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	// Горизонтальная группировка.
	ЭлементГруппа02.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	// Без отображения в форме.
	ЭлементГруппа02.ОтображатьЗаголовок = Ложь;
	ЭлементГруппа02.Отображение         =ОтображениеОбычнойГруппы.Нет;
	
	ЭлементГруппа03     = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ГруппаФормы"), ЭлементГруппа01);
	ЭлементГруппа03.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	// Горизонтальная группировка.
	ЭлементГруппа03.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	// Без отображения в форме.
	ЭлементГруппа03.ОтображатьЗаголовок = Ложь;
	ЭлементГруппа03.Отображение         =ОтображениеОбычнойГруппы.Нет;
	
	Возврат Новый Структура("ГруппаЛево, ГруппаПраво", ЭлементГруппа02, ЭлементГруппа03);
	
КонецФункции // СоздатьЭлементыДляСвойства()


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидНоменклатуры = Параметры.ВидНоменклатуры;
	
	ГруппаСвойстваВидаНоменклатуры = ЭтаФорма.Элементы["РазмещениеСвойстваВидаНоменклатуры"];
	ГруппаСвойстваНоменклатуры = ЭтаФорма.Элементы["РазмещениеСвойстваНоменклатуры"];
	
	ТипЧисло = Новый ОписаниеТипов("Число");
	
	
	
	Массив = Новый Массив;
	
	ДобавляемыеРеквизиты              = Новый Массив();
	СоответствиеЭлементаИТипаЗначений = Новый Соответствие;
	
	
	//////////////////////////////////////////////////////////
	// Генерация реквизитов формы
	
	МассивКатегорийНоменклатуры = ПодборТоваровСервер.ПолучитьОбщиеСвойстваНоменклатуры();
	Для каждого Категория Из МассивКатегорийНоменклатуры Цикл
		
		ОписаниеСвойства = ПолучитьСтруктуруОписанияСвойства(Категория);
		Массив.Добавить(ОписаниеСвойства);
		
		Реквизит = Новый РеквизитФормы(
			ОписаниеСвойства.ИмяРеквизитаФормы, // Имя реквизита
			ОписаниеСвойства.ТипЗначения,       // Тип
			,                                    // Путь
			Категория,                           // Заголовок
			Ложь                                 // СохраняемыеДанные
		);
		ДобавляемыеРеквизиты.Добавить(Реквизит);
		
	КонецЦикла;
	
	
	МассивСтруктурСвойствИЗначений = ПодборТоваровСервер.ПолучитьСвойстваВидаНоменклатуры(Параметры.ВидНоменклатуры);
	Для каждого СтруктураСвойства Из МассивСтруктурСвойствИЗначений Цикл
		
		Если Строка(СтруктураСвойства.ТипЗначения) = "Булево" Тогда
			
			ОписаниеСвойства = ПолучитьСтруктуруОписанияСвойстваБулево();
			ОписаниеСвойства.Свойство    = СтруктураСвойства.Свойство;
			ОписаниеСвойства.СвойствоХарактеристики = СтруктураСвойства.СвойствоХарактеристики;
			ОписаниеСвойства.ИмяРеквизитаФормы = ПолучитьИмяРеквизитаФормы();
			ОписаниеСвойства.ИмяСвойства = Строка(СтруктураСвойства.Свойство);
			ОписаниеСвойства.ТипЗначения = СтруктураСвойства.ТипЗначения;
			Массив.Добавить(ОписаниеСвойства);
			
			Реквизит = Новый РеквизитФормы(
				ОписаниеСвойства.ИмяРеквизитаФормы, // Имя реквизита
				ОписаниеСвойства.ТипЗначения,       // Тип
				,                                   // Путь
				ОписаниеСвойства.Свойство,          // Заголовок
				Ложь                                // СохраняемыеДанные
			);
			ДобавляемыеРеквизиты.Добавить(Реквизит);
			
		ИначеЕсли СтруктураСвойства.Значение.Количество() < 13 Тогда // Перечислимое свойство <13>
			
			ОписаниеСвойства = ПолучитьСтруктуруОписанияСвойстваФлажками();
			ОписаниеСвойства.Свойство    = СтруктураСвойства.Свойство;
			ОписаниеСвойства.СвойствоХарактеристики = СтруктураСвойства.СвойствоХарактеристики;
			ОписаниеСвойства.ИмяСвойства = Строка(СтруктураСвойства.Свойство);
			ОписаниеСвойства.ТипЗначения = СтруктураСвойства.ТипЗначения;
			Массив.Добавить(ОписаниеСвойства);
			
			Для каждого ЗначениеСвойства Из СтруктураСвойства.Значение Цикл
				
				ОписаниеЗначения = ПолучитьСтруктуруОписанияПеречислимогоЗначения();
				ОписаниеЗначения.ИмяРеквизитаФормы = ПолучитьИмяРеквизитаФормы();
				ОписаниеЗначения.Значение          = ЗначениеСвойства;
				
				ОписаниеСвойства.РеквизитыФормы.Добавить(ОписаниеЗначения);
				
				Реквизит = Новый РеквизитФормы(ОписаниеЗначения.ИмяРеквизитаФормы, Новый ОписаниеТипов("Булево"), , ЗначениеСвойства, Ложь);
				ДобавляемыеРеквизиты.Добавить(Реквизит);
				
			КонецЦикла;
			
		ИначеЕсли Строка(СтруктураСвойства.ТипЗначения) = "Число" ИЛИ Строка(СтруктураСвойства.ТипЗначения) = "Дата" Тогда
			
			ОписаниеСвойства = ПолучитьСтруктуруОписанияСвойстваИнтервалом();
			ОписаниеСвойства.Свойство    = СтруктураСвойства.Свойство;
			ОписаниеСвойства.СвойствоХарактеристики = СтруктураСвойства.СвойствоХарактеристики;
			ОписаниеСвойства.ИмяСвойства = Строка(СтруктураСвойства.Свойство);
			ОписаниеСвойства.ТипЗначения = СтруктураСвойства.ТипЗначения;
			ОписаниеСвойства.ИмяРеквизитаФормыНачальноеЗначение = ПолучитьИмяРеквизитаФормы();
			ОписаниеСвойства.ИмяРеквизитаФормыКонечноеЗначение = ПолучитьИмяРеквизитаФормы();
			Массив.Добавить(ОписаниеСвойства);
			
			Реквизит = Новый РеквизитФормы(ОписаниеСвойства.ИмяРеквизитаФормыНачальноеЗначение, СтруктураСвойства.ТипЗначения, , , Ложь);
			ДобавляемыеРеквизиты.Добавить(Реквизит);
			Реквизит = Новый РеквизитФормы(ОписаниеСвойства.ИмяРеквизитаФормыКонечноеЗначение, СтруктураСвойства.ТипЗначения, , , Ложь);
			ДобавляемыеРеквизиты.Добавить(Реквизит);
		
		Иначе
			
			ОписаниеСвойства = ПолучитьСтруктуруОписанияСвойстваСписком();
			ОписаниеСвойства.Свойство    = СтруктураСвойства.Свойство;
			ОписаниеСвойства.СвойствоХарактеристики = СтруктураСвойства.СвойствоХарактеристики;
			ОписаниеСвойства.ТипЗначения = СтруктураСвойства.ТипЗначения;
			ОписаниеСвойства.ИмяСвойства = Строка(СтруктураСвойства.Свойство);
			ОписаниеСвойства.ИмяРеквизитаФормы = ПолучитьИмяРеквизитаФормы();
			Массив.Добавить(ОписаниеСвойства);
			
			Реквизит = Новый РеквизитФормы(ОписаниеСвойства.ИмяРеквизитаФормы, Новый ОписаниеТипов("СписокЗначений"), , , Ложь);
			ДобавляемыеРеквизиты.Добавить(Реквизит);
			
			СоответствиеЭлементаИТипаЗначений.Вставить(ОписаниеСвойства.ИмяРеквизитаФормы, СтруктураСвойства.ТипЗначения);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Изменение типа у списков значений;
	ЭтаФорма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	Для каждого КлючИЗначение Из СоответствиеЭлементаИТипаЗначений Цикл
		ЭтаФорма[КлючИЗначение.Ключ].ТипЗначения = КлючИЗначение.Значение;
	КонецЦикла;
	
	
	//////////////////////////////////////////////////////////
	// Генерация элементов формы
	
	Для Каждого ОписаниеСвойства Из Массив Цикл
		
		Если ОписаниеСвойства.ТипСвойства = 1 Тогда
			
			ЭлементыДляСвойства = СоздатьЭлементыДляСвойства(ГруппаСвойстваВидаНоменклатуры, ОписаниеСвойства.ИмяСвойства+":");
			
			Счетчик = 0;
			КоличествоРеквизитовФормы =  ОписаниеСвойства.РеквизитыФормы.Количество();
			Для Каждого РеквизитФормы Из ОписаниеСвойства.РеквизитыФормы Цикл
				
				// Распределение по колонкам.
				Счетчик = Счетчик + 1;
				Если КоличествоРеквизитовФормы > 4 Тогда
					Если Счетчик%2 Тогда
						Группа= ЭлементыДляСвойства.ГруппаЛево;
					Иначе
						Группа = ЭлементыДляСвойства.ГруппаПраво;
					КонецЕсли;
				Иначе
					Группа= ЭлементыДляСвойства.ГруппаЛево;
				КонецЕсли;
				
				ЭлементФормы = ЭтаФорма.Элементы.Добавить(РеквизитФормы.ИмяРеквизитаФормы, Тип("ПолеФормы"), Группа);
				ЭлементФормы.Вид                = ВидПоляФормы.ПолеФлажка;
				ЭлементФормы.ПутьКДанным        = РеквизитФормы.ИмяРеквизитаФормы;
				ЭлементФормы.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
				
			КонецЦикла;
			
		ИначеЕсли ОписаниеСвойства.ТипСвойства = 2 Тогда
			
			Группы = СоздатьЭлементыДляСвойства(ГруппаСвойстваВидаНоменклатуры, ОписаниеСвойства.ИмяСвойства+":");
			
			ЭлементФормы_ = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ТаблицаФормы"), Группы.ГруппаЛево);
			ЭлементФормы_.ПутьКДанным = ОписаниеСвойства.ИмяРеквизитаФормы;
			
			ЭлементФормы = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ПолеФормы"), ЭлементФормы_);
			ЭлементФормы.ПутьКДанным = ОписаниеСвойства.ИмяРеквизитаФормы + ".Значение";
			
		ИначеЕсли ОписаниеСвойства.ТипСвойства = 4 Тогда
			
			ЭлементФормы = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ПолеФормы"), ГруппаСвойстваВидаНоменклатуры);
			ЭлементФормы.Вид                = ВидПоляФормы.ПолеФлажка;
			ЭлементФормы.ПутьКДанным        = ОписаниеСвойства.ИмяРеквизитаФормы;
			ЭлементФормы.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
			
		ИначеЕсли ОписаниеСвойства.ТипСвойства = 5 Тогда
			
			ЭлементФормы = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ПолеФормы"), ГруппаСвойстваНоменклатуры);
			ЭлементФормы.Вид                = ВидПоляФормы.ПолеФлажка;
			ЭлементФормы.ПутьКДанным        = ОписаниеСвойства.ИмяРеквизитаФормы;
			ЭлементФормы.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
			
		ИначеЕсли ОписаниеСвойства.ТипСвойства = 3 Тогда
			
			Группы = СоздатьЭлементыДляСвойства(ГруппаСвойстваВидаНоменклатуры, ОписаниеСвойства.ИмяСвойства+":");
			
			ЭлементФормы = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ПолеФормы"), Группы.ГруппаЛево);
			ЭлементФормы.Вид         = ВидПоляФормы.ПолеВвода;
			ЭлементФормы.Заголовок   = "Минимум";
			ЭлементФормы.ПутьКДанным = ОписаниеСвойства.ИмяРеквизитаФормыНачальноеЗначение;
			
			ЭлементФормы = ЭтаФорма.Элементы.Добавить(ПолучитьУникальныйИдентификатор(), Тип("ПолеФормы"), Группы.ГруппаПраво);
			ЭлементФормы.Вид         = ВидПоляФормы.ПолеВвода;
			ЭлементФормы.Заголовок   = "Максимум";
			ЭлементФормы.ПутьКДанным = ОписаниеСвойства.ИмяРеквизитаФормыКонечноеЗначение;
			
		КонецЕсли;
		
	КонецЦикла;
	
		//Если СтрРеквизит.ИмяРеквизитаСвойство <> "" Тогда
		//	Связь = Новый СвязьПараметраВыбора("Отбор.Владелец", СтрРеквизит.ИмяРеквизитаСвойство);
		//	масСвязи = Новый Массив;
		//	масСвязи.Добавить(Связь);
		//	Элемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(масСвязи);
		//	Форма[СтрРеквизит.ИмяРеквизитаСвойство] = СтрРеквизит.Свойство;
		//КонецЕсли;
	
	ОписаниеФормы = Новый Структура;
	ОписаниеФормы.Вставить("Массив", Массив);
	
	
	// Восстановление настроек.
	Если Параметры.ТекущийОтбор <> Неопределено Тогда 
		
		Если Параметры.ТекущийОтбор.ОтборПоВидамНоменклатуры.Количество() > 0 Тогда
			ЗначенияСвойств = Параметры.ТекущийОтбор.ОтборПоВидамНоменклатуры[0].ЗначенияСвойств;
			Для каждого СтруктураЗначенияСвойств Из ЗначенияСвойств Цикл
				
				Для Каждого Эл Из Массив Цикл
					
					Если Эл.Свойство = СтруктураЗначенияСвойств.Свойство Тогда
						
						Если Эл.ТипСвойства = 1 Тогда
							
							Для каждого РеквФормы Из Эл.РеквизитыФормы Цикл
								
								Если СтруктураЗначенияСвойств.Значение.НайтиПоЗначению(РеквФормы.Значение) <> Неопределено ТОгда
									ЭтаФорма[РеквФормы.ИмяРеквизитаФормы] = Истина;
								КонецЕсли;
								
							КонецЦикла;
							
						ИначеЕсли Эл.ТипСвойства = 2 Тогда
							
							ЭтаФорма[Эл.ИмяРеквизитаФормы] = СтруктураЗначенияСвойств.Значение;
							
						ИначеЕсли Эл.ТипСвойства = 5 Тогда
							
							ЭтаФорма[Эл.ИмяРеквизитаФормы] = СтруктураЗначенияСвойств.Значение;
							
						ИначеЕсли Эл.ТипСвойства = 4 Тогда
							
							ЭтаФорма[Эл.ИмяРеквизитаФормы] = СтруктураЗначенияСвойств.Значение;
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЦикла;
		КонецЕсли;
		
		Для каждого Категория Из Параметры.ТекущийОтбор.ОтборПоКатегориям Цикл
			
			Для Каждого Эл Из Массив Цикл
				
				Если Эл.Свойство = Категория Тогда
					
					ЭтаФорма[Эл.ИмяРеквизитаФормы] = Истина;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.ГруппаСвойстваНоменклатуры.Видимость = ГруппаСвойстваНоменклатуры.ПодчиненныеЭлементы.Количество() > 0;
	Элементы.ГруппаСвойстваВидаНоменклатуры.Видимость = ГруппаСвойстваВидаНоменклатуры.ПодчиненныеЭлементы.Количество() > 0;
	
	Если Элементы.ГруппаСвойстваНоменклатуры.Видимость = Ложь
		И Элементы.ГруппаСвойстваВидаНоменклатуры.Видимость = Ложь Тогда
		// Вывести надпись свойства не заданы
		Элементы.ДекорацияСвойстваНеЗаданы.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	ДанныеОтбора = Новый Структура("ВидНоменклатуры, ЗначенияСвойств", ВидНоменклатуры, Новый Массив);
	
	ДанныеОтбораПоКатегориям = Новый Массив;
	
	Для каждого Свойство Из ОписаниеФормы.Массив Цикл
		
		// Перечислимое свойство. Представлено на форме флажками.
		// Сконвертируем флажки в список значений для отбора.
		// Если список будет не пустой - добавим отбор
		Если Свойство.ТипСвойства = 1 Тогда 
			
			СписокЗначений = Новый СписокЗначений;
			ДобавитьНеЗаполнено = Ложь;
			Для каждого РеквизитФормы Из Свойство.РеквизитыФормы Цикл
			
				Если ЭтаФорма[РеквизитФормы.ИмяРеквизитаФормы] Тогда
					Если РеквизитФормы.Значение = Null Тогда
						ДобавитьНеЗаполнено = Истина;
					Иначе
						СписокЗначений.Добавить(РеквизитФормы.Значение);
					КонецЕсли;
				КонецЕсли;
			
			КонецЦикла;
			
			Если СписокЗначений.Количество() > 0 Тогда
			
				СтруктураЗначенияСвойств = Новый Структура;
				СтруктураЗначенияСвойств.Вставить("Тип", Свойство.ТипСвойства);
				СтруктураЗначенияСвойств.Вставить("Свойство", Свойство.Свойство);
				СтруктураЗначенияСвойств.Вставить("СвойствоХарактеристики", Свойство.СвойствоХарактеристики);
				СтруктураЗначенияСвойств.Вставить("ДобавитьНеЗаполнено", ДобавитьНеЗаполнено);
				СтруктураЗначенияСвойств.Вставить("Значение", СписокЗначений);
				
				ДанныеОтбора.ЗначенияСвойств.Добавить(СтруктураЗначенияСвойств);
			
			КонецЕсли;
			
		// Список значений. Представлено на форме списком значений.
		// Если список не пустой - добавим в отбор.
		ИначеЕсли Свойство.ТипСвойства = 2 Тогда
			
			Список = ЭтаФорма[Свойство.ИмяРеквизитаФормы];
			
			Если Список.Количество() > 0 Тогда
			
				СтруктураЗначенияСвойств = Новый Структура;
				СтруктураЗначенияСвойств.Вставить("Тип", Свойство.ТипСвойства);
				СтруктураЗначенияСвойств.Вставить("Свойство", Свойство.Свойство);
				СтруктураЗначенияСвойств.Вставить("СвойствоХарактеристики", Свойство.СвойствоХарактеристики);
				СтруктураЗначенияСвойств.Вставить("ДобавитьНеЗаполнено", Ложь);
				СтруктураЗначенияСвойств.Вставить("Значение", Список);
				
				ДанныеОтбора.ЗначенияСвойств.Добавить(СтруктураЗначенияСвойств);
			
			КонецЕсли;
			
		// Свойство представлено на форме интервалом.
		ИначеЕсли Свойство.ТипСвойства = 3 Тогда
			
			СтруктураЗначенияСвойств = Новый Структура;
			СтруктураЗначенияСвойств.Вставить("Тип", Свойство.ТипСвойства);
			СтруктураЗначенияСвойств.Вставить("Свойство", Свойство.Свойство);
			СтруктураЗначенияСвойств.Вставить("СвойствоХарактеристики", Свойство.СвойствоХарактеристики);
			СтруктураЗначенияСвойств.Вставить("ДобавитьНеЗаполнено", Ложь);
			СтруктураЗначенияСвойств.Вставить("Значение", 0);
			СтруктураЗначенияСвойств.Вставить("НачальноеЗначение", ЭтаФорма[Свойство.ИмяРеквизитаФормыНачальноеЗначение]);
			СтруктураЗначенияСвойств.Вставить("КонечноеЗначение", ЭтаФорма[Свойство.ИмяРеквизитаФормыКонечноеЗначение]);
			
			ДанныеОтбора.ЗначенияСвойств.Добавить(СтруктураЗначенияСвойств);
			
		// Свойство представлено на флажком.
		ИначеЕсли Свойство.ТипСвойства = 4 Тогда
			
			Если ЭтаФорма[Свойство.ИмяРеквизитаФормы] Тогда
				
				СтруктураЗначенияСвойств = Новый Структура;
				СтруктураЗначенияСвойств.Вставить("Тип", Свойство.ТипСвойства);
				СтруктураЗначенияСвойств.Вставить("Свойство", Свойство.Свойство);
				СтруктураЗначенияСвойств.Вставить("СвойствоХарактеристики", Свойство.СвойствоХарактеристики);
				СтруктураЗначенияСвойств.Вставить("ДобавитьНеЗаполнено", Ложь);
				СтруктураЗначенияСвойств.Вставить("Значение", Истина);
				
				ДанныеОтбора.ЗначенияСвойств.Добавить(СтруктураЗначенияСвойств);
				
			КонецЕсли;
			
		// Категория номенклатуры.
		ИначеЕсли Свойство.ТипСвойства = 5 Тогда
			
			Если ЭтаФорма[Свойство.ИмяРеквизитаФормы] Тогда
				ДанныеОтбораПоКатегориям.Добавить(Свойство.Свойство);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДанныеОтбораПоСвойствамВидаНоменклатуры = Новый Массив;
	Если ДанныеОтбора.ЗначенияСвойств.Количество() > 0 Тогда
		ДанныеОтбораПоСвойствамВидаНоменклатуры.Добавить(ДанныеОтбора);
	КонецЕсли;
	
	// Массив будет пустой если отбор не установлен.
	Закрыть(
		Новый Структура(
			"ОтборПоВидамНоменклатуры,
			|ОтборПоКатегориям",
			ДанныеОтбораПоСвойствамВидаНоменклатуры,
			ДанныеОтбораПоКатегориям
		)
	);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры
