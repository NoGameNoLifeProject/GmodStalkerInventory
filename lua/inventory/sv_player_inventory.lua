Inventory = Inventory or {}

function Inventory:TransferItem(from, to, itemId, amount, data, fromSlot)
	Inventory:RemoveItem(from, itemId, data and data or amount)
	Inventory:AddItem(to, itemId, amount, data, fromSlot)
end

function Inventory:TransferItemPlayerBox(ply, dest, itemId, amount, data, fromSlot)
	if dest == "Player" then
		ply:RemoveItem(itemId, data and data or amount, true)
		ply:GiveItem(itemId, amount, data, nil, fromSlot)
	elseif dest == "PlayerBox" then
		ply:RemoveItem(itemId, data and data or amount)
		ply:GiveItem(itemId, amount, data, true, fromSlot)
	end
end

function pMeta:UseInventoryItem(itemId, amount, data, slot, container, isPlayerBox)
	if !itemId and slot then
		local inventory = self:GetBetterNWTable("Inventory")
		if !inventory.CustomSlots.QuickSlots[slot] then return end
		itemId = inventory.CustomSlots.QuickSlots[slot].ID
	end
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.OnPlayerUse then itemTable.OnPlayerUse(self) end
	if itemTable.DeleteOnUse then
		if slot then
			self:RemoveItemFromQuickSlot(slot, amount)
		elseif IsValid(container) then
			if isPlayerBox then
				self:RemoveItem(itemId, data or amount, true)
			else
				Inventory:RemoveItem(container, itemId, amount, data)
			end	
		else
			self:RemoveItem(itemId, data or amount)
		end
	end
end

function pMeta:PlayerGiveWeapon(itemId, data, slot)
	local weapons = self:GetWeapons()
	for _, weapon in ipairs(weapons) do
		if weapon.ItemId and weapon.ItemId == itemId then return end
	end
	local itemTable = Inventory:GetItemByID(itemId)
	local weapon = self:Give(itemTable.Weapon)
	weapon.ItemId = itemId
	weapon.Data = data
	if data.WeaponClip1 then
		weapon:SetClip1(data.WeaponClip1)
		weapon.Data.WeaponClip1 = data.WeaponClip1
	end
	if data.WeaponClip2 then
		weapon:SetClip2(data.WeaponClip2)
		weapon.Data.WeaponClip2 = data.WeaponClip2
	end
	local ammo1, ammo2 = game.GetAmmoName(weapon:GetPrimaryAmmoType()), game.GetAmmoName(weapon:GetSecondaryAmmoType())
	local item1 = Inventory:GetItemByID(ammo1)
	local item2 = Inventory:GetItemByID(ammo2)
	local inventory = self:GetBetterNWTable("Inventory")
	if item1 then
		if (inventory.Categories[item1.Category][item1.Id]) then
			self:SetAmmo(inventory.Categories[item1.Category][item1.Id], ammo1)
		end
	end
	if item2 then
		if (inventory.Categories[item2.Category][item2.Id]) then
			self:SetAmmo(inventory.Categories[item2.Category][item2.Id], ammo2)
		end
	end
end

function pMeta:PlayerUnEquipWeapon(itemId, data, slot, container, isPlayerBox)
	local weapons = self:GetWeapons()
	for _, weapon in ipairs(weapons) do
		if weapon.Data and weapon.Data.Guid and weapon.Data.Guid == data.Guid then
			local inventory
			if isPlayerBox then
				inventory = self:GetBetterNWTable("InventoryBox")
			elseif container then
				inventory = container:GetBetterNWTable("Inventory")
			else
				inventory = self:GetBetterNWTable("Inventory")
			end
			local itemTable = Inventory:GetItemByID(itemId)
			for k, v in ipairs(inventory.Categories[itemTable.Category][itemId]) do
				if v.Guid == data.Guid then
					inventory.Categories[itemTable.Category][itemId][k].WeaponClip1 = weapon:Clip1()
					inventory.Categories[itemTable.Category][itemId][k].WeaponClip2 = weapon:Clip2()
					if isPlayerBox then
						self:SetBetterNWTable("InventoryBox", inventory, true)
					elseif container then
						container:SetBetterNWTable("Inventory", inventory)
					else
						self:SetBetterNWTable("Inventory", inventory, true)
					end
					self:SaveInventory()
				end
			end
			weapon:Remove()
			break
		end
	end
