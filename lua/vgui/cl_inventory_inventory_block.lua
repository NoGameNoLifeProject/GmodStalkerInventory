local PANEL = {}

function PANEL:SetInTrade(state)
	self.IsInTrade = state
end

function PANEL:CreateItemPanel(parent, itemId, item)
	local itemTable = Inventory:GetItemByID(itemId)
	if itemTable.CanStuck then
		for _, v in pairs(parent:GetChildren()) do
			if v.ItemId and v.ItemId == itemId then 
				return false 
			end
		end
	end
	local InvObject = parent:Add("DImageButton")
	InvObject:SetSize(itemTable.SizeX * Inventory.cfg.vgui.gridCellSize * self.sizeCoefX + (itemTable.SizeX - 1) * 5 * self.sizeCoefX , itemTable.SizeY * Inventory.cfg.vgui.gridCellSize * self.sizeCoefX + (itemTable.SizeY - 1) * 5 * self.sizeCoefX)
	InvObject.Material = Material(itemTable.IconMat)
	InvObject.Paint = function(pnl, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
	end
	InvObject.Paint = function(pnl, w, h)
		surface.SetDrawColor(Color(255,255,255,255))
		surface.SetMaterial( pnl.Material )
		surface.DrawTexturedRect( 0, 0, w, h)
		if itemTable.CanStuck then
			local inventory = self.Entity:GetBetterNWTable("Inventory")
			local curAmount = inventory.Categories[itemTable.Category][itemId]
			if curAmount and curAmount > 0 then
				pnl:SetDisabled(false)
				draw.ShadowSimpleText(curAmount, Inventory.cfg.vgui.fonts.theme20, 5, 5, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			else
				pnl:SetDisabled(true)
			end
		end
		if InvObject.IsNPC then
			draw.ShadowSimpleText(util.FormatMoney(math.Round(itemTable.BasePrice * self.Entity:GetNWFloat("VATCoef", 1))), Inventory.cfg.vgui.fonts.theme14, w-5, h-5, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		elseif self.IsInTrade then
			draw.ShadowSimpleText(util.FormatMoney(math.Round(itemTable.BasePrice / self.Entity:GetNWFloat("VATCoef", 1))), Inventory.cfg.vgui.fonts.theme14, w-5, h-5, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		end
		if pnl:IsHovered() and !pnl:IsDragging() then
			draw.RectangleCorners(w, h, Inventory.cfg.vgui.colors.mainTextColor)
		end
	end
	InvObject.DoRightClick = function()
		local menu = DermaMenu(InventoryPanel)
		menu:SetSkin("serverguard")
		if !InvObject.IsNPC then
			if itemTable.CanStuck then
				menu:AddOption("Выкинуть все", function()
					netstream.Start("Inventory:DropItem", itemId, item)
					InvObject:Remove()
				end):SetIcon("icon16/delete.png")
				menu:AddOption("Выкинуть часть", function() 
				Derma_StringRequest("Выкинуть предмет", "Укажите количество", "", function(text)
					local dropAmount = math.Clamp(tonumber(text), 0, item)
					netstream.Start("Inventory:DropItem", itemId, dropAmount)
					if dropAmount == item then
						InvObject:Remove()
					end
					item = item - dropAmount
				end, function(text) end, "Выкинуть", "Отмена") end):SetIcon("icon16/delete.png")
			else
				menu:AddOption("Выкинуть", function()
					netstream.Start("Inventory:DropItem", itemId, item)
					InvObject:Remove()
				end):SetIcon("icon16/delete.png")
			end
			if itemTable.Usable then
				menu:AddOption("Использовать", function()
					netstream.Start("Inventory:UseInventoryItem", itemId, 1, istable(item) and item or nil, nil, self.Entity, self.IsPlayerBox)
					if item == 1  then
						InvObject:Remove()
					end
					item = item - 1
				end):SetIcon("icon16/accept.png")
			end
		end
		menu:Open()
	end
	InvObject.ItemId = itemId
	InvObject.Owner = self.Entity
	InvObject:Droppable("InvItem")
	InvObject.Data = istable(item) and item or nil
	InvObject.Amount = isnumber(item) and item or 1
	InvObject.IsPlayerBox = self.IsPlayerBox
	InvObject.IsNPC = self.IsNPC
	InvObject.TooltipTitle = itemTable.Name
	InvObject.TooltipDesc = itemTable.Desc
	InvObject.TooltipEffectsDesc = itemTable.EffectsDesc
	return InvObject
end

function PANEL:ProcessUnEquipAmmunation(item)
	local itemTable = Inventory:GetItemByID(item.ItemId)
	if itemTable.IsArmor then
		for _, blockFrame in pairs(item:GetParent():GetParent():GetParent():GetChildren()) do
			if blockFrame:GetName() == "InventoryArtSlotsBlock" then
				for _, artPanel in pairs(blockFrame.TileLayout:GetChildren()) do
					local art = artPanel:GetChild(0)
					if art then
						netstream.Start("Inventory:UnEquipArtSlot", art.Slot, self.Entity, false)
						self:CreateItemPanel(self.InvGrid, art.ItemId, art.Data or art.Amount):SetZPos(0)
						art:Remove()
					end
				end
			end
		end
	end
end

function PANEL:Build()
	if !IsValid(self.Entity) then return end
	if self.Entity:IsPlayer() and !self.Entity:Alive() then return end

	self.ScrollPanel = self.Frame:Add("DScrollPanel")
	self.ScrollPanel:SetSize(self.Frame:GetWide(), self.Frame:GetTall())
	self.ScrollPanel.Paint = function(pnl, w, h) draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor) end
	self.ScrollPanel:Receiver("InvItem", function(pnl, items, dropped)
			local item = items[1]
			pnl.HoveredItem = true
			if (dropped) then
				if item.Owner == self.Entity then
					if item.IsNPC or self.IsNPC then return end
					if item.IsPlayerBox and self.IsPlayerBox then return end
					if !item.IsPlayerBox and !self.IsPlayerBox then
						if item.Ammunation then
							netstream.Start("Inventory:UnEquipAmmunation", item.Slot, false, false)
							self:ProcessUnEquipAmmunation(item)
						elseif item.Quick then
							netstream.Start("Inventory:UnEquipQuickSlot", item.Slot, false, false)
						elseif item.Art then
							netstream.Start("Inventory:UnEquipArtSlot", item.Slot, false, false)
						end
					elseif item.IsPlayerBox then
						netstream.Start("Inventory:TransferItemPlayerBox", "Player", item.ItemId, item.Amount, item.Data, true)
					else
						if item.Ammunation then
							netstream.Start("Inventory:UnEquipAmmunation", item.Slot, self.Entity, true)
							self:ProcessUnEquipAmmunation(item)
						elseif item.Quick then
							netstream.Start("Inventory:UnEquipQuickSlot", item.Slot, self.Entity, false)
						elseif item.Art then
							netstream.Start("Inventory:UnEquipArtSlot", item.Slot, self.Entity, false)
						else
							netstream.Start("Inventory:TransferItemPlayerBox", "PlayerBox", item.ItemId, item.Amount, item.Data, true)
						end
					end
				else
					if item.IsNPC and self.IsNPC then return end
					if item.IsNPC then
						local itemTable = Inventory:GetItemByID(item.ItemId)
						local inventory = item.Owner:GetBetterNWTable("Inventory")
						local curAmount = inventory.Categories[itemTable.Category][item.ItemId]
						local itemData = item.Data
						if itemTable.CanStuck then itemData = nil end
						if IsValid(Inventory.TradeConfirmWindow) then Inventory.TradeConfirmWindow:Remove() end
						Inventory.TradeConfirmWindow = vgui.Create("InventoryTradeWindow", Inventory.PlayerInventoryMenu)
						Inventory.TradeConfirmWindow:MakePopup()
						Inventory.TradeConfirmWindow:DoModal()
						Inventory.TradeConfirmWindow:SetSize(400, 160)
						Inventory.TradeConfirmWindow:SetPos(ScrW()/2 - Inventory.TradeConfirmWindow:GetWide()/2, ScrH()/2 - Inventory.TradeConfirmWindow:GetTall()/2 )
						Inventory.TradeConfirmWindow:SetEntity(item.Owner)
						Inventory.TradeConfirmWindow:SetSell(false)
						Inventory.TradeConfirmWindow:Amount(1, itemTable.CanStuck and curAmount or 1)
						Inventory.TradeConfirmWindow:SetItem(item.ItemId, itemData)
						Inventory.TradeConfirmWindow:Build()
						Inventory.TradeConfirmWindow.OnTradeSuccess = function(pnl, amount, data)
							local itemPanel = self:CreateItemPanel(self.InvGrid, item.ItemId, data or amount)
							if itemPanel then itemPanel:SetZPos(0) end
							if !itemTable.CanStuck then
								item:Remove()
							end
						end
						return
					elseif self.IsNPC then
						local itemTable = Inventory:GetItemByID(item.ItemId)
						local inventory = item.Owner:GetBetterNWTable("Inventory")
						local curAmount = inventory.Categories[itemTable.Category][item.ItemId]
						local itemData = item.Data
						if itemTable.CanStuck then itemData = nil end
						if IsValid(Inventory.TradeConfirmWindow) then Inventory.TradeConfirmWindow:Remove() end
						Inventory.TradeConfirmWindow = vgui.Create("InventoryTradeWindow", Inventory.PlayerInventoryMenu)
						Inventory.TradeConfirmWindow:MakePopup()
						Inventory.TradeConfirmWindow:DoModal()
						Inventory.TradeConfirmWindow:SetSize(400, 160)
						Inventory.TradeConfirmWindow:SetPos(ScrW()/2 - Inventory.TradeConfirmWindow:GetWide()/2, ScrH()/2 - Inventory.TradeConfirmWindow:GetTall()/2 )
						Inventory.TradeConfirmWindow:SetEntity(self.Entity)
						Inventory.TradeConfirmWindow:SetSell(true)
						Inventory.TradeConfirmWindow:Amount(1, itemTable.CanStuck and curAmount or 1)
						Inventory.TradeConfirmWindow:SetItem(item.ItemId, itemData)
						Inventory.TradeConfirmWindow:Build()
						Inventory.TradeConfirmWindow.OnTradeSuccess = function(pnl, amount, data)
							local itemPanel = self:CreateItemPanel(self.InvGrid, item.ItemId, data or amount)
							if itemPanel then itemPanel:SetZPos(0) end
							if !itemTable.CanStuck then
								item:Remove()
							end
						end
						return
					elseif item.Ammunation then
						netstream.Start("Inventory:UnEquipAmmunation", item.Slot, self.Entity, false)
					elseif item.Quick then
						netstream.Start("Inventory:UnEquipQuickSlot", item.Slot, self.Entity, false)
					elseif item.Art then
						netstream.Start("Inventory:UnEquipArtSlot", item.Slot, self.Entity, false)
					else
						netstream.Start("Inventory:TransferItem", item.Owner, self.Entity, item.ItemId, item.Amount, item.Data, true)
					end
				end
				if item:GetParent() == self.InvGrid then return end
				self:CreateItemPanel(self.InvGrid, item.ItemId, item.Data or item.Amount):SetZPos(0)
				item:Remove()
			end
		end)
	local sbar = self.ScrollPanel:GetVBar()
	sbar:SetWide(10 * self.sizeCoefX )
	sbar:SetHideButtons(true)
	function sbar:Paint(w, h)
		draw.RoundedBox(10, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
	end
	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(255, 255, 255, 150))
	end

	self.InvGrid = self.ScrollPanel:Add("DTileLayout")
	self.InvGrid:SetSize(self.Frame:GetWide(), self.Frame:GetTall())
	self.InvGrid:SetSpaceX( 5 * self.sizeCoefX )
	self.InvGrid:SetSpaceY( 5 * self.sizeCoefY )
	self.InvGrid:SetBaseSize(Inventory.cfg.vgui.gridCellSize * self.sizeCoefX / 2)

	local inventory = self.IsPlayerBox and self.Entity:GetBetterNWTable("InventoryBox") or self.Entity:GetBetterNWTable("Inventory")
	for _, cat in ipairs(Inventory.cfg.categories) do
		for itemId, item in pairs(inventory.Categories[cat]) do
			if istable(item) then
				for _, item in ipairs(item) do
					local itemTable = Inventory:GetItemByID(itemId)
					self:CreateItemPanel(self.InvGrid, itemId, item)
				end
			else
				local itemTable = Inventory:GetItemByID(itemId)
				self:CreateItemPanel(self.InvGrid, itemId, item)
			end
		end
	end
	//self:AddEmptyCellPanels(emptyCellsAmount)
end

vgui.Register("InventoryInventoryBlock", PANEL, "InventoryBasePanel")