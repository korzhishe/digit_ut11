﻿ 
#Область ПрограммныйИнтерфейс

// Возвращает список доступных типов оборудования.
// 
// Возвращаемое значение:
//   Массив - Массив доступных типов подключаемого оборудования в конфигурации.
//
Функция ПолучитьДоступныеТипыОборудования() Экспорт
	
	СписокОборудования = Новый Массив;
	
	// Сканеры штрихкода
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода);
	// Конец Сканеры штрихкода
	
	// Считыватели магнитных карт
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СчитывательМагнитныхКарт);
	// Конец Считыватели магнитных карт.
	
	// Считыватели RFID
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СчитывательRFID);
	// Конец Считыватели RFID.
	
	// ККТ с передачей данных ОФД
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ККТ);
	// Конец ККТ с передачей данных ОФД.
	
	// Фискальные регистраторы
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор);
	// Конец Фискальные регистраторы.
	
	// Принтеры чеков
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков);
	// Конец принтеры чеков.
	
	// Дисплеи покупателя
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ДисплейПокупателя);
	// Конец Дисплеи покупателя

	// Терминалы сбора данных
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ТерминалСбораДанных);
	// Конец Терминалы сбора данных.

	// Эквайринговые терминалы
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ЭквайринговыйТерминал);
	// Конец Эквайринговые терминалы.
	
	// Электронные весы
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ЭлектронныеВесы);
	// Конец Электронные весы
	
	// Весы с печатью этикеток
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток);
	// Конец Весы с печатью этикеток.
	
	// ККМ offline
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ККМOffline);
	// Конец ККМ offline
	
	// Принтер этикеток
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ПринтерЭтикеток);
	// Конец Принтер этикеток
	
	// Web-Сервис оборудование
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.WebСервисОборудование);
	// Конец Сервис-оборудование
	
	Возврат СписокОборудования;
	
КонецФункции

// Возвращает флаг возможности добавления новых драйверов в справочник драйверов.
// 
// Возвращаемое значение:
//   Булево - В случае разрешение добавления новых драйверов возвращает Истина.
//
Функция ВозможностьДобавленияНовыхДрайверов() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает флаг возможности использовать драйверов снятых с поддержки.
// 
// Возвращаемое значение:
//   Булево - В случае возможность использовать снятых с поддержки драйверов возвращает Истина.
//
Функция ВозможностьИспользоватьСнятыхСПоддержкиДрайверов() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает флаг возможности использовать подключаемое оборудование.
// 
// Возвращаемое значение:
//   Булево - В случае разрешение использовать подключаемое оборудование.
//
Функция ИспользоватьПодключаемоеОборудование() Экспорт
	
	Возврат Константы.ИспользоватьПодключаемоеОборудование.Получить();
	
КонецФункции

// Возвращает признак возможности обращения к разделенным данным из текущего сеанса.
//  
// Возвращаемое значение:
//  Булево - В случае вызова в неразделенной конфигурации возвращает Истина.
//
Функция ДоступноИспользованиеРазделенныхДанных() Экспорт
	
	Возврат ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных();
	
КонецФункции

// Обновление библиотеки в целевой конфигурации.
//                                   
Процедура ОбновлениеБиблиотеки() Экспорт
	
	ОбновитьПоставляемыеДрайвера();
	ОбновитьУстановленныеДрайвера();
	
КонецПроцедуры

