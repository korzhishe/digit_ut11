﻿
#Область ПрограммныйИнтерфейс

//Функция-конструктор структуры корректировки строк заказа
//
// Возвращаемое значение:
//  Структура - Структура параметров для корректировки строк заказа.
//      * Заказы								 - Массив - Заказы, по которым требуется скорректировать строки.
//      * ДокументИнициатор						 - ДокументОбъект - Документ, из которого был вызван метод корректировки заказов.
//      * СкорректироватьМерныеТовары			 - Булево - Строки заказа, по которым было отгружено и оформлено товара меньше, чем в заказе в пределах допустимого отклонения, будут уменьшены.
//      * СкорректироватьМерныеТоварыПоПриемке	 - Булево - Строки заказа, по которым было отгружено и оформлено товара больше, чем в заказе в пределах допустимого отклонения, будут увеличены
//      * ЗакрыватьЗаказы						 - Булево - Нужно ли предпринять попытку установки статуса Закрыт для закза
//
Функция ПараметрыПомощникаЗакрытияЗаказов() Экспорт
	
	Структура = Новый Структура;
	
	Структура.Вставить("Заказы");
	Структура.Вставить("ДокументИнициатор");
	
	Структура.Вставить("СкорректироватьМерныеТовары",             Истина);
	Структура.Вставить("СкорректироватьМерныеТоварыПоПриемке",    Ложь);
	Структура.Вставить("ЗакрыватьЗаказы",                         Истина);
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти




