local PANEL = {}

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
	if IsValid(LocalPlayer()) and LocalPlayer():Alive() then
		draw.RoundedBox(0, 5 * self.sizeCoefX, h - 35 * self.sizeCoefY, math.Remap(LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth(), 0, 423) * self.sizeCoefX, 30 * self.sizeCoefY, Color(240,50,50,160))
	end
	//draw.SimpleText("Имя", "DermaDefault", 5, 5, Inventory.cfg.vgui.colors.mainTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

vgui.Register("InventoryStatusBlock", PANEL, "InventoryBasePanel")