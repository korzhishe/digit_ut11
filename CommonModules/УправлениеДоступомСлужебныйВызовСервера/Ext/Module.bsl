﻿#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обслуживание таблиц ВидыДоступа и ЗначенияДоступа в формах редактирования.

// Только для внутреннего использования.
Функция СформироватьДанныеВыбораПользователя(Знач Текст,
                                             Знач ВключаяГруппы = Истина,
                                             Знач ВключаяВнешнихПользователей = Неопределено,
                                             Знач БезПользователей = Ложь) Экспорт
	
	Возврат Пользователи.СформироватьДанныеВыбораПользователя(
		Текст,
		ВключаяГруппы,
		ВключаяВнешнихПользователей,
		БезПользователей);
	
КонецФункции

#КонецОбласти
