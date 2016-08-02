﻿Перем мКатегорияКассаБонус1;
Перем мКатегорияКассаБонус2;
Перем мКатегорияКассаБонус3;

Перем мСвойствоНоменклатураБонус1;
Перем мСвойствоНоменклатураБонус2;
Перем мСвойствоНоменклатураБонус3;

Перем мПросроченныйТовар;

Перем Кеш;

#Область Вспомогательные_процедуры_и_функции
Функция ЭтоЧисло(Знач ВхСтрока)
	Длина=СтрДлина(ВхСтрока);
	Для Сч=1 По Длина Цикл
	
		Символ=Сред(ВхСтрока,Сч,1);
		Если НЕ (Символ>="0" И Символ<="9") Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина
КонецФункции

Функция РасчетБонусаПоИерархии(Знач Товар, Знач Соотв)
	ТекРодитель=Соотв.Получить(Товар);
	Если ТекРодитель=Неопределено Тогда
		Возврат "";
	Иначе
		ТекРодитель=ТекРодитель.Родитель;
	КонецЕсли;
	ТекРодитель=Соотв.Получить(ТекРодитель);
	Если ТекРодитель=Неопределено Тогда
		Возврат "";
	Иначе
		ТекРодитель=ТекРодитель.Родитель;
	КонецЕсли;
	Пока ЗначениеЗаполнено(ТекРодитель) Цикл
		Зн=Соотв.Получить(ТекРодитель);
		Если ЗначениеЗаполнено(Зн.Бонус) Тогда
			Возврат Формат(Зн.Бонус,"ЧДЦ=2; ЧРД=.; ЧН=; ЧГ=")+"%";
		Иначе
			ТекРодитель=Зн.Родитель;
		КонецЕсли;
	КонецЦикла;
	
	Возврат "";
КонецФункции

Функция РассчетОбъема(Номенклатура)
	Объем=0;
	Если Номенклатура.Комплект Тогда
		Запрос=Новый Запрос("ВЫБРАТЬ
		|	СУММА(КомплектующиеНоменклатуры.ЕдиницаИзмерения.Объем * КомплектующиеНоменклатуры.Количество) КАК Объем
		|ИЗ
		|	РегистрСведений.КомплектующиеНоменклатуры КАК КомплектующиеНоменклатуры
		|ГДЕ
		|	КомплектующиеНоменклатуры.Номенклатура = &Номенклатура");
		Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
		Рез=Запрос.Выполнить();
		Если Рез.Пустой() Тогда
			Объем=0;
		Иначе
			Объем=Рез.Выгрузить()[0].Объем;
		КонецЕсли;
	Иначе
		Объем=Номенклатура.ЕдиницаХраненияОстатков.Объем;
	КонецЕсли;
	Возврат Объем;
КонецФункции

Функция ЕстьПросрочка(Склад)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТоварыВРозницеОстатки.Склад,
		|	ТоварыВРозницеОстатки.Номенклатура,
		|	ТоварыВРозницеОстатки.КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ТоварыВРознице.Остатки(
		|			,
		|			Номенклатура В
		|					(ВЫБРАТЬ
		|						КатегорииОбъектов.Объект
		|					ИЗ
		|						РегистрСведений.КатегорииОбъектов КАК КатегорииОбъектов
		|					ГДЕ
		|						КатегорииОбъектов.Категория = &ПросроченныйТовар)
		|				И Склад = &Склад) КАК ТоварыВРозницеОстатки";
	
	Запрос.УстановитьПараметр("ПросроченныйТовар", мПросроченныйТовар);
	Запрос.УстановитьПараметр("Склад", Склад);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
КонецФункции

Функция ТаблицаДляБонуса3()
	Соотв=Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Группа,
		|	Номенклатура.Родитель,
		|	ЕСТЬNULL(ЗначенияСвойствОбъектов.Значение, 0) КАК Бонус
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ПО Номенклатура.Ссылка = ЗначенияСвойствОбъектов.Объект
		|			И (ЗначенияСвойствОбъектов.Свойство = &Бонус3)
		|ГДЕ
		|	НЕ Номенклатура.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Бонус3", мСвойствоНоменклатураБонус3);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Стр=Новый Структура("Бонус,Родитель",ВыборкаДетальныеЗаписи.Бонус,ВыборкаДетальныеЗаписи.Родитель);
		Соотв.Вставить(ВыборкаДетальныеЗаписи.Группа,Стр)
	КонецЦикла;
	
	Возврат Соотв;
КонецФункции
#КонецОбласти


#Область Получение_цен
// Функция - Получить цены АТТ для кассы
//
// Параметры:
//  Склад		 - Справочник.Склады - Склад, для которого получаем цены
//  Номенклатура - Массив - Массив номенклатуры, для фильтрации
// 
// Возвращаемое значение:
//   - 
//
Функция ПолучитьЦены(Склад,Номенклатура) Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЦеныАТТСрезПоследних.Номенклатура,
	             |	ЦеныАТТСрезПоследних.Цена
	             |ИЗ
	             |	РегистрСведений.ЦеныАТТ.СрезПоследних(
	             |			&ДатаВыгрузки,
	             |			Номенклатура В (&Номенклатура)
	             |				И Склад = &Склад) КАК ЦеныАТТСрезПоследних";
	Запрос.УстановитьПараметр("Склад",Склад);
	Запрос.УстановитьПараметр("ДатаВыгрузки",ТекущаяДата());
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	
	Таб=Запрос.Выполнить().Выгрузить();
	Таб.Индексы.Добавить("Номенклатура");
	Возврат Таб;
КонецФункции

// Функция - Получить дополнительные цены(по Цены номенклатуры) для кассы
//
// Параметры:
//  Склад		 - Справочник.Склады	 - склад, для которого получаем цены
//  Номенклатура - Массив	 - массив номенклатуры, для фильтрации
//  Ночная		 - Булево	 - получаем цены по Тип цен розничной торговли ночной или Тип цен розничной торговли
// 
// Возвращаемое значение:
//   - 
//
Функция ПолучитьЦеныДОП(Склад,Номенклатура,Ночная=Ложь) Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЦеныНоменклатурыСрезПоследних.Номенклатура,
	             |	ЦеныНоменклатурыСрезПоследних.Цена
	             |ИЗ
	             |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	             |			&ДатаВыгрузки,
	             |			Номенклатура В (&Номенклатура)
	             |				И ТипЦен = &ДопЦена) КАК ЦеныНоменклатурыСрезПоследних";
	Запрос.УстановитьПараметр("ДопЦена",?(Не Ночная,Склад.ТипЦенРозничнойТорговли,Склад.ТипЦенРозничнойТорговлиНочной));
	Запрос.УстановитьПараметр("ДатаВыгрузки",ТекущаяДата());
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	
	Таб=Запрос.Выполнить().Выгрузить();
	Таб.Индексы.Добавить("Номенклатура");
	Возврат Таб;
