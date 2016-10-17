﻿////////////////////////////////////////////////////////////////////////////////////////////

Процедура ПроверитьЗаполнениеРеквизитов(ОписаниеОшибки, Отказ) 
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) ИЛИ 
		 НЕ ЗначениеЗаполнено(КонецПериода) ИЛИ
		 КонецПериода < НачалоПериода Тогда
		СформироватьОписаниеОшибки(ОписаниеОшибки, "Неверно заполнен период");
		
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Склад) Тогда
		СформироватьОписаниеОшибки(ОписаниеОшибки, "Поле ""Склад"" не заполнено");
		
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗагрузитьОтчетОРозничныхПродажах И
		 НЕ ЗагрузитьТребованиеНакладную Тогда
		СформироватьОписаниеОшибки(ОписаниеОшибки, "Не выбрано действие для обмена");
		
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьОписаниеОшибки(ОписаниеОшибки, ТекстОшибки) 
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОписаниеОшибки = ОписаниеОшибки + Символы.ПС;
	КонецЕсли;
	
	ОписаниеОшибки = ОписаниеОшибки + ТекстОшибки + "!";
	
КонецПроцедуры

Функция ПолучитьКассуККМ(Склад) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ ПЕРВЫЕ 1 
		|	Кассы.Ссылка КАК Касса 
		|ИЗ 
		|	Справочник.КассыККМ КАК Кассы 
		|ГДЕ 
		|	Кассы.Склад = &Склад
		|";
	Запрос.УстановитьПараметр("Склад", Склад);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Результат = Неопределено;
	Иначе
		Выборка.Следующий();
		
		Результат = Выборка.Касса;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьДоговорЭквайринга(Организация) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДоговорыЭквайринга.Ссылка КАК ДоговорыЭквайринга
		|ИЗ
		|	Справочник.ДоговорыЭквайринга КАК ДоговорыЭквайринга
		|ГДЕ
		|	ДоговорыЭквайринга.ДоговорВзаиморасчетов.Организация = &Организация
		|";
	Запрос.УстановитьПараметр("Организация", Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Выборка.Следующий();
		
		Возврат Выборка.ДоговорыЭквайринга;
	КонецЕсли;
	
КонецФункции

Функция НайтиНоменклатуру(Код) 
	
	Если ЗначениеЗаполнено(Код) Тогда
		Номенклатура = Справочники.Номенклатура.НайтиПоКоду(Код);
		
		Если (НЕ ЗначениеЗаполнено(Номенклатура)) ИЛИ (Номенклатура = Неопределено) ИЛИ (Номенклатура = Справочники.Номенклатура.ПустаяСсылка()) Тогда
			Номенклатура = НайтиСопоставлениеНоменклатуры(Код);
		КонецЕсли;
	Иначе
		Номенклатура = Неопределено;
	КонецЕсли;
	
	Возврат Номенклатура;
	
КонецФункции

Функция НайтиСопоставлениеНоменклатуры(Код) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СопоставлениеНоменклатуры.Номенклатура КАК Номенклатура
		|ИЗ
		|	РегистрСведений.СопоставлениеНоменклатуры КАК СопоставлениеНоменклатуры
		|ГДЕ
		|	СопоставлениеНоменклатуры.Код ПОДОБНО &Код
		|";
	Запрос.УстановитьПараметр("Код", Код);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Результат = Неопределено;
	Иначе
		Выборка.Следующий();
		
		Результат = Выборка.Номенклатура;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура РаспределитьСуммуНабора(ОтчетОРозничныхПродажах) 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	НаборыТоваров.Номенклатура КАК Номенклатура,
		|	НаборыТоваров.НомерСтроки КАК НомерСтроки,
		|	НаборыТоваров.Сумма КАК Сумма
		|ПОМЕСТИТЬ 
		|	ВТ_НаборыТоваров
		|ИЗ
		|	&НаборыТоваров КАК НаборыТоваров ;
		////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.КлючСвязиНаборыТоваров КАК КлючСвязиНаборыТоваров,
		|	Товары.Количество КАК Количество,
		|	Товары.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ 
		|	ВТ_Товары
		|ИЗ
		|	&Товары КАК Товары ;
		////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
		|	ЦеныНоменклатуры.Цена КАК Цена
		|ПОМЕСТИТЬ 
		|	ВТ_Себестоимость
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаДокумента, ТипЦен = &ТипЦен И Номенклатура В ( 
			|ВЫБРАТЬ
			|	ВТ_Товары.Номенклатура
			|ИЗ
			|	ВТ_Товары КАК ВТ_Товары) ) КАК ЦеныНоменклатуры ;
		////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Запрос.КлючСвязиНаборыТоваров КАК КлючСвязиНаборыТоваров,
		|	СУММА(Запрос.Количество) КАК Количество,
		|	СУММА(Запрос.Себестоимость * Запрос.Количество) КАК Себестоимость
		|ПОМЕСТИТЬ 
		|	ВТ_ТоварыОбщая
		|ИЗ (
			|ВЫБРАТЬ
			|	ВТ_Товары.КлючСвязиНаборыТоваров КАК КлючСвязиНаборыТоваров,
			|	ВТ_Товары.Количество КАК Количество,
			|	ЕСТЬNULL(ВТ_Себестоимость.Цена, 0) КАК Себестоимость
			|ИЗ
			|	ВТ_Товары КАК ВТ_Товары
			|ЛЕВОЕ СОЕДИНЕНИЕ 
			|	ВТ_Себестоимость КАК ВТ_Себестоимость
			|	ПО ВТ_Товары.Номенклатура = ВТ_Себестоимость.Номенклатура
			|ГДЕ
			|	ВТ_Товары.КлючСвязиНаборыТоваров <> 0 ) КАК Запрос
		|СГРУППИРОВАТЬ ПО
		|	Запрос.КлючСвязиНаборыТоваров ;
		////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Товары.НомерСтроки КАК НомерСтроки,
		|	ВТ_НаборыТоваров.Сумма КАК СуммаНабор,
		|	ВТ_НаборыТоваров.НомерСтроки КАК НомерНабора,
		|	ВТ_ТоварыОбщая.Количество КАК КоличествоОбщее,
		|	ВТ_ТоварыОбщая.Себестоимость КАК СебестоимостьОбщая,
		|	ЕСТЬNULL(ВТ_Себестоимость.Цена, 0.01) КАК Себестоимость
		|ИЗ
		|	ВТ_Товары КАК ВТ_Товары
		|ЛЕВОЕ СОЕДИНЕНИЕ 
		|	ВТ_НаборыТоваров КАК ВТ_НаборыТоваров
		|	ПО ВТ_Товары.КлючСвязиНаборыТоваров = ВТ_НаборыТоваров.НомерСтроки
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	ВТ_ТоварыОбщая КАК ВТ_ТоварыОбщая
		|	ПО ВТ_Товары.КлючСвязиНаборыТоваров = ВТ_ТоварыОбщая.КлючСвязиНаборыТоваров
		|ЛЕВОЕ СОЕДИНЕНИЕ 
		|	ВТ_Себестоимость КАК ВТ_Себестоимость
		|	ПО ВТ_Товары.Номенклатура = ВТ_Себестоимость.Номенклатура
		|ГДЕ
		|	ВТ_Товары.КлючСвязиНаборыТоваров <> 0
		|ИТОГИ
		|	МАКСИМУМ(СуммаНабор),
		|	МАКСИМУМ(КоличествоОбщее),
		|	МАКСИМУМ(СебестоимостьОбщая)
		|	ПО НомерНабора
		|";
	Запрос.УстановитьПараметр("Товары", 	   ОтчетОРозничныхПродажах.Товары.Выгрузить());
	Запрос.УстановитьПараметр("НаборыТоваров", ОтчетОРозничныхПродажах.НаборыТоваров.Выгрузить());
	Запрос.УстановитьПараметр("ТипЦен", 	   Справочники.ТипыЦенНоменклатуры.НайтиПоКоду("000000070"));
	Запрос.УстановитьПараметр("ДатаДокумента", ОтчетОРозничныхПродажах.Дата);
	Результат = Запрос.Выполнить();
		
	ВыборкаНабор = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Пока ВыборкаНабор.Следующий() Цикл
		МаксимальнаяСумма  = 0;
		МаксимальнаяСтрока = 0;
		ИтоговаяСумма	   = 0;
		
		Если ВыборкаНабор.СуммаНабор = 0 Тогда
			Продолжить;
		КонецЕсли;
				
		Выборка = ВыборкаНабор.Выбрать();
		
		Пока Выборка.Следующий() Цикл			
			СтрокаТабличнойЧасти = ОтчетОРозничныхПродажах.Товары[Выборка.НомерСтроки - 1];	
						
			СебестоимостьОбщая = ВыборкаНабор.СебестоимостьОбщая;
			Себестоимость 	   = Выборка.Себестоимость * СтрокаТабличнойЧасти.Количество;
						
			Если СебестоимостьОбщая = 0 ИЛИ Себестоимость = 0 Тогда
				Доля = 0;
			Иначе
				Доля = Себестоимость / СебестоимостьОбщая * 100;
			КонецЕсли;
			
			Сумма = Окр(ВыборкаНабор.СуммаНабор / 100 * Доля, 2);
						
			СтрокаТабличнойЧасти.Цена  = ?(СтрокаТабличнойЧасти.Количество = 0 ИЛИ Сумма = 0, 0, Сумма / СтрокаТабличнойЧасти.Количество);
			СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.Количество;
			СтрокаТабличнойЧасти.Сумма = ?(СтрокаТабличнойЧасти.Сумма < 0.01, 0.01, СтрокаТабличнойЧасти.Сумма);
			
			ИтоговаяСумма = ИтоговаяСумма + СтрокаТабличнойЧасти.Сумма; 
			
			Если СтрокаТабличнойЧасти.Сумма > МаксимальнаяСумма Тогда
				МаксимальнаяСумма  = СтрокаТабличнойЧасти.Сумма;
				МаксимальнаяСтрока = СтрокаТабличнойЧасти.НомерСтроки - 1; // индекс
			КонецЕсли;
		КонецЦикла;
				
		Если ИтоговаяСумма <> ВыборкаНабор.СуммаНабор И МаксимальнаяСтрока > 0 Тогда			
			СтрокаТабличнойЧасти = ОтчетОРозничныхПродажах.Товары[МаксимальнаяСтрока];			
			СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Сумма + Окр((ВыборкаНабор.СуммаНабор - ИтоговаяСумма), 2);
		КонецЕсли;
	КонецЦикла
		
