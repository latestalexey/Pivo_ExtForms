﻿
Процедура ОсновныеДействияФормыПечатьСВыводомНаЭкран(Кнопка)
	
	Печать("Справка");
	
КонецПроцедуры

Процедура ОсновныеДействияФормыПечатьНапринтер(Кнопка)
	
	ПараметрыПечати = Новый Структура("КоличествоЭкземпляров, НаПринтер");
	ПараметрыПечати.КоличествоЭкземпляров = 1;
	ПараметрыПечати.НаПринтер = Истина;

	Печать("Справка", ПараметрыПечати);
	
КонецПроцедуры

