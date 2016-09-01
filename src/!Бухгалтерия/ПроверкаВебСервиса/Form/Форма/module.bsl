﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	ЧтениеФайл=Новый ЧтениеТекста(ПутьДоФайла,КодировкаТекста.UTF8);
	Текст=ЧтениеФайл.Прочитать();
	Рез=CheckFindDocsEGAIS(Текст);
КонецПроцедуры

Функция CheckFindDocsEGAIS(ArrOfNubmerDate)
	Попытка
		МассивНомеровИДат=ЗначениеИзСтрокиВнутр(ArrOfNubmerDate);
	Исключение
		Возврат "";
	КонецПопытки;
	МассивРезультат=Новый Массив;
	Для Каждого ЭлПоиска Из МассивНомеровИДат Цикл
		Док=документы.РеализацияТоваровУслуг.НайтиПоНомеру(ЭлПоиска.Номер,ЭлПоиска.Дата);
		Если ЗначениеЗаполнено(Док) Тогда
			ДокЕГАИС=Документы.ЕГАИС_ТТН_исх.НайтиПоРеквизиту("УчетныйДокумент",Док);
			Если ДокЕГАИС.СтатусТТН=Перечисления.СтатусыТТН.Принят Тогда
				МассивРезультат.Добавить(ЭлПоиска.Номер+"\"+ЭлПоиска.Дата);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат ЗначениеВСтрокуВнутр(МассивРезультат);
КонецФункции

Процедура ПутьДоФайлаНачалоВыбора(Элемент, СтандартнаяОбработка)
	Диалог=Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр="Text|*.txt";
	Если Диалог.Выбрать() Тогда
		ПутьДоФайла=Диалог.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры
