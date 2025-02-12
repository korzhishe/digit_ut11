﻿
#Область ПрограммныйИнтерфейс

#Область НастройкиКомпоновкиДанныхВидовЦен

// Возвращает параметров, которые можно изменить в настройках схемы компоновки данных
//
// Возвращаемое значение:
//  Массив - Имена параметров
//
Функция ИменаРазрешенныхПараметровСхемКомпоновкиДанных() Экспорт
	
	РазрешенныеИмена = Новый Массив;
	РазрешенныеИмена.Добавить("ДатаДокумента");
	РазрешенныеИмена.Добавить("ЭтоВводНаОсновании");
	РазрешенныеИмена.Добавить("ВидЦены");
	РазрешенныеИмена.Добавить("Основание");
	
	РазрешенныеИмена.Добавить("ИспользуетсяОтборПоСегментуНоменклатуры");
	РазрешенныеИмена.Добавить("ТекстЗапросаКоэффициентУпаковки1");
	РазрешенныеИмена.Добавить("ТекстЗапросаКоэффициентУпаковки2");
	РазрешенныеИмена.Добавить("ТекстЗапросаКоэффициентУпаковки3");
	
	Возврат РазрешенныеИмена;
	
КонецФункции

// Проверяет заполненность обязательных параметров схемы компоновки данных
//
// Параметры:
//  ВидЦены - Ссылка на вид цены, для которого нужно описание параметров
//  НастройкиКомпоновкиДанных - Настройки компоновки данных
//  ПараметрыСхемКомпоновкиДанныхВидовЦен - Таблица параметров схем компоновки данных видов цен
//
// Возвращаемое значение:
//  Структура описания
//
Функция ОписаниеПараметровСхемыКомпоновкиДанных(ВидЦены,
	                                            НастройкиКомпоновкиДанных,
	                                            ПараметрыСхемКомпоновкиДанныхВидовЦен) Экспорт
	
	Для Каждого Элемент Из НастройкиКомпоновкиДанных.ПараметрыДанных.Элементы Цикл
		НайденныеСтроки = ПараметрыСхемКомпоновкиДанныхВидовЦен.НайтиСтроки(
			Новый Структура("Имя, ВидЦены", Строка(Элемент.Параметр), ВидЦены));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.Значение      = Элемент.Значение;
			НайденнаяСтрока.Использование = Элемент.Использование;
		КонецЦикла;
	КонецЦикла;
	
	ОписаниеПараметров = "";
	Для Каждого Параметр Из ПараметрыСхемКомпоновкиДанныхВидовЦен.НайтиСтроки(Новый Структура("ВидЦены", ВидЦены)) Цикл
		
		ЗначениеПараметра = Неопределено;
		Если ЗначениеЗаполнено(Параметр.Использование) Тогда
			Если Параметр.ДоступныеЗначения = Неопределено Тогда
				ЗначениеПараметра = Параметр.Значение;
			Иначе
				ДоступноеЗначение = Параметр.ДоступныеЗначения.НайтиПоЗначению(Параметр.Значение);
				Если ДоступноеЗначение <> Неопределено Тогда
					ЗначениеПараметра = ?(ЗначениеЗаполнено(
						ДоступноеЗначение.Представление), ДоступноеЗначение.Представление, Параметр.Значение);
				Иначе
					ЗначениеПараметра = Параметр.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ОписаниеПараметров = ?(ЗначениеЗаполнено(ОписаниеПараметров), ОписаниеПараметров, НСтр("ru = 'Параметры:'") + " ")
		                   + ?(Не ЗначениеЗаполнено(ОписаниеПараметров), "" , ", ")
		                   + Параметр.Заголовок
		                   + " = "
		                   + ?(ЗначениеЗаполнено(ЗначениеПараметра), Строка(ЗначениеПараметра), НСтр("ru = '<не заполнен>'"));
	КонецЦикла;
	
	ОписаниеПараметров = ОписаниеПараметров
	                   + ?(ЗначениеЗаполнено(Строка(НастройкиКомпоновкиДанных.Отбор)),
	                      " " + НСтр("ru = 'Отбор:'") + " " + Строка(НастройкиКомпоновкиДанных.Отбор),
	                      "");
	
	Возврат Новый Структура("ОписаниеПараметров", ОписаниеПараметров);
	
КонецФункции

