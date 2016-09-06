﻿#Если Клиент Тогда

// Процедура заполняет построитель отчета.
//
Процедура ЗаполнитьПостроительОтчета() Экспорт

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ИСТИНА КАК Печать,
	|	СпрНоменклатура.Номенклатура КАК Номенклатура,
	|	СпрНоменклатура.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	СпрНоменклатура.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	0 КАК Цена,
	|	1 КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		СпрНоменклатура.Ссылка КАК Номенклатура,
	|		ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаНоменклатуры
	|	ИЗ
	|		Справочник.Номенклатура КАК СпрНоменклатура
	|	ГДЕ НЕ СпрНоменклатура.ЭтоГруппа
	|	{ГДЕ
	|		СпрНоменклатура.Ссылка.* КАК Номенклатура}
	|	ОБЪЕДИНИТЬ ВСЕ
	|	ВЫБРАТЬ
	|		СпрХарактеристики.Владелец,
	|		СпрХарактеристики.Ссылка
	|	ИЗ
	|		Справочник.ХарактеристикиНоменклатуры КАК СпрХарактеристики
	|	{ГДЕ
	|		СпрХарактеристики.Владелец.* КАК Номенклатура,
	|		СпрХарактеристики.Ссылка.* КАК ХарактеристикаНоменклатуры}
	|	) КАК СпрНоменклатура
	|";
	
	Если ТолькоИмеющиесяВНаличии Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	(ВЫБРАТЬ
		|		НаСкладе.Номенклатура,
		|		НаСкладе.ХарактеристикаНоменклатуры,
		|		СУММА(НаСкладе.Количество) КАК Количество
		|	ИЗ
		|		(ВЫБРАТЬ
		|			НаСкладе.Номенклатура,
		|			НаСкладе.ХарактеристикаНоменклатуры,
		|			НаСкладе.КоличествоОстаток КАК Количество
		|		ИЗ
		|			РегистрНакопления.ТоварыНаСкладах.Остатки(, {Номенклатура.* КАК Номенклатура,
		|			   ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
		|			   Склад.* КАК Склад}) КАК НаСкладе
		|		ОБЪЕДИНИТЬ ВСЕ
		|		ВЫБРАТЬ
		|			ВРознице.Номенклатура,
		|			ВРознице.ХарактеристикаНоменклатуры,
		|			ВРознице.КоличествоОстаток КАК Количество
		|		ИЗ
		|			РегистрНакопления.ТоварыВРознице.Остатки(, {Номенклатура.* КАК Номенклатура,
		|			   ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
		|			   Склад.* КАК Склад}) КАК ВРознице
		|		ОБЪЕДИНИТЬ ВСЕ
		|		ВЫБРАТЬ
		|			ВНТТ.Номенклатура,
		|			ВНТТ.ХарактеристикаНоменклатуры,
		|			ВНТТ.КоличествоОстаток КАК Количество
		|		ИЗ
		|			РегистрНакопления.ТоварыВНТТ.Остатки(, {Номенклатура.* КАК Номенклатура,
		|			   ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
		|			   Склад.* КАК Склад}) КАК ВНТТ
		|		) КАК НаСкладе
		|	СГРУППИРОВАТЬ ПО
		|		НаСкладе.Номенклатура,
		|		НаСкладе.ХарактеристикаНоменклатуры
		|	) КАК НаСкладе
		|ПО
		|	СпрНоменклатура.Номенклатура = НаСкладе.Номенклатура
		|	И СпрНоменклатура.ХарактеристикаНоменклатуры = НаСкладе.ХарактеристикаНоменклатуры
		|ГДЕ
		|	ЕСТЬNULL(НаСкладе.Количество, 0) > 0
		|";
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + "
	|УПОРЯДОЧИТЬ ПО
	|	СпрНоменклатура.Номенклатура.Наименование,
	|	СпрНоменклатура.ХарактеристикаНоменклатуры.Наименование
	|";

	// Соответствие имен полей в запросе и их представлений в отчете.
	СтруктураПредставлениеПолей = Новый Структура(
	"Номенклатура,   ХарактеристикаНоменклатуры,    Склад",
	"Номенклатура", "Характеристика номенклатуры", "Склад");

	ПостроительОтчета.Текст = ТекстЗапроса;

	ПостроительОтчета.ЗаполнитьНастройки();

	// Создадим список доступных отборов.
	СоответствиеДоступныхОтборов = Новый Соответствие;
	СоответствиеДоступныхОтборов.Вставить("Номенклатура", 0);
	СоответствиеДоступныхОтборов.Вставить("ХарактеристикаНоменклатуры", 0);
	СоответствиеДоступныхОтборов.Вставить("Склад", 0);

	Для Каждого ДоступноеПоле Из ПостроительОтчета.ДоступныеПоля Цикл
		Если СоответствиеДоступныхОтборов[ДоступноеПоле.Имя] =Неопределено Тогда
			ДоступноеПоле.Отбор = Ложь;
		Иначе
			ДоступноеПоле.Отбор = Истина;
		КонецЕсли;
	КонецЦикла;

	// Создадим массив отборов.
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить("Номенклатура");
	МассивОтбора.Добавить("ХарактеристикаНоменклатуры");

	Если ТолькоИмеющиесяВНаличии Тогда
		МассивОтбора.Добавить("Склад");
	КонецЕсли;

	Для Каждого ЭлементОтбора Из МассивОтбора Цикл
		Если ПостроительОтчета.Отбор.Найти(ЭлементОтбора) = Неопределено Тогда
			ПостроительОтчета.Отбор.Добавить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;

	// Вызовем стандартную процедуру заполнения представлений.
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);

