Inventory = Inventory or {}
Inventory.Items = Inventory.Items or {}


function Inventory:RegisterItem(id, itemTable)

	local ITEM = {}
	ITEM.Id 			= id
	ITEM.Name 			= itemTable.Name or id
	ITEM.Desc			= itemTable.Desc or ""
	ITEM.Model			= itemTable.Model or ""
	ITEM.Skin			= itemTable.Skin or 0
	ITEM.Weight 		= itemTable.Weight or 0.1
	ITEM.DefaultAmount	= itemTable.DefaultAmount or 1
	ITEM.Category		= itemTable.Category or "Other"
	ITEM.SizeX			= itemTable.SizeX or 1
	ITEM.SizeY			= itemTable.SizeY or 1
	ITEM.IconMat		= itemTable.IconMat or "icons/items/error.png"
	ITEM.IconColor		= itemTable.IconColor or nil
	ITEM.EffectsDesc 	= itemTable.EffectsDesc or nil
	
	ITEM.Usable			= itemTable.Usable or nil
	ITEM.DeleteOnUse	= itemTable.DeleteOnUse or true
	ITEM.Droppable		= itemTable.Droppable or true
	ITEM.CanStuck		= itemTable.CanStuck or nil

	ITEM.IsWeapon		= itemTable.IsWeapon or nil
	ITEM.IsArtifact		= itemTable.IsArtifact or nil
	ITEM.IsQuest		= itemTable.IsQuest or nil
	ITEM.IsMutant		= itemTable.IsMutant or nil
	ITEM.IsDevice		= itemTable.IsDevice or nil
	ITEM.IsArmor		= itemTable.IsArmor or nil
	ITEM.IsHelmet		= itemTable.IsHelmet or nil
	ITEM.IsAmmo			= itemTable.IsAmmo or nil

	ITEM.Weapon			= itemTable.Weapon or nil
	ITEM.ArmorModel		= itemTable.ArmorModel or nil
	ITEM.Art			= itemTable.Art or nil
	ITEM.ArmorTable		= itemTable.ArmorTable or nil
	ITEM.HelmetTable	= itemTable.HelmetTable or nil
	ITEM.Ammo			= itemTable.Ammo or nil

	ITEM.BasePrice 		= itemTable.BasePrice or 1
	
	ITEM.OnPlayerUse		= itemTable.OnPlayerUse or nil //function(ply) end
	//ITEM.OnPlayerSpawn		= itemTable.OnPlayerSpawn or nil //function(ply) end
	ITEM.OnPlayerGive		= itemTable.OnPlayerGive or nil //function(ply) end
	ITEM.OnArtifactEquip	= itemTable.OnArtifactEquip or nil //function(ply) end
	ITEM.OnArtifactUnEquip	= itemTable.OnArtifactUnEquip or nil //function(ply) end
	ITEM.OnArmorEquip		= itemTable.OnArmorEquip or nil //function(ply) end
	ITEM.OnArmorUnEquip		= itemTable.OnArmorUnEquip or nil //function(ply) end
	ITEM.OnHelmetEquip		= itemTable.OnHelmetEquip or nil //function(ply) end
	ITEM.OnHelmetUnEquip	= itemTable.OnHelmetUnEquip or nil //function(ply) end
	ITEM.OnQuickSlotEquip	= itemTable.OnQuickSlotEquip or nil //function(ply) end
	ITEM.OnQuickSlotUnEquip	= itemTable.OnQuickSlotUnEquip or nil //function(ply) end
	//ITEM.PrePlayerDeath		= itemTable.PrePlayerDeath or nil //function(ply, hitgroup, dmginfo) end
	ITEM.OnPlayerDeath		= itemTable.OnPlayerDeath or nil //function(victim, inflictor, attacker) end
	ITEM.OnRemoved			= itemTable.OnRemoved or nil //function(ent) end
	//ITEM.PostProcessEntity	= itemTable.PostProcessEntity or nil //function(ent) end
	//ITEM.Think				= itemTable.Think or nil//function() end

	Inventory.Items[id] = ITEM
end

function Inventory:GetItemByID(itemID)
	return Inventory.Items[itemID] or false
end