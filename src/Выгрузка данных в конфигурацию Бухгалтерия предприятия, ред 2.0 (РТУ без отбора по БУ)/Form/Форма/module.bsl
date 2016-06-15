﻿Перем мФормаВыбораФильтров;
Перем мФормаПодбораЗначенийФильтра;
Перем мТаблицаФильтры;
Перем мСтруктураТиповФильтров;
Перем мТипФильтраПоУмолчанию;

Перем мУниверсальнаяВыгрузкаДанных;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Служит для настройки построителя при отборе данных
//
// Параметры:
//
Процедура НастроитьПостроитель()

	ТекущееПВД = ЭлементыФормы.ТаблицаПравилВыгрузки.ТекущаяСтрока;
	Если ТекущееПВД.ЭтоГруппа = ИСТИНА ИЛИ 
		 НЕ ТекущееПВД.СпособОтбораДанных = "СтандартнаяВыборка"
		 ИЛИ ТекущееПВД.ИмяОбъектаДляЗапроса = Неопределено Тогда
		ЭлементыФормы.ПостроительОтбор.Доступность                 = ЛОЖЬ;
		ЭлементыФормы.КоманднаяПанельПостроительОтбор.Доступность = ЛОЖЬ;
		КоличествоСтрокОтбора = Построитель.Отбор.Количество();
		Если КоличествоСтрокОтбора Тогда
			Для Индекс = 1 По КоличествоСтрокОтбора Цикл
				Построитель.Отбор.Удалить(0);
			КонецЦикла;
		КонецЕсли;
	Иначе
		ОбъектМетаданных  = Метаданные.НайтиПоТипу(ТекущееПВД.ОбъектВыборки);
		ИмяМетаданных     = СтрЗаменить(ОбъектМетаданных.ПолноеИмя(), ОбъектМетаданных.Имя, ОбъектМетаданных.Представление());
		Построитель.Текст = "ВЫБРАТЬ _.Ссылка КАК Ссылка ИЗ " + ТекущееПВД.ИмяОбъектаДляЗапроса + " КАК _ "+ "{ГДЕ _.Ссылка.* КАК " + СтрЗаменить(ТекущееПВД.ИмяОбъектаДляЗапроса, ".", "_") + "}";
		Построитель.Отбор.Сбросить();
		Если НЕ ТекущееПВД.НастройкиПостроителя = Неопределено Тогда
			Построитель.УстановитьНастройки(ТекущееПВД.НастройкиПостроителя);
		КонецЕсли;
		ЭлементыФормы.ПостроительОтбор.Доступность                 = ИСТИНА;
		ЭлементыФормы.КоманднаяПанельПостроительОтбор.Доступность = ИСТИНА;
	КонецЕсли;

КонецПроцедуры

