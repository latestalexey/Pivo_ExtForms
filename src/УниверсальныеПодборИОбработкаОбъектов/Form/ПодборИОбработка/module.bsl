﻿////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Управляет настройкой элеметов управления формы.
//
// Параметры: 
//  Нет.
//
Процедура вНастроитьЭУ()

	Если ЭлементыФормы.ОбъектПоиска.Значение <> Неопределено Тогда
		Если ЭлементыФормы.ОбъектПоиска.Значение.Тип = "Справочник" Тогда
			ЭлементыФормы.ОбъектПоиска.Картинка = ЭлементыФормы.КартинкаСправочника.Картинка;
		ИначеЕсли ЭлементыФормы.ОбъектПоиска.Значение.Тип = "Документ" Тогда
			ЭлементыФормы.ОбъектПоиска.Картинка = ЭлементыФормы.КартинкаДокумента.Картинка;
		Иначе
			ЭлементыФормы.ОбъектПоиска.Картинка = Неопределено;
		КонецЕсли;
	КонецЕсли;

	Доступность = ЭлементыФормы.ОбъектПоиска.Значение <> Неопределено;
	ЭлементыФормы.КоманднаяПанельПостроительОтчета.Кнопки.НайтиОбъекты.Доступность = Доступность;
	ЭлементыФормы.КоманднаяПанельПостроительОтчета.Кнопки.Настройки.Доступность    = Доступность;
	ЭлементыФормы.КоманднаяПанельНайденныеОбъекты.Кнопки.НайтиОбъекты.Доступность  = Доступность;
	ЭлементыФормы.КоманднаяПанельНайденныеОбъекты.Кнопки.Настройки.Доступность     = Доступность;
	ЭлементыФормы.Панель.Страницы.Обработки.Доступность                            = Доступность;

	Если НЕ ТипОбъектовПоиска = Неопределено Тогда
		ЭлементыФормы.ОбъектПоиска.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры // НастроитьЭУ()

