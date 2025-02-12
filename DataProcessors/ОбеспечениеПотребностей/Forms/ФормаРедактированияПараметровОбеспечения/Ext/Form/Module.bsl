﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.РассчитыватьСтатистику Тогда

		ПериодКлассификации = Константы.ПериодРасчетаТоварныхОграничений.Получить();
		КоличествоПериодовКлассификации = Константы.КоличествоПериодовРасчетаТоварныхОграничений.Получить();
		Период = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(ТекущаяДатаСеанса(),
			ПериодКлассификации, - КоличествоПериодовКлассификации);
		АдресГрафикаРаботы = Обработки.ОбеспечениеПотребностей.СоздатьГрафикВХранилище(
			Период.ДатаНачала, Период.ДатаОкончания, УникальныйИдентификатор);

		ПараметрыРасчетаСтатистики = Новый Структура();
		ПараметрыРасчетаСтатистики.Вставить("ПериодКлассификацииДатаНачала", Период.ДатаНачала);
		ПараметрыРасчетаСтатистики.Вставить("ПериодКлассификацииДатаОкончания", Период.ДатаОкончания);
		ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
		ПараметрыРасчетаСтатистики.Вставить("ИспользоватьХарактеристикиНоменклатуры", ИспользоватьХарактеристикиНоменклатуры);

		СтатистикаПотребления = Обработки.ОбеспечениеПотребностей.СтатистикаПотребления(
			Параметры.КлючПотребности, ПараметрыРасчетаСтатистики, АдресГрафикаРаботы);
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СтатистикаПотребления);

		ПериодКлассификацииНачало    = ПараметрыРасчетаСтатистики.ПериодКлассификацииДатаНачала;
		ПериодКлассификацииОкончание = ПараметрыРасчетаСтатистики.ПериодКлассификацииДатаОкончания;

	ИначеЕсли ТипЗнч(Параметры.СтатистикаПотребления) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.СтатистикаПотребления);
		ПериодКлассификации = Константы.ПериодРасчетаТоварныхОграничений.Получить();
		КоличествоПериодовКлассификации = Константы.КоличествоПериодовРасчетаТоварныхОграничений.Получить();
		Период = ОбщегоНазначенияУТКлиентСервер.РасширенныйПериод(ТекущаяДатаСеанса(), ПериодКлассификации, - КоличествоПериодовКлассификации);
		ПериодКлассификацииНачало    = Период.ДатаНачала;
		ПериодКлассификацииОкончание = Период.ДатаОкончания;
		
	КонецЕсли;
	
	СпособУказанияНастройки = "";
	Если Параметры.РежимОткрытия = "Полный" ИЛИ Параметры.РежимОткрытия = "ТолькоПараметры" Тогда
		
		// Получение записи регистра Товарные ограничения.
		ЗначениеНастройки = РегистрыСведений.ТоварныеОграничения.ПараметрыПоддержанияЗапасаТовараНаСкладе(Параметры.КлючПотребности);
		СпособУказанияНастройки = ЗначениеНастройки.СпособУказанияНастройки;
		ГруппировкаТоварныхОграничений = ЗначениеНастройки.Группировка;
		МетодОбеспечения  = ЗначениеНастройки.МетодОбеспеченияПотребностей;
		МинимальныйЗапас  = ЗначениеНастройки.МинимальноеКоличествоЗапаса;
		МаксимальныйЗапас = ЗначениеНастройки.МаксимальноеКоличествоЗапаса;
		СтраховойЗапас    = ЗначениеНастройки.СтраховоеКоличествоЗапаса;
		УпаковкаЗаказа    = ЗначениеНастройки.УпаковкаЗаказа;
		ОбеспечениеЗаказовПриПоддержанииЗапаса = ЗначениеНастройки.ОбеспечениеЗаказовПриПоддержанииЗапаса;
		НормаПотребления  = ЗначениеНастройки.НормаПотребления;
		
	Иначе
		ОбеспечениеЗаказов = Перечисления.ОбеспечениеЗаказовПриПоддержанииЗапаса.ЗаСчетЗапасов;
	КонецЕсли;
	
	Если Параметры.РежимОткрытия = "Полный" Или Параметры.РежимОткрытия = "ТолькоСпособ" Тогда
		//Инициализация способа обеспечения и параметров способа обеспечения.
		ПолучитьИндивидуальныйИУнаследованныйСпособыОбеспеченияНаСервере(Параметры.КлючПотребности);
		СпособИндивидуальныйСтарый = СпособИндивидуальный;
		
		НачалоПериода = НачалоДня(ТекущаяДатаСеанса());
		ПараметрыЦиклаПоставки = СтруктураПараметровЦиклаПоставкиПоСпособуОбеспечения();
		
		Если ЗначениеЗаполнено(СпособУнаследованный) Тогда
			ПараметрыЦиклаПоставки.СпособОбеспечения = СпособУнаследованный;
			Обработки.ОбеспечениеПотребностей.ЗаполнитьРеквизитыСпособаОбеспечения(ПараметрыЦиклаПоставки, НачалоПериода, Истина);
			ПараметрыЦиклаПоставкиПоГрафикуРаботыУнаследованные = ПараметрыЦиклаПоставкиПоГрафикуРаботы(
				Параметры.КлючПотребности, ПараметрыЦиклаПоставки, НачалоПериода);
		Иначе
			ПараметрыЦиклаПоставкиПоГрафикуРаботыУнаследованные = СтруктураПараметровЦиклаПоставкиПоГрафикуРаботы();
		КонецЕсли;
			
		Если ЗначениеЗаполнено(СпособИндивидуальный) Тогда
			ПараметрыЦиклаПоставки.СпособОбеспечения = СпособИндивидуальный;
			Обработки.ОбеспечениеПотребностей.ЗаполнитьРеквизитыСпособаОбеспечения(ПараметрыЦиклаПоставки, НачалоПериода, Истина);
			ПараметрыЦиклаПоставкиПоГрафикуРаботыИндивидуальные = ПараметрыЦиклаПоставкиПоГрафикуРаботы(
				Параметры.КлючПотребности, ПараметрыЦиклаПоставки, НачалоПериода);
		Иначе
			ПараметрыЦиклаПоставкиПоГрафикуРаботыИндивидуальные = СтруктураПараметровЦиклаПоставкиПоГрафикуРаботы();
		КонецЕсли;
		
		ПереключательСпособа = ?(ЗначениеЗаполнено(СпособИндивидуальный), 1, 0);
	КонецЕсли;
	
	Если ТипЗнч(Параметры.КлючПотребности) = Тип("Структура")
		И Параметры.КлючПотребности.Свойство("Номенклатура") Тогда
		
		Номенклатура = Параметры.КлючПотребности.Номенклатура;
		ЕдиницаИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Номенклатура, "ЕдиницаИзмерения");
		
	КонецЕсли;
	
	Если Параметры.РежимОткрытия = "ТолькоМетод" Тогда
		
		МетодОбеспечения = Параметры.КлючПотребности.МетодОбеспечения;
		
	КонецЕсли;
	
	// Настройка интерфейса формы.
	
	НастройкаУказанаДляГруппы = СпособУказанияНастройки = "ДЛЯ_ГРУППЫ_ТОВАРОВ"
		Или СпособУказанияНастройки = "ДЛЯ_ХАРАКТЕРИСТИК_ТОВАРА";
	
	Если Параметры.РежимОткрытия = "ТолькоПараметры" 
		И ((СпособУказанияНастройки = "ДЛЯ_ГРУППЫ_ТОВАРОВ" И НЕ ЗначениеЗаполнено(Параметры.КлючПотребности.Номенклатура))
			ИЛИ (СпособУказанияНастройки = "ДЛЯ_ХАРАКТЕРИСТИК_ТОВАРА" И НЕ ЗначениеЗаполнено(Параметры.КлючПотребности.Характеристика))) Тогда
			Элементы.ГруппаПредупреждениеОЗапретеРедактированияПараметров.Видимость	= Ложь;
			Элементы.ГруппаМетодОбеспечения.Доступность								= Истина;
		Иначе
			Элементы.ГруппаПредупреждениеОЗапретеРедактированияПараметров.Видимость	= НастройкаУказанаДляГруппы;
			Элементы.ГруппаМетодОбеспечения.Доступность								= Не НастройкаУказанаДляГруппы;
	КонецЕсли;
	Если СпособУказанияНастройки = "ДЛЯ_ГРУППЫ_ТОВАРОВ" Тогда
		
		ШаблонТекста = НСтр("ru = 'Используются метод и параметры обеспечения, установленные для группы: %1'");
		Элементы.КартинкаРедактированиеПараметровНедоступно.РасширеннаяПодсказка.Заголовок =
			СтрШаблон(ШаблонТекста, ГруппировкаТоварныхОграничений);
		
	ИначеЕсли СпособУказанияНастройки = "ДЛЯ_ХАРАКТЕРИСТИК_ТОВАРА" Тогда
		
		ШаблонТекста = НСтр("ru = 'Используются метод и параметры обеспечения, установленные в целом для номенклатуры: %1'");
		Элементы.КартинкаРедактированиеПараметровНедоступно.РасширеннаяПодсказка.Заголовок =
			СтрШаблон(ШаблонТекста, Параметры.КлючПотребности.Номенклатура);
		
	КонецЕсли;
	
	Если Параметры.РежимОткрытия = "Полный" ИЛИ Параметры.РежимОткрытия = "ТолькоСпособ" 
		ИЛИ Параметры.РежимОткрытия = "ТолькоПараметры" Тогда
		//1) Установка заголовка формы.
		Если Параметры.КлючПотребности.Свойство("Группировка") Тогда
			Элементы.КлючПотребностиСтрокой.Заголовок = 
				СтрШаблон(НСтр("ru = 'Группировка: %1.'"),Параметры.КлючПотребности.Группировка);
		Иначе
			ТекстХарактеристика = ?(ЗначениеЗаполнено(Параметры.КлючПотребности.Характеристика),
				СтрШаблон(НСтр("ru = ', Характеристика: %1'"), Параметры.КлючПотребности.Характеристика), "");
			ТекстСклад = ?(Параметры.КлючПотребности.ЭтоРабота, "",
				СтрШаблон(НСтр("ru = ', Склад: %1'"), Параметры.КлючПотребности.Склад));
			
			Элементы.КлючПотребностиСтрокой.Заголовок = СтрШаблон(НСтр("ru = 'Номенклатура: %1%2%3.'"),
				Параметры.КлючПотребности.Номенклатура, ТекстХарактеристика, ТекстСклад);
		КонецЕсли;
			
		//2) Заполнение списка переключателей способа обеспечения.
		Если Параметры.РежимОткрытия <> "ТолькоПараметры" Тогда
			Элементы.ПереключательСпособаУнаследованный.СписокВыбора[0].Представление =
				?(Не ЗначениеЗаполнено(СпособУнаследованный),
					НСтр("ru = 'Не использовать (задавать параметры обеспечения в процессе формирования заказа)'"),
					СтрШаблон(НСтр("ru = '""%1"" (настроенный для схемы обеспечения номенклатуры)'"), СпособУнаследованный));
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.РежимОткрытия = "Полный" Тогда
		
		Элементы.ОкОтмена.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Параметры обеспечения потребностей'");
		
	ИначеЕсли Параметры.РежимОткрытия = "ТолькоПараметры" Тогда
		
		Элементы.ОкОтмена.Видимость = Ложь;
		Элементы.ГруппаСпособОбеспечения.Видимость = Ложь;
		Элементы.ПереключательЗаказПодЗаказ.Видимость = Ложь;
		Элементы.ПодсказкаЗаказПодЗаказ.Видимость     = Ложь;
		
		Заголовок = НСтр("ru = 'Параметры поддержания запаса'");
		
	ИначеЕсли Параметры.РежимОткрытия = "ТолькоСпособ" Тогда
		
		Элементы.ОкОтмена.Видимость = Ложь;
		Элементы.ГруппаМетодОбеспечения.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Параметры обеспечения потребностей'");
		
	ИначеЕсли Параметры.РежимОткрытия = "ТолькоМетод" Тогда
		
		ОбеспечениеЗаказовПриПоддержанииЗапаса = Перечисления.ОбеспечениеЗаказовПриПоддержанииЗапаса.ЗаСчетЗапасов;
		Элементы.КлючПотребностиСтрокой.Видимость   = Ложь;
		Элементы.ГруппаСпособОбеспечения.Видимость  = Ложь;
		Элементы.СпособОбеспеченияСтрокой.Видимость = Ложь;
		
		Элементы.ПереключательЗаказПодЗаказ.Видимость = Ложь;
		Элементы.ПодсказкаЗаказПодЗаказ.Видимость     = Ложь;
		
		Если Не ЗначениеЗаполнено(Номенклатура) Тогда
			Элементы.ЕдиницаИзмерения.Видимость      = Ложь;
			Элементы.ЕдиницаИзмеренияМин.Видимость   = Ложь;
			Элементы.ЕдиницаИзмеренияМакс.Видимость  = Ложь;
			Элементы.ЕдиницаИзмеренияСтрах.Видимость = Ложь;
		КонецЕсли;
		
		Элементы.ЗаписатьЗакрыть.Видимость          = Ложь;
		Элементы.Ок.КнопкаПоУмолчанию               = Истина;
		
		Заголовок = НСтр("ru = 'Параметры поддержания запаса'");
		
	КонецЕсли;
	
	ИспользоватьУпаковки = Параметры.РежимОткрытия = "Полный"
		И ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	Если Не ИспользоватьУпаковки Тогда
		Элементы.УпаковкаЗаказаЗаголовок.Видимость = Ложь;
		Элементы.СтраницыУпаковкаЗначения.Видимость = Ложь;
	КонецЕсли;
	
	ПраваДоступа = ОбеспечениеСервер.ПраваДоступаНаЗаписьСпособаИлиМетода();
	МассивИменЭлементов = Новый Массив();
	Если Не ПраваДоступа.ВариантыОбеспечения Тогда
		МассивИменЭлементов.Добавить("ГруппаСпособОбеспечения");
	КонецЕсли;
	
	Если Не ПраваДоступа.ТоварныеОграничения Тогда
		МассивИменЭлементов.Добавить("ГруппаМетодОбеспечения");
	КонецЕсли;
	
	Если Не ПраваДоступа.ВариантыОбеспечения И Не ПраваДоступа.ТоварныеОграничения Тогда
		МассивИменЭлементов.Добавить("ФормаЗаписатьИЗакрыть");
		МассивИменЭлементов.Добавить("ФормаЗаписать");
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивИменЭлементов, "Доступность", Ложь);
	
	ЦветОшибки = Метаданные.ЭлементыСтиля.ПоясняющийОшибкуТекст.Значение;
	ЦветПоясняющейНадписи = Метаданные.ЭлементыСтиля.ПоясняющийТекст.Значение;
	ЦветИзСтиля = Элементы.МинимальныйЗапасСтрокой.ЦветТекста;

	ЗакрыватьПриВыборе = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриПереключенииСпособаОбеспечения();
	ПриПереключенииМетодаОбеспечения();
	РассчитатьЗапасы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НормаПотребленияПриИзменении(Элемент)
	РассчитатьЗапасы();
