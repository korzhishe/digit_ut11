﻿/////////////////////////////////////Обработка заполнения






/////////////////////////////////////Обработка проведения

Процедура ГАЛ_ОбработкаПроведенияРасходныйОрдерНаТоварыОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
//ПРФТ ++  временно
		
	
//Необходимо проверить, есть ли расходные ордера не со статусом отгрцжен, если есть нечего не делаем
// если есть необхоимо проверить статус задания на доставку, если есть тогда меняем статус задания на "К распределению"
//Если Источник.Статус = Перечисления.СтатусыРасходныхОрдеров.Отгружен Тогда
//	
//	   Отгружен = истина;
//	   //Необходимо найти есть ли еще расходные ордера в подчинении заказа
//	   Если Источник.ТоварыПоРаспоряжениям.Количество()>0 Тогда
//		   
//		   Основание = Источник.ТоварыПоРаспоряжениям[0].Распоряжение;
//		   
//		   Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
//			   
//			   Запрос = Новый Запрос;
//			   Запрос.Текст = "ВЫБРАТЬ
//			   |	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка
//			   |ИЗ
//			   |	Документ.РасходныйОрдерНаТовары.ТоварыПоРаспоряжениям КАК РасходныйОрдерНаТоварыТоварыПоРаспоряжениям
//			   |ГДЕ
//			   |	РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Проведен = ИСТИНА
//			   |	И РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Статус <> &СтатусОтгружен
//			   |	И РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Распоряжение = &Распоряжение
//			   |	И РасходныйОрдерНаТоварыТоварыПоРаспоряжениям.Ссылка.Ссылка <> &ТекДокумент";
//			   
//			   Запрос.УстановитьПараметр("СтатусОтгружен", Перечисления.СтатусыРасходныхОрдеров.Отгружен);
//			   Запрос.УстановитьПараметр("Распоряжение", Основание);
//			   Запрос.УстановитьПараметр("ТекДокумент", Источник.Ссылка);
//			   
//			   Результат = Запрос.Выполнить();
//			   Выборка = Результат.Выбрать();
//			   
//			   Если Выборка.Количество() > 0 Тогда
//				   Отгружен = Ложь;
//			   КонецЕсли;
//			   
//			   
//		   КонецЕсли;
//			
//			
//		   Если Отгружен Тогда //Ищем задание на доставку и ставим статус к распределению
//			   
//			    Запрос = Новый Запрос;
//				Запрос.Текст = "ВЫБРАТЬ
//				               |	РеализацияТоваровУслуг.Ссылка
//				               |ПОМЕСТИТЬ ТЗРеализации
//				               |ИЗ
//				               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
//				               |ГДЕ
//				               |	РеализацияТоваровУслуг.Проведен = ИСТИНА
//				               |	И РеализацияТоваровУслуг.ЗаказКлиента = &ЗаказКлиента
//				               |;
//				               |
//				               |////////////////////////////////////////////////////////////////////////////////
//				               |ВЫБРАТЬ
//				               |	ГАЛ_ЗаказНаДоставку.Ссылка
//				               |ИЗ
//				               |	Документ.ГАЛ_ЗаказНаДоставку КАК ГАЛ_ЗаказНаДоставку
//				               |ГДЕ
//				               |	ГАЛ_ЗаказНаДоставку.Проведен = ИСТИНА
//				               |	И (ГАЛ_ЗаказНаДоставку.СтатусДоставки = &СтатусДоставкиНовая
//				               |			ИЛИ ГАЛ_ЗаказНаДоставку.СтатусДоставки = &СтатусДоставкиПечатается)
//				               |	И ГАЛ_ЗаказНаДоставку.ДокументОснование В
//				               |			(ВЫБРАТЬ
//				               |				ТЗРеализации.Ссылка
//				               |			ИЗ
//				               |				ТЗРеализации КАК ТЗРеализации)
//				               |
//				               |ОБЪЕДИНИТЬ ВСЕ
//				               |
//				               |ВЫБРАТЬ
//				               |	ГАЛ_ЗаказНаДоставку.Ссылка
//				               |ИЗ
//				               |	Документ.ГАЛ_ЗаказНаДоставку КАК ГАЛ_ЗаказНаДоставку
//				               |ГДЕ
//				               |	ГАЛ_ЗаказНаДоставку.СтатусДоставки = &СтатусДоставкиНовая
//				               |	И ГАЛ_ЗаказНаДоставку.Проведен = ИСТИНА
//				               |	И ГАЛ_ЗаказНаДоставку.ДокументОснование = &ДокументОснование";
//				
//				Запрос.УстановитьПараметр("СтатусДоставкиНовая",Справочники.ГАЛ_СтатусыЗаявокНаДоставку.Новый );
//				Запрос.УстановитьПараметр("СтатусДоставкиПечатается",Справочники.ГАЛ_СтатусыЗаявокНаДоставку.Доставляется );

//				Запрос.УстановитьПараметр("ЗаказКлиента",Основание );
//				Запрос.УстановитьПараметр("ДокументОснование",Источник.Ссылка );
//				
//				
//				Результат = Запрос.Выполнить();
//				Выборка = Результат.Выбрать();
//				
//				Если Выборка.Количество()>0 Тогда
//					Пока Выборка.Следующий() Цикл
//						
//						  ТекОбъектЗаказаНаДоставку = Выборка.Ссылка.ПолучитьОбъект();
//						  ТекОбъектЗаказаНаДоставку.СтатусДоставки = Справочники.ГАЛ_СтатусыЗаявокНаДоставку.КРаспределению;
//						  ТекОбъектЗаказаНаДоставку.Записать(РежимЗаписиДокумента.Проведение);
//						  
//						
//					КонецЦикла;
//				КонецЕсли;
//			
//				
//		   КонецЕсли;
//		   
//			
//		   
//	   КонецЕсли;   
//КонецЕсли;

	
	

КонецПроцедуры
