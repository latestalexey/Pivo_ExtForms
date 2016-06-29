﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Индикатор=0;
	ЭлементыФормы.Индикатор.МаксимальноеЗначение=КонтрагентыДляОбработки.Количество();
	мВалюта=Константы.ВалютаРегламентированногоУчета.Получить();
	Для Каждого СтрокаТЧ Из КонтрагентыДляОбработки Цикл
		Если СтрокаТЧ.Пометка Тогда
			Попытка
				Договор=Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
				Договор.Владелец=СтрокаТЧ.Контрагент;
				Договор.ВалютаВзаиморасчетов=мВалюта;
				Договор.ВестиПоДокументамРасчетовСКонтрагентом=ВестиПоДокументамРасчетовСКонтрагентами;
				Договор.ВидДоговора=ВидДоговора;
				Договор.ВедениеВзаиморасчетов=ВедениеВзаиморасчетов;
				Договор.Наименование="Договор "+НРег(Строка(ВидДоговора))+" "+Организация.Префикс;
				Договор.Организация=Организация;
				Договор.Записать();
			Исключение
				Сообщить(ОписаниеОшибки());
				Ответ=Вопрос("Не удалось создать договор для "+СтрокаТЧ.Контрагент+". Продолжить?",РежимДиалогаВопрос.ДаНет,15,КодВозвратаДиалога.Да);
				Если Ответ<>КодВозвратаДиалога.Да Тогда
					КонтрагентыДляОбработки.Очистить();
					Возврат;
				КонецЕсли;
			КонецПопытки;
		КонецЕсли;
		Индикатор=Индикатор+1;
	КонецЦикла;
	КонтрагентыДляОбработки.Очистить();
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

Процедура ЗаполнитьНажатие(Элемент)
	КонтрагентыДляОбработки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПродажиОбороты.Контрагент КАК Контрагент
		|ПОМЕСТИТЬ ВТ_Контрагенты
		|ИЗ
		|	РегистрНакопления.Продажи.Обороты(&НачПериода, &КонПериода, , ) КАК ПродажиОбороты
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДоговорыКонтрагентов.Владелец КАК Контрагент
		|ПОМЕСТИТЬ ВТ_ВладельцыДоговоров
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Организация = &Организация
		|	И ДоговорыКонтрагентов.ВедениеВзаиморасчетов = &ВедениеВзаиморасчетов
		|	И ДоговорыКонтрагентов.ВестиПоДокументамРасчетовСКонтрагентом = &ВестиПоДокументамРасчетовСКонтрагентом
		|	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Контрагенты.Контрагент,
		|	ВТ_ВладельцыДоговоров.Контрагент ЕСТЬ NULL  КАК Пометка
		|ИЗ
		|	ВТ_Контрагенты КАК ВТ_Контрагенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВладельцыДоговоров КАК ВТ_ВладельцыДоговоров
		|		ПО ВТ_Контрагенты.Контрагент = ВТ_ВладельцыДоговоров.Контрагент
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВТ_Контрагенты.Контрагент.Наименование";
	
	Запрос.УстановитьПараметр("ВедениеВзаиморасчетов", ВедениеВзаиморасчетов);
	Запрос.УстановитьПараметр("ВестиПоДокументамРасчетовСКонтрагентом", ВестиПоДокументамРасчетовСКонтрагентами);
	Запрос.УстановитьПараметр("ВидДоговора", ВидДоговора);
	Запрос.УстановитьПараметр("КонПериода", КонецДня(КонПериода));
	Запрос.УстановитьПараметр("НачПериода", НачПериода);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(КонтрагентыДляОбработки.Добавить(),ВыборкаДетальныеЗаписи);
	КонецЦикла;
КонецПроцедуры