КонецПроцедуры

&НаКлиенте
Процедура СпособИндивидуальныйПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(СпособИндивидуальный)Тогда
		НачалоПериода = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
		ПараметрыЦиклаПоставки = СтруктураПараметровЦиклаПоставкиПоСпособуОбеспечения();
		ПараметрыЦиклаПоставки.СпособОбеспечения = СпособИндивидуальный;
		
		ПараметрыЦиклаПоставкиПоГрафикуРаботыИндивидуальные = ПараметрыЦиклаПоставкиПоГрафикуРаботыВызовСервера(
			Параметры.КлючПотребности, ПараметрыЦиклаПоставки, НачалоПериода)
	Иначе
		ПараметрыЦиклаПоставкиПоГрафикуРаботыИндивидуальные = СтруктураПараметровЦиклаПоставкиПоГрафикуРаботы();
	КонецЕсли;
	
	ПриПереключенииСпособаОбеспечения();
	РассчитатьЗапасы();

КонецПроцедуры

&НаКлиенте
Процедура ПереключательЗаказПодЗаказПриИзменении(Элемент)
	МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ЗаказПодЗаказ");
	ПриПереключенииМетодаОбеспечения();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательМинМаксПриИзменении(Элемент)
	МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаМинМакс");
	ПриПереключенииМетодаОбеспечения();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательНаСрокПоНормеПриИзменении(Элемент)
	МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаНаСрокПоНорме");
	ПриПереключенииМетодаОбеспечения();
	РассчитатьЗапасы();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательНаСрокПоСтатистикеПриИзменении(Элемент)
	МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаНаСрокПоСтатистике");
	ПриПереключенииМетодаОбеспечения();
	РассчитатьЗапасы();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательСпособаУнаследованныйПриИзменении(Элемент)
	ПереключательСпособа = 0;
	ПриПереключенииСпособаОбеспечения();
	РассчитатьЗапасы();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательСпособаИндивидуальныйПриИзменении(Элемент)
	ПереключательСпособа = 1;
	ПриПереключенииСпособаОбеспечения();
	РассчитатьЗапасы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)

	Если ЗаписатьНаКлиенте() Тогда
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	Если НЕ ЗначениеЗаполнено(МетодОбеспечения) ИЛИ
		МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ЗаказПодЗаказ") Тогда
		ТекстСообщения = НСтр("ru = 'Не указан метод обеспечения потребностей'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,"МетодОбеспечения");
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = Новый Структура;
	ВыбранноеЗначение.Вставить("МетодОбеспеченияПотребностей",			МетодОбеспечения);
	ВыбранноеЗначение.Вставить("МинимальноеКоличествоЗапаса",			МинимальныйЗапас);
	ВыбранноеЗначение.Вставить("МаксимальноеКоличествоЗапаса",			МаксимальныйЗапас);
	ВыбранноеЗначение.Вставить("СтраховоеКоличествоЗапаса",				СтраховойЗапас);
	ВыбранноеЗначение.Вставить("НормаПотребления",						НормаПотребления);
	ВыбранноеЗначение.Вставить("ОбеспечениеЗаказовПриПоддержанииЗапаса",ОбеспечениеЗаказовПриПоддержанииЗапаса);
	
	ОповеститьОВыборе(ВыбранноеЗначение);
	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьИндивидуальныйИУнаследованныйСпособыОбеспеченияНаСервере(КлючПотребности)
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	&Номенклатура   КАК Номенклатура,
		|	&Характеристика КАК Характеристика,
		|	&Склад          КАК Склад
		|ПОМЕСТИТЬ ВтТовары
		|;
		|
		|//////////////////////////////////////
		|" + РегистрыСведений.СхемыОбеспечения.ВременнаяТаблицаСпособыОбеспечения("ВЫЧИСЛЯТЬ")
		+ "ВЫБРАТЬ
		|Таблица.СпособОбеспеченияПотребностей               КАК СпособОбеспеченияПотребностей,
		|Таблица.СпособОбеспеченияПотребностейУнаследованный КАК СпособОбеспеченияПотребностейУнаследованный,
		|Таблица.ИсточникНастройки                           КАК ИсточникНастройки
		|ИЗ
		|	ВтСпособыОбеспечения КАК Таблица";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Склад",          КлючПотребности.Склад);
	Запрос.УстановитьПараметр("Номенклатура",   КлючПотребности.Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", КлючПотребности.Характеристика);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		Если Выборка.ИсточникНастройки = "НоменклатураХарактеристикаСклад" Тогда
			
			СпособИндивидуальный = Выборка.СпособОбеспеченияПотребностей;
			
		КонецЕсли;
		СпособУнаследованный = Выборка.СпособОбеспеченияПотребностейУнаследованный;
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыЦиклаПоставкиПоГрафикуРаботы(КлючПотребности, ПараметрыЦиклаПоставки, НачалоПериода)
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&СпособОбеспечения    КАК СпособОбеспечения,
	|	&Склад                КАК Склад,
	|	&Номенклатура         КАК Номенклатура,
	|	NULL                  КАК Характеристика,
	|	NULL                  КАК Назначение,
	|	NULL                  КАК Подразделение
	|ПОМЕСТИТЬ Товары
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&СпособОбеспечения             КАК СпособОбеспечения,
	|	&ДатаПоставки                  КАК ДатаПоставки,
	|	&ДатаСледующейПоставки         КАК ДатаСледующейПоставки,
	|	&ПлановаяДатаЗаказа            КАК ПлановаяДатаЗаказа,
	|	&ОбеспечиваемыйПериод          КАК ОбеспечиваемыйПериод,
	|	&СрокИсполненияЗаказа          КАК СрокИсполненияЗаказа,
	|	&ФормироватьПлановыеЗаказы     КАК ФормироватьПлановыеЗаказы,
	|	&НаступилаДатаОчередногоЗаказа КАК НаступилаДатаОчередногоЗаказа
	|ПОМЕСТИТЬ СпособыОбеспечения
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|"
	+ Обработки.ОбеспечениеПотребностей.СформироватьТекстЗапросаПорядкаОбеспечения() +
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	ПорядокОбеспечения";
	
	Запрос.УстановитьПараметр("Склад",         КлючПотребности.Склад);
	Запрос.УстановитьПараметр("Номенклатура",  КлючПотребности.Номенклатура);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	
	Запрос.УстановитьПараметр("СпособОбеспечения"            , ПараметрыЦиклаПоставки.СпособОбеспечения);
	Запрос.УстановитьПараметр("ДатаПоставки"                 , ПараметрыЦиклаПоставки.ДатаПоставки);
	Запрос.УстановитьПараметр("ДатаСледующейПоставки"        , ПараметрыЦиклаПоставки.ДатаСледующейПоставки);
	Запрос.УстановитьПараметр("ПлановаяДатаЗаказа"           , ПараметрыЦиклаПоставки.ПлановаяДатаЗаказа);
	Запрос.УстановитьПараметр("ОбеспечиваемыйПериод"         , ПараметрыЦиклаПоставки.ОбеспечиваемыйПериод);
	Запрос.УстановитьПараметр("СрокИсполненияЗаказа"         , ПараметрыЦиклаПоставки.СрокИсполненияЗаказа);
	Запрос.УстановитьПараметр("ФормироватьПлановыеЗаказы"    , ПараметрыЦиклаПоставки.ФормироватьПлановыеЗаказы);
	Запрос.УстановитьПараметр("НаступилаДатаОчередногоЗаказа", ПараметрыЦиклаПоставки.ФормироватьПлановыеЗаказы);
	
	Результат = СтруктураПараметровЦиклаПоставкиПоГрафикуРаботы();
	ЗаполнитьЗначенияСвойств(Результат, ПараметрыЦиклаПоставки);// копируем ошибки из структуры "ПараметрыЦиклаПоставки".
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(Результат, Выборка);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПараметрыЦиклаПоставкиОсновногоСпособаОбеспечения()
	
	Возврат ?(ПереключательСпособа = 1, ПараметрыЦиклаПоставкиПоГрафикуРаботыИндивидуальные,
			                            ПараметрыЦиклаПоставкиПоГрафикуРаботыУнаследованные);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураПараметровЦиклаПоставкиПоСпособуОбеспечения()
	
	СтруктураПараметров = Новый Структура();
	
	СтруктураПараметров.Вставить("СпособОбеспечения",                Неопределено);
	СтруктураПараметров.Вставить("ДатаПоставки",                     '00010101');
	СтруктураПараметров.Вставить("ДатаСледующейПоставки",            '00010101');
	СтруктураПараметров.Вставить("ОбеспечиваемыйПериод",             0);
	СтруктураПараметров.Вставить("СрокИсполненияЗаказа",             0);
	СтруктураПараметров.Вставить("ПлановаяДатаЗаказа",               '00010101');
	СтруктураПараметров.Вставить("ФормироватьПлановыеЗаказы",        Ложь);
	СтруктураПараметров.Вставить("НаступилаДатаОчередногоЗаказа",    Ложь);
	СтруктураПараметров.Вставить("НетГрафикаПоставок",               Ложь);
	СтруктураПараметров.Вставить("НетПлановойДатыЗаказаПоКалендарю", Ложь);
	СтруктураПараметров.Вставить("НетДатыПоставкиПоКалендарю",       Ложь);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураПараметровЦиклаПоставкиПоГрафикуРаботы()
	
	СтруктураПараметров = Новый Структура();
	
	СтруктураПараметров.Вставить("СрокИсполненияЗаказа",                       0);
	СтруктураПараметров.Вставить("ОбеспечиваемыйПериод",                       0);
	СтруктураПараметров.Вставить("НетГрафикаПоставок",                         Ложь);
	СтруктураПараметров.Вставить("НетПлановойДатыЗаказаПоКалендарю",           Ложь);
	СтруктураПараметров.Вставить("НетДатыПоставкиПоКалендарю",                 Ложь);
	СтруктураПараметров.Вставить("НетСрокаПоставкиПоКалендарюСклада",          Ложь);
	СтруктураПараметров.Вставить("НетОбеспечиваемогоПериодаПоКалендарюСклада", Ложь);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЕстьОшибкиЦиклаПоставки(ПараметрыЦиклаПоставки)
	
	Возврат ПараметрыЦиклаПоставки.НетГрафикаПоставок
			Или ПараметрыЦиклаПоставки.НетПлановойДатыЗаказаПоКалендарю
			Или ПараметрыЦиклаПоставки.НетДатыПоставкиПоКалендарю
			Или (ПараметрыЦиклаПоставки.Свойство("НетСрокаПоставкиПоКалендарюСклада")
				И (ПараметрыЦиклаПоставки.НетСрокаПоставкиПоКалендарюСклада
					Или ПараметрыЦиклаПоставки.НетОбеспечиваемогоПериодаПоКалендарюСклада));
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстОшибкиЦиклаПоставки(ПараметрыЦиклаПоставки)
	
	Возврат ?(ПараметрыЦиклаПоставки.НетГрафикаПоставок, НСтр("ru = 'Ошибка. Нет графика поставок по способу обеспечения'"),
			?(ПараметрыЦиклаПоставки.НетПлановойДатыЗаказаПоКалендарю
				Или ПараметрыЦиклаПоставки.НетДатыПоставкиПоКалендарю,
					НСтр("ru = 'Ошибка расчета даты поставки по способу обеспечения. Заполните календарь предприятия'"),
			?(ПараметрыЦиклаПоставки.Свойство("НетСрокаПоставкиПоКалендарюСклада")
				И (ПараметрыЦиклаПоставки.НетСрокаПоставкиПоКалендарюСклада
					Или ПараметрыЦиклаПоставки.НетОбеспечиваемогоПериодаПоКалендарюСклада),
						НСтр("ru = 'Ошибка расчета даты поставки по способу обеспечения. Заполните календарь работы склада'"), "")));
	
КонецФункции

&НаКлиенте
Функция ФормаЗаполненаВерно()
	
	Если ПереключательСпособа = 1 И Не ЗначениеЗаполнено(СпособИндивидуальный) Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Укажите способ обеспечения'"),,, "СпособИндивидуальный",);
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ЗаписатьНаКлиенте(НеПроверятьЗаполнение = Ложь)

	Если Не НеПроверятьЗаполнение И Не ФормаЗаполненаВерно() Тогда
		Возврат Ложь;
	КонецЕсли;
	ЗаписатьНаСервере();
	Если Параметры.РежимОткрытия <> "ТолькоПараметры" Тогда
		ВыбранноеЗначение = Новый Структура("СпособОбеспечения",
			?(ПереключательСпособа = 1, СпособИндивидуальный, СпособУнаследованный));
		
	Иначе
		ВыбранноеЗначение = "ПараметрЗаписан";
	КонецЕсли;
	ОповеститьОВыборе(ВыбранноеЗначение);
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПриПереключенииСпособаОбеспечения()
	
	Если Параметры.РежимОткрытия = "ТолькоМетод" ИЛИ Параметры.РежимОткрытия = "ТолькоПараметры" Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.СтраницыИндивидуальныйСпособ.ТекущаяСтраница = ?(ПереключательСпособа = 1,
		Элементы.СтраницаИспользоватьСпособ,
		Элементы.СтраницаНеИспользоватьСпособ);
		
	Сроки = ПараметрыЦиклаПоставкиОсновногоСпособаОбеспечения();
	
	СпособОбеспеченияСтрокой =
		?(ПереключательСпособа = 1 И Не ЗначениеЗаполнено(СпособИндивидуальный), "",
		?(ЕстьОшибкиЦиклаПоставки(Сроки), ТекстОшибкиЦиклаПоставки(Сроки), 
		?(Сроки.СрокИсполненияЗаказа > 0 И Сроки.ОбеспечиваемыйПериод > 0, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ближайшее поступление (пополнение запаса) ожидается через %1 дн и обеспечивает период %2 дн.'"),
			Сроки.СрокИсполненияЗаказа,
			Сроки.ОбеспечиваемыйПериод),
		?(Сроки.СрокИсполненияЗаказа = 0 И Сроки.ОбеспечиваемыйПериод = 0,
			НСтр("ru = 'Поступление (пополнение запаса) возможно в любой день, обеспечиваемый период не ограничен.'"),
		?(Сроки.СрокИсполненияЗаказа > 0 И Сроки.ОбеспечиваемыйПериод = 0, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ближайшее поступление (пополнение запаса) ожидается через %1 дн, обеспечиваемый период не ограничен.'"),
				Сроки.СрокИсполненияЗаказа),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Поступление (пополнение запаса) возможно в любой день и обеспечивает период %1 дн.'"),
			Сроки.ОбеспечиваемыйПериод))))));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПереключенииМетодаОбеспечения()
	
	Если Параметры.РежимОткрытия = "ТолькоСпособ" Тогда
		Возврат;
	КонецЕсли;
	
	ПереключательЗаказПодЗаказ      = 0;
	ПереключательМинМакс            = 0;
	ПереключательНаСрокПоНорме      = 0;
	ПереключательНаСрокПоСтатистике = 0;
	
	Если МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ЗаказПодЗаказ") Тогда
		ПереключательЗаказПодЗаказ = 1;
	ИначеЕсли МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаМинМакс") Тогда
		ПереключательМинМакс = 1;
	ИначеЕсли МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаНаСрокПоНорме") Тогда
		ПереключательНаСрокПоНорме = 1;
	Иначе
		//Отрабатываем Метод обеспечения = "ПоддержаниеЗапасаНаСрокПоСтатистике".
		ПереключательНаСрокПоСтатистике = 1;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ОбеспечениеЗаказовПриПоддержанииЗапаса) Тогда
		ОбеспечениеЗаказовПриПоддержанииЗапаса = ПредопределенноеЗначение("Перечисление.ОбеспечениеЗаказовПриПоддержанииЗапаса.ЗаСчетЗапасов");
	КонецЕсли;

	//Настраиваем видимость параметров поддержания запаса.
	Если МетодОбеспечения
		= ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ЗаказПодЗаказ") Тогда
		
		Элементы.СтраницыНормаСреднедневноеЗаголовок.ТекущаяСтраница = Элементы.СтраницаНормаПотребленияЗаголовок;
		Элементы.СтраницыНормаЗначения.ТекущаяСтраница      = Элементы.СтраницаНормаНеИспользуется;
		Элементы.СтраницыМинЗапасЗначения.ТекущаяСтраница   = Элементы.СтраницаМинЗапасНеИспользуется;
		Элементы.СтраницыМаксЗапасЗначения.ТекущаяСтраница  = Элементы.СтраницаМаксЗапасНеИспользуется;
		Элементы.СтраницыСтрахЗапасЗначения.ТекущаяСтраница = Элементы.СтраницаСтрахЗапасНеИспользуется;
		Элементы.СтраницыУчетЗаказов.ТекущаяСтраница        = Элементы.СтраницаУчетЗаказовНеИспользуется;
		
	ИначеЕсли МетодОбеспечения
		= ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаМинМакс") Тогда
		
		Элементы.СтраницыНормаСреднедневноеЗаголовок.ТекущаяСтраница = Элементы.СтраницаНормаПотребленияЗаголовок;
		Элементы.СтраницыНормаЗначения.ТекущаяСтраница      = Элементы.СтраницаНормаНеИспользуется;
		Элементы.СтраницыМинЗапасЗначения.ТекущаяСтраница   = Элементы.СтраницаМинЗапас;
		Элементы.СтраницыМаксЗапасЗначения.ТекущаяСтраница  = Элементы.СтраницаМаксЗапас;
		Элементы.СтраницыСтрахЗапасЗначения.ТекущаяСтраница = Элементы.СтраницаСтрахЗапасНеИспользуется;
		Элементы.СтраницыУчетЗаказов.ТекущаяСтраница        = Элементы.СтраницаУчетЗаказов;
		
	ИначеЕсли МетодОбеспечения
		= ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаНаСрокПоНорме") Тогда
		
		Элементы.СтраницыНормаСреднедневноеЗаголовок.ТекущаяСтраница = Элементы.СтраницаНормаПотребленияЗаголовок;
		Элементы.СтраницыНормаЗначения.ТекущаяСтраница      = Элементы.СтраницаНорма;
		Элементы.СтраницыМинЗапасЗначения.ТекущаяСтраница   = Элементы.СтраницаМинЗапасСтрокой;
		Элементы.СтраницыМаксЗапасЗначения.ТекущаяСтраница  = Элементы.СтраницаМаксЗапасСтрокой;
		Элементы.СтраницыСтрахЗапасЗначения.ТекущаяСтраница = Элементы.СтраницаСтрахЗапас;
		Элементы.СтраницыУчетЗаказов.ТекущаяСтраница        = Элементы.СтраницаУчетЗаказов;
		
	ИначеЕсли МетодОбеспечения
		= ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаНаСрокПоСтатистике") Тогда
		
		Элементы.СтраницыНормаСреднедневноеЗаголовок.ТекущаяСтраница = Элементы.СтраницаСреднедневноеПотреблениеЗаголовок;
		Элементы.СтраницыНормаЗначения.ТекущаяСтраница      = Элементы.СтраницаСреднедневноеПотреблениеСтрокой;
		Элементы.СтраницыМинЗапасЗначения.ТекущаяСтраница   = Элементы.СтраницаМинЗапасСтрокой;
		Элементы.СтраницыМаксЗапасЗначения.ТекущаяСтраница  = Элементы.СтраницаМаксЗапасСтрокой;
		Элементы.СтраницыСтрахЗапасЗначения.ТекущаяСтраница = Элементы.СтраницаСтрахЗапас;
		Элементы.СтраницыУчетЗаказов.ТекущаяСтраница        = Элементы.СтраницаУчетЗаказов;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Номенклатура) Тогда
		Элементы.СтраницыУпаковкаЗначения.ТекущаяСтраница = Элементы.СтраницаУпаковкаСтрокой;
	Иначе
		Элементы.СтраницыУпаковкаЗначения.ТекущаяСтраница = Элементы.СтраницаУпаковка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьЗапасы()
	
	РассчитываетсяИндивидуально = НСтр("ru = 'индивидуальный расчет для номенклатуры'");
	ОшибкаРасчетаЦиклПоставки   = НСтр("ru = 'ошибка расчета (нет данных графика поставок)'");
	
	Если Параметры.РежимОткрытия = "ТолькоМетод" ИЛИ Параметры.РежимОткрытия = "ТолькоПараметры" Тогда
		МинимальныйЗапасСтрокой = РассчитываетсяИндивидуально;
		МаксимальныйЗапасСтрокой = РассчитываетсяИндивидуально;
		СреднедневноеПотреблениеСтрокой = РассчитываетсяИндивидуально;
		Элементы.МинимальныйЗапасСтрокой.ЦветТекста = ЦветПоясняющейНадписи;
		Элементы.МаксимальныйЗапасСтрокой.ЦветТекста = ЦветПоясняющейНадписи;
		Элементы.СреднедневноеПотреблениеСтрокой.ЦветТекста = ЦветПоясняющейНадписи;
		
		Возврат;
	КонецЕсли;
	
	Сроки = ПараметрыЦиклаПоставкиОсновногоСпособаОбеспечения();
	ЕстьОшибкиЦиклаПоставки = ЕстьОшибкиЦиклаПоставки(Сроки);
	
	Если МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаНаСрокПоНорме") Тогда
		
		Если Не ЕстьОшибкиЦиклаПоставки Тогда
			МинимальныйЗапасРасчетный  = Сроки.СрокИсполненияЗаказа * НормаПотребления;
			МаксимальныйЗапасРасчетный = Сроки.ОбеспечиваемыйПериод * НормаПотребления;
		Иначе
			МинимальныйЗапасРасчетный  = 0;
			МаксимальныйЗапасРасчетный = 0;
		КонецЕсли;
		
		МинимальныйЗапасСтрокой =
			?(ЕстьОшибкиЦиклаПоставки, ОшибкаРасчетаЦиклПоставки,
			
			?(НормаПотребления = 0,
				НСтр("ru = 'задайте норму потребления'"),
			
			?(Сроки.СрокИсполненияЗаказа = 0, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '0.000 %1 (на 0 дн)'"),
				ЕдиницаИзмерения),
					
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 %2 (на %3 дн)'"),
				Формат(МинимальныйЗапасРасчетный, "ЧДЦ=3"),
				ЕдиницаИзмерения,
				Сроки.СрокИсполненияЗаказа))));
		
		МаксимальныйЗапасСтрокой =
			?(ЕстьОшибкиЦиклаПоставки, ОшибкаРасчетаЦиклПоставки,
		
			?(НормаПотребления = 0,
				НСтр("ru = 'задайте норму потребления'"),
				
			?(Сроки.ОбеспечиваемыйПериод = 0,
				НСтр("ru = 'задайте обеспечиваемый период'"),
					
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 %2 (на %3 дн)'"),
				Формат(МаксимальныйЗапасРасчетный, "ЧДЦ=3"),
				ЕдиницаИзмерения,
				Сроки.ОбеспечиваемыйПериод))));
		
		Элементы.МинимальныйЗапасСтрокой.ЦветТекста = ?(ЕстьОшибкиЦиклаПоставки Или НормаПотребления = 0,
			ЦветОшибки, ЦветИзСтиля);
			
		Элементы.МаксимальныйЗапасСтрокой.ЦветТекста = ?(ЕстьОшибкиЦиклаПоставки Или НормаПотребления = 0
			Или Сроки.ОбеспечиваемыйПериод = 0,
			ЦветОшибки, ЦветИзСтиля);
		
	ИначеЕсли МетодОбеспечения = ПредопределенноеЗначение("Перечисление.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаНаСрокПоСтатистике") Тогда
		
		Если Не ЕстьОшибкиЦиклаПоставки Тогда
			МинимальныйЗапасРасчетный  = Сроки.СрокИсполненияЗаказа    * СреднедневноеПотребление;
			МаксимальныйЗапасРасчетный = Сроки.ОбеспечиваемыйПериод    * СреднедневноеПотребление;
		Иначе
			МинимальныйЗапасРасчетный  = 0;
			МаксимальныйЗапасРасчетный = 0;
		КонецЕсли;
		
		МинимальныйЗапасСтрокой =
			?(ЕстьОшибкиЦиклаПоставки, ОшибкаРасчетаЦиклПоставки,
			
			?(СреднедневноеПотребление = 0,
				НСтр("ru = 'нет потребления по статистике'"),
			
			?(Сроки.СрокИсполненияЗаказа = 0, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '0.000 %1 (на 0 дн)'"),
				ЕдиницаИзмерения),
				
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 %2 (на %3 дн)'"),
				Формат(МинимальныйЗапасРасчетный, "ЧДЦ=3"),
				ЕдиницаИзмерения,
				Сроки.СрокИсполненияЗаказа))));
		
		МаксимальныйЗапасСтрокой =
			?(ЕстьОшибкиЦиклаПоставки, ОшибкаРасчетаЦиклПоставки,
			
			?(СреднедневноеПотребление = 0,
				НСтр("ru = 'нет потребления по статистике'"),
				
			?(Сроки.ОбеспечиваемыйПериод = 0,
				НСтр("ru = 'задайте обеспечиваемый период'"),
				
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 %2 (на %3 дн)'"),
				Формат(МаксимальныйЗапасРасчетный, "ЧДЦ=3"),
				ЕдиницаИзмерения,
				Сроки.ОбеспечиваемыйПериод))));
		
		СреднедневноеПотреблениеСтрокой =
			?(ЕстьОшибкиЦиклаПоставки, ОшибкаРасчетаЦиклПоставки,
			
			?(СреднедневноеПотребление = 0, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'нет статистики за %1 - %2'"),
				Формат(ПериодКлассификацииНачало,    "ДЛФ=D"),
				Формат(ПериодКлассификацииОкончание, "ДЛФ=D")),
				
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (+/- %2) %3 (статистика за %4 - %5)'"),
				Формат(СреднедневноеПотребление, "ЧДЦ=3"),
				Формат(СреднееОтклонение, "ЧДЦ=3; ЧН=0.000"),
				ЕдиницаИзмерения,
				Формат(ПериодКлассификацииНачало,    "ДЛФ=D"),
				Формат(ПериодКлассификацииОкончание, "ДЛФ=D"))));
		
		Элементы.МинимальныйЗапасСтрокой.ЦветТекста = ?(ЕстьОшибкиЦиклаПоставки Или СреднедневноеПотребление = 0,
			ЦветОшибки, ЦветИзСтиля);
			
		Элементы.МаксимальныйЗапасСтрокой.ЦветТекста = ?(ЕстьОшибкиЦиклаПоставки Или СреднедневноеПотребление = 0
			Или Сроки.ОбеспечиваемыйПериод = 0,
			ЦветОшибки, ЦветИзСтиля);
			
		Элементы.СреднедневноеПотреблениеСтрокой.ЦветТекста = ?(СреднедневноеПотребление = 0,
			ЦветОшибки, ЦветИзСтиля);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	ПраваДоступа = ОбеспечениеСервер.ПраваДоступаНаЗаписьСпособаИлиМетода();
	Если Параметры.РежимОткрытия <> "ТолькоПараметры"
		И (СпособУказанияНастройки = "ДЛЯ_ХАРАКТЕРИСТИК_ТОВАРА" Или СпособУказанияНастройки = "ДЛЯ_ГРУППЫ_ТОВАРОВ") Тогда
		ПраваДоступа.ТоварныеОграничения = Ложь;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
	
		Если ПраваДоступа.ТоварныеОграничения Тогда
			//Запись товарного ограничения.
			Если Параметры.КлючПотребности.Свойство("Группировка") И 
				ЗначениеЗаполнено(Параметры.КлючПотребности.Группировка) Тогда
				КлючЗаписи = РегистрыСведений.ТоварныеОграничения.КлючЗаписиГруппировки();
			ИначеЕсли ЗначениеЗаполнено(Параметры.КлючПотребности.Характеристика) Тогда
				КлючЗаписи = РегистрыСведений.ТоварныеОграничения.КлючЗаписиХарактеристики();
			Иначе
				КлючЗаписи = РегистрыСведений.ТоварныеОграничения.КлючЗаписиНоменклатуры();
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(КлючЗаписи, Параметры.КлючПотребности);
			Если Параметры.РежимОткрытия = "Полный" Тогда
				Если МетодОбеспечения = Перечисления.МетодыОбеспеченияПотребностей.ЗаказПодЗаказ Тогда
					РегистрыСведений.ТоварныеОграничения.УдалитьПоддержаниеЗапаса(КлючЗаписи);
				КонецЕсли;
				РегистрыСведений.ТоварныеОграничения.ЗадатьУпаковкуТовара(Параметры.КлючПотребности.Номенклатура,
					Параметры.КлючПотребности.Характеристика, Параметры.КлючПотребности.Склад, УпаковкаЗаказа);
			КонецЕсли;
			Если МетодОбеспечения = Перечисления.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаМинМакс Тогда
				ПараметрыЗаписи = РегистрыСведений.ТоварныеОграничения.ПараметрыМинМакс();
				ПараметрыЗаписи.МинимальноеКоличествоЗапаса				= МинимальныйЗапас;
				ПараметрыЗаписи.МаксимальноеКоличествоЗапаса			= МаксимальныйЗапас;
				ПараметрыЗаписи.ОбеспечениеЗаказовПриПоддержанииЗапаса	= ОбеспечениеЗаказовПриПоддержанииЗапаса;
				РегистрыСведений.ТоварныеОграничения.ДобавитьПоддержаниеЗапасаМинМакс(КлючЗаписи, ПараметрыЗаписи);
			ИначеЕсли МетодОбеспечения = Перечисления.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаНаСрокПоНорме Тогда
				ПараметрыЗаписи = РегистрыСведений.ТоварныеОграничения.ПараметрыРасчетПоНорме();
				ПараметрыЗаписи.НормаПотребления						= НормаПотребления;
				ПараметрыЗаписи.СтраховоеКоличествоЗапаса				= СтраховойЗапас;
				ПараметрыЗаписи.ОбеспечениеЗаказовПриПоддержанииЗапаса	= ОбеспечениеЗаказовПриПоддержанииЗапаса;
				РегистрыСведений.ТоварныеОграничения.ДобавитьПоддержаниеЗапасаРасчетПоНорме(КлючЗаписи, ПараметрыЗаписи);
			ИначеЕсли МетодОбеспечения = Перечисления.МетодыОбеспеченияПотребностей.ПоддержаниеЗапасаНаСрокПоСтатистике Тогда
				ПараметрыЗаписи = РегистрыСведений.ТоварныеОграничения.ПараметрыРасчетПоСтатистике();
				ПараметрыЗаписи.СтраховоеКоличествоЗапаса				= СтраховойЗапас;
				ПараметрыЗаписи.ОбеспечениеЗаказовПриПоддержанииЗапаса	= ОбеспечениеЗаказовПриПоддержанииЗапаса;
				РегистрыСведений.ТоварныеОграничения.ДобавитьПоддержаниеЗапасаРасчетПоСтатистике(КлючЗаписи, ПараметрыЗаписи);
			КонецЕсли;
			
		КонецЕсли;
	
		Если ПраваДоступа.ВариантыОбеспечения И Параметры.РежимОткрытия <> "ТолькоПараметры" Тогда
			
			НаборЗаписей = ?(Параметры.КлючПотребности.ЭтоРабота,
				РегистрыСведений.ВариантыОбеспеченияРаботами.СоздатьНаборЗаписей(),
				РегистрыСведений.ВариантыОбеспеченияТоварами.СоздатьНаборЗаписей());
			НаборЗаписей.Отбор.Номенклатура.Значение = Параметры.КлючПотребности.Номенклатура;
			НаборЗаписей.Отбор.Номенклатура.Использование = Истина;
			НаборЗаписей.Отбор.Характеристика.Значение = Параметры.КлючПотребности.Характеристика;
			НаборЗаписей.Отбор.Характеристика.Использование = Истина;
			Если Не Параметры.КлючПотребности.ЭтоРабота Тогда
				НаборЗаписей.Отбор.Склад.Значение          = Параметры.КлючПотребности.Склад;
				НаборЗаписей.Отбор.Склад.Использование = Истина;
			КонецЕсли;
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОбновлятьРеквизитДопУпорядочивания", Ложь);
			НаборЗаписей.Отбор.СпособОбеспеченияПотребностей.Использование = Истина;
			
			//Удаление действовавшего ранее индивидуального способа обеспечения.
			Если ЗначениеЗаполнено(СпособИндивидуальныйСтарый) Тогда
				
				НаборЗаписей.Отбор.СпособОбеспеченияПотребностей.Значение = СпособИндивидуальныйСтарый;
				НаборЗаписей.Прочитать();
				НаборЗаписей[0].РеквизитДопУпорядочивания = 2;
				НаборЗаписей.Записать(Истина);
				
			КонецЕсли;
			
			//Чтение и запись нового индивидуального способа в качестве основного способа.
			Если ПереключательСпособа = 1 И ЗначениеЗаполнено(СпособИндивидуальный) Тогда
				
				НаборЗаписей.Отбор.СпособОбеспеченияПотребностей.Значение = СпособИндивидуальный;
				НаборЗаписей.Прочитать();
				
				Если НаборЗаписей.Количество() > 0 Тогда
					Запись = НаборЗаписей[0];
				Иначе
					Запись = НаборЗаписей.Добавить();
					ЗаполнитьЗначенияСвойств(Запись, Параметры.КлючПотребности);
					Запись.СпособОбеспеченияПотребностей = СпособИндивидуальный;
				КонецЕсли;
				
				Запись.РеквизитДопУпорядочивания = 1;
				НаборЗаписей.Записать(Истина);
				СпособИндивидуальныйСтарый = СпособИндивидуальный;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Модифицированность = Ложь;
		ДанныеЗаписаны = Истина;
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыЦиклаПоставкиПоГрафикуРаботыВызовСервера(КлючПотребности, ПараметрыЦиклаПоставки, НачалоПериода)
	Обработки.ОбеспечениеПотребностей.ЗаполнитьРеквизитыСпособаОбеспечения(ПараметрыЦиклаПоставки, НачалоПериода, Истина);
	Возврат ПараметрыЦиклаПоставкиПоГрафикуРаботы(КлючПотребности, ПараметрыЦиклаПоставки, НачалоПериода);
КонецФункции

#КонецОбласти
