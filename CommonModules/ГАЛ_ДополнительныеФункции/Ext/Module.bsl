﻿

#Область ФункцииПреобразованияЦвета


// Функция вычислет степень числа
// _База    - Число                - Число, возводимое в степень
// _Степ   - Число                - Степень числа
&НаСервере
Функция Степень(_База, _Степ) Экспорт 
	Результат = 1;
	Для К = 1 По _Степ Цикл
		Результат = Результат *_База;                              
	КонецЦикла;
	Возврат Результат;
КонецФункции // Возвращает Число, возведенное в степень

// Функция переводит десятичное число в шестнадцатеричное
// Параметры:  _Число                - Число                - Десятичное число
// Возвращаемое значение:  Строка - Шестнадцатеричное число
//
&НаСервере
Функция DecToHex(Знач _Число) Экспорт 
	База = 16;
	Результат = "";
	Пока _Число <> 0 Цикл
		Поз =_Число % База;
		Результат = Сред("0123456789ABCDEF", Поз + 1, 1) + Результат;
		_Число = Цел(_Число / База);
	КонецЦикла;
	// >>Gmix  немного доработал
	Если Результат = "" Тогда
		Результат="0";
	КонецЕсли;
	Если СтрДлина(Результат)=1 Тогда
		Результат="0"+Результат;
	КонецЕсли;
	// <<Gmix
	Возврат Результат;
КонецФункции // DecToHex()

// Функция переводит шестнадцатеричное число в десятичное
// Параметры: _Hex     - Строка              - Шестнадцатеричное число
// Возвращаемое значение: Число   - Десятичное число
//
&НаСервере

Функция HexToDec(Знач _Hex) Экспорт 
	База = 16;
	_Hex = СокрЛП(_Hex);
	СтаршаяСтепень = СтрДлина(_Hex) - 1;
	Результат = 0;
	счСимволов = 1;
	Пока СтаршаяСтепень >=0 Цикл
		_HexСимвол = Сред(_Hex, счСимволов, 1);
		Представление = Найти("0123456789ABCDEF", _HexСимвол) - 1;
		Результат = Результат + Представление * Степень(База, СтаршаяСтепень);
		СтаршаяСтепень = СтаршаяСтепень - 1;
		СчСимволов = СчСимволов + 1;
	КонецЦикла;   
	Возврат Результат;
КонецФункции // HexToDec() 
//Получить значение дополнительного реквизита	
&НаСервере
Функция ПолучитьЗначениеДополнительногоРеквизита(пОбъект,ИмяСвойства) Экспорт 
		
		Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию(ИмяСвойства,Истина);
		
		Отбор = Новый Структура();
		Отбор.Вставить("Свойство",Свойство);	
		НайтиСтроки = пОбъект.ДополнительныеРеквизиты.НайтиСтроки(Отбор);
		
		Если НайтиСтроки.Количество() > 0 Тогда
			Возврат НайтиСтроки[0].Значение;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	
КонецФункции







#КонецОбласти

