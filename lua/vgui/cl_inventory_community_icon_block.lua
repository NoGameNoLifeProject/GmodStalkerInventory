local PANEL = {}

local CommunitiesIcons = {
	["stranger"] = Material("", "noclamp"),
	["mutants"] = Material("", "noclamp"),
	["loners"] = Material("icons/groups/Loners.png", "noclamp"),
	["traders"] = Material("icons/groups/Traders.png", "noclamp"),
	["ecologs"] = Material("icons/groups/Ecologs.png", "noclamp"),
	["bandits"] = Material("icons/groups/Bandits.png", "noclamp"),
	["military"] = Material("icons/groups/Military.png", "noclamp"),
	["duty"] = Material("icons/groups/Duty.png", "noclamp"),
	["freedom"] = Material("icons/groups/Freedom.png", "noclamp"),
	["mercs"] = Material("icons/groups/Mercs.png", "noclamp"),
	["monolith"] = Material("icons/groups/Monolith.png", "noclamp")
}

function PANEL:Paint(w, h)
	//if self.IsContainer or self.IsPlayerBox then // Disabled due to gamemode dependency
		draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
	//else
	//	surface.SetDrawColor(Color(255,255,255,255))
	//	surface.SetMaterial( CommunitiesIcons[self.Entity:GetCommunity()] )
	//	surface.DrawTexturedRect( 0, 0, w, h)
	//end
end

vgui.Register("InventoryCommunityIconBlock", PANEL, "InventoryBasePanel")