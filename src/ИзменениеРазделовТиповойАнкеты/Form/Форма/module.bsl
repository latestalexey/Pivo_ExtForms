﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Об=Анкета.ПолучитьОбъект();
	Для Каждого СтрокаВопроса Из Об.ВопросыАнкеты Цикл
		НомРаздела=Прав(СтрокаВопроса.Вопрос.Наименование,2);
		Если СтрокаВопроса.Раздел.Наименование<>НомРаздела Тогда
			НовРаздел=Справочники.РазделыАнкеты.НайтиПоКоду(НомРаздела,Ложь,,Анкета);
			Если Не ЗначениеЗаполнено(НовРаздел) Тогда
				НовРаздел=Справочники.РазделыАнкеты.СоздатьЭлемент();
				НовРаздел.Наименование=НомРаздела;
				НовРаздел.Владелец=Анкета;
				НовРаздел.Записать();
			КонецЕсли;
			СтрокаВопроса.Раздел=НовРаздел.Ссылка;
		КонецЕсли;
	КонецЦикла;
	Если Об.Модифицированность() Тогда
		Об.Записать();
	КонецЕсли;
КонецПроцедуры
