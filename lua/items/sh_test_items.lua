Inventory:RegisterItem("vodka", {
   Name			= "Водка",
   Desc			= [[Экспериментальный образец военного экзоскелета. 
                  В серийное производство не пошёл ввиду чрезвычайно высокой себестоимости и некоторых огрехов в проектировании. 
                  Несмотря на это, из-за возможности значительно увеличивать мобильность носителя пользуется спросом и потому негласно выпускается малыми партиями за пределами Украины. 
                  Оснащён встроенным контейнером для артефактов.]],
   Model			= "models/chernobyl/item/food/vokda.mdl",
   Weight 		= 0.1,
   SizeX			= 1,
   SizeY			= 1,
   Usable 		= true,
   CanStuck		= true,
   DefaultAmount = 3,
   BasePrice   = 100,
   IconMat 		= "icons/food/vodka.png",
   OnPlayerUse = function(ply)
      ply:ViewPunch(Angle(math.random(-179, 179), math.random(-179, 179), math.random(-179, 179)))
   end
})

Inventory:RegisterItem("TestArtelectramoonlight", {
   Name         = "Тест Лунный свет",
   Desc         = "Данный артефакт электростатической природы демонстрирует способность к резонансу под воздействием пси-волн.",
   Model        = "models/predatorcz/stalker/artifacts/electra_moonlight.mdl",
   Art          = "electra_moonlight",
   IsArtifact   = true,
   Weight       = 1,
   SizeX        = 1,
   SizeY        = 1,
   //Category     = "Artifacts",
   BasePrice   = 2000,
   IconMat      = "icons/arts/artelectramoonlight.png",
   OnArtifactEquip = function(ply)
      print("Equip")
   end,
   OnArtifactUnEquip = function(ply)
      print("UnEquip")
   end,
})

Inventory:RegisterItem("TestFreeRE1", {
   Name         = "Бронекостюм Комменданта",
   Desc         = "Комбинезон сталкера с усиленным бронежилетом, производимый ремесленниками группировки «Свобода», — удачное сочетание броневой и аномальной защит. Встроенный бронежилет из бронепластин и уложенного в несколько слоёв кевлара способен остановить пистолетную пулю. Для защиты от малых аномальных воздействий ткань костюма пропитана составом «Суверен».»",
   Model        = "models/chernobyl/outfit/freedom_heavy.mdl",
   ArmorModel   = "models/stalkertnb/beri_free.mdl", -- моделька игрока с броней
   IsArmor      = true,
   Weight       = 15,
   SizeX        = 2,
   SizeY        = 2,
   BasePrice    = 5000,
   //Category     = "Armor"
   IconMat      = "icons/armor/80.png",
   ArmorTable      = {
      Effects = {
         RadiationDef = 40, --Радиационная защита
         ChemicalDef = 40, --Химическая защита
         ElectricalDef = 40, --Электро защита
         ThermalDef = 40, --Термическая защита
         PsyDef = 0, --Пси защита
         ImpactDef = 55, --Защита от удара
         BlastDef = 50, --Защиты от взрыва
         BulletDef = 65, --Пулестойкость
      },
      Stamina = 0, --Восстановление выносливости
      MaxWeight = 20, --Макс. переносимый вес
      Containters = 1, --Кол-во контейнеров
      Helmet = true, --Использует отдельный шлем
   },
   EffectsDesc  = {
      [1] = {title = "Радиационная защита", value = "40", unit = "%", state = 1},
      [2] = {title = "Химическая защита", value = "40", unit = "%", state = 1},
      [3] = {title = "Электро защита", value = "40", unit = "%", state = 1},
      [4] = {title = "Термическая защита", value = "40", unit = "%", state = 1},
      [5] = {title = "Пси защита", value = "0", unit = "%", state = 2},
      [6] = {title = "Защита от удара", value = "55", unit = "%", state = 1},
      [7] = {title = "Защита от взрыва", value = "50", unit = "%", state = 1},
      [8] = {title = "Пулестойкость", value = "65", unit = "%", state = 1},
      [9] = {title = "Макс. переносимый вес", value = "20", unit = "кг", state = 3},
   }
})

