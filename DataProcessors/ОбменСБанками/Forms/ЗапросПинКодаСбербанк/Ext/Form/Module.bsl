﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	НомерКонтейнера = Сред(УчетнаяЗапись, 4, 1);

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("НомерКонтейнера", НомерКонтейнера);
	СтруктураВозврата.Вставить("ПинКод", ПинКод);
	СтруктураВозврата.Вставить("ЗапомнитьСессию", ЗапомнитьПароль);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти