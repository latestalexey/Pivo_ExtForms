﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Кнопка1Нажатие(Неопределено);
	Кнопка2Нажатие(Неопределено);
	Кнопка3Нажатие(Неопределено);
КонецПроцедуры

Процедура Кнопка1Нажатие(Элемент)
	НаборЗаписей=РегистрыСведений.ОчередьОтправкиСМСРегистрацияЕГАИС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ДокументПродажи.Установить(ДокументДляпрверки);
	НаборЗаписей.Записать();
	
	ИТИМодуль_СверкаСЕГАИС.ЗагеристироватьДокументДляПроверки(ДокументДляпрверки);
КонецПроцедуры

Процедура Кнопка2Нажатие(Элемент)
	ИТИМодуль_СверкаСЕГАИС.ВыполнитьПоискДокументовВБухгалтерии();
КонецПроцедуры

Процедура Кнопка3Нажатие(Элемент)
	ИТИМодуль_СверкаСЕГАИС.ВыполнитьПоискДокументовВЕГАИС();
КонецПроцедуры