end

function pMeta:PlayerEquipArmor(itemId, data, slot)
	local itemTable = Inventory:GetItemByID(itemId)
	self:SetModel(itemTable.ArmorModel)
	if itemTable.ArmorTable then
		for k, v in pairs(itemTable.ArmorTable.Effects) do
			self["Set"..k](self, self["Get"..k](self) + v)
		end
		if itemTable.ArmorTable.MaxWeight then
			local additionMaxWeight = self:GetNWFloat("Inventory:MaxWeight", Inventory.cfg.defaultMaxWeight) - Inventory.cfg.defaultMaxWeight
			self:SetNWFloat("Inventory:MaxWeight", itemTable.ArmorTable.MaxWeight + additionMaxWeight)
		end
		if itemTable.ArmorTable.Containters then
			self:SetNWInt("Inventory:Containters", itemTable.ArmorTable.Containters)
		end
	end
	if itemTable.OnArmorEquip then itemTable.OnArmorEquip(self) end
end

function pMeta:PlayerUnEquipArmor(itemId, data, slot)
	local itemTable = Inventory:GetItemByID(itemId)
	self:SetModel(Inventory.cfg.defaultPlayerModel)
	if itemTable.ArmorTable then
		for k, v in pairs(itemTable.ArmorTable.Effects) do
			self["Set"..k](self, self["Get"..k](self) - v)
		end
		if itemTable.ArmorTable.MaxWeight then
			self:SetNWFloat("Inventory:MaxWeight", self:GetNWFloat("Inventory:MaxWeight", Inventory.cfg.defaultMaxWeight) - itemTable.ArmorTable.MaxWeight + Inventory.cfg.defaultMaxWeight)
		end
	end
	self:SetNWInt("Inventory:Containters", 0)
	if itemTable.OnArmorUnEquip then itemTable.OnArmorUnEquip(self) end
end

function pMeta:PlayerEquipHelmet(itemId, data, slot)
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.HelmetTable then
		for k, v in pairs(itemTable.HelmetTable.Effects) do
			self["Set"..k](self, self["Get"..k](self) + v)
		end
	end
	if itemTable.OnHelmetEquip then itemTable.OnHelmetEquip(self) end
end

function pMeta:PlayerUnEquipHelmet(itemId, data, slot)
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.HelmetTable then
		for k, v in pairs(itemTable.HelmetTable.Effects) do
			self["Set"..k](self, self["Get"..k](self) - v)
		end
	end
	if itemTable.OnHelmetUnEquip then itemTable.OnHelmetUnEquip(self) end
end

function pMeta:PlayerGiveDevice(itemId, data, slot)
	local itemTable = Inventory:GetItemByID(itemId)
	local weapon = self:Give(itemTable.Weapon)
	weapon.ItemId = itemId
	weapon.Data = data
end

function pMeta:PlayerUnEquipDevice(itemId, data, slot)
	local weapons = self:GetWeapons()
	for _, weapon in ipairs(weapons) do
		if weapon.Data and weapon.Data.Guid and weapon.Data.Guid == data.Guid then
			weapon:Remove()
			break
		end
	end
end

