//Перенесено из основного гейммода для работы брони
local Entity = FindMetaTable("Entity")

local function CreateEntityVar(str, def, min, max)
	
	def = def or 0

	Entity["Get"..str] = function(self)

		return self:GetNWInt("Chernobyl."..str, def)

	end

	if CLIENT then return end

	min = min or 0
	max = max or 200

	Entity["Set"..str] = function(self, int)

		self:SetNWInt("Chernobyl."..str, math.Clamp(int, min, max))

	end

	Entity["Add"..str] = function(self, int)

		self["Set"..str](self, math.Clamp(self["Get"..str](self) + int, min, max))

	end

end

CreateEntityVar("ImpactDef")
CreateEntityVar("BulletDef")
CreateEntityVar("ThermalDef")
CreateEntityVar("ChemicalDef")
CreateEntityVar("ElectricalDef")
CreateEntityVar("RadiationDef")
CreateEntityVar("PsyDef")
CreateEntityVar("BlastDef")

function Entity:GetChunk()

	return self:GetNWEntity("Chunk")

end