КонецПроцедуры // ЗаполнитьПостроительОтчета()

// Процедура перезаполняет цены в табличной части.
//
Процедура ПерезаполнитьЦены() Экспорт

	СтруктураЗначений = Новый Структура;
	СтруктураЗначений.Вставить("НовыйТипЦен", ТипЦен);

	ЗапросПоЦенам = Ценообразование.СформироватьЗапросПоЦенам(СтруктураЗначений,
	   Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатуры,
	   Товары.ВыгрузитьКолонку("Номенклатура"),
	   ДатаПечати,
	   Неопределено).Выгрузить();
	ЗапросПоЦенам.Индексы.Добавить("Номенклатура");

	ПустаяХарактеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	ТипЦенРассчитывается = ТипЦен.Рассчитывается;

	СтруктураКурса = МодульВалютногоУчета.ПолучитьКурсВалюты(Валюта, РабочаяДата);
	Курс = СтруктураКурса.Курс;
	Кратность = СтруктураКурса.Кратность;

	Для Каждого СтрокаТовара Из Товары Цикл
		ХарактеристикаНоменклатуры = СтрокаТовара.ХарактеристикаНоменклатуры;

		СтруктураПоиска = Новый Структура("Номенклатура", СтрокаТовара.Номенклатура);

		СтрокиЦен = ЗапросПоЦенам.НайтиСтроки(СтруктураПоиска);

		СтрокаБезХарактеристики = Неопределено;
		СтрокаСХарактеристикой = Неопределено;

		Для Каждого СтрокаЦен Из СтрокиЦен Цикл
			Если СтрокаЦен.ХарактеристикаНоменклатуры = ПустаяХарактеристика Тогда
				СтрокаБезХарактеристики = СтрокаЦен;
			ИначеЕсли СтрокаЦен.ХарактеристикаНоменклатуры = ХарактеристикаНоменклатуры Тогда
				СтрокаСХарактеристикой = СтрокаЦен;
			КонецЕсли;
		КонецЦикла;

		Если СтрокаСХарактеристикой <> Неопределено Тогда
			НайденнаяСтрока = СтрокаСХарактеристикой;
		ИначеЕсли СтрокаБезХарактеристики <> Неопределено Тогда
			НайденнаяСтрока = СтрокаБезХарактеристики;
		Иначе
			НайденнаяСтрока = Неопределено;
		КонецЕсли;

		Если (НайденнаяСтрока <> Неопределено) И (НайденнаяСтрока.Цена <> 0) Тогда
			Цена = НайденнаяСтрока.Цена * (1 + ?(ТипЦенРассчитывается, НайденнаяСтрока.ПроцентСкидкиНаценки / 100, 0));
			Цена = Ценообразование.ОкруглитьЦену(Цена, ТипЦен.ПорядокОкругления, ТипЦен.ОкруглятьВБольшуюСторону);
			Цена = Ценообразование.ПересчитатьЦенуПриИзмененииВалюты(Цена, НайденнаяСтрока.ВалютаЦены, Валюта, Курс, Кратность);

			СтрокаТовара.ЕдиницаИзмерения = НайденнаяСтрока.ЕдиницаИзмеренияЦены;
		Иначе
			Цена = 0;
		КонецЕсли;

		СтрокаТовара.Цена = Цена;
	КонецЦикла;

