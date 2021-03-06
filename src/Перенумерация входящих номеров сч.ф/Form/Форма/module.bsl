﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Для Каждого СтрокаТЧ Из ТабДокументов Цикл
		Если ЗначениеЗаполнено(СтрокаТЧ.СчетФактураВыданный) И 
			ЗначениеЗаполнено(СтрокаТЧ.СчетФактураПолученный) Тогда
			Об=СтрокаТЧ.СчетФактураПолученный.ПолучитьОбъект();
			Об.НомерВходящегоДокумента=СтрокаТЧ.СчетФактураВыданный.Номер;
			Об.Записать();
		КонецЕсли;
	КонецЦикла;
	ТабДокументов.Очистить();
	Сообщить("Входящие номера документов изменены");
КонецПроцедуры

Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(НачалоКвартала, ?(КонецКвартала='0001-01-01', КонецКвартала, КонецДня(КонецКвартала)));
	Если НастройкаПериода.Редактировать() Тогда
		НачалоКвартала = НастройкаПериода.ПолучитьДатуНачала();
		КонецКвартала = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры

Процедура ДействияФормыЗаполнить(Кнопка)
	ТабДокументов.Очистить();

	Запрос = Новый Запрос;
	
	Запрос.Текст="ВЫБРАТЬ
	             |	РеализацияТоваровУслуг.Ссылка КАК РТУ,
	             |	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
	             |	СУММА(-РеализацияТоваровУслугТовары.Количество) КАК Количество
	             |ПОМЕСТИТЬ ВТРеализация
	             |ИЗ
	             |	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	             |		ПО РеализацияТоваровУслугТовары.Ссылка = РеализацияТоваровУслуг.Ссылка
	             |ГДЕ
	             |	РеализацияТоваровУслуг.Проведен
	             |	И РеализацияТоваровУслуг.Организация = &Организация
	             |	И РеализацияТоваровУслуг.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоКвартала, ДЕНЬ) И КОНЕЦПЕРИОДА(&КонецКвартала, ДЕНЬ)
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	РеализацияТоваровУслуг.Ссылка,
	             |	РеализацияТоваровУслугТовары.Номенклатура
	             |
	             |ИНДЕКСИРОВАТЬ ПО
	             |	РТУ,
	             |	Номенклатура
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ПоступлениеТоваровУслуг.Ссылка КАК ПТУ,
	             |	ПоступлениеТоваровУслугТовары.Номенклатура КАК Номенклатура,
	             |	СУММА(ПоступлениеТоваровУслугТовары.Количество) КАК Количество
	             |ПОМЕСТИТЬ ВТПоступление
	             |ИЗ
	             |	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	             |		ПО ПоступлениеТоваровУслугТовары.Ссылка = ПоступлениеТоваровУслуг.Ссылка
	             |ГДЕ
	             |	ПоступлениеТоваровУслуг.Проведен
	             |	И ПоступлениеТоваровУслуг.Контрагент = &СвКонтрагент
	             |	И ПоступлениеТоваровУслуг.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&НачалоКвартала, ДЕНЬ) И КОНЕЦПЕРИОДА(&КонецКвартала, ДЕНЬ)
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ПоступлениеТоваровУслуг.Ссылка,
	             |	ПоступлениеТоваровУслугТовары.Номенклатура
	             |
	             |ИНДЕКСИРОВАТЬ ПО
	             |	ПТУ,
	             |	Номенклатура
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ВТРеализация.РТУ КАК РТУ,
	             |	ЕСТЬNULL(ВТПоступление.ПТУ, ЗНАЧЕНИЕ(Документ.ПоступлениеТоваровУслуг.ПустаяСсылка)) КАК ПТУ,
	             |	ВТРеализация.Номенклатура КАК Номенклатура,
	             |	ВТРеализация.Количество
	             |ПОМЕСТИТЬ ВТ_ДекартовоРеализация
	             |ИЗ
	             |	ВТРеализация КАК ВТРеализация
	             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоступление КАК ВТПоступление
	             |		ПО ВТРеализация.РТУ.Контрагент.ИНН = ВТПоступление.ПТУ.Организация.ИНН
	             |			И ВТРеализация.РТУ.Организация.ИНН = ВТПоступление.ПТУ.Контрагент.ИНН
	             |			И (НАЧАЛОПЕРИОДА(ВТРеализация.РТУ.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(ВТПоступление.ПТУ.Дата, ДЕНЬ))
	             |
	             |ИНДЕКСИРОВАТЬ ПО
	             |	РТУ,
	             |	ПТУ,
	             |	Номенклатура
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ЕСТЬNULL(ВТРеализация.РТУ, ЗНАЧЕНИЕ(Документ.РеализацияТоваровУслуг.ПустаяСсылка)) КАК РТУ,
	             |	ВТПоступление.ПТУ КАК ПТУ,
	             |	ВТПоступление.Номенклатура КАК Номенклатура,
	             |	ВТПоступление.Количество
	             |ПОМЕСТИТЬ ВТ_ДекартовоПоступление
	             |ИЗ
	             |	ВТРеализация КАК ВТРеализация
	             |		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоступление КАК ВТПоступление
	             |		ПО ВТРеализация.РТУ.Контрагент.ИНН = ВТПоступление.ПТУ.Организация.ИНН
	             |			И ВТРеализация.РТУ.Организация.ИНН = ВТПоступление.ПТУ.Контрагент.ИНН
	             |			И (НАЧАЛОПЕРИОДА(ВТРеализация.РТУ.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(ВТПоступление.ПТУ.Дата, ДЕНЬ))
	             |
	             |ИНДЕКСИРОВАТЬ ПО
	             |	РТУ,
	             |	ПТУ,
	             |	Номенклатура
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ВложенныйЗапрос.СчФ_В КАК СчетФактураВыданный,
	             |	ВложенныйЗапрос.СчФ_В.Организация КАК СчетФактураВыданныйОрганизация,
	             |	ВложенныйЗапрос.СчФ_В.Контрагент КАК СчетФактураВыданныйКонтрагент,
	             |	ВложенныйЗапрос.РТУ.СуммаДокумента КАК РеализацияСумма,
	             |	ВложенныйЗапрос.СчФ_П КАК СчетФактураПолученный,
	             |	ВложенныйЗапрос.СчФ_П.Организация КАК СчетФактураПолученныйОрганизация,
	             |	ВложенныйЗапрос.СчФ_П.Контрагент КАК СчетФактураПолученныйКонтрагент,
	             |	ВложенныйЗапрос.ПТУ.СуммаДокумента КАК ПоступлениеСумма
	             |ИЗ
	             |	(ВЫБРАТЬ
	             |		ВложенныйЗапрос.РТУ КАК РТУ,
	             |		ВложенныйЗапрос.ПТУ КАК ПТУ,
	             |		ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	             |		СУММА(ВложенныйЗапрос.Количество) КАК Количество,
	             |		СчетФактураВыданный.Ссылка КАК СчФ_В,
	             |		СчетФактураПолученный.Ссылка КАК СчФ_П
	             |	ИЗ
	             |		(ВЫБРАТЬ
	             |			ВТ_ДекартовоРеализация.РТУ КАК РТУ,
	             |			ВТ_ДекартовоРеализация.ПТУ КАК ПТУ,
	             |			ВТ_ДекартовоРеализация.Номенклатура КАК Номенклатура,
	             |			ВТ_ДекартовоРеализация.Количество КАК Количество
	             |		ИЗ
	             |			ВТ_ДекартовоРеализация КАК ВТ_ДекартовоРеализация
	             |		
	             |		ОБЪЕДИНИТЬ ВСЕ
	             |		
	             |		ВЫБРАТЬ
	             |			ВТ_ДекартовоПоступление.РТУ,
	             |			ВТ_ДекартовоПоступление.ПТУ,
	             |			ВТ_ДекартовоПоступление.Номенклатура,
	             |			ВТ_ДекартовоПоступление.Количество
	             |		ИЗ
	             |			ВТ_ДекартовоПоступление КАК ВТ_ДекартовоПоступление) КАК ВложенныйЗапрос
	             |			ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный КАК СчетФактураВыданный
	             |			ПО ВложенныйЗапрос.РТУ = СчетФактураВыданный.ДокументОснование
	             |			ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный КАК СчетФактураПолученный
	             |			ПО ВложенныйЗапрос.ПТУ = СчетФактураПолученный.ДокументОснование
	             |	
	             |	СГРУППИРОВАТЬ ПО
	             |		ВложенныйЗапрос.Номенклатура,
	             |		ВложенныйЗапрос.РТУ,
	             |		ВложенныйЗапрос.ПТУ,
	             |		СчетФактураВыданный.Ссылка,
	             |		СчетФактураПолученный.Ссылка) КАК ВложенныйЗапрос
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ВложенныйЗапрос.РТУ.СуммаДокумента,
	             |	ВложенныйЗапрос.ПТУ.СуммаДокумента,
	             |	ВложенныйЗапрос.СчФ_В,
	             |	ВложенныйЗапрос.СчФ_В.Организация,
	             |	ВложенныйЗапрос.СчФ_В.Контрагент,
	             |	ВложенныйЗапрос.СчФ_П,
	             |	ВложенныйЗапрос.СчФ_П.Организация,
	             |	ВложенныйЗапрос.СчФ_П.Контрагент
	             |
	             |ИМЕЮЩИЕ
	             |	МАКСИМУМ(ВложенныйЗапрос.Количество) = 0
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	ВложенныйЗапрос.СчФ_В.Дата";

	Запрос.УстановитьПараметр("КонецКвартала", КонецКвартала);
	Запрос.УстановитьПараметр("НачалоКвартала", НачалоКвартала);
	Запрос.УстановитьПараметр("Организация", Организация);
	Выборка=РегистрыСведений.СобственныеКонтрагенты.Выбрать(Новый Структура("Организация",Организация));
	Если Выборка.Следующий() Тогда
		Запрос.УстановитьПараметр("СвКонтрагент", Выборка.Контрагент);
	Иначе
		Сообщить("Не связан контрагент с организацией");
		Возврат;
	КонецЕсли;

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяСтрока=ТабДокументов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,ВыборкаДетальныеЗаписи);
	КонецЦикла;
КонецПроцедуры
