﻿//Признак использования настроек
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
Перем мТипыОбрабатываемыхОбъектов Экспорт;

Перем мНастройка;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет обработку объектов.
//
// Параметры:
//  Объект                 - обрабатываемый объект.
//  ПорядковыйНомерОбъекта - порядковый номер обрабатываемого объекта.
//
Процедура вОбработатьОбъект(Объект, ПорядковыйНомерОбъекта)

	Для каждого Реквизит из Реквизиты Цикл
		Если Реквизит.Пометка Тогда
			Объект[Реквизит.Идентификатор] = Реквизит.Значение;
		КонецЕсли;
	КонецЦикла;
	Объект.Записать();

КонецПроцедуры // ОбработатьОбъект()

// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
Функция вВыполнитьОбработку() Экспорт

	Для Индекс = 0 По НайденныеОбъекты.Количество() - 1 Цикл
		ОбработкаПрерыванияПользователя();
		Строка = НайденныеОбъекты.Получить(Индекс);
		Если НЕ Строка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		Объект = Строка.Объект.ПолучитьОбъект();
		вОбработатьОбъект(Объект, Индекс);
	КонецЦикла;

	Возврат Индекс;

КонецФункции // вВыполнитьОбработку()

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вСохранитьНастройку() Экспорт

	Если ПустаяСтрока(ЭлементыФормы.ТекущаяНастройка) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;

    НоваяНастройка = Новый Структура();

	РеквизитыДляСохранения = Реквизиты.Скопировать();
	
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;

	Если      ТекущаяНастройка.Родитель = Неопределено Тогда
		
		НоваяСтрока = ТекущаяНастройка.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
		
	ИначеЕсли НЕ ТекущаяНастройка.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение Тогда
		
		НоваяСтрока           = ТекущаяНастройка.Родитель.Строки.Добавить();
		НоваяСтрока.Обработка = ЭлементыФормы.ТекущаяНастройка.Значение;
		ТекущаяНастройка      = НоваяСтрока;
		ЭтаФорма.ВладелецФормы.ЭлементыФормы.ДоступныеОбработки.ТекущаяСтрока = НоваяСтрока;
		
	КонецЕсли;
	
	ТекущаяНастройка.Настройка = НоваяНастройка;
	
	ЭтаФорма.Модифицированность = Ложь;

КонецПроцедуры // вСохранитьНастройку()

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьНастройку() Экспорт

	Если ТекущаяНастройка.Родитель = Неопределено Тогда
		вУстановитьИмяНастройки("Новая настройка");
	Иначе
		Если НЕ ТекущаяНастройка.Настройка = Неопределено Тогда
			мНастройка = ТекущаяНастройка.Настройка;
		КонецЕсли;
	КонецЕсли;

	Для каждого РеквизитНастройки из мНастройка Цикл
		Значение = мНастройка[РеквизитНастройки.Ключ];
		Если НЕ Значение = Неопределено Тогда
			Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
		КонецЕсли;
	КонецЦикла;

	Если РеквизитыДляСохранения.Количество() Тогда
		Реквизиты = РеквизитыДляСохранения.Скопировать();
	КонецЕсли;
	
КонецПроцедуры //вЗагрузитьНастройку()

// Устанавливает значение реквизита "ТекущаяНастройка" по имени настройки или произвольно.
//
// Параметры:
//  ИмяНастройки   - произвольное имя настройки, которое необходимо установить.
//
Процедура вУстановитьИмяНастройки(ИмяНастройки = "") Экспорт

	Если ПустаяСтрока(ИмяНастройки) Тогда
		Если ТекущаяНастройка = Неопределено Тогда
			ЭлементыФормы.ТекущаяНастройка.Значение = "";
		Иначе
			ЭлементыФормы.ТекущаяНастройка.Значение = ТекущаяНастройка.Обработка;
		КонецЕсли;
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Значение = ИмяНастройки;
	КонецЕсли;

КонецПроцедуры // вУстановитьИмяНастройки()

