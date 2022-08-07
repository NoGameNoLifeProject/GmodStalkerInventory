hook.Add("Inventory:PostPlayerEquipQuickSlot", "Inventory:PostPlayerEquipQuickSlot", function(ply, itemId, amount, slot)
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.OnArtifactEquip then itemTable.OnQuickSlotEquip(ply) end
end)

hook.Add("Inventory:PostPlayerUnEquipQuickSlot", "Inventory:PostPlayerUnEquipQuickSlot", function(ply, itemId, amount, slot)
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.OnQuickSlotUnEquip then itemTable.OnQuickSlotUnEquip(ply) end
end)

hook.Add("Inventory:PostPlayerEquipArtSlot", "Inventory:PostPlayerEquipArtSlot", function(ply, itemId, data, slot)
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.OnArtifactEquip then itemTable.OnArtifactEquip(ply) end
end)

hook.Add("Inventory:PostPlayerUnEquipArtSlot", "Inventory:PostPlayerUnEquipArtSlot", function(ply, itemId, data, slot)
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.OnArtifactUnEquip then itemTable.OnArtifactUnEquip(ply) end
end)




hook.Add("Inventory:PostPlayerGiveItem", "Inventory:PostPlayerGiveItem", function(ply, itemId, amount, data, fromSlot)
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.IsAmmo then
		ply:SetAmmo(math.max(ply:GetAmmoCount(itemId) + amount, 0), itemId)
	end
	if itemTable.OnPlayerGive then itemTable.OnPlayerGive(ply) end
	if fromSlot then return end
	local slot = false
	if itemTable.IsWeapon then
		slot = ply:EmptyWeaponSlot()
	elseif itemTable.IsHelmet then
		if !ply:IsSlotEmpty("Armor") then
			local inventory = ply:GetBetterNWTable("Inventory")
			local id = inventory.CustomSlots["Armor"].ID
			local itemTableArmor = Inventory:GetItemByID(id)
			if !itemTableArmor.ArmorTable.Helmet then
				return
			end
		end
		slot = ply:IsSlotEmpty("Helmet") and "Helmet" or false
	elseif itemTable.IsArmor then
		if !ply:IsSlotEmpty("Helmet") then
			if !itemTable.ArmorTable.Helmet then
				return
			end
		end
		slot = ply:IsSlotEmpty("Armor") and "Armor" or false
	elseif itemTable.IsDevice then
		slot = ply:IsSlotEmpty("Device") and "Device" or false
	end
	if slot then
		ply:EquipAmmunation(itemId, data, slot)
	end
end)

hook.Add("Inventory:PostPlayerRemoveItem", "Inventory:PostPlayerRemoveItem", function(ply, itemId, amount)
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.IsAmmo then
		ply:SetAmmo(math.max(ply:GetAmmoCount(itemId) - amount, 0), itemId)
	end
	if itemTable.OnRemoved then itemTable.OnRemoved(ply) end
end)

hook.Add("TFA_PostCompleteReload", "Inventory:TFA_PostCompleteReload", function(weapon)
	local ammo1, ammo2 = game.GetAmmoName(weapon:GetPrimaryAmmoType()), game.GetAmmoName(weapon:GetSecondaryAmmoType())
	local item1 = Inventory:GetItemByID(ammo1)
	local item2 = Inventory:GetItemByID(ammo2)
	local ply = weapon:GetOwner()
	local inventory = ply:GetBetterNWTable("Inventory")
	local ammoCount, newAmmoCount
	if item1 then
		ammoCount = ply:GetAmmoCount(ammo1)
		inventory.Categories[item1.Category][item1.Id] = ammoCount > 0 and ammoCount or nil
	end
	if item2 then
		ammoCount = ply:GetAmmoCount(ammo2)
		inventory.Categories[item2.Category][item2.Id] = ammoCount > 0 and ammoCount or nil
	end
	if inventory.CustomSlots["FirstWeapon"] and inventory.CustomSlots["FirstWeapon"].Data.Guid == weapon.Data.Guid then
		inventory.CustomSlots["FirstWeapon"].Data.WeaponClip1 = weapon:Clip1()
		inventory.CustomSlots["FirstWeapon"].Data.WeaponClip2 = weapon:Clip2()
	elseif inventory.CustomSlots["SecondWeapon"] and inventory.CustomSlots["SecondWeapon"].Data.Guid == weapon.Data.Guid then
		inventory.CustomSlots["SecondWeapon"].Data.WeaponClip1 = weapon:Clip1()
		inventory.CustomSlots["SecondWeapon"].Data.WeaponClip2 = weapon:Clip2()
	end
	ply:SetBetterNWTable("Inventory", inventory, true)
	ply:SaveInventory()
end)

hook.Add("TFA_LoadShell", "Inventory:TFA_LoadShell", function(weapon)
	local ammo1 = game.GetAmmoName(weapon:GetPrimaryAmmoType())
	local item1 = Inventory:GetItemByID(ammo1)
	local ply = weapon:GetOwner()
	local inventory = ply:GetBetterNWTable("Inventory")
	if item1 then
		local ammoCount = inventory.Categories[item1.Category][item1.Id] - 1
		inventory.Categories[item1.Category][item1.Id] = ammoCount > 0 and ammoCount or nil
	end
	if inventory.CustomSlots["FirstWeapon"] and inventory.CustomSlots["FirstWeapon"].Data.Guid == weapon.Data.Guid then
		inventory.CustomSlots["FirstWeapon"].Data.WeaponClip1 = weapon:Clip1() - 1
		inventory.CustomSlots["FirstWeapon"].Data.WeaponClip2 = weapon:Clip2()
	elseif inventory.CustomSlots["SecondWeapon"] and inventory.CustomSlots["SecondWeapon"].Data.Guid == weapon.Data.Guid then
		inventory.CustomSlots["SecondWeapon"].Data.WeaponClip1 = weapon:Clip1() - 1
		inventory.CustomSlots["SecondWeapon"].Data.WeaponClip2 = weapon:Clip2()
	end
	ply:SetBetterNWTable("Inventory", inventory, true)
	ply:SaveInventory()
end)

hook.Add( "PostPlayerDeath", "Inventory:PostPlayerDeath", function( ply, inflictor, attacker )
	local inventory = ply:GetBetterNWTable("Inventory")
	local ragdoll = ply:GetRagdollEntity()
	local ent = ents.Create("prop_ragdoll")
	ent:SetPos(ply:GetPos())
	ent:SetModel(ply:GetModel())
	ent:SetAngles(ragdoll:GetAngles() or Angle(0, 0, 0))
	ragdoll:Remove()
	ent:Spawn()
	
	local entInventory = {}
	entInventory.Categories = {}
	for _, v in ipairs(Inventory.cfg.categories) do
		entInventory.Categories[v] = {}
	end
	entInventory.Info = {}
	entInventory.Info.Weight = 0
	
	local weight = 0
	for _, cat in ipairs(Inventory.cfg.deathLostCategories) do
		for k, v in pairs(inventory.Categories[cat]) do
			entInventory.Categories[cat][k] = v
			local itemTable = Inventory:GetItemByID(k)
			weight = weight + (istable(v) and itemTable.Weight * #v or itemTable.Weight * v)
			if itemTable.OnPlayerDeath then itemTable.OnPlayerDeath(ply) end
		end 
		inventory.Categories[cat] = {}
	end
	entInventory.Info.Weight = entInventory.Info.Weight + weight
	inventory.Info.Weight = inventory.Info.Weight - weight
	
	timer.Create("RemovePlayerRagDoll"..ent:GetCreationID(), 300, 1, function()
		if IsValid(ent) then ent:Remove() end
	end)

	ent:SetBetterNWTable("Inventory", entInventory, true)
	ply:SetBetterNWTable("Inventory", inventory, true)
	ply:SaveInventory()
end )

hook.Add("CanSurviveBlowout", "InventoryCanSurviveBlowout", function(ply)

	if !ply:GetNWBool("BlowoutProtected") then return end

	ply:SetNWBool("BlowoutProtected", false)
	return true

end)

hook.Add("PreBlowout", "Inventory:PreBlowout", function(power, forced)

	if forced then return end

	for _, ent in pairs(ents.FindByClass "inventory_item") do

		local itemTable = Inventory:GetItemByID(ent:GetItemID())
		if !(itemTable && itemTable.IsArtifact) then continue end

		ent:Remove()

	end

end)

hook.Add( "InitPostEntity", "Inventory:InitPostEntity", function()
	file.CreateDir( "ngnl" )
	file.CreateDir( "ngnl/inventory" )
	file.CreateDir( "ngnl/inventorybox" )
	file.CreateDir( "ngnl/traders" )
end)

hook.Add("PlayerSay", "Inventory:PlayerSay", function(ply, text)
	if text == "/traders" then
		if !(IsValid(ply) && ply:Alive()) then return "" end
		if ply:GetUserGroup() == 'founder' or serverguard.player:HasPermission(ply, "Manage Traders") then
			netstream.Start(ply, "Inventory:OpenTradersConfig", Inventory.Traders)
		end
		return ""
	end
end)