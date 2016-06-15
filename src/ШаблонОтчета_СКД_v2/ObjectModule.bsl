﻿Перем СохраненнаяНастройка Экспорт;        // Текущий вариант отчета

Перем ТаблицаВариантовОтчета Экспорт;      // Таблица вариантов доступных текущему пользователю

	
Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	//добавить выборку периодовОтчета
	
	КомпоновщикНастроек.Восстановить();
	Настройка                  = КомпоновщикНастроек.ПолучитьНастройки();
	ТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);
	
	ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ПараметрНачалоПериода = Неопределено или ПараметрКонецПериода = Неопределено тогда
		Возврат Результат;
	Иначе
		НачалоПериода = ?(ПараметрНачалоПериода.Значение <> Неопределено, Дата(ПараметрНачалоПериода.Значение), '00010101');
		КонецПериода  = ?(ПараметрКонецПериода.Значение <> Неопределено, Дата(ПараметрКонецПериода.Значение), '00010101');
		Если НачалоПериода = '00010101'  тогда
			НачалоПериода = НачалоМесяца(ТекущаяДата());
		КонецЕсли;
		Если КонецПериода = '00010101' тогда
			КонецПериода = КонецМесяца(ТекущаяДата());
		КонецЕсли;
		ПараметрКонецПериода.Использование = Истина;
		ПараметрНачалоПериода.Использование = Истина;
		
		ПараметрКонецПериода.Значение  = КонецПериода;
		ПараметрНачалоПериода.Значение = НачалоПериода;
	КонецЕсли;
	
	ДтНачМесяца = ДобавитьМесяц(НачалоГода(НачалоПериода), -48);
	ТекстЗапроса = "ВЫБРАТЬ
	|	ДАТАВРЕМЯ("+Формат(ДтНачМесяца, "ДФ=yyyy")+", "+Месяц(ДтНачМесяца)+", "+День(ДтНачМесяца)+") КАК ПериодРегистрации
	|ПОМЕСТИТЬ ВТПериоды";
	ДтНачМесяца = ДобавитьМесяц(ДтНачМесяца, 1);
	
	Пока ДтНачМесяца <= КонецПериода Цикл
		ТекстЗапроса =  ТекстЗапроса + "
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ДАТАВРЕМЯ("+Формат(ДтНачМесяца, "ДФ=yyyy")+", "+Месяц(ДтНачМесяца)+", "+День(ДтНачМесяца)+") КАК Период
		|";
		ДтНачМесяца = ДобавитьМесяц(ДтНачМесяца, 1);
	КонецЦИкла;
	
	СтрокаЗамены = 
	"ВЫБРАТЬ
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ПериодРегистрации
	|ПОМЕСТИТЬ ВТПериоды";
	
	СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос, СтрокаЗамены, ТекстЗапроса);
	
	ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	
	УдалитьЛишниеПредставленияВШапке(Результат);
	
	СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос, ТекстЗапроса, СтрокаЗамены);

	КомпоновщикНастроек.ЗагрузитьНастройки(Настройка);
	Возврат Результат;
	
КонецФункции

Процедура УдалитьЛишниеПредставленияВШапке(Результат)
	
	Ячейка = Результат.НайтиТекст("Удалить", , , , истина, Истина, ложь);
	Пока Ячейка <> Неопределено Цикл
		УдаляемаяОбласть = Результат.Область("R"+Ячейка.Верх);
		Результат.УдалитьОбласть(УдаляемаяОбласть, ТипСмещенияТабличногоДокумента.ПоВертикали);
		Ячейка = Результат.НайтиТекст("Удалить", , , , истина, Истина, ложь);
	КонецЦикла;
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт

	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

