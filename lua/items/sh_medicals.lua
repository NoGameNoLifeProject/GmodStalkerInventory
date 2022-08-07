Inventory:RegisterItem("medkit1", {
	Name			= "Аптечка",
	Desc			= [[Обычная универсальная аптечка военного назначения.]],
	Model			= "models/kek1ch/dev_aptechka_low.mdl",
	Weight			= 0.4,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/medkit.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:RemoveStatEffect("bleeding")
		ply:GiveStatEffect("regeneration", 5, 10)
	end
})

Inventory:RegisterItem("medkit2", {
	Name			= "Армейская аптечка",
	Desc			= [[Усовершенствованный вариант обычной аптечки военного назначения.]],
	Model			= "models/kek1ch/dev_aptechka_high.mdl",
	Weight			= 0.4,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/armymedkit.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:RemoveStatEffect("bleeding")
		ply:GiveStatEffect("regeneration", 5, 14)
	end
})

Inventory:RegisterItem("medkit3", {
	Name			= "Научная аптечка",
	Desc			= [[Усовершенствованный медицинский набор, разработаный специально для условий Зоны.]],
	Model			= "models/kek1ch/dev_aptechka_mid.mdl",
	Weight			= 0.4,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/sciencemedkit.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:RemoveStatEffect("bleeding")
		ply:GiveStatEffect("regeneration", 9, 10)
		if ply:GetEffect("radiation") then
			local radiation = ply:GetEffect("radiation").Force
			if (radiation - 5 <= 0) then
				ply:RemoveStatEffect("radiation")
			else
				ply:AdjustStatEffect("radiation", 0, -5)
			end
		end
	end
})

Inventory:RegisterItem("bandage", {
	Name			= "Бинт",
	Desc			= [[Простой перевязочный материал для остановки кровотечения.]],
	Model			= "models/kek1ch/dev_bandage.mdl",
	Weight			= 0.1,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/bandage.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:GiveStatEffect("regeneration", 2, 5)
		if ply:GetEffect("bleeding") then
			local bleeding = ply:GetEffect("bleeding").Force
			if (bleeding - 1 <= 0) then
				ply:RemoveStatEffect("bleeding")
			else
				ply:AdjustStatEffect("bleeding", 0, -1)
			end
		end
	end
})

Inventory:RegisterItem("antirads", {
	Name			= "Противорадиационные препараты",
	Desc			= [[Набор таблеток, выводящий радионуклиды из организма.]],
	Model			= "models/kek1ch/dev_antirad.mdl",
	Weight			= 0.05,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/antirad.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:RemoveStatEffect("radiation")
	end
})

Inventory:RegisterItem("antidote", {
	Name			= "Антидот",
	Desc			= [[Медицинский препарат, защищает от химического воздействия.]],
	Model			= "models/kek1ch/drug_antidot.mdl",
	Weight			= 0.06,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/antiraddrugs.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:SetChemicalDef(ply:GetChemicalDef() + 100)
		timer.Simple(60, function()
			ply:SetChemicalDef(ply:GetChemicalDef() - 100)
		end)
	end
})

Inventory:RegisterItem("anabiotic", {
	Name			= "Анабиотик",
	Desc			= [[Экспериментальный медицинский препарат, позволяет пережить Выброс.]],
	Model			= "models/kek1ch/drug_anabiotic.mdl",
	Weight			= 0.01,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/anabiotic.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:SetNWBool("BlowoutProtected", true)
	end
})

Inventory:RegisterItem("radioprotectant", {
	Name			= "Радиопротектор",
	Desc			= [[Препарат, защищающий от радиации.]],
	Model			= "models/kek1ch/drug_radioprotector.mdl",
	Weight			= 0.01,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/radioprotector.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:SetRadiationDef(ply:GetRadiationDef() + 100)
		timer.Simple(60, function()
			ply:SetRadiationDef(ply:GetRadiationDef() - 100)
		end)
	end
})

Inventory:RegisterItem("hercules", {
	Name			= "Геркулес",
	Desc			= [[Стимулирующий препарат, уменьшающий утомляемость мышц. Это помогает испытывать большие нагрузки с меньшим расходом силы и энергии.]],
	Model			= "models/kek1ch/drug_booster.mdl",
	Weight			= 0.5,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/hercules.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:GiveStatEffect("weight", 240, 20)
	end
})

Inventory:RegisterItem("psiblockade", {
	Name			= "Пси-блокада",
	Desc			= [[Препарат для защиты от пси-излучения.]],
	Model			= "models/chernobyl/item/medical/psy_pills.mdl",
	Weight			= 0.02,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/psiblockade.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:SetPsyDef(ply:GetPsyDef() + 100)
		timer.Simple(60, function()
			ply:SetPsyDef(ply:GetPsyDef() - 100)
		end)
	end
})

Inventory:RegisterItem("periwinkle", {
	Name			= "Барвинок",
	Desc			= [[Медицинский препарат, ускоряющий заживление ран.]],
	Model			= "models/kek1ch/drug_cat_eye.mdl",
	Weight			= 0.02,
	Category		= "Medicals",
	SizeX			= 1,
	SizeY			= 1,
	IconMat			= "icons/medicals/periwinkle.png",
	Usable			= true,
	CanStuck		= true,
	OnPlayerUse		= function(ply)
		ply:GiveStatEffect("regeneration", 60, 1)
	end
})