Inventory:RegisterItem("TestTacticalhelmet", {
   Name         = "Тактический шлем",
   Desc         = "Западный образец тактического шлема, лишённый какой-либо маркировки. Предназначен для обеспечения командира подразделения максимальным количеством тактической информации при установке соответствующей электронной «начинки». Отличается усиленной конструкцией; кроме того, оснащён многослойной кевларовой защитой, респиратором и прибором ночного видения.",
   Model        = "models/kek1ch/helm_battle.mdl",
   IsHelmet     = true,
   Weight       = 4,
   SizeX        = 1,
   SizeY        = 1,
   BasePrice    = 2000,
   //Category     = "Armor",
   IconMat      = "icons/armor/tacticalhelmet.png",
   HelmetTable  = {
      Effects = {
         RadiationDef = 2, --Радиационная защита
         ChemicalDef = 3, --Химическая защита
         PsyDef = 14, --Пси защита
         BulletDef = 21, --Пулестойкость
      },
      NVD = 1, --уровень пнв
   }
})

/*Inventory:RegisterItem("Stlaker_5.45x39мм", {
   Name              = "Патроны 5.45х39",
   Desc              = "Патроны для советских штурмовых винтовок",
   Model             = "models/chernobyl/ammo/545x39.mdl",
   Ammo              = "Stlaker_5.45x39мм",
   Weight            = 0.01,
   SizeX             = 1,
   SizeY             = 1,
   IsAmmo            = true,
   DefaultAmount     = 30,
   CanStuck          = true,
   //Category          = "Ammo",
   IconMat           = "icons/ammo/54539.png",
})*/

Inventory:RegisterItem("TestWeaponak74m", {
   Name         = "AK-74M",
   Desc         = "АК-74 модернизированный. Оснащён складывающимся на левый бок полимерным прикладом и универсальным креплением (планка «ласточкин хвост») для крепления прицелов, как оптических, так и ночных, на левой стороне ствольной коробки. Таким образом АК-74М заменил сразу четыре модели: АК-74, АКС-74, АК-74Н и АКС-74Н. \n Средния точность и убойность вместе с довольно средней скорострельностью, характеризуют её как самую дешёвую штурмовую винтовку. \n в Зоне, но найти на просторах Зоны эту винтовку крайне легко.",
   Model        = "models/smc/ak74m/w_ak74m_farengar.mdl",
   Weapon       = "tfa_ins2_ak74m",
   IsWeapon     = true,
   Weight       = 6,
   SizeX        = 6,
   SizeY        = 2,
   BasePrice    = 3451,
   //Category     = "Weapons",
   IconMat      = "icons/weapons/ak74m.png",
})

Inventory:RegisterItem("TestMedkit1", {
   Name         = "Аптечка",
   Desc         = "Обычная универсальная аптечка военного назначения.",
   Model        = "models/kek1ch/dev_aptechka_low.mdl",
   Weight       = 0.4,
   SizeX        = 1,
   SizeY        = 1,
   Usable       = true,
   CanStuck     = true,
   BasePrice    = 100,
   IconMat      = "icons/medicals/medkit.png",
   //Category     = "Meicals"
   //OnPlayerUse  = function(ply)
   //   ply:InventoryRegenerationAdd(10, 5)
   //   ply:SetNWBool("Bleeding", false)
   //end
})

Inventory:RegisterItem("TestDetectorveles", {
   Name         = "Детектор Велес",
   Desc         = "«Велес» — современный детектор, позволяющий находить все известные науке артефакты, положение которых отображается на дисплее. ",
   Model        = "models/kali/miscstuff/stalker/detector_veles.mdl",
   Weapon       = "detector_veles_n",
   IsDevice      = true,
   Weight       = 1,
   SizeX        = 1,
   SizeY        = 1,
   BasePrice    = 6000,
   //Category     = "Weapons",
   IconMat      = "icons/weapons/detectorveles.png",
})