// Обновить поставляемые драйверы в составе конфигурации.
//                                   
Процедура ОбновитьПоставляемыеДрайвера() Экспорт
	
	// Сканеры штрихкода
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодСканерыШтрихкода, "AddIn.ScancodeScanner", "ДрайверСканкодСканерШтрихкода", Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСканерыШтрихкода, "AddIn.Scaner45", , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкода, "AddIn.Scanner", "Драйвер1ССканерШтрихкода", Ложь, "8.1.8.1");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкодаNative, "AddIn.InputDevice", "Драйвер1СУстройстваВводаNative", Ложь, "8.1.8.1");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГексагонСканерыШтрихкода, "AddIn.ProtonScanner", "ДрайверГексагонСканерШтрихкода", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСканерыШтрихкода8X, "AddIn.ATOL_Scaners_1CInt", "ДрайверАТОЛУстройстваВвода8X", Ложь);
	// Конец Сканеры штрихкода
	
	//++ НЕ ГИСМ
	// Считыватели магнитных карт
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССчитывателиМагнитныхКарт, "AddIn.Scanner", "Драйвер1ССканерШтрихкода", Ложь, "8.1.8.1");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССчитывателиМагнитныхКартNative, "AddIn.InputDevice", "Драйвер1СУстройстваВводаNative", Ложь, "8.1.8.1");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСчитывателиМагнитныхКарт, "AddIn.Scaner45", , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСчитывателиМагнитныхКарт8X, "AddIn.ATOL_Scaners_1CInt", "ДрайверАТОЛУстройстваВвода8X", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикIronLogicСчитывателиБесконтактныхКарт, "AddIn.ZR1CExtension", "ДрайверIronLogicCсчитывателиZ2", Ложь, "1.2.2.1");
	// Конец Считыватели магнитных карт.
	
	// Фискальные регистраторы
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СФискальныйРегистраторЭмулятор, "AddIn.EmulatorFP1C", "Драйвер1СФискальныйРегистратор", Ложь, "1.0.13.1");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СРарусФискальныеРегистраторыФеликс, "AddIn.fr_feliksRMK1c82", "Драйвер1СРарусФискальныеРегистраторыФеликс", Ложь, "1.2.3.9");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СРарусФискальныеРегистраторыМебиус, "AddIn.fr_moebius1c82", "Драйвер1СРарусФискальныеРегистраторыМебиус", Ложь, "1.1.1.5");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолФискальныеРегистраторы, "AddIn.ATOL_KKM_1C", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолФискальныеРегистраторыУниверсальный, "AddIn.ATOL_KKM_1C", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолФискальныеРегистраторы8X, "AddIn.ATOL_KKM_1C82", "ДрайверАТОЛФискальныеРегистраторы8X", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикВерсияТФискальныеРегистраторы, "AddIn.KSBFR1K1C", , Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикККСФискальныеРегистраторы, "AddIn.SparkTF", "ДрайверККСФискальныеРегистраторы", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМФискальныеРегистраторы, "AddIn.DrvFR1C", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМФискальныеРегистраторыУниверсальный, "AddIn.SMDrvFR1C", "ДрайверШтрихМФискальныеРегистраторы", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикОРИОНФискальныеРегистраторы, "AddIn.OrionFR_1C8", , Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикКристаллСервисФискальныеРегистраторыPirit, "AddIn.PiritK", "ДрайверКристаллСервисФискальныеРегистраторыPirit", Ложь, "4.02");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикДримкасФискальныеРегистраторыVikiPrint, "AddIn.VikiP", "ДрайверДримкасФискальныеРегистраторыVikiPrint", Ложь, "4.02");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикИскраФискальныеРегистраторыПрим, "AddIn.IskraFR", "ДрайверИскраФискальныеРегистраторыПрим", Ложь, "1.0.0.5");
	// Конец Фискальные регистраторы.
	
	// ККТ с передачей данных                                                                                                                            
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолККТ54ФЗ, "AddIn.ATOL_KKM_1C82_54FZ", "ДрайверАТОЛККТ54ФЗ", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолККТ54ФЗ9X, "AddIn.ATOL_KKT_1C83_V9", "ДрайверАтолККТ54ФЗ9X", Ложь, "9.11.0.5947");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМККТ54ФЗ, "AddIn.SMDrvFR1C22", "ДрайверШтрихМККТ54ФЗ", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикВерсияТK1Ф54ФЗ, "AddIn.VT_KKT_1CInt", "ДрайверВерсияТK1Ф54ФЗ", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикИскраККТ54ФЗ, "AddIn.IskraKKT", "ДрайверИскраККТ54ФЗ", Ложь, "2.0.0.8");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикККСККТ54ФЗ, "AddIn.Spark115F", "ДрайверККСККТ54ФЗ", Ложь, "1.0.0.1");
	// Конец ККТ с передачей данных                                                                                              
	
	// Принтеры чеков
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СПринтерЧеков, "AddIn.ReceiptPrinterNative", "Драйвер1СПринтерЧеков", Ложь, "2.0.3.5");
	// Конец Принтеры чеков.
	
	// Дисплеи покупателя
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолДисплеиПокупателя, "AddIn.Line45", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикККСДисплеиПокупателя, "AddIn.VFCD220E", "ДрайверККСДисплеиПокупателя", Ложь, "1.0.1.1");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодДисплеиПокупателя, "AddIn.1CDSPPromag", "ДрайверСканкодДисплеиПокупателя", Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМДисплеиПокупателя, "AddIn.LineDisplay", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикКристаллСервисДисплеиПокупателяVikiVision, "AddIn.VikiVision", "ДрайверКристаллСервисДисплеиПокупателяVikiVision", Ложь, "1.03");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СДисплейПокупателя, "AddIn.CustomerDisplay1C", "Драйвер1СДисплейПокупателя", Ложь, "1.0.5.1");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолДисплеиПокупателя8X, "AddIn.ATOL_Line_1CInt", "ДрайверАТОЛДисплейПокупателя8X", Ложь);
	// Конец Дисплеи покупателя
	
	// Терминалы сбора данных
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолТерминалыСбораДанных, "AddIn.PDX45", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГексагонТерминалыСбораДанных, "AddIn.ProtonTSD", "ДрайверГексагонТСД", Ложь, "6.6");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанных, "AddIn.CipherLab", , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиТерминалыСбораДанных, "AddIn.iPOSoft_DT", "ДрайверСканситиТСДCipherLab", Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикКлеверенсТерминалыСбораДанных, "AddIn.Cleverence.TO_TSD", "ДрайверКлеверенсТСД", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМТерминалыСбораДанных, "AddIn.Terminals", , Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолТерминалыСбораДанныхMobileLogistics, "AddIn.PDX1C_Int", "ДрайверАТОЛТСДMobileLogistics", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанныхNative, "AddIn.CipherLab8", "ДрайверСканкодТерминалыСбораДанныхNative", Ложь, "1.0.0.6");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикRightScanТерминалыСбораДанных, "AddIn.RSExchange", "ДрайверRightScanТерминалыСбораДанных", Ложь);
	// Конец Терминалы сбора данных.
	
	// Эквайринговые терминалы
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикИНПАСЭквайринговыеТерминалыSmart, "AddIn.a_inpas1c82", "ДрайверИНПАСЭквайринговыеТерминалыSmart", Ложь, "1.0.0.24", Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикИНПАСЭквайринговыеТерминалыUNIPOS, "AddIn.a_inpasDC1c83", "ДрайверИНПАСЭквайринговыеТерминалыUNIPOS", Ложь, "1.1.1.2");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикTRPOSЭквайринговыеТерминалы, "AddIn.a_trpos1c82", "ДрайверTRPOSЭквайринговыеТерминалы", Ложь, "1.0.0.34");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСБРФЭквайринговыеТерминалы, "AddIn.SBRFCOMObject|AddIn.SBRFCOMExtension", , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикUCSEFTPOSЭквайринговыеТерминалы, "AddIn.UCS_EFTPOS", "ДрайверUCSEFTPOSЭквайринговыеТерминалы", Ложь, "1.0.8.3");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГАЗПРОМБАНКЭквайринговыеТерминалы, "AddIn.GPBEMVGateNativeAPI1C", "ДрайверГАЗПРОМБАНКЭквайринговыеТерминалы", Ложь, "1.0.3.5");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикARCUS2ЭквайринговыеТерминалыIngenico, "AddIn.IngenicoDriver1C", "ДрайверARCUS2ЭквайринговыеТерминалыIngenico", Ложь, "1.0.0.1");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикIboxProПоддержкаMPosЭквайринга, "AddIn.iboxPro", "ДрайверIboxProПоддержкаMPosЭквайринга", Ложь, "1.2.4");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМПлатежныйТерминалYarus, "AddIn.ShtrihPayMan1C", "ДрайверШтрихМПлатежныйТерминалYarus", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СЭквайринговыеТерминалыСбербанк, "AddIn.SberAcquiringTerminal", "Драйвер1СЭквайринговыеТерминалыСбербанк", Ложь, "1.0.2.1");
	// Конец Эквайринговые терминалы.
	                           
	// Электронные весы
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолЭлектронныеВесы, "AddIn.Scale45", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМЭлектронныеВесы, "AddIn.Scale45", "ДрайверШтрихМЭлектронныеВесы", Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикCASЭлектронныеВесы, "AddIn.CasCentreSimpleScale", "ДрайверCASЭлектронныеВесы", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолЭлектронныеВесы8X, "AddIn.ATOL_Scale_1CInt", "ДрайверАТОЛЭлектронныеВесы8X", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикМассаКЭлектронныеВесы, "AddIn.MassaKDriverR1C", "ДрайверМассаКЭлектронныеВесыИСПечатьюЭтикеток", Ложь, "2.3.10063");
	// Конец Электронные весы
	
	// Весы с печатью этикеток
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикACOMВесыСПечатьюЭтикеток);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМВесыСПечатьюЭтикеток, "AddIn.DrvLP", "ДрайверШтрихМВесыCПечатьюЭтикеток", Истина);    
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикCASВесыСПечатьюЭтикеток, "AddIn.CasCentrePrintingScale", "ДрайверCASВесыСПечатьюЭтикеток", Ложь); 
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикМассаКВесыСПечатьюЭтикеток, "AddIn.MassaKDriverR1C", "ДрайверМассаКЭлектронныеВесыИСПечатьюЭтикеток", Ложь, "2.3.10063");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАТОЛВесыСПечатьюЭтикеток8X, "AddIn.ATOL_ScaleLP_1CInt", "ДрайверАТОЛВесыСПечатьюЭтикеток8X", Ложь);
	// Конец Весы с печатью этикеток.
	
	// ККМ offline.
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолККМOffline);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМККМOffline);   
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СККМOffline);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СЭвоторККМOffline);
	// Конец ККМ offline
	
	// Принтеры этикеток
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГексагонПринтераЭтикеток, "AddIn.HexagonLabelPrinterDriver", "ДрайверГексагонПринтераЭтикеток", Ложь, "2.6.6");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиПринтераЭтикеток, "AddIn.ScanCityTSC1C", "ДрайверСканситиПринтераЭтикеток", Ложь, "1.0.0.42");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодПринтераЭтикетокGodexEZPL8Native, "AddIn.GodexEZPL8", "ДрайверСканкодПринтераЭтикетокGodexEZPL8Native", Ложь, "1.0.0.25");
	// Конец Принтеры этикеток.
	//-- НЕ ГИСМ
	
	// RFID считыватели
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикERFIDСчитывательRFID, "AddIn.RFIDReader", "ДрайверERFIDСчитывательRFID", Ложь, "1.0.0.11");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикКлеверенсСчитывателиRFID, "AddIn.Cleverence.TO_RFID", "ДрайверКлеверенсCчитывателиRFID", Ложь, "1.2.33");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодСчитывательRFIDCipherLab, "AddIn.CipherLab186x", "ДрайверСканкодСчитывательRFIDCipherLab", Ложь, "1.0.0.12");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикISBCСчитывательRFID, "AddIn.RFIDDevice", "ДрайверISBCСчитывательRFID", Ложь, "1.1.1.0");
	// Конец RFID считыватели
	
	//++ НЕ ГИСМ
	// Web-Сервис оборудование
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СWebСервисОборудование);
	// Конец Web-Сервис оборудование
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Обновить установленные драйвера.
//
Процедура ОбновитьУстановленныеДрайвера() Экспорт
	
	//++ НЕ ГИСМ
	// ККТ с передачей данных ОФД
	МенеджерОборудованияВызовСервера.ОбновитьУстановленныеДрайвера(Перечисления.ТипыПодключаемогоОборудования.ККТ);
	// Конец ККТ с передачей данных ОФД.
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Обновить параметры ККТ.
//
Процедура ОбновитьПараметрыККТ() Экспорт
	
