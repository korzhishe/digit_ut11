﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		Справочники.ВидыНоменклатуры.ИменаРеквизитовДляФормыНастройкаСоставаРеквизитовСерии("ОткрытиеФормыРедактирования"));
	ИменаСохраняемыхРеквизитов = Справочники.ВидыНоменклатуры.ИменаРеквизитовДляФормыНастройкаСоставаРеквизитовСерии("СохранениеРезультатов");
	
	НастроитьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ИспользоватьНомерСерии
		И Не ИспользоватьСрокГодностиСерии
		И Не ИспользоватьНомерКИЗГИСМСерии Тогда
		ТекстСообщения = НСтр("ru = 'Не выполнена настройка использования реквизитов серии.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура ИспользоватьСрокГодностиСерииПриИзменении(Элемент)
	Если ИспользоватьСрокГодностиСерии Тогда
		ТочностьУказанияСрокаГодностиСерии = ПредопределенноеЗначение("Перечисление.ТочностиУказанияСрокаГодности.СТочностьюДоДней");
	Иначе
		ТочностьУказанияСрокаГодностиСерии = ПредопределенноеЗначение("Перечисление.ТочностиУказанияСрокаГодности.ПустаяСсылка");
	КонецЕсли;
	
	НастроитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИспользованияСерийПриИзменении(Элемент)
	ЭтоЭкземпляр = (НастройкаИспользованияСерий = ПредопределенноеЗначение("Перечисление.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара"));
	
	Если ЭтоЭкземпляр Тогда
		ИспользоватьНомерСерии     = Не КиЗГИСМ;
		ИспользоватьRFIDМеткиСерии = ПродукцияМаркируемаяДляГИСМ
									Или КиЗГИСМ; 
	Иначе
		ИспользоватьRFIDМеткиСерии = Ложь;
	КонецЕсли;
	
	НастроитьФорму();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФорму()
	
	Элементы.ИспользоватьНомерКИЗГИСМСерии.Видимость = ПродукцияМаркируемаяДляГИСМ
														Или КиЗГИСМ;
		
	Элементы.ИспользоватьНомерСерии.Доступность = Не (НастройкаИспользованияСерий = Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара
													Или ПродукцияМаркируемаяДляГИСМ
													Или КиЗГИСМ);
		
	Элементы.ИспользоватьСрокГодностиСерии.Доступность = Не КиЗГИСМ;
	
	Элементы.НастройкаИспользованияСерий.Доступность = Не (ПродукцияМаркируемаяДляГИСМ
															Или КиЗГИСМ);
	
	Элементы.ТочностьУказанияСрокаГодностиСерии.Доступность = ИспользоватьСрокГодностиСерии;
	
	Элементы.ИспользоватьRFIDМетки.Доступность = (НастройкаИспользованияСерий
													= Перечисления.НастройкиИспользованияСерийНоменклатуры.ЭкземплярТовара)
													И Не ПродукцияМаркируемаяДляГИСМ
													И Не КиЗГИСМ;
	
КонецПроцедуры

#КонецОбласти
