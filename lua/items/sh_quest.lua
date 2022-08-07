Inventory:RegisterItem("blackbox", {
	Name			= "Бортовой самописец",
	Desc			= [[«Чёрный ящик», уцелевший при падении вертолёта «Скат-1». В нём должна содержаться зашифрованная информация о последних минутах полёта.]],
	Model			= "models/chernobyl/item/box_black.mdl",
	Weight			= 32,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/blackbox.png",
	IsQuest			= true,
})

Inventory:RegisterItem("order562", {
	Name			= "Приказ №562",
	Desc			= [[«Совершенно секретно. Приказ №562 нач. штаба обороны объекта №1 Р. Ю. Диденко.Подразделению химзащиты №423 сменить дислокацию из сектора Б103 в сектор А19 для проведения полевых испытаний хим. смеси «Перин-В3» в условиях, особо приближённых к боевым. Отв. за пров. испытаний: ком. подр. п/к П.П. Славин. Отв. за транспортировку и безопасность - зам. ком. подр. п/пк К.С. Валов.]],
	Model			= "models/chernobyl/item/handhelds/files2.mdl",
	Weight			= 0.05,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/order562.png",
	IsQuest			= true,
})

Inventory:RegisterItem("product62", {
	Name			= "Документация по «изделию №62»",
	Desc			= [[Документация, в которой описан принцип работы и основные ТТХ электромагнитной установки.В документы вложена записка: «Документацию необходимо вернуть в центральную лабораторию (X8). Я буду занят, доставишь сам. В КБО «Юбилейный» используй магнитную карту - спустишься на лифте на минус второй этаж, дальше разберёшься сам. Карту доступа прилагаю.»— Н. Лебедев. Эти документы не должны попасть в чужие руки: они явно заинтересуют аналитиков СБУ.]],
	Model			= "models/kek1ch/notes_document_case_2.mdl",
	Weight			= 0.05,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/product62.png",
	IsQuest			= true,
})

Inventory:RegisterItem("documentx16", {
	Name			= "Документы из лаборатории X16",
	Desc			= [[Полиэтиленовый файл с документами. Без ученой степени по биологии сложно что-то в них понять.]],
	Model			= "models/kek1ch/notes_document_case_3.mdl",
	Weight			= 0.05,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/documentx16.png",
	IsQuest			= true,
})

Inventory:RegisterItem("documentx18part4", {
	Name			= "Документы из Лабаратории",
	Desc			= [[Толстая стопка научных бумаг. Сплошные термины, формулы и диаграммы.]],
	Model			= "models/kek1ch/notes_document_case_1.mdl",
	Weight			= 0.8,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/documentx18part4.png",
	IsQuest			= true,
})

Inventory:RegisterItem("experimentbook", {
	Name			= "Тетрадь с записью об эксперименте",
	Desc			= [[В тетради есть подробное описание эксперимента по направленному воздействию пси-полем на объект, который находится в другом полушарии Земли. Группа учёных на судне в Карибском море получила сигнал, но с искажениями. Модуляции были непонятным образом искажены, словно «подправлены» кем-то. Одна из рабочих версий основана на предположении о верности теории ноосферы, которая якобы и привнесла эти искажения.Эти документы не должны попасть в чужие руки: они явно заинтересуют аналитиков СБУ.]],
	Model			= "models/kek1ch/notes_writing_book_1.mdl",
	Weight			= 0.05,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/experimentbook.png",
	IsQuest			= true,
})

Inventory:RegisterItem("armydocument", {
	Name			= "Документы военных",
	Desc			= [[Кейс с документами. Сделан из огнеупорного материала.]],
	Model			= "models/kek1ch/safe_container.mdl",
	Weight			= 1,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/armydocument.png",
	IsQuest			= true,
})

Inventory:RegisterItem("bluecase", {
	Name			= "Стальной ящик",
	Desc			= [[Кейс с документами. Сделан из огнеупорного материала.]],
	Model			= "models/z-o-m-b-i-e/st/box/st_box_metall_01.mdl",
	Weight			= 1,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/bluecase.png",
	IsQuest			= true,
})

Inventory:RegisterItem("calibrationtools", {
	Name			= "Инструменты для калибровки",
	Desc			= [[Профессиональный набор инструментов для тонкой доводки оборудования. Надпись на ящике гласит, что набор произведен в ГДР. Того, что включено в комплект, достаточно для проведения почти любых работ по настройке и калибровке.]],
	Model			= "models/chernobyl/item/box_toolkit_3.mdl",
	Weight			= 1,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/calibrationtools.png",
	IsQuest			= true,
})