// Загружает справочник.
//
// Параметры: 
//  Объект         - объект справочник.
//
Процедура вЗагрузитьСправочник(Объект)

	// Код
	Если Объект.ДлинаКода Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Код";
		НоваяСтрока.Идентификатор = "Код";
		Если Объект.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Число Тогда
			НоваяСтрока.Тип = вОписаниеТипа("Число");
		ИначеЕсли Объект.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Строка Тогда
			НоваяСтрока.Тип = вОписаниеТипа("Строка");
		КонецЕсли;
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Наименование
	Если Объект.ДлинаНаименования Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Наименование";
		НоваяСтрока.Идентификатор = "Наименование";
		НоваяСтрока.Тип           = вОписаниеТипа("Строка");
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Владелец
	Если Объект.Владельцы.Количество() Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Владелец";
		НоваяСтрока.Идентификатор = "Владелец";
		
		МассивТипов = Новый Массив;
		Для каждого Владелец из Объект.Владельцы Цикл
			МассивТипов.Добавить(мМенеджеры[Владелец].ТипСсылки);
		КонецЦикла;
		НоваяСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Родитель
	Если Объект.КоличествоУровней > 1 Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Родитель";
		НоваяСтрока.Идентификатор = "Родитель";

		МассивТипов = Новый Массив;
		МассивТипов.Добавить(мМенеджеры[Объект].ТипСсылки);

		НоваяСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	вЗагрузитьРеквизиты(Объект);

КонецПроцедуры // ЗагрузитьСправочник()

// Загружает документ.
//
// Параметры: 
//  Объект         - объект документ.
//
Процедура вЗагрузитьДокумент(Объект)

	// Номер
	Если Объект.ДлинаНомера Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Номер";
		НоваяСтрока.Идентификатор = "Номер";
		Если Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераДокумента.Число Тогда
			НоваяСтрока.Тип = вОписаниеТипа("Число");
		ИначеЕсли Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераДокумента.Строка Тогда
			НоваяСтрока.Тип = вОписаниеТипа("Строка");
		КонецЕсли;
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Дата
	НоваяСтрока = Реквизиты.Добавить();
	НоваяСтрока.Реквизит      = "Дата";
	НоваяСтрока.Идентификатор = "Дата";
	НоваяСтрока.Тип           = вОписаниеТипа("Дата");
	НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();

	вЗагрузитьРеквизиты(Объект);

КонецПроцедуры // ЗагрузитьДокумент()

// Загружает реквизиты справочника или документа.
//
// Параметры: 
//  Объект         - объект справочник или документ.
//
Процедура вЗагрузитьРеквизиты(Объект)

	Для каждого Реквизит из Объект.Реквизиты Цикл
		Если Реквизит.Тип.Типы().Количество() = 1 Тогда
			Если Реквизит.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = ?(ПустаяСтрока(Реквизит.Синоним), Реквизит.Имя, Реквизит.Синоним);
		НоваяСтрока.Идентификатор = Реквизит.Имя;
		НоваяСтрока.Тип           = Реквизит.Тип;
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЦикла;

КонецПроцедуры // ЗагрузитьРеквизиты()

// Позволяет создать описание типов на основании строкового представления типа.
//
// Параметры: 
//  ТипСтрокой     - Строковое представление типа.
//
// Возвращаемое значение:
//  Описание типов.
//
Функция вОписаниеТипа(ТипСтрокой) Экспорт

	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип(ТипСтрокой));
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);

	Возврат ОписаниеТипов;

КонецФункции // вОписаниеТипа()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	Если мИспользоватьНастройки Тогда
		вУстановитьИмяНастройки();
		вЗагрузитьНастройку();
	Иначе
		ЭлементыФормы.ТекущаяНастройка.Доступность = Ложь;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.СохранитьНастройку.Доступность = Ложь;
	КонецЕсли;

	ОбъектПоиска = ЭтаФорма.ВладелецФормы.ЭлементыФормы.ОбъектПоиска.Значение;

	Если ОбъектПоиска = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТекущаяНастройка.Настройка = Неопределено Тогда
		Если ОбъектПоиска.Тип = "Справочник" Тогда
			вЗагрузитьСправочник(ОбъектПоиска.Объект);
		ИначеЕсли ОбъектПоиска.Тип = "Документ" Тогда
			вЗагрузитьДокумент(ОбъектПоиска.Объект);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры // ПередОткрытием()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