КонецПроцедуры // ПерезаполнитьЦены()

// Функция формирует табличный документ - печатная форма ценника.
//
// Возвращаемое значение:
//  ТабличныйДокумент - сформированный табличный документ или Неопределено, если есть ошибки.
//
Функция ПечатьЦенника() Экспорт

	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Предупреждение("Не выбрана организация!");
		Возврат Неопределено;
	КонецЕсли;

	ТабДокумент                     = Новый ТабличныйДокумент;
	
	//Если ЦенникСигареты Тогда
	//	ТабДокумент.ИмяПараметровПечати="ПАРАМЕТРЫ_ПЕЧАТИ_ЦЕННИКИ_СИГАРЕТЫ";
	//Иначе
	//	Если ВариантПечати=0 Тогда
	//		ТабДокумент.ИмяПараметровПечати="ПАРАМЕТРЫ_ПЕЧАТИ_ЦЕННИКИ_СТАНДАРТ";
	//	Иначе
	//		ТабДокумент.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
	//		ТабДокумент.ПолеСверху	= 0;
	//		ТабДокумент.ПолеСлева	= 0;
	//		ТабДокумент.ПолеСправа	= 0;
	//		ТабДокумент.ПолеСнизу	= 0;
	//	КонецЕсли;
	//КонецЕсли;
	//КонецЕсли;
	Если ВариантПечати=0 Тогда
		ТабДокумент.ИмяПараметровПечати="ПАРАМЕТРЫ_ПЕЧАТИ_ЦЕННИКИ_СТАНДАРТ";
	ИначеЕсли ВариантПечати=1 Тогда
		ТабДокумент.ИмяПараметровПечати="ПАРАМЕТРЫ_ПЕЧАТИ_ЦЕННИКИ_СТАНДАРТ"
	ИначеЕсли ВариантПечати=2 Тогда
		ТабДокумент.ИмяПараметровПечати="ПАРАМЕТРЫ_ПЕЧАТИ_ЦЕННИКИ_ПРАЙС";
	ИначеЕсли ВариантПечати=3 Тогда
		ТабДокумент.ИмяПараметровПечати="ПАРАМЕТРЫ_ПЕЧАТИ_ЦЕННИКИ_УЗКИЙ";
	Иначе
		ТабДокумент.ОриентацияСтраницы=ОриентацияСтраницы.Ландшафт;
		ТабДокумент.ПолеСверху	= 0;
		ТабДокумент.ПолеСлева	= 0;
		ТабДокумент.ПолеСправа	= 0;
		ТабДокумент.ПолеСнизу	= 0;
	КонецЕсли;
	Если НЕ ТабДокумент.АвтоМасштаб Тогда
		ТабДокумент.АвтоМасштаб=Истина;
	КонецЕсли;
	ЦенникСигареты=(ВариантПечати=1);
	
	Если ЦенникСигареты Тогда
		Макет								= ПолучитьМакет("ЦенникУзкий");
	Иначе
		Если ВариантПечати=0 Тогда
			Макет                           = ПолучитьМакет("Ценник");
		Иначе
			Макет                           = ПолучитьМакет("Ценник39");
		КонецЕсли;
	КонецЕсли;
	//ОбластьЦенникаОбыч                  = Макет.ПолучитьОбласть("Строка|Столбец");
	//ОбластьЦенникаПразд             	= Макет.ПолучитьОбласть("СтрокаФон|Столбец");
	Если ВыводитьШтрихкод Тогда
		ОбластьЦенника	= Макет.ПолучитьОбласть("СтрокаШтрихкод|Столбец");
	иначе
		ОбластьЦенника	= Макет.ПолучитьОбласть("Строка|Столбец");
	КонецЕсли;
	ДатаПечати = РабочаяДата;

	ТекСтолбец = 0;
	ТекСтрока  = 0;
	КолСтрок=?(ЦенникСигареты,3*2,?(ВариантПечати=3,4,3));
	КолСтолбцов=?(ВариантПечати=3,4,5);
    //KAV
	КатегорияНовинка	= Справочники.КатегорииОбъектов.НайтиПоНаименованию("""Новинка""").Ссылка;
	ДвойнаяЛиния		= Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,3);
	ПростаяЛиния		= Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная,1);
	Для Каждого СтрокаТаблицы Из Товары Цикл
		Если СтрокаТаблицы.Печать Тогда
			Для Тмп = 1 По СтрокаТаблицы.Количество Цикл
				//Если ИТИИндустрияОбщийМодульКлиентСервер.ПринадлежитКатегории(СтрокаТаблицы.Номенклатура,КатегорияНовинка) Тогда
				//	//KAV++ Пока убрали
				//	//ОбластьЦенника=ОбластьЦенникаПразд
				//	ОбластьЦенника=ОбластьЦенникаОбыч;
				//	//KAV--
				//Иначе
					//ОбластьЦенника=ОбластьЦенникаОбыч;
				//КонецЕсли;
				ОбластьЦенника.Параметры.Заполнить(СтрокаТаблицы);
				Если ИТИИндустрияОбщийМодульКлиентСервер.ПринадлежитКатегории(СтрокаТаблицы.Номенклатура,КатегорияНовинка) Тогда
					ОбластьЦенника.Параметры.НоменклатураНаименование		= "НОВИНКА!!! "+СтрокаТаблицы.Номенклатура.НаименованиеПолное;
				Иначе
					ОбластьЦенника.Параметры.НоменклатураНаименование		= СтрокаТаблицы.Номенклатура.НаименованиеПолное;
				КонецЕсли;
				ОбластьЦенника.Параметры.ХарактеристикаНаименование      = СтрокаТаблицы.ХарактеристикаНоменклатуры;
				Если не ВыводитьШтрихкод Тогда
					ОбластьЦенника.Параметры.ЕдиницаНаименование             = СтрокаТаблицы.ЕдиницаИзмерения;
				КонецЕсли;
				ОбластьЦенника.Параметры.Цена                            = ОбщегоНазначения.ФорматСумм(СтрокаТаблицы.Цена, Валюта, "00");
				ОбластьЦенника.Параметры.ДатаПечати                      = ДатаПечати;
				ОбластьЦенника.Параметры.Организация                     = Организация;
				ОбластьЦенника.Параметры.ОрганизацияНаименование         = Организация;
				ОбластьЦенника.Параметры.НоменклатураСтранаПроисхождения = СтрокаТаблицы.Номенклатура.СтранаПроисхождения;
				
                //+Мажарцев
        		ЗапросШк=Новый Запрос;
				ЗапросШк.Параметры.Вставить("Номенклатура", СтрокаТаблицы.Номенклатура);
				ЗапросШк.Текст = "ВЫБРАТЬ
				                 |	ШК.Штрихкод КАК ШтрихКод,
				                 |	ШК.Владелец КАК Владелец,
				                 |	ШК.ТипШтрихкода,
				                 |	ШК.ПредставлениеШтрихкода
				                 |ИЗ
				                 |	РегистрСведений.Штрихкоды КАК ШК
				                 |ГДЕ
				                 |	ШК.Владелец = &Номенклатура";
				РезультатЗапроса=ЗапросШк.Выполнить().Выгрузить();
				Для Каждого Строка ИЗ РезультатЗапроса Цикл
					Если не ВыводитьШтрихкод Тогда
              			ОбластьЦенника.Параметры.шк                              = Строка.ШтрихКод;
					КонецЕсли;
				КонецЦикла;
				Если ВыводитьШтрихкод Тогда
					ТипКода = ПолучитьЗначениеТипаШтрихкодаДляЭУ(Строка.ТипШтрихкода);
					Если ТипКода = -1 Тогда
						ОбщегоНазначения.СообщитьОбОшибке("Для штрихкода формата """ + Строка.ТипШтрихкода 
						+ """ не существует соответствующего типа в ЭУ ""1С:Печать штрихкодов"".
						| Позиция будет пропущена");
						Продолжить;
					КонецЕсли;
					
					Если РаботаСТорговымОборудованием.ПроверитьШтрихКод(?(ПустаяСтрока(Строка.ПредставлениеШтрихкода),
						Строка.Штрихкод,
						Строка.ПредставлениеШтрихкода),
						Строка.ТипШтрихкода) Тогда
						ОбластьЦенника.Рисунки.Штрихкод.Объект.ТипКода   = ТипКода;
						ОбластьЦенника.Рисунки.Штрихкод.Объект.Сообщение = ?(ПустаяСтрока(Строка.ПредставлениеШтрихкода),
						Строка.Штрихкод,
						Строка.ПредставлениеШтрихкода);
						ОбластьЦенника.Рисунки.Штрихкод.Объект.ОтображатьТекст=Ложь;
					КонецЕсли;
					//-Мажарцев
				КонецЕсли;
				
				Если ТекСтолбец = 0 Тогда
					ТабДокумент.Вывести(ОбластьЦенника);
				Иначе
					ТабДокумент.Присоединить(ОбластьЦенника);
				КонецЕсли;

				ТекСтолбец = ТекСтолбец + 1;

				Если ТекСтолбец = КолСтолбцов Тогда
					ТекСтрока  = ТекСтрока + 1;
					ТекСтолбец = 0;
				КонецЕсли;

				Если ТекСтрока = КолСтрок Тогда
					ТекСтрока = 0;
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

	ТабДокумент.ТолькоПросмотр = Истина;

	Возврат ТабДокумент;

КонецФункции // ПечатьЦенника()

// Функция выполняет проверку параметров для заполнения цен.
//
// Возвращаемое значение:
//  Булево - Истина, если все параметры заданы.
//
Функция ПроверитьПараметрыЗаполненияЦен(ПечетьБезПроверкиЗаполненияПараметров = Неопределено) Экспорт

	Перем РезультатПроверки, СтрокаСообщения;

	РезультатПроверки = Истина;
	СтрокаСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(ТипЦен) Тогда
		РезультатПроверки = Ложь;
		СтрокаСообщения = "Не выбран тип цен! Укажите тип цен и повторите перезаполнение цен." + Символы.ПС;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Валюта) Тогда
		РезультатПроверки = Ложь;
		СтрокаСообщения = СтрокаСообщения + "Не выбрана валюта!  Укажите валюту и повторите перезаполнение цен.";
	КонецЕсли;

	Если НЕ РезультатПроверки И ПечетьБезПроверкиЗаполненияПараметров <> Истина Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщения);
	КонецЕсли;
	Возврат РезультатПроверки;

КонецФункции // ПроверитьПараметрыЗаполненияЦен()
//KAV
Функция ПечатьПрайса() Экспорт
	ТабДокумент								= Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати			= "ПАРАМЕТРЫ_ПЕЧАТИ_ПрайсИТИ";
	
	ТабДокументТемп							= Новый ТабличныйДокумент;
	ТабДокументТемп.ИмяПараметровПечати		= "ПАРАМЕТРЫ_ПЕЧАТИ_ПрайсИТИ";
	
	ТабДокументТест							= Новый ТабличныйДокумент;
	ТабДокументТест.ИмяПараметровПечати		= "ПАРАМЕТРЫ_ПЕЧАТИ_ПрайсИТИ";
	
	Макет                           = ПолучитьМакет("ПрайсЛист");
	
	ОбластьШапка					= Макет.ПолучитьОбласть("Шапка|Столбец");
	ОбластьСтрока					= Макет.ПолучитьОбласть("Строка|Столбец");
	
	ДатаПечати = РабочаяДата;

	ТекСтолбец = 0;
	//Да. Но я потом это копирую
	Если ТекСтолбец=0 Тогда
		ТабДокументТемп							= Новый ТабличныйДокумент;
		ТабДокументТемп.ИмяПараметровПечати		= "ПАРАМЕТРЫ_ПЕЧАТИ_ПрайсИТИ";
	    ОбластьШапка.Параметры.ПериодПрайса		= "Дата формирования прайса: "+Формат(ДатаПечати,"ДФ=dd/MM/yy");
		ТабДокументТемп.НачатьАвтогруппировкуСтрок();
		ТабДокументТемп.Вывести(ОбластьШапка);
	КонецЕсли;
	
	МассивПроверка=Новый Массив;
	МассивПроверка.Добавить(ТабДокументТемп);
	МассивПроверка.Добавить(ОбластьСтрока);
	ТребВывод=Ложь;		
	ТабДокумент.НачатьАвтогруппировкуКолонок();
	//СтдВысотаПечати=53;
	СтдВысотаПечати=КолСтрок;
	Корректировка=0;
	ТекСтрока=0;
	Для Каждого СтрокаТаблицы Из Товары Цикл
		Если СтрокаТаблицы.Печать Тогда
			ОбластьСтрока.Параметры.Номенклатура		= СтрокаТаблицы.Номенклатура.НаименованиеПолное;
			ОбластьСтрока.Параметры.Цена				= ОбщегоНазначения.ФорматСумм(СтрокаТаблицы.Цена, Валюта, "00");
			
			Если ТекСтрока<СтдВысотаПечати Тогда//СтдВысотаПечати-Корректировка Тогда
				ТабДокументТемп.Вывести(ОбластьСтрока);
				ТребВывод=Истина;
				ТекСтрока=ТекСтрока+1;
				Если СтрДлина(СтрокаТаблицы.Номенклатура.НаименованиеПолное)>50 Тогда
					Корректировка=Корректировка+1;
				КонецЕсли;
			Иначе
				ТребВывод=Ложь;
				ТекСтрока=0;
				Если ТекСтолбец=0 Тогда
					ТабДокумент.Присоединить(ТабДокументТемп);
					
					ТекСтолбец=1;
					ТабДокументТемп							= Новый ТабличныйДокумент;
					ТабДокументТемп.ИмяПараметровПечати		= "ПАРАМЕТРЫ_ПЕЧАТИ_ПрайсИТИ";
					ТабДокументТемп.НачатьАвтогруппировкуСтрок();
					
	    			ОбластьШапка.Параметры.ПериодПрайса		= "";
					ТабДокументТемп.Вывести(ОбластьШапка);
				Иначе
					ТабДокумент.Присоединить(ТабДокументТемп);
					
					ТабДокумент.ЗакончитьАвтогруппировкуКолонок();
					ТабДокумент.Вывести(Новый ТабличныйДокумент);
					ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					
					ТекСтолбец=0;
					Корректировка=0;
					ТабДокументТемп							= Новый ТабличныйДокумент;
					ТабДокументТемп.ИмяПараметровПечати		= "ПАРАМЕТРЫ_ПЕЧАТИ_ПрайсИТИ";
					ТабДокументТемп.НачатьАвтогруппировкуСтрок();
					
	    			ОбластьШапка.Параметры.ПериодПрайса		= "Дата формирования прайса: "+Формат(ДатаПечати,"ДФ=dd/MM/yy");
					ТабДокументТемп.Вывести(ОбластьШапка);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если ТребВывод Тогда
		ТабДокумент.Присоединить(ТабДокументТемп);
	КонецЕсли;
	ТабДокумент.ЗакончитьАвтогруппировкуКолонок();
	ТабДокумент.ТолькоПросмотр = Истина;

	Возврат ТабДокумент;

КонецФункции // ПечатьЦенника()
//KAV                                                                                                           
#КонецЕсли

Функция ПолучитьЗначениеТипаШтрихкодаДляЭУ(ТипКода)
	Перем Значение;
	
	Если ТипКода = ПланыВидовХарактеристик.ТипыШтрихкодов.EAN8 Тогда
		Значение = 0;
	ИначеЕсли ТипКода = ПланыВидовХарактеристик.ТипыШтрихкодов.EAN13 Тогда
		Значение = 1;
	ИначеЕсли ТипКода = ПланыВидовХарактеристик.ТипыШтрихкодов.EAN128 Тогда
		Значение = 2;
	ИначеЕсли ТипКода = ПланыВидовХарактеристик.ТипыШтрихкодов.Code39 Тогда
		Значение = 3;
	ИначеЕсли ТипКода = ПланыВидовХарактеристик.ТипыШтрихкодов.Code128 Тогда
		Значение = 4;
	Иначе
		Значение = -1;
	КонецЕсли;
	
	Возврат Значение;
КонецФункции // ПолучитьЗначениеТипаШтрихкодаДляЭУ()

