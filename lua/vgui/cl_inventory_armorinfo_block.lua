local PANEL = {}

local EffectsLeft = {
	[1] = {Name = "RadiationDef", Mat = Material("vgui/icons/radiation.png", "noclamp"), Value = 0},
	[2] = {Name = "ChemicalDef", Mat = Material("vgui/icons/chemical.png", "noclamp"), Value = 0},
	[3] = {Name = "ElectricalDef", Mat = Material("vgui/icons/electrical.png", "noclamp"), Value = 0},
	[4] = {Name = "ThermalDef", Mat = Material("vgui/icons/thermal.png", "noclamp"), Value = 0}
}
local EffectsRight = {
	[1] = {Name = "PsyDef", Mat = Material("vgui/icons/psy.png", "noclamp"), Value = 0},
	[2] = {Name = "ImpactDef", Mat = Material("vgui/icons/impact.png", "noclamp"), Value = 0},
	[3] = {Name = "BlastDef", Mat = Material("vgui/icons/explosion.png", "noclamp"), Value = 0},
	[4] = {Name = "BulletDef", Mat = Material("vgui/icons/bullet.png", "noclamp"), Value = 0},
}

local HeartMat = Material("vgui/icons/heart.png", "noclamp")
local InfoMat = Material("vgui/info_bar.png", "noclamp")
local InfoMaxLong = Material("vgui/info_bar_long.png", "noclamp")
local HealthSaved = 0
local EffectCurVal = 0

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Inventory.cfg.vgui.colors.mainColor)
	local ply = LocalPlayer()
	local startIX = 5 * self.sizeCoefX
	local startRX = 50 * self.sizeCoefX
	local startY = 15 * self.sizeCoefY
	local iconSize = 32 * self.sizeCoefX
	surface.SetDrawColor(255,255,255,255)
	surface.SetMaterial( HeartMat )
	surface.DrawTexturedRect( startIX, startY, iconSize, iconSize )
	surface.SetMaterial( InfoMaxLong )
	surface.DrawTexturedRect( startRX, startY, w-70 * self.sizeCoefX, h/8 )

	local healthCurVal = math.Remap(ply:Health(), 0, ply:GetMaxHealth(), 0, w - 70 * self.sizeCoefX)
	HealthSaved = math.Approach(HealthSaved, healthCurVal, healthCurVal > HealthSaved and 10 or -10 )
	draw.DrawMaskRectangle(startRX, startY, HealthSaved, h/8, function() 
			surface.SetDrawColor(255, 59, 59, 255)
			surface.SetMaterial( InfoMaxLong )
			surface.DrawTexturedRect( startRX, startY, w - 70 * self.sizeCoefX, h/8 )
		end)

	for k, effect in ipairs(EffectsLeft) do
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial( effect.Mat )
		surface.DrawTexturedRect( startIX, startY + k * h/5, iconSize, iconSize )
		surface.SetMaterial( InfoMat )
		surface.DrawTexturedRect( startRX, startY + k * h/5, w/2.6, h/8 )
		
		EffectCurVal = math.Remap(ply["Get"..effect.Name](ply), 0, 100, 0, w/2.6)
		effect.Value = math.Approach(effect.Value, EffectCurVal, EffectCurVal > effect.Value and 5 or -5 )
		draw.DrawMaskRectangle(startRX, startY + k * h/5, effect.Value, h/8, function() 
			surface.SetDrawColor(0, 242, 255, 255)
			surface.SetMaterial( InfoMat )
			surface.DrawTexturedRect( startRX, startY + k * h/5, w/2.6, h/8 )
		end)
	end
	for k, effect in ipairs(EffectsRight) do
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial( effect.Mat )
		surface.DrawTexturedRect( w/2 + startIX, startY + k * h/5, iconSize, iconSize )
		surface.SetMaterial( InfoMat )
		surface.DrawTexturedRect( w/2 + startRX, startY + k * h/5, w/2.6, h/8 )
		
		EffectCurVal = math.Remap(ply["Get"..effect.Name](ply), 0, 100, 0, w/2.6)
		effect.Value = math.Approach(effect.Value, EffectCurVal, EffectCurVal > effect.Value and 5 or -5 )
		draw.DrawMaskRectangle(w/2 + startRX, startY + k * h/5, effect.Value, h/8, function() 
			surface.SetDrawColor(0, 242, 255, 255)
			surface.SetMaterial( InfoMat )
			surface.DrawTexturedRect( w/2 + startRX, startY + k * h/5, w/2.6, h/8 )
		end)
	end
end

vgui.Register("InventoryArmorInfoBlock", PANEL, "InventoryBasePanel")