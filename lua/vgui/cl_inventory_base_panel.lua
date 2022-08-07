local PANEL = {}

function PANEL:Init()
	self.sizeCoefX = 1
	self.sizeCoefY = 1
	self.Info = {}
	self.Entity = nil

	self.Frame = vgui.Create("DFrame", self:GetParent())
	self.Frame:SetDraggable(false)
	self.Frame:ShowCloseButton(false)
	self.Frame:SetTitle("")
	self.Frame:DockPadding(0, 0, 0, 0)
	self.Frame.Paint = function(pnl, w, h) end
end

function PANEL:SetIsPlayerBox(state)
	self.IsPlayerBox = state
end

function PANEL:SetIsContainer(state)
	self.IsContainer = state
end

function PANEL:SetIsNPC(state)
	self.IsNPC = state
end

function PANEL:SetEntity(ent)
	self.Entity = ent
end

function PANEL:SetSizeCoef(coefx, coefy)
	self.sizeCoefX = coefx
	self.sizeCoefY = coefy
	self:InvalidateLayout(true)
end

function PANEL:Build()
end

function PANEL:PerformLayout()
	local x, y = self:GetPos()
	self.Frame:SetPos(x, y)
	self.Frame:SetSize(self:GetWide(), self:GetTall())
	self.Frame:InvalidateChildren(true)
end

vgui.Register("InventoryBasePanel", PANEL, "PANEL")