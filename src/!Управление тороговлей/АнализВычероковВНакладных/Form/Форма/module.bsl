﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	ИндикаторДокументов=0;
	ИндикаторРазборВерсия=0;
	
	//1. Определяем "раннюю версию" для документов
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииОбъектов.Объект КАК Документ,
		|	ВерсииОбъектов.НомерВерсии,
		|	ВерсииОбъектов.ДатаВерсии,
		|	ВерсииОбъектов.АвторВерсии
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВерсииОбъектов.Объект КАК Объект,
		|		МИНИМУМ(ВерсииОбъектов.ДатаВерсии) КАК ДатаВерсии
		|	ИЗ
		|		РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
		|	ГДЕ
		|		ВерсииОбъектов.Объект В(&МассивДокументов)
		|		И ВерсииОбъектов.ДатаВерсии МЕЖДУ &НачПериода И &КонПериода
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ВерсииОбъектов.Объект) КАК ВложенныйЗапрос
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
		|		ПО ВложенныйЗапрос.Объект = ВерсииОбъектов.Объект
		|			И ВложенныйЗапрос.ДатаВерсии = ВерсииОбъектов.ДатаВерсии";
		
	Запрос.УстановитьПараметр("МассивДокументов", СписокДокументовДляАнализа.ВыгрузитьКолонку("Документ"));
	Запрос.УстановитьПараметр("КонПериода", КонецДня(КонПериода));
	Запрос.УстановитьПараметр("НачПериода", НачалоДня(НачПериода));
	РезультатОригиналы=Запрос.Выполнить();
	Если РезультатОригиналы.Пустой() Тогда
		ВызватьИсключение "Не найдено оригинальных версий объектов";
	КонецЕсли;
	ТаблицаОригинальныхВерсия=ПолучитьТаблицуВерсийПоЗапросу(РезультатОригиналы.Выбрать(),"Расчет оригинальных версий","ИндикаторДокументов",ЭтаФорма);
	
	//2. Определяем остальные для документов
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииОбъектов.Объект КАК Документ,
		|	ВерсииОбъектов.НомерВерсии КАК НомерВерсии,
		|	ВерсииОбъектов.ДатаВерсии,
		|	ВерсииОбъектов.АвторВерсии
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВерсииОбъектов.Объект КАК Объект,
		|		МИНИМУМ(ВерсииОбъектов.ДатаВерсии) КАК ДатаВерсии
		|	ИЗ
		|		РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
		|	ГДЕ
		|		ВерсииОбъектов.Объект В(&МассивДокументов)
		|		И ВерсииОбъектов.ДатаВерсии МЕЖДУ &НачПериода И &КонПериода
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ВерсииОбъектов.Объект) КАК ВложенныйЗапрос
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВерсииОбъектов КАК ВерсииОбъектов
		|		ПО ВложенныйЗапрос.Объект = ВерсииОбъектов.Объект
		|			И ВложенныйЗапрос.ДатаВерсии < ВерсииОбъектов.ДатаВерсии
		|ИТОГИ ПО
		|	Документ";
	РезультатВерсии=запрос.Выполнить();
	Если РезультатВерсии.Пустой() Тогда
		ВызватьИсключение "Нет версий объектов для анализа";
	КонецЕсли;                                                 
	ВыборкаВерсийПоДокументам=РезультатВерсии.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	//3. Сборка таблицы результата
	ТаблицаРезультат=ИнициализацияИтоговойТаблицы();
	Пока ВыборкаВерсийПоДокументам.Следующий() Цикл
		ВыборкаВерсий=ВыборкаВерсийПоДокументам.Выбрать();
		ИндикаторРазборВерсия=0;
		ТабТемп=ПолучитьТаблицуВерсийПоЗапросу(ВыборкаВерсий,"Расчет версий для "+Строка(ВыборкаВерсийПоДокументам.Документ),"ИндикаторРазборВерсия",ЭтаФорма);
		
		Таб1=ТаблицаОригинальныхВерсия.Скопировать(ТаблицаОригинальныхВерсия.НайтиСтроки(Новый Структура("Документ",ВыборкаВерсийПоДокументам.Документ)),"Номенклатура,Количество");
		ВыборкаВерсий.Сбросить();
		Сч=1;
		Пока ВыборкаВерсий.Следующий() Цикл
			Таб2=ТабТемп.Скопировать(ТабТемп.НайтиСтроки(Новый Структура("Документ,НомерВерсии",ВыборкаВерсийПоДокументам.Документ,ВыборкаВерсий.НомерВерсии)),"Номенклатура,Количество");
			
			Рез=РазницаТаблицЗначений(Таб1,Таб2,"Номенклатура");
			
			СтрокаРезультат=ТаблицаРезультат.Добавить();
			СтрокаРезультат.Документ				= ВыборкаВерсийПоДокументам.Документ;
			СтрокаТемп=ТаблицаОригинальныхВерсия.Найти(ВыборкаВерсийПоДокументам.Документ,"Документ");
			СтрокаРезультат.НомерВерсииОригинал		= СтрокаТемп.НомерВерсии;
			СтрокаРезультат.ДатаВерсииОригинал		= СтрокаТемп.ДатаВерсии;
			СтрокаРезультат.АвторВерсииОригинал		= СтрокаТемп.АвторВерсии;
			
			СтрокаРезультат.НомерВерсии				= ВыборкаВерсий.НомерВерсии;
			СтрокаРезультат.ДатаВерсии				= ВыборкаВерсий.ДатаВерсии;
			СтрокаРезультат.АвторВерсии				= ВыборкаВерсий.АвторВерсии;
			СтрокаРезультат.ГруппировкаВерсий		= Сч;
			
			СтрокаРезультат.ЧислоОтличий			= Рез.Количество();
			Сч=Сч+1;
		КонецЦикла;
	КонецЦикла;
	
	//4. Передадим данные в скд
	ВывестиРезультат(ТаблицаРезультат,ЭлементыФормы.Результат);
	
	ЭлементыФормы.ОсновнаяПанель.ТекущаяСтраница=ЭлементыФормы.ОсновнаяПанель.Страницы.Отчет;
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

Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	Перем ВыполненноеДействие;
	СтандартнаяОбработка=Ложь;
	Поля=ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьПоля();
	Если Поля.Найти("НомерВерсии")=Неопределено Тогда 
		ОбработкаРасшифровки=Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки,Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		ДоступныеДействия=Новый Массив;      // заполняем доступные действия, если параметр не указан, то будут доступны все действия
		ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
		Настройки=ОбработкаРасшифровки.Выполнить(Расшифровка,ВыполненноеДействие,ДоступныеДействия);
	ИначеЕсли ЗначениеЗаполнено(Поля.Найти("НомерВерсии").Значение) Тогда
		НомерВерсии=Поля.Найти("НомерВерсии").Значение;
		НомерВерсииОригинал=ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьРодителей()[0].ПолучитьПоля().Найти("НомерВерсииОригинал").Значение;
		
		МассивВерсий=Новый СписокЗначений;
		МассивВерсий.Добавить(НомерВерсииОригинал);
		МассивВерсий.Добавить(НомерВерсии);
		
		ТабДок=Новый ТабличныйДокумент;
		ОтчетПоВерсионированию.СсылкаНаОбъект=ДанныеРасшифровки.Элементы[Расшифровка].ПолучитьРодителей()[0].ПолучитьПоля().Найти("Документ").Значение;
		ОтчетПоВерсионированию.СформироватьОтчет(ТабДок,МассивВерсий);
		ТабДок.Защита=Истина;
		ТабДок.Показать();
	КонецЕсли;
КонецПроцедуры

ОтчетПоВерсионированию=Отчеты.ИсторияИзмененийОбъектов.Создать();