// Устанавливает состояние пометки у подчиненных строк строки дерева значений
// в зависимости от пометки текущей строки
//
// Параметры:
//  ТекСтрока      - Строка дерева значений
// 
Процедура УстановитьПометкиПодчиненных(ТекСтрока)

	Включить    = ТекСтрока.Включить;
	Подчиненные = ТекСтрока.Строки;

	Если Подчиненные.Количество() > 0 Тогда
		Для каждого Строка из Подчиненные Цикл
			Строка.Включить = Включить;
			УстановитьПометкиПодчиненных(Строка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры // УстановитьПометкиПодчиненных()

// Устанавливает состояние пометки у родительских строк строки дерева значений
// в зависимости от пометки текущей строки
//
// Параметры:
//  ТекСтрока      - Строка дерева значений
// 
Процедура УстановитьПометкиРодителей(ТекСтрока)

	Родитель = ТекСтрока.Родитель;
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли; 

	ТекСостояние       = Родитель.Включить;

	НайденыВключенные  = Ложь;
	НайденыВыключенные = Ложь;

	Для каждого Строка из Родитель.Строки Цикл
        Если Строка.Включить = 0 Тогда
			НайденыВыключенные = Истина;
		ИначеЕсли Строка.Включить = 1 Тогда
			НайденыВключенные  = Истина;
		КонецЕсли; 
		Если НайденыВключенные И НайденыВыключенные Тогда
			Прервать;
		КонецЕсли; 
	КонецЦикла;

	
	Если НайденыВключенные И НайденыВыключенные Тогда
		Включить = 2;
	ИначеЕсли НайденыВключенные И (Не НайденыВыключенные) Тогда
		Включить = 1;
	ИначеЕсли (Не НайденыВключенные) И НайденыВыключенные Тогда
		Включить = 0;
	ИначеЕсли (Не НайденыВключенные) И (Не НайденыВыключенные) Тогда
		Включить = 2;
	КонецЕсли;

	Если Включить = ТекСостояние Тогда
		Возврат;
	Иначе
		Родитель.Включить = Включить;
		УстановитьПометкиРодителей(Родитель);
	КонецЕсли; 
	
КонецПроцедуры // УстановитьПометкиРодителей()

// Выполняет настройку обработки по умолчанию
//
Процедура ЗаполнитьНачальныеНастройки() 

	НоваяСтрока = ТаблицаСписокФильтров.Добавить();
	НоваяСтрока.ИмяФильтра		 	 = "Подразделение";
	НоваяСтрока.ПредставлениеФильтра = "Подразделение";
	НоваяСтрока.ОписаниеФильтра 	 = "Подразделение";

	МассивТиповПодразделения = Новый Массив;
	МассивТиповПодразделения.Добавить(Тип("СправочникСсылка.Подразделения"));
	
	ОписаниеТиповФильтра             = Новый ОписаниеТипов(МассивТиповПодразделения);
	НоваяСтрока.ТипФильтра           = ЭлементыФормы.ТипФильтра.СписокВыбора[0].Значение; //ОписаниеТиповФильтра;
	НоваяСтрока.СписокФильтров.Колонки.Очистить();
	НоваяСтрока.СписокФильтров.Колонки.Добавить("ЗначениеФильтра", ОписаниеТиповФильтра);

	НоваяСтрока = ТаблицаСписокФильтров.Добавить();
	НоваяСтрока.ИмяФильтра		 	 = "Склад";
	НоваяСтрока.ПредставлениеФильтра = "Склад";
	НоваяСтрока.ОписаниеФильтра 	 = "Склад";

	МассивТиповСклады = Новый Массив;
	МассивТиповСклады.Добавить(Тип("СправочникСсылка.Склады"));
	
	ОписаниеТиповФильтра             = Новый ОписаниеТипов(МассивТиповСклады);
	НоваяСтрока.ТипФильтра           = ЭлементыФормы.ТипФильтра.СписокВыбора[0].Значение; //ОписаниеТиповФильтра;
	НоваяСтрока.СписокФильтров.Колонки.Очистить();
	НоваяСтрока.СписокФильтров.Колонки.Добавить("ЗначениеФильтра", ОписаниеТиповФильтра);

	мТаблицаФильтры.Очистить();

	СтрФильтры = мТаблицаФильтры.Добавить();
	СтрФильтры.ИмяПоля           = "Подразделение";
	СтрФильтры.ПредставлениеПоля = "Подразделение";
	СтрФильтры.ОписаниеПоля      = "Подразделение";

	СтрФильтры.ОписаниеТипов = Новый ОписаниеТипов(МассивТиповПодразделения);

	СтрФильтры = мТаблицаФильтры.Добавить();
	СтрФильтры.ИмяПоля           = "Склад";
	СтрФильтры.ПредставлениеПоля = "Склад";
	СтрФильтры.ОписаниеПоля      = "Склад";

	СтрФильтры.ОписаниеТипов = Новый ОписаниеТипов(МассивТиповСклады);

	ФильтрыОтчета    .Очистить();

КонецПроцедуры // ЗаполнитьНачальныеНастройкиИзменениеЦен()

// Заполняет элементы формы отчета в соответствии со значениями реквизитов.
// Параметры:
//	Нет.
//
Процедура ЗаполнитьПоРеквизитам()

	// Восстановим таблицу фильтров.

	МассивСтрока = Новый Массив; 
	МассивСтрока.Добавить(Тип("Строка"));
	КвалификаторСтроки = Новый КвалификаторыСтроки("100", ДопустимаяДлина.Переменная);
	ОписаниеТиповСтрока = Новый ОписаниеТипов(МассивСтрока, , КвалификаторСтроки);

	ТаблицаСписокВсехФильтров = ФильтрыОтчета.Выгрузить();
	ТаблицаСписокВсехФильтров.Свернуть("ИмяФильтра",);

	СтруктураПоиска = Новый Структура("ИмяФильтра");

	Для Каждого Фильтр Из ТаблицаСписокВсехФильтров Цикл
		
		НоваяСтрока = ТаблицаСписокФильтров.Добавить();
		
		// Определим типы значения добавляемого фильтра.
		ВидФильтра=мТаблицаФильтры.Найти(Фильтр.ИмяФильтра,"ИмяПоля");

		Если ВидФильтра<>Неопределено Тогда
			ОписаниеТиповФильтра=ВидФильтра.ОписаниеТипов;
		Иначе
			ОписаниеТиповФильтра=ОписаниеТиповСтрока;
		КонецЕсли;

		НоваяСтрока.СписокФильтров.Колонки.Очистить();
		НоваяСтрока.СписокФильтров.Колонки.Добавить("ЗначениеФильтра", ОписаниеТиповФильтра);

		СтруктураПоиска.ИмяФильтра = Фильтр.ИмяФильтра;

		НайденныеСтроки = ФильтрыОтчета.НайтиСтроки(СтруктураПоиска);

		// Общие данные берем из первой строки: строки с одинаковым именем фильтра
		// должны содержать одинаковые значения ОписаниеФильтра, ПредставлениеФильтра
		НоваяСтрока.ИмяФильтра		 	 = Фильтр.ИмяФильтра;
		НоваяСтрока.ОписаниеФильтра 	 = НайденныеСтроки[0].ОписаниеФильтра;
		НоваяСтрока.ПредставлениеФильтра = НайденныеСтроки[0].ПредставлениеФильтра;
		
		Если НайденныеСтроки.Количество() = 1 
			И (НайденныеСтроки[0].ТипФильтра = мТипФильтраПоУмолчанию 
			ИЛИ ПустаяСтрока(НайденныеСтроки[0].ТипФильтра)) Тогда

			// Одиночный фильтр заносим в поле ЗначениеФильтра таблицы
			НоваяСтрока.ТипФильтра      = мТипФильтраПоУмолчанию;
			НоваяСтрока.ЗначениеФильтра = НайденныеСтроки[0].ЗначениеФильтра;
		Иначе

			// Множественный фильтр: заносим строку представления в поле ЗначениеФильтра таблицы,
			// конкретные значения - в поле СписокФильтров, которое является таблицей.
			НоваяСтрока.ТипФильтра      = НайденныеСтроки[0].ТипФильтра;
			НоваяСтрока.ЗначениеФильтра = "<Задано множественным фильтром>";
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл

				НоваяСтрокаСписка = НоваяСтрока.СписокФильтров.Добавить();
				НоваяСтрокаСписка.ЗначениеФильтра= НайденнаяСтрока.ЗначениеФильтра;
			КонецЦикла;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ЗаполнитьПоРеквизитам()

// Обновляет заданную строку списка фильтров
// Параметры:
//	СписокФильтров - таблица значений множественного фильтра
//	Фильтр - строка списка фильтров
//
Процедура ОбновитьСтрокуСпискаФильтров(СписокФильтров, Фильтр)

	Если СписокФильтров.Количество() > 0  Тогда

		Фильтр.ЗначениеФильтра = "<Задано множественным фильтром>";

	Иначе

		Если Фильтр.ЗначениеФильтра = "<Задано множественным фильтром>" Тогда

			НайдСтр = мТаблицаФильтры.Найти(Фильтр.ИмяФильтра, "ИмяПоля");

			Если НайдСтр <> Неопределено Тогда

				ТипыЗначения = НайдСтр.ОписаниеТипов.Типы();

				// Если тип единичный, то присвоим пустое значение этого типа			
				Если ТипыЗначения.Количество() = 1 Тогда

					Фильтр.ЗначениеФильтра = ОбщегоНазначения.ПустоеЗначениеТипа(ТипыЗначения[0]);

				Иначе

					Фильтр.ЗначениеФильтра = Неопределено;

				КонецЕсли;

			Иначе

				Фильтр.ЗначениеФильтра = Неопределено;


			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ОбновитьСтрокуСпискаФильтров()

// Обновляет все строки списка фильтров
//
Процедура ОбновитьСписокФильтров()

	Таблица = ЭлементыФормы.ТабличноеПолеСписокФильтров.Значение;

	Для Каждого СтрокаТаблицы Из Таблица Цикл

		ОбновитьСтрокуСпискаФильтров(СтрокаТаблицы.СписокФильтров, СтрокаТаблицы);

	КонецЦикла;

КонецПроцедуры // ОбновитьСписокФильтров()

// Обновляет значение, связанное с табличным полем ТабличноеПолеЗначенияФильтров,
// что позволяет показывать множественный фильтр, соответствующий текущей строке
// списка фильтров.
// Параметры:
//	Нет.
//
Процедура ОбновитьТабличноеПолеЗначенияФильтров()

	Элемент = ЭлементыФормы.ТабличноеПолеСписокФильтров;

	Если Элемент.ТекущиеДанные = Неопределено Тогда 
		Возврат 
	КонецЕсли;

	СтруктураПоиска = Новый Структура;

	СписокФильтров = Элемент.ТекущиеДанные.СписокФильтров;

	Если СписокФильтров.Колонки.Найти("ЗначениеФильтра") = Неопределено Тогда
		СписокФильтров.Колонки.Добавить("ЗначениеФильтра",,"Множественный фильтр");
	КонецЕсли;

	ЭлементыФормы.ТабличноеПолеЗначенияФильтров.Значение = СписокФильтров;

КонецПроцедуры // ОбновитьТабличноеПолеЗначенияФильтров()

// Инициализирует универсальную обработку выгрузки данных, загружает правила
//
// Параметры:
//  Нет.
// 
Процедура ИнициализироватьУниверсальнуюОбработкуВыгрузкиДанных()

	// Инициализация обработки УниверсальныйОбменДаннымиXML
	
	мУниверсальнаяВыгрузкаДанных = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	
КонецПроцедуры // ЗагрузитьПравилаОбмена() 

// Перенос настройки, заданной в диалоге, в реквизиты отчета.
//
Процедура ЗаполнитьРеквизитыПоДиалогу()

	// Добавим фильтры
	Таблица = ЭлементыФормы.ТабличноеПолеСписокФильтров.Значение;
	ФильтрыОтчета.Очистить();

	Для Каждого СтрокаТаблицы Из Таблица Цикл

		Если СтрокаТаблицы.СписокФильтров.Количество() = 0 Тогда

			НоваяСтрока = ФильтрыОтчета.Добавить();
			НоваяСтрока.ИмяФильтра           = СтрокаТаблицы.ИмяФильтра;
			НоваяСтрока.ПредставлениеФильтра = СтрокаТаблицы.ПредставлениеФильтра;
			НоваяСтрока.ЗначениеФильтра      = СтрокаТаблицы.ЗначениеФильтра;
			НоваяСтрока.ОписаниеФильтра      = СтрокаТаблицы.ОписаниеФильтра;
			НоваяСтрока.ТипФильтра           = СтрокаТаблицы.ТипФильтра;

		Иначе

			Для Каждого Фильтр Из СтрокаТаблицы.СписокФильтров Цикл

				НоваяСтрока = ФильтрыОтчета.Добавить();
				НоваяСтрока.ИмяФильтра           = СтрокаТаблицы.ИмяФильтра;
				НоваяСтрока.ПредставлениеФильтра = СтрокаТаблицы.ПредставлениеФильтра;
				НоваяСтрока.ЗначениеФильтра      = Фильтр.ЗначениеФильтра;
				НоваяСтрока.ОписаниеФильтра      = СтрокаТаблицы.ОписаниеФильтра;
				НоваяСтрока.ТипФильтра           = СтрокаТаблицы.ТипФильтра;

			КонецЦикла;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ЗаполнитьРеквизитыПоДиалогу()

// Вызывает диалог выбора файла для выбора файла данных
//
Процедура ВыборФайла(Элемент, ПроверятьСуществование=Ложь)
	
	ДиалогФыбораФайла								=	Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогФыбораФайла.Фильтр						=	"Файл данных (*.xml)|*.xml";
	ДиалогФыбораФайла.Заголовок						=	"Выберите файл";
	ДиалогФыбораФайла.ПредварительныйПросмотр		=	Ложь;
	ДиалогФыбораФайла.Расширение					=	"xml";
	ДиалогФыбораФайла.ИндексФильтра					=	0;
	ДиалогФыбораФайла.ПолноеИмяФайла				=	Элемент.Значение;
	ДиалогФыбораФайла.ПроверятьСуществованиеФайла	=	ПроверятьСуществование;
	
	Если ДиалогФыбораФайла.Выбрать() Тогда
		Элемент.Значение = ДиалогФыбораФайла.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработкчик события "ПередОткрытием"
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	СписокТиповФильтра=Новый СписокЗначений;

	Для Каждого ЭлементСтруктуры Из мСтруктураТиповФильтров Цикл

		СписокТиповФильтра.Добавить(ЭлементСтруктуры.Ключ,ЭлементСтруктуры.Значение);

	КонецЦикла;

	ЭлементыФормы.ТипФильтра.СписокВыбора = СписокТиповФильтра;
	ЭлементыФормы.ТипФильтра.Значение=СписокТиповФильтра[0].Значение;

	ТаблицаСписокФильтров.Очистить();

	ЗаполнитьНачальныеНастройки();
	ЗаполнитьПоРеквизитам();
	ОбновитьСписокФильтров();
	
	Если БазоваяВерсия Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (базовая версия)";		
		ЭлементыФормы.ЮридическоеЛицо.АвтоОтметкаНезаполненного = Истина;
	Иначе
		ЭлементыФормы.ЮридическоеЛицо.АвтоОтметкаНезаполненного = Ложь;
		ЭлементыФормы.ЮридическоеЛицо.ОтметкаНезаполненного     = Ложь;
	КонецЕсли;	
	НеЗамещатьДокументыПриЗагрузке = Истина;
	НеЗамещатьСправочникиПриЗагрузке = Ложь;

	ИнициализироватьУниверсальнуюОбработкуВыгрузкиДанных();

	
КонецПроцедуры // ПередОткрытием()

// Процедура - обработкчик события "ПриЗакрытии"
//
Процедура ПриЗакрытии()

	ФильтрыОтчета.Очистить();

КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора".
//
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)

	Если Источник = мФормаВыбораФильтров Тогда

		Если ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока  = Неопределено Тогда
			Возврат;
		КонецЕсли;

		РедактируемаяСтрока = ТаблицаСписокФильтров[ТаблицаСписокФильтров.Индекс(ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока)];

		Для Каждого Строка Из ЗначениеВыбора Цикл // должно содержать не более одной строки
			РедактируемаяСтрока.ИмяФильтра= Строка.ИмяФильтра;
			РедактируемаяСтрока.ПредставлениеФильтра = Строка.ПредставлениеФильтра;
			РедактируемаяСтрока.ОписаниеФильтра = Строка.ОписаниеФильтра;

			ТипыЗначения = Строка.ОписаниеТипов.Типы();

			// Если тип единичный, то присвоим пустое значение этого типа			
			Если ТипыЗначения.Количество() = 1 Тогда
				РедактируемаяСтрока.ЗначениеФильтра = ОбщегоНазначения.ПустоеЗначениеТипа(ТипыЗначения[0]);
			Иначе
				РедактируемаяСтрока.ЗначениеФильтра = Неопределено;
			КонецЕсли;
			РедактируемаяСтрока.СписокФильтров.Колонки.Очистить();
			РедактируемаяСтрока.СписокФильтров.Колонки.Добавить("ЗначениеФильтра", Строка.ОписаниеТипов,"Множественный фильтр: "+Строка.ПредставлениеФильтра);

			ЭлементыФормы.ТипФильтра.Значение=мТипФильтраПоУмолчанию;
			РедактируемаяСтрока.ТипФильтра=мТипФильтраПоУмолчанию;

			ОбновитьТабличноеПолеЗначенияФильтров();

			ЭлементыФормы.ТабличноеПолеЗначенияФильтров.Колонки.Очистить();
			НоваяКолонка = ЭлементыФормы.ТабличноеПолеЗначенияФильтров.Колонки.Добавить("ЗначениеФильтра");
			НоваяКолонка.Имя = "ЗначениеФильтра";
			НоваяКолонка.Данные = "ЗначениеФильтра";
			НоваяКолонка.ТекстШапки= "Множественный фильтр: "+ Строка.ПредставлениеФильтра;
			НоваяКолонка.Ширина = 10;
			НоваяКолонка.УстановитьЭлементУправления(Тип("ПолеВвода"));
			НоваяКолонка.ЭлементУправления.АвтоВыборНезаполненного=Истина;
			НоваяКолонка.ЭлементУправления.АвтоОтметкаНезаполненного=Ложь;
			НоваяКолонка.ЭлементУправления.РежимВыбораНезаполненного=РежимВыбораНезаполненного.ПриАктивизации;
		
			Попытка
				НоваяКолонка.ЭлементУправления.ВыборГруппИЭлементов=ИспользованиеГруппИЭлементов.ГруппыИЭлементы;
			Исключение

			КонецПопытки;

		КонецЦикла;

	ИначеЕсли Источник = мФормаПодбораЗначенийФильтра Тогда
		Если ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущиеДанные  = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		НоваяСтрока = ЭлементыФормы.ТабличноеПолеЗначенияФильтров.Значение.Добавить();
		НоваяСтрока.ЗначениеФильтра = ЗначениеВыбора;
		ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущиеДанные.ЗначениеФильтра = "<Задано множественным фильтром>";
	КонецЕсли;

КонецПроцедуры // ОбработкаВыбора()

// Процедура - обработчик нажатия кнопки настройки периода.
//
Процедура КнопкаНастройкаПериодаНажатие(Элемент)
	
	НП = Новый НастройкаПериода;
	НП.УстановитьПериод(ДатаНач, ДатаКон);

	Если НП.Редактировать() Тогда

		ДатаНач = НП.ПолучитьДатуНачала();
		ДатаКон = НП.ПолучитьДатуОкончания();

	КонецЕсли;

КонецПроцедуры // КнопкаНастройкаПериодаНажатие()

// Процедура - обработчик события "НачалоВыбора" для поля "Имя файла данных"
//
Процедура ИмяФайлаДанныхНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ВыборФайла(Элемент);
	
КонецПроцедуры

// Процедура - обработчик события "Открытие" для поля "Имя файла данных"
//
Процедура ИмяФайлаДанныхОткрытие(Элемент, СтандартнаяОбработка)

	ЗапуститьПриложение("explorer " + Элемент.Значение);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


// Процедура вызывается при нажатии кнопки "Выполнить".
//
Процедура КнопкаВыполнитьНажатие(Элемент)

	ЗаполнитьРеквизитыПоДиалогу();

	Если ПустаяСтрока(ФайлВыгрузки) Тогда
		Предупреждение("Не указано имя файла данных.");
		Возврат;
	КонецЕсли;
	
	Если БазоваяВерсия И НЕ ЗначениеЗаполнено(Организация) Тогда
		Предупреждение("Не выбрана организация!");
		Возврат;
	КонецЕсли;

	ТаблицаСписокВсехФильтров = ФильтрыОтчета.Выгрузить();
	ТаблицаСписокВсехФильтров.Свернуть("ИмяФильтра, ЗначениеФильтра",);
	
	// Загрузка правил обмена

	Если ТаблицаПравилВыгрузки.Строки.Количество() = 0 Тогда
		ЗагрузитьПравилаОбмена("");
	КонецЕсли;

	// Установка параметров выгрузки
	
	мУниверсальнаяВыгрузкаДанных.ИмяФайлаОбмена = ФайлВыгрузки;
		
	мУниверсальнаяВыгрузкаДанных.ПостроительОтчета = Построитель;
	мУниверсальнаяВыгрузкаДанных.ДатаНачала     = ДатаНач;
	мУниверсальнаяВыгрузкаДанных.ДатаОкончания  = ?(НЕ ЗначениеЗаполнено(ДатаКон), ДатаКон, КонецДня(ДатаКон));
	мУниверсальнаяВыгрузкаДанных.РежимОбмена    = "Выгрузка";
	мУниверсальнаяВыгрузкаДанных.ВыводВОкноСообщенийИнформационныхСообщений = ФлагКомментироватьОбработкуОбъектов;
	