// Выполняет запрос и выгружает результат в таблицу значений.
//
// Параметры: 
//  Нет.
//
Процедура вВыполнитьОтчет() Экспорт

	Настройки = ПостроительОтчета.ПолучитьНастройки();

	ИскомыйОбъект = ЭлементыФормы.ОбъектПоиска.Значение;

	Если СтрокаПоиска <> "" Тогда
		УсловиеПоискаПоСтроке = "";

		СтрокаДляПоиска = СтрЗаменить(СтрокаПоиска, """", """""");

		Если ИскомыйОбъект.Тип = "Справочник" Тогда
			Если ИскомыйОбъект.Объект.ДлинаНаименования <> 0 Тогда
				Если УсловиеПоискаПоСтроке <> "" Тогда
					УсловиеПоискаПоСтроке = УсловиеПоискаПоСтроке + " ИЛИ ";
				КонецЕсли;
				УсловиеПоискаПоСтроке = УсловиеПоискаПоСтроке + " Наименование ПОДОБНО ""%"
				                      + СтрокаДляПоиска + "%""";
			КонецЕсли;

			Если ИскомыйОбъект.Объект.ДлинаКода <> 0 И ИскомыйОбъект.Объект.ТипКода = 
				Метаданные.СвойстваОбъектов.ТипКодаСправочника.Строка Тогда
				Если УсловиеПоискаПоСтроке <> "" Тогда
					УсловиеПоискаПоСтроке = УсловиеПоискаПоСтроке + " ИЛИ ";
				КонецЕсли;
				УсловиеПоискаПоСтроке = УсловиеПоискаПоСтроке + " Код ПОДОБНО ""%"
				                      + СтрокаДляПоиска + "%""";
			КонецЕсли;
		ИначеЕсли ИскомыйОбъект.Тип = "Документ" Тогда
			Если ИскомыйОбъект.Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераДокумента.Строка Тогда
				Если УсловиеПоискаПоСтроке <> "" Тогда
					УсловиеПоискаПоСтроке = УсловиеПоискаПоСтроке + " ИЛИ ";
				КонецЕсли;
				УсловиеПоискаПоСтроке = УсловиеПоискаПоСтроке + " Номер ПОДОБНО ""%"
				                      + СтрокаДляПоиска + "%""";
			КонецЕсли;
		КонецЕсли;

		Для Каждого Реквизит Из ИскомыйОбъект.Объект.Реквизиты Цикл
			Если Реквизит.Тип.СодержитТип(Тип("Строка")) Тогда
				Если УсловиеПоискаПоСтроке <> "" Тогда
					УсловиеПоискаПоСтроке = УсловиеПоискаПоСтроке + " ИЛИ ";
				КонецЕсли;
				УсловиеПоискаПоСтроке = УсловиеПоискаПоСтроке + Реквизит.Имя + " ПОДОБНО ""%"
				                      + СтрокаДляПоиска + "%""";
			КонецЕсли;
		КонецЦикла;

		ПостроительОтчета.Текст = вПолучитьТекстЗапроса(ИскомыйОбъект, УсловиеПоискаПоСтроке);
	Иначе
		ПостроительОтчета.Текст = вПолучитьТекстЗапроса(ИскомыйОбъект);
	КонецЕсли;

	ПостроительОтчета.ЗаполнитьНастройки();
	ПостроительОтчета.УстановитьНастройки(Настройки);

	ПостроительОтчета.Выполнить();
	НайденныеОбъекты = ПостроительОтчета.Результат.Выгрузить();
	
	КолонкаПредставление = НайденныеОбъекты.Колонки.Найти("Представление");
	Если КолонкаПредставление <> Неопределено Тогда
		НайденныеОбъекты.Колонки.Удалить(КолонкаПредставление);
	КонецЕсли; 
	

	ЭлементыФормы.НайденныеОбъекты.СоздатьКолонки();
	ЭлементыФормы.Панель.ТекущаяСтраница = ЭлементыФормы.Панель.Страницы.Получить(1);

	МассивТипов	= Новый Массив;
	МассивТипов.Добавить(Тип("Булево"));

	НайденныеОбъекты.Колонки.Добавить("Пометка", Новый ОписаниеТипов(МассивТипов));

	ЭлементыФормы.НайденныеОбъекты.Колонки["Объект"].ДанныеФлажка = "Пометка";
	ЭлементыФормы.НайденныеОбъекты.Колонки["Объект"].РежимРедактирования = РежимРедактированияКолонки.Непосредственно;

	Для каждого Строка из НайденныеОбъекты Цикл
		Строка.Пометка = Истина;
	КонецЦикла;

КонецПроцедуры // вВыполнитьОтчет()

// Формирует текст запроса.
//
// Параметры: 
//  ИскомыйОбъект         - объект поиска.
//  УсловиеПоискаПоСтроке - строка поиска.
//
Функция вПолучитьТекстЗапроса(ИскомыйОбъект, УсловиеПоискаПоСтроке = "")

	Условие = "";

	ТекстЗапроса = "ВЫБРАТЬ Ссылка КАК Объект, Представление";
	Если ИскомыйОбъект.Тип = "Справочник" Тогда
		Если ИскомыйОбъект.Объект.ОсновноеПредставление <> Метаданные.СвойстваОбъектов.ОсновноеПредставлениеСправочника.ВВидеНаименования Тогда
			Если ИскомыйОбъект.Объект.ДлинаНаименования <> 0 Тогда
				ТекстЗапроса = ТекстЗапроса + ", " + Символы.ПС + "Наименование";
			КонецЕсли;
			Если ИскомыйОбъект.Объект.ДлинаКода <> 0 Тогда
				Условие = "Код";
			КонецЕсли;
		КонецЕсли;
		Если ИскомыйОбъект.Объект.ОсновноеПредставление <> Метаданные.СвойстваОбъектов.ОсновноеПредставлениеСправочника.ВВидеКода Тогда
			Если ИскомыйОбъект.Объект.ДлинаКода <> 0 Тогда
				ТекстЗапроса = ТекстЗапроса + ", " + Символы.ПС + "Код";
			КонецЕсли;
			Если ИскомыйОбъект.Объект.ДлинаНаименования <> 0 Тогда
				Условие = "Наименование";
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ИскомыйОбъект.Тип = "Документ" Тогда
		Условие = "Дата";
		Если ИскомыйОбъект.Объект.ДлинаНомера > 0 Тогда
			Условие = Условие + ", Номер";
		КонецЕсли;
	КонецЕсли;

	Для Каждого Реквизит Из ИскомыйОбъект.Объект.Реквизиты Цикл
		ТекстЗапроса = ТекстЗапроса + ", " + Символы.ПС + Реквизит.Имя;
	КонецЦикла; 

	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ИЗ" + Символы.ПС;
	ТекстЗапроса = ТекстЗапроса + "	" + ИскомыйОбъект.Тип + "." + ИскомыйОбъект.Объект.Имя + " КАК _Таблица" + Символы.ПС;

	Для каждого ТЧ Из ИскомыйОбъект.Объект.ТабличныеЧасти Цикл
		Для каждого ТЧР Из ТЧ.Реквизиты Цикл
			Если Условие <> "" Тогда
				Условие = Условие + ",";
			КонецЕсли;
			Условие = Условие + ТЧ.Имя + "." + ТЧР.Имя + ".* КАК " + ТЧ.Имя + ТЧР.Имя;
		КонецЦикла; 
	КонецЦикла;

	Если Условие <> "" Тогда
		ТекстЗапроса = ТекстЗапроса + "{ГДЕ " + Условие + "}" + Символы.ПС;
	КонецЕсли;

	Если УсловиеПоискаПоСтроке <> "" Тогда
		ТекстЗапроса = ТекстЗапроса + "ГДЕ " + УсловиеПоискаПоСтроке + Символы.ПС;
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + "АВТОУПОРЯДОЧИВАНИЕ";

	Возврат ТекстЗапроса;

КонецФункции // ПолучитьТекстЗапроса()

// Выполняет настройку объекта ПостроительОтчетов.
//
// Параметры: 
//  Нет.
//
Процедура вНастроитьПостроитель()

	Перем Настройки;

	ИскомыйОбъект = ЭлементыФормы.ОбъектПоиска.Значение;

	Если ИскомыйОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;

	НовыйТекущийОбъект = ИскомыйОбъект.Тип + ИскомыйОбъект.Объект.Имя;

	Если ТекущийОбъект <> "" И НовыйТекущийОбъект <> ТекущийОбъект Тогда
		Настройки = ПостроительОтчета.ПолучитьНастройки();
		НастройкиПостроителя.Вставить(ТекущийОбъект, Настройки);
	КонецЕсли;

	ПостроительОтчета.Текст = вПолучитьТекстЗапроса(ИскомыйОбъект);
	ПостроительОтчета.ЗаполнитьНастройки();

	ПостроительОтчета.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.ЗначенияГруппировок;

	ТекущийОбъект = НовыйТекущийОбъект;

	Пока ПостроительОтчета.Отбор.Количество() <> 0 Цикл
		ПостроительОтчета.Отбор.Удалить(0);
	КонецЦикла;

	Если НастройкиПостроителя.Свойство(ТекущийОбъект, Настройки) Тогда
		ПостроительОтчета.УстановитьНастройки(Настройки);
	КонецЕсли;

КонецПроцедуры // НастроитьПостроитель()

Функция вОбработкаДоступна(ПроверяемыйТипОбъекта = "", ИмяОбработки)

	Если ПустаяСтрока(ПроверяемыйТипОбъекта) Тогда
		Возврат Ложь;
	КонецЕсли;

	ТипыОбрабатываемыхОбъектов = ПолучитьФорму(ИмяОбработки).мТипыОбрабатываемыхОбъектов;

	Если ТипыОбрабатываемыхОбъектов = Неопределено Тогда
    	Возврат Истина;
	Иначе
		Если Найти(ТипыОбрабатываемыхОбъектов, ПроверяемыйТипОбъекта) Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции // ОбработкаДоступна()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	Если ЭтаФорма.КлючУникальности = Неопределено Тогда
        Отказ = Истина;
		ЭтотОбъект.ПолучитьФорму("ПодборИОбработка",, Новый УникальныйИдентификатор()).Открыть();
	КонецЕсли;

КонецПроцедуры // ПередОткрытием()

Процедура ПриОткрытии()

	СписокВыбора = ЭлементыФормы.ОбъектПоиска.СписокВыбора;
	ЭлементыФормы.ОбъектПоиска.ВысотаСпискаВыбора = 15;

	Для Каждого Справочник Из Метаданные.Справочники Цикл
		Если ПравоДоступа("Просмотр", Справочник) Тогда
			ИмяСправочника = Справочник.Синоним;
			Если ИмяСправочника = "" Тогда
				ИмяСправочника = Справочник.Имя;
			КонецЕсли;
			Структура = Новый Структура;
			Структура.Вставить("Тип", "Справочник");
			Структура.Вставить("Объект", Справочник);
			СписокВыбора.Добавить(Структура, ИмяСправочника, ,ЭлементыФормы.КартинкаСправочника.Картинка);
		КонецЕсли;
	КонецЦикла;

	Для Каждого Документ Из Метаданные.Документы Цикл
		Если ПравоДоступа("Просмотр", Документ) Тогда
			ИмяДокумента = Документ.Синоним;
			Если ИмяДокумента = "" Тогда
				ИмяДокумента = Документ.Имя;
			КонецЕсли;
			Структура = Новый Структура;
			Структура.Вставить("Тип", "Документ");
			Структура.Вставить("Объект", Документ);
			СписокВыбора.Добавить(Структура, ИмяДокумента, ,ЭлементыФормы.КартинкаДокумента.Картинка);
		КонецЕсли;
	КонецЦикла;

	Если НЕ ТипОбъектовПоиска = Неопределено Тогда
		ТекущийОбъект = мМенеджеры[Метаданные.НайтиПоТипу(ТипОбъектовПоиска)].ИмяТипа + мМенеджеры[Метаданные.НайтиПоТипу(ТипОбъектовПоиска)].Имя;
	КонецЕсли;
	
	Если ТекущийОбъект <> "" Тогда
		Для Каждого ИскомыйОбъект Из ЭлементыФормы.ОбъектПоиска.СписокВыбора Цикл
			Объект = ИскомыйОбъект.Значение.Тип + ИскомыйОбъект.Значение.Объект.Имя;
			Если Объект = ТекущийОбъект Тогда
				ЭлементыФормы.ОбъектПоиска.Значение = ИскомыйОбъект.Значение;
				вНастроитьЭУ();
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		вНастроитьПостроитель();
	КонецЕсли;

	ВосстановленныеДоступныеОбработки = ВосстановитьЗначение("ДоступныеОбработки");
	Если НЕ ВосстановленныеДоступныеОбработки = Неопределено Тогда
		ДоступныеОбработки = ВосстановленныеДоступныеОбработки;
	КонецЕсли;

	ВосстановленныеВыбранныеОбработки = ВосстановитьЗначение("ВыбранныеОбработки");
	Если НЕ ВосстановленныеВыбранныеОбработки = Неопределено Тогда
		ВыбранныеОбработки = ВосстановленныеВыбранныеОбработки;
	КонецЕсли;

	вЗагрузитьОбработки(ДоступныеОбработки, ВыбранныеОбработки);
	
КонецПроцедуры // ПриОткрытии()

Процедура ПриЗакрытии()

    СохранитьЗначение("ДоступныеОбработки", ДоступныеОбработки);
	СохранитьЗначение("ВыбранныеОбработки", ВыбранныеОбработки);
	
КонецПроцедуры

Процедура ПередСохранениемЗначений(Отказ)

	Если ТекущийОбъект <> "" Тогда
		Настройки = ПостроительОтчета.ПолучитьНастройки();
		НастройкиПостроителя.Вставить(ТекущийОбъект, Настройки);
	КонецЕсли;

КонецПроцедуры // ПередСохранениемЗначений()

Процедура ПослеВосстановленияЗначений()

	Если ТекущийОбъект <> "" Тогда
		Для Каждого ИскомыйОбъект Из ЭлементыФормы.ОбъектПоиска.СписокВыбора Цикл
			Объект = ИскомыйОбъект.Значение.Тип + ИскомыйОбъект.Значение.Объект.Имя;
			Если Объект = ТекущийОбъект Тогда
				ЭлементыФормы.ОбъектПоиска.Значение = ИскомыйОбъект.Значение;
				вНастроитьЭУ();
				Прервать;
			КонецЕсли;
		КонецЦикла;

		вНастроитьПостроитель();
	КонецЕсли;

КонецПроцедуры // ПослеВосстановленияЗначений()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ ПостроительОтчета

Процедура Настройки(Кнопка)

	ФормаНастроек = ПолучитьФорму("ФормаНастроек",ЭтаФорма);
	ФормаНастроек.ОткрытьМодально();

КонецПроцедуры // Настройки()

Процедура ВыполнитьПоиск(Кнопка)

	вВыполнитьОтчет();

КонецПроцедуры // ВыполнитьПоиск()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ НайденныеОбъекты

Процедура КоманднаяПанельНайденныеОбъектыУстановитьФлажки(Кнопка)

	Для каждого Строка из НайденныеОбъекты Цикл
		Строка.Пометка = Истина;
	КонецЦикла;

КонецПроцедуры // КоманднаяПанельНайденныеОбъектыУстановитьФлажки()

Процедура КоманднаяПанельНайденныеОбъектыСнятьФлажки(Кнопка)

	Для каждого Строка из НайденныеОбъекты Цикл
		Строка.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры // КоманднаяПанельНайденныеОбъектыСнятьФлажки()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ НайденныеОбъекты

Процедура НайденныеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ОткрытьЗначение(Элемент.ТекущаяСтрока.Объект);

КонецПроцедуры // НайденныеОбъектыВыбор()

Процедура НайденныеОбъектыПередНачаломДобавления(Элемент, Отказ, Копирование)

	Отказ = Истина;

КонецПроцедуры // НайденныеОбъектыПередНачаломДобавления()

Процедура НайденныеОбъектыПередУдалением(Элемент, Отказ)

	Отказ = Истина;

КонецПроцедуры // НайденныеОбъектыПередУдалением()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

Процедура ОбъектПоискаПриИзменении(Элемент)

	вНастроитьПостроитель();
	вНастроитьЭУ();

КонецПроцедуры // ОбъектПоискаПриИзменении()

Процедура ДоступныеОбработкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если ВыбраннаяСтрока.Родитель = Неопределено Тогда
		Если НЕ вОбработкаДоступна(ОбъектПоиска.Тип, ВыбраннаяСтрока.ИмяФормы) Тогда
            Предупреждение("Данная обработка недоступна для типа <" + ОбъектПоиска.Тип + ">");
			Возврат;
		КонецЕсли;
		Обработка = ПолучитьФорму(ВыбраннаяСтрока.ИмяФормы, ЭтаФорма);
	Иначе
		Если НЕ вОбработкаДоступна(ОбъектПоиска.Тип, ВыбраннаяСтрока.Родитель.ИмяФормы) Тогда
            Предупреждение("Данная обработка недоступна для типа <" + ОбъектПоиска.Тип + ">");
			Возврат;
		КонецЕсли;
		Обработка = ПолучитьФорму(ВыбраннаяСтрока.Родитель.ИмяФормы, ЭтаФорма);
	КонецЕсли;

	Обработка.ТекущаяНастройка = ВыбраннаяСтрока;
	Обработка.ОткрытьМодально();
	
КонецПроцедуры // ДоступныеОбработкиВыбор()

Процедура ДоступныеОбработкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель)

	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;

	Если Элемент.ТекущиеДанные.Родитель = Неопределено Тогда
		Если Копирование Тогда
			Отказ = Истина;
        Иначе
			Если НЕ вОбработкаДоступна(ОбъектПоиска.Тип, Элемент.ТекущиеДанные.ИмяФормы) Тогда
	            Предупреждение("Данная обработка недоступна для типа <" + ОбъектПоиска.Тип + ">");
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			Отказ = НЕ ПолучитьФорму(Элемент.ТекущиеДанные.ИмяФормы).мИспользоватьНастройки;
		КонецЕсли;
	Иначе
		Если НЕ вОбработкаДоступна(ОбъектПоиска.Тип, Элемент.ТекущиеДанные.Родитель.ИмяФормы) Тогда
			Предупреждение("Данная обработка недоступна для типа <" + ОбъектПоиска.Тип + ">");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
        Отказ = Истина;
		Если НЕ Копирование Тогда
			Если ПолучитьФорму(Элемент.ТекущиеДанные.Родитель.ИмяФормы).мИспользоватьНастройки Тогда
				ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = Элемент.ТекущиеДанные.Родитель.Строки.Добавить();
				ЭлементыФормы.ДоступныеОбработки.ИзменитьСтроку();
			КонецЕсли;
		Иначе

			НоваяСтрока = Элемент.ТекущиеДанные.Родитель.Строки.Добавить();
			НоваяСтрока.Обработка = Элемент.ТекущиеДанные.Обработка;

			Если НЕ Элемент.ТекущиеДанные.Настройка = Неопределено Тогда
				НоваяНастройка = Новый Структура();
				Для каждого РеквизитНастройки из Элемент.ТекущиеДанные.Настройка Цикл
	                Значение = РеквизитНастройки.Значение;
					Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), Значение);");
				КонецЦикла;

				НоваяСтрока.Настройка = НоваяНастройка;
			КонецЕсли;
			
			ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
			ЭлементыФормы.ДоступныеОбработки.ИзменитьСтроку();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДоступныеОбработкиПередНачаломДобавления()

