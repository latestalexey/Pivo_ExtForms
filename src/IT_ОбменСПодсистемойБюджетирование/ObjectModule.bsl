﻿//Функция ПолучитьЗапросПоНастройке получает список запросов 
//из справочника IT_НастройкиИмпорта и соединяет их в один запрос
//
Функция ПолучитьЗапросПоНастройке(ДополнительныеОтбор=Неопределено) Экспорт
	Запрос = Новый ПостроительОтчета;
	
	ТекстЗапроса = "";
	Для Каждого ТекСтрокаЗапроса Из ЗапросБюджета.Запросы Цикл
		
		ТекстЗапроса = ТекстЗапроса + ТекСтрокаЗапроса.Запрос.Текст + ";";
		Для Каждого ТекСтрокаПараметраЗапроса Из ТекСтрокаЗапроса.Запрос.Параметры Цикл
			//Запрос.УстановитьПараметр(ТекСтрокаПараметраЗапроса.Имя, ТекСтрокаПараметраЗапроса.Значение);
			Запрос.Параметры.Вставить(ТекСтрокаПараметраЗапроса.Имя, ТекСтрокаПараметраЗапроса.Значение);
		КонецЦикла;
		
	КонецЦикла;
	ТекстЗапроса = Лев(ТекстЗапроса,СтрДлина(ТекстЗапроса)-1);
	
	Запрос.Текст = ТекстЗапроса;
	Если ДополнительныеОтбор<>Неопределено Тогда
		Запрос.УстановитьНастройки(ДополнительныеОтбор,Истина,Ложь,Ложь,Ложь,Ложь);
	КонецЕсли;
	
	Запрос.Параметры.Вставить("ДатаНачала",		НачалоДня(ДатаНачала));
	Запрос.Параметры.Вставить("ДатаОкончания",	КонецДня(ДатаОкончания));
	Запрос.Параметры.Вставить("ДатаНач",		Новый Граница(НачалоДня(ДатаНачала),ВидГраницы.Включая));
	Запрос.Параметры.Вставить("ДатаКон",		Новый Граница(КонецДня(ДатаОкончания),ВидГраницы.Включая));
	
	Возврат Запрос.ПолучитьЗапрос();
КонецФункции

ПостроительОтбор.Текст="ВЫБРАТЬ
	                       |	Подразделения.Ссылка
	                       |ИЗ
	                       |	Справочник.Подразделения КАК Подразделения
	                       |{ГДЕ
	                       |	Подразделения.Ссылка.* КАК Подразделение}
	                       |;
	                       |
	                       |////////////////////////////////////////////////////////////////////////////////
	                       |ВЫБРАТЬ
	                       |	Номенклатура.Ссылка
	                       |ИЗ
	                       |	Справочник.Номенклатура КАК Номенклатура
	                       |{ГДЕ
	                       |	Номенклатура.Ссылка.* КАК Номенклатура}
	                       |;
	                       |
	                       |////////////////////////////////////////////////////////////////////////////////
	                       |ВЫБРАТЬ
	                       |	Контрагенты.Ссылка
	                       |ИЗ
	                       |	Справочник.Контрагенты КАК Контрагенты
	                       |{ГДЕ
	                       |	Контрагенты.Ссылка.* КАК Контрагент}";
	ПостроительОтбор.ЗаполнитьНастройки();
	ПостроительОтбор.Отбор.Добавить("Подразделение");
	ПостроительОтбор.Отбор.Добавить("Номенклатура");
	ПостроительОтбор.Отбор.Добавить("Контрагент");