function pMeta:TakeAll(container, isPlayerBox)
	if IsValid(container) then
		if isPlayerBox then
			inventory = self:GetBetterNWTable("InventoryBox")
		else
			inventory = container:GetBetterNWTable("Inventory")
		end
		local pInventory = self:GetBetterNWTable("Inventory")
		for k, v in pairs(inventory.Categories) do
			for itemId, item in pairs(v) do
				if istable(item) then
					for _, nItem in ipairs(item) do
						self:GiveItem(itemId, 1, nItem, nil, true)
						if isPlayerBox then
							self:RemoveItem(itemId, nItem, true)
						else
							Inventory:RemoveItem(container, itemId, nItem)
						end	
					end
				else
					self:GiveItem(itemId, item, nil, nil, true)
					if isPlayerBox then
						self:RemoveItem(itemId, item, true)
					else
						Inventory:RemoveItem(container, itemId, item)
					end	
				end
			end
		end
	end
end

function pMeta:EquipAmmunationFromAmmunation(from, to)
	local inventory = self:GetBetterNWTable("Inventory")
	if inventory.CustomSlots[from] then
		inventory.CustomSlots[to] = inventory.CustomSlots[from]
		inventory.CustomSlots[from] = false
		hook.Run("Inventory:PostPlayerEquipAmmunation", self, inventory.CustomSlots[to].ID, inventory.CustomSlots[to].Data, to)
		self:SetBetterNWTable("Inventory", inventory, true)
		self:SaveInventory()
	end
end

function pMeta:EquipAmmunation(itemId, data, slot, container, isPlayerBox)
	if !data or !istable(data) then return end
	if !slot then return end
	local itemTable = Inventory:GetItemByID(itemId)
	local inventory 
	local pInventory = self:GetBetterNWTable("Inventory")
	if IsValid(container) then
		if isPlayerBox then
			inventory = self:GetBetterNWTable("InventoryBox")
		else
			inventory = container:GetBetterNWTable("Inventory")
		end
	else
		inventory = pInventory
	end
	if inventory.Categories[itemTable.Category][itemId] then
		local exist = false
		for k, v in ipairs(inventory.Categories[itemTable.Category][itemId]) do
			if v.Guid == data.Guid then
				exist = true
			end
		end
		if !exist then return end
		if slot == "FirstWeapon" and itemTable.IsWeapon then
			pInventory.CustomSlots.FirstWeapon = {ID = itemId, Data = data}
			self:PlayerGiveWeapon(itemId, data, slot)
			hook.Run("Inventory:PostPlayerEquipWeapon", self, itemId, data, slot)
		elseif slot == "SecondWeapon" and itemTable.IsWeapon then
			pInventory.CustomSlots.SecondWeapon = {ID = itemId, Data = data}
			self:PlayerGiveWeapon(itemId, data, slot)
			hook.Run("Inventory:PostPlayerEquipWeapon", self, itemId, data, slot)
		elseif slot == "Helmet" and itemTable.IsHelmet then
			pInventory.CustomSlots.Helmet = {ID = itemId, Data = data}
			self:PlayerEquipHelmet(itemId, data, slot)
			hook.Run("Inventory:PostPlayerEquipHelmet", self, itemId, data, slot)
		elseif slot == "Armor" and itemTable.IsArmor then
			pInventory.CustomSlots.Armor = {ID = itemId, Data = data}
			self:PlayerEquipArmor(itemId, data, slot)
			hook.Run("Inventory:PostPlayerEquipArmor", self, itemId, data, slot)
		elseif slot == "Device" and itemTable.IsDevice then
			pInventory.CustomSlots.Device = {ID = itemId, Data = data}
			self:PlayerGiveDevice(itemId, data, slot)
			hook.Run("Inventory:PostPlayerEquipDevice", self, itemId, data, slot)
		else
			return
		end
		hook.Run("Inventory:PostPlayerEquipAmmunation", self, itemId, data, slot)
		self:SetBetterNWTable("Inventory", pInventory, true)
		self:SaveInventory()
		if IsValid(container) then
			if isPlayerBox then
				self:RemoveItem(itemId, data, true)
			else
				Inventory:RemoveItem(container, itemId, data)
			end	
		else
			self:RemoveItem(itemId, data)
		end
	end
end