КонецФункции
#КонецОбласти

// Процедура - Отправить письмо с уведомлением о работе выгрузки
//
// Параметры:
//  ПолучательПисем	 - Строка	 - адрес, на который отпрвлять уведомление
//  ЗаголовокПисьма	 - Строка	 - заголовок письма-уведомления
//  ТелоПисьма		 - Строка	 - содержание письма
//
Процедура ОтправитьПисьмо(ПолучательПисем,ЗаголовокПисьма,ТелоПисьма) Экспорт

	УчетныеЗаписи = Новый Массив;
	УчетныеЗаписи.Добавить(Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоНаименованию("1С").Ссылка);
	Письма = Новый Соответствие;
	СтруктураПисьма = Новый Структура;
	СтруктураПисьма.Вставить("Тема"         , ЗаголовокПисьма);
	СтруктураПисьма.Вставить("УчетнаяЗапись", Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоКоду("000000001"));
	Отбой=Символы.ПС+Символы.ВК;
	ТекстПисьма=Новый ТекстовыйДокумент;
	ТекстПисьма.ДобавитьСтроку(ТелоПисьма);
	ТекстПисьма.ДобавитьСтроку("Начало выгрузки:");
	ТекстПисьма.ДобавитьСтроку(Формат(ТекущаяДата(),"ДЛФ=DDT"));
	СтруктураПисьма.Вставить("Тело"      , ТекстПисьма.ПолучитьТекст());
	СписокКому = Новый СписокЗначений;
	СписокКому.Добавить(ПолучательПисем,"Ответственный");
	СтруктураПисьма.Вставить("Кому", СписокКому);
	Письмо = УправлениеЭлектроннойПочтой.НаписатьПисьмо(Справочники.Пользователи.НайтиПоКоду("Регламент"), СтруктураПисьма,,, Истина, "Ответ", ,,ложь);
	Если ЗначениеЗаполнено(Письмо) Тогда
		ОбъектПисьмо = Письмо.ПисьмоСсылка.ПолучитьОбъект();
		ОбъектПисьмо.СтатусПисьма = Перечисления.СтатусыПисем.Исходящее;
		ОбъектПисьмо.Записать();
		
		Если Не ЗначениеЗаполнено(ОбъектПисьмо.Ответственный) Тогда
			ОбъектПисьмо.Ответственный = Справочники.Пользователи.НайтиПоКоду("Регламент");
		КонецЕсли; 
		
		Письма.Вставить(Письмо.ПисьмоСсылка, ОбъектПисьмо);
		УправлениеЭлектроннойПочтой.ПолучениеОтправкаПисем(Неопределено, Справочники.Пользователи.НайтиПоКоду("Регламент"), УчетныеЗаписи, Письма, Истина,Ложь,Ложь);
	КонецЕсли;
	

КонецПроцедуры

#Область Получение_данных_для_выгрузки
Функция ПолучитьТаблицуТоваровДляВыгрузки() Экспорт
	Запрос = Новый Запрос();
	//KAV++ Крапивин Андрей. 31.03.2015 16:05:50 #1187558 Добавим расчет объема
