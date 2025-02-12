﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СписаниеЗадолженностиЗадолженность.Ссылка КАК Ссылка,
	|	КОЛИЧЕСТВО(СписаниеЗадолженностиЗадолженность.Ссылка) КАК Всего
	|ПОМЕСТИТЬ ЗаписейВТЧ
	|ИЗ
	|	Документ.СписаниеЗадолженности.Задолженность КАК СписаниеЗадолженностиЗадолженность
	|
	|СГРУППИРОВАТЬ ПО
	|	СписаниеЗадолженностиЗадолженность.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтрагентДоходыРасходы.Регистратор КАК Регистратор,
	|	КОЛИЧЕСТВО(КонтрагентДоходыРасходы.Регистратор) КАК ВсегоДвижений,
	|	ЗаписейВТЧ.Всего КАК ВсегоТЧ
	|ИЗ
	|	РегистрНакопления.ДвиженияКонтрагентДоходыРасходы КАК КонтрагентДоходыРасходы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЗаписейВТЧ КАК ЗаписейВТЧ
	|		ПО КонтрагентДоходыРасходы.Регистратор = ЗаписейВТЧ.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	КонтрагентДоходыРасходы.Регистратор,
	|	ЗаписейВТЧ.Всего
	|	
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(КонтрагентДоходыРасходы.Регистратор) <> ЗаписейВТЧ.Всего";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоДвижения", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", "РегистрНакопления.ДвиженияКонтрагентДоходыРасходы");
	
	Регистраторы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяРегистра = "РегистрНакопления.ДвиженияКонтрагентДоходыРасходы";
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.СписаниеЗадолженности");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Регистраторы,
		"РегистрНакопления.ДвиженияКонтрагентДоходыРасходы", Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
