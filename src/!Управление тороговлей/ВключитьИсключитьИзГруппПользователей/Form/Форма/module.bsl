﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	ВыборкаГрупп=Справочники.ГруппыПользователей.ВыбратьИерархически(ГруппаПользователей);
	Пока ВыборкаГрупп.Следующий() Цикл
		Об=ВыборкаГрупп.ПолучитьОбъект();
		Для Каждого СтрокаТЧ ИЗ СписокПользователей Цикл
			Рез=Об.ПользователиГруппы.Найти(СтрокаТЧ.Пользователь);
			Если Включить Тогда
				Если Рез=Неопределено Тогда
					Об.ПользователиГруппы.Добавить().Пользователь=СтрокаТЧ.Пользователь;
				КонецЕсли;
			Иначе
				Если Рез<>Неопределено Тогда
					Об.ПользователиГруппы.Удалить(Об.ПользователиГруппы.Индекс(Рез));
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Если Об.Модифицированность() Тогда
			Об.Записать();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