Процедура ДоступныеОбработкиПередУдалением(Элемент, Отказ)

	Если Элемент.ТекущаяСтрока.Родитель = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если Вопрос("Удалить настройку?", РежимДиалогаВопрос.ОКОтмена,, КодВозвратаДиалога.ОК) = КодВозвратаДиалога.ОК Тогда
        ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("СтрокаДоступнойОбработки", Элемент.ТекущаяСтрока);
		МассивДляУдаления = ВыбранныеОбработки.НайтиСтроки(ПараметрыОтбора);
		Для Индекс = 0 по МассивДляУдаления.Количество() - 1 Цикл
			ВыбранныеОбработки.Удалить(МассивДляУдаления[Индекс]);
		КонецЦикла;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ДоступныеОбработкиПередУдалением()

Процедура ДоступныеОбработкиПередНачаломИзменения(Элемент, Отказ)

	Если Элемент.ТекущиеДанные.Родитель = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ДоступныеОбработкиПередНачаломИзменения()

Процедура ДобавитьВВыбранныеНажатие(Элемент)

	ТекущаяСтрока = ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока;
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		Если ТекущаяСтрока.Родитель = Неопределено Тогда
			ИмяФормы = ТекущаяСтрока.ИмяФормы;
			Если ПолучитьФорму(ИмяФормы).мИспользоватьНастройки Тогда
				Возврат;
			КонецЕсли;
			Если НЕ вОбработкаДоступна(ОбъектПоиска.Тип, ТекущаяСтрока.ИмяФормы) Тогда
	            Предупреждение("Данная обработка недоступна для типа <" + ОбъектПоиска.Тип + ">");
				Возврат;
			КонецЕсли;
			НоваяСтрока = ВыбранныеОбработки.Добавить();
			НоваяСтрока.СтрокаДоступнойОбработки = ТекущаяСтрока;
			НоваяСтрока.Пометка                  = Истина;
		Иначе
            ИмяФормы = ТекущаяСтрока.Родитель.ИмяФормы;
			Если НЕ вОбработкаДоступна(ОбъектПоиска.Тип, ТекущаяСтрока.Родитель.ИмяФормы) Тогда
	            Предупреждение("Данная обработка недоступна для типа <" + ОбъектПоиска.Тип + ">");
				Возврат;
			КонецЕсли;
			НоваяСтрока = ВыбранныеОбработки.Добавить();
			НоваяСтрока.СтрокаДоступнойОбработки = ТекущаяСтрока;
			НоваяСтрока.Пометка                  = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыбранныеОбработкиПередНачаломДобавления(Элемент, Отказ, Копирование)

	Если НЕ Копирование Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыбранныеОбработкиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
    Если ВыбраннаяСтрока.СтрокаДоступнойОбработки.Родитель = Неопределено Тогда
		Обработка = ПолучитьФорму(ВыбраннаяСтрока.СтрокаДоступнойОбработки.ИмяФормы, ЭтаФорма);
	Иначе
		Обработка = ПолучитьФорму(ВыбраннаяСтрока.СтрокаДоступнойОбработки.Родитель.ИмяФормы, ЭтаФорма);
	КонецЕсли;

	Обработка.ТекущаяНастройка = ВыбраннаяСтрока.СтрокаДоступнойОбработки;
	Обработка.ОткрытьМодально();

