﻿
Процедура КоманднаяПанельСпискаОтборовУстановитьФлажки(Кнопка)
	СписокОбъектовДляОтбора.ЗаполнитьПометки(Истина);
КонецПроцедуры

Процедура КоманднаяПанельСпискаОтборовСнятьФлажки(Кнопка)
	СписокОбъектовДляОтбора.ЗаполнитьПометки(Ложь);
КонецПроцедуры

Процедура СписокОбъектовДляОтбораПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		ОформлениеСтроки.Шрифт = ?(ОформлениеСтроки.ДанныеСтроки.Пометка, ШрифтыСтиля.ШрифтВажнойНадписи, ШрифтыСтиля.ШрифтТекста);
	КонецЦикла;
	
КонецПроцедуры