//	мУниверсальнаяВыгрузкаДанных.ФлагРежимОтладкиОбработчиков = Истина;;
	
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("НеЗамещатьДокументыПриЗагрузке",   НеЗамещатьДокументыПриЗагрузке);
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("НеЗамещатьСправочникиПриЗагрузке", НеЗамещатьСправочникиПриЗагрузке);
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("ПроводитьДокументыПриЗагрузке",    ПроводитьДокументыПриЗагрузке);
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("ВыгружатьАналитикуПоСкладам",      ВыгружатьАналитикуПоСкладам);
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("Организация",                      Организация);
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("БазоваяВерсия",                    БазоваяВерсия);
	
    СписокСкладов       = Новый СписокЗначений;
	СписокПодразделений = Новый СписокЗначений;

	Для Каждого СтрокаФильтры Из ФильтрыОтчета Цикл

		Если НЕ ЗначениеЗаполнено(СтрокаФильтры.ЗначениеФильтра) Тогда
			Продолжить;
		КонецЕсли;

		Если СтрокаФильтры.ИмяФильтра="Подразделение" Тогда
			СписокПодразделений.Добавить(СтрокаФильтры.ЗначениеФильтра);
		ИначеЕсли СтрокаФильтры.ИмяФильтра="Склад" Тогда
			СписокСкладов.Добавить(СтрокаФильтры.ЗначениеФильтра);
		КонецЕсли;

	КонецЦикла;
		
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("СписокСкладов"		,СписокСкладов);
	мУниверсальнаяВыгрузкаДанных.Параметры.Вставить("СписокПодразделений",СписокПодразделений);

	мУниверсальнаяВыгрузкаДанных.ТаблицаПравилВыгрузки = ТаблицаПравилВыгрузки.Скопировать();
	
	// Выгружаем данные
	
	мУниверсальнаяВыгрузкаДанных.ВыполнитьВыгрузку();
	
КонецПроцедуры // КнопкаВыполнитьНажатие()

// Прочедура-обработчик события "Обработка выбора" поля ввода "Тип фильтра"
// 
Процедура ТипФильтраОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если НЕ (ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока = Неопределено) Тогда

		ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока.ТипФильтра=ВыбранноеЗначение;

	КонецЕсли;
КонецПроцедуры

// Прочедура-обработчик события "При изменении" флажка "Выгружать аналитику по складам"
// 
Процедура ВыгружатьАналитикуПоСкладамПриИзменении(Элемент)
	
	Если ЭлементыФормы.ВыгружатьАналитикуПоСкладам.Значение = Истина Тогда
		Если глЗначениеПеременной("УказаниеСкладовВТабличнойЧастиДокументов") <> Перечисления.ВариантыУказанияСкладовВТабличнойЧастиДокументов.НеИспользовать Тогда
			Предупреждение("Настройки конфигурации позволяют задавать склады в табличной части документов! Выгрузка аналитики по складам невозможна!");
			ЭлементыФормы.ВыгружатьАналитикуПоСкладам.Значение = Ложь;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик нажатия кнопки подбора панели меню таблицы множественного фильтра.
//
Процедура КоманднаяПанельЗначенияФильтровПодбор(Кнопка)

	Если ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущиеДанные = Неопределено Тогда
		Предупреждение("Выберите фильтр!", 60);
		Возврат;
	КонецЕсли;

	Если мФормаПодбораЗначенийФильтра <> Неопределено Тогда
		Если мФормаПодбораЗначенийФильтра.Открыта() Тогда
			Предупреждение("Завершите предыдущий подбор!", 60);
			мФормаПодбораЗначенийФильтра.Активизировать();
			Возврат;
		КонецЕсли;
	КонецЕсли;

	НайдСтрФильтры = мТаблицаФильтры.Найти(ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущиеДанные.ИмяФильтра, "ИмяПоля");
	
	Если НайдСтрФильтры <> Неопределено Тогда
		
		СписокТипов = Новый СписокЗначений;
		Для Каждого ЗначениеТипа Из НайдСтрФильтры.ОписаниеТипов.Типы() Цикл
			Если ЗначениеТипа = Тип("Строка")
				ИЛИ ЗначениеТипа = Тип("Число")
				ИЛИ ЗначениеТипа = Тип("Дата")
				ИЛИ ЗначениеТипа = Тип("Булево") Тогда
			Иначе
				отПустоеЗначениеТипа = Новый(ЗначениеТипа);
				МетаданныеТипа = отПустоеЗначениеТипа.Метаданные();
				СписокТипов.Добавить(МетаданныеТипа, МетаданныеТипа.Представление());
			КонецЕсли;
		КонецЦикла;
		
		Если СписокТипов.Количество() = 0 Тогда 
			Возврат;
		ИначеЕсли СписокТипов.Количество() = 1 Тогда
			ВыбранныйЭлемент = СписокТипов[0];
		Иначе
			ВыбранныйЭлемент = СписокТипов.ВыбратьЭлемент("Выберите тип");
			Если ВыбранныйЭлемент = Неопределено Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		МетаданныеТипа = ВыбранныйЭлемент.Значение;
		
		НайденаФорма = Ложь;
		
		Если Метаданные.Справочники.Найти(МетаданныеТипа.Имя) <> Неопределено Тогда
			мФормаПодбораЗначенийФильтра = Справочники[МетаданныеТипа.Имя].ПолучитьФормуВыбора(, ЭтаФорма);
			НайденаФорма = Истина;

			// Сразу установим специфические свойства формы списка справочника
			мФормаПодбораЗначенийФильтра.ПараметрВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.ГруппыИЭлементы;
			
		ИначеЕсли Метаданные.Документы.Найти(МетаданныеТипа.Имя) <> Неопределено Тогда
			мФормаПодбораЗначенийФильтра = Документы[МетаданныеТипа.Имя].ПолучитьФормуВыбора(, ЭтаФорма);
			НайденаФорма = Истина;
		ИначеЕсли Метаданные.ПланыВидовХарактеристик.Найти(МетаданныеТипа.Имя) <> Неопределено Тогда
			мФормаПодбораЗначенийФильтра = ПланыВидовХарактеристик[МетаданныеТипа.Имя].ПолучитьФормуВыбора(, ЭтаФорма);
			НайденаФорма = Истина;
		КонецЕсли;
		
		Если НайденаФорма Тогда
			мФормаПодбораЗначенийФильтра.ВладелецФормы = ЭтаФорма;
			мФормаПодбораЗначенийФильтра.РежимВыбора = Истина;
			мФормаПодбораЗначенийФильтра.ЗакрыватьПриВыборе = Ложь;
						
			мФормаПодбораЗначенийФильтра.Открыть();

		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // КоманднаяПанельЗначенияФильтровПодбор()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ ТабличноеПолеСписокФильтров

// Прочедура-обработчик события "ПриАктивизацииСтроки" табличного поля
// 
Процедура ТабличноеПолеСписокФильтровПриАктивизацииСтроки(Элемент)

	Если Элемент.ТекущиеДанные<>Неопределено Тогда

		Если ПустаяСтрока(Элемент.ТекущиеДанные.ПредставлениеФильтра) Тогда
			Возврат;
		КонецЕсли;

		ЭлементыФормы.ТипФильтра.Значение=?(НЕ ПустаяСтрока(Элемент.ТекущиеДанные.ТипФильтра),Элемент.ТекущиеДанные.ТипФильтра,мТипФильтраПоУмолчанию);

	КонецЕсли;

	ОбновитьТабличноеПолеЗначенияФильтров();

	ЭлементыФормы.ТабличноеПолеЗначенияФильтров.Колонки.Очистить();
	НоваяКолонка = ЭлементыФормы.ТабличноеПолеЗначенияФильтров.Колонки.Добавить("ЗначениеФильтра");
	НоваяКолонка.Имя = "ЗначениеФильтра";
	НоваяКолонка.Данные = "ЗначениеФильтра";

	Если Элемент.ТекущиеДанные<>Неопределено Тогда
		НоваяКолонка.ТекстШапки= "Множественный фильтр: "+ Элемент.ТекущиеДанные.ПредставлениеФильтра;
	Иначе
		НоваяКолонка.ТекстШапки= "Множественный фильтр";
	КонецЕсли;

	НоваяКолонка.Ширина = 10;
	НоваяКолонка.УстановитьЭлементУправления(Тип("ПолеВвода"));
	НоваяКолонка.ЭлементУправления.АвтоВыборНезаполненного=Истина;
	НоваяКолонка.ЭлементУправления.АвтоОтметкаНезаполненного=Ложь;
	НоваяКолонка.ЭлементУправления.РежимВыбораНезаполненного=РежимВыбораНезаполненного.ПриАктивизации;

	Попытка
		НоваяКолонка.ЭлементУправления.ВыборГруппИЭлементов=ИспользованиеГруппИЭлементов.ГруппыИЭлементы;
	Исключение

	КонецПопытки;

КонецПроцедуры // ТабличноеПолеСписокФильтровПриАктивизацииСтроки()

// Прочедура-обработчик события "ПередУдалением" табличного поля
// 
Процедура ТабличноеПолеСписокФильтровПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	
КонецПроцедуры
 
// Процедура - обработчик события "ПередНачаломДобавления"
//
Процедура ТабличноеПолеСписокФильтровПередНачаломДобавления(Элемент, Отказ, Копирование)

	СтруктураНеиспользуемыеЗначения = Новый Структура;

	Для Каждого Строка Из ТаблицаСписокФильтров Цикл

		СтруктураНеиспользуемыеЗначения.Вставить(Строка.ИмяФильтра);

	КонецЦикла;

	Если СтруктураНеиспользуемыеЗначения.Количество() = 2 Тогда //мТаблицаФильтры.Количество() Тогда
		Предупреждение("Все возможные отборы уже введены!");
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