КонецПроцедуры // ВыбранныеОбработкиВыбор()

Процедура КоманднаяПанельВыбранныеОбработкиВыполнить(Кнопка)

	Для каждого Строка из ВыбранныеОбработки Цикл
		Если Строка.Пометка Тогда
			Если Строка.СтрокаДоступнойОбработки.Родитель = Неопределено Тогда
				ИмяФормы = Строка.СтрокаДоступнойОбработки.ИмяФормы;
			Иначе
				ИмяФормы = Строка.СтрокаДоступнойОбработки.Родитель.ИмяФормы;
			КонецЕсли;
			Если НЕ вОбработкаДоступна(ОбъектПоиска.Тип, ИмяФормы) Тогда
	            Сообщить("Обработка " + ИмяФормы + " недоступна для типа <" + ОбъектПоиска.Тип + ">");
				Продолжить;
			КонецЕсли;
			Обработка = ПолучитьФорму(ИмяФормы, ЭтаФорма);
			Обработка.ТекущаяНастройка = Строка.СтрокаДоступнойОбработки;
			Обработка.вЗагрузитьНастройку();
			Обработка.вВыполнитьОбработку();
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // КоманднаяПанельОбработкиВыполнить()

Процедура КоманднаяПанельВыбранныеОбработкиУстановитьФлажки(Кнопка)

	Для каждого Строка из ВыбранныеОбработки Цикл
		Строка.Пометка = Истина;
	КонецЦикла;

