﻿&НаКлиенте
Перем ЗаписьXML, ЗаписьXML21;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ПредупреждениеЗакрытиеМесяца.Видимость = Не ВсеМесяцыЗакрыты();
	Элементы.ПоказатьОтчет.Видимость = Ложь;
	Элементы.ПоказатьОтчет21.Видимость = Ложь;
	ОстанавливатьсяПриРасхождениях = Истина;
	КонецРасчета = КонецМесяца(ТекущаяДатаСеанса());
	СписокЭтаповДляТестирования = ЭтапыДляТестирования();
	ПредставлениеЭтаповДляТестирования = ПредставлениеЭтаповДляТестирования(СписокЭтаповДляТестирования);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РабочийКаталог = КаталогДокументов();
	НачалоРасчета = СебестоимостьМинПериод();
	НачалоРасчетаСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(НачалоРасчета);
	КонецРасчетаСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(КонецРасчета);
	
	ИнициализироватьДанные();
		
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеЭтаповДляТестированияНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭтапыДляТестированияВыбор = Новый ОписаниеОповещения("ПредставлениеЭтаповДляТестированияНажатие_Выбор", ЭтотОбъект);
	СписокЭтаповДляТестирования.ПоказатьОтметкуЭлементов(ЭтапыДляТестированияВыбор, НСтр("ru = 'Выберите этапы для тестирования'"));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Запустить(Команда)
	
	ТекущийМесяц = НачалоРасчета;
	СообщениеОбОшибке = "";
	НачалоЗамера = 0;
	КоличествоРасхождений = 0;
	
	Тестирование();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтчет(Команда)
	ДанныеТестирования = Новый ДвоичныеДанные(ПутьКФайлу);
	АдресХранилища = ПоместитьВоВременноеХранилище(ДанныеТестирования, УникальныйИдентификатор);
	ПараметрыОтчета = Новый Структура("ПутьКФайлу, СформироватьПриОткрытии", АдресХранилища, Истина);
	ОткрытьФорму("Отчет.РезультатыТестирования.Форма.ФормаОтчета", ПараметрыОтчета, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтчет21(Команда)
	ДанныеТестирования = Новый ДвоичныеДанные(ПутьКФайлу21);
	АдресХранилища = ПоместитьВоВременноеХранилище(ДанныеТестирования, УникальныйИдентификатор);
	ПараметрыОтчета = Новый Структура("ПутьКФайлу, СформироватьПриОткрытии", АдресХранилища, Истина);
	ОткрытьФорму("Отчет.РезультатыТестирования.Форма.ФормаОтчета", ПараметрыОтчета, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КаталогФайловОшибокНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	
	Диалог.Заголовок = НСтр("ru = 'Выберите каталог для сохранения результатов'");
	Диалог.Каталог = РабочийКаталог;
	Диалог.МножественныйВыбор = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКаталогЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКаталогЗавершение(Каталог, ДополнительныеПараметры) Экспорт
	Если Каталог <> Неопределено Тогда
		РабочийКаталог= Каталог[0];
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КаталогФайловОшибокОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение("explorer "+ РабочийКаталог);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЗадание(Команда)
	ИзмененияВИнтерфейсеПриРаботеВФоне(Ложь);
	ОтменитьФоновоеЗаданиеЗакрытияМесяца();
	ОтключитьОбработчикОжидания("ПродолжитьТестирование");
КонецПроцедуры

&НаКлиенте
Процедура НачалоРасчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("НачалоРасчетаВыборЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.НачалоВыбораПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, НачалоРасчета, ЭтаФорма, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура КонецРасчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("КонецРасчетаВыборЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.НачалоВыбораПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, КонецРасчета, ЭтаФорма, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура НачалоРасчетаВыборЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	Если ВыбранныйПериод <> Неопределено Тогда
		НачалоРасчета = ВыбранныйПериод;
		НачалоРасчетаСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(ВыбранныйПериод);
		Если НачалоРасчета > КонецРасчета Тогда
			КонецРасчетаВыборЗавершение(НачалоРасчета, Неопределено);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонецРасчетаВыборЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	Если ВыбранныйПериод <> Неопределено Тогда
		КонецРасчета = ВыбранныйПериод;
		КонецРасчетаСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(ВыбранныйПериод);
		Если НачалоРасчета > КонецРасчета Тогда
			НачалоРасчетаВыборЗавершение(КонецРасчета, Неопределено);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НачалоРасчетаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	НачалоРасчета = ДобавитьМесяц(НачалоРасчета, Направление);
	НачалоРасчетаСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(НачалоРасчета);
	Если НачалоРасчета > КонецРасчета Тогда
		КонецРасчетаВыборЗавершение(НачалоРасчета, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонецРасчетаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	КонецРасчета = ДобавитьМесяц(КонецРасчета, Направление);
	КонецРасчетаСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(КонецРасчета);
	Если НачалоРасчета > КонецРасчета Тогда
		НачалоРасчетаВыборЗавершение(КонецРасчета, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонецРасчетаПриИзменении(Элемент)
	Элементы.ПредупреждениеЗакрытиеМесяца.Видимость = Не ВсеМесяцыЗакрыты();
КонецПроцедуры

&НаКлиенте
Процедура СравнитьСЭталоннымиДанными21ПриИзменении(Элемент)
	Элементы.КаталогЭталонныхДанных21.Доступность = СравнитьСЭталоннымиДанными21;
	Элементы.ТолькоСравнитьС21.Доступность = СравнитьСЭталоннымиДанными21;
	ТолькоСравнитьС21 = ТолькоСравнитьС21 И СравнитьСЭталоннымиДанными21;
	Если СравнитьСЭталоннымиДанными21 Тогда
		КаталогЭталонныхДанных21НачатьВыбор();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КаталогЭталонныхДанных21НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	КаталогЭталонныхДанных21НачатьВыбор()
КонецПроцедуры

&НаКлиенте
Процедура КаталогЭталонныхДанных21Открытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение("explorer "+ КаталогЭталонныхДанных21);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область МетаданныеКТестированию

&НаСервере
Функция ЭтапыДляТестирования()
	Возврат Обработки.ТестированиеОперацийЗакрытийМесяца.ЭтапыДляТестирования();
КонецФункции

#КонецОбласти // МетаданныеКТестированию

&НаКлиенте
Процедура ИнициализироватьДанные()
	ТекущийМесяц = НачалоРасчета;
	ПутьКФайлу = "";
	ПутьКФайлу21 = "";
КонецПроцедуры

&НаСервере
Функция СебестоимостьМинПериод()
	Возврат Обработки.ТестированиеОперацийЗакрытийМесяца.СебестоимостьМинПериод();
КонецФункции

&НаСервере
Функция ВсеМесяцыЗакрыты()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрЗаданий.Месяц КАК Месяц,
	|	NULL КАК ДатаОтражения
	|ИЗ
	|	РегистрСведений.ЗаданияКРасчетуСебестоимости КАК РегистрЗаданий
	|ГДЕ
	|	РегистрЗаданий.Месяц < &КонецРасчета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрЗаданий.Месяц,
	|	NULL
	|ИЗ
	|	РегистрСведений.ЗаданияКРаспределениюРасчетовСКлиентами КАК РегистрЗаданий
	|ГДЕ
	|	РегистрЗаданий.Месяц < &КонецРасчета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрЗаданий.Месяц,
	|	NULL
	|ИЗ
	|	РегистрСведений.ЗаданияКРаспределениюРасчетовСПоставщиками КАК РегистрЗаданий
	|ГДЕ
	|	РегистрЗаданий.Месяц < &КонецРасчета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрЗаданий.Месяц,
	|	NULL
	|ИЗ
	|	РегистрСведений.ЗаданияКЗакрытиюМесяца КАК РегистрЗаданий
	|ГДЕ
	|	РегистрЗаданий.Месяц < &КонецРасчета
	|	И РегистрЗаданий.Операция В (ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.РаспределениеНДС),
	|									ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.ПризнаниеРасходовПриУСН),
	|									ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.СторноДоходовКУДиР),
	|									ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.РасчетНалогаУСН))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрЗаданий.Месяц,
	|	NULL
	|ИЗ
	|	РегистрСведений.ЗаданияКФормированиюЗаписейКнигиПокупокПродаж КАК РегистрЗаданий
	|ГДЕ
	|	РегистрЗаданий.Месяц < &КонецРасчета
	|
	|";
	Запрос.УстановитьПараметр("КонецРасчета", КонецМесяца(КонецРасчета)+1);
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой();
	
КонецФункции

&НаКлиенте
Процедура Тестирование()
	
	ВыбранныеЭтапы = Новый Массив;
	Для каждого ЭтапДляТестирования из СписокЭтаповДляТестирования Цикл
		Если ЭтапДляТестирования.Пометка Тогда
			ВыбранныеЭтапы.Добавить(ЭтапДляТестирования.Значение);
		КонецЕсли;
	КонецЦикла;
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("СписокОрганизаций", Новый Массив);
	ПараметрыЗадания.Вставить("Организация", Неопределено);
	ПараметрыЗадания.Вставить("МассивОпераций", Новый Массив);
	ПараметрыЗадания.Вставить("ПериодРегистрации", ТекущийМесяц);
	ПараметрыЗадания.Вставить("Период", ТекущийМесяц);
	ПараметрыЗадания.Вставить("Тестирование", Истина);
	ПараметрыЗадания.Вставить("Этапы", ВыбранныеЭтапы);
	ПараметрыЗадания.Вставить("АдресХранилища", АдресХранилища);
	Если СравнитьСЭталоннымиДанными21 Тогда
		ПараметрыЗадания.Вставить("ХранилищеЭталонныхДанных21", ЭталонныеДанные21(ТекущийМесяц));
		ПараметрыЗадания.Вставить("ТолькоСравнитьС21", ТолькоСравнитьС21);
	КонецЕсли;
	
	Если НачалоЗамера = 0 Тогда
		НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
	КонецЕсли;
	
	Если ТекущийМесяц <= КонецРасчета Тогда
		РасчетМесяцаНачатВ = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ТекстСообщения = ЗапуститьТестированиеВФоне(ТекущийМесяц, ПараметрыЗадания);
		Если ТекстСообщения = "" Тогда
			ИзмененияВИнтерфейсеПриРаботеВФоне(Истина);
			ПодключитьОбработчикОжидания("ПродолжитьТестирование", 15);
		Иначе
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.Сообщить();
		КонецЕсли;
	Иначе
		ИзмененияВИнтерфейсеПриРаботеВФоне(Ложь);
		ЗакончитьЗаписьРасхождений();
		ВывестиСтатистику(НачалоЗамера);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьТестирование()
	
	Если ЕстьАктивноеФоновоеЗадание() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееКоличествоРасхождений = 0;
	ОтключитьОбработчикОжидания("ПродолжитьТестирование");
	// разобрать результаты расчета
	РезультатРасчета = ПолучитьИзВременногоХранилища(АдресХранилища);
	ДлительностьМс = ТекущаяУниверсальнаяДатаВМиллисекундах() - РасчетМесяцаНачатВ;
	Отказ = Ложь;
	Если РезультатРасчета <> Неопределено Тогда
		
		Если РезультатРасчета.Отказ Тогда
			СообщениеОбОшибке.ДобавитьСтроку(НСтр("ru = 'Ошибка тестирования!'"));
			СообщениеОбОшибке.ДобавитьСтроку(РезультатРасчета.ОписаниеОшибки);
		Иначе
		
			Если РезультатРасчета.Свойство("Расхождения")
				И ЗначениеЗаполнено(РезультатРасчета.Расхождения) Тогда
				ТекущееКоличествоРасхождений = ЗаписатьРасхожденияВФайл(ПутьКФайлу, РезультатРасчета.Расхождения, ЗаписьXML);
			КонецЕсли;
			
			ИнформацияОДействии = НСтр("ru = 'Выполнен расчет'");
			ВывестиРезультатРасчета(ТекущийМесяц, ДлительностьМс, ТекущееКоличествоРасхождений, ИнформацияОДействии);
			
			Если РезультатРасчета.Свойство("Расхождения21")
				И ЗначениеЗаполнено(РезультатРасчета.Расхождения21) Тогда
				КоличествоРасхождений21 = ЗаписатьРасхожденияВФайл(ПутьКФайлу21, РезультатРасчета.Расхождения21, ЗаписьXML21);
				ТекущееКоличествоРасхождений = ТекущееКоличествоРасхождений + КоличествоРасхождений21;
			КонецЕсли;
			Если СравнитьСЭталоннымиДанными21 Тогда
				ИнформацияОДействии = НСтр("ru = 'Выполнено сравнение c эталонными данными ERP 2.1'");
				ВывестиРезультатРасчета(ТекущийМесяц, ДлительностьМс, ТекущееКоличествоРасхождений, ИнформацияОДействии);
			КонецЕсли;
			КоличествоРасхождений = КоличествоРасхождений + ТекущееКоличествоРасхождений;
		КонецЕсли;
		
		Отказ = РезультатРасчета.Отказ;
		
	КонецЕсли;
	
	УдалитьИзВременногоХранилища(АдресХранилища);
	
	Если Не Отказ
		И ТекущийМесяц < НачалоМесяца(КонецРасчета)
		И (КоличествоРасхождений = 0
			Или Не ОстанавливатьсяПриРасхождениях) Тогда
		// переход к следующему месяцу
		ТекущийМесяц = КонецМесяца(ТекущийМесяц) + 1;
		
		Тестирование();
	Иначе
		ИзмененияВИнтерфейсеПриРаботеВФоне(Ложь);
		ЗакончитьЗаписьРасхождений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьЗапись(ПутьКТекущемуФайлу, ТекущаяЗаписьXML)
	ПутьКТекущемуФайлу = ИмяТекущегоФайла(РабочийКаталог);
	
	ТекущаяЗаписьXML = Новый ЗаписьXML;
	ТекущаяЗаписьXML.ОткрытьФайл(ПутьКТекущемуФайлу);
	
	ТекущаяЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("Корневой");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяТекущегоФайла(РабочийКаталог)
	
	ИмяФайла = "" + РабочийКаталог + Формат(ТекущаяДатаСеанса(), "ДФ=dd-MM-yyyy") + "_" + Строка(Новый УникальныйИдентификатор()) + ".xml";
	Возврат ИмяФайла;
	
КонецФункции

&НаКлиенте
Процедура ЗакончитьЗаписьРасхождений()
	Если ЗаписьXML <> Неопределено Тогда
		ЗаписьXML.ЗаписатьКонецЭлемента(); // Корневой
		ЗаписьXML.Закрыть();
		ЗаписьXML = Неопределено;
	КонецЕсли;
	Если ЗаписьXML21 <> Неопределено Тогда
		ЗаписьXML21.ЗаписатьКонецЭлемента(); // Корневой
		ЗаписьXML21.Закрыть();
		ЗаписьXML21 = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзмененияВИнтерфейсеПриРаботеВФоне(ФоновоеЗаданиеЗапущено = Ложь)
	Элементы.ФормаЗапустить.Доступность = Не ФоновоеЗаданиеЗапущено;
	Элементы.ФормаЗакрыть.Доступность = Не ФоновоеЗаданиеЗапущено;
	Если ФоновоеЗаданиеЗапущено Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаФоновоеЗадание;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаПараметры;
	КонецЕсли;
	Шаблон = НСтр("ru='Выполняется закрытие месяца: %МесяцГод% г...'");
	Элементы.ЗаголовокРасчетаВФоне.Заголовок = СтрЗаменить(Шаблон, "%МесяцГод%", Формат(ТекущийМесяц, "ДФ='ММММ гггг'"));
	Элементы.ПоказатьОтчет.Доступность = Не ФоновоеЗаданиеЗапущено;
	Элементы.ПоказатьОтчет21.Доступность = Не ФоновоеЗаданиеЗапущено;
	Элементы.ПоказатьОтчет.Видимость = Не ПустаяСтрока(ПутьКФайлу);
	Элементы.ПоказатьОтчет21.Видимость = Не ПустаяСтрока(ПутьКФайлу21);
	Элементы.ПредупреждениеЗакрытиеМесяца.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Функция ЗаписатьРасхожденияВФайл(ТекущийПутьКФайлу, ТекущиеРасхождения, ТекущаяЗаписьXML)
	
	ТекущееКоличествоРасхождений = 0;
	Если ТекущаяЗаписьXML = Неопределено Тогда // инициализируем
		ИнициализироватьЗапись(ТекущийПутьКФайлу, ТекущаяЗаписьXML);
	КонецЕсли;
	Если ТекущиеРасхождения.Получить("КоличествоРасхождений") <> Неопределено Тогда
		ТекущееКоличествоРасхождений = ТекущиеРасхождения["КоличествоРасхождений"];
	КонецЕсли;
	
	ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("Период");
	СтрокаXML = ЗначениеВСтрокуXML(ТекущийМесяц);
	ТекущаяЗаписьXML.ЗаписатьТекст(СтрокаXML);

	Для Каждого Строка Из ТекущиеРасхождения Цикл
		
		Если Строка.Ключ = "КоличествоРасхождений" Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("ОбъектМетаданных");
		СтрокаXML = ЗначениеВСтрокуXML(Строка.Ключ); // имя регистра
		ТекущаяЗаписьXML.ЗаписатьТекст(СтрокаXML);
		
		ТекущаяЗаписьXML.ЗаписатьНачалоЭлемента("Записи");
		ТекущаяЗаписьXML.ЗаписатьТекст(Строка.Значение.Записи);
		ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // записи

		ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // имя регистра
	КонецЦикла;
	ТекущаяЗаписьXML.ЗаписатьКонецЭлемента(); // Период

	Возврат ТекущееКоличествоРасхождений;
КонецФункции

&НаКлиенте
Функция ЗначениеВСтрокуXML(Значение) Экспорт
	#Если НЕ ВебКлиент Тогда
	ЗначениеXML = Новый ЗаписьXML;
	ЗначениеXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗначениеXML, Значение, НазначениеТипаXML.Явное);
	Возврат ЗначениеXML.Закрыть();
	#Иначе
	Возврат Неопределено;
	#КонецЕсли