Inventory:RegisterItem("fineworktools", {
	Name			= "Инструменты для тонкой работы",
	Desc			= [[Неплохой набор инструментов. Судя по всему, тщательно подобран опытным мастером «под себя, родного». Несмотря на годы, весь инструментарий хорошо сохранился.]],
	Model			= "models/chernobyl/item/box_toolkit_2.mdl",
	Weight			= 1,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/fineworktools.png",
	IsQuest			= true,
})

Inventory:RegisterItem("toolsforroughwork", {
	Name			= "Инструменты для грубой работы",
	Desc			= [[Набор инструментов «Юный техник». Вряд ли подойдёт для работы, в которой нужна тонкость, но в условиях тотальной нехватки инструментов в Зоне может пригодиться экономному технику.]],
	Model			= "models/chernobyl/item/box_toolkit_1.mdl",
	Weight			= 1,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/toolsforroughwork.png",
	IsQuest			= true,
})

Inventory:RegisterItem("laptop", {
	Name			= "Ноутбук с инофрмацией",
	Desc			= [[Среди множества спама в почтовом ящике ноутбука возможно скрывается полезная информация]],
	Model			= "models/chernobyl/item/noteb.mdl",
	Weight			= 2.1,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/laptop.png",
	IsQuest			= true,
})

Inventory:RegisterItem("decoder", {
	Name			= "Декодер",
	Desc			= [[Нечто вроде мощной электронной отмычки. Похоже, что она создана с целью взломать какой-то специфический электронный замок. Как ни странно, конструкция не подразумевает универсальности — оно создавалось для конкретного замка и не способно взламывать какие-либо другие коды.]],
	Model			= "models/kali/miscstuff/stalker/sensor_d.mdl",
	Weight			= 0.5,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/decoder.png",
	IsQuest			= true,
})

Inventory:RegisterItem("memorymodule", {
	Name			= "Модуль памяти",
	Desc			= [[Модуль памяти, извлёченный из беспилотного разведывательного аппарата. Несмотря на крушение носителя, модуль памяти работоспособен — но, к сожалению, заблокирован.]],
	Model			= "models/chernobyl/item/memory_module.mdl",
	Weight			= 5,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/memorymodule.png",
	IsQuest			= true,
})

Inventory:RegisterItem("mutantscaner", {
	Name			= "Сканер присутствия мутантов",
	Desc			= [[Комплекс из сканера аномальной активности, датчика присутствия мутантов (ограниченного радиуса действия) и блока записи. Прибор снабжён автоматическим выключателем, который срабатывает после накопления определённого количества данных.]],
	Model			= "models/chernobyl/item/scanner_anomaly.mdl",
	Weight			= 5,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/mutantscaner.png",
	IsQuest			= true,
})

Inventory:RegisterItem("anomaliesscaner", {
	Name			= "Сканер аномальной активности",
	Desc			= [[В корпусе прибора воедино собраны детектор артефактов, аккумулятор и мощный передатчик. Эта штука должна сканировать аномалии, определяя количество и тип появившихся в них артефактов. Вся полученная информация должна автоматически пересылаться в бункер учёных.]],
	Model			= "models/chernobyl/item/scanner_artefact.mdl",
	Weight			= 5,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/anomaliesscaner.png",
	IsQuest			= true,
})

Inventory:RegisterItem("flash1", {
	Name			= "Флешка с фильмами",
	Desc			= [[На флешку записаны все последние новинки кино, но все в неподходящем для просмотра на КПК разрешении.]],
	Model			= "models/kali/miscstuff/stalker/usb_a.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/flash1.png",
	IsQuest			= true,
})

Inventory:RegisterItem("flash2", {
	Name			= "Флешка с данными",
	Desc			= [[Флешка заблокирована]],
	Model			= "models/kali/miscstuff/stalker/usb_b.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/flash2.png",
	IsQuest			= true,
})

Inventory:RegisterItem("flash3", {
	Name			= "Флешка Стрелка",
	Desc			= [[Флешка заблокирована]],
	Model			= "models/kali/miscstuff/stalker/usb_a.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/flash1.png",
	IsQuest			= true,
})

Inventory:RegisterItem("flash4", {
	Name			= "Флешка безымянного",
	Desc			= [[Флешка заблокирована]],
	Model			= "models/kali/miscstuff/stalker/usb_a.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/flash1.png",
	IsQuest			= true,
})

Inventory:RegisterItem("flash5", {
	Name			= "Флешка озабоченного",
	Desc			= [[На флешке 10гб порнографии]],
	Model			= "models/kali/miscstuff/stalker/usb_b.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/flash2.png",
	IsQuest			= true,
})

