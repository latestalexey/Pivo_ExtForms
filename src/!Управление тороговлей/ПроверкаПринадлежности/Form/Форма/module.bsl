﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Набор=Док.ПолучитьОбъект().ПринадлежностьПоследовательностям.ПартионныйУчет;
	Набор.Прочитать();
	Если Набор.Количество()>0 Тогда
		Сообщить("ЮХУ!");
	КонецЕсли;
КонецПроцедуры