КонецФункции

&НаСервере
Функция ЗапуститьТестированиеВФоне(Период, ПараметрыЗадания)
	
	Результат = Обработки.ТестированиеОперацийЗакрытийМесяца.ЗапуститьТестированиеВФоне(ПараметрыЗадания);
	Если ТипЗнч(Результат) <> Тип("Строка") Тогда
		ИдентификаторЗадания = Результат;
		Результат = "";
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВывестиРезультатРасчета(Период, ДлительностьМс, ТекущееКоличествоРасхождений, ИнформацияОДействии)
	
	Если АвтоТест Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаЛогФайла = "";
	СтрокаЛогФайла = СтрокаЛогФайла + НСтр("ru ='%ИнформацияОДействии% за месяц %Период% за %Длительность%'");
	СтрокаЛогФайла = СтрЗаменить(СтрокаЛогФайла, "%ИнформацияОДействии%", ИнформацияОДействии);
	СтрокаЛогФайла = СтрЗаменить(СтрокаЛогФайла, "%Период%", Формат(Период, "ДФ='ММММ гггг'"));
	СтрокаЛогФайла = СтрЗаменить(СтрокаЛогФайла, "%Длительность%", ПеревестиМиллисекундыВДеньЧасМинутаСекунда(ДлительностьМс));
	
	Если ТекущееКоличествоРасхождений > 0 Тогда
		СтрокаЛогФайла = СтрокаЛогФайла + "
		|" + НСтр("ru ='Выявлено %КоличествоРасхождений%.'");
		СтрокаЛогФайла = СтрЗаменить(СтрокаЛогФайла, "%КоличествоРасхождений%", ЧислоРасхожденийПрописью(ТекущееКоличествоРасхождений));
	Иначе
		СтрокаЛогФайла = СтрокаЛогФайла + "
		|" + НСтр("ru ='Расхождений нет.'");
	КонецЕсли;
	СтрокаЛогФайла = СтрокаЛогФайла + "
	|";
	СообщениеОбОшибке.ДобавитьСтроку(СтрокаЛогФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСтатистику(НачалоЗамера)
	Если АвтоТест Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаЛогФайла = "";
	ДлительностьМс = ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЗамера;
	СтрокаЛогФайла = СтрокаЛогФайла + "
	|===================================================
	|" + НСтр("ru ='Тестирование выполнено за %Количество%'");
	СтрокаЛогФайла = СтрЗаменить(СтрокаЛогФайла, "%Количество%", ПеревестиМиллисекундыВДеньЧасМинутаСекунда(ДлительностьМс));
	СообщениеОбОшибке.ДобавитьСтроку(СтрокаЛогФайла);
	
КонецПроцедуры

&НаКлиенте
Функция ПеревестиМиллисекундыВДеньЧасМинутаСекунда(Знач Миллисекунды)
	Результат = "";
	Часы = 0;
	Минуты = 0;
	
	Секунды = Окр(Миллисекунды / 1000, 0, РежимОкругления.Окр15как10);
	Если Секунды >= 60 Тогда
		Минуты = Окр(Секунды / 60, 0, РежимОкругления.Окр15как10);
		Секунды = Секунды - Минуты * 60;
		Результат = "" + Секунды + " "+ НСтр("ru='с.'");
		Если Минуты >= 60 Тогда
			Часы = Окр(Минуты / 60, 0, РежимОкругления.Окр15как10);
			Минуты = Минуты - Часы * 60;
		КонецЕсли;
		Результат = "" + Минуты + " "+ НСтр("ru='мин.'") + " " + Результат;
		Если Часы > 0 Тогда
			 Результат = "" + Часы + " "+ НСтр("ru='час.'") + " " + Результат;
		КонецЕсли;
	ИначеЕсли Секунды < 1 Тогда
		Результат = "" + 1 + " "+ НСтр("ru='с.'");
	Иначе 
		Результат = "" + Секунды + " "+ НСтр("ru='с.'");
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ЧислоРасхожденийПрописью(ТекущееКоличествоРасхождений)
	
	КоличествоПрописью = ЧислоПрописью(
		ТекущееКоличествоРасхождений,
		"Л = ru_RU; НП = Истина; НД = Ложь; ДП = Ложь;",
		НСтр("ru = 'расхождение,расхождения,расхождений,с,,,,,0'"));
	Поз = Найти(КоличествоПрописью, "расхождени");
	Если Поз <> 0 Тогда
		КоличествоПрописью = Сред(КоличествоПрописью, Поз);
	КонецЕсли;
	КоличествоПрописью = Строка(ТекущееКоличествоРасхождений) + " " + НРег(КоличествоПрописью);
	
	Возврат КоличествоПрописью;
	
КонецФункции

&НаКлиенте
Функция ЭталонныеДанные21(ТестируемыйМесяц)
	
	Результат = Неопределено;
	
	МассивФайлов = НайтиФайлы(КаталогЭталонныхДанных21, "*erp21_cost_data*.xml");
	Если МассивФайлов.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'В каталоге движений ERP 2.1 не найдено ни одного файла выгрузки движений по регистрам'");
	КонецЕсли;
	
	АдресФайла = ПоместитьВоВременноеХранилище("",УникальныйИдентификатор);
	
	Для Каждого ТекФайл Из МассивФайлов Цикл
		ИмяФайла = ТекФайл.ПолноеИмя;

   		НачатьПомещениеФайла(,АдресФайла, ИмяФайла, Ложь);
		
		Результат = ЭталонныеДанные21Сервер(АдресФайла, ТестируемыйМесяц);
		
		Если Результат <> Неопределено Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(АдресФайла) Тогда
		УдалитьИзВременногоХранилища(АдресФайла);
	КонецЕсли;
	
	Если Результат = Неопределено Тогда
		ТекстИсключения = СтрШаблон(
			НСтр("ru = 'В каталоге движений ERP 2.1 не найден файл выгрузки движений за %1'"),
			Формат(ТестируемыйМесяц,"ДФ='MMMM yyyy'"));
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭталонныеДанные21Сервер(АдресФайла, ТестируемыйМесяц)
	
	Результат = Неопределено;
	
	ДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);

	ИмяПромежуточногоФайла = ПолучитьИмяВременногоФайла();
	ДанныеФайла.Записать(ИмяПромежуточногоФайла);

	Чтение = Новый ЧтениеXML;
	Чтение.ОткрытьФайл(ИмяПромежуточногоФайла);

	Пока Чтение.Прочитать() Цикл
		Если Чтение.Имя = "Период"
			И Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Чтение.Прочитать();
			ПериодИзФайла = ОбщегоНазначения.ЗначениеИзСтрокиXML(Чтение.Значение);
			Если НачалоМесяца(ПериодИзФайла) <> НачалоМесяца(ТестируемыйМесяц) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		Если Чтение.Имя = "Движения"
			И Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			Чтение.Прочитать();
			Если ЗначениеЗаполнено(Чтение.Значение) Тогда
				Результат = Чтение.Значение;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Чтение.Закрыть();
	Чтение = Неопределено;
	
	УдалитьФайлы(ИмяПромежуточногоФайла);
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура КаталогЭталонныхДанных21НачатьВыбор()

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	
	Диалог.Заголовок = НСтр("ru = 'Выберите каталог с эталонными данными УП версии 2.1'");
	Диалог.Каталог = КаталогЭталонныхДанных21;
	Диалог.МножественныйВыбор = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКаталогЭталонныхДанных21Завершение", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКаталогЭталонныхДанных21Завершение(Каталог, ДополнительныеПараметры) Экспорт
	Если Каталог <> Неопределено Тогда
		КаталогЭталонныхДанных21 = Каталог[0];
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеЭтаповДляТестированияНажатие_Выбор(Список, Параметры = Неопределено) Экспорт
	ПредставлениеЭтаповДляТестирования = ПредставлениеЭтаповДляТестирования(СписокЭтаповДляТестирования);
	Элементы.ПредупреждениеЗакрытиеМесяца.Видимость = Не ВсеМесяцыЗакрыты();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеЭтаповДляТестирования(Список)
	
	СтрокаВозврата = "";
	Для каждого ЭтапТестирования из Список Цикл
		Если ЭтапТестирования.Пометка Тогда
			СтрокаВозврата = СтрокаВозврата + ?(СтрокаВозврата = "", "", ", ") + НРег(ЭтапТестирования.Представление);
		КонецЕсли;
	КонецЦикла;
	
	СтрокаВозврата = СтрокаВозврата + ?(СтрокаВозврата = "", НСтр("ru = '< нет >'"), ".");
	
	Возврат СтрокаВозврата;
	
КонецФункции

&НаСервере
Функция ЕстьАктивноеФоновоеЗадание()
	
	АктивныеРасчеты = РегистрыСведений.ВыполнениеОперацийЗакрытияМесяца.ПроверитьНаличиеАктивныхРасчетов();
	
	Если АктивныеРасчеты.ЕстьАктивныеРасчеты Тогда
		Возврат Истина;
	КонецЕсли;
	
	СостояниеЗадания = ЗакрытиеМесяцаСервер.ТекущееСостояниеФоновогоЗадания(ИдентификаторЗадания);
	
	Возврат СостояниеЗадания.Активно;
	
КонецФункции

&НаСервере
Функция ОтменитьФоновоеЗаданиеЗакрытияМесяца()
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Результат = Истина;
	Иначе
		Результат = ЗакрытиеМесяцаСервер.ОтменитьВыполнениеФоновогоЗадания(ИдентификаторЗадания);
		РегистрыСведений.ВыполнениеОперацийЗакрытияМесяца.УстановитьПризнакОкончанияРасчета();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