// Прочедура-обработчик события "Начало выбора" поля ввода "Представление фильтра"
// табличного поля
// 
Процедура ТабличноеПолеСписокФильтровПредставлениеФильтраНачалоВыбора(Элемент, СтандартнаяОбработка)

	Форма = ПолучитьФорму("ФормаВыбора", ЭтаФорма, "дляФормаФильтра");

	Если Форма.Открыта() Тогда
		Форма.Активизировать();
		Ответ = Вопрос("Предыдущая операция выбора фильтра не завершена.
			|Завершить?",РежимДиалогаВопрос.ДаНет,30,КодВозвратаДиалога.Да);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Форма.Закрыть();
		КонецЕсли;
	КонецЕсли;	

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("МножественныйВыбор", Ложь);
	СтруктураПараметров.Вставить("ИсходнаяТаблица", "СписокФильтров");
	СтруктураПараметров.Вставить("ТаблицаФильтры",мТаблицаФильтры);

	СтруктураСуществующиеЗначения = Новый Структура;
	СтруктураНеиспользуемыеЗначения = Новый Структура;

	Для Каждого Строка Из ТаблицаСписокФильтров Цикл

		// Кроме этой строки
		Если ТаблицаСписокФильтров.Индекс(Строка) <> ТаблицаСписокФильтров.Индекс(ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока) Тогда
			СтруктураНеиспользуемыеЗначения.Вставить(Строка.ИмяФильтра);
		КонецЕсли;

	КонецЦикла;

	Если СтруктураНеиспользуемыеЗначения.Количество() = мТаблицаФильтры.Количество() Тогда
		Предупреждение("Все возможные отборы уже введены!");
	КонецЕсли;

	Если Не ПустаяСтрока(ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущиеДанные.ИмяФильтра) Тогда
		СтруктураСуществующиеЗначения.Вставить(ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущиеДанные.ИмяФильтра);
	КонецЕсли;

	СтруктураПараметров.Вставить("СтруктураНеиспользуемыеЗначения", СтруктураНеиспользуемыеЗначения);
	СтруктураПараметров.Вставить("СтруктураСуществующиеЗначения", СтруктураСуществующиеЗначения);

	// Передача параметров в форму
	Форма.НачальноеЗначениеВыбора = СтруктураПараметров;
	Форма.РежимВыбора = Истина;
	Форма.Открыть();
	мФормаВыбораФильтров = Форма;

КонецПроцедуры

// Прочедура-обработчик события "Начало выбора" поля ввода "Представление фильтра"
// табличного поля
// 
Процедура ТабличноеПолеСписокФильтровЗначениеФильтраНачалоВыбора(Элемент, СтандартнаяОбработка)

	Перем Значение;

	Если ПустаяСтрока(ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока.ПредставлениеФильтра) Тогда
		Предупреждение("Выберите фильтр!",60);
		СтандартнаяОбработка=Ложь;
		Возврат;
	КонецЕсли;

	Фильтр = ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока;
	ТипыФильтра = Фильтр.СписокФильтров.Колонки.ЗначениеФильтра.ТипЗначения;

	МассивТипов = ТипыФильтра.Типы();

	Если МассивТипов.Количество() = 1 Тогда

		Если МассивТипов[0]=Тип("Число") Тогда
			Элемент.Значение=0;
		ИначеЕсли МассивТипов[0]=Тип("Строка") Тогда
			Элемент.Значение="";
		ИначеЕсли МассивТипов[0]=Тип("Дата") Тогда
			Элемент.Значение=ТекущаяДата();
		Иначе
		Элемент.Значение = Новый(МассивТипов[0]);
        КонецЕсли;
		
		Элемент.ВыбиратьТип = Ложь;

	Иначе

		Элемент.ОграничениеТипа = Фильтр.СписокФильтров.Колонки.ЗначениеФильтра.ТипЗначения;
		Элемент.ВыбиратьТип = Истина;

	КонецЕсли;

КонецПроцедуры

// Прочедура-обработчик события "Обработка выбора" поля ввода "Значение фильтра"
// табличного поля
// 
Процедура ТабличноеПолеСписокФильтровЗначениеФильтраОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ТаблицаЗначенияФильтров.Очистить();	

КонецПроцедуры

// Прочедура-обработчик события "Перед началом изменения" поля ввода "Значение фильтра"
// табличного поля
// 
Процедура ТабличноеПолеЗначенияФильтровПередНачаломИзменения(Элемент, Отказ)
	ЭлементСписокФильтров = ЭлементыФормы.ТабличноеПолеСписокФильтров;

	Если ЭлементСписокФильтров.ТекущиеДанные = Неопределено Тогда 
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры // ТабличноеПолеЗначенияФильтровПередНачаломИзменения()

// Прочедура-обработчик события "Перед удалением" поля ввода "Значение фильтра"
// табличного поля
// 
Процедура ТабличноеПолеЗначенияФильтровПередУдалением(Элемент, Отказ)
	Перем Фильтр, КопияСписокФильтров;
	УдаленоЗначение = Элемент.ТекущаяСтрока.ЗначениеФильтра;
	Фильтр = ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока;
	КопияСписокФильтров = Фильтр.СписокФильтров.Скопировать();
	НайденнаяСтрока = КопияСписокФильтров.Найти(УдаленоЗначение, "ЗначениеФильтра");
	КопияСписокФильтров.Удалить(НайденнаяСтрока);

	ОбновитьСтрокуСпискаФильтров(КопияСписокФильтров, Фильтр);
КонецПроцедуры // ТабличноеПолеЗначенияФильтровПередУдалением()

// Прочедура-обработчик события "Перед началом добавления" поля ввода "Значение фильтра"
// табличного поля
// 
Процедура ТабличноеПолеЗначенияФильтровПередНачаломДобавления(Элемент, Отказ, Копирование)
	Если ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока = Неопределено Тогда
		Предупреждение("Выберите фильтр!", 60);
		Отказ = Истина;
	Иначе
		Если ЭлементыФормы.ТабличноеПолеЗначенияФильтров.Колонки.ЗначениеФильтра.ТекстШапки="Множественный фильтр" тогда
			ЭлементыФормы.ТабличноеПолеЗначенияФильтров.Колонки.ЗначениеФильтра.ТекстШапки="Множественный фильтр: "
			+ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока.ПредставлениеФильтра;
		КонецЕсли;
	КонецЕсли; 

КонецПроцедуры // ТабличноеПолеЗначенияФильтровПередНачаломДобавления()

// Прочедура-обработчик события "Перед окончанием редактирования" поля ввода "Значение фильтра"
// табличного поля
// 
Процедура ТабличноеПолеЗначенияФильтровПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)

	Перем Фильтр, СписокФильтров;

	Если НЕ ОтменаРедактирования Тогда

		Фильтр = ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущаяСтрока;
		СписокФильтров = Фильтр.СписокФильтров;
		ОбновитьСтрокуСпискаФильтров(СписокФильтров, Фильтр);

	КонецЕсли; 

КонецПроцедуры // ТабличноеПолеЗначенияФильтровПередОкончаниемРедактирования()

// Прочедура-обработчик события "Окончание ввода текста" поля ввода "Значение фильтра"
// табличного поля
// 
Процедура ТабличноеПолеСписокФильтровЗначениеФильтраОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)

	Если ЭлементыФормы.ТабличноеПолеСписокФильтров.ТекущиеДанные.СписокФильтров.Количество() > 0 Тогда
		Значение = "<Задано множественным фильтром>";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры // ТабличноеПолеСписокФильтровЗначениеФильтраОкончаниеВводаТекста()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ ТаблицаПравилВыгрузки

// Процедура - обработчик события "ПриИзмененииФлажка" табличного поля
//

