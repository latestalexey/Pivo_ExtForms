﻿Перем ОтчетПоВерсионированию Экспорт;
Перем СхемаКомпоновкиДанных Экспорт;
Перем ДанныеРасшифровки Экспорт;

Функция РазницаТаблицЗначений(Таблица0, Таблица1, Измерения) Экспорт
	
	ВсеКолонки = "";
	Для Каждого Колонка Из Таблица0.Колонки Цикл 
		ВсеКолонки = ВсеКолонки + ", " + Колонка.Имя
	КонецЦикла;
	ВсеКолонки = Сред(ВсеКолонки, 2);
    
    Таблица = Таблица1.Скопировать();    
    
    Таблица.Колонки.Добавить("Знак", Новый ОписаниеТипов("Число"));
    
    Таблица.ЗаполнитьЗначения(1, "Знак");
    
    Для Каждого Строка Из Таблица0 Цикл ЗаполнитьЗначенияСвойств(Таблица.Добавить(), Строка) КонецЦикла;
    
    Таблица.Колонки.Добавить("Счёт");
    Таблица.ЗаполнитьЗначения(1, "Счёт");
    
    Таблица.Свернуть(ВсеКолонки, "Знак, Счёт");
    
    Ответ = Таблица.Скопировать(Новый Структура("Счёт", 1), ВсеКолонки + ", Знак");
    
    Ответ.Сортировать(Измерения);
    Ответ.Свернуть("Номенклатура");
    Возврат Ответ
    
КонецФункции

Функция ПолучитьТаблицуВерсийПоЗапросу(Версии,СообщениеСостояния,ИндикаторПроцесса,Форма,ДолжноБыть=0) Экспорт
#Область Инициализация_таблицы
	ТаблицаОригинальныхВерсий=Новый ТаблицаЗначений;
	
	ТаблицаОригинальныхВерсий.Колонки.Добавить("Документ",		ЭтотОбъект.Метаданные().ТабличныеЧасти.СписокДокументовДляАнализа.Реквизиты.Документ.Тип);
	ТаблицаОригинальныхВерсий.Колонки.Добавить("НомерВерсии",	ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(10,0));
	ТаблицаОригинальныхВерсий.Колонки.Добавить("ДатаВерсии",	ОбщегоНазначения.ПолучитьОписаниеТиповДаты(ЧастиДаты.ДатаВремя));
	ТаблицаОригинальныхВерсий.Колонки.Добавить("АвторВерсии",	Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	ТаблицаОригинальныхВерсий.Колонки.Добавить("Комментарий",	ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(100));
	
	//ТаблицаОригинальныхВерсий.Колонки.Добавить("НомерСтроки",	ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(10,0));
	ТаблицаОригинальныхВерсий.Колонки.Добавить("Номенклатура",	Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаОригинальныхВерсий.Колонки.Добавить("Количество",	ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(15,3));	
#КонецОбласти
	Состояние(СообщениеСостояния);
	Форма.ЭлементыФормы[ИндикаторПроцесса].МаксимальноеЗначение=Версии.Количество();
	ИндикаторДокументов=0;
	Пока Версии.Следующий() Цикл
		//Получим объект
		//ОтчетПоВерсионированию.СсылкаНаОбъект=Версии.Документ;
		Док=РазборВерсии(Версии.НомерВерсии,Версии.Документ);
		Комментарий=Док.Реквизиты.Найти("Комментарий").ЗначениеРеквизита;
		Оригинал=Док.ТабличныеЧасти["Товары"];
		Форма[ИндикаторПроцесса]=Форма[ИндикаторПроцесса]+1;
		Сч=0;
		Пока Сч < Оригинал.Количество() Цикл
			СтрокаВерсий=ТаблицаОригинальныхВерсий.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаВерсий,Версии);
			ЗаполнитьЗначенияСвойств(СтрокаВерсий,Оригинал[сч],"Номенклатура,Количество");
			СтрокаВерсий.Комментарий=Комментарий;
			Сч=Сч+1;
		КонецЦикла;
		Пока Сч < ДолжноБыть Цикл
			СтрокаВерсий=ТаблицаОригинальныхВерсий.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаВерсий,Версии);
			СтрокаВерсий.НомерСтроки=Сч;
			СтрокаВерсий.Комментарий=Комментарий;
			Сч=Сч+1;
		КонецЦикла;
	КонецЦикла;
	Состояние("");
	Возврат ТаблицаОригинальныхВерсий;
КонецФункции

