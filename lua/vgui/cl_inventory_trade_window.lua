local PANEL = {}

function PANEL:Amount(cur, max)
	self.MaxAmount = max
	self.Amount = cur
end

function PANEL:SetItem(itemId, data)
	self.ItemId = itemId
	self.ItemData = data
end

function PANEL:SetEntity(ent)
	self.Entity = ent
end

function PANEL:SetSell(selling)
	self.IsSelling = selling
end

function PANEL:OnTradeSuccess()
end

function PANEL:ClaclPrice()
	local itemTable = Inventory:GetItemByID(self.ItemId)
	return math.Round((self.IsSelling and (itemTable.BasePrice / self.Entity:GetNWFloat("VATCoef", 1)) or (itemTable.BasePrice * self.Entity:GetNWFloat("VATCoef", 1))) * self.Amount)
end

function PANEL:GetPriceString()
	local itemTable = Inventory:GetItemByID(self.ItemId)
	local str = tostring(math.Round(self.IsSelling and itemTable.BasePrice / self.Entity:GetNWFloat("VATCoef", 1) or itemTable.BasePrice * self.Entity:GetNWFloat("VATCoef", 1)))
	return str.." * "..self.Amount.." = "..self:ClaclPrice()
end

PANEL.Paint = function(pnl, w, h)
	draw.RoundedBox(10, 0, 0, w, h, Inventory.cfg.vgui.colors.backgrundColor)
	draw.StencilBlur(pnl, w, h)
	draw.SimpleText("Подтверждение "..(pnl.IsSelling and "продажи" or "покупки"), Inventory.cfg.vgui.fonts.theme30, 5, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_TOP )
	draw.SimpleText("Цена: "..pnl:GetPriceString(), Inventory.cfg.vgui.fonts.theme20, 10, 75, Color( 255, 255, 255, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_TOP )
end

function PANEL:Build()

	self.AmountNumSlider = vgui.Create( "DNumSlider", self )
	self.AmountNumSlider:SetSize(self:GetWide() - 20, 40)
	self.AmountNumSlider:SetPos(10, 40)
	self.AmountNumSlider:SetTall(30)
	self.AmountNumSlider:SetText( "Кол-во" )		
	self.AmountNumSlider:SetMin( 1 )			
	self.AmountNumSlider:SetMax( self.MaxAmount )		
	self.AmountNumSlider:SetDecimals( 0 )
	self.AmountNumSlider:SetDefaultValue(self.Amount)
	self.AmountNumSlider.Label:SetTextColor(Color(240,240,240,240))
	self.AmountNumSlider.Label:SetFont(Inventory.cfg.vgui.fonts.theme20)
	self.AmountNumSlider:SetValue(self.Amount)
	self.AmountNumSlider.Paint = function() end
	self.AmountNumSlider:GetChild(1).Paint = function(s, w, h)
		draw.RoundedBox(0, 0, (h/2)-2, w, 2, Color(240,240,240,240))
	end
	self.AmountNumSlider:GetChild(1):GetChild(0).Paint = function(s, w, h)
		draw.NoTexture()
		surface.SetDrawColor(240,240,240,240)
		draw.Circle(w/2, h/2, 5, 15)
	end
	self.AmountNumSlider.OnValueChanged = function(pnl, value)
		self.Amount = math.Round(value)
	end

	self.CancelButton = vgui.Create("DButton", self)
	self.CancelButton:SetSize(150, 25)
	self.CancelButton:SetPos(self:GetWide()-340, self:GetTall()-40)
	self.CancelButton:SetText("")
	self.CancelButton.Paint = function(PANEL,w,h)
		if PANEL:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, 1, Color(240,240,240,170) )
			draw.RoundedBox(0, 0, h-1, w, 1, Color(240,240,240,170) )
			draw.RoundedBox(0, 0, 0, 1, h, Color(240,240,240,170) )
			draw.RoundedBox(0, w-1, 0, 1, h, Color(240,240,240,170) )
			draw.SimpleText( "Отмена", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "Отмена", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	self.CancelButton.DoClick = function()
		self:Remove()
	end

	self.TradeButton = vgui.Create("DButton", self)
	self.TradeButton:SetSize(150, 25)
	self.TradeButton:SetPos(self:GetWide()-180, self:GetTall()-40)
	self.TradeButton:SetText("")
	self.TradeButton.Paint = function(PANEL,w,h)
		if PANEL:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, 1, Color(240,240,240,170) )
			draw.RoundedBox(0, 0, h-1, w, 1, Color(240,240,240,170) )
			draw.RoundedBox(0, 0, 0, 1, h, Color(240,240,240,170) )
			draw.RoundedBox(0, w-1, 0, 1, h, Color(240,240,240,170) )
			draw.SimpleText( self.IsSelling and "Продать" or "Купить", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( self.IsSelling and "Продать" or "Купить", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	self.TradeButton.DoClick = function()
		local itemTable = Inventory:GetItemByID(self.ItemId)
		if self.IsSelling then
			self:OnTradeSuccess(self.Amount, self.ItemData)
			netstream.Start("Inventory:TraderSellItem", self.Entity, self.ItemId, self.Amount, self.ItemData)
			notification.AddLegacy( "Вы продали "..self.Amount.." "..itemTable.Name, NOTIFY_GENERIC, 3 )
		else
			if !LocalPlayer():CanAfford(math.Round(itemTable.BasePrice * self.Entity:GetNWFloat("VATCoef", 1) * self.Amount)) then
				notification.AddLegacy( "Недостаточно средств для покупки", NOTIFY_ERROR, 3 )
				return 
			end
			self:OnTradeSuccess(self.Amount, self.ItemData)
			netstream.Start("Inventory:TraderBuyItem", self.Entity, self.ItemId, self.Amount, self.ItemData)
			notification.AddLegacy( "Вы купили "..self.Amount.." "..itemTable.Name, NOTIFY_GENERIC, 3 )
		end
		self:Remove()
	end
end

vgui.Register("InventoryTradeWindow",PANEL,"EditablePanel")