// Возвращает имена и типы полей, которые должны обязательно присутствовать
// в СКД, используемой для заполнения цен по данным ИБ
//
// Возвращаемое значение:
//  Соответствие - В ключах содержатся имена полей, в значениях - типы полей
//
Функция ПолучитьОбязательныеПоляСхемыКомпоновкиДанных() Экспорт
	
	Поля = Новый Соответствие();
	
	Поля.Вставить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		Поля.Вставить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	КонецЕсли;
	
	Возврат Поля;
	
КонецФункции // ПолучитьОбязательныеПоляСхемыКомпоновкиДанных()

// Проверяет заполненность обязательных параметров схемы компоновки данных
//
// Параметры:
//  ВыбранныеЦены - Ссылка на вид цены, для которого нужно получить адрес настроек компоновки данных
//  АдресХранилищаНастройкиКомпоновкиДанных - Адрес с настройками компоновки данных для вида цены
//  АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен - Адрес с настройками параметров настроек компоновки данных для всех видов цен
//
// Возвращаемое значение:
//  Массив описаний ошибок - Найденные ошибки
//
Функция ПроверитьЗаполненностьОбязательныхПараметровСхемыКомпоновкиДанных(ВыбранныеЦены,
	                                                                      АдресХранилищаНастройкиКомпоновкиДанных,
	                                                                      АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен) Экспорт
	
	Ошибки = Новый Массив;
	
	РазрешенныеИмена = ИменаРазрешенныхПараметровСхемКомпоновкиДанных();
	
	ПараметрыСхемКомпоновкиДанныхВидовЦен = ПолучитьИзВременногоХранилища(АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен);
	ТаблицаНастройкиКомпоновкиДанных      = ПолучитьИзВременногоХранилища(АдресХранилищаНастройкиКомпоновкиДанных);
	
	Для Каждого ВидЦены Из ВыбранныеЦены Цикл
		НайденнаяСтрока = ТаблицаНастройкиКомпоновкиДанных.Найти(ВидЦены, "ВидЦены");
		Если НайденнаяСтрока = Неопределено Тогда
			Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не заполены обязательные параметры для вида цены ""%1""'"),
				Строка(ВидЦены));
			Ошибки.Добавить(Новый Структура("ВидЦены, Описание", ВидЦены, Описание));
		Иначе
			НайденныеСтроки = ПараметрыСхемКомпоновкиДанныхВидовЦен.НайтиСтроки(Новый Структура("ВидЦены", ВидЦены));
			Для Каждого ПараметрДанных Из НайденныеСтроки Цикл
				
				ПроверкаВыполнена = Ложь;
				
				Для Каждого СтрокаТЧ Из НайденнаяСтрока.НастройкиКомпоновкиДанных.ПараметрыДанных.Элементы Цикл
					Если Строка(СтрокаТЧ.Параметр) = ПараметрДанных.Имя Тогда
						Если Не ЗначениеЗаполнено(СтрокаТЧ.Значение)
							И РазрешенныеИмена.Найти(ПараметрДанных.Имя) = Неопределено Тогда
							Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Не заполено значение параметра ""%1"" для вида цены ""%2""'"),
								ПараметрДанных.Заголовок,
								Строка(ВидЦены));
							Ошибки.Добавить(Новый Структура("ВидЦены, Описание", ВидЦены, Описание));
						КонецЕсли;
						ПроверкаВыполнена = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не ПроверкаВыполнена Тогда
					
					Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не заполено значение параметра ""%1"" для вида цены ""%2""'"),
						ПараметрДанных.Заголовок,
						Строка(ВидЦены));
					Ошибки.Добавить(Новый Структура("ВидЦены, Описание", ВидЦены, Описание));
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ошибки;
	
КонецФункции

// Возвращает адрес настроек компоновки данных для вида цены по умолчанию
//
// Параметры:
//  ВидЦены - Ссылка на вид цены, для которого нужно получить адрес настроек компоновки данных
//  АдресХранилищаНастройкиКомпоновкиДанных - Адрес с настройками компоновки данных для всех видов цены формы
//  УникальныйИдентификатор - Уникальный идентификатор формы
//
// Возвращаемое значение:
//  Строка - адрес настроек компоновки данных для вида цены
//
Функция НастройкиСхемыКомпоновкиДанныхПоУмолчанию(ВидЦены,
	                                              АдресСхемыКомпоновкиДанных,
	                                              УникальныйИдентификатор) Экспорт
	
	НастройкиКомпоновкиДанных = ВидЦены.ХранилищеНастроекКомпоновкиДанных.Получить();
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	Если Не ЗначениеЗаполнено(НастройкиКомпоновкиДанных) Тогда
		
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		УстановитьПривилегированныйРежим(Истина);
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		УстановитьПривилегированныйРежим(Ложь);
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		
		Возврат ПоместитьВоВременноеХранилище(КомпоновщикНастроек.ПолучитьНастройки(), УникальныйИдентификатор);
		
	Иначе
		Возврат ПоместитьВоВременноеХранилище(НастройкиКомпоновкиДанных, УникальныйИдентификатор);
	КонецЕсли;
	
