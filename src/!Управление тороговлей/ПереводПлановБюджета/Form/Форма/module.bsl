﻿Перем ТекстЗапроса;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	Запрос=Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Подразделение",		Подразделение);
	Запрос.УстановитьПараметр("СценарийБюджета",	Сценарий);
	Запрос.УстановитьПараметр("ДатаНач",			НачалоДня(НачПериода));
	Запрос.УстановитьПараметр("ДатаКон",			КонецДня(КонПериода));
	Запрос.УстановитьПараметр("ВидБюджета",			Перечисления.IT_ВидыБюджета.БДР);
	
	Результат=Запрос.Выполнить();
	РезТаб=Результат.Выгрузить();
	Подразделения=ИТИИндустрияОбщийМодульКлиентСервер.ЗаполнитьМассивУникальнымиЗначениями(РезТаб.ВыгрузитьКолонку("Подразделение"),Истина);
	ДокПланирования=ИТИИндустрияОбщийМодульКлиентСервер.ЗаполнитьМассивУникальнымиЗначениями(РезТаб.ВыгрузитьКолонку("Регистратор"),Истина);
	ВыборкаПоМесяцам=Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоМесяцам.Следующий() Цикл
		Док=Документы.IT_ПланСтатьиБюджет.СоздатьДокумент();
		Док.ВидБюджета=Перечисления.IT_ВидыБюджета.БДР;
		Док.Дата=ВыборкаПоМесяцам.Период;
		Док.Комментарий="План по новой формие для "+Строка(Подразделение);
		Док.Ответственный=глЗначениеПеременной("глТекущийПользователь");
		Док.Период=ВыборкаПоМесяцам.Период;
		Док.СценарийБюджета=Сценарий;
		Док.ВидОперации=Перечисления.IT_ВидОперацииПланаБюджета.ПоПодразделениям;
		Док.Дата=ВыборкаПоМесяцам.Период;
		ВыборкаСтатьи=ВыборкаПоМесяцам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Сч=0;
		Пока ВыборкаСтатьи.Следующий() Цикл
			ВыборкаДетали=ВыборкаСтатьи.Выбрать();
			Пока ВыборкаДетали.Следующий() Цикл
				СтрокаНовая=Док.СписокАналитическихРазрезов.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНовая,ВыборкаДетали);
				СтрокаНовая.ИндексСтрокиТаблицыПодразделений=Сч;
			КонецЦикла;
			Сч=Сч+1;
		КонецЦикла;
		Для Каждого Эл Из Подразделения Цикл
			Док.Подразделения.Добавить().Подразделение=Эл;
		КонецЦикла;
		Док.Подразделение=Подразделение;
		Док.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;
	
	Для Каждого ДокПлан Из ДокПланирования Цикл
		Об=ДокПлан.ПолучитьОбъект();
		Об.Комментарий=Об.Комментарий+"Отменен для формирования укрупненного плана";
		Об.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Об.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
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


ТекстЗапроса="ВЫБРАТЬ
             |	IT_УчетБюджетовОбороты.Период КАК Период,
             |	IT_АналитикаУчетаБюджета.СтатьяБюджета КАК СтатьяБюджета,
             |	IT_АналитикаУчетаБюджета.Проект,
             |	IT_АналитикаУчетаБюджета.Подразделение,
             |	IT_АналитикаУчетаБюджета.Контрагент,
             |	IT_АналитикаУчетаБюджета.Номенклатура,
             |	IT_УчетБюджетовОбороты.КоличествоОборот КАК Количество,
             |	IT_УчетБюджетовОбороты.СуммаОборот КАК Сумма,
             |	IT_УчетБюджетовОбороты.Регистратор,
             |	IT_УчетБюджетовОбороты.ПодКонтролем КАК ПодКонтролемРуководителя
             |ИЗ
             |	РегистрНакопления.IT_УчетБюджетов.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК IT_УчетБюджетовОбороты
             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.IT_АналитикаУчетаБюджета КАК IT_АналитикаУчетаБюджета
             |		ПО IT_УчетБюджетовОбороты.АналитикаУчетаБюджета = IT_АналитикаУчетаБюджета.КлючАналитикиУчетаБюджета
             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.IT_АналитикаВидаБюджета КАК IT_АналитикаВидаБюджета
             |		ПО IT_УчетБюджетовОбороты.АналитикаВидаБюджета = IT_АналитикаВидаБюджета.КлючАналитикиВидаБюджета
             |ГДЕ
             |	IT_АналитикаУчетаБюджета.Подразделение В ИЕРАРХИИ(&Подразделение)
             |	И IT_АналитикаВидаБюджета.СценарийБюджета = &СценарийБюджета
             |	И IT_АналитикаВидаБюджета.ВидБюджета = &ВидБюджета
             |
             |УПОРЯДОЧИТЬ ПО
             |	Период
             |ИТОГИ ПО
             |	Период ПЕРИОДАМИ(МЕСЯЦ, , ),
             |	СтатьяБюджета"
