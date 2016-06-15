﻿Перем ПараметрыФормы Экспорт;

Перем ОбрабатываемыеДанные;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(ПараметрыФормы) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ОбрабатываемыеДанные, ПараметрыФормы);
		ОбрабатываемыеДанные.Вставить("Регион", ПараметрыФормы.КодРегиона);
	КонецЕсли;
	
	Наименование = ОбрабатываемыеДанные.Наименование;
	ИНН = ОбрабатываемыеДанные.ИНН;
	КПП = ОбрабатываемыеДанные.КПП;
	
	ВывестиПредставлениеАдреса();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

Процедура АдресОПНажатие(Элемент)
	
	ИДКонфигурации = РегламентированнаяОтчетность.ИДКонфигурации();
	ЭтоУПП_КА = (ИДКонфигурации = "УПП" ИЛИ ИДКонфигурации = "КА");
	
	ФормаВводаАдреса = РегламентированнаяОтчетность.роПолучитьОбщуюФорму("ВводРоссийскогоАдреса");
	ФормаВводаАдреса.НачальноеЗначениеВыбора = ОбрабатываемыеДанные;
	ЗаполнитьЗначенияСвойств(ФормаВводаАдреса, ОбрабатываемыеДанные, "ТипДома, ТипКорпуса, ТипКвартиры");
	
	Если ФормаВводаАдреса.ОткрытьМодально() Тогда
		ЗаполнитьЗначенияСвойств(ОбрабатываемыеДанные, ФормаВводаАдреса.НачальноеЗначениеВыбора);
		ЗаполнитьЗначенияСвойств(ОбрабатываемыеДанные, ФормаВводаАдреса, "ТипДома, ТипКорпуса, ТипКвартиры");
		Если ЭтоУПП_КА Тогда
			ОбрабатываемыеДанные.ПредставлениеАдреса = ФормаВводаАдреса.Представление;
		Иначе
			ОбрабатываемыеДанные.ПредставлениеАдреса = ФормаВводаАдреса.ПредставлениеНаФорме;
		КонецЕсли;
		
		Модифицированность = Истина;
	КонецЕсли;
	
	ВывестиПредставлениеАдреса();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ЭтаФорма.Закрыть(РезультатВвода());
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция РезультатВвода()
	
	ОбрабатываемыеДанные.Наименование = Наименование;
	ОбрабатываемыеДанные.ИНН = ИНН;
	ОбрабатываемыеДанные.КПП = КПП;
	
	КодРегиона = ОбрабатываемыеДанные.Регион;
	ОбрабатываемыеДанные.Удалить("Регион");
	ОбрабатываемыеДанные.Вставить("КодРегиона", КодРегиона);
	
	Возврат ОбрабатываемыеДанные;
	
КонецФункции

Процедура ВывестиПредставлениеАдреса()
	
	Если НЕ ПустаяСтрока(ОбрабатываемыеДанные.ПредставлениеАдреса) Тогда
		ЭлементыФормы.АдресОП.Заголовок = ОбрабатываемыеДанные.ПредставлениеАдреса;
	Иначе
		ЭлементыФормы.АдресОП.Заголовок = "Ввести адрес обособленного подразделения";
	КонецЕсли;
	
КонецПроцедуры

ОбрабатываемыеДанные= Новый Структура;

ОбрабатываемыеДанные.Вставить("Наименование", "");
ОбрабатываемыеДанные.Вставить("ИНН",          "");
ОбрабатываемыеДанные.Вставить("КПП",          "");

ОбрабатываемыеДанные.Вставить("Индекс",          "");
ОбрабатываемыеДанные.Вставить("Регион",          "");
ОбрабатываемыеДанные.Вставить("Район",           "");
ОбрабатываемыеДанные.Вставить("Город",           "");
ОбрабатываемыеДанные.Вставить("НаселенныйПункт", "");
ОбрабатываемыеДанные.Вставить("Улица",           "");
ОбрабатываемыеДанные.Вставить("Дом",             "");
ОбрабатываемыеДанные.Вставить("Корпус",          "");
ОбрабатываемыеДанные.Вставить("Квартира",        "");
ОбрабатываемыеДанные.Вставить("ТипДома",         "");
ОбрабатываемыеДанные.Вставить("ТипКорпуса",      "");
ОбрабатываемыеДанные.Вставить("ТипКвартиры",     "");

ОбрабатываемыеДанные.Вставить("ПредставлениеАдреса", "");
