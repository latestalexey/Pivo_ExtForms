﻿	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслуг.Организация,
		|	ПоступлениеТоваровУслуг.Склад,
		|	ПоступлениеТоваровУслугТовары.СерияНоменклатуры
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
		|		ПО ПоступлениеТоваровУслугТовары.Ссылка = ПоступлениеТоваровУслуг.Ссылка
		|ГДЕ
		|	ПоступлениеТоваровУслугТовары.СерияНоменклатуры <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|	И ПоступлениеТоваровУслугТовары.СерияНоменклатуры.Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Об=ВыборкаДетальныеЗаписи.СерияНоменклатуры.ПолучитьОбъект();
		Об.Склад=ВыборкаДетальныеЗаписи.Склад;
		Об.Записать();
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