Inventory:RegisterItem("flash6", {
	Name			= "Флешка военных",
	Desc			= [[Флешка заблокирована]],
	Model			= "models/kali/miscstuff/stalker/usb_b.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/flash2.png",
	IsQuest			= true,
})

Inventory:RegisterItem("yellowcard", {
	Name			= "Жёлтая ключ-карта",
	Desc			= [[Магнитная ключ-карта жёлого цвета. На одной из плоскостей нанесено «Х8».С её помощью открывается запертая дверь в арсенал, в лаборатории Х8]],
	Model			= "МОДЕЛИ НЕТ!",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/yellowcard.png",
	IsQuest			= true,
})

Inventory:RegisterItem("redcard", {
	Name			= "Красная ключ-карта",
	Desc			= [[Магнитная ключ-карта красного цвета. На одной из плоскостей нанесено «Х8».С её помощью открывается запертая дверь в арсенал, в лаборатории Х8]],
	Model			= "МОДЕЛИ НЕТ!",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/redcard.png",
	IsQuest			= true,
})

Inventory:RegisterItem("oldmagnitcard", {
	Name			= "Старая магнитная ключ-карта",
	Desc			= [[Магнитная ключ-карта, принадлежащая Кардану. Использовалась для допуска в цех, где испытывалось «изделие №62».]],
	Model			= "МОДЕЛИ НЕТ!",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/oldmagnitcard.png",
	IsQuest			= true,
})

Inventory:RegisterItem("keys1", {
	Name			= "Ключ",
	Desc			= [[Обычный на вид ключ, помеченный буквой «А»]],
	Model			= "models/chernobyl/item/key.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/keys.png",
	IsQuest			= true,
})

Inventory:RegisterItem("keys2", {
	Name			= "Ключ",
	Desc			= [[Обычный на вид ключ, помеченный буквой «Б».]],
	Model			= "models/chernobyl/item/key.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/keys.png",
	IsQuest			= true,
})

Inventory:RegisterItem("c4", {
	Name			= "Взрывчатка с таймером",
	Desc			= [[Пластиковая взрывчатка стандартного армейского образца. Оснащена пятисекундным таймером-замедлителем. (Деактивирована)]],
	Model			= "МОДЕЛИ НЕТ!",
	Weight			= 3.4,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/c4.png",
	IsQuest			= true,
})

Inventory:RegisterItem("passport", {
	Name			= "Удостоверение Сотрудника СБУ",
	Desc			= [[Удостоверение сотрудника СБУ]],
	Model			= "",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/passport.png",
	IsQuest			= true,
})

Inventory:RegisterItem("textolite", {
	Name			= "Текстолит",
	Desc			= [[Основа печатной платы. То, что испытывает радиотехник-любитель при виде нетронутой текстолитовой плиты, сравнимо разве что с ощущениями писателя над чистым листом.]],
	Model			= "models/chernobyl/item/materials_textolite.mdl",
	Weight			= 0.5,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/146.png",
	IsQuest			= true,
})

Inventory:RegisterItem("wire", {
	Name			= "Медь",
	Desc			= [[Медь является отличным проводником — и, по совместительству, ценным цветным металлом. Ввиду данного факта такая проволока представляет собой большую редкость: все имевшиеся запасы меди в Зоне были найдены и сданы во вторсырьё ещё в середине 1990-х.]],
	Model			= "models/chernobyl/item/materials_wire.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/wire.png",
	IsQuest			= true,
})

Inventory:RegisterItem("rosin", {
	Name			= "Банка канифоли",
	Desc			= [[Банка канифоли, используемой при пайке. Редкая вещь в Зоне: как правило, фрагменты сломавшихся предметов здесь соединяют при помощи изоленты.]],
	Model			= "models/chernobyl/item/box_kanifol.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/grease.png",
	IsQuest			= true,
})

Inventory:RegisterItem("featherbed", {
	Name			= "Перин-В3",
	Desc			= [[Баллон с опасным химическим веществом нервно-паралитического действия.]],
	Model			= "МОДЕЛИ НЕТ!",
	Weight			= 3.1,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/141.png",
	IsQuest			= true,
})

Inventory:RegisterItem("121", {
	Name			= "Документы о деятельности военных",
	Desc			= [[Документы о деятельности военных в Припяти за месяц]],
	Model			= "models/kek1ch/notes_writing_book_2.mdl",
	Weight			= 0.2,
	Category			= "Quest",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/items/121.png",
	IsQuest			= true,
})