Процедура ПрименитьНастройку() Экспорт
	
	Схема = ТиповыеОтчеты.ПолучитьСхемуКомпоновкиОбъекта(ЭтотОбъект);

	// Считываение структуры настроек отчета
 	Если Не СохраненнаяНастройка.Пустая() Тогда
		
		СтруктураНастроек = СохраненнаяНастройка.ХранилищеНастроек.Получить();
		Если Не СтруктураНастроек = Неопределено Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновщика);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		Иначе
			КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КонецЕсли;
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	СписокПолейПодстановкиОтборовПоУмолчанию = Новый Соответствие;
	СписокПолейПодстановкиОтборовПоУмолчанию.Вставить("Организация", "ОсновнаяОрганизация");
	
	Возврат Новый Структура("ИспользоватьСобытияПриФормированииОтчета,
	|ПриВыводеЗаголовкаОтчета,
	|ПослеВыводаПанелиПользователя,
	|ПослеВыводаПериода,
	|ПослеВыводаПараметра,
	|ПослеВыводаГруппировки,
	|ПослеВыводаОтбора,
	|ДействияПанелиИзменениеФлажкаДопНастроек,
	|ПриПолучениеНастроекПользователя, 
	|ЗаполнитьОтборыПоУмолчанию, 
	|СписокПолейПодстановкиОтборовПоУмолчанию,
	|СписокДоступныхПредопределенныхНастроек,
	|МинимальныйПериодОтчета", 
	ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, ложь, истина, СписокПолейПодстановкиОтборовПоУмолчанию,, "Месяц");

КонецФункции


#Если ТолстыйКлиентОбычноеПриложение Тогда
// Настройка отчета при отработки расшифровки
Процедура Настроить(Отбор) Экспорт
	
	// Настройка отбора
	Для каждого ЭлементОтбора Из Отбор Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
		Иначе
			ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Поле);
		КонецЕсли;
		
		Если КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		Иначе
			НовыйЭлементОтбора.Использование  = Истина;
			НовыйЭлементОтбора.ЛевоеЗначение  = ПолеОтбора;
			Если ЭлементОтбора.Иерархия Тогда
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
				КонецЕсли;
			Иначе
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				КонецЕсли;
			КонецЕсли;
			
			НовыйЭлементОтбора.ПравоеЗначение = ЭлементОтбора.Значение;
			
		КонецЕсли;                                    
				
	КонецЦикла;
	
	ТиповыеОтчеты.УдалитьДублиОтбора(КомпоновщикНастроек);
	
КонецПроцедуры
#КонецЕсли

Функция ЕстьДетальныеПоля(ВыбранныеПоля)
	ЕстьРесурсы = ложь;
	Для каждого ВыбраноеПоле из ВыбранныеПоля Цикл
		ДоступноеПоле = ТиповыеОтчеты.ПолучитьДоступноеПолеПоПолюКомпоновкиДанных(ВыбраноеПоле.Поле, КомпоновщикНастроек);
		Если ДоступноеПоле <> Неопределено тогда
			Если ДоступноеПоле.Ресурс тогда
				ЕстьРесурсы = истина;
			Иначе
				ЕстьРесурсы = ложь;
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Не ЕстьРесурсы;
КонецФункции

Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	ЕстьКодДохода                = ПрисутствуетПоле("КодДохода");
	ЕстьВидРасчета               = ПрисутствуетПоле("ВидРасчета");
	ЕстьРегистратор              = ПрисутствуетПоле("Регистратор"); 
	ЕстьСтавкаНалогообложения    = ПрисутствуетПоле("НДФЛ.СтавкаНалогообложенияНДФЛ"); 
	ЕстьФизЛицо                  = ПрисутствуетПоле("Сотрудник");
	ЕстьКПП                      = ПрисутствуетПоле("КПП");
	ЕстьМесяцНалоговогоПериода	 = ПрисутствуетПоле("НДФЛ.МесяцНалоговогоПериода");
								   
	ЕстьВидПособия                        = ПрисутствуетПоле("Пособия.ВидПособия");
	ЕстьИнвалид                           = ПрисутствуетПоле("Взносы.Инвалид");
	ЕстьРебенок                           = ПрисутствуетПоле("Пособия.Ребенок");
	ЕстьВидЗанятости                      = ПрисутствуетПоле("Пособия.ВидЗанятости");
	ЕстьСреднийЗаработок                  = ПрисутствуетПоле("Пособия.РазмерСреднегоЗаработка");
	ЕстьВидСтрахования                    = ПрисутствуетПоле("Пособия.ВидСтрахования");
	ЕстьКодПоОКАТО                        = ПрисутствуетПоле("НДФЛ.КодПоОКАТО") Или ПрисутствуетПоле("НДФЛ.КодПоОКТМО"); 
	ЕстьКодТерритории                     = ПрисутствуетПоле("НДФЛ.КодТерритории"); 
	ЕстьВычет                             = ПрисутствуетПоле("НДФЛ.КодВычетНДФЛ"); 
	
	ЕстьВидДохода                         = ПрисутствуетПоле("ВидДохода");
	ЕстьВидТарифаСтраховыхВзносов         = ПрисутствуетПоле("ВидТарифаСтраховыхВзносов");
	ЕстьРодилсяДо1967                     = ПрисутствуетПоле("РодилсяДо1967");
	ЕстьВидЗастрахованногоЛица            = ПрисутствуетПоле("ВидЗастрахованногоЛица");
	ЕстьОблагаетсяПоДополнительномуТарифу = ПрисутствуетПоле("Взносы.ОблагаетсяПоДополнительномуТарифу");
	ЕстьОблагаетсяВзносамиНаДоплатуКПенсииШахтерам = ПрисутствуетПоле("Взносы.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам");
	ЕстьОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией = ПрисутствуетПоле("Взносы.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией");
	ЕстьВыплатаЗаСчетФедеральногоБюджета  = ПрисутствуетПоле("Пособия.ВыплатаЗаСчетФедеральногоБюджета");
	ЕстьИнвалид                           = ПрисутствуетПоле("Взносы.Инвалид");
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КПП",   ЕстьКПП);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "МесяцНалоговогоПериода",   ЕстьМесяцНалоговогоПериода);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Инвалид",   ЕстьИнвалид);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КодДохода",   ЕстьКодДохода);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидРасчета",  ЕстьВидРасчета);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Регистратор", ЕстьРегистратор);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "СтавкаНалогообложенияРезидента", ЕстьСтавкаНалогообложения);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ФизЛицо",     ЕстьФизЛицо);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидПособия",              ЕстьВидПособия);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Ребенок",                 ЕстьРебенок);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидЗанятости",            ЕстьВидЗанятости);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "РазмерСреднегоЗаработка", ЕстьСреднийЗаработок);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидСтрахования",          ЕстьВидСтрахования);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КодПоОКАТО",              ЕстьКодПоОКАТО);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КодТерритории",           ЕстьКодТерритории);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Вычет",                   ЕстьВычет);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "Инвалид",                 ЕстьИнвалид);
	
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидДохода",                 ЕстьВидДохода);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидТарифаСтраховыхВзносов", ЕстьВидТарифаСтраховыхВзносов или ЕстьИнвалид);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "РодилсяДо1967",             ЕстьРодилсяДо1967);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВидЗастрахованногоЛица",    ЕстьВидЗастрахованногоЛица);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ОблагаетсяПоДополнительномуТарифу", ЕстьОблагаетсяПоДополнительномуТарифу);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам", ЕстьОблагаетсяВзносамиНаДоплатуКПенсииШахтерам);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией", ЕстьОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "ВыплатаЗаСчетФедеральногоБюджета", ЕстьВыплатаЗаСчетФедеральногоБюджета);
	
	
	Если ЕстьВычет тогда 
		Если ЕстьКодДохода тогда 
			Сообщить("Поле Вычет невозможно использовать с группировкой или отбором по полю ""Код дохода"".");
		КонецЕсли;
	КонецЕсли;
	
	ВыбранныеПоля = ТиповыеОтчеты.ПолучитьВыбранныеПоля(КомпоновщикНастроек);
	
	СписокПолей = Новый СписокЗначений;
	
	Для каждого ВыбранноеПоле из ВыбранныеПоля Цикл
		ДоступноеПоле = ТиповыеОтчеты.ПолучитьДоступноеПолеПоПолюКомпоновкиДанных(ВыбранноеПоле.Поле, КомпоновщикНастроек);
		Если ДоступноеПоле <> Неопределено И ДоступноеПоле.Родитель <> Неопределено тогда
			Если ЕстьКодДохода тогда
				Если Найти(ДоступноеПоле.Поле, "Пособия.") <> 0 Или Найти(ДоступноеПоле.Поле, "Взносы.") <> 0 тогда
					Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ невозможно вывести одновременно с группировкой или отбором по полю ""Код дохода"".");
					ДобавитьПустоеОформдениеПоля(ВыбранноеПоле.Поле);
					СписокПолей.Добавить(ДоступноеПоле.Поле);
				ИначеЕсли Найти(ДоступноеПоле.Поле, "База") = 0 тогда
					Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ невозможно вывести одновременно с группировкой или отбором по полю ""Код дохода"".");
					ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
					СписокПолей.Добавить(ДоступноеПоле.Поле);
				КонецЕсли;
			КонецЕсли;
			Если ЕстьВидДохода тогда
				Если Найти(ДоступноеПоле.Поле, "Взносы.ФССНесчастныеСлучаи") <> 0 или Найти(ДоступноеПоле.Поле, "Взносы.ТФОМС") <> 0 
					или Найти(ДоступноеПоле.Поле, "Взносы.ФФОМС") <> 0 или Найти(ДоступноеПоле.Поле, "Взносы.ТФОМС") <> 0
					или Найти(ДоступноеПоле.Поле, "Взносы.ФСС") <> 0 или Найти(ДоступноеПоле.Поле, "Взносы.ПФРПоДополнительномуТарифу") <> 0
					или Найти(ДоступноеПоле.Поле, "Взносы.ПФРНакопительная") <> 0 или Найти(ДоступноеПоле.Поле, "Взносы.ПФРСтраховая") <> 0 
					или Найти(ДоступноеПоле.Поле, "Взносы.ПФРПоСуммарномуТарифу") <> 0 тогда
					
					Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ невозможно вывести одновременно с группировкой или отбором по полю ""Вид дохода"".");
					ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
					СписокПолей.Добавить(ДоступноеПоле.Поле);
				КонецЕсли;
			КонецЕсли;
			Если ЕстьВидРасчета тогда
				Если Найти(ДоступноеПоле.Поле, "База") = 0 и Найти(ДоступноеПоле.Поле, "НеОблагается") = 0 и Строка(ДоступноеПоле.Поле) <> "Взносы.Начислено" и Строка(ДоступноеПоле.Поле) <> "Взносы.Скидка" тогда
					Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ невозможно вывести одновременно с группировкой или отбором по полю ""Вид расчета"".");
					ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
					СписокПолей.Добавить(ДоступноеПоле.Поле);
				КонецЕсли;
			КонецЕсли;
			Если ЕстьРегистратор тогда
				Если Найти(ДоступноеПоле.Поле, "ФССНС.") <> 0 тогда
					Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ невозможно вывести одновременно с группировкой или отбором по полю ""Регистратор"".");
					ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
					СписокПолей.Добавить(ДоступноеПоле.Поле);
				КонецЕсли;
			КонецЕсли;
			Если ЕстьСтавкаНалогообложения	тогда
				Если Найти(ДоступноеПоле.Поле, "НДФЛ.") = 0 тогда
					Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ невозможно вывести одновременно с группировкой или отбором по полю ""Ставка налогообложения"".");
					ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
					СписокПолей.Добавить(ДоступноеПоле.Поле);
				КонецЕсли;
			КонецЕсли;
			Если ЕстьФизЛицо тогда
				Если Найти(ДоступноеПоле.Поле, "ФССНС.") <> 0 тогда
					Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ невозможно вывести одновременно с группировкой или отбором по полю ""Сотрудник"".");
					ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
					СписокПолей.Добавить(ДоступноеПоле.Поле);
				КонецЕсли;
			КонецЕсли;
			Если ЕстьВидПособия или ЕстьРебенок или ЕстьВидЗанятости или ЕстьСреднийЗаработок или ЕстьВидСтрахования тогда
				Если Найти(ДоступноеПоле.Поле, "Пособия.") = 0 тогда
					Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ невозможно вывести одновременно с группировкой или отбором по полю ""Вид пособия"".");
					ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
					СписокПолей.Добавить(ДоступноеПоле.Поле);
				КонецЕсли;
			КонецЕсли;
			Если ЕстьВычет тогда
				Если Найти(ДоступноеПоле.Поле, "НалогНДФЛ") <> 0 или Найти(ДоступноеПоле.Поле, "НалогНДФЛУдержаный") <> 0 
					или Найти(ДоступноеПоле.Поле, "БазаНДФЛ") <> 0 или Найти(ДоступноеПоле.Поле, "СуммаДоходаНеОблагаемая") <> 0 тогда
					Сообщить("Поле """ + ДоступноеПоле.Заголовок + """ невозможно вывести одновременно с группировкой или отбором по полю ""Вычет НДФЛ"".");
					ДобавитьПустоеОформдениеПоля(ДоступноеПоле.Поле);
					СписокПолей.Добавить(ДоступноеПоле.Поле);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Если ЕстьДетальныеПоля(ВыбранныеПоля) тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьОтборИлиПоВсемПоказателям(КомпоновщикНастроек.Настройки, ВыбранныеПоля, СписокПолей);
	
КонецПроцедуры

Процедура ДобавитьПустоеОформдениеПоля(Поле)
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
	ЗначениеТекст = УсловноеОформление.Оформление.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Text"));
	ЗначениеТекст.Значение = "-";
	ЗначениеТекст.Использование = Истина;
	
	ПолеОформления = УсловноеОформление.Поля.Элементы.Добавить();
	ПолеОформления.Использование = Истина;
	ПолеОформления.Поле = Поле;
	
КонецПроцедуры


Процедура ДобавитьОтборИлиПоВсемПоказателям(СтруктураОтчета, ВыбранныеПоля, СписокПолей)
	// создадим отбор или 
	ГруппаИли = СтруктураОтчета.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Для каждого ВыбранноеПоле из ВыбранныеПоля Цикл
		Если (Найти(Строка(ВыбранноеПоле.Поле), "UserField") > 0 или Найти(Строка(ВыбранноеПоле.Поле), "ПользовательскиеПоля") > 0) или СписокПолей.НайтиПоЗначению(ВыбранноеПоле.Поле) <> Неопределено тогда
			Продолжить;
		КонецЕсли;
		ТиповыеОтчеты.ДобавитьОтбор(ГруппаИли, Строка(ВыбранноеПоле.Поле), 0, ВидСравненияКомпоновкиДанных.НеРавно);
	КонецЦикла;
	Если ГруппаИли.Элементы.Количество() = 0 тогда
		ГруппаИли.Использование = истина;
	КонецЕсли;
	Если ГруппаИли.Элементы.Количество() = 0 тогда
		СтруктураОтчета.Отбор.Элементы.Удалить(ГруппаИли);
	КонецЕсли;
КонецПроцедуры


Функция ПрисутствуетПоле(Поле)
	
	ЕстьГруппировка = ложь;
	
	ЕстьГруппировка = НайтиПоле(КомпоновщикНастроек.Настройки.Структура, Поле);

	
	//Для каждого ЭлементСтруктуры из КомпоновщикНастроек.Настройки.Структура Цикл
	//	
	//	Если Тип(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") тогда
	//		
	//		ЕстьГруппировка = НайтиПоле(ЭлементСтруктуры.Строки, Поле) или НайтиПоле(ЭлементСтруктуры.Колонки, Поле);
	//		
	//	ИначеЕсли Тип(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") тогда
	//		
	//		ЕстьГруппировка = НайтиПоле(ЭлементСтруктуры.Структура, Поле);
	//		
	//	ИначеЕсли Тип(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") тогда
	//		
	//		Если ЭлементСтруктуры.Точки.Количество() <> 0 тогда
	//			
	//			ЕстьГруппировка = НайтиПоле(ЭлементСтруктуры.Точки, Поле) ИЛИ НайтиПоле(ЭлементСтруктуры.Серии, Поле);
	//			
	//		КонецЕсли;
	//		
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	Если ЕстьГруппировка тогда
		Возврат ЕстьГруппировка;
	КонецЕсли;
	
	// найти поле группировки в отборе
	Для каждого ОтборПоле из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		
		ПолеПериодРегистрации = Новый ПолеКомпоновкиДанных(Поле);
		
		Если ТипЗнч(ОтборПоле) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") тогда
			ЕстьГруппировка = ИспользуетсяОтбор(ОтборПоле.Элементы, ПолеПериодРегистрации);
		Иначе
			Если ОтборПоле.Использование и (ОтборПоле.ЛевоеЗначение = ПолеПериодРегистрации или ОтборПоле.ПравоеЗначение = ПолеПериодРегистрации) тогда
				
				ЕстьГруппировка = истина;
				
				Прервать;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ВыбранныеПоля = ТиповыеОтчеты.ПолучитьВыбранныеПоля(КомпоновщикНастроек);
	
	Для каждого ПолеВыбора из ВыбранныеПоля Цикл
		
		ПолеПериодРегистрации = Новый ПолеКомпоновкиДанных(Поле);
		
		Если ТипЗНЧ(ПолеВыбора) = Тип("ВыбранноеПолеКомпоновкиДанных") И ПолеВыбора.Использование И ПолеВыбора.Поле = ПолеПериодРегистрации тогда
			
			ЕстьГруппировка = истина;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	
	Возврат ЕстьГруппировка;
	
КонецФункции 

Функция ИспользуетсяОтбор(Элементы, ПолеПериодРегистрации)
	
	ЕстьГруппировка = ложь;
	
	Для каждого ОтборПоле из Элементы Цикл
		
		Если ТипЗнч(ОтборПоле) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") тогда
			ЕстьГруппировка = ИспользуетсяОтбор(ОтборПоле.Элементы, ПолеПериодРегистрации);
		Иначе
			Если ОтборПоле.Использование и (ОтборПоле.ЛевоеЗначение = ПолеПериодРегистрации или ОтборПоле.ПравоеЗначение = ПолеПериодРегистрации) тогда
				
				ЕстьГруппировка = истина;
				
				Прервать;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЕстьГруппировка;
	
КонецФункции

// Функция возвращает значение истина, если в группировках элементов структуры присутствует поле "Период регистрации"
//
Функция НайтиПоле(Структура, Поле)
	
	ЕстьПоле = ложь;
	
	Если ТипЗнч(Структура) <> Тип("КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных") 
	 и ТипЗнч(Структура) <> Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") 
	 и ТипЗнч(Структура) <> Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных") 
	 тогда
		
		Возврат ЕстьПоле;
		
	КонецЕсли;
	
	ПолеПериодРегистрации = Новый ПолеКомпоновкиДанных(Поле);
	
	Для каждого ЭлементСтруктуры из Структура Цикл
		
		Если Тип(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") 
			или  Тип(ЭлементСтруктуры) = Тип("ГруппировкаТаблицыКомпоновкиДанных") 
			или  Тип(ЭлементСтруктуры) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") тогда
			Для каждого ПолеГруппировки из ЭлементСтруктуры.ПоляГруппировки.Элементы Цикл
				Если ТипЗнч(ПолеГруппировки) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") тогда
					Продолжить;
				КонецЕсли;
				Если ПолеГруппировки.Использование И ПолеГруппировки.Поле = ПолеПериодРегистрации тогда
					ЕстьПоле = истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ЕстьПоле тогда
			Прервать;
		КонецЕсли;
		Если Тип(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") тогда
			ЕстьПоле = НайтиПоле(ЭлементСтруктуры.Строки, Поле) или НайтиПоле(ЭлементСтруктуры.Колонки, Поле);
		ИначеЕсли Тип(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") 
			или  Тип(ЭлементСтруктуры) = Тип("ГруппировкаТаблицыКомпоновкиДанных") 
			или  Тип(ЭлементСтруктуры) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") тогда
			ЕстьПоле = НайтиПоле(ЭлементСтруктуры.Структура, Поле);
		ИначеЕсли Тип(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") тогда
			Если ЭлементСтруктуры.Точки.Количество() <> 0 тогда
				ЕстьПоле = НайтиПоле(ЭлементСтруктуры.Точки, Поле) ИЛИ НайтиПоле(ЭлементСтруктуры.Серии, Поле);
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;
	
	Возврат ЕстьПоле;
	
КонецФункции //НайтиПоле()

Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;

Если КомпоновщикНастроек = Неопределено Тогда
	КомпоновщикНастроек =  Новый КомпоновщикНастроекКомпоновкиДанных;
КонецЕсли;

УправлениеОтчетами.ЗаменитьНазваниеПолейСхемыКомпоновкиДанных(СхемаКомпоновкиДанных);
СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос = УправлениеОтчетамиПереопределяемый.ПодставитьЗапросДляПолученияНалоговойПолитики(СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос);
