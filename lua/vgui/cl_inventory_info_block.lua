local PANEL = {}

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
	if !self.IsContainer and !self.IsPlayerBox then
		startXLeft = 10 * self.sizeCoefX
		startXRight = w - startXLeft
		startY =  5 * self.sizeCoefY
		draw.SimpleText("Имя", Inventory.cfg.vgui.fonts.paint20, startXLeft, startY, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(self.Entity:Name(), Inventory.cfg.vgui.fonts.paint20, startXRight, startY, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	
		// Disabled due to gamemode dependency
		/*draw.SimpleText("Группировка", Inventory.cfg.vgui.fonts.paint20, startXLeft, startY + h/4, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		if self.Entity:GetClass() == "npc_human_stalker" then
			draw.SimpleText(self.Entity:GetCommunityInfo(), Inventory.cfg.vgui.fonts.paint20, startXRight, startY + h/4, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		else	
			draw.SimpleText(self.Entity:GetCommunityName(), Inventory.cfg.vgui.fonts.paint20, startXRight, startY + h/4, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		end
		
		draw.SimpleText("Репутация", Inventory.cfg.vgui.fonts.paint20, startXLeft, startY + 2 * h/4, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		if self.Entity:GetClass() == "npc_human_stalker" then
			draw.SimpleText("Нейтрал", Inventory.cfg.vgui.fonts.paint20, startXRight, startY + 2 * h/4, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		else
			draw.SimpleText(ReputationToString(self.Entity:GetRep()), Inventory.cfg.vgui.fonts.paint20, startXRight, startY + 2 * h/4, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		end

		draw.SimpleText("Деньги", Inventory.cfg.vgui.fonts.paint20, startXLeft, startY + 3 * h/4, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(self.Entity:GetRUB(), Inventory.cfg.vgui.fonts.paint20, startXRight, startY + 3 * h/4, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		*/
	end
end

vgui.Register("InventoryInfoBlock", PANEL, "InventoryBasePanel")