function pMeta:UnEquipAmmunation(slot, container, isPlayerBox)
	if self:IsSlotEmpty(slot) then return end
	local inventory = self:GetBetterNWTable("Inventory")
	local item = inventory.CustomSlots[slot]
	local itemTable = Inventory:GetItemByID(item.ID)
	if IsValid(container) and isPlayerBox then
		self:RemoveItemFromSlot(slot)
		self:GiveItem(item.ID, 1, item.Data, true, true)
	elseif IsValid(container) then
		self:RemoveItemFromSlot(slot)
		Inventory:AddItem(container, item.ID, 1, item.Data, true)
	else
		self:RemoveItemFromSlot(slot)
		self:GiveItem(item.ID, 1, item.Data, nil, true)
	end
	if slot == "FirstWeapon" then
		self:PlayerUnEquipWeapon(item.ID, item.Data, slot, container, isPlayerBox)
		hook.Run("Inventory:PostPlayerUnEquipWeapon", self, item.ID, item.Data, slot)
	elseif slot == "SecondWeapon" then
		self:PlayerUnEquipWeapon(item.ID, item.Data, slot, container, isPlayerBox)
		hook.Run("Inventory:PostPlayerUnEquipWeapon", self, item.ID, item.Data, slot)
	elseif slot == "Helmet" then
		self:PlayerUnEquipHelmet(item.ID, item.Data, slot)
		hook.Run("Inventory:PostPlayerUnEquipHelmet", self, item.ID, item.Data, slot)
	elseif slot == "Armor" then
		self:PlayerUnEquipArmor(item.ID, item.Data, slot)
		hook.Run("Inventory:PostPlayerUnEquipArmor", self, item.ID, item.Data, slot)
	elseif slot == "Device" then
		self:PlayerUnEquipDevice(item.ID, item.Data, slot)
		hook.Run("Inventory:PostPlayerUnEquipDevice", self, item.ID, item.Data, slot)
	end
	hook.Run("Inventory:PostPlayerUnEquipAmmunation", self, item.ID, item.Data, slot)
end

function pMeta:EquipQuickSlotFromQuickSlot(from, to)
	local inventory = self:GetBetterNWTable("Inventory")
	if inventory.CustomSlots.QuickSlots[from] then
		inventory.CustomSlots.QuickSlots[to] = inventory.CustomSlots.QuickSlots[from]
		inventory.CustomSlots.QuickSlots[from] = false
		hook.Run("Inventory:PostPlayerEquipQuickSlot", self, inventory.CustomSlots.QuickSlots[to].ID, inventory.CustomSlots.QuickSlots[to].Amount, to)
		self:SetBetterNWTable("Inventory", inventory, true)
		self:SaveInventory()
	end
end

function pMeta:EquipQuickSlot(itemId, amount, slot, container, isPlayerBox)
	if !slot then return end
	local itemTable = Inventory:GetItemByID(itemId)
	local inventory 
	local pInventory = self:GetBetterNWTable("Inventory")
	if IsValid(container) then
		if isPlayerBox then
			inventory = self:GetBetterNWTable("InventoryBox")
		else
			inventory = container:GetBetterNWTable("Inventory")
		end
	else
		inventory = pInventory
	end
	if inventory.Categories[itemTable.Category][itemId] then
		pInventory.CustomSlots.QuickSlots[slot] = {ID = itemId, Amount = amount}
		hook.Run("Inventory:PostPlayerEquipQuickSlot", self, itemId, amount, slot)
		self:SetBetterNWTable("Inventory", pInventory, true)
		self:SaveInventory()
		if IsValid(container) then
			if isPlayerBox then
				self:RemoveItem(itemId, amount, true)
			else
				Inventory:RemoveItem(container, itemId, amount)
			end
		else
			self:RemoveItem(itemId, amount)
		end
	end
end

function pMeta:UnEquipQuickSlot(slot, container, isPlayerBox)
	if self:IsQuickSlotEmpty(slot) then return end
	local inventory = self:GetBetterNWTable("Inventory")
	local item = inventory.CustomSlots.QuickSlots[slot]
	local itemTable = Inventory:GetItemByID(item.ID)
	if IsValid(container) and isPlayerBox then
		self:RemoveItemFromQuickSlot(slot)
		self:GiveItem(item.ID, 1, item.Amount, true)
	elseif IsValid(container) then
		self:RemoveItemFromQuickSlot(slot)
		Inventory:AddItem(container, item.ID, item.Amount)
	else
		self:RemoveItemFromQuickSlot(slot)
		self:GiveItem(item.ID, item.Amount)
	end
	hook.Run("Inventory:PostPlayerUnEquipQuickSlot", self, item.ID, item.Amount, slot)
end

function pMeta:EquipArtSlotFromArtSlot(from, to)
	local inventory = self:GetBetterNWTable("Inventory")
	if inventory.CustomSlots.Artifacts[from] then
		inventory.CustomSlots.Artifacts[to] = inventory.CustomSlots.Artifacts[from]
		inventory.CustomSlots.Artifacts[from] = false
		hook.Run("Inventory:PostPlayerEquipArtSlot", self, inventory.CustomSlots.Artifacts[to].ID, inventory.CustomSlots.Artifacts[to].Data, to)
		self:SetBetterNWTable("Inventory", inventory, true)
		self:SaveInventory()
	end
end

function pMeta:EquipArtSlot(itemId, data, slot, container, isPlayerBox)
	if !data or !istable(data) then return end
	if !slot then return end
	local itemTable = Inventory:GetItemByID(itemId)
	local inventory 
	local pInventory = self:GetBetterNWTable("Inventory")
	if IsValid(container) then
		if isPlayerBox then
			inventory = self:GetBetterNWTable("InventoryBox")
		else
			inventory = container:GetBetterNWTable("Inventory")
		end
	else
		inventory = pInventory
	end
	if inventory.Categories[itemTable.Category][itemId] then
		local exist = false
		for k, v in ipairs(inventory.Categories[itemTable.Category][itemId]) do
			if v.Guid == data.Guid then
				exist = true
			end
		end
		if !exist then return end
		pInventory.CustomSlots.Artifacts[slot] = {ID = itemId, Data = data}
		hook.Run("Inventory:PostPlayerEquipArtSlot", self, itemId, data, slot)
		self:SetBetterNWTable("Inventory", pInventory, true)
		self:SaveInventory()
		if IsValid(container) then
			if isPlayerBox then
				self:RemoveItem(itemId, data, true)
			else
				Inventory:RemoveItem(container, itemId, data)
			end
		else
			self:RemoveItem(itemId, data)
		end
	end
end

function pMeta:UnEquipArtSlot(slot, container, isPlayerBox)
	if self:IsArtSlotEmpty(slot) then return end
	local inventory = self:GetBetterNWTable("Inventory")
	local item = inventory.CustomSlots.Artifacts[slot]
	local itemTable = Inventory:GetItemByID(item.ID)
	if IsValid(container) and isPlayerBox then
		self:RemoveItemFromArtSlot(slot)
		self:GiveItem(item.ID, 1, item.Data, true)
	elseif IsValid(container) then
		self:RemoveItemFromArtSlot(slot)
		Inventory:AddItem(container, item.ID, 1, item.Data)
	else
		self:RemoveItemFromArtSlot(slot)
		self:GiveItem(item.ID, 1, item.Data)
	end
	hook.Run("Inventory:PostPlayerUnEquipArtSlot", self, item.ID, item.Data, slot)
end

function pMeta:RemathInventoryWeight()
	local inventory = self:GetBetterNWTable("Inventory")
	local weight = 0
	for _, cat in pairs(inventory.Categories) do
		for k, v in pairs(cat) do
			local itemTable = Inventory:GetItemByID(k)
			if itemTable then
				weight = weight + itemTable.Weight * (istable(v) and 1 or v)
			end
		end
	end
	inventory.Info.Weight = math.max(math.Round(weight, 2), 0)
end

function pMeta:ClearPlayerInventoryEffects()
	self:ClearStatEffects()
	for _, v in pairs(Inventory.cfg.entityVars) do
		self["Set"..v](self, 0)
	end
	self:SetModel(Inventory.cfg.defaultPlayerModel)
	self:SetNWFloat("Inventory:MaxWeight", Inventory.cfg.defaultMaxWeight)
	self:SetNWInt("Inventory:Containters", 0)
end

function eMeta:CreateInventory()
	local inventory = {}
	inventory.Categories = {}
	for _, v in ipairs(Inventory.cfg.categories) do
		inventory.Categories[v] = {}
	end
	inventory.Info = {}
	inventory.Info.Weight = 0
	self:SetBetterNWTable("Inventory", inventory)
end

function Inventory:LockEntity(ent)
	ent:SetNWBool("IsLocked", true)
end

function Inventory:UnLockEntity(ent)
	ent:SetNWBool("IsLocked", false)
end

netstream.Hook("Inventory:SyncEntityInventory", function(ply, ent, open)
	netstream.Start(ply, "Inventory:SyncEntityInventory", ent, ent:GetBetterNWTable("Inventory"), open)
end)

netstream.Hook("Inventory:LockEntity", function(ply, ent)
	Inventory:LockEntity(ent)
end)

netstream.Hook("Inventory:UnLockEntity", function(ply, ent)
	Inventory:UnLockEntity(ent)
end)

netstream.Hook("Inventory:UseInventoryItem", function(ply, itemId, amount, data, slot, container, isPlayerBox)
	ply:UseInventoryItem(itemId, amount, data, slot, container, isPlayerBox)
end)

netstream.Hook("Inventory:TakeAll", function(ply, container, isPlayerBox)
	ply:TakeAll(container, isPlayerBox)
end)

netstream.Hook("Inventory:EquipArtSlotFromArtSlot", function(ply, from, to)
	ply:EquipArtSlotFromArtSlot(from, to)
end)

netstream.Hook("Inventory:EquipArtSlot", function(ply, itemId, data, slot, container, isPlayerBox)
	ply:EquipArtSlot(itemId, data, slot, container, isPlayerBox)
end)

netstream.Hook("Inventory:UnEquipArtSlot", function(ply, slot, container, isPlayerBox)
	ply:UnEquipArtSlot(slot, container, isPlayerBox)
end)

netstream.Hook("Inventory:EquipQuickSlotFromQuickSlot", function(ply, from, to)
	ply:EquipQuickSlotFromQuickSlot(from, to)
end)

netstream.Hook("Inventory:EquipQuickSlot", function(ply, itemId, amount, slot, container, isPlayerBox)
	ply:EquipQuickSlot(itemId, amount, slot, container, isPlayerBox)
end)

netstream.Hook("Inventory:UnEquipQuickSlot", function(ply, slot, container, isPlayerBox)
	ply:UnEquipQuickSlot(slot, container, isPlayerBox)
end)

netstream.Hook("Inventory:EquipAmmunationFromAmmunation", function(ply, from, to)
	ply:EquipAmmunationFromAmmunation(from, to)
end)

netstream.Hook("Inventory:EquipAmmunation", function(ply, itemId, data, slot, container, isPlayerBox)
	ply:EquipAmmunation(itemId, data, slot, container, isPlayerBox)
end)

netstream.Hook("Inventory:UnEquipAmmunation", function(ply, slot, container, isPlayerBox)
	ply:UnEquipAmmunation(slot, container, isPlayerBox)
end)

netstream.Hook("Inventory:TransferItem", function(ply, from, to, itemId, amount, data, fromSlot)
	Inventory:TransferItem(from, to, itemId, amount, data, fromSlot)
end)

netstream.Hook("Inventory:TransferItemPlayerBox", function(ply, dest, itemId, amount, data, fromSlot)
	Inventory:TransferItemPlayerBox(ply, dest, itemId, amount, data, fromSlot)
end)