КонецПроцедуры

Процедура РаспределитьСуммуБонусов(ОтчетОРозничныхПродажах, СуммаОплатыБонусами) 
	
	ОбщаяСумма = ОтчетОРозничныхПродажах.НаборыТоваров.Итог("Сумма");
	
	МаксимальнаяСумма  = 0;
	МаксимальнаяСтрока = 0;
	ИтоговаяСкидка	   = 0;
	
	Для Каждого СтрокаТабличнойЧасти Из ОтчетОРозничныхПродажах.НаборыТоваров Цикл
		Если СтрокаТабличнойЧасти.Сумма = 0 ИЛИ ОбщаяСумма = 0 Тогда
			Доля = 0;
		Иначе
			Доля = СтрокаТабличнойЧасти.Сумма / ОбщаяСумма * 100;
		КонецЕсли;
		
		Скидка = Окр(СуммаОплатыБонусами / 100 * Доля, 2);
		
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Сумма - Скидка;
		СтрокаТабличнойЧасти.Сумма = ?(СтрокаТабличнойЧасти.Сумма < 0.1, 0, СтрокаТабличнойЧасти.Сумма);
		
		ИтоговаяСкидка = ИтоговаяСкидка + Скидка;
		
		Если СтрокаТабличнойЧасти.Сумма > МаксимальнаяСумма Тогда
			МаксимальнаяСумма  = СтрокаТабличнойЧасти.Сумма;
			МаксимальнаяСтрока = СтрокаТабличнойЧасти.НомерСтроки - 1; // индекс
		КонецЕсли;
	КонецЦикла;
	
	Если ИтоговаяСкидка <> СуммаОплатыБонусами И МаксимальнаяСтрока > 0 Тогда			
		СтрокаТабличнойЧасти = ОтчетОРозничныхПродажах.Товары[МаксимальнаяСтрока];			
		СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Сумма - Окр((СуммаОплатыБонусами - ИтоговаяСкидка), 2);
	КонецЕсли;
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////////////////

