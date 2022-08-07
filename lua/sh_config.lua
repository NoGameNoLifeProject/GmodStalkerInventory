Inventory = Inventory or {}
Inventory.cfg = Inventory.cfg or {}

Inventory.cfg.defaultPlayerModel = "models/stalkertnb/bandit3.mdl"
Inventory.cfg.defaultMaxWeight = 30
Inventory.cfg.limitEntities = 260
Inventory.cfg.categories = {
	[1] = "Medicals",
	[2] = "Food",
	[3] = "Quest",
	[4] = "Artifacts",
	[5] = "Mutants",
	[6] = "Weapons",
	[7] = "Ammo",
	[8] = "Armor",
	[9] = "Other"
}

Inventory.cfg.deathLostCategories = {
	[1] = "Medicals",
	[2] = "Food",
	[3] = "Quest",
	[4] = "Artifacts",
	[5] = "Mutants",
	[6] = "Ammo"
}

Inventory.cfg.entityVars = {
	[1] = "ImpactDef",
	[2] = "BulletDef",
	[3] = "ThermalDef",
	[4] = "ChemicalDef",
	[5] = "ElectricalDef",
	[6] = "RadiationDef",
	[7] = "PsyDef",
	[8] = "BlastDef"
}

if CLIENT then
	Inventory.cfg.vgui = Inventory.cfg.vgui or {}
	Inventory.cfg.vgui.colors = Inventory.cfg.vgui.colors or {}
	Inventory.cfg.vgui.fonts = Inventory.cfg.vgui.fonts or {}

	Inventory.cfg.vgui.colors.backgrundColor = Color(0, 0, 0, 180)
	Inventory.cfg.vgui.colors.mainColor = Color(28, 27, 27, 125)
	Inventory.cfg.vgui.colors.mainTextColor = Color(240, 240, 240, 240)
	Inventory.cfg.vgui.colors.greenColor = Color(0, 217, 54, 240)
	Inventory.cfg.vgui.colors.warnColor = Color(255, 127, 8, 240)
	Inventory.cfg.vgui.colors.redColor = Color(242, 0, 0, 240)
	Inventory.cfg.vgui.colors.hoveredColor = Color(220,220,220,25)
	Inventory.cfg.vgui.colors.disabledColor = Color(46, 46, 46,100)

	hook.Add("PostGamemodeLoaded", "Inventory:cfg.PostGamemodeLoaded", function()
		Inventory.cfg.vgui.fonts.theme14 = Font(FONT_PDA, 14, 300)
		Inventory.cfg.vgui.fonts.theme20 = Font(FONT_PDA, 18, 300)
		Inventory.cfg.vgui.fonts.theme30 = Font(FONT_PDA, 24, 300)
		Inventory.cfg.vgui.fonts.symbol20 = Font(FONT_SYMBOL, 20, 300)
		Inventory.cfg.vgui.fonts.symbol30 = Font(FONT_SYMBOL, 30, 300)
		Inventory.cfg.vgui.fonts.paint20 = Font(FONT_PAINT, 20, 300)
		Inventory.cfg.vgui.fonts.paint30 = Font(FONT_PAINT, 30, 300)
	end)

	Inventory.cfg.vgui.gridCellSize = 64

	Inventory.cfg.effectsIcons = {
		["bleeding"] = {
			[1] = Material("icons/effects/258.png"),
			[2] = Material("icons/effects/220.png"),
			[3] = Material("icons/effects/227.png"),
			[4] = Material("icons/effects/234.png"),
		},
		["psi"] = {
			[1] = Material("icons/effects/267.png"),
			[2] = Material("icons/effects/240.png"),
			[3] = Material("icons/effects/244.png"),
			[4] = Material("icons/effects/248.png"),
		},
		["radiation"] = {
			[1] = Material("icons/effects/263.png"),
			[2] = Material("icons/effects/225.png"),
			[3] = Material("icons/effects/232.png"),
			[4] = Material("icons/effects/239.png"),
		},
		["regeneration"] = {
			[1] = Material("icons/effects/255.png"),
			[2] = Material("icons/effects/255.png"),
			[3] = Material("icons/effects/268.png"),
			[4] = Material("icons/effects/268.png"),
		},
		["burn"] = {
			[1] = Material("icons/effects/266.png"),
			[2] = Material("icons/effects/241.png"),
			[3] = Material("icons/effects/245.png"),
			[4] = Material("icons/effects/249.png"),
		},
		["chemical"] = {
			[1] = Material("icons/effects/264.png"),
			[2] = Material("icons/effects/243.png"),
			[3] = Material("icons/effects/247.png"),
			[4] = Material("icons/effects/251.png"),
		},
		["stamina"] = {
			[1] = Material("icons/effects/269.png"),
			[2] = Material("icons/effects/269.png"),
			[3] = Material("icons/effects/269.png"),
			[4] = Material("icons/effects/269.png"),
		},
		["weight"] = {
			[1] = Material("icons/effects/256.png"),
			[2] = Material("icons/effects/256.png"),
			[3] = Material("icons/effects/256.png"),
			[4] = Material("icons/effects/256.png"),
		},
	}
end

pMeta = FindMetaTable( 'Player' )
eMeta = FindMetaTable( 'Entity' )

hook.Add("InitPostEntity", "Inventory:InitPostEntity", function()
	if serverguard then serverguard.permission:Add("Spawn Inventory Items") end
	if serverguard then serverguard.permission:Add("Manage Traders") end
end)

//hook "OnItemSpawned" (self)

//hook "Inventory:PrePlayerGiveItem" (ply, itemId, amount, data, fromSlot) return true to prevent
//hook "Inventory:PostPlayerGiveItem" (ply, itemId, amount, data, fromSlot)
//hook "Inventory:PrePlayerRemoveItem" (ply, itemId, amount) return true to prevent
//hook "Inventory:PostPlayerRemoveItem" (ply, itemId, amount)
//hook "Inventory:PreInventoryRemoveItem" (ent, itemId, amount, data) return true to prevent
//hook "Inventory:PostInventoryRemoveItem" (ent, itemId, amount, data)
//hook "Inventory:PreInventoryAddItem" (ent, itemId, amount, data) return true to prevent
//hook "Inventory:PostInventoryAddItem" (ent, itemId, amount, data)

//hook "Inventory:PostPlayerEquipAmmunation" (ply, itemId, data, slot)
//hook "Inventory:PostPlayerEquipQuickSlot" (ply, itemId, amount, slot)
//hook "Inventory:PostPlayerEquipArtSlot" (ply, itemId, data, slot)
//hook "Inventory:PostPlayerUnEquipAmmunation" (ply, itemId, data, slot)
//hook "Inventory:PostPlayerUnEquipQuickSlot" (ply, itemId, amount, slot)
//hook "Inventory:PostPlayerUnEquipArtSlot" (ply, itemId, data, slot)

//hook "Inventory:PostPlayerEquipWeapon" (ply, itemId, data, slot)
//hook "Inventory:PostPlayerEquipHelmet" (ply, itemId, data, slot)
//hook "Inventory:PostPlayerEquipArmor" (ply, itemId, data, slot)
//hook "Inventory:PostPlayerEquipDevice" (ply, itemId, data, slot)

//hook "Inventory:PostPlayerUnEquipWeapon" (ply, itemId, data, slot)
//hook "Inventory:PostPlayerUnEquipHelmet" (ply, itemId, data, slot)
//hook "Inventory:PostPlayerUnEquipArmor" (ply, itemId, data, slot)
//hook "Inventory:PostPlayerUnEquipDevice" (ply, itemId, data, slot)