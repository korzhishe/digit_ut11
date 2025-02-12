﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Если ПолучитьФункциональнуюОпцию("ИспользоватьКоммерческиеПредложенияКлиентам") Тогда
	СоздаватьКоммерческоеПредложение = Истина;
	ПечататьКоммерческоеПредложение = Истина;
КонецЕсли;

Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
	СоздаватьЗаказКлиента = Истина;
	ПечататьЗаказКлиента = Истина;
КонецЕсли;

Если ПолучитьФункциональнуюОпцию("ИспользоватьСчетаНаОплатуКлиентам") Тогда
	СоздаватьСчетНаОплату = Истина;
	ПечататьСчетНаОплату = Истина;
КонецЕсли;

СоздаватьЗаявкуНаВозвратТоваровОтКлиентов = Ложь;
СоздаватьДокументПродажи = Истина;
СтатусЗаказаКлиента = Перечисления.СтатусыЗаказовКлиентов.НеСогласован;
СтатусЗаявкиНаВозвратТоваровОтКлиентов = Перечисления.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КВозврату;
СтатусКоммерческогоПредложения = Перечисления.СтатусыКоммерческихПредложенийКлиентам.Действует;
СтатусРеализацииТоваровУслуг = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;

ПечататьРеализациюТоваровУслуг = Истина;
ПечататьАктВыполненныхРабот = Истина;
ПечататьСчетФактуру = Истина;
ПечататьЗаявкуНаВозвратТоваровОтКлиентов = Ложь;

СпособДоставки = Перечисления.СпособыДоставки.Самовывоз;
СпособПрогнозированияПродаж = Перечисления.СпособыПрогнозированияПродаж.ПоСтатистикеПродаж;
ЗаполнятьТоварыПоСоглашению = Ложь;
ПериодСбораСтатистики = 30;
ВариантОбеспечения = Перечисления.ВариантыОбеспечения.Требуется;
#КонецЕсли