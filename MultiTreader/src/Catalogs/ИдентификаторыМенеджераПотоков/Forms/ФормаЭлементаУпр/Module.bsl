&НаКлиенте
Перем ТекИдентификаторМенеджера;


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ккЗаполнениеНастроекЗаданияМенеджера" Тогда
		
		Если ТипЗнч(Параметр) = Тип("Структура") Тогда
			
			НастройкиМенеджера = Параметр;
			ЕстьНастройки = Истина;
			ОбновитьДекорацииНастроек();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОткрытьНастройки(Команда)
	
	
	Если ТипЗнч(ДвоичныеДанныеФайла) <> Тип("ДвоичныеДанные") Тогда
		ТекстСообщения = НСтр("ru ='Для данного идентификатора не указана внешняя обработка настроек.'");
		Сообщить(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПолноеИмяФайла = КаталогВременныхФайлов() + Объект.ИмяФайлаОбработки;
	ДвоичныеДанныеФайла.Записать(ПолноеИмяФайла);
	
	АдресХранилища = "";
	Результат = ПоместитьФайл(АдресХранилища, ПолноеИмяФайла, , Ложь);
	ИмяОбработки = ПодключитьВнешнююОбработку(АдресХранилища);
	
	Если ТипЗнч(НастройкиМенеджера) <> Тип("Структура") Тогда
		НастройкиМенеджера = Новый Структура;
	КонецЕсли;
	
	Попытка
		
		ПутьКФорме = СтрШаблон("ВнешняяОбработка.%1.Форма", ИмяОбработки);
		ПараметрыФормы = Новый Структура("НастройкиМенеджера", НастройкиМенеджера);
		ОткрытьФорму(ПутьКФорме, ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор, , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Ошибка: " + ОписаниеОшибки();
		Сообщение.Сообщить();;
		
	КонецПопытки;
	
	УдалитьФайлы(ПолноеИмяФайла);

КонецПроцедуры

//#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДоступностьЭлементовФормы();
	ОбновитьДекорацииНастроек();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Хранилище = Новый ХранилищеЗначения(ДвоичныеДанныеФайла);
	
	ТекущийОбъект.НастройкиЗадания = Новый ХранилищеЗначения(НастройкиМенеджера);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДвоичныеДанныеФайла = ТекущийОбъект.Хранилище.Получить();
	
	НастройкиМенеджера = ТекущийОбъект.НастройкиЗадания.Получить();
	
	ЕстьНастройки = ?(НастройкиМенеджера = Неопределено, Ложь, Истина);

КонецПроцедуры

//#КонецОбласти


//#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИмяФайлаОбработкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог                    = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок          = "Выбор обработки";
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Фильтр             = "Внешние обработки (*.epf)|*.epf";
	Диалог.ПолноеИмяФайла     = Объект.ИмяФайлаОбработки;

	Если Диалог.Выбрать() Тогда
		Объект.ИмяФайлаОбработки = Сред(Диалог.ПолноеИмяФайла, СтрДлина(Диалог.Каталог) + 1);
		ДвоичныеДанныеФайла = Новый ДвоичныеДанные(Диалог.ПолноеИмяФайла);
    КонецЕсли;
	
	// ОписаниеЗащиты = Новый ОписаниеЗащитыОтОпасныхДействий;
    // ОписаниеЗащиты.ПредупреждатьОбОпасныхДействиях = Ложь;
    // ВнешняяОбработка = ВнешниеОбработки.Создать(ПутьКОбработке, Ложь, ОписаниеЗащиты);
	
    ДоступностьЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОбработкиОчистка(Элемент, СтандартнаяОбработка)
	
	ДвоичныеДанныеФайла = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВнешнююОбработку(Команда)
    Если НЕ ДвоичныеДанныеФайла = Неопределено Тогда
        АдресФайлаВХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
        ПолучитьФайл(АдресФайлаВХранилище);
    КонецЕсли; 
КонецПроцедуры

//#КонецОбласти

Процедура ДоступностьЭлементовФормы()
	Элементы.ЗаписатьВнешнююОбработку.Доступность = НЕ (ДвоичныеДанныеФайла = Неопределено);	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
//// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

 &НаСервере
Функция ПодключитьВнешнююОбработку(АдресХранилища)
	ОписаниеЗащиты = Новый ОписаниеЗащитыОтОпасныхДействий;
	ОписаниеЗащиты.ПредупреждатьОбОпасныхДействиях = Ложь;
	Возврат ВнешниеОбработки.Подключить(АдресХранилища, ,Ложь, ОписаниеЗащиты);
КонецФункции

&НаКлиенте
Процедура ОбновитьДекорацииНастроек()
	
	Если ЕстьНастройки Тогда
		Элементы.НадписьПредупреждение.Заголовок = НСтр("ru ='Настройки заполнены'");
		Элементы.ЗаполнитьНастройки.Заголовок    = НСтр("ru ='Открыть'");
		Элементы.НадписьПредупреждение.ЦветТекста =  ЦветУспех;
	Иначе
		Элементы.НадписьПредупреждение.Заголовок = НСтр("ru ='Настройки не заполнены'");
		Элементы.ЗаполнитьНастройки.Заголовок    = НСтр("ru ='Заполнить'");
		Элементы.НадписьПредупреждение.ЦветТекста =ЦветОжидается;      
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЦветОжидается = WebЦвета.Бежевый;
    ЦветУспех     = WebЦвета.НейтральноЗеленый;
	Объект.КоличествоПотоков = ?(Объект.КоличествоПотоков = 0,1,Объект.КоличествоПотоков);
	Объект.КоличествоЭлементовКолекцииНаПоток = ?(Объект.КоличествоЭлементовКолекцииНаПоток = 0,1,Объект.КоличествоЭлементовКолекцииНаПоток);
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ПараметрыОбъекта = ТекущийОбъект.НастройкиЗадания.Получить();
	Если НЕ ПараметрыОбъекта = Неопределено Тогда
		Для Каждого ЭлементСтруктуры Из ПараметрыОбъекта Цикл
			СтрокаТЧ = СтруктураПараметров.Добавить();
			СтрокаТЧ.Ключ = ЭлементСтруктуры.Ключ;
			Если ТипЗнч(ЭлементСтруктуры.Значение) = Тип("ТаблицаЗначений") Тогда
				СтрокаТЧ.Значение = "<ТаблицаЗначений>";	
			Иначе
				СтрокаТЧ.Значение = ЭлементСтруктуры.Значение;
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли; 
КонецПроцедуры
