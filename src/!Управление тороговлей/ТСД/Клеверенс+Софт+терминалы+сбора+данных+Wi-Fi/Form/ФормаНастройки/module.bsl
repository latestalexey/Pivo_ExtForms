﻿///////////////////////////////////////////////////////////////////////////////
//// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мНетОшибки;
Перем мМодель Экспорт;
Перем мПараметры Экспорт;

///////////////////////////////////////////////////////////////////////////////
//// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "Перед открытием" формы.
//
// Параметры:
//  Отказ                - <Булево>
//                       - Признак отказа от открытия формы. Если в теле
//                         процедуры-обработчика установить данному параметру
//                         значение Истина, открытие формы выполнено не будет.
//                         Значение по умолчанию: Ложь 
//
//  СтандартнаяОбработка - <Булево>
//                       - В данный параметр передается признак выполнения
//                         стандартной (системной) обработки события. Если в
//                         теле процедуры-обработчика установить данному
//                         параметру значение Ложь, стандартная обработка
//                         события производиться не будет. Отказ от стандартной
//                         обработки не отменяет открытие формы.
//                         Значение по умолчанию: Истина 
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	ЭлементыФормы.Драйвер.ЦветТекстаПоля = ЦветаСтиля.ЦветОтрицательногоЧисла;
	Драйвер = "Не установлен";
	ЭлементыФормы.Версия.ЦветТекстаПоля = ЦветаСтиля.ЦветОтрицательногоЧисла;
	Версия  = "Не определена";

	ЭлементыФормы.НастройкаТСД.Значение = "Настройка параметров терминала сбора данных """ + мМодель + """";

	времВыбиратьИсточникЗагрузки = Неопределено;
	
	времТипСвязи                = Неопределено;
	времСтрокаПодключенияКСерверу = Неопределено;
	времПрокси = Неопределено;
	времПортПрокси = Неопределено;
	времПереписыватьНоменклатуру = Неопределено;

	мПараметры.Свойство("ВыбиратьИсточникЗагрузки", времВыбиратьИсточникЗагрузки);
	мПараметры.Свойство("ТипСвязи", времТипСвязи);
	
	мПараметры.Свойство("ПереписыватьНоменклатуру", времПереписыватьНоменклатуру);
	
	ЗагружатьВсеДокументы = ?(времВыбиратьИсточникЗагрузки = Неопределено, Ложь, Не времВыбиратьИсточникЗагрузки);
	
	ТипСвязи                = ?(времТипСвязи                = Неопределено, "Сервер", времТипСвязи);
	Если ТипСвязи = "Сервер" Тогда
		// Жульков 01.10.2013 +
		ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Страница1;
		// Жульков 01.10.2013 -
		
		мПараметры.Свойство("СтрокаПодключенияКСерверу", времСтрокаПодключенияКСерверу);
		мПараметры.Свойство("Прокси", времПрокси);
    	мПараметры.Свойство("ПортПрокси", времПортПрокси);
		
		ЭлементыФормы.СтрокаПодключенияКСерверу.Доступность = Истина;
		ЭлементыФормы.Прокси.Доступность = Истина;
        ЭлементыФормы.ПортПрокси.Доступность = Истина;
		ЭлементыФормы.ПроверкаСоединения.Доступность = Истина;
		
		СтрокаПодключенияКСерверу = ?(времСтрокаПодключенияКСерверу = Неопределено, ПолучитьIPПоУмолчанию(), времСтрокаПодключенияКСерверу); 
	    Прокси = ?(времПрокси = Неопределено, "", времПрокси);
        ПортПрокси = ?(времПортПрокси = Неопределено, 0, времПортПрокси);
	Иначе 	  
		// Жульков 01.10.2013 +
		ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Страница2;
		// Жульков 01.10.2013 -
		
		ЭлементыФормы.СтрокаПодключенияКСерверу.Доступность = Ложь;
		ЭлементыФормы.Прокси.Доступность = Ложь;
        ЭлементыФормы.ПортПрокси.Доступность = Ложь;
		ЭлементыФормы.ПроверкаСоединения.Доступность = Ложь;
		// Жульков 01.10.2013 +
		Если ТипСвязи = "RDPСвязь" Тогда
			ЭлементыФормы.ПапкаОбмена.Видимость = Истина;
			ЭлементыФормы.НадписьПапкаОбмена.Видимость = Истина;
		Иначе
			ЭлементыФормы.ПапкаОбмена.Видимость = Ложь;	
			ЭлементыФормы.НадписьПапкаОбмена.Видимость = Ложь;
		КонецЕсли;
		// Жульков 01.10.2013 -
	КонецЕсли;
	
	ПереписыватьНоменклатуру = ?(времПереписыватьНоменклатуру = Неопределено, Истина, времПереписыватьНоменклатуру);	
	
	// Жульков 01.10.2013 +
	времПапкаОбмена = Неопределено;
	мПараметры.Свойство("ПапкаОбмена", времПапкаОбмена);
	ПапкаОбмена = ?(времПапкаОбмена = Неопределено, "", времПапкаОбмена);
	// Жульков 01.10.2013 -
	
	времИспШаблоныВесового = Неопределено;
	мПараметры.Свойство("ИспШаблоныВесовогоТовара", времИспШаблоныВесового);
	ИспШаблоныВесового = ?(времИспШаблоныВесового = Неопределено, Истина, времИспШаблоныВесового);
	
	времПрефиксВесовогоТовара = Неопределено;
	мПараметры.Свойство("ПрефиксВесовогоТовара", времПрефиксВесовогоТовара);
	ПрефиксВесовогоТовара = ?(времПрефиксВесовогоТовара = Неопределено, ПолучитьПрефиксВесовогоТовара(), времПрефиксВесовогоТовара);
	
	времДлинаКодаВесовогоТовара = Неопределено;
	мПараметры.Свойство("ДлинаКодаВесовогоТовара", времДлинаКодаВесовогоТовара);
	ДлинаКодаВесовогоТовара = ?(времДлинаКодаВесовогоТовара = Неопределено, ПолучитьДлинуКодаВесовогоТовара(), времДлинаКодаВесовогоТовара);
	
	//времКоэффициентВеса = Неопределено;
	//мПараметры.Свойство("КоэффициентВеса", времКоэффициентВеса);
	//КоэффициентВеса = ?(времКоэффициентВеса = Неопределено, 1000, времКоэффициентВеса);
	
	времЧислоЗнаковПослеЗапВВесе = Неопределено;
	мПараметры.Свойство("ЧислоЗнаковПослеЗапВВесе", времЧислоЗнаковПослеЗапВВесе);
	ЧислоЗнаковПослеЗапВВесе = ?(времЧислоЗнаковПослеЗапВВесе = Неопределено, 2, времЧислоЗнаковПослеЗапВВесе);
	
	ИспШаблоныВесовогоПриИзменении(Неопределено);
	
	ПроверкаДрайвераИВерсии();
	
	//+ZHKN. 07.10.2015. №505 Убрать кнопку "Ещё"
	Если Версия_3_3нака_СтрокаВЧисло(мВерсияИзДрайвера) >= 30000 Тогда
		ЭлементыФормы.ДопПараметры.Видимость = Ложь;
	КонецЕсли;
	//-ZHKN. 07.10.2015. №505

КонецПроцедуры // ПередОткрытием()

// Процедура представляет обработчик события "Нажатие" кнопки
// "ОК" командной панели "ОсновныеДействияФормы".
//
// Параметры:
//  Кнопка - <КнопкаКоманднойПанели>
//         - Кнопка, с которой связано данное событие (кнопка "ОК").
//
Процедура ОсновныеДействияФормыОК(Кнопка)

	Ошибки = "";

	Если ДлинаКодаВесовогоТовара <= 0 Тогда
		Ошибки = "Длина кода весового товара должна быть > 0.";
	КонецЕсли;
	
	Если ПустаяСтрока(Ошибки) Тогда
		мПараметры = Новый Структура;
		мПараметры.Вставить("ВыбиратьИсточникЗагрузки", Не ЗагружатьВсеДокументы);
		// Жульков 01.10.2013 +
		мПараметры.Вставить("ОбменЧерезПапку", ?(ТипСвязи = "RDPСвязь", Истина, Ложь) );
		мПараметры.Вставить("ПапкаОбмена", ПапкаОбмена);
        // Жульков 01.10.2013 -
		мПараметры.Вставить("ТипСвязи",                ТипСвязи);
		мПараметры.Вставить("СтрокаПодключенияКСерверу", СтрокаПодключенияКСерверу);
		мПараметры.Вставить("Прокси", Прокси);
		мПараметры.Вставить("ПортПрокси", ПортПрокси);
		мПараметры.Вставить("ПереписыватьНоменклатуру", ПереписыватьНоменклатуру);
		
		мПараметры.Вставить("ИспШаблоныВесовогоТовара", ИспШаблоныВесового);
		мПараметры.Вставить("ПрефиксВесовогоТовара", ПрефиксВесовогоТовара);
		мПараметры.Вставить("ДлинаКодаВесовогоТовара", ДлинаКодаВесовогоТовара);
		//мПараметры.Вставить("КоэффициентВеса", КоэффициентВеса);
		мПараметры.Вставить("ЧислоЗнаковПослеЗапВВесе", ЧислоЗнаковПослеЗапВВесе);
		
		Сообщить("Для применения настроек требуется перезапуск 1С!", СтатусСообщения.Важное);
		
		Закрыть(КодВозвратаДиалога.ОК);
	Иначе
		Предупреждение(Ошибки);
	КонецЕсли;

КонецПроцедуры // ОсновныеДействияФормыОК()

// Процедура представляет обработчик события "Нажатие" кнопки
// "Отмена" командной панели "ОсновныеДействияФормы".
//
// Параметры:
//  Кнопка - <КнопкаКоманднойПанели>
//         - Кнопка, с которой связано данное событие (кнопка "Отмена").
//
Процедура ОсновныеДействияФормыОтмена(Кнопка)

	Закрыть(КодВозвратаДиалога.Отмена);

КонецПроцедуры // ОсновныеДействияФормыОтмена() 

Процедура ПроверкаДрайвераИВерсии()

	Объект = Неопределено;
	ВерсияДрайвера = Неопределено;
	
	времПараметры = Новый Структура;
	//времПараметры.Вставить("Порт",                     Порт);
	//времПараметры.Вставить("Скорость",                 Скорость);
	//времПараметры.Вставить("ТипСвязи",                 ТипСвязи);
	//времПараметры.Вставить("НомерБазы",                НомерБазы);
	//времПараметры.Вставить("НомерДокумента",           НомерДокумента);
	времПараметры.Вставить("ВыбиратьИсточникЗагрузки", Не ЗагружатьВсеДокументы);

	времПараметры.Вставить("ТипСвязи",                ТипСвязи);
	времПараметры.Вставить("СтрокаПодключенияКСерверу", ПолучитьСтрокуПодключения(СтрокаПодключенияКСерверу));
	времПараметры.Вставить("Прокси", Прокси);
	времПараметры.Вставить("ПортПрокси", ПортПрокси);


	Если ОбработкаОбъект.СоздатьОбъектДрайвера(Объект, мМодель, времПараметры) = мНетОшибки Тогда
		ЭлементыФормы.Драйвер.ЦветТекстаПоля = ЦветаСтиля.ЦветТекстаФормы;
		Драйвер = "Установлен";

		Если мВерсияИзДрайвера <> Неопределено Тогда
			Если ВерсииРавны() Тогда
				ЭлементыФормы.Версия.ЦветТекстаПоля = ЦветаСтиля.ЦветТекстаФормы;
			Иначе
				ЭлементыФормы.Версия.ЦветТекстаПоля = ЦветаСтиля.ЦветОтрицательногоЧисла;
			КонецЕсли;

			Версия = мВерсияИзДрайвера;
		Иначе
			ЭлементыФормы.Версия.ЦветТекстаПоля = ЦветаСтиля.ЦветОтрицательногоЧисла;
			Версия  = "Не определена";
		КонецЕсли;
	Иначе
		ЭлементыФормы.Драйвер.ЦветТекстаПоля = ЦветаСтиля.ЦветОтрицательногоЧисла;
		Драйвер = "Не установлен";
		ЭлементыФормы.Версия.ЦветТекстаПоля = ЦветаСтиля.ЦветОтрицательногоЧисла;
		Версия  = "Не определена";
	КонецЕсли;

КонецПроцедуры //ПроверкаДрайвераИВерсии()

Процедура ПроверитьДемо(Объект)
	Если ТипСвязи <> "Сервер" Тогда
		ДемоРез = Объект.Драйвер.ПроверитьДемо();
		Если ДемоРез = 1 Тогда
			ЭлементыФормы.ДемоСообщ.Заголовок = "Демо-версия драйвера.";
		ИначеЕсли ДемоРез = 0 Тогда
			ЭлементыФормы.ДемоСообщ.Заголовок = "Полнофункциональная версия драйвера.";
		ИначеЕсли ДемоРез = -1 Тогда
			ЭлементыФормы.ДемоСообщ.Заголовок = "Ошибка при проверке лицензии.";
		КонецЕсли;
	Иначе
		ЭлементыФормы.ДемоСообщ.Заголовок = "";
	КонецЕсли;
КонецПроцедуры

Процедура ТестУстройстваНажатие(Элемент)

	Объект = Неопределено;

	времПараметры = Новый Структура;
	//времПараметры.Вставить("Порт",                     Порт);
	//времПараметры.Вставить("Скорость",                 Скорость);
	//времПараметры.Вставить("ТипСвязи",                 ТипСвязи);
	//времПараметры.Вставить("НомерБазы",                НомерБазы);
	//времПараметры.Вставить("НомерДокумента",           НомерДокумента);
	времПараметры.Вставить("ВыбиратьИсточникЗагрузки", Не ЗагружатьВсеДокументы);

	времПараметры.Вставить("ТипСвязи",                ТипСвязи);
	времПараметры.Вставить("СтрокаПодключенияКСерверу", ПолучитьСтрокуПодключения(СтрокаПодключенияКСерверу));
	времПараметры.Вставить("Прокси", Прокси);
	времПараметры.Вставить("ПортПрокси", ПортПрокси);

	Если ОбработкаОбъект.СоздатьОбъектДрайвера(Объект, мМодель, времПараметры) = мНетОшибки Тогда
		РезультатТеста = "";
		МассивЗначений = Новый Массив;
		Если ТипСвязи = "Сервер" Тогда
			МассивЗначений.Добавить(1);	
			МассивЗначений.Добавить(ПолучитьСтрокуПодключения(СтрокаПодключенияКСерверу));	
			МассивЗначений.Добавить(Прокси);
			МассивЗначений.Добавить(ПортПрокси);
		Иначе
			МассивЗначений.Добавить(0);	
		КонецЕсли;
		
		МассивЗначений.Добавить(ПереписыватьНоменклатуру);
		
		Если Объект.Драйвер.ТестУстройства(МассивЗначений, РезультатТеста) Тогда
			Сообщить(Строка(мМодель) + ": Тест успешно выполнен." + Символы.ПС + "Дополнительное описание: " + РезультатТеста + Символы.ПС, СтатусСообщения.Информация);
			ИдТерминала = Объект.Драйвер.ПолучитьИдТерминала();
			Если ПустаяСтрока(ИдТерминала) Тогда
				ИдТерминала = "Ид. не получен. Установите и запустите программу ТСД";
			КонецЕсли;
			ПроверитьДемо(Объект);
		Иначе 
			Сообщить(Строка(мМодель) + ": Тест не пройден." + Символы.ПС + "Дополнительное описание: " + РезультатТеста + Символы.ПС, СтатусСообщения.Важное);
		КонецЕсли;
		
		Объект.Драйвер.ОсвободитьРесурсы();
	Иначе
		Сообщить(Строка(мМодель) + ": Тест не пройден." + Символы.ПС + "Дополнительное описание: Ошибка при создании объекта драйвера" 
		         + Символы.ПС + "Проверьте, что драйвер зарегистрирован в системе" + Символы.ПС, СтатусСообщения.Важное);
	КонецЕсли;

КонецПроцедуры

Процедура ПолучитьИдНажатие(Элемент)
	Объект = Неопределено;
	
	времПараметры = Новый Структура;
	//времПараметры.Вставить("Порт",                     Порт);
	//времПараметры.Вставить("Скорость",                 Скорость);
	//времПараметры.Вставить("ТипСвязи",                 ТипСвязи);
	//времПараметры.Вставить("НомерБазы",                НомерБазы);
	//времПараметры.Вставить("НомерДокумента",           НомерДокумента);
	времПараметры.Вставить("ВыбиратьИсточникЗагрузки", Не ЗагружатьВсеДокументы);

	времПараметры.Вставить("ТипСвязи",                ТипСвязи);
	времПараметры.Вставить("СтрокаПодключенияКСерверу", ПолучитьСтрокуПодключения(СтрокаПодключенияКСерверу));
	времПараметры.Вставить("Прокси", Прокси);
	времПараметры.Вставить("ПортПрокси", ПортПрокси);
	
	Если ОбработкаОбъект.СоздатьОбъектДрайвера(Объект, мМодель, времПараметры) = мНетОшибки Тогда
		ИдТерминала = Объект.Драйвер.ПолучитьИдТерминала();
		Если ПустаяСтрока(ИдТерминала) Тогда
			ИдТерминала = "Ид. не получен. Установите и запустите программу ТСД";
		КонецЕсли;
		ПроверитьДемо(Объект);	
	КонецЕсли;
КонецПроцедуры	

Процедура ПроверкаСоединенияНажатие(Элемент)
	Объект = Неопределено;

	времПараметры = Новый Структура;
	//времПараметры.Вставить("НомерБазы",                НомерБазы);
	//времПараметры.Вставить("НомерДокумента",           НомерДокумента);
	времПараметры.Вставить("ВыбиратьИсточникЗагрузки", Не ЗагружатьВсеДокументы);

	времПараметры.Вставить("ТипСвязи",                ТипСвязи);
	времПараметры.Вставить("СтрокаПодключенияКСерверу", ПолучитьСтрокуПодключения(СтрокаПодключенияКСерверу));
	времПараметры.Вставить("Прокси", Прокси);
	времПараметры.Вставить("ПортПрокси", ПортПрокси);

	Если ОбработкаОбъект.СоздатьОбъектДрайвера(Объект, мМодель, времПараметры) = мНетОшибки Тогда
		МассивЗначений = Новый Массив;
		Если ТипСвязи = "Сервер" Тогда
			МассивЗначений.Добавить(1);	
			МассивЗначений.Добавить(ПолучитьСтрокуПодключения(СтрокаПодключенияКСерверу));	
			МассивЗначений.Добавить(Прокси);
			МассивЗначений.Добавить(ПортПрокси);
		Иначе
			МассивЗначений.Добавить(0);	
		КонецЕсли;
		
		Если Объект.Драйвер.ПроверитьСоединениеССервером(МассивЗначений) Тогда
			Сообщить("Проверка прошла успешно!");	
		Иначе
			Ошибка = "";
			Объект.Драйвер.ПолучитьОшибку(Ошибка);
			Сообщить("Соединение не установлено! Ошибка: " + Ошибка);
		КонецЕсли;	
		
		Объект.Драйвер.ОсвободитьРесурсы();
	КонецЕсли;
КонецПроцедуры	

Процедура ИнформацияОДрайвереСсылкаНажатие(Элемент)

	ЗапуститьПриложение(ЭлементыФормы.ИнформацияОДрайвереСсылка.Значение);

КонецПроцедуры

Процедура ТипСвязиПриИзменении(Элемент)
	Если ТипСвязи = "Сервер" Тогда
		// Жульков 01.10.2013 +
		ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Страница1;
		ЭлементыФормы.ПапкаОбмена.Видимость = Ложь;
		ЭлементыФормы.НадписьПапкаОбмена.Видимость = Ложь;
		// Жульков 01.10.2013 -
		ЭлементыФормы.СтрокаПодключенияКСерверу.Доступность = Истина;
		ЭлементыФормы.Прокси.Доступность = Истина;
        ЭлементыФормы.ПортПрокси.Доступность = Истина;
		ЭлементыФормы.ПроверкаСоединения.Доступность = Истина;
		
		Если ПустаяСтрока(СтрокаПодключенияКСерверу) Тогда
			СтрокаПодключенияКСерверу = ПолучитьIPПоУмолчанию()+":9400";	
		КонецЕсли;
		
		ЭлементыФормы.ПроверкаСоединения.Доступность = Истина;
	Иначе
		// Жульков 01.10.2013 +
		ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Страница2;
		Если ТипСвязи = "RDPСвязь" Тогда
			ЭлементыФормы.ПапкаОбмена.Видимость = Истина;
			ЭлементыФормы.НадписьПапкаОбмена.Видимость = Истина;
		Иначе
			ЭлементыФормы.ПапкаОбмена.Видимость = Ложь;
			ЭлементыФормы.НадписьПапкаОбмена.Видимость = Ложь;
		КонецЕсли;
		// Жульков 01.10.2013 -
		ЭлементыФормы.СтрокаПодключенияКСерверу.Доступность = Ложь;
		ЭлементыФормы.Прокси.Доступность = Ложь;
        ЭлементыФормы.ПортПрокси.Доступность = Ложь;
		ЭлементыФормы.ПроверкаСоединения.Доступность = Ложь;
		ЭлементыФормы.ПроверкаСоединения.Доступность = Ложь;
	КонецЕсли;	
КонецПроцедуры

Процедура ПапкаОбменаОткрытие(Элемент, СтандартнаяОбработка)
	//Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	//ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	//ДиалогОткрытияФайла.ПолноеИмяФайла = ПапкаОбмена;
	//ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	//ДиалогОткрытияФайла.Заголовок = "Выберите папку";
	//
	//Если ДиалогОткрытияФайла.Выбрать() Тогда
	//	ПапкаОбмена = ДиалогОткрытияФайла.Каталог;	
	//КонецЕсли;
	//
КонецПроцедуры

Процедура ПапкаОбменаНачалоВыбора(Элемент, СтандартнаяОбработка)
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = ПапкаОбмена;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите папку";
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ПапкаОбмена = ДиалогОткрытияФайла.Каталог;	
	КонецЕсли;
КонецПроцедуры


Процедура ДопПараметрыНажатие(Элемент)
	
	Объект = Неопределено;

	времПараметры = Новый Структура;
	//времПараметры.Вставить("Порт",                     Порт);
	//времПараметры.Вставить("Скорость",                 Скорость);
	//времПараметры.Вставить("ТипСвязи",                 ТипСвязи);
	//времПараметры.Вставить("НомерБазы",                НомерБазы);
	//времПараметры.Вставить("НомерДокумента",           НомерДокумента);
	времПараметры.Вставить("ВыбиратьИсточникЗагрузки", Не ЗагружатьВсеДокументы);

	времПараметры.Вставить("ТипСвязи",                ТипСвязи);
	времПараметры.Вставить("СтрокаПодключенияКСерверу", СтрокаПодключенияКСерверу);
	времПараметры.Вставить("Прокси", Прокси);
	времПараметры.Вставить("ПортПрокси", ПортПрокси);

	Если ОбработкаОбъект.СоздатьОбъектДрайвера(Объект, мМодель, времПараметры) = мНетОшибки Тогда
		ФормаДопНастройки = ПолучитьФорму("ФормаДопНастройкиТСД");
		ФормаДопНастройки.мОбъект = Объект; 
		ФормаДопНастройки.Открыть();
	Иначе
		Сообщить("Не удалось создать объект драйвера!");
	КонецЕсли;
	
КонецПроцедуры

Процедура ИспШаблоныВесовогоПриИзменении(Элемент)
	ЭлементыФормы.ПрефиксВесовогоТовара.Доступность = ИспШаблоныВесового;
	ЭлементыФормы.ДлинаКодаВесовогоТовара.Доступность = ИспШаблоныВесового;
	//ЭлементыФормы.КоэффициентВеса.Доступность = ИспШаблоныВесового;
	ЭлементыФормы.ЧислоЗнаковПослеЗапВВесе.Доступность = ИспШаблоныВесового;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
//// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мНетОшибки = Перечисления.ТООшибкиОбщие.ПустаяСсылка();