Функция ИнициализацияИтоговойТаблицы() Экспорт
	Таблица=Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Документ",			ЭтотОбъект.Метаданные().ТабличныеЧасти.СписокДокументовДляАнализа.Реквизиты.Документ.Тип);
	Таблица.Колонки.Добавить("НомерВерсииОригинал",	ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(10,0));
	Таблица.Колонки.Добавить("ДатаВерсииОригинал",	ОбщегоНазначения.ПолучитьОписаниеТиповДаты(ЧастиДаты.ДатаВремя));
	Таблица.Колонки.Добавить("АвторВерсииОригинал",	Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	Таблица.Колонки.Добавить("НомерВерсии",			ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(10,0));
	Таблица.Колонки.Добавить("ДатаВерсии",			ОбщегоНазначения.ПолучитьОписаниеТиповДаты(ЧастиДаты.ДатаВремя));
	Таблица.Колонки.Добавить("АвторВерсии",			Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	Таблица.Колонки.Добавить("ГруппировкаВерсий",	ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(10,0));
	Таблица.Колонки.Добавить("ЧислоОтличий",		ОбщегоНазначения.ПолучитьОписаниеТиповЧисла(10,0));
	Таблица.Колонки.Добавить("Комментарий",			ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(100));
	
	Возврат Таблица;
КонецФункции

Процедура ВывестиРезультат(ТаблицаРезультат,ПолеДляВывода) Экспорт
	ПолеДляВывода.Очистить();
	ВнешниеНаборыДанных=Новый Структура("ТаблицаРезультат",ТаблицаРезультат);
	
	//Получаем схему из макета
	СхемаКомпоновкиДанных = ПолучитьМакет("СхемаКомпановкиДанных");
	
	//создадим компоновщик настроек и загрузим настройки по умолчанию, вместо настроек по умолчанию можно использовать восстановленные настройки
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Настройки = КомпоновщикНастроек.Настройки;
	
	//Помещаем в переменную данные о расшифровке данных - здесь ненужный пункт, но пусть будет.
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	//Очищаем поле табличного документа
	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ПолеДляВывода);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	ПолеДляВывода.ОтображатьЗаголовки = Ложь;
	ПолеДляВывода.ОтображатьСетку = Ложь;
	ПолеДляВывода.Защита=Истина;
КонецПроцедуры

Функция РазборВерсии(НомерВерсии, Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ АвторВерсии, ДатаВерсии, ВерсияОбъекта 
	                |ИЗ РегистрСведений.ВерсииОбъектов
	                |ГДЕ Объект = &Ссылка
	                |И НомерВерсии = &НомВер";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("НомВер", Число(НомерВерсии));
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ВерсияОбъекта = Выборка.ВерсияОбъекта.Получить();
	
	Если ВерсияОбъекта = Неопределено Тогда
		Возврат Ложь;
	Иначе
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
		ВерсияОбъекта.Записать(ИмяВременногоФайла);
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);
		СтрокаXML = ТекстовыйДокумент.ПолучитьТекст();
		УдалитьФайлы(ИмяВременногоФайла);
		
		Результат = РазборПредставленияОбъектаXML(СтрокаXML, Ссылка);
		Результат.Вставить("ИмяОбъекта", Строка(Ссылка));
		Результат.Вставить("АвторИзменения", СокрЛП(Строка(Выборка.АвторВерсии)));
		Результат.Вставить("ДатаИзменения", Выборка.ДатаВерсии);
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

Функция РазборПредставленияОбъектаXML(СтрокаXML, Ссылка)
	
	// содержит имя метаданного измененного объекта
	Перем ИмяОбъекта;
	
	// Содержит положение маркера в дереве XML.
	// Требуется для идентификации текущего элемента.
	Перем УровеньЧтения;
	
	// Содержат значения реквизитов справочников / документов
	ЗначенияРеквизитов = Новый ТаблицаЗначений;
	
	ЗначенияРеквизитов.Колонки.Добавить("НаименованиеРеквизита");
	ЗначенияРеквизитов.Колонки.Добавить("ЗначениеРеквизита");
	ЗначенияРеквизитов.Колонки.Добавить("ТипРеквизита");
	
	ТабличныеЧасти = Новый Соответствие;
	
	ЧтениеXML = Новый ЧтениеXML;
	
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	// уровень позиции маркера в иерархии XML:
	// 0 - уровень не задан
	// 1 - первый элемент (имя объекта)
	// 2 - описание реквизита или табличной части
	// 3 - описание строки табличной части
	// 4 - описание поля строки табличной части
	УровеньЧтения = 0;
	
	ТабличныеЧастиМТД = Ссылка.Метаданные().ТабличныеЧасти;
	
	ТипЗначения = "";
	
	ТипЗначенияПоляТЧ = "";
	
	// основной цикл разбора по XML
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			УровеньЧтения = УровеньЧтения + 1;
			Если УровеньЧтения = 1 Тогда // указатель на первом элементе XML - корень XML
				ИмяОбъекта = ЧтениеXML.Имя;
			ИначеЕсли УровеньЧтения = 2 Тогда // указатель на втором уровне - это реквизит или имя табличной части
				ИмяРеквизита = ЧтениеXML.Имя;
				Если ТабличныеЧастиМТД.Найти(ИмяРеквизита) <> Неопределено Тогда
					ИмяТабличнойЧасти = ИмяРеквизита;
					// создаем новую таблицу значений в таблице соответствий
					Если ТабличныеЧасти[ИмяТабличнойЧасти] = Неопределено Тогда
						ТабличныеЧасти.Вставить(ИмяТабличнойЧасти, Новый ТаблицаЗначений);
					КонецЕсли;
				КонецЕсли;
				НовоеЗР = ЗначенияРеквизитов.Добавить();
				НовоеЗР.НаименованиеРеквизита = ИмяРеквизита;
				
				Если ЧтениеXML.КоличествоАтрибутов() > 0 Тогда
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						Если ЧтениеXML.ТипУзла = ТипУзлаXML.Атрибут 
						   И ЧтениеXML.Имя = "xsi:type" Тогда
							НовоеЗР.ТипРеквизита = ЧтениеXML.Значение;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			
			ИначеЕсли (УровеньЧтения = 3) и (ЧтениеXML.Имя = "Row") Тогда // указатель на поле табличной части
				ТабличныеЧасти[ИмяТабличнойЧасти].Добавить();
			ИначеЕсли УровеньЧтения = 4 Тогда // указатель на поле табличной части
				
				ТипЗначенияПоляТЧ = "";
				
				ИмяПоляТЧ = ЧтениеXML.Имя; // 
				Таблица   = ТабличныеЧасти[ИмяТабличнойЧасти];
				Если Таблица.Колонки.Найти(ИмяПоляТЧ)= Неопределено Тогда
					Таблица.Колонки.Добавить(ИмяПоляТЧ);
				КонецЕсли;
				
				Если ЧтениеXML.КоличествоАтрибутов() > 0 Тогда
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						Если ЧтениеXML.ТипУзла = ТипУзлаXML.Атрибут 
						   И ЧтениеXML.Имя = "xsi:type" Тогда
							XMLТип = ЧтениеXML.Значение;
							
							Если Лев(XMLТип, 3) = "xs:" Тогда
								ТипЗначенияПоляТЧ = ИзXMLТипа(Новый ТипДанныхXML(Прав(XMLТип, СтрДлина(XMLТип)-3), "http://www.w3.org/2001/XMLSchema"));
							Иначе
								ТипЗначенияПоляТЧ = ИзXMLТипа(Новый ТипДанныхXML(XMLТип, ""));
							КонецЕсли;
							
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
			КонецЕсли;
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
			УровеньЧтения = УровеньЧтения - 1;
			ТипЗначения = "";
		ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			Если (УровеньЧтения = 2) Тогда // значение реквизита
				НовоеЗР.ЗначениеРеквизита = ЧтениеXML.Значение;
				//ЗначенияРеквизитов[ИмяРеквизита] = ЧтениеXML.Значение;
				
			ИначеЕсли (УровеньЧтения = 4) Тогда // значение реквизита
				ПоследняяСтрока = ТабличныеЧасти[ИмяТабличнойЧасти].Получить(ТабличныеЧасти[ИмяТабличнойЧасти].Количество()-1);
				
				Если ТипЗначенияПоляТЧ = "" Тогда
					
					ОписаниеРТЧ = ТабличныеЧастиМТД[ИмяТабличнойЧасти].Реквизиты.Найти(ИмяПоляТЧ);
					
					Если ОписаниеРТЧ = Неопределено Тогда
						ОписаниеРТЧ = ТабличныеЧастиМТД[ИмяТабличнойЧасти].СтандартныеРеквизиты.Найти(ИмяПоляТЧ);
					КонецЕсли;
					
					Если ОписаниеРТЧ <> Неопределено
					   И ОписаниеРТЧ.Тип.Типы().Количество() = 1 Тогда
						ТипЗначенияПоляТЧ = ОписаниеРТЧ.Тип.Типы()[0];
					КонецЕсли;
					
				КонецЕсли;
				
				ПоследняяСтрока[ИмяПоляТЧ] = ?(НЕ ЗначениеЗаполнено(ТипЗначенияПоляТЧ), ЧтениеXML.Значение, XMLЗначение(ТипЗначенияПоляТЧ, ЧтениеXML.Значение));
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// 2-й этап: из списка реквизитов исключаем табличные части
	Для Каждого Элемент Из ТабличныеЧасти Цикл
		ЗначенияРеквизитов.Удалить(ЗначенияРеквизитов.Найти(Элемент.Ключ));
	КонецЦикла;
	//ТабличныеЧастиМТД
	Для Каждого ЭлементСоответствия Из ТабличныеЧасти Цикл
		Таблица = ЭлементСоответствия.Значение;
		Если Таблица.Колонки.Количество() = 0 Тогда
			ТаблицаМТД = ТабличныеЧастиМТД.Найти(ЭлементСоответствия.Ключ);
			Если ТаблицаМТД <> Неопределено Тогда
				Для Каждого ОписаниеКолонки Из ТаблицаМТД.Реквизиты Цикл
					Если Таблица.Колонки.Найти(ОписаниеКолонки.Имя)= Неопределено Тогда
						Таблица.Колонки.Добавить(ОписаниеКолонки.Имя);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Реквизиты", ЗначенияРеквизитов);
	Результат.Вставить("ТабличныеЧасти", ТабличныеЧасти);
	
	Возврат Результат;
	
КонецФункции

