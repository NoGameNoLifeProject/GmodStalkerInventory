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
		if pnl:IsHovered() and !pnl:IsDragging() then
			draw.RectangleCorners(w, h, Inventory.cfg.vgui.colors.mainTextColor)
		end
	end
	InvObject.DoRightClick = function()
		local menu = DermaMenu(InventoryPanel)
		menu:SetSkin("serverguard")
		menu:AddOption("Выкинуть", function()
			netstream.Start("Inventory:DropItemFromArtSlot", parent.Slot)
			InvObject:Remove()
		end):SetIcon("icon16/delete.png")
		menu:Open()
	end
	InvObject.ItemId = itemId
	InvObject.Owner = self.Entity
	InvObject:Droppable("InvItem")
	InvObject.Data = item
	InvObject.Slot = parent.Slot or nil
	InvObject.Art = true
	InvObject.TooltipTitle = itemTable.Name
	InvObject.TooltipDesc = itemTable.Desc
	InvObject.TooltipEffectsDesc = itemTable.EffectsDesc
	return InvObject
end

local function CanFit(itemId)
	local itemTable = Inventory:GetItemByID(itemId)
	return itemTable.IsArtifact
end

function PANEL:Build()
	self.TileLayout = vgui.Create("DTileLayout", self.Frame)
	self.TileLayout:SetSize(self.Frame:GetWide(), self.Frame:GetTall())
	self.TileLayout:SetSpaceY( 5 * self.sizeCoefX )
	self.TileLayout:SetSpaceX( 5 * self.sizeCoefY )
	self.TileLayout:SetBaseSize(115 * self.sizeCoefX)

	local inventory = self.Entity:GetBetterNWTable("Inventory")
	for i = 1, 5 do
		local artSlot = self.TileLayout:Add("DPanel")
		artSlot:SetSize(115 * self.sizeCoefX, 105 * self.sizeCoefY)
		artSlot:SetText("")
		artSlot.Slot = i
		artSlot.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
			if self.Entity:GetNWInt("Inventory:Containters", 0 ) < pnl.Slot then
				draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.disabledColor)
				return
			end 
			if (pnl.HoveredItem) then
				draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.hoveredColor)
				pnl.HoveredItem = false
			end
		end
		artSlot:Receiver("InvItem", function(pnl, items, dropped)
			local item = items[1]
			if self.Entity:IsQuickSlotEmpty(pnl.Slot) and CanFit(item.ItemId) and item:GetParent() != pnl and self.Entity:GetNWInt("Inventory:Containters", 0 ) >= pnl.Slot then
				pnl.HoveredItem = true
				if (dropped) then
					if item.Art then
						netstream.Start("Inventory:EquipArtSlotFromArtSlot", item.Slot, pnl.Slot)
					else
						netstream.Start("Inventory:EquipArtSlot", item.ItemId, item.Data, pnl.Slot, item.Owner, item.IsPlayerBox)
					end
					self:CreateItemPanel(pnl, item.ItemId, item.Data)				
					item:Remove()
				end
			end
		end)
		if inventory.CustomSlots.Artifacts[artSlot.Slot] then
			self:CreateItemPanel(artSlot, inventory.CustomSlots.Artifacts[artSlot.Slot].ID, inventory.CustomSlots.Artifacts[artSlot.Slot].Data)
		end
	end
end

vgui.Register("InventoryArtSlotsBlock", PANEL, "InventoryBasePanel")