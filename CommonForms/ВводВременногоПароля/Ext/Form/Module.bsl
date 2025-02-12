﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Сертификат = Параметры.Сертификат;
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СпособДоставкиПаролей = "phone";
	
	ПараметрыПроцедуры = Новый Структура("ИдентификаторСертификата", Сертификат.Идентификатор);
	
	ДлительнаяОперация = СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьНастройкиПолученияВременныхПаролей", ПараметрыПроцедуры);
	
	ПарольОтправляется = Истина;
	Элементы.ПолучитьВременныйПарольДругимСпособом.Видимость = Ложь;	
	Телефон = "...";
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповещение = Новый ОписаниеОповещения("ПолучитьНастройкиПолученияВременныхПаролейПослеВыполнения", ЭтотОбъект);
	СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ДлительнаяОперация);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ПарольИзменениеТекстаРедактирования(Элемент, Элемент.ТекстРедактирования, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Пароль = СокрЛП(Текст);
	Если ЗначениеЗаполнено(Пароль) И СтрДлина(Пароль) = 6 Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьПароль");
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьПароль", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьОткрытую(ПараметрыФормы)
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьПароль");
	Если Открыта() Тогда 
		Закрыть(ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПолучателя(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Состояние", "ИзменениеНастроекПолученияВременныхПаролей");
	ПараметрыФормы.Вставить("Сертификат", Сертификат);
	
	ЗакрытьОткрытую(ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПарольПовторно(Команда)

	Пароль = Неопределено;
	Оповещение = Новый ОписаниеОповещения("ПолучитьВременныйПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПолучитьПарольНаСервере(Истина));
		
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подтвердить(Команда)
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьПароль");
	ОчиститьСообщения();
	ТекстОшибки = "";
	Пароль = СокрЛП(Пароль);
	Если ЗначениеЗаполнено(Пароль) И СтрДлина(Пароль) = 6 Тогда
		Оповещение = Новый ОписаниеОповещения("ПодтвердитьПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПодтвердитьНаСервере());
		УправлениеФормой(ЭтаФорма);
	ИначеЕсли ЗначениеЗаполнено(Пароль) И СтрДлина(Пароль) <> 6 Тогда
		ТекстОшибки = НСтр("ru = 'Пароль должен состоять из 6 цифр'");
	Иначе
		ТекстОшибки = НСтр("ru = 'Пароль не указан'");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВременныйПарольДругимСпособом(Команда)
	
	Если СпособДоставкиПаролей = "phone" Тогда
		СпособДоставкиПаролей = "email";
	Иначе
		СпособДоставкиПаролей = "phone";
	КонецЕсли;
	
	ОтправитьПарольПовторно(Неопределено);
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодтвердитьПарольПослеВыполнения(Результат, ВходящийКонтекст) Экспорт

	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		СохранитьМаркерБезопасноти(Результат.РезультатВыполнения);
		ЗакрытьОткрытую(Новый Структура("Состояние", "ПарольПринят"));
	Иначе
		ПарольПроверяется = Ложь;
		УправлениеФормой(ЭтаФорма);
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(Результат.ИнформацияОбОшибке);
		Если СтрНайти(ТекстИсключения, "Invalid password") Тогда
			ТекстОшибки = НСтр("ru = 'Указан неверный пароль'");
		ИначеЕсли СтрНайти(ТекстИсключения, "MaxAttemptsInputPasswordExceededError") Тогда
			ЗакрытьОткрытую(Новый Структура("Состояние, ОписаниеОшибки", "ПарольНеПринят", НСтр("ru = 'Превышен лимит попыток ввода пароля'"))); 
		ИначеЕсли СтрНайти(ТекстИсключения, "PasswordExpiredError") Тогда
			ЗакрытьОткрытую(Новый Структура("Состояние, ОписаниеОшибки", "ПарольНеПринят", НСтр("ru = 'Срок действия пароля истек'")));
		Иначе 
			ЗакрытьОткрытую(Новый Структура("Состояние, ОписаниеОшибки", "ПарольНеПринят", НСтр("ru = 'Выполнение операции временно невозможно'")));
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьМаркерБезопасноти(МаркерБезопасности)
	
	УстановитьПривилегированныйРежим(Истина);
	МаркерыБезопасности = Новый Соответствие;
	Для Каждого ЭлементСоответствия Из ПараметрыСеанса.МаркерыБезопасности Цикл
		МаркерыБезопасности.Вставить(ЭлементСоответствия.Ключ, ЭлементСоответствия.Значение);
	КонецЦикла;
	
	МаркерыБезопасности[МаркерБезопасности.ИдентификаторСертификата] = МаркерБезопасности.МаркерБезопасности;
	
	ПараметрыСеанса.МаркерыБезопасности = Новый ФиксированноеСоответствие(МаркерыБезопасности);		
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНастройкиПолученияВременныхПаролейПослеВыполнения(Результат, ВходящийКонтекст) Экспорт
	
	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		Телефон          = Результат.РезультатВыполнения.Телефон;
		ЭлектроннаяПочта = Результат.РезультатВыполнения.ЭлектроннаяПочта;
		
		Получатель = Телефон;
		
		Оповещение = Новый ОписаниеОповещения("ПолучитьВременныйПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПолучитьПарольНаСервере());
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеПоказаПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен. Повторите попытку позже.'"));		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПоказаПредупреждения(ВходящийКонтекст) Экспорт
	
	ЗакрытьОткрытую(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВременныйПарольПослеВыполнения(Результат, ВходящийКонтекст) Экспорт
	
	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		Таймер = Результат.РезультатВыполнения.ЗадержкаПередПовторнойОтправкой;
		ПарольОтправлен = Истина;
		ПарольОтправляется = Ложь;
		ЗапуститьОбратныйОтсчет();
		УправлениеФормой(ЭтаФорма);
		ПодключитьОбработчикОжидания("Подключаемый_АктивироватьПолеДляВводаПароля", 0.1, Истина);
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеПоказаПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен. Повторите попытку позже.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьПароль()
	
	Подтвердить(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АктивироватьПолеДляВводаПароля()
	
	Пароль = Неопределено;
	Элементы.Пароль.ОбновитьТекстРедактирования();
	ТекущийЭлемент = Элементы.Пароль;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПарольНаСервере(Повторно = Ложь)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторСертификата", Сертификат.Идентификатор);
	ПараметрыПроцедуры.Вставить("ПовторнаяОтправка", Повторно);
	ПараметрыПроцедуры.Вставить("Тип", СпособДоставкиПаролей);
	
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьВременныйПароль", ПараметрыПроцедуры);
	
КонецФункции

&НаКлиенте
Процедура ЗапуститьОбратныйОтсчет()
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОбратногоОтсчета()
	
	Таймер = Таймер - 1;
	Если Таймер >= 0 Тогда
		НадписьОбратногоОтсчета = СтрШаблон(НСтр("ru = 'Запросить пароль повторно можно будет через %1 сек.'"), Таймер);
		ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);		
	Иначе
		НадписьОбратногоОтсчета = "";
		ПарольОтправлен = Ложь;		
		Элементы.ПолучитьВременныйПарольДругимСпособом.Видимость = ЗначениеЗаполнено(ЭлектроннаяПочта);
		Элементы.ИзменитьПолучателя.Заголовок = НСтр("ru = 'Изменить адрес'");
		
		УправлениеФормой(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.НадписьОбратногоОтсчета.Видимость = Форма.ПарольОтправлен;	
	Элементы.ОтправитьПарольПовторно.Видимость = Не Форма.ПарольОтправлен И Не Форма.ПарольОтправляется;
	
	ТекстКоманды = НСтр("ru = 'Отправить пароль на %1'");
	Если Форма.СпособДоставкиПаролей = "phone" Тогда
		Если Форма.ПарольОтправляется Тогда
			Элементы.Пояснение.Заголовок = НСтр("ru = 'Выполняется отправка пароля в SMS-сообщении на номер'");
		Иначе
			Элементы.Пояснение.Заголовок = НСтр("ru = 'Пароль отправлен в SMS-сообщении на номер'");
		КонецЕсли;
		Элементы.ИзменитьПолучателя.Заголовок = НСтр("ru = 'Изменить номер'");
		Элементы.ПолучитьВременныйПарольДругимСпособом.Заголовок = СтрШаблон(ТекстКоманды, Форма.ЭлектроннаяПочта);
		Форма.Получатель = Форма.Телефон;
		Элементы.Пароль.ПодсказкаВвода = НСтр("ru = 'Введите пароль из SMS'");
	ИначеЕсли Форма.СпособДоставкиПаролей = "email" Тогда
		Если Форма.ПарольОтправляется Тогда
			Элементы.Пояснение.Заголовок = НСтр("ru = 'Выполняется отправка пароля в письме на адрес'");
		Иначе
			Элементы.Пояснение.Заголовок = НСтр("ru = 'Пароль отправлен в письме на адрес'");
		КонецЕсли;	
		Элементы.ИзменитьПолучателя.Заголовок = НСтр("ru = 'Изменить адрес'");
		Элементы.ПолучитьВременныйПарольДругимСпособом.Заголовок = СтрШаблон(ТекстКоманды, Форма.Телефон);
		Форма.Получатель = Форма.ЭлектроннаяПочта;
		Элементы.Пароль.ПодсказкаВвода = НСтр("ru = 'Введите пароль из письма'");
	КонецЕсли;
	
	Элементы.ИндикаторДлительнойОперации.Видимость = Форма.ПарольОтправляется;
	Элементы.ГруппаПароль.Доступность = Не Форма.ПарольОтправляется И Не Форма.ПарольПроверяется;		
	Элементы.ГруппаДополнительно.Доступность = Не Форма.ПарольОтправляется И Не Форма.ПарольПроверяется;
		
	Элементы.ИндикаторДлительнойОперации2.Видимость = Форма.ПарольПроверяется;
	Элементы.НадписьПроверкаПароля.Видимость = Форма.ПарольПроверяется;
	Элементы.ТекстОшибки.Видимость = Не Форма.ПарольПроверяется;
	
КонецПроцедуры

&НаСервере
Функция ПодтвердитьНаСервере()
	
	ПарольПроверяется = Истина;

	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторСертификата", Сертификат.Идентификатор);
	ПараметрыПроцедуры.Вставить("ВременныйПароль", Пароль);
	
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьСеансовыйКлюч", ПараметрыПроцедуры);
	
КонецФункции

#КонецОбласти