// ККТ с передачей данных ОФД
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.СпособФорматоЛогическогоКонтроля = &СпособФорматоЛогическогоКонтроля
	|	И ПодключаемоеОборудование.ТипОборудования = &ТипОборудования";
	Запрос.УстановитьПараметр("СпособФорматоЛогическогоКонтроля", Перечисления.СпособыФорматоЛогическогоКонтроля.ПустаяСсылка());
	Запрос.УстановитьПараметр("ТипОборудования", Перечисления.ТипыПодключаемогоОборудования.ККТ);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Оборудование = Выборка.Ссылка.ПолучитьОбъект();
		Оборудование.СпособФорматоЛогическогоКонтроля = Перечисления.СпособыФорматоЛогическогоКонтроля.НеКонтролировать;
		Оборудование.ДопустимоеРасхождениеФорматоЛогическогоКонтроля = 0.01;
		Оборудование.ОбменДанными.Загрузка = Истина;
		Оборудование.Записать();
	КонецЦикла;
// Конец ККТ с передачей данных ОФД
	
КонецПроцедуры

#КонецОбласти

#Область ОборудованиеККТ

// Процедура заполняет реквизиты организации для регистрации ФН.
//
Процедура ЗаполнитьРеквизитыОрганизацииДляРегистрацииФН(Организация, ПараметрыРегистрации) Экспорт
	
