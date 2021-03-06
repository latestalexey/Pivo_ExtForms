﻿
// Процедура вызывается при нажатии кнопки "Заполнить" из панели ОсновныеДействияФормы
//В процедуре выполняется создание и заполнение документа "IT_ОтражениеФактическихДанныхБюджетирования" 
//данными из табличной части.
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Если  СписокАналитическихРазрезов.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Табличная часть не заполнена!";
		Сообщение.Сообщить(); 
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СписокАналитическихРазрезов.СтатьяБюджета,
	               |	СписокАналитическихРазрезов.Проект,
	               |	СписокАналитическихРазрезов.Контрагент,
	               |	СписокАналитическихРазрезов.Номенклатура,
	               |	СписокАналитическихРазрезов.ЕдиницаИзмерения,
	               |	СписокАналитическихРазрезов.Количество,
	               |	СписокАналитическихРазрезов.Сумма,
	               |	СписокАналитическихРазрезов.Подразделение КАК Подразделение,
	               |	СписокАналитическихРазрезов.ВидБюджета КАК ВидБюджета,
	               |	СписокАналитическихРазрезов.Период КАК Период
	               |ПОМЕСТИТЬ ВТТабЧасть
	               |ИЗ
	               |	&ТабЧасть КАК СписокАналитическихРазрезов
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТТабЧасть.СтатьяБюджета,
	               |	ВТТабЧасть.Проект,
	               |	ВТТабЧасть.Контрагент,
	               |	ВТТабЧасть.Номенклатура,
	               |	ВТТабЧасть.ЕдиницаИзмерения,
	               |	ВТТабЧасть.Количество,
	               |	ВТТабЧасть.Сумма,
	               |	ВТТабЧасть.Подразделение КАК Подразделение,
	               |	ВТТабЧасть.ВидБюджета КАК ВидБюджета,
	               |	ВТТабЧасть.Период КАК Период
	               |ИЗ
	               |	ВТТабЧасть КАК ВТТабЧасть
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период
	               |ИТОГИ ПО
	               |	Подразделение,
	               |	ВидБюджета,
	               |	Период";
	Запрос.УстановитьПараметр("ТабЧасть",СписокАналитическихРазрезов);
	ВыборкаПодразделений = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПодразделений.Следующий() Цикл
		ВыборкаВидаБюджета = ВыборкаПодразделений.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаВидаБюджета.Следующий() Цикл 
			ВыборкаПериод = ВыборкаВидаБюджета.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПериод.Следующий() Цикл 
				Док = Документы.IT_ОтражениеФактическихДанныхБюджетирования.СоздатьДокумент();
				Док.ДатаНачала = ДатаНачала;
				Док.ДатаОкончания = ДатаОкончания;
				Док.Подразделение = ВыборкаПодразделений.Подразделение;
				Док.ВидБюджета = ВыборкаВидаБюджета.ВидБюджета;
				Док.Период = ВыборкаПериод.Период;
				Док.Дата = ВыборкаПериод.Период;
				Док.Ответственный=глЗначениеПеременной("глТекущийПользователь");
				Выборка = ВыборкаПериод.Выбрать();
				Пока Выборка.Следующий() Цикл
					Стр = Док.СписокАналитическихРазрезов.Добавить();  
					ЗаполнитьЗначенияСвойств(Стр,Выборка); 						 
				КонецЦикла;				 
				Док.Записать(РежимЗаписиДокумента.Проведение);
			КонецЦикла;
		КонецЦикла;	 
	КонецЦикла;
КонецПроцедуры

//Процедура вызывается при нажатии кнопки "Заполнить" из панели "КоманднаяПанель"
//Заполняется табличная часть "СписокАналитическихРазрезов"
//
Процедура ЗаполнитьТабЧасть(Кнопка)
	СписокАналитическихРазрезов.Очистить();	
	
	Если ЗначениеЗаполнено(ЗапросБюджета) Тогда		
		РезультатВыполнения=ЗаполнитьТаблицуНаСервере();  
		
		ПараметрыОбработчикаОжидания = Новый Структура;
	
		Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		Иначе
			
		КонецЕсли;
	Иначе 
		Сообщение =Новый СообщениеПользователю;
		Сообщение.Текст = "Не заполнено поле запрос бюджета!";
		Сообщение.Сообщить();                  		
	КонецЕсли;
КонецПроцедуры

Функция ЗаполнитьТаблицуНаСервере()
	Запрос = ПолучитьЗапросПоНастройке(ПостроительОтбор.ПолучитьНастройки(Истина,Ложь,Ложь,Ложь,Ложь));	
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ИдентификаторЗадания = Неопределено;
	
	Если ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.IT_ОбменСПодсистемойБюджетирование.ВыполнитьЗапросНаСервере(Запрос, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Обработки.IT_ОбменСПодсистемойБюджетирование.ВыполнитьЗапросНаСервере", 
			Запрос, 
			НСтр("ru = 'Получение данных по бюджетированию'"));
						
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;		
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

Процедура ОбработкаРезультатаЗапроса(РезультатыЗапроса)
	Для Каждого РезультатЗапроса Из РезультатыЗапроса Цикл
		тзДанные = РезультатЗапроса.Выгрузить();
		// проверка служебной таблицы
		Если тзДанные.Количество()=1 И тзДанные.Колонки.Количество()=1 И тзДанные.Колонки.Найти("Количество")<>Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого СтрокаТЗ ИЗ тзДанные Цикл
			Стр = СписокАналитическихРазрезов.Добавить();
			ЗаполнитьЗначенияСвойств(Стр, СтрокаТЗ);
			Стр.ВидБюджета = ВидБюджета;
		КонецЦикла;
	КонецЦикла;	
КонецПроцедуры

Процедура Подключаемый_ПроверитьВыполнениеЗадания()  
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ВызватьИсключение;
	КонецПопытки;	
КонецПроцедуры

Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

Процедура ЗагрузитьПодготовленныеДанные()
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(РезультатВыполнения)=Тип("Строка") Тогда
		Сообщить(РезультатВыполнения);
	Иначе
		ОбработкаРезультатаЗапроса(РезультатВыполнения);
	КонецЕсли;
КонецПроцедуры

 
//Процедура вызывается при изменении элемента формы "ВидБюджета"
//
Процедура ВидБюджетаПриИзменении(Элемент)
	
	ЭлементыФормы.ЗапросБюджета.Значение = Неопределено;	
	Если ЭлементыФормы.ВидБюджета.Значение = Перечисления.IT_ВидыБюджета.БДР Тогда 
		Бюджет = Перечисления.IT_ВидыБюджета.БДР;
	ИначеЕсли ЭлементыФормы.ВидБюджета.Значение = Перечисления.IT_ВидыБюджета.БДДС Тогда 
		Бюджет = Перечисления.IT_ВидыБюджета.БДДС;
	Иначе 
		ЭлементыФормы.ЗапросБюджета.Значение = Неопределено;
	КонецЕсли; 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	IT_НастройкиИмпорта.Ссылка КАК Настройка
		|ИЗ
		|	Справочник.IT_НастройкиИмпорта КАК IT_НастройкиИмпорта
		|ГДЕ
		|	IT_НастройкиИмпорта.Основная = ИСТИНА
		|	И IT_НастройкиИмпорта.ВидБюджета = &ВидБюджета";  
		
	Запрос.УстановитьПараметр("ВидБюджета", Бюджет);
	Результат = Запрос.Выполнить();                 
	
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЭлементыФормы.ЗапросБюджета.Значение = ВыборкаДетальныеЗаписи.Настройка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(ДатаНачала, ?(ДатаОкончания='0001-01-01', ДатаОкончания, КонецДня(ДатаОкончания)));
	Если НастройкаПериода.Редактировать() Тогда
		ДатаНачала = НастройкаПериода.ПолучитьДатуНачала();
		ДатаОкончания = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры

Процедура ПриОткрытии()
	
КонецПроцедуры