// Обработчик действия "НачалоВыбораИзСписка" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)

	Элемент.СписокВыбора.Очистить();

	Если ТекущаяНастройка.Родитель = Неопределено Тогда
		КоллекцияСтрок = ТекущаяНастройка.Строки;
	Иначе
		КоллекцияСтрок = ТекущаяНастройка.Родитель.Строки;
	КонецЕсли;

	Для каждого Строка из КоллекцияСтрок Цикл
		Элемент.СписокВыбора.Добавить(Строка, Строка.Обработка);
	КонецЦикла;

КонецПроцедуры // ТекущаяНастройкаНачалоВыбораИзСписка()

// Обработчик действия "ОбработкаВыбора" реквизита "ТекущаяНастройка".
//
Процедура ТекущаяНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Если НЕ ТекущаяНастройка = ВыбранноеЗначение Тогда

		Если ЭтаФорма.Модифицированность Тогда
			Если Вопрос("Сохранить текущую настройку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да Тогда
				вСохранитьНастройку();
			КонецЕсли;
		КонецЕсли;

		ТекущаяНастройка = ВыбранноеЗначение;
		вУстановитьИмяНастройки();

		вЗагрузитьНастройку();

	КонецЕсли;

КонецПроцедуры // ТекущаяНастройкаОбработкаВыбора()

// Обработчик действия "Выполнить" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыВыполнить(Кнопка)

	ОбработаноОбъектов = вВыполнитьОбработку();

	Предупреждение("Обработка <" + СокрЛП(ЭтаФорма.Заголовок) + "> завершена!
                   |Обработано объектов: " + ОбработаноОбъектов + ".");

КонецПроцедуры // ОсновныеДействияФормыВыполнить()

// Обработчик действия "СохранитьНастройку" командной панели "ОсновныеДействияФормы".
//
Процедура ОсновныеДействияФормыСохранитьНастройку(Кнопка)

	вСохранитьНастройку();

КонецПроцедуры // ОсновныеДействияФормыСохранитьНастройку()

// Обработчик действия "НачалоВыбора" поля ввода "Значение" табличного поля "Реквизиты".
//
Процедура РеквизитыЗначениеНачалоВыбора(Элемент, СтандартнаяОбработка)

	ТипыФильтра = ЭлементыФормы.Реквизиты.ТекущаяСтрока.Тип;

	МассивТипов = ТипыФильтра.Типы();

	Если МассивТипов.Количество() = 1 Тогда
		Элемент.ВыбиратьТип = Ложь;
	Иначе
		Элемент.ОграничениеТипа = ТипыФильтра;
		Элемент.ВыбиратьТип = Истина;
	КонецЕсли;

КонецПроцедуры // РеквизитыЗначениеНачалоВыбора()

// Обработчик действия "ОбработкаВыбора" поля ввода "Значение" табличного поля "Реквизиты".
//
Процедура РеквизитыЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ЭлементыФормы.Реквизиты.ТекущиеДанные.Пометка = Истина;

КонецПроцедуры // РеквизитыЗначениеОбработкаВыбора()

// Обработчик действия "ОкончаниеВводаТекста" поля ввода "Значение" табличного поля "Реквизиты".
//
Процедура РеквизитыЗначениеОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)

	ЭлементыФормы.Реквизиты.ТекущиеДанные.Пометка = Истина;

КонецПроцедуры

// Обработчик действия "ПриНачалеРедактирования" табличного поля "Реквизиты".
//
Процедура РеквизитыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Элемент.Колонки.Значение.ЭлементУправления.ОграничениеТипа = Элемент.ТекущиеДанные.Тип;
КонецПроцедуры

// Обработчик действия "ПриВыводеСтроки" табличного поля "Реквизиты".
//
Процедура РеквизитыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	ОформлениеСтроки.Ячейки.Значение.Текст = Строка(ДанныеСтроки.Тип.ПривестиЗначение(ОформлениеСтроки.Ячейки.Значение.Значение));
КонецПроцедуры

// Обработчик действия "СнятьФлажки" командной панели "КоманднаяПанельРеквизиты".
//
Процедура КоманднаяПанельРеквизитыСнятьФлажки(Кнопка)

	Для каждого Строка из Реквизиты Цикл
		Строка.Пометка = Ложь;
	КонецЦикла;

КонецПроцедуры // КоманднаяПанельРеквизитыСнятьФлажки()



////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("РеквизитыДляСохранения");

мТипыОбрабатываемыхОбъектов = Неопределено;