КонецФункции

// Устанавливает настройки компоновки данных для вида цены
//
// Параметры:
//  ВидЦены - Ссылка на вид цены, для которого нужно получить адрес настроек компоновки данных
//  АдресХранилищаНастроекДляВидаЦены - Адрес с настройками компоновки данных для вида цены
//  АдресХранилищаНастройкиКомпоновкиДанных - Адрес с настройками компоновки данных для всех видов цен
//  АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен - Адрес с настройками параметров схем компоновки данных
//
// Возвращаемое значение:
//  Структура - Описание параметров схемы компоновки данных
//
Функция УстановитьНастройкиКомпоновкиДанныхДляВидаЦены(ВидЦены,
	                                                   АдресХранилищаНастроекДляВидаЦены,
	                                                   АдресХранилищаНастройкиКомпоновкиДанных,
	                                                   АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен) Экспорт
	
	НастройкиКомпоновкиДанных        = ПолучитьИзВременногоХранилища(АдресХранилищаНастроекДляВидаЦены);
	ТаблицаНастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресХранилищаНастройкиКомпоновкиДанных);
	
	НайденнаяСтрока = ТаблицаНастройкиКомпоновкиДанных.Найти(ВидЦены, "ВидЦены");
	Если НайденнаяСтрока = Неопределено Тогда
		НайденнаяСтрока = ТаблицаНастройкиКомпоновкиДанных.Добавить();
		НайденнаяСтрока.ВидЦены = ВидЦены;
	КонецЕсли;
	НайденнаяСтрока.НастройкиКомпоновкиДанных = НастройкиКомпоновкиДанных;
	
	ПоместитьВоВременноеХранилище(ТаблицаНастройкиКомпоновкиДанных, АдресХранилищаНастройкиКомпоновкиДанных);
	
	ПараметрыСхемКомпоновкиДанныхВидовЦен = ПолучитьИзВременногоХранилища(АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен);
	Возврат ОписаниеПараметровСхемыКомпоновкиДанных(ВидЦены, НастройкиКомпоновкиДанных, ПараметрыСхемКомпоновкиДанныхВидовЦен);
	
КонецФункции

// Возвращает адрес настроек компоновки данных для вида цены
//
// Параметры:
//  ВидЦены - Ссылка на вид цены, для которого нужно получить адрес настроек компоновки данных
//  АдресХранилищаНастройкиКомпоновкиДанных - Адрес с настройками компоновки данных для всех видов цены формы
//  УникальныйИдентификатор - Уникальный идентификатор формы
//
// Возвращаемое значение:
//  Строка - адрес настроек компоновки данных для вида цены
//
Функция АдресНастроекКомпоновкиДанныхДляВидаЦены(ВидЦены,
	                                             АдресХранилищаНастройкиКомпоновкиДанных,
	                                             УникальныйИдентификатор) Экспорт
	
	ТаблицаНастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресХранилищаНастройкиКомпоновкиДанных);
	
	НайденнаяСтрока = ТаблицаНастройкиКомпоновкиДанных.Найти(ВидЦены, "ВидЦены");
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат ПоместитьВоВременноеХранилище(НайденнаяСтрока.НастройкиКомпоновкиДанных, УникальныйИдентификатор);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область РаботаСExcel

