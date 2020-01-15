﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Наименование = Строка(Владелец);
	
	НастройкиПродажДляПользователейСервер.ОчиститьНеиспользуемыеПравилаПродаж(ЭтотОбъект);
	
	ЕстьУточненияПоЦеновымГруппам = ЦеновыеГруппы.Количество() > 0;
	
	Если Не РМК_Использовать Тогда
		РМК_ВозвратТовара           = Ложь;
		РМК_ВнесениеДенег           = Ложь;
		РМК_ВыемкаДенег             = Ложь;
		РМК_КорректировкаСтрок      = Ложь;
		РМК_Отложить                = Ложь;
		РМК_Зарезервировать         = Ложь;
		РМК_ОткрытьСмену            = Ложь;
		РМК_ЗакрытьСмену            = Ложь;
		РМК_ИзменениеКартЛояльности = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОграничиватьРучныеСкидки Тогда
		КлючевыеРеквизиты = Новый Массив;
		КлючевыеРеквизиты.Добавить("ЦеноваяГруппа");
		ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(ЭтотОбъект, "ЦеновыеГруппы", КлючевыеРеквизиты, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли