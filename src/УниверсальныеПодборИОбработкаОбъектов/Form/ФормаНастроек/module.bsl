﻿Процедура КоманднаяПанельВыбранныеПоляПрименить(Кнопка)
	ВладелецФормы.вВыполнитьОтчет();
КонецПроцедуры

Процедура ВыбранныеПоляПередУдалением(Элемент, Отказ)
	Если Элемент.ТекущиеДанные.Имя = "Объект" Тогда
		Отказ = Истина;
		Предупреждение("Вы не можете удалить поле ""Объект"""); 
	КонецЕсли; 
КонецПроцедуры

Процедура КоманднаяПанель9НайтиОбъекты(Кнопка)
	ВладелецФормы.вВыполнитьОтчет();
КонецПроцедуры

Процедура ВыбранныеПоляПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущиеДанные.Имя = "Объект" Тогда
		Отказ = Истина;
		Предупреждение("Вы не можете удалить поле ""Объект"""); 
	КонецЕсли; 
КонецПроцедуры

