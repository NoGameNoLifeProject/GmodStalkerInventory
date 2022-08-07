local PANEL = {}

function PANEL:CreateItemPanel(parent, itemId, item)
	local itemTable = Inventory:GetItemByID(itemId)
	local InvObject = parent:Add("DImageButton")
	if parent.Slot == "FirstWeapon" or parent.Slot == "SecondWeapon" then
		InvObject:SetSize(math.min(itemTable.SizeY * Inventory.cfg.vgui.gridCellSize * self.sizeCoefX + (itemTable.SizeY - 1) * 5 * self.sizeCoefX, parent:GetWide()) , 
			math.min(itemTable.SizeX * Inventory.cfg.vgui.gridCellSize * self.sizeCoefX + (itemTable.SizeX - 1) * 5 * self.sizeCoefX, parent:GetTall()))
	else
		InvObject:SetSize(math.min(itemTable.SizeX * Inventory.cfg.vgui.gridCellSize * self.sizeCoefX + (itemTable.SizeX - 1) * 5 * self.sizeCoefX, parent:GetWide()) , 
			math.min(itemTable.SizeY * Inventory.cfg.vgui.gridCellSize * self.sizeCoefX + (itemTable.SizeY - 1) * 5 * self.sizeCoefX, parent:GetTall()))
	end
	InvObject:SetPos(parent:GetWide()/2 - InvObject:GetWide()/2, parent:GetTall()/2 - InvObject:GetTall()/2)
	InvObject.Paint = function(pnl, w, h) end
	InvObject.Material = Material(itemTable.IconMat, 'noclamp')
	local rotate = (parent.Slot == "FirstWeapon" or parent.Slot == "SecondWeapon") and 90 or 0
	InvObject.PaintOver = function(pnl, w, h)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.SetMaterial( pnl.Material )
		surface.DrawTexturedRectRotated( w/2, h/2, h, w, rotate )
		if pnl:IsHovered() and !pnl:IsDragging() then
			draw.RectangleCorners(w, h, Inventory.cfg.vgui.colors.mainTextColor)
		end
	end
	InvObject.DoRightClick = function()
		local menu = DermaMenu(InventoryPanel)
		menu:SetSkin("serverguard")
		menu:AddOption("Выкинуть", function()
			netstream.Start("Inventory:DropItemFromSlot", parent.Slot)
			InvObject:Remove()
		end):SetIcon("icon16/delete.png")
		menu:Open()
	end
	InvObject.ItemId = itemId
	InvObject.Owner = self.Entity
	InvObject:Droppable("InvItem")
	InvObject.Data = item
	InvObject.Slot = parent.Slot or nil
	InvObject.Ammunation = true
	InvObject.TooltipTitle = itemTable.Name
	InvObject.TooltipDesc = itemTable.Desc
	InvObject.TooltipEffectsDesc = itemTable.EffectsDesc
	return InvObject
end

function PANEL:CanFit(slot, itemId)
	local itemTable = Inventory:GetItemByID(itemId)
	if slot == "FirstWeapon" and itemTable.IsWeapon then
		return true
	elseif slot == "SecondWeapon" and itemTable.IsWeapon then
		return true
	elseif slot == "Helmet" and itemTable.IsHelmet then
		local inventory = self.Entity:GetBetterNWTable("Inventory")
		if inventory.CustomSlots.Armor then
			local armorTable = Inventory:GetItemByID(inventory.CustomSlots.Armor.ID)
			if armorTable and armorTable.ArmorTable and !armorTable.ArmorTable.Helmet then
				return false
			end
		end 
		return true
	elseif slot == "Armor" and itemTable.IsArmor then
		local inventory = self.Entity:GetBetterNWTable("Inventory")
		if inventory.CustomSlots.Helmet then
			local armorTable = Inventory:GetItemByID(itemId)
			if armorTable and armorTable.ArmorTable and !armorTable.ArmorTable.Helmet then
				//return false
			end
		end 
		return true
	elseif slot == "Device" and itemTable.IsDevice then
		return true
	end
	return false
