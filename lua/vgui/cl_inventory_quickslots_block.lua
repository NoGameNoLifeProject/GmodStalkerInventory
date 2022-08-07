local PANEL = {}

function PANEL:CreateItemPanel(parent, itemId, item)
	local itemTable = Inventory:GetItemByID(itemId)
	local InvObject = parent:Add("DImageButton")
	InvObject:SetSize(math.min(itemTable.SizeX * Inventory.cfg.vgui.gridCellSize * self.sizeCoefX + (itemTable.SizeX - 1) * 5 * self.sizeCoefX, parent:GetWide()) , 
		math.min(itemTable.SizeY * Inventory.cfg.vgui.gridCellSize * self.sizeCoefX + (itemTable.SizeY - 1) * 5 * self.sizeCoefX, parent:GetTall()))
	InvObject:SetPos(parent:GetWide()/2 - InvObject:GetWide()/2, parent:GetTall()/2 - InvObject:GetTall()/2)
	InvObject.Paint = function(pnl, w, h) end
	InvObject.Material = Material(itemTable.IconMat, 'noclamp')
	InvObject.PaintOver = function(pnl, w, h)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.SetMaterial( pnl.Material )
		surface.DrawTexturedRect( 0, 0, w, h)
		draw.ShadowSimpleText(item, Inventory.cfg.vgui.fonts.theme20, 5, 5, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		if pnl:IsHovered() and !pnl:IsDragging()  then
			draw.RectangleCorners(w, h, Inventory.cfg.vgui.colors.mainTextColor)
		end
	end
	InvObject.DoRightClick = function()
		local menu = DermaMenu(InventoryPanel)
		menu:SetSkin("serverguard")
		menu:AddOption("Выкинуть", function()
			netstream.Start("Inventory:DropItemFromQuickSlot", parent.Slot)
			InvObject:Remove()
		end):SetIcon("icon16/delete.png")
		menu:AddOption("Использовать", function()
			netstream.Start("Inventory:UseInventoryItem", itemId, 1, istable(item) and item or nil, parent.Slot)
			if item == 1  then
				InvObject:Remove()
			end
			item = item - 1
		end):SetIcon("icon16/accept.png")
		menu:Open()
	end
	InvObject.ItemId = itemId
	InvObject.Owner = self.Entity
	InvObject:Droppable("InvItem")
	InvObject.Amount = isnumber(item) and item or 1
	InvObject.Slot = parent.Slot or nil
	InvObject.Quick = true
	InvObject.TooltipTitle = itemTable.Name
	InvObject.TooltipDesc = itemTable.Desc
	InvObject.TooltipEffectsDesc = itemTable.EffectsDesc
	return InvObject
end

local function CanFit(itemId)
	local itemTable = Inventory:GetItemByID(itemId)
	return itemTable.CanStuck and itemTable.Usable
end

function PANEL:Build()
	self.TileLayout = vgui.Create("DTileLayout", self.Frame)
	self.TileLayout:SetSize(self.Frame:GetWide(), self.Frame:GetTall())
	self.TileLayout:SetSpaceY( 5 * self.sizeCoefX)
	self.TileLayout:SetSpaceX( 10 * self.sizeCoefY )
	self.TileLayout:SetBaseSize(140 * self.sizeCoefX)

	local inventory = self.Entity:GetBetterNWTable("Inventory")
	for i = 1, 4 do
		local quickSlot = self.TileLayout:Add("DPanel")
		quickSlot:SetSize(140 * self.sizeCoefX, 105 * self.sizeCoefY)
		quickSlot:SetText("")
		quickSlot.Slot = i
		quickSlot.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
			if (pnl.HoveredItem) then
				draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.hoveredColor)
				pnl.HoveredItem = false
			end
		end
		quickSlot:Receiver("InvItem", function(pnl, items, dropped)
			local item = items[1]
			if self.Entity:IsQuickSlotEmpty(pnl.Slot) and CanFit(item.ItemId) and item:GetParent() != pnl then
				pnl.HoveredItem = true
				if (dropped) then
					if item.Quick then
						netstream.Start("Inventory:EquipQuickSlotFromQuickSlot", item.Slot, pnl.Slot)
					else
						netstream.Start("Inventory:EquipQuickSlot", item.ItemId, item.Amount, pnl.Slot, item.Owner, item.IsPlayerBox)
					end
					self:CreateItemPanel(pnl, item.ItemId, item.Amount)				
					item:Remove()
				end
			end
		end)
		if inventory.CustomSlots.QuickSlots[quickSlot.Slot] then
			self:CreateItemPanel(quickSlot, inventory.CustomSlots.QuickSlots[quickSlot.Slot].ID, inventory.CustomSlots.QuickSlots[quickSlot.Slot].Amount)
		end
	end
end

vgui.Register("InventoryQuickSlotsBlock", PANEL, "InventoryBasePanel")