Inventory = Inventory or {}
Inventory.Traders = Inventory.Traders or {}

function Inventory:AddTrader(trader, name)
	Inventory.Traders[name] = trader
end

function Inventory:LoadTraders()
	for k, v in pairs(self.Traders) do
		if (file.Exists("ngnl/traders/"..v.TraderIdentifier..".json","DATA")) then
			local items = util.JSONToTable(file.Read("ngnl/traders/"..v.TraderIdentifier..".json","DATA"))
			v:SetBetterNWTable("TraderItems", items)
			self:ReGenerateTrader(v)
		end
	end
end

function Inventory:ReGenerateTrader(ent)
	ent:CreateInventory()
	local items = ent:GetBetterNWTable("TraderItems")
	for k, v in pairs(items) do
		if !(math.random(0, 100) <= v.chance) then continue end
		local itemTable = Inventory:GetItemByID(k)
		if itemTable.CanStuck then
			Inventory:AddItem(ent, k, math.random(v.min, v.max))
		else
			local amount = math.random(v.min, v.max)
			for i = 1, amount do
				Inventory:AddItem(ent, k, 1, {Guid = Inventory.Utils:GenerateGuid(10, 5)})
			end
		end
	end
end

function Inventory:TraderBuyItem(ply, ent, itemId, amount, data)
	local itemTable = Inventory:GetItemByID(itemId)
	local price = math.Round(itemTable.BasePrice * ent:GetNWFloat("VATCoef", 1) * amount)
	ply:AddRUB(-price)
	ply:GiveItem(itemId, amount, data)
	self:RemoveItem(ent, itemId, data or amount)
end

function Inventory:TraderSellItem(ply, ent, itemId, amount, data)
	local itemTable = Inventory:GetItemByID(itemId)
	local price = math.Round((itemTable.BasePrice / ent:GetNWFloat("VATCoef", 1)) * amount)
	ply:AddRUB(price)
	ply:RemoveItem(itemId, data or amount)
	self:AddItem(ent, itemId, amount, data)
end  

netstream.Hook("Inventory:UpdateTraderItems", function(ply, ent, items)
	if !ply:GetUserGroup() == 'founder' and !serverguard.player:HasPermission(ply, "Manage Traders") then return end
	ent:SetBetterNWTable("TraderItems", items)
	file.Write("ngnl/traders/"..ent.TraderIdentifier..".json", util.TableToJSON(items, true))
end)

netstream.Hook("Inventory:ReGenerateTrader", function(ply, ent)
	if !ply:GetUserGroup() == 'founder' and !serverguard.player:HasPermission(ply, "Manage Traders") then return end
	Inventory:ReGenerateTrader(ent)
end)

netstream.Hook("Inventory:TraderBuyItem", function(ply, ent, itemId, amount, data)
	local itemTable = Inventory:GetItemByID(itemId)
	if !ply:CanAfford(math.Round(itemTable.BasePrice * ent:GetNWFloat("VATCoef", 1) * amount)) then return end
	Inventory:TraderBuyItem(ply, ent, itemId, amount, data)
end)

netstream.Hook("Inventory:TraderSellItem", function(ply, ent, itemId, amount, data)
	Inventory:TraderSellItem(ply, ent, itemId, amount, data)
end)