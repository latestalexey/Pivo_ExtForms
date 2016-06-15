﻿Перем МассивДатДокументов;

МассивДатДокументов=Новый Массив;
МассивДатДокументов.Добавить(НачалоМесяца(ТекущаяДата()));
Если день(ТекущаяДата())<=Константы.ГраницаОбновленияБюджетовПрошлыйМесяц.Получить() Тогда
	МассивДатДокументов.Добавить(ДобавитьМесяц(НачалоМесяца(ТекущаяДата()),-1));
КонецЕсли;
Если день(ТекущаяДата())=Константы.ГраницаОбновленияБюджетовПрошлыйМесяц.Получить() Тогда
	Задача=Задачи.ЗадачиПользователя.СоздатьЗадачу();
	Задача.Дата=ТекущаяДата();
	Задача.Исполнитель=Справочники.Пользователи.НайтиПоНаименованию("Камалова",Ложь);
	Задача.Наименование="Автообновление бюджетов прошлый месяц";
	Задача.Описание="С сегодняшнего дня не будут обновляться бюджеты предыдущего месяца";
	Задача.Оповещение=Истина;
	Задача.СрокОповещения=НачалоДня(ТекущаяДата())+10*60*60;
	Задача.СрокИсполнения=НачалоДня(ТекущаяДата())+10*60*60;
	Задача.Записать();
КонецЕсли;