end

function PANEL:ProcessEquipArmor(item)
	local itemTable = Inventory:GetItemByID(item.ItemId)
	if itemTable.ArmorTable and !itemTable.ArmorTable.Helmet then
		local helmet = self.Helmet:GetChild(0)
		if helmet then
			for _, blockFrame in pairs(item:GetParent():GetParent():GetParent():GetParent():GetParent():GetChildren()) do
				if blockFrame:GetName() == "InventoryInventoryBlock" then
					netstream.Start("Inventory:UnEquipAmmunation", helmet.Slot, self.Entity, false)
					blockFrame:CreateItemPanel(blockFrame.InvGrid, helmet.ItemId, helmet.Data or helmet.Amount):SetZPos(0)
					helmet:Remove()
				end
			end
		end
	end
end


function PANEL:Build()
	local inventory = self.Entity:GetBetterNWTable("Inventory")
	self.Weapon1 = vgui.Create("DPanel", self.Frame)
	self.Weapon1:SetText("")
	self.Weapon1:SetPos(0, 0)
	self.Weapon1:SetSize(180 * self.sizeCoefX, 480 * self.sizeCoefY)
	self.Weapon1.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
		if (pnl.HoveredItem) then
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.hoveredColor)
			pnl.HoveredItem = false
		end
	end
	self.Weapon1:Receiver("InvItem", function(pnl, items, dropped)
		local item = items[1]
		if self.Entity:IsSlotEmpty(pnl.Slot) and self:CanFit(pnl.Slot, item.ItemId) then
			pnl.HoveredItem = true
			if (dropped) then
				if item.Ammunation and item:GetParent() != pnl then
					netstream.Start("Inventory:EquipAmmunationFromAmmunation", item.Slot, pnl.Slot)
				else
					netstream.Start("Inventory:EquipAmmunation", item.ItemId, item.Data, pnl.Slot, item.Owner, item.IsPlayerBox)
				end
				self:CreateItemPanel(pnl, item.ItemId, item.Data)				
				item:Remove()
			end
		end
	end)
	self.Weapon1.Slot = "FirstWeapon"
	if inventory.CustomSlots.FirstWeapon then
		self:CreateItemPanel(self.Weapon1, inventory.CustomSlots.FirstWeapon.ID, inventory.CustomSlots.FirstWeapon.Data)
	end

	local wep1Wide = self.Weapon1:GetWide()
	self.Weapon2 = vgui.Create("DPanel", self.Frame)
	self.Weapon2:SetText("")
	self.Weapon2:SetPos(wep1Wide + 10, 0)
	self.Weapon2:SetSize(180 * self.sizeCoefX, 480 * self.sizeCoefY)
	self.Weapon2.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
		if (pnl.HoveredItem) then
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.hoveredColor)
			pnl.HoveredItem = false
		end
	end
	self.Weapon2:Receiver("InvItem", function(pnl, items, dropped)
		local item = items[1]
		if self.Entity:IsSlotEmpty(pnl.Slot) and self:CanFit(pnl.Slot, item.ItemId) then
			pnl.HoveredItem = true
			if (dropped) then
				if item.Ammunation and item:GetParent() != pnl then
					netstream.Start("Inventory:EquipAmmunationFromAmmunation", item.Slot, pnl.Slot)
				else
					netstream.Start("Inventory:EquipAmmunation", item.ItemId, item.Data, pnl.Slot, item.Owner)
				end
				self:CreateItemPanel(pnl, item.ItemId, item.Data)				
				item:Remove()
			end
		end
	end)
	self.Weapon2.Slot = "SecondWeapon"
	if inventory.CustomSlots.SecondWeapon then
		self:CreateItemPanel(self.Weapon2, inventory.CustomSlots.SecondWeapon.ID, inventory.CustomSlots.SecondWeapon.Data)
	end

	local wep2Wide = self.Weapon2:GetWide()
	self.Helmet = vgui.Create("DPanel", self.Frame)
	self.Helmet:SetText("")
	self.Helmet:SetPos(wep1Wide + 10 + wep2Wide + 10, 0)
	self.Helmet:SetSize(220 * self.sizeCoefX, 140 * self.sizeCoefY)
	self.Helmet.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
		if (pnl.HoveredItem) then
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.hoveredColor)
			pnl.HoveredItem = false
		end
	end
	self.Helmet:Receiver("InvItem", function(pnl, items, dropped)
		local item = items[1]
		if self.Entity:IsSlotEmpty(pnl.Slot) and self:CanFit(pnl.Slot, item.ItemId) then
			pnl.HoveredItem = true
			if (dropped) then
				netstream.Start("Inventory:EquipAmmunation", item.ItemId, item.Data, pnl.Slot, item.Owner, item.IsPlayerBox)
				self:CreateItemPanel(pnl, item.ItemId, item.Data)				
				item:Remove()
			end
		end
	end)
	self.Helmet.Slot = "Helmet"
	if inventory.CustomSlots.Helmet then
		self:CreateItemPanel(self.Helmet, inventory.CustomSlots.Helmet.ID, inventory.CustomSlots.Helmet.Data)
	end

	local helmetTall = self.Helmet:GetTall()
	self.Armor = vgui.Create("DPanel", self.Frame)
	self.Armor:SetText("")
	self.Armor:SetPos(wep1Wide + 10 + wep2Wide + 10, 5 + helmetTall)
	self.Armor:SetSize(220 * self.sizeCoefX, 250 * self.sizeCoefY)
	self.Armor.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
		if (pnl.HoveredItem) then
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.hoveredColor)
			pnl.HoveredItem = false
		end
	end
	self.Armor:Receiver("InvItem", function(pnl, items, dropped)
		local item = items[1]
		if self.Entity:IsSlotEmpty(pnl.Slot) and self:CanFit(pnl.Slot, item.ItemId) then
			pnl.HoveredItem = true
			if (dropped) then
				netstream.Start("Inventory:EquipAmmunation", item.ItemId, item.Data, pnl.Slot, item.Owner, item.IsPlayerBox)
				self:CreateItemPanel(pnl, item.ItemId, item.Data)
				self:ProcessEquipArmor(item)	
				item:Remove()
			end
		end
	end)
	self.Armor.Slot = "Armor"
	if inventory.CustomSlots.Armor then
		self:CreateItemPanel(self.Armor, inventory.CustomSlots.Armor.ID, inventory.CustomSlots.Armor.Data)
	end


	local armorTall = self.Armor:GetTall()
	self.Device = vgui.Create("DPanel", self.Frame)
	self.Device:SetText("")
	self.Device:SetPos(wep1Wide + 10 + wep2Wide + 10, 5 + helmetTall + 5 + armorTall)
	self.Device:SetSize(220 * self.sizeCoefX, 80 * self.sizeCoefY)
	self.Device.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
		if (pnl.HoveredItem) then
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.hoveredColor)
			pnl.HoveredItem = false
		end
	end
	self.Device:Receiver("InvItem", function(pnl, items, dropped)
		local item = items[1]
		if self.Entity:IsSlotEmpty(pnl.Slot) and self:CanFit(pnl.Slot, item.ItemId) then
			pnl.HoveredItem = true
			if (dropped) then
				netstream.Start("Inventory:EquipAmmunation", item.ItemId, item.Data, pnl.Slot, item.Owner, item.IsPlayerBox)
				self:CreateItemPanel(pnl, item.ItemId, item.Data)				
				item:Remove()
			end
		end
	end)
	self.Device.Slot = "Device"
	if inventory.CustomSlots.Device then
		self:CreateItemPanel(self.Device, inventory.CustomSlots.Device.ID, inventory.CustomSlots.Device.Data)
	end

end

vgui.Register("InventoryAmmunationBlock", PANEL, "InventoryBasePanel")