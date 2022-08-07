Inventory = Inventory or {}
Inventory.Items = Inventory.Items or {}

function pMeta:GiveItem(id, amount, data, isPlayerBox, fromSlot)
	amount = amount or 1
	data = data or {}
	if hook.Run("Inventory:PrePlayerGiveItem", self, id, amount, data, fromSlot) then return end
	local itemTable = Inventory:GetItemByID(id)
	local inventory = isPlayerBox and self:GetBetterNWTable("InventoryBox") or self:GetBetterNWTable("Inventory")
	if itemTable.CanStuck then
		inventory.Categories[itemTable.Category][id] = inventory.Categories[itemTable.Category][id] and inventory.Categories[itemTable.Category][id] + amount or amount
	else
		inventory.Categories[itemTable.Category][id] = inventory.Categories[itemTable.Category][id] or {}
		table.insert(inventory.Categories[itemTable.Category][id], data)
	end
	inventory.Info.Weight = math.Round(inventory.Info.Weight + itemTable.Weight * amount, 2)
	if isPlayerBox then 
		self:SetBetterNWTable("InventoryBox", inventory, true)
	else
		self:SetBetterNWTable("Inventory", inventory, true)
		hook.Run("Inventory:PostPlayerGiveItem", self, id, amount, data, fromSlot)
	end
	self:SaveInventory()
end

function pMeta:DropItem(id, amount)
	amount = amount or 1
	Inventory:CreateItem(id, self, isnumber(amount) and amount or 1, istable(amount) and amount or nil)
	self:RemoveItem(id, amount)
end

function pMeta:DropItemFromSlot(slot)
	local inventory = self:GetBetterNWTable("Inventory")
	if inventory.CustomSlots[slot] then
		local item = inventory.CustomSlots[slot]
		Inventory:CreateItem(item.ID, self, 1, item.Data)
		self:UnEquipAmmunation(slot)
		self:RemoveItem(item.ID, item.Data)
	end
end

function pMeta:DropItemFromQuickSlot(slot)
	local inventory = self:GetBetterNWTable("Inventory")
	if inventory.CustomSlots.QuickSlots[slot] then
		local item = inventory.CustomSlots.QuickSlots[slot]
		Inventory:CreateItem(item.ID, self, item.Amount)
		self:RemoveItemFromQuickSlot(slot)
	end
end

function pMeta:DropItemFromArtSlot(slot)
	local inventory = self:GetBetterNWTable("Inventory")
	if inventory.CustomSlots.Artifacts[slot] then
		local item = inventory.CustomSlots.Artifacts[slot]
		Inventory:CreateItem(item.ID, self, 1, item.Data)
		self:RemoveItemFromArtSlot(slot)
	end
end

function pMeta:RemoveItem(id, amount, isPlayerBox)
	amount = amount or 1
	if hook.Run("Inventory:PrePlayerRemoveItem", self, id, amount) then return end
	local itemTable = Inventory:GetItemByID(id)
	local inventory = isPlayerBox and self:GetBetterNWTable("InventoryBox") or self:GetBetterNWTable("Inventory")
	if istable(amount) then
		for k, v in ipairs(inventory.Categories[itemTable.Category][id]) do
			if v.Guid == amount.Guid then
				table.remove(inventory.Categories[itemTable.Category][id], k)
			end
		end
		if #inventory.Categories[itemTable.Category][id] == 0 then
			inventory.Categories[itemTable.Category][id] = nil
		end
	else
		local newAmount = inventory.Categories[itemTable.Category][id] - amount
		if newAmount <= 0 then
			inventory.Categories[itemTable.Category][id] = nil
		else
			inventory.Categories[itemTable.Category][id] = newAmount
		end
	end
	inventory.Info.Weight = math.max(math.Round(inventory.Info.Weight - itemTable.Weight * (istable(amount) and 1 or amount), 2), 0)
	if isPlayerBox then 
		self:SetBetterNWTable("InventoryBox", inventory, true)
	else
		self:SetBetterNWTable("Inventory", inventory, true)
		hook.Run("Inventory:PostPlayerRemoveItem", self, id, amount)
	end
	self:SaveInventory()
end

function pMeta:RemoveItemFromSlot(slot)
	local inventory = self:GetBetterNWTable("Inventory")
	inventory.CustomSlots[slot] = false
	self:SetBetterNWTable("Inventory", inventory, true)
	self:SaveInventory()
end

function pMeta:RemoveItemFromQuickSlot(slot, amount)
	local inventory = self:GetBetterNWTable("Inventory")
	if amount then
		local newAmount = inventory.CustomSlots.QuickSlots[slot].Amount - amount
		if newAmount > 0 then
			inventory.CustomSlots.QuickSlots[slot].Amount = newAmount
		else
			inventory.CustomSlots.QuickSlots[slot] = false
		end
	else
		inventory.CustomSlots.QuickSlots[slot] = false
	end
	self:SetBetterNWTable("Inventory", inventory, true)
	self:SaveInventory()
end

function pMeta:RemoveItemFromArtSlot(slot)
	local inventory = self:GetBetterNWTable("Inventory")
	inventory.CustomSlots.Artifacts[slot] = false
	self:SetBetterNWTable("Inventory", inventory, true)
	self:SaveInventory()
end

function Inventory:RemoveItem(ent, id, amount, data)
	if ent:IsPlayer() then return ent:RemoveItem(id, data or amount) end
	amount = amount or 1
	if hook.Run("Inventory:PreInventoryRemoveItem", ent, id, amount, data) then return end
	local itemTable = Inventory:GetItemByID(id)
	local inventory = ent:GetBetterNWTable("Inventory")
	if istable(amount) then
		for k, v in ipairs(inventory.Categories[itemTable.Category][id]) do
			if v.Guid == amount.Guid then
				table.remove(inventory.Categories[itemTable.Category][id], k)
			end
		end
		if #inventory.Categories[itemTable.Category][id] == 0 then
			inventory.Categories[itemTable.Category][id] = nil
		end
	else
		local newAmount = inventory.Categories[itemTable.Category][id] - amount
		if newAmount <= 0 then
			inventory.Categories[itemTable.Category][id] = nil
		else
			inventory.Categories[itemTable.Category][id] = newAmount
		end
	end
	inventory.Info.Weight = math.max(math.Round(inventory.Info.Weight - itemTable.Weight * (istable(amount) and 1 or amount), 2), 0)
	ent:SetBetterNWTable("Inventory", inventory)
	hook.Run("Inventory:PostInventoryRemoveItem", ent, id, amount, data)
end

function Inventory:AddItem(ent, id, amount, data, fromSlot)
	if ent:IsPlayer() then return ent:GiveItem(id, amount, data, nil, fromSlot) end
	amount = amount or 1
	data = data or {}
	if hook.Run("Inventory:PreInventoryAddItem", ent, id, amount, data, fromSlot) then return end
	local itemTable = Inventory:GetItemByID(id)
	local inventory = ent:GetBetterNWTable("Inventory")
	if itemTable.CanStuck then
		inventory.Categories[itemTable.Category][id] = inventory.Categories[itemTable.Category][id] and inventory.Categories[itemTable.Category][id] + amount or amount
	else
		inventory.Categories[itemTable.Category][id] = inventory.Categories[itemTable.Category][id] or {}
		table.insert(inventory.Categories[itemTable.Category][id], data)
	end
	inventory.Info.Weight = math.Round(inventory.Info.Weight + itemTable.Weight * amount, 2)
	ent:SetBetterNWTable("Inventory", inventory)
	hook.Run("Inventory:PostInventoryAddItem", ent, id, amount, data, fromSlot)
end

function Inventory:GetItemDropPos(ply)
	local data = {}
		data.start = ply:GetShootPos()
		data.endpos = ply:GetShootPos() + ply:GetAimVector()*86
		data.filter = ply
	local trace = util.TraceLine(data)
		data.start = trace.HitPos
		data.endpos = data.start + trace.HitNormal*46
		data.filter = {}
	trace = util.TraceLine(data)

	return trace.HitPos
end

function Inventory:CreateItem(item, pos, amount, data)
	amount = amount or 1
	data = data or {}
	if (type(pos) == "Player") then
		pos = Inventory:GetItemDropPos(pos)
	end

	local entity = ents.Create("inventory_item")
		entity:Spawn()
		entity:SetPos(pos)
		entity:SetAngles(Angle(0, 0, 0))
		entity:SetItem(item)
		entity:SetAmount(amount)
		entity:SetData(data)

	return entity
end

netstream.Hook("Inventory:DropItemFromArtSlot", function(ply, slot)
	ply:DropItemFromArtSlot(slot)
end)

netstream.Hook("Inventory:DropItemFromQuickSlot", function(ply, slot)
	ply:DropItemFromQuickSlot(slot)
end)

netstream.Hook("Inventory:DropItemFromSlot", function(ply, slot)
	ply:DropItemFromSlot(slot)
end)

netstream.Hook("Inventory:DropItem", function(ply, id, amount)
	ply:DropItem(id, amount)
end)

netstream.Hook("Inventory:RemoveItem", function(ply, id, amount)
	ply:RemoveItem(id, amount)
end)

netstream.Hook("Inventory:CreateItemQMenu", function( ply, id )
	if ply:GetUserGroup() == 'founder' or serverguard.player:HasPermission(ply, "Spawn Inventory Items") then
		local itemTable = Inventory:GetItemByID(id)
		local data
		if !itemTable.CanStuck then
			data = {Guid = Inventory.Utils:GenerateGuid(10, 5)}
		end
		Inventory:CreateItem(id, ply, itemTable.DefaultAmount, data)
	end
end)