КонецПроцедуры

// Получить структуру шаблона чека.
Функция ПолучитьСтруктуруШаблонаЧека(ПараметрыШаблонаЧека, ДополнительныйТекст = "", ТипОборудования = "") Экспорт
	
КонецФункции 

#КонецОбласти

#Область ОборудованиеOffline

// Функция возвращает префикс весового товара применяемого для генерации штрихкода.
// Используется при выгрузке в весы с печатью этикеток.
//
// Параметры:
//  ПодключаемоеОборудованиеСсылка - Ссылка на экземпляр подключаемого оборудования.
// 
// Возвращаемое значение:
//   Число - Префикс весового товара.
//
Функция ПолучитьПрефиксВесовогоТовара(ПодключаемоеОборудованиеСсылка) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Функция возвращает префикс штучного товара применяемого для генерации штрихкода.
// Используется при выгрузке в весы с печатью этикеток.
//
// Параметры:
//  ПодключаемоеОборудованиеСсылка - Ссылка на экземпляр подключаемого оборудования.
// 
// Возвращаемое значение:
//   Число - Префикс штучного товара который фасуется на весах.
//
Функция ПолучитьПрефиксШтучногоТовара(ПодключаемоеОборудованиеСсылка) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриСозданииНаСервере".
//
Процедура ЭкземплярОборудованияПриСозданииНаСервере(Объект, ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт
	//++ НЕ ГИСМ
	Элемент = ЭтаФорма.Элементы.Добавить("ПравилоОбмена", Тип("ПолеФормы"), );
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "Объект.ПравилоОбмена";
	
	// Доступ к узлу есть только для соответствующего оборудования.
	Если Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМOffline
		ИЛИ Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток
		Тогда
		ЭтаФорма.Элементы.ПравилоОбмена.Видимость = Истина;
		ПараметрыВыбораПравилаОбмена = ПолучитьПараметрыВыбораПравилаОбмена(Объект);
		Если ЗначениеЗаполнено(ПараметрыВыбораПравилаОбмена) Тогда
			ЭтаФорма.Элементы.ПравилоОбмена.ПараметрыВыбора = ПараметрыВыбораПравилаОбмена;
		КонецЕсли;
	Иначе
		ЭтаФорма.Элементы.ПравилоОбмена.Видимость = Ложь;
	КонецЕсли;
	//-- НЕ ГИСМ
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЧтенииНаСервере".
//
Процедура ЭкземплярОборудованияПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписьюНаСервере".
//
Процедура ЭкземплярОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЗаписиНаСервере".
//
Процедура ЭкземплярОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписиНаСервере".
//
Процедура ЭкземплярОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ОбработкаПроверкиЗаполненияНаСервере".
//
Процедура ЭкземплярОборудованияОбработкаПроверкиЗаполненияНаСервере(Объект, ЭтаФорма, Отказ, ПроверяемыеРеквизиты) Экспорт

КонецПроцедуры

#КонецОбласти

#Область РаботаСФормойНастройкиWebServiceОборудования

// Дополнительные переопределяемые действия с управляемой формой в Форме настройки Web-сервис оборудования
// при событии "ПриСозданииНаСервере".
//
Процедура ФормаНастройкиWebСервисОборудованияПриСозданииНаСервере(Идентификатор, ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЧтенииНаСервере".
//
Процедура ФормаНастройкиWebСервисОборудованияПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписьюНаСервере".
//
Процедура ФормаНастройкиWebСервисОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЗаписиНаСервере".
//
Процедура ФормаНастройкиWebСервисОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписиНаСервере".
//
Процедура ФормаНастройкиWebСервисОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ОбработкаПроверкиЗаполненияНаСервере".
//
Процедура ФормаНастройкиWebСервисОборудованияСохранитьЗначенияРеквизитов(Идентификатор, ЭтаФорма) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Функция создает узел для данного экземпляра подключаемого оборудования и возвращает ссылку на него
// Применяется перед записью элемента справочника Подключаемое оборудование
Функция ПолучитьУзелРИБ(ПодключаемоеОборудованиеОбъект) Экспорт
	
	//++ НЕ ГИСМ
	УзелОбъект = ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.СоздатьУзел();
	УзелОбъект.УстановитьНовыйКод();
	УзелОбъект.Наименование = ПодключаемоеОборудованиеОбъект.Наименование;
	УзелОбъект.Записать();
	
	Возврат УзелОбъект.Ссылка;
	//-- НЕ ГИСМ
	
	Возврат Неопределено;
	
КонецФункции

// Функция возвращает параметры выбора для поля ввода ПравилоОбмена.
//
Функция ПолучитьПараметрыВыбораПравилаОбмена(ПодключаемоеОборудованиеОбъект) Экспорт
	
	ПараметрыВыбора = Новый Массив;
	
	//++ НЕ ГИСМ
	Если ПодключаемоеОборудованиеОбъект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипПодключаемогоОборудования", Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток);
	ИначеЕсли ПодключаемоеОборудованиеОбъект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККМOffline Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипПодключаемогоОборудования", Перечисления.ТипыПодключаемогоОборудования.ККМOffline);
	КонецЕсли;
	
	ПараметрыВыбора.Добавить(НовыйПараметр);
	//-- НЕ ГИСМ
	
	Возврат Новый ФиксированныйМассив(ПараметрыВыбора);
	
КонецФункции

#КонецОбласти