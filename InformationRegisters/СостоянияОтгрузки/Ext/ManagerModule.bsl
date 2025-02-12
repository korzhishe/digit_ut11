﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура ОтразитьСостоянияОтгрузки() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварыКОтгрузкеОстатки.ДокументОтгрузки КАК Ссылка
	|ПОМЕСТИТЬ ДанныеСостояниеТоваровОтгрузки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыКОтгрузкеОстатки.ДокументОтгрузки КАК ДокументОтгрузки,
	|		ТоварыКОтгрузкеОстатки.Номенклатура КАК Номенклатура,
	|		ТоварыКОтгрузкеОстатки.Характеристика КАК Характеристика,
	|		ТоварыКОтгрузкеОстатки.Склад КАК Склад,
	|		ТоварыКОтгрузкеОстатки.Серия КАК Серия,
	|		ТоварыКОтгрузкеОстатки.КОтгрузкеОстаток КАК КОтгрузкеОстаток,
	|		ТоварыКОтгрузкеОстатки.СобираетсяОстаток КАК СобираетсяОстаток,
	|		ТоварыКОтгрузкеОстатки.СобраноОстаток КАК СобраноОстаток
	|	ИЗ
	|		РегистрНакопления.ТоварыКОтгрузке.Остатки(, ) КАК ТоварыКОтгрузкеОстатки) КАК ТоварыКОтгрузкеОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКОтгрузкеОстатки.ДокументОтгрузки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РеализацияТоваровУслугТовары.Ссылка
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|ГДЕ
	|	РеализацияТоваровУслугТовары.Ссылка.Проведен
	|	И РеализацияТоваровУслугТовары.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|	И РеализацияТоваровУслугТовары.Ссылка.Дата >= РеализацияТоваровУслугТовары.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке
	|	И РеализацияТоваровУслугТовары.Ссылка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.КПредоплате)
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияТоваровУслугТовары.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РеализацияТоваровУслугТовары.Ссылка
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|ГДЕ
	|	РеализацияТоваровУслугТовары.Ссылка.Проведен
	|	И РеализацияТоваровУслугТовары.Ссылка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацийТоваровУслуг.Отгружено)
	|	И (НЕ РеализацияТоваровУслугТовары.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|		ИЛИ РеализацияТоваровУслугТовары.Ссылка.Дата < РеализацияТоваровУслугТовары.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке)
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияТоваровУслугТовары.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПеремещениеТоваров.Ссылка
	|ИЗ
	|	Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
	|ГДЕ
	|	ПеремещениеТоваров.Проведен
	|	И НЕ ПеремещениеТоваров.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПеремещенийТоваров.Принято)
	|	И (НЕ ПеремещениеТоваров.СкладОтправитель.ИспользоватьОрдернуюСхемуПриОтгрузке
	|		ИЛИ ПеремещениеТоваров.Дата < ПеремещениеТоваров.СкладОтправитель.ДатаНачалаОрдернойСхемыПриОтгрузке)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВнутреннееПотреблениеТоваров.Ссылка
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров КАК ВнутреннееПотреблениеТоваров
	|ГДЕ
	|	ВнутреннееПотреблениеТоваров.Проведен
	|	И НЕ ВнутреннееПотреблениеТоваров.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВнутреннихПотребленийТоваров.Отгружено)
	|	И (НЕ ВнутреннееПотреблениеТоваров.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|		ИЛИ ВнутреннееПотреблениеТоваров.Дата < ВнутреннееПотреблениеТоваров.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВозвратТоваровПоставщику.Ссылка
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
	|ГДЕ
	|	ВозвратТоваровПоставщику.Проведен
	|	И НЕ ВозвратТоваровПоставщику.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыВозвратовТоваровПоставщикам.Отгружено)
	|	И (НЕ ВозвратТоваровПоставщику.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|		ИЛИ ВозвратТоваровПоставщику.Дата < ВозвратТоваровПоставщику.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке)
	|	
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СборкаТоваров.Ссылка
	|ИЗ
	|	Документ.СборкаТоваров КАК СборкаТоваров
	|ГДЕ
	|	СборкаТоваров.Проведен
	|	И НЕ СборкаТоваров.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСборокТоваров.СобраноРазобрано)
	|	И (НЕ СборкаТоваров.Склад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|		ИЛИ СборкаТоваров.Дата < СборкаТоваров.Склад.ДатаНачалаОрдернойСхемыПриОтгрузке)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеСостояниеТоваровОтгрузки.Ссылка КАК ДокументОтгрузки
	|ИЗ
	|	ДанныеСостояниеТоваровОтгрузки КАК ДанныеСостояниеТоваровОтгрузки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияОтгрузки КАК СостоянияОтгрузки
	|		ПО (СостоянияОтгрузки.ДокументОтгрузки = ДанныеСостояниеТоваровОтгрузки.Ссылка)
	|ГДЕ
	|	СостоянияОтгрузки.ДокументОтгрузки ЕСТЬ NULL 
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеСостояниеТоваровОтгрузки.Ссылка";
	
	МассивРезультатовЗапросов = Запрос.ВыполнитьПакет();
	ДокументыОтгрузкиБезСостояния = МассивРезультатовЗапросов[1].Выбрать();
	
	МассивДокументовОтгрузки = Новый Массив;
		
	Пока ДокументыОтгрузкиБезСостояния.Следующий() Цикл                                   		
		МассивДокументовОтгрузки.Добавить(ДокументыОтгрузкиБезСостояния.ДокументОтгрузки);
	КонецЦикла;
	
	СкладыСервер.ОтразитьСостоянияОтгрузки(МассивДокументовОтгрузки, Ложь);

#КонецОбласти
КонецПроцедуры
#КонецОбласти

#КонецЕсли