// Возвращает номер документа в пределах дня
//
// Параметры:
//  МассивДокументов - Массив, документы для выгрузки
//  УникальныйИдентификатор - Уникальный идентификатор формы
//  ПараметрыПечати - Структура, параметры печати, используемые при подготовке документов к выгрузке
//
// Возвращаемое значение:
//  Массив структур - Данные о созданных файлах
//
Функция ВыгрузитьВExcel(МассивДокументов, УникальныйИдентификатор, ПараметрыПечати) Экспорт
	
	ВозвращаемыеДанные = Новый Массив;
	
	Для Каждого Документ Из МассивДокументов Цикл
	
		АдресФайлаВоВременномХранилище = ВыгрузитьВExcelБезСсылки(Документ, УникальныйИдентификатор, ПараметрыПечати);
		
		ПараметрыФайла = Новый Структура();
		ПараметрыФайла.Вставить("Автор", Пользователи.АвторизованныйПользователь());
		ПараметрыФайла.Вставить("ВладелецФайлов", Документ);
		ПараметрыФайла.Вставить("ИмяБезРасширения", "Excel" + " " + Формат(ТекущаяДата(), "ДФ='dd.MM.yyyy ЧЧ.мм.сс'"));
		ПараметрыФайла.Вставить("РасширениеБезТочки", "xls");
		ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ТекущаяДата());
		
		Файл = ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(ПараметрыФайла, АдресФайлаВоВременномХранилище, Неопределено);
			
		Если Файл <> Неопределено Тогда
			ПрисоединенныеФайлыСлужебный.ЗанятьФайлДляРедактированияСервер(Файл);
			ДанныеФайла = ПрисоединенныеФайлы.ПолучитьДанныеФайла(Файл, УникальныйИдентификатор, Истина);
			СтрокаДанных = Новый Структура("ДанныеФайла, Файл", ДанныеФайла, Файл);
			ВозвращаемыеДанные.Добавить(СтрокаДанных);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат ВозвращаемыеДанные;
	
КонецФункции

// Возвращает номер документа в пределах дня
//
// Параметры:
//  МассивДокументов - Массив, документы для выгрузки
//  УникальныйИдентификатор - Уникальный идентификатор формы
//  ПараметрыПечати - Структура, параметры печати, используемые при подготовке документов к выгрузке
//
// Возвращаемое значение:
//  Массив структур - Данные о созданных файлах
//
Функция ВыгрузитьВExcelБезСсылки(Документ, УникальныйИдентификатор, ПараметрыПечати) Экспорт
	
	ВозвращаемыеДанные = Новый Массив;
	
	МассивОбъектов = Новый Массив;
	ОбъектыПечати  = Новый СписокЗначений;
	
	МассивОбъектов.Добавить(Документ);
	ОбъектыПечати.Добавить(Документ);
	
	ТабличныйДокумент = Документы.УстановкаЦенНоменклатуры.СформироватьПечатнуюФормуУстановкиЦенНоменклатуры(
		МассивОбъектов,
		ОбъектыПечати,
		ПараметрыПечати);
		
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ТабличныйДокумент.Записать(ИмяВременногоФайла, ТипФайлаТабличногоДокумента.XLS97);
	
	АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(
		Новый ДвоичныеДанные(ИмяВременногоФайла), УникальныйИдентификатор);
	
	Возврат АдресФайлаВоВременномХранилище;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Возвращает номер документа в пределах дня
//
// Параметры:
//  ДатаДокумента - Дата, Дата на которую нужно рассчитать номер
//  Ссылка - ДокументСсылка.УстановкаЦенНоменклатуры
//
// Возвращаемое значение:
//  Число - Номер документа
//
Функция РассчитатьНомерВПределахДня(ДатаДокумента, Ссылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МАКСИМУМ(Т.Период) КАК Дата
	|ИЗ
	|	&Таблица КАК Т
	|ГДЕ
	|	Т.Регистратор <> &Ссылка
	|	И Т.Период МЕЖДУ НАЧАЛОПЕРИОДА(&ДатаДокумента, ДЕНЬ) И КОНЕЦПЕРИОДА(&ДатаДокумента, ДЕНЬ)");
	
	Запрос.УстановитьПараметр("ДатаДокумента", ДатаДокумента);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.УстановкаЦенНоменклатуры") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Таблица", "РегистрСведений.ЦеныНоменклатуры");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Таблица", "РегистрСведений.ЦеныНоменклатурыПоставщиков");
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() И Выборка.Дата <> Null Тогда
		// Начало дня - 0 секунда. Так как как минимум один документ уже существует, то
		// нужно прибавить 1 (0 секунда соответствует номеру документа 1).
		// Так же прибавим единицу, так как нам требуется номер слудующего документа.
		Возврат Выборка.Дата - НачалоДня(ДатаДокумента) + 2;
	Иначе
		Возврат 1;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти
