Inventory = Inventory or {}

function pMeta:SaveInventory()
	local inventory = self:GetBetterNWTable("Inventory")
	local inventoryBox = self:GetBetterNWTable("InventoryBox")
	local str = string.lower(self:SteamID():gsub(":","_"))
	file.Write("ngnl/inventory/"..str..".json", util.TableToJSON(inventory, true))
	file.Write("ngnl/inventorybox/"..str..".json", util.TableToJSON(inventoryBox, true))
end

function pMeta:LoadCustomSlots()
	local inventory = self:GetBetterNWTable("Inventory")
	if inventory.CustomSlots.FirstWeapon then
		self:PlayerGiveWeapon(inventory.CustomSlots.FirstWeapon.ID, inventory.CustomSlots.FirstWeapon.Data, "FirstWeapon")
	end
	if inventory.CustomSlots.SecondWeapon then
		self:PlayerGiveWeapon(inventory.CustomSlots.SecondWeapon.ID, inventory.CustomSlots.SecondWeapon.Data, "SecondWeapon")
	end
	if inventory.CustomSlots.Helmet then
		self:PlayerEquipHelmet(inventory.CustomSlots.Helmet.ID, inventory.CustomSlots.Helmet.Data, "Helmet")
	end
	if inventory.CustomSlots.Armor then
		self:PlayerEquipArmor(inventory.CustomSlots.Armor.ID, inventory.CustomSlots.Armor.Data, "Armor")
	else
		self:SetModel(Inventory.cfg.defaultPlayerModel)
	end
	if inventory.CustomSlots.Device then
		self:PlayerGiveDevice(inventory.CustomSlots.Device.ID, inventory.CustomSlots.Device.Data, "Device")
	end
	if !self.InventoryInitialized then
		self.InventoryInitialized = true
		for k, v in pairs(inventory.CustomSlots.Artifacts) do
			if v then
				hook.Run("Inventory:PostPlayerEquipArtSlot", self, v.ID, v.Data, k)
			end
		end
	end
end

function Inventory:LoadPlayerInventory(ply)
	local str = string.lower(ply:SteamID():gsub(":","_"))
	local inventory = {}
	local inventoryBox = {}
	if (file.Exists("ngnl/inventory/"..str..".json","DATA")) then
		inventory = util.JSONToTable(file.Read("ngnl/inventory/"..str..".json","DATA"))
		for _, v in ipairs(Inventory.cfg.categories) do
			inventory.Categories[v] = inventory.Categories[v] or {}
		end
		ply:SetBetterNWTable("Inventory", inventory, true)
		
		inventoryBox = util.JSONToTable(file.Read("ngnl/inventorybox/"..str..".json","DATA"))
		for _, v in ipairs(Inventory.cfg.categories) do
			inventoryBox.Categories[v] = inventoryBox.Categories[v] or {}
		end
		ply:SetBetterNWTable("InventoryBox", inventoryBox, true)
	else
		inventory.Categories = {}
		for _, v in ipairs(Inventory.cfg.categories) do
			inventory.Categories[v] = {}
		end
		inventory.Info = {}
		inventory.Info.Weight = 0
		inventoryBox = table.Copy(inventory)

		inventory.CustomSlots = {}
		inventory.CustomSlots.FirstWeapon = false
		inventory.CustomSlots.SecondWeapon = false
		inventory.CustomSlots.Helmet = false
		inventory.CustomSlots.Armor = false
		inventory.CustomSlots.Device = false
		inventory.CustomSlots.QuickSlots = { [1] = false, [2] = false, [3] = false, [4] = false, [5] = false }
		inventory.CustomSlots.Artifacts = { [1] = false, [2] = false, [3] = false, [4] = false }

		ply:SetBetterNWTable("Inventory", inventory, true)
		ply:SetBetterNWTable("InventoryBox", inventoryBox, true)
		ply:SaveInventory()
	end
end

hook.Add("PlayerIsLoaded", "Inventory:PlayerIsLoaded", function(ply)
	Inventory:LoadPlayerInventory(ply)
	ply.Introduced = true
end)

hook.Add("PostPlayerSpawn", "Inventory:PostPlayerSpawn", function(ply)
	if ply.Introduced then
		AddLuaTask(ply:ClearPlayerInventoryEffects())
		AddLuaTask(ply:RemathInventoryWeight())
		AddLuaTask(ply:LoadCustomSlots())
	end
end)

netstream.Hook("PlayerIsLoaded", function(ply)
	hook.Run("PlayerIsLoaded", ply)
end)