#Область Запрос
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	               |	ВложенныйЗапрос.ПЛУ,
	               |	ВложенныйЗапрос.ЕдиницаИзмерения,
	               |	ВложенныйЗапрос.ЭтоГруппа,
	               |	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	               |	ВложенныйЗапрос.Комплект КАК Комплект,
	               |	ВложенныйЗапрос.ВесовойТовар,
	               |	ВложенныйЗапрос.Остаток,
	               |	ВЫБОР
	               |		КОГДА ВложенныйЗапрос.Номенклатура В ИЕРАРХИИ (&ГрСигареты)
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК ГрСигареты,
	               |	ВложенныйЗапрос.Номенклатура В ИЕРАРХИИ (&ГрСигаретыБлоками) КАК ГрСигаретыБлоками,
	               |	ВложенныйЗапрос.Номенклатура В ИЕРАРХИИ (&ГрБутылки) КАК ГрБутылки,
	               |	ВложенныйЗапрос.Номенклатура В ИЕРАРХИИ (&ГрСнекиВесовые, &ГрХолодильник) КАК Кратность0,
	               |	ВложенныйЗапрос.Номенклатура В ИЕРАРХИИ (&ГрПивоРозлив, &ГрВиноРозлив) КАК Кратность05,
	               |	ВложенныйЗапрос.Номенклатура.ВидНоменклатуры = &ВН_ПодарочныйСертификат КАК ЭтоПодарСерт,
	               |	ВложенныйЗапрос.Объем
	               |ПОМЕСТИТЬ ВТ_Номенклатура
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		НоменклатураСпр.Ссылка КАК Номенклатура,
	               |		НоменклатураСпр.Код КАК ПЛУ,
	               |		НоменклатураСпр.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	               |		НоменклатураСпр.ЭтоГруппа КАК ЭтоГруппа,
	               |		НЕОПРЕДЕЛЕНО КАК ХарактеристикаНоменклатуры,
	               |		ЛОЖЬ КАК Комплект,
	               |		НоменклатураСпр.Весовой КАК ВесовойТовар,
	               |		0 КАК Остаток,
	               |		СУММА(НоменклатураСпр.ЕдиницаХраненияОстатков.Объем) КАК Объем
	               |	ИЗ
	               |		Справочник.Номенклатура КАК НоменклатураСпр
	               |	ГДЕ
	               |		НоменклатураСпр.Ссылка В ИЕРАРХИИ(&СпНоменклатура)
	               |		И НЕ НоменклатураСпр.ЭтоГруппа
	               |		И НЕ НоменклатураСпр.Архивный
	               |		И НЕ НоменклатураСпр.Комплект
	               |		И НЕ НоменклатураСпр.ПометкаУдаления
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		НоменклатураСпр.Ссылка,
	               |		НоменклатураСпр.Код,
	               |		НоменклатураСпр.ЕдиницаХраненияОстатков,
	               |		НоменклатураСпр.ЭтоГруппа,
	               |		НоменклатураСпр.Весовой
	               |	
	               |	ОБЪЕДИНИТЬ
	               |	
	               |	ВЫБРАТЬ
	               |		НоменклатураСпр.Ссылка,
	               |		НоменклатураСпр.Код,
	               |		НоменклатураСпр.ЕдиницаХраненияОстатков,
	               |		НоменклатураСпр.ЭтоГруппа,
	               |		НЕОПРЕДЕЛЕНО,
	               |		ИСТИНА,
	               |		ЛОЖЬ,
	               |		0,
	               |		СУММА(ЕСТЬNULL(КомплектующиеНоменклатуры.ЕдиницаИзмерения.Объем, 0) * ЕСТЬNULL(КомплектующиеНоменклатуры.Количество, 0))
	               |	ИЗ
	               |		Справочник.Номенклатура КАК НоменклатураСпр
	               |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КомплектующиеНоменклатуры КАК КомплектующиеНоменклатуры
	               |			ПО (КомплектующиеНоменклатуры.Номенклатура = НоменклатураСпр.Ссылка)
	               |				И (КомплектующиеНоменклатуры.Комплектующая В ИЕРАРХИИ (&ГрПивоРозлив, &ГрСамара))
	               |	ГДЕ
	               |		НЕ НоменклатураСпр.Архивный
	               |		И НоменклатураСпр.Комплект
	               |		И НЕ НоменклатураСпр.ПометкаУдаления
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		НоменклатураСпр.Ссылка,
	               |		НоменклатураСпр.Код,
	               |		НоменклатураСпр.ЕдиницаХраненияОстатков,
	               |		НоменклатураСпр.ЭтоГруппа) КАК ВложенныйЗапрос
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Номенклатура
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_Номенклатура.Номенклатура,
	               |	ВТ_Номенклатура.ПЛУ,
	               |	ВТ_Номенклатура.ЕдиницаИзмерения,
	               |	ВТ_Номенклатура.ЭтоГруппа,
	               |	ВТ_Номенклатура.ХарактеристикаНоменклатуры,
	               |	ВТ_Номенклатура.Комплект,
	               |	ВТ_Номенклатура.ВесовойТовар,
	               |	ВТ_Номенклатура.Остаток,
	               |	ВТ_Номенклатура.ГрСигареты,
	               |	ВТ_Номенклатура.ГрСигаретыБлоками,
	               |	ВТ_Номенклатура.ГрБутылки,
	               |	ВТ_Номенклатура.Кратность0,
	               |	ВТ_Номенклатура.Кратность05,
	               |	ВТ_Номенклатура.ЭтоПодарСерт,
	               |	ВТ_Номенклатура.Объем,
	               |	ЕСТЬNULL(ЗначенияСвойствОбъектовФиксБонус.Значение, """") КАК ФиксированныйБонус,
	               |	ЕСТЬNULL(ЗначенияСвойствОбъектовБонус1.Значение, """") КАК Бонус1,
	               |	ЕСТЬNULL(ЗначенияСвойствОбъектовБонус2.Значение, """") КАК Бонус2,
	               |	ЕСТЬNULL(ЗначенияСвойствОбъектовБонус3Иерархия.Значение, """") КАК Бонус3,
	               |	ЕСТЬNULL(ЗначенияСвойствОбъектовКратность.Значение.Наименование, """") КАК КратностьТовара,
	               |	КатегорииОбъектовКонтролироватьОстаток.Категория ЕСТЬ НЕ NULL  КАК КонтролироватьОстаток
	               |ИЗ
	               |	ВТ_Номенклатура КАК ВТ_Номенклатура
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектовФиксБонус
	               |		ПО ВТ_Номенклатура.Номенклатура = ЗначенияСвойствОбъектовФиксБонус.Объект
	               |			И (ЗначенияСвойствОбъектовФиксБонус.Свойство = &ФиксированныйБонус)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектовКратность
	               |		ПО ВТ_Номенклатура.Номенклатура = ЗначенияСвойствОбъектовКратность.Объект
	               |			И (ЗначенияСвойствОбъектовКратность.Свойство = &КратностьВКассе)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектовБонус1
	               |		ПО ВТ_Номенклатура.Номенклатура = ЗначенияСвойствОбъектовБонус1.Объект
	               |			И (ЗначенияСвойствОбъектовБонус1.Свойство = &Бонус1)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектовБонус2
	               |		ПО ВТ_Номенклатура.Номенклатура = ЗначенияСвойствОбъектовБонус2.Объект
	               |			И (ЗначенияСвойствОбъектовБонус2.Свойство = &Бонус2)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектовБонус3Иерархия
	               |		ПО ВТ_Номенклатура.Номенклатура.Родитель = ЗначенияСвойствОбъектовБонус3Иерархия.Объект
	               |			И (ЗначенияСвойствОбъектовБонус3Иерархия.Свойство = &Бонус3)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КатегорииОбъектов КАК КатегорииОбъектовКонтролироватьОстаток
	               |		ПО ВТ_Номенклатура.Номенклатура = КатегорииОбъектовКонтролироватьОстаток.Объект
	               |			И (КатегорииОбъектовКонтролироватьОстаток.Категория = &ИстекаетСрокГодности)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ВТ_Номенклатура.Комплект,
	               |	ВТ_Номенклатура.Номенклатура.Код";
#КонецОбласти				   

#Область Параметры_запроса
	Запрос.УстановитьПараметр("ГрСигареты",			Справочники.ИТИКонстанты.ГруппаНоменклатурыСигареты.Указатель);
	Запрос.УстановитьПараметр("ГрСигаретыБлоками",	Справочники.Номенклатура.НайтиПоКоду("00000008437").Ссылка);
	Запрос.УстановитьПараметр("ГрБутылки",			Справочники.Номенклатура.НайтиПоКоду("00000000221").Ссылка);
	Запрос.УстановитьПараметр("КратностьВКассе",	ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("Кратность товара в кассе"));
	
	//Бонусы
	Запрос.УстановитьПараметр("ФиксированныйБонус",	ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("Фиксированный бонус"));
	Запрос.УстановитьПараметр("Бонус1",				мСвойствоНоменклатураБонус1);
	Запрос.УстановитьПараметр("Бонус2",				мСвойствоНоменклатураБонус2);
	Запрос.УстановитьПараметр("Бонус3",				мСвойствоНоменклатураБонус3);
	
	//_Кратность = "";
	Запрос.УстановитьПараметр("ГрСнекиВесовые",		Справочники.Номенклатура.НайтиПоКоду("00000000700"));
	Запрос.УстановитьПараметр("ГрХолодильник",		Справочники.Номенклатура.НайтиПоКоду("00000000944"));
	//_Кратность = "0,5000";			
	Запрос.УстановитьПараметр("ГрПивоРозлив",		Справочники.Номенклатура.НайтиПоКоду("00000000001"));
	Запрос.УстановитьПараметр("ГрСамара",			Справочники.Номенклатура.НайтиПоКоду("00000031087"));
	Запрос.УстановитьПараметр("ГрВиноРозлив",		Справочники.Номенклатура.НайтиПоКоду("00000003904"));
	
	//Подарочные сертификаты!
	Запрос.УстановитьПараметр("ВН_ПодарочныйСертификат",	Справочники.ВидыНоменклатуры.НайтиПоКоду("000000019"));
	
	//Контролировать номенклатуру
	Запрос.УстановитьПараметр("ИстекаетСрокГодности",		мПросроченныйТовар);
	
	СпНоменклатура  = Новый СписокЗначений;
	Выборка = Справочники.ИТИКонстанты.Выбрать(Справочники.ИТИКонстанты.НайтиПоНаименованию("Группы для выгрузки в кассы").Ссылка);
	Пока Выборка.Следующий() Цикл
		Если Не Выборка.ПометкаУдаления и ЗначениеЗаполнено(Выборка.Указатель) Тогда
			СпНоменклатура.Добавить(Выборка.Указатель);
		КонецЕсли;
	КонецЦикла;
	Запрос.УстановитьПараметр("СпНоменклатура", СпНоменклатура);
#КонецОбласти
	РезультатЗапроса=Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ПоказатьОповещениеПользователя("Список товаров для выгрузки пуст.");
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить();
КонецФункции

Функция ДополнитьТаблицуПодарочныемиСертификатами(ЗНАЧ Товары,ОбСклад)
	Запрос = Новый Запрос;
	//KAV++ Крапивин Андрей. 31.03.2015 16:05:50 #1187558 Добавим расчет объема
#Область Запрос
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВходТаблица.Номенклатура,
	               |	ВходТаблица.ПЛУ,
	               |	ВходТаблица.ЕдиницаИзмерения,
	               |	ВходТаблица.ЭтоГруппа,
	               |	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаНоменклатуры,
	               |	ВходТаблица.Комплект,
	               |	ВходТаблица.ВесовойТовар,
	               |	ВходТаблица.Остаток,
	               |	ВходТаблица.ГрСигареты,
	               |	ВходТаблица.ГрСигаретыБлоками,
	               |	ВходТаблица.ГрБутылки,
	               |	ВходТаблица.Кратность0,
	               |	ВходТаблица.Кратность05,
	               |	ЛОЖЬ КАК ЭтоПодарСерт,
	               |	ВходТаблица.КонтролироватьОстаток КАК КонтролироватьОстаток,
	               |	ВходТаблица.ФиксированныйБонус,
	               |	ВходТаблица.Бонус1,
	               |	ВходТаблица.Бонус2,
	               |	ВходТаблица.Бонус3,
	               |	ВходТаблица.КратностьТовара,
	               |	ВходТаблица.Объем
	               |ПОМЕСТИТЬ ПодготовленнаяТаблица
	               |ИЗ
	               |	&ВходТаблица КАК ВходТаблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура,
	               |	ВложенныйЗапрос.ПЛУ,
	               |	ВложенныйЗапрос.ЕдиницаИзмерения,
	               |	ВложенныйЗапрос.ЭтоГруппа,
	               |	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	               |	ВложенныйЗапрос.Комплект КАК Комплект,
	               |	ВложенныйЗапрос.ВесовойТовар,
	               |	ВложенныйЗапрос.Остаток,
	               |	ЛОЖЬ КАК ГрСигареты,
	               |	ЛОЖЬ КАК ГрСигаретыБлоками,
	               |	ЛОЖЬ КАК ГрБутылки,
	               |	ЛОЖЬ КАК Кратность0,
	               |	ЛОЖЬ КАК Кратность05,
	               |	ИСТИНА КАК ЭтоПодарСерт,
	               |	ЛОЖЬ КАК КонтролироватьОстаток,
	               |	ЕСТЬNULL(ЗначенияСвойствОбъектовФиксБонус.Значение, """") КАК ФиксированныйБонус,
	               |	ЕСТЬNULL(ЗначенияСвойствОбъектовКратность.Значение.Наименование, """") КАК КратностьТовара,
	               |	ВложенныйЗапрос.Объем,
	               |	"""" КАК Бонус1,
	               |	"""" КАК Бонус2,
	               |	"""" КАК Бонус3
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ТоварыВРозницеОстатки.Номенклатура.Ссылка КАК Номенклатура,
	               |		ТоварыВРозницеОстатки.Номенклатура.Код КАК ПЛУ,
	               |		ТоварыВРозницеОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	               |		ЛОЖЬ КАК ЭтоГруппа,
	               |		НЕОПРЕДЕЛЕНО КАК ХарактеристикаНоменклатуры,
	               |		ЛОЖЬ КАК Комплект,
	               |		ЛОЖЬ КАК ВесовойТовар,
	               |		ТоварыВРозницеОстатки.КоличествоОстаток КАК Остаток,
	               |		ТоварыВРозницеОстатки.Номенклатура.ЕдиницаХраненияОстатков.Объем КАК Объем
	               |	ИЗ
	               |		РегистрНакопления.ТоварыВРознице.Остатки(
	               |				,
	               |				Номенклатура.ВидНоменклатуры = &ВН_ПодарочныйСертификат
	               |					И Склад = &Склад) КАК ТоварыВРозницеОстатки) КАК ВложенныйЗапрос
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектовФиксБонус
	               |		ПО ВложенныйЗапрос.Номенклатура = ЗначенияСвойствОбъектовФиксБонус.Объект
	               |			И (ЗначенияСвойствОбъектовФиксБонус.Свойство = &ФиксированныйБонус)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектовКратность
	               |		ПО ВложенныйЗапрос.Номенклатура = ЗначенияСвойствОбъектовКратность.Объект
	               |			И (ЗначенияСвойствОбъектовКратность.Свойство = &КратностьВКассе)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ПодготовленнаяТаблица.Номенклатура,
	               |	ПодготовленнаяТаблица.ПЛУ,
	               |	ПодготовленнаяТаблица.ЕдиницаИзмерения,
	               |	ПодготовленнаяТаблица.ЭтоГруппа,
	               |	ПодготовленнаяТаблица.ХарактеристикаНоменклатуры,
	               |	ПодготовленнаяТаблица.Комплект,
	               |	ПодготовленнаяТаблица.ВесовойТовар,
	               |	ПодготовленнаяТаблица.Остаток,
	               |	ПодготовленнаяТаблица.ГрСигареты,
	               |	ПодготовленнаяТаблица.ГрСигаретыБлоками,
	               |	ПодготовленнаяТаблица.ГрБутылки,
	               |	ПодготовленнаяТаблица.Кратность0,
	               |	ПодготовленнаяТаблица.Кратность05,
	               |	ПодготовленнаяТаблица.ЭтоПодарСерт,
	               |	ПодготовленнаяТаблица.КонтролироватьОстаток,
	               |	ПодготовленнаяТаблица.ФиксированныйБонус,
	               |	ПодготовленнаяТаблица.КратностьТовара,
	               |	ПодготовленнаяТаблица.Объем,
	               |	ПодготовленнаяТаблица.Бонус1,
	               |	ПодготовленнаяТаблица.Бонус2,
	               |	ПодготовленнаяТаблица.Бонус3
	               |ИЗ
	               |	ПодготовленнаяТаблица КАК ПодготовленнаяТаблица";
#КонецОбласти

#Область Параметры_запроса
	//Подарочные сертификаты!
	Запрос.УстановитьПараметр("ВН_ПодарочныйСертификат",	Справочники.ВидыНоменклатуры.НайтиПоКоду("000000019"));
	Запрос.УстановитьПараметр("Склад",						ОбСклад);
	Запрос.УстановитьПараметр("ВходТаблица",				Товары);
	
	Запрос.УстановитьПараметр("ФиксированныйБонус",	ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("Фиксированный бонус"));
	Запрос.УстановитьПараметр("КратностьВКассе",	ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("Кратность товара в кассе"));
#КонецОбласти
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Функция ДополнитьТаблицуПросроченнымиТоварами(ЗНАЧ Товары,ОбСклад)
	Запрос = Новый Запрос;
	//KAV++ Крапивин Андрей. 31.03.2015 16:05:50 #1187558 Добавим расчет объема
#Область Запрос
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВходТаблица.Номенклатура,
	               |	ВходТаблица.ПЛУ,
	               |	ВходТаблица.ЕдиницаИзмерения,
	               |	ВходТаблица.ЭтоГруппа,
	               |	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаНоменклатуры,
	               |	ВходТаблица.Комплект,
	               |	ВходТаблица.ВесовойТовар,
	               |	ВходТаблица.Остаток,
	               |	ВходТаблица.ГрСигареты,
	               |	ВходТаблица.ГрСигаретыБлоками,
	               |	ВходТаблица.ГрБутылки,
	               |	ВходТаблица.Кратность0,
	               |	ВходТаблица.Кратность05,
	               |	ВходТаблица.ЭтоПодарСерт КАК ЭтоПодарСерт,
				   |	ВходТаблица.КонтролироватьОстаток КАК КонтролироватьОстаток,
	               |	ВходТаблица.ФиксированныйБонус,
	               |	ВходТаблица.Бонус1,
	               |	ВходТаблица.Бонус2,
	               |	ВходТаблица.Бонус3,
	               |	ВходТаблица.КратностьТовара,
	               |	ВходТаблица.Объем
	               |ПОМЕСТИТЬ ПодготовленнаяТаблица
	               |ИЗ
	               |	&ВходТаблица КАК ВходТаблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВложенныйЗапрос.Номенклатура,
	               |	ВложенныйЗапрос.ПЛУ,
	               |	ВложенныйЗапрос.ЕдиницаИзмерения,
	               |	ВложенныйЗапрос.ЭтоГруппа,
	               |	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
	               |	ВложенныйЗапрос.Комплект КАК Комплект,
	               |	ВложенныйЗапрос.ВесовойТовар КАК ВесовойТовар,
	               |	ВложенныйЗапрос.ГрСигареты КАК ГрСигареты,
	               |	ВложенныйЗапрос.ГрСигаретыБлоками КАК ГрСигаретыБлоками,
	               |	ВложенныйЗапрос.ГрБутылки КАК ГрБутылки,
	               |	ВложенныйЗапрос.Кратность0 КАК Кратность0,
	               |	ВложенныйЗапрос.Кратность05 КАК Кратность05,
	               |	ВложенныйЗапрос.ЭтоПодарСерт КАК ЭтоПодарСерт,
				   |	ВложенныйЗапрос.КонтролироватьОстаток КАК КонтролироватьОстаток,
	               |	ВложенныйЗапрос.ФиксированныйБонус КАК ФиксированныйБонус,
	               |	ВложенныйЗапрос.КратностьТовара КАК КратностьТовара,
	               |	ВложенныйЗапрос.Объем КАК Объем,
	               |	ВложенныйЗапрос.Бонус1 КАК Бонус1,
	               |	ВложенныйЗапрос.Бонус2 КАК Бонус2,
	               |	ВложенныйЗапрос.Бонус3 КАК Бонус3,
	               |	ВложенныйЗапрос.Остаток
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ПодготовленнаяТаблица.Номенклатура КАК Номенклатура,
	               |		ПодготовленнаяТаблица.ПЛУ КАК ПЛУ,
	               |		ПодготовленнаяТаблица.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |		ПодготовленнаяТаблица.ЭтоГруппа КАК ЭтоГруппа,
	               |		ПодготовленнаяТаблица.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	               |		ПодготовленнаяТаблица.Комплект КАК Комплект,
	               |		ПодготовленнаяТаблица.ВесовойТовар КАК ВесовойТовар,
	               |		ВЫБОР
	               |			КОГДА ТоварыВРозницеОстатки.КоличествоОстаток ЕСТЬ НЕ NULL 
	               |				ТОГДА ТоварыВРозницеОстатки.КоличествоОстаток
	               |			ИНАЧЕ ПодготовленнаяТаблица.Остаток
	               |		КОНЕЦ КАК Остаток,
	               |		ПодготовленнаяТаблица.ГрСигареты КАК ГрСигареты,
	               |		ПодготовленнаяТаблица.ГрСигаретыБлоками КАК ГрСигаретыБлоками,
	               |		ПодготовленнаяТаблица.ГрБутылки КАК ГрБутылки,
	               |		ПодготовленнаяТаблица.Кратность0 КАК Кратность0,
	               |		ПодготовленнаяТаблица.Кратность05 КАК Кратность05,
	               |		ПодготовленнаяТаблица.ЭтоПодарСерт КАК ЭтоПодарСерт,
				   |		ПодготовленнаяТаблица.КонтролироватьОстаток КАК КонтролироватьОстаток,
	               |		ПодготовленнаяТаблица.ФиксированныйБонус КАК ФиксированныйБонус,
	               |		ПодготовленнаяТаблица.КратностьТовара КАК КратностьТовара,
	               |		ПодготовленнаяТаблица.Объем КАК Объем,
	               |		ПодготовленнаяТаблица.Бонус1 КАК Бонус1,
	               |		ПодготовленнаяТаблица.Бонус2 КАК Бонус2,
	               |		ПодготовленнаяТаблица.Бонус3 КАК Бонус3
	               |	ИЗ
	               |		ПодготовленнаяТаблица КАК ПодготовленнаяТаблица
	               |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыВРознице.Остатки(
	               |					,
	               |					Номенклатура В
	               |							(ВЫБРАТЬ
	               |								КатегорииОбъектов.Объект
	               |							ИЗ
	               |								РегистрСведений.КатегорииОбъектов КАК КатегорииОбъектов
	               |							ГДЕ
	               |								КатегорииОбъектов.Категория = &ПросроченныйТовар)
	               |						И Склад = &Склад) КАК ТоварыВРозницеОстатки
	               |			ПО ПодготовленнаяТаблица.Номенклатура = ТоварыВРозницеОстатки.Номенклатура) КАК ВложенныйЗапрос";
#КонецОбласти

#Область Параметры_запроса
	//Подарочные сертификаты!
	Запрос.УстановитьПараметр("ПросроченныйТовар",	мПросроченныйТовар);
	Запрос.УстановитьПараметр("Склад",				ОбСклад);
	Запрос.УстановитьПараметр("ВходТаблица",		Товары);
#КонецОбласти
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции
	
Функция ПодготовитьТаблицуКВыгрузке(ЗНАЧ Товары,ОбСклад,КассаККМ) Экспорт
	//1. Дополним сертификатами
	ТоварыВозврта=ДополнитьТаблицуПодарочныемиСертификатами(Товары,ОбСклад);
	//2. Дополним просроченным товаром
	Если ЕстьПросрочка(ОбСклад) Тогда
		ТоварыВозврта=ДополнитьТаблицуПросроченнымиТоварами(ТоварыВозврта,ОбСклад);
	КонецЕсли;
	//3. Дополним ценами
	ТоварыВозврта.Колонки.Добавить("Цена");
	ТоварыВозврта.Колонки.Добавить("ЦенаНочь");
#Область Заполнение_цен
	СпНоменклатура  = ТоварыВозврта.ВыгрузитьКолонку("Номенклатура");
	//KAV++ Цены получим сразу
	ТаблицаЦенАТТ		= ПолучитьЦены(ОбСклад,СпНоменклатура);
	ТаблицаЦенДоп		= ПолучитьЦеныДОП(ОбСклад,СпНоменклатура);
	ТаблицаЦенДопНочь	= ПолучитьЦеныДОП(ОбСклад,СпНоменклатура,Истина);
	//KAV--
	//идет анализ цен
	
	Бонус1=ИТИИндустрияОбщийМодульКлиентСервер.ПринадлежитКатегории(КассаККМ,мКатегорияКассаБонус1);
	Бонус2=ИТИИндустрияОбщийМодульКлиентСервер.ПринадлежитКатегории(КассаККМ,мКатегорияКассаБонус2);
	Бонус3=ИТИИндустрияОбщийМодульКлиентСервер.ПринадлежитКатегории(КассаККМ,мКатегорияКассаБонус3);
	
	
	Колво=ТоварыВозврта.Количество();
	Сч=1;
	
	МассДляУдаления=Новый Массив;
	Для Каждого СтрокаТовара Из ТоварыВозврта Цикл
		Состояние("Подготовка данных для выгрузки",Окр(Сч/Колво)*100);
		
		Цена  = ПолучитьЦеныИзТаблицы(СтрокаТовара.Номенклатура,ТаблицаЦенАТТ);
		Если НЕ (СтрокаТовара.Комплект И АкционныйТоварБезЦен) Тогда//не акционный товар
			Если Цена=0 Тогда//цены АТТ нету
				Цена = ПолучитьЦеныИзТаблицы(СтрокаТовара.Номенклатура,ТаблицаЦенДоп);//смотрим дополнительную цену
				Если Цена=0 Тогда//цены нету и дополнительной
					МассДляУдаления.Добавить(СтрокаТовара);
					Продолжить;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		СтрокаТовара.Цена = Цена;
		Цена=ПолучитьЦеныИзТаблицы(СтрокаТовара.Номенклатура,ТаблицаЦенДопНочь);
		СтрокаТовара.ЦенаНочь=Цена;
		
		//Доп проверка. ПЛУ = ЧИСЛО
		Если НЕ ЭтоЧисло(СтрокаТовара.ПЛУ) Тогда
			Сообщить("Для номенклатуры "+СтрокаТовара.Номенклатура.Наименование+" задан не корректный код позиции """+СтрокаТовара.Номенклатура.Код+""". Позиция будет исключена из выгрузки",СтатусСообщения.Важное);
			МассДляУдаления.Добавить(СтрокаТовара);
			Продолжить;
		КонецЕсли;
			
		//09-07-2015 Переработка фиксированного бонуса.
		Если ЗначениеЗаполнено(СтрокаТовара.Бонус1) И Бонус1 Тогда
			СтрокаТовара.ФиксированныйБонус=Формат(СтрокаТовара.Бонус1,"ЧДЦ=2; ЧРД=.; ЧН=; ЧГ=")+"%";
		ИначеЕсли ЗначениеЗаполнено(СтрокаТовара.Бонус2) И Бонус2 Тогда
			СтрокаТовара.ФиксированныйБонус=Формат(СтрокаТовара.Бонус2,"ЧДЦ=2; ЧРД=.; ЧН=; ЧГ=")+"%";
		ИначеЕсли Бонус3 Тогда
			Если ЗначениеЗаполнено(СтрокаТовара.Бонус3) Тогда
				СтрокаТовара.ФиксированныйБонус=Формат(СтрокаТовара.Бонус3,"ЧДЦ=2; ЧРД=.; ЧН=; ЧГ=")+"%";
			Иначе
				СтрокаТовара.ФиксированныйБонус=РасчетБонусаПоИерархии(СтрокаТовара.Номенклатура,кеш);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;		
	ТоварыВозврта.Колонки.Удалить("Бонус1");
	ТоварыВозврта.Колонки.Удалить("Бонус2");
#КонецОбласти
	Состояние("Удаление товаров из выгрузки");
	Для Каждого Эл Из МассДляУдаления Цикл
		ТоварыВозврта.Удалить(Эл);
	КонецЦикла;
	Состояние("");
	Возврат ТоварыВозврта
КонецФункции

Функция ПолучитьЦеныИзТаблицы(Номенклатура,ТаблицаЦен)
	СтрЦен=ТаблицаЦен.Найти(Номенклатура,"Номенклатура");
	Если СтрЦен=Неопределено Тогда
		Цена=0;
	Иначе
		Цена=СтрЦен.Цена;
	КонецЕсли;
	Возврат Цена;
КонецФункции
#КонецОбласти

мПросроченныйТовар=Справочники.КатегорииОбъектов.НайтиПоКоду("000000189");

мКатегорияКассаБонус1=Справочники.КатегорииОбъектов.НайтиПоКоду("000000174");
мКатегорияКассаБонус2=Справочники.КатегорииОбъектов.НайтиПоКоду("000000175");
мКатегорияКассаБонус3=Справочники.КатегорииОбъектов.НайтиПоКоду("000000177");

мСвойствоНоменклатураБонус1=ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("000000069");
мСвойствоНоменклатураБонус2=ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("000000070");
мСвойствоНоменклатураБонус3=ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("000000075");

Кеш=ТаблицаДляБонуса3();
