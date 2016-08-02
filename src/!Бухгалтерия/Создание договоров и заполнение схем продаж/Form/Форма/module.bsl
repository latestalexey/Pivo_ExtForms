﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	ОбСхема=Схема.ПолучитьОбъект();
	Для Каждого СтрокаПродавец Из Продавцы Цикл
		Для Каждого СтрокаПокупатель Из Покупатели Цикл
			СтрокаТЧ=ОбСхема.Состав.Добавить();
			СтрокаТЧ.Договор1=ПолучитьДоговорПродажи(СтрокаПродавец.Контрагент,СтрокаПокупатель.Контрагент);
			СтрокаТЧ.Договор2=ПолучитьДоговорПокупки(СтрокаПродавец.Контрагент,СтрокаПокупатель.Контрагент);
			СтрокаТЧ.ЗависимОт=Уровень-1;
			СтрокаТЧ.НомерШага=Уровень;
		КонецЦикла;
	КонецЦикла;
	ОбСхема.ПолучитьФорму().Открыть();
КонецПроцедуры

Функция ПолучитьДоговорПродажи(Продавец, Покупатель)
	
	Отбор=Новый Структура("Контрагент");
	Набор=РегистрыСведений.СобственныеКонтрагенты.СоздатьНаборЗаписей();
	Набор.Прочитать();
	Таб=Набор.Выгрузить();
	Организация	=Таб.Найти(Продавец,"Контрагент").Организация;
	Контрагент	=Покупатель;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.Ссылка
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Владелец = &Контрагент
		|	И ДоговорыКонтрагентов.Организация = &Организация
		|	И НЕ ДоговорыКонтрагентов.ПометкаУдаления
		|	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора";

	Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат=Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Договор=Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
		Договор.Владелец		= Контрагент;
		Договор.Организация		= Организация;
		Договор.Наименование	= Организация.Наименование +" продает "+Контрагент.Наименование;
		Договор.ВидДоговора		= Перечисления.ВидыДоговоровКонтрагентов.СПокупателем;
		Форма=Договор.ПолучитьФорму();
		Форма.Открыть();
		Договор.Записать();
		Форма.Закрыть();
	Иначе
		Выборка=Результат.Выбрать();
		Выборка.Следующий();
		Договор=Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Договор.Ссылка;
КонецФункции

Функция ПолучитьДоговорПокупки(Продавец, Покупатель)
	
	Отбор=Новый Структура("Контрагент");
	Набор=РегистрыСведений.СобственныеКонтрагенты.СоздатьНаборЗаписей();
	Набор.Прочитать();
	Таб=Набор.Выгрузить();
	Организация	=Таб.Найти(Покупатель,"Контрагент").Организация;
	Контрагент	=Продавец;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.Ссылка
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Владелец = &Контрагент
		|	И ДоговорыКонтрагентов.Организация = &Организация
		|	И НЕ ДоговорыКонтрагентов.ПометкаУдаления
		|	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора";

	Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Результат=Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Договор=Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
		Договор.Владелец		= Контрагент;
		Договор.Организация		= Организация;
		Договор.Наименование	= Организация.Наименование +" покупает у "+Контрагент.Наименование;
		Договор.ВидДоговора		= Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
		Форма=Договор.ПолучитьФорму();
		Форма.Открыть();
		Договор.Записать();
		Форма.Закрыть();
	Иначе
		Выборка=Результат.Выбрать();
		Выборка.Следующий();
		Договор=Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Договор.Ссылка;
КонецФункции


Процедура СхемаПриИзменении(Элемент)
	ЭлементыФормы.Уровень.МинимальноеЗначение=1;
	ЭлементыФормы.Уровень.МаксимальноеЗначение=Схема.КолШагов;
	Уровень=1;
	ЗаполнитьТабилцы();
КонецПроцедуры

Процедура ЗаполнитьТабилцы()
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СхемыПродажСостав.Договор1,
		|	СхемыПродажСостав.Договор2
		|ПОМЕСТИТЬ ВТ_Договоры
		|ИЗ
		|	Справочник.СхемыПродаж.Состав КАК СхемыПродажСостав
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СхемыПродаж КАК СхемыПродаж
		|		ПО СхемыПродажСостав.Ссылка = СхемыПродаж.Ссылка
		|ГДЕ
		|	СхемыПродаж.Ссылка = &Схема
		|	И СхемыПродажСостав.НомерШага = &Уровень
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_Договоры.Договор2.Владелец КАК Продавец
		|ИЗ
		|	ВТ_Договоры КАК ВТ_Договоры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_Договоры.Договор1.Владелец КАК Покупатель
		|ИЗ
		|	ВТ_Договоры КАК ВТ_Договоры";
	
	Запрос.УстановитьПараметр("Схема", Схема);
	Запрос.УстановитьПараметр("Уровень", Уровень);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Покупатели.Очистить();
	Продавцы.Очистить();
	
	Для Каждого СтрокаТЧ Из РезультатЗапроса[1].Выгрузить() Цикл
		Продавцы.Добавить().Контрагент=СтрокаТЧ.Продавец;
	КонецЦикла;
	Для Каждого СтрокаТЧ Из РезультатЗапроса[2].Выгрузить() Цикл
		Покупатели.Добавить().Контрагент=СтрокаТЧ.Покупатель;
	КонецЦикла;
КонецПроцедуры


Процедура УровеньПриИзменении(Элемент)
	ЗаполнитьТабилцы();
КонецПроцедуры

