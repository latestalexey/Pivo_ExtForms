﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	//Выгрузка остатков
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Продажи.Организация КАК Организация,
		|	Продажи.Субконто1 КАК Номенклатура,
		|	СУММА(-Продажи.КоличествоОборот) КАК КоличествоОборот
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Обороты(НАЧАЛОПЕРИОДА(&ДатаОстатков, ДЕНЬ), КОНЕЦПЕРИОДА(&ДатаОстатков, ДЕНЬ), Регистратор, Счет В ИЕРАРХИИ (&Счет41), , , КорСчет В ИЕРАРХИИ (&Счет90_02_1), ) КАК Продажи
		|ГДЕ
		|	Продажи.Регистратор.Контрагент В
		|			(ВЫБРАТЬ
		|				СобственныеКонтрагенты.Контрагент
		|			ИЗ
		|				РегистрСведений.СобственныеКонтрагенты КАК СобственныеКонтрагенты)
		|	И Продажи.Регистратор.Контрагент.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
		|
		|СГРУППИРОВАТЬ ПО
		|	Продажи.Организация,
		|	Продажи.Субконто1
		|
		|УПОРЯДОЧИТЬ ПО
		|	Организация,
		|	Номенклатура";

	Запрос.УстановитьПараметр("ДатаОстатков", ДатаОстатков);
	Запрос.УстановитьПараметр("Счет41", ПланыСчетов.Хозрасчетный.Товары);
	Запрос.УстановитьПараметр("Счет90_02_1", ПланыСчетов.Хозрасчетный.СебестоимостьПродажНеЕНВД);
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	ЗаписьФайла=Новый ЗаписьТекста(ПутьВыгрузки+"ВыгрузкаПродаж.txt");
	ЗаписьФайла.ЗаписатьСтроку(Формат(ДатаОстатков,"ДФ=yyyyMMddччммсс"));
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Строка=ВыборкаДетальныеЗаписи.Организация.Наименование+"	"
				+ВыборкаДетальныеЗаписи.Номенклатура.Код+"	"
				+Формат(ВыборкаДетальныеЗаписи.КоличествоОборот,"ЧГ=");
		ЗаписьФайла.ЗаписатьСтроку(Строка);
	КонецЦикла;
	ЗаписьФайла.Закрыть();
КонецПроцедуры

Процедура ПутьВыгрузкиНачалоВыбора(Элемент, СтандартнаяОбработка)
	Диалог=Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Каталог=ПутьВыгрузки;
	Если Диалог.Выбрать() Тогда
		ПутьВыгрузки=Диалог.Каталог+"\";
	КонецЕсли;
КонецПроцедуры