Процедура ТаблицаПравилВыгрузкиПриИзмененииФлажка(Элемент, Колонка)

	Если Колонка.Имя = "ПВД" Тогда
		ТекСтрока = ЭлементыФормы.ТаблицаПравилВыгрузки.ТекущаяСтрока;
		Если ТекСтрока.Включить = 2 Тогда
			ТекСтрока.Включить = 0;
		КонецЕсли;
		УстановитьПометкиПодчиненных(ТекСтрока);
		УстановитьПометкиРодителей(ТекСтрока);
	КонецЕсли;

КонецПроцедуры // ТаблицаПравилВыгрузкиПриИзмененииФлажка()

// Выполняет загрузку правил обмена из макета
//
Процедура ЗагрузитьПравилаОбмена(Кнопка)

	// Производим загрузку правил обмена

	Состояние("Выполняется загрузка правил обмена...");
	

	УникальныйИдентификатор        = Новый УникальныйИдентификатор();
	ИмяВременногоФайлаПравилОбмена = КаталогВременныхФайлов() + УникальныйИдентификатор + ".xml";

	МакетПравилОбмена = ПолучитьМакет("ПравилаОбменаТекст");
	МакетПравилОбмена.Записать(ИмяВременногоФайлаПравилОбмена);

	мУниверсальнаяВыгрузкаДанных.ИмяФайлаПравилОбмена = ИмяВременногоФайлаПравилОбмена;
	мУниверсальнаяВыгрузкаДанных.ЗагрузитьПравилаОбмена();

	Попытка
		УдалитьФайлы(ИмяВременногоФайлаПравилОбмена);  // Удаляем временный файл правил
	Исключение КонецПопытки;

	ТаблицаПравилВыгрузки = мУниверсальнаяВыгрузкаДанных.ТаблицаПравилВыгрузки.Скопировать();

	// Для отладки

	//мУниверсальнаяВыгрузкаДанных = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	//мУниверсальнаяВыгрузкаДанных.ИмяФайлаПравилОбмена = "K:\ConvData\RTr10_1.xml";
	//мУниверсальнаяВыгрузкаДанных.ЗагрузитьПравилаОбмена();
	//ТаблицаПравилВыгрузки = мУниверсальнаяВыгрузкаДанных.ТаблицаПравилВыгрузки.Скопировать();
	
КонецПроцедуры

Процедура ТаблицаПравилВыгрузкиПриАктивизацииСтроки(Элемент)
	НастроитьПостроитель()
КонецПроцедуры

Процедура ПостроительОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	ТекущееПВД = ЭлементыФормы.ТаблицаПравилВыгрузки.ТекущаяСтрока;
	Если Построитель.Отбор.Количество() Тогда
		ТекущееПВД.НастройкиПостроителя = Построитель.ПолучитьНастройки();
		ТекущееПВД.ИспользоватьОтбор    = ИСТИНА;
	Иначе
		ТекущееПВД.НастройкиПостроителя = Неопределено;
		ТекущееПВД.ИспользоватьОтбор    = ЛОЖЬ;
	КонецЕсли;

КонецПроцедуры

Процедура ПостроительОтборПослеУдаления(Элемент)

	ТекущееПВД = ЭлементыФормы.ТаблицаПравилВыгрузки.ТекущаяСтрока;
	Если Построитель.Отбор.Количество() Тогда
		ТекущееПВД.НастройкиПостроителя = Построитель.ПолучитьНастройки();
		ТекущееПВД.ИспользоватьОтбор    = ИСТИНА;
	Иначе
		ТекущееПВД.НастройкиПостроителя = Неопределено;
		ТекущееПВД.ИспользоватьОтбор    = ЛОЖЬ;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

МассивСтрока = Новый Массив; 
МассивСтрока.Добавить(Тип("Строка"));
КвалификаторСтроки = Новый КвалификаторыСтроки("100", ДопустимаяДлина.Переменная);
мОписаниеТиповСтрока = Новый ОписаниеТипов(МассивСтрока, , КвалификаторСтроки);

МассивЧисло = Новый Массив;
МассивЧисло.Добавить(Тип("Число"));
КвалификаторЧисла = Новый КвалификаторыЧисла(1,0);
мОписаниеТиповЧисло = Новый ОписаниеТипов(МассивЧисло, КвалификаторЧисла);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
мОписаниеТиповБулево = Новый ОписаниеТипов(МассивБулево);

МассивТаблицаЗначений = Новый Массив;
МассивТаблицаЗначений.Добавить(Тип("ТаблицаЗначений"));
мОписаниеТиповТаблицаЗначений = Новый ОписаниеТипов(МассивТаблицаЗначений);

мТаблицаФильтры     = Новый ТаблицаЗначений;
мТаблицаФильтры.Колонки.Добавить("ИмяПоля", мОписаниеТиповСтрока);
мТаблицаФильтры.Колонки.Добавить("ПредставлениеПоля", мОписаниеТиповСтрока);
мТаблицаФильтры.Колонки.Добавить("ОписаниеПоля", мОписаниеТиповСтрока);
мТаблицаФильтры.Колонки.Добавить("Пометка", мОписаниеТиповБулево);
мТаблицаФильтры.Колонки.Добавить("ОписаниеТипов");

мСтруктураТиповФильтров = Новый Структура;
мСтруктураТиповФильтров.Вставить("ОдноИз", "Одно из:");
мСтруктураТиповФильтров.Вставить("ВсеКроме", "Все, кроме:");

мТипФильтраПоУмолчанию = "ОдноИз";

ТаблицаЗначенияФильтров.Колонки.Добавить("ИмяФильтра",мОписаниеТиповСтрока,"Множественный фильтр");

ТаблицаСписокФильтров.Колонки.Добавить("ИмяФильтра", мОписаниеТиповСтрока);
ТаблицаСписокФильтров.Колонки.Добавить("ОписаниеФильтра");
ТаблицаСписокФильтров.Колонки.Добавить("СписокФильтров", мОписаниеТиповТаблицаЗначений);
ТаблицаСписокФильтров.Колонки.Добавить("ТипФильтра", мОписаниеТиповСтрока);

мТипФильтраПоУмолчанию = "ОдноИз";
