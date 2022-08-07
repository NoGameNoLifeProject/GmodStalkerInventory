local PANEL = {}

function PANEL:Build()
	self.TileLayout = vgui.Create("DTileLayout", self.Frame)
	self.TileLayout:SetSize(self.Frame:GetWide(), self.Frame:GetTall())
	self.TileLayout:SetSpaceY( 5 * self.sizeCoefX)
	self.TileLayout:SetSpaceX( 10 * self.sizeCoefY )
	self.TileLayout:SetBaseSize(140 * self.sizeCoefX)

	for i = 1, 4 do
		local fastSlot = self.TileLayout:Add("DPanel")
		fastSlot:SetSize(140 * self.sizeCoefX, 105 * self.sizeCoefY)
		fastSlot:SetText("")
		fastSlot.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.mainColor)
		end
	end
end

vgui.Register("InventoryFastSlotsBlock", PANEL, "InventoryBasePanel")