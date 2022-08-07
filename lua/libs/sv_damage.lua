//Перенесено из основного гейммода для работы брони
DAMAGE_IMPACT = DMG_SLASH
DAMAGE_BULLET = DMG_BULLET
DAMAGE_THERMAL = DMG_BURN
DAMAGE_CHEMICAL = DMG_POISON
DAMAGE_ELECTRICAL = DMG_SHOCK
DAMAGE_RADIATION = DMG_RADIATION
DAMAGE_PSY = DMG_DISSOLVE
DAMAGE_BLAST = DMG_BLAST

local DMGTypes = {

	[DAMAGE_IMPACT] = "ImpactDef",
	[DAMAGE_BULLET] = "BulletDef",
	[DAMAGE_THERMAL] = "ThermalDef",
	[DAMAGE_CHEMICAL] = "ChemicalDef",
	[DAMAGE_ELECTRICAL] = "ElectricalDef",
	[DAMAGE_RADIATION] = "RadiationDef",
	[DAMAGE_PSY] = "PsyDef",
	[DAMAGE_BLAST] = "BlastDef"
	
}

local function CalcDamage(ent, amount, type)

	if !DMGTypes[type] then return amount end

	local mod = ent["Get"..DMGTypes[type]](ent)
	if !mod then return amount end

	return math.Round((amount/100)*(100 - mod))

end

hook.Add("EntityTakeDamage", "Inventory:EntityTakeDamage", function(ent, dmg)
	dmg:SetDamage(CalcDamage(ent, dmg:GetDamage(), dmg:GetDamageType()))
end)