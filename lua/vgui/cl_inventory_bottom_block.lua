local PANEL = {}

function PANEL:Build()
	if self.IsAmmunation then
		self.Button = vgui.Create("DButton", self.Frame)
		self.Button:SetSize(self.Frame:GetWide(), self.Frame:GetTall())
		self.Button:SetText("")
		self.Button.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
			draw.ShadowSimpleText("Выход", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if pnl:IsHovered() then
				draw.RectangleCorners(w, h, Inventory.cfg.vgui.colors.mainTextColor)
			end
		end
		self.Button.DoClick = function(pnl)
			self:GetParent():GetParent():Remove()
		end
	elseif self.IsContainer then
		self.Frame.Paint = function(pnl, w, h)
			draw.RoundedBox(0, w/2 + 5, 0, w/2-5, h, Inventory.cfg.vgui.colors.mainColor)
			local inventory = self.IsPlayerBox and LocalPlayer():GetBetterNWTable("InventoryBox") or self.Entity:GetBetterNWTable("Inventory")
			draw.ShadowSimpleText("Общий вес: " .. math.Round(inventory.Info.Weight, 2) .. "кг", Inventory.cfg.vgui.fonts.theme30, w/2 + w/4 + 5, h/2, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		self.Button = vgui.Create("DButton", self.Frame)
		self.Button:SetSize(self.Frame:GetWide()/2-5, self.Frame:GetTall())
		self.Button:SetText("")
		self.Button.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
			draw.ShadowSimpleText("Взять все", Inventory.cfg.vgui.fonts.theme30, w/2, h/2, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if pnl:IsHovered() then
				draw.RectangleCorners(w, h, Inventory.cfg.vgui.colors.mainTextColor)
			end
		end
		self.Button.DoClick = function(pnl)
			netstream.Start("Inventory:TakeAll", self.Entity, self.IsPlayerBox)
			self:GetParent():GetParent():Remove()
		end
	else
		self.Frame.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
			local inventory = self.Entity:GetBetterNWTable("Inventory")
			local maxWeight = self.Entity:GetNWFloat("Inventory:MaxWeight", Inventory.cfg.defaultMaxWeight)
			local maxWeightText = self.Entity:IsPlayer() and "(max "..maxWeight.."кг)" or ""
			surface.SetFont(Inventory.cfg.vgui.fonts.theme30)
			local x, y = surface.GetTextSize(maxWeightText)
			local color = Inventory.cfg.vgui.colors.mainTextColor
			if inventory.Info.Weight >= maxWeight then
				local dif = inventory.Info.Weight - maxWeight
				if dif >= 5 then
					color = Inventory.cfg.vgui.colors.redColor
				elseif dif >= 0 then
					color = Inventory.cfg.vgui.colors.warnColor
				end 
			end 
			draw.ShadowSimpleText(maxWeightText, Inventory.cfg.vgui.fonts.theme30, w-50, h/2, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)	
			draw.ShadowSimpleText(math.Round(inventory.Info.Weight, 2) .. "кг", Inventory.cfg.vgui.fonts.theme30, w-50 - x - 10, h/2, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			local wsizeX, _ = surface.GetTextSize(math.Round(inventory.Info.Weight, 2) .. "кг")
			draw.ShadowSimpleText("Общий вес: ", Inventory.cfg.vgui.fonts.theme30, w-50 - x - 15 - wsizeX, h/2, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end
end

function PANEL:SetIsContainer(state)
	self.IsContainer = state
end

function PANEL:SetIsAmmunation(state)
	self.IsAmmunation = state
end

vgui.Register("InventoryBottomBlock", PANEL, "InventoryBasePanel")