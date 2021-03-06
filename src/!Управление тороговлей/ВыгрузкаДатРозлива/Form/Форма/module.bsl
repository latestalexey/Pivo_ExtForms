﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	//1. Формируем запрос
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровУслуг.Ссылка КАК Ссылка,
		|	ПоступлениеТоваровУслуг.Номер КАК Номер,
		|	ПоступлениеТоваровУслуг.Дата КАК Дата,
		|	ПоступлениеТоваровУслугТовары.НомерСтроки КАК НомерСтроки,
		|	ПоступлениеТоваровУслугТовары.Номенклатура,
		|	ПоступлениеТоваровУслугТовары.Номенклатура.Код КАК КодНоменклатуры,
		|	ПоступлениеТоваровУслугТовары.ДатаРозлива
		|ИЗ
		|	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
		|		ПО ПоступлениеТоваровУслугТовары.Ссылка = ПоступлениеТоваровУслуг.Ссылка
		|ГДЕ
		|	ПоступлениеТоваровУслуг.Дата МЕЖДУ &ДатаНач И &ДатаКон
		|	И ПоступлениеТоваровУслуг.ОтражатьВБухгалтерскомУчете
		|	И ПоступлениеТоваровУслуг.Проведен
		|	И ПоступлениеТоваровУслугТовары.ДатаРозлива <> ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ДатаКон", КонПериода);
	Запрос.УстановитьПараметр("ДатаНач", НачПериода);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗаписьXML = Новый ЗаписьXML();
    ЗаписьXML.УстановитьСтроку();
    СериализаторXDTO.ЗаписатьXML(ЗаписьXML, РезультатЗапроса.Выгрузить());
    СтрокаXML = ЗаписьXML.Закрыть();
	ЗаписьТекста=Новый ЗаписьТекста(Путь);
	ЗаписьТекста.Записать(СтрокаXML);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(НачПериода, ?(КонПериода='0001-01-01', КонПериода, КонецДня(КонПериода)));
	Если НастройкаПериода.Редактировать() Тогда
		НачПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры

Процедура ПутьНачалоВыбора(Элемент, СтандартнаяОбработка)
	Диалог=Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Фильтр="XML|*.xml";
	Если Диалог.Выбрать() Тогда
		Путь=Диалог.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры
