Inventory = Inventory or {}
Inventory.Queue = Inventory.Queue or {}

hook.Add("OnItemRemoved", "Inventory:OnItemRemoved", function(item)
	table.RemoveByValue(Inventory.Queue, item)
end)

hook.Add("OnItemSpawned", "Inventory:OnItemSpawned", function(newItem)
	if #Inventory.Queue >= Inventory.cfg.limitEntities then
		local item = Inventory.Queue[1]
		table.remove(Inventory.Queue, 1)
		item.RemovedByLimit = true
		item:Remove()
	end
	table.insert(Inventory.Queue, newItem)
end)