Процедура ПолучитьФайлJSON(ДатаНачало, ДатаКонец, ИмяФайлаОтправки, ИмяФайлаОтвета, РесурсНаСервере, ОписаниеОшибки, Отказ)
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьФайл(ИмяФайлаОтправки, , , Новый ПараметрыЗаписиJSON( , Символы.Таб));
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("user");
	ЗаписьJSON.ЗаписатьЗначение("Пользователь");
	ЗаписьJSON.ЗаписатьИмяСвойства("password");
	ЗаписьJSON.ЗаписатьЗначение("Пароль");
	ЗаписьJSON.ЗаписатьИмяСвойства("idstore");
	ЗаписьJSON.ЗаписатьЗначение(Число(Склад.Код));
	ЗаписьJSON.ЗаписатьИмяСвойства("datebegin");
	ЗаписьJSON.ЗаписатьЗначение(Формат(ДатаНачало, "ДФ=гггг-ММ-дд"));
	ЗаписьJSON.ЗаписатьИмяСвойства("dateend");
	ЗаписьJSON.ЗаписатьЗначение(Формат(ДатаКонец, "ДФ=гггг-ММ-дд"));
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	ЗаписьJSON.Закрыть();
	
	ФайлОтправки = Новый Файл(ИмяФайлаОтправки);
	
	ЗаголовокHTTP = Новый Соответствие();
	ЗаголовокHTTP.Вставить("POST /token HTTP/1.0");
	ЗаголовокHTTP.Вставить("Host", "miladoma.ru");
	ЗаголовокHTTP.Вставить("Content-Type", "multipart/form-data");
	ЗаголовокHTTP.Вставить("Content-Length", XMLСтрока(ФайлОтправки.Размер()));
	
	HTTPСоединение = Новый HTTPСоединение("10.66.68.128", "8080", , , , 600);
	
	Попытка
		HTTPОтвет = HTTPСоединение.ОтправитьДляОбработки(ИмяФайлаОтправки, РесурсНаСервере, ИмяФайлаОтвета, ЗаголовокHTTP);
	Исключение
		СформироватьОписаниеОшибки(ОписаниеОшибки, ОписаниеОшибки());
		
		Отказ = Истина;
		
		Возврат;
	КонецПопытки;
	
	ФайлОтвета = Новый Файл(ИмяФайлаОтвета);
	
	ВремяНачалаОжидания = ТекущаяДата();
	
	Пока Истина Цикл
		Если ФайлОтвета.Существует() Тогда
			ТекстОтвета = Новый ТекстовыйДокумент();
			ТекстОтвета.Прочитать(ИмяФайлаОтвета);
			                               
			Если ТекстОтвета.КоличествоСтрок() > 0 Тогда
				ОтветСервера = ТекстОтвета.ПолучитьТекст();
			КонецЕсли;
			
			Прервать;
		Иначе
			Если ТекущаяДата() - ВремяНачалаОжидания > 120 Тогда
				СформироватьОписаниеОшибки(ОписаниеОшибки, "Не удалось получить данные с сервера. Время ожидания истиекло");
				
				Отказ = Истина;
				
				Прервать;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////////////////

Процедура ЗагрузитьОтчетОРозничныхПродажах(ДатаНачало, ДатаКонец, ОписаниеОшибки, Отказ)
		
	ИмяФайлаОтправки 	 = ПолучитьИмяВременногоФайла("json");
	ИмяФайлаОтвета_sales = ПолучитьИмяВременногоФайла("json");
	ИмяФайлаОтвета_pays  = ПолучитьИмяВременногоФайла("json");
	
	//Сообщить(ИмяФайлаОтправки);
	//Сообщить(ИмяФайлаОтвета_sales);
	//Сообщить(ИмяФайлаОтвета_pays);
	
	// Получаем JSON с сервера
	ПолучитьФайлJSON(ДатаНачало, ДатаКонец, ИмяФайлаОтправки, ИмяФайлаОтвета_sales, "/b2c/getrestaurantsales", ОписаниеОшибки, Отказ);
	ПолучитьФайлJSON(ДатаНачало, ДатаКонец, ИмяФайлаОтправки, ИмяФайлаОтвета_pays,  "/b2c/getrestaurantpays",  ОписаниеОшибки, Отказ);
	
	// Читаем данные из файла товаров
	Если НЕ Отказ Тогда
		ЧтениеJSON_Товары = Новый ЧтениеJSON;
		ЧтениеJSON_Товары.ОткрытьФайл(ИмяФайлаОтвета_sales, );
		
		Товары = ПрочитатьJSON(ЧтениеJSON_Товары);
		
		Если Товары.data.Количество() = 0 Тогда
			СформироватьОписаниеОшибки(ОписаниеОшибки, "Продажи за " + Формат(ДатаНачало, "ДФ=dd.MM.yyyy") + " по складу " + СокрЛП(Склад) + " отсутствуют");
				
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Читаем данные из файла оплат
	Если НЕ Отказ Тогда
		ЧтениеJSON_Оплата = Новый ЧтениеJSON;
		ЧтениеJSON_Оплата.ОткрытьФайл(ИмяФайлаОтвета_pays, );
		
		Оплата = ПрочитатьJSON(ЧтениеJSON_Оплата);
		
		Если Оплата.data.Количество() = 0 Тогда
			СформироватьОписаниеОшибки(ОписаниеОшибки, "Оплата за " + Формат(ДатаНачало, "ДФ=dd.MM.yyyy") + " по складу " + СокрЛП(Склад) + " отсутствуют");
				
			Отказ = Истина;	
		КонецЕсли;
	КонецЕсли;
	
	ОтчетОРозничныхПродажах = Документы.ОтчетОРозничныхПродажах.СоздатьДокумент();
	
	// Заполняем табличные части Товары и НаборыТоваров
	Если НЕ Отказ Тогда
		КлючСвязиНаборыТоваров = 0;
		КодВладельца 		   = "";
		
		ВременнаяТаблица = Новый ТаблицаЗначений;
		ВременнаяТаблица.Колонки.Добавить("Код");
		ВременнаяТаблица.Колонки.Добавить("Наименование");
		ВременнаяТаблица.Колонки.Добавить("Тип");
		ВременнаяТаблица.Колонки.Добавить("НомерСтрокиОРП");
		
		ПрошлоеЗначение_КодКабаре = "";
		ПрошлоеЗначение_Весовой   = 0;
		
		Для Н = 0 По Товары.data.Количество() - 1 Цикл
			Если Товары.data[н].isdish = 1 Тогда
				// Набор-комплект 
				СтрокаТабличнойЧасти = ОтчетОРозничныхПродажах.НаборыТоваров.Добавить();
				
				КодКабаре	 = СокрЛП(Товары.data[н].dishcode);
				Номенклатура = НайтиНоменклатуру(КодКабаре);
				
				КлючСвязиНаборыТоваров = СтрокаТабличнойЧасти.НомерСтроки;
				КодВладельца 		   = СокрЛП(Товары.data[н].dishcode);
				
				// Проверка на возможные ошибки в КаБаРе
				Если ПрошлоеЗначение_Весовой = 1 Тогда
					Сообщить("Возможно, для позиции с кодом " + ПрошлоеЗначение_КодКабаре + " не указаны ингридиенты!", СтатусСообщения.Важное);
				КонецЕсли;
				
				ПрошлоеЗначение_Весовой   = 1;
				ПрошлоеЗначение_КодКабаре = КодКабаре;
			Иначе
				// Товар
				СтрокаТабличнойЧасти = ОтчетОРозничныхПродажах.Товары.Добавить();
				
				КодКабаре	 = СокрЛП(Товары.data[н].goodscode);
				Номенклатура = НайтиНоменклатуру(КодКабаре);
				
				СтрокаТабличнойЧасти.КлючСвязиНаборыТоваров = ?(Товары.data[н].dishcode = КодВладельца, КлючСвязиНаборыТоваров, 0);
				
				// Проверка на возможные ошибки в КаБаРе
				ПрошлоеЗначение_Весовой = 0;
			КонецЕсли;
			
			// Неопознаный товар добавляем в таблицу для сопоставления
			Если (НЕ ЗначениеЗаполнено(Номенклатура)) ИЛИ (Номенклатура = Неопределено) ИЛИ (Номенклатура = Справочники.Номенклатура.ПустаяСсылка()) Тогда
				СтрокаВременнойТаблицы = ВременнаяТаблица.Добавить();
				СтрокаВременнойТаблицы.Код 			  = КодКабаре;
				СтрокаВременнойТаблицы.Наименование   = СокрЛП(Товары.data[н].fullname);
				СтрокаВременнойТаблицы.Тип 			  = Товары.data[н].isdish;
				СтрокаВременнойТаблицы.НомерСтрокиОРП = СтрокаТабличнойЧасти.НомерСтроки;
			Иначе
				СтрокаТабличнойЧасти.Номенклатура = Номенклатура;
			КонецЕсли;
			
			// Корректировка единицы измерения
			Весовой = Товары.data[н].isweight;
			Весовой = ?(Весовой = Неопределено ИЛИ Весовой = "null", 0, Весовой);
			
			ЕдиницаИзмерения = СокрЛП(Товары.data[н].ed);
			ЕдиницаИзмерения = ?(ЕдиницаИзмерения = Неопределено ИЛИ ЕдиницаИзмерения = "null", "шт.", ЕдиницаИзмерения);
						
			Коэффициент = ?((ЕдиницаИзмерения = "л."  ИЛИ 
							 ЕдиницаИзмерения = "л"   ИЛИ 
							 ЕдиницаИзмерения = "кг." ИЛИ 
							 ЕдиницаИзмерения = "кг") И Весовой = 1, 1000, 1);
							 
			// Исключения по коэффициенту для некоторые позиций ¯\_(ツ)_/¯
			Если КодКабаре = "00000010800" ИЛИ
				 КодКабаре = "00000012727" ИЛИ
				 КодКабаре = "00000039586" ИЛИ 
				 КодКабаре = "00000039587" ИЛИ
				 КодКабаре = "00000039588" ИЛИ
				 КодКабаре = "00000039589" ИЛИ
				 КодКабаре = "00000039590" ИЛИ
				 КодКабаре = "00000039591" Тогда
				Коэффициент = 1; 
			КонецЕсли;
			
			// Заполнение данных табличной части
			СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтрокаТабличнойЧасти.Номенклатура.ЕдиницаХраненияОстатков;
			СтрокаТабличнойЧасти.Коэффициент 	  = СтрокаТабличнойЧасти.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент;
			СтрокаТабличнойЧасти.Количество 	  = Число(Товары.data[н].quantity) * Коэффициент;
			СтрокаТабличнойЧасти.Сумма 			  = Число(Товары.data[н].summa);
			СтрокаТабличнойЧасти.Цена 			  = ?(СтрокаТабличнойЧасти.Сумма = 0 ИЛИ СтрокаТабличнойЧасти.Количество = 0, 
													  0, 
													  СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество);
			СтрокаТабличнойЧасти.СтавкаНДС 		  = Перечисления.СтавкиНДС.БезНДС;
			СтрокаТабличнойЧасти.Склад 			  = Склад;
		КонецЦикла;
		
		ЧтениеJSON_Товары.Закрыть();
	КонецЕсли;
	
	// Сопоставление неопознаной номенклатуры
	Если НЕ Отказ Тогда
		СопоставлениеНоменклатуры.Загрузить(ВременнаяТаблица);
		СопоставлениеНоменклатуры.Свернуть("Код, Наименование, Тип");
			
		Если СопоставлениеНоменклатуры.Количество() > 0 Тогда
			Форма = ЭтотОбъект.ПолучитьФорму("ФормаСопоставления");
			Отказ = Форма.ОткрытьМодально();
			
			Отказ = ?(Отказ = Неопределено, Истина, Отказ);
			
			Если Отказ Тогда
				Сообщить("Документ не загружен, по причине не сопоставления номенклатуры!", СтатусСообщения.Важное);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Перенос данных о сопоставлении в регистр сведений СопоставлениеНоменклатуры и табличные части
	Если НЕ Отказ Тогда
		Для Каждого СтрокаСопоставление Из СопоставлениеНоменклатуры Цикл
			МенеджерЗаписи = РегистрыСведений.СопоставлениеНоменклатуры.СоздатьМенеджерЗаписи(); 
			МенеджерЗаписи.Код   		= СтрокаСопоставление.Код;  
			МенеджерЗаписи.Номенклатура = СтрокаСопоставление.Номенклатура;
			МенеджерЗаписи.Наименование = СтрокаСопоставление.Наименование;
			
			Попытка
				МенеджерЗаписи.Записать();
			Исключение
				СформироватьОписаниеОшибки(ОписаниеОшибки, "Не удалось записать данные в регистр ""СопоставлениеНоменклатуры""");
				
				Отказ = Истина;
			КонецПопытки;
			
			Отбор = Новый Структура;
			Отбор.Вставить("Код", СтрокаСопоставление.Код);
			НайденыеСтроки = ВременнаяТаблица.НайтиСтроки(Отбор);
			
			Для Каждого СтрокаВременнойТаблицы ИЗ НайденыеСтроки Цикл
				ТаблицаПоиска = ?(СтрокаВременнойТаблицы.Тип = 1, "НаборыТоваров", "Товары");
				
				СтрокаОРП = ОтчетОРозничныхПродажах[ТаблицаПоиска][СтрокаВременнойТаблицы.НомерСтрокиОРП - 1];
				СтрокаОРП.Номенклатура 	   = СтрокаСопоставление.Номенклатура;
				СтрокаОРП.ЕдиницаИзмерения = СтрокаСопоставление.Номенклатура.ЕдиницаХраненияОстатков;
				СтрокаОРП.Коэффициент 	   = СтрокаСопоставление.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	// Заполняем табличные части ОплатаПлатежнымиКартами
	Если НЕ Отказ Тогда 
		СуммаОплатыБонусами = 0;
		СуммаОплатыКартой   = 0;
		
		// Итоговые суммы оплаты картой и бонусами
		Для Н = 0 По Оплата.data.Количество() - 1 Цикл
			Если Число(Оплата.data[н].isbonuspayment) = 1 Тогда
				СуммаОплатыБонусами = СуммаОплатыБонусами + Число(Оплата.data[н].summa);
			КонецЕсли;
			
			Если Число(Оплата.data[н].paymentkind) = 4 ИЛИ 
				 Число(Оплата.data[н].paymentkind) = 23 Тогда
				СуммаОплатыКартой = СуммаОплатыКартой + Число(Оплата.data[н].summa);
			КонецЕсли;
		КонецЦикла;
		
		ЧтениеJSON_Оплата.Закрыть();
		
		// Оплату картой переносим в табличную часть ОплатаПлатежнымиКартами
		Если СуммаОплатыКартой > 0 Тогда
			ОтчетОРозничныхПродажах.ДоговорЭквайринга = ПолучитьДоговорЭквайринга(Склад.Организация);
			
			Если ЗначениеЗаполнено(ОтчетОРозничныхПродажах.ДоговорЭквайринга) Тогда 
				ОтчетОРозничныхПродажах.Эквайрер 					   = ОтчетОРозничныхПродажах.ДоговорЭквайринга.Эквайрер;
				ОтчетОРозничныхПродажах.ДоговорВзаиморасчетовЭквайрера = ОтчетОРозничныхПродажах.ДоговорЭквайринга.ДоговорВзаиморасчетов;
				
				СоответствиеТарифов = УправлениеРозничнойТорговлей.СформироватьСоответствиеТарифовЭквайринг(ОтчетОРозничныхПродажах.ДоговорЭквайринга);
			Иначе
				СоответствиеТарифов = Неопределено;
			КонецЕсли;
			
			СтрокаТабличнойЧасти =  ОтчетОРозничныхПродажах.ОплатаПлатежнымиКартами.Добавить();
			СтрокаТабличнойЧасти.ВидОплаты = Справочники.ВидыОплатЧекаККМ.НайтиПоКоду("000000002"); // VISA
			СтрокаТабличнойЧасти.Сумма 	   = СуммаОплатыКартой;
			
			Если СоответствиеТарифов <> Неопределено Тогда
				СтрокаТабличнойЧасти.ПроцентТорговойУступки = СоответствиеТарифов[СтрокаТабличнойЧасти.ВидОплаты];
	            СтрокаТабличнойЧасти.СуммаТорговойУступки   = СтрокаТабличнойЧасти.Сумма * СтрокаТабличнойЧасти.ПроцентТорговойУступки / 100;
			КонецЕсли;
		КонецЕсли;
		
		// Оплату бонусами распределяем по сумме в табличной части НаборыТоваров
		Если СуммаОплатыБонусами > 0 Тогда
			РаспределитьСуммуБонусов(ОтчетОРозничныхПродажах, СуммаОплатыБонусами);
		КонецЕсли;
	КонецЕсли;
	
	// Распределение суммы набора по ингридиентам
	Если НЕ Отказ Тогда 
		РаспределитьСуммуНабора(ОтчетОРозничныхПродажах);
	КонецЕсли;
	
	// Заполненое шапки и открытие формы
	Если НЕ Отказ Тогда
		ОтчетОРозничныхПродажах.Дата						= НачалоДня(ДатаКонец) - 600; // 23:50:00
		ОтчетОРозничныхПродажах.ОтражатьВБухгалтерскомУчете = Ложь;
		ОтчетОРозничныхПродажах.ОтражатьВНалоговомУчете 	= Ложь;
		ОтчетОРозничныхПродажах.Склад						= Склад;
		ОтчетОРозничныхПродажах.Комментарий 				= "КаБаРе" + ?(СуммаОплатыБонусами = 0, "", ". Оплата бонусами - " + СуммаОплатыБонусами);
		ОтчетОРозничныхПродажах.Организация					= Склад.Организация;
		ОтчетОРозничныхПродажах.ТипЦен						= Склад.ТипЦенРозничнойТорговли;
		ОтчетОРозничныхПродажах.КассаККМ					= ПолучитьКассуККМ(Склад);
		ОтчетОРозничныхПродажах.Подразделение				= Склад.Подразделение;
		
		ФормаДокумента = ОтчетОРозничныхПродажах.ПолучитьФорму("ФормаДокумента");
		ФормаДокумента.Открыть();
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗагрузитьТребованиеНакладную(ДатаНачало, ДатаКонец, ОписаниеОшибки, Отказ) 
	
	ИмяФайлаОтправки = ПолучитьИмяВременногоФайла("json");
	ИмяФайлаОтвета   = ПолучитьИмяВременногоФайла("json");
	
	//Сообщить(ИмяФайлаОтправки);
	//Сообщить(ИмяФайлаОтвета);
	
	// Получаем JSON с сервера
	ПолучитьФайлJSON(ДатаНачало, ДатаКонец, ИмяФайлаОтправки, ИмяФайлаОтвета, "/b2c/getrestaurantwriteoff", ОписаниеОшибки, Отказ);
	
	// Читаем данные из файла товаров
	Если НЕ Отказ Тогда
		ЧтениеJSON_Товары = Новый ЧтениеJSON;
		ЧтениеJSON_Товары.ОткрытьФайл(ИмяФайлаОтвета, );
		
		Товары = ПрочитатьJSON(ЧтениеJSON_Товары);
		
		Если Товары.data.Количество() = 0 Тогда
			СформироватьОписаниеОшибки(ОписаниеОшибки, "Списания за период " + Формат(ДатаНачало, "ДФ=dd.MM.yyyy") + " по " + Формат(ДатаКонец, "ДФ=dd.MM.yyyy") + " складу " + СокрЛП(Склад) + " отсутствуют");
				
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Заполняем табличные части Товары
	Если НЕ Отказ Тогда
		ТребованиеНакладная = Документы.ТребованиеНакладная.СоздатьДокумент();
		
		Комментарий 		   = "";
		ИдентификаторДокумента = "";

		ВременнаяТаблица = Новый ТаблицаЗначений;
		ВременнаяТаблица.Колонки.Добавить("Код");
		ВременнаяТаблица.Колонки.Добавить("Наименование");
		ВременнаяТаблица.Колонки.Добавить("Тип");
		ВременнаяТаблица.Колонки.Добавить("НомерСтрокиОРП");
		
		
		Для Н = 0 По Товары.data.Количество() - 1 Цикл
			Если ИдентификаторДокумента <> СокрЛП(Товары.data[н].IdDoc) И ИдентификаторДокумента <> "" Тогда
				ЗавершитьДокументТребованиеНакладная(ТребованиеНакладная, ВременнаяТаблица, ДатаКонец, Комментарий, ОписаниеОшибки, Отказ);
				
				ВременнаяТаблица.Очистить();
				
				ТребованиеНакладная = Документы.ТребованиеНакладная.СоздатьДокумент();
			КонецЕсли;
			
			КодКабаре	 = СокрЛП(Товары.data[н].goodscode);
			Номенклатура = НайтиНоменклатуру(КодКабаре);

			СтрокаТабличнойЧасти = ТребованиеНакладная.Материалы.Добавить();			
							
			// Неопознаный товар добавляем в таблицу для сопоставления
			Если (НЕ ЗначениеЗаполнено(Номенклатура)) ИЛИ (Номенклатура = Неопределено) ИЛИ (Номенклатура = Справочники.Номенклатура.ПустаяСсылка()) Тогда
				СтрокаВременнойТаблицы = ВременнаяТаблица.Добавить();
				СтрокаВременнойТаблицы.Код 			  = КодКабаре;
				СтрокаВременнойТаблицы.Наименование   = СокрЛП(Товары.data[н].fullname);
				СтрокаВременнойТаблицы.Тип 			  = Товары.data[н].isdish;
				СтрокаВременнойТаблицы.НомерСтрокиОРП = СтрокаТабличнойЧасти.НомерСтроки;
			Иначе
				СтрокаТабличнойЧасти.Номенклатура = Номенклатура;
			КонецЕсли;
			
			// Корректировка весового товара
			Весовой = Товары.data[н].isweight;
			Весовой = ?(Весовой = Неопределено ИЛИ Весовой = "null", 0, Весовой);
			
			ЕдиницаИзмерения = СокрЛП(Товары.data[н].ed);
			ЕдиницаИзмерения = ?(ЕдиницаИзмерения = Неопределено ИЛИ ЕдиницаИзмерения = "null", "шт.", ЕдиницаИзмерения);
			
			Коэффициент = ?((ЕдиницаИзмерения = "л."  ИЛИ 
							 ЕдиницаИзмерения = "л"   ИЛИ 
							 ЕдиницаИзмерения = "кг." ИЛИ 
							 ЕдиницаИзмерения = "кг") И Весовой = 1, 1000, 1);
			
			// Исключения по коэффициенту для некоторые позиций ¯\_(ツ)_/¯
			Если КодКабаре = "00000010800" ИЛИ
				 КодКабаре = "00000012727" ИЛИ
				 КодКабаре = "00000039586" ИЛИ 
				 КодКабаре = "00000039587" ИЛИ
				 КодКабаре = "00000039588" ИЛИ
				 КодКабаре = "00000039589" ИЛИ
				 КодКабаре = "00000039590" ИЛИ
				 КодКабаре = "00000039591" Тогда
				Коэффициент = 1; 
			КонецЕсли;
			
			// Заполнение данных табличной части
			СтрокаТабличнойЧасти.ЕдиницаИзмерения 	  = СтрокаТабличнойЧасти.Номенклатура.ЕдиницаХраненияОстатков;
			СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест = СтрокаТабличнойЧасти.Номенклатура.ЕдиницаХраненияОстатков;
			СтрокаТабличнойЧасти.Коэффициент 	  	  = СтрокаТабличнойЧасти.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент;
			СтрокаТабличнойЧасти.КоличествоМест   	  = Число(Товары.data[н].quantity) * Коэффициент;   
			СтрокаТабличнойЧасти.Количество 	  	  = Число(Товары.data[н].quantity) * Коэффициент;
			СтрокаТабличнойЧасти.Качество		  	  = Справочники.Качество.Новый;
			СтрокаТабличнойЧасти.Подразделение	  	  = Склад.Подразделение;
			СтрокаТабличнойЧасти.НоменклатурнаяГруппа = СтрокаТабличнойЧасти.Номенклатура.НоменклатурнаяГруппаЗатрат;
			СтрокаТабличнойЧасти.Склад				  = Склад;
			
			//
			Комментарий 		   = СокрЛП(Товары.data[н].Prim); 
			ИдентификаторДокумента = СокрЛП(Товары.data[н].IdDoc);
		КонецЦикла;
		
		Если НЕ Отказ И ИдентификаторДокумента <> "" Тогда
			ЗавершитьДокументТребованиеНакладная(ТребованиеНакладная, ВременнаяТаблица, ДатаКонец, Комментарий, ОписаниеОшибки, Отказ);
		КонецЕсли;
		
		ЧтениеJSON_Товары.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗавершитьДокументТребованиеНакладная(ТребованиеНакладная, ВременнаяТаблица, ДатаКонец, Комментарий, ОписаниеОшибки, Отказ)
	
	// Сопоставление неопознаной номенклатуры
	Если НЕ Отказ Тогда
		СопоставлениеНоменклатуры.Загрузить(ВременнаяТаблица);
		СопоставлениеНоменклатуры.Свернуть("Код, Наименование, Тип");
			
		Если СопоставлениеНоменклатуры.Количество() > 0 Тогда
			Форма = ЭтотОбъект.ПолучитьФорму("ФормаСопоставления");
			Отказ = Форма.ОткрытьМодально();
			
			Отказ = ?(Отказ = Неопределено, Истина, Отказ);
			
			Если Отказ Тогда
				Сообщить("Документ не загружен, по причине не сопоставления номенклатуры!", СтатусСообщения.Важное);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Перенос данных о сопоставлении в регистр сведений СопоставлениеНоменклатуры и табличные части
	Если НЕ Отказ Тогда
		Для Каждого СтрокаСопоставление Из СопоставлениеНоменклатуры Цикл
			МенеджерЗаписи = РегистрыСведений.СопоставлениеНоменклатуры.СоздатьМенеджерЗаписи(); 
			МенеджерЗаписи.Код   		= СтрокаСопоставление.Код;  
			МенеджерЗаписи.Номенклатура = СтрокаСопоставление.Номенклатура;
			МенеджерЗаписи.Наименование = СтрокаСопоставление.Наименование;
			
			Попытка
				МенеджерЗаписи.Записать();
			Исключение
				СформироватьОписаниеОшибки(ОписаниеОшибки, "Не удалось записать данные в регистр ""СопоставлениеНоменклатуры""");
				
				Отказ = Истина;
			КонецПопытки;
			
			Отбор = Новый Структура;
			Отбор.Вставить("Код", СтрокаСопоставление.Код);
			НайденыеСтроки = ВременнаяТаблица.НайтиСтроки(Отбор);
			
			Для Каждого СтрокаВременнойТаблицы ИЗ НайденыеСтроки Цикл
				СтрокаОРП = ТребованиеНакладная.Материалы[СтрокаВременнойТаблицы.НомерСтрокиОРП - 1];
				СтрокаОРП.Номенклатура 	   	   = СтрокаСопоставление.Номенклатура;
				СтрокаОРП.ЕдиницаИзмерения 	   = СтрокаСопоставление.Номенклатура.ЕдиницаХраненияОстатков;
				СтрокаОРП.ЕдиницаИзмеренияМест = СтрокаСопоставление.Номенклатура.ЕдиницаХраненияОстатков;
				СтрокаОРП.Коэффициент 	   	   = СтрокаСопоставление.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент;
				СтрокаОРП.НоменклатурнаяГруппа = СтрокаСопоставление.Номенклатура.НоменклатурнаяГруппаЗатрат;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;	
	
	// Заполненое шапки и открытие формы
	Если НЕ Отказ Тогда
		ТребованиеНакладная.Дата						 = КонецДня(ДатаКонец) - 14401; // 20:00:00
		ТребованиеНакладная.Склад						 = Склад;
		ТребованиеНакладная.Комментарий 				 = "КаБаРе: " + Комментарий;
		ТребованиеНакладная.Организация					 = Склад.Организация;
		ТребованиеНакладная.Подразделение				 = Склад.Подразделение;
		ТребованиеНакладная.ОтражатьВУправленческомУчете = Истина;
		ТребованиеНакладная.ОтражатьВБухгалтерскомУчете  = Ложь;
		ТребованиеНакладная.ОтражатьВНалоговомУчете 	 = Ложь;
	
		ФормаДокумента = ТребованиеНакладная.ПолучитьФорму("ФормаДокумента");
		ФормаДокумента.Открыть();
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////////////////

Процедура КнопкаВыполнитьНажатие(Кнопка) 
	
	Отказ = Ложь;
	ОписаниеОшибки = "";
	
	ПроверитьЗаполнениеРеквизитов(ОписаниеОшибки, Отказ);
	
	Если НЕ Отказ Тогда
		Если ЗагрузитьОтчетОРозничныхПродажах Тогда	
			ТекущаяДата = НачалоДня(НачалоПериода);
			
			Пока ТекущаяДата <= НачалоДня(КонецПериода) Цикл
				Отказ = Ложь;
				
				ЗагрузитьОтчетОРозничныхПродажах(ТекущаяДата, КонецДня(ТекущаяДата) + 1, ОписаниеОшибки, Отказ);
				
				Если Отказ Тогда
					Сообщить(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
				КонецЕсли;
				
				ТекущаяДата = ТекущаяДата + 86400;
			КонецЦикла;
		КонецЕсли;
		
		Если ЗагрузитьТребованиеНакладную Тогда
			ЗагрузитьТребованиеНакладную(НачалоДня(НачалоПериода), КонецДня(КонецПериода), ОписаниеОшибки, Отказ);
			
			Если Отказ Тогда
				Сообщить(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Сообщить(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриОткрытии() 
	
	НачалоПериода = НачалоДня(ТекущаяДата()) - 1;
	КонецПериода  = НачалоДня(ТекущаяДата()) - 1;
	
КонецПроцедуры