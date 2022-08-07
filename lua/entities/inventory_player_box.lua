AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "PlayerBox"
ENT.Category = "Dev"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.IsPlayerBox = true 
ENT.IsContainer = true

if (SERVER) then
	function ENT:PostEntityPaste(player, ent)
		ent:Remove()
	end

	function ENT:Initialize()
		self:SetModel("models/z-o-m-b-i-e/st/equipment_cache/st_equipment_box_01.mdl")
		self:SetSkin(1)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		
		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
		
		self:SetUseType(SIMPLE_USE)
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

	function ENT:Use(activator, caller)
		netstream.Start(activator, "Inventory:OpenPlayerInventory", self)
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end