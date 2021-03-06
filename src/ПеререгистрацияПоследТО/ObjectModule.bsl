﻿Набор=Последовательности.ВнутренниеПродажи.СоздатьНаборЗаписей();
Набор.Прочитать();
Набор.Очистить();

//1. Реализации
Отбор=Новый Структура("ВнутреннийДокумент",Ложь);
Выборка=Документы.РеализацияТоваровУслуг.Выбрать(,,Отбор);
Пока Выборка.Следующий() Цикл
	Если Выборка.Проведен Тогда
		Набор.Отбор.Регистратор.Установить(Выборка.Ссылка);
		Набор.Прочитать();
		Запись=Набор.Добавить();
		Запись.Регистратор=Выборка.Ссылка;
		Запись.Период=Выборка.Дата;
		Набор.Записать();
	КонецЕсли;
КонецЦикла;

//2. Перемещения
Выборка=Документы.ПеремещениеТоваров.Выбрать(,,);
Пока Выборка.Следующий() Цикл
	Если Выборка.Проведен И Выборка.СкладПолучатель.ВидСклада = Перечисления.ВидыСкладов.Розничный Тогда
		Набор.Отбор.Регистратор.Установить(Выборка.Ссылка);
		Набор.Прочитать();
		Запись=Набор.Добавить();
		Запись.Регистратор=Выборка.Ссылка;
		Запись.Период=Выборка.Дата;
		Набор.Записать();
	КонецЕсли;
КонецЦикла;

Набор.Записать();