КонецПроцедуры // КоманднаяПанельВыбранныеОбработкиУстановитьФлажки()

Процедура КоманднаяПанельВыбранныеОбработкиСнятьФлажки(Кнопка)

	Для каждого Строка из ВыбранныеОбработки Цикл
		Строка.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры // КоманднаяПанельВыбранныеОбработкиСнятьФлажки()

Процедура ДоступныеОбработкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)

	ОформлениеСтроки.Ячейки["Обработка"].ОтображатьКартинку = Истина;
	Если ДанныеСтроки.Родитель = Неопределено Тогда
		ОформлениеСтроки.Ячейки["Обработка"].ИндексКартинки = 0;
	Иначе
		ОформлениеСтроки.Ячейки["Обработка"].ИндексКартинки = 1;
	КонецЕсли;
	
КонецПроцедуры // ДоступныеОбработкиПриВыводеСтроки()

Процедура ВыбранныеОбработкиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)

    СтрокаДоступнойОбработки = ДанныеСтроки.СтрокаДоступнойОбработки;
	Если НЕ СтрокаДоступнойОбработки = Неопределено Тогда
        Если СтрокаДоступнойОбработки.Родитель = Неопределено Тогда
			ОформлениеСтроки.Ячейки.ОбработкаНастройка.УстановитьТекст(Строка(СтрокаДоступнойОбработки.Обработка));
		Иначе
			ОформлениеСтроки.Ячейки.ОбработкаНастройка.УстановитьТекст(Строка(СтрокаДоступнойОбработки.Родитель.Обработка) + " - " + Строка(СтрокаДоступнойОбработки.Обработка));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельДоступныеОбработкиСохранитьНастройку(Кнопка)

	ДиалогВыбораФайла =	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	
	ДиалогВыбораФайла.Фильтр                      =	"Файл сохраненной настройки (*.sav)|*.sav";
	ДиалогВыбораФайла.Заголовок                   =	"Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр     =	Ложь;
	ДиалогВыбораФайла.Расширение                  =	"sav";
	ДиалогВыбораФайла.ИндексФильтра               =	0;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла =	Ложь;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ИмяФайла = ДиалогВыбораФайла.ПолноеИмяФайла;
	Иначе
		Возврат;
	КонецЕсли;

	Настройка = Новый Соответствие();

	ВыбранныеОбработкиДляСохранения = Новый ТаблицаЗначений;

	ВыбранныеОбработкиДляСохранения.Колонки.Добавить("ИмяФормы");
	ВыбранныеОбработкиДляСохранения.Колонки.Добавить("НомерНастройки");
	ВыбранныеОбработкиДляСохранения.Колонки.Добавить("Пометка");

	Для каждого ВыбраннаяОбработка из ВыбранныеОбработки Цикл
		НоваяСтрока = ВыбранныеОбработкиДляСохранения.Добавить();
        Если ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель = Неопределено Тогда
			НоваяСтрока.ИмяФормы       = ВыбраннаяОбработка.СтрокаДоступнойОбработки.ИмяФормы;
			НоваяСтрока.НомерНастройки = ВыбраннаяОбработка.СтрокаДоступнойОбработки.Строки.Индекс(ВыбраннаяОбработка.СтрокаДоступнойОбработки);
			НоваяСтрока.Пометка        = ВыбраннаяОбработка.Пометка;
		Иначе
			НоваяСтрока.ИмяФормы       = ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель.ИмяФормы;
			НоваяСтрока.НомерНастройки = ВыбраннаяОбработка.СтрокаДоступнойОбработки.Родитель.Строки.Индекс(ВыбраннаяОбработка.СтрокаДоступнойОбработки);
			НоваяСтрока.Пометка        = ВыбраннаяОбработка.Пометка;
		КонецЕсли;
	КонецЦикла;

	Настройка.Вставить("ДоступныеОбработки", ДоступныеОбработки);
	Настройка.Вставить("ВыбранныеОбработки", ВыбранныеОбработкиДляСохранения);

	Если НЕ ЗначениеВФайл(ИмяФайла, Настройка) Тогда
		Предупреждение("Настройка не сохранена!!!");
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельДоступныеОбработкиЗагрузитьНастройку(Кнопка)

	ДиалогВыбораФайла =	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Фильтр                      =	"Файл сохраненной настройки (*.sav)|*.sav";
	ДиалогВыбораФайла.Заголовок                   =	"Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр     =	Ложь;
	ДиалогВыбораФайла.Расширение                  =	"sav";
	ДиалогВыбораФайла.ИндексФильтра               =	0;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла =	Истина;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		ИмяФайла = ДиалогВыбораФайла.ПолноеИмяФайла;
	Иначе
		Возврат;
	КонецЕсли;

	Настройка = ЗначениеИзФайла(ИмяФайла);
	ДоступныеОбработки            = Настройка["ДоступныеОбработки"];
	ВыбранныеОбработкиДляЗагрузки = Настройка["ВыбранныеОбработки"];

	ВыбранныеОбработки.Очистить();

	Для каждого ВыбраннаяОбработка из ВыбранныеОбработкиДляЗагрузки Цикл
        Форма = ДоступныеОбработки.Строки.Найти(ВыбраннаяОбработка.ИмяФормы, "ИмяФормы");
		Если НЕ Форма = Неопределено Тогда
			Если ПолучитьФорму(ВыбраннаяОбработка.ИмяФормы).мИспользоватьНастройки Тогда
				Настройка = Форма.Строки.Получить(ВыбраннаяОбработка.НомерНастройки);
			Иначе
				Настройка = Форма;
			КонецЕсли;
			
            Если НЕ Настройка = Неопределено Тогда
				НоваяСтрока = ВыбранныеОбработки.Добавить();
				НоваяСтрока.СтрокаДоступнойОбработки = Настройка;
				НоваяСтрока.Пометка                  = ВыбраннаяОбработка.Пометка;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	вЗагрузитьОбработки(ДоступныеОбработки, ВыбранныеОбработки);
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОчиститьНатройкиОбработок(Кнопка)

	СохранитьЗначение("ДоступныеОбработки", Неопределено);
	СохранитьЗначение("ВыбранныеОбработки", Неопределено);

	ДоступныеОбработки.Строки.Очистить();
	ВыбранныеОбработки.Очистить();

	вЗагрузитьОбработки(ДоступныеОбработки, ВыбранныеОбработки);
	
КонецПроцедуры // ГлавнаяКоманднаяПанельОчиститьНатройкиОбработок()
