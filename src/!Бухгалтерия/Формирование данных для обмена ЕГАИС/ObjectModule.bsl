﻿Функция ОпределитьНастройкиЕГАИС(ВхОрганизация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕГАИС_Настройки.FSRAR_ID КАК FSRAR_ID,
	|	ЕГАИС_Настройки.Ссылка КАК НастройкаЕГАИС
	|ИЗ
	|	Справочник.ЕГАИС_Настройки КАК ЕГАИС_Настройки
	|ГДЕ
	|	ЕГАИС_Настройки.Организация = &Организация
	|	И НЕ ЕГАИС_Настройки.ПометкаУдаления";
	Запрос.УстановитьПараметр("Организация",	ВхОрганизация);
	рез = Запрос.Выполнить().Выгрузить();
	Если рез.Количество()>0 Тогда
		Возврат рез[0];
	Иначе
		Возврат "";
	КонецЕсли;	
	
КонецФункции	

Функция ПолучитьНоменклатуруПоИД(ИД) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИД",ИД);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕГАИС_Номенклатура.Ссылка
	               |ИЗ
	               |	РегистрСведений.ЕГАИС_Номенклатура КАК ЕГАИС_Номенклатура
	               |ГДЕ
	               |	ЕГАИС_Номенклатура.AlcCode = &ИД";
	рез = Запрос.Выполнить().Выгрузить();
	Если рез.Количество()>0 Тогда
		Возврат рез[0].Ссылка;
	Иначе
		// отправим запрос
		Сообщить("Не найдена продукция с кодом:" + ИД + " в классификаторе продукции");
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции

Функция ПолучитьКонтрагентаПоИД(ИД, ТолькоНаименование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИД",ИД);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕГАИС_Контрагенты.Ссылка
	               |ИЗ
	               |	РегистрСведений.ЕГАИС_Контрагенты КАК ЕГАИС_Контрагенты
	               |ГДЕ
	               |	ЕГАИС_Контрагенты.ClientRegId = &ИД";
	рез = Запрос.Выполнить().Выгрузить();
	Если рез.Количество()>0 Тогда
		Возврат рез[0].Ссылка;
		Если ТолькоНаименование Тогда
			Возврат рез[0].Ссылка.Наименование;
		Иначе
			Возврат рез[0].Ссылка;
		КонецЕсли;
	Иначе
		// отправим запрос
		Сообщить("Не найден контрагент с кодом:" + ИД + " в классификаторе контрагентов");
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции

Функция ПолучитьПараметрыЕГАИСДляНоменклатуры(Номенклатура, ТолькоИД) Экспорт
	
	//KAV++
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕГАИС_РазныеЕмкостиДляКодаАП.КодАП
	               |ИЗ
	               |	РегистрСведений.ЕГАИС_РазныеЕмкостиДляКодаАП КАК ЕГАИС_РазныеЕмкостиДляКодаАП
	               |ГДЕ
	               |	ЕГАИС_РазныеЕмкостиДляКодаАП.Номенклатура = &Номенклатура";
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	рез = Запрос.Выполнить().Выгрузить();
	Если Рез.Количество()>0 Тогда
		Если ТолькоИД Тогда
			Возврат Рез[0].КодАП;
		Иначе
			Запрос.Текст = "ВЫБРАТЬ
	               |	ЕГАИС_Номенклатура.FullName,
	               |	ЕГАИС_Номенклатура.ShortName,
	               |	ЕГАИС_Номенклатура.ProductVCode,
	               |	ЕГАИС_Номенклатура.Capacity,
	               |	ЕГАИС_Номенклатура.AlcVolume,
				   |    ЕГАИС_Номенклатура.AlcCode,
	               |	ЕГАИС_Номенклатура.Producer,
				   |    ЕГАИС_Номенклатура.Importer,
	               |	ЕГАИС_Номенклатура.Ссылка
	               |ИЗ
	               |	РегистрСведений.ЕГАИС_Номенклатура КАК ЕГАИС_Номенклатура
	               |ГДЕ
	               |	ЕГАИС_Номенклатура.AlcCode = &КодАП";
			Запрос.УстановитьПараметр("КодАП",Рез[0].КодАП);
			Рез=Запрос.Выполнить().Выгрузить();
			Если Рез.Количество()>0 Тогда
				Возврат Рез[0];
			Иначе
				Сообщить("Не найдена продукция:" + Номенклатура + " в классификаторе продукции");
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	//KAV--
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура",Номенклатура);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕГАИС_Номенклатура.FullName,
	               |	ЕГАИС_Номенклатура.ShortName,
	               |	ЕГАИС_Номенклатура.ProductVCode,
	               |	ЕГАИС_Номенклатура.Capacity,
	               |	ЕГАИС_Номенклатура.AlcVolume,
				   |    ЕГАИС_Номенклатура.AlcCode,
	               |	ЕГАИС_Номенклатура.Producer,
				   |    ЕГАИС_Номенклатура.Importer,
	               |	ЕГАИС_Номенклатура.Ссылка
	               |ИЗ
	               |	РегистрСведений.ЕГАИС_Номенклатура КАК ЕГАИС_Номенклатура
	               |ГДЕ
	               |	ЕГАИС_Номенклатура.Ссылка = &Номенклатура";
	рез = Запрос.Выполнить().Выгрузить();
	Если рез.Количество()>0 Тогда
		Если ТолькоИД Тогда
			Возврат рез[0].AlcCode;
		Иначе
			Возврат рез[0];
		КонецЕсли;
	Иначе
		// отправим запрос
		Сообщить("Не найдена продукция:" + Номенклатура + " в классификаторе продукции");
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции

Функция ПолучитьПараметрыЕГАИСДляКонтрагента(Контрагент, ТолькоИД) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕГАИС_Контрагенты.ClientRegId,
	               |	ЕГАИС_Контрагенты.FullName,
	               |	ЕГАИС_Контрагенты.ShortName,
	               |	ЕГАИС_Контрагенты.INN,
	               |	ЕГАИС_Контрагенты.KPP,
	               |	ЕГАИС_Контрагенты.Country,
				   |    ЕГАИС_Контрагенты.RegionCode,
				   |    ЕГАИС_Контрагенты.description,
	               |	ЕГАИС_Контрагенты.Ссылка
	               |ИЗ
	               |	РегистрСведений.ЕГАИС_Контрагенты КАК ЕГАИС_Контрагенты
	               |ГДЕ
	               |	ЕГАИС_Контрагенты.Ссылка = &Контрагент";
	рез = Запрос.Выполнить().Выгрузить();
	Если рез.Количество()>0 Тогда
		Если ТолькоИД Тогда
			Возврат рез[0].ClientRegId;
		Иначе
			Возврат рез[0];
		КонецЕсли;
	Иначе
		// отправим запрос
		Сообщить("Не найден контрагент:" + Контрагент + " в классификаторе контрагентов");
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции


Функция НайтиДоговорПоИмени(Контрагент, Организация, Вид, Имячко) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ДоговорыКонтрагентов.Ссылка КАК Договор
	               |ИЗ
	               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	               |ГДЕ
	               |	ДоговорыКонтрагентов.Организация = &Организация
	               |	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора
	               |	И ДоговорыКонтрагентов.Владелец = &Контрагент
	               |	И ДоговорыКонтрагентов.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("Контрагент",   Контрагент);
	Запрос.УстановитьПараметр("ВидДоговора",  Вид);
	Запрос.УстановитьПараметр("Наименование", Имячко);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать(); 
		Выборка.Следующий();
		Возврат Выборка.Договор.Ссылка;
	
КонецФункции

Функция НайтиЭлементСправочника(ЗначениеРеквизита, ВидСпр, ИмяРеквизита, ВидРеквизита) Экспорт
	
	Если Найти(ВидСпр, "Справочники.")<>0 Тогда
		ВидСпр = СтрЗаменить(ВидСпр, "Справочники.", "");
	КонецЕсли;
	
	Если ВидРеквизита = "ОснРеквизиты" Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТекСправочник.Ссылка КАК ТекСсылка
		|ИЗ
		|	Справочник." + ВидСпр + " КАК ТекСправочник
		|ГДЕ
		|	Ссылка." + ИмяРеквизита + "= &ЗначениеРеквизита";
		
		Запрос.УстановитьПараметр("ЗначениеРеквизита", ЗначениеРеквизита);
		Результат = Запрос.Выполнить().Выбрать();
		
		Пока Результат.Следующий() Цикл
			Возврат Результат.ТекСсылка;
			Прервать;
		КонецЦикла;
		
	ИначеЕсли ВидРеквизита = "Свойства" Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗначенияСвойствОбъектов.Объект
		|ИЗ
		|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектов
		|			ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов КАК НазначенияСвойствКатегорийОбъектов
		|			ПО СвойстваОбъектов.НазначениеСвойства = НазначенияСвойствКатегорийОбъектов.Ссылка
		|		ПО ЗначенияСвойствОбъектов.Свойство = СвойстваОбъектов.Ссылка
		|ГДЕ
		|	СвойстваОбъектов.Наименование = &ТекРеквизит
	 	|	И ЗначенияСвойствОбъектов.Значение.Наименование = &ЗначениеРеквизита
		|	И НазначенияСвойствКатегорийОбъектов.Ссылка.Наименование = &ТекВидСпр";
		
		Запрос.УстановитьПараметр("ТекРеквизит", ИмяРеквизита);
		Запрос.УстановитьПараметр("ЗначениеРеквизита", ЗначениеРеквизита);
		Если ВидСпр = "Контрагенты" Тогда
			Запрос.УстановитьПараметр("ТекВидСпр", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты.Наименование);
		ИначеЕсли ВидСпр = "Организации" Тогда
			Запрос.УстановитьПараметр("ТекВидСпр", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Организации.Наименование);
		ИначеЕсли ВидСпр = "Склады" Тогда
			Запрос.УстановитьПараметр("ТекВидСпр", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Склады.Наименование);
		ИначеЕсли ВидСпр = "Номенклатура" Тогда
			Запрос.УстановитьПараметр("ТекВидСпр", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура.Наименование);
		КонецЕсли;	
			
		Результат = Запрос.Выполнить().Выбрать();
		
		Пока Результат.Следующий() Цикл
			Сообщить(Результат.Объект.Наименование);
			Возврат Результат.Объект;
			Прервать;
		КонецЦикла;
	КонецЕсли;
	
КонецФункции

Функция ОпределитьСвойствоПоЭлементуСправочника(ТекОбъект, ВидСпр, ИмяРеквизита) Экспорт
	
	
	Если Найти(ВидСпр, "Справочники.")<>0 Тогда
		ВидСпр = СтрЗаменить(ВидСпр, "Справочники.", "");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗначенияСвойствОбъектов.Значение КАК ЗначениеСвойства
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектов
	|			ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов КАК НазначенияСвойствКатегорийОбъектов
	|			ПО СвойстваОбъектов.НазначениеСвойства = НазначенияСвойствКатегорийОбъектов.Ссылка
	|		ПО ЗначенияСвойствОбъектов.Свойство = СвойстваОбъектов.Ссылка
	|ГДЕ
	|	СвойстваОбъектов.Наименование = &ТекРеквизит
 	|	И ЗначенияСвойствОбъектов.Объект = &ТекОбъект
	|	И НазначенияСвойствКатегорийОбъектов.Ссылка.Наименование = &ТекВидСпр";
	
	Запрос.УстановитьПараметр("ТекРеквизит", ИмяРеквизита);
	Запрос.УстановитьПараметр("ТекОбъект", ТекОбъект);
	Если ВидСпр = "Контрагенты" Тогда
		Запрос.УстановитьПараметр("ТекВидСпр", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты.Наименование);
	ИначеЕсли ВидСпр = "Организации" Тогда
		Запрос.УстановитьПараметр("ТекВидСпр", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Организации.Наименование);
	ИначеЕсли ВидСпр = "Склады" Тогда
		Запрос.УстановитьПараметр("ТекВидСпр", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Склады.Наименование);
	ИначеЕсли ВидСпр = "Номенклатура" Тогда
		Запрос.УстановитьПараметр("ТекВидСпр", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура.Наименование);
	КонецЕсли;	
		
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		Возврат Результат.ЗначениеСвойства.Наименование;
		Прервать;
	КонецЦикла;

КонецФункции

Функция СформироватьПараметрыЕГАИС(СтрокаДанных) Экспорт
	
	ПараметрыАП = "НачПарамЕГАИС"			+
	              СтрокаДанных.КодАП_ЕГАИС	+ "," +
	              СтрокаДанных.Справка_А	+ "," +
	              СтрокаДанных.Справка_Б	+
				  "КонПарамЕГАИС";
				  
	Возврат ПараметрыАП;
	
КонецФункции

Функция СоздатьНовуюСериюНоменклатуры(ПараметрыЕГАИС, Номенклатура, НаименованиеНовойСерии) Экспорт
	
	СерияТМЦ              = Справочники.СерииНоменклатуры.СоздатьЭлемент();
	СерияТМЦ.Наименование = НаименованиеНовойСерии;
	СерияТМЦ.Владелец     = Номенклатура; 
	СерияТМЦ.Комментарий  = ПараметрыЕГАИС;
	//Крапивин. Добавить запись в регистр сведений Справки А и Б.
	
	СерияТМЦ.Записать();
	
	Возврат СерияТМЦ.Ссылка;
	
КонецФункции

Функция НайтиСериюНоменклатуры(ПараметрыЕГАИС, Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СерииНоменклатуры.Ссылка КАК СерияТМЦ
	|ИЗ
	|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|ГДЕ
	|	СерииНоменклатуры.Владелец = &Номенклатура
	|	И СерииНоменклатуры.ПометкаУдаления = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка УБЫВ";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Выборка = Запрос.Выполнить().Выбрать();
	НужнаяСерияТМЦ = неопределено;
	Пока Выборка.Следующий() Цикл
		Если Найти(Выборка.СерияТМЦ.Комментарий, ПараметрыЕГАИС)<>0 Тогда
			НужнаяСерияТМЦ = Выборка.СерияТМЦ;	
		КонецЕсли;
	КонецЦикла;
	
	Возврат НужнаяСерияТМЦ;
	
КонецФункции

Функция ПроверитьСериюНоменклатуры(СерияТМЦ, ПараметрыЕГАИС, Номенклатура, НаименованиеНовойСерии) Экспорт
	
	Если Найти(СерияТМЦ.Комментарий, "НачПарамЕГАИС")<>0 и Найти(СерияТМЦ.Комментарий, "КонПарамЕГАИС")<>0 Тогда
		Если Найти(СерияТМЦ.Комментарий, ПараметрыЕГАИС)=0 Тогда
			ДругаяСерияТМЦ = НайтиСериюНоменклатуры(ПараметрыЕГАИС, Номенклатура);
			Если ДругаяСерияТМЦ = неопределено Тогда //Используем текущую
				Об=СерияТМЦ.ПолучитьОбъект();
				Об.Комментарий=ПараметрыЕГАИС;
				Об.Записать();
				ОбщегоНазначения.СообщитьИнформациюПользователю("Для серии "+Строка(СерияТМЦ)+" обновлены параметры ЕГАИС");
			Иначе
				ОбщегоНазначения.СообщитьИнформациюПользователю("Возможно некорректно указана серия "+Строка(СерияТМЦ)+" для "+Строка(Номенклатура)+". Есть уже серия с подобными параметрами");
			КонецЕсли;
		КонецЕсли;
	Иначе
	    ТекСерияТМЦ_Об             = СерияТМЦ.ПолучитьОбъект();
		ТекСерияТМЦ_Об.Комментарий = ТекСерияТМЦ_Об.Комментарий + " " + ПараметрыЕГАИС;
		ТекСерияТМЦ_Об.Записать();
		ОбщегоНазначения.СообщитьИнформациюПользователю("Для серии "+Строка(СерияТМЦ)+" обновлены параметры ЕГАИС");
	КонецЕсли;
КонецФункции
									
Функция ПривестиНомерНаПечать(Номер) Экспорт
	ТемпНомер=Номер;
	Если ЗначениеЗаполнено(ТемпНомер) Тогда
		Пока НЕ ((Лев(ТемпНомер,1)>="1" И Лев(ТемпНомер,1)<="9")) Цикл
			ТемпНомер=Сред(ТемпНомер,2);
		КонецЦикла;
		Возврат ТемпНомер;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция ПрочитатьПоступление(ТТН_Прих) Экспорт
	Таб=Новый ТаблицаЗначений;
	Таб.Колонки.Добавить("Номенклатура",	Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Таб.Колонки.Добавить("Справка_А",		Новый ОписаниеТипов("Строка"));
	Таб.Колонки.Добавить("Справка_Б",		Новый ОписаниеТипов("Строка"));
	Таб.Колонки.Добавить("КодАП_ЕГАИС",		Новый ОписаниеТипов("Строка"));
	Таб.Колонки.Добавить("Количество",		Новый ОписаниеТипов("Число"));
	Таб.Колонки.Добавить("Цена",			Новый ОписаниеТипов("Число"));
	
	Для Каждого СтрокаТЧ ИЗ ТТН_Прих.Товары Цикл
		НоваяСтрока=Таб.Добавить();
		Если ЗначениеЗаполнено(СтрокаТЧ.СпрНоменклатура) Тогда
			НоваяСтрока.Номенклатура=СтрокаТЧ.СпрНоменклатура;
		Иначе
			Сп=ЕГАИС_ИТИ.ПолучитьСписокНоменклатурыПоКодуАП(СтрокаТЧ.КодАП_ЕГАИС);
			Если Сп.Количество() Тогда
				НоваяСтрока.Номенклатура=Сп[0].Значение.СпрНоменклатура;
			Иначе
				НоваяСтрока.Номенклатура=Справочники.Номенклатура.ПустаяСсылка()
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока.КодАП_ЕГАИС		= СтрокаТЧ.КодАП_ЕГАИС;
		НоваяСтрока.Справка_А		= СтрокаТЧ.СПР_А;
		НоваяСтрока.Справка_Б		= СтрокаТЧ.СПР_Б;
		НоваяСтрока.Количество		= СтрокаТЧ.Количество*?(СтрокаТЧ.Емкость=0,10,1);
		НоваяСтрока.Цена			= СтрокаТЧ.Цена;
	КонецЦикла;
	
	Возврат Таб;
КонецФункции

Процедура СопоставитьТаблицуДокументаИТаблицуЕГАИС(СсылкаНаДокумент,ТоварыЕГАИС,НаклЕГАИС,РеквизитСерии="СерияНоменклатуры") Экспорт
	Об=СсылкаНаДокумент.ПолучитьОбъект();
	ТоварыУчет=Об.Товары;
	КопияДляСверки=СсылкаНаДокумент.Товары.Выгрузить();
	КопияДляСверки.Колонки.Добавить("Спр_А",Новый ОписаниеТипов("Строка"));
	КопияДляСверки.Колонки.Добавить("Спр_Б",Новый ОписаниеТипов("Строка"));
	
	//ДопИнфо=Новый Структура("Заголовок,НомерДок,ДатаДок,ДатаРозлива","По ТТН вх. ЕГАИС",СсылкаНаДокумент.Номер,Формат(СсылкаНаДокумент.Дата,"DT"));
	ДопИнфо=Новый Структура("НазваниеНовойСерии,ДатаРозлива","("+Формат(НаклЕГАИС.ДатаТТН,"ДФ=yyyy-MM-dd")+")/"+НаклЕГАИС.ТТН+" от "+Формат(НаклЕГАИС.ДатаТТН,"ДФ=dd.MM.yyyy")+"("+НаклЕГАИС.Получатель+")",);
	
	Для Каждого СтрокаТЧ Из КопияДляСверки Цикл
		ЗаполнитьЗначенияСвойств(СтрокаТЧ,ЕГАИС_ИТИ.ПолучитьСправкиНоменклатуры(СсылкаНаДокумент.Организация,Неопределено,СтрокаТЧ[РеквизитСерии]));
	КонецЦикла;
	Для Каждого СтрокаЕГАИС Из ТоварыЕГАИС Цикл
		Отбор=Новый Структура("Номенклатура,Количество,Спр_А",СтрокаЕГАИС.Номенклатура,СтрокаЕГАИС.Количество,СтрокаЕГАИС.Справка_А);
		Рез=КопияДляСверки.НайтиСтроки(Отбор);
		ПараметрыЕГАИС=СформироватьПараметрыЕГАИС(СтрокаЕГАИС);
		Если Рез.Количество()=0 Тогда //Нет такой строки в документе
			//Поищем отдельно без справки. Может надо будет создать серия...
			Отбор=Новый Структура("Номенклатура,Количество",СтрокаЕГАИС.Номенклатура,СтрокаЕГАИС.Количество);
			Рез=КопияДляСверки.НайтиСтроки(Отбор);
			Если Рез.Количество()=0 Тогда //тогда точно нифига нет
				СтрокаНовая=ТоварыУчет.Добавить();
				СтрокаНовая.Номенклатура		= СтрокаЕГАИС.Номенклатура;
				СтрокаНовая.Количество			= СтрокаЕГАИС.Количество;
				СтрокаНовая[РеквизитСерии]		= ЕГАИС_ИТИ.ПолучитьСериюНоменклатурыЕГАИС(СтрокаЕГАИС.Номенклатура,СтрокаЕГАИС.Справка_А,СтрокаЕГАИС.Справка_Б,Истина,ДопИнфо,'00010101');
				ОбщегоНазначения.СообщитьИнформациюПользователю("Добавлена новая строка "+СтрокаНовая.НомерСтроки+"! В ней не будет заполнена Дата розлива");
				ПроверитьСериюНоменклатуры(СтрокаНовая[РеквизитСерии],ПараметрыЕГАИС,СтрокаЕГАИС.Номенклатура,"");
				СтрокаНовая.Цена				= СтрокаЕГАИС.Цена;
				ОбработкаТабличныхЧастей.ПриИзмененииНоменклатурыТабЧасти(СтрокаНовая,	Об);
				ОбработкаТабличныхЧастей.ЗаполнитьСтавкуНДСТабЧасти(СтрокаНовая,		Об); 
				ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(СтрокаНовая,			Об);
				ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти(СтрокаНовая,		Об);
			
				Об.ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл(СтрокаНовая, "Товары", Истина, Истина);
				ЗаписаитьДанныеОСправкахСерии(СсылкаНаДокумент.Организация,СтрокаЕГАИС.Номенклатура,СтрокаНовая[РеквизитСерии],СтрокаЕГАИС.Справка_А,СтрокаЕГАИС.Справка_Б,СсылкаНаДокумент);
			Иначе
				СтрокаНовая=ТоварыУчет[Рез[0].НомерСтроки-1];
				Если НЕ ЗначениеЗаполнено(СтрокаНовая[РеквизитСерии]) Тогда
					СтрокаНовая[РеквизитСерии]	= ЕГАИС_ИТИ.ПолучитьСериюНоменклатурыЕГАИС(СтрокаЕГАИС.Номенклатура,СтрокаЕГАИС.Справка_А,СтрокаЕГАИС.Справка_Б,Истина,ДопИнфо,СтрокаНовая.ДатаРозлива);
				КонецЕсли;
				ПроверитьСериюНоменклатуры(СтрокаНовая[РеквизитСерии],ПараметрыЕГАИС,СтрокаЕГАИС.Номенклатура,"");
				//ЗаписаитьДанныеОСправкахСерии(СсылкаНаДокумент.Организация,СтрокаЕГАИС.Номенклатура,СтрокаНовая.СерияНоменклатуры,СтрокаЕГАИС.Справка_А,СтрокаЕГАИС.Справка_Б,СсылкаНаДокумент);
				КопияДляСверки.Удалить(Рез[0]);
			КонецЕсли;
		Иначе
			СтрокаНовая=ТоварыУчет[Рез[0].НомерСтроки-1];
			ПроверитьСериюНоменклатуры(СтрокаНовая[РеквизитСерии],ПараметрыЕГАИС,СтрокаЕГАИС.Номенклатура,"");
			//ЗаписаитьДанныеОСправкахСерии(СсылкаНаДокумент.Организация,СтрокаЕГАИС.Номенклатура,СтрокаНовая.СерияНоменклатуры,СтрокаЕГАИС.Справка_А,СтрокаЕГАИС.Справка_Б,СсылкаНаДокумент);
			КопияДляСверки.Удалить(Рез[0]);
		КонецЕсли;
	КонецЦикла;	
	Если Об.Модифицированность() Тогда
		Об.Записать();
	КонецЕсли;
КонецПроцедуры

Процедура ЗаписаитьДанныеОСправкахСерии(Организация,Номенклатура,СерияНоменклатуры,СправкаА,СправкаБ,Документ)
	Набор=РегистрыСведений.ЕГАИС_СправкиАиБ.СоздатьНаборЗаписей();
	Набор.Отбор.Регистратор.Установить(Документ);
	Набор.Прочитать();
	Стр=Новый Структура("Организация,Номенклатура,СерияНоменклатуры,СправкаА,СправкаБ",Организация,Номенклатура,СерияНоменклатуры,СправкаА,СправкаБ);
	Если Набор.Выгрузить().НайтиСтроки(Стр).Количество()=0 Тогда	
		Запись=Набор.Добавить();
		Запись.Номенклатура=Номенклатура;
		Запись.Организация=Организация;
		Запись.Период=Документ.Дата;
		Запись.Регистратор=Документ;
		Запись.СерияНоменклатуры=СерияНоменклатуры;
		Запись.СправкаА=СправкаА;
		Запись.СправкаБ=СправкаБ;
		Набор.Записать();
	КонецЕсли;
КонецПроцедуры

//Андрей
