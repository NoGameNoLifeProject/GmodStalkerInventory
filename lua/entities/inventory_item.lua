AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Item"
ENT.Category = "Dev"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.DefaultModel = "models/props_junk/cardboard_box004a.mdl"

if (SERVER) then
	function ENT:PostEntityPaste(player, ent)
		ent:Remove()
	end

	function ENT:Initialize()
		self:SetModel(self.DefaultModel)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:DrawShadow(false)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
		
		self:SetUseType(SIMPLE_USE)
		
		hook.Run("OnItemSpawned", self)
	end

	function ENT:Use(activator, caller)
		activator:GiveItem(self:GetItemID(), self:GetAmount(), self:GetData())
		self:Remove()
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)
	end

	function ENT:SetAmount(amount)
		self:SetNWInt("Amount", amount)
	end

	function ENT:SetData(data)
		self:SetBetterNWTable("ItemData", data, true)
	end
	
	function ENT:SetItem(itemID)
		self:SetNWString("ItemID", itemID)
		local itemTable = Inventory:GetItemByID(itemID)

		if (itemTable) then
			self:SetSkin(itemTable.Skin or 0)
			self:SetModel(itemTable.Model or self.DefaultModel)
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetSolid(SOLID_VPHYSICS)

			local physObj = self:GetPhysicsObject()

			if (!IsValid(physObj)) then
				local min, max = Vector(-8, -8, -8), Vector(8, 8, 8)

				self:PhysicsInitBox(min, max)
				self:SetCollisionBounds(min, max)
			end

			if (IsValid(physObj)) then
				physObj:EnableMotion(true)
				physObj:Wake()
			end

			if (itemTable.PostProcessEntity) then
				itemTable.PostProcessEntity(self)
			end
		end
	end

	function ENT:OnRemove()
		if !self.RemovedByLimit then
			hook.Run("OnItemRemoved", self)
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end

function ENT:GetAmount()
	return self:GetNWInt("Amount")
end

function ENT:GetData()
	return self:GetBetterNWTable("ItemData")
end

function ENT:GetItemID()
	return self:GetNWString("ItemID", "")
end

function ENT:GetItemTable()
	return Inventory:GetItemByID(self:GetItemID())
end