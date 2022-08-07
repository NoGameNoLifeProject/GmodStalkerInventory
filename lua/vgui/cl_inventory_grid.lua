local PANEL = {}

function PANEL:Init()
	self.Frame = vgui.Create("DFrame", self:GetParent())
	self.Frame:SetDraggable(false)
	self.Frame:ShowCloseButton(false)
	self.Frame:SetTitle("")
end

function PANEL:PerformLayout()
	local x, y = self:GetPos()
	self.Frame:SetPos(x, y)
	self.Frame:SetSize(self:GetWide(), self:GetTall())
end

vgui.Register("InventoryGrid", PANEL, "PANEL")