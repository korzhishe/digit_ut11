﻿
&НаСервере
Функция ПолучитьПараметрыОткрытияФормы(АктВыполненныхРабот)
	
	ПараметрыОткрытияФормы = Неопределено;
	
	МассивЗаказов = ПолучитьЗаказыАктыСервер(АктВыполненныхРабот);
	
	Если ПроверитьПорядокРасчетов(АктВыполненныхРабот)
	 Или МассивЗаказов.Количество() = 0 Тогда
		
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ИмяФормы", "Документ.СчетНаОплатуКлиенту.Форма.ФормаДокумента");
		ПараметрыОткрытияФормы.Вставить("ПараметрыФормы", Новый Структура("Основание", АктВыполненныхРабот));
		
	ИначеЕсли МассивЗаказов.Количество() = 1 Тогда
		
		ПараметрыОткрытияФормы = Новый Структура();
		ПараметрыОткрытияФормы.Вставить("ИмяФормы", "Документ.СчетНаОплатуКлиенту.Форма.ФормаСозданияСчетовНаОплату");
		ПараметрыОткрытияФормы.Вставить("ПараметрыФормы", Новый Структура("ДокументОснование", МассивЗаказов[0]));
		
	КонецЕсли;
	
	Возврат ПараметрыОткрытияФормы;
	
КонецФункции

&НаСервере
Функция ПроверитьПорядокРасчетов(АктВыполненныхРабот)
	
	ПорядокРасчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АктВыполненныхРабот, "ПорядокРасчетов");
	
	Возврат ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоЗаказамНакладным;
	
КонецФункции

&НаСервере
Функция ПолучитьЗаказыАктыСервер(АктВыполненныхРабот)
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	АктВыполненныхРаботУслуги.ЗаказКлиента КАК ЗаказКлиента
		|ПОМЕСТИТЬ
		|	Заказы
		|ИЗ
		|	Документ.АктВыполненныхРабот.Услуги КАК АктВыполненныхРаботУслуги
		|ГДЕ
		|	АктВыполненныхРаботУслуги.Ссылка = &АктВыполненныхРабот
		|	И АктВыполненныхРаботУслуги.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
		|	И АктВыполненныхРаботУслуги.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
		|	И АктВыполненныхРаботУслуги.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	АктВыполненныхРабот.ЗаказКлиента КАК ЗаказКлиента
		|ИЗ
		|	Документ.АктВыполненныхРабот КАК АктВыполненныхРабот
		|ГДЕ
		|	АктВыполненныхРабот.Ссылка = &АктВыполненныхРабот
		|	И АктВыполненныхРабот.ЗаказКлиента <> НЕОПРЕДЕЛЕНО
		|	И АктВыполненныхРабот.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)
		|	И АктВыполненныхРабот.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка)
		|;
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Заказы.ЗаказКлиента КАК ЗаказКлиента
		|ИЗ
		|	Заказы КАК Заказы
		|");
		
	Запрос.УстановитьПараметр("АктВыполненныхРабот", АктВыполненныхРабот);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	МассивЗаказов = РезультатЗапроса[1].Выгрузить().ВыгрузитьКолонку("ЗаказКлиента");
	Возврат МассивЗаказов;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытияФормы = ПолучитьПараметрыОткрытияФормы(ПараметрКоманды);
	
	Если ПараметрыОткрытияФормы = Неопределено Тогда
		
		ТекстОшибки = НСтр("ru='%Документ% оформлен по нескольким заказам. Необходимо ввести счет на оплату на основании заказов.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", ПараметрКоманды);
	
		ВызватьИсключение ТекстОшибки;
		
	КонецЕсли;
	
	ОткрытьФорму(
		ПараметрыОткрытияФормы.ИмяФормы,
		ПараметрыОткрытияФормы.ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
