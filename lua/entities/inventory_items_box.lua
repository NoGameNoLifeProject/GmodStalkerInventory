AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Items Box"
ENT.Category = "Dev"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.IsContainer = true

if (SERVER) then
	function ENT:PostEntityPaste(player, ent)
		ent:Remove()
	end

	local models = {
		"models/z-o-m-b-i-e/st/equipment_cache/st_equipment_box_01.mdl",
		"models/z-o-m-b-i-e/st/equipment_cache/st_equipment_box_02.mdl",
		"models/z-o-m-b-i-e/st/equipment_cache/st_equipment_seif_04.mdl",
		"models/z-o-m-b-i-e/st/equipment_cache/st_equipment_instrument_01.mdl",
		"models/z-o-m-b-i-e/st/army_base/st_army_base_04.mdl",
		"models/chernobyl/item/backpack-1.mdl",
		"models/chernobyl/item/backpack-2.mdl",
	}

	function ENT:Initialize()
		self:SetModel(table.Random(models))
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		
		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
		
		self:SetUseType(SIMPLE_USE)
		self:CreateInventory()
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)
	end

	function ENT:SpawnFunction( ply, tr, ClassName )

		if ( !tr.Hit ) then return end

		local SpawnPos = tr.HitPos + tr.HitNormal * 10
		local SpawnAng = ply:EyeAngles()
		SpawnAng.p = 0
		SpawnAng.y = SpawnAng.y + 180
	
		local ent = ents.Create( ClassName )
		ent:SetPos( SpawnPos )
		ent:SetAngles( SpawnAng )
		ent:Spawn()
		ent:Activate()
	
		return ent

	end
end

function ENT:Use(activator, caller)
	if !(Inventory:IsEntityLocked(self)) then
   		netstream.Start(activator, "Inventory:OpenPlayerInventory", self)
    	Inventory:LockEntity(self)
    end
end

function ENT:Draw()
	self:DrawModel()
end