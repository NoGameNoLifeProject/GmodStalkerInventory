local PANEL = {}

local function CreateItemPanel(PANEL, listPanel, itemTable, chance, min, max)
	local itemPanel = listPanel:Add("DPanel")
	itemPanel:Dock(TOP)
	itemPanel:SetTall(40)
	itemPanel:DockMargin( 0, 0, 0, 5 )
	itemPanel:Droppable( "ItemsReceiver" )
	itemPanel.ItemTable = itemTable
	itemPanel.Material = Material(itemTable.IconMat)
	itemPanel.Paint = function(pnl, w, h)
		draw.RoundedBox(5, 0, 0, w, h, Color(0, 0, 0, 200 ) )
		surface.SetDrawColor(Color(255,255,255,255))
		surface.SetMaterial( pnl.Material )
		surface.DrawTexturedRect( 0, 0, h, h)
		draw.ShadowSimpleText(itemTable.Name, Inventory.cfg.vgui.fonts.theme20, h + 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
	if listPanel == PANEL.ActiveItems then
		PANEL.ActiveItemsList[itemTable.Id] = {chance = (chance and chance or 10), min=(min and min or 1), max=(max and max or 1)}
		itemPanel:SetTall(80)
		
		itemPanel.AmountPanel = vgui.Create( "DPanel", itemPanel )
		itemPanel.AmountPanel:Dock(BOTTOM)
		itemPanel.AmountPanel:DockMargin( 100, 2, 0, 2 )
		itemPanel.AmountPanel:SetTall(20)
		itemPanel.AmountPanel.Paint = function(pnl, w, h)
			//draw.ShadowSimpleText("Мин. Кол-во", Inventory.cfg.vgui.fonts.theme20, 0, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			//draw.ShadowSimpleText("Макс. Кол-во", Inventory.cfg.vgui.fonts.theme20, w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		itemPanel.AmountPanel.MinText = vgui.Create( "DLabel", itemPanel.AmountPanel)
		itemPanel.AmountPanel.MinText:Dock(LEFT)
		itemPanel.AmountPanel.MinText:DockMargin( 0, 0, 5, 0 )
		itemPanel.AmountPanel.MinText:SetFont(Inventory.cfg.vgui.fonts.theme20)
		itemPanel.AmountPanel.MinText:SetText("Мин. Кол-во")
		itemPanel.AmountPanel.MinText:SizeToContentsX()

		itemPanel.AmountPanel.MinNumber = vgui.Create("DNumberWang", itemPanel.AmountPanel)
		itemPanel.AmountPanel.MinNumber:Dock(LEFT)
		itemPanel.AmountPanel.MinNumber:DockMargin( 0, 0, 5, 0 )
		itemPanel.AmountPanel.MinNumber:SetSize(45, 18)
		itemPanel.AmountPanel.MinNumber:SetMin(1)
		itemPanel.AmountPanel.MinNumber:SetMax(1500)
		itemPanel.AmountPanel.MinNumber:SetValue(PANEL.ActiveItemsList[itemTable.Id].min)
		itemPanel.AmountPanel.MinNumber.OnValueChanged = function(pnl)
			if (itemPanel.AmountPanel.MaxNumber:GetValue() < pnl:GetValue()) then
				itemPanel.AmountPanel.MaxNumber:SetValue(pnl:GetValue())
			end
			PANEL.ActiveItemsList[itemTable.Id].min = pnl:GetValue() 
		end

		itemPanel.AmountPanel.MaxText = vgui.Create( "DLabel", itemPanel.AmountPanel)
		itemPanel.AmountPanel.MaxText:Dock(LEFT)
		itemPanel.AmountPanel.MaxText:DockMargin( 0, 0, 5, 0 )
		itemPanel.AmountPanel.MaxText:SetFont(Inventory.cfg.vgui.fonts.theme20)
		itemPanel.AmountPanel.MaxText:SetText("Макс. Кол-во")
		itemPanel.AmountPanel.MaxText:SizeToContentsX()

		itemPanel.AmountPanel.MaxNumber = vgui.Create("DNumberWang", itemPanel.AmountPanel)
		itemPanel.AmountPanel.MaxNumber:Dock(LEFT)
		itemPanel.AmountPanel.MaxNumber:DockMargin( 0, 0, 5, 0 )
		itemPanel.AmountPanel.MaxNumber:SetSize(45, 18)
		itemPanel.AmountPanel.MaxNumber:SetMin(1)
		itemPanel.AmountPanel.MaxNumber:SetMax(1500)
		itemPanel.AmountPanel.MaxNumber:SetValue(PANEL.ActiveItemsList[itemTable.Id].max)
		itemPanel.AmountPanel.MaxNumber.OnValueChanged = function(pnl)
			if (pnl:GetValue() < itemPanel.AmountPanel.MinNumber:GetValue()) then
				itemPanel.AmountPanel.MinNumber:SetValue(pnl:GetValue())
			end
			PANEL.ActiveItemsList[itemTable.Id].max = pnl:GetValue() 
		end

		itemPanel.SpawnChanceNumSlider = vgui.Create( "DNumSlider", itemPanel )
		itemPanel.SpawnChanceNumSlider:Dock(BOTTOM)
		itemPanel.SpawnChanceNumSlider:DockMargin( 100, 2, 0, 2 )
		itemPanel.SpawnChanceNumSlider:SetTall(30)
		itemPanel.SpawnChanceNumSlider:SetText( "Шанс появления" )		
		itemPanel.SpawnChanceNumSlider:SetMin( 0.01 )			
		itemPanel.SpawnChanceNumSlider:SetMax( 100 )		
		itemPanel.SpawnChanceNumSlider:SetDecimals( 2 )
		itemPanel.SpawnChanceNumSlider:SetDefaultValue(PANEL.ActiveItemsList[itemTable.Id].chance)
		itemPanel.SpawnChanceNumSlider.Label:SetTextColor(Color(240,240,240,240))
		itemPanel.SpawnChanceNumSlider.Label:SetFont(Inventory.cfg.vgui.fonts.theme20)
		itemPanel.SpawnChanceNumSlider:SetValue(PANEL.ActiveItemsList[itemTable.Id].chance)
		itemPanel.SpawnChanceNumSlider.Paint = function() end
		itemPanel.SpawnChanceNumSlider:GetChild(1).Paint = function(s, w, h)
			draw.RoundedBox(0, 0, (h/2)-2, w, 2, Color(240,240,240,240))
		end
		itemPanel.SpawnChanceNumSlider:GetChild(1):GetChild(0).Paint = function(s, w, h)
			draw.NoTexture()
			surface.SetDrawColor(240,240,240,240)
			draw.Circle(w/2, h/2, 5, 15)
		end
		itemPanel.SpawnChanceNumSlider.OnValueChanged = function(pnl, value)
			PANEL.ActiveItemsList[itemTable.Id].chance = math.Round(value, 2)
		end
	end
end

function PANEL:ReBuild()
	self.ActiveItems:Clear()
	self.DeActiveItems:Clear()

	self.ActiveItemsList = self.Entity:GetBetterNWTable("TraderItems", {})

	if self.ActiveItemsList then
		for k, v in pairs(Inventory.Items) do
			if self.ActiveItemsList[k] then
				CreateItemPanel(self, self.ActiveItems, v, self.ActiveItemsList[k].chance, self.ActiveItemsList[k].min, self.ActiveItemsList[k].max)
			end
		end
	end

	for k, v in pairs(Inventory.Items) do
		if Inventory.cfg.categories[1] == v.Category then
			if self.ActiveItemsList[k] then continue end 
			CreateItemPanel(self, self.DeActiveItems, v)
		end
	end
end

function PANEL:Build()
	local function DoDrop( PANEL, panels, bDoDrop, Command, x, y )
		if ( bDoDrop ) then
			for k, v in pairs( panels ) do
				if PANEL == v:GetParent():GetParent() then continue end
				CreateItemPanel(self, PANEL, v.ItemTable)
				if PANEL == self.DeActiveItems then
					self.ActiveItemsList[v.ItemTable.Id] = nil
				end
				v:Remove()
			end
		end
	end

	self.ActiveItems = vgui.Create( "DScrollPanel", self.Frame)
	self.ActiveItems:SetPos( 5, 5 )
	self.ActiveItems:SetSize( self.Frame:GetWide()/2.4, self.Frame:GetTall()/1.05)
	self.ActiveItems:Receiver( "ItemsReceiver", DoDrop )
	self.ActiveItems.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 200 ) )
	end

	self.DeActiveItems = vgui.Create( "DScrollPanel", self.Frame)
	self.DeActiveItems:SetPos( self.Frame:GetWide()/2.4 + 40, 5 )
	self.DeActiveItems:SetSize( self.Frame:GetWide()/3.5, self.Frame:GetTall()/1.05  )
	self.DeActiveItems:Receiver( "ItemsReceiver", DoDrop )
	self.DeActiveItems.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 200 ) )
	end

	for k, v in pairs(Inventory.cfg.categories) do
		local button = vgui.Create("DButton", self.Frame)
		button:SetSize(self.Frame:GetWide()/5, 40)
		button:SetPos(self.Frame:GetWide()/2.4 + self.Frame:GetWide()/3.5 + 80, 40 + 50*(k-1))
		button:SetText("")
		button.Paint = function(PANEL, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 200 ) )
			if PANEL:IsHovered() then
				draw.RoundedBox(0, 0, 0, w, 1, Color(240,240,240,170) )
				draw.RoundedBox(0, 0, h-1, w, 1, Color(240,240,240,170) )
				draw.RoundedBox(0, 0, 0, 1, h, Color(240,240,240,170) )
				draw.RoundedBox(0, w-1, 0, 1, h, Color(240,240,240,170) )
				draw.SimpleText( v, Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( v, Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		button.DoClick = function()
			self.DeActiveItems:Clear()
			for l, m in pairs(Inventory.Items) do
				if m.Category == v then
					if self.ActiveItemsList[l] then continue end 
					CreateItemPanel(self, self.DeActiveItems, m)
				end
			end
		end
	end

	self.SaveButton = vgui.Create("DButton", self.Frame)
	self.SaveButton:SetSize(110, 25)
	self.SaveButton:SetPos(self.Frame:GetWide()-130, self.Frame:GetTall()-40)
	self.SaveButton:SetText("")
	self.SaveButton.Paint = function(PANEL,w,h)
		if PANEL:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, 1, Color(240,240,240,170) )
			draw.RoundedBox(0, 0, h-1, w, 1, Color(240,240,240,170) )
			draw.RoundedBox(0, 0, 0, 1, h, Color(240,240,240,170) )
			draw.RoundedBox(0, w-1, 0, 1, h, Color(240,240,240,170) )
			draw.SimpleText( "Сохранить", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "Сохранить", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	self.SaveButton.DoClick = function()
		netstream.Start("Inventory:UpdateTraderItems", self.Entity, self.ActiveItemsList)
		self:GetParent():GetParent():Remove()
	end

	self.ReGenerateTraderButton = vgui.Create("DButton", self.Frame)
	self.ReGenerateTraderButton:SetSize(130, 25)
	self.ReGenerateTraderButton:SetPos(self.Frame:GetWide()-290, self.Frame:GetTall()-40)
	self.ReGenerateTraderButton:SetText("")
	self.ReGenerateTraderButton.Paint = function(PANEL,w,h)
		if PANEL:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, 1, Color(240,240,240,170) )
			draw.RoundedBox(0, 0, h-1, w, 1, Color(240,240,240,170) )
			draw.RoundedBox(0, 0, 0, 1, h, Color(240,240,240,170) )
			draw.RoundedBox(0, w-1, 0, 1, h, Color(240,240,240,170) )
			draw.SimpleText( "Регенерация", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "Регенерация", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	self.ReGenerateTraderButton.DoClick = function()
		netstream.Start("Inventory:ReGenerateTrader", self.Entity)
		self:GetParent():GetParent():Remove()
	end
end

vgui.Register("InventoryTradersConfigBlock",PANEL,"InventoryBasePanel")